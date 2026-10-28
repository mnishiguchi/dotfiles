#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "$0")/.." && pwd)
git_backup="$project_dir/bin/git-backup"
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT HUP INT TERM

fail() {
  printf '%s\n' "git_backup_test: $*" >&2
  exit 1
}

repo="$test_dir/example repo"
output_dir="$test_dir/archives"
mkdir -p "$repo"

git -C "$repo" init -q
printf '%s\n' tracked >"$repo/tracked.txt"
printf '%s\n' ignored >"$repo/ignored.txt"
printf '%s\n' 'ignored.txt' >"$repo/.gitignore"
git -C "$repo" add tracked.txt .gitignore
printf '%s\n' changed >"$repo/tracked.txt"
printf '%s\n' untracked >"$repo/untracked.txt"

help_output=$($git_backup --help)
[[ $help_output == *'Usage: git backup'* ]] || fail "help did not include usage"

dry_run_output=$(cd "$repo" && "$git_backup" --dry-run)
[[ $dry_run_output == *'Selected:   3 files'* ]] || fail "dry run reported the wrong file count"
[[ $dry_run_output == *'tracked.txt'* ]] || fail "dry run omitted a tracked file"
[[ $dry_run_output == *'untracked.txt'* ]] || fail "dry run omitted an untracked file"
[[ $dry_run_output != *'ignored.txt'* ]] || fail "dry run included an ignored file"

(cd "$repo" && "$git_backup" "$output_dir") >/dev/null
archive=$(find "$output_dir" -maxdepth 1 -type f -name '*.tar.gz' -print -quit)
[[ -n $archive ]] || fail "archive was not created"

archive_contents=$(tar -tzf "$archive")
[[ $archive_contents == *'/tracked.txt'* ]] || fail "archive omitted a tracked file"
[[ $archive_contents == *'/untracked.txt'* ]] || fail "archive omitted an untracked file"
[[ $archive_contents != *'/ignored.txt'* ]] || fail "archive included an ignored file"
[[ $archive_contents != *'/.git/'* ]] || fail "archive included Git metadata"

if (cd "$repo" && "$git_backup" "$repo/backups") >/dev/null 2>&1; then
  fail "an output directory inside the repository was accepted"
fi

printf '%s\n' "git_backup_test: ok"

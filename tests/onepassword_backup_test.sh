#!/usr/bin/env sh
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
backup="$project_dir/bin/onepassword-backup"
fixture_dir="$project_dir/tests/fixtures"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

fail() {
  printf '%s\n' "onepassword_backup_test: $*" >&2
  exit 1
}

assert_empty_directory() {
  directory="$1"

  if find "$directory" -mindepth 1 -print -quit | grep -q .; then
    fail "expected an empty directory: $directory"
  fi
}

mkdir "$test_dir/encrypted" "$test_dir/failed-encryption"
printf '%s' backup-data >"$test_dir/vault.1pux"
printf '%s' another-backup >"$test_dir/failing.1pux"

printf 'n\n' | PATH="$fixture_dir:$PATH" \
  "$backup" encrypt "$test_dir/vault.1pux" "$test_dir/encrypted" >/dev/null

encrypted_file=$(find "$test_dir/encrypted" -maxdepth 1 -type f -name '*.1pux.age')
[ -n "$encrypted_file" ] || fail "encrypted output was not created"
cmp "$test_dir/vault.1pux" "$encrypted_file" >/dev/null ||
  fail "encrypted output did not match fake age output"

mkdir "$test_dir/shasum-path"
ln -s "$fixture_dir/age" "$test_dir/shasum-path/age"
for command_name in bash basename cat sh shasum; do
  ln -s "$(command -v "$command_name")" "$test_dir/shasum-path/$command_name"
done
PATH="$test_dir/shasum-path" "$backup" verify "$encrypted_file" >/dev/null

if printf 'n\n' | PATH="$fixture_dir:$PATH" FAKE_AGE_FAIL=encrypt \
  "$backup" encrypt "$test_dir/failing.1pux" "$test_dir/failed-encryption" \
  >/dev/null 2>&1; then
  fail "failed encryption unexpectedly succeeded"
fi
assert_empty_directory "$test_dir/failed-encryption"

PATH="$fixture_dir:$PATH" \
  "$backup" decrypt "$encrypted_file" "$test_dir/restored.1pux" >/dev/null
cmp "$test_dir/vault.1pux" "$test_dir/restored.1pux" >/dev/null ||
  fail "restored output did not match fake age output"

if PATH="$fixture_dir:$PATH" FAKE_AGE_FAIL=decrypt \
  "$backup" decrypt "$encrypted_file" "$test_dir/failed.1pux" \
  >/dev/null 2>&1; then
  fail "failed decryption unexpectedly succeeded"
fi
[ ! -e "$test_dir/failed.1pux" ] || fail "failed decryption left its final output"
if find "$test_dir" -maxdepth 1 -name '.failed.1pux.*' -print -quit | grep -q .; then
  fail "failed decryption left a temporary output"
fi

if "$backup" verify one two >/dev/null 2>&1; then
  fail "verify accepted excess arguments"
fi

printf '%s\n' "onepassword_backup_test: ok"

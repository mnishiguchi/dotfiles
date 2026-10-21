#!/usr/bin/env sh
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
age_file="$project_dir/bin/age-file"
fixture_dir="$project_dir/tests/fixtures"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

fail() {
  printf '%s\n' "age_file_test: $*" >&2
  exit 1
}

mkdir "$test_dir/work"
: >"$test_dir/empty.age"

(
  cd "$test_dir/work"
  PATH="$fixture_dir:$PATH" "$age_file" decrypt "$test_dir/empty.age" >/dev/null
)

[ -f "$test_dir/work/empty" ] || fail "empty decrypted output was not created"
[ ! -s "$test_dir/work/empty" ] || fail "empty decrypted output was not empty"

printf '%s\n' "age_file_test: ok"

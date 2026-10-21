#!/usr/bin/env sh
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
  printf '%s\n' "bin_options_test: $*" >&2
  exit 1
}

assert_usage_error() {
  expected="$1"
  shift

  set +e
  output=$("$@" 2>&1 </dev/null)
  status=$?
  set -e

  [ "$status" -eq 2 ] || fail "expected status 2, got $status: $*"

  case "$output" in
  *"$expected"*)
    ;;
  *)
    fail "expected '$expected' in: $output"
    ;;
  esac
}

assert_usage_error "unknown option: --bogus" \
  "$project_dir/bin/bashpaste" --bogus
assert_usage_error "unknown option: --bogus" \
  "$project_dir/bin/extract" --bogus
assert_usage_error "unknown option: --bogus" \
  "$project_dir/bin/hexdocs" --bogus
assert_usage_error "unknown option: --bogus" \
  "$project_dir/bin/hexpm" --bogus

printf '%s\n' "bin_options_test: ok"

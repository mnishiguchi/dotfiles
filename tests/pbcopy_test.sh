#!/usr/bin/env sh
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
pbcopy="$project_dir/bin/pbcopy"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

fail() {
  printf '%s\n' "pbcopy_test: $*" >&2
  exit 1
}

assert_fails_with() {
  expected="$1"
  shift

  if output=$("$@" 2>&1 </dev/null); then
    fail "command unexpectedly succeeded: $*"
  fi

  case "$output" in
  *"$expected"*)
    ;;
  *)
    fail "expected '$expected' in: $output"
    ;;
  esac
}

help_output=$("$pbcopy" -help)
case "$help_output" in
*"Usage:"*"-pboard general"*)
  ;;
*)
  fail "-help did not print the expected usage"
  ;;
esac

assert_fails_with "unknown option: --bogus" "$pbcopy" --bogus
assert_fails_with "-pboard requires a pasteboard name" "$pbcopy" -pboard
assert_fails_with "pasteboard 'find' is not supported" "$pbcopy" -pboard find
assert_fails_with "unknown pasteboard: other" "$pbcopy" -pboard other
assert_fails_with "unexpected argument: text" "$pbcopy" text

ln -s "$(command -v tee)" "$test_dir/wl-copy"
printf 'hello' | PATH="$test_dir:$PATH" WAYLAND_DISPLAY=test \
  "$pbcopy" -pboard general >/dev/null

printf '%s\n' "pbcopy_test: ok"

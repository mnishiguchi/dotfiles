#!/usr/bin/env sh
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
pbpaste="$project_dir/bin/pbpaste"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

fail() {
  printf '%s\n' "pbpaste_test: $*" >&2
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

help_output=$("$pbpaste" -help)
case "$help_output" in
*"Usage:"*"-pboard general"*"-Prefer txt"*)
  ;;
*)
  fail "-help did not print the expected usage"
  ;;
esac

assert_fails_with "unknown option: --bogus" "$pbpaste" --bogus
assert_fails_with "-pboard requires a pasteboard name" "$pbpaste" -pboard
assert_fails_with "pasteboard 'font' is not supported" "$pbpaste" -pboard font
assert_fails_with "unknown pasteboard: other" "$pbpaste" -pboard other
assert_fails_with "-Prefer requires a data type" "$pbpaste" -Prefer
assert_fails_with "preferred type 'rtf' is not supported" "$pbpaste" -Prefer rtf
assert_fails_with "unknown preferred type: other" "$pbpaste" -Prefer other
assert_fails_with "unexpected argument: text" "$pbpaste" text

printf '%s\n' \
  '#!/usr/bin/env sh' \
  'printf "%s" provider-output' \
  "printf '%s' \"\$*\" >\"\$PBP_TEST_ARGS\"" \
  >"$test_dir/wl-paste"
chmod +x "$test_dir/wl-paste"

args_file="$test_dir/args"
output=$(
  PATH="$test_dir:$PATH" \
    PBP_TEST_ARGS="$args_file" \
    WAYLAND_DISPLAY=test \
    "$pbpaste" -pboard general -Prefer txt
)

[ "$output" = provider-output ] || fail "pbpaste did not return provider output"
[ "$(cat "$args_file")" = "--no-newline --type text" ] ||
  fail "pbpaste invoked wl-paste with unexpected arguments"

printf '%s\n' "pbpaste_test: ok"

#!/usr/bin/env sh
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
notes="$project_dir/bin/notes"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

fail() {
  printf '%s\n' "notes_test: $*" >&2
  exit 1
}

notebook_dir="$test_dir/notebook"
fake_bin="$test_dir/bin"
output_file="$test_dir/nvim-args"

mkdir -p "$notebook_dir/.zk" "$fake_bin"
: >"$notebook_dir/.zk/config.toml"

cat >"$fake_bin/nvim" <<'EOF'
#!/usr/bin/env sh
printf '%s\n' "$PWD" "$@" >"$NOTES_TEST_OUTPUT"
EOF
chmod +x "$fake_bin/nvim"

cat >"$fake_bin/zk" <<'EOF'
#!/usr/bin/env sh
printf '%s\n' "$@" >"$NOTES_TEST_ZK_OUTPUT"
mkdir -p "$3/.zk"
: >"$3/.zk/config.toml"
EOF
chmod +x "$fake_bin/zk"

PATH="$fake_bin:$PATH" \
  NOTES_TEST_OUTPUT="$output_file" \
  ZK_NOTEBOOK_DIR="$notebook_dir" \
  "$notes"

expected=$(printf '%s\n' "$notebook_dir" -c ZkNotes)
actual=$(cat "$output_file")
[ "$actual" = "$expected" ] || fail "unexpected nvim invocation: $actual"

PATH="$fake_bin:$PATH" \
  NOTES_TEST_OUTPUT="$output_file" \
  ZK_NOTEBOOK_DIR="$notebook_dir" \
  "$notes" list

actual=$(cat "$output_file")
[ "$actual" = "$expected" ] || fail "unexpected nvim invocation for list: $actual"

init_dir="$test_dir/initialized-notebook"
zk_output_file="$test_dir/zk-args"

PATH="$fake_bin:$PATH" \
  NOTES_TEST_ZK_OUTPUT="$zk_output_file" \
  ZK_NOTEBOOK_DIR="$init_dir" \
  "$notes" init >/dev/null

expected=$(printf '%s\n' init --no-input "$init_dir")
actual=$(cat "$zk_output_file")
[ "$actual" = "$expected" ] || fail "unexpected zk invocation: $actual"
[ -f "$init_dir/.zk/config.toml" ] || fail "notebook was not initialized"

PATH="$fake_bin:$PATH" \
  NOTES_TEST_ZK_OUTPUT="$zk_output_file" \
  ZK_NOTEBOOK_DIR="$init_dir" \
  "$notes" init | grep -q "notebook already initialized"

ancestor_dir="$test_dir/existing-notebook"
nested_dir="$ancestor_dir/notes"
mkdir -p "$ancestor_dir/.zk"
: >"$ancestor_dir/.zk/config.toml"

if output=$(PATH="$fake_bin:$PATH" ZK_NOTEBOOK_DIR="$nested_dir" "$notes" init 2>&1); then
  fail "nested notebook initialization unexpectedly succeeded"
fi

case "$output" in
*"another zk notebook exists at $ancestor_dir"*) ;;
*)
  fail "unexpected ancestor-notebook error: $output"
  ;;
esac

[ ! -e "$nested_dir" ] || fail "nested notebook directory was created"

if output=$(ZK_NOTEBOOK_DIR="$test_dir/missing" "$notes" 2>&1); then
  fail "missing notebook unexpectedly succeeded"
fi

case "$output" in
*"notebook directory not found"*) ;;
*)
  fail "unexpected missing-notebook error: $output"
  ;;
esac

printf '%s\n' "notes_test: ok"

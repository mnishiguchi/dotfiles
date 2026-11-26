#!/bin/bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-snippets.XXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
export HOME="$scratch/home" XDG_CONFIG_HOME="$scratch/config"
export TEST_PLATFORM=Linux DISPLAY=:99 XDG_SESSION_TYPE=x11
unset WAYLAND_DISPLAY
export DOTFILES_SNIPPETS_FILE="$scratch/snippets.txt"
export MOCK_DIR="$scratch" MOCK_CHOICE='greeting/hello' MOCK_STATUS=0
mkdir -p "$HOME/.local/bin" "$XDG_CONFIG_HOME"
export PATH="$HOME/.local/bin:$PATH"
cat > "$DOTFILES_SNIPPETS_FILE" <<'DATA'
# comments
  # indented comment
greeting/hello!Hello ! world
empty!
cmd output!printf 'MiXeD\nline 2\n'
cmd fails!printf 'not copied'; exit 7
cmd pipeline!false | cat
not cmd!$(touch SHOULD_NOT_EXIST)
DATA
ln -s "$root/bin/dotfiles-snippets" "$HOME/.local/bin/dotfiles-snippets"
cat > "$HOME/.local/bin/uname" <<'SH'
#!/bin/sh
printf '%s\n' "$TEST_PLATFORM"
SH
cat > "$HOME/.local/bin/dotfiles-menu" <<'SH'
#!/bin/sh
cat > "$MOCK_DIR/menu"
[ "${MOCK_CHANGE_FOCUS:-no}" != yes ] || printf '99\n' > "$MOCK_DIR/focus"
[ "$MOCK_STATUS" = 0 ] || exit "$MOCK_STATUS"
printf '%s\n' "$MOCK_CHOICE"
SH
cat > "$HOME/.local/bin/pbcopy" <<'SH'
#!/bin/sh
cat > "$MOCK_DIR/clipboard"
SH
cat > "$HOME/.local/bin/xdotool" <<'SH'
#!/bin/sh
case "$1" in
  getactivewindow) cat "$MOCK_DIR/focus";;
  key) printf '%s\n' "$*" > "$MOCK_DIR/paste";;
  type) cat > "$MOCK_DIR/typed";;
  *) exit 1;;
esac
SH
cat > "$HOME/.local/bin/osascript" <<'SH'
#!/bin/sh
cat > "$MOCK_DIR/applescript"
if [ "$#" = 0 ]; then printf '123\n'; else
  [ "$2" = 123 ] || exit 1
  [ "${MOCK_DENY_PASTE:-no}" != yes ] || exit 1
  printf 'mac-paste\n' > "$MOCK_DIR/paste"
fi
SH
cat > "$HOME/.local/bin/open" <<'SH'
#!/bin/sh
printf '%s\n' "$@" > "$MOCK_DIR/open"
SH
cat > "$HOME/.local/bin/rofi-combi-menu" <<'SH'
#!/bin/sh
printf 'native-combi\n'
SH
cat > "$HOME/.local/bin/notify-send" <<'SH'
#!/bin/sh
exit 0
SH
cat > "$HOME/.local/bin/sleep" <<'SH'
#!/bin/sh
exit 0
SH
chmod +x "$HOME/.local/bin/"*
engine="$root/bin/dotfiles-snippets" launcher="$root/bin/dotfiles-launcher"
expect_status() {
  local expected=$1 status=0
  shift
  "$@" > "$scratch/stdout" 2> "$scratch/stderr" || status=$?
  [[ "$status" == "$expected" ]] || { cat "$scratch/stderr" >&2; echo "expected $expected, got $status: $*" >&2; exit 1; }
}
for TEST_PLATFORM in Linux Darwin; do
  export TEST_PLATFORM
  "$engine" --check >/dev/null
  [[ $("$engine" --list | wc -l | tr -d ' ') == 6 ]]
  [[ $("$engine" --print 'greeting/hello') == 'Hello ! world' ]]
  [[ $("$engine" --print 'cmd output') == $'MiXeD\nline 2' ]]
  [[ $("$engine" --raw 'cmd output') == "printf 'MiXeD\\nline 2\\n'" ]]
  [[ $("$engine" --print 'not cmd') == '$(touch SHOULD_NOT_EXIST)' ]]
  if [[ "$TEST_PLATFORM" == Linux ]]; then
    MOCK_CHOICE='cmd output' "$engine"
    [[ $(cat "$scratch/clipboard") == $'MiXeD\nline 2' ]]
    MOCK_STATUS=1 "$engine"
    [[ $(cat "$scratch/clipboard") == $'MiXeD\nline 2' ]]
    expect_status 2 env MOCK_CHOICE='bad selection' "$engine"
  else
    "$engine" --copy 'cmd output'
    [[ $(cat "$scratch/clipboard") == $'MiXeD\nline 2' ]]
    expect_status 2 "$engine"
    [[ $(cat "$scratch/clipboard") == $'MiXeD\nline 2' ]]
  fi
  expect_status 1 "$engine" --copy 'cmd fails'
  expect_status 1 "$engine" --copy 'cmd pipeline'
  [[ $(cat "$scratch/clipboard") == $'MiXeD\nline 2' ]]
  expect_status 2 "$engine" --print nonexistent
  expect_status 2 "$engine" --unknown
  "$engine" --copy empty
  [[ ! -s "$scratch/clipboard" ]]
done
# No execution during --list/check; reject malformed and duplicate names.
printf 'cmd side effect!touch "%s"\n' "$scratch/side-effect" >> "$DOTFILES_SNIPPETS_FILE"
"$engine" --check >/dev/null; "$engine" --list >/dev/null
[[ ! -e "$scratch/side-effect" ]]
cp "$DOTFILES_SNIPPETS_FILE" "$scratch/valid"
printf 'greeting/hello!duplicate\n' >> "$DOTFILES_SNIPPETS_FILE"
expect_status 2 "$engine" --check
cp "$scratch/valid" "$DOTFILES_SNIPPETS_FILE"
printf 'broken line\n' >> "$DOTFILES_SNIPPETS_FILE"
expect_status 2 "$engine" --check
cp "$scratch/valid" "$DOTFILES_SNIPPETS_FILE"
# Optional paste only if focus returns; permission/focus failure retains copy.
export TEST_PLATFORM=Linux
printf '42\n' > "$scratch/focus"
MOCK_CHOICE='greeting/hello' "$engine" --paste
[[ $(cat "$scratch/paste") == 'key --clearmodifiers ctrl+v' ]]
rm "$scratch/paste"
expect_status 1 env MOCK_CHANGE_FOCUS=yes "$engine" --paste
[[ ! -e "$scratch/paste" && $(cat "$scratch/clipboard") == 'Hello ! world' ]]
expect_status 1 env WAYLAND_DISPLAY=wayland-0 "$engine" --paste
[[ ! -e "$scratch/paste" ]]
export TEST_PLATFORM=Darwin
expect_status 2 "$engine" --paste
"$engine" --paste 'greeting/hello'
[[ $(cat "$scratch/paste") == mac-paste ]]
rm "$scratch/paste"
expect_status 1 env MOCK_DENY_PASTE=yes "$engine" --paste 'greeting/hello'
[[ ! -e "$scratch/paste" && $(cat "$scratch/clipboard") == 'Hello ! world' ]]
# The combined application launcher is Linux/Rofi-only.
export TEST_PLATFORM=Darwin
expect_status 2 "$launcher"
status=0
"$root/bin/dotfiles-menu" </dev/null >/dev/null 2>"$scratch/menu-error" || status=$?
[[ "$status" == 69 && "$(cat "$scratch/menu-error")" == *'use Spotlight'* ]]
export TEST_PLATFORM=Linux
[[ $("$launcher") == native-combi ]]
ROFI_RETV=1 "$root/rofi/bin/rofi-snippets-modi" 'cmd output'
for attempt in 1 2 3 4 5; do
  [[ -s "$scratch/typed" ]] && break
  /bin/sleep 0.1
done
[[ $(cat "$scratch/typed") == $'MiXeD\nline 2' ]]
ROFI_RETV=2 "$root/rofi/bin/rofi-snippets-modi" 'cmd output'
[[ $(cat "$scratch/clipboard") == $'MiXeD\nline 2' ]]
# Old and new managed paths point to one source. Conflicting local files stop.
mkdir -p "$XDG_CONFIG_HOME/dotfiles" "$XDG_CONFIG_HOME/rofi"
ln -s "$root/snippets/snippets.txt" "$XDG_CONFIG_HOME/dotfiles/snippets.txt"
ln -s "$root/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
unset DOTFILES_SNIPPETS_FILE
"$engine" --check >/dev/null
rm "$XDG_CONFIG_HOME/rofi/snippets.txt"
printf 'local!keep\n' > "$XDG_CONFIG_HOME/rofi/snippets.txt"
expect_status 2 "$engine" --check
rm "$XDG_CONFIG_HOME/dotfiles/snippets.txt"
[[ $("$engine" --print local) == keep ]]
# Check original snippet definitions and portable command syntax.
export DOTFILES_SNIPPETS_FILE="$root/snippets/snippets.txt"
[[ $("$engine" --list | wc -l | tr -d ' ') == 20 ]]
if command -v openssl >/dev/null; then
  [[ $("$engine" --print 'cmd hash/md5') == 1a79a4d60de6718e8e5b326e338ae533 ]]
  [[ $("$engine" --print 'cmd hash/sha256' | wc -c | tr -d ' ') == 64 ]]
  [[ $("$engine" --print 'cmd hash/sha512' | wc -c | tr -d ' ') == 128 ]]
fi
[[ $("$engine" --print 'cmd timestamp/iso8601') =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}$ ]]
[[ $("$engine" --print 'cmd timestamp/rfc2822') =~ [+-][0-9]{4}$ ]]
# Test real installer wiring in isolated homes, with a legacy managed symlink.
(
  export HOME="$scratch/install-home" XDG_CONFIG_HOME="$scratch/install-config"
  export XDG_CACHE_HOME="$scratch/install-cache" XDG_DATA_HOME="$scratch/install-data"
  export XDG_STATE_HOME="$scratch/install-state"
  export TEST_PLATFORM=Linux
  mkdir -p "$HOME" "$XDG_CONFIG_HOME/rofi"
  ln -s "$root/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
  # Only test presence of rofi; no real GUI is used.
  printf '#!/bin/sh\nexit 0\n' > "$scratch/home/.local/bin/rofi"
  chmod +x "$scratch/home/.local/bin/rofi"
  "$root/install.sh" --only rofi --check >/dev/null
  [[ ! -e "$XDG_CONFIG_HOME/dotfiles/snippets.txt" ]]
  "$root/install.sh" --only rofi >/dev/null
  [[ "$XDG_CONFIG_HOME/dotfiles/snippets.txt" -ef "$XDG_CONFIG_HOME/rofi/snippets.txt" ]]
  [[ -L "$HOME/.local/bin/dotfiles-menu" && -L "$HOME/.local/bin/dotfiles-snippets" ]]
  [[ -L "$HOME/.local/bin/pbcopy" && -L "$HOME/.local/bin/dotfiles-launcher" ]]
  "$root/install.sh" --only rofi --verify >/dev/null
  # macOS installs shared snippets and Spotlight sync, not Rofi menus.
  export HOME="$scratch/mac-home" XDG_CONFIG_HOME="$scratch/mac-config" TEST_PLATFORM=Darwin
  mkdir -p "$HOME/.local/bin"
  ln -s "$root/bin/dotfiles-menu" "$HOME/.local/bin/dotfiles-menu"
  ln -s "$root/bin/dotfiles-launcher" "$HOME/.local/bin/dotfiles-launcher"
  ln -s "$root/bin/dotfiles-snippets-sync" "$HOME/.local/bin/dotfiles-snippets-sync"
  "$root/install.sh" --only bin,rofi --check >/dev/null
  [[ -L "$HOME/.local/bin/dotfiles-menu" && -L "$HOME/.local/bin/dotfiles-launcher" ]]
  "$root/install.sh" --only bin,rofi >/dev/null
  [[ -L "$XDG_CONFIG_HOME/dotfiles/snippets.txt" && ! -e "$XDG_CONFIG_HOME/rofi" ]]
  [[ -L "$HOME/.local/bin/dotfiles-macos-snippets-sync" ]]
  [[ ! -e "$HOME/.local/bin/dotfiles-menu" && ! -L "$HOME/.local/bin/dotfiles-menu" ]]
  [[ ! -e "$HOME/.local/bin/dotfiles-launcher" && ! -L "$HOME/.local/bin/dotfiles-launcher" ]]
  [[ ! -e "$HOME/.local/bin/dotfiles-snippets-sync" && ! -L "$HOME/.local/bin/dotfiles-snippets-sync" ]]
  "$root/install.sh" --only bin,rofi --verify >/dev/null
)
printf 'snippets_test: ok\n'

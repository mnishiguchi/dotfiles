#!/bin/bash
# No native macOS applets, clipboard or GUI are touched by these tests.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/snippet-app-test.XXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
export HOME="$scratch/home" XDG_CONFIG_HOME="$scratch/config" XDG_STATE_HOME="$scratch/state"
unset DOTFILES_SNIPPETS_FILE
mkdir -p "$HOME/.local/bin" "$XDG_CONFIG_HOME/dotfiles" "$scratch/mock"
export PATH="$scratch/mock:$PATH"
export MOCK_LOG="$scratch/compiled"
: > "$MOCK_LOG"
cat > "$scratch/mock/uname" <<'SH'
#!/bin/sh
echo "${TEST_PLATFORM:-Darwin}"
SH
cat > "$scratch/mock/id" <<'SH'
#!/bin/sh
echo 501
SH
cat > "$scratch/mock/osacompile" <<'SH'
#!/bin/sh
set -eu
[ "$1" = -o ]
[ "${FAIL_COMPILE:-no}" != yes ] || exit 7
mkdir -p "$2/Contents/Resources/Scripts"
cp "$3" "$2/Contents/Resources/Scripts/main.scpt"
printf 'mock plist\n' > "$2/Contents/Info.plist"
printf '%s\n' "${2##*/}" >> "$MOCK_LOG"
SH
chmod +x "$scratch/mock/"*
ln -s "$root/bin/dotfiles-snippets" "$HOME/.local/bin/dotfiles-snippets"
sync="$root/bin/dotfiles-macos-snippets-sync"
file="$XDG_CONFIG_HOME/dotfiles/snippets.txt"
apps="$HOME/Applications/Dotfiles Snippets"
cat > "$file" <<'TXT'
cmd uuid!printf UUID
cmd date/today!printf DATE
日本語 "quoted" $dollar 'single' \backslash!literal!value
TXT
status=0; "$sync" --verify > /dev/null || status=$?
[[ "$status" == 3 && ! -e "$HOME/Applications" && ! -e "$XDG_STATE_HOME" ]]
"$sync" --check >/dev/null
[[ ! -s "$MOCK_LOG" && ! -e "$HOME/Applications" ]]
mkdir -p "$HOME/Applications/Snippet UUID.app" "$apps"
if "$sync" --check >/dev/null 2>&1; then exit 1; fi
rmdir "$apps"
"$sync" >/dev/null
"$sync" --verify >/dev/null
[[ -d "$apps/Snippet cmd uuid.app" && -d "$apps/Snippet cmd date - today.app" ]]
[[ -d "$HOME/Applications/Snippet UUID.app" ]]
source="$apps/Snippet 日本語 \"quoted\" \$dollar 'single' \\backslash.app/Contents/Resources/Scripts/main.scpt"
[[ -f "$source" ]]
grep -F 'quoted form of "日本語 \"quoted\" $dollar '\''single'\'' \\backslash"' "$source" >/dev/null
! grep -F 'literal!value' "$source"
[[ $(wc -l < "$MOCK_LOG") -eq 3 ]]
"$sync" >/dev/null
[[ $(wc -l < "$MOCK_LOG") -eq 3 ]]
# Value-only changes do not require recompiling; apps resolve at launch.
sed 's/printf UUID/printf NEW/' "$file" > "$scratch/new"; cp "$scratch/new" "$file"
"$sync" --verify >/dev/null
printf 'new!text\n' >> "$file"
status=0; "$sync" --verify >/dev/null || status=$?; [[ "$status" == 3 ]]
# Failed compilation preserves the original app set and releases the lock.
if FAIL_COMPILE=yes "$sync" > /dev/null 2>&1; then exit 1; fi
[[ -d "$apps/Snippet cmd uuid.app" && ! -e "$apps/Snippet new.app" ]]
[[ ! -e "$XDG_STATE_HOME/dotfiles/snippet-apps/.lock" ]]
"$sync" >/dev/null; [[ -d "$apps/Snippet new.app" ]]
grep -v '^new!' "$file" > "$scratch/new"; cp "$scratch/new" "$file"
"$sync" >/dev/null; [[ ! -e "$apps/Snippet new.app" ]]
retired=("$XDG_STATE_HOME"/dotfiles/snippet-apps/retired.*/apps/'Snippet new.app')
[[ -d "${retired[0]}" ]]
# Refuse unknown items, altered payloads, and colliding generated names.
mkdir "$apps/Foreign.app"
if "$sync" --check >/dev/null 2>&1; then exit 1; fi
rmdir "$apps/Foreign.app"
printf 'cmd date - today!collision\n' >> "$file"
if "$sync" --check >/dev/null 2>&1; then exit 1; fi
grep -v '^cmd date - today!' "$file" > "$scratch/new"; cp "$scratch/new" "$file"
"$sync" --verify >/dev/null
printf 'tampered\n' >> "$apps/Snippet cmd uuid.app/Contents/Resources/Scripts/main.scpt"
if "$sync" --verify >/dev/null 2>&1; then exit 1; fi
[[ -d "$apps/Snippet cmd uuid.app" ]]
if TEST_PLATFORM=Linux "$sync" --check >/dev/null 2>&1; then exit 1; fi
printf 'macos_snippet_apps_test: ok\n'

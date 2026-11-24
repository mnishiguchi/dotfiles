#!/bin/bash
# Exercise actual interactive shell config with broken optional executables.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home" TERM=xterm USER=tester
export XDG_CONFIG_HOME="$HOME/.config" XDG_CACHE_HOME="$HOME/.cache" XDG_DATA_HOME="$HOME/.local/share" XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$HOME/.local/bin" "$XDG_CONFIG_HOME/fish"
export PATH="$HOME/.local/bin:$PATH"
export TEST_ROOT="$ROOT"
for tool in eza fzf; do
  printf '#!/bin/sh\nexit 1\n' > "$HOME/.local/bin/$tool"
done
cat > "$HOME/.local/bin/zoxide" <<'EOF'
#!/bin/sh
case "$1 $2" in
  '--version ') echo 'zoxide test';;
  'init bash') echo 'z() { :; }; zi() { return 42; }';;
  'init fish') printf '%s\n' 'function z; true; end' 'function zi; return 42; end';;
  *) exit 1;;
esac
EOF
chmod +x "$HOME/.local/bin/"*
# Simulate Linux here so the macOS Homebrew shellenv cannot reorder mock PATH.
printf '#!/bin/sh\necho Linux\n' > "$HOME/.local/bin/uname"
chmod +x "$HOME/.local/bin/uname"
touch "$HOME/probe"
cd "$HOME"
# Source a full rc in an interactive child, no user/system profiles.
bash --noprofile --norc -ic 'source "$TEST_ROOT/bash/bashrc"; alias ls | grep -qv eza || exit 1; type z >/dev/null || exit 1; zi >/dev/null 2>&1; test "$?" = 127' </dev/null
if command -v fish >/dev/null 2>&1; then
  fish --no-config -ic 'source "$TEST_ROOT/fish/config.fish"; functions ls | string match -q "*eza*"; and exit 1; functions -q z; or exit 1; ls | string match -q "*probe*"; or exit 1; zi >/dev/null 2>&1; test $status -eq 127' </dev/null
else
  printf '%s\n' 'Fish not installed; Fish health regression skipped.'
fi
printf '%s\n' 'shell_health_test: ok'

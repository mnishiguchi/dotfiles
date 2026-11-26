#!/bin/bash
# Exercise doctor output and status with real managed links and mocked tools.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd -P)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-doctor.XXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
export HOME="$scratch/home"
export XDG_CONFIG_HOME="$HOME/.config" XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share" XDG_STATE_HOME="$HOME/.local/state"
export SHELL=/usr/bin/fish
export TEST_PLATFORM=Linux
mkdir -p "$HOME" "$scratch/mock"
export PATH="$scratch/mock:$PATH"
cat > "$scratch/mock/uname" <<'SH'
#!/bin/sh
case "$1" in -s) echo "$TEST_PLATFORM";; -m) echo test-arch;; *) echo "$TEST_PLATFORM";; esac
SH
cat > "$scratch/mock/tool" <<'SH'
#!/bin/sh
name=${0##*/}
if [ "$name" = "${BROKEN_TOOL:-}" ]; then
  echo "simulated runtime failure: $name" >&2
  exit 42
fi
if [ "$name" = docker ]; then
  case "$*" in
    --version) echo 'Docker mock version';;
    'compose version') [ "${NO_COMPOSE:-}" != yes ] || exit 42; echo 'Compose mock version';;
    *) echo 'unexpected Docker daemon operation' >&2; exit 99;;
  esac
elif [ "$name" = tmux ] && [ "$1" = show-options ]; then
  if [ "${NO_TMUX:-}" = yes ]; then exit 1; fi
  echo /usr/bin/fish
elif [ "$name" = fish ] && [ "$1" = -n ]; then
  if [ "${BAD_SYNTAX:-}" = yes ]; then echo 'simulated syntax failure' >&2; exit 1; fi
  test -f "$2"
else
  echo "$name mock version"
fi
SH
cat > "$scratch/mock/rofi" <<'SH'
#!/bin/sh
echo 'rofi mock version'
SH
cat > "$scratch/mock/dscl" <<'SH'
#!/bin/sh
echo 'UserShell: /opt/homebrew/bin/fish'
SH
cat > "$scratch/mock/dotfiles-macos-snippets-sync" <<'SH'
#!/bin/sh
case "${1:-}" in --verify) exit 0;; esac
exit 2
SH
chmod +x "$scratch/mock/"*
for tool in fish tmux git mise nvim yazi fzf rg eza zoxide just lazygit copyq docker; do
  ln -s tool "$scratch/mock/$tool"
done

# Execute through the installed symlink after exercising a real installation.
# No files in the real home directory or repository should be changed.
bash "$root/install.sh" >/dev/null
doctor="$HOME/.local/bin/dotfiles-doctor"
output=$("$doctor" 2>&1)
[[ "$output" == *'OK: Managed links'* && "$output" == *'OK: Terminal launcher'* ]]
[[ "$output" == *'OK: CopyQ clipboard manager'* ]]
[[ "$output" == *'OK: Docker CLI'* && "$output" == *'OK: Docker Compose'* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 0'* ]]
[[ "$output" != *'install.sh:'* && "$output" != *'OK: fish:'* ]]
output=$("$doctor" --verbose 2>&1)
[[ "$output" == *'install.sh: ok'* && "$output" == *"OK: fish: $scratch/mock/fish"* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 0'* ]]
output=$("$doctor" -v 2>&1)
[[ "$output" == *'install.sh: ok'* ]]

# Drift is reported with remediation; checking must not repair it.
rm "$HOME/.local/bin/dotfiles-terminal"
status=0
output=$("$doctor" 2>&1) || status=$?
[[ "$status" == 1 && "$output" == *'install.sh: link   '* ]]
[[ "$output" == *'FAIL: Managed links differ. Run ./install.sh'* ]]
[[ "$output" == *'FAIL: Terminal launcher missing or not executable:'* ]]
[[ "$output" == *'Required failures: 2; advisory warnings: 0'* ]]
[[ ! -e "$HOME/.local/bin/dotfiles-terminal" ]]
bash "$root/install.sh" >/dev/null

# An actual installer error must not be misreported as drift.
rm -rf "$XDG_CACHE_HOME"
touch "$XDG_CACHE_HOME"
status=0
output=$("$doctor" 2>&1) || status=$?
[[ "$status" == 1 && "$output" == *'not a directory:'* ]]
[[ "$output" == *'Managed links could not be checked (installer exit 1)'* ]]
[[ "$output" != *'Managed links differ.'* && -f "$XDG_CACHE_HOME" ]]
rm "$XDG_CACHE_HOME"
mkdir "$XDG_CACHE_HOME"

# Optional failures retain advisory semantics and expose the actual error.
output=$(BROKEN_TOOL=eza "$doctor" 2>&1)
[[ "$output" == *'Warning: eza failed its version check (exit 42)'* ]]
[[ "$output" == *'simulated runtime failure: eza'* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 1'* ]]
status=0
output=$(BROKEN_TOOL=git "$doctor" 2>&1) || status=$?
[[ "$status" == 1 && "$output" == *'FAIL: git failed its version check (exit 42)'* ]]
[[ "$output" == *'simulated runtime failure: git'* ]]
[[ "$output" == *'Required failures: 1; advisory warnings: 0'* ]]
status=0
output=$(BAD_SYNTAX=yes "$doctor" 2>&1) || status=$?
[[ "$status" == 1 && "$output" == *'simulated syntax failure'* ]]
output=$(NO_TMUX=yes "$doctor" 2>&1)
[[ "$output" == *'Required failures: 0; advisory warnings: 1'* ]]

# CopyQ is optional because dotfiles also run in headless sessions.
rm "$scratch/mock/copyq"
output=$("$doctor" 2>&1)
[[ "$output" == *'Warning: CopyQ clipboard manager not found'* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 1'* ]]
ln -s tool "$scratch/mock/copyq"

# Docker CLI and plugin are advisory; no daemon is needed.
output=$(NO_COMPOSE=yes "$doctor" 2>&1)
[[ "$output" == *'Warning: Docker Compose plugin unavailable'* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 1'* ]]
output=$(BROKEN_TOOL=docker "$doctor" 2>&1)
[[ "$output" == *'Warning: Docker CLI version check failed'* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 1'* ]]

# Check Darwin-specific login-shell branch with the actual installer.
export TEST_PLATFORM=Darwin
bash "$root/install.sh" --force >/dev/null
output=$("$doctor" 2>&1)
[[ "$output" == *'Platform: Darwin / test-arch'* && "$output" == *'OK: Login shell'* && "$output" == *'OK: Spotlight snippets'* ]]
[[ "$output" == *'Required failures: 0; advisory warnings: 0'* ]]
output=$("$doctor" --help)
[[ "$output" == *'--verbose'* ]]
status=0
output=$("$doctor" --unknown 2>&1) || status=$?
[[ "$status" == 2 && "$output" == *'Unknown option: --unknown'* ]]
printf '%s\n' 'doctor_test: ok'

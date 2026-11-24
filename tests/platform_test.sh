#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
scratch="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-platform.XXXXXX")"
trap 'rm -rf -- "$scratch"' EXIT
export HOME="$scratch/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$HOME/.local/bin" "$scratch/mock"
# Exercise the real platform before installing uname stubs.
native_preview="$("$project_dir/install.sh" --only bin --check)"
status=0
"$project_dir/install.sh" --only bin --verify >/dev/null || status=$?
[[ "$status" == 3 && ! -e "$XDG_CONFIG_HOME" ]]
case "$(uname -s)" in
  Linux) [[ "$native_preview" == *'/.local/bin/debian-kernel-prune'* ]] ;;
  Darwin) [[ "$native_preview" != *'/.local/bin/debian-kernel-prune'* ]] ;;
esac
export PATH="$scratch/mock:$PATH"
cat > "$scratch/mock/uname" <<'SH'
#!/bin/sh
printf '%s\n' "$TEST_PLATFORM"
SH
chmod +x "$scratch/mock/uname"
export TEST_PLATFORM=Linux
"$project_dir/install.sh" --only shell,bin,other >/dev/null
[[ -L "$HOME/.local/bin/debian-kernel-prune" ]]
[[ -L "$HOME/.local/bin/dotfiles-terminal" ]]
[[ -L "$XDG_CONFIG_HOME/alacritty/alacritty.toml" ]]
"$project_dir/install.sh" --only shell,bin,other >/dev/null

clean_preview="$("$project_dir/install.sh" --only shell,bin,other --check --force)"
[[ "$clean_preview" != *'mkdir  '* && "$clean_preview" != *'link   '* ]]
"$project_dir/install.sh" --only shell,bin,other --verify >/dev/null
rm "$HOME/.local/bin/dotfiles-doctor"
status=0
"$project_dir/install.sh" --only bin --verify >/dev/null || status=$?
[[ "$status" == 3 && ! -e "$HOME/.local/bin/dotfiles-doctor" ]]
"$project_dir/install.sh" --only bin >/dev/null

export TEST_PLATFORM=Darwin
"$project_dir/install.sh" --only bin,rofi --check --force >/dev/null
[[ -L "$HOME/.local/bin/debian-kernel-prune" ]]
"$project_dir/install.sh" --only bin,rofi --force >/dev/null
[[ ! -e "$HOME/.local/bin/debian-kernel-prune" && ! -L "$HOME/.local/bin/debian-kernel-prune" ]]
[[ -L "$HOME/.local/bin/pbcopy" ]]
[[ -L "$HOME/.local/bin/pbpaste" ]]
[[ ! -e "$XDG_CONFIG_HOME/rofi" ]]
"$project_dir/install.sh" --only other >/dev/null

# --only other must install a runnable launcher in a fresh home.
rm "$HOME/.local/bin/dotfiles-terminal"
"$project_dir/install.sh" --only other >/dev/null
[[ -x "$HOME/.local/bin/dotfiles-terminal" ]]
cat > "$HOME/.local/bin/tmux" <<'SH'
#!/bin/sh
printf 'tmux:%s\n' "$*"
SH
cat > "$scratch/login-shell" <<'SH'
#!/bin/sh
printf 'shell:%s\n' "$*"
SH
chmod +x "$HOME/.local/bin/tmux" "$scratch/login-shell"
export SHELL="$scratch/login-shell"
unset TMUX
for TEST_PLATFORM in Linux Darwin; do
  [[ "$("$project_dir/bin/dotfiles-terminal")" == 'tmux:new-session -A -s main' ]]
  [[ "$(TMUX=existing "$project_dir/bin/dotfiles-terminal")" == 'shell:-l' ]]
done
rm "$HOME/.local/bin/tmux"
# Restrict PATH to exercise the missing-tmux fallback even on a machine with tmux.
[[ "$(TEST_PLATFORM=Linux PATH="$scratch/mock" "$project_dir/bin/dotfiles-terminal")" == 'shell:-l' ]]

# Do not touch the real pasteboard or inspect actual processes in tests.
cat > "$scratch/mock/lsof" <<'SH'
#!/bin/sh
case "$*" in
  *-iTCP:3000*) printf '%s\n' 'COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME' 'server 1 me 3u IPv4 0 0t0 TCP *:3000 (LISTEN)' ;;
  *-iUDP:3000*) printf '%s\n' 'COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME' 'server 1 me 4u IPv4 0 0t0 UDP *:3000' 'client 2 me 5u IPv4 0 0t0 UDP 127.0.0.1:4000->127.0.0.1:3000' ;;
  *) exit 1 ;;
esac
SH
chmod +x "$scratch/mock/lsof"
output="$(TEST_PLATFORM=Darwin "$project_dir/bin/port-who" 3000)"
[[ "$output" == *'TCP *:3000 (LISTEN)'* && "$output" == *'UDP *:3000'* && "$output" != *'client'* ]]

printf '%s\n' 'platform_test: ok'

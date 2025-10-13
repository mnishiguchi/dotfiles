#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

this_name="$(basename "$0")"
this_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

help() {
  cat <<'EOF'
Install all dotfiles defined in this project.

Usage:
  install.sh [options]

Options:
  --debug            Enable shell tracing
  --force, -f        Overwrite destination files
  --check            Dry run (show what would change)
  --only <sections>  Comma-separated list: rofi,shell,nvim,git,other
  --help, -h         Show help
EOF
}

say() { echo "$this_name: $*"; }
say_warn() { printf '%b\n' "\033[33m$this_name: $*\033[0m"; }
say_err() { printf '%b\n' "\033[31m$this_name: $*\033[0m" >&2; }
err() {
  say_err "ERROR $*"
  exit 1
}

# Options
debug=false
force=false
check=false
only_sections=""
while [[ $# -gt 0 ]]; do
  case "$1" in
  --debug) debug=true ;;
  --force | -f) force=true ;;
  --check) check=true ;;
  --only)
    shift
    only_sections="${1:-}"
    ;;
  --help | -h)
    help
    exit 0
    ;;
  *) say_warn "Ignoring unknown option: $1" ;;
  esac
  shift || true
done
[[ "$debug" == true ]] && set -x

# Env
# shellcheck source=/dev/null
source "${this_dir}/shell/variables"

backup_dir="$HOME/.dotfiles-backup/$(hostname -s)"
mkdir -p "$backup_dir"

timestamp() { date "+%Y%m%d%H%M%S"; }

# Resolve absolute, dereferenced path if possible
abspath() {
  python3 - "$1" <<'PY'
import os, sys; print(os.path.realpath(sys.argv[1]))
PY
}

backup_file() {
  local target="$1"
  local base ts dest
  base="$(basename "$target")"
  ts="$(timestamp)"
  dest="$backup_dir/${base}~${ts}"

  if [[ -e "$target" || -L "$target" ]]; then
    say "backup $target -> $dest"
    [[ "$check" == true ]] && return 0
    # Follow symlinks and preserve recursively
    if cp -aL "$target" "$dest" 2>/dev/null; then
      :
    else
      # Fallback for platforms lacking -a
      cp -RL "$target" "$dest" 2>/dev/null || true
    fi
  fi
}

# Idempotent, safe symlink
do_symlink() {
  local src="$1" target="$2" ln_flags="-sv"
  [[ "$force" == true ]] && ln_flags="-sfv"

  # Ensure parent exists
  [[ "$check" == true ]] || mkdir -p "$(dirname "$target")"

  # If target is already a symlink to src, skip
  if [[ -L "$target" ]]; then
    local cur dest
    cur="$(readlink "$target")" || cur=""
    dest="$src"
    # Normalize both if possible
    if [[ -n "$cur" && "$(abspath "$cur" 2>/dev/null || echo "$cur")" == "$(abspath "$dest" 2>/dev/null || echo "$dest")" ]]; then
      say "ok     $target already -> $src"
      return 0
    fi
  fi

  # If target exists and is not the right link, back it up
  if [[ -e "$target" || -L "$target" ]]; then
    say "exists $target -- backing up"
    backup_file "$target"
  fi

  say "link   $target -> $src"
  [[ "$check" == true ]] && return 0
  ln $ln_flags "$src" "$target" || true
}

# Section filter
wants() {
  [[ -z "$only_sections" ]] && return 0
  IFS=',' read -r -a parts <<<"$only_sections"
  for p in "${parts[@]}"; do
    [[ "$p" == "$1" ]] && return 0
  done
  return 1
}

# ----------------------
# Sections
# ----------------------

section_rofi() {
  command -v rofi >/dev/null || {
    say_warn "rofi not found; skipping rofi section"
    return
  }
  do_symlink "${this_dir}/rofi/bin/gh-repos" "$HOME/.local/bin/gh-repos"
  do_symlink "${this_dir}/rofi/bin/rofi-gh-repos-modi" "$HOME/.local/bin/rofi-gh-repos-modi"
  do_symlink "${this_dir}/rofi/bin/rofi-power-modi" "$HOME/.local/bin/rofi-power-modi"
  do_symlink "${this_dir}/rofi/bin/rofi-snippets-modi" "$HOME/.local/bin/rofi-snippets-modi"
  do_symlink "${this_dir}/rofi/bin/rofi-combi-menu" "$HOME/.local/bin/rofi-combi-menu"
  do_symlink "${this_dir}/rofi/bin/rofi-power-menu" "$HOME/.local/bin/rofi-power-menu"
  do_symlink "${this_dir}/rofi/config/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
  do_symlink "${this_dir}/rofi/config/power-theme.rasi" "$XDG_CONFIG_HOME/rofi/power-theme.rasi"
  do_symlink "${this_dir}/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
}

section_shell() {
  do_symlink "${this_dir}/shell/aliases" "$XDG_CONFIG_HOME/shell/aliases"
  do_symlink "${this_dir}/shell/variables" "$XDG_CONFIG_HOME/shell/variables"
  do_symlink "${this_dir}/bash/bash_profile" "$HOME/.bash_profile"
  do_symlink "${this_dir}/bash/bashrc" "$HOME/.bashrc"
  do_symlink "${this_dir}/bash/starship.toml" "$XDG_CONFIG_HOME/bash/starship.toml"
}

section_nvim() {
  do_symlink "${this_dir}/nvim" "$XDG_CONFIG_HOME/nvim"
}

section_git() {
  mkdir -p "$XDG_CONFIG_HOME/git"
  do_symlink "${this_dir}/git/global-excludes" "$XDG_CONFIG_HOME/git/global-excludes"
  do_symlink "${this_dir}/git/commit-template" "$XDG_CONFIG_HOME/git/commit-template"
}

section_other() {
  do_symlink "${this_dir}/direnv/direnv.toml" "$XDG_CONFIG_HOME/direnv/direnv.toml"
  do_symlink "${this_dir}/editorconfig" "$HOME/.editorconfig"
  do_symlink "${this_dir}/elixir/default-mix-commands" "$HOME/.default-mix-commands"
  do_symlink "${this_dir}/elixir/iex.exs" "$HOME/.iex.exs"
  do_symlink "${this_dir}/nodejs/npmrc" "$HOME/.npmrc"
  do_symlink "${this_dir}/tmux/tmux.conf" "$HOME/.tmux.conf"
}

main() {
  trap 'say_err "failed at line $LINENO"; exit 1' ERR

  wants rofi && section_rofi
  wants shell && section_shell
  wants nvim && section_nvim
  wants git && section_git
  wants other && section_other

  # Default: run all if --only wasn’t provided
  if [[ -z "$only_sections" ]]; then
    section_rofi
    section_shell
    section_nvim
    section_git
    section_other
  fi

  say "done"
}

main "$@"

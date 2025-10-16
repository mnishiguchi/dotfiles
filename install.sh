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

backup_dir="$HOME/.dotfiles-backup/$(hostname -s)"
mkdir -p "$backup_dir"

timestamp() { date "+%Y%m%d%H%M%S"; }
ensure_dir() { [[ "$check" == true ]] || mkdir -p "$1"; }

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

# Move the existing path into backup (used for --force)
backup_move() {
  local target="$1"
  local base ts dest
  base="$(basename "$target")"
  ts="$(timestamp)"
  dest="$backup_dir/${base}~${ts}"

  if [[ -e "$target" || -L "$target" ]]; then
    say "backup+move $target -> $dest"
    [[ "$check" == true ]] && return 0
    mkdir -p "$backup_dir"
    mv -f "$target" "$dest"
  fi
}

# Idempotent, safe symlink (overwrite only with --force)
do_symlink() {
  local src="$1" target="$2" ln_flags="-sv"
  [[ "$force" == true ]] && ln_flags="-sfv"

  # Ensure parent exists (skipped in --check)
  ensure_dir "$(dirname "$target")"

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

  # Conflict handling
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ "$force" == true ]]; then
      backup_move "$target"
    else
      say_err "conflict: $target exists. Re-run with --force to overwrite (a backup will be saved in $backup_dir)."
      exit 1
    fi
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
  ensure_dir "$HOME/.local/bin"
  ensure_dir "$XDG_CONFIG_HOME/rofi"

  command -v rofi >/dev/null || {
    say_warn "rofi not found; skipping rofi section"
    return
  }
  do_symlink "${this_dir}/rofi/bin/rofi-snippets-modi" "$HOME/.local/bin/rofi-snippets-modi"
  do_symlink "${this_dir}/rofi/bin/rofi-combi-menu" "$HOME/.local/bin/rofi-combi-menu"
  do_symlink "${this_dir}/rofi/config/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
  do_symlink "${this_dir}/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
}

section_shell() {
  do_symlink "${this_dir}/starship.toml" "$XDG_CONFIG_HOME/starship.toml"

  ensure_dir "$XDG_CONFIG_HOME/bash"
  do_symlink "${this_dir}/bash/bash_profile" "$HOME/.bash_profile"
  do_symlink "${this_dir}/bash/bashrc" "$HOME/.bashrc"
}

section_nvim() {
  ensure_dir "$XDG_CONFIG_HOME"
  do_symlink "${this_dir}/nvim" "$XDG_CONFIG_HOME/nvim"
}

section_git() {
  ensure_dir "$XDG_CONFIG_HOME/git"
  do_symlink "${this_dir}/git/global-excludes" "$XDG_CONFIG_HOME/git/global-excludes"
  do_symlink "${this_dir}/git/commit-template" "$XDG_CONFIG_HOME/git/commit-template"
}

section_other() {
  ensure_dir "$XDG_CONFIG_HOME/alacritty"
  do_symlink "${this_dir}/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  do_symlink "${this_dir}/alacritty/alacritty.yml" "$XDG_CONFIG_HOME/alacritty/alacritty.yml"

  ensure_dir "$XDG_CONFIG_HOME/direnv"
  do_symlink "${this_dir}/direnv/direnv.toml" "$XDG_CONFIG_HOME/direnv/direnv.toml"

  do_symlink "${this_dir}/editorconfig" "$HOME/.editorconfig"
  do_symlink "${this_dir}/elixir/default-mix-commands" "$HOME/.default-mix-commands"
  do_symlink "${this_dir}/elixir/iex.exs" "$HOME/.iex.exs"
  do_symlink "${this_dir}/nodejs/npmrc" "$HOME/.npmrc"
  do_symlink "${this_dir}/tmux/tmux.conf" "$HOME/.tmux.conf"
}

main() {
  trap 'say_err "failed at line $LINENO"; exit 1' ERR

  if [[ -n "$only_sections" ]]; then
    wants rofi && section_rofi
    wants shell && section_shell
    wants nvim && section_nvim
    wants git && section_git
    wants other && section_other
  else
    # Default: run all
    section_rofi
    section_shell
    section_nvim
    section_git
    section_other
  fi

  say "done"
}

main "$@"

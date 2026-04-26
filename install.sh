#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

script_name="$(basename "$0")"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

debug=false
force=false
check=false
only_sections=""

help() {
  cat <<'EOF'
Install dotfiles from this repository.

Usage:
  install.sh [options]

Options:
  --check            Dry run. Show what would change.
  --force, -f        Replace existing files after backing them up.
  --only <sections>  Install only selected sections.
                     Available: shell,rofi,nvim,git,other
  --debug            Enable shell tracing.
  --help, -h         Show this help.
EOF
}

say() {
  printf '%s\n' "$script_name: $*"
}

say_warn() {
  printf '\033[33m%s: %s\033[0m\n' "$script_name" "$*" >&2
}

say_err() {
  printf '\033[31m%s: ERROR %s\033[0m\n' "$script_name" "$*" >&2
}

err() {
  say_err "$*"
  exit 1
}

timestamp() {
  date "+%Y%m%d%H%M%S"
}

host_name() {
  hostname -s 2>/dev/null || hostname
}

backup_dir="$HOME/.dotfiles-backup/$(host_name)"

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --check)
      check=true
      shift
      ;;

    --force | -f)
      force=true
      shift
      ;;

    --only)
      if [[ $# -lt 2 ]]; then
        err "--only requires a comma-separated section list"
      fi

      only_sections="$2"
      shift 2
      ;;

    --debug)
      debug=true
      shift
      ;;

    --help | -h)
      help
      exit 0
      ;;

    *)
      err "unknown option: $1"
      ;;
    esac
  done

  if [[ "$debug" == true ]]; then
    set -x
  fi
}

ensure_dir() {
  local path="${1:-}"

  if [[ -z "$path" ]]; then
    err "ensure_dir received an empty path"
  fi

  if [[ "$check" == true ]]; then
    say "mkdir  $path"
    return
  fi

  mkdir -p -- "$path"
}

backup_path_for() {
  local target="$1"
  local backup_name

  if [[ "$target" == "$HOME/"* ]]; then
    backup_name="${target#"$HOME"/}"
  else
    backup_name="${target#/}"
  fi

  backup_name="${backup_name//\//__}"

  printf '%s/%s~%s' "$backup_dir" "$backup_name" "$(timestamp)"
}

backup_existing_path() {
  local target="$1"
  local destination

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    return
  fi

  destination="$(backup_path_for "$target")"

  say "backup $target -> $destination"

  if [[ "$check" == true ]]; then
    return
  fi

  mkdir -p -- "$backup_dir"
  mv -- "$target" "$destination"
}

same_symlink_target() {
  local source="$1"
  local target="$2"
  local current_source
  local desired_source

  if [[ ! -L "$target" ]]; then
    return 1
  fi

  current_source="$(readlink -f -- "$target" 2>/dev/null || true)"
  desired_source="$(readlink -f -- "$source" 2>/dev/null || true)"

  if [[ -z "$current_source" || -z "$desired_source" ]]; then
    return 1
  fi

  [[ "$current_source" == "$desired_source" ]]
}

link_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    err "missing source: $source"
  fi

  ensure_dir "$(dirname -- "$target")"

  if same_symlink_target "$source" "$target"; then
    say "ok     $target already -> $source"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ "$force" == true ]]; then
      backup_existing_path "$target"
    else
      err "conflict: $target exists. Re-run with --force to replace it."
    fi
  fi

  say "link   $target -> $source"

  if [[ "$check" == true ]]; then
    return
  fi

  ln -s -- "$source" "$target"
}

section_enabled() {
  local requested_section="$1"
  local section

  if [[ -z "$only_sections" ]]; then
    return 0
  fi

  IFS=',' read -r -a selected_sections <<<"$only_sections"

  for section in "${selected_sections[@]}"; do
    if [[ "$section" == "$requested_section" ]]; then
      return 0
    fi
  done

  return 1
}

validate_only_sections() {
  local section

  if [[ -z "$only_sections" ]]; then
    return
  fi

  IFS=',' read -r -a selected_sections <<<"$only_sections"

  for section in "${selected_sections[@]}"; do
    case "$section" in
    shell | rofi | nvim | git | other)
      ;;

    "")
      err "--only contains an empty section"
      ;;

    *)
      err "unknown section for --only: $section"
      ;;
    esac
  done
}

run_section() {
  local section="$1"

  if section_enabled "$section"; then
    "section_$section"
  fi
}

## Sections

section_shell() {
  ensure_dir "$XDG_CONFIG_HOME/fish"

  link_path "$script_dir/bash/bashrc" "$HOME/.bashrc"
  link_path "$script_dir/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
}

section_rofi() {
  if ! command -v rofi >/dev/null 2>&1; then
    say_warn "rofi not found; skipping rofi section"
    return
  fi

  ensure_dir "$HOME/.local/bin"
  ensure_dir "$XDG_CONFIG_HOME/rofi"

  link_path "$script_dir/rofi/bin/rofi-snippets-modi" "$HOME/.local/bin/rofi-snippets-modi"
  link_path "$script_dir/rofi/bin/rofi-combi-menu" "$HOME/.local/bin/rofi-combi-menu"
  link_path "$script_dir/rofi/config/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
  link_path "$script_dir/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
}

section_nvim() {
  ensure_dir "$XDG_CONFIG_HOME"

  link_path "$script_dir/nvim" "$XDG_CONFIG_HOME/nvim"
}

section_git() {
  ensure_dir "$XDG_CONFIG_HOME/git"

  link_path "$script_dir/git/global-excludes" "$XDG_CONFIG_HOME/git/global-excludes"
  link_path "$script_dir/git/commit-template" "$XDG_CONFIG_HOME/git/commit-template"
}

section_other() {
  ensure_dir "$XDG_CONFIG_HOME/alacritty"
  ensure_dir "$XDG_CONFIG_HOME/direnv"

  link_path "$script_dir/alacritty/alacritty.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"
  link_path "$script_dir/alacritty/alacritty.yml" "$XDG_CONFIG_HOME/alacritty/alacritty.yml"
  link_path "$script_dir/direnv/direnv.toml" "$XDG_CONFIG_HOME/direnv/direnv.toml"

  link_path "$script_dir/editorconfig" "$HOME/.editorconfig"
  link_path "$script_dir/elixir/default-mix-commands" "$HOME/.default-mix-commands"
  link_path "$script_dir/elixir/iex.exs" "$HOME/.iex.exs"
  link_path "$script_dir/nodejs/npmrc" "$HOME/.npmrc"
  link_path "$script_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
}

main() {
  trap 'say_err "failed at line $LINENO"' ERR

  parse_args "$@"

  : "${XDG_CONFIG_HOME:=$HOME/.config}"
  : "${XDG_CACHE_HOME:=$HOME/.cache}"
  : "${XDG_DATA_HOME:=$HOME/.local/share}"
  : "${XDG_STATE_HOME:=$HOME/.local/state}"

  ensure_dir "$XDG_CONFIG_HOME"
  ensure_dir "$XDG_CACHE_HOME"
  ensure_dir "$XDG_DATA_HOME"
  ensure_dir "$XDG_STATE_HOME"

  validate_only_sections

  run_section shell
  run_section rofi
  run_section nvim
  run_section git
  run_section other

  say "done"
}

main "$@"

#!/usr/bin/env bash
set -eu

# https://stackoverflow.com/a/246128/3837223
this_name="$(basename "$0")"
this_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# https://github.com/japaric/trust/blob/08c86c03efb887c33abd4bd5bc3677f81bac98e7/install.sh
help() {
  cat <<'EOF'
Install all dotfiles that are defined in this project.

Usage:
    install.sh [options]

Options:
    --debug         Display debugging information
    --force, -f     Force overwriting destination files
    --help, -h      Display this message
EOF
}

say() {
  echo "$this_name: $1"
}

say_err() {
  say "$1" >&2
}

err() {
  say_err "ERROR $1"
  exit 1
}

## Option parser

debug=
force=
while [[ "$#" -gt 0 ]]; do
  case "$1" in
  --debug)
    debug=true
    ;;
  --force | -f)
    force=true
    ;;
  --help | -h)
    help
    exit 0
    ;;
  *) ;;
  esac
  shift
done

## Environment variables

source "${this_dir}/shell/variables"

# https://wiki.archlinux.org/title/XDG_Base_Directory
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Git user and email to set up git automatically
GIT_USER_NAME="${GIT_USER_NAME:-}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-}"
GITHUB_USER_NAME="${GITHUB_USER_NAME:-}"

## Presentation

# color_ok="\033[92m"
color_error="\033[91m"
color_warning="\033[93m"
color_default="\033[39m"

## Symlink helpers

if [[ "$debug" = true ]]; then
  set -x
fi

timestamp() { date "+%Y%m%d%H%M%S"; }

basename_no_ext() {
  local f
  f="$(basename "$1")" # remove all the higher path segments
  f="${f#.}"           # remove leading dot
  echo "${f%%.*}"      # remove extension
}

get_ext() {
  local f
  f="$(basename "$1")" # remove all the higher path segments
  f="${f#.}"           # remove all the higher path segments
  local ext="${f#*.}"  # get extension
  # return extension if detected; else return nothing
  [[ ! "$ext" = "$f" ]] && echo "$ext" || return 1
}

backup_dir="$HOME/.dotfiles-backup"
mkdir -p "$backup_dir"

backup_file() {
  local new_filename
  local cp_flags

  if get_ext "$1"; then
    new_filename="$backup_dir/$(basename_no_ext "$1")~$(date "+%Y%m%d").$(get_ext "$1")"
  else
    new_filename="$backup_dir/$(basename_no_ext "$1")~$(date "+%Y%m%d")"
  fi

  if [[ "$(uname)" = Darwin ]]; then
    cp_flags="-RLv"
  else
    # r = recursive
    # L = follow and expand symlinks
    cp_flags="-rLv"
  fi

  # Ignore errors because we want to suppress "cp: directory causes a cycle"
  cp "$cp_flags" "$1" "$new_filename" &>/dev/null || true
}

# Symlinks a file to the specified target
#
# Usage:
#   do_symlink file1 file2
#   do_symlink dir1 dir2
#
do_symlink() {
  local src="$1"
  local target="$2"

  if [[ "$force" = true ]]; then
    ln_flags="-sfv"
  else
    ln_flags="-sv"
  fi

  if [[ -e "$src" ]]; then
    mkdir -p "$(dirname "$target")"

    if [[ -e "$target" ]]; then
      echo "exists $target -- backing up"
      backup_file "$target"
    fi

    # alway exit 0
    ln "$ln_flags" "$src" "$target" || true
  else
    printf "${color_error}✗ source file does not exist: %s\n${color_default}" "$src"
  fi

  echo
}

# Note: always use absolute path when linking files
# Note: symlnking a directory can be tricky

## Rofi

if command -v rofi >/dev/null; then
  # bin
  do_symlink "${this_dir}/rofi/bin/gh-repos" "$HOME/.local/bin/gh-repos"

  # modi
  do_symlink "${this_dir}/rofi/bin/rofi-gh-repos-modi" "$HOME/.local/bin/rofi-gh-repos-modi"
  do_symlink "${this_dir}/rofi/bin/rofi-power-modi" "$HOME/.local/bin/rofi-power-modi"
  do_symlink "${this_dir}/rofi/bin/rofi-snippets-modi" "$HOME/.local/bin/rofi-snippets-modi"

  # menu
  do_symlink "${this_dir}/rofi/bin/rofi-combi-menu" "$HOME/.local/bin/rofi-combi-menu"
  do_symlink "${this_dir}/rofi/bin/rofi-power-menu" "$HOME/.local/bin/rofi-power-menu"

  # configuration
  do_symlink "${this_dir}/rofi/config/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
  do_symlink "${this_dir}/rofi/config/power-theme.rasi" "$XDG_CONFIG_HOME/rofi/power-theme.rasi"
  do_symlink "${this_dir}/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
fi

## Shells

do_symlink "${this_dir}/shell/aliases" "$XDG_CONFIG_HOME/shell/aliases"
do_symlink "${this_dir}/shell/variables" "$XDG_CONFIG_HOME/shell/variables"

do_symlink "${this_dir}/bash/bash_profile" "$HOME/.bash_profile"
do_symlink "${this_dir}/bash/bashrc" "$HOME/.bashrc"
do_symlink "${this_dir}/bash/starship.toml" "$XDG_CONFIG_HOME/bash/starship.toml"

do_symlink "${this_dir}/zsh/zshenv" "$HOME/.zshenv"
do_symlink "${this_dir}/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
do_symlink "${this_dir}/zsh/starship.toml" "$XDG_CONFIG_HOME/zsh/starship.toml"

## Other software

do_symlink "${this_dir}/nvim" "$XDG_CONFIG_HOME/nvim"
do_symlink "${this_dir}/direnv/direnv.toml" "$XDG_CONFIG_HOME/direnv/direnv.toml"
do_symlink "${this_dir}/editorconfig" "$HOME/.editorconfig"
do_symlink "${this_dir}/elixir/default-mix-commands" "$HOME/.default-mix-commands"
do_symlink "${this_dir}/elixir/iex.exs" "$HOME/.iex.exs"
do_symlink "${this_dir}/nodejs/npmrc" "$HOME/.npmrc"
do_symlink "${this_dir}/tmux/tmux.conf" "$HOME/.tmux.conf"
do_symlink "${this_dir}/vim/vimrc" "$HOME/.vim/vimrc"

## Git

gen_git_config() {
  git config --global user.name "$GIT_USER_NAME"
  git config --global user.email "$GIT_USER_EMAIL"
  git config --global github.user "$GITHUB_USER_NAME"
  git config --global core.ignorecase false
  git config --global core.longpaths true
  git config --global init.defaultBranch "main"
  git config --global fetch.prune true
  git config --global advice.detachedHead false

  if command -v diff-so-fancy >/dev/null; then
    git config --global interactive.diffFilter "diff-so-fancy --patch"
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  fi

  if [[ "$(uname)" = "Darwin" ]]; then
    git config --global credential.helper "osxkeychain"
  else
    git config --global credential.helper "store"
  fi

  excludesfile_target="$XDG_CONFIG_HOME/git/excludes"
  if do_symlink "${this_dir}/git/excludes" "$excludesfile_target"; then
    git config --global core.excludesfile "$excludesfile_target"
  fi

  commit_template_target="$XDG_CONFIG_HOME/git/commit-template"
  if do_symlink "${this_dir}/git/commit-template" "$commit_template_target"; then
    git config --global commit.template "$commit_template_target"
  fi
}

# https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
mkdir -p "$XDG_CONFIG_HOME/git"
git_config_file="$XDG_CONFIG_HOME/git/config"

if [[ -f "$git_config_file" ]]; then
  echo "git config file already exists at ${git_config_file}"
  echo
else
  touch "$git_config_file" && gen_git_config
fi

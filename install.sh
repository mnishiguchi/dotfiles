#!/usr/bin/env bash

## Check paths

whereisthis() { cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P; }
this_dir="$(whereisthis)"
printf "current dir: %s\nscript path: %s\n" "$(pwd)" "$this_dir"

## Environment variables

source "${this_dir}/shell/variables"

# https://wiki.archlinux.org/title/XDG_Base_Directory
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Git user and email to set up git automatically
GIT_USER_NAME="${GIT_USER_NAME:-somebody}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-somebody@example.com}"
GITHUB_USER_NAME="${GITHUB_USER_NAME:somebody}"

## Colors

color_default="\033[39m"
black="\033[30m"
red="\033[0;31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
magenta="\033[35m"
cyan="\033[36m"
light_gray="\033[37m"
dark_gray="\033[90m"
light_red="\033[91m"
light_green="\033[92m"
light_yellow="\033[93m"
light_blue="\033[94m"
light_magenta="\033[95m"
light_cyan="\033[96m"
white="\033[97m"

## Helpers

color_error="\033[91m"
color_warning="\033[93m"
puts_warning() { printf "${color_warning}warning: %s${color_default}\n" "${1}"; }
puts_error() { printf "${color_error}error: %s${color_default}\n" "${1}"; }
pcall() { "$@" || true; }
command_exists() { command -v "$1" >/dev/null; }

# Symlinks a file if the file exists.
#
# Usage:
#
#   symlink_file file1 file2
#
function symlink_file {
  if [ -f "$1" ]; then
    mkdir -p "$(dirname "$2")"
    ln -sf "$1" "$2"
    printf "${green}✓${color_default} %s -> %s\n" "$1" "$2"
  else
    printf "${red}✗ source file does not exist: %s\n" "$1"
  fi
}

# Symlinks a directory if the directory exists.
#
# Usage:
#
#   symlink_dir dir1 dir2
#
function symlink_dir {
  if [ -d "$1" ]; then
    mkdir -p "$(dirname "$2")"
    ln -sf "$1" "$2"
    printf "${green}✓${color_default} %s -> %s\n" "$1" "$2"
  else
    printf "${red}✗ source directory does not exist: %s\n" "$1"
  fi
}

# Note: always use absolute path when linking files
# Note: symlnking a directory can be tricky

## Git

# https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
mkdir -p "$XDG_CONFIG_HOME/git"
touch "$XDG_CONFIG_HOME/git/config"

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global github.user "$GITHUB_USER_NAME"
git config --global core.ignorecase false
git config --global init.defaultBranch "main"
git config --global fetch.prune true
git config --global advice.detachedHead false

if command_exists diff-so-fancy; then
  git config --global interactive.diffFilter "diff-so-fancy --patch"
  git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
fi

if [ "$(uname)" = "Darwin" ]; then credential_helper="osxkeychain"; else credential_helper="store"; fi
git config --global credential.helper "$credential_helper"

excludesfile="$XDG_CONFIG_HOME/git/excludes"
symlink_file "${this_dir}/git/excludes" "$excludesfile"
git config --global core.excludesfile "$excludesfile"

commit_template="$XDG_CONFIG_HOME/git/commit-template"
symlink_file "${this_dir}/git/commit-template" "$commit_template"
git config --global commit.template "$commit_template"

# print global git configuration
echo -e "${light_yellow}$(git config --global --list)${color_default}"

## Rofi

if command_exists rofi; then
  # bin
  symlink_file "${this_dir}/rofi/bin/gh-repos" "$HOME/.local/bin/gh-repos"

  # modi
  symlink_file "${this_dir}/rofi/bin/rofi-gh-repos-modi" "$HOME/.local/bin/rofi-gh-repos-modi"
  symlink_file "${this_dir}/rofi/bin/rofi-power-modi" "$HOME/.local/bin/rofi-power-modi"
  symlink_file "${this_dir}/rofi/bin/rofi-snippets-modi" "$HOME/.local/bin/rofi-snippets-modi"

  # menu
  symlink_file "${this_dir}/rofi/bin/rofi-combi-menu" "$HOME/.local/bin/rofi-combi-menu"
  symlink_file "${this_dir}/rofi/bin/rofi-power-menu" "$HOME/.local/bin/rofi-power-menu"

  # configuration
  symlink_file "${this_dir}/rofi/config/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
  symlink_file "${this_dir}/rofi/config/power-theme.rasi" "$XDG_CONFIG_HOME/rofi/power-theme.rasi"
  symlink_file "${this_dir}/rofi/config/snippets.txt" "$XDG_CONFIG_HOME/rofi/snippets.txt"
fi

## Shells

symlink_file "${this_dir}/shell/aliases" "$XDG_CONFIG_HOME/shell/aliases"
symlink_file "${this_dir}/shell/editors" "$XDG_CONFIG_HOME/shell/editors"
symlink_file "${this_dir}/shell/functions" "$XDG_CONFIG_HOME/shell/functions"
symlink_file "${this_dir}/shell/variables" "$XDG_CONFIG_HOME/shell/variables"

symlink_file "${this_dir}/bash/bash_profile" "$HOME/.bash_profile"
symlink_file "${this_dir}/bash/bashrc" "$HOME/.bashrc"
symlink_file "${this_dir}/bash/starship.toml" "$XDG_CONFIG_HOME/bash/starship.toml"

symlink_file "${this_dir}/zsh/zshenv" "$HOME/.zshenv"
symlink_file "${this_dir}/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc"
symlink_file "${this_dir}/zsh/starship.toml" "$XDG_CONFIG_HOME/zsh/starship.toml"

## Other software

symlink_dir "${this_dir}/nvim" "$XDG_CONFIG_HOME/nvim"
symlink_file "${this_dir}/direnv/direnv.toml" "$XDG_CONFIG_HOME/direnv/direnv.toml"
symlink_file "${this_dir}/editorconfig" "$HOME/.editorconfig"
symlink_file "${this_dir}/elixir/default-mix-commands" "$HOME/.default-mix-commands"
symlink_file "${this_dir}/elixir/iex.exs" "$HOME/.iex.exs"
symlink_file "${this_dir}/npmrc" "$XDG_CONFIG_HOME/npm/npmrc"
symlink_file "${this_dir}/ranger/rc.conf" "$XDG_CONFIG_HOME/ranger/rc.conf"
symlink_file "${this_dir}/ruby/irbrc" "$HOME/.irbrc"
symlink_file "${this_dir}/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
symlink_file "${this_dir}/vim/vimrc" "$HOME/.vim/vimrc"

#!/usr/bin/env bash
set -e

# where this script is located
SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

printf "==> Symlinking dotfiles from %s\n" "$SCRIPTPATH"

# Symlinks a file if the file exists.
#
# Usage:
#
#   symlink_file file1 file2
#
function symlink_file {
  if [ -f "$1" ]; then
    mkdir -p $(dirname "$2")
    ln -sf "$1" "$2"
    printf "✓ %s -> %s\n" "$1" "$2"
  else
    printf "✗ source file does not exist: %s\n" "$1"
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
    mkdir -p $(dirname "$2")
    ln -sf "$1" "$2"
    printf "✓ %s -> %s\n" "$1" "$2"
  else
    printf "✗ source directory does not exist: %s\n" "$1"
  fi
}

# always use absolute path when linking files
symlink_dir "$SCRIPTPATH/nvim" "$HOME/.config/nvim"
symlink_file "$SCRIPTPATH/editorconfig" "$HOME/.editorconfig"
symlink_file "$SCRIPTPATH/gitignore_global" "$HOME/.gitignore"
symlink_file "$SCRIPTPATH/iex.exs" "$HOME/.iex.exs"
symlink_file "$SCRIPTPATH/tmux.conf" "$HOME/.tmux.conf"
symlink_file "$SCRIPTPATH/vimrc" "$HOME/.vimrc"
symlink_file "$SCRIPTPATH/zshrc" "$HOME/.zshrc"
symlink_file "$SCRIPTPATH/solargraph_config.yml" "$HOME/.config/solargraph/config.yml"
symlink_file "$SCRIPTPATH/rofi/config/config.rasi" "$HOME/.config/rofi/config.rasi"
symlink_file "$SCRIPTPATH/rofi/config/power-theme.rasi" "$HOME/.config/rofi/power-theme.rasi"
symlink_file "$SCRIPTPATH/rofi/bin/rofi-combi-menu" "$HOME/.local/bin/rofi-combi-menu"
symlink_file "$SCRIPTPATH/rofi/bin/rofi-power-menu" "$HOME/.local/bin/rofi-power-menu"
symlink_file "$SCRIPTPATH/rofi/bin/rofi-power-modi" "$HOME/.local/bin/rofi-power-modi"
symlink_file "$SCRIPTPATH/rofi/bin/rofi-snippets-modi" "$HOME/.local/bin/rofi-snippets-modi"
symlink_file "$SCRIPTPATH/rofi/config/snippets.txt" "$HOME/.config/rofi/snippets.txt"
symlink_file "$SCRIPTPATH/rofi/bin/gh-repos" "$HOME/.local/bin/gh-repos"
symlink_file "$SCRIPTPATH/rofi/bin/rofi-gh-repos-modi" "$HOME/.local/bin/rofi-gh-repos-modi"

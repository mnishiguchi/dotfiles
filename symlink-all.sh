#!/bin/sh
set -e

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
echo "symlinking dotfiles from \"$SCRIPTPATH\" to \"$HOME\""

# be sure to use absolute path when linking files
DOTFILE="$SCRIPTPATH/neovim"
[ -d "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.config/nvim"

DOTFILE="$SCRIPTPATH/editorconfig"
[ -f "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.editorconfig"

DOTFILE="$SCRIPTPATH/gitignore_global"
[ -f "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.gitignore"

DOTFILE="$SCRIPTPATH/iex.ex"
[ -f "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.iex.exs"

DOTFILE="$SCRIPTPATH/tmux.conf"
[ -f "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.tmux.conf"

DOTFILE="$SCRIPTPATH/vimrc"
[ -f "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.vimrc"

DOTFILE="$SCRIPTPATH/zshrc"
[ -f "$DOTFILE" ] && ln -sf "$DOTFILE" "$HOME/.zshrc"

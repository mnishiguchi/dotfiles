#!/bin/sh
set -e

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"
echo "symlinking dotfiles from \"$SCRIPTPATH\" to \"$HOME\""

# be sure to use absolute path when linking files
ln -sf $SCRIPTPATH/.editorconfig $HOME/.editorconfig
ln -sf $SCRIPTPATH/.eslintrc.json $HOME/.eslintrc.json
ln -sf $SCRIPTPATH/.iex.exs $HOME/.iex.exs
ln -sf $SCRIPTPATH/.prettierrc $HOME/.config/.prettierrc
ln -sf $SCRIPTPATH/.vimrc $HOME/.vimrc
ln -sf $SCRIPTPATH/.zshrc $HOME/.zshrc
ln -sf $SCRIPTPATH/starship.toml $HOME/.config/starship.toml

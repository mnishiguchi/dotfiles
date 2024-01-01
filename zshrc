# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# https://github.com/denysdovhan/spaceship-prompt#oh-my-zsh
ZSH_THEME="simple"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  asdf
  colored-man-pages
  common-aliases
  direnv
  z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Ignores any errors when the command is run
pcall() {
  if ! "$@"; then
    return 0
  fi
}

# Ensures the command exists
command-exists() {
  if ! command -v "$1" >/dev/null; then
    echo "$1 not installed" 1>&2
    return 1
  fi
}

## Paths

# On Apple silicon, Homebrew installs files into the /opt/homebrew/ folder, which is not part of the default shell $PATH.
if [ -d "/opt/homebrew/bin:$PATH" ]; then
  PATH="/opt/homebrew/bin:$PATH"
fi

# Include user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

## Files

# create a zip archive of a directory
mkzip() { zip -r "$1".zip "$1"; }

# create a tar-gzip archive of a directory
mktgz() { tar cvzf "$1".tgz "$1"; }
mktargz() { tar cvzf "$1".tar.gz "$1"; }

# extract a compressed archive
extract() {
  if [ ! -f "$1" ]; then
    echo "error: invalid file '$1'"
    return 1
  fi

  case "$1" in
  *.tar.bz2) tar xvjf "$1" ;;
  *.tar.gz) tar xvzf "$1" ;;
  *.bz2) bunzip2 "$1" ;;
  *.rar) unrar x "$1" ;;
  *.gz) gunzip "$1" ;;
  *.tar) tar xvf "$1" ;;
  *.tbz2) tar xvjf "$1" ;;
  *.tgz) tar xvzf "$1" ;;
  *.zip) unzip "$1" ;;
  *.ZIP) unzip "$1" ;;
  *.pax) cat "$1" | pax -r ;;
  *.pax.Z) uncompress "$1" —stdout | pax -r ;;
  *.Z) uncompress "$1" ;;
  *.7z) 7z x "$1" ;;
  *)
    echo "error: don't know how to extract '$1'"
    return 1
    ;;
  esac
}

encrypt() {
  if [ ! -f "$1" ] && [ ! -d "$1" ]; then
    echo "error: invalid file or directory '$1'"
    return 1
  fi

  source="$1"
  archive="${source}.tar.gz"
  tar cvzf "$archive" "$source"
  gpg --symmetric --cipher-algo aes256 "$archive"
  rm -rf "$archive"
}

decrypt() {
  if [ ! -f "$1" ]; then
    echo "error: invalid file: '$1'"
    return 1
  fi

  source="$1"

  case "$source" in
  *.tar.gz.gpg)
    gpg --decrypt "$source" | tar xvzf -
    ;;
  *.gpg)
    gpg --output "${source%.*}" --decrypt "$source"
    ;;
  *)
    echo "error: don't know how to extract '$source'"
    return 1
    ;;
  esac
}

## Git

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch --all'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'
alias gco='git checkout'
alias gd='git diff'
alias gdca='git diff --cached'
alias gf='git fetch'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias gp='git push'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'

## Erlang and Elixir

# https://www.erlang.org/doc/man/erlc.html
export ERLC_USE_SERVER=true
# https://erlang.mk/guide/building.html
export MAKEFLAGS="-j$(($(nproc) + 1))"
# https://hexdocs.pm/iex/IEx.html
export ERL_AFLAGS="-kernel shell_history enabled"
# https://hexdocs.pm/iex/IEx.Helpers.html#open/1
command-exists code && export ELIXIR_EDITOR="code --goto"
command-exists codium && export ELIXIR_EDITOR="codium --goto"
# https://hexdocs.pm/hex/Mix.Tasks.Hex.Docs.html
alias hexdocs="mix hex.docs online "
# https://github.com/asdf-vm/asdf-erlang/blob/master/README.md#setting-the-environment-variable-in-bash
export KERL_BUILD_DOCS="yes"

## Ruby

alias be="bundle exec"

# Install bundler with specific version
install-bundler() {
  if [ -z $1 ]; then
    echo "==> Installing default bundler..."
    gem install bundler
  else
    echo "==> Installing bundler $1..."
    gem uninstall -xI bundler && gem install bundler --version "$1"
  fi
}

## etc


alias timestamp='date "+%Y%m%d%H%M%S"'

TERMINAL_OUTPUT_FILE="~/Desktop/terminal-output.txt"
alias 2desk="tee $TERMINAL_OUTPUT_FILE"

# Show current dir in an iterm tab
# https://gist.github.com/phette23/5270658#gistcomment-3020766
precmd() {
  echo -ne "\e]1;${PWD##*/}\a"
}

# Add newline to the prompt
NEWLINE=$'\n'
PROMPT="$PROMPT${NEWLINE}$ "

# Use ripgrep instead of grep for fzf
# https://dev.to/iggredible/how-to-search-faster-in-vim-with-fzf-vim-36ko
command-exists rg && export FZF_DEFAULT_COMMAND='rg --files'

# Run a simple web server
command-exists npx && alias serve='npx serve '

# Opens memolist index page in the right directory for grepping
alias memolist="(cd $HOME/Documents/memolist/memo && nvim .)"

# Turn on/off capslock
capslock() {
  if [ "$(uname)" = "Darwin" ]; then
    echo "capslock() does not support 'Darwin'"
    return 0
  fi

  if [ -z "$1" ]; then
    # use capslock as capslock
    setxkbmap -option
  else
    # use capslock as another ctrl
    setxkbmap -option ctrl:nocaps
  fi

  setxkbmap -print -verbose 10
}

alias nocaps="capslock off"

# Do this at the very end so that we can tell all above is executed
pcall neofetch

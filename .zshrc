# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/mnishiguchi/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# https://github.com/denysdovhan/spaceship-prompt#oh-my-zsh
# ZSH_THEME="spaceship"

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
# export UPDATE_ZSH_DAYS=13

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  asdf
  bundler
  colored-man-pages
  emoji
  git
  gitfast
  gitignore
  iterm2
  kubectl
  kube-ps1
  mix
  rbenv
  z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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

# ==============================================================================
# My custom settings
# Template: https://gist.github.com/natelandau/10654137
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ENVIRONMENT CONFIGURATION
# ------------------------------------------------------------------------------

# On Apple silicon, Homebrew installs files into the /opt/homebrew/ folder, which is not part of the default shell $PATH.
PATH=/opt/homebrew/bin:$PATH

# https://www.rabbitmq.com/install-homebrew.html
PATH=$PATH:/opt/homebrew/opt/rabbitmq/sbin

# https://docs.flutter.dev/get-started/install/macos#update-your-path
PATH=$PATH:$HOME/src/flutter/bin

# Remove duplicate path entries: https://unix.stackexchange.com/a/149054
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

STRAP_BIN_DIR=~/src/strap/bin
if [ -d $STRAP_BIN_DIR ]; then
  PATH="$STRAP_BIN_DIR:${PATH}"
fi

export ANDROID_HOME=$HOME/Library/Android/sdk

# Use specific version of java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Show current dir in an iterm tab: https://gist.github.com/phette23/5270658#gistcomment-3020766
precmd() {
  echo -ne "\e]1;${PWD##*/}\a"
}

# ------------------------------------------------------------------------------
# 2. MAKE TERMINAL BETTER
# ------------------------------------------------------------------------------

alias which='type -a'                              # Find executables
alias path='echo -e ${PATH//:/\\n}'                # Echo all executable paths
alias t2desk='tee ~/Desktop/terminal-output.txt' # Pipe content to file on MacOS Desktop

alias desk='cd ~/Desktop'
alias src='cd ~/src'
alias dotfiles='cd ~/dotfiles'
alias reload='exec zsh -l'
alias timestamp='date "+%Y%m%d%H%M%S"'

# ------------------------------------------------------------------------------
# 3. FILE AND FOLDER MANAGEMENT
# ------------------------------------------------------------------------------

# Create a zip archive of a folder
mkzip() { zip -r "$1".zip "$1"; }

# Create a tar gzip archive of a folder
mktargz() { tar czvf "$1".tar.gz "$1"; }

# Extract most known archives with one command
extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar e $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ------------------------------------------------------------------------------
# 4. SEARCHING
# ------------------------------------------------------------------------------

ff() { /usr/bin/find . -name "$@"; }     # Find file under the current directory
ffs() { /usr/bin/find . -name "$@"'*'; } # Find file whose name starts with a given string
ffe() { /usr/bin/find . -name '*'"$@"; } # Find file whose name ends with a given string

# ------------------------------------------------------------------------------
# 5. PROCESS MANAGEMENT
# ------------------------------------------------------------------------------

# Find out the pid of a specified process
# - Note that the command name can be specified via a regex
# - E.g. find-pid '/d$/' finds pids of all processes with names ending in 'd'
# - Without the 'sudo' it will only find processes of the current user
fd-pids() { lsof -t -c "$@"; }

alias mem='top -R -F -s 10 -o rsize'
alias cpu='top -R -F -s 10 -o cpu'

# List processes owned by my user
my-ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command; }

# ------------------------------------------------------------------------------
# 6. NETWORKING
# ------------------------------------------------------------------------------

alias my-ip='curl icanhazip.com'                                 # Public facing IP Address
alias flush-dns='dscacheutil -flushcache'                        # Flush out the DNS Cache
alias ip-info0='ipconfig getpacket en0'                          # Get info on connections for en0
alias ip-info1='ipconfig getpacket en1'                          # Get info on connections for en1
alias show-listening-connections='sudo lsof -i | grep LISTEN'    # All listening connections
alias show-network-connections='lsof -i'                         # Show all open TCP/IP sockets
alias show-open-sockets='sudo /usr/sbin/lsof -i -P'              # Display open sockets
alias show-open-tcp-sockets='sudo /usr/sbin/lsof -nP | grep TCP' # Display only open TCP sockets
alias show-open-udp-sockets='sudo /usr/sbin/lsof -nP | grep UDP' # Display only open UDP sockets

# Display useful host related informaton
host-info() {
  echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Current network location :$NC " ; scselect
  echo -e "\n${RED}Public facing IP Address :$NC " ; curl icanhazip.com
  echo
}

# ------------------------------------------------------------------------------
# 7. SYSTEMS OPERATIONS & INFORMATION
# ------------------------------------------------------------------------------

# Recursively delete .DS_Store files
alias rm-ds-store="find . -type f -name '*.DS_Store' -ls -delete"

# Show/Hide hidden files in Finder
alias show-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Clean up LaunchServices to remove duplicates in the "Open With" menu
alias clean-launch-services="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# ------------------------------------------------------------------------------
# 8. SOFTWARE ENGINEERING
# ------------------------------------------------------------------------------

## Git

# Use aliases from https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias grm='git rm --cached -r'

## Elixir

# https://hexdocs.pm/iex/IEx.html
export ERL_AFLAGS="-kernel shell_history enabled"

## Ruby

# Install bundler with specific version
install-bundler() {
  if [ -z $1 ]; then
    # echo "Installing default bundler..."
    gem install bundler
  else
    # echo "Installing bundler $1..."
    gem uninstall -xI bundler && gem install bundler --version "$1"
  fi
}

## NodeJS

# https://trilon.io/blog/how-to-delete-all-nodemodules-recursively
# Find all the "node_modules" directories in the current directory.
alias fd-node-modules='find . -name "node_modules" -type d -prune -print | xargs du -chs'
# Delete all the "node_modules" directories in the current directory.
alias rm-node-modules='find . -name "node_modules" -type d -prune -print -exec rm -rf "{}" \;'

## rbenv etc

eval "$(rbenv init -)"
eval "$(pyenv init --path)" # https://github.com/pyenv/pyenv/issues/1906
eval "$(nodenv init -)"

## direnv

# https://direnv.net/docs/hook.html
eval "$(direnv hook zsh)"

## zsh-users https://github.com/zsh-users

source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# starship prompt https://starship.rs/
eval "$(starship init zsh)"

# Generated by Strap - PATH
export PATH=/usr/local/opt/mysql-client@5.7/bin:$PATH

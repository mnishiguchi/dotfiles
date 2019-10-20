# Template: https://gist.github.com/natelandau/10654137

# -------------------------------
# 1. ENVIRONMENT CONFIGURATION
# -------------------------------

BLACK="\[\e[0;30m\]"
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
BROWN="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
PURPLE="\[\e[0;35m\]"
CYAN="\[\e[0;36m\]"
LIGHT_GRAY="\[\e[0;37m\]"
DARK_GRAY="\[\e[1;30m\]"
LIGHT_RED="\[\e[1;31m\]"
LIGHT_GREEN="\[\e[1;32m\]"
YELLOW="\[\e[1;33m\]"
LIGHT_BLUE="\[\e[1;34m\]"
LIGHT_PURPLE="\[\e[1;35m\]"
LIGHT_CYAN="\[\e[1;36m\]"
WHITE="\[\e[1;37m\]"
END_COLOR="\[\e[0m\]"

# iterm2
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# https://www.iterm2.com/3.3/documentation-scripting-fundamentals.html
# https://gitlab.com/gnachman/iterm2/issues/5958
function iterm2_print_user_vars() {
  iterm2_set_user_var rubyVersion $(ruby -v | awk '{ print $2 }')
  iterm2_set_user_var nodeVersion $(node -v)
  # This is a workaround to support both python 2 and 3.
  iterm2_set_user_var pythonVersion $(
    python <<END
import platform
print(platform.python_version())
END
  )
}

# Show current dir in an iterm tab: https://gist.github.com/phette23/5270658#gistcomment-1336409
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
fi

source ~/git-prompt.sh
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
export GIT_PS1_SHOWDIRTYSTATE=1
# Call iterm2_print_user_vars in PS1 for loading iterms vars: https://gitlab.com/gnachman/iterm2/issues/5958
export PS1="${YELLOW}\u${END_COLOR}:${LIGHT_CYAN}\w${END_COLOR}${LIGHT_GRAY}\$(__git_ps1)\[$(iterm2_print_user_vars)\] \n\$ "

# -----------------------------
# 2. MAKE TERMINAL BETTER
# -----------------------------

alias cp='cp -iv'                        # Preferred 'cp' implementation
alias mv='mv -iv'                        # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                  # Preferred 'mkdir' implementation
alias ll='ls -FlAhp'                     # Preferred 'ls' implementation
alias l='clear && ll'
alias less='less -FSRXc'                 # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }            # Always list directory contents upon 'cd'
alias ..='cd ../'                        # Go back 1 directory level
alias ...='cd ../../'                    # Go back 2 directory levels
alias which='type -all'                  # Find executables
alias path='echo -e ${PATH//:/\\n}'      # Echo all executable Paths
mcd() { mkdir -p "$1" && cd "$1"; }      # Makes new Dir and jumps inside
trash() { command mv "$@" ~/.Trash; }    # Moves a file to the MacOS trash
ql() { qlmanage -p "$*" >&/dev/null; }   # Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt' # Pipe content to file on MacOS Desktop

alias _='sudo'
alias o='open'
alias c='pbcopy' # Copy text from stdin into the clipboard buffer
alias v='pbpaste' # Pastes from your clipboard to stdout
alias downloads='cd ~/Downloads'
alias desk='cd ~/Desktop'
alias src='cd ~/src && ls'
alias edit='code'
alias dot='code ~/dotfiles'

# Search a manpage arg1 for a term arg2 case insensitive
mans() { man $1 | grep -iC2 --color=always $2 | less; }

# -------------------------------
# 3. FILE AND FOLDER MANAGEMENT
# -------------------------------

zipf() { zip -r "$1".zip "$1"; }       # To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)' # Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'    # Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'    # Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat' # Creates a file of 10mb size (all zeros)

# 'Cd's to frontmost window of MacOS Finder
cdf() {
  currFolderPath=$(
    /usr/bin/osascript <<EOT
        tell application "Finder"
            try
        set currFolder to (folder of the front window as alias)
            on error
        set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell
EOT
  )
  echo "cd to \"$currFolderPath\""
  cd "$currFolderPath"
}

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

# ---------------------------
# 4. SEARCHING
# ---------------------------

alias qfind="find . -name "              # Quickly search for file
ff() { /usr/bin/find . -name "$@"; }     # Find file under the current directory
ffs() { /usr/bin/find . -name "$@"'*'; } # Find file whose name starts with a given string
ffe() { /usr/bin/find . -name '*'"$@"; } # Find file whose name ends with a given string

# Search for a file using MacOS Spotlight's metadata
spotlight() { mdfind "kMDItemDisplayName == '$@'wc"; }

# ---------------------------
# 5. PROCESS MANAGEMENT
# ---------------------------

# Find out the pid of a specified process
# - Note that the command name can be specified via a regex
# - E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
# - Without the 'sudo' it will only find processes of the current user
findPid() { lsof -t -c "$@"; }

alias mem='top -R -F -s 10 -o rsize'
alias cpu='top -R -F -s 10 -o cpu'

# List processes owned by my user
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command; }

# ---------------------------
# 6. NETWORKING
# ---------------------------

alias myip='curl icanhazip.com'                   # Public facing IP Address
alias netCons='lsof -i'                           # Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'          # Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'           # Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP' # Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP' # Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'            # Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'            # Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'      # All listening connections

# Display useful host related informaton
ii() {
  echo -e "\nYou are logged on ${RED}$HOST"
  echo -e "\nAdditionnal information:$NC " ; uname -a
  echo -e "\n${RED}Users logged on:$NC " ; w -h
  echo -e "\n${RED}Current date :$NC " ; date
  echo -e "\n${RED}Machine stats :$NC " ; uptime
  echo -e "\n${RED}Current network location :$NC " ; scselect
  echo -e "\n${RED}Public facing IP Address :$NC " ; myip
  echo
}

# ---------------------------------------
# 7. SYSTEMS OPERATIONS & INFORMATION
# ---------------------------------------

# Recursively delete .DS_Store files
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

# Show/Hide hidden files in Finder
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

# Clean up LaunchServices to remove duplicates in the "Open With" menu
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# ---------------------------------------
# 8. WEB DEVELOPMENT
# ---------------------------------------

# Git
alias g='git'
alias ga='git add'
alias gs='git status'
alias gas='git add -A; git status'
alias gc='git commit'
alias gcam='gc --am'
alias go='git checkout'
alias gf='git fetch'
alias gp='git push'
alias gb='git branch'
alias gd='git diff'
alias grm='git rm --cached -r'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph  --decorate --all'

# Ruby and Rails
export BUNDLER_EDITOR='code'
alias be="bundle exec"
alias bu="bundle update"
alias cap="be cap"
alias dbreset="be rake db:drop && be rake db:create && be rake db:migrate && be rake db:seed"
alias precompile="RAILS_ENV=production be rake assets:clean && RAILS_ENV=production be rake assets:precompile"
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'
alias pryr='be pry -r ./config/environment'

alias rcop='rubocop'
alias rcop-fix='rubocop -a'
alias rcop-todo='rubocop --auto-gen-config'

# Install bundler with specific version
installBundler() {
  if [ -z $1 ]; then
    # echo "Installing default bundler..."
    gem install bundler
  else
    # echo "Installing bundler $1..."
    gem uninstall -xI bundler && gem install bundler --version "$1"
  fi
}

# Jekyll
alias jek="be jekyll serve -w"

# Python
alias pr="pipenv run"

# Puma-dev
alias pdev-log="tail -f ~/Library/Logs/puma-dev.log"
alias pdev-restart="touch tmp/restart.txt"

# Utiities
alias reload='source ~/.bash_profile'
alias timestamp='date "+%Y%m%d%H%M%S"'
alias chrome='open -a "Google Chrome.app"'

# SSH
# `ssh-add` adds private keys to the ssh agent, there is an issue with this not happening by default on start / reboot.
ssh-add -K 2>/dev/null

# Heroku
export PATH="/usr/local/heroku/bin:$PATH"

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias ya='yarn add '
alias yr='yarn remove '
alias yu='yarn upgrade '

# Flutter
export PATH=$PATH:$HOME/src/flutter/bin

# RBENV etc
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

eval "$(nodenv init -)"
export PATH="$HOME/.nodenv/bin:$PATH"

eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Strap
STRAP_BIN_DIR=~/src/strap/bin
if [ -d $STRAP_BIN_DIR ]; then
  PATH="$STRAP_BIN_DIR:${PATH}"
fi

# Use specific version of java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# AWS
export AWS_DEFAULT_REGION=us-east-1
alias aws-config='cat ~/.aws/config'
alias aws-credentials='cat ~/.aws/credentials'

# Remove duplicate path entries: https://unix.stackexchange.com/a/149054
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

alias inknotes='code ~/inknotes.md'

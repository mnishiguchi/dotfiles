# Template: https://gist.github.com/natelandau/10654137

# -------------------------------
# 1. ENVIRONMENT CONFIGURATION
# -------------------------------

export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$PATH:$HOME/src/flutter/bin
export PATH=$PATH:/usr/local/opt/rabbitmq/sbin

STRAP_BIN_DIR=~/src/strap/bin
if [ -d $STRAP_BIN_DIR ]; then
  PATH="$STRAP_BIN_DIR:${PATH}"
fi

# Use specific version of java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Remove duplicate path entries: https://unix.stackexchange.com/a/149054
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

export GREP_OPTIONS='--color=always'

# Show current dir in an iterm tab: https://gist.github.com/phette23/5270658#gistcomment-1336409
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
fi

# -----------------------------
# 2. MAKE TERMINAL BETTER
# -----------------------------

alias cp='cp -iv'                        # Preferred 'cp' implementation
alias mv='mv -iv'                        # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                  # Preferred 'mkdir' implementation
alias grep='rg'                          # https://github.com/BurntSushi/ripgrep
alias cat='bat'                          # https://github.com/sharkdp/bat
alias ls='exa'                           # https://the.exa.website
alias ll='gls --time-style=long-iso -lAF'
alias less='less -FSRXc'                 # Preferred 'less' implementation
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
alias desk='cd ~/Desktop'
alias src='cd ~/src && ls'
alias dot='code ~/dotfiles'
alias clear='clear && source ~/.bash_profile'
alias timestamp='date "+%Y%m%d%H%M%S"'
alias chrome='open -a "Google Chrome.app"'

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
alias finderShowHidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias finderHideHidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Clean up LaunchServices to remove duplicates in the "Open With" menu
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# ---------------------------------------
# 8. SOFTWARE ENGINEERING
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
alias gb='git branch'
alias gd='git diff'
alias grm='git rm --cached -r'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph  --decorate --all'

# Ruby
export BUNDLER_EDITOR='code'
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"
alias cap="be cap"
alias fman="be foreman start -f"
alias dbreset="be rake db:drop && be rake db:create && be rake db:migrate && be rake db:seed"
alias logdev='tail -f log/development.log'
alias logtest='tail -f log/test.log'
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

# SSH
# `ssh-add` adds private keys to the ssh agent, there is an issue with this not happening by default on start / reboot.
ssh-add -K 2>/dev/null

# Yarn
alias ya='yarn add '
alias yr='yarn remove '
alias yu='yarn upgrade '

# AWS
alias aws-config='code ~/.aws/config'
alias aws-credentials='code ~/.aws/credentials'

# Docker
alias dk='docker'
alias dc='docker-compose'
alias dcr='docker-compose run'
alias dcx='docker-compose exec'
alias dcl='docker-compose logs'

# My memo
# Cd to home so that I can use global ruby.
# The dev-null redirection is for skipping std ouput of my custom cd definition.
alias inknotes='cd ~ > /dev/null ; mdless ~/inknotes.md ; cd - > /dev/null'

alias vsconfig='code ~/Library/"Application Support"/Code/User/settings.json'

# https://starship.rs/
eval "$(starship init bash)"

# https://github.com/anyenv/anyenv
eval "$(anyenv init -)"
# This will set the LANG variable for your environment
export LANG=en_US.UTF-8

. $(brew --prefix asdf)/asdf.sh

. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash

source /Users/mnishiguchi/.config/broot/launcher/bash/br

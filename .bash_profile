# To load in the git branch prompt script
source ~/.git-prompt.sh

# To load in the .bashrc
source ~/.bashrc

# For subl to work on the command line for Sublime Text 3
export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
export EDITOR='subl -w'

# Coloring in the terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Highlight grep matches
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# Prompt
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '

# Finder
alias show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# My Utiities
alias find_app_files=funcFindAppFiles
funcFindAppFiles() {
  find app -type f | awk '{print "_"$0"_"}'
}
alias find_file_by_name='find . -type f -iname'
alias find_dir_by_name='find . -type d -iname'
funcFindStrInDir() {
    /usr/bin/grep -r "$1" $2
}
alias find_str_in_dir=funcFindStrInDir

# Ruby and Rails
alias cd-rails='cd /Users/masa/workspace-rails;ls'
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:seed"
alias rails_testlog='tail -f log/test.log'

# Git
alias gs='git status '
alias ga='git add'
alias gas='git add -A; git st'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Added by Canopy installer on 2015-04-15
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make bashprompt show that Canopy is active, otherwise 1
VIRTUAL_ENV_DISABLE_PROMPT=1 source /Users/masa/Library/Enthought/Canopy_32bit/User/bin/activate

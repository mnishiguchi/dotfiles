# Load script for the git branch prompt
source ~/.git-prompt.sh

# `subl` command to open Sublime Text 3 from the command line
export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
export EDITOR='subl -w'

# Coloring for the terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Highlight grep matches
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# Custom prompt
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '

# Show dotfiles in OS X Finder
alias show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Git

alias gs='git status '
alias ga='git add'
alias gas='git add -A; git st'
alias gc='git commit'
alias go='git checkout '

# Rails

alias cd-rails='cd /Users/masa/workspace-rails;ls'
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:seed"
alias testlog='tail -f log/test.log'

# Utiities

alias find_file_by_name='find . -type f -iname'
alias find_dir_by_name='find . -type d -iname'

funcFindAppFiles() {
  find app -type f | awk '{print "_"$0"_"}'
}
alias find_app_files=funcFindAppFiles

funcFindStrDir() {
  /usr/bin/grep -r "$1" $2
}
alias find_str_in_dir=funcFindStrDir

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Added by Canopy installer on 2015-04-15
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make bashprompt show that Canopy is active, otherwise 1
VIRTUAL_ENV_DISABLE_PROMPT=1 source /Users/masa/Library/Enthought/Canopy_32bit/User/bin/activate

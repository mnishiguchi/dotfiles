# Load scripts
source ~/.git-prompt.sh

# Move dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias desk='cd ~/Desktop'
alias proj_ruby='cd ~/projects/ruby'
alias proj_rails='cd ~/projects/ruby'
alias proj_ng='cd ~/projects/ng'
alias proj_ng2='cd ~/projects/ng2'
alias proj_react='cd ~/projects/react'
alias proj_node='cd ~/projects/node'
alias proj_php='cd ~/projects/php'
alias proj_wp='cd ~/projects/php'

# Show hidden files in OS X Finder
alias show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Git
alias gs='git status '
alias ga='git add'
alias gas='git add -A; git st'
alias gc='git commit'
alias go='git checkout '
alias grm='git rm --cached -r '
alias gl='git log --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'

# Ruby and Rails
alias be="bundle exec "
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed"
alias testlog='tail -f log/test.log'

# Jekyll
alias jek="jekyll serve -w"

# Utiities
alias reload='source ~/.bash_profile'
alias timestamp='date "+%y-%m-%d_%H_%M_%S"'
alias find_file_by_name='find . -type f -iname'
alias find_dir_by_name='find . -type d -iname'

function ls-a(){
  echo ""
  echo "----------"
  ls -AF1 $1
  echo "----------"
  echo ""
}

function app_files() {
  find app -type f | awk '{print "_"$0"_"}'
}

function find_string() {
  /usr/bin/grep -r "$1" $2
}


# Sublime
# `subl` command to open Sublime Text 3 from the command line
# export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
# export EDITOR='subl -w'

# Github
export GITHUB_USERNAME='mnishiguchi'

# Colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Highlight grep matches
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# ANSI codes
BLACK="\[\e[0;30m\]"
BLUE="\[\e[0;34m\]"
GREEN="\[\e[0;32m\]"
CYAN="\[\e[0;36m\]"
RED="\[\e[0;31m\]"
PURPLE="\[\e[0;35m\]"
BROWN="\[\e[0;33m\]"
GRAY="\[\e[0;37m\]"
DARK_GRAY="\[\e[1;30m\]"
LIGHT_BLUE="\[\e[1;34m\]"
LIGHT_GREEN="\[\e[1;32m\]"
LIGHT_CYAN="\[\e[1;36m\]"
LIGHT_RED="\[\e[1;31m\]"
LIGHT_PURPLE="\[\e[1;35m\]"
YELLOW="\[\e[1;33m\]"
WHITE="\[\e[1;37m\]"
END_COLOR="\[\e[m\]"

# Custom prompt
# PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
# PS1="$BROWN\u$END_COLOR@$GREEN\h$END_COLOR:$LIGHT_BLUE\w$END_COLOR$GRAY$(__git_ps1)\n\$ "
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}

alias chrome='open -a "Google Chrome.app"'

export PATH="$HOME/.rbenv/bin:$PATH"
# Load scripts
source ~/.git-prompt.sh

# Move dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias desk='cd ~/Desktop'
alias proj_ruby='cd ~/projects/ruby'
alias proj_rails='cd ~/projects/ruby'
alias proj_ng='cd ~/projects/ng'
alias proj_ng2='cd ~/projects/ng2'
alias proj_react='cd ~/projects/react'
alias proj_node='cd ~/projects/node'
alias proj_php='cd ~/projects/php'
alias proj_wp='cd ~/projects/php'

# Show hidden files in OS X Finder
alias show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Git
alias gs='git status '
alias ga='git add'
alias gas='git add -A; git st'
alias gc='git commit'
alias go='git checkout '
alias grm='git rm --cached -r '
alias gl='git log --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'

# Ruby and Rails
alias be="bundle exec "
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed"
alias testlog='tail -f log/test.log'

# Jekyll
alias jek="jekyll serve -w"

# Utiities
alias reload='source ~/.bash_profile'
alias timestamp='date "+%y-%m-%d_%H_%M_%S"'
alias find_file_by_name='find . -type f -iname'
alias find_dir_by_name='find . -type d -iname'

function ls-a(){
  echo ""
  echo "----------"
  ls -AF1 $1
  echo "----------"
  echo ""
}

function app_files() {
  find app -type f | awk '{print "_"$0"_"}'
}

function find_string() {
  /usr/bin/grep -r "$1" $2
}


# Sublime
# `subl` command to open Sublime Text 3 from the command line
# export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
# export EDITOR='subl -w'

# Github
export GITHUB_USERNAME='mnishiguchi'

# Colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Highlight grep matches
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# ANSI codes
BLACK="\[\e[0;30m\]"
BLUE="\[\e[0;34m\]"
GREEN="\[\e[0;32m\]"
CYAN="\[\e[0;36m\]"
RED="\[\e[0;31m\]"
PURPLE="\[\e[0;35m\]"
BROWN="\[\e[0;33m\]"
GRAY="\[\e[0;37m\]"
DARK_GRAY="\[\e[1;30m\]"
LIGHT_BLUE="\[\e[1;34m\]"
LIGHT_GREEN="\[\e[1;32m\]"
LIGHT_CYAN="\[\e[1;36m\]"
LIGHT_RED="\[\e[1;31m\]"
LIGHT_PURPLE="\[\e[1;35m\]"
YELLOW="\[\e[1;33m\]"
WHITE="\[\e[1;37m\]"
END_COLOR="\[\e[m\]"

# Custom prompt
# PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
# PS1="$BROWN\u$END_COLOR@$GREEN\h$END_COLOR:$LIGHT_BLUE\w$END_COLOR$GRAY$(__git_ps1)\n\$ "
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}

alias chrome='open -a "Google Chrome.app"'

export PATH="$HOME/.rbenv/bin:$PATH"
# Load scripts
source ~/.git-prompt.sh

# Move dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias desk='cd ~/Desktop'
alias proj_ruby='cd ~/projects/ruby'
alias proj_rails='cd ~/projects/ruby'
alias proj_ng='cd ~/projects/ng'
alias proj_ng2='cd ~/projects/ng2'
alias proj_react='cd ~/projects/react'
alias proj_node='cd ~/projects/node'
alias proj_php='cd ~/projects/php'
alias proj_wp='cd ~/projects/php'

# Show hidden files in OS X Finder
alias show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Git
alias gs='git status '
alias ga='git add'
alias gas='git add -A; git st'
alias gc='git commit'
alias go='git checkout '
alias grm='git rm --cached -r '
alias gl='git log --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'

# Ruby and Rails
alias be="bundle exec "
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed"
alias testlog='tail -f log/test.log'

# Jekyll
alias jek="jekyll serve -w"

# Utiities
alias reload='source ~/.bash_profile'
alias timestamp='date "+%y-%m-%d_%H_%M_%S"'
alias find_file_by_name='find . -type f -iname'
alias find_dir_by_name='find . -type d -iname'

function ls-a(){
  echo ""
  echo "----------"
  ls -AF1 $1
  echo "----------"
  echo ""
}

function app_files() {
  find app -type f | awk '{print "_"$0"_"}'
}

function find_string() {
  /usr/bin/grep -r "$1" $2
}


# Sublime
# `subl` command to open Sublime Text 3 from the command line
# export PATH=/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
# export EDITOR='subl -w'

# Github
export GITHUB_USERNAME='mnishiguchi'

# Colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Highlight grep matches
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# ANSI codes
BLACK="\[\e[0;30m\]"
BLUE="\[\e[0;34m\]"
GREEN="\[\e[0;32m\]"
CYAN="\[\e[0;36m\]"
RED="\[\e[0;31m\]"
PURPLE="\[\e[0;35m\]"
BROWN="\[\e[0;33m\]"
GRAY="\[\e[0;37m\]"
DARK_GRAY="\[\e[1;30m\]"
LIGHT_BLUE="\[\e[1;34m\]"
LIGHT_GREEN="\[\e[1;32m\]"
LIGHT_CYAN="\[\e[1;36m\]"
LIGHT_RED="\[\e[1;31m\]"
LIGHT_PURPLE="\[\e[1;35m\]"
YELLOW="\[\e[1;33m\]"
WHITE="\[\e[1;37m\]"
END_COLOR="\[\e[m\]"

# Custom prompt
# PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
# PS1="$BROWN\u$END_COLOR@$GREEN\h$END_COLOR:$LIGHT_BLUE\w$END_COLOR$GRAY$(__git_ps1)\n\$ "
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# {{{
# Node Completion - Auto-generated, do not touch.
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done
# }}}

alias chrome='open -a "Google Chrome.app"'

### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

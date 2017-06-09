# Colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Highlight grep matches
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# ANSI codes
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

# Custom prompt
source ~/.git-prompt.sh
# PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
# PS1="$BROWN\u$END_COLOR@$GREEN\h$END_COLOR:$LIGHT_BLUE\w$END_COLOR$GRAY$(__git_ps1)\n\$ "
PS1='\[\e[1;33m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\[\e[1;32m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '

# Move dirs
alias ..='cd ..'
alias ...='cd ...'
alias desk='cd ~/Desktop'
alias code='cd ~/projects'

# Show hidden files in OS X Finder
alias show_files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide_files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# Git
export GITHUB_USERNAME='mnishiguchi'
alias gs='git status '
alias ga='git add'
alias gas='git add -A; git st'
alias gc='git commit'
alias go='git checkout '
alias grm='git rm --cached -r '
# The basic colors accepted are normal, black, red, green, yellow, blue, magenta, cyan and white.
# https://git-scm.com/docs/pretty-formats#_pretty_formats
# https://git-scm.com/docs/git-config#git-config-color
alias gl='git log --decorate --graph --pretty=format:"%C(#cbff57)%h%C(reset) %C(auto)%d%C(reset) %C(#ff57cb)%ar%C(reset) %C(#57cbff)%an%C(reset) %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(#cbff57)%h%C(reset) %C(auto)%d%C(reset) %C(#ff57cb)%ar%C(reset) %C(#57cbff)%an%C(reset) %n%w(72,1,2)%s"'

# Ruby and Rails
alias be="bundle exec "
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed"
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'

# Jekyll
alias jek="jekyll serve -w"

# Utiities
alias reload='source ~/.bash_profile'
alias timestamp='date "+%Y%m%d%H%M%S"'
alias chrome='open -a "Google Chrome.app"'

function ls-a() {
  echo ""
  echo "----------"
  ls -AF1 $1
  echo "----------"
  echo ""
}

function app_files() {
  find app -type f | awk '{print "_"$0"_"}'
}

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

### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

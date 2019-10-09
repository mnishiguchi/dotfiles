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

# cd
alias ..='cd ..'
alias ...='cd ...'
alias desk='cd ~/Desktop'
alias dot='cd ~/dotfiles'
alias src='cd ~/src && ls'

# top
alias mem='top -o rsize'
alias cpu='top -o cpu'

# OSX Finder
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# git
alias ga='git add'
alias gs='git status '
alias gas='git add -A; git st'
alias gc='git commit'
alias go='git checkout'
alias gf='git fetch'
alias gp='git push'
alias gb='git branch'
alias gd='git diff'
alias grm='git rm --cached -r '
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph  --decorate --all'

# ruby and rails
export BUNDLER_EDITOR='code'
alias be="bundle exec "
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'
alias pryr='bundle exec pry -r ./config/environment'

# python
alias pr="pipenv run"

# puma-dev
alias pdev-log="tail -f ~/Library/Logs/puma-dev.log"
alias pdev-restart="touch tmp/restart.txt"

# jekyll
alias jek="jekyll serve -w"

# utiities
alias reload='source ~/.bash_profile'
alias timestamp='date "+%Y%m%d%H%M%S"'
alias chrome='open -a "Google Chrome.app"'

# ssh
# `ssh-add` adds private keys to the ssh agent, there is an issue with this not happening by default on start / reboot.
ssh-add -K 2> /dev/null

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias ya='yarn add '
alias yr='yarn remove '
alias yu='yarn upgrade '

# flutter
export PATH=$PATH:$HOME/src/flutter/bin

# https://stackoverflow.com/questions/10940736/rbenv-not-changing-ruby-version
# export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(pyenv init -)"

# strap
STRAP_BIN_DIR=~/src/strap/bin
if [ -d $STRAP_BIN_DIR ]; then
  PATH="$STRAP_BIN_DIR:${PATH}"
fi

alias inknotes='cat ~/inknotes.md'

# use specific version of java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# Rubocop
alias rcp='rubocop'
alias rcp-fix='rubocop -a'
alias rcp-todo='rubocop --auto-gen-config'

# iterm2
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# https://www.iterm2.com/3.3/documentation-scripting-fundamentals.html
# https://gitlab.com/gnachman/iterm2/issues/5958
function iterm2_print_user_vars() {
  iterm2_set_user_var rubyVersion $(ruby -v | awk '{ print $2 }')
  iterm2_set_user_var nodeVersion $(node -v)
  # This is a workaround to support both python 2 and 3.
  iterm2_set_user_var pythonVersion $(
python << END
import platform
print(platform.python_version())
END
  )
}

# Show current dir in an iterm tab
# https://gist.github.com/phette23/5270658#gistcomment-1336409
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'
fi

# Prompt
source ~/git-prompt.sh
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
GIT_PS1_SHOWDIRTYSTATE=1
# Call iterm2_print_user_vars in PS1 for loading iterms vars: https://gitlab.com/gnachman/iterm2/issues/5958
PS1="${YELLOW}\u${END_COLOR}:${LIGHT_CYAN}\w${END_COLOR}${LIGHT_GRAY}\$(__git_ps1)\[$(iterm2_print_user_vars)\] \$ "

# aws
export AWS_DEFAULT_REGION=us-east-1
alias aws-config='cat ~/.aws/config'
alias aws-credentials='cat ~/.aws/credentials'

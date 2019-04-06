# colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# grep match highlight
export GREP_OPTIONS='--color=auto'
export TERM="xterm-color"

# prompt
source ~/bin/git-prompt.sh
PS1='\[\e[1;33m\]\u\[\e[0m\]@\[\e[1;34m\]\h\[\e[0m\]:\[\e[1;32m\]\w\[\e[0m\]\[\e[0;37m\]$(__git_ps1)\n\$ '
GIT_PS1_SHOWDIRTYSTATE=1

# cd
alias ..='cd ..'
alias ...='cd ...'
alias desk='cd ~/Desktop'
alias dot='cd ~/dotfiles'

# top
alias mem='top -o rsize'
alias cpu='top -o cpu'

# show and hide hidden files in OS X Finder
alias show-hidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files shown'
alias hide-hidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app; echo Dot files hidden'

# git
export GITHUB_USERNAME='mnishiguchi'
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
# The basic colors accepted are normal, black, red, green, yellow, blue, magenta, cyan and white.
# https://git-scm.com/docs/pretty-formats#_pretty_formats
# https://git-scm.com/docs/git-config#git-config-color
alias gl='git log --decorate --graph --pretty=format:"%C(#cbff57)%h%C(reset) %C(auto)%d%C(reset) %C(#ff57cb)%ar%C(reset) %C(#57cbff)%an%C(reset) %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(#cbff57)%h%C(reset) %C(auto)%d%C(reset) %C(#ff57cb)%ar%C(reset) %C(#57cbff)%an%C(reset) %n%w(72,1,2)%s"'

# ruby and rails
alias be="bundle exec "
alias bu='bundle update '
alias precompile="RAILS_ENV=production rake assets:clean && RAILS_ENV=production bundle exec rake assets:precompile"
alias dbreset="rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed"
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'

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

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# elasticsearch
export PATH="/usr/local/opt/elasticsearch@5.6/bin:$PATH"

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias ya='yarn add '
alias yr='yarn remove '
alias yu='yarn upgrade '

# flutter
export PATH=$PATH:$HOME/development/flutter/bin

# rbenv
# https://stackoverflow.com/a/12150580/3837223
export PATH="$HOME/.rbenv/bin:$PATH"
# load rbenv
eval "$(rbenv init -)"

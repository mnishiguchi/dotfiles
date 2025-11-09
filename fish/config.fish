status is-interactive; or exit

## XDG & common dirs

set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
mkdir -p $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_STATE_HOME

## PATHs

if not set -q ANDROID_HOME
    set -gx ANDROID_HOME "$HOME/Android/Sdk"
end

for p in \
    "$HOME/.local/bin" \
    "$HOME/.cargo/bin" \
    "$XDG_DATA_HOME/npm/bin" \
    /usr/local/go/bin \
    "$XDG_CONFIG_HOME/flutter/bin" \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/emulator" \
    /var/lib/flatpak/exports/bin \
    "$HOME/.local/share/flatpak/exports/bin"
    test -d $p; and fish_add_path $p
end

alias paths='printf "%s\n" $PATH'

## Mise (make tools available early)

if type -q mise
    mise activate fish | source
end

## Editors

if not set -q EDITOR
    if type -q nvim
        set -gx EDITOR nvim
    else if type -q vim
        set -gx EDITOR vim
    else
        set -gx EDITOR nano
    end
end

if not set -q VISUAL
    if type -q code
        set -gx VISUAL code
    else
        set -gx VISUAL $EDITOR
    end
end

if not set -q GIT_EDITOR
    set -gx GIT_EDITOR $EDITOR
end

if not set -q ELIXIR_EDITOR
    if type -q code
        set -gx ELIXIR_EDITOR "code --goto"
    else
        set -gx ELIXIR_EDITOR $EDITOR
    end
end

## ls aliases

if type -q eza
    alias ls='eza --group-directories-first --classify --time-style="+%Y-%m-%d %H:%M"'
    alias ll='ls --long'
    alias la='ls --long --all'
    alias lt='ls --long --time modified'
    alias lr='ls --recurse'
    alias l.='ls --long --list-dirs .*'
else
    alias ls='ls -Fh --color=auto'
    alias ll='ls -l'
    alias la='ls -lA'
    alias lt='ls -lt'
    alias lr='ls -R'
    alias l.='ls -ld .*'
end

## Git shortcuts

abbr --add ga 'git add'
abbr --add gaa 'git add --all'
abbr --add gb 'git branch'
abbr --add gba 'git branch --all'
abbr --add gc 'git commit --verbose'
abbr --add gC 'git commit --verbose --amend'
abbr --add gcn 'git commit --verbose --no-edit --amend'
abbr --add gc0 'git commit --allow-empty -m "empty commit"'
abbr --add gco 'git checkout'
abbr --add gd 'git diff'
abbr --add gdca 'git diff --cached'
abbr --add gf 'git fetch'
abbr --add glog 'git log --oneline --decorate --graph'
abbr --add gloga 'git log --oneline --decorate --graph --all'
abbr --add gp 'git push'
abbr --add gpf 'git push --force-with-lease --force-if-includes'
abbr --add gpF 'git push --force'
alias 'gc!'='git commit --verbose --amend'
alias 'gpf!'='git push --force'

## Misc aliases

alias ..='cd ../'
alias ...='cd ../../'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -vI'
alias grep='grep --color=auto'
alias rg='rg --color=auto --smart-case'
alias wget='wget --continue'
alias be='bundle exec'

## Integrations

if type -q fzf
    set -l fzf_opts \
        --reverse \
        --color=dark \
        --color=fg:-1,bg:-1 \
        --color=fg+:-1,bg+:-1 \
        --color=hl:#5fff87,hl+:#ffaf5f \
        --color=info:#af87ff \
        --color=prompt:#5fff87 \
        --color=pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7

    if set -q FZF_DEFAULT_OPTS
        # Append our defaults after existing ones so our theme takes precedence
        set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS $fzf_opts
    else
        set -gx FZF_DEFAULT_OPTS $fzf_opts
    end

    # fzf keybindings: Ctrl-T (files), Alt-C (cd), Ctrl-R (history).
    fzf --fish | source
end

if type -q direnv
    direnv hook fish | source
end

if type -q zoxide
    zoxide init fish | source
end

function y
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    command yazi $argv --cwd-file="$tmp"

    if test -f "$tmp"
        set -l newcwd (string trim (cat -- "$tmp"))
        test -n "$newcwd"; and test "$newcwd" != "$PWD"; and cd -- "$newcwd"
        rm -f -- "$tmp"
    end
end

## Utilities

if not type -q open
    function open
        nohup command xdg-open $argv >/dev/null 2>/dev/null &
    end
end

function timestamp
    date "+%Y%m%d%H%M%S"
end

abbr --add 2desk 'tee $HOME/Desktop/terminal-output-(date "+%Y%m%d%H%M%S").txt'
abbr --add codium "flatpak run com.vscodium.codium"

function hexdocs
    if test (count $argv) -ge 1
        mix hex.docs online $argv[1]
    else
        mix hex.docs online elixir
    end
end

function hexpm
    open "https://hex.pm/packages?search="(string join ' ' $argv)
end

function mkarchive
    if test (count $argv) -lt 2
        echo "usage: mkarchive <output> <files/dirs...>" >&2
        return 2
    end

    set -l out $argv[1]
    set -l files $argv[2..-1]

    switch $out
        case '*.tar'
            tar -cvf $out -- $files
        case '*.tar.gz' '*.tgz'
            tar -cvf - -- $files | gzip -c >$out
        case '*.zip'
            zip -r -X -- $out $files
        case '*'
            echo "mkarchive: unsupported extension: $out" >&2
            echo "supported: .tar .tar.gz(.tgz) .zip" >&2
            return 1
    end
end

function mkgpg
    if test (count $argv) -lt 2
        echo "usage: mkgpg <basename> <files/dirs...>" >&2
        return 2
    end

    set -l base $argv[1]
    set -l files $argv[2..-1]
    set -l tarball "$base.tar.gz"
    set -l enc "$base.tar.gz.gpg"

    tar -cvf - -- $files | gzip -c >$tarball

    if gpg --symmetric --cipher-algo AES256 --output $enc --quiet --batch $tarball
        rm -f -- $tarball
    else
        echo "gpg encryption failed (leaving plaintext: $tarball)" >&2
    end
end

function extract
    if test (count $argv) -lt 1
        echo "usage: extract <archive>" >&2
        return 2
    end

    set -l f $argv[1]

    switch $f
        case '*.tar'
            tar xvf $f
        case '*.tar.gz' '*.tgz'
            tar xvzf $f
        case '*.zip' '*.ZIP'
            unzip -- $f
        case '*.gz'
            gunzip --keep -- $f
        case '*'
            echo "extract: unsupported archive: $f" >&2
            echo "supported: .tar .tar.gz(.tgz) .zip [.gz single-file]" >&2
            return 1
    end
end

function capslock
    if not type -q setxkbmap
        echo "capslock: setxkbmap not found" >&2
        return 1
    end

    if test (count $argv) -lt 1
        echo "usage: capslock on|off" >&2
        return 2
    end

    switch (string lower -- $argv[1])
        case on
            setxkbmap -option
        case off
            setxkbmap -option ctrl:nocaps
        case '*'
            echo "usage: capslock on|off" >&2
            return 2
    end
end

## Prompt

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_use_informative_chars 1
set -g __fish_git_prompt_showcolorhints 1
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showupstream auto

set -g __fish_git_prompt_color_branch --bold magenta
set -g __fish_git_prompt_color_clean green
set -g __fish_git_prompt_color_staged yellow
set -g __fish_git_prompt_color_dirty red
set -g __fish_git_prompt_color_untracked brmagenta
set -g __fish_git_prompt_color_stash blue
set -g __fish_git_prompt_color_upstream brcyan

function fish_prompt
    set -l last_status $status
    set -l user (whoami)
    set -l host (prompt_hostname)
    set -l cwd (prompt_pwd)

    if test "$USER" = root
        set_color --bold red
    else
        set_color yellow
    end
    printf '%s' $user
    set_color normal
    printf '@'
    set_color green
    printf '%s' $host
    set_color normal
    printf ':'
    set_color --bold cyan
    printf '%s' $cwd
    set_color normal

    set -l vcs
    if functions -q fish_vcs_prompt
        set vcs (fish_vcs_prompt 2>/dev/null)
    else
        set vcs (__fish_git_prompt 2>/dev/null)
    end
    if test -n "$vcs"
        printf ' %s' $vcs
    end

    printf '\n'
    if test $last_status -eq 0
        set_color --bold green
    else
        set_color --bold red
    end
    printf '$ '
    set_color normal
end

## Message of the Day

if type -q fastfetch
    echo
    fastfetch --logo none 2>/dev/null
    echo
end

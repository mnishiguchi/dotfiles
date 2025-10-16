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
    /var/lib/flatpak/exports/bin \
    "$HOME/.local/share/flatpak/exports/bin" \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/platform-tools" \
    "$XDG_CONFIG_HOME/flutter/bin" \
    "$XDG_CONFIG_HOME/herd-lite/bin" \
    "$XDG_DATA_HOME/npm/bin" \
    /usr/local/go/bin \
    "$HOME/.asdf/shims"
    test -d $p; and fish_add_path $p
end

alias path='printf "%s\n" $PATH'

## editors

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

## asdf (0.16+)

if not set -q ASDF_DATA_DIR
    set -gx ASDF_DATA_DIR "$HOME/.asdf"
end

if test -f "$ASDF_DATA_DIR/asdf.fish"
    source "$ASDF_DATA_DIR/asdf.fish"
else if type -q asdf
    test -d "$ASDF_DATA_DIR/completions"; and for f in $ASDF_DATA_DIR/completions/*.fish
        source $f
    end
end

## fzf defaults

if type -q fzf
    set -gx FZF_DEFAULT_OPTS '
  --reverse
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  '

    if type -q rg
        set -l _fzf_base "rg --files --hidden --max-filesize 1M --glob !.git"
        if test -f "$XDG_CONFIG_HOME/git/global-excludes"
            set -gx FZF_DEFAULT_COMMAND \
                "$_fzf_base --ignore-file $XDG_CONFIG_HOME/git/global-excludes"
        else
            set -gx FZF_DEFAULT_COMMAND "$_fzf_base"
        end
    else if type -q fd
        set -gx FZF_DEFAULT_COMMAND "fd --hidden --follow --exclude .git"
    else
        set -gx FZF_DEFAULT_COMMAND "find . -type f ! -path '*/.git/*'"
    end
end

## keybindings

# Ctrl-R: fzf history if available; otherwise builtin reverse search
if type -q fzf
    function _kb_fzf_history
        set -l sel (history --reverse | uniq | fzf)
        if test -n "$sel"
            commandline --replace -- $sel
            commandline -f repaint
        end
    end
    bind -e \cr
    bind \cr _kb_fzf_history
else
    bind -e \cr
    bind \cr backward-isearch
end

## ls aliases

if type -q eza
    alias ls='eza --group-directories-first --classify --time-style="+%Y-%m-%d %H:%M"'
    alias ll='ls --long'
    alias la='ls --long --all'
    alias lt='ls --long --time modified'
    alias lr='ls --recurse'
    alias l.='ls --long --list-dirs .*'
else if type -q exa
    alias ls='exa --classify'
    alias ll='exa --long --classify'
    alias la='exa --long --all --classify'
    alias lt='exa --long --classify --sort=time'
    alias lr='exa --recurse --classify'
    alias l.='exa --long --classify --all --group-directories-first --ignore-glob="*/*"'
else
    alias ls='ls -Fh --color=auto'
    alias ll='ls -l'
    alias la='ls -lA'
    alias lt='ls -lt'
    alias lr='ls -R'
    alias l.='ls -ld .*'
end

## misc aliases

alias ..='cd ../'
alias ...='cd ../../'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -vI'
alias grep='grep --color=always'
alias wget='wget --continue'
alias be='bundle exec'

## git shortcuts

alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch --all'
alias gc='git commit --verbose'
alias 'gc!'='git commit --verbose --amend'
alias 'gcn!'='git commit --verbose --no-edit --amend'
alias gc0='git commit --allow-empty -m "empty commit"'
alias gco='git checkout'
alias gd='git diff'
alias gdca='git diff --cached'
alias gf='git fetch'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias gp='git push'
alias gpf='git push --force-with-lease --force-if-includes'
alias 'gpf!'='git push --force'

## archive helpers

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

## caps lock helpers

function capslock
    if test (uname) = Darwin
        echo "capslock() does not support 'Darwin'"
        return 1
    end

    if test (count $argv) -eq 0
        setxkbmap -option
    else
        setxkbmap -option ctrl:nocaps
    end

    setxkbmap -print -verbose 10
end

alias caps='capslock'
alias nocaps='capslock off'

## integrations

if type -q direnv
    direnv hook fish | source
end

if type -q zoxide
    zoxide init fish | source
end

function y --wraps yazi
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    command yazi $argv --cwd-file="$tmp"

    if test -f "$tmp"
        set -l newcwd (string trim (cat -- "$tmp"))
        test -n "$newcwd"; and test "$newcwd" != "$PWD"; and cd -- "$newcwd"
        rm -f -- "$tmp"
    end
end

## utilities

if not type -q open
    function open
        nohup command xdg-open $argv >/dev/null 2>/dev/null &
    end
end

function timestamp
    date "+%Y%m%d%H%M%S"
end

abbr --add 2desk 'tee $HOME/Desktop/terminal-output-(date "+%Y%m%d%H%M%S").txt'

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

function findtext
    if test (count $argv) -lt 1
        echo "usage: findtext <pattern> [path]" >&2
        return 2
    end

    set -l pattern $argv[1]
    set -l root "."

    if test (count $argv) -ge 2
        set root $argv[2]
    end

    if type -q rg
        rg \
            --smart-case \
            --line-number \
            --with-filename \
            --color=always \
            -- "$pattern" "$root" \
            | less -R
        set -l exit_code $pipestatus[1]
    else
        grep \
            --recursive \
            --ignore-case \
            --line-number \
            --with-filename \
            --color=always \
            -- "$pattern" "$root" \
            | less -R
        set -l exit_code $pipestatus[1]
    end

    if test $exit_code -ne 0
        echo "No matches for '$pattern' in '$root'." >&2
    end

    return $exit_code
end

## Prompt

function fish_prompt
    # capture previous command's exit code first
    set -l last_status $status

    # first line: user@host:cwd
    set_color yellow
    printf '%s' $USER
    set_color normal
    printf '@'
    set_color green
    printf '%s' (hostname -s)
    set_color normal
    printf ':'
    set_color -o cyan
    printf '%s' (prompt_pwd)
    set_color normal

    # git segment
    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        # fallback for detached HEAD: show tag or short SHA
        set branch (command git describe --tags --always 2>/dev/null)
    end

    if test -n "$branch"
        set -l ahead 0
        set -l behind 0

        # ahead/behind vs upstream (TAB-separated counts)
        set -l counts (command git rev-list --left-right --count HEAD...@'{u}' 2>/dev/null)
        if test $status -eq 0
            set -l parts (string split \t -- $counts)
            if test (count $parts) -ge 2
                set ahead $parts[1]
                set behind $parts[2]
            end
        end

        # dirty count (staged/unstaged/untracked)
        set -l dirty_lines (command git status --porcelain --untracked-files=normal 2>/dev/null)
        set -l dirty_count (count $dirty_lines)

        printf ' '
        set_color -o magenta
        printf ' %s' $branch
        set_color normal

        set -l arrows ''
        if test "$ahead" -gt 0
            set arrows "$arrows⇡"
        end
        if test "$behind" -gt 0
            set arrows "$arrows⇣"
        end
        if test -n "$arrows"
            printf ' [%s]' $arrows
        end

        if test "$dirty_count" -gt 0
            printf ' [±%d]' $dirty_count
        end
    end

    # second line: status-colored prompt char
    printf '\n'
    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    printf '$ '
    set_color normal
end

## optional banner

if type -q fastfetch
    echo
    fastfetch --logo none 2>/dev/null
    echo
end

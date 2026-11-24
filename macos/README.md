# macOS configuration

Use [installers](https://github.com/mnishiguchi/installers) to install Homebrew
packages, fonts, Mise tools and configure the login shell. This repository
only manages configuration. There is no second Brewfile to maintain.

From the dotfiles checkout (also works on Linux):

```sh
./install.sh --check --force  # preview only
./install.sh --force          # backup conflicts and link
./install.sh --verify         # 0 ready, 3 drift, 1 error
```

Use Alacritty 0.14 or newer (`terminal.shell`). The portable launcher finds
Homebrew tools even from a GUI app, attaches to tmux `main`, or opens the
login shell if tmux is missing or cannot execute. Configure Fish using
`installers/macos-bootstrap.sh --only shell`. Log out and back in. For a
running tmux server, check `tmux show-options -gv default-shell`; change it
without terminating existing panes using `tmux set-option -g default-shell`
with the absolute Fish path.

Run `dotfiles-doctor` in a terminal after setup. It checks link drift and
executes core tools. Open Alacritty from the Dock and manually verify tmux,
Fish, clipboard, Neovim UI and font rendering. If the terminal fails, use
Apple Terminal and launch Alacritty with `-vv -e /bin/zsh -l`.

Shell startup probes eza, fzf and zoxide before enabling integrations. If
eza is broken or missing, use the native ls aliases; if fzf is unavailable,
`z` still works and `zi` explains the missing requirement. Start a new shell
after repairing tools. Use `/bin/ls` for immediate recovery in an existing
shell. Do not force-link unrelated shared libraries to fix runtime errors.

Rofi and the Debian kernel helper are Linux-only. Clipboard helpers delegate
to native macOS commands. No OS upgrades or package removal are performed.

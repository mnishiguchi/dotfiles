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
executes core tools. Use `dotfiles-doctor --verbose` to show managed links
and executable paths even when checks pass. Open Alacritty from the Dock
and manually verify tmux, Fish, clipboard, Neovim UI and font rendering. If the terminal fails, use
Apple Terminal and launch Alacritty with `-vv -e /bin/zsh -l`.

## Launch Alacritty with Command + Return

Use the built-in macOS Shortcuts app to reproduce the Linux `Super + Enter`
terminal launcher. No additional automation software is required.

| Setting | Value |
| --- | --- |
| Shortcut name | `Alacritty` |
| Action | Open App: Alacritty |
| Keyboard shortcut | Command + Return |
| Input | Continue if there is no input |

On a new Mac:

1. Open Shortcuts and look for an existing `Alacritty` shortcut. Reuse it if
   present. Otherwise, create a shortcut named `Alacritty` and add the Open
   App action, selecting Alacritty. If a saved `Alacritty.shortcut` export
   exists in `macos/shortcuts/`, open it instead and review the import.
2. Open the shortcut editor, click the information button and select Details.
   Click Add Keyboard Shortcut and press Command + Return. Enable Use as
   Quick Action and Services Menu if needed; allow the shortcut to continue
   without input.
3. Close the editor and press Command + Return from Finder or another app.
   Verify that Alacritty opens or comes to the foreground and that the usual
   terminal launcher, tmux and Fish behavior works.

The action can also be tested independently of the keyboard binding:

```sh
shortcuts run Alacritty
```

If a foreground app intercepts the key combination, review its shortcuts
and System Settings > Keyboard > Keyboard Shortcuts > Services.

To preserve a working workflow, use Shortcuts > File > Export, select Anyone
and save `Alacritty.shortcut` under `macos/shortcuts/`. Review the workflow
before committing it to a public repository. On export, Apple receives a
copy for validation. Verify and restore the key binding separately after
import; do not assume it travels with the exported workflow.

This GUI preference is intentionally not applied by `install.sh` or checked
by `dotfiles-doctor`. Do not replace the user's Services preferences or edit
Shortcuts' internal database to automate a single key binding.

See Apple's [shortcut keyboard setup](https://support.apple.com/guide/shortcuts-mac/apd163eb9f95/mac)
and [shortcut export guide](https://support.apple.com/guide/shortcuts-mac/apdf01f8c054/mac).

Shell startup probes eza, fzf and zoxide before enabling integrations. If
eza is broken or missing, use the native ls aliases; if fzf is unavailable,
`z` still works and `zi` explains the missing requirement. Start a new shell
after repairing tools. Use `/bin/ls` for immediate recovery in an existing
shell. Do not force-link unrelated shared libraries to fix runtime errors.

Rofi and the Debian kernel helper are Linux-only. Clipboard helpers delegate
to native macOS commands. No OS upgrades or package removal are performed.

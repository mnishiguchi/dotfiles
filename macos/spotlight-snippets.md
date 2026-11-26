# Spotlight snippet applications

macOS uses the built-in Spotlight launcher for ordinary applications and
shared snippets. The dotfiles repository contains the snippet definitions,
execution engine, and a macOS-only synchronizer that generates one small
AppleScript application per snippet.

## Install and synchronize

```sh
./install.sh --only bin
dotfiles-macos-snippets-sync --check
dotfiles-macos-snippets-sync
dotfiles-macos-snippets-sync --verify
```

Press Cmd+Space and search for a generated result such as `Snippet cmd uuid`.
Press Enter to run it. The app invokes `dotfiles-snippets --copy NAME` and
copies the current output to the clipboard; paste with Cmd+V. The app stores
the snippet name, not the snippet value or generated output. Clipboard-only
operation does not require Accessibility permission.

## Maintenance

The source of truth is `snippets/snippets.txt`, linked to
`${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/snippets.txt`. After adding,
renaming, or removing a snippet, run `dotfiles-macos-snippets-sync` again.
Changing only a snippet value does not require regeneration.

Generated applications live in `~/Applications/Dotfiles Snippets/` and are
not committed to Git. `--check` previews changes; `--verify` exits 0 when
current, 3 for drift, and 1 for errors. `--clean` asks for confirmation and
archives only the verified managed directory. Previous generations are kept
under `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/snippet-apps/`; review
and remove those archives manually when no longer needed. The original proof
of concept `~/Applications/Snippet UUID.app` is outside the managed directory
and can be moved to Trash if it duplicates the generated result.

Spotlight may take time to index new applications. Check that Spotlight
search is enabled in System Settings and that `~/Applications` is not excluded
from Spotlight Privacy settings. Dotfiles do not modify Spotlight shortcuts
or indexing preferences. Keep Cmd+Space enabled for Spotlight.

## Retiring dmenu-mac

After confirming the generated apps appear and launch from Spotlight, remove
the old Homebrew cask explicitly:

```sh
brew uninstall --cask dmenu-mac
```

The installers Brewfile no longer includes dmenu-mac. Homebrew Bundle does not
automatically uninstall a cask merely because it is absent from a Brewfile.
The dotfiles installer also backs up old managed symlinks for the former
macOS menu and synchronizer; it leaves unrelated files and custom commands
untouched.

Linux continues to use the existing Rofi combi menu and theme.

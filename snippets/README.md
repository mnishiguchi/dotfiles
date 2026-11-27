# Shared snippets and native launchers

The snippet engine and definitions are shared across Linux and macOS. Linux
uses Rofi for interactive selection; macOS uses native Spotlight to launch one
generated application per snippet.

## Install and verify

From the checkout:

```sh
./install.sh --only bin,rofi --check
./install.sh --only bin,rofi
./install.sh --only bin,rofi --verify
dotfiles-snippets --check
dotfiles-doctor
```

Rofi is skipped on macOS. Both platforms link `snippets/snippets.txt` into
`${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/snippets.txt`. The old tracked
`rofi/config/snippets.txt` remains a compatibility symlink to the shared file.
Do not force-install over a private, independently maintained snippet file.
Review and merge it first, or use `DOTFILES_SNIPPETS_FILE=/path/to/trusted.txt`.
If both shared and legacy config files exist but differ, the engine refuses to
choose one automatically. A legacy-only file is still supported.

## Shared commands

```sh
dotfiles-snippets --copy 'cmd uuid'
dotfiles-snippets --paste 'cmd uuid' # opt-in automatic paste
dotfiles-snippets --list             # list names without evaluating commands
dotfiles-snippets --check            # validate format and unique names
dotfiles-snippets --print 'cmd timestamp/iso8601'
dotfiles-snippets --raw 'cmd uuid'   # literal command, without execution
```

Each non-comment line is `name!value`. Only the first `!` is the delimiter.
Names beginning with `cmd ` run the value with Bash and copy their stdout
(with trailing newlines removed). Other values are literal text. Blank lines
and comments are ignored; duplicate and reserved names fail validation. The
tracked file is executable code: review it before trusting it. Do not store
real passwords or private tokens in a public repository. Password snippets
generate values locally; they do not store passwords. Clipboard history tools
may retain copied values.

A failed command does not replace the clipboard. A cancelled menu returns
success without touching the clipboard. Names are matched exactly after
selection; arbitrary text from a menu is never executed as a command. The file
is read into memory before selecting a snippet. Use text, not binary output.
A command snippet runs in the invoking process's directory.

The built-in hash commands use OpenSSL, and dates use options shared by BSD
and GNU date. `uuidgen` and `openssl` are needed for their respective snippets.
GUI invocation adds `~/.local/bin` and the usual Homebrew paths.

## macOS: Spotlight snippet applications

macOS uses Spotlight for both ordinary applications and snippets. The
synchronizer creates a small AppleScript application for each shared snippet;
selecting one runs that named snippet and copies its current output. No second
menu, terminal window, Accessibility permission, or third-party launcher is
needed for clipboard-only operation.

```sh
./install.sh --only bin
dotfiles-macos-snippets-sync --check
dotfiles-macos-snippets-sync
dotfiles-macos-snippets-sync --verify
```

Press Cmd+Space and search for a generated result such as `Snippet cmd uuid`.
Press Enter to run it, then Cmd+V to paste the copied result. The generated app
stores the snippet name, not its value or output.

Generated bundles live in `~/Applications/Dotfiles Snippets/` and are not
committed to Git. A name such as `cmd date/today` becomes
`Snippet cmd date - today.app`. Names that collide after conversion are
rejected. The installer links the synchronizer but does not generate apps
automatically; `dotfiles-doctor` checks synchronization without compiling or
launching anything.

After adding, renaming, or removing a snippet, run the synchronizer again.
Changing only a snippet value needs no regeneration. `--check` previews
changes; `--verify` exits 3 for drift or 1 for errors. Unchanged apps are left
alone. When the set changes, the new set is compiled before the old set is
archived under `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/snippet-apps/`.
The script refuses unowned directories, unregistered items, and modified
compiled payloads or plists. `--clean` requires confirmation and archives only
the verified managed set. Review and delete retired archives manually when no
longer needed. The proof-of-concept `~/Applications/Snippet UUID.app` is
outside the managed directory; move it to Trash manually if it duplicates the
generated result. Spotlight may need time to index newly generated apps.

The synchronizer uses the shared XDG configuration, not a temporary
`DOTFILES_SNIPPETS_FILE` override. No Spotlight shortcuts, indexing settings,
or unrelated application bundles are changed by dotfiles.

On macOS, `dotfiles-snippets` requires an explicit snippet name when copying
or pasting. Its no-argument interactive selector is Linux/Rofi-only. Use the
individual generated apps from Spotlight, or pass `NAME` to the command.

For optional automatic paste, a Shortcuts action can run
`"$HOME/.local/bin/dotfiles-snippets" --paste 'cmd uuid'`. macOS System Events
may require Automation and Accessibility permission for the invoking app.
The script records the frontmost app before running the snippet and waits
briefly for that same PID to regain focus. It does not force focus or paste into
a different app. If capture, focus, or permissions fail, the value remains on
the clipboard and the script reports failure. A PID check cannot guarantee
that the original text field is still focused; use copy mode in sensitive
contexts. No Enter is sent and the clipboard is not restored.

## KDE Wayland: native frontend under evaluation

KRunner handles application launch; no Rofi or CopyQ dependency is required
for named snippet copying. Test the existing engine directly:

```sh
dotfiles-snippets --check
dotfiles-snippets --copy 'cmd uuid'
```

Paste into a disposable text editor using its usual shortcut. A future KDE
frontend may expose the names as user desktop entries searchable in KRunner,
similar to the Spotlight implementation. This is not yet implemented or
verified. Keep command execution and shared snippet data independent of the
frontend; do not simulate typing on Wayland.

## Linux: Rofi integration

The native `rofi-combi-menu` and `rofi-snippets-modi` commands remain available;
existing bindings and theme do not need to change. `dotfiles-snippets` without
a name opens the Rofi selector. The Rofi module uses the shared parser. Its
selection action still types using `xdotool` (X11). For `ROFI_RETV=2`, it copies
the evaluated value rather than raw command text. Actual Shift+Enter handling
depends on Rofi's key configuration. Use `dotfiles-snippets --raw NAME` for
literal command text.

Optional `--paste` uses Ctrl+V on X11 with `xdotool` only if the original window
is still focused. It is not suitable for terminals that use Ctrl+Shift+V. On
Wayland, automatic paste is not attempted; copy mode works with a supported
clipboard provider.

`dotfiles-menu` and `dotfiles-launcher` are Linux/Rofi interfaces. On macOS,
Spotlight is the application and snippet launcher.

## Tests

```sh
bash tests/snippets_test.sh
bash tests/macos_snippet_apps_test.sh
```

Tests use mocked menus, clipboard tools, application compilation, and paste
commands. They do not touch a real GUI or clipboard. On each real desktop,
verify snippet execution and clipboard output; test optional paste in a
disposable text editor.

# macOS setup

Use the same Fish, tmux, Alacritty, Neovim and Mise configuration as Linux.
The dotfiles installer only links configuration; it never installs packages,
changes the login shell, or upgrades macOS automatically.

## 1. Prerequisites

Back up important files and check the OS with `sw_vers`. Homebrew's supported
Apple Silicon versions currently start at macOS 15 (Sequoia); Sonoma 14 is
Tier 3 as of November 2026. Some formulae and casks may fail there. See
[Homebrew installation](https://docs.brew.sh/Installation) and
[support tiers](https://docs.brew.sh/Support-Tiers). If also installing Asahi
Linux, check its firmware/macOS requirements before choosing an OS update.

Check the Xcode Command Line Tools with `xcode-select -p`. If absent:

```sh
xcode-select --install
```

Wait for the system installation to complete. In the native macOS Terminal
(zsh or Bash), check whether Homebrew already exists:

```sh
uname -m
command -v brew
ls -l /opt/homebrew/bin/brew /usr/local/bin/brew
```

On Apple Silicon `uname -m` should be `arm64`. Use a native Terminal rather
than a Rosetta session. If Homebrew is not installed, follow the official
instructions at <https://brew.sh/>. The standard installer command is:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the installer's printed shell setup instructions. For Apple Silicon:

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
brew --version
```

Intel Homebrew normally uses `/usr/local/bin/brew` instead.
For the default zsh, persist the matching `brew shellenv` line in
`~/.zprofile` once (do not overwrite existing contents). Fish and Bash
configuration in this repository initialize standard Homebrew prefixes.

## 2. Install shared development tools

From the root of the dotfiles checkout:

```sh
brew bundle install --no-upgrade --file=macos/Brewfile
brew bundle check --no-upgrade --file=macos/Brewfile
```

The Brewfile is a package manifest, not a lockfile. This command can still
install or update dependencies. It does not install language runtimes;
use Mise per project as on Linux. Do not run `brew bundle cleanup` as part
of setup. If a tool cannot be installed on the current OS, start with
`brew install fish tmux` and install the other tools after resolving the OS
or package-specific issue. Existing Alacritty installations can be reused.
The Homebrew Alacritty cask is disabled as of November 2026, so it is not in
the Brewfile. If needed, see the official [Alacritty releases](https://github.com/alacritty/alacritty/releases)
for the macOS build. Follow normal macOS security checks; do not disable
Gatekeeper globally.

The Neovim config uses `vim.pack` and requires a sufficiently recent Neovim
(0.12 or newer). Check `nvim --version`; use a recent build via Mise if the
Homebrew version is too old. Git-changed uses modern Git, Bash and GNU sort
(provided by `coreutils` on macOS).

## 3. Install dotfiles

```sh
./install.sh --check --force
./install.sh --force
```

Existing conflicting files are backed up under `~/.dotfiles-backup/`.
The installer skips Rofi and the Debian kernel helper on macOS. With `--force`,
it backs up an old kernel-helper link only if it points to this checkout.
Other existing files are not automatically removed. The clipboard wrappers
forward all arguments to native `/usr/bin/pbcopy` and `/usr/bin/pbpaste`.

## 4. Use Fish as the login shell (optional, recommended for parity)

```sh
fish_path="$(command -v fish)"
printf '%s\n' "$fish_path"
```

Ensure the printed value is the absolute path to the installed Fish (normally
`/opt/homebrew/bin/fish` on Apple Silicon). Then, from zsh or Bash:

```sh
if ! grep -Fxq "$fish_path" /etc/shells; then
  printf '%s\n' "$fish_path" | sudo tee -a /etc/shells
fi
chsh -s "$fish_path"
```

Log out and back in before testing the login shell. If a tmux server already
exists, existing panes and the server's default shell may still be the old
shell. Check `tmux show-options -gv default-shell`; open a fresh session after
saving any work rather than killing a server with active panes.

To switch back: `chsh -s /bin/zsh`. If using Bash as a login shell instead,
ensure `~/.bash_profile` sources `~/.bashrc`; this installer deliberately
leaves login profiles unmanaged.

## 5. Verify

```sh
command -v brew fish tmux nvim mise eza fzf rg lazygit
nvim --version
fish --version
tmux -V
```

Open Alacritty. The shared launcher locates tmux through PATH (including
Homebrew for GUI launches), attaches to `main`, or opens a login shell if
tmux is absent. It also avoids nested tmux sessions. The terminal uses
native copy/paste shortcuts (Command+C/V on macOS, Ctrl+Shift+C/V on Linux).

If Alacritty does not start, run from macOS Terminal:

```sh
/Applications/Alacritty.app/Contents/MacOS/alacritty -vv -e /bin/zsh -l
```

For a non-sensitive clipboard check, run:

```sh
printf 'clipboard test' | pbcopy
pbpaste
```

This replaces the current clipboard content. Rofi, Flatpak aliases and X11
keyboard remapping remain Linux-specific; on macOS, use System Settings >
Keyboard > Keyboard Shortcuts > Modifier Keys for Caps Lock remapping.

## Tests

Run `/bin/bash tests/platform_test.sh` to exercise isolated temporary homes,
Linux/Darwin installer branches and stubbed tmux/lsof. The CI matrix also
checks Fish syntax on both platforms. Real GUI, Homebrew package installation,
clipboard behavior and login-shell changes require a Mac for validation.

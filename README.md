# dotfiles

My collection of dotfiles.

## Get started

```bash
git clone https://github.com/mnishiguchi/dotfiles.git my_dotfiles
```

```bash
cd my_dotfiles
```

```bash
./install.sh --help
```

```text
Install all dotfiles defined in this project.

Usage:
  install.sh [options]

Options:
  --debug            Enable shell tracing
  --force, -f        Overwrite destination files
  --check            Dry run (show what would change)
  --only <sections>  Comma-separated list: shell,bin,rofi,nvim,git,other
  --help, -h         Show help
```

## Commands

The `bin` section installs these commands into `~/.local/bin`:

| Command | Description | Dependency |
| --- | --- | --- |
| `age-file` | Encrypt or decrypt a file with an `age` passphrase | `age` |
| `bashpaste` | Review and run a Bash snippet from the clipboard | `bash`, `pbpaste` |
| `extract` | Extract a supported archive into the current directory | `tar`, `unzip`, or `gzip` |
| `git-backup` | Snapshot a Git working tree to a compressed archive | `git`, GNU `tar` |
| `git-changed` | List existing files changed from a Git base branch | `git` |
| `hexdocs` | Open Hex documentation for an Elixir package | `mix`, Hex |
| `hexpm` | Search for packages on Hex.pm | `python3`, `xdg-open`, `gio`, or macOS `open` |
| `debian-kernel-prune` | Inspect and safely purge old Debian/LMDE kernels | `bash`, `dpkg-query`, `apt-get`, `sudo` (for apply) |
| `mp4-to-gif` | Convert a video to an optimized animated GIF | `ffmpeg` |
| `mkarchive` | Create a tarball or ZIP archive | `tar`, `gzip`, or `zip` |
| `mkgpg` | Create a GPG-encrypted compressed archive | `tar`, `gzip`, `gpg` |
| `notes` | Initialize or list zk notes in Neovim | `nvim`, `zk`, `zk-nvim` |
| `onepassword-backup` | Encrypt, verify, and restore 1Password 1PUX backups | `age` |
| `pbcopy` | Copy standard input to the Wayland or X11 clipboard | `wl-clipboard`, `xclip`, or `xsel` |
| `pbpaste` | Write the Wayland or X11 clipboard to standard output | `wl-clipboard`, `xclip`, or `xsel` |
| `port-who` | Show the process listening on a TCP or UDP port | `ss` |
| `retry` | Retry a command with a configurable delay | `bash` |

Install only the commands with:

```bash
./install.sh --only bin
```

## Conservative Debian/LMDE kernel cleanup

On Debian/LMDE systems with versioned `linux-image` packages, use
`debian-kernel-prune` to inspect old kernels without changing anything:

```bash
debian-kernel-prune
debian-kernel-prune --dry-run
debian-kernel-prune --apply
```

The default command is **inspection-only**. `--dry-run` checks the proposed
APT removal plan. `--apply` requires a terminal, an explicit `PURGE` response,
and the usual APT confirmation. **Never run it unattended.**

The script keeps the running kernel, the newest installed kernel, and at
least the three newest installed kernels. To protect another known-good boot
version, pass `--keep RELEASE` (repeat as needed). For example:

```bash
debian-kernel-prune --dry-run --keep 6.12.115+deb13.1-amd64
```

It refuses APT plans that remove unrelated packages, does not call
`autoremove`, and never deletes `/boot` files directly. It cannot determine
which kernel you have personally verified works; confirm you have a known-good
fallback before applying changes. A package retained by this script could
still be removed by a separate later `apt autoremove`, so review those plans
independently.

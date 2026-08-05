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
| `git-changed` | List existing files changed from a Git base branch | `git` |
| `hexdocs` | Open Hex documentation for an Elixir package | `mix`, Hex |
| `hexpm` | Search for packages on Hex.pm | `python3`, `xdg-open`, `gio`, or macOS `open` |
| `mp4-to-gif` | Convert a video to an optimized animated GIF | `ffmpeg` |
| `mkarchive` | Create a tarball or ZIP archive | `tar`, `gzip`, or `zip` |
| `mkgpg` | Create a GPG-encrypted compressed archive | `tar`, `gzip`, `gpg` |
| `onepassword-backup` | Encrypt, verify, and restore 1Password 1PUX backups | `age` |
| `pbcopy` | Copy standard input to the Wayland or X11 clipboard | `wl-clipboard`, `xclip`, or `xsel` |
| `pbpaste` | Write the Wayland or X11 clipboard to standard output | `wl-clipboard`, `xclip`, or `xsel` |
| `port-who` | Show the process listening on a TCP or UDP port | `ss` |
| `retry` | Retry a command with a configurable delay | `bash` |

Install only the commands with:

```bash
./install.sh --only bin
```

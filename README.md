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
| `bashpaste` | Review and run a Bash snippet from the clipboard | `bash`, `pbpaste` |
| `extract` | Extract a supported archive into the current directory | `tar`, `unzip`, or `gzip` |
| `mp4-to-gif` | Convert a video to an optimized animated GIF | `ffmpeg` |
| `mkarchive` | Create a tarball or ZIP archive | `tar`, `gzip`, or `zip` |
| `mkgpg` | Create a GPG-encrypted compressed archive | `tar`, `gzip`, `gpg` |
| `pbcopy` | Copy standard input to the Wayland or X11 clipboard | `wl-clipboard`, `xclip`, or `xsel` |
| `pbpaste` | Write the Wayland or X11 clipboard to standard output | `wl-clipboard`, `xclip`, or `xsel` |

Install only the commands with:

```bash
./install.sh --only bin
```

# dotfiles

My collection of dotfiles for Linux and macOS.

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
  --verify           Dry run; exit 3 for drift, 1 for errors, 0 when ready
  --only <sections>  Comma-separated list: shell,bin,rofi,nvim,git,other
  --help, -h         Show help
```

## macOS

See [macOS setup](macos/README.md) for Homebrew, the shared CLI toolchain,
Alacritty, Fish and tmux. Package installation and dotfile linking are separate.
On Linux, continue using the distribution package manager.

## Alacritty local overrides

The installer links `alacritty.toml` and `base.toml` into
`${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/`. The shared base retains the
10 pt default. Alacritty loads an optional `local.toml` from the same directory
last, so machine-specific settings take precedence. Keep the local file outside
this checkout; the installer never creates, replaces or removes it.

For example, create or edit `~/.config/alacritty/local.toml` (adjust the path
if using a custom XDG config directory):

```toml
[font]
size = 14.0
```

Run `./install.sh --only other` to install the shared config links after
updating this repository. Restart Alacritty to verify the resulting font size.
If no override is needed, leave `local.toml` absent. See the
[Alacritty configuration reference](https://alacritty.org/config-alacritty.html).

## Commands

The `bin` section installs these commands into `~/.local/bin`:

| Command | Description | Dependency |
| --- | --- | --- |
| `dotfiles-doctor` | Check managed links and terminal tool health | `bash` |
| `age-file` | Encrypt or decrypt a file with an `age` passphrase | `age` |
| `bashpaste` | Review and run a Bash snippet from the clipboard | `bash`, `pbpaste` |
| `extract` | Extract a supported archive into the current directory | `tar`, `unzip`, or `gzip` |
| `git-backup` | Snapshot a Git working tree to a compressed archive | `git`, GNU `tar` |
| `git-changed` | List existing files changed from a Git base branch | `git` |
| `hexdocs` | Open Hex documentation for an Elixir package | `mix`, Hex |
| `hexpm` | Search for packages on Hex.pm | `python3`, `xdg-open`, `gio`, or macOS `open` |
| `debian-kernel-prune` | Inspect and safely purge old Debian/LMDE kernels | `bash`, `dpkg-query`, `apt-get`, `sudo` (for apply) |
| `mp4-to-gif` | Convert a video to an optimized animated GIF | `ffmpeg` |
| `video-share` | Make a smaller MP4 and normalize audible audio for sharing | `ffmpeg`, `ffprobe` |
| `mkarchive` | Create a tarball or ZIP archive | `tar`, `gzip`, or `zip` |
| `mkgpg` | Create a GPG-encrypted compressed archive | `tar`, `gzip`, `gpg` |
| `notes` | Initialize or list zk notes in Neovim | `nvim`, `zk`, `zk-nvim` |
| `onepassword-backup` | Encrypt, verify, and restore 1Password 1PUX backups | `age` |
| `pbcopy` | Copy standard input to the system clipboard | Native macOS or `wl-clipboard`, `xclip`, or `xsel` |
| `pbpaste` | Write the system clipboard to standard output | Native macOS or `wl-clipboard`, `xclip`, or `xsel` |
| `port-who` | Show the process listening on a TCP or UDP port | `ss` (Linux), `lsof` (macOS) |
| `retry` | Retry a command with a configurable delay | `bash` |

Install only the commands with:

```bash
./install.sh --only bin
```

## Share-friendly video conversion

Use `video-share` to compress a video into an MP4 suitable for sending online:

```bash
video-share recording.mov
# -> recording-share.mp4
video-share --max-size 1920x1080 --crf 25 recording.mov
video-share -f recording.mov custom-share.mp4
```

Defaults: up to **1280x720** (without upscaling), H.264 CRF 27, and AAC
96 kb/s. When the audio contains meaningful signal, it is normalized toward
**-16 LUFS**, with a -1.5 dBTP true-peak ceiling. Missing or essentially
silent audio is not amplified. Audio detection uses an approximate -55 dBFS
peak threshold; very faint recordings below that threshold are treated as
near-silent rather than having their background noise boosted.

The original stays untouched. An existing output requires `--force`, and the
script never overwrites its input. If encoding produces a file that is not
smaller, no output is saved; increase `--crf` or reduce `--max-size`.
Output contains the first video and first audio stream; subtitles, additional
tracks, chapters, and metadata are omitted for simple sharing. You need
`ffmpeg` built with `libx264` and `loudnorm`, plus `ffprobe`.

## Diagnostics

Run `dotfiles-doctor` after setup or an OS upgrade. It reports required tool failures
and advisory warnings without installing software or changing configuration.
Successful checks are concise by default; failure details are shown automatically.

```bash
dotfiles-doctor
dotfiles-doctor --verbose  # Show all managed links and executable paths.
```

If managed links differ, preview changes with `./install.sh --check --force`
from the dotfiles checkout, then run `./install.sh`. Use `--force` only after
reviewing any existing-file conflicts; replacements are backed up.

The doctor exits 0 when required checks pass (even with advisory warnings),
1 when a required check fails, and 2 for invalid usage. Use
`./install.sh --verify` for machine-readable link drift checks (0: ready,
3: drift, 1: error).

## Tests

Run `bash tests/platform_test.sh` for cross-platform installer and terminal
smoke tests and `bash tests/doctor_test.sh` for diagnostic output and exit
status regressions. Run the other scripts in `tests/` on Linux with their
respective prerequisites.

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

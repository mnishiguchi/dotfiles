#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "$0")/.." && pwd -P)
video_share=$project_dir/bin/video-share
for command in ffmpeg ffprobe awk; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'video_share_test: skipping (missing %s)\n' "$command"
    exit 0
  fi
done

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
fail() {
  printf 'video_share_test: %s\n' "$*" >&2
  exit 1
}
assert_fails() {
  local expected=$1 actual status
  shift
  set +e
  actual=$("$@" 2>&1 </dev/null)
  status=$?
  set -e
  (( status != 0 )) || fail "unexpected success: $*"
  [[ $actual == *"$expected"* ]] || fail "expected '$expected' in: $actual"
}

# Synthetic videos include moving pixels to make size reduction measurable.
ffmpeg -hide_banner -loglevel error -f lavfi \
  -i 'testsrc2=size=960x540:rate=24:duration=2' \
  -f lavfi -i 'sine=frequency=440:sample_rate=48000:duration=2' \
  -filter:a 'volume=0.03' -c:v libx264 -preset ultrafast -crf 14 \
  -c:a aac -shortest "$tmp/quiet clip.mp4"
ffmpeg -hide_banner -loglevel error -f lavfi \
  -i 'testsrc2=size=960x540:rate=24:duration=1' \
  -c:v libx264 -preset ultrafast -crf 14 -an "$tmp/no-audio.mp4"
ffmpeg -hide_banner -loglevel error -f lavfi \
  -i 'testsrc2=size=960x540:rate=24:duration=1' \
  -f lavfi -i 'anullsrc=channel_layout=mono:sample_rate=48000' \
  -t 1 -c:v libx264 -preset ultrafast -crf 14 \
  -c:a aac "$tmp/silent.mp4"
ffmpeg -hide_banner -loglevel error -f lavfi \
  -i 'sine=frequency=440:duration=1' -vn -c:a aac "$tmp/audio-only.m4a"
ffmpeg -hide_banner -loglevel error -f lavfi \
  -i 'color=c=black:s=320x240:r=10:d=1' -an \
  -c:v libx264 -preset veryslow -crf 35 "$tmp/tiny.mp4"

# Helpful failures, never altering the input or overwriting an output.
assert_fails 'unknown option' "$video_share" --bogus
assert_fails '--max-size must be' "$video_share" --max-size broken "$tmp/quiet clip.mp4"
assert_fails '--crf must be' "$video_share" --crf 50 "$tmp/quiet clip.mp4"
assert_fails 'input and output refer to the same file' \
  "$video_share" --force "$tmp/quiet clip.mp4" "$tmp/quiet clip.mp4"
assert_fails 'input has no video stream' "$video_share" "$tmp/audio-only.m4a"
assert_fails 'compressed file was not smaller' "$video_share" "$tmp/tiny.mp4"
[[ ! -e "$tmp/tiny-share.mp4" ]] || fail 'oversized output was saved'

output=$("$video_share" --max-size 640x360 "$tmp/quiet clip.mp4")
[[ $output == *'Audio: normalizing'* ]] || fail "audio normalization not selected: $output"
[[ -f "$tmp/quiet clip-share.mp4" ]] || fail 'default output not written'
(( $(wc -c < "$tmp/quiet clip-share.mp4") < $(wc -c < "$tmp/quiet clip.mp4") )) ||
  fail 'output is not smaller'
size=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height \
  -of csv=p=0:s=x "$tmp/quiet clip-share.mp4")
[[ $size == 640x360 ]] || fail "unexpected output size: $size"

# Audio volume should rise appreciably for a quiet source.
measure_mean() {
  local report
  report=$(ffmpeg -hide_banner -nostdin -nostats -i "$1" \
    -map 0:a:0 -vn -af volumedetect -f null - 2>&1)
  [[ $report =~ mean_volume:[[:space:]]*([-0-9.]+)[[:space:]]dB ]] ||
    fail 'could not measure audio mean'
  printf '%s\n' "${BASH_REMATCH[1]}"
}
mean_before=$(measure_mean "$tmp/quiet clip.mp4")
mean_after=$(measure_mean "$tmp/quiet clip-share.mp4")
awk -v before="$mean_before" -v after="$mean_after" \
  'BEGIN {exit !(after > before + 8)}' ||
  fail "audio was not noticeably louder: $mean_before -> $mean_after"
assert_fails 'output already exists' "$video_share" "$tmp/quiet clip.mp4"
"$video_share" -f "$tmp/quiet clip.mp4" >/dev/null

no_audio_report=$("$video_share" "$tmp/no-audio.mp4")
[[ $no_audio_report == *'no audio stream'* ]] || fail 'no-audio file mishandled'
no_audio_count=$(ffprobe -v error -select_streams a -show_entries stream=index \
  -of csv=p=0 "$tmp/no-audio-share.mp4")
[[ -z $no_audio_count ]] || fail 'a silent video gained an audio track'

silent_report=$("$video_share" "$tmp/silent.mp4")
[[ $silent_report == *'silent or near-silent'* ]] || fail 'silent audio was boosted'
[[ -f "$tmp/silent-share.mp4" ]] || fail 'silent output not written'

# Installer registers the command under ~/.local/bin.
mkdir "$tmp/home"
install_preview=$(HOME="$tmp/home" "$project_dir/install.sh" --only bin --check)
[[ $install_preview == *'/.local/bin/video-share'* ]] || fail 'installer does not expose video-share'
[[ ! -e "$tmp/home/.local/bin/video-share" ]] || fail 'installer dry run changed files'

printf 'video_share_test: ok\n'

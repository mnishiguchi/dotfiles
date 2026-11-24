#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "$0")/.." && pwd -P)
prune=$project_dir/bin/debian-kernel-prune
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/bin"

fail() {
  printf 'debian_kernel_prune_test: %s\n' "$*" >&2
  exit 1
}

cat > "$tmp/bin/uname" <<'MOCK'
#!/usr/bin/env bash
case "$1" in
  -r) printf '%s\n' "$MOCK_RUNNING" ;;
  -s) printf '%s\n' Linux ;;
  *) exit 2 ;;
esac
MOCK

cat > "$tmp/bin/dpkg-query" <<'MOCK'
#!/usr/bin/env bash
for release in $MOCK_KERNELS; do
  printf 'linux-image-%s\tii \n' "$release"
done
printf 'linux-image-amd64\tii \n'
printf 'linux-image-6.12.1+deb13-amd64\trc \n'
MOCK

cat > "$tmp/bin/df" <<'MOCK'
#!/usr/bin/env bash
printf 'Filesystem Size Used Avail Use%% Mounted on\n'
printf '/dev/mock 944M 616M 263M 71%% /boot\n'
MOCK

cat > "$tmp/bin/apt-get" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
if [[ $1 == -s && $2 == purge && $3 == -- ]]; then
  shift 3
  [[ ${MOCK_APT_FAIL:-0} != 1 ]] || exit 12
  printf 'Reading package lists...\n'
  for package in "$@"; do
    [[ ${MOCK_SKIP_PURG:-0} != 1 ]] && printf 'Purg %s [mock]\n' "$package"
    [[ ${MOCK_HEADERS:-0} != 1 ]] || printf 'Purg %s [mock]\n' "${package/linux-image-/linux-headers-}"
  done
  if [[ ${MOCK_EVIL:-0} == 1 ]]; then
    printf 'Remv linux-image-amd64 [mock]\n'
  fi
else
  printf 'actual: %s\n' "$*" >> "$MOCK_LOG"
fi
MOCK
chmod +x "$tmp/bin"/*

export PATH="$tmp/bin:$PATH"
export MOCK_LOG="$tmp/purge.log"
export MOCK_KERNELS='6.12.113+deb13-amd64 6.12.115+deb13.1-amd64 6.12.116+deb13-amd64 6.12.117+deb13-amd64'
export MOCK_RUNNING='6.12.115+deb13.1-amd64'

assert_contains() {
  [[ $1 == *"$2"* ]] || fail "expected '$2' in: $1"
}

# The dotfiles installer must expose the renamed command.
mkdir -p "$tmp/home"
install_preview=$(HOME="$tmp/home" "$project_dir/install.sh" --only bin --check)
assert_contains "$install_preview" '/.local/bin/debian-kernel-prune'
[[ ! -e "$tmp/home/.local/bin/debian-kernel-prune" ]] || fail 'installer dry run created a file'

assert_fails() {
  local expected=$1 output status
  shift
  set +e
  output=$("$@" 2>&1 </dev/null)
  status=$?
  set -e
  (( status != 0 )) || fail "unexpected success: $*"
  assert_contains "$output" "$expected"
}

# Inspection is read-only and shows only the oldest kernel as eligible.
output=$("$prune")
assert_contains "$output" '6.12.113+deb13-amd64'
assert_contains "$output" 'protected (running)'
assert_contains "$output" 'protected (newest)'
assert_contains "$output" 'protected (recent-fallback)'
assert_contains "$output" 'Inspection only; nothing has changed.'
[[ ! -e "$MOCK_LOG" ]] || fail 'inspection invoked real purge'

# APT simulation accepts headers tied to candidates and makes no changes.
output=$(MOCK_HEADERS=1 "$prune" --dry-run)
assert_contains "$output" 'Purg linux-image-6.12.113+deb13-amd64'
assert_contains "$output" 'Purg linux-headers-6.12.113+deb13-amd64'
assert_contains "$output" 'APT plan validated'
assert_contains "$output" 'Dry run; nothing has changed.'
[[ ! -e "$MOCK_LOG" ]] || fail 'dry run invoked real purge'

# Explicitly protecting the only candidate should result in no APT call.
output=$("$prune" --dry-run --keep 6.12.113+deb13-amd64)
assert_contains "$output" 'No old kernel packages meet'
assert_fails '--keep release is not installed' "$prune" --keep 6.12.999+deb13-amd64

# APT removing a meta-package, or omitting the requested purge, is rejected.
assert_fails 'unrelated package: linux-image-amd64' env MOCK_EVIL=1 "$prune" --dry-run
assert_fails 'did not propose removing' env MOCK_SKIP_PURG=1 "$prune" --dry-run
assert_fails 'APT simulation failed' env MOCK_APT_FAIL=1 "$prune" --dry-run

# Without an installed running kernel, never make any suggestions.
assert_fails 'running kernel' env MOCK_RUNNING='6.12.999+deb13-amd64' "$prune"

# Running an older release protects it in addition to the three newest.
output=$(env MOCK_KERNELS="6.12.90+deb13-amd64 $MOCK_KERNELS" \
  MOCK_RUNNING='6.12.90+deb13-amd64' "$prune")
assert_contains "$output" '6.12.90+deb13-amd64'
assert_contains "$output" 'protected (running)'
assert_contains "$output" 'linux-image-6.12.113+deb13-amd64'

# Applying requires a terminal, even if stdin contains the confirmation word.
assert_fails 'requires an interactive terminal' "$prune" --apply
[[ ! -e "$MOCK_LOG" ]] || fail 'non-interactive apply invoked real purge'

# With a real pseudo-terminal, a precise confirmation invokes only the mock.
if command -v script >/dev/null 2>&1; then
  output=$(printf 'PURGE\n' | script -qec "$prune --apply" /dev/null 2>&1)
  assert_contains "$output" 'Starting APT purge'
  grep -Fq 'actual: purge -- linux-image-6.12.113+deb13-amd64' "$MOCK_LOG" ||
    fail 'interactive apply did not purge the selected package'
else
  printf 'debian_kernel_prune_test: skipping pty apply check (script unavailable)\n' >&2
fi

printf 'debian_kernel_prune_test: ok\n'

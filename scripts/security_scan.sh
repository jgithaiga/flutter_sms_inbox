#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

LOCKFILES=("pubspec.lock" "example/pubspec.lock")
SEVERITY="HIGH,CRITICAL"

build_local_severity_args() {
  local help_text
  help_text="$(osv-scanner scan --help 2>&1 || true)"

  if echo "$help_text" | grep -q -- "--severity"; then
    echo "--severity $SEVERITY"
    return
  fi

  if echo "$help_text" | grep -q -- "--min-severity"; then
    echo "--min-severity HIGH"
    return
  fi

  echo ""
}

build_docker_severity_args() {
  local help_text
  help_text="$(docker run --rm ghcr.io/google/osv-scanner:latest scan --help 2>&1 || true)"

  if echo "$help_text" | grep -q -- "--severity"; then
    echo "--severity $SEVERITY"
    return
  fi

  if echo "$help_text" | grep -q -- "--min-severity"; then
    echo "--min-severity HIGH"
    return
  fi

  echo ""
}

scan_with_osv() {
  local lockfile="$1"
  local severity_args
  severity_args="$(build_local_severity_args)"
  echo "Scanning $lockfile with osv-scanner"
  if [[ -n "$severity_args" ]]; then
    # shellcheck disable=SC2086
    osv-scanner scan --lockfile "$lockfile" $severity_args
  else
    echo "Warning: this osv-scanner version does not support severity filtering; scanning all severities."
    osv-scanner scan --lockfile "$lockfile"
  fi
}

scan_with_docker() {
  local lockfile="$1"
  local severity_args
  severity_args="$(build_docker_severity_args)"
  echo "Scanning $lockfile with osv-scanner Docker image"
  if [[ -n "$severity_args" ]]; then
    # shellcheck disable=SC2086
    docker run --rm \
      -v "$ROOT_DIR:/src" \
      -w /src \
      ghcr.io/google/osv-scanner:latest \
      scan --lockfile "$lockfile" $severity_args
  else
    echo "Warning: this Docker osv-scanner image does not support severity filtering; scanning all severities."
    docker run --rm \
      -v "$ROOT_DIR:/src" \
      -w /src \
      ghcr.io/google/osv-scanner:latest \
      scan --lockfile "$lockfile"
  fi
}

if command -v osv-scanner >/dev/null 2>&1; then
  for lockfile in "${LOCKFILES[@]}"; do
    scan_with_osv "$lockfile"
  done
elif command -v docker >/dev/null 2>&1; then
  for lockfile in "${LOCKFILES[@]}"; do
    scan_with_docker "$lockfile"
  done
else
  echo "Error: neither osv-scanner nor docker is installed." >&2
  echo "Install osv-scanner, or install Docker and re-run this script." >&2
  exit 1
fi

echo "Security scan completed successfully."

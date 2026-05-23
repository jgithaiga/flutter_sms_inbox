#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

LOCKFILES=("pubspec.lock" "example/pubspec.lock")
SEVERITY="HIGH,CRITICAL"

scan_with_osv() {
  local lockfile="$1"
  echo "Scanning $lockfile with osv-scanner"
  osv-scanner scan --lockfile "$lockfile" --severity "$SEVERITY"
}

scan_with_docker() {
  local lockfile="$1"
  echo "Scanning $lockfile with osv-scanner Docker image"
  docker run --rm \
    -v "$ROOT_DIR:/src" \
    -w /src \
    ghcr.io/google/osv-scanner:latest \
    scan --lockfile "$lockfile" --severity "$SEVERITY"
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

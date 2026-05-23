#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

run_outdated() {
  local target_dir="$1"
  local label="$2"

  echo ""
  echo "== Dependency report: $label =="
  (
    cd "$target_dir"
    flutter pub outdated --no-transitive
  )
}

run_outdated "." "root package"
run_outdated "example" "example app"

echo ""
echo "Dependency report completed."

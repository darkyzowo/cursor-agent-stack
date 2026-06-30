#!/usr/bin/env bash
# install-project-skills.sh — copy domain skills into the current repo (run from repo root)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_ROOT="${1:-$SCRIPT_DIR/.cursor/skills}"
BUNDLE="${BUNDLE:-all}"
TARGET_ROOT="$(pwd)/.cursor/skills"

if [[ ! -d "$TEMPLATE_ROOT" ]]; then
  echo "Template skills not found: $TEMPLATE_ROOT" >&2
  exit 1
fi

mkdir -p "$TARGET_ROOT"

copy_skill() {
  local name="$1"
  if [[ ! -d "$TEMPLATE_ROOT/$name" ]]; then
    echo "Warning: skill not in template, skipping: $name" >&2
    return 0
  fi
  mkdir -p "$TARGET_ROOT/$name"
  cp -R "$TEMPLATE_ROOT/$name/"* "$TARGET_ROOT/$name/"
  echo "  - $name"
}

case "$BUNDLE" in
  2d)
    echo "Installing skills (bundle: 2d)"
    copy_skill security-audit
    copy_skill playwright
    copy_skill ui-ux-pro-max
    ;;
  3d)
    echo "Installing skills (bundle: 3d)"
    copy_skill security-audit
    copy_skill playwright
    copy_skill ui-ux-pro-max
    copy_skill r3f-three
    ;;
  all)
    echo "Installing skills (bundle: all)"
    for d in "$TEMPLATE_ROOT"/*; do
      [[ -d "$d" ]] || continue
      copy_skill "$(basename "$d")"
    done
    ;;
  *)
    echo "Unknown BUNDLE: $BUNDLE (use 2d, 3d, or all)" >&2
    exit 1
    ;;
esac

echo "Installed to $TARGET_ROOT"

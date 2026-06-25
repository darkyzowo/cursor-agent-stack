#!/usr/bin/env bash
# install-project-skills.sh — copy domain skills into the current repo (run from repo root)
set -euo pipefail

TEMPLATE_ROOT="${1:-$(cd "$(dirname "$0")" && pwd)/.cursor/skills}"
TARGET_ROOT="$(pwd)/.cursor/skills"

if [[ ! -d "$TEMPLATE_ROOT" ]]; then
  echo "Template skills not found: $TEMPLATE_ROOT" >&2
  exit 1
fi

mkdir -p "$TARGET_ROOT"
cp -R "$TEMPLATE_ROOT"/* "$TARGET_ROOT"/

echo "Installed project skills to $TARGET_ROOT"
ls -1 "$TARGET_ROOT"

#!/usr/bin/env bash
# install-3d.sh — 3D / R3F module for web repos (run from repo root)
set -euo pipefail

TEMPLATE_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"
CURSOR_DIR="$PROJECT_ROOT/.cursor"

echo "Cursor Agent Stack — 3D module"
echo "Target: $PROJECT_ROOT"

mkdir -p "$CURSOR_DIR/skills"
for name in r3f-three ui-ux-pro-max playwright security-audit; do
  if [[ -d "$TEMPLATE_ROOT/.cursor/skills/$name" ]]; then
    mkdir -p "$CURSOR_DIR/skills/$name"
    cp -R "$TEMPLATE_ROOT/.cursor/skills/$name/"* "$CURSOR_DIR/skills/$name/"
  fi
done
echo "Installed skills"

mkdir -p "$CURSOR_DIR/rules" "$CURSOR_DIR/design-refs"
cp -f "$TEMPLATE_ROOT/.cursor/rules/3d-interactive-lane.mdc" "$CURSOR_DIR/rules/"
cp -f "$TEMPLATE_ROOT/.cursor/design-refs/3d.md" "$CURSOR_DIR/design-refs/"

mkdir -p "$CURSOR_DIR/session"
cp -f "$TEMPLATE_ROOT/.cursor/session/.gitignore" "$CURSOR_DIR/session/"

mkdir -p "$PROJECT_ROOT/scenes"
if [[ ! -f "$PROJECT_ROOT/scenes/ProofScene.tsx" ]]; then
  cp -f "$TEMPLATE_ROOT/scenes/ProofScene.tsx" "$PROJECT_ROOT/scenes/"
  cp -f "$TEMPLATE_ROOT/scenes/README.md" "$PROJECT_ROOT/scenes/"
  echo "Installed scenes/ProofScene.tsx"
else
  echo "Kept existing scenes/ProofScene.tsx"
fi

echo ""
echo "Next steps:"
echo "  1. Reload Cursor"
echo "  2. npm i three @react-three/fiber @react-three/drei"
echo "  3. Render ProofScene before environment work"
echo "  4. Hybrid: also run install-frontend.sh"

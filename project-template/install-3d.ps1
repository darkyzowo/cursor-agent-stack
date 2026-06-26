#!/usr/bin/env pwsh
# install-3d.ps1 — 3D / R3F module for web repos (run from repo root)
param(
  [string]$TemplateRoot = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = Get-Location
$CursorDir = Join-Path $ProjectRoot '.cursor'

Write-Host "Cursor Agent Stack — 3D module" -ForegroundColor Cyan
Write-Host "Target: $ProjectRoot" -ForegroundColor DarkGray

# 1. Skills: r3f-three + ui-ux-pro-max (stack CSV includes react-three-fiber)
$skillsSrc = Join-Path $TemplateRoot '.cursor\skills'
$skillsDst = Join-Path $CursorDir 'skills'
New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null
foreach ($name in @('r3f-three', 'ui-ux-pro-max', 'playwright', 'security-audit')) {
  $src = Join-Path $skillsSrc $name
  if (Test-Path $src) {
    robocopy $src (Join-Path $skillsDst $name) /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
  }
}
Write-Host "Installed skills (r3f-three, ui-ux-pro-max, playwright, security-audit)" -ForegroundColor Green

# 2. Rule + design refs
New-Item -ItemType Directory -Force -Path (Join-Path $CursorDir 'rules') | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\rules\3d-interactive-lane.mdc') (Join-Path $CursorDir 'rules\3d-interactive-lane.mdc')
New-Item -ItemType Directory -Force -Path (Join-Path $CursorDir 'design-refs') | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\design-refs\3d.md') (Join-Path $CursorDir 'design-refs\3d.md')
Write-Host "Installed 3d-interactive-lane rule + design-refs/3d.md" -ForegroundColor Green

# 3. Session gitignore (checkpoint hooks are global)
$sessionDir = Join-Path $CursorDir 'session'
New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\session\.gitignore') (Join-Path $sessionDir '.gitignore')

# 4. Proof scene template (do not overwrite existing)
$scenesDir = Join-Path $ProjectRoot 'scenes'
New-Item -ItemType Directory -Force -Path $scenesDir | Out-Null
$proof = Join-Path $scenesDir 'ProofScene.tsx'
if (-not (Test-Path $proof)) {
  Copy-Item -Force (Join-Path $TemplateRoot 'scenes\ProofScene.tsx') $proof
  Copy-Item -Force (Join-Path $TemplateRoot 'scenes\README.md') (Join-Path $scenesDir 'README.md')
  Write-Host "Installed scenes/ProofScene.tsx" -ForegroundColor Green
} else {
  Write-Host "Kept existing scenes/ProofScene.tsx" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Reload Cursor (third-party agent configs enabled)"
Write-Host "  2. npm i three @react-three/fiber @react-three/drei"
Write-Host "  3. Render ProofScene before any environment work"
Write-Host "  4. Hybrid UI+3D: also run install-frontend.ps1"
Write-Host "  Docs: docs/3D.md in cursor-agent-stack repo"

#!/usr/bin/env pwsh
# install-project-skills.ps1 — copy domain skills into the current repo (run from repo root)
param(
  [string]$TemplateRoot = (Join-Path $PSScriptRoot '.cursor\skills'),
  [ValidateSet('2d', '3d', 'all')]
  [string]$Bundle = 'all'
)

$ErrorActionPreference = 'Stop'
$TargetRoot = Join-Path (Get-Location) '.cursor\skills'

if (-not (Test-Path $TemplateRoot)) {
  Write-Error "Template skills not found: $TemplateRoot"
}

$bundles = @{
  '2d'  = @('security-audit', 'playwright', 'ui-ux-pro-max')
  '3d'  = @('security-audit', 'playwright', 'ui-ux-pro-max', 'r3f-three')
  'all' = (Get-ChildItem $TemplateRoot -Directory | Select-Object -ExpandProperty Name)
}

$skills = $bundles[$Bundle]
New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null

foreach ($name in $skills) {
  $src = Join-Path $TemplateRoot $name
  if (-not (Test-Path $src)) {
    Write-Warning "Skill not in template, skipping: $name"
    continue
  }
  robocopy $src (Join-Path $TargetRoot $name) /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
}

Write-Host "Installed project skills (bundle: $Bundle) to $TargetRoot" -ForegroundColor Green
foreach ($name in $skills) {
  if (Test-Path (Join-Path $TargetRoot $name)) { Write-Host "  - $name" }
}

#!/usr/bin/env pwsh
# install-project-skills.ps1 — copy domain skills into the current repo (run from repo root)
param(
  [string]$TemplateRoot = (Join-Path $PSScriptRoot '.cursor\skills')
)

$ErrorActionPreference = 'Stop'
$TargetRoot = Join-Path (Get-Location) '.cursor\skills'

if (-not (Test-Path $TemplateRoot)) {
  Write-Error "Template skills not found: $TemplateRoot"
}

New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
robocopy $TemplateRoot $TargetRoot /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null

Write-Host "Installed project skills to $TargetRoot" -ForegroundColor Green
Get-ChildItem $TargetRoot -Directory | ForEach-Object { Write-Host "  - $($_.Name)" }

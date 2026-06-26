#!/usr/bin/env pwsh
# install.ps1 — install Cursor Agent Stack to ~/.cursor/

$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$CursorHome = Join-Path $env:USERPROFILE ".cursor"

Write-Host "Cursor Agent Stack installer" -ForegroundColor Cyan
Write-Host "Target: $CursorHome" -ForegroundColor DarkGray

foreach ($dir in @("rules", "hooks", "skills", "session")) {
  New-Item -ItemType Directory -Force -Path (Join-Path $CursorHome $dir) | Out-Null
}

$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$hooksJson = Join-Path $CursorHome "hooks.json"
if (Test-Path $hooksJson) {
  Copy-Item $hooksJson "$hooksJson.bak-$ts"
  Write-Host "Backed up hooks.json -> hooks.json.bak-$ts" -ForegroundColor Yellow
}

Copy-Item -Recurse -Force (Join-Path $RepoRoot "cursor\rules\*") (Join-Path $CursorHome "rules\")
Copy-Item -Recurse -Force (Join-Path $RepoRoot "cursor\hooks\*") (Join-Path $CursorHome "hooks\")
Copy-Item -Recurse -Force (Join-Path $RepoRoot "cursor\skills\*") (Join-Path $CursorHome "skills\")
Copy-Item -Force (Join-Path $RepoRoot "cursor\hooks.json") $hooksJson
Copy-Item -Force (Join-Path $RepoRoot "cursor\statusline.js") (Join-Path $CursorHome "statusline.js")
Copy-Item -Force (Join-Path $RepoRoot "cursor\session\.gitignore") (Join-Path $CursorHome "session\.gitignore")

$cliConfig = Join-Path $CursorHome "cli-config.json"
$statusLineBlock = @"
  "statusLine": {
    "type": "command",
    "command": "node $($CursorHome -replace '\\', '/')/statusline.js",
    "padding": 2,
    "updateIntervalMs": 500,
    "timeoutMs": 1500
  }
"@

Write-Host ""
Write-Host "Installed rules, hooks, skills, statusline.js" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Enable cursor.agent.enableThirdPartyConfigs = true in Cursor Settings"
Write-Host "  2. Reload Cursor (Developer -> Reload Window)"
Write-Host "  3. Optional CLI HUD — merge into $cliConfig :"
Write-Host $statusLineBlock -ForegroundColor DarkGray
Write-Host ""
Write-Host "  4. Per repo: copy project-template\.cursor\session\.gitignore to .cursor\session\"
Write-Host "  5. Web apps: install-frontend.ps1 (2D) or install-3d.ps1 (R3F) — see docs/FRONTEND.md and docs/3D.md"

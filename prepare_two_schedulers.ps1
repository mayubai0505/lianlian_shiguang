# Prepare two background scheduled functions for us-central1. Does not deploy or delete anything.
param([switch]$Apply)
$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$corePath = Join-Path $root 'functions\src\core.js'
$fanPath = Join-Path $root 'functions\src\creator\fan_mail_handlers.js'
if (!(Test-Path $corePath) -or !(Test-Path $fanPath)) { throw 'Run from Firebase project root; expected functions/src/core.js and functions/src/creator/fan_mail_handlers.js' }
$core = [IO.File]::ReadAllText($corePath)
$fan = [IO.File]::ReadAllText($fanPath)
function Patch-One([string]$body, [string]$pattern, [string]$name) {
  $matches = [regex]::Matches($body,$pattern,[Text.RegularExpressions.RegexOptions]::Singleline)
  if ($matches.Count -ne 1) { throw "${name}: expected 1 region: REGION match; found $($matches.Count). No files changed." }
  $match = $matches[0]
  $replacement = $match.Groups[1].Value + "'us-central1'" + $match.Groups[2].Value
  return $body.Substring(0,$match.Index) + $replacement + $body.Substring($match.Index + $match.Length)
}
# These patterns only match each named function's onSchedule options object.
$eventPattern='(exports\.processEventEndingNotifications\s*=\s*onSchedule\s*\(\s*\{[^}]*?\bregion\s*:\s*)REGION(\s*,)'
$fanPattern='(handlers\.processCreatorFanMailJobs\s*=\s*onSchedule\s*\(\s*\{[^}]*?\bregion\s*:\s*)REGION(\s*,)'
$newCore = Patch-One $core $eventPattern 'processEventEndingNotifications'
$newFan = Patch-One $fan $fanPattern 'processCreatorFanMailJobs'
if ($newCore -eq $core -or $newFan -eq $fan) { throw 'Expected both files to change. No files changed.' }
if (!$Apply) {
  Write-Host '[DRY RUN] Both changes can be made exactly once.'
  Write-Host ' - processEventEndingNotifications: asia-east1 -> us-central1'
  Write-Host ' - processCreatorFanMailJobs: asia-east1 -> us-central1'
  Write-Host ' - processQixiLetters: NOT CHANGED (pause old Cloud Scheduler job separately)'
  Write-Host 'No files changed, no deployment performed. Run again with -Apply after reviewing.'
  exit 0
}
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$backupDir=Join-Path $root ("region_backup_" + $stamp)
New-Item -ItemType Directory -Path $backupDir | Out-Null
Copy-Item -LiteralPath $corePath -Destination (Join-Path $backupDir 'core.js')
Copy-Item -LiteralPath $fanPath -Destination (Join-Path $backupDir 'fan_mail_handlers.js')
[IO.File]::WriteAllText($corePath,$newCore,[Text.UTF8Encoding]::new($false))
[IO.File]::WriteAllText($fanPath,$newFan,[Text.UTF8Encoding]::new($false))
Write-Host "Prepared source changes. Backup: $backupDir"
Write-Host 'Next: node --check on BOTH files, then verify deployed functions and migration plan.'
Write-Host 'No deployment or deletion performed.'

param([string]$ProjectRoot=".")
$ErrorActionPreference="Stop"
$core = Join-Path (Resolve-Path $ProjectRoot).Path "functions\src\core.js"
if(-not (Test-Path $core)){ throw "Missing functions\src\core.js" }

$enc = New-Object System.Text.UTF8Encoding($false)
$src = [System.IO.File]::ReadAllText((Resolve-Path $core))

$old = @'
const creatorMonthlyRewardHandlers = createCreatorMonthlyRewards({
  db, APP_ID, REGION, HttpsError, Timestamp, FieldValue, onDocumentCreated, onCall, creatorFanMailVerified,
});
'@

$new = @'
const creatorMonthlyRewardHandlers = createCreatorMonthlyRewards({
  db, APP_ID, REGION, HttpsError, Timestamp, FieldValue, onDocumentCreated, onCall, creatorFanMailVerified,
  sendToUserDevices, logger,
});
'@

if($src.Contains($old)){
  $src=$src.Replace($old,$new)
}elseif($src -notmatch "sendToUserDevices,\s*logger"){
  throw "Could not find creatorMonthlyRewardHandlers injection block. Upload latest core.js for manual merge."
}

$exportNeedle = "exports.creatorRewardTrackPublicBirth = creatorMonthlyRewardHandlers.creatorRewardTrackPublicBirth;"
$exportLine = "exports.creatorRewardTrackPublicWorldBirth = creatorMonthlyRewardHandlers.creatorRewardTrackPublicWorldBirth;"
if($src.Contains($exportNeedle) -and -not $src.Contains($exportLine)){
  $src=$src.Replace($exportNeedle, $exportNeedle + "`r`n" + $exportLine)
}

[System.IO.File]::WriteAllText((Resolve-Path $core),$src,$enc)
Write-Host "SUCCESS: core.js creator monthly reward wiring updated."

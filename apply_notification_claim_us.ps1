param(
    [string]$ProjectRoot = "."
)

$ErrorActionPreference = "Stop"

function Read-Utf8File([string]$Path) {
    return [System.IO.File]::ReadAllText((Resolve-Path $Path))
}

function Write-Utf8File([string]$Path, [string]$Content) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Resolve-Path $Path), $Content, $enc)
}

$root = (Resolve-Path $ProjectRoot).Path
$file = Join-Path $root "lib\screens\notification_list_page.dart"

if (-not (Test-Path $file)) {
    throw "Missing file: $file"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = $file + ".backup_" + $stamp
Copy-Item $file $backup

$src = Read-Utf8File $file

$old = @'
FirebaseFunctions.instanceFor(region: 'asia-east1')
          .httpsCallable('claimCreatorFlowerGift')
'@

$new = @'
FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('claimCreatorFlowerGift')
'@

if ($src.Contains($old)) {
    $src = $src.Replace($old, $new)
    Write-Utf8File $file $src
    Write-Host "SUCCESS: claimCreatorFlowerGift frontend region changed to us-central1."
    Write-Host ("Backup: " + $backup)
}
elseif ($src -match "FirebaseFunctions\.instanceFor\(region:\s*'us-central1'\)[\s\S]{0,120}claimCreatorFlowerGift") {
    Write-Host "Already patched: claimCreatorFlowerGift is using us-central1."
}
else {
    throw "Could not find the expected claimCreatorFlowerGift asia-east1 call. No changes were made."
}

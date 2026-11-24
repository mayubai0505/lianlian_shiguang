param([string]$ProjectRoot=".")
$ErrorActionPreference="Stop"
$root=(Resolve-Path $ProjectRoot).Path
$enc=New-Object System.Text.UTF8Encoding($false)

function Patch-File([string]$Path,[scriptblock]$Transform) {
  if(-not(Test-Path $Path)){ throw "Missing file: $Path" }
  $stamp=Get-Date -Format "yyyyMMdd-HHmmss"
  Copy-Item $Path ($Path+".backup_"+$stamp)
  $src=[System.IO.File]::ReadAllText((Resolve-Path $Path))
  $dst=& $Transform $src
  if($dst -eq $src){ Write-Host "No change needed: $Path"; return }
  [System.IO.File]::WriteAllText((Resolve-Path $Path),$dst,$enc)
  Write-Host "Updated: $Path"
}

$core=Join-Path $root "functions\src\core.js"
Patch-File $core {
  param($src)
  $anchor="exports.claimCreatorFlowerGift = creatorFlowerGiftHandlers.claimCreatorFlowerGift;"
  if(-not $src.Contains($anchor)){ throw "core.js creator flower gift export block not found" }
  $lines=@'
exports.searchCreatorGiftFollowersUs = creatorFlowerGiftHandlers.searchCreatorGiftFollowersUs;
exports.giftCreatorFlowersUs = creatorFlowerGiftHandlers.giftCreatorFlowersUs;
exports.claimCreatorFlowerGiftUs = creatorFlowerGiftHandlers.claimCreatorFlowerGiftUs;
'@
  if(-not $src.Contains("exports.claimCreatorFlowerGiftUs =")){
    $src=$src.Replace($anchor,$anchor+"`r`n"+$lines.Trim())
  }
  return $src
}

$notify=Join-Path $root "lib\screens\notification_list_page.dart"
Patch-File $notify {
  param($src)
  $old=@'
FirebaseFunctions.instanceFor(region: 'asia-east1')
          .httpsCallable('claimCreatorFlowerGift')
'@
  $new=@'
FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('claimCreatorFlowerGiftUs')
'@
  if($src.Contains($old)){
    return $src.Replace($old,$new)
  }
  if($src -match "instanceFor\(region:\s*'us-central1'\)[\s\S]{0,120}claimCreatorFlowerGiftUs"){
    return $src
  }
  throw "notification_list_page.dart claimCreatorFlowerGift call not found"
}

Write-Host "SUCCESS: Asia flower gift functions preserved; US aliases wired for new app."

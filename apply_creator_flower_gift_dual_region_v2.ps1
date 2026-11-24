param([string]$ProjectRoot=".")
$ErrorActionPreference="Stop"
$root=(Resolve-Path $ProjectRoot).Path
$enc=New-Object System.Text.UTF8Encoding($false)
function Patch([string]$p,[scriptblock]$f){
 if(-not(Test-Path $p)){throw "Missing: $p"}
 $src=[IO.File]::ReadAllText((Resolve-Path $p))
 $dst=& $f $src
 if($dst -ne $src){
  Copy-Item $p ($p+".backup_"+(Get-Date -Format "yyyyMMdd-HHmmss"))
  [IO.File]::WriteAllText((Resolve-Path $p),$dst,$enc)
  Write-Host "Updated: $p"
 } else { Write-Host "No change: $p" }
}
Patch (Join-Path $root "functions\src\core.js") {
 param($src)
 $a="exports.claimCreatorFlowerGift = creatorFlowerGiftHandlers.claimCreatorFlowerGift;"
 if(-not $src.Contains($a)){throw "core export anchor not found"}
 if(-not $src.Contains("exports.claimCreatorFlowerGiftUs =")){
  $add="`r`nexports.searchCreatorGiftFollowersUs = creatorFlowerGiftHandlers.searchCreatorGiftFollowersUs;`r`nexports.giftCreatorFlowersUs = creatorFlowerGiftHandlers.giftCreatorFlowersUs;`r`nexports.claimCreatorFlowerGiftUs = creatorFlowerGiftHandlers.claimCreatorFlowerGiftUs;"
  $src=$src.Replace($a,$a+$add)
 }
 return $src
}
Patch (Join-Path $root "lib\screens\notification_list_page.dart") {
 param($src)
 $old="FirebaseFunctions.instanceFor(region: 'asia-east1')`r`n          .httpsCallable('claimCreatorFlowerGift')"
 $new="FirebaseFunctions.instanceFor(region: 'us-central1')`r`n          .httpsCallable('claimCreatorFlowerGiftUs')"
 if($src.Contains($old)){return $src.Replace($old,$new)}
 if($src -match "claimCreatorFlowerGiftUs"){return $src}
 throw "claimCreatorFlowerGift call not found"
}
Write-Host "SUCCESS"

# Run at Flutter project root. Never replaces the existing core.js.
$ErrorActionPreference = 'Stop'
$path = '.\functions\src\core.js'
if (!(Test-Path $path)) { throw "找不到 $path" }
$source = [System.IO.File]::ReadAllText((Resolve-Path $path))
if ($source.Contains('exports.googlePlayRtdn')) { Write-Host '已包含 RTDN exports，跳過。'; exit 0 }
$anchor = "exports.fulfillApplePurchase ="
if ($source.IndexOf($anchor) -lt 0) { throw '找不到 Apple 購買函式錨點，為保護原檔已停止。' }
if ($source.IndexOf($anchor) -ne $source.LastIndexOf($anchor)) { throw '找到多個錨點，為保護原檔已停止。' }
$insertion = @'
// Google Play offline RTDN + retry. Existing IAP handlers are unchanged.
const offlineGooglePlay = require('./payments/google_play_offline')
  .createGooglePlayOfflineFunctions({db,FieldValue,HttpsError});
exports.googlePlayRtdn = offlineGooglePlay.googlePlayRtdn;
exports.retryGooglePlayOrders = offlineGooglePlay.retryGooglePlayOrders;

'@
$backup = "$path.before_google_play_offline_$(Get-Date -Format yyyyMMdd_HHmmss).bak"
Copy-Item $path $backup
$newText = $source.Insert($source.IndexOf($anchor), $insertion + "`n")
[System.IO.File]::WriteAllText((Resolve-Path $path),$newText,(New-Object System.Text.UTF8Encoding($false)))
Write-Host "完成插入；備份：$backup"

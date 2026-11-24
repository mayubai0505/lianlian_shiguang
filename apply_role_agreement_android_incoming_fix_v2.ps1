param(
    [string]$ProjectRoot = "."
)

$ErrorActionPreference = "Stop"

function Read-Utf8File([string]$Path) {
    return [System.IO.File]::ReadAllText((Resolve-Path $Path))
}

function Write-Utf8File([string]$Path, [string]$Content) {
    $enc = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText((Resolve-Path $Path), $Content, $enc)
}

$root = (Resolve-Path $ProjectRoot).Path
$main = Join-Path $root "lib\main.dart"
$incoming = Join-Path $root "lib\screens\role_agreement_incoming_page.dart"
$native = Join-Path $root "lib\services\role_agreement_native_calls.dart"

foreach ($f in @($main, $incoming, $native)) {
    if (-not (Test-Path $f)) {
        throw "Missing file: $f"
    }
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backup = Join-Path $root ("role_agreement_call_fix_backup_" + $stamp)
New-Item -ItemType Directory -Force -Path $backup | Out-Null
Copy-Item $main (Join-Path $backup "main.dart")
Copy-Item $incoming (Join-Path $backup "role_agreement_incoming_page.dart")
Copy-Item $native (Join-Path $backup "role_agreement_native_calls.dart")

# ------------------------------------------------------------
# 1) Fix RoleAgreementIncomingPage Firestore path
# ------------------------------------------------------------
$src = Read-Utf8File $incoming

$oldPath = @'
final agreement = await FirebaseFirestore.instance.collection('role_agreements').doc(uid)
      .collection('characters').doc(widget.characterId)
      .collection('items').doc(widget.agreementId).get();
'@

$newPath = @'
final agreement = await FirebaseFirestore.instance
      .collection('users').doc(uid)
      .collection('characters').doc(widget.characterId)
      .collection('role_agreements').doc(widget.agreementId)
      .get();
'@

if ($src.Contains($oldPath)) {
    $src = $src.Replace($oldPath, $newPath)
}
elseif ($src -match "collection\('users'\).*collection\('role_agreements'\)") {
    Write-Host "IncomingPage path already fixed."
}
else {
    throw "Could not find expected old Firestore path in role_agreement_incoming_page.dart"
}

Write-Utf8File $incoming $src

# ------------------------------------------------------------
# 2) Add Android incoming-call permission helper
# ------------------------------------------------------------
$src = Read-Utf8File $native

if ($src -notmatch "prepareAndroidIncomingPermissions") {
    $needle = "  static String? callIdFor(String agreementId) {"

    if (-not $src.Contains($needle)) {
        throw "Could not find callIdFor insertion point."
    }

    $helper = @'
  static Future<void> prepareAndroidIncomingPermissions() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      await FlutterCallkitIncoming.requestNotificationPermission({
        'title': '允許角色來電通知',
        'rationaleMessagePermission': '角色約定到時間時，需要通知權限才能顯示來電。',
        'postNotificationMessageRequired': '請允許通知權限，才能接收角色約定來電。',
      });
    } catch (error) {
      debugPrint('Role agreement notification permission check failed: $error');
    }

    try {
      final canUse = await FlutterCallkitIncoming.canUseFullScreenIntent();
      if (!canUse) {
        await FlutterCallkitIncoming.requestFullIntentPermission();
      }
    } catch (error) {
      debugPrint('Role agreement full screen intent permission check failed: $error');
    }
  }

'@

    $src = $src.Replace($needle, $helper + $needle)
    Write-Utf8File $native $src
}
else {
    Write-Host "Android permission helper already exists."
}

# ------------------------------------------------------------
# 3) Make Firebase background handler show Android incoming call
# ------------------------------------------------------------
$src = Read-Utf8File $main

if ($src -notmatch "ROLE_AGREEMENT_BACKGROUND_CALL_V1") {
    $firebaseInitLine = "  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);"

    if (-not $src.Contains($firebaseInitLine)) {
        throw "Could not find Firebase initialization line inside background handler."
    }

    $backgroundInsert = @'

  // ROLE_AGREEMENT_BACKGROUND_CALL_V1
  final roleAgreementType = (message.data['type'] ?? '').toString();
  if (roleAgreementType == 'role_agreement_call' &&
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.android) {
    try {
      await RoleAgreementNativeCalls.showFromRemoteMessage(message);
      debugPrint('Background role agreement call forwarded to CallKit');
    } catch (error, stackTrace) {
      debugPrint('Background role agreement call failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    return;
  }
'@

    $replacement = $firebaseInitLine + $backgroundInsert
    $src = $src.Replace($firebaseInitLine, $replacement)
}
else {
    Write-Host "Background role agreement handler already exists."
}

# ------------------------------------------------------------
# 4) Request Android incoming-call permissions after FCM permission
# ------------------------------------------------------------
if ($src -notmatch "ROLE_AGREEMENT_ANDROID_PERMISSION_V1") {
    $permissionLine = "    await messaging.requestPermission(alert: true, badge: false, sound: true);"

    if (-not $src.Contains($permissionLine)) {
        throw "Could not find messaging.requestPermission line."
    }

    $permissionInsert = @'

    // ROLE_AGREEMENT_ANDROID_PERMISSION_V1
    await RoleAgreementNativeCalls.prepareAndroidIncomingPermissions();
'@

    $src = $src.Replace($permissionLine, $permissionLine + $permissionInsert)
}
else {
    Write-Host "Android incoming permission initialization already exists."
}

Write-Utf8File $main $src

Write-Host ""
Write-Host "SUCCESS: Role agreement Android incoming-call patch applied."
Write-Host ("Backup folder: " + $backup)
Write-Host ""
Write-Host "Modified files:"
Write-Host "  lib\main.dart"
Write-Host "  lib\screens\role_agreement_incoming_page.dart"
Write-Host "  lib\services\role_agreement_native_calls.dart"
Write-Host ""
Write-Host "Next:"
Write-Host "  flutter analyze lib\main.dart lib\screens\role_agreement_incoming_page.dart lib\services\role_agreement_native_calls.dart"

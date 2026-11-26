import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';

/// System call-style UI. Android displays the price before acceptance.
/// Only a verified native accept of that invitation can bypass the second UI.
class RoleAgreementNativeCalls {
  static String? _lastVoipToken;
  static const _pricedVersion = 'android20_v1';
  static bool isPricedNativeAccept(Map<String, dynamic> extra) =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android &&
      extra['nativeAcceptedWithPrice'] == true &&
      extra['priceNoticeVersion'] == _pricedVersion && validData(extra);

  // Only called from actual CallKit acceptance or accepted-call recovery.
  static Map<String, dynamic> _acceptedExtra(Map<String, dynamic> extra) => {
    ...extra,
    'nativeAcceptedWithPrice': !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        extra['priceNoticeVersion'] == _pricedVersion,
    'inAppInvitation': false,
    'nativeAcceptEvent': true,
  };

  /// iPhone 專用：將 PushKit VoIP token 交給可信任後端。與普通 FCM token 不同。
  /// 使用者登入後以及重新開啟 App 時呼叫；登入變更就重送。
  static Future<void> registerIosVoipToken() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS || Firebase.apps.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final token = (await FlutterCallkitIncoming.getDevicePushTokenVoIP())?.toString().trim() ?? '';
      if (!RegExp(r'^[a-fA-F0-9]{64,256}$').hasMatch(token)) return;
      final key = '${user.uid}:$token';
      if (_lastVoipToken == key) return;
      await FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('registerRoleAgreementVoipToken').call({'token': token.toLowerCase()});
      _lastVoipToken = key;
      debugPrint('✅ 拾光約定 iOS VoIP token 已同步');
    } catch (error) {
      debugPrint('⚠️ 拾光約定 VoIP token 同步失敗: $error');
    }
  }
  static bool get supported => !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

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
  static String? callIdFor(String agreementId) {
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(agreementId)) return null;
    final hex = agreementId.substring(0, 32);
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  static bool validData(Map<String, dynamic> data) =>
      data['type'] == 'role_agreement_call' &&
      RegExp(r'^[A-Za-z0-9_-]{1,160}$').hasMatch('${data['characterId'] ?? ''}') &&
      callIdFor('${data['agreementId'] ?? ''}') != null;

  static String safeAvatarUrl(dynamic raw) {
    final value = raw is String ? raw.trim() : '';
    final uri = Uri.tryParse(value);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty &&
        uri.userInfo.isEmpty && value.length <= 4096 ? value : '';
  }

  static Future<String> _resolveNativeAvatar(dynamic raw) async {
    final direct = safeAvatarUrl(raw);
    if (direct.isNotEmpty) return direct;
    final path = raw is String ? raw.trim() : '';
    if (!path.startsWith('gs://') && !path.startsWith('/')) return '';
    try {
      final storage = FirebaseStorage.instance;
      final ref = path.startsWith('gs://') ? storage.refFromURL(path) : storage.ref(path);
      return safeAvatarUrl(await ref.getDownloadURL().timeout(const Duration(milliseconds: 900)));
    } catch (_) { return ''; }
  }

  static Future<void> showFromRemoteMessage(RemoteMessage message) async {
    if (!supported || !validData(message.data)) return;
    // On iOS, terminated/background system calls MUST originate in native PushKit.
    // Ordinary FCM is used here only as an in-app fallback, never as VoIP transport.
    if (defaultTargetPlatform == TargetPlatform.iOS) return;
    final data = message.data;
    final agreementId = '${data['agreementId']}';
    final id = callIdFor(agreementId)!;
    final avatar = await _resolveNativeAvatar(data['characterAvatarPath']);
    await FlutterCallkitIncoming.showCallkitIncoming(CallKitParams(
      id: id,
      nameCaller: '${data['characterName'] ?? ''}'.trim().isEmpty ? '角色' : '${data['characterName']}'.trim(),
      avatar: avatar,
      appName: '戀戀拾光',
      handle: '接通扣20花花',
      type: 0,
      duration: 30000,
      extra: {
        'type': 'role_agreement_call',
        'characterId': '${data['characterId']}',
        'agreementId': agreementId,
        'sessionId': '${data['sessionId'] ?? ''}',
        'characterName': '${data['characterName'] ?? ''}',
        'priceNoticeVersion': _pricedVersion,
        'characterAvatarUrl': avatar,
      },
      android: const AndroidParams(
        isCustomNotification: true,
        textAccept: '接聽（20花花）',
        textDecline: '拒接',
        isShowFullLockedScreen: true,
        ringtonePath: 'system_ringtone_default',
        incomingCallNotificationChannelName: '拾光約定來電',
        missedCallNotificationChannelName: '未接來電',
        backgroundColor: '#514B78',
        actionColor: '#8976C9',
        textColor: '#FFFFFF',
      ),
      ios: const IOSParams(handleType: 'generic', supportsVideo: false,
        supportsHolding: false, supportsGrouping: false,
        supportsUngrouping: false, ringtonePath: 'system_ringtone_default'),
    ));
  }

  // Recover only explicitly accepted calls; ringing calls must never open
  // a confirmation page automatically.
  static Future<void> recoverAcceptedCalls(
      void Function(Map<String, dynamic>) onAccept) async {
    if (!supported) return;
    try {
      final calls = await FlutterCallkitIncoming.activeCalls();
      debugPrint('[RA] active calls: ${calls.length}');
      for (final call in calls) {
        if (call.isAccepted != true) continue;
        final extra = extractExtra(call.extra);
        if (extra == null || call.id.toLowerCase() !=
            callIdFor('${extra['agreementId']}')) {
          debugPrint('[RA] accepted call missing valid metadata');
          continue;
        }
        debugPrint('[RA] recovered native accept');
        onAccept(_acceptedExtra(extra));
      }
    } catch (error) {
      debugPrint('[RA] active call recovery failed: $error');
    }
  }

  // Only an explicit native decline reaches this endpoint. Never charge here.
  static Future<void> reportDecline(Map<String, dynamic> extra,
      {required String expectedUid}) async {
    if (!(validData(extra) || validTimeoutData(extra)) || Firebase.apps.isEmpty ||
        FirebaseAuth.instance.currentUser?.uid != expectedUid) {
      throw StateError('role agreement decline auth unavailable');
    }
    final result = await FirebaseFunctions.instanceFor(region: 'us-central1')
        .httpsCallable('declineRoleAgreementCall', options: HttpsCallableOptions(
          timeout: const Duration(seconds: 12),
        )).call({
          if (validTimeoutData(extra)) ...{
            'action': 'unanswered', 'nativeCallId': '${extra['nativeCallId']}',
          } else ...{
            'characterId': '${extra['characterId']}',
            'agreementId': '${extra['agreementId']}',
            'action': extra['action'] ?? 'declined',
          },
        });
    final data = result.data;
    if (data is! Map || data['success'] != true) {
      throw StateError('role agreement decline not confirmed');
    }
  }

  static bool validTimeoutData(Map<String, dynamic> data) =>
      data['action'] == 'unanswered' && RegExp(
          r'^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$')
          .hasMatch('${data['nativeCallId'] ?? ''}');

  static Future<void> close(String agreementId) async {
    if (!supported) return;
    final id = callIdFor(agreementId);
    if (id != null) await FlutterCallkitIncoming.endCall(id);
  }

  static Map<String, dynamic>? extractExtra(Map<String, dynamic>? raw) {
    if (raw == null) return null;
    final extra = raw.map((key, value) => MapEntry(key.toString(), value));
    return validData(extra) ? extra : null;
  }

  static StreamSubscription<CallEvent?> listen({
    required void Function(Map<String, dynamic>) onAccept,
    required void Function(Map<String, dynamic>) onDecline,
  }) => FlutterCallkitIncoming.onEvent.listen((callEvent) {
    if (callEvent == null) return;
    // flutter_callkit_incoming 3.1.x uses sealed event subtypes, not
    // event.event / event.body / Event.actionCallAccept.
    if (callEvent is CallEventActionDidUpdateDevicePushTokenVoip) {
      _lastVoipToken = null;
      unawaited(registerIosVoipToken());
      return;
    }
    if (callEvent is CallEventActionCallAccept) {
      final extra = extractExtra(callEvent.callKitParams.extra);
      debugPrint('[RA] native accept event; valid=${extra != null}');
      if (extra != null && callEvent.callKitParams.id.toLowerCase() ==
          callIdFor('${extra['agreementId']}')) onAccept(_acceptedExtra(extra));
      return;
    }
    if (callEvent is CallEventActionCallDecline) {
      final extra = extractExtra(callEvent.callKitParams.extra);
      if (extra != null) onDecline(extra);
      return;
    }
    if (callEvent is CallEventActionCallTimeout) {
      final extra = <String, dynamic>{'action': 'unanswered',
        'nativeCallId': callEvent.id.toLowerCase()};
      if (validTimeoutData(extra)) onDecline(extra);
    }
  });
}

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:ui' show PlatformDispatcher;


class ReminderNotificationService {
  ReminderNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
  static String? _initialPayload;
  static bool _initialized = false;
  static String? _initialNotificationPayload;
  static const String _pendingPayloadKey =
      'pending_notification_payload';

  static Future<void> _savePendingPayload(
      String? payload,
      ) async {
    if (payload == null || payload.trim().isEmpty) {
      return;
    }

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _pendingPayloadKey,
      payload,
    );

    debugPrint('✅ 已儲存待處理通知：$payload');
  }
  static String? consumeInitialPayload() {
    final payload = _initialNotificationPayload;
    _initialNotificationPayload = null;
    return payload;
  }
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    try {
      final timezone =
      await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(
        tz.getLocation(timezone.identifier),
      );
    } catch (e) {
      debugPrint('取得裝置時區失敗：$e');

      // 取得失敗時先使用台灣時區保底。
      tz.setLocalLocation(
        tz.getLocation('Asia/Taipei'),
      );
    }

    const androidSettings =
    AndroidInitializationSettings(
      'ic_notification',
    );

    const iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {
        debugPrint(
          '玩家點擊備忘錄通知：${response.payload}',
        );

        await _savePendingPayload(
          response.payload,
        );
      },
    );

    final NotificationAppLaunchDetails?
    launchDetails =
    await _plugin
        .getNotificationAppLaunchDetails();

    if (launchDetails
        ?.didNotificationLaunchApp ==
        true) {
      _initialNotificationPayload =
          launchDetails
              ?.notificationResponse
              ?.payload;
    }

    _initialized = true;
  }

  static Future<bool> requestPermission() async {
    await initialize();

    bool granted = true;

    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final bool? notificationGranted =
      await androidPlugin
          .requestNotificationsPermission();

      final bool? exactAlarmGranted =
      await androidPlugin
          .requestExactAlarmsPermission();

      granted =
          (notificationGranted ?? false) &&
              (exactAlarmGranted ?? false);

      debugPrint(
        '通知權限：$notificationGranted，'
            '精準鬧鐘權限：$exactAlarmGranted',
      );
    }

    final iosPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      final bool? iosGranted =
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      granted = iosGranted ?? false;
    }

    return granted;
  }

  static int notificationIdFromMemoId(
      String memoId,
      ) {
    return memoId.hashCode & 0x7fffffff;
  }

  static String _buildCharacterReminderBody({
    required AppLocalizations l10n,
    required String memoContent,
    String? personalityType,
  }) {
    final String type =
        personalityType?.trim().toLowerCase() ?? '';

    if (type.contains('傲嬌')) {
      return l10n.memo_notification_tsundere(memoContent);
    }

    if (type.contains('霸總') ||
        type.contains('強勢') ||
        type.contains('總裁')) {
      return l10n.memo_notification_dominant(memoContent);
    }

    if (type.contains('病嬌')) {
      return l10n.memo_notification_yandere(memoContent);
    }

    if (type.contains('溫柔') ||
        type.contains('知性') ||
        type.contains('暖男')) {
      return l10n.memo_notification_gentle(memoContent);
    }

    if (type.contains('高冷') ||
        type.contains('冷淡') ||
        type.contains('冷酷')) {
      return l10n.memo_notification_cold(memoContent);
    }

    if (type.contains('陽光') ||
        type.contains('活潑') ||
        type.contains('少年')) {
      return l10n.memo_notification_sunny(memoContent);
    }

    if (type.contains('慵懶')) {
      return l10n.memo_notification_lazy(memoContent);
    }

    if (type.contains('年上') ||
        type.contains('哥哥') ||
        type.contains('成熟')) {
      return l10n.memo_notification_older(memoContent);
    }

    if (type.contains('年下') ||
        type.contains('奶狗')) {
      return l10n.memo_notification_younger(memoContent);
    }

    if (type.contains('機械') ||
        type.contains('ai')) {
      return l10n.memo_notification_mechanical(memoContent);
    }

    return l10n.memo_notification_default(memoContent);
  }

  static Future<void> scheduleMemoNotification({
    required String memoId,
    required DateTime reminderDateTime,
    required String characterName,
    required String memoContent,
    String? characterId,
    String? personalityType,
  }) async {
    await initialize();

    final l10n = await AppLocalizations.delegate.load(
      PlatformDispatcher.instance.locale,
    );

    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = tz.TZDateTime(
      tz.local,
      reminderDateTime.year,
      reminderDateTime.month,
      reminderDateTime.day,
      reminderDateTime.hour,
      reminderDateTime.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      debugPrint(
        '備忘錄通知時間已經過期，不排程：$scheduledDate',
      );
      return;
    }

    final notificationId =
    notificationIdFromMemoId(memoId);

    final androidDetails = AndroidNotificationDetails(
      'memo_reminders',
      l10n.memo_notification_channel_name,
      channelDescription: l10n.memo_notification_channel_description,

      icon: 'ic_notification',

      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      enableVibration: true,
    );

    const iosDetails =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final String reminderBody =
    _buildCharacterReminderBody(
      l10n: l10n,
      memoContent: memoContent,
      personalityType: personalityType,
    );

    await _plugin.zonedSchedule(
      id: notificationId,
      title: l10n.memo_notification_title(characterName),
      body: reminderBody,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
      payload: [
        'type=memo',
        if (characterId != null)
          'characterId=$characterId',
        'memoId=$memoId',
      ].join('&'),
    );

    debugPrint(
      '✅ 備忘錄通知已排程：'
          '$scheduledDate / $notificationId',
    );
  }

  static Future<void> cancelMemoNotification(
      String memoId,
      ) async {
    await initialize();

    final notificationId =
    notificationIdFromMemoId(memoId);

    await _plugin.cancel(
      id: notificationId,
    );

    debugPrint(
      '🗑️ 已取消備忘錄通知：$notificationId',
    );
  }

  static Future<void>
  rescheduleMemoNotification({
    required String memoId,
    required DateTime reminderDateTime,
    required String characterName,
    required String memoContent,
    String? characterId,
    String? personalityType,
  }) async {
    await cancelMemoNotification(
      memoId,
    );

    await scheduleMemoNotification(
      memoId: memoId,
      reminderDateTime:
      reminderDateTime,
      characterName: characterName,
      memoContent: memoContent,
      characterId: characterId,
      personalityType: personalityType,
    );
  }

  static Future<
      List<PendingNotificationRequest>>
  getPendingNotifications() async {
    await initialize();

    return _plugin
        .pendingNotificationRequests();
  }
}
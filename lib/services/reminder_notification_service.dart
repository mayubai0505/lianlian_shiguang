import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
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
    required String memoContent,
    String? personalityType,
  }) {
    final String type =
        personalityType?.trim().toLowerCase() ?? '';

    if (type.contains('傲嬌')) {
      return '我才不是擔心你，只是怕你忘記而已。今天別忘了：$memoContent';
    }

    if (type.contains('霸總') ||
        type.contains('強勢') ||
        type.contains('總裁')) {
      return '行程已經替你記好了，準時完成。今天別忘了：$memoContent';
    }

    if (type.contains('病嬌')) {
      return '不可以忘記喔，我可是會一直記得的。今天別忘了：$memoContent';
    }

    if (type.contains('溫柔') ||
        type.contains('知性') ||
        type.contains('暖男')) {
      return '怕你忙著忙著就忘了，所以想提醒你一下。今天別忘了：$memoContent';
    }

    if (type.contains('高冷') ||
        type.contains('冷淡') ||
        type.contains('冷酷')) {
      return '提醒你一件事。今天別忘了：$memoContent';
    }

    if (type.contains('陽光') ||
        type.contains('活潑') ||
        type.contains('少年')) {
      return '嘿，今天還有一件重要的事喔！別忘了：$memoContent';
    }

    if (type.contains('慵懶')) {
      return '雖然很想繼續躺著，但還是得提醒你。今天別忘了：$memoContent';
    }

    if (type.contains('年上') ||
        type.contains('哥哥') ||
        type.contains('成熟')) {
      return '乖，今天的事情別忘記了。記得：$memoContent';
    }

    if (type.contains('年下') ||
        type.contains('奶狗')) {
      return '我有乖乖幫你記住喔！今天別忘了：$memoContent';
    }

    if (type.contains('機械') ||
        type.contains('ai')) {
      return '提醒事項已啟動。今日任務：$memoContent';
    }

    return '今天別忘了：$memoContent';
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

    const androidDetails = AndroidNotificationDetails(
      'memo_reminders',
      '備忘錄提醒',
      channelDescription: '由角色提醒玩家已設定的備忘事項',

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

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final String reminderBody =
    _buildCharacterReminderBody(
      memoContent: memoContent,
      personalityType: personalityType,
    );

    await _plugin.zonedSchedule(
      id: notificationId,
      title: '$characterName 提醒你',
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
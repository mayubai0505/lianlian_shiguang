import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

class DesktopWidgetNativeService {
  static const String appGroupId =
      'group.com.yubaimo.lianlian_shiguang';

  static const String androidProviderName =
      'LianLianHomeWidgetProvider';

  static const String androidQualifiedProviderName =
      'com.yubaimo.lianlian_shiguang.widget.'
      'LianLianHomeWidgetProvider';

  static const String iosWidgetKind =
      'LianLianHomeWidget';

  static String _key(String widgetConfigId, String field) {
    return 'widget_${widgetConfigId}_$field';
  }

  static Future<void> saveAndRefresh({
    required String widgetConfigId,
    required String widgetType,
    required String characterId,
    required String characterName,
    required String imageUrl,
    required String size,
    required String layout,
    required Map<String, dynamic> settings,
    required List<String> displayLines,
    required bool requestPin,
  }) async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(appGroupId);
    }

    final String? groupId =
    Platform.isIOS ? appGroupId : null;

    final values = <String, String>{
      _key(widgetConfigId, 'type'): widgetType,
      _key(widgetConfigId, 'character_id'): characterId,
      _key(widgetConfigId, 'character_name'): characterName,
      _key(widgetConfigId, 'size'): size,
      _key(widgetConfigId, 'layout'): layout,
      _key(widgetConfigId, 'settings_json'): jsonEncode(settings),
      _key(widgetConfigId, 'line_1'):
      displayLines.isNotEmpty ? displayLines[0] : '',
      _key(widgetConfigId, 'line_2'):
      displayLines.length > 1 ? displayLines[1] : '',
      _key(widgetConfigId, 'line_3'):
      displayLines.length > 2 ? displayLines[2] : '',
      _key(widgetConfigId, 'line_4'):
      displayLines.length > 3 ? displayLines[3] : '',
      _key(widgetConfigId, 'image_source_url'): imageUrl,

      // Legacy fallback: widgets created before per-instance binding
      // can still display the latest content instead of going blank.
      'widget_type': widgetType,
      'widget_character_id': characterId,
      'widget_character_name': characterName,
      'widget_size': size,
      'widget_layout': layout,
      'widget_settings_json': jsonEncode(settings),
      'widget_line_1':
      displayLines.isNotEmpty ? displayLines[0] : '',
      'widget_line_2':
      displayLines.length > 1 ? displayLines[1] : '',
      'widget_line_3':
      displayLines.length > 2 ? displayLines[2] : '',
      'widget_line_4':
      displayLines.length > 3 ? displayLines[3] : '',
      'widget_image_source_url': imageUrl,
    };

    for (final entry in values.entries) {
      await HomeWidget.saveWidgetData<String>(
        entry.key,
        entry.value,
        appGroupId: groupId,
      );
    }

    await HomeWidget.saveWidgetData<bool>(
      _key(widgetConfigId, 'disabled'),
      false,
      appGroupId: groupId,
    );

    if (imageUrl.trim().isNotEmpty) {
      try {
        await HomeWidget.saveImage(
          _key(widgetConfigId, 'image'),
          NetworkImage(imageUrl.trim()),
          appGroupId: groupId,
        );

        // Legacy fallback image.
        await HomeWidget.saveImage(
          'widget_image',
          NetworkImage(imageUrl.trim()),
          appGroupId: groupId,
        );
      } catch (_) {
        // Keep text usable even if an image cannot be cached.
      }
    }

    if (Platform.isAndroid && requestPin) {
      // This tells the Android provider which App-side config belongs
      // to the next widget instance being added to the launcher.
      await HomeWidget.saveWidgetData<String>(
        'widget_pending_config_id',
        widgetConfigId,
        appGroupId: groupId,
      );

      await HomeWidget.requestPinWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
      );
      return;
    }

    await HomeWidget.updateWidget(
      name: androidProviderName,
      androidName: androidProviderName,
      qualifiedAndroidName: androidQualifiedProviderName,
      iOSName: iosWidgetKind,
    );
  }


  static const String _registryPrefsKey = 'desktop_widget_registry_v1';

  static Map<String, String> get _statusLabels => <String, String>{
    'mood': '心情',
    'currentState': appL10n.widget_key_message,
    'location': appL10n.widget_key_message_variant_b,
    'relationship': '關係',
    'outfit': '衣著',
    'weather': '天氣',
    'thought': '想法',
    'action': '動作',
    'affinity': '好感度',
  };

  static String _statusDisplayValue(
      Map<String, dynamic> statusBar,
      Map<String, dynamic> statusBarChanges,
      String field,
      ) {
    final rawValue = statusBar[field]?.toString().trim() ?? '';
    final rawChange = statusBarChanges[field];

    if (rawChange is Map) {
      final change = Map<String, dynamic>.from(rawChange);
      final bool changed = change['changed'] == true;
      final previousValue =
          change['previousValue']?.toString().trim() ?? '';
      final currentValue =
          change['value']?.toString().trim() ?? rawValue;

      if (changed &&
          previousValue.isNotEmpty &&
          currentValue.isNotEmpty &&
          previousValue != currentValue) {
        return '$previousValue → $currentValue';
      }
    }

    return rawValue;
  }

  static List<String> buildCharacterStatusLines({
    required Map<String, dynamic> settings,
    required Map<String, dynamic> statusBar,
    Map<String, dynamic> statusBarChanges = const <String, dynamic>{},
    String location = '',
  }) {
    final rawFields = settings['fields'];
    final fields = rawFields is List
        ? rawFields.map((e) => e.toString()).toList()
        : const <String>['mood', 'currentState', 'location'];

    final lines = <String>[];

    for (final field in fields.take(3)) {
      String value;

      if (field == 'location') {
        value = location.trim();
      } else {
        value = _statusDisplayValue(
          statusBar,
          statusBarChanges,
          field,
        );
      }

      if (value.isEmpty) continue;

      final label = _statusLabels[field] ?? field;
      lines.add('$label｜$value');
    }

    return lines;
  }

  static Future<List<String>> loadCharacterStatusLines({
    required String characterId,
    required Map<String, dynamic> settings,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || characterId.trim().isEmpty) {
      return <String>[appL10n.widget_label_character];
    }

    try {
      final sessions = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc('lianlianshiguang')
          .collection('chat_sessions')
          .where('userId', isEqualTo: user.uid)
          .where('characterId', isEqualTo: characterId)
          .get();

      if (sessions.docs.isEmpty) {
        return const <String>['尚未有角色狀態'];
      }

      final sortedSessions = sessions.docs.toList()
        ..sort((a, b) {
          final aTime = a.data()['lastActivity'];
          final bTime = b.data()['lastActivity'];

          final aMs = aTime is Timestamp
              ? aTime.millisecondsSinceEpoch
              : 0;
          final bMs = bTime is Timestamp
              ? bTime.millisecondsSinceEpoch
              : 0;

          return bMs.compareTo(aMs);
        });

      for (final session in sortedSessions) {
        final sessionData = session.data();
        final location =
            sessionData['lastStoryLocation']?.toString().trim() ?? '';

        final messages = await session.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(30)
            .get();

        for (final doc in messages.docs) {
          final data = doc.data();

          if (data['sender']?.toString() != 'ai') continue;

          final rawStatusBar = data['statusBar'];
          if (rawStatusBar is! Map || rawStatusBar.isEmpty) continue;

          final statusBar =
          Map<String, dynamic>.from(rawStatusBar);

          final rawChanges = data['statusBarChanges'];
          final statusBarChanges = rawChanges is Map
              ? Map<String, dynamic>.from(rawChanges)
              : <String, dynamic>{};

          final lines = buildCharacterStatusLines(
            settings: settings,
            statusBar: statusBar,
            statusBarChanges: statusBarChanges,
            location: location,
          );

          if (lines.isNotEmpty) {
            return lines;
          }
        }
      }
    } catch (error) {
      debugPrint('⚠️ Widget 讀取角色最新狀態失敗：$error');
    }

    return const <String>['尚未有角色狀態'];
  }

  static Future<void> refreshCharacterStatusWidgetsForCharacter({
    required String characterId,
    required Map<String, dynamic> statusBar,
    Map<String, dynamic> statusBarChanges = const <String, dynamic>{},
    String location = '',
  }) async {
    if (characterId.trim().isEmpty || statusBar.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_registryPrefsKey);

      if (raw == null || raw.trim().isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      bool didUpdateAny = false;

      for (final item in decoded.whereType<Map>()) {
        final data = Map<String, dynamic>.from(item);

        if (data['widgetType']?.toString() != 'character_status') {
          continue;
        }

        if (data['characterId']?.toString() != characterId) {
          continue;
        }

        final widgetConfigId = data['id']?.toString().trim() ?? '';
        if (widgetConfigId.isEmpty) continue;

        final settings = data['settings'] is Map
            ? Map<String, dynamic>.from(data['settings'] as Map)
            : <String, dynamic>{};

        final lines = buildCharacterStatusLines(
          settings: settings,
          statusBar: statusBar,
          statusBarChanges: statusBarChanges,
          location: location,
        );

        if (lines.isEmpty) continue;

        final String? groupId =
        Platform.isIOS ? appGroupId : null;

        for (int i = 0; i < 4; i++) {
          await HomeWidget.saveWidgetData<String>(
            _key(widgetConfigId, 'line_${i + 1}'),
            i < lines.length ? lines[i] : '',
            appGroupId: groupId,
          );
        }

        didUpdateAny = true;
      }

      if (!didUpdateAny) return;

      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(appGroupId);
      }

      await HomeWidget.updateWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
        iOSName: iosWidgetKind,
      );
    } catch (error) {
      debugPrint('⚠️ Widget 即時更新角色狀態失敗：$error');
    }
  }


  static String _formatPostTime(dynamic rawCreatedAt) {
    DateTime? createdAt;

    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdAt = rawCreatedAt;
    }

    if (createdAt == null) return appL10n.widget_format_post_time_label_moment_latest;

    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return appL10n.widget_format_post_time_label_update_moment;
    if (diff.inMinutes < 60) return appL10n.widget_format_post_time_label_minutes_ago_update_moment(diff.inMinutes);
    if (diff.inHours < 24) return appL10n.widget_format_post_time_label_hours_ago_update_moment(diff.inHours);
    if (diff.inDays == 1) return appL10n.widget_format_post_time_label_update_moment_days;
    if (diff.inDays < 7) return appL10n.widget_format_post_time_label_update_moment_days_ago(diff.inDays);

    return appL10n.widget_format_post_time_label_update_moment_variant_b(createdAt.month, createdAt.day);
  }

  static List<String> buildLatestPostLines({
    required Map<String, dynamic> settings,
    required String content,
    required dynamic createdAt,
    int likeCount = 0,
    int commentCount = 0,
    bool hasImage = false,
  }) {
    final lines = <String>[
      _formatPostTime(createdAt),
    ];

    final trimmedContent = content.trim();

    if (trimmedContent.isNotEmpty) {
      lines.add('「$trimmedContent」');
    } else if (hasImage) {
      lines.add(appL10n.widget_format_post_time_message_share_photo);
    } else {
      lines.add(appL10n.widget_format_post_time_message_update_moment);
    }

    final showLikes = settings['showLikes'] != false;
    final showComments = settings['showComments'] != false;

    final stats = <String>[];
    if (showLikes) stats.add('♡ $likeCount');
    if (showComments) stats.add('💬 $commentCount');

    if (stats.isNotEmpty) {
      lines.add(stats.join('　'));
    }

    return lines.take(4).toList();
  }

  static Future<Map<String, dynamic>> loadLatestPostWidgetData({
    required String characterId,
    required Map<String, dynamic> settings,
    required String fallbackImageUrl,
  }) async {
    if (characterId.trim().isEmpty) {
      return <String, dynamic>{
        'lines': <String>[appL10n.widget_format_post_time_message_current_character_moment],
        'imageUrl': fallbackImageUrl,
      };
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc('lianlianshiguang')
          .collection('moments')
          .where('authorId', isEqualTo: characterId)
          .get();

      if (snapshot.docs.isEmpty) {
        return <String, dynamic>{
          'lines': const <String>['目前還沒有角色動態'],
          'imageUrl': fallbackImageUrl,
        };
      }

      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = a.data()['createdAt'];
          final bTime = b.data()['createdAt'];

          final aMs = aTime is Timestamp
              ? aTime.millisecondsSinceEpoch
              : 0;
          final bMs = bTime is Timestamp
              ? bTime.millisecondsSinceEpoch
              : 0;

          return bMs.compareTo(aMs);
        });

      final data = docs.first.data();

      final content = data['content']?.toString() ?? '';
      final postImageUrl = data['imageUrl']?.toString().trim() ?? '';
      final likeCount = data['likeCount'] is num
          ? (data['likeCount'] as num).toInt()
          : 0;
      final commentCount = data['commentCount'] is num
          ? (data['commentCount'] as num).toInt()
          : 0;

      final lines = buildLatestPostLines(
        settings: settings,
        content: content,
        createdAt: data['createdAt'],
        likeCount: likeCount,
        commentCount: commentCount,
        hasImage: postImageUrl.isNotEmpty,
      );

      final bool showImage = settings['showImage'] != false;

      return <String, dynamic>{
        'lines': lines,
        'imageUrl': showImage && postImageUrl.isNotEmpty
            ? postImageUrl
            : fallbackImageUrl,
      };
    } catch (error) {
      debugPrint('⚠️ Widget 讀取角色最新貼文失敗：$error');

      return <String, dynamic>{
        'lines': const <String>['目前還沒有角色動態'],
        'imageUrl': fallbackImageUrl,
      };
    }
  }

  static Future<void> refreshLatestPostWidgetsForCharacter({
    required String characterId,
    required String content,
    String imageUrl = '',
    dynamic createdAt,
    int likeCount = 0,
    int commentCount = 0,
  }) async {
    if (characterId.trim().isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_registryPrefsKey);

      if (raw == null || raw.trim().isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      bool didUpdateAny = false;
      final String? groupId =
      Platform.isIOS ? appGroupId : null;

      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(appGroupId);
      }

      for (final item in decoded.whereType<Map>()) {
        final data = Map<String, dynamic>.from(item);

        if (data['widgetType']?.toString() != 'character_post') {
          continue;
        }

        if (data['characterId']?.toString() != characterId) {
          continue;
        }

        final widgetConfigId = data['id']?.toString().trim() ?? '';
        if (widgetConfigId.isEmpty) continue;

        final settings = data['settings'] is Map
            ? Map<String, dynamic>.from(data['settings'] as Map)
            : <String, dynamic>{};

        final lines = buildLatestPostLines(
          settings: settings,
          content: content,
          createdAt: createdAt,
          likeCount: likeCount,
          commentCount: commentCount,
          hasImage: imageUrl.trim().isNotEmpty,
        );

        for (int i = 0; i < 4; i++) {
          await HomeWidget.saveWidgetData<String>(
            _key(widgetConfigId, 'line_${i + 1}'),
            i < lines.length ? lines[i] : '',
            appGroupId: groupId,
          );
        }

        final fallbackImageUrl =
            data['imageUrl']?.toString().trim() ?? '';
        final showImage = settings['showImage'] != false;
        final targetImageUrl =
        showImage && imageUrl.trim().isNotEmpty
            ? imageUrl.trim()
            : fallbackImageUrl;

        await HomeWidget.saveWidgetData<String>(
          _key(widgetConfigId, 'image_source_url'),
          targetImageUrl,
          appGroupId: groupId,
        );

        if (targetImageUrl.isNotEmpty) {
          try {
            await HomeWidget.saveImage(
              _key(widgetConfigId, 'image'),
              NetworkImage(targetImageUrl),
              appGroupId: groupId,
            );
          } catch (error) {
            debugPrint('⚠️ Widget 快取最新貼文圖片失敗：$error');
          }
        }

        didUpdateAny = true;
      }

      if (!didUpdateAny) return;

      await HomeWidget.updateWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
        iOSName: iosWidgetKind,
      );
    } catch (error) {
      debugPrint('⚠️ Widget 即時更新角色貼文失敗：$error');
    }
  }


  static String _extractDailyQuote(String rawText) {
    final text = rawText
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();

    if (text.isEmpty) return '';

    // 優先抓角色真正說出口的「台詞」。
    final quoteMatches = RegExp(r'「([^」]+)」', dotAll: true).allMatches(text);
    for (final match in quoteMatches) {
      final value = (match.group(1) ?? '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (value.isNotEmpty) {
        return value;
      }
    }

    // 沒有中文引號時，避開狀態欄／時間／地點，取第一段有內容的文字。
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .where((line) =>
    !line.startsWith('時間：') &&
        !line.startsWith(appL10n.widget_extract_daily_quote_message) &&
        !line.contains('｜'))
        .toList();

    if (lines.isEmpty) return '';

    var value = lines.first
        .replaceAll(RegExp(r'^[（(].*?[）)]\s*'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (value.length > 72) {
      value = '${value.substring(0, 72)}…';
    }

    return value;
  }

  static String _formatDailyQuoteTime(dynamic rawTimestamp) {
    DateTime? time;

    if (rawTimestamp is Timestamp) {
      time = rawTimestamp.toDate();
    } else if (rawTimestamp is DateTime) {
      time = rawTimestamp;
    }

    if (time == null) return '';

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static List<String> buildDailyQuoteLines({
    required Map<String, dynamic> settings,
    required String quote,
    required dynamic timestamp,
  }) {
    final lines = <String>[];

    if (quote.trim().isNotEmpty) {
      lines.add('「${quote.trim()}」');
    } else {
      lines.add(appL10n.widget_format_daily_quote_time_message_today);
    }

    if (settings['showTime'] == true) {
      final time = _formatDailyQuoteTime(timestamp);
      if (time.isNotEmpty) {
        lines.add(time);
      }
    }

    return lines;
  }

  static Future<Map<String, dynamic>> _findLatestAiQuoteForCharacter(
      String characterId,
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || characterId.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final sessions = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc('lianlianshiguang')
          .collection('chat_sessions')
          .where('userId', isEqualTo: user.uid)
          .where('characterId', isEqualTo: characterId)
          .get();

      if (sessions.docs.isEmpty) {
        return <String, dynamic>{};
      }

      final sortedSessions = sessions.docs.toList()
        ..sort((a, b) {
          final aTime = a.data()['lastActivity'];
          final bTime = b.data()['lastActivity'];

          final aMs = aTime is Timestamp
              ? aTime.millisecondsSinceEpoch
              : 0;
          final bMs = bTime is Timestamp
              ? bTime.millisecondsSinceEpoch
              : 0;

          return bMs.compareTo(aMs);
        });

      for (final session in sortedSessions) {
        final messages = await session.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(30)
            .get();

        for (final doc in messages.docs) {
          final data = doc.data();
          if (data['sender']?.toString() != 'ai') continue;

          final rawText = data['text']?.toString() ?? '';
          final quote = _extractDailyQuote(rawText);
          if (quote.isEmpty) continue;

          return <String, dynamic>{
            'quote': quote,
            'timestamp': data['timestamp'],
          };
        }
      }
    } catch (error) {
      debugPrint('⚠️ Widget 讀取今日一句失敗：$error');
    }

    return <String, dynamic>{};
  }

  static Future<List<String>> loadDailyQuoteWidgetData({
    required String characterId,
    required Map<String, dynamic> settings,
  }) async {
    final data = await _findLatestAiQuoteForCharacter(characterId);

    return buildDailyQuoteLines(
      settings: settings,
      quote: data['quote']?.toString() ?? '',
      timestamp: data['timestamp'],
    );
  }

  static Future<void> refreshDailyQuoteWidgetsOnAppOpen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_registryPrefsKey);

      if (raw == null || raw.trim().isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final now = DateTime.now();
      final todayKey =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';

      bool didUpdateAny = false;
      final String? groupId =
      Platform.isIOS ? appGroupId : null;

      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(appGroupId);
      }

      for (final item in decoded.whereType<Map>()) {
        final data = Map<String, dynamic>.from(item);

        if (data['widgetType']?.toString() != 'daily_quote') {
          continue;
        }

        final widgetConfigId =
            data['id']?.toString().trim() ?? '';
        final characterId =
            data['characterId']?.toString().trim() ?? '';

        if (widgetConfigId.isEmpty || characterId.isEmpty) {
          continue;
        }

        final settings = data['settings'] is Map
            ? Map<String, dynamic>.from(data['settings'] as Map)
            : <String, dynamic>{};

        final refreshMode =
            settings['refreshMode']?.toString() ?? 'daily';

        // daily：跨日才更新。
        // app_open：每次冷啟動 / 回前景都讀最新一句。
        if (refreshMode == 'daily') {
          final lastDate = prefs.getString(
            'desktop_widget_daily_quote_date_$widgetConfigId',
          );

          if (lastDate == todayKey) {
            continue;
          }
        }

        final latest = await _findLatestAiQuoteForCharacter(
          characterId,
        );

        final lines = buildDailyQuoteLines(
          settings: settings,
          quote: latest['quote']?.toString() ?? '',
          timestamp: latest['timestamp'],
        );

        for (int i = 0; i < 4; i++) {
          await HomeWidget.saveWidgetData<String>(
            _key(widgetConfigId, 'line_${i + 1}'),
            i < lines.length ? lines[i] : '',
            appGroupId: groupId,
          );
        }

        await prefs.setString(
          'desktop_widget_daily_quote_date_$widgetConfigId',
          todayKey,
        );

        didUpdateAny = true;
      }

      if (!didUpdateAny) return;

      await HomeWidget.updateWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
        iOSName: iosWidgetKind,
      );
    } catch (error) {
      debugPrint('⚠️ Widget App 開啟刷新今日一句失敗：$error');
    }
  }


  static Future<void> refreshDailyQuoteWidgetsForCharacter({
    required String characterId,
    required String aiText,
    required dynamic timestamp,
  }) async {
    if (characterId.trim().isEmpty || aiText.trim().isEmpty) return;

    final quote = _extractDailyQuote(aiText);
    if (quote.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_registryPrefsKey);
      if (raw == null || raw.trim().isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final today = DateTime.now();
      final todayKey =
          '${today.year.toString().padLeft(4, '0')}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';

      bool didUpdateAny = false;
      final String? groupId =
      Platform.isIOS ? appGroupId : null;

      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(appGroupId);
      }

      for (final item in decoded.whereType<Map>()) {
        final data = Map<String, dynamic>.from(item);

        if (data['widgetType']?.toString() != 'daily_quote') {
          continue;
        }

        if (data['characterId']?.toString() != characterId) {
          continue;
        }

        final widgetConfigId = data['id']?.toString().trim() ?? '';
        if (widgetConfigId.isEmpty) continue;

        final settings = data['settings'] is Map
            ? Map<String, dynamic>.from(data['settings'] as Map)
            : <String, dynamic>{};

        final refreshMode =
            settings['refreshMode']?.toString() ?? 'daily';

        if (refreshMode == 'daily') {
          final lastDate =
          prefs.getString('desktop_widget_daily_quote_date_$widgetConfigId');

          if (lastDate == todayKey) {
            continue;
          }
        }

        final lines = buildDailyQuoteLines(
          settings: settings,
          quote: quote,
          timestamp: timestamp,
        );

        for (int i = 0; i < 4; i++) {
          await HomeWidget.saveWidgetData<String>(
            _key(widgetConfigId, 'line_${i + 1}'),
            i < lines.length ? lines[i] : '',
            appGroupId: groupId,
          );
        }

        await prefs.setString(
          'desktop_widget_daily_quote_date_$widgetConfigId',
          todayKey,
        );

        didUpdateAny = true;
      }

      if (!didUpdateAny) return;

      await HomeWidget.updateWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
        iOSName: iosWidgetKind,
      );
    } catch (error) {
      debugPrint('⚠️ Widget 即時更新今日一句失敗：$error');
    }
  }


  static DateTime _dateOnlyForWidget(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static Future<Map<String, dynamic>> _loadPeriodCareState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return <String, dynamic>{};

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('period_tracker')
          .get();

      final records = <Map<String, dynamic>>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final startRaw = data['startDate'];
        if (startRaw is! Timestamp) continue;

        final endRaw = data['endDate'];
        records.add(<String, dynamic>{
          'startDate': _dateOnlyForWidget(startRaw.toDate()),
          'endDate': _dateOnlyForWidget(
            endRaw is Timestamp ? endRaw.toDate() : startRaw.toDate(),
          ),
          'isOngoing': data['isOngoing'] == true,
        });
      }

      if (records.isEmpty) {
        return <String, dynamic>{
          'status': 'no_data',
        };
      }

      records.sort(
            (a, b) => (a['startDate'] as DateTime)
            .compareTo(b['startDate'] as DateTime),
      );

      final today = _dateOnlyForWidget(DateTime.now());

      Map<String, dynamic>? ongoing;
      for (final record in records.reversed) {
        if (record['isOngoing'] == true) {
          ongoing = record;
          break;
        }
      }

      if (ongoing != null) {
        final start = ongoing['startDate'] as DateTime;
        final dayCount = today.difference(start).inDays + 1;

        return <String, dynamic>{
          'status': 'ongoing',
          'dayCount': dayCount < 1 ? 1 : dayCount,
        };
      }

      final latest = records.last;
      final latestEnd = latest['endDate'] as DateTime;
      final daysAfterEnd = today.difference(latestEnd).inDays;

      if (daysAfterEnd >= 0 && daysAfterEnd <= 2) {
        return <String, dynamic>{
          'status': 'just_ended',
          'daysAfterEnd': daysAfterEnd,
        };
      }

      final cycleLengths = <int>[];
      for (var i = 1; i < records.length; i++) {
        final previous = records[i - 1]['startDate'] as DateTime;
        final current = records[i]['startDate'] as DateTime;
        final days = current.difference(previous).inDays;
        if (days >= 15 && days <= 60) {
          cycleLengths.add(days);
        }
      }

      if (cycleLengths.isNotEmpty) {
        final averageCycle =
        (cycleLengths.reduce((a, b) => a + b) / cycleLengths.length)
            .round();

        final lastStart = latest['startDate'] as DateTime;
        final predictedStart =
        lastStart.add(Duration(days: averageCycle));
        final daysUntil = predictedStart.difference(today).inDays;

        if (daysUntil >= 0 && daysUntil <= 3) {
          return <String, dynamic>{
            'status': 'upcoming',
            'daysUntil': daysUntil,
          };
        }
      }

      return <String, dynamic>{
        'status': 'normal',
      };
    } catch (error) {
      debugPrint('⚠️ Widget 讀取生理期狀態失敗：$error');
      return <String, dynamic>{
        'status': 'no_data',
      };
    }
  }

  static List<String> buildPeriodCareLines({
    required Map<String, dynamic> settings,
    required Map<String, dynamic> state,
  }) {
    final privacyMode = settings['privacyMode'] != false;
    final showCycleStatus = settings['showCycleStatus'] == true;
    final status = state['status']?.toString() ?? 'no_data';

    String careLine;
    String? cycleLine;

    switch (status) {
      case 'ongoing':
        careLine = appL10n.widget_load_period_care_state_message_today;
        final dayCount = state['dayCount'] is num
            ? (state['dayCount'] as num).toInt()
            : 1;
        cycleLine = appL10n.widget_load_period_care_state_message_period_days(dayCount);
        break;
      case 'upcoming':
        careLine = appL10n.widget_load_period_care_state_message_days;
        final daysUntil = state['daysUntil'] is num
            ? (state['daysUntil'] as num).toInt()
            : 0;
        cycleLine =
        daysUntil == 0 ? appL10n.widget_load_period_care_state_message_today_start : appL10n.widget_load_period_care_state_message_days_variant_b(daysUntil);
        break;
      case 'just_ended':
        careLine = appL10n.widget_load_period_care_state_message_today_variant_b;
        cycleLine = appL10n.widget_load_period_care_state_message_period_end;
        break;
      case 'normal':
        careLine = appL10n.widget_load_period_care_state_message_today_variant_c;
        cycleLine = appL10n.widget_load_period_care_state_message_current_reminder;
        break;
      default:
        careLine = '「今天也記得好好照顧自己。」';
        cycleLine = appL10n.widget_load_period_care_state_message;
        break;
    }

    if (privacyMode) {
      return <String>[careLine];
    }

    final lines = <String>[careLine];
    if (showCycleStatus && cycleLine != null && cycleLine.isNotEmpty) {
      lines.add(cycleLine);
    }
    return lines;
  }

  static Future<List<String>> loadPeriodCareWidgetData({
    required Map<String, dynamic> settings,
  }) async {
    final state = await _loadPeriodCareState();
    return buildPeriodCareLines(
      settings: settings,
      state: state,
    );
  }

  static Future<void> refreshPeriodCareWidgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_registryPrefsKey);
      if (raw == null || raw.trim().isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final state = await _loadPeriodCareState();
      bool didUpdateAny = false;

      final String? groupId =
      Platform.isIOS ? appGroupId : null;

      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(appGroupId);
      }

      for (final item in decoded.whereType<Map>()) {
        final data = Map<String, dynamic>.from(item);

        if (data['widgetType']?.toString() != 'period_care') {
          continue;
        }

        final widgetConfigId = data['id']?.toString().trim() ?? '';
        if (widgetConfigId.isEmpty) continue;

        final settings = data['settings'] is Map
            ? Map<String, dynamic>.from(data['settings'] as Map)
            : <String, dynamic>{};

        final lines = buildPeriodCareLines(
          settings: settings,
          state: state,
        );

        for (int i = 0; i < 4; i++) {
          await HomeWidget.saveWidgetData<String>(
            _key(widgetConfigId, 'line_${i + 1}'),
            i < lines.length ? lines[i] : '',
            appGroupId: groupId,
          );
        }

        didUpdateAny = true;
      }

      if (!didUpdateAny) return;

      await HomeWidget.updateWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
        iOSName: iosWidgetKind,
      );
    } catch (error) {
      debugPrint('⚠️ Widget 即時更新生理期陪伴失敗：$error');
    }
  }


  static DateTime _anniversaryDateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime? _parseCharacterBirthday(dynamic rawBirthday) {
    if (rawBirthday == null) return null;

    if (rawBirthday is Timestamp) {
      return rawBirthday.toDate();
    }

    if (rawBirthday is DateTime) {
      return rawBirthday;
    }

    final raw = rawBirthday.toString().trim();
    if (raw.isEmpty || raw == '.' || raw == '未知' || raw == '未設定') {
      return null;
    }

    final direct = DateTime.tryParse(raw);
    if (direct != null) return direct;

    // 支援 8/17、08-17、8月17日、1998/8/17 等常見角色生日格式。
    final normalized = raw
        .replaceAll(appL10n.widget_parse_character_birthday_message, '/')
        .replaceAll(appL10n.widget_parse_character_birthday_message_variant_b, '/')
        .replaceAll('日', '')
        .replaceAll('-', '/')
        .replaceAll('.', '/');

    final parts = normalized
        .split('/')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      if (parts.length >= 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        return DateTime(year, month, day);
      }

      if (parts.length == 2) {
        final month = int.parse(parts[0]);
        final day = int.parse(parts[1]);
        return DateTime(2000, month, day);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static List<String> _buildBirthdayCountdownLines(dynamic rawBirthday) {
    final birthday = _parseCharacterBirthday(rawBirthday);
    if (birthday == null) {
      return <String>[
        appL10n.widget_build_birthday_countdown_lines_message_character_birthday,
        appL10n.widget_build_birthday_countdown_lines_message_birthday_settings,
      ];
    }

    final now = DateTime.now();
    final today = _anniversaryDateOnly(now);

    DateTime nextBirthday = DateTime(
      today.year,
      birthday.month,
      birthday.day,
    );

    if (nextBirthday.isBefore(today)) {
      nextBirthday = DateTime(
        today.year + 1,
        birthday.month,
        birthday.day,
      );
    }

    final days = nextBirthday.difference(today).inDays;
    final birthdayLabel =
        '${birthday.month}/${birthday.day}';

    return <String>[
      appL10n.widget_build_birthday_countdown_lines_message_birthday_countdown(birthdayLabel),
      days == 0 ? appL10n.widget_build_birthday_countdown_lines_message_today : appL10n.widget_build_birthday_countdown_lines_message_days(days),
    ];
  }

  static Future<List<String>> _buildRelationshipDaysLines(
      String characterId,
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || characterId.trim().isEmpty) {
      return <String>[
        appL10n.widget_build_birthday_countdown_lines_message,
        appL10n.widget_build_birthday_countdown_lines_message_variant_b,
      ];
    }

    try {
      final sessions = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc('lianlianshiguang')
          .collection('chat_sessions')
          .where('userId', isEqualTo: user.uid)
          .where('characterId', isEqualTo: characterId)
          .get();

      DateTime? firstMetAt;

      for (final doc in sessions.docs) {
        final rawCreatedAt = doc.data()['createdAt'];
        if (rawCreatedAt is! Timestamp) continue;

        final createdAt = rawCreatedAt.toDate();

        if (firstMetAt == null || createdAt.isBefore(firstMetAt)) {
          firstMetAt = createdAt;
        }
      }

      if (firstMetAt == null) {
        return const <String>[
          '和他相遇',
          '尚未有相遇紀錄',
        ];
      }

      final today = _anniversaryDateOnly(DateTime.now());
      final firstDay = _anniversaryDateOnly(firstMetAt);
      final days = today.difference(firstDay).inDays + 1;

      return <String>[
        '和他相遇',
        appL10n.widget_build_birthday_countdown_lines_message_days_variant_b(days < 1 ? 1 : days),
      ];
    } catch (error) {
      debugPrint('⚠️ Widget 讀取相遇天數失敗：$error');
      return const <String>[
        '和他相遇',
        '尚未有相遇紀錄',
      ];
    }
  }

  static List<String> _buildCustomAnniversaryLines(
      Map<String, dynamic> settings,
      ) {
    final content =
        settings['memoContent']?.toString().trim() ?? '';
    final rawDate =
        settings['memoDate']?.toString().trim() ?? '';
    final reminder =
        settings['memoReminderText']?.toString().trim() ?? '';

    final targetDate =
    rawDate.isEmpty ? null : DateTime.tryParse(rawDate);

    if (targetDate == null) {
      return <String>[
        content.isEmpty ? appL10n.widget_build_birthday_countdown_lines_message_variant_c : content,
        appL10n.widget_build_birthday_countdown_lines_message_date_select,
      ];
    }

    final today = _anniversaryDateOnly(DateTime.now());
    final eventDay = _anniversaryDateOnly(targetDate);
    final days = eventDay.difference(today).inDays;

    final countdown = days > 0
        ? '還有 $days 天'
        : days == 0
        ? '就是今天'
        : appL10n.widget_build_birthday_countdown_lines_message_elapsed_days(days.abs());

    return <String>[
      content.isEmpty ? '重要的日子' : content,
      countdown,
      if (reminder.isNotEmpty) reminder,
    ].take(4).toList();
  }

  static Future<List<String>> loadAnniversaryWidgetData({
    required String characterId,
    required Map<String, dynamic> characterData,
    required Map<String, dynamic> settings,
  }) async {
    final eventType =
        settings['eventType']?.toString() ?? 'relationship_days';

    switch (eventType) {
      case 'birthday':
        return _buildBirthdayCountdownLines(
          characterData['birthday'],
        );

      case 'custom':
        return _buildCustomAnniversaryLines(settings);

      case 'relationship_days':
      default:
        return _buildRelationshipDaysLines(characterId);
    }
  }

  static Future<void> refreshAnniversaryWidgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_registryPrefsKey);

      if (raw == null || raw.trim().isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      bool didUpdateAny = false;
      final String? groupId =
      Platform.isIOS ? appGroupId : null;

      if (Platform.isIOS) {
        await HomeWidget.setAppGroupId(appGroupId);
      }

      for (final item in decoded.whereType<Map>()) {
        final data = Map<String, dynamic>.from(item);

        if (data['widgetType']?.toString() != 'anniversary') {
          continue;
        }

        final widgetConfigId = data['id']?.toString().trim() ?? '';
        final characterId =
            data['characterId']?.toString().trim() ?? '';

        if (widgetConfigId.isEmpty || characterId.isEmpty) continue;

        final settings = data['settings'] is Map
            ? Map<String, dynamic>.from(data['settings'] as Map)
            : <String, dynamic>{};

        // Registry 目前沒有保存完整 characterData；
        // birthday 會在建立 Widget 時正確寫入。每日重新計算則先處理
        // 相遇天數與自訂倒數，避免依賴不存在的角色資料。
        final eventType =
            settings['eventType']?.toString() ?? 'relationship_days';

        List<String> lines;
        if (eventType == 'relationship_days') {
          lines = await _buildRelationshipDaysLines(characterId);
        } else if (eventType == 'custom') {
          lines = _buildCustomAnniversaryLines(settings);
        } else {
          continue;
        }

        for (int i = 0; i < 4; i++) {
          await HomeWidget.saveWidgetData<String>(
            _key(widgetConfigId, 'line_${i + 1}'),
            i < lines.length ? lines[i] : '',
            appGroupId: groupId,
          );
        }

        didUpdateAny = true;
      }

      if (!didUpdateAny) return;

      await HomeWidget.updateWidget(
        name: androidProviderName,
        androidName: androidProviderName,
        qualifiedAndroidName: androidQualifiedProviderName,
        iOSName: iosWidgetKind,
      );
    } catch (error) {
      debugPrint('⚠️ Widget 重新整理紀念日失敗：$error');
    }
  }

  static Future<void> addWidgetConfigToHomeScreen(
      String widgetConfigId,
      ) async {
    if (!Platform.isAndroid) {
      return;
    }

    // 如果桌面上的 Widget 是玩家自己誤刪，
    // App 內的設定仍然存在；重新啟用同一份 config，
    // 再交給下一顆 Launcher Widget 綁定。
    await HomeWidget.saveWidgetData<bool>(
      _key(widgetConfigId, 'disabled'),
      false,
    );

    await HomeWidget.saveWidgetData<String>(
      'widget_pending_config_id',
      widgetConfigId,
    );

    await HomeWidget.requestPinWidget(
      name: androidProviderName,
      androidName: androidProviderName,
      qualifiedAndroidName: androidQualifiedProviderName,
    );
  }

  static Future<void> disableWidgetConfig(
      String widgetConfigId,
      ) async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(appGroupId);
    }

    final String? groupId =
    Platform.isIOS ? appGroupId : null;

    await HomeWidget.saveWidgetData<bool>(
      _key(widgetConfigId, 'disabled'),
      true,
      appGroupId: groupId,
    );

    await HomeWidget.updateWidget(
      name: androidProviderName,
      androidName: androidProviderName,
      qualifiedAndroidName: androidQualifiedProviderName,
      iOSName: iosWidgetKind,
    );
  }
}
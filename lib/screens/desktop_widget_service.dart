import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

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
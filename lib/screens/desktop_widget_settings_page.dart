import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/app_constants.dart';
import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import 'desktop_widget_service.dart';
import '../services/reminder_notification_service.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';


class _SavedDesktopWidget {
  final String id;
  final String widgetType;
  final String widgetTitle;
  final String characterId;
  final String characterName;
  final String imageUrl;
  final String size;
  final String layout;
  final Map<String, dynamic> settings;
  final int createdAtMs;

  const _SavedDesktopWidget({
    required this.id,
    required this.widgetType,
    required this.widgetTitle,
    required this.characterId,
    required this.characterName,
    required this.imageUrl,
    required this.size,
    required this.layout,
    required this.settings,
    required this.createdAtMs,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'widgetType': widgetType,
    'widgetTitle': widgetTitle,
    'characterId': characterId,
    'characterName': characterName,
    'imageUrl': imageUrl,
    'size': size,
    'layout': layout,
    'settings': settings,
    'createdAtMs': createdAtMs,
  };

  factory _SavedDesktopWidget.fromJson(Map<String, dynamic> json) {
    return _SavedDesktopWidget(
      id: json['id']?.toString() ?? '',
      widgetType: json['widgetType']?.toString() ?? '',
      widgetTitle: json['widgetTitle']?.toString() ?? '',
      characterId: json['characterId']?.toString() ?? '',
      characterName: json['characterName']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      size: json['size']?.toString() ?? 'medium',
      layout: json['layout']?.toString() ?? 'full_background',
      settings: json['settings'] is Map
          ? Map<String, dynamic>.from(json['settings'])
          : <String, dynamic>{},
      createdAtMs: (json['createdAtMs'] as num?)?.toInt() ?? 0,
    );
  }
}

class _DesktopWidgetRegistry {
  static const String _prefsKey = 'desktop_widget_registry_v1';

  static Future<List<_SavedDesktopWidget>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.trim().isEmpty) {
      return const <_SavedDesktopWidget>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <_SavedDesktopWidget>[];

      return decoded
          .whereType<Map>()
          .map(
            (item) => _SavedDesktopWidget.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .where((item) => item.id.isNotEmpty)
          .toList()
        ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    } catch (_) {
      return const <_SavedDesktopWidget>[];
    }
  }

  static Future<void> add(_SavedDesktopWidget item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final updated = <_SavedDesktopWidget>[
      item,
      ...current.where((existing) => existing.id != item.id),
    ];

    await prefs.setString(
      _prefsKey,
      jsonEncode(updated.map((entry) => entry.toJson()).toList()),
    );

    await DesktopWidgetNativeService.syncIosWidgetConfigIds(
      updated.map((entry) => entry.id),
    );
  }
  static Future<void> update(_SavedDesktopWidget item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final updated = current
        .map((existing) => existing.id == item.id ? item : existing)
        .toList();

    await prefs.setString(
      _prefsKey,
      jsonEncode(updated.map((entry) => entry.toJson()).toList()),
    );

    await DesktopWidgetNativeService.syncIosWidgetConfigIds(
      updated.map((entry) => entry.id),
    );
  }

  static Future<void> remove(String widgetId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final updated = current
        .where((item) => item.id != widgetId)
        .toList();

    await prefs.setString(
      _prefsKey,
      jsonEncode(updated.map((entry) => entry.toJson()).toList()),
    );

    await DesktopWidgetNativeService.syncIosWidgetConfigIds(
      updated.map((entry) => entry.id),
    );
  }

}

class _DesktopWidgetPhotoOption {
  final String imageUrl;
  final String description;
  final int requiredAffection;

  const _DesktopWidgetPhotoOption({
    required this.imageUrl,
    required this.description,
    required this.requiredAffection,
  });
}

enum DesktopWidgetType {
  latestPost,
  periodCare,
  dailyQuote,
  anniversary,
  characterStatus,
}

class DesktopWidgetTypeInfo {
  final DesktopWidgetType type;
  final String title;
  final String subtitle;
  final String iconAsset;

  const DesktopWidgetTypeInfo({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });
}

List<DesktopWidgetTypeInfo> get desktopWidgetTypes => [
  DesktopWidgetTypeInfo(
    type: DesktopWidgetType.latestPost,
    title: appL10n.widget_settings_remove_title_character_latest,
    subtitle: appL10n.widget_settings_remove_subtitle_moment_latest,
    iconAsset: 'assets/icons/icon_widget_latest_post.png',
  ),
  DesktopWidgetTypeInfo(
    type: DesktopWidgetType.periodCare,
    title: appL10n.widget_settings_remove_title_period,
    subtitle: appL10n.widget_settings_remove_subtitle_character_end,
    iconAsset: 'assets/icons/icon_widget_period_companion.png',
  ),
  DesktopWidgetTypeInfo(
    type: DesktopWidgetType.dailyQuote,
    title: appL10n.widget_settings_remove_title,
    subtitle: appL10n.widget_settings_remove_subtitle_days,
    iconAsset: 'assets/icons/icon_widget_daily_quote.png',
  ),
  DesktopWidgetTypeInfo(
    type: DesktopWidgetType.anniversary,
    title: appL10n.widget_settings_remove_title_reminder,
    subtitle: appL10n.widget_settings_remove_subtitle_character_birthday_reminder,
    iconAsset: 'assets/icons/icon_widget_anniversary.png',
  ),
  DesktopWidgetTypeInfo(
    type: DesktopWidgetType.characterStatus,
    title: appL10n.widget_settings_remove_title_character,
    subtitle: appL10n.widget_settings_remove_subtitle_chat_latest_mood,
    iconAsset: 'assets/icons/icon_widget_character_status.png',
  ),
];


DesktopWidgetTypeInfo? _desktopWidgetInfoFromNativeType(String nativeType) {
  switch (nativeType) {
    case 'character_post':
      return desktopWidgetTypes.firstWhere(
            (item) => item.type == DesktopWidgetType.latestPost,
      );
    case 'period_care':
      return desktopWidgetTypes.firstWhere(
            (item) => item.type == DesktopWidgetType.periodCare,
      );
    case 'daily_quote':
      return desktopWidgetTypes.firstWhere(
            (item) => item.type == DesktopWidgetType.dailyQuote,
      );
    case 'anniversary':
      return desktopWidgetTypes.firstWhere(
            (item) => item.type == DesktopWidgetType.anniversary,
      );
    case 'character_status':
      return desktopWidgetTypes.firstWhere(
            (item) => item.type == DesktopWidgetType.characterStatus,
      );
    default:
      return null;
  }
}

class DesktopWidgetSettingsPage extends StatefulWidget {
  const DesktopWidgetSettingsPage({super.key});

  @override
  State<DesktopWidgetSettingsPage> createState() =>
      _DesktopWidgetSettingsPageState();
}

class _DesktopWidgetSettingsPageState
    extends State<DesktopWidgetSettingsPage> {
  bool _isLoadingWidgets = true;
  List<_SavedDesktopWidget> _savedWidgets =
  const <_SavedDesktopWidget>[];

  @override
  void initState() {
    super.initState();
    _reloadSavedWidgets();
  }

  Future<void> _reloadSavedWidgets() async {
    final items = await _DesktopWidgetRegistry.load();

    await DesktopWidgetNativeService.syncIosWidgetConfigIds(
      items.map((entry) => entry.id),
    );

    if (!mounted) return;

    setState(() {
      _savedWidgets = items;
      _isLoadingWidgets = false;
    });
  }

  String _sizeLabel(String size) {
    switch (size) {
      case 'small':
        return '小';
      case 'large':
        return '大';
      default:
        return appL10n.widget_settings_size_label;
    }
  }

  Future<void> _addSavedWidgetBackToDesktop(
      _SavedDesktopWidget item,
      ) async {
    try {
      await DesktopWidgetNativeService
          .addWidgetConfigToHomeScreen(item.id);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_size_label_message_send,
        customIcon: Icons.add_to_home_screen_rounded,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '⚠️ 重新新增桌面小工具失敗：$error',
      );
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_size_label_message_try_again_later_failed,
        isError: true,
      );
    }
  }

  Future<void> _editSavedWidget(_SavedDesktopWidget item) async {
    final info = _desktopWidgetInfoFromNativeType(item.widgetType);
    if (info == null) {
      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_edit_saved_widget_message_character_reminder_again,
        isError: true,
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DesktopWidgetDisplaySettingsPage(
          info: info,
          characterId: item.characterId,
          characterData: <String, dynamic>{
            'name': item.characterName,
          },
          imageUrl: item.imageUrl,
          initialSettings: item.settings,
          editingWidgetId: item.id,
          initialSize: item.size,
          initialLayout: item.layout,
        ),
      ),
    );

    await _reloadSavedWidgets();
  }

  Future<void> _deleteSavedWidget(_SavedDesktopWidget item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(appL10n.widget_settings_delete_saved_widget_title_delete_small),
          content: Text(
            appL10n.widget_settings_delete_saved_widget_message_stop_display_long_press_home_after_delete(item.characterName, item.widgetTitle),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('刪除'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await DesktopWidgetNativeService.disableWidgetConfig(item.id);
    } catch (error) {
      debugPrint('⚠️ 停用桌面小工具失敗：$error');
    }

    await _DesktopWidgetRegistry.remove(item.id);

    if (!mounted) return;

    await _reloadSavedWidgets();

    if (!mounted) return;

    ToastUtils.showCenterToast(
      context,
      appL10n.widget_settings_delete_saved_widget_message_delete_settings_small,
      customIcon: Icons.delete_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
          title: Text(
            appL10n.widget_settings_message_desktop_widget,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.8,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: _reloadSavedWidgets,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 36),
              children: [
                Text(
                  appL10n.widget_settings_message_character_days,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 14,
                    height: 1.6,
                    color: onSurface.withValues(alpha: 0.62),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ImageIcon(
                      const AssetImage(
                        'assets/icons/icon_settings_widget.png',
                      ),
                      size: 19,
                      color: primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appL10n.widget_settings_message_small,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_isLoadingWidgets)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 34),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_savedWidgets.isEmpty)
                  Container(
                    padding:
                    const EdgeInsets.fromLTRB(18, 28, 18, 26),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha: 0.42),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.09),
                            shape: BoxShape.circle,
                          ),
                          child: ImageIcon(
                            const AssetImage(
                              'assets/icons/icon_settings_widget.png',
                            ),
                            size: 30,
                            color: primary.withValues(alpha: 0.78),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          appL10n.widget_settings_message_desktop_widget_variant_b,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          appL10n.widget_settings_message_character_reminder,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 12.5,
                            height: 1.55,
                            color:
                            onSurface.withValues(alpha: 0.52),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ..._savedWidgets.map(
                        (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 96,
                        ),
                        decoration: BoxDecoration(
                          color:
                          theme.cardColor.withValues(alpha: 0.48),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color:
                            primary.withValues(alpha: 0.14),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 82,
                              height: 100,
                              child: item.imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                fit: BoxFit.cover,
                                alignment:
                                const Alignment(0, -0.12),
                                errorWidget: (_, __, ___) =>
                                    Container(
                                      color: theme.colorScheme
                                          .secondaryContainer,
                                      child: const Icon(
                                        Icons.person_rounded,
                                      ),
                                    ),
                              )
                                  : Container(
                                color: theme.colorScheme
                                    .secondaryContainer,
                                child: const Icon(
                                  Icons.person_rounded,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.characterName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                      GoogleFonts.notoSerifTc(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.widgetTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                      GoogleFonts.notoSerifTc(
                                        fontSize: 12,
                                        color: onSurface.withValues(
                                          alpha: 0.58,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      appL10n.widget_settings_message_size(_sizeLabel(item.size)),
                                      style:
                                      GoogleFonts.notoSerifTc(
                                        fontSize: 11,
                                        color: primary.withValues(
                                          alpha: 0.78,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: appL10n.widget_settings_tooltip,
                                    onPressed: () =>
                                        _addSavedWidgetBackToDesktop(item),
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      Icons.add_rounded,
                                      size: 22,
                                      color: primary.withValues(alpha: 0.86),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: appL10n.widget_settings_tooltip_small,
                                    onPressed: () => _editSavedWidget(item),
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      size: 20,
                                      color: primary.withValues(alpha: 0.78),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: appL10n.widget_settings_tooltip_delete_small,
                                    onPressed: () => _deleteSavedWidget(item),
                                    visualDensity: VisualDensity.compact,
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 20,
                                      color: theme.colorScheme.error
                                          .withValues(alpha: 0.82),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const DesktopWidgetTypeSelectionPage(),
                        ),
                      );
                      await _reloadSavedWidgets();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      appL10n.widget_settings_message_desktop_widget_variant_c,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: primary.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: primary.withValues(alpha: 0.75),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          appL10n.widget_settings_message_character_photo_content_select_small,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 12.5,
                            height: 1.55,
                            color:
                            onSurface.withValues(alpha: 0.58),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DesktopWidgetTypeSelectionPage extends StatelessWidget {
  const DesktopWidgetTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
          title: Text(
            appL10n.widget_settings_desktop_type_selection_message_select_small,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.6,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
            children: [
              Text(
                appL10n.widget_settings_desktop_type_selection_message_select,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13.5,
                  height: 1.5,
                  color: onSurface.withValues(alpha: 0.58),
                ),
              ),
              const SizedBox(height: 18),
              ...desktopWidgetTypes.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: theme.cardColor.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DesktopWidgetSetupStartPage(info: item),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: primary.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.09),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ImageIcon(
                                AssetImage(item.iconAsset),
                                size: 25,
                                color: primary.withValues(alpha: 0.82),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      color: onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 12,
                                      height: 1.45,
                                      color: onSurface.withValues(alpha: 0.52),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: primary.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopWidgetSetupStartPage extends StatefulWidget {
  final DesktopWidgetTypeInfo info;

  const DesktopWidgetSetupStartPage({
    super.key,
    required this.info,
  });

  @override
  State<DesktopWidgetSetupStartPage> createState() =>
      _DesktopWidgetSetupStartPageState();
}

class _DesktopWidgetSetupStartPageState
    extends State<DesktopWidgetSetupStartPage> {
  final TextEditingController _searchController = TextEditingController();

  late final Stream<QuerySnapshot> _charactersStream;

  final Set<String> _blockedCharacterIds = <String>{};
  final Set<String> _blockedCreatorIds = <String>{};

  // Widget 選角只顯示「已加好友」或「曾聊過天」的角色。
  final Set<String> _friendCharacterIds = <String>{};
  final Set<String> _chattedCharacterIds = <String>{};

  StreamSubscription<QuerySnapshot>? _blockedCharactersSub;
  StreamSubscription<QuerySnapshot>? _blockedCreatorsSub;
  StreamSubscription<QuerySnapshot>? _friendsSub;
  StreamSubscription<QuerySnapshot>? _chatSessionsSub;

  String _searchQuery = '';
  String? _selectedCharacterId;
  Map<String, dynamic>? _selectedCharacterData;
  QueryDocumentSnapshot? _selectedCharacterDoc;

  @override
  void initState() {
    super.initState();

    _charactersStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters')
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .limit(200)
        .snapshots();

    _listenBlockedCharacters();
    _listenBlockedCreators();
    _listenFriends();
    _listenChattedCharacters();
  }

  void _listenBlockedCharacters() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _blockedCharactersSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('blockedCharacters')
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;
      setState(() {
        _blockedCharacterIds
          ..clear()
          ..addAll(snapshot.docs.map((doc) => doc.id));
      });
    });
  }

  void _listenBlockedCreators() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _blockedCreatorsSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('blockedCreators')
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;
      setState(() {
        _blockedCreatorIds
          ..clear()
          ..addAll(snapshot.docs.map((doc) => doc.id));
      });
    });
  }


  void _listenFriends() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _friendsSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .snapshots()
        .listen(
          (snapshot) {
        if (!mounted) return;

        setState(() {
          _friendCharacterIds
            ..clear()
            ..addAll(
              snapshot.docs.map((doc) {
                final data = doc.data();
                final characterId =
                    data['characterId']?.toString().trim() ?? '';

                return characterId.isNotEmpty
                    ? characterId
                    : doc.id;
              }),
            );
        });
      },
      onError: (error) {
        debugPrint('❌ Widget 讀取好友角色失敗：$error');
      },
    );
  }

  void _listenChattedCharacters() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _chatSessionsSub = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('chat_sessions')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen(
          (snapshot) {
        if (!mounted) return;

        setState(() {
          _chattedCharacterIds
            ..clear()
            ..addAll(
              snapshot.docs
                  .map(
                    (doc) =>
                doc.data()['characterId']
                    ?.toString()
                    .trim() ??
                    '',
              )
                  .where((id) => id.isNotEmpty),
            );
        });
      },
      onError: (error) {
        debugPrint('❌ Widget 讀取聊天角色失敗：$error');
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _blockedCharactersSub?.cancel();
    _blockedCreatorsSub?.cancel();
    _friendsSub?.cancel();
    _chatSessionsSub?.cancel();
    super.dispose();
  }

  List<QueryDocumentSnapshot> _filteredCharacters(
      QuerySnapshot snapshot,
      ) {
    final keyword = _searchQuery.trim().toLowerCase();

    final docs = snapshot.docs.where((doc) {
      if (_blockedCharacterIds.contains(doc.id)) {
        return false;
      }

      final isEligible =
          _friendCharacterIds.contains(doc.id) ||
              _chattedCharacterIds.contains(doc.id);

      if (!isEligible) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;
      final creatorId = data['createdBy']?.toString().trim() ?? '';

      if (creatorId.isNotEmpty &&
          _blockedCreatorIds.contains(creatorId)) {
        return false;
      }

      if (keyword.isEmpty) {
        return true;
      }

      final name =
          data['name']?.toString().toLowerCase() ?? '';
      final creatorName =
          data['creatorName']?.toString().toLowerCase() ?? '';
      final occupation =
          data['occupation']?.toString().toLowerCase() ?? '';

      return name.contains(keyword) ||
          creatorName.contains(keyword) ||
          occupation.contains(keyword);
    }).cast<QueryDocumentSnapshot>().toList();

    if (keyword.isEmpty) {
      docs.sort((a, b) {
        final aData = a.data() as Map<String, dynamic>;
        final bData = b.data() as Map<String, dynamic>;

        final aLikes =
            int.tryParse(aData['likesCount']?.toString() ?? '') ?? 0;
        final bLikes =
            int.tryParse(bData['likesCount']?.toString() ?? '') ?? 0;

        return bLikes.compareTo(aLikes);
      });
    }

    return docs;
  }

  String _characterImageUrl(Map<String, dynamic> data) {
    return (
        data['avatar'] ??
            data['avatarPath'] ??
            ''
    ).toString().trim();
  }

  void _selectCharacter(
      QueryDocumentSnapshot doc,
      ) {
    final data = Map<String, dynamic>.from(
      doc.data() as Map<String, dynamic>,
    );

    setState(() {
      _selectedCharacterId = doc.id;
      _selectedCharacterData = data;
      _selectedCharacterDoc = doc;
    });
  }

  Future<int> _resolveCurrentAffection(String characterId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    int affection = 0;

    try {
      final globalDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('characters')
          .doc(characterId)
          .get();

      final globalValue = globalDoc.data()?['affection'];
      if (globalValue is num) {
        affection = globalValue.toInt();
      }
    } catch (error) {
      debugPrint('⚠️ Widget 讀取角色總好感失敗：$error');
    }

    try {
      final sessions = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('chat_sessions')
          .where('userId', isEqualTo: user.uid)
          .where('characterId', isEqualTo: characterId)
          .get();

      for (final doc in sessions.docs) {
        final value = doc.data()['friendshipScore'];
        final score = value is num
            ? value.toInt()
            : int.tryParse(value?.toString() ?? '') ?? 0;

        if (score > affection) {
          affection = score;
        }
      }
    } catch (error) {
      debugPrint('⚠️ Widget 讀取聊天室好感失敗：$error');
    }

    return affection;
  }

  Future<List<CharacterPhoto>> _loadAffectionPhotos(
      Character character,
      String characterId,
      ) async {
    final existing = character.gallery;

    if (existing != null && existing.isNotEmpty) {
      return List<CharacterPhoto>.from(existing);
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId)
          .collection('photos')
          .orderBy('req', descending: false)
          .get();

      return Future.wait(
        snapshot.docs.map((doc) async {
          final photo = CharacterPhoto.fromMap(doc.data());

          if (photo.imageUrl.startsWith('gs://')) {
            try {
              photo.imageUrl = await FirebaseStorage.instance
                  .refFromURL(photo.imageUrl)
                  .getDownloadURL();
            } catch (error) {
              debugPrint('⚠️ Widget 轉換角色照片網址失敗：$error');
            }
          }

          return photo;
        }),
      );
    } catch (error) {
      debugPrint('⚠️ Widget 讀取好感相簿失敗：$error');
      return const <CharacterPhoto>[];
    }
  }

  Future<void> _goToPhotoStep() async {
    final characterId = _selectedCharacterId;
    final characterData = _selectedCharacterData;
    final characterDoc = _selectedCharacterDoc;

    if (characterId == null ||
        characterData == null ||
        characterDoc == null) {
      return;
    }

    try {
      final character =
      await Character.fromFirestoreAsync(characterDoc);

      final currentAffection =
      await _resolveCurrentAffection(characterId);

      final formalPhotos =
      await _loadAffectionPhotos(character, characterId);

      if (!mounted) return;

      final options = <_DesktopWidgetPhotoOption>[];

      for (final photo in formalPhotos) {
        final url = photo.imageUrl.trim();
        if (url.isEmpty ||
            options.any((item) => item.imageUrl == url)) {
          continue;
        }

        options.add(
          _DesktopWidgetPhotoOption(
            imageUrl: url,
            description: photo.description,
            requiredAffection: photo.requiredAffection,
          ),
        );
      }

      // 若正式相簿沒有舊版 galleryPaths，保留第一張做相容；
      // 沒有解鎖門檻資料的舊照片不再硬塞「永遠鎖定」狀態。
      if (options.isEmpty) {
        for (final path in character.galleryPaths) {
          final url = path.trim();
          if (url.isEmpty ||
              options.any((item) => item.imageUrl == url)) {
            continue;
          }

          options.add(
            _DesktopWidgetPhotoOption(
              imageUrl: url,
              description: '',
              requiredAffection: 0,
            ),
          );
        }
      }

      final avatarUrl = character.avatarPath.trim();
      if (avatarUrl.isNotEmpty &&
          !options.any((item) => item.imageUrl == avatarUrl)) {
        options.insert(
          0,
          _DesktopWidgetPhotoOption(
            imageUrl: avatarUrl,
            description: '',
            requiredAffection: 0,
          ),
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DesktopWidgetPhotoSelectionPage(
            info: widget.info,
            characterId: characterId,
            characterData: characterData,
            photos: options,
            currentAffection: currentAffection,
          ),
        ),
      );
    } catch (error) {
      debugPrint('❌ 讀取角色照片失敗：$error');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_go_to_photo_step_message_try_again_later_failed_load_character_photo,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
          title: Text(
            widget.info.title,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  12,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '1',
                              style: GoogleFonts.notoSerifTc(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appL10n.widget_settings_message_character_select,
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w600,
                                    color: onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  appL10n.widget_settings_message_character_friend_days,
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 12,
                                    color: onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: onSurface),
                      decoration: InputDecoration(
                        hintText: appL10n.widget_settings_hint_character_search,
                        hintStyle: TextStyle(
                          color: onSurface.withValues(alpha: 0.45),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: primary,
                        ),
                        suffixIcon: _searchQuery.isEmpty
                            ? null
                            : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon:
                          const Icon(Icons.close_rounded),
                        ),
                        filled: true,
                        fillColor: theme.cardColor.withValues(
                          alpha: isDark ? 0.60 : 0.42,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(
                            color: primary.withValues(alpha: 0.12),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(
                            color: primary.withValues(alpha: 0.10),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim();
                        });
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _charactersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          appL10n.widget_settings_message_try_again_later_failed_load_character,
                          style: GoogleFonts.notoSerifTc(
                            color:
                            onSurface.withValues(alpha: 0.62),
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final docs =
                    _filteredCharacters(snapshot.data!);

                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          appL10n.widget_settings_message_current_character_chat_friend_add,
                          style: GoogleFonts.notoSerifTc(
                            color:
                            onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        4,
                        18,
                        14,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.80,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data =
                        doc.data() as Map<String, dynamic>;
                        final selected =
                            _selectedCharacterId == doc.id;
                        final imageUrl =
                        _characterImageUrl(data);

                        return GestureDetector(
                          onTap: () =>
                              _selectCharacter(doc),
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 160),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? primary
                                    : primary.withValues(
                                  alpha: 0.12,
                                ),
                                width: selected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 9,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(19),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  if (imageUrl.isNotEmpty)
                                    CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      alignment:
                                      const Alignment(0, -0.15),
                                      memCacheWidth: 720,
                                      placeholder: (_, __) =>
                                          Container(
                                            color: theme.colorScheme
                                                .secondaryContainer,
                                          ),
                                      errorWidget:
                                          (_, __, ___) =>
                                          _imageFallback(
                                            theme,
                                          ),
                                    )
                                  else
                                    _imageFallback(theme),

                                  Align(
                                    alignment:
                                    Alignment.bottomCenter,
                                    child: Container(
                                      height: 95,
                                      decoration:
                                      BoxDecoration(
                                        gradient:
                                        LinearGradient(
                                          begin: Alignment
                                              .bottomCenter,
                                          end: Alignment
                                              .topCenter,
                                          colors: [
                                            Colors.black
                                                .withValues(
                                              alpha: 0.78,
                                            ),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    left: 12,
                                    right: 12,
                                    bottom: 11,
                                    child: Text(
                                      data['name']
                                          ?.toString() ??
                                          '',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style:
                                      GoogleFonts.notoSerifTc(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.w600,
                                        shadows: const [
                                          Shadow(
                                            color:
                                            Colors.black54,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  if (selected)
                                    Positioned(
                                      top: 9,
                                      right: 9,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration:
                                        BoxDecoration(
                                          color: primary,
                                          shape:
                                          BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: theme
                                              .colorScheme
                                              .onPrimary,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: _selectedCharacterId == null
                          ? null
                          : _goToPhotoStep,
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor:
                        theme.colorScheme.onPrimary,
                        disabledBackgroundColor:
                        primary.withValues(alpha: 0.20),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        appL10n.widget_settings_message_character_photo_select,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageFallback(ThemeData theme) {
    return Container(
      color: theme.colorScheme.secondaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: 52,
        color: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}

class DesktopWidgetPhotoSelectionPage extends StatefulWidget {
  final DesktopWidgetTypeInfo info;
  final String characterId;
  final Map<String, dynamic> characterData;
  final List<_DesktopWidgetPhotoOption> photos;
  final int currentAffection;

  const DesktopWidgetPhotoSelectionPage({
    super.key,
    required this.info,
    required this.characterId,
    required this.characterData,
    required this.photos,
    required this.currentAffection,
  });

  @override
  State<DesktopWidgetPhotoSelectionPage> createState() =>
      _DesktopWidgetPhotoSelectionPageState();
}

class _DesktopWidgetPhotoSelectionPageState
    extends State<DesktopWidgetPhotoSelectionPage> {
  int _selectedPhotoIndex = 0;

  @override
  void initState() {
    super.initState();

    final firstUnlockedIndex = widget.photos.indexWhere(
          (photo) =>
      widget.currentAffection >= photo.requiredAffection,
    );

    if (firstUnlockedIndex >= 0) {
      _selectedPhotoIndex = firstUnlockedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    final characterName =
        widget.characterData['name']?.toString() ?? '';

    final photos = widget.photos;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
          title: Text(
            appL10n.widget_settings_desktop_photo_selection_message_character_photo_select,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.fromLTRB(22, 8, 22, 14),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        style: GoogleFonts.notoSerifTc(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            characterName,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appL10n.widget_settings_desktop_photo_selection_message_current_affection_unlocked_photo(widget.currentAffection),
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12,
                              color: onSurface.withValues(
                                alpha: 0.52,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: photos.isEmpty
                    ? Center(
                  child: Text(
                    appL10n.widget_settings_desktop_photo_selection_message_current_character_photo,
                    style: GoogleFonts.notoSerifTc(
                      color: onSurface.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                )
                    : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    4,
                    18,
                    18,
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.76,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    final imageUrl = photo.imageUrl;
                    final isLocked =
                        widget.currentAffection <
                            photo.requiredAffection;
                    final selected =
                        !isLocked &&
                            _selectedPhotoIndex == index;

                    return GestureDetector(
                      onTap: isLocked
                          ? () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              appL10n.widget_settings_desktop_photo_selection_message_required_affection_unlock_photo(photo.requiredAffection),
                            ),
                          ),
                        );
                      }
                          : () {
                        setState(() {
                          _selectedPhotoIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration:
                        const Duration(milliseconds: 160),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? primary
                                : primary.withValues(
                              alpha: 0.13,
                            ),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(19),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                alignment:
                                const Alignment(0, -0.12),
                                placeholder: (_, __) =>
                                    Container(
                                      color: theme.colorScheme
                                          .secondaryContainer,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    ),
                                errorWidget: (_, __, ___) =>
                                    Container(
                                      color: theme.colorScheme
                                          .secondaryContainer,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.person_rounded,
                                        size: 52,
                                        color: theme.colorScheme
                                            .onSecondaryContainer,
                                      ),
                                    ),
                              ),
                              Align(
                                alignment:
                                Alignment.bottomCenter,
                                child: Container(
                                  height: 78,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(
                                          alpha: 0.65,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 9,
                                child: Text(
                                  photo.requiredAffection <= 0
                                      ? appL10n.widget_settings_message_photo_public
                                      : isLocked
                                      ? appL10n.widget_settings_message_unlock(photo.requiredAffection)
                                      : appL10n.widget_settings_message_unlocked(photo.requiredAffection),
                                  style:
                                  GoogleFonts.notoSerifTc(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                    fontWeight:
                                    FontWeight.w600,
                                    shadows: const [
                                      Shadow(
                                        color:
                                        Colors.black54,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (selected)
                                Positioned(
                                  top: 9,
                                  right: 9,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration:
                                    BoxDecoration(
                                      color: primary,
                                      shape:
                                      BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: theme
                                          .colorScheme
                                          .onPrimary,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              if (isLocked) ...[
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black
                                        .withValues(
                                      alpha: 0.52,
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (photos.isNotEmpty)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: () {
                          final selectedPhoto =
                          photos[_selectedPhotoIndex];

                          if (widget.currentAffection <
                              selectedPhoto.requiredAffection) {
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DesktopWidgetDisplaySettingsPage(
                                    info: widget.info,
                                    characterId:
                                    widget.characterId,
                                    characterData:
                                    widget.characterData,
                                    imageUrl:
                                    selectedPhoto.imageUrl,
                                  ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor:
                          theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          appL10n.widget_settings_message_content_settings,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopWidgetDisplaySettingsPage extends StatefulWidget {
  final DesktopWidgetTypeInfo info;
  final String characterId;
  final Map<String, dynamic> characterData;
  final String imageUrl;
  final Map<String, dynamic>? initialSettings;
  final String? editingWidgetId;
  final String? initialSize;
  final String? initialLayout;

  const DesktopWidgetDisplaySettingsPage({
    super.key,
    required this.info,
    required this.characterId,
    required this.characterData,
    required this.imageUrl,
    this.initialSettings,
    this.editingWidgetId,
    this.initialSize,
    this.initialLayout,
  });

  @override
  State<DesktopWidgetDisplaySettingsPage> createState() =>
      _DesktopWidgetDisplaySettingsPageState();
}

class _DesktopWidgetDisplaySettingsPageState
    extends State<DesktopWidgetDisplaySettingsPage> {
  bool _postShowImage = true;
  bool _postShowLikes = true;
  bool _postShowComments = true;

  bool _periodPrivacyMode = true;
  bool _periodShowCycleStatus = false;

  bool _dailyQuoteShowTime = true;
  String _dailyQuoteRefreshMode = 'daily';

  String _anniversaryEventType = 'relationship_days';
  String? _selectedMemoId;
  String? _selectedMemoContent;
  DateTime? _selectedMemoDate;
  String? _selectedMemoPersonalityType;
  String? _selectedMemoReminderText;

  final Set<String> _statusFields = <String>{
    'mood',
    'currentState',
    'location',
  };

  @override
  void initState() {
    super.initState();

    final settings = widget.initialSettings;
    if (settings == null || settings.isEmpty) return;

    switch (widget.info.type) {
      case DesktopWidgetType.latestPost:
        _postShowImage = settings['showImage'] != false;
        _postShowLikes = settings['showLikes'] != false;
        _postShowComments = settings['showComments'] != false;
        break;
      case DesktopWidgetType.periodCare:
        _periodPrivacyMode = settings['privacyMode'] != false;
        _periodShowCycleStatus = settings['showCycleStatus'] == true;
        break;
      case DesktopWidgetType.dailyQuote:
        _dailyQuoteShowTime = settings['showTime'] != false;
        _dailyQuoteRefreshMode =
            settings['refreshMode']?.toString() ?? 'daily';
        break;
      case DesktopWidgetType.anniversary:
        _anniversaryEventType =
            settings['eventType']?.toString() ?? 'relationship_days';
        _selectedMemoId = settings['memoId']?.toString();
        _selectedMemoContent = settings['memoContent']?.toString();
        _selectedMemoPersonalityType =
            settings['memoPersonalityType']?.toString();
        _selectedMemoReminderText =
            settings['memoReminderText']?.toString();
        final rawDate = settings['memoDate']?.toString();
        if (rawDate != null && rawDate.isNotEmpty) {
          _selectedMemoDate = DateTime.tryParse(rawDate);
        }
        break;
      case DesktopWidgetType.characterStatus:
        final rawFields = settings['fields'];
        if (rawFields is List && rawFields.isNotEmpty) {
          _statusFields
            ..clear()
            ..addAll(rawFields.map((e) => e.toString()));
        }
        break;
    }
  }

  Map<String, dynamic> _buildSettings() {
    switch (widget.info.type) {
      case DesktopWidgetType.latestPost:
        return {
          'showImage': _postShowImage,
          'showLikes': _postShowLikes,
          'showComments': _postShowComments,
        };
      case DesktopWidgetType.periodCare:
        return {
          'privacyMode': _periodPrivacyMode,
          'showCycleStatus': _periodShowCycleStatus,
        };
      case DesktopWidgetType.dailyQuote:
        return {
          'showTime': _dailyQuoteShowTime,
          'refreshMode': _dailyQuoteRefreshMode,
        };
      case DesktopWidgetType.anniversary:
        return {
          'eventType': _anniversaryEventType,
          'memoId': _selectedMemoId,
          'memoContent': _selectedMemoContent,
          'memoDate': _selectedMemoDate?.toIso8601String(),
          'memoPersonalityType': _selectedMemoPersonalityType,
          'memoReminderText': _selectedMemoReminderText,
        };
      case DesktopWidgetType.characterStatus:
        return {
          'fields': _statusFields.toList(),
        };
    }
  }

  void _openPreview() {
    if (widget.info.type == DesktopWidgetType.anniversary &&
        _anniversaryEventType == 'custom' &&
        (_selectedMemoId == null || _selectedMemoDate == null)) {
      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_open_preview_message_player_select,
        isError: true,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DesktopWidgetPreviewPage(
          info: widget.info,
          characterId: widget.characterId,
          characterData: widget.characterData,
          imageUrl: widget.imageUrl,
          settings: _buildSettings(),
          editingWidgetId: widget.editingWidgetId,
          initialSize: widget.initialSize,
          initialLayout: widget.initialLayout,
        ),
      ),
    );
  }

  Future<void> _pickCustomMemoEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_pick_custom_memo_event_message_login_account,
        isError: true,
      );
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('characters')
          .doc(widget.characterId)
          .collection('memos')
          .orderBy('reminderDate', descending: false)
          .get();

      if (!mounted) return;

      final events = snapshot.docs.map((doc) {
        final data = doc.data();
        final rawDate = data['reminderDate'];
        final reminderDate =
        rawDate is Timestamp ? rawDate.toDate() : null;

        return <String, dynamic>{
          'id': doc.id,
          'content': data['content']?.toString().trim() ?? '',
          'reminderDate': reminderDate,
          'personalityType':
          data['reminderPersonalityType']?.toString().trim() ?? '',
        };
      }).where((event) {
        return (event['content'] as String).isNotEmpty &&
            event['reminderDate'] is DateTime;
      }).toList();

      if (events.isEmpty) {
        ToastUtils.showCenterToast(
          context,
          appL10n.widget_settings_pick_custom_memo_event_message_memo_current_character,
        );
        return;
      }

      final selected = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        builder: (sheetContext) {
          final theme = Theme.of(sheetContext);
          final primary = theme.colorScheme.primary;
          final onSurface = theme.colorScheme.onSurface;

          return SafeArea(
            child: FractionallySizedBox(
              heightFactor: 0.72,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_note_rounded,
                          color: primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            appL10n.widget_settings_pick_custom_memo_event_message_player_select,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: primary.withValues(alpha: 0.12),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      itemCount: events.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final date =
                        event['reminderDate'] as DateTime;
                        final content =
                        event['content'] as String;
                        final isSelected =
                            _selectedMemoId == event['id'];

                        final now = DateTime.now();
                        final today = DateTime(
                          now.year,
                          now.month,
                          now.day,
                        );
                        final eventDay = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                        final days =
                            eventDay.difference(today).inDays;

                        final countdownText = days > 0
                            ? '還有 $days 天'
                            : days == 0
                            ? '就是今天'
                            : '已過 ${days.abs()} 天';

                        return Material(
                          color: isSelected
                              ? primary.withValues(alpha: 0.10)
                              : theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () =>
                                Navigator.of(sheetContext).pop(event),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(15, 13, 13, 13),
                              child: Row(
                                children: [
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: primary.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Icons.notifications_none_rounded,
                                      color: primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          content,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}  $countdownText',
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 11.5,
                                            color: onSurface.withValues(
                                              alpha: 0.52,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (selected == null || !mounted) return;

      final selectedContent = selected['content'] as String;
      final selectedPersonality =
          selected['personalityType']?.toString() ?? '';
      final l10n = AppLocalizations.of(context)!;
      final reminderText =
      ReminderNotificationService.buildCharacterReminderBody(
        l10n: l10n,
        memoContent: selectedContent,
        personalityType: selectedPersonality,
      );

      setState(() {
        _anniversaryEventType = 'custom';
        _selectedMemoId = selected['id'] as String;
        _selectedMemoContent = selectedContent;
        _selectedMemoDate = selected['reminderDate'] as DateTime;
        _selectedMemoPersonalityType = selectedPersonality;
        _selectedMemoReminderText = reminderText;
      });
    } catch (error) {
      debugPrint('❌ 讀取玩家事件失敗：$error');

      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        appL10n.widget_settings_message_try_again_later_failed_load,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final characterName =
        widget.characterData['name']?.toString() ?? '';

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
          title: Text(
            appL10n.widget_settings_message_content_settings_variant_b,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
                  children: [
                    _StepHeader(
                      number: '3',
                      title: widget.info.title,
                      subtitle: appL10n.widget_settings_subtitle_content,
                      primary: primary,
                      onSurface: onSurface,
                    ),
                    const SizedBox(height: 18),
                    _SelectedCharacterPreview(
                      imageUrl: widget.imageUrl,
                      characterName: characterName,
                      primary: primary,
                    ),
                    const SizedBox(height: 22),
                    _buildTypeSettings(
                      theme: theme,
                      primary: primary,
                      onSurface: onSurface,
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: _openPreview,
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        appL10n.widget_settings_message_small_variant_b,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSettings({
    required ThemeData theme,
    required Color primary,
    required Color onSurface,
  }) {
    switch (widget.info.type) {
      case DesktopWidgetType.latestPost:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSectionTitle(
              title: appL10n.widget_settings_title,
              primary: primary,
            ),
            _SettingsCard(
              children: [
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(appL10n.widget_settings_title_variant_b),
                  value: _postShowImage,
                  onChanged: (value) {
                    setState(() => _postShowImage = value);
                  },
                ),
                _divider(primary),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(appL10n.widget_settings_title_variant_c),
                  value: _postShowLikes,
                  onChanged: (value) {
                    setState(() => _postShowLikes = value);
                  },
                ),
                _divider(primary),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(appL10n.widget_settings_title_comment),
                  value: _postShowComments,
                  onChanged: (value) {
                    setState(() => _postShowComments = value);
                  },
                ),
              ],
            ),
          ],
        );

      case DesktopWidgetType.periodCare:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSectionTitle(
              title: appL10n.widget_settings_title_variant_d,
              primary: primary,
            ),
            _ChoiceCard(
              selected: _periodPrivacyMode,
              icon: Icons.visibility_off_outlined,
              title: appL10n.widget_settings_title_variant_e,
              subtitle: appL10n.widget_settings_subtitle_period_character,
              onTap: () {
                setState(() {
                  _periodPrivacyMode = true;
                  _periodShowCycleStatus = false;
                });
              },
              primary: primary,
            ),
            const SizedBox(height: 10),
            _ChoiceCard(
              selected: !_periodPrivacyMode,
              icon: Icons.calendar_today_outlined,
              title: appL10n.widget_settings_title_variant_f,
              subtitle: appL10n.widget_settings_subtitle_end,
              onTap: () {
                setState(() {
                  _periodPrivacyMode = false;
                  _periodShowCycleStatus = true;
                });
              },
              primary: primary,
            ),
            if (!_periodPrivacyMode) ...[
              const SizedBox(height: 12),
              _SettingsCard(
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(appL10n.widget_settings_title_variant_g),
                    value: _periodShowCycleStatus,
                    onChanged: (value) {
                      setState(() => _periodShowCycleStatus = value);
                    },
                  ),
                ],
              ),
            ],
          ],
        );

      case DesktopWidgetType.dailyQuote:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSectionTitle(
              title: '今日一句',
              primary: primary,
            ),
            _SettingsCard(
              children: [
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(appL10n.widget_settings_title_time),
                  value: _dailyQuoteShowTime,
                  onChanged: (value) {
                    setState(() => _dailyQuoteShowTime = value);
                  },
                ),
                _divider(primary),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(appL10n.widget_settings_title_update),
                  subtitle: Text(
                    _dailyQuoteRefreshMode == 'daily'
                        ? appL10n.widget_settings_message_update_days
                        : appL10n.widget_settings_message_update,
                  ),
                  trailing: PopupMenuButton<String>(
                    initialValue: _dailyQuoteRefreshMode,
                    onSelected: (value) {
                      setState(() => _dailyQuoteRefreshMode = value);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'daily',
                        child: Text('每天更新一次'),
                      ),
                      PopupMenuItem(
                        value: 'app_open',
                        child: Text(appL10n.widget_settings_text_update),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

      case DesktopWidgetType.anniversary:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSectionTitle(
              title: appL10n.widget_settings_title_content,
              primary: primary,
            ),
            _ChoiceCard(
              selected:
              _anniversaryEventType == 'relationship_days',
              icon: Icons.favorite_border_rounded,
              title: appL10n.widget_settings_title_days,
              subtitle: appL10n.widget_settings_subtitle_character_today_days,
              onTap: () {
                setState(() {
                  _anniversaryEventType = 'relationship_days';
                });
              },
              primary: primary,
            ),
            const SizedBox(height: 10),
            _ChoiceCard(
              selected: _anniversaryEventType == 'birthday',
              icon: Icons.cake_outlined,
              title: '角色生日',
              subtitle: appL10n.widget_settings_subtitle_character_birthday,
              onTap: () {
                setState(() {
                  _anniversaryEventType = 'birthday';
                });
              },
              primary: primary,
            ),
            const SizedBox(height: 10),
            _ChoiceCard(
              selected: _anniversaryEventType == 'custom',
              icon: Icons.event_note_outlined,
              title: appL10n.widget_settings_title_player,
              subtitle: _selectedMemoContent == null
                  ? appL10n.widget_settings_message_memo_character_select_reminder
                  : appL10n.widget_settings_message_selected(_selectedMemoContent ?? ''),
              onTap: _pickCustomMemoEvent,
              primary: primary,
            ),
            if (_anniversaryEventType == 'custom' &&
                _selectedMemoDate != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.14),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: primary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${_selectedMemoDate!.year}/${_selectedMemoDate!.month.toString().padLeft(2, '0')}/${_selectedMemoDate!.day.toString().padLeft(2, '0')}',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _pickCustomMemoEvent,
                      child: const Text('更換'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      case DesktopWidgetType.characterStatus:
        const options = <String, String>{
          'mood': '心情',
          'currentState': '當前狀態',
          'location': '地點',
          'relationship': '關係',
          'outfit': '衣著',
          'weather': '天氣',
          'thought': '想法',
          'action': '動作',
          'affinity': '好感度',
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSectionTitle(
              title: '角色狀態',
              primary: primary,
            ),
            Text(
              appL10n.widget_settings_message_select,
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                color: onSurface.withValues(alpha: 0.50),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: options.entries.map((entry) {
                final selected = _statusFields.contains(entry.key);

                return FilterChip(
                  selected: selected,
                  label: Text(entry.value),
                  onSelected: (value) {
                    if (value) {
                      if (_statusFields.length >= 3) {
                        ToastUtils.showCenterToast(
                          context,
                          appL10n.widget_settings_message_character,
                        );
                        return;
                      }

                      setState(() => _statusFields.add(entry.key));
                    } else {
                      if (_statusFields.length <= 1) return;
                      setState(() => _statusFields.remove(entry.key));
                    }
                  },
                  selectedColor: primary.withValues(alpha: 0.16),
                  checkmarkColor: primary,
                  side: BorderSide(
                    color: selected
                        ? primary.withValues(alpha: 0.52)
                        : primary.withValues(alpha: 0.15),
                  ),
                );
              }).toList(),
            ),
          ],
        );
    }
  }

  Widget _divider(Color primary) {
    return Divider(
      height: 1,
      color: primary.withValues(alpha: 0.12),
    );
  }
}

class DesktopWidgetPreviewPage extends StatefulWidget {
  final DesktopWidgetTypeInfo info;
  final String characterId;
  final Map<String, dynamic> characterData;
  final String imageUrl;
  final Map<String, dynamic> settings;
  final String? editingWidgetId;
  final String? initialSize;
  final String? initialLayout;

  const DesktopWidgetPreviewPage({
    super.key,
    required this.info,
    required this.characterId,
    required this.characterData,
    required this.imageUrl,
    required this.settings,
    this.editingWidgetId,
    this.initialSize,
    this.initialLayout,
  });

  @override
  State<DesktopWidgetPreviewPage> createState() =>
      _DesktopWidgetPreviewPageState();
}

class _DesktopWidgetPreviewPageState
    extends State<DesktopWidgetPreviewPage> {
  String _size = 'medium';
  String _layout = 'full_background';
  double _imageFocusX = 0.5;
  double _imageFocusY = 0.05;
  double _imageScale = 1.0;
  bool _isAddingToHomeScreen = false;

  @override
  void initState() {
    super.initState();
    _size = widget.initialSize ?? 'medium';
    _layout = widget.initialLayout ?? 'full_background';

    final storedFocusX = widget.settings['imageFocusX'];
    final storedFocusY = widget.settings['imageFocusY'];

    _imageFocusX = storedFocusX is num
        ? storedFocusX.toDouble().clamp(0.0, 1.0)
        : 0.5;

    _imageFocusY = storedFocusY is num
        ? storedFocusY.toDouble().clamp(0.0, 1.0)
        : _defaultFocusYForSize(_size);

    final storedScale = widget.settings['imageScale'];
    _imageScale = storedScale is num
        ? storedScale.toDouble().clamp(1.0, 3.0)
        : 1.0;
  }

  double _defaultFocusYForSize(String size) {
    switch (size) {
      case 'small':
        return 0.03;
      case 'large':
        return 0.33;
      case 'medium':
      default:
        return 0.05;
    }
  }

  void _resetImageFocus() {
    setState(() {
      _imageFocusX = 0.5;
      _imageFocusY = _defaultFocusYForSize(_size);
      _imageScale = 1.0;
    });
  }

  String get _nativeWidgetType {
    switch (widget.info.type) {
      case DesktopWidgetType.latestPost:
        return 'character_post';
      case DesktopWidgetType.periodCare:
        return 'period_care';
      case DesktopWidgetType.dailyQuote:
        return 'daily_quote';
      case DesktopWidgetType.anniversary:
        return 'anniversary';
      case DesktopWidgetType.characterStatus:
        return 'character_status';
    }
  }

  Future<void> _addToHomeScreen() async {
    if (_isAddingToHomeScreen) return;

    setState(() => _isAddingToHomeScreen = true);

    try {
      final characterName =
          widget.characterData['name']?.toString().trim() ?? '';

      final widgetConfigId = widget.editingWidgetId ??
          '${DateTime.now().microsecondsSinceEpoch}_${widget.characterId}';

      final effectiveSettings = <String, dynamic>{
        ...widget.settings,
        'imageFocusX': _imageFocusX,
        'imageFocusY': _imageFocusY,
        'imageScale': _imageScale,
      };

      List<String> displayLines;
      String displayImageUrl = widget.imageUrl;

      if (widget.info.type == DesktopWidgetType.characterStatus) {
        displayLines =
        await DesktopWidgetNativeService.loadCharacterStatusLines(
          characterId: widget.characterId,
          settings: widget.settings,
        );
      } else if (widget.info.type == DesktopWidgetType.latestPost) {
        final latestPost =
        await DesktopWidgetNativeService.loadLatestPostWidgetData(
          characterId: widget.characterId,
          settings: widget.settings,
          fallbackImageUrl: widget.imageUrl,
        );

        final rawLines = latestPost['lines'];
        displayLines = rawLines is List
            ? rawLines.map((e) => e.toString()).toList()
            : const <String>['目前還沒有角色動態'];

        displayImageUrl =
            latestPost['imageUrl']?.toString().trim() ?? widget.imageUrl;
      } else if (widget.info.type == DesktopWidgetType.dailyQuote) {
        displayLines =
        await DesktopWidgetNativeService.loadDailyQuoteWidgetData(
          characterId: widget.characterId,
          settings: widget.settings,
        );
      } else if (widget.info.type == DesktopWidgetType.periodCare) {
        displayLines =
        await DesktopWidgetNativeService.loadPeriodCareWidgetData(
          settings: widget.settings,
        );
      } else if (widget.info.type == DesktopWidgetType.anniversary) {
        displayLines =
        await DesktopWidgetNativeService.loadAnniversaryWidgetData(
          characterId: widget.characterId,
          characterData: widget.characterData,
          settings: widget.settings,
        );
      } else {
        displayLines = _sampleLines();
      }

      await DesktopWidgetNativeService.saveAndRefresh(
        widgetConfigId: widgetConfigId,
        widgetType: _nativeWidgetType,
        characterId: widget.characterId,
        characterName: characterName,
        imageUrl: displayImageUrl,
        size: _size,
        layout: _layout,
        settings: effectiveSettings,
        imageFocusX: _imageFocusX,
        imageFocusY: _imageFocusY,
        imageScale: _imageScale,
        displayLines: displayLines,
        requestPin: widget.editingWidgetId == null,
      );

      if (!mounted) return;

      final savedItem = _SavedDesktopWidget(
        id: widgetConfigId,
        widgetType: _nativeWidgetType,
        widgetTitle: widget.info.title,
        characterId: widget.characterId,
        characterName: characterName,
        imageUrl: widget.imageUrl,
        size: _size,
        layout: _layout,
        settings: effectiveSettings,
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
      );

      if (widget.editingWidgetId == null) {
        await _DesktopWidgetRegistry.add(savedItem);
      } else {
        await _DesktopWidgetRegistry.update(savedItem);
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const DesktopWidgetSettingsPage(),
        ),
            (route) => route.isFirst,
      );
    } catch (error) {
      debugPrint('❌ 加入桌面小工具失敗：$error');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '加入桌面小工具失敗：$error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isAddingToHomeScreen = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final characterName =
        widget.characterData['name']?.toString() ?? '';

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
          title: Text(
            appL10n.widget_settings_message_small_variant_c,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 26),
                  children: [
                    _StepHeader(
                      number: '4',
                      title: appL10n.widget_settings_title_confirm,
                      subtitle: appL10n.widget_settings_subtitle_large,
                      primary: primary,
                      onSurface: onSurface,
                    ),
                    const SizedBox(height: 20),
                    _buildWidgetPreview(
                      theme: theme,
                      characterName: characterName,
                    ),
                    const SizedBox(height: 20),
                    _SettingsSectionTitle(
                      title: appL10n.widget_settings_title_size,
                      primary: primary,
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        _ChoiceChipButton(
                          label: '小',
                          selected: _size == 'small',
                          onTap: () => setState(() => _size = 'small'),
                        ),
                        _ChoiceChipButton(
                          label: '中',
                          selected: _size == 'medium',
                          onTap: () => setState(() => _size = 'medium'),
                        ),
                        _ChoiceChipButton(
                          label: '大',
                          selected: _size == 'large',
                          onTap: () => setState(() => _size = 'large'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SettingsSectionTitle(
                      title: appL10n.widget_settings_title_variant_h,
                      primary: primary,
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        _ChoiceChipButton(
                          label: appL10n.widget_settings_label_photo,
                          selected: _layout == 'full_background',
                          onTap: () => setState(
                                () => _layout = 'full_background',
                          ),
                        ),
                        _ChoiceChipButton(
                          label: appL10n.widget_settings_label_character,
                          selected: _layout == 'character_card',
                          onTap: () => setState(
                                () => _layout = 'character_card',
                          ),
                        ),
                      ],
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(height: 18),
                      _SettingsSectionTitle(
                        title: '調整角色位置',
                        primary: primary,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _openImageCropEditor(
                            theme: theme,
                            characterName: characterName,
                          ),
                          icon: const Icon(Icons.crop_free_rounded),
                          label: Text(
                            '放大／拖曳調整取景',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '進入調整畫面後可雙指縮放、單指拖曳，不會再帶著整個頁面一起上下跑。',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 12,
                          height: 1.5,
                          color: onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed:
                      _isAddingToHomeScreen ? null : _addToHomeScreen,
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: _isAddingToHomeScreen
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.widgets_rounded),
                      label: Text(
                        _isAddingToHomeScreen
                            ? appL10n.widget_settings_message_sync
                            : appL10n.widget_settings_message_desktop_widget_add,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetPreview({
    required ThemeData theme,
    required String characterName,
  }) {
    final availableWidth = MediaQuery.sizeOf(context).width - 44;

    final double previewWidth;
    final double previewHeight;

    if (Platform.isIOS) {
      switch (_size) {
        case 'small':
          previewWidth =
          availableWidth > 300 ? 300 : availableWidth;
          previewHeight = previewWidth;
          break;
        case 'medium':
          previewWidth =
          availableWidth > 620 ? 620 : availableWidth;
          previewHeight = previewWidth * 0.50;
          break;
        case 'large':
          previewWidth =
          availableWidth > 520 ? 520 : availableWidth;
          previewHeight = previewWidth;
          break;
        default:
          previewWidth =
          availableWidth > 620 ? 620 : availableWidth;
          previewHeight = previewWidth * 0.50;
      }
    } else {
      previewWidth = availableWidth;
      previewHeight = switch (_size) {
        'small' => availableWidth * 0.42,
        'large' => availableWidth * 0.90,
        _ => availableWidth * 0.58,
      };
    }

    Widget preview = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: previewWidth,
      height: previewHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _layout == 'character_card'
          ? _buildCardLayout(theme, characterName)
          : _buildFullLayout(theme, characterName),
    );

    return Align(
      alignment: Alignment.center,
      child: preview,
    );
  }

  Future<void> _openImageCropEditor({
    required ThemeData theme,
    required String characterName,
  }) async {
    double tempFocusX = _imageFocusX;
    double tempFocusY = _imageFocusY;
    double tempScale = _imageScale;

    double scaleStartValue = tempScale;

    final result = await showModalBottomSheet<Map<String, double>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: false,
      isDismissible: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final editorWidth = screenWidth - 32;

            final double editorHeight = switch (_size) {
              'small' => editorWidth,
              'large' => editorWidth,
              _ => editorWidth * 0.50,
            };

            void updateFocusFromPan(DragUpdateDetails details) {
              setSheetState(() {
                final scaledWidth = editorWidth * tempScale;
                final scaledHeight = editorHeight * tempScale;

                tempFocusX = (
                    tempFocusX -
                        details.delta.dx / scaledWidth
                ).clamp(0.0, 1.0);

                tempFocusY = (
                    tempFocusY -
                        details.delta.dy / scaledHeight
                ).clamp(0.0, 1.0);
              });
            }

            void updateScaleStart(ScaleStartDetails details) {
              scaleStartValue = tempScale;
            }

            void updateScale(ScaleUpdateDetails details) {
              if (details.pointerCount < 2) return;

              setSheetState(() {
                tempScale = (
                    scaleStartValue * details.scale
                ).clamp(1.0, 3.0);
              });
            }

            return Material(
              color: theme.colorScheme.surface,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.viewInsetsOf(context).bottom + 18,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '調整角色取景',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: '重設',
                          onPressed: () {
                            setSheetState(() {
                              tempFocusX = 0.5;
                              tempFocusY = _defaultFocusYForSize(_size);
                              tempScale = 1.0;
                              scaleStartValue = 1.0;
                            });
                          },
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                    Text(
                      '單指拖曳調整上下左右位置；雙指縮放調整大小。框內看到的，就是桌面小工具會顯示的範圍。',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        height: 1.45,
                        color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.58),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: editorWidth,
                        height: editorHeight,
                        child: Listener(
                          onPointerDown: (_) {},
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,

                            // 單指拖曳：只負責上下左右移動
                            onPanUpdate: updateFocusFromPan,

                            // 雙指縮放：只在 pointerCount >= 2 時改倍率
                            onScaleStart: updateScaleStart,
                            onScaleUpdate: updateScale,

                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Transform.scale(
                                  scale: tempScale,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.imageUrl,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(
                                      (tempFocusX * 2.0) - 1.0,
                                      (tempFocusY * 2.0) - 1.0,
                                    ),
                                  ),
                                ),
                                IgnorePointer(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.80,
                                        ),
                                        width: 1.2,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.zoom_out_rounded, size: 18),
                        Expanded(
                          child: Slider(
                            value: tempScale,
                            min: 1.0,
                            max: 3.0,
                            divisions: 20,
                            onChanged: (value) {
                              setSheetState(() {
                                tempScale = value;
                                scaleStartValue = value;
                              });
                            },
                          ),
                        ),
                        const Icon(Icons.zoom_in_rounded, size: 18),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.open_with_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '位置：${(tempFocusX * 100).round()}% / ${(tempFocusY * 100).round()}%　'
                              '縮放：${tempScale.toStringAsFixed(1)}×',
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 11.5,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.56,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(
                                sheetContext,
                                <String, double>{
                                  'focusX': tempFocusX,
                                  'focusY': tempFocusY,
                                  'scale': tempScale,
                                },
                              );
                            },
                            child: const Text('套用'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !mounted) return;

    setState(() {
      _imageFocusX = result['focusX'] ?? _imageFocusX;
      _imageFocusY = result['focusY'] ?? _imageFocusY;
      _imageScale = result['scale'] ?? _imageScale;
    });
  }

  Alignment get _previewImageAlignment {
    if (!Platform.isIOS) {
      return const Alignment(0, -0.12);
    }

    return Alignment(
      (_imageFocusX * 2.0) - 1.0,
      (_imageFocusY * 2.0) - 1.0,
    );
  }

  Widget _buildFullLayout(
      ThemeData theme,
      String characterName,
      ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: Platform.isIOS ? _imageScale : 1.0,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            alignment: _previewImageAlignment,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.66),
              ],
            ),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 16,
          child: _previewText(characterName, Colors.white),
        ),
      ],
    );
  }

  Widget _buildCardLayout(
      ThemeData theme,
      String characterName,
      ) {
    return Container(
      color: theme.cardColor,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Transform.scale(
              scale: Platform.isIOS ? _imageScale : 1.0,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                alignment: _previewImageAlignment,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _previewText(
                characterName,
                theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewText(
      String characterName,
      Color textColor,
      ) {
    final lines = _sampleLines();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          characterName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            shadows: textColor == Colors.white
                ? const [
              Shadow(
                color: Colors.black45,
                blurRadius: 5,
              ),
            ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        ...lines.map(
              (line) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              line,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(
                color: textColor.withValues(alpha: 0.90),
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _sampleLines() {
    switch (widget.info.type) {
      case DesktopWidgetType.latestPost:
        return [
          '剛剛更新了動態',
          appL10n.widget_settings_sample_lines_message_today_end,
        ];

      case DesktopWidgetType.periodCare:
        final privacy =
            widget.settings['privacyMode'] as bool? ?? true;
        return privacy
            ? [appL10n.widget_settings_sample_lines_message_days]
            : [appL10n.widget_settings_sample_lines_message_period, appL10n.widget_settings_sample_lines_message_today];

      case DesktopWidgetType.dailyQuote:
        return [
          appL10n.widget_settings_sample_lines_message_today_variant_b,
          if (widget.settings['showTime'] == true) '09:18',
        ];

      case DesktopWidgetType.anniversary:
        final type =
            widget.settings['eventType']?.toString() ?? '';
        if (type == 'birthday') {
          return [appL10n.widget_settings_sample_lines_label_birthday_countdown, appL10n.widget_settings_sample_lines_label_days];
        }
        if (type == 'custom') {
          final content =
              widget.settings['memoContent']?.toString().trim() ?? '';
          final rawDate =
              widget.settings['memoDate']?.toString().trim() ?? '';

          DateTime? targetDate;
          if (rawDate.isNotEmpty) {
            targetDate = DateTime.tryParse(rawDate);
          }

          if (targetDate == null) {
            return [
              content.isEmpty ? '重要的日子' : content,
              '尚未選擇日期',
            ];
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final eventDay = DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
          );
          final days = eventDay.difference(today).inDays;

          final countdown = days > 0
              ? '還有 $days 天'
              : days == 0
              ? '就是今天'
              : '已過 ${days.abs()} 天';

          final reminder =
              widget.settings['memoReminderText']?.toString().trim() ?? '';

          return [
            content.isEmpty ? '重要的日子' : content,
            countdown,
            if (reminder.isNotEmpty) reminder,
          ];
        }
        return ['和他相遇', appL10n.widget_settings_sample_lines_label_days_variant_b];

      case DesktopWidgetType.characterStatus:
        final fields = List<String>.from(
          widget.settings['fields'] ?? const <String>[],
        );

        final samples = <String, String>{
          'mood': appL10n.widget_settings_sample_lines_message_mood,
          'currentState': appL10n.widget_settings_sample_lines_message_end,
          'location': appL10n.widget_settings_sample_lines_message,
          'relationship': appL10n.widget_settings_sample_lines_message_variant_b,
          'outfit': appL10n.widget_settings_sample_lines_message_variant_c,
          'weather': appL10n.widget_settings_sample_lines_message_days_variant_b,
          'thought': appL10n.widget_settings_sample_lines_message_variant_d,
          'action': appL10n.widget_settings_sample_lines_message_variant_e,
          'affinity': appL10n.widget_settings_sample_lines_message_affection,
        };

        return fields
            .map((key) => samples[key] ?? key)
            .toList();
    }
  }
}

class _StepHeader extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final Color primary;
  final Color onSurface;

  const _StepHeader({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: GoogleFonts.notoSerifTc(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12,
                    color: onSurface.withValues(alpha: 0.52),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedCharacterPreview extends StatelessWidget {
  final String imageUrl;
  final String characterName;
  final Color primary;

  const _SelectedCharacterPreview({
    required this.imageUrl,
    required this.characterName,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primary.withValues(alpha: 0.13),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 108,
            height: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.12),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                characterName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;
  final Color primary;

  const _SettingsSectionTitle({
    required this.title,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.notoSerifTc(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: primary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(18);

    // ListTile / SwitchListTile must paint on a Material ancestor.
    // Keep the card background on Material so ink effects stay visible.
    return Material(
      color: theme.cardColor.withValues(alpha: 0.48),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Column(children: children),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color primary;

  const _ChoiceCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Material(
      color: theme.cardColor.withValues(alpha: 0.48),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? primary.withValues(alpha: 0.62)
                  : primary.withValues(alpha: 0.13),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? primary
                    : onSurface.withValues(alpha: 0.48),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11.5,
                        height: 1.4,
                        color: onSurface.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberSelectorRow extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberSelectorRow({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed:
            value <= min ? null : () => onChanged(value - 1),
            icon: const Icon(Icons.remove_circle_outline_rounded),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed:
            value >= max ? null : () => onChanged(value + 1),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ChoiceChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) => onTap(),
      selectedColor: primary.withValues(alpha: 0.16),
      checkmarkColor: primary,
      side: BorderSide(
        color: selected
            ? primary.withValues(alpha: 0.50)
            : primary.withValues(alpha: 0.13),
      ),
    );
  }
}
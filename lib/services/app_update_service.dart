import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class AppUpdateService {
  AppUpdateService._();

  static bool _isChecking = false;
  static bool _isDialogShowing = false;

  static Future<void> checkForUpdate(
      BuildContext context, {
        bool forceCheck = false,
      }) async {
    if (_isChecking || _isDialogShowing || kIsWeb) return;

    _isChecking = true;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version.trim();

      final snapshot = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();

      if (!snapshot.exists) return;

      final data = snapshot.data() ?? <String, dynamic>{};

      final latestVersion =
          data['latestVersion']?.toString().trim() ?? '';
      final minimumVersion =
          data['minimumVersion']?.toString().trim() ?? '';

      if (latestVersion.isEmpty) return;

      final hasUpdate = _compareVersion(currentVersion, latestVersion) < 0;

      if (!hasUpdate) return;

      final isForced = minimumVersion.isNotEmpty &&
          _compareVersion(currentVersion, minimumVersion) < 0;

      final prefs = await SharedPreferences.getInstance();
      final dismissedVersion =
          prefs.getString('dismissed_update_version') ?? '';

      if (!forceCheck && !isForced && dismissedVersion == latestVersion) {
        return;
      }

      if (!context.mounted) return;

      final l10n = AppLocalizations.of(context)!;

      final androidStoreUrl =
          data['androidStoreUrl']?.toString().trim() ?? '';
      final iosStoreUrl =
          data['iosStoreUrl']?.toString().trim() ?? '';

      _isDialogShowing = true;

      await showDialog<void>(
        context: context,
        barrierDismissible: !isForced,
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);
          final primary = theme.colorScheme.primary;
          final onSurface = theme.colorScheme.onSurface;

          return PopScope(
            canPop: !isForced,
            child: AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
              contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              title: Text(
                l10n.appUpdateTitle,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              content: Text(
                '${l10n.appUpdateMessage}\n\n'
                    '${l10n.appUpdateCurrentVersion} $currentVersion　→　'
                    '${l10n.appUpdateLatestVersion} $latestVersion',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13.5,
                  height: 1.7,
                  color: onSurface.withValues(alpha: 0.72),
                ),
              ),
              actions: [
                if (!isForced)
                  TextButton(
                    onPressed: () async {
                      await prefs.setString(
                        'dismissed_update_version',
                        latestVersion,
                      );

                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: Text(
                      l10n.appUpdateLater,
                      style: GoogleFonts.notoSerifTc(
                        color: onSurface.withValues(alpha: 0.58),
                      ),
                    ),
                  ),
                FilledButton(
                  onPressed: () async {
                    final opened = await _openStore(
                      androidStoreUrl: androidStoreUrl,
                      iosStoreUrl: iosStoreUrl,
                    );

                    if (!opened && dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.appUpdateStoreOpenFailed,
                              style: GoogleFonts.notoSerifTc(),
                            ),
                          ),
                        );
                    }

                    if (!isForced && dialogContext.mounted) {
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    l10n.appUpdateGo,
                    style: GoogleFonts.notoSerifTc(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('⚠️ 檢查 App 更新失敗：$error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isChecking = false;
      _isDialogShowing = false;
    }
  }

  static int _compareVersion(String a, String b) {
    final left = _versionNumbers(a);
    final right = _versionNumbers(b);
    final maxLength = left.length > right.length ? left.length : right.length;

    for (int i = 0; i < maxLength; i++) {
      final l = i < left.length ? left[i] : 0;
      final r = i < right.length ? right[i] : 0;

      if (l < r) return -1;
      if (l > r) return 1;
    }

    return 0;
  }

  static List<int> _versionNumbers(String version) {
    final clean = version.split('+').first.split('-').first;
    return clean
        .split('.')
        .map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }

  static Future<bool> _openStore({
    required String androidStoreUrl,
    required String iosStoreUrl,
  }) async {
    String url = '';

    if (Platform.isAndroid) {
      url = androidStoreUrl.trim();

      if (url.isEmpty) {
        const packageName = 'com.yubaimo.lianlian_shiguang';
        final marketUri = Uri.parse('market://details?id=$packageName');

        if (await canLaunchUrl(marketUri)) {
          return launchUrl(
            marketUri,
            mode: LaunchMode.externalApplication,
          );
        }

        url = 'https://play.google.com/store/apps/details?id=$packageName';
      }
    } else if (Platform.isIOS) {
      url = iosStoreUrl.trim();
    }

    if (url.isEmpty) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}

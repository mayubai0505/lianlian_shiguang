import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  static const Locale _defaultLocale = Locale.fromSubtags(
    languageCode: 'zh',
    scriptCode: 'Hant',
  );

  Locale _locale = _defaultLocale;
  Locale get locale => _locale;

  int _changeVersion = 0;

  LocaleNotifier() {
    _loadLocale();
  }

  void setLocale(Locale newLocale) {
    final normalized = _normalizeLocale(newLocale);

    // 使用者主動切換語言後，讓較早啟動的非同步讀取失效，
    // 避免舊設定稍後讀完又把新語言覆蓋掉。
    _changeVersion++;
    _locale = normalized;
    notifyListeners();

    // 不阻塞 UI；完整保存 language + script。
    _saveLocale(normalized);
  }

  Locale _normalizeLocale(Locale input) {
    final languageCode = input.languageCode.toLowerCase();
    final scriptCode = input.scriptCode;
    final countryCode = input.countryCode?.toUpperCase();

    if (languageCode == 'zh') {
      // 專案的中文 ARB 使用 script-based locale：
      // app_zh_Hant.arb / app_zh_Hans.arb
      if (scriptCode?.toLowerCase() == 'hans' ||
          countryCode == 'CN' ||
          countryCode == 'SG') {
        return const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
        );
      }

      return const Locale.fromSubtags(
        languageCode: 'zh',
        scriptCode: 'Hant',
      );
    }

    return Locale(languageCode);
  }

  Future<void> _saveLocale(Locale value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('language_code', value.languageCode);

    final scriptCode = value.scriptCode;
    if (scriptCode != null && scriptCode.isNotEmpty) {
      await prefs.setString('script_code', scriptCode);
    } else {
      await prefs.remove('script_code');
    }

    // 清掉舊版 region 儲存，避免 zh_CN / zh_TW 與 Hans / Hant 混用。
    await prefs.remove('country_code');

    final localeTag = scriptCode != null && scriptCode.isNotEmpty
        ? '${value.languageCode}_$scriptCode'
        : value.languageCode;

    await prefs.setString('locale_tag', localeTag);
  }

  Future<void> _loadLocale() async {
    final loadVersion = _changeVersion;
    final prefs = await SharedPreferences.getInstance();

    final localeTag = prefs.getString('locale_tag');
    Locale loadedLocale;

    if (localeTag != null && localeTag.trim().isNotEmpty) {
      final normalizedTag = localeTag.trim().replaceAll('-', '_');
      final parts = normalizedTag.split('_');

      if (parts.length >= 2 &&
          (parts[1].toLowerCase() == 'hans' ||
              parts[1].toLowerCase() == 'hant')) {
        loadedLocale = Locale.fromSubtags(
          languageCode: parts[0],
          scriptCode: parts[1],
        );
      } else if (parts.length >= 2) {
        // 相容舊資料：zh_CN / zh_TW
        loadedLocale = Locale(parts[0], parts[1]);
      } else {
        loadedLocale = Locale(parts[0]);
      }
    } else {
      final languageCode = prefs.getString('language_code') ?? 'zh';
      final savedScriptCode = prefs.getString('script_code');
      final savedCountryCode = prefs.getString('country_code');

      if (languageCode.toLowerCase() == 'zh') {
        if (savedScriptCode != null && savedScriptCode.isNotEmpty) {
          loadedLocale = Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: savedScriptCode,
          );
        } else {
          // 舊版相容：CN / SG 視為簡中，其餘中文視為繁中。
          loadedLocale = Locale('zh', savedCountryCode ?? 'TW');
        }
      } else {
        loadedLocale = Locale(languageCode);
      }
    }

    loadedLocale = _normalizeLocale(loadedLocale);

    if (loadVersion != _changeVersion) return;

    _locale = loadedLocale;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class LocaleNotifier extends ChangeNotifier {
  // 預設語言為繁體中文
  Locale _locale = const Locale('zh', 'TW');

  Locale get locale => _locale;

  LocaleNotifier() {
    // 一建立就去讀取上次儲存的語言
    _loadLocale();
  }

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    _saveLocale(newLocale); // 儲存新的選擇
    notifyListeners(); // 通知 App 重畫
  }

  // 將語言選擇儲存到手機
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString('country_code', locale.countryCode!);
    } else {
      await prefs.remove('country_code');
    }
  }

  // 從手機讀取儲存的語言
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'zh';
    final countryCode = prefs.getString('country_code') ?? 'TW';
    _locale = Locale(languageCode, countryCode);
    notifyListeners();
  }
}

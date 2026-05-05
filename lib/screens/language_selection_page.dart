import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_notifier.dart'; // 引入我們的語言大腦
import '../services/theme_notifier.dart';
import 'package:flutter/services.dart'; // ✨ 為了震動回饋
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
//語言模型

// ✨ 修正後的語言模型：乾淨俐落，只要三個參數
class Language {
  final String code;
  final String? countryCode;
  final String nativeName;

  Language(this.code, this.countryCode, this.nativeName);
}

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  // ✨ 修正後的清單：完全符合國際標準
  static final List<Language> supportedLanguages = [
    Language('zh', 'TW', '繁體中文'),
    Language('zh', 'CN', '简体中文'),
    Language('en', null, 'English'),
    Language('ja', null, '日本語'),
    Language('ko', null, '한국어'),
    Language('vi', null, 'Tiếng Việt'),
    Language('id', null, 'Bahasa Indonesia'),
    Language('th', null, 'ภาษาไทย'),
    Language('ar', null, 'العربية'),
    Language('fr', null, 'Français'),
    Language('ms', null, 'Bahasa Melayu'),
    Language('es', null, 'Español'),
    Language('hi', null, 'हिन्दी'),
    Language('pt', null, 'Português'),
  ];

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.title_language_settings),
        elevation: 0,
        backgroundColor: Colors.transparent, // 讓 AppBar 浮在背景上
      ),
      extendBodyBehindAppBar: true, // 背景延伸到頂部
      body: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          // ✨ 把 theme 移到這裡面，這樣切換主題時顏色才會瞬間更新！
          final theme = Theme.of(context);

          return Container(
            decoration: themeNotifier.currentBackground,
            child: ListView.builder(
              // ✨ 極致防跑版：自動計算「手機頂部狀態列 + AppBar 的高度」，再往下加 20
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery
                    .of(context)
                    .padding
                    .top + 20,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              itemCount: supportedLanguages.length,
              itemBuilder: (context, index) {
                final lang = supportedLanguages[index];
                final isSelected = localeNotifier.locale.languageCode ==
                    lang.code &&
                    localeNotifier.locale.countryCode == lang.countryCode;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      localeNotifier.setLocale(
                          Locale(lang.code, lang.countryCode));
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withOpacity(0.9)
                            : theme.colorScheme.surface.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? theme.colorScheme.primary : Colors
                              .white24,
                          width: 1.5,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ] : [],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            // ✨ 拆掉 Column，直接留下 nativeName 的 Text 就好！
                            child: Text(
                              lang.nativeName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: theme.colorScheme.onPrimary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
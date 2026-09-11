import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/locale_notifier.dart'; // 引入我們的語言大腦
import '../services/theme_notifier.dart';
import 'package:flutter/services.dart'; // ✨ 為了震動回饋
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
//語言模型

// ✨ 修正後的語言模型：乾淨俐落，只要三個參數
class Language {
  final String code;
  final String? scriptCode;
  final String nativeName;

  const Language(this.code, this.scriptCode, this.nativeName);

  Locale get locale => scriptCode == null
      ? Locale(code)
      : Locale.fromSubtags(
    languageCode: code,
    scriptCode: scriptCode,
  );
}

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  // ✨ 修正後的清單：完全符合國際標準
  static final List<Language> supportedLanguages = [
    const Language('zh', 'Hant', '繁體中文'),
    const Language('zh', 'Hans', '简体中文'),
    const Language('en', null, 'English'),
    const Language('ja', null, '日本語'),
    const Language('ko', null, '한국어'),
    const Language('vi', null, 'Tiếng Việt'),
    const Language('id', null, 'Bahasa Indonesia'),
    const Language('th', null, 'ภาษาไทย'),
    const Language('ar', null, 'العربية'),
    const Language('fr', null, 'Français'),
    const Language('ms', null, 'Bahasa Melayu'),
    const Language('es', null, 'Español'),
    const Language('hi', null, 'हिन्दी'),
    const Language('pt', null, 'Português'),
  ];

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = context.watch<ThemeNotifier>();
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final primary = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final isDarkMode = theme.brightness == Brightness.dark;
    final double screenWidth = mediaQuery.size.width;

    // 以目前調好的 390px 寬手機為基準，讓花草跟著裝置寬度縮放。
    // 限制縮放範圍，避免小手機太小、平板又顯得過大。
    final double layoutScale = (screenWidth / 390).clamp(0.84, 1.20);
    final double botanicalWidth =
    (screenWidth * 0.48).clamp(154.0, 242.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: themeNotifier.currentBackground,
        child: Stack(
          children: [
            Positioned(
              // 花草避開狀態列，並比原本再往下放一些。
              top: mediaQuery.padding.top + (28 * layoutScale),
              right: -5 * layoutScale,
              width: botanicalWidth,
              child: IgnorePointer(
                child: Opacity(
                  opacity: isDarkMode ? 0.09 : 0.22,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      primary,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/language/language_top_right_botanical.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 680),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 48,
                                    child: IconButton(
                                      tooltip:
                                      MaterialLocalizations.of(context)
                                          .backButtonTooltip,
                                      onPressed: () =>
                                          Navigator.maybePop(context),
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.topLeft,
                                      visualDensity: VisualDensity.compact,
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: textColor.withValues(alpha: 0.82),
                                        size: 25,
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
                                          l10n.title_language_settings,
                                          style: GoogleFonts.notoSerifTc(
                                            color: textColor,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2.2,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          l10n.languageSelectionSubtitle,
                                          style: GoogleFonts.notoSerifTc(
                                            color: textColor.withValues(
                                              alpha: 0.55,
                                            ),
                                            fontSize: 14,
                                            letterSpacing: 0.9,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 26),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 38),
                    sliver: SliverList.separated(
                      itemCount: supportedLanguages.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final lang = supportedLanguages[index];
                        final currentLocale = localeNotifier.locale;
                        final isSelected =
                            currentLocale.languageCode == lang.code &&
                                currentLocale.scriptCode == lang.scriptCode;

                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: Semantics(
                              button: true,
                              selected: isSelected,
                              label: lang.nativeName,
                              child: InkWell(
                                onTap: () async {
                                  HapticFeedback.lightImpact();

                                  final selectedLocale = lang.locale;

                                  localeNotifier.setLocale(selectedLocale);

                                  final user =
                                      FirebaseAuth.instance.currentUser;

                                  if (user != null) {
                                    final notificationLocale =
                                    lang.code == 'zh'
                                        ? (lang.scriptCode == 'Hans'
                                        ? 'zh_Hans'
                                        : 'zh_Hant')
                                        : lang.code;

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .set({
                                        'notificationLocale':
                                        notificationLocale,
                                        'notificationLocaleUpdatedAt':
                                        FieldValue.serverTimestamp(),
                                      }, SetOptions(merge: true));
                                    } catch (e) {
                                      debugPrint(
                                        '⚠️ 通知語系同步失敗：$e',
                                      );
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 240),
                                  curve: Curves.easeOutCubic,
                                  constraints:
                                  const BoxConstraints(minHeight: 72),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface.withValues(
                                      alpha: isDarkMode ? 0.72 : 0.66,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: primary.withValues(
                                        alpha: isSelected ? 0.58 : 0.13,
                                      ),
                                      width: isSelected ? 1.25 : 0.8,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primary.withValues(
                                          alpha: isSelected ? 0.12 : 0.035,
                                        ),
                                        blurRadius: isSelected ? 14 : 9,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 32,
                                        height: 38,
                                        child: Opacity(
                                          opacity: isSelected ? 0.9 : 0.48,
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              primary,
                                              BlendMode.srcIn,
                                            ),
                                            child: Image.asset(
                                              'assets/images/language/language_item_leaf.png',
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) =>
                                                  Icon(
                                                    Icons.eco_outlined,
                                                    color: primary,
                                                    size: 25,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Text(
                                          lang.nativeName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSerifTc(
                                            color: textColor.withValues(
                                              alpha: isSelected ? 0.94 : 0.82,
                                            ),
                                            fontSize: 18,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            letterSpacing: 0.4,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      AnimatedContainer(
                                        duration:
                                        const Duration(milliseconds: 240),
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? primary.withValues(alpha: 0.1)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: primary.withValues(
                                              alpha: isSelected ? 0.58 : 0.2,
                                            ),
                                            width: isSelected ? 1.4 : 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 180,
                                          ),
                                          child: isSelected
                                              ? Icon(
                                            Icons.check_rounded,
                                            key: const ValueKey('check'),
                                            color: primary,
                                            size: 25,
                                          )
                                              : const SizedBox(
                                            key: ValueKey('empty'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
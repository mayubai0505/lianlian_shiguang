import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'main_page.dart';
import 'package:provider/provider.dart'; // ✅ 修正：解決 Undefined name 'Provider'
import '../services/theme_notifier.dart'; // ✅ 修正：解決 ThemeNotifier isn't a type
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../page/app_texts.dart';

//新手引導
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: themeNotifier.currentBackground,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✨ 1. 增加一點神祕感的頂部裝飾
                  Icon(Icons.auto_awesome, color: primaryColor.withOpacity(0.6), size: 40),
                  const SizedBox(height: 20),

                  // ✨ 2. 像邀請函一樣的卡片設計
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.onboarding_invitation,
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 4,
                              color: primaryColor.withOpacity(0.7),
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.onboarding_welcome,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: onSurface
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.onboarding_quote,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                        const SizedBox(height: 32),

                        // ✨ 3. 禮物視覺區
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // 後方的光暈
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.1),
                              ),
                            ),
                            Image.asset('assets/images/flower_gift.png', height: 100),
                          ],
                        ),

                        const SizedBox(height: 24),
                        Text(
                          l10n.onboarding_gift_title,
                          style: TextStyle(
                              fontSize: 18,
                              color: primaryColor,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.onboarding_gift_subtitle,
                          style: TextStyle(fontSize: 13, color: onSurface.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // ✨ 4. 進入遊戲按鈕
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(isCreating: true),
                        ),
                      ).then((value) {
                        if (value == true && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.5),
                    ),
                    child: Text(l10n.onboarding_start_button, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 16),

                  // ✨ 5. 法律條款區
                  Column(
                    children: [
                      Text(
                        l10n.legal_agreement_prefix, // ✨ 換成翻譯變數
                        style: TextStyle(fontSize: 12, color: onSurface.withOpacity(0.5)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 📜 服務條款按鈕
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LegalDocumentPage(isPrivacyPolicy: false),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(l10n.legal_terms_button, style: TextStyle(fontSize: 12, color: primaryColor)), // ✨ 換成翻譯變數
                          ),

                          Text(l10n.legal_and, style: TextStyle(fontSize: 12, color: onSurface.withOpacity(0.5))), // ✨ 換成翻譯變數

                          // 🔒 隱私權政策按鈕
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LegalDocumentPage(isPrivacyPolicy: true),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(l10n.legal_privacy_button, style: TextStyle(fontSize: 12, color: primaryColor)), // ✨ 換成翻譯變數
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
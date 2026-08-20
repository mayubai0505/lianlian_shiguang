import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // ✨  引入 provider
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/theme_notifier.dart'; // ✨ 引入主題大腦
import '../services/toast_utils.dart';
import 'feedback_page.dart';
import 'help_page.dart';
import 'language_selection_page.dart'; // ✨ 引入語言選擇頁面
import 'package:shared_preferences/shared_preferences.dart';
import '../page/theme_selection_page.dart';
import '../page/character_management_page.dart';
import '../page/app_texts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


//設定

class SettingsPage extends StatefulWidget { // ✨ 改成 StatefulWidget
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ✨ 建立 State
  final AuthService authService = AuthService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadVibrationSettings(); // ✨ 初始化時讀取設定
  }

  // 輔助函式：建立一個帶有標題的區塊
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 34, 6, 14),
      child: Text(
        title,
        style: GoogleFonts.notoSerifTc(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String content) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok_button),
          ),
        ],
      ),
    );
  }

  // ✨ 新增：讀取本地設定的函式
  Future<void> _loadVibrationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    });
  }


  // ✨ 2. 順便幫總裁補上「登出確認彈窗」的邏輯，避免下一個報錯
  void _showLogoutDialog(BuildContext context, AppLocalizations l10n, AuthService authService) {
    showDialog(
      context: context,
      // 🌟 加上這行，確保彈窗能衝破任何層級顯示出來
      useRootNavigator: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.logoutButton ),
          content: Text(l10n.logoutDialogTitle),
          actions: [
            TextButton(
              child: Text(l10n.logoutDialogActionCancel ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                l10n.logoutDialogActionConfirm,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                // 1. 先關掉原本的「確認登出」對話框
                Navigator.of(dialogContext).pop();
                // 2. 顯示「轉圈圈 + 甜心訊息」的 Loading 視窗
                showDialog(
                  context: context,
                  barrierDismissible: false, // 🌟 關鍵：不准玩家亂點關掉，直到登出完成
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(), // 轉圈圈
                        const SizedBox(height: 20),
                        Text(
                          l10n.logoutSuccessSnackbar,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ), // 🌟 這裡結尾
                      ],
                    ),
                  ),
                );
                // 3. 執行正式登出 (給它一點緩衝時間，讓玩家看清楚妳的話)
                await Future.delayed(const Duration(seconds: 1)); // 🌟 故意延遲 1 秒，不然跑太快看不清
                await authService.signOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ✨ 3. 重置外觀的確認彈窗
  void _showResetDialog(BuildContext context, ThemeNotifier themeNotifier) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) =>
          AlertDialog(
            // 🌟 總裁無敵防護罩：管你什麼主題，對話框絕對要有實心底色！
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2C) // 深色模式給深灰底
                : Colors.white,           // 淺色/漸層模式絕對給白底

            // 🌟 擋掉 Material 3 雞婆的自動染色功能，確保顏色純粹
            surfaceTintColor: Colors.transparent,

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title:  Text(l10n.resetAppearanceTitle),
            content: Text(l10n.resetAppearanceWarning),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child:  Text(l10n.cancelButton)
              ),
              TextButton(
                onPressed: () {
                  themeNotifier.resetToDefault();
                  Navigator.pop(dialogContext);
                  // ✨ 總裁級：一鍵恢復外觀的優雅回饋，將視覺焦點完美留在角色身上！
                  ToastUtils.showCenterToast(
                    context, // 💡 若在 async 之後，請記得確認 if (context.mounted)
                    l10n.appearanceRestored,
                    customIcon: Icons.settings_backup_restore_rounded, // 💡 總裁精選：「恢復/時光倒流」的最佳通用圖示
                    // 💡 總裁秘技：如果是專門針對「角色裝扮」的恢復，
                    // 用 Icons.checkroom_rounded (衣帽間) 或 Icons.face_retouching_off_rounded 也會非常有沉浸感喔！
                  );
                },
                child: Text(l10n.confirmReset, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // 🚀 刪除帳號的確認彈窗 (最高權限指令！)
  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n, AuthService authService) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteAccountDialogTitle),
        content: Text(l10n.deleteAccountDialogContent),
        actions: [
          TextButton(
            child: Text(l10n.deleteAccountDialogActionCancel),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            child: Text(
              l10n.deleteAccountDialogActionConfirm,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {

              // 關閉確認刪除視窗
              Navigator.of(dialogContext).pop();

              try {
                await FirebaseAuth.instance.currentUser?.getIdToken(true);
              } catch (e) {
                debugPrint("⚠️ 強制刷新憑證失敗，可能需要重新登入: $e");
                // 如果連這裡都失敗，通常代表玩家真的離開太久，憑證死透了
              }

              // 申請刪除（不是立即刪除）
              final String? errorMessage =
              await authService.requestDeleteAccount();


              if (!context.mounted) return;


              if (errorMessage == null) {


                // 顯示3天冷靜期通知
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (successContext) => AlertDialog(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    title: Text(
                      l10n.accountDeletionSubmittedTitle,
                    ),

                    content: Text(
                      l10n.accountDeletionSubmittedContent,
                    ),


                    actions: [

                      TextButton(
                        child:  Text(l10n.ok_button),
                        onPressed: () async {

                          Navigator.of(successContext).pop();


                          await authService.signOut(context);


                        },
                      ),

                    ],
                  ),
                );
              } else {
                _showErrorDialog(
                  '發生錯誤',
                  errorMessage,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTintedSettingAsset({
    required String maskAsset,
    required Color color,
    double size = 31,
    double opacity = 0.82,
  }) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        maskAsset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        color: color,
        colorBlendMode: BlendMode.srcIn,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  // 無卡片設計：以留白與細分隔線取代大量圓角框。
  Widget _buildSettingsTile({
    required String maskAsset,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    required ThemeData theme,
    bool showDivider = true,
  }) {
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 74),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _buildTintedSettingAsset(
                        maskAsset: maskAsset,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                            color: onSurface,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            subtitle,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 13,
                              height: 1.35,
                              letterSpacing: 0.35,
                              color: onSurface.withValues(alpha: 0.52),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  trailing ??
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 23,
                        color: primaryColor.withValues(alpha: 0.55),
                      ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.7,
            indent: 52,
            color: primaryColor.withValues(alpha: 0.17),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 準備變色龍變數
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final String providerId = currentUser?.providerData.first.providerId ??
        "unknown";
    final String authMethod = providerId == 'google.com'
        ? l10n.authMethodGoogle
        : l10n.authMethodUnknown;

    return Container(
      decoration: themeNotifier.currentBackground, // ✅ 漸層背景鋪滿全螢幕
      child: Scaffold(
        backgroundColor: Colors.transparent, // ✅ Scaffold 透明
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            l10n.settingsTitle,
            style: GoogleFonts.notoSerifTc(
              color: onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.2,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: onSurface),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: theme.brightness == Brightness.dark ? 0.08 : 0.16,
                  child: Image.asset(
                    'assets/images/setting/settings_botanical_overlay_mask.png',
                    fit: BoxFit.fill,
                    color: primaryColor,
                    colorBlendMode: BlendMode.srcIn,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 2, 22, 34),
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                children: <Widget>[
                  _buildSectionTitle(context, l10n.settingsSectionAppearance),

                  // 1. 變更主題
                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_theme_palette_mask.png',
                    title: l10n.changeTheme,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const ThemeSelectionPage())),
                    theme: theme,
                  ),

                  // 2. 恢復預設
                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_reset_appearance_mask.png',
                    title: l10n.resetToDefaultAppearance,
                    subtitle: l10n.clearCustomSettings,
                    onTap: () => _showResetDialog(context, themeNotifier),
                    theme: theme,
                  ),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_contact_mask.png',
                    title: l10n.contactUs,
                    subtitle: l10n.contactDescription,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const FeedbackPage())),
                    theme: theme,
                  ),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_language_mask.png',
                    title: l10n.changeLanguage,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => const LanguageSelectionPage())),
                    theme: theme,
                    showDivider: false,
                  ),

                  _buildSectionTitle(context, l10n.settingsSectionAccount),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_account_mask.png',
                    title: l10n.accountManagement,
                    subtitle: '${l10n.userId} ${currentUser?.uid ?? "N/A"}',
                    trailing: Text(
                      authMethod,
                      style: GoogleFonts.notoSerifTc(
                        color: primaryColor,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    onTap: () {
                      if (currentUser?.uid != null) {
                        Clipboard.setData(ClipboardData(text: currentUser!
                            .uid));
                        // ✨ 總裁級：行雲流水的複製回饋，瞬間確認不拖泥帶水！
                        ToastUtils.showCenterToast(
                          context, // 💡 如果前一步有使用 await，請確認外層是否有 if (context.mounted)
                          l10n.userIdCopied,
                          // 💡 總裁秘技：針對 User ID，除了用傳統的 Icons.copy_rounded，
                          // 非常推薦使用 Icons.badge_rounded (識別證) 或 Icons.fingerprint_rounded (指紋)，能大幅提升「專屬身分」的高級感！
                          customIcon: Icons.badge_rounded,
                        );
                      }
                    },
                    theme: theme,
                  ),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_blocked_character_mask.png',
                    title: l10n.characterManagement,
                    subtitle: l10n.viewBlockedCharacters,
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => const CharacterManagementPage())),
                    theme: theme,
                    showDivider: false,
                  ),

                  // 🌟 這是合併後的樣子
                  _buildSectionTitle(context, l10n.settingsSectionAbout),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_privacy_mask.png',
                    title: l10n.privacyPolicy,
                    theme: theme,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LegalDocumentPage(
                            type: LegalPageType.privacy,
                          ),
                        ),
                      );
                    },
                  ),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_terms_mask.png',
                    title: l10n.termsOfService,
                    theme: theme,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LegalDocumentPage(
                            type: LegalPageType.terms,
                          ),
                        ),
                      );
                    },
                  ),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/profile/profile_quill_mask.png',
                    title: "創作者規範",
                    theme: theme,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LegalDocumentPage(
                            type: LegalPageType.creator,
                          ),
                        ),
                      );
                    },
                  ),

                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_guide_mask.png',
                    title: '遊玩指南',
                    theme: theme,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const HelpPage(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsTile(
                    maskAsset:
                    'assets/images/setting/settings_open_source_mask.png',
                    title: l10n.openSourceLicenses,
                    subtitle: l10n.openSourceLicensesDescription,
                    theme: theme,
                    showDivider: false,
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: '戀戀拾光',
                        applicationVersion: '1.0.1',
                        applicationLegalese: '© 2026 默語白',
                      );
                    },
                  ),
                  const SizedBox(height: 34),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          _showLogoutDialog(context, l10n, authService),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.logoutButton,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 17,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 72,
                            height: 1,
                            color: primaryColor.withValues(alpha: 0.55),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => _showDeleteAccountDialog(
                        context,
                        l10n,
                        authService,
                      ),
                      child: Text(
                        l10n.deleteAccountButton,
                        style: GoogleFonts.notoSerifTc(
                          color: Colors.redAccent,
                          fontSize: 14,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Text(
                    l10n.appDisclaimer,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11,
                      height: 1.5,
                      color: onSurface.withValues(alpha: 0.38),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.appVersion('1.0.0'),
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11,
                      color: onSurface.withValues(alpha: 0.38),
                    ),
                    textAlign: TextAlign.center,
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

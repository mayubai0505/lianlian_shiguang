import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✨  引入 provider
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/theme_notifier.dart'; // ✨ 引入主題大腦
import 'feedback_page.dart';
import 'language_selection_page.dart'; // ✨ 引入語言選擇頁面
import 'package:shared_preferences/shared_preferences.dart';
import '../page/theme_selection_page.dart';
import '../page/character_management_page.dart';
import '../page/app_texts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'login_page.dart';

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
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme
              .of(context)
              .colorScheme
              .primary, // 讓標題顏色也跟隨主題
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title:  Text(l10n.resetAppearanceTitle),
            content: Text(l10n.resetAppearanceWarning),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext),
                  child:  Text(l10n.cancelButton
                  )),
              TextButton(
                onPressed: () {
                  themeNotifier.resetToDefault();
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(l10n.appearanceRestored)));
                },
                child:Text(l10n.confirmReset, style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // 🚀 刪除帳號的確認彈窗 (最高權限指令！)
  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n, AuthService authService) {
    showDialog(
      context: context,
      useRootNavigator: true, // 🌟 確保彈窗一定會顯示在螢幕最前方
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
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
            ),
            onPressed: () async {
              // 1. 先關掉彈窗
              Navigator.of(dialogContext).pop();
              // 2. 執行刪除動作
              final String? errorMessage = await authService.deleteAccount();
              if (context.mounted) {
                if (errorMessage == null) {
                  // ✅ 成功：顯示成功訊息
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.deleteAccountSuccessSnackbar)),
                  );

                  // 🌟 核心修正：不要只是 pop()，要徹底跳回登入頁
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false, // 清空所有歷史頁面
                  );
                } else {
                  // ❌ 失敗：顯示錯誤原因（例如需重新登入）
                  _showErrorDialog('發生錯誤', errorMessage);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // ✨ 1. 這是建立每個設定選項的「食譜」
  Widget _buildSettingsTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        // ✅ 毛玻璃效果：根據主題自動調整透明度
        color: theme.cardColor.withValues(alpha:isDarkMode ? 0.6 : 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha:0.05)), // 極淡的邊框感
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? primaryColor),
        title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha:0.6)))
            : null,
        trailing: trailing ?? Icon(Icons.chevron_right,
            color: theme.colorScheme.onSurface.withValues(alpha:0.3)),
        onTap: onTap,
      ),
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
    final isDarkMode = theme.brightness == Brightness.dark;
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
          title: Text(l10n.settingsTitle, style: TextStyle(color: onSurface)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: onSurface),
        ),
        body: Column(
          children: [
            // --- 上半部：滾動設定清單 ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: <Widget>[
                  _buildSectionTitle(context, l10n.settingsSectionAppearance),

                  // 1. 變更主題
                  _buildSettingsTile(
                    icon: Icons.palette_outlined,
                    title: l10n.changeTheme,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const ThemeSelectionPage())),
                    theme: theme,
                  ),

                  // 2. 恢復預設
                  _buildSettingsTile(
                    icon: Icons.restore,
                    iconColor: Colors.orangeAccent,
                    title: l10n.resetToDefaultAppearance,
                    subtitle: l10n.clearCustomSettings,
                    onTap: () => _showResetDialog(context, themeNotifier),
                    theme: theme,
                  ),

                  _buildSettingsTile(
                    icon: Icons.contact_support_outlined,
                    title: l10n.contactUs,
                    subtitle: l10n.contactDescription,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const FeedbackPage())),
                    theme: theme,
                  ),

                  _buildSettingsTile(
                    icon: Icons.language,
                    title: l10n.changeLanguage,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => const LanguageSelectionPage())),
                    theme: theme,
                  ),

                  _buildSectionTitle(context, l10n.settingsSectionAccount),

                  _buildSettingsTile(
                    icon: Icons.account_circle_outlined,
                    title: l10n.accountManagement,
                    subtitle: '${l10n.userId} ${currentUser?.uid ?? "N/A"}',
                    trailing: Text(
                        authMethod, style: TextStyle(color: primaryColor)),
                    onTap: () {
                      if (currentUser?.uid != null) {
                        Clipboard.setData(ClipboardData(text: currentUser!
                            .uid));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.userIdCopied)));
                      }
                    },
                    theme: theme,
                  ),

                  // ✨ 心動震動感應開關
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha:
                          isDarkMode ? 0.6 : 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile(
                      secondary: Icon(Icons.vibration, color: primaryColor),
                      title:  Text(l10n.vibrationHapticTitle,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:  Text(l10n.vibrationHapticDescription),
                      value: _vibrationEnabled,
                      activeThumbColor: primaryColor,
                      onChanged: (bool value) async {
                        setState(() => _vibrationEnabled = value);
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('vibration_enabled', value);
                        if (value) HapticFeedback.mediumImpact();
                      },
                    ),
                  ),

                  _buildSettingsTile(
                    icon: Icons.block,
                    title: l10n.characterManagement,
                    subtitle: l10n.viewBlockedCharacters,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => const CharacterManagementPage())),
                    theme: theme,
                  ),

                  // 🌟 這是合併後的樣子
                  _buildSectionTitle(context, l10n.settingsSectionAbout),

                  _buildSettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.privacyPolicy, // ✨ 直接換成多語系變數
                    theme: theme,
                    onTap: () {
                      // 🚪 開啟隱私權政策的任意門
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LegalDocumentPage(isPrivacyPolicy: true), // 🌟 傳入 true
                        ),
                      );
                    },
                  ),

                  _buildSettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.termsOfService, // ✨ 直接換成多語系變數
                    theme: theme,
                    onTap: () {
                      // 🚪 開啟服務條款的任意門
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LegalDocumentPage(isPrivacyPolicy: false), // 🌟 傳入 false
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // --- 下半部：登出與刪除按鈕 (放在同一個 Column 下方) ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      _showLogoutDialog(context, l10n, authService);
                    },
                    // ✅ 確保參數對齊
                    child: Text(l10n.logoutButton),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _showDeleteAccountDialog(context, l10n, authService),
                    child: Text(l10n.deleteAccountButton, style: const TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),

            // --- 底部版本號 ---
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  Text(
                    l10n.appDisclaimer,
                    style: TextStyle(
                        fontSize: 11, color: onSurface.withValues(alpha:0.4)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.appVersion('1.0.0'),
                    style: TextStyle(
                        fontSize: 11, color: onSurface.withValues(alpha:0.4)),
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
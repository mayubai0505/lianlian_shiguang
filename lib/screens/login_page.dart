import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart'; // ✅ 確保導入您的 AuthService
import '../services/toast_utils.dart';
import 'onboarding_page.dart'; // ✅ 確保導入導航頁面
import 'main_page.dart'; // ✅ 確保導入主頁面
import 'email_login_page.dart'; // ✅ 確保導入 Email 登入頁面
import 'dart:async';
import '../services/butterfly_loading_view.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';

//登入介面

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
bool _isLoginLoading = false;
class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  BuildContext? _dialogContext; // 🎯 專門用來記住轉圈圈的 ID
  bool _isLoginLoading = false;
  bool _termsAccepted = false;

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        _dialogContext = ctx;
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC8EBFF),
                  Color(0xFFDCC5F4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: const ButterflyLoadingView(),
          ),
        );
      },
    );
  }

  // ✨ 處理登入成功後的轉場
  void _handleLoginSuccess(Map<String, dynamic> resultMap) {
    final User? user = resultMap['user'] as User?;
    final bool isNewUser = resultMap['isNewUser'] as bool? ?? false;

    if (user != null) {
      if (isNewUser) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    }
  }

  bool _checkTermsAccepted() {
    if (!_termsAccepted) {
      ToastUtils.showCenterToast(
        context,
        '請先閱讀並同意使用條款與社群規範',
        customIcon: Icons.info_outline_rounded,
      );
      return false;
    }
    return true;
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('使用條款'),
          content: const SingleChildScrollView(
            child: Text(
              '歡迎使用戀戀拾光。\n\n'
                  '使用本服務前，您必須同意遵守本使用條款與社群規範。\n\n'
                  '您不得上傳、建立、發布或傳送任何違法、侵權、色情裸露、暴力、仇恨、騷擾、辱罵、詐欺、垃圾訊息，'
                  '或其他令人反感、冒犯、危害他人權益的內容。\n\n'
                  '戀戀拾光對不當內容與濫用行為採取零容忍政策。'
                  '若使用者違反規範，我們可能會移除相關內容、限制功能、暫停或終止帳號。\n\n'
                  '使用者可透過 App 內建的檢舉與封鎖功能回報不當內容或濫用使用者。',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('我知道了'),
            ),
          ],
        );
      },
    );
  }

  void _showCommunityRulesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('社群規範'),
          content: const SingleChildScrollView(
            child: Text(
              '戀戀拾光希望提供安全、友善且尊重創作者與使用者的互動環境。\n\n'
                  '我們不允許以下內容或行為：\n'
                  '1. 色情裸露或性暗示不當內容\n'
                  '2. 騷擾、辱罵、霸凌或威脅他人\n'
                  '3. 仇恨、歧視或煽動暴力\n'
                  '4. 血腥、暴力或危險行為內容\n'
                  '5. 侵犯他人著作權、肖像權或其他權利\n'
                  '6. 垃圾訊息、詐騙或惡意行為\n'
                  '7. 其他令人反感或不適合公開顯示的內容\n\n'
                  '使用者可以檢舉不當內容，也可以封鎖濫用使用者。'
                  '封鎖後，該使用者的內容將不再顯示於您的畫面中。',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('我知道了'),
            ),
          ],
        );
      },
    );
  }

  // 🌟 終極合併版：負責控制蝴蝶、精準紀錄、以及轉場導向
  Future<void> _performLogin(
      Future<Map<String, dynamic>?> Function() loginMethod,
      ) async {
    setState(() => _isLoginLoading = true);
    _showLoadingDialog(context);

    try {
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("🟢 [1. 啟動] 蝴蝶巡邏開始，等待 AuthService 回傳...");

      final result = await loginMethod();

      print("🟢 [2. 接收] AuthService 執行完畢！");

      if (_dialogContext != null) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }

      await Future.delayed(const Duration(milliseconds: 300));

      if (result != null && mounted) {
        print("✅ [3. 成功] 拿到資料了，準備穿越時光隧道 (跳轉中)！");
        _handleLoginSuccess(result);
      } else if (result != null && !mounted) {
        print("🚀 [超車提示] 登入其實成功了！資料也拿到了！");
        print("只不過 Firebase 狀態監聽器動作太快，已經自動把畫面切換走了，所以 LoginPage 提早下班啦！");
      } else {
        print("🟡 [提示] 登入被取消或回傳為空值。");
      }
    } catch (e) {
      print("🔴 [錯誤] 登入過程發生崩潰: $e");

      if (_dialogContext != null) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          '連線異常，請稍後再試：$e',
          customIcon: Icons.cloud_off_rounded,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoginLoading = false);
        print("🏁 [4. 結束] Loading 狀態解除。");
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      }
    }
  }

  @override
  void dispose() {
    if (_dialogContext != null) {
      try {
        Navigator.of(_dialogContext!).pop();
      } catch (e) {
        print("強制關閉蝴蝶視窗時略過錯誤: $e");
      }
      _dialogContext = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool showFacebookLogin = false;
    final bool showGoogleLogin =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    // ✅ Apple 登入只在 iOS / iPadOS 顯示
    final bool showAppleLogin =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF3E5F5),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌸 遊戲標題
                Text(
                  l10n.app_name,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  l10n.login_slogan,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFAB47BC),
                  ),
                ),

                const SizedBox(height: 40),

                _termsAgreementSection(),

                const SizedBox(height: 20),

                // 🚀 Google 登入
                if (showGoogleLogin) ...[
                  _buildLoginButton(
                    text: l10n.login_with_google,
                    iconWidget: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24,
                    ),
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    onPressed: () {
                      if (!_checkTermsAccepted()) return;
                      _performLogin(_authService.signInWithGoogle);
                    },
                  ),
                ],

// ✅ Apple 登入：只在 iOS / iPadOS 顯示
                if (showAppleLogin) ...[
                  _buildLoginButton(
                    text: l10n.login_with_apple,
                    iconWidget: const Icon(
                      Icons.apple,
                      color: Colors.white,
                      size: 28,
                    ),
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      if (!_checkTermsAccepted()) return;
                      _performLogin(_authService.signInWithApple);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // 🚀 Facebook 登入
                if (showFacebookLogin) ...[
                  const SizedBox(height: 16),
                  _buildLoginButton(
                    text: l10n.login_with_facebook,
                    iconWidget: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 28,
                    ),
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    onPressed: () {
                      if (!_checkTermsAccepted()) return;
                      _performLogin(_authService.signInWithFacebook);
                    },
                  ),
                ],

                const SizedBox(height: 32),

                // 分隔線
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 80,
                      color: const Color(0xFFE1BEE7),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        l10n.common_or,
                        style: const TextStyle(
                          color: Color(0xFF8E24AA),
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 80,
                      color: const Color(0xFFE1BEE7),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 專屬信箱登入
                _buildLoginButton(
                  text: l10n.login_with_email,
                  iconWidget: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: const Color(0xFFBA68C8),
                  textColor: Colors.white,
                  onPressed: () {
                    if (!_checkTermsAccepted()) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailLoginPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _termsAgreementSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _termsAccepted,
            activeColor: const Color(0xFF7B1FA2),
            onChanged: _isLoginLoading
                ? null
                : (value) {
              setState(() {
                _termsAccepted = value ?? false;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                children: [
                  const Text(
                    '我已閱讀並同意',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6A4A6F),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showTermsDialog,
                    child: const Text(
                      '《使用條款》',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B1FA2),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(
                    '與',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6A4A6F),
                    ),
                  ),
                  GestureDetector(
                    onTap: _showCommunityRulesDialog,
                    child: const Text(
                      '《社群規範》',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7B1FA2),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✨ 按鈕工廠
  Widget _buildLoginButton({
    required String text,
    required Widget iconWidget,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 2,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        onPressed: _isLoginLoading ? null : onPressed,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            iconWidget,
            Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
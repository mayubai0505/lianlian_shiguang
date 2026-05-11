import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart'; // ✅ 確保導入您的 AuthService
import 'onboarding_page.dart'; // ✅ 確保導入導航頁面
import 'main_page.dart'; // ✅ 確保導入主頁面
import 'email_login_page.dart'; // ✅ 確保導入 Email 登入頁面
import 'dart:async';
import 'package:video_player/video_player.dart';
import '../services/butterfly_loading_view.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//登入介面

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  BuildContext? _dialogContext; // 🎯 專門用來記住轉圈圈的 ID
  bool _isLoginLoading = false;

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        _dialogContext = ctx;
        return Dialog(
          backgroundColor: Colors.transparent, // 讓外框透明，改用 Container 畫背景
          elevation: 0,
          child: Container(
            // ✨ 這裡就是注入總裁配色精華的地方
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC8EBFF), // 妳指定的 RGBA(200, 235, 255)
                  Color(0xFFDCC5F4), // 妳指定的 RGBA(220, 197, 244)
                ],
              ),
              // 加一點點細微的陰影，讓它浮起來更有立體感
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: const ButterflyLoadingView(), // 呼叫剛才寫好的蝴蝶影片組件
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

  // 🌟 終極合併版：負責控制蝴蝶、精準紀錄、以及轉場導向
  Future<void> _performLogin(Future<Map<String, dynamic>?> Function() loginMethod) async {
    // 1. 蝴蝶起飛 🦋
    setState(() => _isLoginLoading = true);
    _showLoadingDialog(context); // ✨ 總裁加持：呼叫漸層蝴蝶視窗！

    try {
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("🟢 [1. 啟動] 蝴蝶巡邏開始，等待 AuthService 回傳...");

      // 2. 執行登入方法 (Google, Apple, 或 Facebook)
      final result = await loginMethod();

      print("🟢 [2. 接收] AuthService 執行完畢！");

      // 給動畫一點點喘息時間 (300ms)，避免畫面切換太生硬
      await Future.delayed(const Duration(milliseconds: 300));

      // ✨ 關鍵防護：在做任何跳轉或判斷前，先把蝴蝶視窗關掉！
      if (_dialogContext != null) {
        // 建議用 _dialogContext 本身來 pop，最安全！
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }

      // 3. 判斷跳轉
      if (result != null && mounted) {
        print("✅ [3. 成功] 拿到資料了，準備穿越時光隧道 (跳轉中)！");
        _handleLoginSuccess(result);

      } else if (result != null && !mounted) {
        // 🌟 總裁，這就是真相！
        print("🚀 [超車提示] 登入其實成功了！資料也拿到了！");
        print("只不過 Firebase 狀態監聽器動作太快，已經自動把畫面切換走了，所以 LoginPage 提早下班啦！");

      } else {
        // 真正失敗或取消才會走到這
        print("🟡 [提示] 登入被取消或回傳為空值。");
      }

    } catch (e) {
      print("🔴 [錯誤] 登入過程發生崩潰: $e");

      // ✨ 關鍵防護：如果發生錯誤掉進來，也一定要把蝴蝶關掉！
      if (_dialogContext != null) {
        Navigator.of(_dialogContext!).pop();
        _dialogContext = null;
      }

      if (mounted) {
        // 這裡記得替換成我們剛才設定的 l10n 多國語系喔！
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('連線異常，請稍後再試：$e'),
            backgroundColor: const Color(0xFF9C27B0), // 總裁專屬紫色
          ),
        );
      }
    } finally {
      // 4. ✅ 解除按鈕等其他的 Loading 狀態
      if (mounted) {
        setState(() => _isLoginLoading = false);
        print("🏁 [4. 結束] 蝴蝶平安降落，Loading 狀態解除。");
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            // ✅ 總裁指定的漸層效果：淡紫色到純白
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF3E5F5), // 浪漫淡紫色 (取代原本的淡粉色)
                Colors.white,       // 漸層到純白
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌸 遊戲標題
                Text(l10n.app_name,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // 深紫色標題
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(l10n.login_slogan,
                  style: TextStyle(fontSize: 16, color: Color(0xFFAB47BC)), // 紫色副標題
                ),
                const SizedBox(height: 60),
                // 🚀 登入按鈕群
                _buildLoginButton(
                  text: l10n.login_with_google,
                  iconWidget: Image.asset('assets/images/google_logo.png', height: 24),
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () => _performLogin(_authService.signInWithGoogle),
                ),
                const SizedBox(height: 16),
                _buildLoginButton(
                  text: l10n.login_with_apple,
                  iconWidget: const Icon(Icons.apple, color: Colors.white, size: 28),
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () => _performLogin(_authService.signInWithApple),
                ),
                const SizedBox(height: 16),
                _buildLoginButton(
                  text: l10n.login_with_facebook,
                  iconWidget: const Icon(Icons.facebook, color: Colors.white, size: 28),
                  backgroundColor: const Color(0xFF1877F2),
                  textColor: Colors.white,
                  onPressed: () => _performLogin(_authService.signInWithFacebook),
                ),
                const SizedBox(height: 32),
                // 分隔線
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 1, width: 80, color: const Color(0xFFE1BEE7)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(l10n.common_or, style: TextStyle(color: Color(0xFF8E24AA))),
                    ),
                    Container(height: 1, width: 80, color: const Color(0xFFE1BEE7)),
                  ],
                ),
                const SizedBox(height: 32),
                // 專屬信箱登入
                _buildLoginButton(
                  text: l10n.login_with_email,
                  iconWidget: const Icon(Icons.email_outlined, color: Colors.white),
                  backgroundColor: const Color(0xFFBA68C8), // 亮紫色按鈕
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmailLoginPage()),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
        ),
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            iconWidget,
            Center(
              child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
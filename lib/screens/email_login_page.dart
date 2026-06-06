import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/toast_utils.dart';
import 'main_page.dart';
import 'onboarding_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//信箱登入

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoginMode = true; // true = 登入模式, false = 註冊模式
  bool _obscurePassword = true; // 密碼遮罩

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 核心執行邏輯
  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (email.isEmpty || password.isEmpty) {
      // ✨ 總裁級防呆：登入大門的優雅守衛，完美跨越虛擬鍵盤的視覺死角！
      ToastUtils.showCenterToast(
        context,
        l10n.error_email_password_empty,
        isError: true, // 💡 全域統一的紅色驚嘆號，明確告知這是一項「必須完成的任務」
        // 💡 總裁秘技：如果想讓語意更貼近登入情境，
        // 非常推薦換成 customIcon: Icons.key_off_rounded 或是 Icons.no_accounts_rounded！
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic>? result;
      if (_isLoginMode) {
        // 執行登入
        result = await _authService.signInWithEmail(email, password);
      } else {
        // 執行註冊
        result = await _authService.registerWithEmail(email, password);
      }

      if (result != null && mounted) {
        final User? user = result['user'] as User?;
        final bool isNewUser = result['isNewUser'] as bool? ?? false;

        if (user != null) {
          if (isNewUser) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OnboardingPage()),
                  (route) => false, // 清除所有上一頁紀錄
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // 處理常見錯誤並翻譯成白話文
      String errorMessage = l10n.auth_error_default;
      if (e.code == 'user-not-found') {
        errorMessage = l10n.auth_error_user_not_found;
      } else if (e.code == 'wrong-password') {
        errorMessage = l10n.auth_error_wrong_password;
      } else if (e.code == 'email-already-in-use') {
        errorMessage = l10n.auth_error_email_in_use;
      } else if (e.code == 'weak-password') {
        errorMessage = l10n.auth_error_weak_password;
      } else if (e.code == 'invalid-email') {
        errorMessage = l10n.auth_error_invalid_email;
      }

      if (mounted) {
        // ✨ 總裁級防護：動態錯誤訊息的完美封裝，絕不讓不可控的字串破壞畫面排版！
        ToastUtils.showCenterToast(
          context,
          errorMessage,
          isError: true, // 💡 全域統一的紅色驚嘆號，清楚傳達這是個異常狀態
        );
      }
    } finally {
      // 💡 總裁讚賞：無懈可擊的 finally 善後區塊，確保狀態完美重置！
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // 讓 AppBar 變成透明，這樣漸層才能透上來
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ✅ 返回按鈕改成深紫色
        iconTheme: const IconThemeData(color: Color(0xFF7B1FA2)),
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            // ✅ 同步主頁面的浪漫紫漸層
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF3E5F5), // 浪漫淡紫色
                Colors.white, // 漸層到純白
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // ✅ 圖示改成紫色系
                  Icon(
                      Icons.mark_email_unread_outlined,
                      size: 80,
                      color: const Color(0xFF9C27B0).withOpacity(0.8)
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _isLoginMode ?l10n.title_welcome_back : l10n.title_register_account,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C) // 深紫色文字
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 信箱輸入框
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.label_email,
                      labelStyle: const TextStyle(color: Color(0xFF7B1FA2)),
                      // ✅ 前綴圖示改成紫色
                      prefixIcon: const Icon(
                          Icons.email_outlined, color: Color(0xFF9C27B0)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFBA68C8),
                            width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 密碼輸入框
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText:l10n.label_password,
                      labelStyle: const TextStyle(color: Color(0xFF7B1FA2)),
                      // ✅ 前綴圖示改成紫色
                      prefixIcon: const Icon(
                          Icons.lock_outline, color: Color(0xFF9C27B0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons
                              .visibility,
                          color: const Color(0xFF9C27B0),
                        ),
                        onPressed: () =>
                            setState(() =>
                            _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFBA68C8),
                            width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 送出按鈕
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // ✅ 送出按鈕改成跟 Email 登入按鈕一樣的亮紫色
                      backgroundColor: const Color(0xFFBA68C8),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 3,
                    ),
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3)
                    )
                        : Text(
                        _isLoginMode ?l10n.action_login : l10n.action_register,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 切換模式按鈕
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode;
                        _passwordController.clear();
                      });
                    },
                    child: Text(
                      _isLoginMode
                          ? l10n.prompt_no_account
                          : l10n.prompt_has_account,
                      style: const TextStyle(
                          color: Color(0xFF7B1FA2), // ✅ 改成深紫色，看起來更有質感
                          fontWeight: FontWeight.bold
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
  }
}
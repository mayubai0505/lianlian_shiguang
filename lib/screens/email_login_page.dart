import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_service.dart';
import '../services/toast_utils.dart';
import 'main_page.dart';
import 'onboarding_page.dart';

import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// 信箱登入
class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  // ============================================================
  // 條款版本
  // 服務條款或隱私權政策有重大更新時，將版本號改成 1.1、1.2……
  // 玩家就會重新看到新版條款。
  // ============================================================
  static const String _currentTermsVersion = '1.0';
  static const String _currentPrivacyVersion = '1.0';

  // ============================================================
  // Notion 公開網址
  // ⚠️ 必須換成「Publish to web」後的公開網址
  // ============================================================
  static const String _termsNotionUrl =
      'https://你的服務條款公開網址.notion.site';

  static const String _privacyNotionUrl =
      'https://你的隱私權政策公開網址.notion.site';

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoginMode = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // Email 格式驗證
  // 不限制 Gmail，可接受一般合法網域。
  // ============================================================
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    );

    return emailRegex.hasMatch(email);
  }

  // ============================================================
  // Notion 條款閱讀視窗
  // 玩家必須先成功開啟網址，才可以按「我已閱讀並同意」。
  // ============================================================
  Future<bool> _showExternalPolicyDialog({
    required String title,
    required String url,
  }) async {
    bool hasOpenedPolicy = false;
    bool isOpening = false;

    final bool accepted =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                Future<void> openPolicy() async {
                  if (isOpening) return;

                  setDialogState(() {
                    isOpening = true;
                  });

                  try {
                    final Uri? uri = Uri.tryParse(url);

                    if (uri == null ||
                        !uri.hasScheme ||
                        !uri.hasAuthority) {
                      throw const FormatException(
                        '條款網址格式不正確',
                      );
                    }

                    final bool opened = await launchUrl(
                      uri,
                      mode: kIsWeb
                          ? LaunchMode.platformDefault
                          : LaunchMode.externalApplication,
                      webOnlyWindowName: '_blank',
                    );

                    if (!opened) {
                      throw Exception('無法開啟條款網址');
                    }

                    if (!dialogContext.mounted) return;

                    setDialogState(() {
                      hasOpenedPolicy = true;
                    });
                  } catch (e) {
                    debugPrint('❌ 開啟$title失敗：$e');

                    if (dialogContext.mounted) {
                      ToastUtils.showCenterToast(
                        dialogContext,
                        '無法開啟$title，請確認網路後再試。',
                        customIcon: Icons.link_off_rounded,
                        isError: true,
                      );
                    }
                  } finally {
                    if (dialogContext.mounted) {
                      setDialogState(() {
                        isOpening = false;
                      });
                    }
                  }
                }

                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF7B1FA2),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '請先開啟並閱讀完整$title。'
                              '閱讀後回到《戀戀拾光》，即可按下'
                              '「我已閱讀並同意」。',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed:
                            isOpening ? null : openPolicy,
                            icon: isOpening
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(
                              Icons.open_in_new_rounded,
                            ),
                            label: Text(
                              isOpening
                                  ? '正在開啟……'
                                  : '閱讀完整$title',
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: hasOpenedPolicy
                                ? Colors.green.withValues(
                              alpha: 0.08,
                            )
                                : Colors.grey.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                hasOpenedPolicy
                                    ? Icons
                                    .check_circle_outline
                                    : Icons.info_outline,
                                color: hasOpenedPolicy
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  hasOpenedPolicy
                                      ? '已開啟$title，可以確認同意。'
                                      : '尚未開啟$title。',
                                  style: TextStyle(
                                    color: hasOpenedPolicy
                                        ? Colors.green
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: isOpening
                            ? null
                            : () {
                          Navigator.of(
                            dialogContext,
                          ).pop(false);
                        },
                        child: const Text('取消登入'),
                      ),
                      ElevatedButton(
                        onPressed: hasOpenedPolicy
                            ? () {
                          Navigator.of(
                            dialogContext,
                          ).pop(true);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                        ),
                        child:
                        const Text('我已閱讀並同意'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ) ??
            false;

    return accepted;
  }

  // ============================================================
  // 檢查條款版本
  // 已同意目前版本：直接通過。
  // 沒同意／版本不同：依序顯示服務條款及隱私權政策。
  // ============================================================
  Future<bool> _ensureCurrentAgreement(
      User user,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final DocumentReference<Map<String, dynamic>>
    userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      final userDoc = await userRef.get();
      final Map<String, dynamic> data =
          userDoc.data() ?? <String, dynamic>{};

      final bool termsAreCurrent =
          data['acceptedTermsVersion'] ==
              _currentTermsVersion;

      final bool privacyIsCurrent =
          data['acceptedPrivacyVersion'] ==
              _currentPrivacyVersion;

      // 兩份都是目前版本，不再重複顯示
      if (termsAreCurrent && privacyIsCurrent) {
        return true;
      }

      bool acceptedTermsThisTime =
          termsAreCurrent;

      bool acceptedPrivacyThisTime =
          privacyIsCurrent;

      if (!termsAreCurrent) {
        acceptedTermsThisTime =
        await _showExternalPolicyDialog(
          title: l10n.terms_title,
          url: _termsNotionUrl,
        );

        if (!acceptedTermsThisTime) {
          return false;
        }
      }

      if (!mounted) return false;

      if (!privacyIsCurrent) {
        acceptedPrivacyThisTime =
        await _showExternalPolicyDialog(
          title: '隱私權政策',
          url: _privacyNotionUrl,
        );

        if (!acceptedPrivacyThisTime) {
          return false;
        }
      }

      if (!acceptedTermsThisTime ||
          !acceptedPrivacyThisTime) {
        return false;
      }

      await userRef.set({
        'acceptedTermsVersion':
        _currentTermsVersion,
        'acceptedPrivacyVersion':
        _currentPrivacyVersion,
        'acceptedTermsAt':
        FieldValue.serverTimestamp(),
        'acceptedPrivacyAt':
        FieldValue.serverTimestamp(),
        'agreementPlatform': kIsWeb
            ? 'web'
            : defaultTargetPlatform.name,
        'acceptedTermsUrl':
        _termsNotionUrl,
        'acceptedPrivacyUrl':
        _privacyNotionUrl,
      }, SetOptions(merge: true));

      debugPrint(
        '✅ Email 帳號已記錄條款同意版本：'
            'terms=$_currentTermsVersion，'
            'privacy=$_currentPrivacyVersion',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ 檢查 Email 條款狀態失敗：$e');
      debugPrint('$stackTrace');

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          '目前無法確認條款狀態，請稍後再試。',
          customIcon: Icons.error_outline,
          isError: true,
        );
      }

      return false;
    }
  }

  // ============================================================
  // 登入成功後的共用處理
  // ============================================================
  Future<void> _handleLoginSuccess(
      Map<String, dynamic> result,
      ) async {
    final User? user =
    result['user'] as User?;

    final bool isNewUser =
        result['isNewUser'] as bool? ?? false;

    if (user == null) return;

    final bool agreementAccepted =
    await _ensureCurrentAgreement(user);

    if (!agreementAccepted) {
      if (!mounted) return;

      await _authService.signOut(context);
      return;
    }

    if (!mounted) return;

    if (isNewUser) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
          const OnboardingPage(),
        ),
            (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainPage(),
        ),
            (route) => false,
      );
    }
  }

  // ============================================================
  // 忘記密碼
  // ============================================================
  Future<void> _resetPassword() async {
    final l10n =
    AppLocalizations.of(context)!;

    final String email =
    _emailController.text
        .trim()
        .toLowerCase();

    if (email.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.forgot_password_empty_email,
        isError: true,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ToastUtils.showCenterToast(
        context,
        l10n.forgot_password_error_invalid_email,
        isError: true,
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.forgot_password_email_sent,
        customIcon:
        Icons.mark_email_read_rounded,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          l10n.forgot_password_error_default;

      if (e.code == 'invalid-email') {
        message =
            l10n.forgot_password_error_invalid_email;
      } else if (e.code == 'user-not-found') {
        message =
            l10n.forgot_password_error_user_not_found;
      }

      ToastUtils.showCenterToast(
        context,
        message,
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.forgot_password_error_with_message(
          e.toString(),
        ),
        isError: true,
      );
    }
  }

  // ============================================================
  // Email 登入／註冊
  // ============================================================
  Future<void> _submit() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final String email =
    _emailController.text
        .trim()
        .toLowerCase();

    // 密碼不要轉小寫。
    // 也不要 trim 中間內容，以免改變玩家原本的密碼。
    final String password =
        _passwordController.text;

    final l10n =
    AppLocalizations.of(context)!;

    if (email.isEmpty ||
        password.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.error_email_password_empty,
        isError: true,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ToastUtils.showCenterToast(
        context,
        '請輸入有效的電子郵件地址。',
        isError: true,
      );
      return;
    }

    // Firebase Email/Password 的密碼最低為 6 個字元。
    if (!_isLoginMode &&
        password.length < 6) {
      ToastUtils.showCenterToast(
        context,
        l10n.auth_error_weak_password,
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic>? result;

      if (_isLoginMode) {
        result =
        await _authService.signInWithEmail(
          email,
          password,
        );
      } else {
        result =
        await _authService.registerWithEmail(
          email,
          password,
        );
      }

      if (result == null || !mounted) {
        return;
      }

      await _handleLoginSuccess(result);
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          l10n.auth_error_default;

      if (e.code == 'user-not-found') {
        errorMessage =
            l10n.auth_error_user_not_found;
      } else if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        // 新版 Firebase 有時會把帳號或密碼錯誤統一回傳
        // invalid-credential。
        errorMessage =
            l10n.auth_error_wrong_password;
      } else if (e.code ==
          'email-already-in-use') {
        errorMessage =
            l10n.auth_error_email_in_use;
      } else if (e.code ==
          'weak-password') {
        errorMessage =
            l10n.auth_error_weak_password;
      } else if (e.code == 'invalid-email') {
        errorMessage =
            l10n.auth_error_invalid_email;
      } else if (e.code ==
          'too-many-requests') {
        errorMessage =
        '嘗試次數過多，請稍後再試。';
      } else if (e.code ==
          'network-request-failed') {
        errorMessage =
        '網路連線異常，請確認網路後再試。';
      }

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          errorMessage,
          isError: true,
        );
      }
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Email 登入／註冊發生錯誤：$e',
      );
      debugPrint('$stackTrace');

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          '連線異常，請稍後再試。',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
    AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF7B1FA2),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 20,
              ),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    Icon(
                      Icons
                          .mark_email_unread_outlined,
                      size: 80,
                      color: const Color(0xFF9C27B0)
                          .withValues(alpha: 0.8),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      _isLoginMode
                          ? l10n.title_welcome_back
                          : l10n
                          .title_register_account,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A148C),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email 輸入框
                    TextField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType:
                      TextInputType.emailAddress,
                      textInputAction:
                      TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization:
                      TextCapitalization.none,
                      autofillHints: const [
                        AutofillHints.email,
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.label_email,
                        hintText:
                        'name@example.com',
                        labelStyle:
                        const TextStyle(
                          color: Color(0xFF7B1FA2),
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF9C27B0),
                        ),
                        filled: true,
                        fillColor: Colors.white
                            .withValues(alpha: 0.8),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(
                            color: Color(0xFFBA68C8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 密碼輸入框
                    TextField(
                      controller:
                      _passwordController,
                      enabled: !_isLoading,
                      obscureText:
                      _obscurePassword,
                      textInputAction:
                      TextInputAction.done,
                      autofillHints: [
                        _isLoginMode
                            ? AutofillHints.password
                            : AutofillHints
                            .newPassword,
                      ],
                      onSubmitted: (_) {
                        if (!_isLoading) {
                          _submit();
                        }
                      },
                      decoration: InputDecoration(
                        labelText:
                        l10n.label_password,
                        labelStyle:
                        const TextStyle(
                          color: Color(0xFF7B1FA2),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF9C27B0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(
                              0xFF9C27B0,
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                            setState(() {
                              _obscurePassword =
                              !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white
                            .withValues(alpha: 0.8),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                          borderSide:
                          const BorderSide(
                            color: Color(0xFFBA68C8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    if (_isLoginMode) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment:
                        Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : _resetPassword,
                          child: Text(
                            l10n.forgot_password,
                            style: const TextStyle(
                              color:
                              Color(0xFF7B1FA2),
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // 登入／註冊按鈕
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFFBA68C8),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        const Color(0xFFBA68C8)
                            .withValues(alpha: 0.5),
                        minimumSize:
                        const Size(
                          double.infinity,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(25),
                        ),
                        elevation: 3,
                      ),
                      onPressed:
                      _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : Text(
                        _isLoginMode
                            ? l10n.action_login
                            : l10n
                            .action_register,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      '首次登入或條款更新時，'
                          '系統將請您閱讀並同意服務條款及隱私權政策。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 登入／註冊模式切換
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        setState(() {
                          _isLoginMode =
                          !_isLoginMode;
                          _passwordController
                              .clear();
                          _obscurePassword =
                          true;
                        });
                      },
                      child: Text(
                        _isLoginMode
                            ? l10n
                            .prompt_no_account
                            : l10n
                            .prompt_has_account,
                        style: const TextStyle(
                          color: Color(0xFF7B1FA2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
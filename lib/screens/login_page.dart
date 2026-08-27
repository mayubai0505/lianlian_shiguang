import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//登入介面

enum LoginMethod {
  google,
  apple,
  facebook,
  email,
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
bool _isLoginLoading = false;
class _LoginPageState extends State<LoginPage> {
  static const String _currentTermsVersion = '1.0';
  static const String _currentPrivacyVersion = '1.0';

  // ⚠️ 換成你公開發布後的 Notion 網址
  static const String _termsNotionUrl =
      'https://adaptable-roof-829.notion.site/3ab919a5415180e89545dce77d552a6c';

  static const String _privacyNotionUrl =
      'https://adaptable-roof-829.notion.site/3ab919a541518035ad5ec56427a427ec';

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

  // 👇 總裁，把這整段「同步大頭貼」的功能本體貼進來 👇
  Future<void> syncUserAvatar() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.photoURL != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          // ⚠️ 記得確認這裡的 key 是妳資料庫裡存頭貼的欄位名稱！
          // 例如：'characterAvatarPath' 或是 'photoUrl'
          'photoUrl': user.photoURL,
        }, SetOptions(merge: true));

        debugPrint('✅ 登入成功：大頭貼網址已自動同步更新！');
      } catch (e) {
        debugPrint('⚠️ 大頭貼同步更新失敗: $e');
      }
    }
  }

  // 👆 貼到這裡結束 👆


  // ✨ 處理登入成功後的轉場
  Future<void> _handleLoginSuccess(Map<String, dynamic> resultMap,) async {
    final User? user =
    resultMap['user'] as User?;

    final bool isNewUser =
        resultMap['isNewUser'] as bool? ?? false;

    if (user == null) return;

    // 先確認服務條款與隱私權政策
    final bool agreementAccepted =
    await _ensureCurrentAgreement(user);

    if (!agreementAccepted) {
      // 未完成同意，不允許進入 App
      await _authService.signOut(context);
      return;
    }

    if (!mounted) return;

    // 同步登入帳號的大頭貼
    await syncUserAvatar();

    if (!mounted) return;

    if (isNewUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
          const OnboardingPage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
          const MainPage(),
        ),
      );
    }
  }

  void _showLoginMethodInfoDialog(LoginMethod method) {
    String title = '';
    String providerName = '';

    switch (method) {
      case LoginMethod.google:
        title = 'Google 快速登入';
        providerName = 'Google';
        break;

      case LoginMethod.apple:
        title = 'Apple 登入';
        providerName = 'Apple';
        break;

      case LoginMethod.facebook:
        title = 'Facebook 登入';
        providerName = 'Facebook';
        break;

      case LoginMethod.email:
        title = '戀戀帳號（Email）';
        providerName = '戀戀帳號（Email）';
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              '''
使用 $providerName 登入《戀戀拾光》。

請注意：

• $providerName 與其他登入方式為不同帳號系統。

• 若使用 $providerName 建立帳號，請持續使用相同方式登入。

• 角色資料、聊天紀錄與購買內容不會與其他登入方式互通。

建議首次登入後持續使用相同的登入方式，以避免建立不同帳號而導致資料無法共用。
''',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('知道了'),
            ),
          ],
        );
      },
    );
  }

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
                    final uri = Uri.tryParse(url);

                    if (uri == null ||
                        !uri.hasScheme ||
                        !uri.hasAuthority) {
                      throw const FormatException(
                        '條款網址格式不正確',
                      );
                    }

                    // 與設定頁相同：直接在 App 內用 WebView 開啟。
                    await Navigator.of(dialogContext).push(
                      MaterialPageRoute(
                        builder: (_) => _PolicyWebViewPage(
                          title: title,
                          url: url,
                        ),
                      ),
                    );

                    if (!dialogContext.mounted) return;

                    setDialogState(() {
                      hasOpenedPolicy = true;
                    });
                  } catch (e) {
                    debugPrint('❌ 開啟 $title 失敗：$e');

                    if (dialogContext.mounted) {
                      ToastUtils.showCenterToast(
                        dialogContext,
                        '無法開啟$title，請確認網路後再試。',
                        customIcon: Icons.link_off_rounded,
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
                      borderRadius: BorderRadius.circular(20),
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
                              '閱讀後回到《戀戀拾光》，即可按下「我已閱讀並同意」。',
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
                          Navigator.of(dialogContext)
                              .pop(false);
                        },
                        child: const Text('取消登入'),
                      ),
                      ElevatedButton(
                        onPressed: hasOpenedPolicy
                            ? () {
                          Navigator.of(dialogContext)
                              .pop(true);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('我已閱讀並同意'),
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

  Future<bool> _ensureCurrentAgreement(User user,) async {
    final l10n = AppLocalizations.of(context)!;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      final userDoc = await userRef.get();
      final data =
          userDoc.data() ?? <String, dynamic>{};

      final bool termsAreCurrent =
          data['acceptedTermsVersion'] ==
              _currentTermsVersion;

      final bool privacyIsCurrent =
          data['acceptedPrivacyVersion'] ==
              _currentPrivacyVersion;

      // 同一版本已同意，不再重複顯示
      if (termsAreCurrent && privacyIsCurrent) {
        return true;
      }

      bool acceptedTermsThisTime = termsAreCurrent;
      bool acceptedPrivacyThisTime = privacyIsCurrent;

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
          title: l10n.legal_privacy_button,
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

        // 留存當時同意的來源網址，日後較好查核
        'acceptedTermsUrl': _termsNotionUrl,
        'acceptedPrivacyUrl':
        _privacyNotionUrl,
      }, SetOptions(merge: true));

      debugPrint(
        '✅ 已記錄條款同意版本：'
            'terms=$_currentTermsVersion，'
            'privacy=$_currentPrivacyVersion',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ 檢查條款同意狀態失敗：$e');
      debugPrint('$stackTrace');

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          '目前無法確認條款狀態，請稍後再試。',
          customIcon: Icons.error_outline,
        );
      }

      return false;
    }
  }

  // 🌟 終極合併版：負責控制蝴蝶、精準紀錄、以及轉場導向
  Future<void> _performLogin(
      Future<Map<String, dynamic>?> Function() loginMethod,) async {
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
        // ⭐ 檢查是否有刪除申請
        final user = result['user'];
        if (user != null) {
          final bool hasDeleteRequest =
          await _authService.hasPendingDeleteRequest(
            user.uid,
          );

          if (hasDeleteRequest) {
            final bool restored =
            await _showRestoreAccountDialog(context);
            if (!restored) {
              await _authService.signOut(context);
              return;
            }
          }
        }
        print("✅ [3. 成功] 拿到資料了，準備穿越時光隧道 (跳轉中)！");
        await _handleLoginSuccess(result);
      } else if (result != null && !mounted) {
        print("🚀 [超車提示] 登入其實成功了！資料也拿到了！");
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
    final bool showGoogleLogin = true;
    // ✅ Apple 登入只在 iOS / iPadOS 顯示
    final bool showAppleLogin =
        kIsWeb ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                const SizedBox(height: 60),

                // 🚀 Google 登入
                if (showGoogleLogin) ...[
                  _buildLoginButton(
                    infoMethod: LoginMethod.google,
                    text: l10n.login_with_google,
                    iconWidget: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24,
                    ),
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    onPressed: () {
                      _performLogin(_authService.signInWithGoogle);
                    },
                  ),
                ],

// ✅ Apple 登入：只在 iOS / iPadOS 顯示
                if (showAppleLogin) ...[
                  _buildLoginButton(
                    infoMethod: LoginMethod.apple,
                    text: l10n.login_with_apple,
                    iconWidget: const Icon(
                      Icons.apple,
                      color: Colors.white,
                      size: 28,
                    ),
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      _performLogin(_authService.signInWithApple);
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // 🚀 Facebook 登入
                if (showFacebookLogin) ...[
                  const SizedBox(height: 16),
                  _buildLoginButton(
                    infoMethod: LoginMethod.facebook,
                    text: l10n.login_with_facebook,
                    iconWidget: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 28,
                    ),
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    onPressed: () {
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
                  infoMethod: LoginMethod.email,
                  text: l10n.login_with_email,
                  iconWidget: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 23,
                  ),
                  backgroundColor: const Color(0xFFBA68C8),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailLoginPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: Text(
                    '首次登入或條款更新時，系統將請您閱讀並同意服務條款及隱私權政策。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showRestoreAccountDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!; // 確保有這行來抓取語系

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.restoreAccountDialogTitle,
          ),
          content: Text(
            l10n.restoreAccountDialogContent,
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancelLoginButton),
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
            ),
            TextButton(
              child: Text(
                l10n.restoreAccountButton,
              ),
              onPressed: () async {
                await _authService.cancelDeleteAccount();
                Navigator.pop(
                  context,
                  true,
                );
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  // ✨ 按鈕工廠
  Widget _buildLoginButton({
    required String text,
    required Widget iconWidget,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    LoginMethod? infoMethod,
  }) {
    final screenWidth = MediaQuery
        .sizeOf(context)
        .width;
    final l10n = AppLocalizations.of(context)!;
    // 小螢幕減少左右留白，避免按鈕內容太擠
    final horizontalPadding =
    screenWidth < 360 ? 20.0 : 40.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor:
          backgroundColor.withValues(alpha: 0.6),
          elevation: 2,
          padding: EdgeInsets.zero,
          minimumSize: const Size(
            double.infinity,
            54,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        onPressed: _isLoginLoading
            ? null
            : onPressed,
        child: SizedBox(
          height: 54,
          child: Row(
            children: [
              // 左側圖示固定區域
              SizedBox(
                width: 48,
                child: Center(
                  child: iconWidget,
                ),
              ),

              // 中間文字會依剩餘空間自動縮小
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // 右側固定相同寬度，維持文字視覺置中
              SizedBox(
                width: 48,
                child: infoMethod == null
                    ? SizedBox.shrink()
                    : IconButton(
                  tooltip: l10n.loginMethodInfoTooltip,
                  splashRadius: 18,
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: 19,
                    color: textColor.withValues(
                      alpha: 0.72,
                    ),
                  ),
                  onPressed: () {
                    _showLoginMethodInfoDialog(
                      infoMethod,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const _PolicyWebViewPage({
    required this.title,
    required this.url,
  });

  @override
  State<_PolicyWebViewPage> createState() =>
      _PolicyWebViewPageState();
}

class _PolicyWebViewPageState extends State<_PolicyWebViewPage> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true) return;
            if (!mounted) return;

            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: '重新整理',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _hasError = false;
                _isLoading = true;
              });
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError)
            WebViewWidget(
              controller: _controller,
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 2.2,
              ),
            ),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 58,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '頁面載入失敗',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '請確認網路連線後再試一次。',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });

                        _controller.loadRequest(
                          Uri.parse(widget.url),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('重新載入'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
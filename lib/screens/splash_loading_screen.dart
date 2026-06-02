import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // 記得保留這個 import

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

// 載入動畫 (改成 StatefulWidget 才能監聽畫面載入完成)
class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  // 用來記錄圖片是不是已經載入過了
  bool _imagesPreloaded = false;

  // 🌟 使用 didChangeDependencies 而不是 initState，因為預載圖片需要 context
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 確保預載動作只執行一次
    if (!_imagesPreloaded) {
      _imagesPreloaded = true;
      _preloadImagesAndUnlockSplash();
    }
  }

  // 🛡️ 核心防護網：強制預先載入
  Future<void> _preloadImagesAndUnlockSplash() async {
    try {
      // 1. 下令 Flutter：先把這兩張圖給我解碼，放進記憶體等著！
      await Future.wait([
        precacheImage(const AssetImage('assets/images/splash_bg_only.png'), context),
        precacheImage(const AssetImage('assets/images/butterfly_transparent.png'), context),
      ]);
    } catch (e) {
      debugPrint("圖片預載失敗: $e");
    }

    // 2. 確定圖片都 100% 準備好了，才下令把死守在最前面的「原生漸層畫面」撤掉！
    if (mounted) {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // ✨ 1. 滿版漸層背景
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_bg_only.png'),
            fit: BoxFit.cover,
          ),
        ),
        // ✨ 2. Stack 分層排版
        child: Stack(
          children: [
            // 🦋 第一層：絕對置中的蝴蝶
            Center(
              child: Image.asset(
                'assets/images/butterfly_transparent.png',
                // 這裡的數字可以微調，讓它跟原生畫面的蝴蝶大小一模一樣
                width: 250,
              ),
            ),

            // ⏳ 第二層：底部的載入文字與動畫
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.splash_loading_universe,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : const Color(0xFF7B1FA2),
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              isDark ? Colors.white70 : const Color(0xFF7B1FA2)),
                          backgroundColor:
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
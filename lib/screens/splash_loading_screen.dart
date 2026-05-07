import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//載入動畫

class SplashLoadingScreen extends StatelessWidget {
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 取得當前主題，確保載入頁也符合深淺色模式
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // 使用漸層背景，讓等待的過程也很有質感
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF100B20), const Color(0xFF20163A)]
            // 🌸 淺色模式：浪漫溫柔的淡紫色漸層 (依您的要求修改)
                : [const Color(0xFFF8F0FB), const Color(0xFFE1BEE7)], // ✨ 這裡是新的淡紫配色喔
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌸 1. 這裡放您的 Logo 圖片
            // 如果還沒有 Logo 圖片，可以先用一個漂亮的 Icon 暫代
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha:0.1),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha:0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome, // 替換成您的 Logo: Image.asset('assets/images/logo.png')
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 40),

            // ✨ 2. 載入文字
            SizedBox(
              height: 30, // 給一個固定的高度，讓渲染引擎不要因為字體載入而亂縮放
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.splash_loading_universe,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withValues(alpha:0.8),
                    letterSpacing: 2.0, // 字距拉開一點比較有呼吸感
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // ⏳ 3. 載入動畫 (精緻的圓形進度條)
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                backgroundColor: theme.colorScheme.primary.withValues(alpha:0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
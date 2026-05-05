// 這個檔案只會在非 Web 平台（如 iOS、Android）被編譯和使用
part of 'firebase_options_platform.dart';

class _PlatformFirebaseOptionsNonWeb
    implements PlatformFirebaseOptionsInterface {
  // --- 修正：改回了最簡單的同步錯誤拋出方式 ---
  @override
  FirebaseOptions get currentPlatformFirebaseOptions {
    // 在非 Web 平台上，我們通常不使用這種手動方式獲取配置。
    // Firebase CLI 會自動生成一個 `firebase_options.dart` 檔案。
    // 因此，這個實現可以是一個空的或拋出錯誤的佔位符。
    throw UnsupportedError(
      'This method should not be called on non-web platforms. '
      'Use DefaultFirebaseOptions.currentPlatform instead.',
    );
  }

  // --- 修正：改回了最簡單的同步回傳 null ---
  @override
  String? get initialAuthToken {
    // 初始 Token 只與 Web 平台相關
    return null;
  }
}

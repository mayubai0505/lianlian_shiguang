// 這個檔案是 Firebase 配置的平台特定實現的「主檔案」
library firebase_options_platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:js/js_util.dart' as js_util; // 導入 js_util 供 web part 使用
import 'package:web/web.dart' as web; // 🌟 取代 dart:html
import 'dart:js_interop';            // 🌟 新一代 JS 溝通核心
import 'dart:js_interop_unsafe';     // 🌟 專門處理像 __initial_auth_token 這種自訂屬性   // 🌟 搬過來這裡

// Dart 編譯器會根據目標平台，自動選擇其中一個 part 檔案來編譯。
part 'firebase_options_platform.web.dart';
part 'firebase_options_platform.non_web.dart';

/// 這是 FirebaseOptions 的平台特定實現的抽象接口。
abstract class PlatformFirebaseOptionsInterface {
  // --- 修正：改回了最簡單的同步獲取方式 ---
  FirebaseOptions get currentPlatformFirebaseOptions;
  String? get initialAuthToken;
}

/// 一個頂層的 getter，它會根據當前是否為 Web 平台，
/// 返回正確的平台實現實例。
PlatformFirebaseOptionsInterface get platformFirebaseOptions {
  if (kIsWeb) {
    return _PlatformFirebaseOptionsWeb();
  } else {
    return _PlatformFirebaseOptionsNonWeb();
  }
}

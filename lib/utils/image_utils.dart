import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io';

// 這是一個「頂層函式」，不屬於任何 class，因此可以在 App 的任何地方被呼叫。
ImageProvider getAvatarImageProvider(String path) {
  // 優先處理 http 網路圖片
  if (path.startsWith('http')) {
    // 使用 NetworkImage，並加入錯誤處理，如果載入失敗就顯示預設頭像
    return NetworkImage(path,
      scale: 1.0, // 確保圖片品質
    );
  }
  // 處理 App 內部的 assets 圖片
  if (path.startsWith('assets/')) {
    return AssetImage(path);
  }
  // 處理手機本地檔案 (僅限非網頁平台)
  if (!kIsWeb) {
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
  }
  // 如果以上都不是，或檔案不存在，回傳一個最安全的預設頭像
  return const AssetImage('assets/images/avatar1.png');
}
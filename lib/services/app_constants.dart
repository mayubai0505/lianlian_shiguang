import 'package:flutter/material.dart';

// 🌟 遊戲總部設定檔案
class AppConfig {
  // 🌸 遊戲的身分地址 (Firebase 路徑)
  static const String appId = "lianlianshiguang";
  static const String version = "1.0.1";

  // 💰 每日簽到獎勵
  static const int dailyCheckIn = 10;

  // 🎨 全域色調設定
  static const Color primaryColor = Color(0xFFFFB6C1); // 櫻花粉

  // 🌸 👇👇👇 完美加在這裡：各種聊天模式的花朵消耗量 👇👇👇
  static const int costDailyChat = 1;       // 舊版日常模式（相容保留）
  static const int costGeminiChat = 1;      // 閒聊：標準價格 1 花；每日前 10 次免費由後端判斷
  static const int costStoryChat = 5;       // 故事模式
  static const int costImmersiveChat = 7;   // 沉浸模式
  static const int costResonanceChat = 10;  // 共鳴模式
}
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
  static const int costDailyChat = 1;      // 一般聊天
  static const int costStoryChat = 5;      // 故事模式
  static const int costImmersiveChat = 7;  // 沉浸模式
  static const int costGeminiChat = 0;     // Gemini 模式
}
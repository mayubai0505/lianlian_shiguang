import 'package:flutter/material.dart';

// 🌟 遊戲總部設定檔案
class AppConfig {
  // 🌸 遊戲的身分地址 (Firebase 路徑)
  // 之後如果想換名字，只要在這裡把 "default-app-id" 改成 "lianlianshiguang" 即可！
  static const String appId = "lianlianshiguang";
  static const String version = "1.0.1";

  // 💰 每日簽到獎勵
  static const int dailyCheckIn = 10;

  // 🎨 這裡甚至可以放一些全域的色調設定
  static const Color primaryColor = Color(0xFFFFB6C1); // 櫻花粉
}
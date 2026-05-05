import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class LawTextPage extends StatelessWidget {
  final String title;
  final String content;

  const LawTextPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFE6D5B8), // 🌟 用妳遊戲的溫暖色系
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6, // 🌟 讓行距大一點，比較好閱讀
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
// lib/app_texts.dart
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LegalDocumentPage extends StatelessWidget {
// 假設妳是用一個 boolean 來判斷：true 代表隱私權，false 代表服務條款
  final bool isPrivacyPolicy;

  const LegalDocumentPage({super.key, required this.isPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    // 🌟 1. 取得翻譯通行證
    final l10n = AppLocalizations.of(context)!;

    // 🌟 2. 根據參數，決定要抓哪一個標題、內容... 還有日期！
    final String pageTitle = isPrivacyPolicy
        ? l10n.privacy_policy_title
        : l10n.terms_title;

    final String pageContent = isPrivacyPolicy
        ? l10n.privacy_policy_body
        : l10n.terms_body;

    // 🌟 3. 動態抓取對應的更新日期
    final String updateTime = isPrivacyPolicy
        ? l10n.privacy_policy_date
        : l10n.terms_date;

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🕒 第一層：更新時間
            Text(
              updateTime,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // 📄 第二層：條款主要內容
            Text(
              pageContent,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
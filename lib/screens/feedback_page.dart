import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import 'package:url_launcher/url_launcher.dart'; // ✨ 1. 引入 url_launcher 套件
import 'package:flutter/services.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';

//意見回饋

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // ✨ 2. 新增一個 Controller 來獲取輸入的文字
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // ✨ 3. 新增一個函式來處理郵件傳送
  Future<void> _sendEmail() async {
    final l10n = AppLocalizations.of(context)!;
    final String feedbackText = _feedbackController.text.trim();

    if (feedbackText.isEmpty) {
      // ✨ 總裁級：表單防呆！輕量錯誤提示，俐落提醒玩家
      ToastUtils.showCenterToast(context, l10n.error_feedback_empty, isError: true);
      return;
    }

    // ⚠️ 請務必將 'your-email@example.com' 換成您自己要接收反饋的 Email 信箱！
    final String recipientEmail = 'shiguanglianlian@gmail.com';
    final String subject =l10n.email_subject_feedback;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(feedbackText)}',
    );

    // 嘗試啟動 Email App
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // 如果無法啟動郵件 App，可以給予提示並自動複製
      Clipboard.setData(ClipboardData(text: recipientEmail));

      // ✨ 總裁級：貼心幫玩家複製好 Email，並用帶圖示的輕量彈窗優雅告知
      if (context.mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.msg_email_app_not_found_copied,
          customIcon: Icons.copy, // 放一個複製的圖示，讓玩家一目了然
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // ✨ 4. 讀取主題相關的變數
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      // ✨ 5. 將 AppBar 和 body 的背景都設為透明或跟隨主題
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:  Text(l10n.title_contact_us),
        backgroundColor: Colors.transparent, // AppBar 背景透明
        elevation: 0,
        foregroundColor: theme.colorScheme.onBackground,
      ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: themeNotifier.currentBackground, // ✨ 使用漸層背景
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
            left: 24,
            right: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.title_contact_us_heading,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                  l10n.desc_contact_us_body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _feedbackController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: l10n.hint_enter_feedback,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  filled: true,
                  fillColor: theme.cardColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.email_outlined),
                label: Text(l10n.action_send_via_email),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _sendEmail, // ✨ 連接到傳送函式
              ),
            ],
          ),
        ),
          ),
        ),
    );
  }
}
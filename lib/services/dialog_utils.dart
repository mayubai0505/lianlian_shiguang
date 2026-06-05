import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // 用於日期判斷

class DialogUtils {
  /// 顯示帶有「今日不再顯示」功能的對話框
  static Future<void> showNoticeDialog(
      BuildContext context, {
        required String title,
        required String content,
        required String key, // 該提示的唯一識別碼
        VoidCallback? onConfirm,
      }) async {
    // 檢查今天是否已設定為不再顯示
    if (await _isSuppressedToday(key)) return;

    if (!context.mounted) return;

    bool doNotShowAgain = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // 強制玩家閱讀，直到互動
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: doNotShowAgain,
                title: const Text('今日不再顯示', style: TextStyle(fontSize: 14)),
                onChanged: (val) => setState(() => doNotShowAgain = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (doNotShowAgain) {
                  await _setSuppressedToday(key);
                }
                if (onConfirm != null) onConfirm();
                Navigator.pop(context);
              },
              child: const Text('確定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 檢查是否在今日內被抑制顯示
  static Future<bool> _isSuppressedToday(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final lastShownDate = prefs.getString('dialog_date_$key');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return lastShownDate == today;
  }

  /// 設定今日內不再顯示
  static Future<void> _setSuppressedToday(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('dialog_date_$key', today);
  }
}
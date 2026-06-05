import 'package:flutter/material.dart';

class ToastUtils {
  // 注意：這裡把底線拿掉了，並加上 static 和 BuildContext 參數
  static void showCenterToast(
      BuildContext context,
      String message, {
        bool isError = false,
        IconData? customIcon,
      }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // 背景透明，不阻擋視線
      builder: (BuildContext dialogContext) {
        // 1.5 秒後自動關閉彈窗
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
            Navigator.pop(dialogContext);
          }
        });

        return Center(
          child: Material(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 錯誤時顯示紅驚嘆號
                  if (isError) const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                  // 成功/一般提示顯示自訂圖示
                  if (!isError && customIcon != null) Icon(customIcon, color: Colors.amberAccent, size: 20),
                  // 圖示跟文字的間距
                  if (isError || customIcon != null) const SizedBox(width: 8),

                  Text(message, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
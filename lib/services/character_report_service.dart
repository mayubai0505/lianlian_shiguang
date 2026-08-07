import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/character_model.dart';
import '../screens/feedback_page.dart';
import 'toast_utils.dart';

class CharacterReportService {
  CharacterReportService._();

  static Future<void> showReportDialog({
    required BuildContext context,
    required Character character,
    String source = 'unknown',
  }) async {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入後再檢舉角色',
        isError: true,
      );
      return;
    }

    // 不讓創作者檢舉自己的角色
    if (currentUser.uid ==
        character.createdBy) {
      ToastUtils.showCenterToast(
        context,
        '無法檢舉自己建立的角色',
        isError: true,
      );
      return;
    }

    try {
      final result =
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => FeedbackPage(
            category:
            ReportCategory.character,
            lockCategory: true,
            characterId:
            character.id,
            characterName:
            character.name,
          ),
        ),
      );

      if (!context.mounted) return;

      if (result == true) {
        ToastUtils.showCenterToast(
          context,
          '檢舉已送出，我們會進行審核',
          customIcon:
          Icons.flag_outlined,
        );
      }
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 開啟角色檢舉頁失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        '無法開啟檢舉頁面，請稍後再試',
        isError: true,
      );
    }
  }
}
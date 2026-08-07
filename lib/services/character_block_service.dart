import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/character_model.dart';
import 'toast_utils.dart';

class CharacterBlockService {
  CharacterBlockService._();

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  /// 顯示封鎖確認視窗
  static Future<bool> showBlockDialog({
    required BuildContext context,
    required Character character,
  }) async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入後再封鎖角色',
        isError: true,
      );
      return false;
    }

    if (user.uid == character.createdBy) {
      ToastUtils.showCenterToast(
        context,
        '無法封鎖自己建立的角色',
        isError: true,
      );
      return false;
    }

    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.block_rounded,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 8),
                  Text('封鎖角色'),
                ],
              ),
              content: Text(
                '確定要封鎖「${character.name}」嗎？\n\n'
                    '封鎖後，你將不會再於邂逅、瞬間等推薦內容中看到這個角色。',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child: const Text('取消'),
                ),
                FilledButton(
                  style:
                  FilledButton.styleFrom(
                    backgroundColor:
                    Colors.redAccent,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child: const Text('確認封鎖'),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirmed) {
      return false;
    }

    return blockCharacter(
      context: context,
      character: character,
    );
  }

  /// 真正寫入封鎖資料
  static Future<bool> blockCharacter({
    required BuildContext context,
    required Character character,
  }) async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    try {
      debugPrint(
        '🚫 開始封鎖角色：${character.name} (${character.id})',
      );

      final blockedRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('blockedCharacters')
          .doc(character.id);

      await blockedRef.set(
        {
          'characterId': character.id,
          'name': character.name,
          'avatarPath':
          character.avatarPath,
          'createdBy':
          character.createdBy,
          'isBlocked': true,
          'blockedAt':
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      debugPrint(
        '✅ blockedCharacters 寫入成功：${character.id}',
      );

      if (!context.mounted) {
        return true;
      }

      ToastUtils.showCenterToast(
        context,
        '已封鎖「${character.name}」',
        customIcon:
        Icons.person_off_outlined,
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 封鎖角色失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (context.mounted) {
        ToastUtils.showCenterToast(
          context,
          '封鎖失敗，請稍後再試',
          isError: true,
        );
      }

      return false;
    }
  }

  /// 解除封鎖
  static Future<bool> unblockCharacter({
    required BuildContext context,
    required String characterId,
  }) async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return false;
    }

    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('blockedCharacters')
          .doc(characterId)
          .delete();

      if (context.mounted) {
        ToastUtils.showCenterToast(
          context,
          '已解除封鎖',
          customIcon:
          Icons.person_outline_rounded,
        );
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 解除封鎖失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (context.mounted) {
        ToastUtils.showCenterToast(
          context,
          '解除封鎖失敗，請稍後再試',
          isError: true,
        );
      }

      return false;
    }
  }
}
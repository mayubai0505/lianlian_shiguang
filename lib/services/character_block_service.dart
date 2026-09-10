import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      ToastUtils.showCenterToast(
        context,
        l10n.character_block_login_required,
        isError: true,
      );
      return false;
    }

    if (user.uid == character.createdBy) {
      ToastUtils.showCenterToast(
        context,
        l10n.character_block_self_forbidden,
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
              title: Row(
                children: [
                  const Icon(
                    Icons.block_rounded,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.character_block_title),
                ],
              ),
              content: Text(
                l10n.character_block_confirm_message(character.name),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child: Text(l10n.cancelButton),
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
                  child: Text(l10n.character_block_confirm),
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
    final l10n = AppLocalizations.of(context)!;
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
        l10n.character_block_success(character.name),
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
          l10n.character_block_failed,
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
    final l10n = AppLocalizations.of(context)!;
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
          l10n.character_unblock_success,
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
          l10n.character_unblock_failed,
          isError: true,
        );
      }

      return false;
    }
  }
}
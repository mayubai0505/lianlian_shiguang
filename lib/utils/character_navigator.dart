import 'package:flutter/material.dart';

import '../repositories/character_repository.dart';
import '../screens/character_profile_page.dart';
import '../screens/private_character_profile_page.dart';

class CharacterNavigator {
  CharacterNavigator._();

  static Future<void> open(
      BuildContext context, {
        required String characterId,
        String? fallbackName,
        String? sessionId,
      }) async {
    final String trimmedId =
    characterId.trim();

    // 先檢查 ID，再查快取
    if (trimmedId.isEmpty) {
      _showUnavailableDialog(
        context,
        fallbackName: fallbackName,
      );
      return;
    }

    final bool hasCachedCharacter =
    CharacterRepository.hasValidCache(
      trimmedId,
    );

    bool loadingDialogShown = false;

    // 沒有快取才顯示讀取圈
    if (!hasCachedCharacter) {
      loadingDialogShown = true;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      final result =
      await CharacterRepository.findById(
        trimmedId,
      );

      if (!context.mounted) {
        return;
      }

      // 有顯示讀取圈才關閉
      if (loadingDialogShown) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop();

        loadingDialogShown = false;
      }

      switch (result.status) {
        case CharacterLookupStatus
            .publicCharacter:
          final character =
              result.character;

          if (character == null) {
            _showUnavailableDialog(
              context,
              fallbackName: fallbackName,
            );
            return;
          }

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CharacterProfilePage(
                    character: character,
                    characterId: trimmedId,
                    sessionId: sessionId,
                  ),
            ),
          );
          break;

        case CharacterLookupStatus
            .ownPrivateCharacter:
          final character =
              result.character;

          if (character == null) {
            _showUnavailableDialog(
              context,
              fallbackName: fallbackName,
            );
            return;
          }

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PrivateCharacterProfilePage(
                    character: character,
                  ),
            ),
          );
          break;

        case CharacterLookupStatus.unavailable:
          _showUnavailableDialog(
            context,
            fallbackName: fallbackName,
          );
          break;
      }
    } catch (e, stackTrace) {
      debugPrint(
        '❌ CharacterNavigator 開啟失敗：$e',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!context.mounted) {
        return;
      }

      // 只有真的顯示過讀取圈才關閉
      if (loadingDialogShown) {
        final navigator = Navigator.of(
          context,
          rootNavigator: true,
        );

        if (navigator.canPop()) {
          navigator.pop();
        }

        loadingDialogShown = false;
      }

      _showErrorDialog(context);
    }
  }

  static void _showUnavailableDialog(
      BuildContext context, {
        String? fallbackName,
      }) {
    showDialog<void>(
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
                Icons.lock_outline_rounded,
                color: Colors.grey,
              ),
              SizedBox(width: 8),
              Text(
                '機密檔案',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 38,
                backgroundColor:
                Color(0xFFE0E0E0),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 42,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),

              if (fallbackName != null &&
                  fallbackName.trim().isNotEmpty)
                Text(
                  fallbackName.trim(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

              const SizedBox(height: 10),

              const Text(
                '此角色可能已轉為私人、下架、違規封存或刪除。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('我知道了'),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(
      BuildContext context,
      ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text('讀取失敗'),
          content: const Text(
            '暫時無法讀取角色資料，請稍後再試。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }
}
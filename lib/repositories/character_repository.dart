import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../screens/character_model.dart';
import '../services/app_constants.dart';

enum CharacterLookupStatus {
  publicCharacter,
  ownPrivateCharacter,
  unavailable,
}

class CharacterLookupResult {
  final CharacterLookupStatus status;
  final Character? character;

  const CharacterLookupResult({
    required this.status,
    this.character,
  });
}

class CharacterRepository {
  CharacterRepository._();

  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  // 🧠 角色記憶體快取
  static final Map<String, _CachedCharacterResult>
  _characterCache = {};

  // 快取有效時間
  static const Duration cacheDuration =
  Duration(minutes: 10);

  /// 檢查該角色是否有仍然有效的快取
  static bool hasValidCache(
      String characterId,
      ) {
    final String trimmedId =
    characterId.trim();

    if (trimmedId.isEmpty) {
      return false;
    }

    final cached =
    _characterCache[trimmedId];

    if (cached == null) {
      return false;
    }

    if (!cached.isValid) {
      _characterCache.remove(trimmedId);
      return false;
    }

    return true;
  }

  /// 清除單一角色快取
  static void invalidate(
      String characterId,
      ) {
    final String trimmedId =
    characterId.trim();

    if (trimmedId.isEmpty) {
      return;
    }

    _characterCache.remove(trimmedId);

    debugPrint(
      '🧹 已清除角色快取：$trimmedId',
    );
  }

  /// 清除全部角色快取
  static void clearCache() {
    _characterCache.clear();

    debugPrint('🧹 已清除所有角色快取');
  }

  /// 依角色 ID 尋找角色
  static Future<CharacterLookupResult> findById(
      String characterId,
      ) async {
    final String trimmedId =
    characterId.trim();

    if (trimmedId.isEmpty) {
      return const CharacterLookupResult(
        status:
        CharacterLookupStatus.unavailable,
      );
    }

    // ==========================================
    // 0. 優先使用有效快取
    // ==========================================
    final cached =
    _characterCache[trimmedId];

    if (cached != null && cached.isValid) {
      debugPrint(
        '⚡ 使用角色快取：$trimmedId',
      );

      return cached.result;
    }

    // 過期快取清掉
    if (cached != null) {
      _characterCache.remove(trimmedId);
    }

    // ==========================================
    // 1. 先查公開角色
    // ==========================================
    final publicDoc = await _db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters')
        .doc(trimmedId)
        .get();

    if (publicDoc.exists) {
      final character =
      await Character.fromFirestoreAsync(
        publicDoc,
      );

      final result =
      CharacterLookupResult(
        status: CharacterLookupStatus
            .publicCharacter,
        character: character,
      );

      _characterCache[trimmedId] =
          _CachedCharacterResult(
            result: result,
            cachedAt: DateTime.now(),
          );

      debugPrint(
        '💾 已快取公開角色：$trimmedId',
      );

      return result;
    }

    // ==========================================
    // 2. 公開區沒有，再查目前玩家自己的私人角色
    // ==========================================
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final privateDoc = await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(currentUser.uid)
          .collection('private_characters')
          .doc(trimmedId)
          .get();

      if (privateDoc.exists) {
        final character =
        await Character.fromFirestoreAsync(
          privateDoc,
        );

        final result =
        CharacterLookupResult(
          status: CharacterLookupStatus
              .ownPrivateCharacter,
          character: character,
        );

        _characterCache[trimmedId] =
            _CachedCharacterResult(
              result: result,
              cachedAt: DateTime.now(),
            );

        debugPrint(
          '💾 已快取私人角色：$trimmedId',
        );

        return result;
      }
    }

    // 找不到不要長時間快取，
    // 避免角色剛恢復公開時仍顯示不存在。
    return const CharacterLookupResult(
      status:
      CharacterLookupStatus.unavailable,
    );
  }
}

class _CachedCharacterResult {
  final CharacterLookupResult result;
  final DateTime cachedAt;

  const _CachedCharacterResult({
    required this.result,
    required this.cachedAt,
  });

  bool get isValid {
    return DateTime.now()
        .difference(cachedAt) <
        CharacterRepository.cacheDuration;
  }
}
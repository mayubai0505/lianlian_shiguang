import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 同帳號共用的「已看過教學」狀態。
/// true 為永久完成；不會在裝置間傳播 false，避免舊裝置重置新裝置紀錄。
/// 既有 SharedPreferences 只在這台裝置第一次綁定帳號時匯入，防止不同帳號互相污染。
class TutorialSeenSync {
  TutorialSeenSync._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const _migrationOwnerKey = 'tutorial_seen_legacy_owner_v1';

  static String _localKey(String uid, String key) => 'tutorial_seen_v1_${uid}_$key';

  static Future<bool> hasSeen(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return prefs.getBool(key) ?? false;

    final localKey = _localKey(uid, key);
    final localSeen = prefs.getBool(localKey) ?? false;
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (_auth.currentUser?.uid != uid) return false;
      final data = doc.data() ?? <String, dynamic>{};
      final seen = data['tutorialSeen'];
      if (seen is Map && seen[key] == true) {
        await prefs.setBool(localKey, true);
        return true;
      }

      // 舊版本只有不分帳號的 SharedPreferences。
      // 僅允許此裝置第一位完成綁定的 UID 匯入，防止切換帳號後交叉污染。
      var owner = prefs.getString(_migrationOwnerKey);
      if (owner == null) {
        owner = uid;
        await prefs.setString(_migrationOwnerKey, uid);
      }
      if (owner == uid && (prefs.getBool(key) ?? false)) {
        await markSeen(key);
        return true;
      }
      if (localSeen) {
        await markSeen(key);
        return true;
      }
      return false;
    } catch (error) {
      debugPrint('TutorialSeenSync.hasSeen($key): $error');
      return localSeen;
    }
  }

  static Future<void> markSeen(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      await prefs.setBool(key, true);
      return;
    }
    await prefs.setBool(_localKey(uid, key), true);
    try {
      await _db.collection('users').doc(uid).set({
        'tutorialSeen': {key: true},
      }, SetOptions(merge: true));
    } catch (error) {
      // 本機狀態保留；下次讀取將補送到 Firestore。
      debugPrint('TutorialSeenSync.markSeen($key): $error');
    }
  }
}

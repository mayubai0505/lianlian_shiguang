import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class CharacterService {
  // 🚀 靜態方法：讓大家不用實例化就能直接呼叫
  static Future<void> recordEncounter(Map<String, dynamic> characterData) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final charRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('characters')
        .doc(characterData['id']); // 使用角色的 ID

    // 執行雲端存檔 (使用 merge 防止覆蓋掉封鎖狀態)
    await charRef.set({
      'name': characterData['name'],
      'avatar': characterData['avatar'],
      'desc': characterData['desc'],
      'lastMetAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // 檢查是否有初始化過 isBlocked，沒有才補上
    final doc = await charRef.get();
    if (!doc.exists || (doc.data() as Map).containsKey('isBlocked') == false) {
      await charRef.update({'isBlocked': false});
    }
  }
}
// 檔案：lib/services/profile_service.dart
//ID讀取

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // ✨ 1. 確保這個 import 存在
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ✨ 2. 修正 import 路徑 (請將 your_project_name 換成您專案的名稱)
import 'package:lianlian_shiguang/models/player_profile.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ✨ 完美細節 1：抽離重複的上傳邏輯
  Future<String> _uploadAvatar(String uid, String avatarPath) async {
    // 如果是內建資產路徑，直接回傳不處理
    if (avatarPath.startsWith('assets')) return avatarPath;

    final fileName = 'avatar_${uid}_${DateTime.now().millisecondsSinceEpoch}.png';
    final ref = _storage.ref().child('user_avatars').child(uid).child(fileName);

    if (kIsWeb) {
      // 🌐 Web 環境處理：改用 XFile 轉二進位，解決 http.get 抓不到 blob 網址的問題
      final bytes = await XFile(avatarPath).readAsBytes();
      await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    } else {
      // 📱 行動裝置環境處理
      await ref.putFile(File(avatarPath), SettableMetadata(contentType: 'image/png'));
    }
    return await ref.getDownloadURL();
  }

  // ✨ 完美細節 2：建立個人檔案
  Future<void> createNewProfile(
  BuildContext context, {
    required String nickname,
    required String playerID,
    required String avatarPath,
    required String gender,
    required DateTime? birthDate,
  }) async {
    // 🌟 召喚翻譯年糕
    final l10n = AppLocalizations.of(context);

    final User? currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception(l10n?.error_user_not_found ?? "找不到使用者，請重新登入");

    // 檢查 ID 是否重複
    final idDoc = await _db.collection('playerIDs').doc(playerID).get();
    if (idDoc.exists) throw Exception(l10n?.error_id_taken ?? "此 ID 已被使用，請換一個！");

    // 上傳頭像 (調用私有方法)
    final String finalAvatarPath = await _uploadAvatar(currentUser.uid, avatarPath);

    final profileData = {
      'uid': currentUser.uid,
      'nickname': nickname,
      'playerID': playerID,
      'avatarPath': finalAvatarPath,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
      'isFirstBirthdayRewardClaimed': false,
    };

    // 使用 Batch 確保兩個文檔同時寫入成功
    final batch = _db.batch();
    batch.set(_db.collection('users').doc(currentUser.uid), profileData);
    batch.set(_db.collection('playerIDs').doc(playerID), {'uid': currentUser.uid});
    await batch.commit();

    // 同步到本地快取
    await _updateLocalPrefs(
      nickname: nickname,
      playerID: playerID,
      avatarPath: finalAvatarPath,
      gender: gender,
      birthDate: birthDate,
      isProfileComplete: true,
    );
  }

// ✨ 完美細節 3：更新個人檔案
  Future<void> updateExistingProfile(
      BuildContext context, {
    required String newNickname,
    required String newID,
    required String originalID,
    required bool hasChangedID,
    required bool isAgeEditable,
    required String avatarPath,
    required String gender,
    required DateTime? birthDate,
  }) async {
    // 🌟 召喚翻譯年糕
    final l10n = AppLocalizations.of(context);
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception(l10n?.error_user_not_found ?? "找不到使用者，請重新登入");

    final prefs = await SharedPreferences.getInstance();
    final dataToUpdate = <String, dynamic>{};

    // 1. 處理暱稱更新
    if (newNickname != prefs.getString('nickname')) {
      dataToUpdate['nickname'] = newNickname;
    }

    // 2. 處理頭像更新 (使用私有方法)
    if (avatarPath != prefs.getString('avatarPath')) {
      dataToUpdate['avatarPath'] = await _uploadAvatar(currentUser.uid, avatarPath);
    }

    // 3. 處理性別與生日
    if (gender != prefs.getString('gender')) dataToUpdate['gender'] = gender;
    if (birthDate != null && isAgeEditable) {
      dataToUpdate['birthDate'] = birthDate.toIso8601String();
    }

    // 4. 處理 ID 變更 (涉及多表，使用 Transaction)
    if (newID != originalID && !hasChangedID) {
      await _db.runTransaction((transaction) async {
        final newIdRef = _db.collection('playerIDs').doc(newID);
        final newIdDoc = await transaction.get(newIdRef);

        if (newIdDoc.exists) throw Exception(l10n?.error_id_taken_short ?? "此 ID 已被使用！");

        transaction.set(newIdRef, {'uid': currentUser.uid});
        if (originalID.isNotEmpty) {
          transaction.delete(_db.collection('playerIDs').doc(originalID));
        }

        dataToUpdate['playerID'] = newID;
        dataToUpdate['hasChangedID'] = true; // 資料庫也要存這個狀態
      });
    }

    // 5. 統一執行資料庫更新與本地同步
    if (dataToUpdate.isNotEmpty) {
      await _db.collection('users').doc(currentUser.uid).update(dataToUpdate);

      // 同步到本地
      await _updateLocalPrefs(
        nickname: dataToUpdate['nickname'] ?? prefs.getString('nickname'),
        playerID: dataToUpdate['playerID'] ?? prefs.getString('playerID'),
        avatarPath: dataToUpdate['avatarPath'] ?? prefs.getString('avatarPath'),
        gender: dataToUpdate['gender'] ?? prefs.getString('gender'),
        birthDate: birthDate, // 這裡要根據邏輯判斷，為了簡潔先略過
        hasChangedID: dataToUpdate['playerID'] != null,
      );
    }
  }

  // ✨ 完美細節 4：抽離本地同步邏輯
  Future<void> _updateLocalPrefs({
    required String nickname,
    required String playerID,
    required String avatarPath,
    required String gender,
    DateTime? birthDate,
    bool? isProfileComplete,
    bool? hasChangedID,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', nickname);
    await prefs.setString('playerID', playerID);
    await prefs.setString('avatarPath', avatarPath);
    await prefs.setString('gender', gender);
    if (isProfileComplete != null) await prefs.setBool('isProfileComplete', isProfileComplete);
    if (hasChangedID != null) await prefs.setBool('hasChangedID', hasChangedID);
    if (birthDate != null) {
      await prefs.setString('birthDate', birthDate.toIso8601String());
      await prefs.setBool('isAgeSet', true);
    }
  }
}

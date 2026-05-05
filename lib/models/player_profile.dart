// 檔案：lib/models/player_profile.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerProfile {
  final String uid;
  final String nickname;
  final String playerID;
  final String avatarPath;
  final String gender;
  final DateTime? birthDate;
  final DateTime? createdAt;

  PlayerProfile({
    required this.uid,
    required this.nickname,
    required this.playerID,
    required this.avatarPath,
    required this.gender,
    this.birthDate,
    this.createdAt,
  });

  PlayerProfile copyWith({
    String? uid,
    String? nickname,
    String? playerID,
    String? avatarPath,
    String? gender,
    DateTime? birthDate,
    DateTime? createdAt,
  }) {
    return PlayerProfile(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      playerID: playerID ?? this.playerID,
      avatarPath: avatarPath ?? this.avatarPath,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ✨ 功能1：將物件轉換成可以存入 Firestore 的 Map 格式
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'playerID': playerID,
      'avatarPath': avatarPath,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  // ✨ 功能2：從 Firestore 讀取的 Map 格式，轉換成我們的 PlayerProfile 物件
  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      playerID: map['playerID'] ?? '',
      avatarPath: map['avatarPath'] ?? '',
      gender: map['gender'] ?? 'Not Selected',
      birthDate:
          map['birthDate'] != null ? DateTime.tryParse(map['birthDate']) : null,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

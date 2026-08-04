import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // 為了 XFile
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ✨ 定義單張照片的資料結構
class CharacterPhoto {
  String imageUrl;
  XFile? localFile;
  int requiredAffection;
  String description;

  CharacterPhoto({
    required this.imageUrl,
    this.localFile,
    required this.requiredAffection,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'url': imageUrl, // 為了相容 Firebase 的寫法，統一把 key 設為 url
      'req': requiredAffection,
      'desc': description,
    };
  }

  factory CharacterPhoto.fromMap(Map<String, dynamic> map) {
    return CharacterPhoto(
      imageUrl: map['url'] ?? map['imageUrl'] ?? '',
      requiredAffection: map['req'] ?? map['requiredAffection'] ?? 0,
      description: map['desc'] ?? map['description'] ?? '',
    );
  }

  factory CharacterPhoto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CharacterPhoto.fromMap(data);
  }
}

// ✨ 定義單一顆「彩蛋 / 特殊劇情」的結構
class EasterEgg {
  final String id;
  final String keyword;
  final String title;
  final String teaser;
  final String contentPrompt;
  final String? setScene;

  EasterEgg({
    required this.id,
    required this.keyword,
    required this.title,
    required this.teaser,
    required this.contentPrompt,
    this.setScene,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keyword': keyword,
      'title': title,
      'teaser': teaser,
      'contentPrompt': contentPrompt,
      'setScene': setScene,
    };
  }

  factory EasterEgg.fromMap(Map<String, dynamic> map) {
    return EasterEgg(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      keyword: map['keyword'] ?? '',
      title: map['title'] ?? '',
      teaser: map['teaser'] ?? '',
      contentPrompt: map['contentPrompt'] ?? '',
      setScene: map['setScene'],
    );
  }
}

// ✨ 完整的角色模型
class Character {
  final String id;
  final String name;
  final String avatarPath;
  final String bannerImagePath;
  final List<String> galleryPaths;
  final List<CharacterPhoto>? gallery;
  final String createdBy;
  final String worldSetting;
  final String? storyModeFirstLine;
  final List<String>? identities;
  final DateTime createdAt;
  final String creatorName;
  final DateTime lastChatTime;
  final int playCount;
  final String age;
  final String occupation;
  final String birthday;
  final String height;
  final List<String> personalityTags;
  final String storySummary;
  final String initialStory;
  final String firstLine;
  final String background;
  final String detailedPersonality;
  final String appearance;
  final String gender;
  bool isPublic;
  final String toneAndStyle;
  final String likes;
  final int likesCount;
  final String dislikes;
  final String secrets;
  final String initialRelationship;
  final String dialogueExamples;
  final String playerIdentity;
  final List<EasterEgg> easterEggs;
  final List<String> extraInfoItems;
  final String? contentLanguage;
  final String stageStranger;
  final String stageAcquaintance;
  final String stageIntimate;
  final String? voicePreviewUrl;
  final String socialInteraction;
  final String? voiceId;
  final List<String>? likedGifts;
  final List<String>? dislikedGifts;
  final double? voiceStability;
  final double? voiceStyle;
  final Map<String, String>? relationships;
  final List<Map<String, dynamic>> npcCharacters;
  final Map<String, dynamic>? translations;

  Character({
    required this.id,
    required this.name,
    required this.avatarPath,
    this.bannerImagePath = '',
    required this.galleryPaths,
    this.gallery,
    required this.createdBy,
    required this.worldSetting,
    required this.createdAt,
    DateTime? lastChatTime,
    this.creatorName = '神祕創作者',
    required this.playCount,
    required this.age,
    required this.occupation,
    required this.birthday,
    required this.height,
    required this.personalityTags,
    required this.storySummary,
    required this.initialStory,
    required this.firstLine,
    required this.background,
    required this.appearance,
    required this.gender,
    required this.isPublic,
    this.detailedPersonality = '',
    required this.toneAndStyle,
    required this.likes,
    required this.likesCount,
    required this.dislikes,
    required this.secrets,
    this.storyModeFirstLine,
    required this.initialRelationship,
    required this.dialogueExamples,
    this.easterEggs = const [],
    required this.extraInfoItems,
    this.contentLanguage,
    this.stageStranger = '',
    this.stageAcquaintance = '',
    this.stageIntimate = '',
    this.socialInteraction = '',
    this.playerIdentity = '',
    this.voiceId,
    this.voicePreviewUrl,
    this.likedGifts,
    this.identities,
    this.dislikedGifts,
    this.voiceStability,
    this.voiceStyle,
    this.translations,
    this.relationships,
    this.npcCharacters = const [],
  }) : this.lastChatTime = lastChatTime ?? DateTime.fromMillisecondsSinceEpoch(0);


  static Future<Character> fromFirestoreAsync(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // 1. 處理 EasterEggs
    var eggsData = data['easterEggs'] as List<dynamic>?;
    List<EasterEgg> eggs = [];
    if (eggsData != null) {
      eggs = eggsData.map((e) => EasterEgg.fromMap(e as Map<String, dynamic>)).toList();
    }

    // 2. ✨ 核心修正：處理相簿 (gallery) 與 子集合 photos
    List<CharacterPhoto> finalGallery = [];

    try {
      // 先嘗試從最新的 photos 子集合抓取
      final photosSnapshot = await doc.reference.collection('photos').orderBy('orderIndex').get();
      if (photosSnapshot.docs.isNotEmpty) {
        finalGallery = photosSnapshot.docs.map((p) => CharacterPhoto.fromFirestore(p)).toList();
      }
      // 如果子集合沒有，才退回使用主文件的 gallery 欄位 (相容舊資料)
      else if (data['gallery'] != null) {
        List rawList = data['gallery'] as List;
        finalGallery = await Future.wait(rawList.map((e) async {
          var photo = CharacterPhoto.fromMap(Map<String, dynamic>.from(e));
          if (photo.imageUrl.startsWith('gs://')) {
            try {
              photo.imageUrl = await FirebaseStorage.instance.refFromURL(photo.imageUrl).getDownloadURL();
            } catch (err) {
              print("相簿圖片網址轉換失敗: $err");
            }
          }
          return photo;
        }).toList());
      }
    } catch (e) {
      print("讀取相簿資料時發生錯誤: $e");
    }

    // 3. ✨ 核心修正：處理大頭貼 (avatarPath)
    // 優先使用相簿裡的第一張照片當作大頭貼，確保更新聲線時絕對不會跳回預設圖！
    String avatar = 'assets/images/blank_avatar.png';
    if (finalGallery.isNotEmpty && finalGallery.first.imageUrl.isNotEmpty) {
      avatar = finalGallery.first.imageUrl;
    } else {
      // 若真的完全沒有相簿，才去讀舊的 avatarPath
      avatar = data['avatarPath'] ?? 'assets/images/blank_avatar.png';
      if (avatar.startsWith('gs://')) {
        try {
          avatar = await FirebaseStorage.instance.refFromURL(avatar).getDownloadURL();
        } catch (e) {
          print("大頭貼網址轉換失敗: $e");
        }
      }
    }

    return Character(
      id: doc.id,
      name: data['name'] ?? '',
      avatarPath: avatar,         // ✨ 使用最新的防呆大頭貼
      bannerImagePath: data['bannerImagePath']?.toString() ?? '',
      gallery: finalGallery,      // ✨ 帶入正確讀取到的相簿陣列
      galleryPaths: List<String>.from(data['galleryPaths'] ?? []),
      storyModeFirstLine: data['storyModeFirstLine'] ?? data['firstLine'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      playCount: data['playCount'] ?? 0,
      worldSetting:
      data['worldSetting']?.toString().trim().isNotEmpty == true
          ? data['worldSetting'].toString()
          : data['background']?.toString() ?? '',      likesCount: data['likesCount'] ?? 0,
      age: data['age'] ?? '',
      occupation: data['occupation'] ?? '',
      identities: data['identities'] != null ? List<String>.from(data['identities']) : [],
      birthday: data['birthday'] ?? '',
      height: data['height'] ?? '',
      personalityTags: List<String>.from(data['personalityTags'] ?? []),
      storySummary: data['storySummary'] ?? '',
      initialStory: data['story'] ?? '',
      firstLine: data['storyModeFirstLine'] ?? '',
      background: data['background'] ?? '',
      detailedPersonality: data['detailedPersonality'] ?? '',
      appearance: data['appearance'] ?? '',
      gender: data['gender'] ?? '未選擇',
      isPublic: data['isPublic'] ?? true,
      toneAndStyle: data['toneAndStyle'] ?? '',
      likes: data['likes'] ?? '',
      dislikes: data['dislikes'] ?? '',
      likedGifts: data['likedGifts'] != null ? List<String>.from(data['likedGifts']) : [],
      dislikedGifts: data['dislikedGifts'] != null ? List<String>.from(data['dislikedGifts']) : [],
      secrets: data['secrets'] ?? '',
      initialRelationship: data['initialRelationship'] ?? '',
      dialogueExamples: data['dialogueExamples'] ?? '',
      easterEggs: eggs,
      creatorName: data['creatorName'] ?? '神祕創作者',
      extraInfoItems: List<String>.from(data['extraInfoItems'] ?? []),
      contentLanguage: data['content_language'],
      stageStranger: data['stageStranger'] ?? '',
      stageAcquaintance: data['stageAcquaintance'] ?? '',
      stageIntimate: data['stageIntimate'] ?? '',
      socialInteraction: data['socialInteraction'] ?? '',
      playerIdentity: data['playerIdentity'] ?? '',
      voiceId: data['voiceId'] ?? data['voice_id'],
      voiceStability: data['voiceStability']?.toDouble(),
      voiceStyle: data['voiceStyle']?.toDouble(),
      voicePreviewUrl: data['voice_preview_url'] ?? data['voicePreviewUrl'],
      translations: data['translations'] as Map<String, dynamic>?,
      relationships: data['relationships'] != null
          ? Map<String, String>.from(data['relationships'])
          : {},
      npcCharacters:
      (data['npcCharacters'] as List<dynamic>?)
          ?.map(
            (item) => Map<String, dynamic>.from(
          item as Map,
        ),
      )
          .toList() ??
          [],
      lastChatTime: data['lastChatTime'] != null ? (data['lastChatTime'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatarPath': avatarPath,
      'bannerImagePath': bannerImagePath,
      'galleryPaths': galleryPaths,
      'gallery': gallery?.map((e) => e.toMap()).toList(),
      'createdBy': createdBy,
      'createdAt': createdAt,
      'creatorName': creatorName,
      'playCount': playCount,
      'age': age,
      'occupation': occupation,
      'identities': identities,
      'birthday': birthday,
      'height': height,
      'personalityTags': personalityTags,
      'storySummary': storySummary,
      'story': initialStory,
      'storyModeFirstLine': firstLine,
      'background': background,
      'detailedPersonality': detailedPersonality,
      'worldSetting': worldSetting,
      'appearance': appearance,
      'gender': gender,
      'isPublic': isPublic,
      'toneAndStyle': toneAndStyle,
      'likes': likes,
      'dislikes': dislikes,
      'likedGifts': likedGifts,
      'dislikedGifts': dislikedGifts,
      'secrets': secrets,
      'initialRelationship': initialRelationship,
      'dialogueExamples': dialogueExamples,
      'lastChatTime': Timestamp.fromDate(lastChatTime),
      'easterEggs': easterEggs.map((egg) => egg.toMap()).toList(),
      'extraInfoItems': extraInfoItems,
      'content_language': contentLanguage,
      'stageStranger': stageStranger,
      'stageAcquaintance': stageAcquaintance,
      'stageIntimate': stageIntimate,
      'socialInteraction': socialInteraction,
      'playerIdentity': playerIdentity,
      'voiceId': voiceId,
      'voice_preview_url': voicePreviewUrl,
      'voiceStability': voiceStability,
      'voiceStyle': voiceStyle,
      'relationships': relationships,
      'npcCharacters': npcCharacters,
    };
  }
}
// ✨ 全域工具函式：當我們只有 ID，但需要一個「預載中」的角色物件時使用
Character getCharacterById(String id) {
  return Character(
    id: id,
    name: "正在讀取中...",
    avatarPath: "assets/images/blank_avatar.png", // 使用妳定義的預設圖
    galleryPaths: [],
    gallery: [],
    createdBy: "system",
    createdAt: DateTime.now(),
    playCount: 0,
    likesCount: 0,
    age: "0",
    occupation: "未知",
    birthday: "...",
    height: "...",
    personalityTags: [],
    storySummary: "背景故事載入中...",
    initialStory: "初始劇情同步中...",
    firstLine: "正在準備開場白...",
    background: "正在加載背景...",
    worldSetting: "世界觀載入中...",
    detailedPersonality: "正在加載性格...",
    appearance: "外貌描述加載中...",
    gender: "未知",
    isPublic: false,
    toneAndStyle: "正在加載語氣...",
    likes: "...",
    dislikes: "尚未讀取",
    secrets: "...",
    initialRelationship: "陌生人",
    dialogueExamples: "對話範例讀取中...",
    extraInfoItems: [],
    // 以下為妳 model 裡的選填或預設欄位
    stageStranger: "初識",
    stageAcquaintance: "熟識",
    stageIntimate: "曖昧",
    socialInteraction: "",
    playerIdentity: "",
    identities: [],
    likedGifts: [],
    dislikedGifts: [],
    relationships: {},
    npcCharacters: [],
  );
}
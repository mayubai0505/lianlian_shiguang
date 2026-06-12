import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import '../services/toast_utils.dart';
import 'chat_page.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import 'character_model.dart';
import 'package:http/http.dart' as http; // ✨ 負責跟後端連線
 import 'package:audioplayers/audioplayers.dart'; // 記得匯入
import '../services/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';

// ✨ 這是一個既能「創建」也能「編輯」的萬能頁面
class CharacterEditPage extends StatefulWidget {
  final DocumentSnapshot? draftDoc;
  final Character? character;
  const CharacterEditPage({super.key, this.character,this.draftDoc});

  @override
  _CharacterEditPageState createState() => _CharacterEditPageState();
}

class _CharacterEditPageState extends State<CharacterEditPage> {
  final List<String> relationshipKeys = [
    'relationship_childhood_friend',
    'relationship_senior_junior',
    'relationship_bickering_couple',
    'relationship_colleagues',
    'relationship_other',
  ];
  String _getTranslatedLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'relationship_childhood_friend':
        return l10n.relationship_childhood_friend;
      case 'relationship_senior_junior':
        return l10n.relationship_senior_junior;
      case 'relationship_bickering_couple':
        return l10n.relationship_bickering_couple;
      case 'relationship_colleagues':
        return l10n.relationship_colleagues;
      case 'relationship_other':
        return l10n.relationship_other;
      default:
      // 如果找不到 Key（可能是舊資料手寫的內容），就直接回傳原本的字串
        return key;
    }
  }
  bool _isSaving = false;
  bool _isGeneratingVoice = false;
  bool _isInit = false; // ✨ 專屬防護旗標
  bool _isTestingSettings = false;
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'asia-east1');
  Map<String, String> _relationships = {};
  List<Map<String, dynamic>> _voiceSamples = [];
  List<Map<String, dynamic>> newSamples = [];
  List<Character> _myCharacters = [];
  String? _generatedVoiceId;
  String? _selectedVoiceId;    // 存聲音 ID
  static const String genderIdMale = 'male';
  static const String genderIdFemale = 'female';
  static const String genderIdOther = 'other';
  String? _currentDraftId;
  int? _selectedSampleIndex;
  int? _playingSampleIndex;
  String? _finalVoicePreviewUrl;
  Uint8List? _finalAudioBytes; // 🌟 加在 _finalVoicePreviewUrl 旁邊
  double _voiceStability = 0.33;
  double _voiceStyle = 0.75;
  // --- Controllers ---
  late AudioPlayer _audioPlayer;
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _ageController = TextEditingController();
  final _occupationController = TextEditingController();
  final _heightController = TextEditingController();
  final _appearanceController = TextEditingController();
  final _personalityController = TextEditingController();
  final _backgroundController = TextEditingController();
  final _storyController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _secretsController = TextEditingController();
  final _toneController = TextEditingController();
  final _detailedPersonalityController = TextEditingController();
  final _dialogueExamplesController = TextEditingController();
  final _extraInputController = TextEditingController();
  final _storySummaryController = TextEditingController();
  final _firstLineController = TextEditingController();
  final TextEditingController _customRelationshipController = TextEditingController();
  final _stageStrangerController = TextEditingController(); // 陌生階段
  final _stageAcquaintanceController = TextEditingController(); // 熟悉階段
  final _stageIntimateController = TextEditingController(); // 親密階段
  final _socialInteractionController = TextEditingController(); // 社交/環境互動
  final _playerIdentityController = TextEditingController(); // 玩家預設身分
  List<String> getRelationshipOptions(AppLocalizations l10n){ return[l10n.relationship_childhood_friend, // 青梅竹馬
  l10n.relationship_senior_junior,    // 學長學妹
  l10n.relationship_bickering_couple,   // 歡喜冤家
  l10n.relationship_colleagues,       // 職場同事
  l10n.relationship_other,     // 這裡用翻譯的「其他」
  ];}
  // --- State Variables ---
  bool _isDeleting = false; // 刪除狀態
  String _gender = '';
  List<String> _personalityTags = [];
  bool _isPublic = true;
  List<String> _extraInfoItems = [];
  // 變成這樣，用來存包含門檻與描述的完整圖片資料
  List<CharacterPhoto> _galleryPhotos = [];
  String? _selectedRelationship;
  List<EasterEgg> _easterEggs = [];//彩蛋
  // 🌟 變數升級為列表
  // --- Services ---
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String APP_ID = AppConfig.appId;
  bool get isEditing => widget.character != null;
  @override
  void initState() {
    super.initState();
    // 1. 初始化播放器
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      debugPrint("🔊 播放器狀態目前是: $state");
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        if (mounted) setState(() => _playingSampleIndex = null);
      }
    });
    _fetchMyCharacters();
    // ==========================================
    // 🌟 核心分流：決定畫面的初始資料來源
    // ==========================================
    if (isEditing && widget.character != null) {
      // ✨✨✨ 路線一：編輯現有角色 ✨✨✨
      final char = widget.character!;
      Map<String, dynamic> mapData = char.toMap();
      // -- 基本文字與設定 --
      _nameController.text = char.name;
      _ageController.text = char.age;
      _occupationController.text = char.occupation;
      _birthdayController.text = char.birthday  ;
      _heightController.text = char.height ;
      _backgroundController.text = char.background;
      _storySummaryController.text = char.storySummary;
      _storyController.text = char.initialStory;
      _firstLineController.text = char.firstLine;
      _toneController.text = char.toneAndStyle;
      _detailedPersonalityController.text = char.detailedPersonality;
      _likesController.text = char.likes;
      _dislikesController.text = char.dislikes;
      _secretsController.text = char.secrets;
      _appearanceController.text = char.appearance ;
      _dialogueExamplesController.text = char.dialogueExamples;
      // -- 陣列與清單 (保留妳的安全寫法) --
      _personalityTags = List.from(char.personalityTags);
      _easterEggs = List.from(char.easterEggs);
      _extraInfoItems = List<String>.from(char.extraInfoItems ); // 👈 統一留這個最安全的！
      // -- 權限 --
      _isPublic = char.isPublic;
      // -- 新增的進階設定欄位 --
      _playerIdentityController.text = mapData['playerIdentity'] ?? '';
      _stageStrangerController.text = mapData['stageStranger'] ?? '';
      _stageAcquaintanceController.text = mapData['stageAcquaintance'] ?? '';
      _stageIntimateController.text = mapData['stageIntimate'] ?? '';
      _socialInteractionController.text = mapData['socialInteraction'] ?? '';
      String savedGender1 = char.gender;
      if (savedGender1 == '男') {
        _gender = 'male';
      } else if (savedGender1 == '女') {
        _gender = 'female';
      } else if (savedGender1 == '其他') {
        _gender = 'other';
      } else {
        _gender = savedGender1;
      }      // -- 照片畫廊 --
      if (char.gallery != null) {
        _galleryPhotos = List.from(char.gallery!);
      } else {
        _galleryPhotos = char.galleryPaths.map((url) =>
            CharacterPhoto(imageUrl: url, requiredAffection: 0, description: '')
        ).toList();
      }
      _galleryPhotos.sort((a, b) => a.requiredAffection.compareTo(b.requiredAffection));
      // -- 關係設定 --
      if (char.relationships != null) {
        _relationships = Map<String, String>.from(char.relationships!);
      }
      String? oldRelation = char.initialRelationship;
      if (oldRelation.isNotEmpty) {        // 假設妳有一個 relationshipKeys 的常數 List
        if (relationshipKeys.contains(oldRelation)) {
          _selectedRelationship = oldRelation;
        } else {
          _selectedRelationship = 'relationship_other';
          _customRelationshipController.text = oldRelation;
        }
      }
      // -- 語音與音色設定 (統一整理在這裡) --
      _generatedVoiceId = char.voiceId;
      _selectedVoiceId = char.voiceId;
      _finalVoicePreviewUrl = char.voicePreviewUrl;
      _voiceStability = char.voiceStability ?? 0.33;
      _voiceStyle = char.voiceStyle ?? 0.75;

    } else if (widget.draftDoc != null) {
      // ✨✨✨ 路線二：從秘密工作室點擊草稿進來 ✨✨✨
      final data = widget.draftDoc!.data() as Map<String, dynamic>;

      // 1. 【基本欄位對齊】
      _nameController.text = data['name'] ?? '';
      _ageController.text = data['age']?.toString() ?? '';
      _occupationController.text = data['occupation'] ?? '';
      _birthdayController.text = data['birthday'] ?? '';
      _heightController.text = data['height']?.toString() ?? '';
      _appearanceController.text = data['appearance'] ?? '';
      _backgroundController.text = data['background'] ?? '';
      _storySummaryController.text = data['storySummary'] ?? '';
      _storyController.text = data['story'] ?? '';
      _firstLineController.text = data['storyModeFirstLine'] ?? '';
      _toneController.text = data['toneAndStyle'] ?? '';

      // 2. 【性別攔截】
      String savedGender = data['gender'] ?? '';
      if (savedGender == 'male' || savedGender == '男') _gender = 'male';
      else if (savedGender == 'female' || savedGender == '女') _gender = 'female';
      else if (savedGender == 'other' || savedGender == '其他') _gender = 'other';
      else _gender = savedGender;

      // 3. 【社交與演變】(這就是妳說沒跑出來的社交資料)
      _playerIdentityController.text = data['playerIdentity'] ?? '';
      _detailedPersonalityController.text = data['detailedPersonality'] ?? '';
      _stageStrangerController.text = data['stageStranger'] ?? '';
      _stageAcquaintanceController.text = data['stageAcquaintance'] ?? '';
      _stageIntimateController.text = data['stageIntimate'] ?? '';
      _socialInteractionController.text = data['socialInteraction'] ?? '';

      // 4. 【專屬語音】(修正為資料庫的下底線格式：voice_id)
      _generatedVoiceId = data['voice_id'];
      _selectedVoiceId = data['voice_id'];
      _finalVoicePreviewUrl = data['voice_preview_url'];
      // 數值轉換，防止 Firebase 的 double/int 混用噴錯
      _voiceStability = (data['voiceStability'] is num) ? data['voiceStability'].toDouble() : 0.33;
      _voiceStyle = (data['voiceStyle'] is num) ? data['voiceStyle'].toDouble() : 0.75;

      // 5. 【照片合併：對齊 url/req/desc】
      // ✨ 修正 2：讀取草稿時，如果是本機路徑，要還原成 XFile
      List<CharacterPhoto> tempGallery = [];
      if (data['gallery'] != null) {
        var rawGallery = data['gallery'] as List<dynamic>;
        tempGallery = rawGallery.map((item) {
          final photoData = item as Map<String, dynamic>;
          final String savedUrl = photoData['url'] ?? '';

          return CharacterPhoto(
              imageUrl: savedUrl.startsWith('http') ? savedUrl : '',
              // 如果不是 http 開頭，代表它是上次存在手機裡的暫存檔，還原給 localFile
              localFile: (!savedUrl.startsWith('http') && savedUrl.isNotEmpty) ? XFile(savedUrl) : null,
              requiredAffection: photoData['req'] ?? 0,
              description: photoData['desc'] ?? ''
          );
        }).where((photo) => photo.imageUrl.isNotEmpty || photo.localFile != null).toList(); // 放寬條件：有本機檔案的也要留著！
      }

      // ✨ 修正 3：大頭貼也比照辦理
      String? mainAvatar = data['avatarPath'];
      if (mainAvatar != null && mainAvatar.isNotEmpty) {
        bool alreadyIn = tempGallery.any((p) =>
        p.imageUrl == mainAvatar || (p.localFile != null && p.localFile!.path == mainAvatar));
        if (!alreadyIn) {
          tempGallery.insert(0, CharacterPhoto(
              imageUrl: mainAvatar.startsWith('http') ? mainAvatar : '',
              localFile: (!mainAvatar.startsWith('http') && mainAvatar.isNotEmpty) ? XFile(mainAvatar) : null,
              requiredAffection: 0,
              description: ''
          ));
        }
      }
      _galleryPhotos = tempGallery;
      _galleryPhotos.sort((a, b) => a.requiredAffection.compareTo(b.requiredAffection));
      // 1. 【初始關係：翻譯轉換】
      // 解決顯示 "relationship_other" 或 "relationship_childhood_friend" 的問題
      final savedRel = data['initialRelationship'] ?? '';
      const builtInKeys = [
        'relationship_childhood_friend',
        'relationship_senior_junior',
        'relationship_bickering_couple',
        'relationship_colleagues'
      ];

      if (savedRel == '' || savedRel == null) {
        _selectedRelationship = null;
        _customRelationshipController.clear();
      } else if (builtInKeys.contains(savedRel)) {
        // 它是內建英文 Key，我們把它指派給選單變數，Dropdown 會自己變中文
        _selectedRelationship = savedRel;
        _customRelationshipController.clear();
      } else {
        // 如果存的是 "relationship_other" 或者是玩家寫的「中文」
        _selectedRelationship = 'relationship_other';
        if (savedRel == 'relationship_other') {
          _customRelationshipController.clear(); // 如果只是 "其他" 這個選項，就清空輸入框
        } else {
          _customRelationshipController.text = savedRel; // 顯示玩家寫的「鄰居」、「前任」等
        }
      }

      // 2. 【身分設定】
      _playerIdentityController.text = data['playerIdentity'] ?? '';

      // 3. 【社交圈：與其他角色的關係 (Tab 3)】
      // 總裁，重點來了！妳剛才的 debugPrint 裡「真的沒有」relationships 這個欄位！
      // 我們嘗試抓看看妳可能存錯的名字
      var relData = data['relationships'] ?? data['character_relationships'] ?? data['related_characters'];
      if (relData != null) {
        _relationships = Map<String, String>.from(relData);
      } else {
        _relationships = {}; // 真的沒抓到，就只能給空的
      }
      // 8. 【標籤與彩蛋】
      if (data['personalityTags'] != null) _personalityTags = List<String>.from(data['personalityTags']);
      if (data['extraInfoItems'] != null) _extraInfoItems = List<String>.from(data['extraInfoItems']);
      if (data['easterEggs'] != null) {
        var rawEggs = data['easterEggs'] as List<dynamic>;
        _easterEggs = rawEggs.map((eggData) => EasterEgg(
          id: eggData['id'] ?? '',
          keyword: eggData['keyword'] ?? '',
          title: eggData['title'] ?? '',
          teaser: eggData['teaser'] ?? '',
          contentPrompt: eggData['contentPrompt'] ?? '',
        )).toList();
      }

      _currentDraftId = widget.draftDoc!.id;
    } else {
      // ✨✨✨ 路線三：完全從零開始的全新角色 ✨✨✨
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDraftData();
      });
    }
  }
  // ✨✨✨ 完美的翻譯與初始化區塊 ✨✨✨
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🛡️ 啟動防護罩：確保只在剛進頁面時翻譯一次！
    if (!_isInit) {
      // 這裡可以安全地取得翻譯字典
      final l10n = AppLocalizations.of(context)!;

      // 掃描所有的照片，幫空字串補上翻譯
      for (int i = 0; i < _galleryPhotos.length; i++) {
        if (_galleryPhotos[i].description.isEmpty) {
          // 💡 總裁小知識：在 didChangeDependencies 裡面直接改值就好，
          // 不需要寫 setState，因為系統執行完這裡，本來就會緊接著去跑 build() 更新畫面！
          _galleryPhotos[i].description = isEditing
              ? l10n.default_photo_desc
              : l10n.draft_photo_desc;
        }
      }

      // 事情做完後，把大門鎖上！
      _isInit = true;
    }
  }
  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _heightController.dispose();
    _appearanceController.dispose();
    _personalityController.dispose();
    _backgroundController.dispose();
    _storyController.dispose();
    _detailedPersonalityController.dispose();
    _likesController.dispose();
    _dislikesController.dispose();
    _secretsController.dispose();
    _toneController.dispose();
    _dialogueExamplesController.dispose();
    _extraInputController.dispose();
    _storySummaryController.dispose();
    _firstLineController.dispose();
    _customRelationshipController.dispose();
    _stageStrangerController.dispose();
    _stageAcquaintanceController.dispose();
    _socialInteractionController.dispose();
    _audioPlayer.dispose();
    _playerIdentityController.dispose();
    _stageIntimateController.dispose();
    super.dispose();
  }

  Future<void> _playVoice(Uint8List audioBytes) async {
    if (!mounted) {
      debugPrint("頁面已關閉，取消播放語音");
      return;
    }
    try {
      // 1. 檢查數據是否存在
      if (audioBytes.isEmpty) {
        debugPrint("❌ 錯誤：這筆語音數據是空的，無法播放");
        return;
      }

      // 2. 先停止目前的播放器
      await _audioPlayer.stop();

      // 3. 🌟 核心重點：根據平台採取不同策略，打破快取魔咒！
      if (kIsWeb) {
        // 💻 網頁版：瀏覽器機制不同，可以直接安全使用 BytesSource
        await _audioPlayer.play(BytesSource(audioBytes));
      } else {
        // 📱 手機版：強制寫入一個「檔名永遠不重複」的實體檔案
        final directory = await getTemporaryDirectory();
        // 🔑 關鍵魔法：用毫秒級的時間戳記當檔名，例如 voice_test_171746201823.mp3
        final String uniqueFileName = 'voice_test_${DateTime.now().millisecondsSinceEpoch}.mp3';
        final file = File('${directory.path}/$uniqueFileName');

        // 將最新收到的 API 聲音寫入這個新檔案
        await file.writeAsBytes(audioBytes);

        // 指定播放這個絕對不會被快取的全新檔案
        await _audioPlayer.play(DeviceFileSource(file.path));
      }

      debugPrint("🎵 正在播放最新生成的語音...");
    } catch (e) {
      debugPrint("❌ 播放語音時發生錯誤: $e");
      if (mounted) {
        setState(() => _playingSampleIndex = null);
      }
    }
  }

  Future<void> _saveToDraft() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    // ✨ 1. 聰明判斷玩家要存哪個聲音 ID
    final String finalVoiceIdToSave = _generatedVoiceId ?? _selectedVoiceId ?? '';
    try {
      List<String> identitiesArray = _occupationController.text.trim().isEmpty
          ? []
          : _occupationController.text.split(RegExp(r'[/,，/／]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final String finalRelationship = (_selectedRelationship == 'relationship_other')
          ? _customRelationshipController.text.trim()
          : (_selectedRelationship ?? '');

      // 🌟 2. 確保在草稿模式下，如果還沒上傳，優先抓取本機路徑 (localFile.path)
      _galleryPhotos.sort((a, b) => a.requiredAffection.compareTo(b.requiredAffection));
      List<String> galleryPathsOnly = _galleryPhotos
          .map((p) {
        if (p.imageUrl.isNotEmpty) return p.imageUrl;
        if (p.localFile != null) return p.localFile!.path;
        return '';
      })
          .where((path) => path.isNotEmpty)
          .toList();

// ✨ 修正 1：確保本機的圖片路徑也有被存進草稿裡
      final galleryData = _galleryPhotos.map((p) {
        return {
          'url': p.imageUrl.isNotEmpty ? p.imageUrl : (p.localFile?.path ?? ''),
          'req': p.requiredAffection,
          'desc': p.description,
        };
      }).toList();
      // 🌟 3. 大頭貼防護罩：從剛才整理好的 galleryPathsOnly 拿第一張，絕對不會拿到空字串
      String currentAvatarPath = widget.character?.avatarPath ?? 'assets/images/blank_avatar.png';
      if (galleryPathsOnly.isNotEmpty) {
        currentAvatarPath = galleryPathsOnly.first;
      }

      // 🌟 總裁補位：動態產生給後端看的多角色【名字與關係】對照字串！
      String multiCharactersString = "目前主要角色：【${_nameController.text.trim()}】\n";
      _relationships.forEach((targetId, description) {
        final targetChar = _myCharacters.firstWhere(
              (c) => c.id == targetId,
          orElse: () => Character(
            id: targetId,
            name: '未知角色',
            avatarPath: '',
            age: '',
            occupation: '',
            birthday: '',
            height: '',
            gender: '',
            background: '',
            storySummary: '',
            initialStory: '',
            firstLine: '',
            toneAndStyle: '',
            detailedPersonality: '',
            likes: '',
            dislikes: '',
            secrets: '',
            appearance: '',
            dialogueExamples: '',
            personalityTags: [],
            easterEggs: [],
            extraInfoItems: [],
            isPublic: true,
            galleryPaths: [],
            // ✨✨✨ 這裡就是剛才漏掉的 4 個必填參數，直接塞預設值給它！ ✨✨✨
            createdBy: 'system',
            createdAt: DateTime.now(),
            playCount: 0,
            likesCount: 0,
            initialRelationship: '',
          ),
        );
        multiCharactersString += "【${targetChar.name}】：$description\n";
      });

      // 🌟 4. 終極草稿資料大集合
      final draftData = {
        'avatarPath': currentAvatarPath,
        'galleryPaths': galleryPathsOnly,
        'gallery': galleryData,
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim(),
        'identities': identitiesArray,
        'occupation': _occupationController.text.trim(),
        'birthday': _birthdayController.text.trim(),
        'gender': _gender,
        'height': _heightController.text.trim(),
        'appearance': _appearanceController.text.trim(),
        'personalityTags': _personalityTags,
        'detailedPersonality': _detailedPersonalityController.text.trim(),
        'background': _backgroundController.text.trim(),
        'likes': _likesController.text.trim(),
        'dislikes': _dislikesController.text.trim(),
        'secrets': _secretsController.text.trim(),
        'toneAndStyle': _toneController.text.trim(),
        'initialRelationship': finalRelationship,
        'dialogueExamples': _dialogueExamplesController.text.trim(),
        'storySummary': _storySummaryController.text.trim(),
        'story': _storyController.text.trim(),
        'storyModeFirstLine': _firstLineController.text.trim(),
        'isPublic': false,
        'isDraft': true,
        'isCompleted': false,
        'status': 'draft',
        'createdBy': user.uid,
        'extraInfoItems': _extraInfoItems,
        'content_language': l10n.localeName,
        'stageStranger': _stageStrangerController.text.trim(),
        'stageAcquaintance': _stageAcquaintanceController.text.trim(),
        'stageIntimate': _stageIntimateController.text.trim(),
        'socialInteraction': _socialInteractionController.text.trim(),
        'easterEggs': _easterEggs.map((egg) => egg.toMap()).toList(),
        'playerIdentity': _playerIdentityController.text.trim(),
        'voice_id': finalVoiceIdToSave.isEmpty ? null : finalVoiceIdToSave,
        'voice_preview_url': _finalVoicePreviewUrl,
        'voiceStability': _voiceStability,
        'voiceStyle': _voiceStyle,
        'relationships': _relationships, // 🌟 補上這行，Tab 3 的關係就不會消失了！
        'multiCharacters': multiCharactersString,
      };

      // 🌟 5. 寫入 Firestore 的草稿區 (draft_characters)
      if (_currentDraftId != null) {
        await _db.collection('draft_characters').doc(_currentDraftId).update(draftData);
      } else {
        final docRef = await _db.collection('draft_characters').add(draftData);
        _currentDraftId = docRef.id;
      }
      if (mounted) {
        // ✨ 總裁級：行雲流水的草稿儲存確認，完美避開虛擬鍵盤的干擾！
        ToastUtils.showCenterToast(
          context,
          l10n.draft_saved_success,
          customIcon: Icons.save_rounded, // 💡 用「磁碟片/儲存」或是 Icons.edit_document，給予滿滿的安心感
        );
      }
    } catch (e) {
      print("儲存草稿失敗: $e"); // 開發者除錯用，保留沒問題
      if (mounted) {
        // ⚠️ 總裁級防護：儲存失敗的緊急提醒！讓玩家有機會先手動複製文字備份
        ToastUtils.showCenterToast(
          context,
          l10n.draft_save_failed,
          isError: true, // 💡 紅色驚嘆號，明確告知「現在離開會遺失資料喔」
        );
      }
    } finally {
      if (mounted) {
      }
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    // 如果內容完全是空的，就直接讓玩家走，不要煩他
    if (_nameController.text.isEmpty && _storySummaryController.text.isEmpty) {
      return true;
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:Text(l10n.draft_save_title),
        content:Text(l10n.draft_save_content),
        actions: [
          // 選項一：不儲存，直接走
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:Text(l10n.not_save, style: TextStyle(color: Colors.grey)),
          ),
          // 選項二：取消，留下來繼續寫
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:Text(l10n.cancel),
          ),
          // 選項三：儲存，存完後再走
          ElevatedButton(
            onPressed: () async {
              // 這裡呼叫我們剛才寫好的儲存草稿函數
              await _saveToDraft();
              if (context.mounted) Navigator.of(context).pop({
                'changed': true,
                'goProfile': true,
              });
            },
            child:Text(l10n.save_draft),
          ),
        ],
      ),
    );

    return result ?? false; // 如果玩家點擊旁邊空白處關閉，視為「取消」
  }

  void _scrollToFocus(FocusNode focusNode) {
    // 等待鍵盤彈出的動畫跑完 (大約 300 毫秒)，再執行滑動
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      // 讓畫面自動滑到這個焦點的位置
      Scrollable.ensureVisible(
        focusNode.context!,
        duration: const Duration(milliseconds: 300), // 滑動動畫的時間
        curve: Curves.easeInOut,
        alignment: 0.5, // 0.5 代表把這個輸入框放在畫面正中間
      );
    });
  }


  Future<void> _deleteCharacter() async {
    if (!isEditing || widget.character == null) return;

    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ToastUtils.showCenterToast(
        context,
        l10n.user_not_found,
        isError: true,
      );
      return;
    }

    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '⚠️${l10n.confirm_delete_title}',
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(
          l10n.confirm_delete_char_content(widget.character!.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm_delete_title),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirm) return;

    setState(() => _isDeleting = true);

    try {
      final batch = _db.batch();

      // ✅ 關鍵：依照角色原本是公開/私密，刪正確位置
      final DocumentReference charDocRef = widget.character!.isPublic
          ? _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character!.id)
          : _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(user.uid)
          .collection('private_characters')
          .doc(widget.character!.id);

      // ✅ 順便刪 photos 子集合，不然會留下孤兒資料
      final photosSnapshot = await charDocRef.collection('photos').get();
      for (final doc in photosSnapshot.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(charDocRef);

      await batch.commit();

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.char_deleted,
        customIcon: Icons.person_remove_rounded,
      );

      // ✅ 回傳給上一頁：我刪掉了，請刷新列表
      Navigator.of(context).pop({
        'changed': true,
        'deleted': true,
        'goProfile': true,
      });
    } catch (e) {
      if (mounted) {
        _showErrorDialog(l10n.delete_failed_msg, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  // ✨✨✨ 錯誤警告視窗 ✨✨✨
  void _showErrorDialog(String title, String content) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok_button),
          ),
        ],
      ),
    );
  }

  // ✨✨✨ 抓取創作者名下的所有角色 (供關係編輯器使用)
  Future<void> _fetchMyCharacters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. 抓取公開角色 (且是自己創建的)
      final publicDocs = await _db.collection('artifacts').doc(AppConfig.appId)
          .collection('public_characters')
          .where('createdBy', isEqualTo: user.uid)
          .get();

      // 2. 抓取私密角色
      final privateDocs = await _db.collection('artifacts').doc(AppConfig.appId)
          .collection('users').doc(user.uid)
          .collection('private_characters')
          .get();

      // ✨ 使用 Future.wait 等待所有非同步任務完成
      final publicChars = await Future.wait(
          publicDocs.docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );
      final privateChars = await Future.wait(
          privateDocs.docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      if (mounted) {
        setState(() {
          // 將公開與私密角色合併放入名單
          _myCharacters = [...publicChars, ...privateChars];
        });
      }
    } catch (e) {
      print("抓取角色關係清單失敗: $e");
    }
  }

  Future<void> _saveCharacter() async {
    final l10n = AppLocalizations.of(context)!;
    // 🌟 1. 基礎防呆與字數檢查 (維持妳原本的優良設計)
    final allImages = _galleryPhotos.length;
    if (_nameController.text.trim().isEmpty || allImages == 0) {
      _showErrorDialog(l10n.cannot_save_title, l10n.cannot_save_content);
      return;
    }
    final String finalVoiceIdToSave = _generatedVoiceId ?? _selectedVoiceId ?? '';

// 🌟 1. 配置清單：直接把「標籤、控制器、上限」綁在一起
    final List<Map<String, dynamic>> checkList = [
      {'label': l10n.detailed_personality_label, 'controller': _detailedPersonalityController, 'limit': 800},
      {'label': l10n.field_background, 'controller': _backgroundController, 'limit': 800},
      {'label': l10n.field_tone, 'controller': _toneController, 'limit': 500},
      {'label': l10n.field_initial_story, 'controller': _storyController, 'limit': 2500},
    ];

// 🌟 2. 只有一個迴圈，通殺所有字數檢查
    for (var item in checkList) {
      final controller = item['controller'] as TextEditingController;
      final int limit = item['limit'];
      final String label = item['label'];

      if (controller.text.trim().length > limit) {
        _showErrorDialog(
            l10n.word_count_exceeded,
            l10n.word_count_error_detail(label, limit)
        );
        return; // 🎯 只要有一個爆字數就攔截，不往下跑儲存
      }
    }

    if (_detailedPersonalityController.text.trim().length < 10) {
      _showErrorDialog(l10n.content_missing, l10n.content_missing_personality);
      return;
    }
    if (_backgroundController.text.trim().length < 20) {
      _showErrorDialog(l10n.content_missing, l10n.content_missing_bg);
      return;
    }
    if (_toneController.text.trim().isEmpty) {
      _showErrorDialog(l10n.content_missing, l10n.content_missing_tone);
      return;
    }

    // --- 開始儲存流程 ---
    setState(() => _isSaving = true);
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // ✨ 總裁級第一道防線：乾淨俐落的權限攔截！
      ToastUtils.showCenterToast(
        context,
        l10n.user_not_found,
        isError: true, // 💡 紅色驚嘆號，明確告知玩家「系統目前無法辨識你的身分」
      );
      setState(() => _isSaving = false);
      return;
    }

    // 顯示轉圈圈 (避免儲存中途被干擾)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final db = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;
      final batch = db.batch();

      DocumentReference charDocRef;
      bool isMovingFolder = false; // ✨ 紀錄是否需要搬家

      if (isEditing) {
        // 1. 找出它原本住在哪裡 (依據 widget.character 傳進來的舊狀態)
        DocumentReference oldDocRef = widget.character!.isPublic
            ? _db.collection('artifacts').doc(AppConfig.appId).collection('public_characters').doc(widget.character!.id)
            : _db.collection('artifacts').doc(AppConfig.appId).collection('users').doc(currentUser.uid).collection('private_characters').doc(widget.character!.id);

        // 2. 找出它現在「應該」住在哪裡 (依據按鈕切換後的新狀態 _isPublic)
        charDocRef = _isPublic
            ? _db.collection('artifacts').doc(AppConfig.appId).collection('public_characters').doc(widget.character!.id)
            : _db.collection('artifacts').doc(AppConfig.appId).collection('users').doc(currentUser.uid).collection('private_characters').doc(widget.character!.id);

        // 3. 判斷是否搬家
        if (oldDocRef.path != charDocRef.path) {
          isMovingFolder = true;
        }

        // 🧹 【大掃除魔法】：去「舊家」把照片子集合清掉
        final oldPhotosSnapshot = await oldDocRef.collection('photos').get();
        for (var doc in oldPhotosSnapshot.docs) {
          batch.delete(doc.reference);
        }

        // ✨✨✨ 如果有搬家，把舊家的主體文件也無情刪除！
        if (isMovingFolder) {
          batch.delete(oldDocRef);
        }
      } else {
        final collectionRef = _isPublic
            ? _db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('public_characters')
            : _db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('users')
            .doc(currentUser.uid)
            .collection('private_characters');

        // ✅ 關鍵：如果是從草稿發布，就用草稿 id 當角色 id
        // 這樣同一份草稿不會每按一次就生一個新角色
        if (widget.draftDoc != null) {
          charDocRef = collectionRef.doc(widget.draftDoc!.id);
        } else {
          charDocRef = collectionRef.doc();
        }
      }

      // 🚀 【極速優化】：照片平行上傳大法！
      List<Future<void>> uploadTasks = [];

      for (int i = 0; i < _galleryPhotos.length; i++) {
        final photoObj = _galleryPhotos[i];

        if (photoObj.localFile != null) {
          // ✨ 不加 await，把任務包起來丟進清單，大家一起衝！
          uploadTasks.add((() async {
            final fileName = 'char_${charDocRef.id}_photo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            final storageRef = storage.ref().child('artifacts/lianlianshiguang/character_photos/$fileName');

            if (kIsWeb) {
              final bytes = await photoObj.localFile!.readAsBytes();
              await storageRef.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
            } else {
              await storageRef.putFile(File(photoObj.localFile!.path));
            }

            // 拿回網址，清空本地檔案
            photoObj.imageUrl = await storageRef.getDownloadURL();
            photoObj.localFile = null;
          })());
        }
      }

      // 🎯 一次性等待所有照片傳完！原本 6 秒瞬間變 1.5 秒！
      if (uploadTasks.isNotEmpty) {
        await Future.wait(uploadTasks);
      }

      // 🌟 【順序優化】：照片都拿到網址了，發號碼牌排隊寫入資料庫！
      List<String> galleryPathsOnly = [];

      for (int i = 0; i < _galleryPhotos.length; i++) {
        final photoObj = _galleryPhotos[i];
        galleryPathsOnly.add(photoObj.imageUrl); // 把網址裝進舊版陣列

        // 寫入 photos 子集合
        final photoDocRef = charDocRef.collection('photos').doc();
        batch.set(photoDocRef, {
          'url': photoObj.imageUrl,
          'req': photoObj.requiredAffection,
          'desc': photoObj.description,
          'orderIndex': i, // ✨✨✨ 絕對關鍵：號碼牌發下去，順序再也不會亂！
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 🌟 總裁補位：動態產生給後端看的多角色【名字與關係】對照字串！
      String multiCharactersString = "目前主要角色：【${_nameController.text.trim()}】\n";
      _relationships.forEach((targetId, description) {
        final targetChar = _myCharacters.firstWhere(
              (c) => c.id == targetId,
          orElse: () => Character(
            id: targetId,
            name: '未知角色',
            avatarPath: '',
            age: '',
            occupation: '',
            birthday: '',
            height: '',
            gender: '',
            background: '',
            storySummary: '',
            initialStory: '',
            firstLine: '',
            toneAndStyle: '',
            detailedPersonality: '',
            likes: '',
            dislikes: '',
            secrets: '',
            appearance: '',
            dialogueExamples: '',
            personalityTags: [],
            easterEggs: [],
            extraInfoItems: [],
            isPublic: true,
            galleryPaths: [],
            // ✨✨✨ 這裡就是剛才漏掉的 4 個必填參數，直接塞預設值給它！ ✨✨✨
            createdBy: 'system',
            createdAt: DateTime.now(),
            playCount: 0,
            likesCount: 0,
            initialRelationship: '',
          ),
        );
        multiCharactersString += "【${targetChar.name}】：$description\n";
      });

      // 🌟 4. 準備主角色的所有資料包 (這行開始保留妳原本的程式碼)
      List<String> identitiesArray = _occupationController.text.trim().isEmpty
          ? []
          : _occupationController.text.split(RegExp(r'[/,，/／]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final String finalRelationship = (_selectedRelationship == 'relationship_other')
          ? _customRelationshipController.text.trim() // 抓手寫內容
          : (_selectedRelationship ?? '');           // 抓選單的 Key

      // 相容舊版，還是把 galleryData 存在主資料夾一份
      final galleryData = _galleryPhotos.map((p) => p.toMap()).toList();
      Map<String, dynamic> characterData = {
        'avatarPath': galleryPathsOnly.isNotEmpty ? galleryPathsOnly.first : 'assets/images/blank_avatar.png',
        'galleryPaths': galleryPathsOnly,
        'gallery': galleryData,
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim(),
        'identities': identitiesArray,
        'occupation': _occupationController.text.trim(),
        'birthday': _birthdayController.text.trim(),
        'gender': _gender,
        'height': _heightController.text.trim(),
        'appearance': _appearanceController.text.trim(),
        'personalityTags': _personalityTags,
        'detailedPersonality': _detailedPersonalityController.text.trim(),
        'background': _backgroundController.text.trim(),
        'likes': _likesController.text.trim(),
        'dislikes': _dislikesController.text.trim(),
        'secrets': _secretsController.text.trim(),
        'toneAndStyle': _toneController.text.trim(),
        'initialRelationship': finalRelationship,
        'dialogueExamples': _dialogueExamplesController.text.trim(),
        'storySummary': _storySummaryController.text.trim(),
        'story': _storyController.text.trim(),
        'storyModeFirstLine': _firstLineController.text.trim(),
        'isPublic': _isPublic,
        'isDraft': false,
        'isCompleted': true,
        'status': 'published',
        'createdBy': currentUser.uid,
        'extraInfoItems': _extraInfoItems,
        'content_language': l10n.localeName,
        'stageStranger': _stageStrangerController.text.trim(),
        'stageAcquaintance': _stageAcquaintanceController.text.trim(),
        'stageIntimate': _stageIntimateController.text.trim(),
        'socialInteraction': _socialInteractionController.text.trim(),
        'easterEggs': _easterEggs.map((egg) => egg.toMap()).toList(),
        'playerIdentity': _playerIdentityController.text.trim(),
        'voice_id': finalVoiceIdToSave.isEmpty ? null : finalVoiceIdToSave,
        'voice_preview_url': _finalVoicePreviewUrl,
        'voiceStability': _voiceStability,
        'voiceStyle': _voiceStyle,
        'relationships': _relationships,
        'multiCharacters': multiCharactersString,
        'createdAt': (widget.character != null && widget.character!.createdAt != null)
            ? Timestamp.fromDate(widget.character!.createdAt)
            : FieldValue.serverTimestamp(),
        'lastEditTime': FieldValue.serverTimestamp(),
      };

      // 🌟 5. 區分編輯 vs 創建的寫入動作
      if (isEditing) {
        if (isMovingFolder) {
          // ✨ 總裁急救包：搬家的時候，強制把「出生時間」和「親媽身分證」塞進行李箱！

          // 1. 確保親媽 ID 不會掉
          characterData['createdBy'] = FirebaseAuth.instance.currentUser?.uid;

          // 3. 原本的遊玩次數也順便帶過去，才不會搬個家就被歸零！
          characterData['playCount'] = widget.character?.playCount ?? 0;

          // 📦 裝備齊全，正式寫入新家！
          batch.set(charDocRef, characterData);
        } else {
          batch.update(charDocRef, characterData); // 沒搬家，原本的 update 就好
        }
      } else {
        // (這裡是妳原本的新建模式，不用動)
        characterData['createdAt'] = FieldValue.serverTimestamp();
        characterData['playCount'] = 0;
        characterData['isNew'] = true;
        batch.set(charDocRef, characterData, SetOptions(merge: true));
      }

      // 🌟 6. 管家，執行 Batch 寫入！
      await batch.commit();
      try {
        final String newAvatarUrl = galleryPathsOnly.isNotEmpty
            ? galleryPathsOnly.first
            : 'assets/images/blank_avatar.png';
        final String newName = _nameController.text.trim();
        final chatSessionsQuery = await db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('chat_sessions')
            .where('characterId', isEqualTo: charDocRef.id) // 鎖定這個角色
            .get();

        if (chatSessionsQuery.docs.isNotEmpty) {
          WriteBatch syncBatch = db.batch();
          for (var sessionDoc in chatSessionsQuery.docs) {
            syncBatch.update(sessionDoc.reference, {
              'characterAvatarPath': newAvatarUrl, // 更新為最新美照
              'characterName': newName,            // 順便更新名字，萬一玩家有改名
            });
          }
          await syncBatch.commit();
          debugPrint("✅ 已同步更新 ${chatSessionsQuery.docs.length} 個聊天室的頭像與名稱");
        }
      } catch (e) {
        // 同步失敗不影響主流程，所以印出錯誤即可
        debugPrint("❌ 同步聊天室資料失敗: $e");
      }
      // ✨✨✨ 總裁指定的：自動清理草稿箱的特定草稿 ✨✨✨
      if (widget.draftDoc != null) {
        try {
          await FirebaseFirestore.instance
              .collection('draft_characters')
              .doc(widget.draftDoc!.id)
              .delete();
          debugPrint("✅ 偵測到從草稿發布：舊草稿 ${widget.draftDoc!.id} 已自動清除！");
        } catch (e) {
          debugPrint("⚠️ 自動清除草稿失敗: $e");
        }
      }
      // 如果是新建，清除草稿
      if (!isEditing) {
        await _clearDraft();
      }
      // 關閉轉圈圈並跳出成功訊息
      if (mounted) { // 💡 若有報錯，請記得替換為 context.mounted
        Navigator.pop(context); // 關閉 loading dialog

        ToastUtils.showCenterToast(
          context,
          l10n.char_saved_success(
            characterData['name'],
            isEditing ? l10n.update_action : l10n.createButton,
          ),
          customIcon: isEditing ? Icons.manage_accounts_rounded : Icons
              .person_add_rounded,
        );

// ✅ 先把成功結果傳回去
        Navigator.of(context).pop({
          'changed': true,
          'goProfile': true,
          'action': isEditing ? 'updated' : 'created',
        });
      }
      } catch (e) {
      if (mounted) Navigator.pop(context); // 關閉 loading dialog
      print("!!! 儲存角色時發生錯誤: ${e.toString()}");
      if (mounted) _showErrorDialog(l10n.cannot_save_title, l10n.save_error_detail(e.toString()));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<String> _uploadImageFile(XFile imageFile) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("找不到使用者");

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final ref = _storage.ref().child('character_images').child(currentUser.uid).child(fileName);
    final metadata = SettableMetadata(contentType: 'image/png');

    final bytes = await imageFile.readAsBytes();
    await ref.putData(bytes, metadata);

    return await ref.getDownloadURL();
  }

  // ✨ 修正 4：讓圖片渲染器認識手機本機的 String 路徑
  ImageProvider _getImageProvider(dynamic imageSource) {
    if (imageSource is String) {
      if (imageSource.startsWith('http')) {
        return NetworkImage(imageSource);
      } else if (imageSource.startsWith('/')) {
        // 💡 如果字串是 '/' 開頭，代表它是手機裡的實體路徑！
        return FileImage(File(imageSource));
      }
    } else if (imageSource is XFile) {
      if (kIsWeb) {
        return NetworkImage(imageSource.path);
      }
      return FileImage(File(imageSource.path));
    }
    return const AssetImage('assets/images/blank_avatar.png');
  }

  void _openEasterEggEditor({EasterEgg? egg, int? index}) {
    final l10n = AppLocalizations.of(context)!;
    final _keywordController = TextEditingController(text: egg?.keyword ?? '');
    final _titleController = TextEditingController(text: egg?.title ?? '');
    final _teaserController = TextEditingController(text: egg?.teaser ?? '');
    final _promptController = TextEditingController(text: egg?.contentPrompt ?? '');
    final _sceneController = TextEditingController(text: egg?.setScene ?? ''); // 場景

    showDialog(
      context: context,
      barrierDismissible: false, // 避免誤觸關閉
      builder: (context) => AlertDialog(
        title: Text(egg == null ?l10n.easter_egg_add_title : l10n.easter_egg_edit_title),
        content: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                controller: _keywordController,
                decoration:InputDecoration(labelText: l10n.keyword_label, hintText: l10n.keyword_hint),
              ),
              const SizedBox(height: 8),
              TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                controller: _titleController,
                decoration:InputDecoration(labelText:l10n.egg_title_label, hintText: l10n.egg_title_hint),
              ),
              const SizedBox(height: 8),
              TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                controller: _teaserController,
                maxLines: 2,
                decoration:InputDecoration(labelText:l10n.egg_teaser_label, hintText: l10n.egg_teaser_hint),
              ),
              const SizedBox(height: 8),
              TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                controller: _sceneController,
                decoration:InputDecoration(labelText:l10n.egg_scene_label, hintText: l10n.egg_scene_hint),
              ),
              const SizedBox(height: 8),
              TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                controller: _promptController,
                maxLines: 4,
                decoration:InputDecoration(labelText:l10n.egg_prompt_label, hintText: l10n.egg_prompt_hint),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              if (_keywordController.text.trim().isEmpty) {
                // ✨ 總裁級防呆：精準攔截空白關鍵字，完美避開虛擬鍵盤的遮擋！
                ToastUtils.showCenterToast(
                  context,
                  l10n.keyword_empty_error,
                  isError: true, // 💡 紅色警告，讓玩家立刻意識到「啊，我忘了打字」
                  // 💡 總裁秘技：如果是用在搜尋功能，你也可以拿掉 isError，改用 customIcon: Icons.search_off_rounded，語意會更精準喔！
                );
                return;
              }

              final newEgg = EasterEgg(
                id: egg?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                keyword: _keywordController.text.trim(),
                title: _titleController.text.trim(),
                teaser: _teaserController.text.trim(),
                contentPrompt: _promptController.text.trim(),
                setScene: _sceneController.text.trim().isEmpty ? null : _sceneController.text.trim(),
              );

              setState(() {
                if (index != null) {
                  _easterEggs[index] = newEgg;
                } else {
                  _easterEggs.add(newEgg);
                }
              });
              Navigator.pop(context);
            },
            child: Text(l10n.confirm_button),
          ),
        ],
      ),
    );
  }

  // ✨ 這是只處理文字和狀態的、更乾淨的版本
  Future<void> _loadDraftData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _nameController.text = prefs.getString('temp_char_name') ?? '';
      _gender = prefs.getString('temp_char_gender') ?? l10n.genderNotSelected;
      _ageController.text = prefs.getString('temp_char_age') ?? '';
      _occupationController.text = prefs.getString('temp_char_occupation') ?? '';
      _birthdayController.text = prefs.getString('temp_char_birthday') ?? '';
      _heightController.text = prefs.getString('temp_char_height') ?? '';
      _appearanceController.text = prefs.getString('temp_char_appearance') ?? '';
      _personalityTags = prefs.getStringList('temp_char_personalityTags') ?? [];
      _detailedPersonalityController.text = prefs.getString('temp_char_detailedPersonality') ?? '';
      _backgroundController.text = prefs.getString('temp_char_background') ?? '';
      _storyController.text = prefs.getString('temp_char_story') ?? '';
      _isPublic = prefs.getBool('temp_char_isPublic') ?? true;
      _likesController.text = prefs.getString('temp_char_likes') ?? '';
      _dislikesController.text = prefs.getString('temp_char_dislikes') ?? '';
      _secretsController.text = prefs.getString('temp_char_secrets') ?? '';
      _toneController.text = prefs.getString('temp_char_tone') ?? '';
      _dialogueExamplesController.text = prefs.getString('temp_char_dialogue') ?? '';
      _extraInfoItems = prefs.getStringList('temp_char_extraInfoItems') ?? [];
      _storySummaryController.text = prefs.getString('temp_char_storySummary') ?? '';
      _firstLineController.text = prefs.getString('temp_char_firstLine') ?? '';
      _selectedRelationship = prefs.getString('temp_char_relationship');
      _customRelationshipController.text = prefs.getString('temp_char_customRelationship') ?? '';
      _stageStrangerController.text = prefs.getString('temp_char_stageStranger') ?? '';
      _stageAcquaintanceController.text = prefs.getString('temp_char_stageAcquaintance') ?? '';
      _stageIntimateController.text = prefs.getString('temp_char_stageIntimate') ?? '';
      _socialInteractionController.text = prefs.getString('temp_char_socialInteraction') ?? '';
      _playerIdentityController.text = prefs.getString('temp_char_playerIdentity') ?? '';
      final easterEggsJson = prefs.getStringList('temp_char_easterEggs');
      if (easterEggsJson != null) {
        _easterEggs = easterEggsJson.map((jsonStr) => EasterEgg.fromMap(jsonDecode(jsonStr))).toList();
      }
    });
  }

  // ✨ 這也是只處理文字和狀態的版本
  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temp_char_name', _nameController.text.trim());
    await prefs.setString('temp_char_gender', _gender);
    await prefs.setString('temp_char_age', _ageController.text.trim());
    await prefs.setString('temp_char_occupation', _occupationController.text.trim());
    await prefs.setString('temp_char_birthday', _birthdayController.text.trim());
    await prefs.setString('temp_char_height', _heightController.text.trim());
    await prefs.setString('temp_char_appearance', _appearanceController.text.trim());
    await prefs.setStringList('temp_char_personalityTags', _personalityTags);
    await prefs.setString('temp_char_detailedPersonality', _detailedPersonalityController.text.trim());
    await prefs.setString('temp_char_background', _backgroundController.text.trim());
    await prefs.setString('temp_char_story', _storyController.text.trim());
    await prefs.setBool('temp_char_isPublic', _isPublic);
    await prefs.setString('temp_char_likes', _likesController.text.trim());
    await prefs.setString('temp_char_dislikes', _dislikesController.text.trim());
    await prefs.setString('temp_char_secrets', _secretsController.text.trim());
    await prefs.setString('temp_char_tone', _toneController.text.trim());
    await prefs.setString('temp_char_dialogue', _dialogueExamplesController.text.trim());
    await prefs.setStringList('temp_char_extraInfoItems', _extraInfoItems);
    await prefs.setString('temp_char_storySummary', _storySummaryController.text.trim());
    await prefs.setString('temp_char_firstLine', _firstLineController.text.trim());
    await prefs.setString('temp_char_stageStranger', _stageStrangerController.text.trim());
    await prefs.setString('temp_char_stageAcquaintance', _stageAcquaintanceController.text.trim());
    await prefs.setString('temp_char_stageIntimate', _stageIntimateController.text.trim());
    await prefs.setString('temp_char_socialInteraction', _socialInteractionController.text.trim());
    await prefs.setString('temp_char_playerIdentity', _playerIdentityController.text.trim());
    final easterEggsJson = _easterEggs.map((egg) => jsonEncode(egg.toMap())).toList();
    await prefs.setStringList('temp_char_easterEggs', easterEggsJson);
    if (_selectedRelationship != null) {
      await prefs.setString('temp_char_relationship', _selectedRelationship!);
    }
    await prefs.setString('temp_char_customRelationship', _customRelationshipController.text.trim());
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('temp_char_')) {
        await prefs.remove(key);
      }
    }
  }

  void _showVoiceGenerationDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController promptController = TextEditingController();
        return AlertDialog(
          title:Text(l10n.voice_custom_title),
          content: TextField(
            scrollPadding: const EdgeInsets.only(bottom: 120),
            controller: promptController,
            decoration:InputDecoration(hintText:l10n.voice_custom_hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:Text(l10n.cancel),
            ),
            ElevatedButton(
              // 🌟 關鍵 1：加上 async
              onPressed: () async {
                final promptText = promptController.text.trim();
                if (promptText.isEmpty) return; // 防呆：沒輸入字就不准按

                Navigator.pop(context); // 先關閉對話框

                // 🌟 關鍵 2：正式上鎖！外面的大按鈕會立刻變成轉圈圈 🔄
                setState(() {
                  _isGeneratingVoice = true;
                });
                // 1. 從 widget.character 抓取角色名字
                String currentName = widget.character?.name ?? l10n.me;
                // 2. 判斷性別和年齡
                String currentGender = _gender == genderIdFemale ? 'female' : 'male';

                try {
                  // 🌟 關鍵 3：加上 await！這會讓程式停在這裡等 ElevenLabs 回傳，鎖才會一直掛著
                  await _generateVoiceFromAPI(
                    promptText, // 傳入玩家打的提示詞
                    characterName: currentName,
                    gender: currentGender,
                    age: 'young',
                  );
                } catch (e) {
                  debugPrint("❌ 生成聲音發生錯誤: $e");
                } finally {
                  // 🌟 關鍵 4：不管 API 是成功還是報錯，最後絕對要解鎖，外面的按鈕才會恢復正常！
                  if (mounted) {
                    setState(() {
                      _isGeneratingVoice = false;
                    });
                  }
                }
              },
              child:Text(l10n.voice_generate_start),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final l10n = AppLocalizations.of(context)!;
    // Only show dialog in creation mode
    if (isEditing) return true;
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exitCreationTitle),
        content: Text(l10n.saveDraftPrompt),
        actions: [
          TextButton(
            onPressed: () {
              _clearDraft();
              Navigator.of(context).pop(true);
            },
            child: Text(l10n.draftNotNeeded),
          ),
          ElevatedButton(
            onPressed: () {
              _saveDraft();
              Navigator.of(context).pop(true);
            },
            child: Text(l10n.draftNeeded),
          ),
        ],
      ),
    ) ??
        false;
  }

  // 🌟 1. 括號裡的 characterName 加上問號 (?)，代表「可以不傳」，並拿掉預設值
  Future<void> _generateVoiceFromAPI(
      String prompt, {
        String? characterName,
        String gender = 'male',
        String age = 'young',
      }) async {
    final l10n = AppLocalizations.of(context)!;

    final String finalCharacterName = characterName ?? l10n.me;

    setState(() {
      _isGeneratingVoice = true;
      _voiceSamples = [];
      _selectedSampleIndex = null;
    });

    try {
      final String sampleScript = l10n.voice_sample_script;

      final String voiceDescription =
          "A $age $gender voice for a character named $finalCharacterName. "
          "$prompt Studio quality recording, clear pronunciation.";

      final callable = _functions.httpsCallable('createVoicePreviews');

      final result = await callable.call({
        'sampleScript': sampleScript,
        'voiceDescription': voiceDescription,
      });

      final responseData = Map<String, dynamic>.from(result.data);
      final previews = responseData['previews'] as List<dynamic>;

      final List<Map<String, dynamic>> newSamples = [];

      for (int i = 0; i < previews.length; i++) {
        final preview = Map<String, dynamic>.from(previews[i]);

        final String generatedVoiceId =
            preview['generated_voice_id']?.toString() ?? '';

        final String audioBase64 =
            preview['audio_base_64']?.toString() ?? '';

        if (generatedVoiceId.isEmpty || audioBase64.isEmpty) {
          debugPrint("⚠️ 第 $i 個語音樣本資料不完整，已略過");
          continue;
        }

        final Uint8List audioBytes = base64Decode(audioBase64);

        if (!kIsWeb) {
          try {
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/temp_voice_$i.mp3';
            final file = File(filePath);
            await file.writeAsBytes(audioBytes);
            debugPrint("手機版：已存檔至 $filePath");
          } catch (e) {
            debugPrint("手機版存檔失敗: $e");
          }
        } else {
          debugPrint("網頁版：略過存檔，直接使用記憶體數據");
        }

        newSamples.add({
          'generated_voice_id': generatedVoiceId,
          'audio_bytes': audioBytes,
          'preview_url': '',
        });
      }

      if (!mounted) return;

      if (newSamples.isNotEmpty) {
        _selectedSampleIndex = 0;
        _selectedVoiceId = newSamples[0]['generated_voice_id'];
      }

      setState(() {
        _voiceSamples = newSamples;
        _isGeneratingVoice = false;
      });
    } catch (e) {
      debugPrint("聲音生成失敗: $e");

      if (!mounted) return;

      setState(() {
        _isGeneratingVoice = false;
      });

      ToastUtils.showCenterToast(
        context,
        l10n.elevenlabs_error(e.toString()),
        isError: true,
      );
    }
  }

  Future<void> _testVoiceSettings() async {
    final l10n = AppLocalizations.of(context)!;
    // 🌟 核心修正：讓系統去找「真正存檔的聲音 ID」，如果沒有才去找「剛選中的」
    final String? targetVoiceId = _generatedVoiceId ?? _selectedVoiceId;

    // 防呆：確認玩家有先選定一個聲音
    if (targetVoiceId == null || targetVoiceId.isEmpty) {
      // ✨ 總裁級引導：溫柔提醒玩家為角色注入「聲音的靈魂」
      ToastUtils.showCenterToast(
        context,
        l10n.voice_bind_first,
        customIcon: Icons.mic_external_off_rounded, // 💡 總裁精選：「找不到麥克風」的圖示，直覺告訴玩家要去設定聲音
        // 或是使用 Icons.record_voice_over_rounded (配音設定) 也很適合！
      );
      return;
    }

    // 1. 上鎖！讓按鈕轉圈圈
    setState(() => _isTestingSettings = true);
    try {
      final callable = _functions.httpsCallable('testVoiceSettings');

      final result = await callable.call({
        'voiceId': targetVoiceId,
        'text': l10n.voice_test_script,
        'stability': _voiceStability,
        'style': _voiceStyle,
      });

      final data = Map<String, dynamic>.from(result.data);
      final Uint8List audioBytes = base64Decode(data['audio_base_64']);

      if (!mounted) return;

      // 🌟 大成功！餵給幽靈免疫播放器
      await _playVoice(audioBytes);
    } catch (e) {
      debugPrint("❌ 試聽失敗: $e");

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.voice_test_failed,
          isError: true,
        );
      }
    }catch (e) {
      debugPrint("❌ 發生錯誤: $e");
    } finally {
      // 3. 不管怎樣，最後一定要解鎖
      if (mounted) {
        setState(() => _isTestingSettings = false);
      }
    }
  }
  Future<void> _confirmVoiceSelection() async {
    if (_selectedSampleIndex == null || _voiceSamples.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() => _isSaving = true);

    final selectedSample = _voiceSamples[_selectedSampleIndex!];

    final String previewVoiceId =
        selectedSample['generated_voice_id']?.toString() ?? '';

    final Uint8List? selectedAudioBytes =
    selectedSample['audio_bytes'] as Uint8List?;

    final String previewUrl =
        selectedSample['preview_url']?.toString() ?? '';

    if (previewVoiceId.isEmpty || selectedAudioBytes == null) {
      if (mounted) {
        setState(() => _isSaving = false);

        ToastUtils.showCenterToast(
          context,
          l10n.voice_bind_failed,
          isError: true,
        );
      }
      return;
    }

    try {
      // ✅ Cloud Function：把 preview voice 轉成正式永久 voice
      final callable = _functions.httpsCallable('createVoiceFromPreview');

      final result = await callable.call({
        'voiceName': l10n.voice_name_default(
          _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : l10n.default_unnamed_character,
        ),
        'voiceDescription': l10n.voice_description_default,
        'generatedVoiceId': previewVoiceId,
      });

      final data = Map<String, dynamic>.from(result.data);

      // ✅ 成功時直接從 Cloud Function 回傳資料拿正式 voice_id
      final String realVoiceId =
          data['voice_id']?.toString() ??
              data['voiceId']?.toString() ??
              previewVoiceId;

      debugPrint("✅ 成功獲得正式 Voice ID: $realVoiceId");

      if (!mounted) return;

      // ✅ 先更新本頁狀態，讓後續儲存角色時會帶到 voice_id
      setState(() {
        _generatedVoiceId = realVoiceId;
        _selectedVoiceId = realVoiceId;
        _finalAudioBytes = selectedAudioBytes;
        _finalVoicePreviewUrl = previewUrl;
        _voiceSamples = []; // 清空三張樣本卡片
      });

      // ✅ 如果是編輯既有角色，立刻同步到 Firebase
      if (widget.character != null) {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (!widget.character!.isPublic && currentUser == null) {
          throw Exception("找不到使用者，無法更新私人角色語音");
        }

        final DocumentReference characterRef = widget.character!.isPublic
            ? FirebaseFirestore.instance
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('public_characters')
            .doc(widget.character!.id)
            : FirebaseFirestore.instance
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('users')
            .doc(currentUser!.uid)
            .collection('private_characters')
            .doc(widget.character!.id);

        await characterRef.update({
          'voice_id': realVoiceId,
          'voice_preview_url': previewUrl,
          'voiceStability': _voiceStability,
          'voiceStyle': _voiceStyle,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.voice_bind_success(widget.character!.name),
          customIcon: Icons.cloud_done_rounded,
        );
      } else {
        // ✅ 新建角色階段：只存在本頁狀態，等按「儲存角色」時一起寫進 characterData
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.voice_bind_success_draft,
          customIcon: Icons.edit_note_rounded,
        );
      }
    } catch (e) {
      debugPrint("❌ 語音綁定失敗: $e");

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.voice_bind_failed,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    // 在 build 裡面
    final List<Map<String, String>> genderOptions = [
      {'id': genderIdMale, 'label': l10n.genderMale},
      {'id': genderIdFemale, 'label': l10n.genderFemale},
      {'id': genderIdOther, 'label': l10n.genderOther},
    ];
// Dropdown 的改法
    DropdownButtonFormField<String>(
      value: _gender.isEmpty ? null : _gender, // 這裡的 _gender 現在存的是 'male' 或 'female'
      items: genderOptions.map((g) => DropdownMenuItem(
        value: g['id'],       // 存入資料庫的值：'male'
        child: Text(g['label']!), // 顯示在畫面上的值：'男性' 或 'Male'
      )).toList(),
      onChanged: (val) => setState(() => _gender = val ?? ''),
    );
    final List<String> relationshipOptions = [
      l10n.relationship_childhood_friend, l10n.relationship_senior_junior,
      l10n.relationship_bickering_couple, l10n.relationship_colleagues,
      l10n.relationship_other,
    ];
    final List<String> defaultPersonalityTags = [
      l10n.tagGentle, l10n.tagCheerful, l10n.tagLively, l10n.tagMischievous,
      l10n.tagRichYoungLady, l10n.tagRichYoungMaster, l10n.tagWealthyFamily,
      l10n.tagScheming, l10n.tagPossessive, l10n.tagParanoid, l10n.tagPersistent,
      l10n.tagUncle, l10n.tagAuntie, l10n.tagSeniorSister, l10n.tagJuniorBrother,
      l10n.tagHandsome, l10n.tagStunning, l10n.tagContrast, l10n.tagFlirty, l10n.tagAgeGap
    ];
    final String? currentValidGender = genderOptions.any((g) => g['id'] == _gender) ? _gender : null;
    final String? currentValidRelationship = relationshipOptions.contains(_selectedRelationship) ? _selectedRelationship : null;

    // 2. 建立一個方便尋找翻譯的 Map (選用，方便維護)
    final Map<String, String> relationshipLabels = {
      'relationship_childhood_friend': l10n.relationship_childhood_friend,
      'relationship_senior_junior': l10n.relationship_senior_junior,
      'relationship_bickering_couple': l10n.relationship_bickering_couple,
      'relationship_colleagues': l10n.relationship_colleagues,
      'relationship_other': l10n.relationship_other,
    };

    return GestureDetector(
      // 點擊任何空白處時觸發這行：取消當前焦點（收起鍵盤）
        onTap: () => FocusScope.of(context).unfocus(),

        // 原本的 PopScope 變成 GestureDetector 的 child
      child: PopScope(
        canPop: false, // 永遠先攔截下來
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // 如果已經退出了就不用管

          // 呼叫我們精心設計的彈窗
          final shouldPop = await _showExitConfirmationDialog();

          if (shouldPop && context.mounted) {
            Navigator.of(context).pop(); // 玩家決定要走了，放行！
          }
        },
      // ✨✨✨ 核心升級：加入 DefaultTabController ✨✨✨
      child: DefaultTabController(
        length: 3, // 三個分頁
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? l10n.edit_character_title(widget.character!.name) : l10n.createCharacterTitle),
            elevation: 0,
            actions: [
              if (isEditing)
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
                  tooltip:l10n.test_mode_tooltip,
                  onPressed: () {
                    // 🛡️ 總裁防呆第一關：檢查角色是不是還沒出生的「幽靈」
                    if (widget.character == null) {
                      // ✨ 總裁級防禦網：測試模式精準攔截！告別突兀的橘色工程色塊
                      ToastUtils.showCenterToast(
                        context,
                        l10n.test_mode_error,
                        customIcon: Icons.warning_amber_rounded, // 💡 總裁精選：用優雅的黃色/橘色警告圖示，取代整塊橘色背景
                        // 如果你覺得這算是嚴重錯誤，也可以直接換成 isError: true
                      );
                      return; // 煞車！絕對不准跳轉！
                    }

// 💡 放行！
// ✨ 總裁級過場：測試模式啟動的專屬儀式感
                    ToastUtils.showCenterToast(
                      context,
                      l10n.test_mode_notice,
                      customIcon: Icons.science_rounded, // 💡 總裁秘技：「實驗室/燒杯」圖示！最適合用在 Test Mode 的放行提示
                      // 喜歡速度感的話，也可以用 Icons.rocket_launch_rounded (火箭發射) 🚀
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                      character: widget.character!, // 這時候用 ! 就絕對安全了
                      chatMode: 'daily',
                      sessionId: 'TEST_DRIVE_${DateTime.now().millisecondsSinceEpoch}',
                      selectedLanguage: l10n.traditional_chinese,
                      characterId: '',
                    )));
                  },
                ),
              if (isEditing)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _isDeleting ? null : _deleteCharacter,
                  tooltip:l10n.delete_character_tooltip,
                ),
            ],
            // ✨✨✨ 頂部導航分頁列 ✨✨✨
            bottom: TabBar(
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: theme.colorScheme.primary,
              tabs:  [
                Tab(icon: const Icon(Icons.menu_book), text: l10n.tab_basic_story),
                Tab(icon: const Icon(Icons.mic), text: l10n.tab_voice),
                Tab(icon: const Icon(Icons.hub), text: l10n.tab_relationship),
              ],
            ),
          ),
          body: Container(
            decoration: themeNotifier.currentBackground,
            child: Stack(
              children: [
                // ✨✨✨ 根據分頁顯示不同內容 ✨✨✨
                TabBarView(
                  children: [
                    // --- 抽屜 1：基本與劇情 ---
                    _buildTab1_BasicAndStory(theme, l10n, currentValidGender, currentValidRelationship, genderOptions, relationshipOptions, defaultPersonalityTags),

                    // --- 抽屜 2：語音設定 ---
                    _buildTab2_Voice(theme),

                    // --- 抽屜 3：關係編輯 ---
                    _buildTab3_Relationships(theme),
                  ],
                ),

                // --- 懸浮儲存按鈕 (維持在最上層，不管哪個分頁都看得到) ---
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    color: theme.scaffoldBackgroundColor.withValues(alpha:0.95),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 4,
                      ),
                      onPressed: _isSaving ? null : _saveCharacter,
                      child: _isSaving
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(isEditing ? l10n.save_changes_button : l10n.createButton, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
        ),
    );
  }

  Widget _buildTab1_BasicAndStory(ThemeData theme, AppLocalizations l10n, String? currentValidGender, String? currentValidRelationship, List<Map<String, String>> genderOptions, List<String> relationshipOptions, List<String> defaultPersonalityTags) {    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 150.0), // 底部留白給儲存按鈕
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageGallery(),
          const SizedBox(height: 24),
          // 💡「卡片 1：🧬 基礎資料
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.section_basic_info, theme),
                  _buildTextField(_nameController, l10n.charNameLabel),
                  _buildTextField(_ageController, l10n.charAgeLabel),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _occupationController,
                      decoration: InputDecoration(
                        labelText: l10n.charJobLabel, // 標籤維持原本的多國語系
                        hintText: l10n.hint_occupation, // ✨ 貼心的 UI 提示
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  _buildTextField(_birthdayController, l10n.charBirthdayLabel),
                  _buildTextField(_heightController, l10n.charHeightLabel),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: currentValidGender,
                      hint: Text(l10n.genderNotSelected),
                      decoration: InputDecoration(labelText: l10n.charGenderLabel, border: const OutlineInputBorder()),
                      items: genderOptions.map((g) => DropdownMenuItem(
                          value: g['id'],
                          child: Text(g['label']!)
                      )).toList(),                      onChanged: (newValue) => setState(() => _gender = newValue ?? ''),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBoxedTextField(_appearanceController, l10n.charAppearanceLabel, maxLength: 500, hintText:l10n.hint_appearance),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 💡 「卡片 2：🎭 劇本與你的身分」
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.section_story_identity, theme),
                  Text(l10n.story_identity_desc, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.6), fontSize: 12)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha:0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha:0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                               TextSpan(text: l10n.advanced_writing_tips_title, style: TextStyle(fontWeight: FontWeight.bold)),
                               TextSpan(text: l10n.advanced_writing_tips_1),
                                TextSpan(text: l10n.advanced_writing_tips_2, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                               TextSpan(text:l10n.advanced_writing_tips_3),
                               TextSpan(text:l10n.advanced_writing_tips_4),
                                TextSpan(text: l10n.advanced_writing_tips_5, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                                TextSpan(text:l10n.advanced_writing_tips_6),
                              ],
                            ),
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(
                      _playerIdentityController,
                      l10n.player_identity_label,
                      maxLength: 200,
                      hintText: l10n.player_identity_hint
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    // 這裡直接使用類別變數 relationshipKeys
                    value: relationshipKeys.contains(_selectedRelationship) ? _selectedRelationship : null,
                    hint: Text(l10n.charInitialRelationshipLabel),
                    decoration: InputDecoration(
                      labelText: l10n.charInitialRelationshipLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: relationshipKeys.map((key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        // 這裡如果報錯，代表 relationshipLabels 沒傳進來
                        // 妳可以直接在裡面定義一次翻譯 Map，或是從外部傳入
                        child: Text(key == 'relationship_other' ? l10n.relationship_other : _getTranslatedLabel(key, l10n)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedRelationship = newValue;
                        if (newValue != 'relationship_other') {
                          _customRelationshipController.clear();
                        }
                      });
                    },
                  ),
                  if (_selectedRelationship == 'relationship_other') ...[
                    const SizedBox(height: 12),
                    TextField(
                      scrollPadding: const EdgeInsets.only(bottom: 120),
                      controller: _customRelationshipController,
                      decoration: InputDecoration(
                        hintText: l10n.relationship_other, // 這裡也可以用翻譯
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  _buildBoxedTextField(
                      _backgroundController,
                      l10n.background_label,
                      maxLength: 800,
                      hintText: l10n.background_hint
                  ),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(_storySummaryController,l10n.story_summary_label, maxLength: 50),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(_storyController, l10n.story_initial_label, maxLength: 2500, hintText:l10n.story_initial_hint),
                  const SizedBox(height: 16),
                  TextFormField(
                    scrollPadding: const EdgeInsets.only(bottom: 120),
                    controller: _firstLineController,
                    decoration: InputDecoration(labelText: l10n.first_line_label, hintText: l10n.first_line_hint, border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 💡 「卡片 3：🌟 個性與好感度演變」
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.section_personality_evo, theme),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: {...defaultPersonalityTags, ..._personalityTags}.map((tag) {
                      return _buildTagButton(tag, _personalityTags.contains(tag), theme);
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _personalityController,
                    decoration: InputDecoration(
                      labelText: l10n.charOtherPersonalityTagsHint,
                      suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addCustomPersonalityTag),
                    ),
                    onFieldSubmitted: (_) => _addCustomPersonalityTag(),
                  ),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(
                      _detailedPersonalityController,
                      l10n.detailed_personality_label,
                      maxLength: 800,
                      hintText: l10n.detailed_personality_hint
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.affection_evo_desc, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.6), fontSize: 12)),
                  const SizedBox(height: 12),
                  _buildBoxedTextField(_stageStrangerController, l10n.stage_1_label, maxLength: 400, hintText: l10n.stage_1_hint),
                  const SizedBox(height: 12),
                  _buildBoxedTextField(_stageAcquaintanceController, l10n.stage_2_label, maxLength: 400, hintText: l10n.stage_2_hint),
                  const SizedBox(height: 12),
                  _buildBoxedTextField(_stageIntimateController,l10n.stage_3_label, maxLength: 400, hintText:l10n.stage_3_hint),
                  const SizedBox(height: 12),
                  _buildBoxedTextField(_socialInteractionController, l10n.social_interaction_label, maxLength: 400, hintText:l10n.social_interaction_hint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 💡 「卡片 4：🗣️ 喜好與習慣」
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.section_habits, theme),
                  _buildBoxedTextField(_likesController, l10n.charLikesLabel, maxLength: 200),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(_dislikesController, l10n.charDislikesLabel, maxLength: 200),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(_secretsController, l10n.charSecretsLabel, maxLength: 200),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(
                      _toneController,
                      l10n.charToneLabel,
                      maxLength: 500,
                      hintText: l10n.tone_hint_detail
                  ),
                  const SizedBox(height: 16),
                  _buildBoxedTextField(_dialogueExamplesController, l10n.charDialogueExampleLabel, maxLength: 500, hintText: l10n.dialogue_example_hint),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 💡「卡片 5：🎁 附加設定與彩蛋」
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.section_easter_eggs, theme),
                  if (_easterEggs.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text(l10n.no_easter_eggs)),
                    ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _easterEggs.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final egg = _easterEggs[index];
                      return Card(
                        elevation: 1,
                        color: theme.colorScheme.surfaceVariant.withValues(alpha:0.5),
                        child: ListTile(
                          leading: const Icon(Icons.card_giftcard, color: Colors.purple),
                          title: Text(egg.keyword, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${egg.title} - ${egg.setScene ?? l10n.no_scene_change}"),
                          trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.grey), onPressed: () => setState(() => _easterEggs.removeAt(index))),
                          onTap: () => _openEasterEggEditor(egg: egg, index: index),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _openEasterEggEditor(),
                    icon: const Icon(Icons.add),
                    label:Text(l10n.add_easter_egg_button),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        foregroundColor: theme.colorScheme.onSecondaryContainer
                    ),
                  ),
                  const Divider(height: 32),
                  Text(l10n.other_extra_info, style: theme.textTheme.titleMedium),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _extraInfoItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_extraInfoItems[index]),
                        trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _editExtraInfoItem(index)),
                        onLongPress: () => setState(() => _extraInfoItems.removeAt(index)),
                      );
                    },
                  ),
                  TextFormField(
                    controller: _extraInputController,
                    decoration: InputDecoration(
                      labelText: l10n.charExtraInfoHint,
                      suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addExtraInfoItem),
                    ),
                    onFieldSubmitted: (_) => _addExtraInfoItem(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPublicPrivateToggle(theme),
        ],
      ),
    );
  }
  Widget _buildTab2_Voice(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(l10n.section_voice_gen, theme),
                  Text(l10n.voice_gen_desc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 16),
                  if (_isGeneratingVoice)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(l10n.voice_generating_status, style: TextStyle(color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                    )

                  // 生成完成，顯示三張小卡片供選擇（且目前還沒決定綁定哪一個）
                  else if (_voiceSamples.isNotEmpty && _generatedVoiceId == null)
                    Column(
                      children: [
                       Text(l10n.voice_select_prompt, style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        // 🌟 產生 3 張聲線卡片
                        ...List.generate(_voiceSamples.length, (index) {
                          final sample = _voiceSamples[index];
                          final isSelected = _selectedSampleIndex == index;
                          bool isPlayingThis = _playingSampleIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSampleIndex = index;
                                _selectedVoiceId = sample['generated_voice_id'];
                              });
                            },
                            child: Card(
                              elevation: isSelected ? 4 : 1,
                              color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha:0.3) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                                    width: 2
                                ),
                              ),
                              child: ListTile(
                                leading: Icon(
                                    isSelected ? Icons.check_circle : Icons.mic_none,
                                    color: theme.colorScheme.primary
                                ),
                                title: Text(l10n.voice_sample_name(index + 1)),
                                subtitle:Text(l10n.voice_sample_desc),
                                // 🌟 這裡換成我們強化的 IconButton
                                trailing: IconButton(
                                  icon: Icon(
                                    isPlayingThis ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                    size: 32,
                                    color: isPlayingThis ? theme.colorScheme.primary : Colors.blue,
                                  ),
                                  onPressed: () async {
                                    if (isPlayingThis) {
                                      // 🛑 暫停
                                      await _audioPlayer.pause();
                                      setState(() {
                                        _playingSampleIndex = null;
                                      });
                                    } else {
                                      // 🎵 播放
                                      final Uint8List? bytes = sample['audio_bytes'];
                                      if (bytes != null && bytes.isNotEmpty) {
                                        // 🌟 1. 先毫無懸念地把圖示變成 ||，讓玩家立刻看到反應
                                        setState(() {
                                          _playingSampleIndex = index;
                                        });
                                        // 🌟 2. 加上 try-catch 防護，避免 stop() 當機
                                        try {
                                          await _audioPlayer.stop();
                                        } catch (e) {
                                          debugPrint('停止舊聲音時忽略錯誤');
                                        }
                                        // 🌟 3. 開始播放新聲音
                                        await _playVoice(bytes);
                                      } else {
                                        // ✨ 總裁級：語音準備中的優雅過場，把視線焦點還給角色！
                                        ToastUtils.showCenterToast(
                                          context, // 💡 如果是在 async 方法中，記得包裝 if (context.mounted)
                                          l10n.voice_preparing,
                                          customIcon: Icons.graphic_eq_rounded, // 💡 總裁精選 1：「聲音波形」圖示，完美暗示語音即將播放
                                          // 💡 總裁精選 2：如果你想強調「讀取中」，也可以用 Icons.hourglass_empty_rounded (沙漏)
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => setState(() {
                                  _voiceSamples = [];
                                  _selectedSampleIndex = null;
                                  _playingSampleIndex = null;
                                  _audioPlayer.stop();
                                }),
                                child:Text(l10n.voice_retry),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _selectedSampleIndex == null ? null : _confirmVoiceSelection,
                                child:Text(l10n.voice_confirm_selection),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )

                  // 3. 已經選好了（顯示成功綁定與最後的預覽按鈕）
                  else if (_generatedVoiceId != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withValues(alpha:0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(l10n.voice_bind_success_banner, style: TextStyle(fontWeight: FontWeight.bold))),
                            // 🌟 總裁解 BUG：重置時必須把舊的「綁定紀錄」徹底清空！
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _generatedVoiceId = null; // 🔑 關鍵 1：解開綁定，這樣才會掉進「顯示三張卡片」的判斷式
                                  _voiceSamples = [];       // 🔑 關鍵 2：清空舊的試聽檔案
                                  _selectedSampleIndex = null;
                                  _playingSampleIndex = null;
                                  _finalAudioBytes = null;
                                });
                                // 徹底清空後，再彈出輸入框讓玩家重新生成
                                _showVoiceGenerationDialog();
                              },
                              child: Text(l10n.voice_remake),
                            ),
                            if (_finalAudioBytes != null || (_finalVoicePreviewUrl != null && _finalVoicePreviewUrl!.isNotEmpty))
                              IconButton(
                                  icon: Icon(Icons.play_circle_fill, color: theme.colorScheme.primary, size: 32),
                                  onPressed: () {
                                    if (_finalAudioBytes != null) {
                                      // 優先播放剛生成的聲音
                                      _playVoice(_finalAudioBytes!);
                                    } else if (_finalVoicePreviewUrl != null) {
                                      // 否則播放上次存好的網址 (這裡要呼叫支援 URL 的播放函式)
                                      _audioPlayer.play(UrlSource(_finalVoicePreviewUrl!));
                                    }
                                  },
                              ),
                          ],
                        ),
                      )

                    // 4. 初始狀態（還沒生成，也沒樣板）
                    else
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          // 🌟 鎖定邏輯 1：如果正在生成，Icon 變成一個小小的轉圈圈；否則保持星星
                          icon: _isGeneratingVoice
                              ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2)
                          )
                              : const Icon(Icons.auto_awesome),
                          // 🌟 鎖定邏輯 2：文字也跟著改變，讓玩家知道進度
                          label: Text(_isGeneratingVoice ? l10n.voice_btn_generating : l10n.voice_btn_generate),
                          // 🌟 鎖定邏輯 3：如果是生成中，onPressed 設為 null，按鈕會自動變灰且無法點擊
                          onPressed: _isGeneratingVoice ? null : _showVoiceGenerationDialog,
                        ),
                      ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Text(l10n.voice_advanced_tuning, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),

                        // 🎚️ 滑桿 1：理智線 (Stability)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.voice_stability_low, style: TextStyle(fontSize: 12)),
                            Text(l10n.voice_stability_value(_voiceStability.toStringAsFixed(2)), style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                            Text(l10n.voice_stability_high, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Slider(
                          value: _voiceStability,
                          min: 0.1,
                          max: 0.9,
                          activeColor: Colors.pinkAccent,
                          onChanged: (value) => setState(() => _voiceStability = value),
                        ),
                        const SizedBox(height: 8),
                        // 🎚️ 滑桿 2：戲劇表現 (Style)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           Text(l10n.voice_style_low, style: TextStyle(fontSize: 12)),
                            Text(l10n.voice_style_value(_voiceStyle.toStringAsFixed(2)), style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                            Text(l10n.voice_style_high, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Slider(
                          value: _voiceStyle,
                          min: 0.0,
                          max: 1.0,
                          activeColor: Colors.pinkAccent,
                          onChanged: (value) => setState(() => _voiceStyle = value),
                        ),
                        const SizedBox(height: 16),
                        // 🌟 守護代幣的防護罩按鈕：加上這個才能發送 API！
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent, // 配合妳的 UI 顏色
                              foregroundColor: Colors.white,
                            ),
                            icon: _isTestingSettings
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.headphones),
                            label: Text(_isTestingSettings ? l10n.voice_test_btn_testing : l10n.voice_test_btn),
                            // 🔒 呼叫剛剛寫好的 _testVoiceSettings
                            onPressed: _isTestingSettings ? null : _testVoiceSettings,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ), // 🌟 這裡就是之前漏掉的結尾！
        ],
      ),
    );
  }
  Widget _buildTab3_Relationships(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle(l10n.section_social_circle, theme),
                      IconButton(onPressed: _showAddRelationshipDialog, icon: const Icon(Icons.group_add, color: Colors.blue)),
                    ],
                  ),
                  Text(l10n.social_circle_desc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 16),

                  if (_relationships.isEmpty)
                    Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(l10n.social_no_drama, style: TextStyle(color: Colors.grey)),
                    )),

                  // 迴圈顯示已建立的關係
                  ..._relationships.entries.map((entry) {
                    final targetId = entry.key;
                    final attitude = entry.value;

                    return Card(
                      margin: const EdgeInsets.only(top: 8),
                      color: theme.colorScheme.surfaceVariant.withValues(alpha:0.5),

                      // ✨ 派尋人小精靈去查名字！
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('artifacts')
                            .doc(AppConfig.appId)
                            .collection('public_characters') // 假設對象都是公開角色
                            .doc(targetId)
                            .get(),
                        builder: (context, snapshot) {
                          String displayName = targetId;
                          String avatarUrl = '';
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            displayName =l10n.loading_text;
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data() as Map<String, dynamic>;
                            displayName = data['name'] ?? targetId;
                            avatarUrl = data['avatarPath'] ?? '';
                          }
                          return ListTile(
                            // ✨ 如果有大頭貼就顯示，沒有就顯示預設 icon
                            leading: avatarUrl.isNotEmpty && avatarUrl.startsWith('http')
                                ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
                                : const Icon(Icons.compare_arrows, color: Colors.pinkAccent),

                            title: Text(l10n.social_target(displayName), style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(l10n.social_attitude(attitude)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                                  onPressed: () => _showEditRelationshipDialog(targetId, displayName, attitude),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => setState(() => _relationships.remove(targetId)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ✨ 專屬的「編輯社交圈看法」彈窗
  void _showEditRelationshipDialog(String targetId, String targetName, String currentAttitude) {
    final attitudeController = TextEditingController(text: currentAttitude);
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.social_edit_title(targetName)),
          content: TextField(
            controller: attitudeController,
            decoration:InputDecoration(
              labelText: l10n.social_attitude_label,
              hintText: l10n.social_attitude_hint,
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:Text( l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final newAttitude = attitudeController.text.trim();
                if (newAttitude.isNotEmpty) {
                  setState(() {
                    // 🌟 直接更新 Map 裡面的值
                    _relationships[targetId] = newAttitude;
                  });
                  Navigator.pop(context);
                }
              },
              child:Text(l10n.social_save_changes),
            ),
          ],
        );
      },
    );
  }

  void _showAddRelationshipDialog() {
    final l10n = AppLocalizations.of(context)!;
    final availableChars = _myCharacters.where((c) => c.id != widget.character?.id).toList();
    showDialog(
      context: context,
      builder: (context) {
        String? selectedCharId;
        final thoughtsController = TextEditingController();
        return AlertDialog(
          title:Text(l10n.social_add_title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration:InputDecoration(labelText:l10n.social_select_target),
                items: availableChars.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                onChanged: (v) => selectedCharId = v,
              ),
              const SizedBox(height: 16),
              TextField(
                scrollPadding: const EdgeInsets.only(bottom: 120),
                controller: thoughtsController,
                decoration:  InputDecoration(labelText: l10n.social_thoughts_label, hintText: l10n.social_thoughts_hint),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child:  Text(l10n.cancelButton
            )),
            ElevatedButton(
              onPressed: () {
                if (selectedCharId != null && thoughtsController.text.isNotEmpty) {
                  setState(() {
                    _relationships[selectedCharId!] = thoughtsController.text.trim();
                  });
                  Navigator.pop(context);
                }
              },
              child:Text(l10n.social_add_confirm),
            ),
          ],
        );
      },
    );
  }

  void _showEditPhotoDialog(int index) {
    final photo = _galleryPhotos[index];
    final TextEditingController descController = TextEditingController(text: photo.description);
    final TextEditingController reqController = TextEditingController(text: photo.requiredAffection.toString());
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.gallery_photo_edit_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descController,
              decoration:  InputDecoration(labelText: l10n.gallery_photo_edit_desc),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reqController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.gallery_photo_edit_req),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child:  Text(l10n.cancelButton)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _galleryPhotos[index] = CharacterPhoto(
                  imageUrl: photo.imageUrl,
                  localFile: photo.localFile,
                  description: descController.text,
                  requiredAffection: int.tryParse(reqController.text) ?? 0,
                );
                _galleryPhotos.sort((a, b) => a.requiredAffection.compareTo(b.requiredAffection));
              });
              Navigator.pop(context);
            },
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }

  // --- 全新相簿 UI (抓蟲升級版：Web CORS 防護版) ---
  Widget _buildImageGallery() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 🕵️‍♀️ 總裁邏輯：尋找「好感度 0」的照片作為主圖。如果找不到，就拿第一張。
    CharacterPhoto? mainPhoto;
    if (_galleryPhotos.isNotEmpty) {
      mainPhoto = _galleryPhotos.firstWhere(
            (p) => p.requiredAffection == 0,
        orElse: () => _galleryPhotos.first,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.charAlbumTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),

        // 🖼️ 上方：智慧大頭貼
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: mainPhoto != null && (mainPhoto.imageUrl.isNotEmpty || mainPhoto.localFile != null)
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image(
              image: _getImageProvider(
                  mainPhoto.localFile ?? (mainPhoto.imageUrl.isNotEmpty ? mainPhoto.imageUrl : null)
              ),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text(l10n.gallery_load_failed, style: const TextStyle(color: Colors.red, fontSize: 12)));
              },
            ),
          )
              : const Center(child: Icon(Icons.photo_camera_back_outlined, size: 60, color: Colors.grey)),
        ),
        const SizedBox(height: 10),

        // 🎞️ 下方：橫向縮圖 (點擊可編輯)
        SizedBox(
          height: 110, // 稍微加高一點
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _galleryPhotos.length + 1,
            itemBuilder: (context, index) {
              if (index == _galleryPhotos.length) {
                return _buildAddImageButton();
              }
              final photo = _galleryPhotos[index];
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  // 🚀 包裹 GestureDetector，點擊觸發編輯彈窗
                  GestureDetector(
                    onTap: () => _showEditPhotoDialog(index),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          // 🌟 如果它是大頭貼 (好感度0)，給它一個亮色的邊框標示
                          color: photo.requiredAffection == 0 ? theme.colorScheme.primary : Colors.grey.shade300,
                          width: photo.requiredAffection == 0 ? 2 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image(
                            image: _getImageProvider(photo.localFile ?? (photo.imageUrl.isNotEmpty ? photo.imageUrl : null)),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              color: Colors.black.withValues(alpha: 0.6),
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                // 顯示描述或好感度
                                photo.requiredAffection == 0 ? "大頭貼" : "LV.${photo.requiredAffection}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 刪除按鈕
                  GestureDetector(
                    onTap: () => setState(() => _galleryPhotos.removeAt(index)),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _addCharacterImage,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!)),
        child: const Icon(Icons.add_a_photo_outlined, color: Colors.black54),
      ),
    );
  }

  // --- 🌟 上傳圖片並彈出設定視窗的核心邏輯 ---
  Future<void> _addCharacterImage() async {
    final l10n = AppLocalizations.of(context)!;
    if (_galleryPhotos.length >= 10) {
      // ✨ 總裁級防護：溫柔的畫廊上限提示，保護畫面的整體美感！
      ToastUtils.showCenterToast(
        context,
        l10n.gallery_upload_limit,
        customIcon: Icons.photo_library_rounded, // 💡 總裁精選：用「相簿/畫廊」圖示，直覺告知容量已滿
        // 💡 總裁秘技：如果想稍微帶點提醒意味，也可以用 Icons.filter_9_plus_rounded (代表超過9個)
      );
      return;
    }

    // 🌟 瘦身魔法陣：直接在源頭把圖片壓縮！
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 1600,
      maxHeight: 1600,
    );

    if (image == null || !mounted) return;

    final affController = TextEditingController(text: '0');
    final descController = TextEditingController(text: l10n.default_photo_desc);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title:Text(l10n.gallery_photo_setup),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: kIsWeb
                  ? Image.network(image.path, height: 120, fit: BoxFit.cover)
                  : Image.file(File(image.path), height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            TextField(
              scrollPadding: const EdgeInsets.only(bottom: 120),
              controller: descController,
              decoration:InputDecoration(labelText: l10n.gallery_photo_desc_label, hintText: l10n.gallery_photo_desc_hint),
            ),
            const SizedBox(height: 8),
            TextField(
              scrollPadding: const EdgeInsets.only(bottom: 120),
              controller: affController,
              keyboardType: TextInputType.number,
              decoration:InputDecoration(labelText: l10n.gallery_photo_req_label, hintText:l10n.gallery_photo_req_hint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:Text(l10n.gallery_cancel_upload, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // 儲存到陣列中
              setState(() {
                _galleryPhotos.add(CharacterPhoto(
                  imageUrl: '', // 尚未上傳，所以網址是空的
                  localFile: image, // 👈 存入本地檔案 (此時已經是被嚴重壓縮過的版本了！)
                  requiredAffection: int.tryParse(affController.text) ?? 0,
                  description: descController.text.isEmpty ?l10n.default_photo_desc : descController.text,
                ));
              });
              Navigator.pop(context);
            },
            child:Text(l10n.gallery_confirm_add),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicPrivateToggle(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.visibility_label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              // ✨ 公開按鈕
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _isPublic = true),
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _isPublic ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.visibility_public,
                      style: TextStyle(
                        color: _isPublic ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 🔒 私人按鈕
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _isPublic = false),
                  borderRadius: BorderRadius.circular(30),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: !_isPublic ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.visibility_private,
                      style: TextStyle(
                        color: !_isPublic ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onPressed, ThemeData theme) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
        foregroundColor: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: isSelected ? 4 : 1,
      ),
      child: Text(text),
    );
  }
  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.7)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.dividerColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:  theme.colorScheme.primary, width: 2.0)),
        ),
      ),
    );
  }

  Widget _buildBoxedTextField(TextEditingController controller, String label, {required int maxLength, String? hintText}) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.4), fontSize: 13),
        labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
        ),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      ),
    );
  }

  void _togglePersonalityTag(String tag) {
    setState(() {
      if (_personalityTags.contains(tag)) {
        _personalityTags.remove(tag);
      } else {
        _personalityTags.add(tag);
      }
    });
  }

  void _addCustomPersonalityTag() {
    final newTag = _personalityController.text.trim();
    String tag = _personalityController.text.trim();
    if (tag.isNotEmpty && !_personalityTags.contains(tag)) {
      setState(() {
        _personalityTags.add(tag);
        _personalityTags.add(newTag);
        _personalityController.clear();
      });
    }
  }


  Widget _buildTagButton(String tag, bool isSelected, ThemeData theme) {
    return ElevatedButton(
      onPressed: () => _togglePersonalityTag(tag),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? theme.colorScheme.primary // 選中時使用主題的主要顏色
            : theme.colorScheme.surfaceVariant, // 未選中時使用一個柔和的背景色
        foregroundColor: isSelected
            ? theme.colorScheme.onPrimary // 選中時的文字顏色
            : theme.colorScheme.onSurfaceVariant, // 未選中時的文字顏色
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
      ),
      child: Text(tag),
    );
  }

  void _addExtraInfoItem() {
    final text = _extraInputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _extraInfoItems.add(text);
        _extraInputController.clear();
      });
    }
  }

  void _editExtraInfoItem(int index) {
    final l10n = AppLocalizations.of(context)!;
    final editController = TextEditingController(text: _extraInfoItems[index]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editExtraInfoTitle),
        content: TextField(
          controller: editController,
          autofocus: true,
          maxLines: null,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child:Text(l10n.cancelButton)),
          ElevatedButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  _extraInfoItems[index] = editController.text.trim();
                });
              }
              Navigator.pop(context);
            },
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }
}
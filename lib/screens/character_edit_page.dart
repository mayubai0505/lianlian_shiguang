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
import 'character_edit_basic_tab.dart';
import 'character_edit_voice_tab.dart';
import 'character_edit_relationship_tab.dart';
import '../services/toast_utils.dart';
import 'chat_page.dart';
import 'character_npc_tab.dart';
import 'character_model.dart';
import 'package:http/http.dart' as http; // ✨ 負責跟後端連線
import 'package:audioplayers/audioplayers.dart'; // 記得匯入
import '../services/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

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
    'relationship_none',
  ];
  String _relationshipNoneLabel(AppLocalizations l10n) {
    final locale = l10n.localeName.toLowerCase();
    if (locale.startsWith('ar')) return 'لا شيء';
    if (locale.startsWith('en')) return 'None';
    if (locale.startsWith('es')) return 'Ninguna';
    if (locale.startsWith('fr')) return 'Aucune';
    if (locale.startsWith('hi')) return 'कोई नहीं';
    if (locale.startsWith('id')) return 'Tidak ada';
    if (locale.startsWith('ja')) return 'なし';
    if (locale.startsWith('ko')) return '없음';
    if (locale.startsWith('ms')) return 'Tiada';
    if (locale.startsWith('pt')) return 'Nenhuma';
    if (locale.startsWith('th')) return 'ไม่มี';
    if (locale.startsWith('vi')) return 'Không có';
    if (locale.contains('hans') || locale == 'zh_cn') return '无';
    return '無';
  }

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
  bool _isLeavingPage = false;
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'asia-east1');
  Map<String, String> _relationships = {};
  List<Map<String, dynamic>> _voiceSamples = [];
  List<Map<String, dynamic>> newSamples = [];
  List<Character> _myCharacters = [];
  List<Map<String, dynamic>> _npcCharacters = [];
  String? _generatedVoiceId;
  String? _selectedVoiceId;    // 存聲音 ID
  static const String genderIdMale = 'male';
  static const String genderIdFemale = 'female';
  static const String genderIdOther = 'other';
  String? _currentDraftId;
  int? _selectedSampleIndex;
  int? _playingSampleIndex;
  int? _loadingSampleIndex;
  bool _isPreloadingFirstVoice = false;
  String? _finalVoicePreviewUrl;
  Uint8List? _finalAudioBytes; // 🌟 加在 _finalVoicePreviewUrl 旁邊
  bool _isLoadingMyCharacters = true;
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

// 新版合併後的角色核心設定
  final _coreCharacterSettingController = TextEditingController();
// 創作者自訂狀態欄／固定回覆格式
  final _customOutputFormatController = TextEditingController();
  final _worldSettingController = TextEditingController();
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
  bool _isCoreCharacterSettingExpanded = false;
  bool _isWorldSettingExpanded = false;
  DocumentReference? _newCharacterDocRef; // 防止新建角色重複產生多筆
  String _gender = '';
  List<String> _personalityTags = [];
  bool _isPublic = true;
  List<String> _extraInfoItems = [];
  // 變成這樣，用來存包含門檻與描述的完整圖片資料
  List<CharacterPhoto> _galleryPhotos = [];
  // 🖼️ 角色首頁橫幅
  XFile? _bannerLocalFile;
  String _bannerImagePath = '';
  bool _isRemovingBanner = false;
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
      debugPrint('🔊 播放器狀態目前是：$state');

      if (!mounted) return;

      switch (state) {
        case PlayerState.completed:
          setState(() {
            _playingSampleIndex = null;
          });
          break;

        case PlayerState.playing:
        case PlayerState.paused:
        case PlayerState.stopped:
        case PlayerState.disposed:
          break;
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
      final savedCoreCharacterSetting =
          mapData['coreCharacterSetting']?.toString().trim() ?? '';
      _customOutputFormatController.text =
          mapData['customOutputFormat']?.toString() ?? '';

      _coreCharacterSettingController.text =
      savedCoreCharacterSetting.isNotEmpty
          ? savedCoreCharacterSetting
          : _buildLegacyCoreCharacterSetting(
        detailedPersonality: char.detailedPersonality,
        toneAndStyle: char.toneAndStyle,
        socialInteraction:
        mapData['socialInteraction']?.toString() ?? '',
      );
      _worldSettingController.text =
      mapData['worldSetting']?.toString().trim().isNotEmpty == true
          ? mapData['worldSetting'].toString()
          : char.background;
      _likesController.text = char.likes;
      _dislikesController.text = char.dislikes;
      _secretsController.text = char.secrets;
      _appearanceController.text = char.appearance ;
      _dialogueExamplesController.text = char.dialogueExamples;
      _bannerImagePath = char.bannerImagePath;
      // -- 陣列與清單 (保留妳的安全寫法) --
      _personalityTags = _deduplicateTagsPreservingOrder(
        char.personalityTags,
      );
      _easterEggs = List.from(char.easterEggs);
      _extraInfoItems = List<String>.from(char.extraInfoItems ); // 👈 統一留這個最安全的！
      _npcCharacters = List<Map<String, dynamic>>.from(char.npcCharacters,);
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
        _npcCharacters =
        List<Map<String, dynamic>>.from(
          mapData['npcCharacters'] ?? [],
        );
      }
      String? oldRelation = char.initialRelationship;
      if (oldRelation.isNotEmpty) {
        if (relationshipKeys.contains(oldRelation)) {
          _selectedRelationship = oldRelation;
        } else {
          _selectedRelationship = 'relationship_other';
          _customRelationshipController.text = oldRelation;
        }
      } else if (_playerIdentityController.text.trim().isNotEmpty) {
        // 新版把「玩家預設身分」併入初始關係：
        // 舊角色若只有 playerIdentity，就帶進「其他」避免資料消失。
        _selectedRelationship = 'relationship_other';
        _customRelationshipController.text =
            _playerIdentityController.text.trim();
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
      _npcCharacters =
      List<Map<String, dynamic>>.from(
        data['npcCharacters'] ?? [],
      );

      // 1. 【基本欄位對齊】
      _nameController.text = data['name'] ?? '';
      _ageController.text = data['age']?.toString() ?? '';
      _occupationController.text = data['occupation'] ?? '';
      _birthdayController.text = data['birthday'] ?? '';
      _heightController.text = data['height']?.toString() ?? '';
      _appearanceController.text = data['appearance'] ?? '';
      _backgroundController.text = data['background'] ?? '';
      _worldSettingController.text =
      data['worldSetting']?.toString().trim().isNotEmpty == true
          ? data['worldSetting'].toString()
          : data['background']?.toString() ?? '';
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
      final savedCoreCharacterSetting =
          data['coreCharacterSetting']?.toString().trim() ?? '';
      _customOutputFormatController.text =
          data['customOutputFormat']?.toString() ?? '';

      _coreCharacterSettingController.text =
      savedCoreCharacterSetting.isNotEmpty
          ? savedCoreCharacterSetting
          : _buildLegacyCoreCharacterSetting(
        detailedPersonality:
        data['detailedPersonality']?.toString() ?? '',
        toneAndStyle:
        data['toneAndStyle']?.toString() ?? '',
        socialInteraction:
        data['socialInteraction']?.toString() ?? '',
      );
      _npcCharacters =
      List<Map<String, dynamic>>.from(
        data['npcCharacters'] ?? [],
      );

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
      final String savedBannerPath =
          data['bannerImagePath']?.toString() ?? '';

      if (savedBannerPath.isNotEmpty) {
        if (savedBannerPath.startsWith('http')) {
          _bannerImagePath = savedBannerPath;
        } else {
          _bannerLocalFile = XFile(savedBannerPath);
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
          _customRelationshipController.clear();
        } else {
          _customRelationshipController.text = savedRel;
        }
      }

      // 2. 【舊版身分設定相容】
      _playerIdentityController.text = data['playerIdentity'] ?? '';
      if ((_selectedRelationship == null ||
          (_selectedRelationship == 'relationship_other' &&
              _customRelationshipController.text.trim().isEmpty)) &&
          _playerIdentityController.text.trim().isNotEmpty) {
        _selectedRelationship = 'relationship_other';
        _customRelationshipController.text =
            _playerIdentityController.text.trim();
      }

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
      if (data['personalityTags'] != null) {
        _personalityTags = _deduplicateTagsPreservingOrder(
          data['personalityTags'] as List<dynamic>,
        );
      }
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

  String _buildLegacyCoreCharacterSetting({
    required String detailedPersonality,
    required String toneAndStyle,
    required String socialInteraction,
  }) {
    final sections = <String>[];

    if (detailedPersonality.trim().isNotEmpty) {
      sections.add(
        '【角色性格與設定】\n${detailedPersonality.trim()}',
      );
    }

    if (toneAndStyle.trim().isNotEmpty) {
      sections.add(
        '【說話語氣與風格】\n${toneAndStyle.trim()}',
      );
    }

    if (socialInteraction.trim().isNotEmpty) {
      sections.add(
        '【社交與環境互動】\n${socialInteraction.trim()}',
      );
    }

    return sections.join('\n\n');
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
    _coreCharacterSettingController.dispose();
    _customOutputFormatController.dispose();
    _worldSettingController.dispose();
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
    _audioPlayer.stop();
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
    debugPrint('🟣 進入 _saveToDraft：isEditing=$isEditing, currentDraftId=$_currentDraftId');

    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('⛔ _saveToDraft 被擋：user == null');
      return;
    }

    debugPrint('👤 _saveToDraft user=${user.uid}');
    if (user == null) return;
    // ✨ 1. 聰明判斷玩家要存哪個聲音 ID
    final String finalVoiceIdToSave = _generatedVoiceId ?? _selectedVoiceId ?? '';
    try {
      List<String> identitiesArray = _occupationController.text.trim().isEmpty
          ? []
          : _occupationController.text.split(RegExp(r'[/,，/／]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final String finalRelationship = (_selectedRelationship == 'relationship_other')
          ? _customRelationshipController.text.trim()
          : (_selectedRelationship == 'relationship_none' ? '' : (_selectedRelationship ?? ''));

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
            worldSetting: '',
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

      final String draftBannerPath;

      if (_bannerLocalFile != null) {
        draftBannerPath = _bannerLocalFile!.path;
      } else if (_isRemovingBanner) {
        draftBannerPath = '';
      } else {
        draftBannerPath = _bannerImagePath;
      }

      // 🌟 4. 終極草稿資料大集合
      final draftData = {
        'avatarPath': currentAvatarPath,
        'bannerImagePath': draftBannerPath,
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
        'personalityTags':
        _deduplicateTagsPreservingOrder(_personalityTags),
        'coreCharacterSetting':
        _coreCharacterSettingController.text.trim(),
        'customOutputFormat':
        _customOutputFormatController.text.trim(),
// 舊版相容：讓尚未更新的程式仍能取得完整角色設定
        'detailedPersonality':
        _coreCharacterSettingController.text.trim(),
        'worldSetting': _worldSettingController.text.trim(),
        'background': _backgroundController.text.trim(),
        'likes': _likesController.text.trim(),
        'dislikes': _dislikesController.text.trim(),
        'secrets': _secretsController.text.trim(),
        'toneAndStyle': '',
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
        'userId': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'extraInfoItems': _extraInfoItems,
        'content_language': l10n.localeName,
        'stageStranger': _stageStrangerController.text.trim(),
        'stageAcquaintance': _stageAcquaintanceController.text.trim(),
        'stageIntimate': _stageIntimateController.text.trim(),
        'socialInteraction': '',
        'easterEggs': _easterEggs.map((egg) => egg.toMap()).toList(),
        'playerIdentity': finalRelationship,
        'voice_id': finalVoiceIdToSave.isEmpty ? null : finalVoiceIdToSave,
        'voice_preview_url': _finalVoicePreviewUrl,
        'voiceStability': _voiceStability,
        'voiceStyle': _voiceStyle,
        'voiceSource': finalVoiceIdToSave.isEmpty ? null : 'voice_bank',
        'relationships': _relationships, // 🌟 補上這行，Tab 3 的關係就不會消失了！
        'npcCharacters': _npcCharacters,
        'multiCharacters': multiCharactersString,
        'sourceCharacterId': widget.character?.id,
        'sourceWasPublic': widget.character?.isPublic,
      };

      // 如果目前沒有草稿 ID，但這是從既有角色編輯來的，先查是否已經有草稿
      if (_currentDraftId == null && widget.character?.id != null) {
        final existingDraftQuery = await _db
            .collection('draft_characters')
            .where('userId', isEqualTo: user.uid)
            .where('sourceCharacterId', isEqualTo: widget.character!.id)
            .limit(1)
            .get();

        if (existingDraftQuery.docs.isNotEmpty) {
          _currentDraftId = existingDraftQuery.docs.first.id;
          debugPrint('🟡 找到既有草稿，改為更新：draftId=$_currentDraftId');
        }
      }

      // 🌟 5. 寫入 Firestore 的草稿區 (draft_characters)
      debugPrint('🟣 準備寫入草稿：currentDraftId=$_currentDraftId');

      if (_currentDraftId != null) {

        await _db
            .collection('draft_characters')
            .doc(_currentDraftId)
            .set(draftData, SetOptions(merge: true));
      } else {
        debugPrint('🟣 新增草稿中...');

        final docRef = await _db.collection('draft_characters').add({
          ...draftData,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _currentDraftId = docRef.id;
        debugPrint('✅ 新草稿建立成功：draftId=$_currentDraftId');
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

  Future<void> _leaveCharacterEditPage(
      Map<String, dynamic> result,
      ) async {
    if (!mounted || _isLeavingPage) return;

    setState(() {
      _isLeavingPage = true;
    });

    debugPrint(
      '🚪 返回原本的 ProfilePage：$result',
    );

    Navigator.of(context).pop(result);
  }

  Future<Map<String, dynamic>?> _showExitConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;

    if (_nameController.text.isEmpty && _storySummaryController.text.isEmpty) {
      return {
        'shouldLeave': true,
        'changed': false,
      };
    }

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.draft_save_title),
        content: Text(l10n.draft_save_content),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              await Future.delayed(const Duration(milliseconds: 200));

              if (!mounted) return;

              await _leaveCharacterEditPage({
                'shouldLeave': true,
                'changed': false,
                'notSaved': true,
                'goProfile': true,
              });
            },
            child: Text(
              l10n.not_save,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop({
                'shouldLeave': false,
                'changed': false,
              });
            },
            child: Text(l10n.cancel),
          ),

          ElevatedButton(
            onPressed: () async {
              debugPrint('🟣 離開確認視窗：儲存草稿按鈕被點擊');

              await _saveToDraft();

              debugPrint('✅ _saveToDraft 已結束，準備關閉確認視窗');

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(); // 只關儲存確認視窗
              }

              await Future.delayed(const Duration(milliseconds: 500));

              if (!mounted) return;

              await _leaveCharacterEditPage({
                'changed': true,
                'goProfile': true,
                'draftSaved': true,
              });
            },
            child: Text(l10n.save_draft),
          ),
        ],
      ),
    );
    return result;
  }

  Future<void> _handleExitPressed() async {
    if (!mounted || _isLeavingPage) return;

    final result = await _showExitConfirmationDialog();

    if (!mounted || result == null) return;

    if (result['shouldLeave'] == true) {
      await _leaveCharacterEditPage(result);
    }
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

    bool shouldSkipResetDeleting = false;

    try {
      final batch = _db.batch();
      final characterId = widget.character!.id;

      final publicRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId);

      final privateRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(user.uid)
          .collection('private_characters')
          .doc(characterId);

      final legacyPrivateRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('private_characters')
          .doc(characterId);

      Future<void> deleteDocAndPhotos(DocumentReference ref) async {
        // 先確認角色文件真的存在。
        // Firestore Rules 的 ownerExisting() 依賴 resource.data；
        // 若對「不存在」的角色文件直接 delete，會被判定 permission-denied。
        final parentSnapshot = await ref.get();

        if (!parentSnapshot.exists) {
          debugPrint('ℹ️ 跳過不存在的角色路徑：${ref.path}');
          return;
        }

        final photosSnapshot = await ref.collection('photos').get();

        for (final doc in photosSnapshot.docs) {
          batch.delete(doc.reference);
        }

        batch.delete(ref);
      }

      await deleteDocAndPhotos(publicRef);
      await deleteDocAndPhotos(privateRef);
      await deleteDocAndPhotos(legacyPrivateRef);

      await batch.commit();

      if (!mounted) return;

      shouldSkipResetDeleting = true;

      setState(() {
        _isLeavingPage = true;
      });

      Navigator.of(context).pop({
        'changed': true,
        'deleted': true,
        'characterId': characterId,
        'goProfile': true,
        'message': l10n.char_deleted,
      });
    } catch (e) {
      debugPrint('❌ 刪除角色失敗: $e');

      if (mounted) {
        _showErrorDialog(l10n.delete_failed_msg, e.toString());
      }
    } finally {
      if (mounted && !shouldSkipResetDeleting) {
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

    if (user == null) {
      if (mounted) {
        setState(() {
          _isLoadingMyCharacters = false;
        });
      }
      return;
    }

    try {
      final publicDocs = await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .where('createdBy', isEqualTo: user.uid)
          .get();

      final privateDocs = await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(user.uid)
          .collection('private_characters')
          .get();

      final publicChars = await Future.wait(
        publicDocs.docs
            .map((doc) => Character.fromFirestoreAsync(doc))
            .toList(),
      );

      final privateChars = await Future.wait(
        privateDocs.docs
            .map((doc) => Character.fromFirestoreAsync(doc))
            .toList(),
      );

      if (!mounted) return;

      setState(() {
        _myCharacters = [
          ...publicChars,
          ...privateChars,
        ];

        _isLoadingMyCharacters = false;
      });
    } catch (e) {
      debugPrint('抓取角色關係清單失敗: $e');

      if (mounted) {
        setState(() {
          _isLoadingMyCharacters = false;
        });
      }
    }
  }

  Future<void> _saveCharacter() async {

    if (_isSaving) {
      debugPrint('⛔ _saveCharacter 被擋：_isSaving 已經是 true');
      return;
    }
    if (_isSaving) return;
    final l10n = AppLocalizations.of(context)!;
    // 🌟 1. 基礎防呆與字數檢查 (維持妳原本的優良設計)
    final allImages = _galleryPhotos.length;
    if (_nameController.text.trim().isEmpty || allImages == 0) {
      _showErrorDialog(l10n.cannot_save_title, l10n.cannot_save_content);
      return;
    }
    if (_gender.trim().isEmpty) {
      _showErrorDialog(
        l10n.content_missing,
        l10n.characterEditSelectGender,
      );
      return;
    }
    final String finalVoiceIdToSave = _generatedVoiceId ?? _selectedVoiceId ?? '';

// 🌟 1. 配置清單：直接把「標籤、控制器、上限」綁在一起
    final List<Map<String, dynamic>> checkList = [
      {
        'label': l10n.characterEditCoreSetting,
        'controller': _coreCharacterSettingController,
        'limit': 6000,
      },
      {
        'label': l10n.characterEditWorldview,
        'controller': _worldSettingController,
        'limit': 10000,
      },
      {
        'label': l10n.field_initial_story,
        'controller': _storyController,
        'limit': 1500,
      },
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

    if (_coreCharacterSettingController.text.trim().length < 10) {
      _showErrorDialog(
        l10n.content_missing,
        l10n.characterEditSettingsMinLength,
      );
      return;
    }

    if (_worldSettingController.text.trim().length < 20) {
      _showErrorDialog(
        l10n.content_missing,
        l10n.characterEditWorldviewMinLength,
      );
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

    const Set<String> officialCreatorUids = {
      'B71k2kyooubYsOtIO1nkiBwyBXt2',
    };

    final bool isOfficialCreator = officialCreatorUids.contains(currentUser.uid);

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

      // 搬家時暫存舊路徑與記憶碎片，避免只搬主文件、漏掉 lores 子集合
      DocumentReference? oldDocRefForMove;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> loreDocsToMove = [];

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
          oldDocRefForMove = oldDocRef;

          // Firestore 不會自動搬移子集合，所以先把舊家的記憶碎片全部讀出來
          final oldLoresSnapshot = await oldDocRef
              .collection('lores')
              .get();

          loreDocsToMove = oldLoresSnapshot.docs;
          debugPrint(
            '📦 準備搬移 ${loreDocsToMove.length} 則記憶碎片：'
                '${oldDocRef.path} → ${charDocRef.path}',
          );
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
          _newCharacterDocRef ??= collectionRef.doc();
          charDocRef = _newCharacterDocRef!;
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

      String finalBannerImagePath = _bannerImagePath;

// 使用者按過移除
      if (_isRemovingBanner) {
        finalBannerImagePath = '';
      }

// 使用者選了新的本機橫幅
      if (_bannerLocalFile != null) {
        final String fileName =
            'char_${charDocRef.id}_banner_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final Reference bannerStorageRef = storage.ref().child(
          'artifacts/lianlianshiguang/character_banners/$fileName',
        );

        if (kIsWeb) {
          final Uint8List bytes =
          await _bannerLocalFile!.readAsBytes();

          await bannerStorageRef.putData(
            bytes,
            SettableMetadata(contentType: 'image/jpeg'),
          );
        } else {
          await bannerStorageRef.putFile(
            File(_bannerLocalFile!.path),
            SettableMetadata(contentType: 'image/jpeg'),
          );
        }

        finalBannerImagePath =
        await bannerStorageRef.getDownloadURL();

        _bannerImagePath = finalBannerImagePath;
        _bannerLocalFile = null;
        _isRemovingBanner = false;
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
            worldSetting: '',
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
          : (_selectedRelationship == 'relationship_none' ? '' : (_selectedRelationship ?? '')); // 「無」存成空字串
      final String originalCreatedBy =
      (widget.character?.createdBy ?? '').trim().isNotEmpty
          ? widget.character!.createdBy
          : currentUser.uid;
      final creatorProfileDoc = await _db
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final String creatorName =
          creatorProfileDoc.data()?['nickname']
              ?.toString()
              .trim() ??
              currentUser.displayName?.trim() ??
              '';
      // 相容舊版，還是把 galleryData 存在主資料夾一份
      final galleryData = _galleryPhotos.map((p) => p.toMap()).toList();
      Map<String, dynamic> characterData = {
        'avatarPath': galleryPathsOnly.isNotEmpty ? galleryPathsOnly.first : 'assets/images/blank_avatar.png',
        'bannerImagePath': finalBannerImagePath,
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
        'personalityTags':
        _deduplicateTagsPreservingOrder(_personalityTags),
        'coreCharacterSetting':
        _coreCharacterSettingController.text.trim(),
        'customOutputFormat':
        _customOutputFormatController.text.trim(),
// 舊版相容：讓尚未更新的程式仍能取得完整角色設定
        'detailedPersonality':
        _coreCharacterSettingController.text.trim(),
        'worldSetting': _worldSettingController.text.trim(),

// 舊版相容欄位暫時保留
        'background': _backgroundController.text.trim(),
        'likes': _likesController.text.trim(),
        'dislikes': _dislikesController.text.trim(),
        'secrets': _secretsController.text.trim(),
        'toneAndStyle': '',
        'initialRelationship': finalRelationship,
        'dialogueExamples': _dialogueExamplesController.text.trim(),
        'storySummary': _storySummaryController.text.trim(),
        'story': _storyController.text.trim(),
        'storyModeFirstLine': _firstLineController.text.trim(),
        'isPublic': _isPublic,
        'isOfficial': _isPublic && isOfficialCreator,
        'isDraft': false,
        'isCompleted': true,
        'status': 'published',
        'createdBy': originalCreatedBy,
        'creatorName': creatorName,
        'creatorNameLower': creatorName.toLowerCase(),
        'extraInfoItems': _extraInfoItems,
        'content_language': l10n.localeName,
        'stageStranger': _stageStrangerController.text.trim(),
        'stageAcquaintance': _stageAcquaintanceController.text.trim(),
        'stageIntimate': _stageIntimateController.text.trim(),
        'socialInteraction': '',
        'easterEggs': _easterEggs.map((egg) => egg.toMap()).toList(),
        'playerIdentity': finalRelationship,
        'voice_id': finalVoiceIdToSave.isEmpty ? null : finalVoiceIdToSave,
        'voice_preview_url': _finalVoicePreviewUrl,
        'voiceStability': _voiceStability,
        'voiceStyle': _voiceStyle,
        'voiceSource': finalVoiceIdToSave.isEmpty ? null : 'voice_bank',
        'relationships': _relationships,
        'npcCharacters': _npcCharacters,   // 👈 加這裡
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
          characterData['createdBy'] = originalCreatedBy;
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

      // 如果公開／私人狀態改變，連同記憶碎片一起搬到新路徑
      if (isMovingFolder &&
          oldDocRefForMove != null &&
          loreDocsToMove.isNotEmpty) {
        for (final loreDoc in loreDocsToMove) {
          final newLoreRef = charDocRef
              .collection('lores')
              .doc(loreDoc.id);

          // 保留原本文件 ID 與全部欄位
          batch.set(
            newLoreRef,
            loreDoc.data(),
            SetOptions(merge: true),
          );

          // 新家寫入成功後，同一批次刪除舊家的記憶
          batch.delete(loreDoc.reference);
        }
      }

      // 🌟 6. 管家，執行 Batch 寫入！
      await batch.commit();

      if (isMovingFolder && loreDocsToMove.isNotEmpty) {
        debugPrint(
          '✅ 已完成搬移 ${loreDocsToMove.length} 則記憶碎片',
        );
      }
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
      if (!mounted) return;
      // 先關掉 loading dialog
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (!mounted) return;

      final result = {
        'changed': true,
        'goProfile': true,
        'action': isEditing ? 'updated' : 'created',
        'message': l10n.char_saved_success(
          characterData['name'],
          isEditing ? l10n.update_action : l10n.createButton,
        ),
      };

      debugPrint('✅ 準備返回上一頁 result=$result');

// 直接回上一頁，不要在這頁先跳 Toast
      Navigator.of(context).pop(result);

      return;
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
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
      _personalityTags = _deduplicateTagsPreservingOrder(
        prefs.getStringList('temp_char_personalityTags') ?? [],
      );
      _detailedPersonalityController.text = prefs.getString('temp_char_detailedPersonality') ?? '';
      final savedCoreSetting =
          prefs.getString('temp_char_coreCharacterSetting')?.trim() ?? '';

      _coreCharacterSettingController.text =
      savedCoreSetting.isNotEmpty
          ? savedCoreSetting
          : prefs
          .getString('temp_char_detailedPersonality')
          ?.trim() ??
          '';
      _worldSettingController.text =
          prefs.getString('temp_char_worldSetting') ??
              prefs.getString('temp_char_background') ??
              '';
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
      final savedBannerPath =
          prefs.getString('temp_char_bannerImagePath') ?? '';

      if (savedBannerPath.startsWith('http')) {
        _bannerImagePath = savedBannerPath;
      } else if (savedBannerPath.isNotEmpty) {
        _bannerLocalFile = XFile(savedBannerPath);
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
    await prefs.setStringList(
      'temp_char_personalityTags',
      _deduplicateTagsPreservingOrder(_personalityTags),
    );
    await prefs.setString(
      'temp_char_coreCharacterSetting',
      _coreCharacterSettingController.text.trim(),
    );

// 舊版相容
    await prefs.setString(
      'temp_char_detailedPersonality',
      _coreCharacterSettingController.text.trim(),
    );    await prefs.setString(
      'temp_char_worldSetting',
      _worldSettingController.text.trim(),
    );
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
    final String tempBannerPath =
        _bannerLocalFile?.path ?? _bannerImagePath;

    await prefs.setString(
      'temp_char_bannerImagePath',
      tempBannerPath,
    );
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

  Future<void> _preloadFirstVoiceSample() async {
    if (_isPreloadingFirstVoice || _voiceSamples.isEmpty) {
      return;
    }

    final sample = _voiceSamples.first;

    final String voiceId =
        sample['voice_id']?.toString().trim() ?? '';

    if (voiceId.isEmpty) return;

    final Uint8List? cachedBytes =
    sample['audio_bytes'] as Uint8List?;

    if (cachedBytes != null && cachedBytes.isNotEmpty) {
      return;
    }

    _isPreloadingFirstVoice = true;

    try {
      final l10n = AppLocalizations.of(context)!;

      debugPrint(
        '⏳ 開始背景預載第一個 Voice：$voiceId',
      );

      final callable = _functions.httpsCallable(
        'testVoiceSettings',
      );

      final result = await callable.call({
        'voiceId': voiceId,
        'text': l10n.voice_sample_script,
        'stability': _voiceStability,
        'style': _voiceStyle,
        'speed': 0.92,
      });

      if (result.data is! Map) {
        debugPrint('⚠️ 第一個 Voice 預載格式錯誤');
        return;
      }

      final data = Map<String, dynamic>.from(
        result.data as Map,
      );

      final String audioBase64 =
          data['audio_base_64']?.toString() ?? '';

      if (audioBase64.isEmpty) {
        debugPrint('⚠️ 第一個 Voice 預載回傳空音訊');
        return;
      }

      final Uint8List audioBytes =
      base64Decode(audioBase64);

      if (audioBytes.isEmpty || !mounted) return;

      // 確認預載期間 Voice 清單沒有被重新生成。
      if (_voiceSamples.isEmpty) return;

      final String currentFirstVoiceId =
          _voiceSamples.first['voice_id']
              ?.toString()
              .trim() ??
              '';

      if (currentFirstVoiceId != voiceId) {
        debugPrint(
          '⚠️ Voice 清單已更新，略過舊的預載結果',
        );
        return;
      }

      setState(() {
        _voiceSamples[0]['audio_bytes'] =
            audioBytes;
      });

      debugPrint(
        '✅ 第一個 Voice 已背景預載完成',
      );
    } on FirebaseFunctionsException catch ( e, stackTrace ) {
      // 預載失敗不影響正常使用；
      // 玩家按下播放時仍會再正式呼叫一次。
      debugPrint(
        '⚠️ 第一個 Voice 預載失敗：'
            '${e.code} ${e.message}',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      debugPrint('⚠️ 第一個 Voice 預載發生錯誤：$e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isPreloadingFirstVoice = false;
    }
  }

  // 🌟 1. 括號裡的 characterName 加上問號 (?)，代表「可以不傳」，並拿掉預設值
  Future<void> _generateVoiceFromAPI(
      String prompt, {
        String? characterName,
        String gender = 'male',
        String age = 'young',
      }) async {
    final l10n = AppLocalizations.of(context)!;

    final String finalCharacterName =
    (characterName?.trim().isNotEmpty ?? false)
        ? characterName!.trim()
        : l10n.me;

    if (mounted) {
      setState(() {
        _isGeneratingVoice = true;
        _voiceSamples = [];
        _selectedSampleIndex = null;
        _playingSampleIndex = null;
      });
    }

    try {
      debugPrint('========== 開始配對 Voice Bank ==========');
      debugPrint('Character: $finalCharacterName');
      debugPrint('Gender: $gender');
      debugPrint('Age: $age');
      debugPrint('Description: ${prompt.trim()}');

      final callable = _functions.httpsCallable(
        'matchVoiceFromBank',
      );

      final result = await callable.call({
        'description': prompt.trim(),
        'characterName': finalCharacterName,
        'gender': gender,
        'age': age,
      });

      debugPrint(
        '✅ matchVoiceFromBank 回傳：${result.data}',
      );

      if (result.data is! Map) {
        throw Exception('語音服務回傳格式錯誤');
      }

      final responseData = Map<String, dynamic>.from(
        result.data as Map,
      );

      final rawPreviews = responseData['previews'];

      if (rawPreviews is! List) {
        throw Exception('語音服務沒有回傳 previews');
      }

      final List<Map<String, dynamic>> matchedSamples = [];

      for (int i = 0; i < rawPreviews.length; i++) {
        final rawPreview = rawPreviews[i];

        if (rawPreview is! Map) {
          debugPrint('⚠️ 第 $i 個配對結果格式錯誤，已略過');
          continue;
        }

        final preview = Map<String, dynamic>.from(
          rawPreview,
        );

        final String voiceId =
            preview['voiceId']?.toString().trim() ??
                preview['voice_id']?.toString().trim() ??
                '';

        if (voiceId.isEmpty) {
          debugPrint('⚠️ 第 $i 個配對結果缺少 voiceId，已略過');
          continue;
        }

        final rawSettings = preview['defaultSettings'];
        final Map<String, dynamic> defaultSettings =
        rawSettings is Map
            ? Map<String, dynamic>.from(rawSettings)
            : <String, dynamic>{};

        matchedSamples.add({
          'voice_id': voiceId,
          'name': preview['name']?.toString().trim() ?? '',
          'preview_url':
          preview['previewUrl']?.toString().trim() ??
              preview['preview_url']?.toString().trim() ??
              '',
          'match_score': preview['score'] ?? preview['matchScore'],
          'default_settings': defaultSettings,

          // 第一次播放後會把試聽音訊暫存在這裡，
          // 再按一次不需要重新呼叫 API。
          'audio_bytes': null,
        });
      }

      if (matchedSamples.isEmpty) {
        throw Exception(l10n.voice_search_failed_retry);
      }

      if (!mounted) return;

      final firstSettings =
      matchedSamples.first['default_settings'];

      setState(() {
        _voiceSamples = matchedSamples;
        _selectedSampleIndex = 0;
        _selectedVoiceId =
            matchedSamples.first['voice_id']?.toString();

        if (firstSettings is Map) {
          final stability = firstSettings['stability'];
          final style = firstSettings['style'];

          if (stability is num) {
            _voiceStability =
                stability.toDouble().clamp(0.1, 0.9);
          }

          if (style is num) {
            _voiceStyle =
                style.toDouble().clamp(0.0, 1.0);
          }
        }

        _isGeneratingVoice = false;
      });

      unawaited(_preloadFirstVoiceSample());

      debugPrint(
        '✅ 成功配對 ${matchedSamples.length} 個 Voice Bank 聲音',
      );
    } on FirebaseFunctionsException catch (
    e,
    stackTrace
    ) {
      debugPrint(
        '========== Voice Bank 配對失敗 ==========',
      );
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');
      debugPrint('details: ${e.details}');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isGeneratingVoice = false;
      });

      ToastUtils.showCenterToast(
        context,
        e.message ?? l10n.voice_search_incomplete_retry,
        isError: true,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========== Voice Bank 配對未知錯誤 ==========',
      );
      debugPrint('error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isGeneratingVoice = false;
      });

      ToastUtils.showCenterToast(
        context,
        l10n.elevenlabs_error(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
        isError: true,
      );
    }
  }

  Future<void> _previewVoiceSample(int index) async {
    if (index < 0 || index >= _voiceSamples.length) {
      return;
    }

    // 同一張卡片正在生成時，禁止重複點擊。
    if (_loadingSampleIndex == index) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final sample = _voiceSamples[index];

    final String voiceId =
        sample['voice_id']?.toString().trim() ?? '';

    if (voiceId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.voice_data_incomplete,
        isError: true,
      );
      return;
    }

    // 點擊目前播放中的 Voice：暫停。
    if (_playingSampleIndex == index) {
      await _audioPlayer.pause();

      if (!mounted) return;

      setState(() {
        _playingSampleIndex = null;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      _loadingSampleIndex = index;
    });

    try {
      final Uint8List? cachedBytes =
      sample['audio_bytes'] as Uint8List?;

      Uint8List audioBytes;

      // 有預載或先前快取，直接使用。
      if (cachedBytes != null && cachedBytes.isNotEmpty) {
        audioBytes = cachedBytes;
        debugPrint('⚡ 使用 Voice 快取：$voiceId');
      } else {
        debugPrint('⏳ Voice 尚未快取，開始生成：$voiceId');

        final callable = _functions.httpsCallable(
          'testVoiceSettings',
        );

        final result = await callable.call({
          'voiceId': voiceId,
          'text': l10n.voice_sample_script,
          'stability': _voiceStability,
          'style': _voiceStyle,
          'speed': 0.92,
        });

        if (result.data is! Map) {
          throw Exception('試聽服務回傳格式錯誤');
        }

        final data = Map<String, dynamic>.from(
          result.data as Map,
        );

        final String audioBase64 =
            data['audio_base_64']?.toString() ?? '';

        if (audioBase64.isEmpty) {
          throw Exception('試聽音訊資料為空');
        }

        audioBytes = base64Decode(audioBase64);

        if (audioBytes.isEmpty) {
          throw Exception('試聽音訊解析失敗');
        }

        if (!mounted) return;

        // 確認生成期間 Voice 清單沒有被換掉。
        if (index >= _voiceSamples.length ||
            _voiceSamples[index]['voice_id']?.toString() != voiceId) {
          debugPrint('⚠️ Voice 清單已更新，略過舊音訊');
          return;
        }

        setState(() {
          _voiceSamples[index]['audio_bytes'] = audioBytes;
        });
      }

      if (!mounted) return;

      // 先設定播放中的卡片，再正式播放。
      setState(() {
        _playingSampleIndex = index;
      });

      await _playVoice(audioBytes);
    } on FirebaseFunctionsException catch (e, stackTrace) {
      debugPrint(
        l10n.voice_preview_failed_detail(
          e.code,
          e.message ?? '',
        ),
      );
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _playingSampleIndex = null;
      });

      ToastUtils.showCenterToast(
        context,
        e.message ?? l10n.voice_generation_failed_retry,
        isError: true,
      );
    } catch (e, stackTrace) {
      debugPrint('試聽聲音發生錯誤：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _playingSampleIndex = null;
      });

      ToastUtils.showCenterToast(
        context,
        l10n.voice_playback_failed_retry,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          if (_loadingSampleIndex == index) {
            _loadingSampleIndex = null;
          }
        });
      }
    }
  }

  Future<void> _testVoiceSettings() async {
    final l10n = AppLocalizations.of(context)!;

    final String targetVoiceId =
    (_generatedVoiceId ?? _selectedVoiceId ?? '')
        .trim();

    if (targetVoiceId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.voice_bind_first,
        customIcon: Icons.mic_external_off_rounded,
      );
      return;
    }

    if (_isTestingSettings) return;

    setState(() {
      _isTestingSettings = true;
    });

    try {
      final callable = _functions.httpsCallable(
        'testVoiceSettings',
      );

      final result = await callable.call({
        'voiceId': targetVoiceId,
        'text': l10n.voice_test_script,
        'stability': _voiceStability,
        'style': _voiceStyle,
      });

      if (result.data is! Map) {
        throw Exception('試聽服務回傳格式錯誤');
      }

      final data = Map<String, dynamic>.from(
        result.data as Map,
      );

      final String audioBase64 =
          data['audio_base_64']?.toString() ?? '';

      if (audioBase64.isEmpty) {
        throw Exception('試聽音訊資料為空');
      }

      final Uint8List audioBytes =
      base64Decode(audioBase64);

      if (!mounted) return;

      _finalAudioBytes = audioBytes;

      await _playVoice(audioBytes);
    } on FirebaseFunctionsException catch (
    e,
    stackTrace
    ) {
      debugPrint(
        '========== testVoiceSettings 失敗 ==========',
      );
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');
      debugPrint('details: ${e.details}');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        e.message ?? l10n.voice_test_failed,
        isError: true,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 試聽失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.voice_test_failed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTestingSettings = false;
        });
      }
    }
  }

  Future<void> _confirmVoiceSelection() async {
    if (_selectedSampleIndex == null ||
        _voiceSamples.isEmpty) {
      return;
    }

    if (_isSaving) return;

    final l10n = AppLocalizations.of(context)!;
    final selectedSample =
    _voiceSamples[_selectedSampleIndex!];

    final String realVoiceId =
        selectedSample['voice_id']
            ?.toString()
            .trim() ??
            '';

    final String previewUrl =
        selectedSample['preview_url']
            ?.toString()
            .trim() ??
            '';

    final Uint8List? selectedAudioBytes =
    selectedSample['audio_bytes']
    as Uint8List?;

    if (realVoiceId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.selected_voice_data_incomplete,
        isError: true,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      debugPrint(
        '✅ Voice選定正式 Voice ID：$realVoiceId',
      );

      if (!mounted) return;

      setState(() {
        _generatedVoiceId = realVoiceId;
        _selectedVoiceId = realVoiceId;
        _finalAudioBytes = selectedAudioBytes;
        _finalVoicePreviewUrl = previewUrl;
        _voiceSamples = [];
        _selectedSampleIndex = null;
        _playingSampleIndex = null;
      });

      // 編輯既有角色時，立即同步 Firestore。
      // 新建角色則等玩家按下「儲存角色」時，
      // 由原本 characterData 一起寫入。
      if (widget.character != null) {
        final currentUser =
            FirebaseAuth.instance.currentUser;

        if (!widget.character!.isPublic &&
            currentUser == null) {
          throw Exception(
            l10n.private_voice_user_not_found,
          );
        }

        final DocumentReference characterRef =
        widget.character!.isPublic
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
          'voiceSource': 'voice_bank',
          'lastUpdated':
          FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.voice_bind_success(
            widget.character!.name,
          ),
          customIcon: Icons.cloud_done_rounded,
        );
      } else {
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.voice_bind_success_draft,
          customIcon: Icons.edit_note_rounded,
        );
      }
    } on FirebaseException catch (
    e,
    stackTrace
    ) {
      debugPrint(
        '========== 儲存 Voice Bank 選擇失敗 ==========',
      );
      debugPrint('plugin: ${e.plugin}');
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.voice_selected_character_save_failed,
        isError: true,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '========== 選定 Voice Bank 聲音失敗 ==========',
      );
      debugPrint('error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.voice_binding_failed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _openTestChat() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    final String finalRelationship =
    (_selectedRelationship == 'relationship_other')
        ? _customRelationshipController.text.trim()
        : (_selectedRelationship == 'relationship_none' ? '' : (_selectedRelationship ?? ''));

    final List<String> previewGalleryPaths = _galleryPhotos
        .map((photo) => photo.imageUrl.trim())
        .where((url) => url.isNotEmpty)
        .toList();

    final String previewAvatarPath = previewGalleryPaths.isNotEmpty
        ? previewGalleryPaths.first
        : 'assets/images/blank_avatar.png';

    final String previewId =
        widget.character?.id ?? 'preview_${DateTime.now().millisecondsSinceEpoch}';

    Character previewCharacter;

    if (widget.character != null) {
      previewCharacter = widget.character!.copyWith(
        initialStory: _storyController.text.trim(),
        firstLine: _firstLineController.text.trim(),
        coreCharacterSetting: _coreCharacterSettingController.text.trim(),
        worldSetting: _worldSettingController.text.trim(),
        customOutputFormat: _customOutputFormatController.text.trim(),
      );
    } else {
      previewCharacter = Character(
        id: previewId,
        name: _nameController.text.trim().isEmpty
            ? l10n.charNameLabel
            : _nameController.text.trim(),
        avatarPath: previewAvatarPath,
        bannerImagePath: _bannerImagePath,
        galleryPaths: previewGalleryPaths,
        gallery: _galleryPhotos,
        createdBy: user?.uid ?? 'preview',
        worldSetting: _worldSettingController.text.trim(),
        createdAt: DateTime.now(),
        playCount: 0,
        age: _ageController.text.trim(),
        occupation: _occupationController.text.trim(),
        birthday: _birthdayController.text.trim(),
        height: _heightController.text.trim(),
        personalityTags:
        _deduplicateTagsPreservingOrder(_personalityTags),
        storySummary: _storySummaryController.text.trim(),
        initialStory: _storyController.text.trim(),
        firstLine: _firstLineController.text.trim(),
        background: _backgroundController.text.trim(),
        appearance: _appearanceController.text.trim(),
        gender: _gender,
        isPublic: _isPublic,
        coreCharacterSetting:
        _coreCharacterSettingController.text.trim(),
        detailedPersonality:
        _coreCharacterSettingController.text.trim(),
        customOutputFormat:
        _customOutputFormatController.text.trim(),
        toneAndStyle: '',
        likes: _likesController.text.trim(),
        likesCount: 0,
        dislikes: _dislikesController.text.trim(),
        secrets: _secretsController.text.trim(),
        initialRelationship: finalRelationship,
        dialogueExamples: _dialogueExamplesController.text.trim(),
        easterEggs: _easterEggs,
        extraInfoItems: _extraInfoItems,
        contentLanguage: l10n.localeName,
        stageStranger: _stageStrangerController.text.trim(),
        stageAcquaintance: _stageAcquaintanceController.text.trim(),
        stageIntimate: _stageIntimateController.text.trim(),
        socialInteraction: '',
        playerIdentity: '',
        voiceId: _generatedVoiceId ?? _selectedVoiceId,
        voicePreviewUrl: _finalVoicePreviewUrl,
        voiceStability: _voiceStability,
        voiceStyle: _voiceStyle,
        relationships: _relationships,
        npcCharacters: _npcCharacters,
      );
    }

    if (!mounted) return;

    ToastUtils.showCenterToast(
      context,
      l10n.test_mode_notice,
      customIcon: Icons.chat_bubble_outline_rounded,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          character: previewCharacter,
          characterId: previewId,
          chatMode: 'daily',
          selectedLanguage: l10n.traditional_chinese,
          isTestMode: true,
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(
      ThemeData theme,
      AppLocalizations l10n,
      ) {
    final bool isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.45),
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  l10n.visibility_label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.visibility_private,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: !_isPublic
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    fontWeight:
                    !_isPublic ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _isPublic,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) {
                    setState(() => _isPublic = value);
                  },
                ),
                Text(
                  l10n.visibility_public,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _isPublic
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    fontWeight:
                    _isPublic ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  disabledBackgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isSaving ? null : _saveCharacter,
                child: _isSaving
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark
                        ? theme.colorScheme.onPrimary
                        : Colors.white,
                  ),
                )
                    : Text(
                  isEditing
                      ? l10n.save_changes_button
                      : l10n.createButton,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cleanSectionLabel(String raw) {
    String value = raw.trimLeft();

    const prefixes = <String>[
      '🎭',
      '🌟',
      '🎁',
      '🗣️',
      '🗣',
      '🧬',
      '🎙️',
      '🎙',
      '👥',
      '💡',
      '✨',
    ];

    bool removed;
    do {
      removed = false;
      value = value.trimLeft();

      for (final prefix in prefixes) {
        if (value.startsWith(prefix)) {
          value = value.substring(prefix.length);
          removed = true;
          break;
        }
      }
    } while (removed);

    return value.trim();
  }

  Widget _buildCleanSection({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 19,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
              ] else
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              if (icon == null) const SizedBox(width: 9),
              Expanded(
                child: Text(
                  _cleanSectionLabel(title),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final List<Map<String, String>> genderOptions = [
      {'id': genderIdMale, 'label': l10n.genderMale},
      {'id': genderIdFemale, 'label': l10n.genderFemale},
      {'id': genderIdOther, 'label': l10n.genderOther},
    ];


    final List<String> defaultPersonalityTags = [
      l10n.tagGentle,
      l10n.tagCheerful,
      l10n.tagLively,
      l10n.tagMischievous,
      l10n.tagRichYoungLady,
      l10n.tagRichYoungMaster,
      l10n.tagWealthyFamily,
      l10n.tagScheming,
      l10n.tagPossessive,
      l10n.tagParanoid,
      l10n.tagPersistent,
      l10n.tagUncle,
      l10n.tagAuntie,
      l10n.tagSeniorSister,
      l10n.tagJuniorBrother,
      l10n.tagHandsome,
      l10n.tagStunning,
      l10n.tagContrast,
      l10n.tagFlirty,
      l10n.tagAgeGap,
    ];

    final String? currentValidGender =
    genderOptions.any((g) => g['id'] == _gender) ? _gender : null;


    final String firstTabLabel =
    l10n.localeName.toLowerCase().startsWith('zh')
        ? '角色設定'
        : l10n.tab_basic_story;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: _isLeavingPage,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || _isLeavingPage) return;
          await _handleExitPressed();
        },
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                isEditing
                    ? l10n.edit_character_title(widget.character!.name)
                    : l10n.createCharacterTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: theme.colorScheme.onSurface,
                onPressed: _handleExitPressed,
              ),
              actions: [
                TextButton.icon(
                  onPressed: _openTestChat,
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    l10n.localeName.toLowerCase().startsWith('zh')
                        ? '測試'
                        : l10n.test_mode_tooltip,
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                if (isEditing)
                  PopupMenuButton<String>(
                    tooltip: l10n.delete_character_tooltip,
                    onSelected: (value) {
                      if (value == 'delete' && !_isDeleting) {
                        _deleteCharacter();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.confirm_delete_title,
                              style: const TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
              bottom: TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.46),
                indicatorColor: theme.colorScheme.primary,
                indicatorWeight: 2.4,
                labelStyle: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: firstTabLabel),
                  Tab(text: l10n.tab_voice),
                  Tab(text: l10n.tab_relationship),
                  Tab(text: l10n.characterEditSupportingCharacters),
                ],
              ),
            ),
            body: ColoredBox(
              color: theme.scaffoldBackgroundColor,
              child: TabBarView(
                children: [
                  CharacterEditBasicTab(
                    l10n: l10n,
                    bannerSection: _buildBannerImageSection(),
                    imageGallerySection: _buildImageGallery(),
                    nameController: _nameController,
                    ageController: _ageController,
                    occupationController: _occupationController,
                    birthdayController: _birthdayController,
                    heightController: _heightController,
                    appearanceController: _appearanceController,
                    customRelationshipController: _customRelationshipController,
                    worldSettingController: _worldSettingController,
                    storySummaryController: _storySummaryController,
                    storyController: _storyController,
                    firstLineController: _firstLineController,
                    personalityController: _personalityController,
                    coreCharacterSettingController: _coreCharacterSettingController,
                    customOutputFormatController: _customOutputFormatController,
                    likesController: _likesController,
                    dislikesController: _dislikesController,
                    secretsController: _secretsController,
                    dialogueExamplesController: _dialogueExamplesController,
                    extraInputController: _extraInputController,
                    currentValidGender: currentValidGender,
                    genderOptions: genderOptions,
                    onGenderChanged: (value) {
                      setState(() {
                        _gender = value ?? '';
                      });
                    },
                    relationshipKeys: relationshipKeys,
                    selectedRelationship: _selectedRelationship,
                    onRelationshipChanged: (value) {
                      setState(() {
                        _selectedRelationship = value;
                        if (value != 'relationship_other') {
                          _customRelationshipController.clear();
                        }
                      });
                    },
                    relationshipLabelForKey: (key) {
                      if (key == 'relationship_other') {
                        return l10n.relationship_other;
                      }
                      if (key == 'relationship_none') {
                        return _relationshipNoneLabel(l10n);
                      }
                      return _getTranslatedLabel(key, l10n);
                    },
                    isWorldSettingExpanded: _isWorldSettingExpanded,
                    onToggleWorldSettingExpanded: () {
                      setState(() {
                        _isWorldSettingExpanded = !_isWorldSettingExpanded;
                      });
                    },
                    isCoreCharacterSettingExpanded: _isCoreCharacterSettingExpanded,
                    onToggleCoreCharacterSettingExpanded: () {
                      setState(() {
                        _isCoreCharacterSettingExpanded =
                        !_isCoreCharacterSettingExpanded;
                      });
                    },
                    personalityTags: _personalityTags,
                    defaultPersonalityTags: defaultPersonalityTags,
                    onTogglePersonalityTag: _togglePersonalityTag,
                    onMovePersonalityTag: _movePersonalityTag,
                    onAddCustomPersonalityTag: _addCustomPersonalityTag,
                    easterEggs: _easterEggs,
                    onOpenEasterEggEditor: _openEasterEggEditor,
                    onRemoveEasterEgg: (index) {
                      setState(() {
                        _easterEggs.removeAt(index);
                      });
                    },
                    extraInfoItems: _extraInfoItems,
                    onEditExtraInfoItem: _editExtraInfoItem,
                    onRemoveExtraInfoItem: (index) {
                      setState(() {
                        _extraInfoItems.removeAt(index);
                      });
                    },
                    onAddExtraInfoItem: _addExtraInfoItem,
                  ),
                  CharacterEditVoiceTab(
                    voiceSamples: _voiceSamples,
                    isGeneratingVoice: _isGeneratingVoice,
                    generatedVoiceId: _generatedVoiceId,
                    selectedSampleIndex: _selectedSampleIndex,
                    playingSampleIndex: _playingSampleIndex,
                    loadingSampleIndex: _loadingSampleIndex,
                    isTestingSettings: _isTestingSettings,
                    voiceStability: _voiceStability,
                    voiceStyle: _voiceStyle,
                    onSampleSelected: (index, voiceId) {
                      setState(() {
                        _selectedSampleIndex = index;
                        _selectedVoiceId = voiceId;
                      });
                    },
                    onPreviewVoiceSample: _previewVoiceSample,
                    onRetryVoiceSamples: () {
                      setState(() {
                        _voiceSamples = [];
                        _selectedSampleIndex = null;
                        _playingSampleIndex = null;
                      });
                      _audioPlayer.stop();
                    },
                    onConfirmVoiceSelection: _confirmVoiceSelection,
                    onShowVoiceGenerationDialog: _showVoiceGenerationDialog,
                    onRemakeVoice: () {
                      setState(() {
                        _generatedVoiceId = null;
                        _selectedVoiceId = null;
                        _voiceSamples = [];
                        _selectedSampleIndex = null;
                        _playingSampleIndex = null;
                        _finalAudioBytes = null;
                        _finalVoicePreviewUrl = null;
                      });
                      _showVoiceGenerationDialog();
                    },
                    onVoiceStabilityChanged: (value) {
                      setState(() => _voiceStability = value);
                    },
                    onVoiceStyleChanged: (value) {
                      setState(() => _voiceStyle = value);
                    },
                    onTestVoiceSettings: _testVoiceSettings,
                  ),
                  CharacterEditRelationshipTab(
                    isLoading: _isLoadingMyCharacters,
                    myCharacters: _myCharacters,
                    relationships: _relationships,
                    onAddRelationship: _showAddRelationshipDialog,
                    onEditRelationship: _showEditRelationshipDialog,
                    onDeleteRelationship: (targetId) {
                      setState(() {
                        _relationships.remove(targetId);
                      });
                    },
                  ),
                  CharacterNpcTab(
                    npcCharacters: _npcCharacters,
                    onAddNpc: _showAddNpcDialog,
                    onEditNpc: _showEditNpcDialog,
                    onDeleteNpc: (index) {
                      setState(() {
                        _npcCharacters.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomActionBar(theme, l10n),
          ),
        ),
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

  void _showAddNpcDialog() {
    _showNpcDialog();
  }

  void _showNpcDialog({
    Map<String, dynamic>? npc,
    int? index,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final nameController = TextEditingController(
      text: npc?['name']?.toString() ?? '',
    );
    final ageController = TextEditingController(
      text: npc?['age']?.toString() ?? '',
    );
    final occupationController = TextEditingController(
      text: npc?['occupation']?.toString() ?? '',
    );
    final relationshipController = TextEditingController(
      text: npc?['relationship']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: npc?['description']?.toString() ?? '',
    );
    final toneController = TextEditingController(
      text: npc?['toneAndStyle']?.toString() ?? '',
    );

    String selectedGender = npc?['gender']?.toString() ?? '';
    final bool isEditingNpc = npc != null && index != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return AnimatedPadding(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: bottomInset),
              child: FractionallySizedBox(
                heightFactor: 0.92,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              isEditingNpc
                                  ? l10n.characterEditEditSupportingCharacter
                                  : l10n.characterEditAddSupportingCharacter,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.cancelButton,
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '基本資料',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText:
                                l10n.characterEditSupportingCharacterName,
                              ).copyWith(
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: l10n
                                            .characterEditSupportingCharacterName,
                                      ),
                                      const TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue:
                              selectedGender.isEmpty ? null : selectedGender,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText: l10n.characterEditGender,
                              ).copyWith(
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: l10n.characterEditGender,
                                      ),
                                      const TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Text(l10n.characterEditMale),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Text(l10n.characterEditFemale),
                                ),
                                DropdownMenuItem(
                                  value: 'other',
                                  child: Text(l10n.characterEditOther),
                                ),
                              ],
                              onChanged: (value) {
                                setSheetState(() {
                                  selectedGender = value ?? '';
                                });
                              },
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: ageController,
                              textInputAction: TextInputAction.next,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText: l10n.characterEditAge,
                              ).copyWith(
                                labelText: l10n.characterEditAge,
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: occupationController,
                              textInputAction: TextInputAction.next,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText:
                                l10n.characterEditIdentityOccupation,
                              ).copyWith(
                                labelText:
                                l10n.characterEditIdentityOccupation,
                              ),
                            ),

                            const SizedBox(height: 26),
                            Divider(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.12),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              '與主角色的設定',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '描述這名配角與主角色之間的關係，以及他在故事中的位置。',
                              style: theme.textTheme.bodySmall?.copyWith(
                                height: 1.5,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.52),
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: relationshipController,
                              minLines: 3,
                              maxLines: 6,
                              maxLength: 1500,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText:
                                l10n.characterEditRelationshipHint,
                              ).copyWith(
                                labelText:
                                l10n.characterEditRelationshipWithMain,
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: descriptionController,
                              minLines: 4,
                              maxLines: 7,
                              maxLength: 1500,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText:
                                l10n.characterEditCharacterProfileHint,
                              ).copyWith(
                                label: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                        l10n.characterEditCharacterProfile,
                                      ),
                                      const TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                alignLabelWithHint: true,
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: toneController,
                              minLines: 2,
                              maxLines: 4,
                              decoration: _cleanInputDecoration(
                                theme,
                                hintText:
                                l10n.characterEditSpeakingStyleHint,
                              ).copyWith(
                                labelText:
                                l10n.characterEditSpeakingStyle,
                                alignLabelWithHint: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border(
                            top: BorderSide(
                              color: theme.dividerColor
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    Navigator.of(sheetContext).pop(),
                                style: OutlinedButton.styleFrom(
                                  minimumSize:
                                  const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(l10n.cancelButton),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final name = nameController.text.trim();
                                  final relationship =
                                  relationshipController.text.trim();
                                  final description =
                                  descriptionController.text.trim();

                                  if (name.isEmpty) {
                                    ToastUtils.showCenterToast(
                                      context,
                                      l10n.characterEditSupportingNameRequired,
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (selectedGender.isEmpty) {
                                    ToastUtils.showCenterToast(
                                      context,
                                      l10n
                                          .characterEditSelectSupportingCharacter,
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (description.isEmpty) {
                                    ToastUtils.showCenterToast(
                                      context,
                                      l10n.characterEditProfileRequired,
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (relationship.length > 1500) {
                                    ToastUtils.showCenterToast(
                                      context,
                                      l10n
                                          .characterEditRelationshipTooLong,
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (description.length > 1500) {
                                    ToastUtils.showCenterToast(
                                      context,
                                      l10n.characterEditProfileTooLong,
                                      isError: true,
                                    );
                                    return;
                                  }

                                  final updatedNpc = <String, dynamic>{
                                    'id': npc?['id'] ??
                                        'npc_${DateTime.now().millisecondsSinceEpoch}',
                                    'name': name,
                                    'gender': selectedGender,
                                    'age': ageController.text.trim(),
                                    'occupation':
                                    occupationController.text.trim(),
                                    'relationship': relationship,
                                    'description': description,
                                    'toneAndStyle':
                                    toneController.text.trim(),
                                  };

                                  setState(() {
                                    if (isEditingNpc) {
                                      _npcCharacters[index] = updatedNpc;
                                    } else {
                                      _npcCharacters.add(updatedNpc);
                                    }
                                  });

                                  Navigator.of(sheetContext).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                  const Size(double.infinity, 48),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  isEditingNpc
                                      ? l10n.characterEditSave
                                      : l10n.characterEditAdd,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditNpcDialog(int index) {
    if (index < 0 ||
        index >= _npcCharacters.length) {
      return;
    }

    _showNpcDialog(
      npc: _npcCharacters[index],
      index: index,
    );
  }

  void _showAddRelationshipDialog() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final availableChars = _myCharacters
        .where((c) => c.id != widget.character?.id)
        .toList();

    String? selectedCharId;
    final thoughtsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  18 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.social_add_title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.social_circle_desc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          height: 1.45,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedCharId,
                        decoration: _cleanInputDecoration(
                          theme,
                          hintText: l10n.social_select_target,
                        ),
                        selectedItemBuilder: (context) {
                          return availableChars.map((c) {
                            final occupation = c.occupation.trim();
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                occupation.isEmpty
                                    ? c.name
                                    : '${c.name} · $occupation',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList();
                        },
                        items: availableChars.map((c) {
                          final occupation = c.occupation.trim();
                          final avatarUrl = c.avatarPath.trim();
                          return DropdownMenuItem<String>(
                            value: c.id,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: theme.colorScheme.primary
                                      .withValues(alpha: 0.08),
                                  backgroundImage: avatarUrl.startsWith('http')
                                      ? NetworkImage(avatarUrl)
                                      : null,
                                  child: !avatarUrl.startsWith('http')
                                      ? Icon(
                                    Icons.person_outline_rounded,
                                    size: 17,
                                    color: theme.colorScheme.primary,
                                  )
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (occupation.isNotEmpty)
                                        Text(
                                          occupation,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setSheetState(() => selectedCharId = v);
                        },
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: thoughtsController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: _cleanInputDecoration(
                          theme,
                          hintText: l10n.social_thoughts_hint,
                        ).copyWith(
                          labelText: l10n.social_thoughts_label,
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(sheetContext),
                              child: Text(l10n.cancelButton),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedCharId == null ||
                                  thoughtsController.text.trim().isEmpty
                                  ? null
                                  : () {
                                setState(() {
                                  _relationships[selectedCharId!] =
                                      thoughtsController.text.trim();
                                });
                                Navigator.pop(sheetContext);
                              },
                              child: Text(l10n.social_add_confirm),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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

  Widget _buildBannerImageSection() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bool hasLocalBanner = _bannerLocalFile != null;
    final bool hasNetworkBanner =
        _bannerImagePath.trim().isNotEmpty && !_isRemovingBanner;

    ImageProvider? bannerProvider;

    if (hasLocalBanner) {
      bannerProvider = _getImageProvider(_bannerLocalFile);
    } else if (hasNetworkBanner) {
      bannerProvider = _getImageProvider(_bannerImagePath);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.characterBannerTitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.characterBannerDescription,
              onPressed: _showBannerInfoDialog,
              icon: const Icon(Icons.info_outline_rounded, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: theme.colorScheme.surface,
              child: InkWell(
                onTap: bannerProvider == null
                    ? _pickBannerImage
                    : () => _showImagePreview(
                  bannerProvider!,
                  title: l10n.characterBannerTitle,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.55),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: bannerProvider == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.panorama_outlined,
                        size: 42,
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.65),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.characterBannerSelect,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.characterBannerSpecs,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  )
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: bannerProvider,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            _imageActionButton(
                              theme,
                              icon: Icons.edit_outlined,
                              onTap: _pickBannerImage,
                            ),
                            const SizedBox(width: 6),
                            _imageActionButton(
                              theme,
                              icon: Icons.delete_outline_rounded,
                              onTap: _removeBannerImage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          bannerProvider == null
              ? l10n.characterBannerDefaultHint
              : l10n.localeName.toLowerCase().startsWith('zh')
              ? '點擊圖片可預覽大圖'
              : l10n.characterBannerDefaultHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _imageActionButton(
      ThemeData theme, {
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  void _showImagePreview(
      ImageProvider imageProvider, {
        String? title,
      }) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: Center(
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (title != null && title.trim().isNotEmpty)
                  Positioned(
                    top: 14,
                    left: 56,
                    right: 56,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBannerInfoDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.characterBannerTitle),
          content:  Text(
            l10n.characterBannerHelpContent,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.ok_button),
            ),
          ],
        );
      },
    );
  }

  // --- 全新相簿 UI (抓蟲升級版：Web CORS 防護版) ---
  Widget _buildImageGallery() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    int mainPhotoIndex = -1;
    CharacterPhoto? mainPhoto;

    if (_galleryPhotos.isNotEmpty) {
      mainPhotoIndex = _galleryPhotos.indexWhere(
            (photo) => photo.requiredAffection == 0,
      );
      if (mainPhotoIndex < 0) {
        mainPhotoIndex = 0;
      }
      mainPhoto = _galleryPhotos[mainPhotoIndex];
    }

    ImageProvider? mainProvider;
    if (mainPhoto != null) {
      mainProvider = _getImageProvider(
        mainPhoto.localFile ??
            (mainPhoto.imageUrl.isNotEmpty ? mainPhoto.imageUrl : null),
      );
    }

    final otherPhotoIndexes = <int>[
      for (int i = 0; i < _galleryPhotos.length; i++)
        if (i != mainPhotoIndex) i,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.charAlbumTitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.localeName.toLowerCase().startsWith('zh')
              ? '第一張圖片將作為主要頭像'
              : l10n.characterEditCharacterImage,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
          ),
        ),
        const SizedBox(height: 10),

        if (mainProvider == null)
          InkWell(
            onTap: _addCharacterImage,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 42,
                    color: theme.colorScheme.primary.withValues(alpha: 0.65),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.characterEditCharacterImage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 230,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: theme.colorScheme.surface,
                    child: InkWell(
                      onTap: () => _showImagePreview(
                        mainProvider!,
                        title: l10n.avatar_label,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image(
                            image: mainProvider,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Row(
                              children: [
                                _imageActionButton(
                                  theme,
                                  icon: Icons.edit_outlined,
                                  onTap: () => _showEditPhotoDialog(
                                    mainPhotoIndex,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _imageActionButton(
                                  theme,
                                  icon: Icons.delete_outline_rounded,
                                  onTap: () {
                                    setState(() {
                                      _galleryPhotos.removeAt(mainPhotoIndex);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 18),
        Text(
          l10n.localeName.toLowerCase().startsWith('zh')
              ? '其他角色照片'
              : l10n.charAlbumTitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 9),

        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: otherPhotoIndexes.length + 1,
            separatorBuilder: (context, index) =>
            const SizedBox(width: 9),
            itemBuilder: (context, index) {
              if (index == otherPhotoIndexes.length) {
                return _buildAddImageButton();
              }

              final photoIndex = otherPhotoIndexes[index];
              final photo = _galleryPhotos[photoIndex];
              final provider = _getImageProvider(
                photo.localFile ??
                    (photo.imageUrl.isNotEmpty ? photo.imageUrl : null),
              );

              return SizedBox(
                width: 78,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Material(
                          color: theme.colorScheme.surface,
                          child: InkWell(
                            onTap: () => _showImagePreview(
                              provider,
                              title: 'LV.${photo.requiredAffection}',
                            ),
                            child: Image(
                              image: provider,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Material(
                        color: theme.colorScheme.surface.withValues(
                          alpha: 0.92,
                        ),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => _showEditPhotoDialog(photoIndex),
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.localeName.toLowerCase().startsWith('zh')
              ? '點擊照片可預覽；鉛筆可編輯照片設定'
              : l10n.charAlbumTitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    final theme = Theme.of(context);
    return InkWell(
      onTap: _addCharacterImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 78,
        height: 96,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          color: theme.colorScheme.primary,
          size: 28,
        ),
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                  image.path,
                  height: 120,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(image.path),
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: l10n.gallery_photo_desc_label,
                  hintText: l10n.gallery_photo_desc_hint,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: affController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.gallery_photo_req_label,
                  hintText: l10n.gallery_photo_req_hint,
                ),
              ),
            ],
          ),
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

  Future<void> _pickBannerImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (image == null || !mounted) return;

    setState(() {
      _bannerLocalFile = image;
      _isRemovingBanner = false;
    });
  }

  void _removeBannerImage() {
    setState(() {
      _bannerLocalFile = null;
      _bannerImagePath = '';
      _isRemovingBanner = true;
    });
  }

  Widget _buildPublicPrivateToggle(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(
          l10n.visibility_label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(l10n.visibility_private),
        Switch(
          value: _isPublic,
          activeColor: theme.colorScheme.primary,
          onChanged: (value) => setState(() => _isPublic = value),
        ),
        Text(l10n.visibility_public),
      ],
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

  Color _getSectionCardColor(ThemeData theme) {
    final bool isDark =
        theme.brightness == Brightness.dark;

    // 將少量主題色混入 Card 的 surface，
    // 比頁面背景稍微重一點，但不會太濃。
    final mixedColor = Color.alphaBlend(
      theme.colorScheme.primary.withValues(
        alpha: isDark ? 0.16 : 0.10,
      ),
      theme.colorScheme.surface,
    );

    // 保留一點透明度，讓底下的漸層主題隱約透出。
    return mixedColor.withValues(
      alpha: isDark ? 0.94 : 0.88,
    );
  }

  Color _getSectionBorderColor(ThemeData theme) {
    final primaryHsl = HSLColor.fromColor(
      theme.colorScheme.primary,
    );

    // 淺色主題稍微加深；黑色主題稍微提亮，
    // 避免邊框融入背景看不見。
    final double adjustedLightness =
    theme.brightness == Brightness.dark
        ? (primaryHsl.lightness + 0.08).clamp(0.0, 1.0)
        : (primaryHsl.lightness - 0.10).clamp(0.0, 1.0);

    return primaryHsl
        .withLightness(adjustedLightness)
        .toColor()
        .withValues(
      alpha: theme.brightness == Brightness.dark
          ? 0.78
          : 0.58,
    );
  }

  ShapeBorder _buildSectionCardShape(ThemeData theme) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: _getSectionBorderColor(theme),
        width: 1.1,
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        _cleanSectionLabel(title),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildRequiredLabel(String label, ThemeData theme) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldHeading(
      String label,
      ThemeData theme, {
        String? description,
        bool isRequired = false,
        double labelFontSize = 15,
      }) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),

              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          if (description != null &&
              description.trim().isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                height: 1.45,
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.52,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _cleanInputDecoration(
      ThemeData theme, {
        String? hintText,
        Widget? suffixIcon,
      }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.34),
        fontSize: 14,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.55),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.55),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        bool isRequired = false,
        String? description,
        String? hintText,
        int? maxLength,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldHeading(
            label,
            theme,
            description: description,
            isRequired: isRequired,
          ),

          TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.35,
                ),
                fontSize: 14,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxedTextField(
      TextEditingController controller,
      String label, {
        required int maxLength,
        String? hintText,
        String? description,
        bool isRequired = false,
        double inputFontSize = 16,

        // 超過指定字數時，是否支援展開／收合
        bool isCollapsible = false,
        bool isExpanded = false,
        VoidCallback? onToggleExpanded,
      }) {
    final theme = Theme.of(context);

    final int currentLength = controller.text.characters.length;
    final int overflow = currentLength - maxLength;
    const int collapseThreshold = 400;

    final bool showExpandButton =
        isCollapsible &&
            currentLength > collapseThreshold;

    final int? effectiveMaxLines =
    showExpandButton && !isExpanded
        ? 7
        : null;

    final NumberFormat numberFormatter = NumberFormat.decimalPattern();

    final String formattedCurrentLength =
    numberFormatter.format(currentLength);

    final String formattedMaxLength =
    numberFormatter.format(maxLength);

    Color counterColor =
    theme.colorScheme.onSurface.withValues(alpha: 0.6);

    if (overflow > 0) {
      counterColor = Colors.red;
    } else if (currentLength >= maxLength - 100) {
      counterColor = Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldHeading(
          label,
          theme,
          description: description,
          isRequired: isRequired,
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: inputFontSize,
              color: theme.textTheme.bodyMedium?.color,
            ),
            keyboardType: TextInputType.multiline,

            // 這兩個長欄位至少保留適當的輸入高度
            minLines: isCollapsible ? 5 : null,
            maxLines: effectiveMaxLines,

            // 保留字數統計，但不要截斷貼上的內容
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.none,

            onChanged: (_) {
              setState(() {});
            },

            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.4,
                ),
                fontSize: 13,
              ),
              labelStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.7,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: overflow > 0
                      ? Colors.red
                      : theme.colorScheme.primary,
                  width: 2,
                ),
              ),

              // 顯示成 2,356 / 2,500
              counterText:
              '$formattedCurrentLength / $formattedMaxLength',

              counterStyle: TextStyle(
                color: counterColor,
                fontWeight: overflow > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
          ),
        ),

        if (showExpandButton)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onToggleExpanded,
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 20,
              ),
              label: Text(
                isExpanded
                    ? AppLocalizations.of(context)!.characterProfileCollapse
                    : AppLocalizations.of(context)!.characterProfileViewMore,
              ),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),

        if (overflow > 0)
          Padding(
            padding: const EdgeInsets.only(
              left: 4,
              top: 2,
              bottom: 6,
            ),
            child: Text(
              '⚠ $label 已超出 ${numberFormatter.format(overflow)} 字，請修正後再發布。',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  void _reorderPersonalityTag(
      int oldIndex,
      int newIndex,
      ) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final tag = _personalityTags.removeAt(oldIndex);
      _personalityTags.insert(newIndex, tag);
    });
  }

  List<String> _deduplicateTagsPreservingOrder(
      Iterable<dynamic> tags,
      ) {
    final seen = <String>{};
    final result = <String>[];

    for (final rawTag in tags) {
      final tag = rawTag.toString().trim();

      if (tag.isEmpty) {
        continue;
      }

      if (seen.add(tag)) {
        result.add(tag);
      }
    }

    return result;
  }

  void _movePersonalityTag(
      String draggedTag,
      String targetTag,
      ) {
    if (draggedTag == targetTag) {
      return;
    }

    setState(() {
      final oldIndex =
      _personalityTags.indexOf(draggedTag);
      final targetIndex =
      _personalityTags.indexOf(targetTag);

      if (oldIndex == -1 || targetIndex == -1) {
        return;
      }

      _personalityTags.removeAt(oldIndex);

      final insertIndex = targetIndex.clamp(
        0,
        _personalityTags.length,
      );

      _personalityTags.insert(
        insertIndex,
        draggedTag,
      );
    });
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
    final String tag = _personalityController.text.trim();

    if (tag.isNotEmpty) {
      setState(() {
        // 如果標籤還不存在清單中，才加進去
        if (!_personalityTags.contains(tag)) {
          _personalityTags.add(tag);
        }


        _personalityController.clear();
      });
    }
  }

  Widget _buildDraggableSelectedTag(
      String tag,
      ThemeData theme,
      ) {
    return DragTarget<String>(
      onWillAccept: (draggedTag) {
        return draggedTag != null &&
            draggedTag != tag;
      },
      onAccept: (draggedTag) {
        _movePersonalityTag(
          draggedTag,
          tag,
        );
      },
      builder: (
          context,
          candidateData,
          rejectedData,
          ) {
        final bool isReceiving =
            candidateData.isNotEmpty;

        final tagButton = AnimatedContainer(
          duration: const Duration(
            milliseconds: 160,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: isReceiving
                ? [
              BoxShadow(
                color: theme.colorScheme.primary
                    .withValues(alpha: 0.28),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : const [],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              _togglePersonalityTag(tag);
            },
            icon: Icon(
              Icons.drag_indicator_rounded,
              size: 17,
              color: theme.colorScheme.onPrimary
                  .withValues(alpha: 0.82),
            ),
            label: Text(tag),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              theme.colorScheme.primary,
              foregroundColor:
              theme.colorScheme.onPrimary,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isReceiving
                      ? theme.colorScheme.onPrimary
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              elevation: isReceiving ? 4 : 2,
            ),
          ),
        );

        return LongPressDraggable<String>(
          data: tag,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.92,
              child: tagButton,
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: tagButton,
          ),
          child: tagButton,
        );
      },
    );
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
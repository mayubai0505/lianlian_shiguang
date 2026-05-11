import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert'; // ✨✨✨ 加上這行！專門處理 JSON 和 utf8 的內建工具箱
import 'dart:ui' show ImageFilter;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'call_screen.dart';
import 'user_profile_popup.dart';
import 'package:lianlian_shiguang/main.dart';
import '../services/theme_notifier.dart';
import 'package:audioplayers/audioplayers.dart'; // 🌟 讓這個頁面認識 UrlSource 和 AudioPlayer
import '../utils/image_utils.dart';
import 'about_me_page.dart';
import 'character_model.dart';
import 'memo_page.dart';
import 'period_tracker_page.dart';
import 'story_summary_page.dart';
import 'package:intl/intl.dart';
import 'store_page.dart';
import 'backpack_page.dart';
import 'background_settings_page.dart';
import '../widgets/dice_duel_overlay.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'character_profile_page.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

//聊天頁面ˋ
enum ChatMode { daily, story, immersive , gemini}
class FlowerStage {
  final int threshold;
  final String imagePath;
  const FlowerStage({required this.threshold, required this.imagePath});
}
class ChatMessage {
  final String id;        // 資料庫的 ID
  final String sender;    // 'user' 或 'ai'
  String text;            // 👈 拿掉 final，這樣 AI 說話時才能「一段一段加進去」
  final String type;      // 'text', 'image', 'audio'
  final String path;      // 圖片或音檔的路徑
  final Timestamp timestamp;
  final bool isAI;        // 方便 UI 判斷要靠左還是靠右


  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.type = 'text',    // 預設為純文字
    this.path = '',
    required this.timestamp,
    required this.isAI,
  });

  // ✨ 從 Firestore 轉回模型的方法 (如果您之後要讀取歷史紀錄會用到)
  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      sender: data['sender'] ?? '',
      text: data['text'] ?? '',
      type: data['type'] ?? 'text',
      path: data['path'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      isAI: data['sender'] == 'ai', // 如果發送者是 ai，那 isAI 就是 true
    );
  }
}

class ChatPage extends StatefulWidget {
  final Character character;
  final String? charIdFromPush; // 👈 身分證字號
  final String? chatMode;
  final String? sessionId;
  final String selectedLanguage;
  final bool isTestMode;
  final bool shouldSave;
  final String? initialText;

  const ChatPage({
    super.key,
    this.charIdFromPush,
    required this.character,
    this.chatMode,
    this.sessionId,
    this.isTestMode = false,
    required this.selectedLanguage,
    required this.shouldSave,
    this.initialText,
  })
      : assert(chatMode != null || sessionId != null, 'Either chatMode or sessionId must be provided');

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ✨ 截圖模式專用變數
  bool _isScreenshotMode = false;      // 是否正在截圖模式中？
  Set<String> _selectedMessageIds = {}; // 裝著被玩家「打勾勾」的對話 ID
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _hasShownAffectionCard = false;
  bool _isInit = false;
  bool _hasTriggeredCheck = false;
  final FocusNode _focusNode = FocusNode(); // ✨ 控制鍵盤的遙控器
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _appearanceController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  bool _isCalling = false;
  List<ChatMessage> _testMessages = [];
  Set<String> _triggeredEggKeywords = {};
  late AudioPlayer _audioPlayer;
  DocumentReference? _sessionDocRef;
  CollectionReference? _messagesCollection;
  late Character _currentCharacter;
  // --- 狀態變數 ---
  bool _isGenerating = false;           // 正在生成中
  // ✨ 補上我們的遊戲 App ID
  // 🌟 總裁指令：拒絕預設值！統一從 AppConfig 抓取 ID
  final String _appId = AppConfig.appId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final ScrollController _menuScrollController = ScrollController();
  // 🚀 請確保您是這樣宣告的：
  ChatMode? _currentMode;
  int _currentFriendship = 0;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isChecking = false;
  StreamSubscription? _pointsSubscription; // 用來管理點數的監聽器
  int _flowerPoints = 0;
  // ✨ 煞車系統專用變數，必須放在類別最上方
  http.Client? _httpClient;
  static const List<FlowerStage> _flowerStages = [
    FlowerStage(threshold: 0, imagePath: 'assets/images/flower_stage_1.png'),
    FlowerStage(threshold: 60, imagePath: 'assets/images/flower_stage_2.png'),
    FlowerStage(threshold: 150, imagePath: 'assets/images/flower_stage_3.png'),
    FlowerStage(threshold: 550, imagePath: 'assets/images/flower_stage_4.png'),
    FlowerStage(threshold: 1720, imagePath: 'assets/images/flower_stage_5.png'),
    FlowerStage(threshold: 2430, imagePath: 'assets/images/flower_stage_6.png'),
    FlowerStage(threshold: 5000, imagePath: 'assets/images/flower_stage_6.png'),
  ];

  String? _sessionId;
  bool _isLoading = true;
  String? _currentStoryTime;  //時間
  String? _currentStoryLocation;  //地點
  String? _highlightedMessageId; // 🌟 用來記住現在要「發光」的是誰
  String _userProfileText = ""; // 存放玩家的專屬名片文字
  String _playerNickname = "玩家"; // ✨ 新增：專門用來記住玩家的暱稱，方便替換字串！
  List<ChatMessage> _localMessages = [];
  String? _userId;
  // 🌟 在 _ChatPageState 裡面補上這個工具
  String _formatPoints(int points) {
    final safePoints = points < 0 ? 0 : points;
    // 如果妳沒裝 intl 套件，就先用最簡單的 toString()
    // 如果有裝，可以用 NumberFormat('#,##0').format(safePoints)
    return safePoints.toString();
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTimeEntry();
    _currentCharacter = widget.character;
    // 在頁面渲染後立刻去尋找這個角色的專屬照片
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ThemeNotifier>(context, listen: false)
            .loadCharacterBackground(_currentCharacter.name);
      }
    });
    // 1. 準備硬體設備 (維持原樣)
    _audioPlayer = AudioPlayer();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _userId = FirebaseAuth.instance.currentUser?.uid;

    // 🌟🌟🌟 總裁無敵星星：測試模式攔截器 🌟🌟🌟
    // 這裡我們直接幫妳把所有「開關」都打開，不讓它有機會去轉圈圈！
    if (widget.isTestMode || !widget.shouldSave) {
      print("🧪 測試模式啟動：正在手動配置 UI...");

      _sessionId = widget.sessionId;     // 🔑 報到成功，給予假 ID
      _currentCharacter = widget.character; // 👤 角色資料載入

      // 🔥 關鍵修復：手動給它一個模式，左上角的按鈕才會出現！
      _currentMode = ChatMode.daily;

      _isLoading = false;                // 🏁 停止轉圈圈

      // 💡 測試模式到此為止，後面那些去資料庫撈資料的程式碼「全部跳過」！
      return;
    }
    // --- 下面是正常模式的邏輯，只有不是測試模式才會跑到這裡 ---
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _executeMessageSending(userText: widget.initialText!);
      });
    }
    _loadDraft();
    _initHardware();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 3. 檢查是不是第一次進來
    if (!_isInit) {
      // 現在可以安全地拿翻譯字典了
      final l10n = AppLocalizations.of(context)!;

      // 把妳的判斷式放進來
      if (widget.character.name == l10n.chat_loading_status) {
        _loadCharacterDataById(widget.character.id);
      } else {
        _currentCharacter = widget.character;
        _finishInitialization();
      }
      _loadExistingProfile();
      _loadUnlockedEggs();
      // 4. 事情做完後，把旗標鎖上 (設為 true)！
      // 這樣下次鍵盤彈出或畫面變化時，就不會再重複撈資料了。
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _chatScrollController.dispose();
    _menuScrollController.dispose();
    _recorder?.closeRecorder();
    _player?.closePlayer();
    _recorder = null;
    _player = null;
    _textController.dispose();
    _focusNode.dispose();
    _pointsSubscription?.cancel();
    _audioPlayer.dispose();
    _httpClient?.close(); // 確保離開頁面時關閉網路連線
    super.dispose();
  }

  // 👇 把這整段貼在 initState 的下方
  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    // 使用 sessionId 當作專屬鑰匙，這樣每個聊天室的草稿都是獨立的！
    final draftKey = 'chat_draft_${widget.sessionId}';
    final savedDraft = prefs.getString(draftKey);

    if (savedDraft != null && savedDraft.isNotEmpty) {
      // 把存好的草稿塞回妳的輸入框控制器
      _textController.text = savedDraft;
    }
  }

  // 讀取 Firebase 舊資料並填入輸入框
  Future<void> _loadExistingProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      // 如果以前有填寫過 profile，就把資料拿出來塞進輸入框
      if (data != null && data.containsKey('profile')) {
        final profile = data['profile'];
        setState(() {
          _heightController.text = profile['height'] ?? '';
          _appearanceController.text = profile['appearance'] ?? '';
          _occupationController.text = profile['occupation'] ?? '';
          _introController.text = profile['intro'] ?? '';
        });
      }
    } catch (e) {
      print("讀取舊名片失敗: $e");
    }
    }

  // ✨ 專屬的儲存/清除草稿功能
  Future<void> _saveDraft(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final draftKey = 'chat_draft_${widget.sessionId}';

    if (text.trim().isEmpty) {
      // 如果輸入框空了，就把草稿刪掉，節省空間
      await prefs.remove(draftKey);
    } else {
      // 把最新的文字存起來
      await prefs.setString(draftKey, text);
    }
  }

  // 🌟 3. 實作：根據 ID 撈取真實角色資料 (通用版，不分角色)
  Future<void> _loadCharacterDataById(String charId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final doc = await FirebaseFirestore.instance.collection('characters').doc(charId).get();
      // 💡 防護網：如果找不到資料，直接拋出錯誤，交給下方的 catch 統一處理
      if (!doc.exists) throw '找不到角色資料 ($charId)';
      final char = await Character.fromFirestoreAsync(doc);
      if (mounted) {
        setState(() => _currentCharacter = char);
        _finishInitialization();
      }
    } catch (e) {
      print("❌ 讀取角色失敗: $e");
      if (mounted) {
        setState(() => _isLoading = false); // 確保一定會關閉讀取圈圈
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.chat_load_char_failed),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // 🌟 4. 集中處理剩餘的初始化動作
  void _finishInitialization() {
    _initializeChat();
    _listenToFlowerPoints();

    // 載入背景圖（這裡現在會使用正確的角色名字）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ThemeNotifier>(context, listen: false)
            .loadCharacterBackground(_currentCharacter.name);
      }
    });
  }

  // 🌟 大合體版本：精準跳轉 ＋ 視覺回饋 ＋ 發光特效
  void _jumpToMessage(String messageId) {
    final l10n = AppLocalizations.of(context)!;
    // 1. 在目前的清單中找出這則訊息的 index
    final index = _localMessages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      // 🕵️‍♀️ 2. 視覺特效開關：標記這則訊息，讓它開始「發光」！
      setState(() {
        _highlightedMessageId = messageId;
      });
      // 3. 計算大概的滾動位置 (ListView 為 reverse: true，估計一個氣泡高 100)
      double targetOffset = index * 100.0;
      // 4. 帥氣地滾動過去！
      _chatScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );
      // ✨ 5. 給玩家視覺回饋：在畫面上方跳出 SnackBar (比原本的灰色質感更升級！)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha:0.9), // 跟隨主題色
          behavior: SnackBarBehavior.floating, // ✨ 漂浮在上面，更有質感
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.65, // 跳轉後 SnackBar 顯示在畫面偏上方
            left: 60,
            right: 60,
          ),
          content:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(l10n.chat_jump_success, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );

      // 🕵️‍♀️ 6. 時效設定：2 秒後自動「關燈」，把光芒消失，恢復正常
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _highlightedMessageId = null; // ✅ 關閉標記
          });
        }
      });
    }
  }

  // 🌟 修正後的 _initHardware 函數
  Future<void> _initHardware() async {
    try {
      // 加上 ?. 代表「如果它不是 null 才執行」
      await _recorder?.openRecorder();
      await _player?.openPlayer();
      print("🎤 角色語音設備已就緒");
    } catch (e) {
      print("❌ 設備初始化失敗: $e");
    }
  }

  Future<void> _initializeChat() async {
    // 🌟 總裁補位：如果是測試模式，直接給它模式，不要去資料庫抓資料！
    if (widget.isTestMode) {
      final String modeName = widget.chatMode ?? 'daily';
      setState(() {
        _currentMode = ChatMode.values.firstWhere(
                (e) => e.name == modeName,
            orElse: () => ChatMode.daily
        );
        _isLoading = false; // 測試模式直接開門，不轉圈圈！
      });
      return; // 🚀 測試模式到此結束，不准往下走去敲資料庫的門
    }

    // --- 以下是正式模式的原有邏輯 ---
    if (widget.sessionId != null) {
      await _loadExistingChat(widget.sessionId!);
    } else if (widget.chatMode != null) {
      final modeName = widget.chatMode ?? 'daily';
      _currentMode = ChatMode.values.firstWhere((e) => e.name == modeName, orElse: () => ChatMode.daily);
      await _createNewChat(widget.chatMode!);
    }
  }

  Future<void> _loadExistingChat(String sessionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final sessionDocRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('chat_sessions')
          .doc(sessionId);

      final doc = await sessionDocRef.get();

      // ✨ 如果房間存在，正常讀取
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        int initialFriendship = data['friendshipScore'] ?? 0;
        final modeName = data['chatMode'] ?? 'daily';
        _currentMode = ChatMode.values.firstWhere((e) => e.name == modeName, orElse: () => ChatMode.daily);

        _sessionDocRef = sessionDocRef;
        _messagesCollection = sessionDocRef.collection('messages'); // 這裡確保賦值

        await sessionDocRef.update({'unreadCount': 0});

        if (mounted) {
          setState(() {
            _sessionId = sessionId;
            _currentFriendship = initialFriendship;
            _currentStoryTime = data['lastStoryTime'];
            _currentStoryLocation = data['lastStoryLocation'];
            _isLoading = false;
          });
        }
      }
      // ✨ 只有一個 else！如果房間不存在，自動原地建房
      else {
        print("✨ 發現新房間或幽靈房間，啟動自動建房程序！");

        // 1. 在資料庫裡建立這間新房的基礎資料
        await sessionDocRef.set({
          'userId': user.uid,
          'characterId': _currentCharacter.id,
          'chatMode': 'daily',
          'friendshipScore': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActivity': FieldValue.serverTimestamp(),
        });

        // 2. 乖乖把管線接好，絕對不讓 _messagesCollection 變成 Null！
        _sessionDocRef = sessionDocRef;
        _messagesCollection = sessionDocRef.collection('messages');

        if (mounted) {
          setState(() {
            _sessionId = sessionId; // 保持原本帶進來的 ID
            _currentFriendship = 0;
            _isLoading = false; // 讓畫面停止轉圈圈，順利進入聊天室
          });
        }
      }
    } catch (e) {
      print("讀取舊聊天室失敗: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createNewChat(String chatMode) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final db = FirebaseFirestore.instance;
      // 1. 取得新房間的 Reference
      final newSessionRef = db
          .collection('artifacts')
          .doc(_appId)
          .collection('chat_sessions')
          .doc();

      // ✨ 2. 開啟批次作業 (Batch)，確保所有動作同進同退
      final batch = db.batch();

      // 準備房間資料
      final newSessionData = {
        'userId': user.uid,
        'characterId': _currentCharacter.id,
        'characterName': _currentCharacter.name,
        'characterAvatarPath': _currentCharacter.avatarPath,
        'friendshipScore': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': l10n.chat_new_room_created,
        'lastActivity': FieldValue.serverTimestamp(),
        'chatMode': chatMode,
        'unreadCount': 0,
      };

      // 將建立房間的動作加入 batch
      batch.set(newSessionRef, newSessionData);

      // 3. 處理系統訊息與開場白 (如果不是閒聊模式)
      if (chatMode != 'gemini') {
        String rawFirstLine = _currentCharacter.firstLine ?? '';
        if (rawFirstLine.isEmpty) rawFirstLine = l10n.chat_first_line_fallback;
        String firstLine = rawFirstLine.replaceAll('{{玩家名字}}', _playerNickname);

        String rawInitialStory = _currentCharacter.initialStory ?? '';
        String initialStoryText = rawInitialStory.replaceAll('{{玩家名字}}', _playerNickname);

        // 如果有系統前情提要，加入 batch
        if (initialStoryText.isNotEmpty) {
          final systemMsgRef = newSessionRef.collection('messages').doc();
          batch.set(systemMsgRef, {
            'sender': 'system',
            'text': initialStoryText,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'text',
            'path': '',
          });
        }
        // 將角色的第一句話加入 batch
        final aiMsgRef = newSessionRef.collection('messages').doc();
        batch.set(aiMsgRef, {
          'sender': 'ai',
          'text': firstLine,
          'type': 'text',
          'path': '',
          'timestamp': FieldValue.serverTimestamp(), // 讓雲端自動排序時間
        });
      }
      // ✨✨✨ 4. 關鍵煞車：等待全部寫入成功！ ✨✨✨
      await batch.commit();
      // 5. 確保資料庫真的寫入成功後，才切換畫面狀態
      if (mounted) {
        setState(() {
          _sessionId = newSessionRef.id;
          _sessionDocRef = newSessionRef;
          _messagesCollection = newSessionRef.collection('messages');
          _currentFriendship = 0;
          _isLoading = false;
        });
      }

    } catch (e) {
      print("❌ 建立新聊天室失敗: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        // ✨ 加上 SnackBar 提示，避免玩家看著白畫面發呆
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.chat_create_room_failed),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // ✨ 總裁專屬：聊天室跳轉角色檔案 (已對齊 widget.character 結構)
  Future<void> _navigateToProfileFromChat(String charId, String charName, String avatarUrl) async {
    // 顯示讀取圈圈
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 去公開區檢查這尊角色還在不在
      final doc = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(charId)
          .get();

      if (mounted) Navigator.pop(context); // 關閉讀取圈圈

      if (doc.exists) {
        // ✅ 狀況 A：角色還在公開海域，大方跳轉！
        final characterData = await Character.fromFirestoreAsync(doc);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterProfilePage(
                character: characterData,
                characterId: charId,
                sessionId: _sessionId,
              ),
            ),
          );
        }
      } else {
        // 🔒 狀況 B：角色已經變私人或刪除了，彈出神祕機密卡！
        _showEncryptedProfileDialog(charName, avatarUrl);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("❌ 跳轉失敗: $e");
    }
  }

  // 🔒 這是那個神祕的「檔案已封存」彈窗
  void _showEncryptedProfileDialog(String name, String avatar) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.chat_secret_file_title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              backgroundImage: getAvatarImageProvider(avatar),
              child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black38)),
            ),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Text(l10n.chat_secret_file_desc, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child:Text(l10n.chat_understood)),
        ],
      ),
    );
  }

  Future<bool> _isThisMyBestFriend(String currentSessionId) async {final l10n = AppLocalizations.of(context)!;

  final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    // 1. 抓取所有聊天室，按好感度從高到低排
    final snapshot = await FirebaseFirestore.instance
        .collection('artifacts')
        .doc(_appId)
        .collection('chat_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('friendshipScore', descending: true)
        .limit(1) // 我只要最高分的那一個
        .get();

    if (snapshot.docs.isEmpty) return false;

    // 2. 如果最高分的那間 ID，跟現在這間一樣，那就是你啦！
    return snapshot.docs.first.id == currentSessionId;
  }

  Future<String?> _uploadFileToStorage(String filePath, String fileType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _sessionId == null) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // 1. 抓取副檔名 (如果是網頁的 blob 網址可能沒副檔名，我們給它預設值)
      String fileExtension = fileType == 'audio' ? 'm4a' : 'png';
      if (!kIsWeb && filePath.contains('.')) {
        fileExtension = filePath.split('.').last;
      }

      // 2. 先把「倉庫位置 (ref)」蓋好！
      final storagePath = 'user_uploads/${user.uid}/$_sessionId/$fileType-$timestamp.$fileExtension';
      final ref = FirebaseStorage.instance.ref(storagePath);

      // 3. 判斷平台，把貨物放進倉庫
      if (kIsWeb) {
        // 🌐 Web 專用：把檔案讀成二進位資料再上傳
        final bytes = await XFile(filePath).readAsBytes();

        // 告訴 Firebase 這是什麼檔案，網頁播放才不會卡住
        final metadata = SettableMetadata(
            contentType: fileType == 'audio' ? 'audio/m4a' : 'image/png'
        );
        await ref.putData(bytes, metadata);
      } else {
        // 📱 手機專用：直接傳實體檔案
        final file = File(filePath);
        await ref.putFile(file);
      }

      // 4. 成功！回傳路徑給聊天室
      return storagePath;

    } catch (e) {
      print("上傳 $fileType 失敗: $e");
      return null;
    }
  }

  Future<void> _sendMessage({
    String text = '',
    String? imagePath,
    String? audioPath,
    String? secretPrompt,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    if (_isGenerating || _sessionId == null) return;
    if (text.trim().isEmpty && imagePath == null && audioPath == null && secretPrompt == null) return;

    // 發送後清空輸入框
    _textController.clear();
    FocusScope.of(context).unfocus();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_draft_${widget.sessionId}');

    if (_currentMode != ChatMode.gemini) { // 假設 gemini 模式不算進度
      if (_currentMode == ChatMode.story) { // 如果妳的劇情模式叫做 story
        _increaseTaskProgress('storyChatProgress', 1);
      } else {
        // 其他當作日常聊天
        _increaseTaskProgress('dailyChatProgress', 3);
      }
    }

    dynamic triggeredEgg; // 這裡用 dynamic 或 妳的 EasterEgg 類別

    // ✨ 1. 彩蛋雷達掃描 (加入防重複觸發機制！)
    if (text.isNotEmpty && _currentMode != ChatMode.gemini && secretPrompt == null) {
      // 假設 _currentCharacter 是從 widget.character 來的
      final easterEggs = widget.character?.easterEggs ?? [];

      for (var egg in easterEggs) {
        // 條件：包含關鍵字 且 這次對話還沒觸發過
        if (text.contains(egg.keyword) && !_triggeredEggKeywords.contains(egg.keyword)) {
          triggeredEgg = egg;
          break;
        }
      }
    }

    // ✨ 2. 觸發彩蛋的「無縫接軌」與「掉落」
    if (triggeredEgg != null) {
      // A. 記錄起來，這輩子(或這次對話)不准再觸發了
      _triggeredEggKeywords.add(triggeredEgg.keyword);
      // B. 把戰利品丟進玩家背包，並顯示精美橫幅
      await _dropEggToBackpack(triggeredEgg);
      // C. 偷偷把劇本塞給 AI (完美對接妳後端的 overrideSystemPrompt)
      // 這裡我們把玩家的原文照發，但是加上了強大的 secretPrompt
      await _executeMessageSending(
        userText: text, // 玩家說的原文，例如：「把那個放到背包裡」
        imagePath: imagePath,
        audioPath: audioPath,
        // 🌟 核心魔法：偷偷把彩蛋設定塞進去！
        // 假設妳彩蛋存指令的欄位叫 setScene，如果是 script 請自行替換
        secretPrompt:l10n.chat_hidden_event_trigger(triggeredEgg.title, triggeredEgg.setScene),
      );

    } else {
      // 😐 沒觸發彩蛋：交給基層員工正常發送
      await _executeMessageSending(
          userText: text,
          imagePath: imagePath,
          audioPath: audioPath,
          secretPrompt: secretPrompt
      );
    }
  }

  Future<void> _increaseTaskProgress(String fieldName, int goal) async {
    if (_userId == null) return;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(_userId);

    try {
      // 取得當前最新進度
      final doc = await userDocRef.get();
      final int currentProgress = doc.data()?[fieldName] ?? 0;

      // 如果還沒達到目標，就幫他 +1
      if (currentProgress < goal) {
        await userDocRef.update({
          fieldName: FieldValue.increment(1),
        });
        print('✅ 任務 $fieldName 進度已更新！');

        // ✨ 順便刷新一下本地變數，這樣玩家開日記時才是準確的
        _loadDailyTaskProgress();
      }
    } catch (e) {
      print('❌ 更新任務進度失敗: $e');
    }
  }

  Future<void> _dropEggToBackpack(dynamic egg) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 🌟 修正地址：精準投遞到該男神的「專屬背包」裡！
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('characters') // 👈 加上這層
          .doc(widget.character!.id) // 👈 指定男神 ID
          .collection('backpack')
          .add({
        'type': 'easter_egg',
        'characterId': widget.character!.id,
        'characterName': widget.character!.name,
        'title': egg.title,
        'keyword': egg.keyword,
        // 🌟 確保這裡有存 prompt 跟 setScene，這樣在背包點擊使用時才有劇本！
        'prompt': egg.contentPrompt ?? egg.prompt,
        'setScene': egg.setScene,
        'teaser': l10n.chat_teaser_keyword(egg.keyword),
        'unlockedAt': FieldValue.serverTimestamp(), // 背包頁面是用 timestamp 還是 unlockedAt 排序？
        'timestamp': FieldValue.serverTimestamp(),  // 保險起見兩個都給它存！
      });

      // 2. 顯示像 Email 一樣的頂部橫幅通知
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
            elevation: 6,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.mail_outline, color: Colors.pinkAccent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.chat_egg_unlocked(egg.title), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(l10n.chat_egg_saved, style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('背包掉落失敗: $e');
    }
  }

  // 🎒 偷偷檢查玩家背包，把已經拿過的彩蛋加進黑名單
  Future<void> _loadUnlockedEggs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.character.id.isEmpty) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('characters')
          .doc(widget.character.id)
          .collection('backpack')
          .get();

      if (mounted) {
        setState(() {
          for (var doc in snapshot.docs) {
            final data = doc.data();
            if (data['keyword'] != null) {
              // 把背包裡有的關鍵字，直接加進防重複觸發的清單中！
              _triggeredEggKeywords.add(data['keyword']);
            }
          }
        });
        debugPrint("🎒 已經將 ${_triggeredEggKeywords.length} 個拿過的彩蛋加入黑名單！");
      }
    } catch (e) {
      debugPrint("檢查背包彩蛋失敗: $e");
    }
  }

  // ✨ 1. 補回昨天寫好的：專門用來塞入「系統公告」 (不觸發 AI)
  Future<void> _addSystemMessage(String text) async {
    if (_messagesCollection == null) return;

    try {
      await _messagesCollection!.add({
        'sender': 'system', // 🌟 對應到你 UI 裡的系統提示框
        'text': text,
        'type': 'text',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 更新聊天室外面的預覽字
      if (_sessionDocRef != null) {
        await _sessionDocRef!.update({
          'lastMessage': text,
          'lastActivity': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('寫入系統公告失敗: $e');
    }
  }

  // 🎒 3. 處理「存入背包」與「畫面通知」的終極函數
  Future<void> _saveEggToBackpack(dynamic egg) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      // ✨ 1. 妳原本完美對齊 BackpackPage 的資料庫寫入邏輯
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('characters')
          .doc(_currentCharacter.id) // 確保對應到當前男神
          .collection('backpack')
          .add({
        'title': l10n.chat_exclusive_story(egg.title ?? egg.keyword), // 使用彩蛋標題，沒有就用關鍵字
        'teaser': l10n.chat_teaser_exclusive(_currentCharacter.name),
        'keyword': egg.keyword,
        'prompt': egg.prompt, // 🌟 妳的彩蛋劇本變數叫做 prompt！
        'setScene': egg.setScene,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // ✨ 2. 加上頂級乙女遊戲的「Email 橫幅掉落特效」
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 50, left: 16, right: 16), // 懸浮在畫面上方
            elevation: 6,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.mail_outline, color: Colors.pinkAccent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.chat_egg_unlocked_dynamic(egg.title ?? egg.keyword), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(l10n.chat_egg_saved_his_backpack, style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4), // 顯示 4 秒後自動消失
          ),
        );
      }
      print("🎒 彩蛋已成功存入 ${_currentCharacter.name} 的專屬背包！");
    } catch (e) {
      print('存入背包失敗: $e');
    }
  }


// --- 處理通話按鈕點擊 ---
  Future<void> _handleCallPress(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
  final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(l10n.please_login_first)),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await userRef.get();

      if (context.mounted) Navigator.pop(context); // 關閉載入圈圈

      final currentPoints = doc.data()?['flowerPoints'] ?? 0;

      if (currentPoints >= 20) {
        if (context.mounted) {
          // ✨ 修正 1：不再傳遞多餘的參數，直接呼叫視窗！
          _showCallConfirmDialog();
        }
      } else {
        if (context.mounted) {
          // ✨ 修正 2：呼叫餘額不足的提示框
          _showInsufficientPointsDialog();
        }
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      print("獲取點數失敗: $e");
    }
  }

  // ❌ 新增：餘額不足的提示框
  void _showInsufficientPointsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.chat_points_not_enough_title, style: TextStyle(fontWeight: FontWeight.bold)),
        content:Text(l10n.chat_points_not_enough_desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:Text(l10n.chat_understood),
          ),
        ],
      ),
    );
  }

  // 🌟 獨家設計：兩步驟置中通話確認視窗
  void _showCallConfirmDialog() {
    final l10n = AppLocalizations.of(context)!;
    int currentPage = 0;
    String selectedLanguage = l10n.ai_chat_language;
    bool shouldSave = true; // ✨ 新增：預設開啟保存

    // ✨ 完美除錯：把寫死的陣列，變成由翻譯官組裝的動態陣列！
    final List<String> languages = [
      l10n.lang_zh,
      l10n.lang_ja,
      l10n.lang_ko,
      l10n.lang_en,
      l10n.lang_vi
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentPage == 0
                      ? _buildDialogPage1(theme, () => setModalState(() => currentPage = 1))
                      : _buildDialogPage2(
                      theme,
                      selectedLanguage,
                      shouldSave, // ✨ 傳入保存狀態
                      languages,
                          (val) => setModalState(() => selectedLanguage = val),
                          (val) => setModalState(() => shouldSave = val), // ✨ 傳入變更邏輯
                          () => setModalState(() => currentPage = 0),
                          () {
                        Navigator.pop(context);
                        // 🚀 執行撥打，同時傳入語言與保存意願！
                        _executeCallSequence(selectedLanguage, shouldSave);
                      }
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 📄 第一頁：通話說明與規則 ---
  Widget _buildDialogPage1(ThemeData theme, VoidCallback onNextPage) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey(0),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(_currentCharacter.avatarPath ?? ''),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(l10n.chat_call_confirm_title(_currentCharacter.name),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
       SizedBox(height: 20),
        _buildBulletText(l10n.chat_call_rule_1, Icons.local_florist, theme.colorScheme.primary),
        _buildBulletText(l10n.chat_call_rule_2, Icons.timer_outlined, theme.colorScheme.secondary), // 可以用次要顏色
        _buildBulletText(l10n.chat_call_rule_3, Icons.headphones_outlined, theme.colorScheme.tertiary), // 可以用第三顏色
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.chat_call_btn_cancel, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5))),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: onNextPage, // 按下後換頁
              child:  Text(l10n.ok_button, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDialogPage2(
  ThemeData theme,
      String currentLang,
      bool shouldSave, // ✨ 新增
      List<String> langs,
      Function(String) onLangChanged,
      Function(bool) onSaveChanged, // ✨ 新增
      VoidCallback onBack,
      VoidCallback onCall
      )
  {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey(1),
      children: [
        Row(
          children: [
            InkWell(onTap: onBack, child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.chat_call_pref_title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 20),
        // --- 語言選擇 ---
        Text(l10n.chat_call_lang_select, style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        _buildDropdown(theme, currentLang, langs, onLangChanged),
        const SizedBox(height: 20),
        // --- 🌟 通話保存開關 ---
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha:0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SwitchListTile(
            title:Text(l10n.chat_call_save_memory, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle:Text(l10n.chat_call_save_memory_desc, style: TextStyle(fontSize: 12)),
            secondary: Icon(Icons.auto_awesome_rounded, color: theme.colorScheme.primary),
            value: shouldSave,
            onChanged: onSaveChanged,
            activeColor: theme.colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        const SizedBox(height: 24),
        // --- 按鈕區 ---
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 12,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton
                  , style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5))),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.call, size: 18),
              label:Text(l10n.chat_call_btn_start, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: onCall,
            ),
          ],
        ),
      ],
    );
  }

// 輔助小元件：把 Dropdown 抽出來讓程式碼更乾淨
  Widget _buildDropdown(ThemeData theme, String currentLang, List<String> langs, Function(String) onLangChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha:0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLang,
          isExpanded: true,
          items: langs.map((String lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
            onChanged: (val) => onLangChanged(val!),
        ),
      ),
    );
  }

  // 🎨 輔助方法：畫出第一頁帶有 Icon 的條列式文字
  Widget _buildBulletText(String text, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.85), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // 🚀 執行通話導航與扣款 (ChatPage 專用版)
  void _executeCallSequence(String selectedLanguage, bool shouldSave) async {
    final l10n = AppLocalizations.of(context)!;
    if (_isCalling) return;
    String? customBgUrl;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // 沒登入直接擋掉

    // 1. 扣除 20 花花邏輯
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // 🌟 只讓雲端扣點，不要在 setState 裡自己寫減法！
      await userRef.update({'flowerPoints': FieldValue.increment(-20)});
    } catch (e) {
      print("扣款失敗: $e");
      return;
    }

    // 🌟 2. 去保險箱抓專屬背景 (不用再寫 if (user != null) 囉)
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('characters')
          .doc(widget.character.id)
          .get();

      if (doc.exists && doc.data() != null) {
        customBgUrl = doc.data()!['callBackgroundUrl'] as String?;
      }
    } catch (e) {
      print("抓取自訂背景失敗: $e");
    }

// 🌟 2. 拿到網址後，再打開通話畫面
    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallOverlay(
              character: widget.character,
              characterId: widget.character.id,
              // ✨✨✨ 關鍵替換：如果有 customBgUrl 就用它，沒有的話才用預設大頭貼
              selectedBackgroundUrl: customBgUrl ?? widget.character.avatarPath,
              selectedLanguage: selectedLanguage,
              shouldSave: shouldSave,
              sessionId: _sessionId ?? '',
              onCallEnded: (duration, messages) async {
                Navigator.pop(context);
                final minutes = (duration / 60).floor();
                final seconds = duration % 60;
                final timeString = minutes > 0 ? '$minutes分$seconds秒' : '$seconds秒';
                await _addSystemMessage(l10n.chat_call_ended(widget.character.name, timeString));
                if (shouldSave) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final memoryRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('call_memories');

                      // ✨ 過濾掉系統訊息，只存玩家跟男神的對話！
                      final cleanMessages = messages.where((msg) => msg['isSystem'] != true).toList();

                      String? firstAudioUrl;
                      for (var msg in cleanMessages) {
                        if (msg['audioUrl'] != null && msg['audioUrl'].toString().isNotEmpty) {
                          firstAudioUrl = msg['audioUrl'];
                          break; // 找到第一個網址就停下來
                        }
                      }

                      await memoryRef.add({
                        'characterId': widget.character.id,
                        'characterName': widget.character.name,
                        'characterAvatar': widget.character.avatarPath,
                        'voiceId': widget.character.voiceId, // ✨ 把聲音 ID 也存起來備用
                        'voiceStability': widget.character.voiceStability,
                        'voiceStyle': widget.character.voiceStyle,
                        'duration': duration,
                        'timestamp': FieldValue.serverTimestamp(),
                        'messages': cleanMessages, // 🌟 成功把整場對話存進去！
                        'audioUrl': firstAudioUrl,
                      });

                      // 🧹 總裁省錢魔法：超過 10 筆就刪掉舊的
                      final snapshot = await memoryRef.orderBy('timestamp', descending: true).get();
                      if (snapshot.docs.length > 10) {
                        for (int i = 10; i < snapshot.docs.length; i++) {
                          await snapshot.docs[i].reference.delete();
                        }
                      }
                    }
                  } catch (e) {
                    print("保存回憶失敗: $e");
                  }
                }
              },
            )
        ),
      );
    }
  }

  Future<void> _executeMessageSending({
    required String userText,
    String? imagePath,
    String? audioPath,
    String? overridePrompt,
    String? secretPrompt,
  }) async {
    // 🌟 1. 身分檢查
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    final l10n = AppLocalizations.of(context)!;
    final userId = currentUser.uid;
    final characterId = _currentCharacter.id;

    try {
      // 🌟 2. 暴力現抓點數：解決 9325 點卻報不夠的問題
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      int myActualFlowers = userDoc.data()?['flowerPoints'] ?? 0;

      final bool isFreeToday = await _isBirthdayFreeChatActive();

      // 🌸 決定本次聊天的收費標準
      int messageCost = 1;
      if (_currentMode == ChatMode.story) messageCost = 5;
      if (_currentMode == ChatMode.immersive) messageCost = 7;
      if (myActualFlowers < messageCost) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.chat_points_shortage(myActualFlowers.toString())), backgroundColor: Colors.redAccent),
          );
        }
        return;
      }
      // 🌟 3. 防彈檢查：如果連線失敗，不要強行執行，避免 Unexpected null value
      if (widget.shouldSave == true && _messagesCollection == null) {
        print("❌ 錯誤：_messagesCollection 是 Null，無法寫入訊息！");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.chat_room_not_ready)));
        }
        return;
      }
      String messageType = 'text';
      String lastMessageText = userText.trim();
      String? storagePath;
      // --- A. 處理媒體檔案上傳 ---
      if (imagePath != null) {
        storagePath = await _uploadFileToStorage(imagePath, 'image');
        messageType = 'image';
        lastMessageText = '[圖片]';
      }
      if (audioPath != null) {
        if (kIsWeb && audioPath.startsWith('blob:')) {
          try {
            final response = await http.get(Uri.parse(audioPath));
            final audioBytes = response.bodyBytes;
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('artifacts/lianlianshiguang/chat_audios')
                .child('web_audio_${DateTime.now().millisecondsSinceEpoch}.webm');
            final uploadTask = await storageRef.putData(audioBytes, SettableMetadata(contentType: 'audio/webm'));
            storagePath = await uploadTask.ref.getDownloadURL();
          } catch (e) {
            print("❌ 網頁版錄音上傳失敗: $e");
          }
        } else {
          storagePath = await _uploadFileToStorage(audioPath, 'audio');
        }
        messageType = 'audio';
        lastMessageText = '[錄音]';
      }

      // --- B. 寫入用戶訊息到 Firestore ---
      if (widget.shouldSave == true && _messagesCollection != null) {
        // 🛡️ 防彈版：這裡加了 _messagesCollection != null 檢查，絕對不會崩潰
        await _messagesCollection!.add({
          'sender': 'user',
          'text': userText.trim(),
          'type': messageType,
          'path': storagePath ?? '',
          'timestamp': FieldValue.serverTimestamp(),
        });

        final userCharRef = _db
            .collection('users')
            .doc(userId)
            .collection('characters')
            .doc(characterId);

        // ⚡ 使用 Transaction 確保「只有變高才更新」
        await _db.runTransaction((transaction) async {
          final snapshot = await transaction.get(userCharRef);
          int currentGlobalAffection = 0;

          if (snapshot.exists) {
            currentGlobalAffection = snapshot.data()?['affection'] ?? 0;
          }

          // 🏆 只有當前聊天室分數 > 總存摺分數時，才更新最高紀錄
          if (_currentFriendship > currentGlobalAffection) {
            transaction.set(userCharRef, {
              'affection': _currentFriendship,
              'characterName': _currentCharacter.name,
              'lastUpdate': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            debugPrint("📈 全域最高好感度已同步更新：$_currentFriendship");
          }
        });
      } else {
        setState(() {
          _testMessages.insert(0, ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sender: 'user',
            text: userText.trim(),
            type: messageType,
            path: storagePath ?? '',
            timestamp: Timestamp.fromDate(DateTime.now()),
            isAI: false,
          ));
        });
      }

      await Future.delayed(const Duration(milliseconds: 300));
      _handleTaskProgressAfterSendingMessage();
      if (mounted) setState(() => _isGenerating = true);

      // --- C. 喚醒真正的長期記憶 ---
      List<Map<String, String>> actualChatHistory = [];
      if (widget.shouldSave == true && _messagesCollection != null) {
        final historySnapshot = await _messagesCollection!.orderBy('timestamp', descending: true).limit(16).get();
        var docsList = historySnapshot.docs.reversed.toList();
        for (int i = 0; i < docsList.length; i++) {
          final data = docsList[i].data() as Map<String, dynamic>;
          final sender = data['sender'];
          String text = data['text'] as String? ?? '';
          if (i == docsList.length - 1 && sender == 'user' && secretPrompt != null) text = secretPrompt;
          if (sender == 'user' || sender == 'ai') {
            actualChatHistory.add({"role": sender == 'ai' ? "assistant" : "user", "text": text});
          }
        }
      } else {
        var recentTests = _testMessages.take(8).toList().reversed.toList();
        for (int i = 0; i < recentTests.length; i++) {
          final msg = recentTests[i];
          final sender = msg.sender;
          String text = msg.text;
          if (i == recentTests.length - 1 && sender == 'user' && secretPrompt != null) text = secretPrompt;
          if (sender == 'user' || sender == 'ai') {
            actualChatHistory.add({"role": sender == 'ai' ? "assistant" : "user", "text": text});
          }
        }
      }

      // --- 喚醒靈魂：讀取玩家記憶與生理期 ---
      final aboutMeSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('characters').doc(characterId).collection('memories').get();
      final aboutMeNotes = aboutMeSnapshot.docs.map((doc) => doc.data()['text'] as String? ?? '').toList();

      List<String> memos = [];
      if (_currentMode == ChatMode.daily || _currentMode == ChatMode.gemini) {
        final memosSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('characters').doc(characterId).collection('memos').get();
        memos = memosSnapshot.docs.map((doc) => doc.data()['content'] as String? ?? '').toList();
      }

      final periodDoc = await FirebaseFirestore.instance.collection('users').doc(userId).collection('characters').doc(characterId).collection('period_tracker').orderBy('startDate', descending: true).limit(1).get();
      String periodStatus = "未知";
      if (periodDoc.docs.isNotEmpty) {
        final data = periodDoc.docs.first.data();
        final Timestamp? startDate = data['startDate'];
        final Timestamp? endDate = data['endDate'];
        if (startDate != null && endDate != null) {
          final now = DateTime.now();
          if (!now.isBefore(startDate.toDate()) && !now.isAfter(endDate.toDate().add(const Duration(days: 1)))) {
            periodStatus = "生理期間";
          } else {
            periodStatus = "非生理期間";
          }
        }
      }

      // --- 🚀 D. 呼叫雲端 AI 大腦 ---
      final idToken = await currentUser.getIdToken();
      int currentScore = _currentFriendship;
      String dynamicRelationship = currentScore.relationshipTitle(l10n);
      final Map<String, dynamic> requestBody = {
        "audioUrl": storagePath ?? "",
        "userMessage": userText.trim(),
        "chatMode": _currentMode?.name ?? "daily",
        "isBirthdayFreebie": isFreeToday,
        "overrideSystemPrompt": overridePrompt ?? "",
        "sessionId": _sessionId,
        "userProfile": _userProfileText.isNotEmpty ? _userProfileText : "玩家尚未提供詳細個人資料",
        "systemDirective": (overridePrompt != null && overridePrompt.isNotEmpty)
            ? "【最高防護指令】上述玩家個人資料僅供背景參考。玩家已觸發特殊劇情，請配合 overrideSystemPrompt 的指示順暢地演出。"
            : "【最高防護指令】上述玩家個人資料僅供背景參考。你必須「維持當前的聊天情境與場景」。絕對不可以因為得知了新資料，就生硬地轉換話題。",
        "aboutMeNotes": aboutMeNotes,
        "memos": memos,
        "periodStatus": periodStatus,
        "lastStoryTime": _currentStoryTime,
        "lastStoryLocation": _currentStoryLocation,
        "characterProfile": {
          "id": _currentCharacter.id,
          "name": _currentCharacter.name,
          "toneAndStyle": _currentCharacter.toneAndStyle?.replaceAll('{{玩家名字}}', _playerNickname) ?? "",
          "background": _currentCharacter.background?.replaceAll('{{玩家名字}}', _playerNickname) ?? "",
          "detailedPersonality": _currentCharacter.detailedPersonality?.replaceAll('{{玩家名字}}', _playerNickname) ?? "",
          "likes": _currentCharacter.likes?.replaceAll('{{玩家名字}}', _playerNickname) ?? "",
          "secrets": _currentCharacter.secrets?.replaceAll('{{玩家名字}}', _playerNickname) ?? "",
          "gender": _currentCharacter.gender ?? "未知",
          "relationship": dynamicRelationship,
          "socialRelationships": _currentCharacter.relationships != null
              ? jsonEncode(_currentCharacter.relationships).replaceAll('{{玩家名字}}', _playerNickname)
              : "",
        },
        "chatHistory": actualChatHistory,
      };

      _httpClient = http.Client();
      final response = await _httpClient!.post(
        Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/getAiResponse'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $idToken'},
        body: jsonEncode(requestBody),
      );

      // --- 🎯 E. 接收 API 秒回的收據，並派出狙擊手監聽 ---
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['status'] == 'success') {
          final String requestId = responseData['requestId'];
          StreamSubscription<DocumentSnapshot>? subscription;

          subscription = FirebaseFirestore.instance.collection('users').doc(userId).collection('aiRequests').doc(requestId).snapshots().listen((snapshot) async {
            if (!snapshot.exists) return;
            final data = snapshot.data() as Map<String, dynamic>;
            final status = data['status'];

            if (status == 'completed') {
              final String rawAiContent = data['response'] ?? "";
              String finalDisplayText = rawAiContent;
              int finalAffectionChange = data['affectionChange'] ?? 0;
              // 🌟🌟🌟 總裁拆箱魔法：旗艦級過濾器 🌟🌟🌟
              try {
                // 1. 先清除 Markdown 可能帶有的外殼
                String cleanedJson = rawAiContent
                    .replaceAll('```json', '')
                    .replaceAll('```', '')
                    .trim();

                // 2. 嘗試解析 JSON
                if (cleanedJson.startsWith('{') && cleanedJson.endsWith('}')) {
                  final Map<String, dynamic> parsedData = jsonDecode(cleanedJson);
                  finalDisplayText = parsedData['response'] ?? finalDisplayText;
                  finalAffectionChange = parsedData['affectionChange'] ?? finalAffectionChange;
                }
              } catch (e) {
                print("❌ 拆箱解析失敗，將以純文字模式處理: $e");
              }

              // ✨ 關鍵核心：處理「雙重跳脫」的換行符號 ✨
              finalDisplayText = finalDisplayText.replaceAll('\\n', '\n');

              // 清除可能殘留的 JSON 標籤符號（防止解析失敗時把括號秀出來）
              if (finalDisplayText.startsWith('{"response":')) {
                // 如果解析失敗但開頭長得像 JSON，就用正則表達式強行抓取內容
                final match = RegExp(r'"response":\s*"([\s\S]*?)"').firstMatch(finalDisplayText);
                if (match != null) {
                  finalDisplayText = match.group(1) ?? finalDisplayText;
                  finalDisplayText = finalDisplayText.replaceAll('\\n', '\n');
                }
              }
              subscription?.cancel();

              if (mounted) {
                final String ultimateDisplayText = finalDisplayText.trim().isNotEmpty ? finalDisplayText : "（似乎在思考中，請再對我說一次話吧...）";

                if (ultimateDisplayText.trim().isNotEmpty) {
                  // 1. 更新畫面上的點數
                  setState(() {
                    _flowerPoints = (_flowerPoints - messageCost).clamp(0, 999999);
                  });

                  // 2. 去資料庫扣款
                  FirebaseFirestore.instance.collection('users').doc(userId).update({'flowerPoints': FieldValue.increment(-messageCost)});

                  // ✨✨✨ 3. 總裁專屬記帳系統：寫入收支明細 ✨✨✨
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId) // 💡 妳前面已經定義好 userId 了，直接用超安全！
                      .collection('flower_logs')
                      .add({
                    'title': '與 ${_currentCharacter.name} 聊天', // 自動抓取正在聊天的角色名字！
                    'amount': -messageCost, // 🔴 自動扣除對應的點數 (例如 -1, -5, -7)
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                }

                // 🌟 好感度邏輯
                if (finalAffectionChange != 0) {
                  int oldScore = _currentFriendship;

                  setState(() {
                    _currentFriendship += finalAffectionChange;
                  });

                  // 升級檢查（這個可以每次都跑，因為升級比較稀有）
                  _checkForLevelUp(oldScore, _currentFriendship);

                  // 🚩 總裁護身符：限制卡片/動畫跳出的次數
                  // 原本是每次 >= 5 就跳，現在加上了 !_hasShownAffectionCard 的判斷
                  if (finalAffectionChange > 0 && !_hasShownAffectionCard) {
                    // 只有好感度增加，且這場聊天「還沒跳過」時才執行
                    _showAffectionAnimation(finalAffectionChange); // 這裡可能是妳跳出卡片的 function

                    // 🔒 執行完立刻鎖起來，這場聊天就不會再跳了
                    _hasShownAffectionCard = true;

                    print("✅ 這場聊天的驚喜卡片已跳過，系統已自動進入沉浸鎖定模式。");
                  }
                }

                // 🌟 寫入 AI 回覆
                if (widget.shouldSave == true && _messagesCollection != null) {
                  await _messagesCollection!.add({
                    'sender': 'ai',
                    'text': ultimateDisplayText,
                    'type': 'text',
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  await _sessionDocRef!.update({
                    'friendshipScore': _currentFriendship,
                    'lastMessage': finalDisplayText,
                    'lastActivity': FieldValue.serverTimestamp(),
                  });

                  try {
                    final userCharRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('characters')
                        .doc(characterId);

                    await FirebaseFirestore.instance.runTransaction((transaction) async {
                      final snapshot = await transaction.get(userCharRef);
                      int currentGlobalAffection = 0;
                      if (snapshot.exists) {
                        currentGlobalAffection = snapshot.data()?['affection'] ?? 0;
                      }

                      // 🏆 只有當前分數更猛時，才更新最高紀錄
                      if (_currentFriendship > currentGlobalAffection) {
                        transaction.set(userCharRef, {
                          'affection': _currentFriendship,
                          'characterName': _currentCharacter.name,
                          'lastUpdate': FieldValue.serverTimestamp(),
                        }, SetOptions(merge: true));
                        print("📈 全域存摺已同步最高分：$_currentFriendship");
                      }
                    });
                  } catch (e) {
                    print("❌ 同步總存摺失敗: $e");
                  }

                  if (!_currentCharacter.isPublic) {
                    try {
                      await FirebaseFirestore.instance.collection('artifacts').doc(const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang')).collection('users').doc(userId).collection('private_characters').doc(characterId).update({'lastChatTime': FieldValue.serverTimestamp()});
                    } catch (e) {
                      print('更新私人角色時間失敗: $e');
                    }
                  }
                } else {
                  setState(() {
                    _testMessages.insert(0, ChatMessage(
                      id: requestId, sender: 'ai', text: ultimateDisplayText, type: 'text', path: '', timestamp: Timestamp.fromDate(DateTime.now()), isAI: true,
                    ));
                  });
                }
                setState(() => _isGenerating = false);
              }
            } else if (status == 'error') {
              subscription?.cancel();
              print("❌ 背景任務失敗: ${data['errorMessage']}");
              if (mounted) {
                setState(() => _isGenerating = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error_network_unavailable)));
              }
            }
          });
        } else {
          if (mounted) {
            setState(() => _isGenerating = false);
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(l10n.error_system_busy)));
          }
        }
      } else {
        if (mounted) {
          setState(() => _isGenerating = false);
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(l10n.error_msg_send_failed)));
        }
      }
    } catch (e, stack) {
      print('❌ 發送訊息時發生嚴重錯誤: $e');
      print('📍 錯誤堆疊: $stack');
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.error_system_confusion)));
      }
    } finally {
      _httpClient?.close();
      _httpClient = null;
    }
  }

  // 檢查今天是否為生日免費日
  Future<bool> _isBirthdayFreeChatActive() async {
    final prefs = await SharedPreferences.getInstance();
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastTriggerDate = prefs.getString('lastBirthdayTriggerDate');
    return lastTriggerDate == todayString;
  }

  Future<void> _handleTaskProgressAfterSendingMessage() async {
    if (_userId == null) return;

    final userDocRef = _db.collection('users').doc(_userId);
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 根據當前的聊天模式，決定要更新哪個任務的進度
    final String progressField = _currentMode == ChatMode.daily
        ? 'dailyTasks.dailyChatProgress'
        : 'dailyTasks.storyChatProgress';

    try {
      await _db.runTransaction((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        if (!userDoc.exists) return;

        final data = userDoc.data()!;
        final lastResetTimestamp = data['lastTasksResetDate'] as Timestamp?;
        String lastResetDateString = '';
        if (lastResetTimestamp != null) {
          lastResetDateString = DateFormat('yyyy-MM-dd').format(lastResetTimestamp.toDate());
        }

        // 如果上次重置日期不是今天，就重置所有任務進度，然後再 +1
        if (lastResetDateString != todayString) {
          transaction.update(userDocRef, {
            'lastTasksResetDate': FieldValue.serverTimestamp(),
            'dailyTasks': {
              'dailyChatProgress': _currentMode == ChatMode.daily ? 1 : 0,
              'dailyChatClaimed': false,
              'storyChatProgress': _currentMode == ChatMode.story ? 1 : 0,
              'storyChatClaimed': false,
              'likeProgress': 0,
              'likeClaimed': false,
            }
          });
        } else {
          // ✨ 1. 先從 transaction 中獲取目前的數據 (這行通常在 transaction 開頭就有了，請確認變數名)
          // 假設妳的 snapshot 變數叫做 snapshot，且 data 是 snapshot.data()
          final currentTasks = (data['dailyTasks'] as Map<String, dynamic>?) ?? {};

          // ✨ 2. 取得這個任務目前的進度 (從路徑中抓出欄位名)
          // 這裡要稍微處理一下，因為 progressField 可能是 'dailyTasks.dailyChatProgress'
          final fieldName = progressField.split('.').last;
          final int currentVal = currentTasks[fieldName] ?? 0;
          // ✨ 3. 設定目標次數 (劇情是 1 次，其他通常是 3 次)
          int goal = progressField.contains('storyChat') ? 1 : 3;
          // ✨ 4. 只有在「還沒達標」的情況下，才執行更新
          if (currentVal < goal) {
            transaction.update(userDocRef, {
              progressField: FieldValue.increment(1),
            });
            print("心動日記進度更新成功: $progressField 從 $currentVal 變 ${currentVal + 1}");
          } else {
            print("心動日記任務已達標 ($currentVal/$goal)，不再增加次數");
          }
        }
      });
      await _loadDailyTaskProgress();
    } catch (e) {
      print("更新心動日記進度失敗: $e");
    }
  }

  // ✨ 補上這個：從資料庫把今天的進度抓回來到變數裡
  int _dailyChatProgress = 0;
  int _storyChatProgress = 0;
  int _likeProgress = 0;
  bool _isDailyChatClaimed = false;
  bool _isStoryChatClaimed = false;
  bool _isLikeClaimed = false;

  Future<void> _loadDailyTaskProgress() async {
    if (_userId == null) return;
    final doc = await _db.collection('users').doc(_userId).get();
    if (doc.exists) {
      final data = doc.data()?['dailyTasks'] ?? {};
      setState(() {
        _dailyChatProgress = data['dailyChatProgress'] ?? 0;
        _storyChatProgress = data['storyChatProgress'] ?? 0;
        _likeProgress = data['likeProgress'] ?? 0;
        _isDailyChatClaimed = data['dailyChatClaimed'] ?? false;
        _isStoryChatClaimed = data['storyChatClaimed'] ?? false;
        _isLikeClaimed = data['likeClaimed'] ?? false;
      });
    }
  }

  void _listenToFlowerPoints() {
    // 取得當前使用者 ID
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _pointsSubscription?.cancel(); // 先取消舊的監聽，避免重複
    _pointsSubscription = _db.collection('users').doc(userId).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey('flowerPoints')) {
        if (mounted) {
          setState(() {
            _flowerPoints = snapshot.data()!['flowerPoints'];
          });
        }
      }
    }, onError: (error) {
      print('在聊天室監聽花花點數失敗: $error');
    });
  }

  // ✨ 進化版煞車系統
  void _stopGenerating() {
    final l10n = AppLocalizations.of(context)!;
    if (_isGenerating && _httpClient != null) {
      // 🛑 直接切斷網路連線！雲端收到斷線通知，就會停止運算並退還點數！
      _httpClient!.close();
      _httpClient = null;
      setState(() {
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar( // 👈 把這裡原本的 const 拿掉
          content: Text(l10n.chat_stop_generating_msg), // 👈 把 const 移來這裡
          backgroundColor: Colors.grey[800], // 👈 換成有質感的深灰色。如果想要更黑，可以換成 Colors.black87
          duration: const Duration(seconds: 2), // 👈 這裡也要加上 const
        ),
      );
    }
  }

  void _showAffectionAnimation(int change) async { // 👈 記得加 async，因為要讀取震動設定
    final bool isIncrease = change > 0;
    final l10n = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    // 檢查玩家有沒有開震動
    bool isVibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    if (isVibrationEnabled) {
      if (isIncrease) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.vibrate();
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: Colors.white.withValues(alpha:0.95),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isIncrease ? Colors.pinkAccent : Colors.blueGrey,
            width: 2,
          ),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.65,
          left: 60,
          right: 60,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncrease ? Icons.favorite : Icons.heart_broken,
              color: isIncrease ? Colors.pink : Colors.blueGrey,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              isIncrease ? l10n.chat_heartbeat_up : l10n.chat_heartbeat_down,
              style: TextStyle(
                color: isIncrease ? Colors.pink[700] : Colors.blueGrey[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initRecorder() async {
    await _recorder!.openRecorder();
    await _player!.openPlayer();
  }
  Future<void> _checkFirstTimeEntry() async {
    if (_hasTriggeredCheck) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data() ?? {};
      bool noProfile = !data.containsKey('profile');
      bool neverSkipped = !data.containsKey('hasSkippedProfile');
      if (noProfile && neverSkipped) {
        if (mounted) {
          // 延遲一下下再彈出，等聊天室背景跟程宇的對話框跑出來，體感更流暢
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              UserProfilePopup.show(context, onSaved: () {
                // 玩家填寫完畢後的邏輯 (例如重新整理背景人設變數)
                _checkProfileCompletion();
              });
            }
          });
        }
      }
      _hasTriggeredCheck = true;
    } catch (e) {
      print("檢查名片狀態失敗: $e");
    }
  }

  Future<void> _checkProfileCompletion() async {
    if (_isChecking) return;
    _isChecking = true;
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isChecking = false;
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data() ?? {};

      final String nickname = data['nickname'] ?? l10n.chat_default_player_name;
      final String birthday = data['birthday'] ?? l10n.authMethodUnknown;
      _playerNickname = nickname;

      // 🌟 新增：多重身分讀取邏輯
      Map<String, dynamic>? activeProfile;

      // 1. 先嘗試找新版的「多重檔案 (profiles)」與「啟動中的 ID (activeProfileId)」
      if (data.containsKey('profiles') && data.containsKey('activeProfileId')) {
        List<dynamic> profiles = data['profiles'];
        String activeId = data['activeProfileId'];

        // 🔍 在陣列中尋找符合 ID 的那個身分
        try {
          activeProfile = profiles.firstWhere((p) => p['id'] == activeId);
        } catch (e) {
          activeProfile = null; // 如果意外找不到就留空
        }
      }
      // 2. 🛡️ 過渡期防護：如果玩家還沒點開過新版設定，就先讀取舊版的單一名片
      else if (data.containsKey('profile')) {
        activeProfile = Map<String, dynamic>.from(data['profile']);
        activeProfile['profileName'] = '預設檔案'; // 幫舊檔案加個稱呼
      }

      // 根據是否找到檔案來更新畫面
      if (activeProfile != null) {
        // ✨ 完整人設檔案
        final String profileName = activeProfile['profileName'] ?? l10n.profile_unnamed_file;
        final String currentIdentityName = activeProfile['name']?.toString().trim().isNotEmpty == true
            ? activeProfile['name']
            : nickname;

        setState(() {
          _userProfileText = l10n.chat_profile_full(
              profileName,                     // {name}
              currentIdentityName,             // {identity}
              birthday,                        // {birthday}
              activeProfile!['height'] ?? '',  // {height}
              activeProfile!['appearance'] ?? '', // {appearance}
              activeProfile!['occupation'] ?? '', // {job}
              activeProfile!['intro'] ?? ''    // {intro}
          );
        });
      } else {
        // 🔒 尚未填寫的神秘狀態
        setState(() {
          _userProfileText = l10n.chat_profile_locked(
              nickname, // {nickname}
              birthday  // {birthday}
          );
        });
      }
    } catch (e) {
      // 這裡屬於除錯訊息，不用翻譯喔！
      print("檢查玩家拾光檔案失敗: $e");
    } finally {
      _isChecking = false;
    }
  }

  void _showMessageOptions(ChatMessage message) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(child: Wrap(
          children: <Widget>[
            // 📸 🌟 總裁推薦：新增「截圖分享」選項
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Colors.purple),
              title: const Text('截圖分享'), // 之後記得補進 l10n 喔！
              onTap: () {
                Navigator.pop(context); // 先關掉選單

                // 🚩 啟動截圖模式魔法
                setState(() {
                  _isScreenshotMode = true;
                  _selectedMessageIds.clear(); // 先清空舊的
                  _selectedMessageIds.add(message.id); // 把目前長按的這句勾起來
                });

                HapticFeedback.mediumImpact(); // 給玩家一個俐落的震動回饋
              },
            ),

            const Divider(), // 加條細線區隔功能區
            // 👇 1. 新增：複製內容按鈕 (放在最上面比較順手)
            ListTile(
              leading: const Icon(Icons.copy),
              title:Text(l10n.chat_msg_copy),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: message.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:Text(l10n.chat_msg_copied),
                    backgroundColor: Colors.grey[800], // 順便幫妳套用剛剛的低調質感顏色！
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            if (message.type == 'text')
              ListTile(
                leading: const Icon(Icons.edit),
                title:  Text(l10n.edit_btn),
                onTap: () {
                  Navigator.pop(context);
                  _editMessage(message);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l10n.delete_btn, style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(message);
              },
            ),
            // 🚩 舉報按鈕 (要帶伴手禮)
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title:Text(l10n.chat_msg_report),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(context, message.text); // 🌟 完美！帶上這句話當證據
              },
            ),

            // 💡 建議按鈕 (不用帶伴手禮，而且開關要換對)
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title:Text(l10n.chat_msg_suggest),
              onTap: () {
                Navigator.pop(context);
                _showSuggestionDialog(context); // 🌟 換成建議視窗，而且只需帶 context！
              },
            ),
          ],
        ));
      },
    );
  }

  // 🚨 1. 舉報對話的彈出視窗 (🌟 接收傳進來的句子)
  void _showReportDialog(BuildContext context, String reportedMessage) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.chat_report_title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 語言問題
              ListTile(
                title: Text(l10n.chat_report_lang),
                onTap: () {
                  Navigator.pop(context);
                  _submitReport(context, l10n.chat_report_lang, reportedMessage);
                },
              ),
              // 2. 內容不當
              ListTile(
                title: Text(l10n.chat_report_inapp),
                onTap: () {
                  Navigator.pop(context);
                  _submitReport(context, l10n.chat_report_inapp, reportedMessage);
                },
              ),
              // 3. 邏輯/內容錯誤
              ListTile(
                title: Text(l10n.chat_report_context),
                onTap: () {
                  Navigator.pop(context);
                  _submitReport(context, l10n.chat_report_context, reportedMessage);
                },
              ),
              // 4. 其他原因 - 🌟 保留圖示並換成更有質感的
              ListTile(
                leading: const Icon(Icons.more_horiz, color: Colors.grey), // 推薦換成這個更像「填寫原因」的圖示
                title: Text(l10n.chat_report_other),
                onTap: () {
                  Navigator.pop(context);
                  _showOtherReasonDialog(context, reportedMessage);
                },
              ),
            ],
          ),
        );
      },
    );
  }

// 🚨 1-1. 新增：專屬「其他原因」的打字視窗 (🌟 接收傳進來的句子)
  void _showOtherReasonDialog(BuildContext context, String reportedMessage) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController otherReasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:Text(l10n.chat_report_other),
          content: TextField(
            controller: otherReasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.chat_report_hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final text = otherReasonController.text.trim();
                if (text.isNotEmpty) {
                  Navigator.pop(context);
                  // 🌟 打包送出！把翻譯好的「其他原因」和玩家輸入的 $text 完美組合
                  _submitReport(context, '${l10n.chat_report_other}: $text', reportedMessage);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child:Text(l10n.chat_report_submit, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

// 🚨 1-2. 負責把舉報資料打包送去後台的快遞員 (🌟 把句子存進資料庫)
  Future<void> _submitReport(BuildContext context, String reason, String reportedMessage) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    final l10n = AppLocalizations.of(context)!;
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'userId': currentUserId,
        'reason': reason,
        'reportedMessage': reportedMessage, // 👈 🌟 破案關鍵！這裡把句子存進去了！
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.chat_report_success), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print('舉報失敗: $e');
    }
  }

// 💡 2. 給予建議的彈出視窗
  void _showSuggestionDialog(BuildContext context) {
    final TextEditingController suggestionController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(l10n.chat_suggest_title),
          content: TextField(
            controller: suggestionController,
            maxLines: 4, // 讓框框大一點，可以寫多一點字
            decoration: InputDecoration(
              hintText: l10n.chat_suggest_hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 取消按鈕
              child: Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final text = suggestionController.text.trim();
                if (text.isNotEmpty) {
                  Navigator.pop(context); // 關閉視窗

                  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
                  // 建立一個叫做 'suggestions' 的資料夾來收集建議
                  await FirebaseFirestore.instance.collection('suggestions').add({
                    'userId': currentUserId,
                    'content': text,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.chat_suggest_success), backgroundColor: Colors.pinkAccent),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child: Text(l10n.chat_report_submit, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMessage(ChatMessage message) async {
    final l10n = AppLocalizations.of(context)!;
    final collection = _messagesCollection;
    if (collection == null) return;
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:Text(l10n.confirm_delete_title),
        content:Text(l10n.chat_del_warn),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton
          )),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child:Text(l10n.delete_btn, style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmDelete == true) {
      try {
        await collection.doc(message.id).delete();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.delete_failed_msg}: $e')));
      }
    }
  }

  // ✨ 一鍵失憶魔法：重置對話
  Future<void> _resetChat() async {
    final l10n = AppLocalizations.of(context)!;
    // ✨ 1. 定義三種選擇結果：null (取消), 'chat_only' (僅對話), 'full_reset' (完全重置)
    final String? resetType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:Row(
          children: [
            Icon(Icons.restart_alt_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(l10n.chat_reset_title),
          ],
        ),
        content: Text(l10n.chat_reset_desc),
        actions: [
          // 選項一：取消
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child:  Text(l10n.cancelButton
                , style: TextStyle(color: Colors.grey)),
          ),
          // 選項二：僅對話
          TextButton(
            onPressed: () => Navigator.of(context).pop('chat_only'),
            child:Text(l10n.chat_reset_only_chat, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // 選項三：完全重置
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop('full_reset'),
            child: Text(l10n.chat_reset_full, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // 如果玩家點旁邊或是點取消，就什麼都不做
    if (resetType == null || _messagesCollection == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. 無論選哪個，對話紀錄一定會殺光
      final snapshots = await _messagesCollection!.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      // 2. ✨ 關鍵邏輯：根據玩家的選擇決定要不要歸零好感度
      Map<String, dynamic> updateData = {
        'lastMessage': resetType == 'full_reset' ? l10n.chat_memory_cleared : l10n.chat_history_reset,
        'lastActivity': FieldValue.serverTimestamp(),
        'lastStoryTime': FieldValue.delete(),
        'lastStoryLocation': FieldValue.delete(),
      };

      if (resetType == 'full_reset') {
        // 如果是完全重置，就把好感度也砍掉！
        updateData['friendshipScore'] = 0;
        setState(() => _currentFriendship = 0);
      }

      await _sessionDocRef!.update(updateData);

      setState(() {
        _currentStoryTime = null;
        _currentStoryLocation = null;
      });

      // 3. 重新發送開場白
      if (_currentMode != ChatMode.gemini) {
        String firstLine = _currentCharacter.firstLine.isNotEmpty
            ? _currentCharacter.firstLine.replaceAll('{{玩家名字}}', _userProfileText.contains('名字:') ? _userProfileText.split('名字:')[1].split('，')[0] : l10n.chat_default_player_name)
            : l10n.chat_default_greeting;

        String initialStoryText = _currentCharacter.initialStory.replaceAll('{{玩家名字}}', _userProfileText.contains('名字:') ? _userProfileText.split('名字:')[1].split('，')[0] : l10n.chat_default_player_name);

        if (initialStoryText.isNotEmpty) {
          await _messagesCollection!.add({
            'sender': 'system',
            'text': initialStoryText,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'text',
            'path': '',
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }

        await _messagesCollection!.add({
          'sender': 'ai',
          'text': firstLine,
          'type': 'text',
          'path': '',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      if (mounted) {
        String snackBarText = resetType == 'full_reset'
            ?l10n.chat_reset_full_msg
            : l10n.chat_reset_chat_msg;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snackBarText)));
      }

    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.common_reset_failed(e.toString()))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editMessage(ChatMessage message) async {
    final collection = _messagesCollection;
    if (collection == null) return;
    final l10n = AppLocalizations.of(context)!;

    final editingController = TextEditingController(text: message.text);
    final bool isAiMessage = message.sender == 'ai'; // 判斷是不是 AI 的訊息

    final String? newText = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // 👇 這裡變乾淨了！把 Row 拿掉，直接放字數統計
              title: Text(l10n.chat_edit_char_count(editingController.text.length.toString()),
                style: TextStyle(
                  fontSize: 14,
                  color: editingController.text.length >= 300 ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: TextField(
                  controller: editingController,
                  autofocus: false,
                  maxLines: null, // 允許多行輸入
                  onChanged: (text) {
                    // ✨ 只要鍵盤有動靜，就馬上重算一次字數！
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: isAiMessage ? l10n.chat_edit_ai_hint : l10n.chat_edit_user_hint,
                  ),
                ),
              ),
              actions: [
                TextButton(
                    child: Text(l10n.cancelButton
                        , style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.of(context).pop()
                ),
                ElevatedButton(
                    child:Text(l10n.confirm_button),
                    onPressed: () => Navigator.of(context).pop(editingController.text)
                ),
              ],
            );
          },
        );
      },
    );

    // 如果玩家有修改內容且按下確認，就更新到資料庫
    if (newText != null && newText.trim().isNotEmpty && newText.trim() != message.text) {
      try {
        await collection.doc(message.id).update({'text': newText.trim()});
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.common_edit_failed(e.toString()))));
      }
    }
  }

  Future<void> _sendPoke(String characterId, String creatorId, String characterName) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    // 取得玩家名稱，若無則顯示「神秘玩家」
    final String playerName = currentUser.displayName ?? l10n.chat_mysterious_player;

    try {
      // 🌟 在通知集合中新增一筆「聲線請求」
      await FirebaseFirestore.instance.collection('mailbox').add({
        'type': 'voice_request',
        'fromUserId': currentUser.uid,
        'fromUserName': playerName,
        'toUserId': creatorId,      // 接收者：角色的創作者
        'characterId': characterId,
        'characterName': characterName,
        'message':l10n.chat_poke_message(playerName, characterName),
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false, // 預設為未讀，之後可用來控制小紅點
      });

      // 🌟 同時更新角色的「被期待次數」，方便創作者統計人氣
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId) // 請確保這裡有妳的 appId
          .collection('public_characters')
          .doc(characterId)
          .update({
        'poke_count': FieldValue.increment(1),
      });

    } catch (e) {
      debugPrint("發送戳戳失敗: $e");
      throw e; // 拋出錯誤讓 UI 層可以捕捉
    }
  }


  Future<void> _playAudio(String path) async {
    if (_player!.isPlaying) {
      await _player!.stopPlayer();
      return;
    }
    await _player!.startPlayer(fromURI: path);
  }

  Future<void> _pickImage() async {
    // ✨ VIP 通道：如果是網頁版，直接呼叫 ImagePicker！
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,    // 🌟 加上這行：畫質壓縮到 70%
        maxWidth: 1080,      // 🌟 加上這行：限制最大寬度
      );
      if (imageFile != null) {
        _sendMessage(text: "(傳送了一張圖片)", imagePath: imageFile.path);
      }
      return; // 執行完就提早結束，不要再往下走
    }

    // 📱 原本的通道：如果是手機版，乖乖照舊檢查權限
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,    // 🌟 手機版也一模一樣加上壓縮！
        maxWidth: 1080,      // 🌟 限制最大寬度
      );
      if (imageFile != null) {
        _sendMessage(text: "(傳送了一張圖片)", imagePath: imageFile.path);
      }
    } else {
      print('相簿權限被拒絕');
    }
  }

  // ✨ 4. 新增一個 getModeName 函式來處理多國語言
  String _getModeName(ChatMode mode, AppLocalizations? l10n) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case ChatMode.daily: return l10n?.chatModeDaily ?? l10n.chatModeDaily;
      case ChatMode.story: return l10n?.chatModeStory ?? l10n.chatModeStory;
      case ChatMode.immersive: return l10n?.chatModeImmersive ?? l10n.chatModeImmersive;
      case ChatMode.gemini: return l10n?.chatModeGemini ?? l10n.chat_mode_gemini;
    }
  }

  void _showToolbox() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        bool showRecordingUI = false;
        bool isCurrentlyRecording = false;
        String? finalAudioPath;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetSetState) {
            final theme = Theme.of(context);
            Future<void> startRecording() async {
              if (isCurrentlyRecording) return;
              // ✨ VIP 通道：如果是網頁版
              if (kIsWeb) {
                await _recorder!.startRecorder(toFile: 'web_audio_record.webm', codec: Codec.opusWebM);
                sheetSetState(() {
                  isCurrentlyRecording = true;
                  finalAudioPath = null;
                });
                return; // 🚀 執行完網頁版就提早結束，絕對不要往下走！
              }
              // 📱 原本的通道：如果是手機版 (iOS / Android)
              final status = await Permission.microphone.request();
              if (status != PermissionStatus.granted) {
                print('麥克風權限被拒絕');
                return;
              }
              // 手機版才有實體資料夾可以存 AAC 檔案
              final tempDir = await getTemporaryDirectory();
              final path = '${tempDir.path}/flutter_sound_${DateTime.now().millisecondsSinceEpoch}.aac';
              await _recorder!.startRecorder(toFile: path, codec: Codec.aacADTS);
              sheetSetState(() {
                isCurrentlyRecording = true;
                finalAudioPath = null;
              });
            }

            Future<void> stopRecording() async {
              if (!isCurrentlyRecording) return;
              String? path = await _recorder!.stopRecorder();
              sheetSetState(() {
                isCurrentlyRecording = false;
                finalAudioPath = path;
              });
              debugPrint("✅ 錄音結束，檔案位置: $finalAudioPath");
            }

            Future<void> playRecordedAudio() async {
              if (finalAudioPath == null) return;

              try {
                // 🌟 總裁級武器：不管是手機路徑還是網頁 blob，UrlSource 都能直接吃！
                await _audioPlayer?.play(UrlSource(finalAudioPath!));
                debugPrint("🎵 正在播放錄音...");
              } catch (e) {
                debugPrint("❌ 播放錄音失敗: $e");
              }
            }

            return Container(
              height: 350,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              // 🌟 如果 showRecordingUI 是 true，就顯示【錄音介面】
              child: showRecordingUI
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      isCurrentlyRecording
                          ? l10n.chat_record_recording
                          : (finalAudioPath == null ? l10n.chat_record_start : l10n.chat_record_done),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isCurrentlyRecording) {
                            stopRecording();
                          } else {
                            startRecording();
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isCurrentlyRecording ? Icons.stop : Icons.mic,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                            size: 40,
                          ),
                        ),
                      ),
                      if (finalAudioPath != null && !isCurrentlyRecording)
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: _isGenerating
                              ? IconButton(
                            icon: const Icon(Icons.stop_circle_outlined,
                                color: Colors.red, size: 32),
                            onPressed: _stopGenerating,
                          )
                              : IconButton(
                            icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              // 🌟 1. 把文字「和」錄音路徑一起打包送出去！
                              _sendMessage(
                                text: _textController.text,
                                audioPath: finalAudioPath, // 👈 絕對不能漏掉這行！
                              );
                              // 🌟 2. 送出後，順便把這個錄音百寶箱關掉，讓玩家看聊天畫面
                              Navigator.pop(context);
                            },
                          ),
                        )
                    ],
                  ),
                ],
              )

              // ✨✨✨ 破案關鍵在這裡：加上這個冒號 (:) 代表「否則」，然後接上妳的【百寶箱九宮格】 ✨✨✨
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: <Widget>[
                    // 🎒 1. 背包
                    _buildToolItem(Icons.backpack_outlined, l10n.chat_tool_backpack, () {
                      Navigator.pop(context); // 關閉下方工具選單
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BackpackPage(
                                character: _currentCharacter,
                                onUseEgg: (eggData) {
                                  if (eggData['setScene'] != null &&
                                      eggData['setScene'].toString().isNotEmpty) {
                                    setState(() {
                                      _currentStoryLocation = eggData['setScene'];
                                    });
                                  }
                                  _executeMessageSending(
                                    userText:l10n.chat_special_story_trigger(eggData['title']),
                                    overridePrompt: eggData['prompt'], // 對齊了！
                                  );
                                },
                              )));
                    }),

                    // 📖 2. 劇情摘要
                    _buildToolItem(Icons.article_outlined,l10n.chat_tool_story, () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StorySummaryPage(
                            character: _currentCharacter,
                          ),
                        ),
                      );
                    }),

                    // 🖼️ 3. 照片
                    _buildToolItem(Icons.photo_library_outlined, l10n.chat_tool_photo, () {
                      Navigator.pop(context);
                      _pickImage();
                    }),

                    // 🎙️ 4. 錄音切換鍵 (按下去就會把 showRecordingUI 變成 true)
                    _buildToolItem(Icons.mic_none, l10n.chat_tool_record, () {
                      sheetSetState(() => showRecordingUI = true);
                    }),

                    // 🪪 5. 拾光檔案
                    _buildToolItem(Icons.badge_outlined,l10n.chat_tool_profile, () {
                      Navigator.pop(context);
                      UserProfilePopup.show(context, onSaved: () {
                        _checkProfileCompletion();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.chat_profile_updated_msg),
                            backgroundColor: Colors.grey[800],
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      });
                    }),
                    // 👆 6. 互動玩法
                    _buildToolItem(Icons.touch_app_outlined, l10n.chat_tool_interact, () {
                      Navigator.pop(context);
                      _showInteractionMenu(context);
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildToolItem(IconData icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 32, color: theme.colorScheme.secondary),
          const SizedBox(height: 8),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildRichTextMessage(String text, {required TextStyle normalStyle, required TextStyle actionStyle}) {
    final regex = RegExp(r'/\*(.*?)\*/', dotAll: true);
    final spans = <TextSpan>[];
    int lastMatchEnd = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start), style: normalStyle));
      }
      final actionContent = match.group(1) ?? '';
      spans.add(TextSpan(text: '*$actionContent*', style: actionStyle));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: normalStyle));
    }
    if (spans.isEmpty) {
      return Text(text, style: normalStyle);
    }
    return RichText(text: TextSpan(children: spans));
  }
  ImageProvider _getAvatarProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  Widget _buildTypingIndicator() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: _getAvatarProvider(_currentCharacter.avatarPath),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
             l10n.chat_typing_indicator,
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha:0.7),
                  fontStyle: FontStyle.italic
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _insertActionMarkdown() {
    final controller = _textController;
    final text = controller.text;
    final selection = controller.selection;
    const markdown = '（）';
    final newPosition = selection.baseOffset + 1;
    if (selection.baseOffset < 0) {
      controller.text = text + markdown;
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length - 1));
      return;
    }
    final newText = text.substring(0, selection.baseOffset) + markdown + text.substring(selection.extentOffset);
    controller.text = newText;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: newPosition));
  }

  int _getNextStageThreshold(int currentScore) => _flowerStages.firstWhere((stage) => currentScore < stage.threshold, orElse: () => _flowerStages.last).threshold;
  FlowerStage _getCurrentStage(int currentScore) {
    return _flowerStages.lastWhere(
          (stage) => currentScore >= stage.threshold,
      // 🌟 找不到（例如負數）時，強制回傳列表中的第一個（通常是陌生/初識）
      orElse: () => _flowerStages.first,
    );
  }
  // ✨✨✨ 彈出模式選擇視窗 ✨✨✨
  Future<void> _showModeSelectionDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 定義每個模式的詳細資訊 (名稱、價格、說明)
    final modeDetails = [
      {
        'mode': ChatMode.daily,
        'title': l10n.chatModeDaily,
        'cost': '1 點',
        'desc': l10n.chat_mode_daily_desc,
        'icon': Icons.coffee,
        // ☕ 總裁指定：淡咖啡色 -> 我們用 Colors.brown.shade200，既有咖啡的溫暖又很輕盈
        'color': Colors.brown.shade200,
      },
      {
        'mode': ChatMode.story,
        'title': l10n.chatModeStory,
        'cost': '5 點',
        'desc': l10n.chat_mode_story_desc,
        'icon': Icons.book,
        // 📖 總裁指定：淡藍色 -> 我們用 Colors.blue.shade200，像晴空一樣的柔和藍色
        'color': Colors.blue.shade200,
      },
      {
        'mode': ChatMode.immersive,
        'title': l10n.chatModeImmersive,
        'cost': '7 點',
        'desc': l10n.chat_mode_immersive_desc,
        'icon': Icons.auto_awesome,
        // ✨ 總裁指定：淡黃色 -> 我們用 Colors.amber.shade200，自帶暖光卻不會刺眼
        'color': Colors.amber.shade200,
      },
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(l10n.chat_switch_mode_title, textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: theme.cardColor.withValues(alpha:0.95),
          children:<Widget>[
          ...modeDetails.map((info) {
            final mode = info['mode'] as ChatMode;
            final isSelected = _currentMode == mode;
            return SimpleDialogOption(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              onPressed: () async {
                setState(() {
                  _currentMode = mode;
                });
                if (_sessionId != null) {
                  // 🌟 修正 4：更新模式也要對準新家路徑
                  await FirebaseFirestore.instance
                      .collection('artifacts')
                      .doc(_appId)
                      .collection('chat_sessions')
                      .doc(_sessionId!)
                      .update({
                    'chatMode': mode.name,
                  });
                }
                Navigator.pop(context); // 關閉視窗
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? (info['color'] as Color).withValues(alpha:0.1) : Colors.transparent,
                  border: isSelected ? Border.all(color: info['color'] as Color, width: 2) : Border.all(color: Colors.grey.withValues(alpha:0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(info['icon'] as IconData, color: info['color'] as Color, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                info['title'] as String,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? (info['color'] as Color) : theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                info['cost'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info['desc'] as String,
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha:0.6)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Divider(color: theme.dividerColor.withValues(alpha:0.5)),
          ),

          // ☎️ 3. 專屬的「通話」按鈕登場！
            SimpleDialogOption(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24).copyWith(bottom: 16),
              onPressed: () {
                // 🌟 1. 先關閉對話框選單
                Navigator.pop(context);
                // 🌟 2. 判斷是否有聲線 ID
                if (widget.character.voiceId == null || widget.character.voiceId!.isEmpty) {
                  // 🎭 3. 跳出第一個 SnackBar：提示目前沒聲音 + 「戳一下」按鈕
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.chat_no_voice_msg(widget.character.name)),
                      backgroundColor: Colors.orangeAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 4), // 給玩家足夠時間去點按鈕
                      action: SnackBarAction(
                        label: l10n.chat_poke_btn,
                        textColor: Colors.white,
                        onPressed: () async {
                          // 🚀 4. 當玩家按下「戳一下」時執行的邏輯
                          try {
                            // 呼叫我們寫好的戳戳函式（把資料傳給雲端）
                            await _sendPoke(
                                widget.character.id,
                                widget.character.createdBy,
                                widget.character.name
                            );
                            // ✨ 5. 成功後，再跳出第二個溫馨 SnackBar 告訴玩家
                         if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.chat_poke_success),
                                  backgroundColor: Colors.pinkAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            debugPrint("戳戳失敗: $e");
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  // ✅ 6. 如果有聲線 ID，直接進入打電話流程
                  _handleCallPress(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha:0.05),
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha:0.3), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🌟 這裡要把妳的 1.6 倍大手機圖標放回來，不能只寫 widget
                    Transform.scale(
                      scale: 1.6,
                      child: Image.asset(
                        'assets/images/my_cute_phone_icon.png',
                        width: 32,
                        height: 32,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : theme.colorScheme.primary,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(l10n.chat_voice_call,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
        ),
            ),
            ),
          ],
        );
      },
    );
  }

  // 🎁 1. 質感升級版：使用 Flutter 內建 Icon 的小禮物清單
  // ✅ 把清單變成一個需要翻譯官的方法
  List<Map<String, dynamic>> _getGiftList(AppLocalizations l10n) {
    return [
      {'name': l10n.gift_heart, 'icon': Icons.favorite, 'color': Colors.redAccent, 'cost': 1},
      {'name': l10n.gift_flower, 'icon': Icons.local_florist, 'color': Colors.pinkAccent, 'cost': 1},
      {'name': l10n.gift_sun, 'icon': Icons.wb_sunny, 'color': Colors.orangeAccent, 'cost': 1},
      {'name': l10n.gift_confetti, 'icon': Icons.celebration, 'color': Colors.blueAccent, 'cost': 3},
      {'name': l10n.gift_coffee, 'icon': Icons.coffee, 'color': Colors.brown, 'cost': 5},
      {'name': l10n.gift_cake, 'icon': Icons.cake, 'color': Colors.purpleAccent, 'cost': 5},
    ];
  }

  // 💡 注意：這裡傳入的參數從 String characterName 變成了 整個 Character 物件！
  int _calculateGiftAffection(Character character, String giftName) {

    // 1️⃣ 檢查：這個禮物有沒有在他「喜歡」的清單裡？
    if (character.likedGifts != null && character.likedGifts!.contains(giftName)) {
      return 10; // 命中紅心！加很多好感度
    }

    // 2️⃣ 檢查：這個禮物有沒有在他「討厭」的清單裡？
    else if (character.dislikedGifts != null && character.dislikedGifts!.contains(giftName)) {
      return -5; // 踩到雷了！扣好感度
    }

    // 3️⃣ 預設：如果都不在清單上，就是普通的禮物
    return 2;
  }

  void _handleNotificationClick(RemoteMessage message) async {
    final data = message.data;
    if (data['type'] == 'chat') {
      final String charId = data['characterId'];

      // 🌟 1. 顯示一個轉圈圈 (或是透明 Overlay)，讓玩家知道在載入
      // showLoadingDialog();

      // 🌟 2. 先去資料庫把學長的「完整檔案」抓下來
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('characters') // 或是您存角色的路徑
          .doc(charId)
          .get();

      if (doc.exists) {
        // 將資料轉回 Character 物件 (假設您有 fromFirestore 函數)
        Character targetChar = await Character.fromFirestoreAsync(doc);

        // 🌟 3. 資料拿到了，這時候才跳轉！
        // 這樣進去 ChatPage 時，character 永遠有值，就不會報錯了！
        navigatorKey.currentState?.pushNamed(
          '/chat',
          arguments: targetChar, // 👈 這次我們直接傳整包物件過去！
        );
      }
    }
  }

  // 🚀 3. 執行送禮的終極合併函數 (內建雲端同步與好感度加分)
  void _handleSendGift(Map<String, dynamic> gift) {
    final l10n = AppLocalizations.of(context)!;
    // 1. 檢查花花點數夠不夠
    if (_flowerPoints < gift['cost']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.chat_gift_points_needed(gift['cost'].toString())),
            backgroundColor: Colors.redAccent
        ),
      );
      return;
    }

    int oldScore = _currentFriendship; // 👈 埋入偵測點 A：紀錄舊分數
    int affectionChange = _calculateGiftAffection(
        _currentCharacter, gift['name']);
    int newScore = oldScore + affectionChange; // 👈 計算新分數

    // 3. 🛡️ 啟動雲端同步！
    // 我們先扣除本地點數並加好感度 (讓玩家感覺「秒更新」)，同時非同步上傳 Firebase
    setState(() {
      _flowerPoints -= gift['cost'] as int; // 扣除花花點數
      _currentFriendship += affectionChange; // 玩家畫面愛心數字立刻跳動
    });

    // ☁️ 同步到 Firebase (使用 increment 確保資料精準)
    if (_sessionDocRef != null) {
      _sessionDocRef!.update({
        'friendshipScore': FieldValue.increment(affectionChange), // 雲端自動加分
        'lastActivity': FieldValue.serverTimestamp(),
      }).catchError((e) => print("❌ 雲端更新失敗: $e"));
    }
    _checkForLevelUp(oldScore, newScore); // 👈 埋入偵測點 B：把新舊分數丟進雷達！

    // 4. 判斷喜好程度的文字 (用來偷偷告訴 AI)
    String preferenceTag = "普通的";
    if (affectionChange >= 10) preferenceTag = "超級喜歡的";
    if (affectionChange < 0) preferenceTag = "有點討厭或無感的";

    // ✨ 5. 抓取玩家名字，讓沉浸感拉滿
    final user = FirebaseAuth.instance.currentUser;
    String playerName = user?.displayName ?? l10n.chat_you;

    // 📦 A 包：給玩家看的 (只會顯示這句)
    String displayText = l10n.chat_sys_gift(playerName, gift['name']);    // 📦 B 包：偷偷塞給 AI 的 (包含好感度與人設指令，不顯示在畫面上)
    String aiSecretPrompt = "【系統事件】$playerName送出了一個【${gift['name']}】。(系統隱藏提示：這是你『$preferenceTag』的禮物，好感度 $affectionChange。請根據角色性格與當前場景，給出最真實的反應。)";

    // 7. 關閉抽屜並發送訊息
    Navigator.pop(context); // 關閉送禮選單

    // 🚀 8. 呼叫我們剛升級的「經理」，把兩包文字都交給他！
    _sendMessage(
        text: displayText, // 👈 畫面上顯示這個
        secretPrompt: aiSecretPrompt // 👈 AI 腦袋裡看這個
    );
  }
  
  // 🕵️‍♀️ 稱號升級偵測器
  void _checkForLevelUp(int oldScore, int newScore) {
    // 條件 1：稱號文字變了
    // 條件 2：新分數必須「大於」舊分數 (這行就是只抓晉升的關鍵！✨)
    if (oldScore.relationshipTitle != newScore.relationshipTitle && newScore > oldScore) {
      _showLevelUpDialog(newScore, true); // 只有升級才會跳出華麗視窗
    }
  }

  // 🎨 華麗升級彈窗 (直接使用 class 內建的 context)
  void _showLevelUpDialog(int newScore, bool isUpgrade) {
    final l10n = AppLocalizations.of(context)!;
    // ✨ 判斷是否為「靈魂伴侶」等級 (根據總裁的 extension 門檻)
    bool isSoulmate = newScore >= 2430;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(
            width: 320, // 靈魂伴侶視窗稍微寬一點，更有份量
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.95),
              borderRadius: BorderRadius.circular(30),
              // ✨ 邊框發光特效
              border: isSoulmate
                  ? Border.all(color: Colors.amberAccent, width: 3) // 靈魂伴侶專屬金邊
                  : Border.all(color: newScore.titleColor.withValues(alpha:0.3), width: 1),
              boxShadow: [
                // 基礎陰影
                BoxShadow(
                    color: newScore.titleColor.withValues(alpha:0.3),
                    blurRadius: 20,
                    spreadRadius: 2
                ),
                // ✨ 靈魂伴侶額外增加一層「金色霓虹光暈」
                if (isSoulmate)
                  const BoxShadow(
                    color: Colors.amber,
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✨ 圖示：靈魂伴侶用大愛心，其他用星光
                Icon(
                    isSoulmate ? Icons.favorite : Icons.auto_awesome,
                    color: isSoulmate ? Colors.redAccent : newScore.titleColor,
                    size: 80 // 縮放一點點更有視覺衝擊
                ),
                const SizedBox(height: 16),
                Text(
                  isSoulmate ? l10n.chat_levelup_soulmate : l10n.chat_levelup_normal,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black87),
                ),
                const SizedBox(height: 12),

                // 稱號顯示盒
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSoulmate
                          ? [Colors.amber.withValues(alpha:0.4), Colors.orangeAccent.withValues(alpha:0.2)]
                          : [newScore.titleColor.withValues(alpha:0.2), newScore.titleColor.withValues(alpha:0.05)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    newScore.relationshipTitle(l10n),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSoulmate ? Colors.orange[900] : newScore.titleColor
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 真心話 (通用邏輯：直接抓 extension 裡的台詞)
                Text(
                  newScore.levelUpMessage(l10n),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.6
                  ),
                ),
                const SizedBox(height: 28),

                // 確定按鈕
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSoulmate ? Colors.amber[700] : newScore.titleColor,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                      isSoulmate ? l10n.chat_levelup_btn_soulmate :l10n.chat_levelup_btn_normal,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // 📍 定位處理：彈出一個選擇視窗，支援自訂地點！
  void _handleLocationSend() {
    final l10n = AppLocalizations.of(context)!;
    // 1. 先關閉原本滑出來的互動抽屜
    Navigator.pop(context);

    // 2. 準備一個控制器，用來抓取玩家自己輸入的文字
    TextEditingController customLocationController = TextEditingController();

    // 3. 彈出地點選擇視窗
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.chat_loc_title),
          content: SingleChildScrollView( // 避免鍵盤擋住畫面
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✨ 預設地點選單
                ...[l10n.chat_loc_1, l10n.chat_loc_2, l10n.chat_loc_3, l10n.chat_loc_4].map((loc) =>
                    ListTile(
                      title: Text(loc),
                      trailing: const Icon(Icons.send, size: 18, color: Colors.blue),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context); // 關閉視窗
                        _sendMessage(text: l10n.chat_player_sent_location(loc));                      },
                    )
                ),

                const Divider(height: 20), // 分隔線
                // ✨ 玩家自訂地點輸入框
                TextField(
                  controller: customLocationController,
                  decoration: InputDecoration(
                    hintText: l10n.chat_loc_hint,
                    hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // 如果玩家有輸入文字，就發送！
                if (customLocationController.text.trim().isNotEmpty) {
                  Navigator.pop(context); // 關閉視窗
                  _sendMessage(text: l10n.chat_player_sent_location(customLocationController.text.trim()));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child:  Text(l10n.chat_loc_custom_btn, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

// 🚀 執行拋硬幣/擲骰子（華麗視覺版）
  void _handleDiceRoll() async {
    final l10n = AppLocalizations.of(context)!;
    // 1. 🔍 抓取名字與設定點數
    final user = FirebaseAuth.instance.currentUser;
    String playerName = user?.displayName ?? l10n.chat_you; // 如果沒名字就叫「妳」
    String aiName = _currentCharacter.name;
    String aiTitle = _currentCharacter.occupation.isNotEmpty
        ? _currentCharacter.occupation
        :l10n.chat_opponent;

    final random = Random();
    int playerRoll = random.nextInt(6) + 1; // 1~6 點
    int aiRoll = random.nextInt(6) + 1; // 1~6 點

    // 關閉互動抽屜
    Navigator.pop(context);

    // ✨ ✨ ✨ 2. 顯示全螢幕骰子動畫 ✨ ✨ ✨
    // 我們利用 showDialog 來呈現一個暫時的動畫疊層
    await showDialog(
      context: context,
      barrierDismissible: false, // 必須等動畫完，不能點旁邊關閉
      barrierColor: Colors.black.withValues(alpha:0.5), // ✨ 把名字換成 barrierColor！
      builder: (context) {
        return DiceDuelOverlay(
          playerName: playerName,
          aiName: aiName,
          aiTitle: aiTitle, // ✨ 這裡把動態稱號傳進去！
          playerRoll: playerRoll,
          aiRoll: aiRoll,
        );
      },
    );

    // 3. ✨ 動態判斷結果（總裁勝負欲）
    String resultText = "";
    String aiActionPrompt = "";
    if (playerRoll > aiRoll) {
      resultText = "$playerName贏了！";
      // 如果學長輸了，要他耍賴或是無奈
      aiActionPrompt = "妳贏了！系統秘密指令：請根據你的傲嬌性格，表現出願賭服輸的無奈，或者是雖然輸了但嘴硬傲嬌耍賴的反應。請將這個反應融入對話中，並自然的開啟新話題。";
    } else if (aiRoll > playerRoll) {
      resultText = "${aiName}贏了！";
      // 如果學長贏了，要他得意
      aiActionPrompt = "你贏了！系統秘密指令：表現出獲勝後的得意洋洋，或是帶點寵溺的語氣取笑玩家的運氣壞，並自然的開啟新話題。";
    } else {
      resultText = "平手！";
      aiActionPrompt = "平手了。系統秘密指令：表現出驚訝或是有趣的反應，或是提議再擲一次，並自然的開啟新話題。";
    }
    // 4. 🔑 組裝「極簡沉浸版」咒語 (B包，偷偷塞給AI)
    String secretPrompt = "【系統事件】骰子對決！"
        "\n🎲 （$playerName擲出了 $playerRoll 點，妳擲出了 $aiRoll 點。結果：$resultText）"
        "\n[系統秘密指令：$aiActionPrompt]";
    // 5. 發送訊息 (A包顯示乾淨的文字，B包偷偷塞給AI)
    _sendMessage(
      text: l10n.chat_dice_duel_result(aiName), // 畫面上顯示這句就好
      secretPrompt: secretPrompt, // AI 腦袋裡看這個
    );
  }

  // 🎁 專屬互動抽屜 (連線成功版！)
  void _showInteractionMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final currentGiftList = _getGiftList(l10n);
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          // ✨ 1. 這裡會產生一個專屬的 scrollController
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                // 🐛 2. 修復 Bug：必須用上面傳下來的 scrollController，底板才能跟著手指滑動伸縮！
                controller: scrollController,
                // ✨ 3. 加入隱形感應網，捕捉「空白處」的點擊
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent, // 🌟 關鍵魔法：讓點擊事件可以穿透捕捉到「沒有元件的空白處」
                  onTap: () {
                    Navigator.pop(context); // 點擊空白處就收起選單！
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 頂部小橫條
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      Text(l10n.chat_interact_title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      // 🏃‍♀️ 玩法 1：肢體互動
                      Text(l10n.chat_interact_action, style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildActionChip(context, '👉', l10n.chat_action_poke, l10n.chat_action_poke_prompt),
                          _buildActionChip(context, '🫂', l10n.chat_action_hug, l10n.chat_action_hug_prompt),
                          _buildActionChip(context, '🤝', l10n.chat_action_hand, l10n.chat_action_hand_prompt),
                        ],
                      ),
                      const Divider(height: 30),
                      // 🎁 玩法 2：送小禮物
                      Text(l10n.chat_interact_gift, style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.8,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: currentGiftList.length,
                        itemBuilder: (context, index) {
                          final gift = currentGiftList[index];
                          return ActionChip(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            avatar: Icon(gift['icon'] as IconData, color: gift['color'] as Color, size: 18),
                            label: Text(
                              '${gift['name']} (${gift['cost']})',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                            backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha:0.5),
                            side: BorderSide(color: Colors.grey.withValues(alpha:0.1)),
                            onPressed: () => _handleSendGift(gift),
                          );
                        },
                      ),
                      const Divider(height: 30),
                      // 📍 其他功能
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on, color: Colors.blue, size: 22),
                        title: Text(l10n.chat_menu_send_location, style: TextStyle(fontSize: 14)),
                        onTap: () => _handleLocationSend(),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.casino, color: Colors.orange, size: 22),
                        title: Text(l10n.chat_dice_btn, style: TextStyle(fontSize: 14)),
                        onTap: () => _handleDiceRoll(),
                      ),
                      // ✨ 讓底部有更多空白，玩家點這裡也能關閉
                      const SizedBox(height: 150),
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

// 提取出 ActionChip 建造器，讓程式碼更乾淨
  Widget _buildActionChip(BuildContext context, String emoji, String label, String message) {
    return ActionChip(
      avatar: Text(emoji),
      label: Text(label),
      onPressed: () {
        Navigator.pop(context);
        _sendMessage(text: message);
      },
    );
  }

  // ✨ 截圖專用的底部按鈕列
  Widget _buildScreenshotBottomBar() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        // ✅ 支援最新 Flutter 語法
        color: theme.cardColor.withValues(alpha: 0.9),
        boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(0, -1), color: Colors.black12)],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isScreenshotMode = false;
                  _selectedMessageIds.clear();
                });
              },
              child: Text(l10n.cancel, style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            Text(
              l10n.selectedMessagesCount(_selectedMessageIds.length),
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.share, size: 18),
              label: Text(l10n.screenshotShare),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedMessageIds.isEmpty ? Colors.grey : Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _selectedMessageIds.isEmpty ? null : _generateAndShareImage,
            ),
          ],
        ),
      ),
    );
  }

// 📸 2. 在幕後畫一張美美的長圖畫布 (防爆裝甲與括弧校正版)
  Widget _buildScreenshotCanvas(List<ChatMessage> selectedMsgs) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12), // 🌟 底部 padding 縮小到 12，切得更緊！
            decoration: BoxDecoration(
              // 🌟 背景根據主題抓取：使用 primaryContainer 做漸層起始
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primaryContainer.withValues(alpha:0.3), // 抓主題淡紫色
                  Colors.white, // 漸層到純白，看起來最乾淨
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🏆 頂部標題
                Text(
                  l10n.exclusiveMomentsWith(_currentCharacter.name),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 24),

                // 💬 渲染對話
                ...selectedMsgs.map((msg) {
                  final isUser = msg.sender == 'user';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          CircleAvatar(
                            backgroundImage: _getAvatarProvider(_currentCharacter.avatarPath),
                            radius: 16,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isUser ? theme.colorScheme.primary : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),
                const Divider(color: Colors.black12, height: 1), // 極細分割線
                const SizedBox(height: 12),

                // 🦋 底部浮水印：總裁親筆蝴蝶 SVG (確保路徑正確)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/butterfly_icon.svg',
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary.withValues(alpha: 0.8), // 跟隨主題色
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.downloadToUnlock,
                      style: TextStyle(
                        fontSize: 11,
                        // 讓文字顏色也自動抓取主題色，看起來才是一套的
                        color: theme.colorScheme.primary.withValues(alpha: 0.6),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// 📸 3. 喀嚓！正式拍照、預覽並分享
  Future<void> _generateAndShareImage() async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      final msgsToExport = _localMessages
          .where((m) => _selectedMessageIds.contains(m.id))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      // 🚀專屬 Hack：字數與換行【極致緊緻版】演算法！
      double canvasHeight = 150.0; // 基礎高度 (標題 + 頂部間距)
      for (var msg in msgsToExport) {
        canvasHeight += 45.0; // 每則訊息的頭像與氣泡基礎開銷
        // 文字精算：寬度 400 的畫布，扣掉邊距後，一行約 18-20 個中文字
        // 每行高度抓 28 像素 (含行距)
        List<String> paragraphs = msg.text.split('\n');
        for (var p in paragraphs) {
          int lines = (p.length / 18).ceil();
          if (lines == 0) lines = 1;
          canvasHeight += (lines * 28.0);
        }
        canvasHeight += 12.0; // 訊息間的額外間距
      }

      canvasHeight += 80.0; // 底部浮水印與最後的緩衝空間

      // 📸 拍照！關鍵在於：不要讓內容被螢幕高度限制住
      final Uint8List imageBytes = await _screenshotController.captureFromWidget(
        // 🌟 核心修正：加上 UnconstrainedBox，讓畫布可以無限向下延伸，徹底消滅黃黑線！
        UnconstrainedBox(
          clipBehavior: Clip.hardEdge,
          child: _buildScreenshotCanvas(msgsToExport),
        ),
        delay: const Duration(milliseconds: 200),
        targetSize: Size(400, canvasHeight),
      );

      if (mounted) Navigator.pop(context); // 關閉 Loading

      // 🌟 預覽視窗
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title:  Text(l10n.exclusiveMomentsGenerated, style: TextStyle(fontWeight: FontWeight.bold)),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(imageBytes),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.selectAgain, style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download, size: 18),
                  label: Text(l10n.downloadAndShare),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(dialogContext);

                    final xFile = XFile.fromData(
                      imageBytes,
                      mimeType: 'image/png',
                      name: 'lianlian_screenshot.png',
                    );

                    await Share.shareXFiles(
                        [xFile],
                        text: l10n.inviteToMeet(_currentCharacter.name)
                    );

                    setState(() {
                      _isScreenshotMode = false;
                      _selectedMessageIds.clear();
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("❌ 截圖失敗: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // 🚨 只有極端情況才給全螢幕載入
    if (widget.character.name == l10n.chat_loading_status) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final int nextStageThreshold = _getNextStageThreshold(_currentFriendship);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 👈 鍵盤消失術！
      },
      // 👇 🌟 總裁，魔法 Container 包在最外面 👇
      child: Container(
        decoration: themeNotifier.characterChatBackground, // 📸 這裡負責顯示專屬照片或預設漸層
        child: Scaffold(
          backgroundColor: Colors.transparent, // 🚩 這裡必須透明，照片才透得過來
          appBar: AppBar(
            title: Text(_currentCharacter.name),
            backgroundColor: theme.appBarTheme.backgroundColor?.withValues(alpha:0.5), // 半透明 AppBar
            elevation: 0,
            foregroundColor: theme.colorScheme.onBackground,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                offset: const Offset(0, 50),
                color: theme.cardColor.withValues(alpha:0.95),
                onSelected: (value) async {
                  switch (value) {
                    case 'search':
                      final String? selectedMessageId = await showSearch<String>(
                        context: context,
                        delegate: ChatHistorySearchDelegate(_localMessages),
                      );
                      if (selectedMessageId != null) {
                        _jumpToMessage(selectedMessageId);
                      }
                      break;
                    case 'gallery':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BackgroundSettingsPage(
                            character: _currentCharacter,
                            characterId: _currentCharacter.id,
                            currentFriendship: _currentFriendship,
                          ),
                        ),
                      );
                      break;
                    case 'about_me':
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMePage(character: _currentCharacter)));
                      break;
                    case 'memo':
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MemoPage(character: _currentCharacter)));
                      break;
                    case 'period':
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodTrackerPage(character: _currentCharacter)));
                      break;
                    case 'reset':
                      _resetChat();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'search',
                    child: ListTile(
                      leading: const Icon(Icons.search),
                      title: Text(l10n.chat_menu_search),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'gallery',
                    child: ListTile(
                      leading: const Icon(Icons.wallpaper, color: Colors.purple),
                      title: Text(l10n.chat_menu_gallery),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'about_me',
                    child: ListTile(
                      leading: const Icon(Icons.face_retouching_natural, color: Colors.pinkAccent),
                      title: Text(l10n.chat_menu_aboutme),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'memo',
                    child: ListTile(
                      leading: const Icon(Icons.note_alt_outlined, color: Colors.orange),
                      title: Text(l10n.chat_menu_memo),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'period',
                    child: ListTile(
                      leading: const Icon(Icons.water_drop_outlined, color: Colors.redAccent),
                      title: Text(l10n.chat_menu_period),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'reset',
                    child: ListTile(
                      leading: const Icon(Icons.restart_alt_rounded, color: Colors.red),
                      title: Text(l10n.chat_menu_reset, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 👇 🌟 移除了原本擋在前面的內層背景，直接放 Column
          body: Column(
            children: [
              // ✨ 1. 頂部狀態欄 (好感度與模式)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha:0.5),
                  border: Border(bottom: BorderSide(color: theme.dividerColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _currentMode == null
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : (_currentMode == ChatMode.gemini
                        ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha:0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withValues(alpha:0.3), width: 1),
                      ),
                      child: Text(
                        _getModeName(_currentMode!, l10n),
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha:0.7),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                        : InkWell(
                      onTap: _showModeSelectionDialog,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha:0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha:0.5), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getModeName(_currentMode!, l10n),
                              style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_drop_down, size: 16, color: theme.colorScheme.onSurface),
                          ],
                        ),
                      ),
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 1. ☁️ 好感度
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  _getCurrentStage(_currentFriendship.clamp(0, 9999)).imagePath,
                                  height: 28,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 6),
                                // 🌟 2. 文字顯示：這裡「不要鎖」，就是要讓玩家看到負數！
                                Text(
                                  "$_currentFriendship / $nextStageThreshold",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface.withValues(alpha:0.8),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _currentFriendship.relationshipTitle(l10n),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: _currentFriendship.titleColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // 2. 🌹 花花點數
                        InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StorePage())),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                Image.asset(
                                  Theme.of(context).brightness == Brightness.dark
                                      ? 'assets/images/flower_gift_dark.png'
                                      : 'assets/images/flower_gift.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _formatPoints(_flowerPoints),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ✨ 2. 中間訊息列表
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_sessionId == null || _messagesCollection == null)
                    ? Center(child: Text(l10n.chat_loading_failed))
                    : widget.isTestMode
                    ? (_testMessages.isEmpty && !_isGenerating
                    ? Center(child: Text(l10n.chat_test_mode_msg))
                    : _buildMessageList(_testMessages))
                    : StreamBuilder<QuerySnapshot>(
                  stream: _messagesCollection!.orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    if (snapshot.hasError) return Center(child: Text(l10n.chat_error_load_msg(snapshot.error.toString())));
                    final messages = snapshot.data!.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
                    _localMessages = messages;
                    if (messages.isEmpty && !_isGenerating) {
                      return Center(child: Text(l10n.chat_empty_msg));
                    }
                    return _buildMessageList(messages);
                  },
                ),
              ),
          if (_isScreenshotMode)
        // 如果是截圖模式，就顯示專屬操作列
        _buildScreenshotBottomBar()
        else ...[
              // ✨ 3. 底部()快捷鍵區
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                color: theme.cardColor.withValues(alpha:0.5),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: (_isGenerating || _isLoading) ? null : () {
                        final text = _textController.text;
                        final selection = _textController.selection;
                        int cursorPosition = selection.baseOffset;
                        if (cursorPosition == -1) {
                          cursorPosition = text.length;
                        }
                        final newText = text.substring(0, cursorPosition) + '（）' + text.substring(cursorPosition);
                        _textController.value = TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(offset: cursorPosition + 1),
                        );
                        _focusNode.requestFocus();
                      },
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                      child: const Text('（）'),
                    ),
                  ],
                ),
              ),
              // ✨ 4. 底部輸入框與發送區
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: const [BoxShadow(blurRadius: 2, offset: Offset(0, -1), color: Colors.black12)],
                ),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cloud_outlined),
                        onPressed: (_isGenerating || _isLoading) ? null : _showToolbox,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _textController,
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0, top: 4.0),
                                  child: Text(
                                    '${value.text.length}/900',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: value.text.length >= 900 ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                            TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              onChanged: (text) {
                                _saveDraft(text);
                              },
                              readOnly: (_isGenerating || _isLoading),
                              minLines: 1,
                              maxLines: 4,
                              maxLength: 900,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: _isGenerating ? l10n.chat_ai_typing : l10n.chat_input_hint_default,
                                border: InputBorder.none,
                                counterText: "",
                                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: _isGenerating
                            ? const Icon(Icons.stop_circle_outlined, color: Colors.red)
                            : Icon(Icons.send, color: theme.colorScheme.primary),
                        // 🌟 載入中也不要讓玩家點發送
                        onPressed: (_isGenerating || _isLoading) ? _stopGenerating : () => _sendMessage(text: _textController.text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
    ],
          ),
        ),
      ),
    );
  }

// 🗓️ 小工具 1：判斷是不是同一天 (支援 Firebase 版)
  bool _isSameDay(Timestamp ts1, Timestamp ts2) {
    final dt1 = ts1.toDate(); // ✨ 把 Firebase 時間轉成一般時間
    final dt2 = ts2.toDate();
    return dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }

  // 🗓️ 小工具 2：格式化日期 (例如：3/27 (五))
  String _getDateString(Timestamp ts) {
    final l10n = AppLocalizations.of(context)!;
    final dt = ts.toDate(); // ✨ 轉換魔法
    final weekdays = [
      l10n.weekday_mon, l10n.weekday_tue, l10n.weekday_wed,
      l10n.weekday_thu, l10n.weekday_fri, l10n.weekday_sat, l10n.weekday_sun
    ];
    return "${dt.month}/${dt.day} ${weekdays[dt.weekday - 1]}";
  }

  // ⏰ 小工具 3：格式化時間 (例如：14:23)
  String _getTimeString(Timestamp ts) {
    final dt = ts.toDate(); // ✨ 轉換魔法
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _chatScrollController,
      reverse: true, // 👈 畫面是由下往上畫的
      padding: const EdgeInsets.all(8.0),
      itemCount: messages.length + (_isGenerating ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isGenerating && index == 0) {
          return _buildTypingIndicator();
        }

        final messageIndex = _isGenerating ? index - 1 : index;
        final message = messages[messageIndex];
        final sender = message.sender;
        final type = message.type;

        // 📸 🌟 截圖模式核心變數：判斷這句話有沒有被玩家打勾
        final isSelected = _selectedMessageIds.contains(message.id);

        // ✨ 判斷要不要顯示「日期分界線」
        bool showDateHeader = false;
        if (messageIndex == messages.length - 1) {
          showDateHeader = true;
        } else {
          final olderMessage = messages[messageIndex + 1];
          if (!_isSameDay(message.timestamp, olderMessage.timestamp)) {
            showDateHeader = true;
          }
        }

        Widget finalMessageWidget; // 用來裝這整列訊息 (包含頭像、氣泡、時間)

        // ✨ 系統故事開頭
        if (sender == 'system') {
          finalMessageWidget = Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 48.0),
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha:0.6),
              borderRadius: BorderRadius.circular(12),
              border: _highlightedMessageId == message.id
                  ? Border.all(color: Colors.yellowAccent, width: 2.5) // 🌟 這裡加上邊框發光！
                  : null,
            ),
            child: Text(
              message.text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha:0.8),
              ),
            ),
          );
        }
        else {
          final isUserMessage = sender == 'user';
          final avatar = CircleAvatar(
            backgroundImage: _getAvatarProvider(_currentCharacter.avatarPath),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[300],
          );

          Widget messageContent;

          // 💬 根據型態畫出對話氣泡
          if (type == 'text') {
            final normalStyle = TextStyle(color: isUserMessage ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant);
            final actionStyle = TextStyle(color: (isUserMessage ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant).withValues(alpha:0.7));
            messageContent = Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUserMessage ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: _highlightedMessageId == message.id
                    ? Border.all(color: Colors.yellowAccent, width: 2.5) // 🌟 這裡也加上發光！
                    : null,
              ),
              child: _buildRichTextMessage(message.text, normalStyle: normalStyle, actionStyle: actionStyle),
            );
          }
          else if (type == 'image') {
            messageContent = ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: kIsWeb
                    ? Image.network(message.path, fit: BoxFit.cover)
                    : Image.file(File(message.path), fit: BoxFit.cover),
              ),
            );
          }
          else {
            final Color iconColor = isUserMessage ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant;
            final Color textColor = isUserMessage ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant;
            messageContent = Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUserMessage ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(onTap: () => _playAudio(message.path), child: Icon(Icons.play_arrow, color: iconColor)),
                  const SizedBox(width: 8),
                  Text(l10n.chat_voice_msg_label, style: TextStyle(color: textColor))
                ],
              ),
            );
          }

          // ⏰ 把「時間」貼到氣泡旁邊
          Widget timeWidget = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              _getTimeString(message.timestamp),
              style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha:0.5)),
            ),
          );

          if (isUserMessage) {
            // 🚩 這裡拿掉了原本的 GestureDetector，移到最外層統一管理
            finalMessageWidget = Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  timeWidget,
                  Flexible(child: messageContent),
                ],
              ),
            );
          } else {
            // 🚩 這裡也拿掉了原本的 GestureDetector，移到最外層統一管理
            finalMessageWidget = Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 頭像點擊功能保留
                  GestureDetector(
                    onTap: () {
                      _navigateToProfileFromChat(
                          widget.character.id,
                          widget.character.name,
                          widget.character.avatarPath
                      );
                    },
                    child: avatar,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(child: messageContent),
                        timeWidget,
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }

        // ✨✨✨ 終極包裝：截圖勾選外殼 ✨✨✨
        final wrappedMessage = GestureDetector(
          behavior: HitTestBehavior.translucent, // 確保點擊空白處也能感應到
          onLongPress: () => _showMessageOptions(message), // 長按依然呼叫妳的底部選單
          onTap: () {
            // 🚩 短按：如果正在截圖模式，就執行勾選/取消
            if (_isScreenshotMode) {
              setState(() {
                if (isSelected) {
                  _selectedMessageIds.remove(message.id);
                  // 如果全部取消了，就自動關閉截圖模式
                  if (_selectedMessageIds.isEmpty) _isScreenshotMode = false;
                } else {
                  _selectedMessageIds.add(message.id);
                }
              });
              HapticFeedback.lightImpact(); // 輕微震動回饋
            }
          },
          child: Container(
            // 勾選時的紫色背景遮罩
            color: (_isScreenshotMode && isSelected)
                ? theme.colorScheme.primary.withValues(alpha:0.15)
                : Colors.transparent,
            child: Row(
              children: [
                // 📸 截圖模式下的勾選按鈕
                if (_isScreenshotMode)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? theme.colorScheme.primary : Colors.grey,
                      size: 22,
                    ),
                  ),
                // 右側放對話內容
                Expanded(
                  child: IgnorePointer(
                    // 🚨 總裁防呆機制：在截圖模式下，暫停內部元件的點擊（如頭像或語音），專心選取對話
                    ignoring: _isScreenshotMode,
                    child: finalMessageWidget,
                  ),
                ),
              ],
            ),
          ),
        );

        // ✨ 最終大組合：把日期和對話組合起來
        if (showDateHeader) {
          return Column(
            children: [
              // 灰色日期標籤
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getDateString(message.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
              // 下面接著畫剛才包裝好的對話
              wrappedMessage,
            ],
          );
        }

        return wrappedMessage;
      },
    );
  }
}

// 🔍 這是 Flutter 內建的搜尋委託器，超好用！
class ChatHistorySearchDelegate extends SearchDelegate<String> {
  final List<dynamic> chatHistory; // 接收妳目前的歷史對話清單

  ChatHistorySearchDelegate(this.chatHistory);

  // 1. 搜尋列右邊的按鈕 (通常是 X，用來清除輸入)
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // 清空輸入框
        },
      ),
    ];
  }

  // 2. 搜尋列左邊的按鈕 (通常是返回鍵)
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // 關閉搜尋畫面
      },
    );
  }

  // 3. 玩家按下 Enter 後顯示的結果 (這裡我們跟即時建議用同一個畫面就好)
  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  // 4. 玩家邊打字邊顯示的「即時搜尋結果」
  @override
  Widget buildSuggestions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // 如果玩家還沒打字，給一個溫馨提示
    if (query.isEmpty) {
      return Center(
        child: Text(l10n.chat_search_hint, style: TextStyle(color: Colors.grey)),
      );
    }

    // 🕵️ 篩選邏輯：把包含「關鍵字(query)」的對話抓出來！
    // 注意：這裡假設妳的對話物件裡面有 text 這個屬性，如果妳的叫 message 或是 content，請記得改！
    final matchQuery = chatHistory.where((msg) {
      return msg.text.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // 如果找不到
    if (matchQuery.isEmpty) {
      return Center(child: Text(l10n.chat_search_empty));
    }

    // 畫出搜尋結果清單
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var match = matchQuery[index];
        bool isPlayer = !match.isAI; // 判斷是不是玩家說的話 (請依妳的變數名稱調整)

        return ListTile(
          leading: Icon(
            isPlayer ? Icons.face : Icons.favorite,
            color: isPlayer ? Colors.blue : Colors.purple,
          ),
          title: Text(match.text, maxLines: 2, overflow: TextOverflow.ellipsis), // 只顯示兩行預覽
          subtitle: Text(isPlayer ? l10n.chat_search_you: l10n.chat_search_him, style: const TextStyle(fontSize: 12)),
          // 在 ChatHistorySearchDelegate 的 buildSuggestions 裡面修改 onTap
          onTap: () {
            // 🌟 關鍵：我們不只傳文字，而是把整個訊息 ID 或是物件傳回去
            // 這樣 ChatPage 才知道要找哪一個「座標」
            close(context, match.id);
          },
        );
      },
    );
  }
}

extension AffectionLevelExtension on int {
  // ✨ 把 get 拿掉，改成需要傳入翻譯官 (l10n) 的方法
  String relationshipTitle(AppLocalizations l10n) {
    // 💖 正數區間
    if (this >= 2430) return l10n.rel_title_soulmate;
    if (this >= 1720) return l10n.rel_title_lover;
    if (this >= 550)  return l10n.rel_title_ambiguous;
    if (this >= 150)  return l10n.rel_title_friend;
    if (this >= 60)   return l10n.rel_title_acquaintance;
    if (this >= 0)    return l10n.rel_title_stranger;

    // 💔 負數區間
    if (this >= -150)  return l10n.rel_title_tense;
    if (this >= -550)  return l10n.rel_title_avoiding;
    if (this >= -1720) return l10n.rel_title_hostile;
    return l10n.rel_title_nemesis;
  }

  // 🎨 顏色不需要翻譯，維持原本的 get 寫法就好
  Color get titleColor {
    if (this >= 1720) return Colors.redAccent;
    if (this >= 550)  return Colors.pinkAccent;
    if (this < 0)     return Colors.blueGrey;
    return Colors.black87;
  }

  // ✨ 同樣把 get 拿掉，改成需要傳入翻譯官的方法
  String levelUpMessage(AppLocalizations l10n) {
    if (this >= 2430) return l10n.rel_msg_soulmate;
    if (this >= 1720) return l10n.rel_msg_lover;
    if (this >= 550)  return l10n.rel_msg_ambiguous;
    if (this >= 150)  return l10n.rel_msg_friend;
    if (this >= 60)   return l10n.rel_msg_acquaintance;
    return l10n.rel_msg_stranger;
  }
}
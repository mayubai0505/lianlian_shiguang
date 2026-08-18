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
import '../services/toast_utils.dart';
import '../utils/character_navigator.dart';
import 'about_us_page.dart';
import 'call_screen.dart';
import 'login_page.dart';
import 'user_profile_popup.dart';
import 'package:lianlian_shiguang/main.dart';
import '../services/theme_notifier.dart';
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
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'feedback_page.dart';

//聊天頁面ˋ
enum ChatMode { daily, story, immersive, gemini }

class FlowerStage {
  final int threshold;
  final String imagePath;
  const FlowerStage({required this.threshold, required this.imagePath});
}

class ChatMessage {
  final String id; // 資料庫的 ID
  final String sender; // 'user' 或 'ai'
  String text; // 👈 拿掉 final，這樣 AI 說話時才能「一段一段加進去」
  final String type; // 'text', 'image', 'audio'
  final String path; // 圖片或音檔的路徑
  final Timestamp timestamp;
  final bool isAI; // 方便 UI 判斷要靠左還是靠右

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.type = 'text', // 預設為純文字
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
  final bool forceNewRoom;
  final String? initialText;
  final String characterId;

  const ChatPage({
    super.key,
    this.charIdFromPush,
    required this.character,
    this.chatMode,
    this.sessionId,
    this.isTestMode = false,
    required this.selectedLanguage,
    this.initialText,
    this.forceNewRoom = false,
    required this.characterId,
  }) : assert(chatMode != null || sessionId != null,
            'Either chatMode or sessionId must be provided');

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 在 _ChatPageState 的變數宣告區加上這行：
  final Map<String, String> _imageDownloadUrlCache = {};
  bool _hasLoadedBirthdayFreeStatus = false;
  bool _hasPromptedProfileSetup = false; // 用來記住「已經問過玩家了」
  Map<String, dynamic>? _roomConfig;
  bool _isMonthlyPassActive = false;
  bool _isBirthdayFreeToday = false;
  // 七夕限定聊天室
  bool _isQixiRoom = false;
  bool _isQixiProgressExpanded = false;
  List<String> _qixiInteractionDates = [];
  bool _isGeneratingQixiOpening = false;
  bool _hasRequestedQixiOpeningThisVisit = false;
  bool _qixiLetterSent = false;
  final Map<String, String> _imageUrlCache = {};
  bool _isInputFocused = false;
  bool _isLoadingRoom = true;
  final List<Map<String, dynamic>> _pendingMediaMessages = [];
  final Map<String, String> _audioDownloadUrlCache = {};
  bool _isChecking = false; // 也要記得保留原本檢查中的狀態變數
  String _userProfileText = ""; // 用來顯示檔案內容的變數
  String? _selectedChatImagePath;
  bool _waitingForNewAiReply = false;
  int _watermarkStyle = 0;
  DateTime? _lastUserSendTime;
  // 🌟 請確保這行加在這裡！這樣整個頁面才都認識它
  int _maxRegenerateCount = 3;
  bool _isMultiSelectMode = false;
  static Set<String> generatingRooms = {};
  // 🌟 總裁的聊天室監控探針
  bool _isReferralTrackerActive = false; // 是否需要啟動邀請計數器
  int _currentReferralChatCount = 0; // 本次上線聊了幾句
  int _freeRegenerateCount = 3; // 預設免費 3 次
  bool _hasMonthlyPass = false; // 是否有買月卡 (預設沒有)
  // ✨ 截圖模式專用變數
  bool _isScreenshotMode = false; // 是否正在截圖模式中？
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
  StreamSubscription? _recorderSub;
  StreamSubscription? _qixiProgressSubscription;
  bool _isRecordingVoice = false;
  bool _isPreviewPlaying = false;
  String? _recordingFilePath;
  String? _pendingAudioPath;
  double _recordDb = -60.0;
  Duration _recordDuration = Duration.zero;
  final AudioPlayer _voicePreviewPlayer = AudioPlayer();
  // --- 狀態變數 ---
  bool _isGenerating = false; // 正在生成中
  bool _isRegenerating = false;
  String? _selectedImagePath;
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
  String? _activeAiRequestId;
  String _createAiRequestId() {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    return '${userId}_${DateTime.now().microsecondsSinceEpoch}';
  }

  String? _sessionId;
  late final String _testSessionId;
  bool _isLoading = true;
  String? _currentStoryTime; //時間
  String? _currentStoryLocation; //地點
  String? _highlightedMessageId; // 🌟 用來記住現在要「發光」的是誰
  String _playerNickname = "玩家"; // ✨ 新增：專門用來記住玩家的暱稱，方便替換字串！
  List<ChatMessage> _localMessages = [];
  String? _userId;
  Map<String, dynamic> _currentAiProfile = {'type': 'basic', 'name': '玩家'};
  String get _roomLockKey {
    final sid = (_sessionId ?? widget.sessionId ?? '').trim();
    return sid.isNotEmpty ? sid : widget.character.id;
  }

  // 🌟 在 _ChatPageState 裡面補上這個工具
  String _formatPoints(int points) {
    final safePoints = points < 0 ? 0 : points;
    // 如果妳沒裝 intl 套件，就先用最簡單的 toString()
    // 如果有裝，可以用 NumberFormat('#,##0').format(safePoints)
    return safePoints.toString();
  }

  Widget _buildQixiProgressCard(ThemeData theme) {
    final int completedCount = _qixiInteractionDates.length.clamp(0, 3);
    final l10n = AppLocalizations.of(context)!;
    final taipeiNow = DateTime.now().toUtc().add(const Duration(hours: 8));

    final todayKey = DateFormat('yyyy-MM-dd').format(taipeiNow);

    final bool todayCompleted = _qixiInteractionDates.contains(todayKey);

    String progressMessage;

    if (_qixiLetterSent) {
      progressMessage = l10n.chatQixiLetterSent;
    } else if (completedCount >= 3) {
      progressMessage = l10n.chatQixiLetterPendingTonight;
    } else if (todayCompleted) {
      progressMessage = l10n.chatQixiTodayCompleted;
    } else {
      progressMessage = l10n.chatQixiTodayNotCompleted;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFEDF4).withValues(alpha: 0.96),
            const Color(0xFFF0E9FF).withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5B8D0).withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAF7E9E).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 點這一列即可展開或收合
          InkWell(
            onTap: () {
              setState(() {
                _isQixiProgressExpanded = !_isQixiProgressExpanded;
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/qixi_chat_badge.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.favorite_rounded,
                        size: 24,
                        color: Color(0xFFE87AA5),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.chatQixiPromiseTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF68425F),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.chatQixiStarProgress(completedCount),
                    style: const TextStyle(
                      color: Color(0xFF9B4269),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _isQixiProgressExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: Color(0xFF806779),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 展開內容
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isQixiProgressExpanded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        l10n.chatQixiProgressRule,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF806779),
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: todayCompleted || completedCount >= 3
                              ? const Color(0xFFFFD6E5)
                              : const Color(0xFFE4DDEA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          progressMessage,
                          style: TextStyle(
                            color: todayCompleted || completedCount >= 3
                                ? const Color(0xFF9B4269)
                                : const Color(0xFF766B78),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          final bool isCompleted = index < completedCount;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(
                                  milliseconds: 300,
                                ),
                                child: Image.asset(
                                  isCompleted
                                      ? 'assets/images/qixi_progress_on.png'
                                      : 'assets/images/qixi_progress_off.png',
                                  key: ValueKey(
                                    'qixi_${index}_$isCompleted',
                                  ),
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.contain,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Icon(
                                      isCompleted
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      size: 32,
                                      color: isCompleted
                                          ? const Color(0xFFE87AA5)
                                          : const Color(0xFF9A8EA2),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                l10n.chatQixiDayNumber(index + 1),
                                style: TextStyle(
                                  color: isCompleted
                                      ? const Color(0xFF9B4269)
                                      : const Color(0xFF817684),
                                  fontSize: 10,
                                  fontWeight: isCompleted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ✨ 總裁級專屬：動態人設字串產生器
  String _buildDynamicUserProfileString() {
    // 防呆機制：如果沒有讀到，給個最基本的預設值
    final profile = _currentAiProfile;

    if (profile['type'] == 'advanced') {
      // 🎭 軌道 A：玩家有設定平行時空人設
      return """
【與你對話的主角當前時空設定】
- 稱呼：${profile['name'] ?? '未填寫'}
- 身高：${profile['height'] ?? '未填寫'}
- 外貌特徵：${profile['appearance'] ?? '未填寫'}
- 職業背景：${profile['occupation'] ?? '未填寫'}
- 個性與自我介紹：${profile['intro'] ?? '未填寫'}

請嚴格根據這個時空的具體設定與女主角互動，展現專屬默契。
""";
    } else {
      // 🛡️ 軌道 B：兜底機制，玩家按了「稍後填寫」
      return """
【與你對話的主角基本資料】
- 稱呼：${profile['name'] ?? '玩家'}
- 性別：${profile['gender'] ?? '未填寫'}
- 生日：${profile['birthday'] ?? '未填寫'}

說明：當前為基礎相識時空，主角尚未展露更多具體的職業或外貌細節。請你以自然的語調與她交流，並在對話中逐步探索。
""";
    }
  }

  @override
  void initState() {
    super.initState();
    _testSessionId =
        'TEST_${FirebaseAuth.instance.currentUser?.uid ?? 'anonymous'}_'
        '${widget.character.id}_'
        '${DateTime.now().millisecondsSinceEpoch}';

    _focusNode.addListener(
      _handleInputFocusChange,
    );
    _isGenerating = generatingRooms.contains(_roomLockKey);
    _currentCharacter = widget.character;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      precacheImage(
        getAvatarImageProvider(_currentCharacter.avatarPath),
        context,
      );
    });
    // 1. 準備硬體設備 (維持原樣)
    _audioPlayer = AudioPlayer();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _userId = FirebaseAuth.instance.currentUser?.uid;

    // 🌟🌟🌟 總裁無敵星星：測試模式攔截器 🌟🌟🌟
    // 這裡我們直接幫妳把所有「開關」都打開，不讓它有機會去轉圈圈！
    if (widget.isTestMode) {
      _sessionId = _testSessionId;
      _currentCharacter = widget.character;
      _currentMode = ChatMode.daily;

      final DateTime now = DateTime.now();

      final String initialStory = (_currentCharacter.initialStory ?? '')
          .replaceAll(
            '{{玩家名字}}',
            _playerNickname,
          )
          .replaceAll(
            '(玩家名字)',
            _playerNickname,
          )
          .trim();

      final String firstLine = (_currentCharacter.firstLine ?? '')
          .replaceAll(
            '{{玩家名字}}',
            _playerNickname,
          )
          .replaceAll(
            '(玩家名字)',
            _playerNickname,
          )
          .trim();

      // 訊息列表採用「最新在前」的順序：
      // 第一個是角色開場白，第二個是較早出現的初始故事。
      if (firstLine.isNotEmpty) {
        _testMessages.add(
          ChatMessage(
            id: 'test_first_line_${now.microsecondsSinceEpoch}',
            sender: 'ai',
            text: firstLine,
            type: 'text',
            path: '',
            timestamp: Timestamp.fromDate(
              now.add(const Duration(milliseconds: 1)),
            ),
            isAI: true,
          ),
        );
      }

      if (initialStory.isNotEmpty) {
        _testMessages.add(
          ChatMessage(
            id: 'test_initial_story_${now.microsecondsSinceEpoch}',
            sender: 'system',
            text: initialStory,
            type: 'text',
            path: '',
            timestamp: Timestamp.fromDate(now),
            isAI: false,
          ),
        );
      }

      _isLoading = false;
      _loadRoomData();
      return;
    }
    // --- 下面是正常模式的邏輯，只有不是測試模式才會跑到這裡 ---
    // 🎯 總裁雷達防線：加在正常模式的第一槍！
    // 一進聊天室，立刻暗中偵測該玩家是不是「被邀請的新人」，如果是就打開計數器！
    _checkReferralEligibility();
    _loadDraft();
    _initHardware();
    _initRegenerateCount();
    _loadRegenerateCount();
// 🛡️ 總裁級防護罩：第一，確保畫面已經畫完 (保護 context 跟多國語言 l10n)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // 🌟 總裁級無縫接軌：有真實 ID 就用真實的，沒有就發放「臨時身分證」
        final String safeRoomId =
            widget.sessionId ?? 'draft_${widget.characterId}';

        // ✨ 直接放行！所有的檢查、兜底跟迎賓彈窗，都交給大腦去處理！
        _checkProfileCompletion(safeRoomId, widget.characterId);
      }
    });
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
    _focusNode.removeListener(
      _handleInputFocusChange,
    );
    _focusNode.dispose();
    _pointsSubscription?.cancel();
    _qixiProgressSubscription?.cancel();
    _audioPlayer.dispose();
    _triggerStorySummary(); //劇情摘要
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

  void _handleInputFocusChange() {
    if (!mounted) return;

    final bool isFocused = _focusNode.hasFocus;

    if (_isInputFocused == isFocused) return;

    setState(() {
      _isInputFocused = isFocused;
    });
  }

  Future<void> _loadRoomData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _isLoadingRoom = false;
        });
      }
      return;
    }

    // 測試聊天室沒有正式房間 ID，不讀取 rooms 資料
    if (widget.isTestMode ||
        widget.sessionId == null ||
        widget.sessionId!.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _roomConfig = null;
          _isLoadingRoom = false;
        });
      }

      debugPrint('🧪 測試聊天室：略過正式房間資料讀取');
      return;
    }

    final String sessionId = widget.sessionId!.trim();

    final roomRef =
        FirebaseFirestore.instance.collection('rooms').doc(sessionId).get();

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    final results = await Future.wait([
      roomRef,
      userRef,
    ]);

    final roomDoc = results[0];
    final userDoc = results[1];

    if (!mounted) return;

    setState(() {
      _roomConfig = roomDoc.data();

      final userData = userDoc.data() as Map<String, dynamic>?;
      final endDateStr = userData?['monthlySubEndDate'] as String?;

      _isMonthlyPassActive = _calculateIsActive(endDateStr);

      _isLoadingRoom = false;
    });

    _checkProfileCompletion(
      sessionId,
      widget.character.id,
    );

    _initRegenerateCount();
  }

// 輔助函式：判斷月卡是否有效
  bool _calculateIsActive(String? dateStr) {
    if (dateStr == null) return false;
    try {
      return DateTime.parse(dateStr).isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  // ✨ 總裁級迎賓流程：自動彈出與後續追蹤 (已升級安全 ID 裝甲)
  void _showWelcomeProfilePopup() {
    bool didSave = false; // 追蹤玩家有沒有乖乖存檔
    final l10n = AppLocalizations.of(context)!;
    // 🌟 總裁級修復：取得安全的房間 ID，保護新房間不崩潰！
    final String safeRoomId = widget.sessionId ?? 'draft_${widget.characterId}';
    UserProfilePopup.show(
      context,
      roomId: safeRoomId, // 🛡️ 換成安全的 ID
      characterId: widget.characterId,
      onSaved: () {
        didSave = true; // 玩家有按儲存！
        FirebaseFirestore.instance
            .collection('users')
            .doc(
              FirebaseAuth.instance.currentUser!.uid,
            )
            .set({
          // 全帳號已處理過第一次拾光檔案提示
          'hasHandledProfileIntro': true,

          // 舊版相容
          'hasSkippedProfile': true,
        }, SetOptions(merge: true));
        _checkProfileCompletion(
            safeRoomId, widget.characterId); // 🛡️ 這裡也換成安全的 ID
      },
    ).then((_) async {
      if (!didSave && mounted) {
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            // 全帳號已處理過第一次拾光檔案提示
            'hasHandledProfileIntro': true,

            // 舊版相容
            'hasSkippedProfile': true,
          }, SetOptions(merge: true));
        }

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              l10n.friendlyReminderTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              l10n.editProfileHint,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  l10n.common_got_it,
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _loadBirthdayFreeStatus() async {
    try {
      final bool result = await _isBirthdayFreeChatActive();

      if (!mounted) return;

      setState(() {
        _isBirthdayFreeToday = result;
        _hasLoadedBirthdayFreeStatus = true;
      });
    } catch (e) {
      debugPrint(
        '⚠️ 讀取生日免費狀態失敗：$e',
      );

      if (!mounted) return;

      setState(() {
        _hasLoadedBirthdayFreeStatus = true;
      });
    }
  }

  // ✨ 總裁專屬：全域共用的次數查帳系統
  Future<void> _initRegenerateCount() async {
    final user = FirebaseAuth.instance.currentUser;
    final String? regenerateSessionId = _sessionId ?? widget.sessionId;

    if (user == null || regenerateSessionId == null) return;

    try {
      // 🌟🌟🌟 總裁查水表：絕對不要相信本地變數，直接去雲端看最新狀態！
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data() ?? {};
      // 根據月卡到期日判斷是否仍有效
      final now = DateTime.now();

      bool hasPass = false;

      final endDateString = userData['monthlySubEndDate'] as String?;

      if (endDateString != null) {
        try {
          final endDate = DateTime.parse(endDateString);

          if (endDate.isAfter(now)) {
            hasPass = true;
          } else {
            // 避免每次都重複寫 Firestore
            if (userData['isMonthlySubscribed'] == true ||
                userData['monthlyCardStatus'] != 'expired') {
              await userDoc.reference.update({
                'isMonthlySubscribed': false,
                'monthlyCardStatus': 'expired',
              });
            }
          }
        } catch (e) {
          debugPrint("❌ monthlySubEndDate 格式錯誤: $e");
        }
      }
      final int maxCount = hasPass ? 20 : 3;
      final todayStr = DateTime.now().toString().substring(0, 10);

      // 1. 定義路徑 (宣告 docRef)
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('aiRequests')
          .doc(regenerateSessionId);

      // 2. 先去抓對話次數資料
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() ?? {};

      final lastDate = data['lastRegenerateDate'] as String?;
      int currentCount = data['regenerateCount'] as int? ?? maxCount;

      // 🌟🌟🌟 總裁霸氣補發：如果今天是同一天，且妳有月卡，但次數竟然可憐到 <= 3，代表妳是今天剛買的！
      if (hasPass && lastDate == todayStr && currentCount <= 3) {
        currentCount = maxCount; // 霸氣直接幫妳把次數灌滿到 20！

        // 順便把滿血的次數寫回雲端，以免下次進來又被扣
        await docRef.set({
          'regenerateCount': maxCount,
        }, SetOptions(merge: true));
      }

      if (currentCount > maxCount) {
        currentCount = maxCount;

        // 順便把校正後的次數寫回雲端，確保資料庫乾淨
        await docRef.set({
          'regenerateCount': maxCount,
        }, SetOptions(merge: true));
      }

      // 3. 判斷是否需要重置
      if (lastDate != todayStr) {
        // 🎉 新的一天 (或是全新對話)：補滿次數
        if (mounted) {
          setState(() {
            _hasMonthlyPass = hasPass; // 更新 UI 的狀態
            _maxRegenerateCount = maxCount;
            _freeRegenerateCount = maxCount;
          });
        }

        // 這時候才執行寫入
        await docRef.set({
          'regenerateCount': maxCount,
          'lastRegenerateDate': todayStr,
        }, SetOptions(merge: true));
      } else {
        // 🕰️ 同一天：讀取雲端現有的次數 (已經經過上面的 VIP 霸氣補發了！)
        if (mounted) {
          setState(() {
            _hasMonthlyPass = hasPass;
            _maxRegenerateCount = maxCount;
            _freeRegenerateCount = currentCount;
          });
        }
      }
    } catch (e) {
      debugPrint("❌ 讀取對話次數失敗: $e");
    }
  }

  String get _webPurchaseUnavailableMessage {
    final locale = Localizations.localeOf(context);

    if (locale.languageCode == 'zh') {
      final isSimplifiedChinese = locale.scriptCode == 'Hans' ||
          locale.countryCode == 'CN' ||
          locale.countryCode == 'SG';

      return isSimplifiedChinese
          ? '网页版目前不提供充值服务，请使用《恋恋拾光》App 购买花花或订阅。'
          : '網頁版目前不提供儲值服務，請使用《戀戀拾光》App 購買花花或訂閱。';
    }

    return 'Purchases are currently unavailable on the web version. '
        'Please use the LoveyDovey app to buy flowers or subscribe.';
  }

  void _showSubscriptionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.stars, color: Colors.pinkAccent),
            const SizedBox(width: 8),
            Text(l10n.starlightContractTitle),
          ],
        ),
        // 在 content 裡面：
        content: Text(
          '${l10n.dailyLimitReachedPrefix}'
          '${_hasMonthlyPass ? l10n.monthlyPassExhausted : l10n.subscribeMonthlyPassPrompt}'
          '${kIsWeb ? '\n\n$_webPurchaseUnavailableMessage' : ''}',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton,
                style: const TextStyle(color: Colors.grey)),
          ),
          if (!kIsWeb)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // 跟隨你的主題色
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  // 1. 關掉警告視窗
                  Navigator.pop(context);

                  // 2. 飛向商城
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StorePage(),
                    ),
                  );
                },
                child: Text(l10n.goToSubscribeButton)),
        ],
      ),
    );
  }

  Future<void> _checkReferralEligibility() async {
    if (_userId == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    if (!userDoc.exists || !mounted) return;

    final data = userDoc.data() ?? {};

    // 檢查：1. 有被邀請 2. 還沒領過獎勵
    String? inviterId = data['invitedBy'];
    bool isClaimed = data['referralRewardClaimed'] ?? true;

    setState(() {
      if (inviterId != null && !isClaimed) {
        _isReferralTrackerActive = true;
        _currentReferralChatCount = data['totalChatMessages'] ?? 0;
        debugPrint("🎯 偵測到合格被邀請新人！計數器已啟動，目前已聊：$_currentReferralChatCount 句");
      } else {
        _isReferralTrackerActive = false;
      }
    });
  }

  void _showReferralSuccessDialog() {
    final l10n = AppLocalizations.of(context)!; // 🌟 載入翻譯字典

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.card_membership_rounded,
                color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Text(l10n.referral_success_title), // 🌟 換成翻譯變數
          ],
        ),
        content: Text(l10n.referral_success_content), // 🌟 換成翻譯變數
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.shop_purchase_awesome,
                style:
                    const TextStyle(fontWeight: FontWeight.bold)), // 🌟 換成翻譯變數
          )
        ],
      ),
    );
  }

  // 讀取 Firebase 舊資料並填入輸入框
  Future<void> _loadExistingProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();

      // 如果以前有填寫過 profile，就把資料拿出來塞進輸入框
      if (data != null && data.containsKey('profile')) {
        final profile = data['profile'];
        if (mounted)
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
      final doc = await FirebaseFirestore.instance
          .collection('characters')
          .doc(charId)
          .get();
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
        // ✨ 總裁級：換成帶有紅色驚嘆號的置中錯誤小彈窗！
        _showCenterToast(l10n.chat_load_char_failed, isError: true);
      }
    }
  }

  // 🌟 4. 集中處理剩餘的初始化動作
  void _finishInitialization() {
    _initializeChat();
    _listenToFlowerPoints();

    // 進聊天室時先載入生日免費狀態，
    // 送訊息時不用再次等待 Firestore。
    unawaited(_loadBirthdayFreeStatus());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Provider.of<ThemeNotifier>(
        context,
        listen: false,
      ).loadCharacterBackground(
        _currentCharacter.name,
      );
    });
  }

  // 🌟 大合體版本：精準跳轉 ＋ 視覺回饋 ＋ 發光特效
  void _jumpToMessage(String messageId) {
    final l10n = AppLocalizations.of(context)!;
    // 1. 在目前的清單中找出這則訊息的 index
    final index = _localMessages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      // 🕵️‍♀️ 2. 視覺特效開關：標記這則訊息，讓它開始「發光」！
      if (mounted)
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
      _showCenterToast(l10n.chat_jump_success,
          customIcon:
              Icons.auto_awesome); // 🕵️‍♀️ 6. 時效設定：2 秒後自動「關燈」，把光芒消失，恢復正常
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          if (mounted)
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
    // 🌟 總裁補位：如果是測試模式，直接開門！
    if (widget.isTestMode) {
      final String modeName = widget.chatMode ?? 'daily';
      if (mounted)
        setState(() {
          _currentMode = ChatMode.values.firstWhere((e) => e.name == modeName,
              orElse: () => ChatMode.daily);
          _isLoading = false;
        });
      return;
    }

    // --- 🚀 總裁無敵帶位員：正式模式 ---
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 情況 1：玩家有直接帶鑰匙 (sessionId) 來
    if (widget.sessionId != null) {
      await _loadExistingChat(widget.sessionId!);
    } else if (widget.forceNewRoom == true) {
      print("✨ 收到強制開新房指令，直接呼叫工程隊！");
      final modeName = widget.chatMode ?? 'daily';
      _currentMode = ChatMode.values
          .firstWhere((e) => e.name == modeName, orElse: () => ChatMode.daily);
      await _createNewChat(modeName);
    }
    // 情況 2：玩家沒帶鑰匙，管家親自去幫他找或蓋房子！
    else {
      try {
        // 🔍 先查查看，他們以前有沒有開過房間？
        final existingSession = await FirebaseFirestore.instance
            .collection('artifacts')
            .doc(const String.fromEnvironment('APP_ID',
                defaultValue: 'lianlianshiguang')) // 確保找到對的 App
            .collection('chat_sessions')
            .where('userId', isEqualTo: user.uid)
            .where('characterId', isEqualTo: widget.character.id)
            .limit(1) // 只要找到一間就好
            .get();

        if (existingSession.docs.isNotEmpty) {
          // 🎉 找到了！帶入他們以前的舊房間
          await _loadExistingChat(existingSession.docs.first.id);
        } else {
          // 🏗️ 沒找到舊房間！管家現場直接呼叫工程隊蓋一間！
          final modeName = widget.chatMode ?? 'daily'; // 預設用 daily 模式開房
          _currentMode = ChatMode.values.firstWhere((e) => e.name == modeName,
              orElse: () => ChatMode.daily);
          await _createNewChat(modeName);
        }
      } catch (e) {
        print("❌ 管家尋找房間時發生錯誤: $e");
        // 萬一查資料庫出錯，為了不讓玩家卡住，強制蓋一間新房間給他！
        final modeName = widget.chatMode ?? 'daily';
        await _createNewChat(modeName);
      }
    }
  }

  void _listenToQixiProgress(
    DocumentReference sessionDocRef,
  ) {
    _qixiProgressSubscription?.cancel();

    _qixiProgressSubscription = sessionDocRef.snapshots().listen((snapshot) {
      if (!mounted || !snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>?;

      if (data == null || data['isQixiRoom'] != true) {
        return;
      }

      final interactionDates =
          (data['qixiInteractionDates'] as List<dynamic>? ?? const <dynamic>[])
              .map((date) => date.toString())
              .where((date) => date.trim().isNotEmpty)
              .toSet()
              .toList()
            ..sort();

      final letterSent = data['qixiLetterSent'] == true;

      setState(() {
        _isQixiRoom = true;
        _qixiInteractionDates = interactionDates;
        _qixiLetterSent = letterSent;
      });
    });
  }

  Future<void> _triggerQixiOpeningIfNeeded(
    Map<String, dynamic> sessionData,
  ) async {
    if (widget.isTestMode ||
        sessionData['isQixiRoom'] != true ||
        sessionData['eventId'] != 'qixi_2026' ||
        sessionData['qixiOpeningGenerated'] == true ||
        _isGeneratingQixiOpening ||
        _hasRequestedQixiOpeningThisVisit ||
        _sessionId == null) {
      return;
    }

    final roomLockKey = _sessionId ?? widget.sessionId ?? widget.character.id;

    if (_isGenerating || generatingRooms.contains(roomLockKey)) {
      return;
    }

    _isGeneratingQixiOpening = true;
    _hasRequestedQixiOpeningThisVisit = true;

    final clientRequestId = _createAiRequestId();

    _activeAiRequestId = clientRequestId;

    generatingRooms.add(roomLockKey);

    if (mounted) {
      setState(() {
        _isGenerating = true;
        _isLoading = false;

        // 七夕免費開場不是玩家互動，
        // 不得觸發每日星光判斷。
        _waitingForNewAiReply = false;
      });
    }

    try {
      await _executeMessageSending(
        userText: '',
        clientRequestId: clientRequestId,
        showInChat: false,
        isContinue: false,
        userMessageAlreadySaved: false,
        isQixiOpening: true,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '🌙 七夕首次赴約生成失敗：$e',
      );
      debugPrint('$stackTrace');
    } finally {
      _isGeneratingQixiOpening = false;
      generatingRooms.remove(roomLockKey);

      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoading = false;
        });
      }
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
        final bool isQixiRoom = data['isQixiRoom'] == true;

        final List<String> qixiInteractionDates = (data['qixiInteractionDates']
                    as List<dynamic>? ??
                const <dynamic>[])
            .map((date) => date.toString())
            .where((date) => date.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();

        final bool qixiLetterSent = data['qixiLetterSent'] == true;
        int initialFriendship = data['friendshipScore'] ?? 0;
        final modeName = data['chatMode'] ?? 'daily';
        _currentMode = ChatMode.values.firstWhere((e) => e.name == modeName,
            orElse: () => ChatMode.daily);

        _sessionDocRef = sessionDocRef;
        _messagesCollection = sessionDocRef.collection('messages'); // 這裡確保賦值
        _listenToQixiProgress(sessionDocRef);

        await sessionDocRef.update({'unreadCount': 0});

        if (mounted) {
          if (mounted)
            setState(() {
              _sessionId = sessionId;
              _currentFriendship = initialFriendship;
              _currentStoryTime = data['lastStoryTime'];
              _currentStoryLocation = data['lastStoryLocation'];

// 七夕房間狀態
              _isQixiRoom = isQixiRoom;
              _qixiInteractionDates = qixiInteractionDates;
              _qixiLetterSent = qixiLetterSent;

              _isLoading = false;
            });
        }
        if (data['isQixiRoom'] == true &&
            data['qixiOpeningGenerated'] != true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            unawaited(
              _triggerQixiOpeningIfNeeded(data),
            );
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
        _listenToQixiProgress(sessionDocRef);

        if (mounted) {
          if (mounted)
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
        String initialStoryText =
            rawInitialStory.replaceAll('{{玩家名字}}', _playerNickname);

        final DateTime now = DateTime.now();

        // ✅ 故事介紹：固定比較早
        if (initialStoryText.isNotEmpty) {
          final systemMsgRef = newSessionRef.collection('messages').doc();
          batch.set(systemMsgRef, {
            'sender': 'system',
            'text': initialStoryText,
            'timestamp': Timestamp.fromDate(now),
            'type': 'text',
            'path': '',
            'orderIndex': 0,
          });
        }

        // ✅ 第一句：固定比較晚
        final aiMsgRef = newSessionRef.collection('messages').doc();
        batch.set(aiMsgRef, {
          'sender': 'ai',
          'text': firstLine,
          'type': 'text',
          'path': '',
          'timestamp':
              Timestamp.fromDate(now.add(const Duration(milliseconds: 1))),
          'orderIndex': 1,
        });
      }
      // ✨✨✨ 4. 關鍵煞車：等待全部寫入成功！ ✨✨✨
      await batch.commit();
      // 5. 確保資料庫真的寫入成功後，才切換畫面狀態
      if (mounted) {
        if (mounted)
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

        // ✨ 總裁級：用置中錯誤小彈窗優雅地提示玩家
        _showCenterToast(l10n.chat_create_room_failed, isError: true);
      }
    }
  }

  // ✨ 總裁專屬：聊天室跳轉角色檔案 (已對齊 widget.character 結構)
  Future<void> _navigateToProfileFromChat(
    String charId,
    String charName,
    String avatarUrl,
  ) async {
    await CharacterNavigator.open(
      context,
      characterId: charId,
      fallbackName: charName,
      sessionId: _sessionId,
    );
  }

  // 🔒 這是那個神祕的「檔案已封存」彈窗
  void _showEncryptedProfileDialog(String name, String avatar) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.chat_secret_file_title,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              backgroundImage: getAvatarImageProvider(avatar),
              child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black38)),
            ),
            const SizedBox(height: 16),
            Text(name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 12),
            Text(l10n.chat_secret_file_desc,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.chat_understood)),
        ],
      ),
    );
  }

  Future<String> _resolveImageUrl(String path) async {
    if (_imageUrlCache.containsKey(path)) {
      return _imageUrlCache[path]!;
    }

    final url = await FirebaseStorage.instance.ref(path).getDownloadURL();

    _imageUrlCache[path] = url;

    return url;
  }

  Future<String?> _uploadFileToStorage(String filePath, String fileType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _sessionId == null) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      String fileExtension = fileType == 'audio' ? 'm4a' : 'png';

      if (!kIsWeb && filePath.contains('.')) {
        fileExtension = filePath.split('.').last.toLowerCase();
      }

      final storagePath =
          'user_uploads/${user.uid}/$_sessionId/$fileType-$timestamp.$fileExtension';

      final ref = FirebaseStorage.instance.ref(storagePath);

      String contentType;

      if (fileType == 'audio') {
        if (fileExtension == 'aac') {
          contentType = 'audio/aac';
        } else if (fileExtension == 'webm') {
          contentType = 'audio/webm';
        } else {
          contentType = 'audio/mp4'; // m4a 建議用 audio/mp4
        }
      } else {
        if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
          contentType = 'image/jpeg';
        } else {
          contentType = 'image/png';
        }
      }

      final metadata = SettableMetadata(
        contentType: contentType,
        cacheControl:
            fileType == 'image' ? 'public,max-age=31536000,immutable' : null,
      );

      if (kIsWeb) {
        final bytes = await XFile(filePath).readAsBytes();
        await ref.putData(bytes, metadata);
      } else {
        final file = File(filePath);
        await ref.putFile(file, metadata);
      }

      final downloadUrl = await ref.getDownloadURL();

      debugPrint('✅ 上傳 $fileType 成功');
      debugPrint('📦 storagePath=$storagePath');
      debugPrint('🔗 downloadUrl=$downloadUrl');

      // 重點：回傳真正可播放 / 可顯示的網址
      return downloadUrl;
    } catch (e) {
      debugPrint("❌ 上傳 $fileType 失敗: $e");
      return null;
    }
  }

  void _showCenterToast(
    String message, {
    bool isError = false,
    IconData? customIcon,
  }) {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (dialogContext) {
        Future.delayed(
          const Duration(milliseconds: 1500),
          () {
            if (!dialogContext.mounted) return;

            Navigator.of(
              dialogContext,
              rootNavigator: true,
            ).pop();
          },
        );

        return PopScope(
          canPop: false,
          child: Center(
            child: Material(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      customIcon ??
                          (isError
                              ? Icons.error_outline
                              : Icons.check_circle_outline),
                      color: isError ? Colors.redAccent : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveUserMessageOnly({
    required String userText,
    String? imagePath,
    String? audioPath,
  }) async {
    if (_messagesCollection == null) return;

    String messageType = 'text';
    String lastMessageText = userText.trim();
    String? storagePath;

    if (imagePath != null) {
      storagePath = await _uploadFileToStorage(imagePath, 'image');
      messageType = 'image';
      lastMessageText = '[圖片]';
    }

    if (audioPath != null) {
      storagePath = await _uploadFileToStorage(audioPath, 'audio');
      messageType = 'audio';
      lastMessageText = '[錄音]';
    }

    await _messagesCollection!.add({
      'sender': 'user',
      'text': userText.trim(),
      'content': userText.trim(),
      'type': messageType,
      'path': storagePath ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _sessionDocRef?.update({
      'lastMessage': lastMessageText,
      'lastActivity': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> _showUseEasterEggDialog(dynamic egg) async {
    if (!mounted) return false;

    // ✨ 1. 取得 l10n 實例
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // ✨ 2. 替換標題
          title: Text(l10n.easter_egg_title),
          // ✨ 3. 替換內容，並把 egg.title 當作參數傳給字典！
          content: Text(
            l10n.easter_egg_content(egg.title),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              // ✨ 4. 替換「不使用」按鈕
              child: Text(l10n.easter_egg_cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              // ✨ 5. 替換「使用彩蛋」按鈕
              child: Text(l10n.easter_egg_confirm),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Future<void> _sendMessage({
    String text = '',
    String? imagePath,
    String? audioPath,
    String? secretPrompt,
    bool showInChat = true,
    bool isContinue = false,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final messageText = text.trim();
    final roomLockKey = _sessionId ?? widget.sessionId ?? widget.character.id;

    if (_isGenerating ||
        _isLoading ||
        generatingRooms.contains(roomLockKey) ||
        _sessionId == null) {
      return;
    }

    final String clientRequestId = _createAiRequestId();

    _activeAiRequestId = clientRequestId;

    String? pendingMediaId;

    if ((imagePath != null && imagePath.isNotEmpty) ||
        (audioPath != null && audioPath.isNotEmpty)) {
      pendingMediaId = DateTime.now().millisecondsSinceEpoch.toString();

      setState(() {
        _pendingMediaMessages.insert(0, {
          'id': pendingMediaId,
          'type': imagePath != null && imagePath.isNotEmpty ? 'image' : 'audio',
          'path': imagePath ?? audioPath ?? '',
          'text': messageText, // 👈 新增這行，讓等待上傳時也知道有文字
          'isUploading': true,
        });
      });
    }

    if (mounted) {
      setState(() {
        _isGenerating = true;
        _isLoading = false;
        _lastUserSendTime = DateTime.now();
        _waitingForNewAiReply = true;
      });
    }

    generatingRooms.add(_roomLockKey);
    try {
      // 發送後清空輸入框
      _textController.clear();
      FocusScope.of(context).unfocus();

      unawaited(
        SharedPreferences.getInstance().then(
          (prefs) => prefs.remove(
            'chat_draft_${widget.sessionId}',
          ),
        ),
      );

      if (_isReferralTrackerActive) {
        await _triggerReferralCounter();
      }

      dynamic triggeredEgg;

      // ✨ 1. 彩蛋雷達掃描
      if (!isContinue &&
          messageText.isNotEmpty &&
          _currentMode != ChatMode.gemini &&
          secretPrompt == null) {
        final easterEggs = widget.character?.easterEggs ?? [];

        for (var egg in easterEggs) {
          if (messageText.contains(egg.keyword) &&
              !_triggeredEggKeywords.contains(egg.keyword)) {
            triggeredEgg = egg;
            break;
          }
        }
      }

      // ✨ 2. 觸發彩蛋或正常發送
      if (triggeredEgg != null) {
        // 1. 先把玩家真正輸入的文字顯示在畫面上
        await _saveUserMessageOnly(
          userText: messageText,
          imagePath: imagePath,
          audioPath: audioPath,
        );

        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }

        // 2. 一旦「發現彩蛋」，就先標記已觸發，避免下次一直跳
        _triggeredEggKeywords.add(triggeredEgg.keyword);
        await _dropEggToBackpack(triggeredEgg);

        // 3. 再詢問玩家要不要使用這次特殊劇情
        final useEgg = await _showUseEasterEggDialog(triggeredEgg);

        if (useEgg) {
          // 使用彩蛋：AI 讀彩蛋劇情
          await _executeMessageSending(
            userText: messageText,
            clientRequestId: clientRequestId,
            imagePath: null,
            audioPath: null,
            overridePrompt: l10n.chat_hidden_event_trigger(
              triggeredEgg.title,
              triggeredEgg.setScene,
            ),
            showInChat: false,
            isContinue: isContinue,
            userMessageAlreadySaved: true,
            pendingMediaId: pendingMediaId,
          );
        } else {
          // 不使用彩蛋：AI 照原本文字正常回覆
          await _executeMessageSending(
            userText: messageText,
            clientRequestId: clientRequestId,
            imagePath: null,
            audioPath: null,
            secretPrompt: null,
            showInChat: false,
            isContinue: isContinue,
            userMessageAlreadySaved: true,
            pendingMediaId: pendingMediaId,
          );
        }
      } else {
        await _executeMessageSending(
          userText: messageText,
          clientRequestId: clientRequestId,
          imagePath: imagePath,
          audioPath: audioPath,
          secretPrompt: secretPrompt,
          showInChat: showInChat,
          isContinue: isContinue,
          pendingMediaId: pendingMediaId,
        );
      }
    } catch (e) {
      debugPrint('❌ _sendMessage 發生錯誤: $e');

      if (mounted) {
        _showCenterToast(
          l10n.chatPageSendFailed,
          isError: true,
        );
      }
    } finally {
      generatingRooms.remove(_roomLockKey);

      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _loadTodayPeriodContext({
    required String userId,
    required String characterId,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayId = DateFormat('yyyyMMdd').format(today);

      final characterRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('characters')
          .doc(characterId);

      final results = await Future.wait([
        characterRef
            .collection('period_tracker')
            .orderBy('startDate', descending: true)
            .limit(1)
            .get(),
        characterRef.collection('period_daily_logs').doc(todayId).get(),
      ]);

      final periodSnapshot = results[0] as QuerySnapshot<Map<String, dynamic>>;

      final dailyLogSnapshot =
          results[1] as DocumentSnapshot<Map<String, dynamic>>;

      final contextLines = <String>[];

      // 讀取目前生理期狀態
      if (periodSnapshot.docs.isEmpty) {
        contextLines.add('生理期狀態：玩家尚未建立生理期紀錄。');
      } else {
        final periodData = periodSnapshot.docs.first.data();

        final startTimestamp = periodData['startDate'] as Timestamp?;

        final endTimestamp = periodData['endDate'] as Timestamp?;

        final isOngoing = periodData['isOngoing'] == true;

        if (startTimestamp == null) {
          contextLines.add('生理期狀態：未知。');
        } else {
          final rawStart = startTimestamp.toDate();
          final startDate = DateTime(
            rawStart.year,
            rawStart.month,
            rawStart.day,
          );

          DateTime endDate = startDate;

          if (endTimestamp != null) {
            final rawEnd = endTimestamp.toDate();
            endDate = DateTime(
              rawEnd.year,
              rawEnd.month,
              rawEnd.day,
            );
          }

          if (isOngoing) {
            contextLines.add(
              '生理期狀態：目前正在生理期，'
              '本次開始日為 ${DateFormat('M 月 d 日').format(startDate)}。',
            );
          } else {
            final isTodayInPeriod =
                !today.isBefore(startDate) && !today.isAfter(endDate);

            contextLines.add(
              isTodayInPeriod ? '生理期狀態：今天仍在已記錄的生理期範圍內。' : '生理期狀態：目前沒有進行中的生理期。',
            );
          }
        }
      }

      // 讀取今天的心情與身體紀錄
      final dailyData = dailyLogSnapshot.data();

      if (dailyData != null) {
        List<String> readStringList(dynamic value) {
          if (value is! Iterable) {
            return <String>[];
          }

          return value
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList();
        }

        final moods = readStringList(dailyData['moods']);

        final symptoms = readStringList(dailyData['symptoms']);

        final customMood = dailyData['customMood']?.toString().trim() ?? '';

        final customSymptom =
            dailyData['customSymptom']?.toString().trim() ?? '';

        final note = dailyData['note']?.toString().trim() ?? '';

        if (moods.isNotEmpty) {
          contextLines.add(
            '今天記錄的心情：${moods.join('、')}。',
          );
        }

        if (symptoms.isNotEmpty) {
          contextLines.add(
            '今天記錄的身體狀態：${symptoms.join('、')}。',
          );
        }

        if (customMood.isNotEmpty) {
          contextLines.add(
            '今天補充的心情：$customMood。',
          );
        }

        if (customSymptom.isNotEmpty) {
          contextLines.add(
            '今天補充的身體狀態：$customSymptom。',
          );
        }

        if (note.isNotEmpty) {
          contextLines.add(
            '今天的備註：$note。',
          );
        }
      }

      contextLines.add(
        '以上是玩家主動記錄的當日背景資訊。'
        '角色可以依人設自然理解、關心或調整互動，'
        '但不必每則回覆都主動提起生理期、心情或症狀，'
        '也不要使用醫療診斷、心理諮商或教科書式口吻。',
      );

      return contextLines.join('\n');
    } catch (e) {
      debugPrint('❌ 讀取今日生理期與身心紀錄失敗：$e');

      return '玩家今日生理期與身心紀錄暫時無法讀取，'
          '不得自行猜測或捏造相關狀態。';
    }
  }

  void _removePendingMediaMessage(String? pendingMediaId) {
    if (pendingMediaId == null) return;
    if (!mounted) return;

    setState(() {
      _pendingMediaMessages.removeWhere(
        (item) => item['id'] == pendingMediaId,
      );
    });
  }

  // ✨ VIP 無痕重新生成通道
  Future<bool> _regenerateAIResponse(
    String aiMessageId,
    String lastUserText,
  ) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || _isGenerating || _sessionId == null) {
      return false;
    }

    final String clientRequestId = _createAiRequestId();
    _activeAiRequestId = clientRequestId;

    final l10n = AppLocalizations.of(context)!;
    final userId = currentUser.uid;
    final characterId = _currentCharacter.id;

    // 只鎖定畫面，不要先刪除舊訊息
    if (mounted) {
      setState(() {
        _isGenerating = true;
        _isRegenerating = true;
      });
    }

    try {
      // 讀取歷史紀錄
      final List<Map<String, String>> actualChatHistory = [];
      String regenerateStartTime = _currentStoryTime ?? '';
      String regenerateStartLocation = _currentStoryLocation ?? '';

      if (_messagesCollection != null) {
        final historySnapshot = await _messagesCollection!
            .orderBy(
              'timestamp',
              descending: true,
            )
            .limit(16)
            .get()
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('讀取歷史紀錄逾時');
          },
        );

        // 🕒📍 重新生成必須從原 AI 回覆的起點重新開始
        try {
          final oldAiDoc =
          await _messagesCollection!.doc(aiMessageId).get();

          final oldAiData =
          oldAiDoc.data() as Map<String, dynamic>?;

          if (oldAiData != null) {
            final savedStartTime =
                oldAiData['storyStartTime']?.toString().trim() ?? '';

            final savedStartLocation =
                oldAiData['storyStartLocation']?.toString().trim() ?? '';

            if (savedStartTime.isNotEmpty) {
              regenerateStartTime = savedStartTime;
            }

            if (savedStartLocation.isNotEmpty) {
              regenerateStartLocation = savedStartLocation;
            }
          }
        }catch (e) {
          debugPrint(
            '⚠️ 讀取重新生成起點失敗，暫時沿用目前故事狀態：$e',
          );
        }

        final docsList = historySnapshot.docs.reversed.toList();

        for (final doc in docsList) {
          // 不要把準備重新生成的舊 AI 回覆送進歷史
          if (doc.id == aiMessageId) {
            continue;
          }

          final data = doc.data() as Map<String, dynamic>;

          final sender = data['sender']?.toString();

          final text = data['text']?.toString().trim() ?? '';

          final imageDescription =
              data['imageDescription']?.toString().trim() ?? '';

          if (text.isEmpty && imageDescription.isEmpty) {
            continue;
          }

          if (sender == 'user' || sender == 'ai') {
            String historyText = text;

            if (sender == 'user' && imageDescription.isNotEmpty) {
              final imageContext = '[玩家曾傳來一張圖片，圖片內容如下：$imageDescription]';

              historyText = historyText.isEmpty
                  ? imageContext
                  : '$historyText\n\n$imageContext';
            }

            actualChatHistory.add({
              'role': sender == 'ai' ? 'assistant' : 'user',
              'text': historyText,
            });
          }
        }
      } else {
        final recentTests = _testMessages
            .where(
              (message) => message.id != aiMessageId,
            )
            .take(8)
            .toList()
            .reversed
            .toList();

        for (final message in recentTests) {
          if (message.sender == 'user' || message.sender == 'ai') {
            final text = message.text.trim();

            if (text.isEmpty) {
              continue;
            }

            actualChatHistory.add({
              'role': message.sender == 'ai' ? 'assistant' : 'user',
              'text': text,
            });
          }
        }
      }

      // 讀取回憶
      final aboutMeSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('characters')
          .doc(characterId)
          .collection('memories')
          .get();

      final aboutMeNotes = aboutMeSnapshot.docs
          .map(
            (doc) => doc.data()['text']?.toString() ?? '',
          )
          .where(
            (text) => text.trim().isNotEmpty,
          )
          .toList();

      // 讀取備忘錄
      List<String> memos = [];

      if (_currentMode == ChatMode.daily || _currentMode == ChatMode.gemini) {
        final memosSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('characters')
            .doc(characterId)
            .collection('memos')
            .get();

        memos = memosSnapshot.docs
            .map(
              (doc) => doc.data()['content']?.toString() ?? '',
            )
            .where(
              (text) => text.trim().isNotEmpty,
            )
            .toList();
      }

      final String periodStatus = await _loadTodayPeriodContext(
        userId: userId,
        characterId: characterId,
      );

      final idToken = await currentUser.getIdToken();

      final dynamicRelationship = _currentFriendship.relationshipTitle(l10n);

      final dynamicProfile = _buildDynamicUserProfileString();

      final playerGenderForAi = _normalizePlayerGenderForAi(
        _currentAiProfile['gender']?.toString(),
      );

      final playerPronounGuide = _buildPlayerPronounGuide(
        playerGenderForAi,
      );

      final Map<String, dynamic> requestBody = {
        'clientRequestId': clientRequestId,
        'audioUrl': '',
        'userMessage': lastUserText,
        'chatMode': _currentMode?.name ?? 'daily',
// 明確告訴後端這是免費重新生成，不能扣聊天花花。
        'isRegenerate': true,
        'isBirthdayFreebie': false,
        'overrideSystemPrompt': '',
        'sessionId': _sessionId,
        'playerName': _playerNickname,
        'playerGender': playerGenderForAi,
        'playerPronounGuide': playerPronounGuide,
        'userProfile': dynamicProfile,
        'systemDirective': '【最高防護指令】這是玩家要求重新生成的對話。'
            '注意：玩家的時空設定與稱呼可能已在此刻發生變更！'
            '你必須立刻捨棄歷史紀錄中的舊稱呼，'
            '現在起，與你對話的主角稱呼強制更新為'
            '「$_playerNickname」，絕對不能叫錯！'
            '請視為全新的互動自然地接續。'
            '以下是對方當前的專屬時空設定：\n'
            '$dynamicProfile\n\n'
            '你必須嚴格根據這些設定與她互動，'
            '並以 JSON 格式回覆，格式為：'
            '{"response": "你的對話台詞", '
            '"affectionChange": 數字}。',
        'aboutMeNotes': aboutMeNotes,
        'memos': memos,
        'periodStatus': periodStatus,
        'lastStoryTime': regenerateStartTime,
        'lastStoryLocation': regenerateStartLocation,
        'characterProfile': {
          'id': _currentCharacter.id,
          'name': _currentCharacter.name,

          // 新版角色核心設定
          'coreCharacterSetting': _currentCharacter.coreCharacterSetting
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'customOutputFormat': _currentCharacter.customOutputFormat
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          // 舊版角色相容欄位
          'toneAndStyle': _currentCharacter.toneAndStyle
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'detailedPersonality': _currentCharacter.detailedPersonality
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'socialInteraction': _currentCharacter.socialInteraction
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'background': _currentCharacter.background
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'worldSetting': _currentCharacter.worldSetting
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'likes': _currentCharacter.likes
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'secrets': _currentCharacter.secrets
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          'gender': _currentCharacter.gender,
          'relationship': dynamicRelationship,

          'socialRelationships': _currentCharacter.relationships != null
              ? jsonEncode(
                  _currentCharacter.relationships,
                )
                  .replaceAll(
                    '{{玩家名字}}',
                    _playerNickname,
                  )
                  .replaceAll(
                    '(玩家名字)',
                    _playerNickname,
                  )
              : '',

          'npcCharacters': _currentCharacter.npcCharacters,
        },

        'chatHistory': actualChatHistory,
      };

      _httpClient = http.Client();

      final response = await _httpClient!
          .post(
            Uri.parse(
              'https://asia-east1-'
              'lianlianshiguang.cloudfunctions.net/'
              'getAiResponse',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 45),
          );

      // 玩家已停止，安靜結束，不扣除次數
      if (_activeAiRequestId != clientRequestId) {
        debugPrint('🛑 重新生成已停止，忽略 HTTP 結果');
        return false;
      }

      // HTTP 請求失敗，不扣除次數
      if (response.statusCode != 200) {
        debugPrint(
          '⚠️ 重新生成 HTTP 錯誤碼：${response.statusCode}',
        );

        _handleGenerationError(
          l10n.error_msg_send_failed,
        );

        return false;
      }

      final decodedBody = utf8.decode(response.bodyBytes);
      final dynamic decoded = jsonDecode(decodedBody);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          '重新生成回傳格式不正確',
        );
      }

      // 後端確認取消，不扣除次數
      if (decoded['status'] == 'cancelled') {
        debugPrint('🛑 後端確認重新生成已取消');
        return false;
      }

      // 後端沒有成功，不扣除次數
      if (decoded['status'] != 'success') {
        _handleGenerationError(
          l10n.error_system_busy,
        );

        return false;
      }

      // 取得真正的新 AI 回覆
      final String regeneratedText =
          (decoded['response'] ?? '').toString().trim();

      // 空回覆不算成功，也不扣除次數
      if (regeneratedText.isEmpty) {
        debugPrint(
          '⚠️ 重新生成回傳成功，'
          '但 response 是空字串：$decodedBody',
        );

        _handleGenerationError(
          l10n.error_system_busy,
        );

        return false;
      }

      if (_messagesCollection == null) {
        throw Exception(
          '訊息集合尚未完成初始化',
        );
      }

      // 確定新回覆成功產生後，才刪除原本的舊回覆
      await _messagesCollection!.doc(aiMessageId).delete();

      final int finalAffectionChange = decoded['affectionChange'] is num
          ? (decoded['affectionChange'] as num).toInt()
          : 0;

      final String regeneratedStoryTime =
          decoded['storyTime']?.toString().trim() ?? '';

      final String regeneratedStoryLocation =
          decoded['storyLocation']?.toString().trim() ?? '';

      if (mounted) {
        setState(() {
          // 🕒📍 同步重新生成後的故事狀態
          if (regeneratedStoryTime.isNotEmpty) {
            _currentStoryTime = regeneratedStoryTime;
          }

          if (regeneratedStoryLocation.isNotEmpty) {
            _currentStoryLocation = regeneratedStoryLocation;
          }
          if (finalAffectionChange != 0) {
            final int oldScore = _currentFriendship;

            _currentFriendship += finalAffectionChange;

            _checkForLevelUp(
              oldScore,
              _currentFriendship,
            );
          }

          _isGenerating = false;
          _isRegenerating = false;
        });
      }

      debugPrint(
        '✅ 重新生成完成並成功寫入訊息：$aiMessageId',
      );

      // 只有走到這裡，才算真正成功
      return true;
    } catch (e, stackTrace) {
      if (_activeAiRequestId != clientRequestId) {
        debugPrint(
          '🛑 重新生成已停止，忽略連線中斷：$e',
        );

        return false;
      }

      debugPrint(
        '❌ 重新生成在前端發生錯誤：$e',
      );
      debugPrint('$stackTrace');

      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isRegenerating = false;
        });

        _showCenterToast(
          l10n.chatPageRegenerateFailed,
          isError: true,
        );
      }

      return false;
    } finally {
      _httpClient?.close();
      _httpClient = null;
    }
  }

// 💡 幫忙簡化 UI 狀態復原的小幫手
  void _handleGenerationError(String errorMessage) {
    if (mounted) {
      setState(() {
        _isGenerating = false;
        _isRegenerating = false;
        _isLoading = false;
      });
      _showCenterToast(errorMessage, isError: true);
    }
  }

  Future<void> _handleContinueButton() async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr =
        DateTime.now().toIso8601String().substring(0, 10); // 取得今天日期 YYYY-MM-DD
    final hideDate = prefs.getString('hide_continue_warning_date');
    // 🌟 提前取得 l10n，這樣隱形指令也能用到
    final l10n = AppLocalizations.of(context)!;

    // 1. 如果玩家今天已經勾選過「不再提示」，就直接發送！
    if (hideDate == todayStr) {
      // 🚀 改用字典檔的隱形指令
      await _sendMessage(
        text: l10n.hiddenPromptContinue,
        showInChat: false,
        isContinue: true,
      );
      return;
    }

    // 2. 計算本次「繼續」需要花費多少點數
    int cost = AppConfig.costDailyChat; // 預設日常聊天
    if (_currentMode == ChatMode.story) cost = AppConfig.costStoryChat;
    if (_currentMode == ChatMode.immersive) cost = AppConfig.costImmersiveChat;
    if (_currentMode == ChatMode.gemini) cost = AppConfig.costGeminiChat;

    // 3. 彈出確認視窗
    bool dontShowAgain = false;

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) {
        // 🌟 在這裡再取一次對話框的 l10n
        final dialogL10n = AppLocalizations.of(context)!;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              // 💡 拿掉 Row 前面的 const
              title: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.pinkAccent),
                  const SizedBox(width: 8),
                  Text(dialogL10n.continueChatTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🚀 傳入 cost 變數給翻譯字串！
                  Text(
                    dialogL10n.continueChatCostWarning(cost),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      setDialogState(() {
                        dontShowAgain = !dontShowAgain;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: dontShowAgain,
                            activeColor: Colors.pinkAccent,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                dontShowAgain = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 💡 拿掉 Text 前面的 const
                        Text(l10n.dontShowAgainToday,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  // 💡 拿掉 Text 前面的 const
                  child: Text(dialogL10n.cancelButton,
                      style: const TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    // 如果有打勾，就把今天日期存起來，今天就不會再吵他了！
                    if (dontShowAgain) {
                      await prefs.setString(
                          'hide_continue_warning_date', todayStr);
                    }

                    if (!context.mounted) return;

                    Navigator.pop(context); // 關閉彈窗

                    // 🚀 改用字典檔的隱形指令
                    await _sendMessage(
                      text: l10n.hiddenPromptContinue,
                      showInChat: false,
                      isContinue: true,
                    );
                  },
                  child: Text(l10n.confirmContinue),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _triggerReferralCounter() async {
    if (_userId == null || !mounted) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(_userId);

    _currentReferralChatCount++;

    debugPrint(
      '🗣️ 新人說話了！當前累計：'
      '$_currentReferralChatCount / 15 句',
    );

    try {
      // 每一則都先把進度寫進自己的 users 文件
      await userRef.update({
        'totalChatMessages': _currentReferralChatCount,
      });

      // 未滿 15 句，不呼叫派彩
      if (_currentReferralChatCount < 15) {
        return;
      }

      if (mounted) {
        setState(() {
          _isReferralTrackerActive = false;
        });
      }

      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable(
        'claimReferralReward',
      );

      final result = await callable.call();

      final data = Map<String, dynamic>.from(
        result.data as Map,
      );

      final bool rewardGranted = data['rewardGranted'] == true;

      if (!mounted) return;

      if (rewardGranted) {
        debugPrint(
          '✅ 星之邀約雙向派彩成功，雙方各獲得 50 花花',
        );

        _showReferralSuccessDialog();
      } else {
        debugPrint(
          'ℹ️ 星之邀約獎勵已經發放過，不重複派彩',
        );
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint(
        '❌ 星之邀約 Function 失敗：'
        '${e.code} / ${e.message}',
      );

      if (mounted) {
        setState(() {
          _isReferralTrackerActive = true;
        });
      }
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 更新邀請進度或派彩失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() {
          _isReferralTrackerActive = true;
        });
      }
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
        'unlockedAt': FieldValue.serverTimestamp(),
        // 背包頁面是用 timestamp 還是 unlockedAt 排序？
        'timestamp': FieldValue.serverTimestamp(),
        // 保險起見兩個都給它存！
      });

      // 2. 顯示像 Email 一樣的頂部橫幅通知
      if (mounted) {
        // ✨ 總裁級：呼叫剛剛寫好的專屬成就解鎖彈窗！
        _showAchievementDialog(
          l10n.chat_egg_unlocked(egg.title),
          l10n.chat_egg_saved,
        );
      }
    } catch (e) {
      debugPrint('背包掉落失敗: $e');
    }
  }

  void _showAchievementDialog(String title, String subtitle) {
    showDialog(
      context: context,
      barrierDismissible: true, // 點擊旁邊可以關閉
      builder: (context) {
        // 自動消失的計時器
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted && Navigator.canPop(context)) Navigator.pop(context);
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline,
                      color: Colors.pinkAccent, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text(subtitle,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
        if (mounted)
          setState(() {
            for (var doc in snapshot.docs) {
              final data = doc.data();
              if (data['keyword'] != null) {
                // 把背包裡有的關鍵字，直接加進防重複觸發的清單中！
                _triggeredEggKeywords.add(data['keyword']);
              }
            }
          });
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

// --- 處理通話按鈕點擊 ---
  Future<void> _handleCallPress(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // ✨ 總裁級：引導註冊/登入的專屬互動彈窗 (已完全支援多國語系)
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.lock_person_outlined, color: Colors.blueAccent),
              const SizedBox(width: 8),
              // 替換：需要登入
              Text(l10n.call_login_title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          // 替換：保留您原本的 please_login_first，並接上新翻譯的下半句
          content: Text(
              '${l10n.please_login_first}\n\n${l10n.call_login_content}',
              style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              // 替換：稍後再說 (若您原本已經有 cancelButton 也可以直接用 l10n.cancelButton)
              child: Text(l10n.cancel_later,
                  style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // 1. 先關閉彈窗

                // 🚀 2. 飛向你的登入介面！
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              // 替換：前往登入
              child: Text(l10n.go_to_login),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
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
      // 這裡只是開發者除錯用的 Print，通常不用放進 l10n，除非要顯示在畫面上
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
        title: Text(l10n.chat_points_not_enough_title,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(l10n.chat_points_not_enough_desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.chat_understood),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              backgroundColor: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentPage == 0
                      ? _buildDialogPage1(
                          theme, () => setModalState(() => currentPage = 1))
                      : _buildDialogPage2(
                          theme,
                          selectedLanguage,
                          shouldSave, // ✨ 傳入保存狀態
                          languages,
                          (val) => setModalState(() => selectedLanguage = val),
                          (val) =>
                              setModalState(() => shouldSave = val), // ✨ 傳入變更邏輯
                          () => setModalState(() => currentPage = 0), () {
                          Navigator.pop(context);
                          // 🚀 執行撥打，同時傳入語言與保存意願！
                          _executeCallSequence(selectedLanguage, shouldSave);
                        }),
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
              child: Text(
                l10n.chat_call_confirm_title(_currentCharacter.name),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildBulletText(l10n.chat_call_rule_1, Icons.local_florist,
            theme.colorScheme.primary),
        _buildBulletText(l10n.chat_call_rule_2, Icons.timer_outlined,
            theme.colorScheme.secondary), // 可以用次要顏色
        _buildBulletText(l10n.chat_call_rule_3, Icons.headphones_outlined,
            theme.colorScheme.tertiary), // 可以用第三顏色
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.chat_call_btn_cancel,
                  style: TextStyle(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: onNextPage, // 按下後換頁
              child: Text(l10n.ok_button,
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
      VoidCallback onCall) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      key: const ValueKey(1),
      children: [
        Row(
          children: [
            InkWell(
                onTap: onBack,
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(l10n.chat_call_pref_title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 20),
        // --- 語言選擇 ---
        Text(l10n.chat_call_lang_select,
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        _buildDropdown(theme, currentLang, langs, onLangChanged),
        const SizedBox(height: 20),
        // --- 🌟 通話保存開關 ---
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SwitchListTile(
            title: Text(l10n.chat_call_save_memory,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: Text(l10n.chat_call_save_memory_desc,
                style: TextStyle(fontSize: 12)),
            secondary: Icon(Icons.auto_awesome_rounded,
                color: theme.colorScheme.primary),
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
              child: Text(l10n.cancelButton,
                  style: TextStyle(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.call, size: 18),
              label: Text(l10n.chat_call_btn_start,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: onCall,
            ),
          ],
        ),
      ],
    );
  }

// 輔助小元件：把 Dropdown 抽出來讓程式碼更乾淨
  Widget _buildDropdown(ThemeData theme, String currentLang, List<String> langs,
      Function(String) onLangChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLang,
          isExpanded: true,
          items: langs
              .map((String lang) =>
                  DropdownMenuItem(value: lang, child: Text(lang)))
              .toList(),
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
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.85),
                  height: 1.4),
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
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

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

    final finalBg = customBgUrl ?? widget.character.avatarPath;
    print("🌟 準備傳進 CallOverlay 的背景圖片是: $finalBg");

// 🌟 2. 拿到網址後，再打開通話畫面
    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallOverlay(
                  character: widget.character,
                  characterId: widget.character.id,
                  // ✨✨✨ 關鍵替換：如果有 customBgUrl 就用它，沒有的話才用預設大頭貼
                  selectedBackgroundUrl:
                      customBgUrl ?? widget.character.avatarPath,
                  selectedLanguage: selectedLanguage,
                  shouldSave: shouldSave,
                  sessionId: _sessionId ?? '',
                  onCallEnded: (duration, messages) async {
                    Navigator.pop(context);
                    final minutes = (duration / 60).floor();
                    final seconds = duration % 60;
                    final timeString = minutes > 0
                        ? l10n.chatPageMinutesSeconds(minutes, seconds)
                        : l10n.chatPageSeconds(seconds);
                    await _addSystemMessage(l10n.chat_call_ended(
                        widget.character.name, timeString));
                    if (shouldSave) {
                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final memoryRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('call_memories');

                          // ✨ 過濾掉系統訊息，只存玩家跟男神的對話！
                          final cleanMessages = messages
                              .where((msg) => msg['isSystem'] != true)
                              .toList();

                          String? firstAudioUrl;
                          for (var msg in cleanMessages) {
                            if (msg['audioUrl'] != null &&
                                msg['audioUrl'].toString().isNotEmpty) {
                              firstAudioUrl = msg['audioUrl'];
                              break; // 找到第一個網址就停下來
                            }
                          }

                          await memoryRef.add({
                            'characterId': widget.character.id,
                            'characterName': widget.character.name,
                            'characterAvatar': widget.character.avatarPath,
                            'voiceId':
                                widget.character.voiceId, // ✨ 把聲音 ID 也存起來備用
                            'voiceStability': widget.character.voiceStability,
                            'voiceStyle': widget.character.voiceStyle,
                            'duration': duration,
                            'timestamp': FieldValue.serverTimestamp(),
                            'messages': cleanMessages, // 🌟 成功把整場對話存進去！
                            'audioUrl': firstAudioUrl,
                          });

                          // 🧹 總裁省錢魔法：超過 10 筆就刪掉舊的
                          final snapshot = await memoryRef
                              .orderBy('timestamp', descending: true)
                              .get();
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
                )),
      );
    }
  }

  Future<void> _executeMessageSending({
    required String userText,
    required String clientRequestId,
    String? imagePath,
    String? audioPath,
    String? overridePrompt,
    String? secretPrompt,
    String? pendingMediaId,
    bool showInChat = true,
    bool isContinue = false,
    bool userMessageAlreadySaved = false,
    bool isQixiOpening = false,
  }) async {
    // 🌟 1. 身分檢查
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _removePendingMediaMessage(pendingMediaId);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final userId = currentUser.uid;
    final characterId = _currentCharacter.id;
    final roomLockKey = _sessionId ?? widget.sessionId ?? widget.character.id;
    try {
      // 🌟 2. 暴力現抓點數：解決 9325 點卻報不夠的問題
      final int myActualFlowers = _flowerPoints;

// 先取得生日免費狀態，再判斷是否需要扣點。
      bool isFreeToday;

      if (_hasLoadedBirthdayFreeStatus) {
        isFreeToday = _isBirthdayFreeToday;
      } else {
        try {
          isFreeToday = await _isBirthdayFreeChatActive();

          _isBirthdayFreeToday = isFreeToday;
          _hasLoadedBirthdayFreeStatus = true;
        } catch (e) {
          debugPrint(
            '⚠️ 即時確認生日免費狀態失敗：$e',
          );

          // 查詢失敗時採保守策略：視為非免費，
          // 真正扣點仍應由後端再次驗證。
          isFreeToday = false;
        }
      }

// 🌸 決定本次聊天的收費標準
      int messageCost = AppConfig.costDailyChat;

      if (_currentMode == ChatMode.story) {
        messageCost = AppConfig.costStoryChat;
      } else if (_currentMode == ChatMode.immersive) {
        messageCost = AppConfig.costImmersiveChat;
      } else if (_currentMode == ChatMode.gemini) {
        messageCost = AppConfig.costGeminiChat;
      }

// 生日免費時跳過前端點數不足檢查
      if (!isQixiOpening && !isFreeToday && myActualFlowers < messageCost) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (
              BuildContext dialogContext,
            ) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    const Icon(
                      Icons.local_florist,
                      color: Colors.pinkAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.chat_points_not_enough_title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  '${l10n.chat_points_shortage(
                    myActualFlowers.toString(),
                  )}\n\n'
                  '${l10n.chat_points_not_enough_desc}'
                  '${kIsWeb ? '\n\n$_webPurchaseUnavailableMessage' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      l10n.cancelButton,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  if (!kIsWeb)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StorePage(),
                          ),
                        );
                      },
                      child: Text(
                        l10n.goToSubscribeButton,
                      ),
                    ),
                ],
              );
            },
          );
        }

        _removePendingMediaMessage(
          pendingMediaId,
        );

        return;
      }
      _hasLoadedBirthdayFreeStatus = true;

      // 🌟 3. 防彈檢查：如果連線失敗，不要強行執行，避免 Unexpected null value
      // ✨ 總裁急救包：給它一點耐心，不要馬上放棄！
      // 🌟 改良後的等待機制：只檢查 Firebase 是否準備好，不管 shouldSave 了
      // 正式聊天室才需要等待 Firestore 訊息集合。
// 測試聊天室使用 _testMessages，因此沒有 _messagesCollection 是正常的。
      if (!widget.isTestMode && _messagesCollection == null) {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (_messagesCollection == null) {
          debugPrint(
            '❌ 錯誤：等了 0.5 秒 '
            '_messagesCollection 還是 Null，'
            '無法寫入正式聊天室訊息！',
          );

          _removePendingMediaMessage(
            pendingMediaId,
          );

          if (mounted) {
            _showCenterToast(
              l10n.chat_room_not_ready,
              isError: true,
            );
          }

          return;
        }
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
                .child(
                    'web_audio_${DateTime.now().millisecondsSinceEpoch}.webm');
            final uploadTask = await storageRef.putData(
                audioBytes, SettableMetadata(contentType: 'audio/webm'));
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

      final bool hasMedia = (imagePath != null && imagePath.isNotEmpty) ||
          (audioPath != null && audioPath.isNotEmpty);

      if (hasMedia && (storagePath == null || storagePath!.isEmpty)) {
        _removePendingMediaMessage(pendingMediaId);

        if (mounted) {
          _showCenterToast(
            l10n.chatPageMediaUploadFailed,
            isError: true,
          );
        }

        return;
      }
      // 🌟🌟🌟 總裁微創手術 2：強制畫面滾動到底部，確保玩家一定能看到男主的「...」！
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 請確認您原本用來滾動的函式名稱是不是這個，如果叫其他名字 (如 _scrollController.animateTo) 請替換掉
        _scrollToBottom();
      });
      String? userMessageId;
      // 🛡️ 防彈版：只要有集合存在，就直接寫入資料庫
      if (showInChat && !userMessageAlreadySaved) {
        if (_messagesCollection != null) {
          final userMessageRef = await _messagesCollection!.add({
            'sender': 'user',
            'text': userText.trim(),
            'type': messageType,
            'path': storagePath ?? '',
            'imageDescription': '',
            'timestamp': FieldValue.serverTimestamp(),
          });

          userMessageId = userMessageRef.id;
// 真正訊息已經寫入 Firestore，移除本機 pending 泡泡
          _removePendingMediaMessage(pendingMediaId);
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
              transaction.set(
                  userCharRef,
                  {
                    'affection': _currentFriendship,
                    'characterName': _currentCharacter.name,
                    'lastUpdate': FieldValue.serverTimestamp(),
                  },
                  SetOptions(merge: true));
            }
          });
        } else {
          if (mounted) {
            setState(() {
              _testMessages.insert(
                  0,
                  ChatMessage(
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
          _removePendingMediaMessage(pendingMediaId);
        }
      }

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      if (!isQixiOpening) {
        _handleTaskProgressAfterSendingMessage();
      }

      // --- C. 喚醒真正的長期記憶 ---
      List<Map<String, String>> actualChatHistory = [];
      // 🌟 直接檢查集合是否存在即可，不再需要 shouldSave
      if (_messagesCollection != null) {
        final historySnapshot = await _messagesCollection!
            .orderBy('timestamp', descending: true)
            .limit(16)
            .get();

        var docsList = historySnapshot.docs.reversed.toList();

        for (int i = 0; i < docsList.length; i++) {
          final doc = docsList[i];

          // 本次玩家訊息會透過後端的 finalUserMessage 加入，
          // 因此不要再放進 chatHistory，避免 AI 收到兩次
          if (userMessageId != null && doc.id == userMessageId) {
            continue;
          }

          final data = doc.data() as Map<String, dynamic>;
          final sender = data['sender'];

          String text = data['text']?.toString().trim() ?? '';

          final imageDescription =
              data['imageDescription']?.toString().trim() ?? '';

          if (sender == 'user' && imageDescription.isNotEmpty) {
            final imageContext = '[玩家曾傳來一張圖片，圖片內容如下：$imageDescription]';

            text = text.isEmpty ? imageContext : '$text\n\n$imageContext';
          }

          if (text.isEmpty) {
            continue;
          }

          // 處理秘密提示詞
          if (i == docsList.length - 1 &&
              sender == 'user' &&
              secretPrompt != null) {
            text = secretPrompt;
          }

          if (sender == 'user' || sender == 'ai') {
            actualChatHistory.add({
              'role': sender == 'ai' ? 'assistant' : 'user',
              'text': text,
            });
          }
        }
      } else {
        var recentTests = _testMessages.take(8).toList().reversed.toList();
        for (int i = 0; i < recentTests.length; i++) {
          final msg = recentTests[i];
          final sender = msg.sender;
          String text = msg.text;
          if (i == recentTests.length - 1 &&
              sender == 'user' &&
              secretPrompt != null) text = secretPrompt;
          if (sender == 'user' || sender == 'ai') {
            actualChatHistory.add(
                {"role": sender == 'ai' ? "assistant" : "user", "text": text});
          }
        }
      }

      if (!isQixiOpening &&
          !showInChat &&
          !isContinue &&
          !userMessageAlreadySaved) {
        actualChatHistory.add({
          "role": "user",
          "text": secretPrompt ?? userText.trim(),
        });
      }

      // --- 喚醒靈魂：讀取玩家記憶與生理期 ---
      final aboutMeSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('characters')
          .doc(characterId)
          .collection('memories')
          .get();
      final aboutMeNotes = aboutMeSnapshot.docs
          .map((doc) => doc.data()['text'] as String? ?? '')
          .toList();

      List<String> memos = [];
      if (_currentMode == ChatMode.daily || _currentMode == ChatMode.gemini) {
        final memosSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('characters')
            .doc(characterId)
            .collection('memos')
            .get();
        memos = memosSnapshot.docs
            .map((doc) => doc.data()['content'] as String? ?? '')
            .toList();
      }
      final String periodStatus = await _loadTodayPeriodContext(
        userId: userId,
        characterId: characterId,
      );
      // --- 🚀 D. 呼叫雲端 AI 大腦 ---
      final idToken = await currentUser.getIdToken();

      int currentScore = _currentFriendship;

      String dynamicRelationship = currentScore.relationshipTitle(l10n);

      String dynamicProfile = _buildDynamicUserProfileString();

      final String effectiveUserMessage = isContinue
          ? l10n.hiddenPromptContinue
          : secretPrompt?.trim().isNotEmpty == true
              ? secretPrompt!.trim()
              : userText.trim();

      final String playerGenderForAi = _normalizePlayerGenderForAi(
        _currentAiProfile['gender']?.toString(),
      );

      final bool hasImage = imagePath != null && imagePath.isNotEmpty;

      final bool hasAudio = audioPath != null && audioPath.isNotEmpty;

      final String playerPronounGuide =
          _buildPlayerPronounGuide(playerGenderForAi);
      final Map<String, dynamic> requestBody = {
        "clientRequestId": clientRequestId,
        "userMessageId": userMessageId ?? "",
        "isTestMode": widget.isTestMode,
        "imageUrl": hasImage ? (storagePath ?? "") : "",
        "audioUrl": hasAudio ? (storagePath ?? "") : "",
        "userMessage": effectiveUserMessage,
        "isContinue": isContinue,
        "chatMode": _currentMode?.name ?? "daily",
        "isBirthdayFreebie": isFreeToday,
        "isQixiOpening": isQixiOpening,
        "overrideSystemPrompt": overridePrompt ?? "",
        "sessionId": widget.isTestMode ? _testSessionId : _sessionId,
        "playerName": _playerNickname,
        "playerGender": playerGenderForAi,
        "playerPronounGuide": playerPronounGuide,
        // 🌟🌟🌟 核心修改點：這裡改呼叫動態人設產生器！ 🌟🌟🌟
        "userProfile": _buildDynamicUserProfileString(),
        "systemDirective": (overridePrompt != null && overridePrompt.isNotEmpty)
            ? "【最高防護指令】與你對話的對象叫做「$_playerNickname」！玩家已觸發特殊劇情，請配合 overrideSystemPrompt 的指示順暢地演出。以下是對方當前的時空設定：\n$dynamicProfile\n\n【玩家性別與稱呼規範】\n玩家性別設定：$playerGenderForAi\n$playerPronounGuide\n\n在實際回覆台詞中，禁止稱呼對方為「玩家」。你可以稱呼對方為「$_playerNickname」或使用符合性別設定的親暱稱呼。\n\n你必須嚴格以 JSON 格式回覆，格式為：{\"response\": \"你的對話台詞\", \"affectionChange\": 數字}。affectionChange 代表這句話增加或減少的好感度(整數)。絕對不可以輸出任何其他格式或說明。"
            : "【最高防護指令】請你「維持當前的聊天情境與場景」。記住，與你對話的對象稱呼是「$_playerNickname」，絕對不能叫錯！以下是對方當前的專屬時空設定：\n$dynamicProfile\n\n【玩家性別與稱呼規範】\n玩家性別設定：$playerGenderForAi\n$playerPronounGuide\n\n在實際回覆台詞中，禁止稱呼對方為「玩家」。你可以稱呼對方為「$_playerNickname」或使用符合性別設定的親暱稱呼。\n\n你必須嚴格根據這些設定與對方互動，並以 JSON 格式回覆，格式為：{\"response\": \"你的對話台詞\", \"affectionChange\": 數字}。affectionChange 代表這句話增加或減少的好感度(整數)。絕對不可以輸出任何其他格式或說明。",
        "aboutMeNotes": aboutMeNotes,
        "memos": memos,
        "periodStatus": periodStatus,
        "lastStoryTime": _currentStoryTime,
        "lastStoryLocation": _currentStoryLocation,
        "characterProfile": {
          "id": _currentCharacter.id,
          "name": _currentCharacter.name,

          // 新版合併後的角色核心設定
          "coreCharacterSetting": _currentCharacter.coreCharacterSetting
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "customOutputFormat": _currentCharacter.customOutputFormat
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          // 舊版相容欄位，暫時保留
          "toneAndStyle": _currentCharacter.toneAndStyle
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "detailedPersonality": _currentCharacter.detailedPersonality
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          // 舊角色的社交／環境互動相容資料
          "socialInteraction": _currentCharacter.socialInteraction
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "background": _currentCharacter.background
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "worldSetting": _currentCharacter.worldSetting
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "likes": _currentCharacter.likes
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "secrets": _currentCharacter.secrets
              .replaceAll(
                '{{玩家名字}}',
                _playerNickname,
              )
              .replaceAll(
                '(玩家名字)',
                _playerNickname,
              ),

          "gender": _currentCharacter.gender,
          "relationship": dynamicRelationship,

          // 這是角色與其他角色的關係，不是 socialInteraction
          "socialRelationships": _currentCharacter.relationships != null
              ? jsonEncode(
                  _currentCharacter.relationships,
                )
                  .replaceAll(
                    '{{玩家名字}}',
                    _playerNickname,
                  )
                  .replaceAll(
                    '(玩家名字)',
                    _playerNickname,
                  )
              : "",

          "npcCharacters": _currentCharacter.npcCharacters,
        },
        "chatHistory": actualChatHistory,
      };

      _httpClient = http.Client();
      http.Response? response;
      try {
        response = await _httpClient!
            .post(
          Uri.parse(
              'https://asia-east1-lianlianshiguang.cloudfunctions.net/getAiResponse'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken'
          },
          body: jsonEncode(requestBody),
        )
            .timeout(
          const Duration(seconds: 110), // ⏳ 總裁級防護：最多只等 110 秒！
          onTimeout: () {
            // 超時的話，丟出一個特製的 TimeoutException
            throw TimeoutException('他思考太久了');
          },
        );
      } catch (e) {
        // 玩家按下停止會關閉 HTTP Client，
        // 這是正常取消，不可顯示系統繁忙。
        if (_activeAiRequestId != clientRequestId) {
          debugPrint(
            '🛑 訊息生成已停止，忽略連線中斷：$e',
          );
          return;
        }
        // 🛡️ 攔截超時或網路斷線
        if (mounted) {
          setState(() {
            _isGenerating = false;
            _isLoading = false;
            generatingRooms.remove(_roomLockKey);
          });
          // 溫柔安撫玩家，不要顯示駭人的英文錯誤
          _showCenterToast(l10n.chatAiThinkingTimeout, isError: true);
        }
        return; // 提早結束，不要往下走
      }

      if (_activeAiRequestId != clientRequestId) {
        debugPrint(
          '🛑 訊息生成已停止，忽略 HTTP 結果',
        );
        return;
      }

      // --- 🎯 E. 接收 API 的直接回覆 (告別舊版監聽器！) ---
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['status'] == 'cancelled') {
          debugPrint('🛑 後端確認訊息生成已取消');
          return;
        }
        if (responseData['status'] == 'already_generated') {
          debugPrint('🌙 七夕首次赴約訊息已經生成，略過重複請求');

          generatingRooms.remove(_roomLockKey);

          if (mounted) {
            setState(() {
              _isGenerating = false;
              _isLoading = false;
            });
          }

          return;
        }
        if (responseData['status'] == 'success') {
          final String aiResponseText =
              responseData['response']?.toString().trim() ?? '';

          final String aiVoiceText =
              responseData['voiceText']?.toString().trim() ?? '';

          final int finalAffectionChange =
              responseData['affectionChange'] is num
                  ? (responseData['affectionChange'] as num).toInt()
                  : 0;

          final String newStoryTime =
              responseData['storyTime']?.toString().trim() ?? '';

          final String newStoryLocation =
              responseData['storyLocation']?.toString().trim() ?? '';

          if (aiResponseText.isEmpty) {
            generatingRooms.remove(_roomLockKey);

            if (mounted) {
              setState(() {
                _isGenerating = false;
                _isLoading = false;
              });

              _showCenterToast(
                l10n.error_system_busy,
                isError: true,
              );
            }

            return;
          }

          // ========================================================
          // 🟢 第一區：【資料庫鐵血執行】不管玩家在不在畫面，這段必須強行過水、記帳！
          // ========================================================

          //  同步更新全域最高好感度 (widget.shouldSave 整個邏輯搬到 mounted 外面)
          // 測試聊天室不能修改正式好感度或正式角色紀錄
          if (!widget.isTestMode) {
            try {
              final userCharRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('characters')
                  .doc(characterId);

              await FirebaseFirestore.instance
                  .runTransaction((transaction) async {
                final snapshot = await transaction.get(userCharRef);

                int currentGlobalAffection = 0;

                if (snapshot.exists) {
                  currentGlobalAffection = snapshot.data()?['affection'] ?? 0;
                }

                final int targetGlobalScore =
                    _currentFriendship + finalAffectionChange;

                if (targetGlobalScore > currentGlobalAffection) {
                  transaction.set(
                    userCharRef,
                    {
                      'affection': targetGlobalScore,
                      'characterName': _currentCharacter.name,
                      'lastUpdate': FieldValue.serverTimestamp(),
                    },
                    SetOptions(merge: true),
                  );
                }
              });
            } catch (e) {
              debugPrint(
                '更新正式好感度失敗：$e',
              );
            }

            if (!_currentCharacter.isPublic) {
              try {
                await FirebaseFirestore.instance
                    .collection('artifacts')
                    .doc(
                      const String.fromEnvironment(
                        'APP_ID',
                        defaultValue: 'lianlianshiguang',
                      ),
                    )
                    .collection('users')
                    .doc(userId)
                    .collection('private_characters')
                    .doc(characterId)
                    .update({
                  'lastChatTime': FieldValue.serverTimestamp(),
                });
              } catch (e) {
                debugPrint(
                  '更新私人角色聊天時間失敗：$e',
                );
              }
            }
          }

          // ========================================================
          // 🟡 第二區：【UI 溫室防線】只有當玩家還在房間畫面上，才需要處理 setState 與升級動畫
          // ========================================================
          generatingRooms.remove(_roomLockKey);

          if (mounted) {
            setState(() {
              // 🕒📍 同步本輪結束後的故事狀態
              if (newStoryTime.isNotEmpty) {
                _currentStoryTime = newStoryTime;
              }

              if (newStoryLocation.isNotEmpty) {
                _currentStoryLocation = newStoryLocation;
              }
              // 測試聊天室沒有 Firestore 訊息監聽，
              // 所以要自行將 AI 回覆加入本機訊息列表。
              if (widget.isTestMode) {
                _testMessages.insert(
                  0,
                  ChatMessage(
                    id: 'test_ai_${DateTime.now().microsecondsSinceEpoch}',
                    sender: 'ai',
                    text: aiResponseText,
                    type: 'text',
                    path: '',
                    timestamp: Timestamp.fromDate(
                      DateTime.now(),
                    ),
                    isAI: true,
                  ),
                );
              }

              // 後端成功完成後，前端同步更新顯示的花花數量。
              final int uiCost = isQixiOpening || isFreeToday ? 0 : messageCost;

              _flowerPoints = (_flowerPoints - uiCost).clamp(0, 999999);

              // 測試模式只在目前畫面模擬好感度變化，
              // 不會寫入正式資料庫。
              if (finalAffectionChange != 0) {
                final int oldScore = _currentFriendship;

                _currentFriendship += finalAffectionChange;

                _checkForLevelUp(
                  oldScore,
                  _currentFriendship,
                );

                if (finalAffectionChange > 0 && !_hasShownAffectionCard) {
                  _showAffectionAnimation(
                    finalAffectionChange,
                  );

                  _hasShownAffectionCard = true;
                }
              }

              _isGenerating = false;
              _isLoading = false;
            });
          }
        } else {
          generatingRooms.remove(_roomLockKey);
          if (mounted) {
            setState(() {
              _isGenerating = false;
              _isLoading = false;
            });
            // ✨ 總裁級：伺服器忙碌，輕量錯誤提示
            _showCenterToast(l10n.error_system_busy, isError: true);
          }
        }
      } else if (response.statusCode == 429) {
        generatingRooms.remove(_roomLockKey);

        if (mounted) {
          setState(() {
            _isGenerating = false;
            _isLoading = false;
          });

          _showCenterToast(l10n.chatPageAlreadyReplying, isError: false);
        }

        return;
      } else if (response.statusCode == 400) {
        // 🛑 退款防護網啟動：攔截到 400 錯誤！
        generatingRooms.remove(_roomLockKey);

        if (mounted) {
          setState(() {
            _isGenerating = false;
            _isLoading = false;
          });
          try {
            final errorData = jsonDecode(utf8.decode(response.bodyBytes));

            if (errorData['error'] == 'CENSORED') {
              // 🛡️ 觸發道德審查：用輕量 Toast 顯示男神害羞提示，絕對不扣花花！
              // 這裡 isError 設為 false 或 true 看妳的 Toast 樣式設計，通常用個溫和的顏色
              _showCenterToast(errorData['message'] ?? l10n.chatAiResponseBlocked,
                  isError: false);
            } else {
              // 其他一般的 400 錯誤（例如缺少參數）
              _showCenterToast(errorData['message'] ?? l10n.error_system_busy,
                  isError: true);
            }
          } catch (e) {
            _showCenterToast(l10n.error_system_confusion, isError: true);
          }
        }
      } else {
        // 其他狀態碼 (例如 500) 或網路異常
        generatingRooms.remove(_roomLockKey);
        if (mounted) {
          setState(() {
            _isGenerating = false;
            _isLoading = false;
          });
          // ✨ 總裁級：網路或傳送異常，輕量錯誤提示
          _showCenterToast(l10n.error_msg_send_failed, isError: true);
        }
      }
    } catch (e, stack) {
      _removePendingMediaMessage(pendingMediaId);
      print('❌ 發送訊息時發生嚴重錯誤: $e');
      print('📍 錯誤堆疊: $stack');
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoading = false;
        });
        // ✨ 總裁級：優雅地攔截崩潰，用輕量小彈窗安撫玩家！
        _showCenterToast(l10n.error_system_confusion, isError: true);
      }
    } finally {
      _removePendingMediaMessage(pendingMediaId);
      _httpClient?.close();
      _httpClient = null;

      generatingRooms.remove(_roomLockKey);

      if (mounted) {
        setState(() {
          _isGenerating = false;
          _isLoading = false;
        });
      }
    }
  }

  String _normalizePlayerGenderForAi(String? rawGender) {
    final gender = (rawGender ?? '').trim();

    if (gender == '男' || gender == '男性' || gender == '男生') {
      return '男性';
    }

    if (gender == '女' || gender == '女性' || gender == '女生') {
      return '女性';
    }

    if (gender == '其他') {
      return '其他';
    }

    return '未設定';
  }

  String _buildPlayerPronounGuide(String playerGender) {
    switch (playerGender) {
      case '男性':
        return '玩家設定為男性。請把對方視為男性，可以使用「你」「他」「男生」「先生」「男友」等稱呼。禁止稱對方為「妳」「她」「女生」「小姐」「女主角」「女友」，除非對方自己明確要求。不得反駁對方的男性身份。';

      case '女性':
        return '玩家設定為女性。請把對方視為女性，可以使用「妳」「她」「女生」「小姐」「女友」等稱呼。';

      case '其他':
        return '玩家性別設定為其他。請使用中性稱呼，例如「你」「對方」或玩家名字。不要擅自判定對方是男生或女生。';

      default:
        return '玩家尚未設定性別。請使用中性稱呼，例如「你」「對方」或玩家名字。不要擅自判定對方是男生或女生。';
    }
  }

  // 🌟 總裁秘技：在前端寫一個小幫手函式，丟在背後跑
  Future<void> _triggerMemoryExtraction(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    try {
      final idToken = await user.getIdToken();

      final url = Uri.parse(
        'https://asia-east1-lianlianshiguang.cloudfunctions.net/extractUserMemory',
      );

      http
          .post(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'characterId': _currentCharacter.id,
          'userMessage': cleanText,
        }),
      )
          .then((response) {
        debugPrint('🧠 記憶捕捉任務結束, 狀態碼: ${response.statusCode}');
      }).catchError((e) {
        debugPrint('⚠️ 記憶捕捉背景失敗，不影響聊天: $e');
      });
    } catch (e) {
      debugPrint('⚠️ 記憶捕捉啟動失敗，不影響聊天: $e');
    }
  }

  // ==========================================
  // 🌟 總裁專屬小工具：強制畫面滾動到底部 (完美適配版)
  // ==========================================
  void _scrollToBottom() {
    // 確保控制器有綁定到畫面上的 ListView，避免報錯
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        0.0, // 因為清單是反向的，所以 0.0 就是最底部！
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
          lastResetDateString =
              DateFormat('yyyy-MM-dd').format(lastResetTimestamp.toDate());
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
          final currentTasks =
              (data['dailyTasks'] as Map<String, dynamic>?) ?? {};

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
            print(
                "心動日記進度更新成功: $progressField 從 $currentVal 變 ${currentVal + 1}");
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
      if (mounted) {
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
  }

  void _listenToFlowerPoints() {
    // 取得當前使用者 ID
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _pointsSubscription?.cancel(); // 先取消舊的監聽，避免重複
    _pointsSubscription =
        _db.collection('users').doc(userId).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey('flowerPoints')) {
        if (mounted) {
          if (mounted)
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
  Future<void> _stopGenerating() async {
    final l10n = AppLocalizations.of(context)!;

    final String? requestId = _activeAiRequestId;

    // 先讓畫面立刻恢復，不必等待取消 API。
    _activeAiRequestId = null;

    _httpClient?.close();
    _httpClient = null;

    generatingRooms.remove(_roomLockKey);

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _isLoading = false;
        _isRegenerating = false;
        _waitingForNewAiReply = false;
      });

      _showCenterToast(
        l10n.chat_stop_generating_msg,
      );
    }

    if (requestId == null || requestId.isEmpty) {
      return;
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final idToken = await currentUser.getIdToken();

      final response = await http
          .post(
            Uri.parse(
              'https://asia-east1-'
              'lianlianshiguang.cloudfunctions.net/'
              'cancelAiResponse',
            ),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: jsonEncode({
              'clientRequestId': requestId,
              'sessionId': _sessionId ?? widget.sessionId ?? '',
            }),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      debugPrint(
        '🛑 AI 取消通知結果：'
        '${response.statusCode} '
        '${response.body}',
      );
    } catch (e) {
      // 取消通知失敗不重新開啟生成畫面。
      debugPrint(
        '⚠️ AI 取消通知失敗：$e',
      );
    }
  }

  void _showAffectionAnimation(int change) async {
    // 👈 記得加 async，因為要讀取震動設定
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
        backgroundColor: Colors.white.withValues(alpha: 0.95),
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

  // ✨ 總裁級進化：加入 currentRoomId 參數，讓每個房間都能召喚專屬的分身！
  Future<void> _checkProfileCompletion(
      String roomId, String characterId) async {
    if (_isChecking) return;
    _isChecking = true;
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _isChecking = false;
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data() ?? {};

// 玩家是否已經建立過任何拾光檔案
      final savedProfiles = data['profiles'];

      final bool hasAnyProfile =
          savedProfiles is List && savedProfiles.isNotEmpty;

// 全帳號是否已處理過第一次提示
      final bool hasHandledProfileIntro =
          data['hasHandledProfileIntro'] == true;

// 相容舊版：以前曾按過「稍後」
      final bool hasSkippedProfile = data['hasSkippedProfile'] == true;

// 有檔案、儲存過或按過稍後，全部角色都不再自動彈出
      final bool shouldNotShowWelcomePopup =
          hasAnyProfile || hasHandledProfileIntro || hasSkippedProfile;

      final String nickname = data['nickname'] ?? l10n.chat_default_player_name;

      final String birthday = data['birthday'] ?? l10n.authMethodUnknown;

      Map<String, dynamic>? activeProfile;

// 全帳號只自動顯示一次，不再依 characterId 判斷
      if (!_hasPromptedProfileSetup && !shouldNotShowWelcomePopup) {
        _hasPromptedProfileSetup = true;

        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (!mounted) return;
            _showWelcomeProfilePopup();
          },
        );
      }

      if (data.containsKey('profiles')) {
        List<dynamic> allProfiles = data['profiles'];
        Map<String, dynamic>? roomProfiles = data['roomProfiles'];
        String? targetProfileId;
        if (roomProfiles != null) {
          // 先找真正的房間 ID，如果找不到，去看看有沒有這角色的「臨時身分證」遺產！
          targetProfileId =
              roomProfiles[roomId] ?? roomProfiles['draft_$characterId'];
        }

        if (targetProfileId != null) {
          // ✨ 總裁級魔法：用 where().firstOrNull 取代笨重的 try-catch
          activeProfile = allProfiles
              .where((p) =>
                  p['id'] == targetProfileId && p['characterId'] == characterId)
              .firstOrNull;
        }
        // ✨ 虛擬組裝：沒有指定人設的房間，一律用最原始的名字跟生日！
        activeProfile ??= {
          'profileName': '基礎檔案',
          'name': nickname,
          'birthday': birthday,
          'height': '尚未填寫',
          'appearance': '尚未填寫',
          'occupation': '尚未填寫',
          'intro': '這份拾光檔案還在等待主人動筆...'
        };
        // 完美渲染 (l10n.chat_profile_full...)
        if (mounted) {
          setState(() {
            // 🌟🌟🌟 總裁級修復：同步更新玩家暱稱變數，讓男主內心設定也能無縫替換！
            _playerNickname =
                activeProfile!['name']?.toString().trim().isNotEmpty == true
                    ? activeProfile!['name']
                    : nickname;

            _currentAiProfile = {
              // 如果是基礎檔案就走軌道 B，否則走軌道 A (高級人設)
              'type': activeProfile!['profileName'] == '基礎檔案'
                  ? 'basic'
                  : 'advanced',
              'name': _playerNickname,
              'height': activeProfile!['height'],
              'appearance': activeProfile!['appearance'],
              'occupation': activeProfile!['occupation'],
              'intro': activeProfile!['intro'],
              'gender': data['gender'] ?? '未填寫', // 從最上面抓下來的基本資料
              'birthday': birthday,
            };

            // 下面是妳原本的程式碼，不動
            _userProfileText = l10n.chat_profile_full(
                activeProfile!['profileName'] ?? l10n.profile_unnamed_file,
                _playerNickname,
                // ✨ 這裡可以直接套用剛剛更新好的變數，更乾淨！
                birthday,
                activeProfile!['height'] ?? '尚未填寫',
                activeProfile!['appearance'] ?? '尚未填寫',
                activeProfile!['occupation'] ?? '尚未填寫',
                activeProfile!['intro'] ?? '這份拾光檔案還在等待主人動筆...');
          });
        }
      }
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _triggerStorySummary() async {
    final user = FirebaseAuth.instance.currentUser;

    // 確保使用者及訊息資料庫已準備完成
    if (user == null || _messagesCollection == null) {
      return;
    }

    // 本次摘要所屬的聊天室
    final String? summarySessionId =
        (_sessionId != null && _sessionId!.trim().isNotEmpty)
            ? _sessionId!.trim()
            : (widget.sessionId != null && widget.sessionId!.trim().isNotEmpty)
                ? widget.sessionId!.trim()
                : null;

    // 沒有真實聊天室 ID 時不建立摘要，避免不同房間混在一起
    if (summarySessionId == null) {
      debugPrint(
        '⚠️ 劇情摘要未發送：尚未取得聊天室 ID',
      );
      return;
    }

    try {
      // 只讀取目前聊天室的最後 10 則訊息
      final querySnapshot = await _messagesCollection!
          .orderBy(
            'timestamp',
            descending: true,
          )
          .limit(10)
          .get();

      // 對話不足 4 則時不產生摘要
      if (querySnapshot.docs.length < 4) {
        return;
      }

      // 將新→舊反轉為舊→新
      final docs = querySnapshot.docs.reversed.toList();

      final List<Map<String, String>> recentHistory = [];

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;

        final text = data['text']?.toString().trim() ?? '';

        if (text.isEmpty) {
          continue;
        }

        /*
       * 你的訊息資料前面使用的是：
       * sender: 'user' / 'ai'
       *
       * 原本用 data['isUser'] 可能會把所有訊息
       * 都判斷成 assistant。
       */
        final sender = data['sender']?.toString() ?? '';

        if (sender != 'user' && sender != 'ai') {
          continue;
        }

        recentHistory.add({
          'role': sender == 'user' ? 'user' : 'assistant',
          'content': text,
        });
      }

      // 過濾後仍不足 4 則，不產生摘要
      if (recentHistory.length < 4) {
        return;
      }

      final idToken = await user.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        debugPrint(
          '⚠️ 劇情摘要未發送：無法取得登入憑證',
        );
        return;
      }

      final url = Uri.parse(
        'https://asia-east1-lianlianshiguang.cloudfunctions.net/generateStorySummary',
      );

      // 保留非阻塞處理，但正確檢查 HTTP 狀態
      http
          .post(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'characterId': widget.characterId,
          'characterName': _currentCharacter.name,
          'playerName': _playerNickname,
          'chatHistory': recentHistory,

          // 關鍵：依聊天室分開儲存
          'sessionId': summarySessionId,
        }),
      )
          .then((response) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          debugPrint(
            '📖 劇情摘要任務完成：'
            '$summarySessionId',
          );
        } else {
          debugPrint(
            '⚠️ 劇情摘要任務失敗：'
            '${response.statusCode} '
            '${response.body}',
          );
        }
      }).catchError((error) {
        debugPrint(
          '⚠️ 劇情摘要連線失敗：$error',
        );
      });
    } catch (e) {
      debugPrint(
        '⚠️ 劇情摘要發送失敗：$e',
      );
    }
  }

  void _showMessageOptions(ChatMessage message) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: <Widget>[
            // 📸 🌟 總裁推薦：新增「截圖分享」選項
            ListTile(
              leading:
                  const Icon(Icons.camera_alt_outlined, color: Colors.purple),
              title: Text(l10n.screenshotShare),
              onTap: () {
                Navigator.pop(context);

                if (mounted)
                  setState(() {
                    _isScreenshotMode = true;
                    _selectedMessageIds.clear();
                    _selectedMessageIds.add(message.id);
                  });

                HapticFeedback.mediumImpact();
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(l10n.chat_msg_copy),
              onTap: () {
                Navigator.pop(context); // 1. 先關閉長按選單
                Clipboard.setData(
                    ClipboardData(text: message.text)); // 2. 複製文字到剪貼簿

                if (mounted) {
                  // ✨ 總裁級：用極致簡約的小彈窗告訴玩家「複製好了！」
                  _showCenterToast(l10n.chat_msg_copied);
                }
              },
            ),

            if (message.type == 'text')
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.edit_btn),
                onTap: () {
                  Navigator.pop(context);
                  _editMessage(message);
                },
              ),
            // 🗑️ 總裁進化版：按下刪除直接進入「多選選取模式」
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l10n.delete_btn,
                  style: const TextStyle(color: Colors.red)), // 顯示「刪除」
              onTap: () {
                Navigator.pop(context); // 先關掉選單

                // 🚩 啟動多選模式，並自動把玩家長按的這句話打勾
                if (mounted) {
                  setState(() {
                    _isMultiSelectMode = true;
                    _selectedMessageIds.clear(); // 先清空舊的紀錄
                    _selectedMessageIds.add(message.id); // 把目前長按的這句勾起來
                  });
                }

                HapticFeedback.mediumImpact(); // 給個震動回饋，質感提升
              },
            ),

            // 🚩 舉報按鈕
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.chat_report_title),
              onTap: () {
                Navigator.pop(context);

                _openChatReportPage(
                  reportedMessage: message.text,
                );
              },
            ),

            // 💡 建議按鈕
            ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text(l10n.chat_msg_suggest),
              onTap: () {
                Navigator.pop(context);
                _showSuggestionDialog(context);
              },
            ),
          ],
        ));
      },
    );
  }

  // 🚨 1. 舉報對話的彈出視窗 (🌟 接收傳進來的句子)
  Future<void> _openChatReportPage({
    required String reportedMessage,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackPage(
          category: ReportCategory.aiReply,
          lockCategory: true,
          characterId: widget.character.id,
          characterName: widget.character.name,
          sessionId: _sessionId,
          reportedContent: reportedMessage,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ToastUtils.showCenterToast(
        context,
        l10n.chatPageReportReceived,
        customIcon: Icons.mark_email_read_rounded,
      );
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
          title: Text(l10n.chat_suggest_title),
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

                  final currentUserId =
                      FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
                  // 建立一個叫做 'suggestions' 的資料夾來收集建議
                  await FirebaseFirestore.instance
                      .collection('suggestions')
                      .add({
                    'userId': currentUserId,
                    'content': text,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  if (context.mounted) {
                    // ✨ 總裁級：俐落的成功回饋，取代底部的色塊！
                    _showCenterToast(l10n.chat_suggest_success);
                  }
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child: Text(l10n.chat_report_submit,
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ✨ 總裁專屬：批次多選刪除大決戰
  Future<void> _deleteSelectedMessages() async {
    if (_selectedMessageIds.isEmpty || _messagesCollection == null) return;

    final l10n = AppLocalizations.of(context)!;
    final int count = _selectedMessageIds.length;

    // 1. 彈出終極確認視窗
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.confirmDeleteMessagesTitle(count),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(l10n.chat_del_warn),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton,
                style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete_btn,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    // 2. 如果總裁點頭，啟動處決程序
    if (confirmDelete == true) {
      // 顯示轉圈圈
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()));

      try {
        // 🚀 啟動 Firebase 批次作業 (Batch)，一次清空不殘留！
        final batch = FirebaseFirestore.instance.batch();

        for (String id in _selectedMessageIds) {
          final docRef = _messagesCollection!.doc(id);
          batch.delete(docRef);
        }

        await batch.commit(); // 執行批次

        if (mounted) Navigator.pop(context); // 關閉轉圈圈

        // 3. 成功後，關閉多選模式並清空名單
        if (mounted) {
          setState(() {
            _isMultiSelectMode = false;
            _selectedMessageIds.clear();
          });

          // ✨ 總裁級：輕巧置中的成功提示！
          _showCenterToast(
            l10n.chatPageMessagesDeleted(count),
          );
        }
      } catch (e) {
        if (mounted) Navigator.pop(context); // 關閉轉圈圈
        if (mounted) {
          // ✨ 總裁級：刪除失敗的輕量錯誤提示，帶上小紅驚嘆號！
          _showCenterToast('${l10n.delete_failed_msg}: $e', isError: true);
        }
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
        title: Row(
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
            child:
                Text(l10n.cancelButton, style: TextStyle(color: Colors.grey)),
          ),
          // 選項二：僅對話
          TextButton(
            onPressed: () => Navigator.of(context).pop('chat_only'),
            child: Text(l10n.chat_reset_only_chat,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // 選項三：完全重置
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop('full_reset'),
            child: Text(l10n.chat_reset_full,
                style: TextStyle(color: Colors.white)),
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
        'lastMessage': resetType == 'full_reset'
            ? l10n.chat_memory_cleared
            : l10n.chat_history_reset,
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

      if (mounted)
        setState(() {
          _currentStoryTime = null;
          _currentStoryLocation = null;
        });

      // 3. 重新發送開場白
      if (_currentMode != ChatMode.gemini) {
        String firstLine = _currentCharacter.firstLine.isNotEmpty
            ? _currentCharacter.firstLine.replaceAll(
                '{{玩家名字}}',
                _userProfileText.contains('名字:')
                    ? _userProfileText.split('名字:')[1].split('，')[0]
                    : l10n.chat_default_player_name)
            : l10n.chat_default_greeting;

        String initialStoryText = _currentCharacter.initialStory.replaceAll(
            '{{玩家名字}}',
            _userProfileText.contains('名字:')
                ? _userProfileText.split('名字:')[1].split('，')[0]
                : l10n.chat_default_player_name);

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
            ? l10n.chat_reset_full_msg
            : l10n.chat_reset_chat_msg;

        // ✨ 總裁級：用優雅的置中提示，為這段關係的「重新開始」畫下完美句點
        _showCenterToast(snackBarText);
      }
    } catch (e) {
      if (mounted) {
        // ✨ 總裁級：重置失敗的輕量錯誤提示，帶上小紅驚嘆號！
        _showCenterToast(l10n.common_reset_failed(e.toString()), isError: true);
      }
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
              title: Text(
                l10n.chat_edit_char_count(
                    editingController.text.length.toString()),
                style: TextStyle(
                  fontSize: 14,
                  color: editingController.text.length >= 300
                      ? Colors.green
                      : Colors.grey,
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
                    if (mounted) setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: isAiMessage
                        ? l10n.chat_edit_ai_hint
                        : l10n.chat_edit_user_hint,
                  ),
                ),
              ),
              actions: [
                TextButton(
                    child: Text(l10n.cancelButton,
                        style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.of(context).pop()),
                ElevatedButton(
                    child: Text(l10n.confirm_button),
                    onPressed: () =>
                        Navigator.of(context).pop(editingController.text)),
              ],
            );
          },
        );
      },
    );

    // 如果玩家有修改內容且按下確認，就更新到資料庫
    if (newText != null &&
        newText.trim().isNotEmpty &&
        newText.trim() != message.text) {
      try {
        final trimmedText = newText.trim();

        await collection.doc(message.id).update({
          'text': trimmedText,
          'content': trimmedText,
          'isEdited': true,
          'editedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        if (mounted) {
          // ✨ 總裁級：編輯失敗的輕量錯誤提示，為聊天室淨化行動完美收尾！
          _showCenterToast(l10n.common_edit_failed(e.toString()),
              isError: true);
        }
      }
    }
  }

  Future<void> _sendPoke(
      String characterId, String creatorId, String characterName) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    // 取得玩家名稱，若無則顯示「神秘玩家」
    final String playerName =
        currentUser.displayName ?? l10n.chat_mysterious_player;

    try {
      // 🌟 在通知集合中新增一筆「聲線請求」
      await FirebaseFirestore.instance.collection('mailbox').add({
        'type': 'voice_request',
        'fromUserId': currentUser.uid,
        'fromUserName': playerName,
        'toUserId': creatorId, // 接收者：角色的創作者
        'characterId': characterId,
        'characterName': characterName,
        'message': l10n.chat_poke_message(playerName, characterName),
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
      rethrow;
    }
  }

  Future<void> _playAudio(String rawPath) async {
    final path = rawPath.trim();
    final l10n = AppLocalizations.of(context)!;
    if (path.isEmpty) {
      debugPrint('⚠️ 音訊 path 是空的');
      return;
    }

    try {
      _audioPlayer ??= AudioPlayer();

      await _audioPlayer!.stop();

      // 1. 手機本機檔案，例如 /data/user/0/xxx/cache/xxx.aac
      if (!kIsWeb && (path.startsWith('/') || path.startsWith('file://'))) {
        final localPath = path.replaceFirst('file://', '');
        final file = File(localPath);

        if (!await file.exists()) {
          debugPrint('❌ 找不到本機音訊檔: $localPath');

          if (!mounted) return;
          ToastUtils.showCenterToast(
            context,
            l10n.chatPageRecordingNotFound,
            isError: true,
          );
          return;
        }

        final fileSize = await file.length();
        debugPrint('🎧 本機音訊大小: $fileSize bytes');

        if (fileSize <= 0) {
          if (!mounted) return;
          ToastUtils.showCenterToast(
            context,
            l10n.chatPageRecordingEmpty,
            isError: true,
          );
          return;
        }

        await _audioPlayer!.play(
          DeviceFileSource(localPath),
        );

        debugPrint('✅ 播放本機音訊');
        return;
      }

      // 2. Firebase Storage path，例如 user_uploads/xxx/audio-xxx.aac
      String playableUrl = path;

      if (path.startsWith('gs://')) {
        playableUrl = _audioDownloadUrlCache[path] ??
            await FirebaseStorage.instance.ref(path).getDownloadURL();

        _audioDownloadUrlCache[path] = playableUrl;
      } else if (!path.startsWith('http') && !path.startsWith('blob:')) {
        playableUrl = _audioDownloadUrlCache[path] ??
            await FirebaseStorage.instance.ref(path).getDownloadURL();

        _audioDownloadUrlCache[path] = playableUrl;
      }

      debugPrint('🎧 最終播放網址: $playableUrl');

      await _audioPlayer!.play(
        UrlSource(playableUrl),
      );

      debugPrint('✅ 播放雲端音訊');
    } catch (e) {
      debugPrint('❌ 播放音訊失敗: $e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.chatPageAudioPlaybackFailed(e.toString()),
        isError: true,
      );
    }
  }

  Future<void> _pickImage() async {
    await _pickChatImage();
  }

  Future<void> _pickChatImage() async {
    if (_isGenerating || _isLoading) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1080,
      );

      debugPrint('🖼️ pickedFile=${pickedFile?.path}');

      if (pickedFile == null) {
        debugPrint('🖼️ 玩家取消選圖');
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedChatImagePath = pickedFile.path;
      });

      debugPrint('🖼️ 已暫存聊天圖片，等待玩家輸入文字後送出');
    } catch (e) {
      debugPrint('❌ 選擇聊天室圖片失敗: $e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.chatPageSelectPhotoFailed(e.toString()),
        isError: true,
      );
    }
  }

  Widget _buildSelectedChatImagePreview() {
    final imagePath = _selectedChatImagePath;
    if (imagePath == null || imagePath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: kIsWeb
                  ? Image.network(
                      imagePath,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath),
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedChatImagePath = null;
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatImage(String rawPath) {
    final path = rawPath.trim();

    if (path.isEmpty) {
      return _buildChatImageError();
    }

    // 1. 真正的 HTTP 網路圖片
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        width: double.infinity,

        // 聊天圖片通常不需要解碼成原始超大尺寸
        memCacheWidth: 1080,

        placeholder: (context, url) {
          return _buildChatImageLoading();
        },

        errorWidget: (context, url, error) {
          return _buildChatImageError();
        },
      );
    }

    // 2. Web 剛選取、尚未上傳的 blob 圖片
    // blob 不能交給 CachedNetworkImage。
    if (path.startsWith('blob:')) {
      return Image.network(
        path,
        width: double.infinity,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildChatImageLoading();
        },
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _buildChatImageError();
        },
      );
    }

    // 3. Firebase Storage 路徑
    // 例如 user_uploads/xxx/image.jpg
    if (path.startsWith('user_uploads/') ||
        path.startsWith('chat_images/') ||
        path.startsWith('uploads/') ||
        path.startsWith('gs://')) {
      return FutureBuilder<String>(
        future: _resolveImageUrl(path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildChatImageLoading();
          }

          final downloadUrl = snapshot.data?.trim() ?? '';

          if (snapshot.hasError || downloadUrl.isEmpty) {
            return _buildChatImageError();
          }

          return CachedNetworkImage(
            imageUrl: downloadUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            memCacheWidth: 1080,
            placeholder: (context, url) {
              return _buildChatImageLoading();
            },
            errorWidget: (
              context,
              url,
              error,
            ) {
              return _buildChatImageError();
            },
          );
        },
      );
    }

    // 4. Web 上無法使用 FileImage。
    // 若不是 http/blob/Storage 路徑，視為無效圖片。
    if (kIsWeb) {
      return _buildChatImageError();
    }

    // 5. Android / iOS 本機圖片
    final localPath = path.replaceFirst('file://', '');

    final file = File(localPath);

    if (!file.existsSync()) {
      return _buildChatImageError();
    }

    return Image.file(
      file,
      width: double.infinity,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,

      // 限制本機圖片的解碼尺寸
      cacheWidth: 1080,

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return _buildChatImageError();
      },
    );
  }

  Widget _buildChatImageLoading() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 180,
      color: theme.colorScheme.secondaryContainer,
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildChatImageError() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 180,
      color: theme.colorScheme.secondaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        size: 36,
        color: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }

  // ✨ 4. 新增一個 getModeName 函式來處理多國語言
  String _getModeName(ChatMode mode) {
    final l10n = AppLocalizations.of(context)!;

    switch (mode) {
      case ChatMode.daily:
        return l10n.chatModeDaily;
      case ChatMode.story:
        return l10n.chatModeStory;
      case ChatMode.immersive:
        return l10n.chatModeImmersive;
      case ChatMode.gemini:
        return l10n.chat_mode_gemini;
    }
  }

  String _formatRecordDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildRecordingWave(double db) {
    final double normalized = ((db + 60) / 60).clamp(0.08, 1.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(18, (index) {
        final double factor = ((index % 5) + 1) / 5;
        final double height = 8 + normalized * factor * 32;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: 4,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }

  void _showToolbox() {
    final l10n = AppLocalizations.of(context)!;

    StreamSubscription? recorderSub;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        bool showRecordingUI = false;
        bool isCurrentlyRecording = false;
        bool isPreviewPlaying = false;
        bool isSendingVoice = false;
        String? finalAudioPath;
        String? recordingPath;

        double recordDb = -60.0;
        Duration recordDuration = Duration.zero;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter sheetSetState) {
            final theme = Theme.of(context);
            Future<void> startRecording() async {
              if (isCurrentlyRecording) return;

              try {
                if (kIsWeb) {
                  recordingPath = 'web_audio_record.webm';

                  await _recorder!.setSubscriptionDuration(
                    const Duration(milliseconds: 80),
                  );

                  await recorderSub?.cancel();
                  recorderSub = _recorder!.onProgress?.listen((event) {
                    final fallbackDb = -35.0 +
                        ((event.duration.inMilliseconds % 600) / 600) * 18;

                    sheetSetState(() {
                      recordDb = event.decibels ?? fallbackDb;
                      recordDuration = event.duration;
                    });
                  });

                  await _recorder!.startRecorder(
                    toFile: recordingPath,
                    codec: Codec.opusWebM,
                  );

                  sheetSetState(() {
                    isCurrentlyRecording = true;
                    finalAudioPath = null;
                    recordDb = -60.0;
                    recordDuration = Duration.zero;
                  });

                  return;
                }

                final status = await Permission.microphone.request();

                if (status != PermissionStatus.granted) {
                  debugPrint('麥克風權限被拒絕');

                  ToastUtils.showCenterToast(
                    context,
                    l10n.chatPageMicrophonePermissionRequired,
                    isError: true,
                  );
                  return;
                }

                final tempDir = await getTemporaryDirectory();
                recordingPath =
                    '${tempDir.path}/flutter_sound_${DateTime.now().millisecondsSinceEpoch}.aac';

                await _recorder!.setSubscriptionDuration(
                  const Duration(milliseconds: 80),
                );

                await recorderSub?.cancel();
                recorderSub = _recorder!.onProgress?.listen((event) {
                  final fallbackDb = -35.0 +
                      ((event.duration.inMilliseconds % 600) / 600) * 18;

                  sheetSetState(() {
                    recordDb = event.decibels ?? fallbackDb;
                    recordDuration = event.duration;
                  });
                });

                await _recorder!.startRecorder(
                  toFile: recordingPath,
                  codec: Codec.aacADTS,
                );

                sheetSetState(() {
                  isCurrentlyRecording = true;
                  finalAudioPath = null;
                  recordDb = -60.0;
                  recordDuration = Duration.zero;
                });

                debugPrint('🎙️ 開始錄音：$recordingPath');
              } catch (e) {
                debugPrint('❌ 開始錄音失敗: $e');

                ToastUtils.showCenterToast(
                  context,
                  l10n.chatRecordingStartFailed,
                  isError: true,
                );
              }
            }

            Future<void> stopRecording() async {
              if (!isCurrentlyRecording) return;

              try {
                final String? stoppedPath = await _recorder!.stopRecorder();

                await recorderSub?.cancel();
                recorderSub = null;

                final String? path =
                    stoppedPath != null && stoppedPath.isNotEmpty
                        ? stoppedPath
                        : recordingPath;

                debugPrint('✅ 錄音結束，檔案位置: $path');

                sheetSetState(() {
                  isCurrentlyRecording = false;
                  finalAudioPath = path;
                });

                if (path == null || path.isEmpty) {
                  ToastUtils.showCenterToast(
                    context,
                    l10n.chatPageRecordingCreationFailed,
                    isError: true,
                  );
                }
              } catch (e) {
                debugPrint('❌ 停止錄音失敗: $e');

                sheetSetState(() {
                  isCurrentlyRecording = false;
                });

                ToastUtils.showCenterToast(
                  context,
                  l10n.chatPageRecordingFailed(e.toString()),
                  isError: true,
                );
              }
            }

            Future<void> playRecordedAudio() async {
              if (finalAudioPath == null || finalAudioPath!.isEmpty) {
                debugPrint('⚠️ 沒有錄音檔可以播放');
                return;
              }

              try {
                final path = finalAudioPath!;
                debugPrint('🎵 準備播放錄音: $path');

                // 如果 _audioPlayer 是 nullable，保險起見先初始化
                _audioPlayer ??= AudioPlayer();

                if (isPreviewPlaying) {
                  await _audioPlayer!.stop();

                  sheetSetState(() {
                    isPreviewPlaying = false;
                  });

                  return;
                }

                await _audioPlayer!.stop();

                if (kIsWeb ||
                    path.startsWith('http') ||
                    path.startsWith('blob:')) {
                  await _audioPlayer!.play(
                    UrlSource(path),
                  );
                } else {
                  final file = File(path);

                  if (!await file.exists()) {
                    debugPrint('❌ 錄音檔不存在: $path');

                    ToastUtils.showCenterToast(
                      context,
                      l10n.chatPageRecordingNotFoundRetry,
                      isError: true,
                    );
                    return;
                  }

                  final fileSize = await file.length();
                  debugPrint('🎵 錄音檔大小: $fileSize bytes');

                  if (fileSize <= 0) {
                    ToastUtils.showCenterToast(
                      context,
                      l10n.chatPageRecordingEmptyRetry,
                      isError: true,
                    );
                    return;
                  }

                  await _audioPlayer!.play(
                    DeviceFileSource(path),
                  );
                }

                sheetSetState(() {
                  isPreviewPlaying = true;
                });

                _audioPlayer!.onPlayerComplete.first.then((_) {
                  sheetSetState(() {
                    isPreviewPlaying = false;
                  });
                });

                debugPrint('✅ 錄音開始播放');
              } catch (e) {
                debugPrint('❌ 播放錄音失敗: $e');

                ToastUtils.showCenterToast(
                  context,
                  l10n.chatRecordingPlaybackFailed,
                  isError: true,
                );
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
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                tooltip: l10n.profilePageCancel,
                                onPressed: isCurrentlyRecording
                                    ? null
                                    : () {
                                        sheetSetState(() {
                                          showRecordingUI = false;
                                        });
                                      },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  isCurrentlyRecording
                                      ? l10n.chat_record_recording
                                      : finalAudioPath == null
                                          ? l10n.chat_tool_record
                                          : l10n.chat_record_done,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (isCurrentlyRecording) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fiber_manual_record,
                                  color: Colors.redAccent,
                                  size: 14,
                                ),
                                const SizedBox(width: 8),
                                _buildRecordingWave(recordDb),
                                const SizedBox(width: 12),
                                Text(
                                  _formatRecordDuration(recordDuration),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            InkWell(
                              onTap: stopRecording,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.stop_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 42,
                                ),
                              ),
                            ),
                          ] else if (finalAudioPath != null) ...[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    .withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isPreviewPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                    ),
                                    onPressed: playRecordedAudio,
                                  ),
                                  Expanded(
                                    child: _buildRecordingWave(-25),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatRecordDuration(recordDuration),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.redAccent,
                                  iconSize: 32,
                                  onPressed: () async {
                                    await _audioPlayer?.stop();

                                    final pathToDelete = finalAudioPath;

                                    if (pathToDelete != null &&
                                        pathToDelete.isNotEmpty &&
                                        !kIsWeb) {
                                      final file = File(pathToDelete);
                                      if (await file.exists()) {
                                        await file.delete();
                                      }
                                    }

                                    sheetSetState(() {
                                      finalAudioPath = null;
                                      recordingPath = null;
                                      isPreviewPlaying = false;
                                      recordDuration = Duration.zero;
                                      recordDb = -60.0;
                                    });

                                    debugPrint('🗑️ 已刪除錄音預覽，不會送出');
                                  },
                                ),
                                const SizedBox(width: 28),
                                _isGenerating
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.stop_circle_outlined,
                                          color: Colors.red,
                                          size: 36,
                                        ),
                                        onPressed: _stopGenerating,
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.send_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 36,
                                        ),
                                        onPressed: isSendingVoice
                                            ? null
                                            : () async {
                                                final path = finalAudioPath;

                                                if (path == null ||
                                                    path.isEmpty) {
                                                  ToastUtils.showCenterToast(
                                                    context,
                                                    l10n.chatPageNoRecordingToSend,
                                                    isError: true,
                                                  );
                                                  return;
                                                }

                                                sheetSetState(() {
                                                  isSendingVoice = true;
                                                });

                                                await _audioPlayer?.stop();

                                                debugPrint(
                                                    '📤 準備送出語音 path=$path');

                                                Navigator.pop(context);

                                                await _sendMessage(
                                                  text: '[語音訊息]',
                                                  audioPath: path,
                                                  showInChat: true,
                                                );
                                              },
                                      ),
                              ],
                            ),
                          ] else ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.18),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Material(
                                    color: theme.colorScheme.primary,
                                    shape: const CircleBorder(),
                                    elevation: 3,
                                    shadowColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.35),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: startRecording,
                                      child: SizedBox(
                                        width: 76,
                                        height: 76,
                                        child: Icon(
                                          Icons.mic_rounded,
                                          color: theme.colorScheme.onPrimary,
                                          size: 38,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.chat_record_start,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
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
                          _buildToolItem(
                              Icons.backpack_outlined, l10n.chat_tool_backpack,
                              () {
                            Navigator.pop(context); // 關閉下方工具選單
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BackpackPage(
                                          character: _currentCharacter,
                                          onUseEgg: (eggData) {
                                            if (eggData['setScene'] != null &&
                                                eggData['setScene']
                                                    .toString()
                                                    .isNotEmpty) {
                                              if (mounted)
                                                setState(() {
                                                  _currentStoryLocation =
                                                      eggData['setScene'];
                                                });
                                            }
                                            // 背包彩蛋屬於獨立的 AI 請求，
// 必須建立自己的取消識別碼。
                                            final String specialRequestId =
                                                _createAiRequestId();

                                            _activeAiRequestId =
                                                specialRequestId;

                                            _executeMessageSending(
                                              userText: l10n
                                                  .chat_special_story_trigger(
                                                eggData['title'],
                                              ),
                                              clientRequestId: specialRequestId,
                                              overridePrompt: eggData['prompt'],
                                            );
                                          },
                                        )));
                          }),

                          // 📖 2. 劇情摘要
                          _buildToolItem(
                            Icons.article_outlined,
                            l10n.chat_tool_story,
                            () async {
                              final String? currentSessionId = _sessionId !=
                                          null &&
                                      _sessionId!.trim().isNotEmpty
                                  ? _sessionId!.trim()
                                  : widget.sessionId != null &&
                                          widget.sessionId!.trim().isNotEmpty
                                      ? widget.sessionId!.trim()
                                      : null;

                              if (currentSessionId == null) {
                                ToastUtils.showCenterToast(
                                  context,
                                  l10n.chatRoomNotReady,
                                  isError: true,
                                );
                                return;
                              }

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => StorySummaryPage(
                                    character: _currentCharacter,

                                    // 目前真正開啟的聊天室 ID
                                    sessionId: currentSessionId,
                                  ),
                                ),
                              );
                            },
                          ),

                          // 🖼️ 3. 照片
                          _buildToolItem(Icons.photo_library_outlined,
                              l10n.chat_tool_photo, () {
                            Navigator.pop(context);
                            _pickImage();
                          }),

                          // 🎙️ 4. 錄音切換鍵 (按下去就會把 showRecordingUI 變成 true)
                          _buildToolItem(Icons.mic_none, l10n.chat_tool_record,
                              () {
                            sheetSetState(() => showRecordingUI = true);
                          }),

                          // 🪪 5. 拾光檔案
                          _buildToolItem(
                              Icons.badge_outlined, l10n.chat_tool_profile, () {
                            final safeContext = this.context;
                            Navigator.pop(context); // 關閉工具列

                            // 🌟 總裁級魔法：如果還沒有 sessionId，發放一張專屬的「臨時身分證」
                            final String safeRoomId = widget.sessionId ??
                                'draft_${widget.characterId}';

                            // ✨ 直接放行開啟視窗，不再阻擋玩家！
                            UserProfilePopup.show(
                              safeContext,
                              roomId: safeRoomId, // 傳入保證安全的房間 ID
                              characterId: widget.characterId,
                              onSaved: () async {
                                // 這裡同步使用 safeRoomId 去重撈大腦記憶
                                await _checkProfileCompletion(
                                    safeRoomId, widget.characterId);

                                if (mounted) {
                                  // ✨ 成功也換成優雅的置中彈窗！
                                  ToastUtils.showCenterToast(
                                      safeContext, l10n.profileUpdatedSuccess);
                                }
                              },
                            );
                          }),
                          // 👆 6. 互動玩法
                          _buildToolItem(
                              Icons.touch_app_outlined, l10n.chat_tool_interact,
                              () {
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

  Widget _buildRichTextMessage(String text,
      {required TextStyle normalStyle, required TextStyle actionStyle}) {
    final regex = RegExp(r'/\*(.*?)\*/', dotAll: true);
    final spans = <TextSpan>[];
    int lastMatchEnd = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: normalStyle));
      }
      final actionContent = match.group(1) ?? '';
      spans.add(TextSpan(text: '*$actionContent*', style: actionStyle));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      spans.add(
          TextSpan(text: text.substring(lastMatchEnd), style: normalStyle));
    }
    if (spans.isEmpty) {
      return Text(text, style: normalStyle);
    }
    return RichText(text: TextSpan(children: spans));
  }

  ImageProvider _getAvatarProvider(String rawPath) {
    final path = rawPath.trim();

    if (path.isEmpty) {
      return const AssetImage(
        'assets/images/avatar1.png',
      );
    }

    // 網路圖片使用快取
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImageProvider(path);
    }

    // App 內建圖片
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }

    // 手機本地檔案
    if (!kIsWeb) {
      final file = File(path);

      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    return const AssetImage(
      'assets/images/avatar1.png',
    );
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
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic),
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
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length - 1));
      return;
    }
    final newText = text.substring(0, selection.baseOffset) +
        markdown +
        text.substring(selection.extentOffset);
    controller.text = newText;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: newPosition));
  }

  int _getNextStageThreshold(int currentScore) => _flowerStages
      .firstWhere((stage) => currentScore < stage.threshold,
          orElse: () => _flowerStages.last)
      .threshold;
  FlowerStage _getCurrentStage(int currentScore) {
    return _flowerStages.lastWhere(
      (stage) => currentScore >= stage.threshold,
      // 🌟 找不到（例如負數）時，強制回傳列表中的第一個（通常是陌生/初識）
      orElse: () => _flowerStages.first,
    );
  }

  Future<void> _loadRegenerateCount() async {
    final user = FirebaseAuth.instance.currentUser;

    final String? regenerateSessionId = _sessionId ?? widget.sessionId;

    if (user == null || regenerateSessionId == null) {
      return;
    }
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('aiRequests')
        .doc(regenerateSessionId);

    try {
      final doc = await docRef.get();
      final data = doc.data();

      if (data == null || data['lastRegenerateDate'] != todayStr) {
        // 新的一天，重置回滿
        await docRef.set({
          'regenerateCount': _maxRegenerateCount,
          'lastRegenerateDate': todayStr,
        }, SetOptions(merge: true));

        if (!mounted) return;

        setState(() {
          _freeRegenerateCount = _maxRegenerateCount;
        });

        return;
      }

      final savedCount = data['regenerateCount'];
      int currentCount = savedCount is int ? savedCount : _maxRegenerateCount;

      // 🔥 核心修正：如果資料庫存的次數「大於」現在的上限（代表月卡剛過期），強制壓回上限
      if (currentCount > _maxRegenerateCount) {
        currentCount = _maxRegenerateCount;
        // 可選：順便把正確的數字寫回 Firebase，保持資料庫乾淨
        docRef.set({'regenerateCount': currentCount}, SetOptions(merge: true));
      }

      if (!mounted) return;

      setState(() {
        _freeRegenerateCount = currentCount;
      });
    } catch (e) {
      debugPrint('⚠️ 讀取重新生成次數失敗: $e');
    }
  }

  Future<bool> _consumeRegenerateCount() async {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    final String? regenerateSessionId = _sessionId ?? widget.sessionId;

    if (user == null || regenerateSessionId == null) {
      return false;
    }

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('aiRequests')
        .doc(regenerateSessionId);
    try {
      int newCount = 0;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        final data = doc.data() ?? {};

        final String? lastDate = data['lastRegenerateDate']?.toString();

        int currentCount;

        if (lastDate != todayStr) {
          currentCount = _maxRegenerateCount;
        } else {
          final savedCount = data['regenerateCount'];
          currentCount = savedCount is int ? savedCount : _maxRegenerateCount;

          // 🔥 核心修正：消費扣除前也要檢查，避免用舊的高額度
          if (currentCount > _maxRegenerateCount) {
            currentCount = _maxRegenerateCount;
          }
        }

        if (currentCount <= 0) {
          throw Exception(l10n.chatRegenerateLimitReached);
        }

        newCount = currentCount - 1;

        transaction.set(
            docRef,
            {
              'regenerateCount': newCount,
              'lastRegenerateDate': todayStr,
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));
      });

      if (!mounted) return true;

      setState(() {
        _freeRegenerateCount = newCount;
      });

      return true;
    } catch (e) {
      debugPrint('⚠️ 扣除重新生成次數失敗: $e');
      return false;
    }
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: theme.cardColor.withValues(alpha: 0.95),
          children: <Widget>[
            ...modeDetails.map((info) {
              final mode = info['mode'] as ChatMode;
              final isSelected = _currentMode == mode;
              return SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                onPressed: () async {
                  if (mounted)
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
                    color: isSelected
                        ? (info['color'] as Color).withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: isSelected
                        ? Border.all(color: info['color'] as Color, width: 2)
                        : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(info['icon'] as IconData,
                          color: info['color'] as Color, size: 28),
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
                                    color: isSelected
                                        ? (info['color'] as Color)
                                        : theme.colorScheme.onSurface,
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
                              style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Divider(color: theme.dividerColor.withValues(alpha: 0.5)),
            ),

            // ☎️ 3. 專屬的「通話」按鈕登場！
            SimpleDialogOption(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24)
                  .copyWith(bottom: 16),
              onPressed: () {
                // 🌟 1. 先關閉對話框選單
                Navigator.pop(context);
                // 🌟 2. 判斷是否有聲線 ID
                if (widget.character.voiceId == null ||
                    widget.character.voiceId!.isEmpty) {
                  // 🎭 3. 跳出第一個 SnackBar：提示目前沒聲音 + 「戳一下」按鈕
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: [
                          const Icon(Icons.volume_mute_rounded,
                              color: Colors.orangeAccent, size: 28),
                          const SizedBox(width: 8),
                          Text(l10n.no_voice_available,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                        ],
                      ),
                      // 這裡放入你原本的沒語音提示文字
                      content: Text(
                          l10n.chat_no_voice_msg(widget.character.name),
                          style: const TextStyle(fontSize: 16)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(l10n.cancelButton ?? '取消',
                              style: const TextStyle(color: Colors.grey)),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          icon: const Icon(Icons.touch_app,
                              size: 18), // 加個可愛的點擊圖示
                          label: Text(l10n.chat_poke_btn), // 你的「戳一下」按鈕
                          onPressed: () async {
                            // 1. 玩家按下戳戳後，先關閉這個催更彈窗
                            Navigator.pop(dialogContext);

                            // 2. 執行你的雲端戳戳邏輯
                            try {
                              await _sendPoke(
                                  widget.character.id,
                                  widget.character.createdBy,
                                  widget.character.name);

                              // 🌟 3. 成功後，華麗呼叫你的自動消失小彈窗！
                              if (mounted) {
                                _showCenterToast(l10n.chat_poke_success);
                              }
                            } catch (e) {
                              debugPrint("戳戳失敗: $e");
                            }
                          },
                        ),
                      ],
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
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1),
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
                    Text(
                      l10n.chat_voice_call,
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
      {
        'name': l10n.gift_heart,
        'icon': Icons.favorite,
        'color': Colors.redAccent,
        'cost': 1
      },
      {
        'name': l10n.gift_flower,
        'icon': Icons.local_florist,
        'color': Colors.pinkAccent,
        'cost': 1
      },
      {
        'name': l10n.gift_sun,
        'icon': Icons.wb_sunny,
        'color': Colors.orangeAccent,
        'cost': 1
      },
      {
        'name': l10n.gift_confetti,
        'icon': Icons.celebration,
        'color': Colors.blueAccent,
        'cost': 3
      },
      {
        'name': l10n.gift_coffee,
        'icon': Icons.coffee,
        'color': Colors.brown,
        'cost': 5
      },
      {
        'name': l10n.gift_cake,
        'icon': Icons.cake,
        'color': Colors.purpleAccent,
        'cost': 5
      },
    ];
  }

  // 💡 注意：這裡傳入的參數從 String characterName 變成了 整個 Character 物件！
  int _calculateGiftAffection(Character character, String giftName) {
    // 1️⃣ 檢查：這個禮物有沒有在他「喜歡」的清單裡？
    if (character.likedGifts != null &&
        character.likedGifts!.contains(giftName)) {
      return 10; // 命中紅心！加很多好感度
    }

    // 2️⃣ 檢查：這個禮物有沒有在他「討厭」的清單裡？
    else if (character.dislikedGifts != null &&
        character.dislikedGifts!.contains(giftName)) {
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
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.local_florist, color: Colors.pinkAccent), // 花朵圖示
              const SizedBox(width: 8),
              // ✨ 替換：心意不足
              Text(l10n.gift_insufficient_title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          // ✨ 替換：接上新的提示問句
          content: Text(
            '${l10n.chat_gift_points_needed(gift['cost'].toString())}\n\n'
            '${l10n.gift_insufficient_prompt}'
            '${kIsWeb ? '\n\n$_webPurchaseUnavailableMessage' : ''}',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              // ✨ 替換：先不要 (若有 cancelButton 則優先使用)
              child: Text(l10n.cancelButton ?? l10n.not_now,
                  style: const TextStyle(color: Colors.grey)),
            ),
            if (!kIsWeb)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext); // 先關閉彈窗

                  // 🚀 飛向商城或是任務頁面！(請換成你實際的頁面名稱)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const StorePage()), // 或 TaskPage()
                  );
                },
                // ✨ 替換：前往獲取
                child: Text(l10n.go_to_get),
              ),
          ],
        ),
      );
      return;
    }

    int oldScore = _currentFriendship; // 👈 埋入偵測點 A：紀錄舊分數
    int affectionChange =
        _calculateGiftAffection(_currentCharacter, gift['name']);
    int newScore = oldScore + affectionChange; // 👈 計算新分數

    // 3. 🛡️ 啟動雲端同步！
    // 我們先扣除本地點數並加好感度 (讓玩家感覺「秒更新」)，同時非同步上傳 Firebase
    if (mounted)
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
    String displayText = l10n.chat_sys_gift(
        playerName, gift['name']); // 📦 B 包：偷偷塞給 AI 的 (包含好感度與人設指令，不顯示在畫面上)
    String aiSecretPrompt =
        "【系統事件】$playerName送出了一個【${gift['name']}】。(系統隱藏提示：這是你『$preferenceTag』的禮物，好感度 $affectionChange。請根據角色性格與當前場景，給出最真實的反應。)";

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
    // ✨ 1. 請翻譯官進來
    final l10n = AppLocalizations.of(context)!;
    // ✨ 2. 加上 (l10n)，讓系統確實去比較「翻譯出來的文字」是不是真的變了！
    if (oldScore.relationshipTitle(l10n) != newScore.relationshipTitle(l10n) &&
        newScore > oldScore) {
      _showLevelUpDialog(newScore, true); // 只有真正跨越階級時，才會跳出華麗視窗
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
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(30),
              // ✨ 邊框發光特效
              border: isSoulmate
                  ? Border.all(color: Colors.amberAccent, width: 3) // 靈魂伴侶專屬金邊
                  : Border.all(
                      color: newScore.titleColor.withValues(alpha: 0.3),
                      width: 1),
              boxShadow: [
                // 基礎陰影
                BoxShadow(
                    color: newScore.titleColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2),
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
                Icon(isSoulmate ? Icons.favorite : Icons.auto_awesome,
                    color: isSoulmate ? Colors.redAccent : newScore.titleColor,
                    size: 80 // 縮放一點點更有視覺衝擊
                    ),
                const SizedBox(height: 16),
                Text(
                  isSoulmate
                      ? l10n.chat_levelup_soulmate
                      : l10n.chat_levelup_normal,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),

                // 稱號顯示盒
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSoulmate
                          ? [
                              Colors.amber.withValues(alpha: 0.4),
                              Colors.orangeAccent.withValues(alpha: 0.2)
                            ]
                          : [
                              newScore.titleColor.withValues(alpha: 0.2),
                              newScore.titleColor.withValues(alpha: 0.05)
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    newScore.relationshipTitle(l10n),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSoulmate
                            ? Colors.orange[900]
                            : newScore.titleColor),
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
                      height: 1.6),
                ),
                const SizedBox(height: 32),

                // 👑 總裁按鈕戰術群組：將單一按鈕升級為雙軌制
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🚀 1. 主打炫耀按鈕：引導玩家扣下裂變板機
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: Text(l10n.chat_levelup_share_btn,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSoulmate
                            ? Colors.amber[700]
                            : newScore.titleColor,
                        foregroundColor: Colors.white,
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () async {
                        // 🪄 自動抓取當前玩家身份作為邀請碼
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;
                        final displayCode =
                            user.uid.substring(0, 8).toUpperCase();
                        // 🪄 自動抓取當前聊天室內互動的角色名字
                        final characterName = _currentCharacter.name;
                        // 🪄 動態組裝千人千面的行銷文案
                        final shareText = l10n.profile_share_message(
                            characterName, displayCode);
                        // ⚡ 喚起跨平台原生分享面板
                        await Share.share(shareText);
                        // 分享完畢後，貼心自動關閉視窗，讓體驗流暢無阻
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    // 🏳️ 2. 次要關閉按鈕：留給害羞不想分享的玩家，改為溫柔的 TextButton 降低搶眼度
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        isSoulmate
                            ? l10n.chat_levelup_btn_soulmate
                            : l10n.chat_levelup_btn_normal,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
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
          content: SingleChildScrollView(
            // 避免鍵盤擋住畫面
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✨ 預設地點選單
                ...[
                  l10n.chat_loc_1,
                  l10n.chat_loc_2,
                  l10n.chat_loc_3,
                  l10n.chat_loc_4
                ].map((loc) => ListTile(
                      title: Text(loc),
                      trailing:
                          const Icon(Icons.send, size: 18, color: Colors.blue),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context); // 關閉視窗
                        _sendMessage(text: l10n.chat_player_sent_location(loc));
                      },
                    )),

                const Divider(height: 20), // 分隔線
                // ✨ 玩家自訂地點輸入框
                TextField(
                  controller: customLocationController,
                  decoration: InputDecoration(
                    hintText: l10n.chat_loc_hint,
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
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
                  _sendMessage(
                      text: l10n.chat_player_sent_location(
                          customLocationController.text.trim()));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(l10n.chat_loc_custom_btn,
                  style: TextStyle(color: Colors.white)),
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
        : l10n.chat_opponent;

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
      barrierColor:
          Colors.black.withValues(alpha: 0.5), // ✨ 把名字換成 barrierColor！
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
      aiActionPrompt =
          "對方贏了！系統秘密指令：請根據你的傲嬌性格，表現出願賭服輸的無奈，或者是雖然輸了但嘴硬傲嬌耍賴的反應。請將這個反應融入對話中，並自然的開啟新話題。";
    } else if (aiRoll > playerRoll) {
      resultText = "${aiName}贏了！";
      // 如果學長贏了，要他得意
      aiActionPrompt = "對方贏了！系統秘密指令：表現出獲勝後的得意洋洋，或是帶點寵溺的語氣取笑玩家的運氣壞，並自然的開啟新話題。";
    } else {
      resultText = "平手！";
      aiActionPrompt = "平手了。系統秘密指令：表現出驚訝或是有趣的反應，或是提議再擲一次，並自然的開啟新話題。";
    }
    // 4. 🔑 組裝「極簡沉浸版」咒語 (B包，偷偷塞給AI)
    String secretPrompt = "【系統事件】骰子對決！"
        "\n🎲 （$playerName擲出了 $playerRoll 點，$aiName擲出了 $aiRoll 點。結果：$resultText）"
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                // 🐛 2. 修復 Bug：必須用上面傳下來的 scrollController，底板才能跟著手指滑動伸縮！
                controller: scrollController,
                // ✨ 3. 加入隱形感應網，捕捉「空白處」的點擊
                child: GestureDetector(
                  behavior: HitTestBehavior
                      .translucent, // 🌟 關鍵魔法：讓點擊事件可以穿透捕捉到「沒有元件的空白處」
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
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      Text(l10n.chat_interact_title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      // 🏃‍♀️ 玩法 1：肢體互動
                      Text(l10n.chat_interact_action,
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildActionChip(context, '👉', l10n.chat_action_poke,
                              l10n.chat_action_poke_prompt),
                          _buildActionChip(context, '🫂', l10n.chat_action_hug,
                              l10n.chat_action_hug_prompt),
                          _buildActionChip(context, '🤝', l10n.chat_action_hand,
                              l10n.chat_action_hand_prompt),
                        ],
                      ),
                      const Divider(height: 30),
                      // 🎁 玩法 2：送小禮物
                      Text(l10n.chat_interact_gift,
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                            avatar: Icon(gift['icon'] as IconData,
                                color: gift['color'] as Color, size: 18),
                            label: Text(
                              '${gift['name']} (${gift['cost']})',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                            backgroundColor: theme.scaffoldBackgroundColor
                                .withValues(alpha: 0.5),
                            side: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.1)),
                            onPressed: () => _handleSendGift(gift),
                          );
                        },
                      ),
                      const Divider(height: 30),
                      // 📍 其他功能
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on,
                            color: Colors.blue, size: 22),
                        title: Text(l10n.chat_menu_send_location,
                            style: TextStyle(fontSize: 14)),
                        onTap: () => _handleLocationSend(),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.casino,
                            color: Colors.orange, size: 22),
                        title: Text(l10n.chat_dice_btn,
                            style: TextStyle(fontSize: 14)),
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

  // 🗑️ 多選刪除專用的底部操作列
  Widget _buildMultiSelectBottomBar() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.95),
        boxShadow: const [
          BoxShadow(blurRadius: 4, offset: Offset(0, -1), color: Colors.black12)
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. 取消按鈕
            TextButton(
              onPressed: () {
                if (mounted)
                  setState(() {
                    _isMultiSelectMode = false;
                    _selectedMessageIds.clear(); // 放棄處決，清空名單
                  });
              },
              child: Text(l10n.cancelButton,
                  style: const TextStyle(color: Colors.grey, fontSize: 16)),
            ),

            // ✨ 總裁修復魔法：用 Expanded 包起來，強制在剩餘空間內置中！
            Expanded(
              child: Text(
                l10n.selectedMessagesCount(_selectedMessageIds.length),
                textAlign: TextAlign.center, // 讓文字乖乖置中
                overflow: TextOverflow.ellipsis, // 如果字數真的太多會變點點點，不報錯
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            ),

            // 3. 處決按鈕
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text(l10n.delete_btn),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedMessageIds.isEmpty
                    ? Colors.grey
                    : Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed:
                  _selectedMessageIds.isEmpty ? null : _deleteSelectedMessages,
            ),
          ],
        ),
      ),
    );
  }

// 提取出 ActionChip 建造器，讓程式碼更乾淨
  Widget _buildActionChip(
      BuildContext context, String emoji, String label, String message) {
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
        boxShadow: const [
          BoxShadow(blurRadius: 4, offset: Offset(0, -1), color: Colors.black12)
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (mounted)
                  setState(() {
                    _isScreenshotMode = false;
                    _selectedMessageIds.clear();
                  });
              },
              child: Text(l10n.cancel,
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            Expanded(
              child: Text(
                l10n.selectedMessagesCount(_selectedMessageIds.length),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.share, size: 18),
              label: Text(l10n.screenshotShare),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _selectedMessageIds.isEmpty ? Colors.grey : Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed:
                  _selectedMessageIds.isEmpty ? null : _generateAndShareImage,
            ),
          ],
        ),
      ),
    );
  }

  // 📸 2. 在幕後畫一張美美的長圖畫布 (全視角主題換色版)
  Widget _buildScreenshotCanvas(List<ChatMessage> selectedMsgs) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // 🎨 決定浮水印顏色
    Color getWatermarkColor() {
      if (_watermarkStyle == 1) return Colors.white;
      if (_watermarkStyle == 2) return Colors.black87;

      // ✨ 模式 0：一樣跟著 surface 的對比色
      return theme.colorScheme.onSurface;
    }

    // 🌌 動態決定背景樣式
    BoxDecoration getBackgroundDecoration() {
      if (_watermarkStyle == 1) {
        return const BoxDecoration(color: Color(0xFF1A1A24)); // 曜石黑
      } else if (_watermarkStyle == 2) {
        return const BoxDecoration(color: Color(0xFFF5F6F8)); // 晨曦白
      }

      // ✨ 模式 0：跟隨 App 的「背景底色」(亮色模式通常是白/灰，暗色模式是黑)
      return BoxDecoration(
        color: theme.colorScheme.surface,
      );
    }

    // 🖋️ 動態決定標題與分隔線顏色
    Color getTitleColor() {
      if (_watermarkStyle == 1) return Colors.white;
      if (_watermarkStyle == 2) return Colors.black87;

      // ✨ 模式 0：跟著 surface 變換對比色 (亮色模式變黑字，暗色模式變白字)
      return theme.colorScheme.onSurface;
    }

    return MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: getBackgroundDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🏆 頂部標題 (顏色動態跟隨)
                Text(
                  l10n.exclusiveMomentsWith(_currentCharacter.name),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getTitleColor(), // ✨ 顏色連動
                    // 如果是亮色背景，就把陰影拿掉比較乾淨
                    shadows: _watermarkStyle == 2
                        ? null
                        : const [
                            BoxShadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ],
                  ),
                ),
                const SizedBox(height: 24),

                // 💬 渲染對話 (這段維持不變)
                ...selectedMsgs.map((msg) {
                  final bool isUser = msg.sender == 'user';
                  final bool isSystem = msg.sender == 'system';

                  // 截圖主題為「跟隨 App」時，完全沿用聊天室色彩。
                  final Color bubbleColor;

                  if (_watermarkStyle == 0) {
                    // 跟隨 App 主題。
                    bubbleColor = isUser
                        ? theme.colorScheme.primary
                        : isSystem
                        ? theme.cardColor.withValues(alpha: 0.72)
                        : theme.colorScheme.surfaceVariant;
                  } else if (_watermarkStyle == 1) {
                    // 曜石黑：所有訊息統一黑色氣泡。
                    bubbleColor = const Color(0xFF171419);
                  } else {
                    // 晨曦白。
                    bubbleColor = isUser
                        ? theme.colorScheme.primary
                        : Colors.black.withValues(alpha: 0.06);
                  }
                  final Color normalTextColor;

                  if (_watermarkStyle == 1) {
                    // 曜石黑模式全部使用白字。
                    normalTextColor = Colors.white;
                  } else if (isUser) {
                    normalTextColor = theme.colorScheme.onPrimary;
                  } else if (isSystem) {
                    normalTextColor =
                        theme.colorScheme.onSurface.withValues(alpha: 0.8);
                  } else if (_watermarkStyle == 2) {
                    normalTextColor = Colors.black87;
                  } else {
                    normalTextColor = theme.colorScheme.primary;
                  }

                  final Color actionTextColor;

                  if (_watermarkStyle == 1) {
                    // 曜石黑模式的括號旁白使用較淡白色。
                    actionTextColor =
                        Colors.white.withValues(alpha: 0.68);
                  } else if (isUser) {
                    actionTextColor =
                        theme.colorScheme.onPrimary.withValues(alpha: 0.72);
                  } else if (_watermarkStyle == 2) {
                    actionTextColor = Colors.black54;
                  } else {
                    actionTextColor = theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7);
                  }
                  final String rawDisplayText = isUser
                      ? msg.text
                      : _getCleanAiMessage(msg.text);

                  final String displayText = rawDisplayText
                      .replaceAll('(玩家名字)', _playerNickname)
                      .replaceAll('{{玩家名字}}', _playerNickname)
                      .replaceAll('【玩家名字】', _playerNickname);

                  Widget messageBody;

                  if (isSystem) {
                    messageBody = Text(
                      displayText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: normalTextColor,
                        fontSize: 14,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  } else if (isUser) {
                    messageBody = _buildRichTextMessage(
                      displayText,
                      normalStyle: TextStyle(
                        color: normalTextColor,
                        fontSize: 15,
                        height: 1.45,
                      ),
                      actionStyle: TextStyle(
                        color: actionTextColor,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    );
                  } else {
                    messageBody = _buildRichTextMessage(
                      displayText,
                      normalStyle: TextStyle(
                        color: normalTextColor,
                        fontSize: 15,
                        height: 1.45,
                      ),
                      actionStyle: TextStyle(
                        color: actionTextColor,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    );
                  }

                  // 系統故事／旁白維持中央卡片，不顯示角色頭像。
                  if (isSystem) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        left: 28,
                        right: 28,
                        bottom: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(12),
                        border: _watermarkStyle == 1
                            ? Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        )
                            : null,
                      ),
                      child: messageBody,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                            theme.colorScheme.secondaryContainer,
                            backgroundImage: _getAvatarProvider(
                              _currentCharacter.avatarPath,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(20),
                              border: _watermarkStyle == 1
                                  ? Border.all(
                                color: Colors.white.withValues(alpha: 0.14),
                              )
                                  : null,
                            ),
                            child: messageBody,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),
                // ✨ 分隔線顏色也跟著標題變色！
                Divider(
                    color: getTitleColor().withValues(alpha: 0.2), height: 1),
                const SizedBox(height: 16),

                // 🦋 底部浮水印：質感膠囊 (沒有按鈕版)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _watermarkStyle == 0
                            ? theme.colorScheme.primary.withValues(alpha: 0.2)
                            : (_watermarkStyle == 1
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/butterfly_icon.svg',
                            height: 18,
                            colorFilter: ColorFilter.mode(
                                getWatermarkColor(), BlendMode.srcIn),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.downloadToUnlock,
                            style: TextStyle(
                              fontSize: 12,
                              color: getWatermarkColor(),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
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

  Widget _buildPendingMediaBubble(Map<String, dynamic> item) {
    final type = item['type']?.toString() ?? '';
    final path = item['path']?.toString() ?? '';
    final text = item['text']?.toString().trim() ?? '';
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.55,
              child: type == 'image'
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildChatImage(path),
                          ),
                          if (text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded),
                              const SizedBox(width: 8),
                              _buildStaticAudioWave(),
                              const SizedBox(width: 8),
                              Text(l10n.chatPageVoiceUploading),
                            ],
                          ),
                          if (text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              text,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticAudioWave() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(12, (index) {
        final height = 8.0 + ((index % 5) * 4.0);

        return Container(
          width: 3,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }

  // 📸 3. 喀嚓！正式拍照、預覽並分享 (總裁動態重拍版)
  Future<void> _generateAndShareImage() async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final msgsToExport = _localMessages
          .where(
            (m) => _selectedMessageIds.contains(m.id),
          )
          .toList()
        ..sort(
          (a, b) => a.timestamp.compareTo(b.timestamp),
        );

      try {
        await precacheImage(
          _getAvatarProvider(
            _currentCharacter.avatarPath,
          ),
          context,
        );
      } catch (e) {
        debugPrint(
          '截圖前預載角色頭像失敗：$e',
        );
      }

      // 🚀 字數與換行【極致緊緻版】高度精算
      double canvasHeight = 150.0;
      for (var msg in msgsToExport) {
        canvasHeight += 45.0;
        List<String> paragraphs = msg.text.split('\n');
        for (var p in paragraphs) {
          int lines = (p.length / 18).ceil();
          if (lines == 0) lines = 1;
          canvasHeight += (lines * 28.0);
        }
        canvasHeight += 12.0;
      }
      canvasHeight += 80.0;

      // 📸 總裁秘製：把「拍照」獨立成一個小函數，這樣換顏色時可以隨時呼叫它重拍！
      Future<Uint8List> takePicture() async {
        return await _screenshotController.captureFromWidget(
          UnconstrainedBox(
            clipBehavior: Clip.hardEdge,
            child: _buildScreenshotCanvas(
                msgsToExport), // 這裡會讀取最新的 _watermarkStyle
          ),
          delay: const Duration(milliseconds: 120),
          targetSize: Size(400, canvasHeight),
          pixelRatio: 2.0,
        );
      }

      // 第一次拍照
      Uint8List imageBytes = await takePicture();

      if (mounted) Navigator.pop(context); // 關閉第一次的 Loading 圈圈

      // 🌟 預覽視窗
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            bool isRecapturing = false; // 控制重拍時的局部轉圈圈

            return StatefulBuilder(
              builder: (BuildContext innerContext, StateSetter setDialogState) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                  // ✨ 魔法發生地：把刷子移到視窗標題的右邊！
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.exclusiveMomentsGenerated,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.brush),
                        color: theme.colorScheme.primary,
                        tooltip: l10n.chatPageChangeWatermarkColor,
                        onPressed: isRecapturing
                            ? null
                            : () async {
                                setDialogState(() {
                                  isRecapturing = true;
                                });

                                try {
                                  setState(() {
                                    _watermarkStyle = (_watermarkStyle + 1) % 3;
                                  });

                                  final newBytes = await takePicture();

                                  if (!innerContext.mounted) return;

                                  setDialogState(() {
                                    imageBytes = newBytes;
                                  });
                                } catch (e) {
                                  debugPrint('重新產生截圖失敗：$e');
                                } finally {
                                  if (innerContext.mounted) {
                                    setDialogState(() {
                                      isRecapturing = false;
                                    });
                                  }
                                }
                              },
                      ),
                    ],
                  ),
                  content: SizedBox(
                    width: 400,
                    child: isRecapturing
                        ? const SizedBox(
                            height: 200,
                            child: Center(
                                child: CircularProgressIndicator())) // 重拍時顯示轉圈圈
                        : SingleChildScrollView(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.medium,
                                cacheWidth: 800,
                              ), // 顯示拍好的照片
                            ),
                          ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(l10n.selectAgain,
                          style: const TextStyle(color: Colors.grey)),
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

                        await Share.shareXFiles([xFile],
                            text: l10n.inviteToMeet(_currentCharacter.name));

                        if (mounted)
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
          },
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("❌ 截圖失敗: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomLockKey =
        (_sessionId ?? widget.sessionId ?? widget.character.id).trim();
    // 🚨 只有極端情況才給全螢幕載入
    if (widget.character.name == l10n.chat_loading_status) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final bool isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    final bool showInputExtras = _isInputFocused && isKeyboardVisible;
    final int nextStageThreshold = _getNextStageThreshold(_currentFriendship);
    bool hasPhotoBackground = themeNotifier.activeCharacterBackground != null ||
        (themeNotifier.currentThemeEnum == AppTheme.custom &&
            themeNotifier.backgroundImagePath != null);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 👈 鍵盤消失術！
      },
      // 👇 🌟 魔法 Container 包在最外面 👇
      child: Container(
        decoration: themeNotifier.characterChatBackground,
        child: Stack(
          children: [
            // 🌟 總裁補丁 2：替換這裡！讓漸層色可以透出來
            Positioned.fill(
              child: Container(
                color: hasPhotoBackground
                    ? theme.colorScheme.surface
                        .withValues(alpha: 0.6) // 有照片：蓋半透明底色
                    : Colors.transparent, // ✨ 沒照片：完全透明！讓櫻花粉、湛藍海完美透出！
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent, // 🚩 這裡必須透明，照片才透得過來
              appBar: AppBar(
                toolbarHeight: 52,
                title: Text(_currentCharacter.name),
                backgroundColor: theme.appBarTheme.backgroundColor
                    ?.withValues(alpha: 0.5), // 半透明 AppBar
                elevation: 0,
                foregroundColor: theme.colorScheme.onBackground,
                actions: [
                  PopupMenuButton<String>(
                      icon: Icon(Icons.menu,
                          color: Theme.of(context).colorScheme.onSurface),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      offset: const Offset(0, 50),
                      color: theme.cardColor.withValues(alpha: 0.95),
                      onSelected: (value) async {
                        switch (value) {
                          case 'search':
                            final String? selectedMessageId =
                                await showSearch<String>(
                              context: context,
                              delegate:
                                  ChatHistorySearchDelegate(_localMessages),
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
                                ),
                              ),
                            );
                            break;
                          case 'about_me':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutMePage(
                                        character: _currentCharacter)));
                            break;
                          case 'about_us':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutUsPage(
                                  // 帶入目前的玩家 ID
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  // ✨ 這裡要加上底線，改成 _currentCharacter.id 喔！
                                  characterId: _currentCharacter.id,
                                ),
                              ),
                            );
                            break;
                          case 'memo':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MemoPage(
                                        character: _currentCharacter)));
                            break;
                          case 'period':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PeriodTrackerPage(
                                        character: _currentCharacter)));
                            break;
                          case 'reset':
                            _resetChat();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
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
                                leading: const Icon(Icons.wallpaper,
                                    color: Colors.purple),
                                title: Text(l10n.chat_menu_gallery),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'about_me',
                              child: ListTile(
                                leading: const Icon(
                                    Icons.face_retouching_natural,
                                    color: Colors.pinkAccent),
                                title: Text(l10n.chat_menu_aboutme),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            // ✨ 新增在這裡：關於我們 (專屬回憶與劇情設定)
                            PopupMenuItem<String>(
                              value: 'about_us',
                              child: ListTile(
                                // ✨ 這裡換成了愛心圖示，並配上浪漫的淡藍色！
                                leading: const Icon(Icons.favorite,
                                    color: Color(0xFF7BD1FF)),
                                title: Text(l10n.chat_menu_aboutus),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'memo',
                              child: ListTile(
                                leading: const Icon(Icons.note_alt_outlined,
                                    color: Colors.orange),
                                title: Text(l10n.chat_menu_memo),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'period',
                              child: ListTile(
                                leading: const Icon(Icons.water_drop_outlined,
                                    color: Colors.redAccent),
                                title: Text(l10n.chat_menu_period),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'reset',
                              child: ListTile(
                                leading: const Icon(Icons.restart_alt_rounded,
                                    color: Colors.red),
                                title: Text(l10n.chat_menu_reset,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ]),
                ],
              ),
              // 👇 🌟 移除了原本擋在前面的內層背景，直接放 Column
              body: Column(
                children: [
                  // ✨ 1. 精簡頂部狀態欄
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha: 0.5),
                      border: Border(
                        bottom: BorderSide(
                          color: theme.dividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // 模式選擇
                        if (_currentMode == null)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        else if (_currentMode == ChatMode.gemini)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _getModeName(_currentMode!),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          InkWell(
                            onTap: _showModeSelectionDialog,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.45),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getModeName(_currentMode!),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 15,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(width: 8),

                        // 好感度、關係與花花點數
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    _getCurrentStage(
                                      _currentFriendship.clamp(0, 9999),
                                    ).imagePath,
                                    width: 22,
                                    height: 22,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$_currentFriendship / $nextStageThreshold',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _currentFriendship.relationshipTitle(l10n),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: _currentFriendship.titleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // 花花點數
                                  InkWell(
                                    onTap: kIsWeb
                                        ? null
                                        : () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const StorePage(),
                                              ),
                                            ),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                        vertical: 2,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            theme.brightness == Brightness.dark
                                                ? 'assets/images/flower_gift_dark.png'
                                                : 'assets/images/flower_gift.png',
                                            width: 18,
                                            height: 18,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            _formatPoints(_flowerPoints),
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isQixiRoom) _buildQixiProgressCard(theme),
                  // ✨ 2. 中間訊息列表
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )

                        // 測試模式必須先判斷，因為它本來就沒有正式 session
                        : widget.isTestMode
                            ? (_testMessages.isEmpty && !_isGenerating
                                ? Center(
                                    child: Text(
                                      l10n.chat_test_mode_msg,
                                    ),
                                  )
                                : _buildMessageList(
                                    _testMessages,
                                  ))

                            // 只有正式聊天室才檢查這兩個資料
                            : (_sessionId == null ||
                                    _messagesCollection == null)
                                ? Center(
                                    child: Text(
                                      l10n.chat_loading_failed,
                                    ),
                                  )
                                : StreamBuilder<QuerySnapshot>(
                                    stream: _messagesCollection!
                                        .orderBy('timestamp', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      if (snapshot.hasError)
                                        return Center(
                                            child: Text(
                                                l10n.chat_error_load_msg(
                                                    snapshot.error
                                                        .toString())));

                                      final messages = snapshot.data!.docs
                                          .map((doc) =>
                                              ChatMessage.fromFirestore(doc))
                                          .toList();
                                      _localMessages = messages;

                                      // ✨✨✨ 靈魂出竅自動解鎖魔法 開始 ✨✨✨
                                      if (messages.isNotEmpty) {
                                        final latestMessage = messages.first;

                                        if (_isGenerating &&
                                            _waitingForNewAiReply &&
                                            latestMessage.sender == 'ai') {
                                          final lastUserSendTime =
                                              _lastUserSendTime;
                                          final DateTime? aiMessageTime =
                                              latestMessage.timestamp?.toDate();

                                          final bool isNewAiReply =
                                              lastUserSendTime != null &&
                                                  aiMessageTime != null &&
                                                  aiMessageTime.isAfter(
                                                      lastUserSendTime);

                                          if (isNewAiReply) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              if (!mounted) return;

                                              setState(() {
                                                _isGenerating = false;
                                                _isLoading = false;
                                                _waitingForNewAiReply = false;
                                              });

                                              generatingRooms
                                                  .remove(_roomLockKey);

                                              debugPrint(
                                                  "✨ 偵測到新的 AI 回覆，解除鎖定狀態！");
                                            });
                                          }
                                        }
                                      }
                                      // ✨✨✨ 靈魂出竅自動解鎖魔法 結束 ✨✨✨
                                      if (messages.isEmpty && !_isGenerating) {
                                        return Center(
                                            child: Text(l10n.chat_empty_msg));
                                      }
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: _buildMessageList(messages),
                                          ),
                                          if (_isRegenerating)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                16,
                                                8,
                                                16,
                                                12,
                                              ),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest
                                                        .withValues(
                                                            alpha: 0.75),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        l10n.chatPageRegenerating,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface
                                                                  .withValues(
                                                                      alpha:
                                                                          0.72),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                  ),
                  if (_isScreenshotMode)
                    // 如果是截圖模式，就顯示專屬操作列
                    _buildScreenshotBottomBar()
                  else ...[
                    // ✨ 3. 底部（）快捷鍵區
                    showInputExtras
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            color: theme.cardColor.withValues(alpha: 0.5),
                            child: Row(
                              children: [
                                OutlinedButton(
                                  onPressed: (_isGenerating || _isLoading)
                                      ? null
                                      : () {
                                          final text = _textController.text;

                                          final selection =
                                              _textController.selection;

                                          int cursorPosition =
                                              selection.baseOffset;

                                          if (cursorPosition < 0 ||
                                              cursorPosition > text.length) {
                                            cursorPosition = text.length;
                                          }

                                          final newText = text.substring(
                                                0,
                                                cursorPosition,
                                              ) +
                                              '（）' +
                                              text.substring(
                                                cursorPosition,
                                              );

                                          _textController.value =
                                              TextEditingValue(
                                            text: newText,
                                            selection: TextSelection.collapsed(
                                              offset: cursorPosition + 1,
                                            ),
                                          );

                                          _focusNode.requestFocus();
                                        },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(42, 30),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('（）'),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),

                    // 🌟 多選模式 / 平常輸入框
                    if (_isMultiSelectMode)
                      _buildMultiSelectBottomBar()
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 2,
                              offset: Offset(0, -1),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_selectedChatImagePath != null)
                                _buildSelectedChatImagePreview(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.cloud_outlined),
                                    onPressed: (_isGenerating || _isLoading)
                                        ? null
                                        : _showToolbox,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        showInputExtras
                                            ? ValueListenableBuilder<
                                                TextEditingValue>(
                                                valueListenable:
                                                    _textController,
                                                builder:
                                                    (context, value, child) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 12,
                                                      top: 2,
                                                    ),
                                                    child: Text(
                                                      '${value.text.length}/900',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            value.text.length >=
                                                                    900
                                                                ? Colors.red
                                                                : Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const SizedBox.shrink(),
                                        TextField(
                                          controller: _textController,
                                          focusNode: _focusNode,
                                          onChanged: (text) {
                                            _saveDraft(text);
                                          },
                                          readOnly:
                                              (_isGenerating || _isLoading),
                                          minLines: 1,
                                          maxLines: 4,
                                          maxLength: 900,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            hintText: _isGenerating
                                                ? AppLocalizations.of(context)
                                                        ?.chat_ai_typing ??
                                                    l10n.chatTypingIndicator
                                                : AppLocalizations.of(context)
                                                        ?.chat_input_hint_default ??
                                                l10n.chatInputHint,
                                            border: InputBorder.none,
                                            counterText: "",
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: _isGenerating
                                        ? const Icon(
                                            Icons.stop_circle_outlined,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.send,
                                            color: _isLoading
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                    onPressed: _isGenerating
                                        ? _stopGenerating
                                        : (_isLoading
                                            ? null
                                            : () async {
                                                final text =
                                                    _textController.text.trim();
                                                final imagePath =
                                                    _selectedChatImagePath;

                                                // 文字跟圖片都沒有，才不送
                                                if (text.isEmpty &&
                                                    (imagePath == null ||
                                                        imagePath.isEmpty)) {
                                                  return;
                                                }

                                                // 先抓出圖片，再清掉畫面預覽
                                                setState(() {
                                                  _selectedChatImagePath = null;
                                                });

                                                await _sendMessage(
                                                  text: text,
                                                  imagePath: imagePath,
                                                  showInChat: true,
                                                );
                                              }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
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
      l10n.weekday_mon,
      l10n.weekday_tue,
      l10n.weekday_wed,
      l10n.weekday_thu,
      l10n.weekday_fri,
      l10n.weekday_sat,
      l10n.weekday_sun
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

    final bool isAiReplying =
        _isGenerating || _isLoading || generatingRooms.contains(_roomLockKey);

    final List<dynamic> displayMessages = [
      ..._pendingMediaMessages,
      ...messages,
    ];

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _chatScrollController,
      reverse: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: displayMessages.length + (isAiReplying ? 1 : 0),
      itemBuilder: (context, index) {
        if (isAiReplying && index == 0) {
          return _buildTypingIndicator();
        }

        final realIndex = isAiReplying ? index - 1 : index;

        if (realIndex < 0 || realIndex >= messages.length) {
          return const SizedBox.shrink();
        }

        final item = displayMessages[realIndex];

        if (item is Map && item['isUploading'] == true) {
          return _buildPendingMediaBubble(
            Map<String, dynamic>.from(item),
          );
        }

        final message = item as ChatMessage;

        final messageIndex = realIndex;
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 48.0),
            decoration: BoxDecoration(
              color: theme.cardColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: _highlightedMessageId == message.id
                  ? Border.all(
                      color: Colors.yellowAccent, width: 2.5) // 🌟 這裡加上邊框發光！
                  : null,
            ),
            child: Text(
              message.text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          );
        } else {
          final isUserMessage = sender == 'user';
          final avatar = CircleAvatar(
            backgroundImage: _getAvatarProvider(_currentCharacter.avatarPath),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[300],
          );

          Widget messageContent;

          // 💬 根據型態畫出對話氣泡
          if (type == 'text') {
            final normalStyle = TextStyle(
              color: isUserMessage
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              height: 1.55,
            );
            final actionStyle = TextStyle(
                color: (isUserMessage
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant)
                    .withValues(alpha: 0.7));

            // ✨✨✨ 總裁修正處：在這裡把殼脫掉！ ✨✨✨
// 先拿到原始文字或脫殼後的文字
            String rawDisplayText =
                isUserMessage ? message.text : _getCleanAiMessage(message.text);

// 🌟 總裁無敵淨水器：不管 AI 講了什麼括號，全部強迫替換成玩家的名字！
            final displayText = rawDisplayText
                .replaceAll('(玩家名字)', _playerNickname)
                .replaceAll('{{玩家名字}}', _playerNickname)
                .replaceAll('【玩家名字】', _playerNickname); // 多加一個括號防禦以防萬一

            messageContent = Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: _highlightedMessageId == message.id
                    ? Border.all(color: Colors.yellowAccent, width: 2.5)
                    : null,
              ),
              // 🌟 玩家的泡泡維持原樣，AI 的泡泡送進我們的專屬上色機！
              child: isUserMessage
                  ? _buildRichTextMessage(displayText,
                      normalStyle: normalStyle, actionStyle: actionStyle)
                  : _buildStyledAiMessage(
                      context,
                      displayText,
                      normalStyle,
                    ),
            );
          } else if (type == 'image') {
            final imageText = message.text.trim();
            final imagePath =
                (message.path != null && message.path!.trim().isNotEmpty)
                    ? message.path!.trim()
                    : message.path.trim();

            messageContent = ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isUserMessage
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: _highlightedMessageId == message.id
                      ? Border.all(color: Colors.yellowAccent, width: 2.5)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: _buildChatImage(imagePath),
                    ),
                    if (imageText.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        imageText,
                        style: TextStyle(
                          color: isUserMessage
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          } else {
            final Color iconColor = isUserMessage
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant;
            final Color textColor = isUserMessage
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant;
            messageContent = Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () => _playAudio(message.path),
                      child: Icon(Icons.play_arrow, color: iconColor)),
                  const SizedBox(width: 8),
                  Text(l10n.chat_voice_msg_label,
                      style: TextStyle(color: textColor))
                ],
              ),
            );
          }
// ✨✨✨ 貼在這裡！ ✨✨✨
// (⚠️ 請注意：_messages 和 index 需要換成妳 ListView.builder 裡實際使用的變數名稱)
          // ✨ 總裁看這裡：條件改成 messageIndex == 0 (因為 reverse: true，0 就是最新的一句)
          // ✨✨✨ 按鈕完美接在這裡！ ✨✨✨
          if (!isUserMessage && messageIndex == 0 && !_isGenerating) {
            messageContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                messageContent, // 上面的對話氣泡
                const SizedBox(height: 4),

                // 🕵️‍♂️ 總裁隱身術：只有在「非多選模式」下，才畫出下面這組按鈕
                if (!_isMultiSelectMode)
                  Wrap(
                    // 🛡️ 總裁防護罩：將 Row 改成 Wrap，徹底消滅 25 像素溢出黃黑線！
                    spacing: 8.0, // 按鈕之間的左右間距 (取代了原本的 SizedBox)
                    runSpacing: 8.0, // 如果螢幕太小換行時的上下間距
                    children: [
                      // 🔄 重新生成按鈕 (升級橢圓明顯版)
                      // 假設您在 build 函數開頭已經有：
// final l10n = AppLocalizations.of(context)!;

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (_freeRegenerateCount > 0)
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.15)
                              : Colors.grey.withValues(alpha: 0.12),
                          foregroundColor: (_freeRegenerateCount > 0)
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(
                          Icons.refresh,
                          size: 16,
                        ),
                        label: Text(
                          l10n.regenerateButtonLabel(
                            _freeRegenerateCount,
                            _maxRegenerateCount,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            // 1. 擋下機制
                            if (_freeRegenerateCount <= 0) {
                              _showSubscriptionDialog();
                              return;
                            }

                            // 2. 檢查訊息集合是否就緒
                            if (_messagesCollection == null) {
                              _showCenterToast(
                                l10n.systemPreparingWait,
                                isError: true,
                              );
                              return;
                            }

                            // 3. 取得最後兩筆訊息
                            final querySnapshot = await _messagesCollection!
                                .orderBy(
                                  'timestamp',
                                  descending: true,
                                )
                                .limit(2)
                                .get();

                            if (!mounted) return;

                            if (querySnapshot.docs.length < 2) {
                              _showCenterToast(
                                l10n.noMessagesToRegenerate,
                                isError: true,
                              );
                              return;
                            }

                            // 4. 取得 AI 訊息 ID 與上一則玩家訊息
                            final aiMessageId = querySnapshot.docs[0].id;

                            final userMessageText =
                                ((querySnapshot.docs[1].data()
                                            as Map<String, dynamic>)['text'] ??
                                        '')
                                    .toString()
                                    .trim();

                            if (userMessageText.isEmpty) {
                              _showCenterToast(
                                l10n.noMessagesToRegenerate,
                                isError: true,
                              );
                              return;
                            }

                            // 5. 先執行重新生成
                            // 5. 先執行重新生成，並接住成功或失敗結果
                            final regenerateSucceeded =
                                await _regenerateAIResponse(
                              aiMessageId,
                              userMessageText,
                            );

// 重新生成失敗或被取消時，直接停止。
// 不扣免費次數，也不扣花花。
                            if (!regenerateSucceeded) {
                              return;
                            }

// 6. 只有真正成功後，才扣除一次免費重新生成次數
                            final consumed = await _consumeRegenerateCount();

                            if (!consumed) {
                              await _loadRegenerateCount();

                              debugPrint(
                                '⚠️ 重新生成成功，但扣除重新生成次數失敗',
                              );
                            }
                          } catch (e, stackTrace) {
                            debugPrint('❌ 重新生成按鈕流程失敗：$e');
                            debugPrint('$stackTrace');

                            if (!mounted) return;

                            _showCenterToast(
                              l10n.chatPageRegenerateFailed,
                              isError: true,
                            );
                          }
                        },
                      ),

                      // ▶️ 繼續按鈕 (也順便幫妳改成一樣的橢圓風格)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.18),
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          disabledBackgroundColor:
                              Colors.grey.withValues(alpha: 0.12),
                          disabledForegroundColor: Colors.grey,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: _isGenerating || _isLoading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.play_arrow, size: 16),
                        label: Text(
                          l10n.continueButton,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (_isGenerating || _isLoading)
                            ? null
                            : () async {
                                await _handleContinueButton();
                              },
                      ),
                    ],
                  ),
              ],
            );
          }

          // ⏰ 把「時間」貼到氣泡旁邊
          Widget timeWidget = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              _getTimeString(message.timestamp),
              style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
          );

          if (isUserMessage) {
            // 🚩 這裡拿掉了原本的 GestureDetector，移到最外層統一管理
            finalMessageWidget = Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 頭像點擊功能保留
                  GestureDetector(
                    onTap: () {
                      _navigateToProfileFromChat(widget.character.id,
                          widget.character.name, widget.character.avatarPath);
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

        // ✨✨✨ 終極包裝：截圖與多選刪除 共用選取外殼 ✨✨✨
        // 💡 總裁看這裡：我們把兩個模式包成一個變數，只要其中一個開啟，就進入選取狀態！
        final bool isSelectionMode = _isScreenshotMode || _isMultiSelectMode;

        final wrappedMessage = GestureDetector(
          behavior: HitTestBehavior.translucent, // 確保點擊空白處也能感應到
          onLongPress: () => _showMessageOptions(message), // 長按依然呼叫妳的底部選單
          onTap: () {
            // 🚩 短按：如果正在截圖或多選模式，就執行勾選/取消
            if (isSelectionMode) {
              if (mounted)
                setState(() {
                  if (isSelected) {
                    _selectedMessageIds.remove(message.id);
                    // 如果全部取消了，就自動關閉兩種模式
                    if (_selectedMessageIds.isEmpty) {
                      _isScreenshotMode = false;
                      _isMultiSelectMode = false;
                    }
                  } else {
                    _selectedMessageIds.add(message.id);
                  }
                });
              HapticFeedback.lightImpact(); // 輕微震動回饋
            }
          },
          child: Container(
            // ✨ 視覺優化：刪除模式給淡淡的紅色遮罩，截圖模式維持原本的主題色
            color: (isSelectionMode && isSelected)
                ? (_isMultiSelectMode
                    ? Colors.red.withValues(alpha: 0.15)
                    : theme.colorScheme.primary.withValues(alpha: 0.15))
                : Colors.transparent,
            child: Row(
              children: [
                // 📸🗑️ 選取模式下的勾選按鈕 (共用元件)
                if (isSelectionMode)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      // ✨ 視覺優化：如果是刪除模式，打勾就變成警告的紅色！
                      color: isSelected
                          ? (_isMultiSelectMode
                              ? Colors.red
                              : theme.colorScheme.primary)
                          : Colors.grey,
                      size: 22,
                    ),
                  ),
                // 右側放對話內容
                Expanded(
                  child: IgnorePointer(
                    // 🚨 總裁防呆機制：在選取模式下，暫停內部元件的點擊（如頭像或語音），專心選取對話
                    ignoring: isSelectionMode,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
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

// 🗑️ 專屬記憶抹除器：從玩家專屬的 chatMessages 裡徹底刪除對話
Future<void> _deleteMessagesFromDB(
    String aiMessageId, String userMessageId) async {
  try {
    // ✨ 總裁看這裡：我們直接去跟 Firebase Auth 要現在登入的玩家 ID！
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      debugPrint('❌ 玩家未登入，找不到 ID，無法刪除！');
      return;
    }

    final String actualUserId = currentUser.uid; // 這就是絕對正確的 ID！

    final db = FirebaseFirestore.instance;
    // 鎖定目標房間：/users/玩家ID/chatMessages/
    final chatRef =
        db.collection('users').doc(actualUserId).collection('chatMessages');

    // 殺掉 AI 的訊息
    await chatRef.doc(aiMessageId).delete();
    // 殺掉玩家的訊息
    await chatRef.doc(userMessageId).delete();

    debugPrint('✅ 成功從 Firebase 徹底抹除這兩回合的對話！');
  } catch (e) {
    debugPrint('❌ 刪除 Firebase 訊息失敗: $e');
  }
}

// ✨ AI 專屬文字掃描器：引號內維持正常色，括號（）與其他旁白強制漆成灰色
// AI 訊息顯示規則：
// 1. 「對話」使用主題色
// 2. （動作）使用主要文字色，並隱藏外層括號
// 3. 狀態欄與其他普通文字維持主要文字色
Widget _buildStyledAiMessage(
  BuildContext context,
  String message,
  TextStyle dialogueStyle,
) {
  if (message.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  final theme = Theme.of(context);
  final actionStyle = TextStyle(
    color: theme.colorScheme.onSurface,
    height: 1.55,
  );

  final dialogueStyle = TextStyle(
    color: theme.colorScheme.primary,
    height: 1.55,
  );
  final RegExp mixedRegex = RegExp(
    r'(「.*?」|“.*?”|".*?"|（.*?）|\(.*?\))',
    dotAll: true,
  );

  final matches = mixedRegex.allMatches(message);

  if (matches.isEmpty) {
    // 沒有動作括號時，視為純對話，使用目前主題色。
    return Text(
      message,
      style: dialogueStyle,
    );
  }

  final List<TextSpan> spans = [];
  int currentIndex = 0;

  for (final match in matches) {
    final String matchedText = match.group(0) ?? '';

    // 引號或括號前面的普通文字，例如時間、地點、狀態欄。
    if (match.start > currentIndex) {
      spans.add(
        TextSpan(
          text: message.substring(
            currentIndex,
            match.start,
          ),
          style: actionStyle,
        ),
      );
    }

    final bool isAction =
        matchedText.startsWith('（') || matchedText.startsWith('(');

    if (isAction) {
      // 只移除最外層括號，不修改資料庫中的原始訊息。
      final String actionText = matchedText.length >= 2
          ? matchedText.substring(
              1,
              matchedText.length - 1,
            )
          : matchedText;

      spans.add(
        TextSpan(
          text: actionText,
          style: actionStyle,
        ),
      );
    } else {
      // 對話保留引號，並使用主題色。
      spans.add(
        TextSpan(
          text: matchedText,
          style: dialogueStyle,
        ),
      );
    }

    currentIndex = match.end;
  }

  // 最後一段普通文字或狀態欄。
  if (currentIndex < message.length) {
    spans.add(
      TextSpan(
        text: message.substring(currentIndex),
        style: actionStyle,
      ),
    );
  }

  return Text.rich(
    TextSpan(children: spans),
  );
}

// 🌟 總裁專屬：高級去殼過濾器 (Flutter 端)
String _getCleanAiMessage(String rawText) {
  // 🌟 1. 先把可能存在的 Markdown 標籤拿掉，防止干擾
  String processedText =
      rawText.replaceAll('```json', '').replaceAll('```', '').trim();

  // 🌟 2. 檢查有沒有包含 JSON 關鍵字
  if (processedText.contains('"response":')) {
    try {
      // 🌟 3. 用正則表達式把引號裡的台詞吸出來
      final regex = RegExp(r'"response"\s*:\s*"((?:[^"\\]|\\.)*)"');
      final matches = regex.allMatches(processedText);

      if (matches.isNotEmpty) {
        return matches.map((m) {
          String content = m.group(1) ?? "";
          // 把 \n 換成真正的換行，把 \" 換成真正的引號
          return content.replaceAll(r'\n', '\n').replaceAll(r'\"', '"');
        }).join('\n\n');
      }
    } catch (e) {
      // 如果解析失敗，就回傳去掉標籤的文字
      return processedText;
    }
  }

  // 🌟 4. 如果本來就是乾淨的，直接回傳
  return processedText;
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
        child:
            Text(l10n.chat_search_hint, style: TextStyle(color: Colors.grey)),
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
          title: Text(match.text,
              maxLines: 2, overflow: TextOverflow.ellipsis), // 只顯示兩行預覽
          subtitle: Text(isPlayer ? l10n.chat_search_you : l10n.chat_search_him,
              style: const TextStyle(fontSize: 12)),
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
    if (this >= 550) return l10n.rel_title_ambiguous;
    if (this >= 150) return l10n.rel_title_friend;
    if (this >= 60) return l10n.rel_title_acquaintance;
    if (this >= 0) return l10n.rel_title_stranger;

    // 💔 負數區間
    if (this >= -150) return l10n.rel_title_tense;
    if (this >= -550) return l10n.rel_title_avoiding;
    if (this >= -1720) return l10n.rel_title_hostile;
    return l10n.rel_title_nemesis;
  }

  // 🎨 顏色不需要翻譯，維持原本的 get 寫法就好
  Color get titleColor {
    if (this >= 1720) return Colors.redAccent;
    if (this >= 550) return Colors.pinkAccent;
    if (this < 0) return Colors.blueGrey;
    return Colors.black87;
  }

  // ✨ 同樣把 get 拿掉，改成需要傳入翻譯官的方法
  String levelUpMessage(AppLocalizations l10n) {
    if (this >= 2430) return l10n.rel_msg_soulmate;
    if (this >= 1720) return l10n.rel_msg_lover;
    if (this >= 550) return l10n.rel_msg_ambiguous;
    if (this >= 150) return l10n.rel_msg_friend;
    if (this >= 60) return l10n.rel_msg_acquaintance;
    return l10n.rel_msg_stranger;
  }
}

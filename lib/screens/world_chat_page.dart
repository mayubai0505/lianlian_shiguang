
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'feedback_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'world_story_timeline_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'store_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_constants.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_input_bar.dart';
import 'world_chat_header.dart';
import 'world_profile_popup.dart';
import 'world_interaction_play_page.dart';
import 'world_scene_page_full.dart';
import 'world_secret_chapters_page.dart';
import 'world_chat_side_menu.dart';
import 'world_chat_search_page.dart';
import 'world_chat_transcript_book_page.dart';
import 'world_chat_records_pages.dart';
import 'world_relationship_live_page.dart';
import 'world_chat_memos_page.dart';
import 'background_settings_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';

/// 私人試玩；所有訊息經 Cloud Function 授權、讀取與儲存。
/// 目前僅限世界創作者私人試玩；世界觀付費模式與互動由 Cloud Functions 計費。
class WorldChatPage extends StatefulWidget {
  const WorldChatPage({super.key, required this.worldId, this.sessionId});
  final String? sessionId;
  final String worldId;
  @override
  State<WorldChatPage> createState() => _WorldChatPageState();
}

class _WorldChatPageState extends State<WorldChatPage> with WidgetsBindingObserver {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final ScreenshotController _worldScreenshot = ScreenshotController();
  int _worldScreenshotStyle = 0; // 0=跟隨主題, 1=曜石黑, 2=晨曦白
  final Set<String> _selectedMessageIds = <String>{};
  bool _worldSelectionMode = false;
  bool _worldDeleteMode = false;
  // 只在本次 App 執行期間保留聊天快取，帳號與世界完全隔離。
  static final Map<String, Map<String, dynamic>> _roomCache = {};
  String get _roomCacheKey => '${FirebaseAuth.instance.currentUser?.uid ?? 'signed_out'}:${widget.worldId}:${widget.sessionId ?? 'legacy'}';
  String get _roomSessionPrefKey => 'world_room_session_${FirebaseAuth.instance.currentUser?.uid ?? 'signed_out'}_${widget.worldId}_${widget.sessionId ?? 'legacy'}';
  bool _serverLoadCompleted = false;
  bool _initialVisualsReady = false;
  String? _initialBackgroundPath;
  bool _loading = true;
  bool _sending = false;
  final Set<String> _cancelledLocalRequests = <String>{};
  bool _stoppingGeneration = false;
  String _name = '開放世界';
  // 只允許正式世界名稱進入畫面；世界 ID 僅用於資料查詢。
  String _safeWorldName(Object? value) {
    final name = (value ?? '').toString().trim();
    return name.isEmpty || name == widget.worldId ? '開放世界' : name;
  }
  String _error = '';
  String _worldCoverImage = '';
  String _selectedMode = 'story';
  OverlayEntry? _centerNotice;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _flowerSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _affinitySubscription;
  int _flowerPoints = 0;
  int _regenerateFreeRemaining = 3;
  bool _paidRegenerateConfirmed = false;
  Map<String, int> _characterAffinity = {};
  Timer? _draftTimer;
  String? _sessionId;
  String? _pendingRequestId;
  String? _pendingRequestText;
  bool _hasStreamData = false;
  // Local-only bubble while the server is generating; never written to Firestore by client.
  bool _pendingFailed = false;
  bool _pendingVisible = false;
  String get _draftKey => 'world_chat_draft_${FirebaseAuth.instance.currentUser?.uid ?? 'anon'}_${widget.worldId}_${widget.sessionId ?? 'legacy'}';
  static const _modes = <String, int>{'story': 5, 'immersive': 7, 'resonance': 10, 'interaction': 12};
  List<dynamic> _messages = [];
  Map<String,String> _npcs = {};
  Map<String,String> _names = {};
  late final HttpsCallable _api = FirebaseFunctions.instanceFor(region:'asia-east1')
      .httpsCallable('worldPrivateTest', options: HttpsCallableOptions(timeout:const Duration(seconds:170)));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focus.addListener(_onInputFocusChanged);
    _restoreDraft();
    _listenFlowerPoints();
    // 優先呈現同帳號、同世界的記憶體快取，避免重複顯示載入動畫。
    final previous = _roomCache[_roomCacheKey];
    if (previous != null && (previous['sessionId'] ?? '').toString().isNotEmpty && (widget.sessionId == null || previous['sessionId'] == widget.sessionId)) {
      _applyCachedRoom(previous);
      _initialVisualsReady = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _listenMessages(_sessionId!);
        _scrollToLatest();
      });
    } else {
      // App 冷啟動時僅保存玩家與世界對應的 sessionId；對話正文不另存 SharedPreferences。
      // 若 Firestore 已有本機磁碟快取，可在網路回覆前直接顯示。
      unawaited(_restoreFirestoreCachedRoom());
    }
    _run('load');
  }

  void _applyCachedRoom(Map<String, dynamic> data) {
    final sid = (data['sessionId'] ?? '').toString();
    if (sid.isEmpty) return;
    _sessionId = sid;
    _name = _safeWorldName(data['worldName']);
    _worldCoverImage = (data['coverImage'] ?? '').toString();
    _messages = List<dynamic>.from(data['messages'] as List? ?? const []);
    _npcs = Map<String, String>.from(data['avatars'] as Map? ?? const {});
    _names = Map<String, String>.from(data['names'] as Map? ?? const {});
    _characterAffinity = Map<String, int>.from(data['affinities'] as Map? ?? const {});
    // 快取只負責預先備妥資料；首次雲端 load 完成以前保持載入指示器。
    // 否則有快取的 sessionId 卻沒有完整畫面資料時，聊天室會先出現空白。
    // _loading 由 _run('load') 成功或失敗統一結束。
    _error = '';
  }

  Future<void> _restoreFirestoreCachedRoom() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString(_roomSessionPrefKey) ?? '';
      if (sid.isEmpty || (widget.sessionId != null && sid != widget.sessionId) || !mounted || _serverLoadCompleted || _sessionId != null) return;
      final snap = await FirebaseFirestore.instance
          .collection('artifacts').doc(AppConfig.appId)
          .collection('world_chat_sessions').doc(sid)
          .collection('messages')
          .orderBy('timestamp', descending: true).limit(200)
          .get(const GetOptions(source: Source.cache));
      if (!mounted || _serverLoadCompleted || _sessionId != null || snap.docs.isEmpty) return;
      final ordered = snap.docs.toList().reversed.toList();
      ordered.sort((a, b) {
        final ta = (a.data()['timestamp'] as Timestamp?)?.microsecondsSinceEpoch ?? 0;
        final tb = (b.data()['timestamp'] as Timestamp?)?.microsecondsSinceEpoch ?? 0;
        if (ta != tb) return ta.compareTo(tb);
        if (a.id == 'ai_${b.id}') return 1;
        if (b.id == 'ai_${a.id}') return -1;
        return a.id.compareTo(b.id);
      });
      // 僅使用同一登入帳號下先前記錄的房間 ID；沒有離線快取就正常等待雲端。
      final cached = <String, dynamic>{
        'sessionId': sid,
        'worldName': _name, // 離線訊息快取沒有世界名稱時，沿用畫面安全預設名稱。
        'coverImage': '',
        'messages': ordered.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
        'avatars': <String, String>{}, 'names': <String, String>{},
        'affinities': <String, int>{},
      };
      _applyCachedRoom(cached);
      _initialVisualsReady = true;
      setState(() {});
      _listenMessages(sid);
      _scrollToLatest();
    } catch (e) {
      // 磁碟快取不是必需項：不存在、關閉或損毀時走原本首次讀取。
      debugPrint('世界聊天室離線快取未命中：$e');
    }
  }

  Future<void> _rememberWorldRoom() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final sid = _sessionId;
    if (uid == null || sid == null || sid.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_chat_type_$uid', 'world');
    await prefs.setString('last_chat_world_$uid', widget.worldId);
    await prefs.setString('last_chat_world_session_$uid', sid);
    await prefs.setInt('last_main_tab_$uid', 2);
    debugPrint('🧭 已記住最後世界觀聊天室：world=${widget.worldId}, session=$sid');
  }

  Future<void> _clearRememberedWorldRoom() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('last_chat_type_$uid') != 'world' ||
        prefs.getString('last_chat_world_$uid') != widget.worldId ||
        prefs.getString('last_chat_world_session_$uid') != _sessionId) return;
    await prefs.remove('last_chat_type_$uid');
    await prefs.remove('last_chat_world_$uid');
    await prefs.remove('last_chat_world_session_$uid');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_sending && mounted) {
      _run('load', silent: true);
    }
  }

  void _onInputFocusChanged() {
    if (mounted) setState(() {});
  }

  // Insert action parentheses at the current caret / around selected text.
  void _insertActionParentheses() {
    final text = _input.text;
    final selection = _input.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final safeStart = start.clamp(0, text.length);
    final safeEnd = end.clamp(safeStart, text.length);
    final selected = text.substring(safeStart, safeEnd);
    final replacement = '（$selected）';
    _input.value = TextEditingValue(
      text: text.replaceRange(safeStart, safeEnd, replacement),
      selection: TextSelection.collapsed(offset: safeStart + 1 + selected.length),
    );
    _scheduleDraftSave(_input.text);
    _focus.requestFocus();
  }

  Future<void> _restoreDraft() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted || _input.text.isNotEmpty) return;
    final draft = prefs.getString(_draftKey) ?? '';
    if (draft.isNotEmpty) _input.text = draft;
  }

  void _scheduleDraftSave(String value) {
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 350), () async {
      final prefs = await SharedPreferences.getInstance();
      if (value.isEmpty) {
        await prefs.remove(_draftKey);
      } else {
        await prefs.setString(_draftKey, value);
      }
    });
  }

  void _listenFlowerPoints() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _flowerSubscription?.cancel();
    _flowerSubscription = FirebaseFirestore.instance.collection('users')
        .doc(uid).snapshots().listen((snapshot) {
      if (!mounted) return;
      final raw = snapshot.data()?['flowerPoints'];
      final points = raw is num ? raw.toInt() : 0;
      if (points != _flowerPoints) setState(() => _flowerPoints = points);
    }, onError: (Object error) {
      if (mounted) _showCenterNotice(AppLocalizations.of(context)!.world_chat_flower_sync1, isError: true);
    });
  }

  // 角色關係以玩家的世界房間及正式角色 ID 隔離。前端僅讀取，
  // 分數應由後端在正式好感度功能上線後更新，不由客戶端自行加分。
  void _listenCharacterAffinities(String sessionId) {
    _affinitySubscription?.cancel();
    // Do not flash 0 while refreshing the Firestore stream.
    _affinitySubscription = FirebaseFirestore.instance
        .collection('artifacts').doc(AppConfig.appId)
        .collection('world_chat_sessions').doc(sessionId)
        .collection('character_affinities')
        .snapshots().listen((snapshot) {
      if (!mounted) return;
      final values = <String, int>{};
      for (final doc in snapshot.docs) {
        // Keep persisted scores even if the character roster loads later.
        // Only known formal characters are displayed by the UI.
        final score = doc.data()['score'];
        values[doc.id] = score is num ? score.toInt().clamp(-5000, 5000).toInt() : 0;
      }
      if (values.isNotEmpty) {
        setState(() => _characterAffinity = {..._characterAffinity, ...values});
      } else {
        debugPrint('世界觀好感度監聽為空，保留 callable 已載入的分數');
      }
    }, onError: (Object error) {
      debugPrint('世界觀好感度即時監聽失敗：$error');
      unawaited(_recoverAffinitiesFromCallable());
    });
  }

  String _affectionAsset(int score) {
    if (score < 60) return 'assets/images/affection/affection_stage_1.png';
    if (score < 150) return 'assets/images/affection/affection_stage_2.webp';
    if (score < 550) return 'assets/images/affection/affection_stage_3.webp';
    if (score < 1720) return 'assets/images/affection/affection_stage_4.webp';
    if (score < 2430) return 'assets/images/affection/affection_stage_5.webp';
    return 'assets/images/affection/affection_stage_6.webp';
  }

  String _legacyFlowerAsset(int score) {
    if (score < 60) return 'assets/images/flower_stage_1.webp';
    if (score < 150) return 'assets/images/flower_stage_2.webp';
    if (score < 550) return 'assets/images/flower_stage_3.webp';
    if (score < 1720) return 'assets/images/flower_stage_4.webp';
    if (score < 2430) return 'assets/images/flower_stage_5.webp';
    return 'assets/images/flower_stage_6.webp';
  }

  int _nextAffectionStage(int score) {
    for (final target in const <int>[60, 150, 550, 1720, 2430, 5000]) {
      if (score < target) return target;
    }
    return 5000;
  }

  // 世界觀 AI 有時只回傳人物名稱（或舊版 NPC ID），用正式名單對齊。
  // 不改寫 Firestore 的正式角色 ID，也不製造不存在的分數。
  String _officialNpcId(String id, String name) {
    if (id.isNotEmpty && (_npcs.containsKey(id) || _names.containsKey(id) ||
        _characterAffinity.containsKey(id))) return id;
    final wanted = name.trim();
    if (wanted.isEmpty) return id;
    for (final entry in _names.entries) {
      if (entry.value.trim() == wanted) return entry.key;
    }
    return id;
  }

  ImageProvider? _worldAvatarProvider(String source) {
    final image = source.trim();
    if (image.startsWith('https://') || image.startsWith('http://')) {
      return CachedNetworkImageProvider(image);
    }
    if (image.startsWith('assets/')) return AssetImage(image);
    return null;
  }

  Future<void> _recoverAffinitiesFromCallable() async {
    try {
      // Callable 由後端驗證房間持有人，可在 Firestore 子集合規則不允許直讀時備援。
      final result = await _api.call({'worldId':widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId, 'action':'load'});
      final raw = (result.data as Map?)?['affinities'];
      if (!mounted || raw is! Map) return;
      final values = <String, int>{};
      for (final entry in raw.entries) {
        if (entry.value is num) values[entry.key.toString()] = (entry.value as num).toInt();
      }
      if (values.isNotEmpty) setState(() => _characterAffinity = {..._characterAffinity, ...values});
      debugPrint('世界觀好感度後端備援：${values.length} 位角色');
    } catch (e) {
      debugPrint('世界觀好感度後端備援失敗：$e');
    }
  }

  Widget _characterAffectionBadge(String characterId, ThemeData theme) {
    final score = _characterAffinity[characterId] ?? 0;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Image.asset(_affectionAsset(score), width: 15, height: 15,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(_legacyFlowerAsset(score),
              width: 15, height: 15, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink())),
      const SizedBox(width: 4),
      // 使用清楚的前景色及足夠字級，避免淺色主題下數值看起來消失。
      Text(
        '$score/${_nextAffectionStage(score)}',
        maxLines: 1,
        softWrap: false,
        style: GoogleFonts.notoSerifTc(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
    ]);
  }

  void _openFlowerStore() {
    if (kIsWeb) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_web_store_unavailable1);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StorePage()));
  }


  // 進入聊天室時先準備背景與常見人物圖片，再一起顯示。
  // 圖片失敗或網路較慢時不阻擋聊天室；圖片由 Flutter/磁碟影像快取持續管理。
  Future<void> _preloadWorldImages(String sessionId, String cover,
      Map<String, String> avatars) async {
    if (!mounted) return;
    String background = '';
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && sessionId.isNotEmpty) {
        final snap = await FirebaseFirestore.instance.collection('users').doc(uid)
            .collection('chatRoomBackgrounds').doc(ThemeNotifier.worldBackgroundKey(widget.worldId))
            .get().timeout(const Duration(seconds: 4));
        background = (snap.data()?['path'] ?? '').toString().trim();
        // 第一次讀取共用背景時，沿用目前房間舊版背景（若尚未建立共用設定）。
        if (!snap.exists) {
          final sharedRef = FirebaseFirestore.instance.collection('users').doc(uid)
              .collection('chatRoomBackgrounds').doc(ThemeNotifier.worldBackgroundKey(widget.worldId));
          final legacy = await FirebaseFirestore.instance.collection('users').doc(uid)
              .collection('chatRoomBackgrounds').doc(sessionId).get();
          final oldPath = (legacy.data()?['path'] ?? '').toString().trim();
          if (oldPath.isNotEmpty) {
            await FirebaseFirestore.instance.runTransaction((tx) async {
              final current = await tx.get(sharedRef);
              if (!current.exists) tx.set(sharedRef, {
                'path': oldPath, 'worldId': widget.worldId,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            });
            background = oldPath;
          }
        }
      }
    } catch (e) {
      debugPrint('世界聊天室背景預載略過：$e');
    }
    if (!mounted) return;
    _initialBackgroundPath = background;
    final sources = <String>{
      if (cover.isNotEmpty) cover,
      if (background.isNotEmpty) background,
      ...avatars.values.where((url) => url.isNotEmpty).take(24),
    };
    ImageProvider? providerFor(String src) {
      if (src.startsWith('https://') || src.startsWith('http://')) {
        return CachedNetworkImageProvider(src);
      }
      if (src.startsWith('assets/')) return AssetImage(src);
      return null;
    }
    await Future.wait<void>(sources.map((src) async {
      final provider = providerFor(src);
      if (provider == null || !mounted) return;
      try {
        await precacheImage(provider, context)
            .timeout(const Duration(seconds: 5));
      } catch (_) { /* 圖片不可用時由畫面內預設頭像處理 */ }
    })).timeout(const Duration(seconds: 6), onTimeout: () => <void>[]);
  }

  void _cacheCurrentRoom() {
    if (_sessionId == null || _sessionId!.isEmpty) return;
    _roomCache[_roomCacheKey] = {
      'sessionId': _sessionId,
      'worldName': _name,
      'coverImage': _worldCoverImage,
      'messages': List<dynamic>.from(_messages),
      'avatars': Map<String, String>.from(_npcs),
      'names': Map<String, String>.from(_names),
      'affinities': Map<String, int>.from(_characterAffinity),
    };
    // 限制記憶體占用，不讓快取隨世界數量無限成長。
    if (_roomCache.length > 4) _roomCache.remove(_roomCache.keys.first);
  }

  void _listenMessages(String sessionId) {
    if (widget.sessionId != null && widget.sessionId!.isNotEmpty && sessionId != widget.sessionId) {
      debugPrint('拒絕監聽其他世界觀房間: expected=${widget.sessionId}, requested=$sessionId');
      return;
    }
    if (_sessionId == sessionId && _messageSubscription != null) return;
    _messageSubscription?.cancel();
    _sessionId = sessionId;
    _listenCharacterAffinities(sessionId);
    _messageSubscription = FirebaseFirestore.instance
        .collection('artifacts').doc(AppConfig.appId)
        .collection('world_chat_sessions').doc(sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: true).limit(200)
        .snapshots().listen((snapshot) {
      if (!mounted) return;
      final docs = snapshot.docs.toList().reversed.toList();
      // The user and AI message of one request share a server timestamp.
      // Firestore's ID tie-break otherwise places ai_ before the user input.
      docs.sort((a,b) {
        final ta = (a.data()['timestamp'] as Timestamp?)?.microsecondsSinceEpoch ?? 0;
        final tb = (b.data()['timestamp'] as Timestamp?)?.microsecondsSinceEpoch ?? 0;
        if (ta != tb) return ta.compareTo(tb);
        if (a.id == 'ai_${b.id}') return 1;
        if (b.id == 'ai_${a.id}') return -1;
        return a.id.compareTo(b.id);
      });
      final next = docs.where((d) => d.data()['sender'] != 'control')
          .map((d) => <String,dynamic>{'id':d.id, ...d.data()}).toList();
      setState(() {
        _messages = next;
        _hasStreamData = true;
        _error = '';
        // The server has committed this exact request. Do not show two user bubbles.
        if (_pendingRequestId != null && next.any((m) => m['id'] == _pendingRequestId)) {
          _pendingVisible = false;
        }
        // The matching AI reply is already committed to Firestore.
        // Stop showing the generating indicator even if the callable response
        // is still fetching the room summary.
        if (_sending && _pendingRequestId != null &&
            next.any((m) => m['id'] == 'ai_$_pendingRequestId' && m['sender'] == 'ai')) {
          _sending = false;
        }
      });
      _cacheCurrentRoom();
      _scrollToLatest();
    }, onError: (Object error) {
      // The callable remains the read-only fallback if rules have not yet been deployed.
      if (mounted) _showCenterNotice(AppLocalizations.of(context)!.world_chat_sync_unavailable1, isError: true);
    });
  }

  bool _needsInitialScroll = true;

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final end = _scroll.position.maxScrollExtent;
      if (_needsInitialScroll) {
        _scroll.jumpTo(end); // No upward/downward animation during first entry.
        _needsInitialScroll = false;
      } else {
        _scroll.animateTo(end,
            duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
      }
    });
  }
  // Best-effort idle summary when the user leaves the world chat.
  // The server applies minimum-turn rules and an idempotent lease.
  void _requestExitSummary() {
    if (_sessionId == null || _sending || _loading) return;
    unawaited(FirebaseFunctions.instanceFor(region: 'asia-east1')
        .httpsCallable('worldStoryMemory', options: HttpsCallableOptions(timeout: const Duration(seconds: 120)))
        .call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId, 'action': 'generate'})
        .then((_) {}, onError: (Object error) {
      debugPrint('World story summary deferred: $error');
    }));
  }

  @override
  void dispose() {
    _requestExitSummary();
    _cacheCurrentRoom();
    // 與一般聊天室相同：正常返回列表即清掉最後房間指向。
    unawaited(_clearRememberedWorldRoom());
    WidgetsBinding.instance.removeObserver(this);
    _draftTimer?.cancel();
    // Persist the latest text even when leaving before the debounce timer fires.
    final lastDraft = _input.text;
    final lastDraftKey = _draftKey;
    unawaited(SharedPreferences.getInstance().then((prefs) async {
      if (lastDraft.trim().isEmpty) { await prefs.remove(lastDraftKey); }
      else { await prefs.setString(lastDraftKey, lastDraft); }
    }));
    _messageSubscription?.cancel();
    _flowerSubscription?.cancel();
    _affinitySubscription?.cancel();
    _centerNotice?.remove();
    _centerNotice?.dispose();
    _centerNotice = null;
    _input.dispose();
    _scroll.dispose();
    _focus.removeListener(_onInputFocusChanged);
    _focus.dispose();
    super.dispose();
  }

  /// 世界觀聊天室統一使用畫面中央提示，不使用底部 SnackBar。
  void _showCenterNotice(String message, {bool isError = false}) {
    if (!mounted) return;
    _centerNotice?.remove();
    _centerNotice?.dispose();
    _centerNotice = null;

    final overlay = Overlay.of(context);
    final theme = Theme.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: IgnorePointer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                color: theme.colorScheme.inverseSurface,
                elevation: 8,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
                          color: theme.colorScheme.onInverseSurface, size: 21),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.onInverseSurface,
                              fontSize: 13, height: 1.5),
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
    );
    _centerNotice = entry;
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (_centerNotice != entry) return;
      entry.remove();
      entry.dispose();
      _centerNotice = null;
    });
  }

  Future<void> _stopWorldGeneration() async {
    final requestId = _pendingRequestId;
    if (!_sending || _stoppingGeneration || requestId == null) return;
    setState(() => _stoppingGeneration = true);
    try {
      final result = await _api.call({
        'worldId': widget.worldId,
        if (widget.sessionId != null) 'sessionId': widget.sessionId,
        'action': 'cancel',
        'requestId': requestId,
      });
      if (!mounted) return;
      final cancelled = (result.data as Map?)?['cancelled'] == true;
      if (cancelled) {
        _cancelledLocalRequests.add(requestId);
        setState(() {
          _sending = false;
          _pendingVisible = false;
          _pendingFailed = false;
        });
        _pendingRequestId = null;
        _pendingRequestText = null;
        _showCenterNotice(AppLocalizations.of(context)!.world_chat_stopped1);
      } else {
        _showCenterNotice(AppLocalizations.of(context)!.world_chat_cannot_stop1);
      }
    } on FirebaseFunctionsException catch (e) {
      if (mounted) _showCenterNotice('停止失敗：${e.message ?? '請再試一次'}', isError: true);
    } catch (e) {
      if (mounted) _showCenterNotice(AppLocalizations.of(context)!.world_chat_stop_retry1, isError: true);
    } finally {
      if (mounted) setState(() => _stoppingGeneration = false);
    }
  }

  Future<void> _run(String action, {String message='', bool silent=false, Map<String,dynamic>? interaction}) async {
    if(action=='send' || action=='interact' || action=='regenerate' || action=='continue') {
      if(_sending || _loading)return;
      setState(() { _sending = true; _pendingFailed = false; });
      _scrollToLatest();
    }
    final requestIdAtStart = _pendingRequestId;
    try {
      final result = await _api.call({
        'action':action,'worldId':widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId,
        if(action=='send') 'message':message,
        if(action=='send' || action=='regenerate' || action=='continue') 'mode':_selectedMode,
        if(action=='regenerate') 'paidRegenerateConfirmed':_paidRegenerateConfirmed,
        if(action=='interact') ...?interaction,
        if(action=='send' || action=='interact' || action=='regenerate' || action=='continue') 'requestId':_pendingRequestId,
      });
      final data=Map<String,dynamic>.from(result.data as Map);
      if (!mounted || (requestIdAtStart != null && _cancelledLocalRequests.contains(requestIdAtStart))) return;
      // Explicitly opened rooms MUST never silently fall back to the legacy world room.
      // Reject the response before preloading images, applying messages or switching listeners.
      final expectedRoomId = widget.sessionId?.trim() ?? '';
      final returnedRoomId = (data['sessionId'] ?? '').toString().trim();
      if (expectedRoomId.isNotEmpty && returnedRoomId != expectedRoomId) {
        _messageSubscription?.cancel();
        _affinitySubscription?.cancel();
        if (mounted) setState(() {
          _loading = false;
          _sending = false;
          _messages = [];
          _hasStreamData = false;
          _error = '房間資料不一致，為避免顯示其他劇情，已停止載入。請確認世界觀後端已更新。';
        });
        debugPrint('世界觀房間不一致: expected=$expectedRoomId, returned=$returnedRoomId, action=$action');
        return;
      }
      final npcs = <String,String>{};
      final names = <String,String>{};
      for(final raw in (data['npcs'] as List? ?? [])) {
        if(raw is! Map)continue;
        final n=Map<String,dynamic>.from(raw);
        final id=(n['id']??'').toString();
        if(id.isNotEmpty){npcs[id]=(n['avatarUrl']??'').toString();names[id]=(n['name']??'').toString();}
      }
      // 不展示快取的半套畫面；快取僅用於減少再次進入的記憶體準備成本。
      if (action == 'load' && !_initialVisualsReady && _loading) {
        // Do not block first chat paint on slow image downloads or background migration.
        _initialVisualsReady = true;
        unawaited(_preloadWorldImages(
          (data['sessionId'] ?? '').toString(),
          (data['coverImage'] ?? '').toString(), npcs,
        ));
      }
      final sid = (data['sessionId'] ?? '').toString();
      final loadedAffinity = <String, int>{};
      final rawAffinity = data['affinities'];
      if (rawAffinity is Map) {
        for (final entry in rawAffinity.entries) {
          if (entry.value is num) {
            loadedAffinity[entry.key.toString()] = (entry.value as num).toInt().clamp(-5000, 5000);
          }
        }
      }
      setState(() {
        if (data['regenerateFreeRemaining'] is num) _regenerateFreeRemaining = (data['regenerateFreeRemaining'] as num).toInt().clamp(0, 3);
        if (loadedAffinity.isNotEmpty) _characterAffinity = {..._characterAffinity, ...loadedAffinity};
        _name=_safeWorldName(data['worldName']);
        _worldCoverImage=(data['coverImage']??'').toString();
        if (!_hasStreamData || _sessionId != sid) {
          _messages=List<dynamic>.from(data['messages'] as List? ?? []);
        }
        _npcs=npcs;_names=names;_loading=false;_error='';
      });
      if (sid.isNotEmpty) {
        _listenMessages(sid);
        unawaited(_rememberWorldRoom());
        if (action == 'load') {
          _serverLoadCompleted = true;
          // Session ID 可復原 Firestore 的裝置離線快取；不儲存明文對話。
          unawaited(SharedPreferences.getInstance().then(
                (prefs) => prefs.setString(_roomSessionPrefKey, sid),
          ).then((_) {}, onError: (Object e) => debugPrint('房間快取索引儲存略過：$e')));
        }
      }
      _cacheCurrentRoom();
      if (action == 'send' || action == 'interact' || action == 'regenerate' || action == 'continue') {
        // Remove optimistic bubble only once the returned result contains the saved request.
        // This works even when the Firestore listener is temporarily unavailable.
        final serverMessages = List<dynamic>.from(data['messages'] as List? ?? []);
        final confirmed = (action == 'regenerate' || action == 'continue') || serverMessages.any((m) => m is Map && m['id'] == _pendingRequestId);
        if (confirmed) {
          setState(() {
            _pendingVisible = false;
            // Fallback when the Firestore listener has not delivered the new pair yet.
            if (action == 'regenerate' || action == 'continue' || !_messages.any((m) => m is Map && m['id'] == _pendingRequestId)) {
              _messages = serverMessages;
            }
          });
        }
        // The input was cleared immediately on send. Never clear text typed afterwards.
        _pendingRequestId = null;
        _pendingRequestText = null;
        _pendingFailed = false;
      }
      _scrollToLatest();
    } on FirebaseFunctionsException catch(e) {
      if(!mounted || (requestIdAtStart != null && _cancelledLocalRequests.contains(requestIdAtStart)))return;
      setState((){
        _loading=false;_error=e.message ?? AppLocalizations.of(context)!.world_chat_connection_failed1;
        if (action == 'send' || action == 'interact') {
          _pendingFailed = true;
          // Restore the unsent text if the request failed, so the player can retry.
          // Do not overwrite anything newly typed by the player.
          if (_input.text.isEmpty) {
            _input.text = message;
            _input.selection = TextSelection.collapsed(offset: _input.text.length);
            _scheduleDraftSave(message);
          }
        }
      });
      if (!silent) _showCenterNotice(_error, isError: true);
    } catch(e) {
      if(!mounted || (requestIdAtStart != null && _cancelledLocalRequests.contains(requestIdAtStart)))return;
      setState((){
        _loading=false;_error=AppLocalizations.of(context)!.world_chat_network_failed1;
        if (action == 'send' || action == 'interact') {
          _pendingFailed = true;
          // Restore the unsent text if the request failed, so the player can retry.
          // Do not overwrite anything newly typed by the player.
          if (_input.text.isEmpty) {
            _input.text = message;
            _input.selection = TextSelection.collapsed(offset: _input.text.length);
            _scheduleDraftSave(message);
          }
        }
      });
      if (!silent) _showCenterNotice(_error, isError: true);
    } finally {
      // A successful call clears _pendingRequestId before reaching finally.
      // Comparing it with requestIdAtStart here leaves _sending stuck at true.
      if (mounted && (action == 'send' || action == 'interact' ||
          action == 'regenerate' || action == 'continue')) {
        setState(() => _sending = false);
      }
    }
  }

  // 重新生成：後端直接替換最新 AI 回覆，不重複收費或修改原回合好感度。
  Future<void> _regenerateWorld() async {
    if (_sending || _loading || _sessionId == null) return;
    if (!_messages.any((m) => m is Map && m['sender'] == 'ai' && m['id'] != 'opening')) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_no_regenerate1);
      return;
    }
    if (_regenerateFreeRemaining <= 0) {
      // 重新生成按原 AI 回覆的模式收費；後端仍是唯一計費權威。
      final latestAi = _messages.whereType<Map>().where((m) => m['sender'] == 'ai' && m['id'] != 'opening').lastOrNull;
      final originalMode = (latestAi?['chatMode'] ?? 'story').toString();
      final price = _modes[originalMode] ?? 5;
      if (_flowerPoints < price) {
        _showCenterNotice('花花不足，重新生成需要 $price 朵', isError:true);
        return;
      }
      final confirmed = await showDialog<bool>(
        context:context,
        builder:(c) => AlertDialog(
          title:Text(AppLocalizations.of(context)!.world_chat_paid_regenerate1),
          content:Text('今日 3 次免費額度已用完，依原回覆模式收取 $price 朵花花。是否繼續？'),
          actions:[
            TextButton(onPressed:()=>Navigator.pop(c,false),child:Text(AppLocalizations.of(context)!.world_chat_cancel1)),
            TextButton(onPressed:()=>Navigator.pop(c,true),child:Text(AppLocalizations.of(context)!.world_chat_confirm1)),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    _paidRegenerateConfirmed = _regenerateFreeRemaining <= 0;
    _pendingRequestId = 'r_${DateTime.now().microsecondsSinceEpoch}';
    _pendingRequestText = null;
    await _run('regenerate');
  }

  // 繼續：不替玩家做動作；依當前模式產生下一段，按模式扣花花。
  Future<void> _continueWorld() async {
    if (_sending || _loading || _sessionId == null) return;
    if (!_messages.any((m) => m is Map && m['sender'] == 'ai' && m['id'] != 'opening')) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_no_continue1);
      return;
    }
    final price = _modes[_selectedMode] ?? 5;
    if (_flowerPoints < price) {
      _showCenterNotice('花花不足，需要 $price 朵', isError: true);
      return;
    }
    _pendingRequestId = 'c_${DateTime.now().microsecondsSinceEpoch}';
    _pendingRequestText = null;
    await _run('continue');
  }

  void _send(){
    final text=_input.text.trim();
    if(text.isEmpty || _sending || _loading)return;
    // Retry an uncertain network result with the same ID; never charge/generate twice.
    if (_pendingRequestText != text || _pendingRequestId == null) {
      _pendingRequestId = 'm_${DateTime.now().microsecondsSinceEpoch}';
      _pendingRequestText = text;
    }
    // Clear the composer immediately, while keeping the message visible on the right.
    // The backend alone stores the authoritative message.
    _input.clear();
    _scheduleDraftSave('');
    setState(() { _pendingVisible = true; _pendingFailed = false; });
    _scrollToLatest();
    // 世界觀模式由後端決定價格、模型及成功後扣花花。
    _run('send',message:text);
  }

  // 僅從本玩家目前已授權讀取的世界房間訊息進行搜尋／匯出。
  // 目前同步視窗是最近 200 筆；不宣稱這是完整歷史。
  String _speakerName(Map<String, dynamic> segment) {
    if ((segment['kind'] ?? '') != 'npc') return '世界旁白';
    final id = (segment['npcId'] ?? '').toString();
    final savedName = (_names[id] ?? '').trim();
    final inlineName = (segment['name'] ?? '').toString().trim();
    return savedName.isNotEmpty ? savedName : (inlineName.isNotEmpty ? inlineName : 'NPC');
  }

  List<Map<String, String>> _flatTranscript() {
    final lines = <Map<String, String>>[];
    for (final raw in _messages) {
      if (raw is! Map) continue;
      final message = Map<String, dynamic>.from(raw);
      if (message['sender'] == 'user') {
        final content = (message['text'] ?? '').toString().trim();
        if (content.isNotEmpty) lines.add({'speaker': '玩家', 'text': content});
        continue;
      }
      for (final rawSegment in (message['segments'] as List? ?? const [])) {
        if (rawSegment is! Map) continue;
        final segment = Map<String, dynamic>.from(rawSegment);
        final content = (segment['text'] ?? '').toString().trim();
        if (content.isEmpty) continue;
        lines.add({'speaker': _speakerName(segment), 'text': content});
      }
    }
    return lines;
  }

  // 開啟搜尋／紀念書時重新讀取資料，而非沿用上一輪 AI 回傳的人物清單。
  Future<Map<String, dynamic>> _latestTranscriptIdentity() async {
    var playerName = '玩家';
    var playerAvatar = '';
    final names = Map<String, String>.from(_names);
    final avatars = Map<String, String>.from(_npcs);
    var cover = _worldCoverImage;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      playerName = (user.displayName ?? '').trim().isNotEmpty
          ? user.displayName!.trim() : playerName;
      playerAvatar = user.photoURL?.trim() ?? '';
      try {
        final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = snap.data() ?? <String, dynamic>{};
        final nickname = (data['nickname'] ?? '').toString().trim();
        final avatar = (data['avatarPath'] ?? '').toString().trim();
        if (nickname.isNotEmpty) playerName = nickname;
        if (avatar.isNotEmpty) playerAvatar = avatar;
      } catch (e) {
        debugPrint('世界觀搜尋讀取玩家最新資料失敗：$e');
      }
    }
    try {
      final snap = await FirebaseFirestore.instance
          .collection('artifacts').doc(AppConfig.appId)
          .collection('worlds').doc(widget.worldId).get();
      final data = snap.data() ?? <String, dynamic>{};
      final latestCover = (data['coverImage'] ?? '').toString().trim();
      if (latestCover.isNotEmpty) cover = latestCover;
      for (final raw in (data['npcCharacters'] as List? ?? const [])) {
        if (raw is! Map) continue;
        final id = (raw['id'] ?? '').toString().trim();
        if (id.isEmpty) continue;
        final name = (raw['name'] ?? '').toString().trim();
        final avatar = (raw['avatarUrl'] ?? '').toString().trim();
        if (name.isNotEmpty) names[id] = name;
        avatars[id] = avatar.isNotEmpty ? avatar : cover;
      }
    } catch (e) {
      debugPrint('世界觀搜尋讀取最新正式角色資料失敗：$e');
    }
    return <String, dynamic>{
      'playerName': playerName, 'playerAvatar': playerAvatar,
      'names': names, 'avatars': avatars, 'cover': cover,
    };
  }

  List<Map<String, String>> _searchEntries(Map<String, dynamic> identity) {
    final names = identity['names'] as Map<String, String>;
    final avatars = identity['avatars'] as Map<String, String>;
    final cover = identity['cover'] as String;
    final result = <Map<String, String>>[];
    for (final raw in _messages) {
      if (raw is! Map) continue;
      final message = Map<String, dynamic>.from(raw);
      if (message['sender'] == 'user') {
        final text = (message['text'] ?? '').toString().trim();
        if (text.isNotEmpty) result.add(<String, String>{
          'speaker': identity['playerName'] as String,
          'avatar': identity['playerAvatar'] as String,
          'kind': 'player', 'text': text,
        });
        continue;
      }
      for (final rawSegment in (message['segments'] as List? ?? const [])) {
        if (rawSegment is! Map) continue;
        final segment = Map<String, dynamic>.from(rawSegment);
        final text = (segment['text'] ?? '').toString().trim();
        if (text.isEmpty) continue;
        final isNpc = segment['kind'] == 'npc';
        final id = (segment['npcId'] ?? '').toString();
        final inlineName = (segment['name'] ?? '').toString().trim();
        result.add(<String, String>{
          'speaker': isNpc ? (names[id] ?? (inlineName.isNotEmpty ? inlineName : 'NPC')) : '世界旁白',
          'avatar': isNpc ? (avatars[id] ?? cover) : '',
          'kind': isNpc ? 'npc' : 'narrator', 'text': text,
        });
      }
    }
    return result;
  }

  Future<void> _searchWorldMessages() async {
    if (!mounted) return;
    final identity = await _latestTranscriptIdentity();
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldChatSearchPage(
        worldName: _name,
        messages: _searchEntries(identity),
      ),
    ));
  }

  /// Reuse the original book UI and PDF exporter; each NPC/narrator is
  /// represented by its own entry, preserving the actual speaker.
  Future<void> _saveWorldTranscript() async {
    if (_messages.isEmpty) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_no_save1);
      return;
    }
    final identity = await _latestTranscriptIdentity();
    if (!mounted) return;
    final latestNames = identity['names'] as Map<String, String>;
    final latestAvatars = identity['avatars'] as Map<String, String>;
    final playerName = identity['playerName'] as String;
    final cover = identity['cover'] as String;
    final transcript = <WorldBookMessage>[];
    final avatarPaths = <String, String>{};
    for (var i = 0; i < _messages.length; i++) {
      final raw = _messages[i];
      if (raw is! Map) continue;
      final message = Map<String, dynamic>.from(raw);
      final sender = (message['sender'] ?? '').toString();
      final stamp = message['timestamp'];
      DateTime? timestamp;
      if (stamp is Timestamp) timestamp = stamp.toDate();
      if (stamp is DateTime) timestamp = stamp;
      final msgId = (message['id'] ?? 'm_$i').toString();
      if (sender == 'user') {
        final t = (message['text'] ?? '').toString().trim();
        if (t.isNotEmpty) transcript.add(WorldBookMessage(id: msgId, sender: 'user',
            text: t, isAI: false, speakerName: playerName, avatarPath: identity['playerAvatar'] as String,
            npcId: '', timestamp: timestamp));
        continue;
      }
      final segments = message['segments'];
      if (segments is! List) continue;
      for (var j = 0; j < segments.length; j++) {
        final segmentRaw = segments[j];
        if (segmentRaw is! Map) continue;
        final segment = Map<String, dynamic>.from(segmentRaw);
        final t = (segment['text'] ?? '').toString().trim();
        if (t.isEmpty) continue;
        final isNpc = segment['kind'] == 'npc';
        final npcId = isNpc ? (segment['npcId'] ?? '').toString() : '';
        final inlineName = (segment['name'] ?? '').toString().trim();
        final name = isNpc ? (latestNames[npcId] ?? (inlineName.isNotEmpty ? inlineName : 'NPC')) : '世界旁白';
        // Temporary NPCs and narration use the creator-uploaded world cover.
        final avatar = isNpc ? (latestAvatars[npcId]?.trim().isNotEmpty == true
            ? latestAvatars[npcId]! : cover) : cover;
        final avatarKey = isNpc ? (npcId.isNotEmpty ? npcId : 'temp_${msgId}_$j') : '__narrator__';
        avatarPaths[avatarKey] = avatar;
        transcript.add(WorldBookMessage(id: '${msgId}_$j', sender: 'ai',
            text: t, isAI: true, speakerName: name, avatarPath: avatar,
            npcId: avatarKey, timestamp: timestamp));
      }
    }
    if (transcript.isEmpty) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_no_save1);
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldChatTranscriptBookPage(
        characterName: _name,
        characterAvatarPath: cover,
        characterPhotoPaths: cover.isEmpty ? const [] : [cover],
        playerName: playerName,
        initialStory: '',
        speakerAvatarPaths: avatarPaths,
        messages: transcript,
      ),
    ));
  }

  void _handleWorldMenuAction(String action) {
    // Menu labels can change for localization/copy edits. Background must not
    // fall through to the generic 'not connected' placeholder.
    final menuAction = action.trim();
    if (menuAction.contains('背景') ||
        menuAction.toLowerCase() == 'background' ||
        menuAction.toLowerCase() == 'chat_background') {
      _openWorldBackground();
      return;
    }
    switch (menuAction) {
      case '搜尋對話':
        _searchWorldMessages();
        break;
      case '保存對話紀錄':
        _saveWorldTranscript();
        break;
      case '世界紀錄':
      case '我的世界紀錄':
      case '劇情摘要':
        _openWorldRecords();
        break;
      case '人物關係':
        _openWorldRelationships();
        break;
      case '背景':
      case '聊天背景':
      case '更換背景':
        _openWorldBackground();
        break;
      case '給世界的備忘錄':
      case '備忘錄':
        _openWorldMemo();
        break;
      default:
        _notReady(action);
    }
  }

  Future<void> _openWorldRecords() async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldStoryTimelinePage(worldId: widget.worldId, worldName: _name, sessionId: _sessionId),
    ));
  }

  Future<void> _openWorldRelationships() async {
    final identity = await _latestTranscriptIdentity();
    if (!mounted) return;
    final names = identity['names'] as Map<String, String>;
    final avatars = identity['avatars'] as Map<String, String>;
    final cover = identity['cover'] as String;
    final sessionId = _sessionId;
    if (sessionId == null || sessionId.isEmpty) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_loading1);
      return;
    }
    final persons = <WorldLiveRelationshipPerson>[];
    for (final id in _npcs.keys) {
      persons.add(WorldLiveRelationshipPerson(
        id: id,
        name: names[id]?.trim().isNotEmpty == true ? names[id]! : (_names[id] ?? AppLocalizations.of(context)!.world_chat_unnamed_character1),
        avatar: avatars[id]?.trim().isNotEmpty == true ? avatars[id]! : cover,
      ));
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldRelationshipLivePage(worldName: _name, sessionId: sessionId, characters: persons),
    ));
  }

  Future<void> _openWorldBackground() async {
    if (_sessionId == null || _sessionId!.isEmpty) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_bg_wait1);
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => BackgroundSettingsPage(
        worldId: widget.worldId, sessionId: _sessionId!,
      ),
    ));
  }

  Future<void> _openWorldMemo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_sign_in1, isError: true);
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldChatMemosPage(
        worldId: widget.worldId, sessionId: _sessionId,
        worldName: _name,
      ),
    ));
  }

  void _notReady(String feature) {
    _showCenterNotice('$feature 的正式資料與後端尚未串接，目前是聊天室介面預覽');
  }

  void _pickMode() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text(AppLocalizations.of(context)!.world_chat_choose_mode1),
              subtitle: Text(AppLocalizations.of(context)!.world_chat_mode_charge_expl1)),
          for (final entry in _modes.entries)
            ListTile(
              title: Text(worldModeLabel(entry.key)),
              subtitle: Text('${entry.value} 朵花花／成功回覆'),
              trailing: _selectedMode == entry.key
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                setState(() => _selectedMode = entry.key);
                Navigator.pop(sheetContext);
              },
            ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  // 與一般角色聊天室共用相同的主題色、圖片資產與花草裝飾。
  Widget _worldToolItem(String assetPath, String title, VoidCallback onTap) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary.withValues(alpha: .88);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(width: 46, height: 46,
            child: Image.asset(assetPath, width: 46, height: 46,
              color: color, colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(Icons.widgets_outlined, size: 30, color: color),
            ),
          ),
          const SizedBox(height: 7),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(fontSize: 13.5, fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: .82), height: 1.2)),
        ]),
      ),
    );
  }

  // 手機相簿挑選玩家自己的照片。世界觀 API 尚未支援 image payload，
  // 不得偽裝已經送出、也不自行建立不受伺服器驗證的訊息。
  Future<void> _pickWorldPlayerPhoto() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 85,
      );
      if (!mounted || picked == null) return;
      await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.world_chat_photo_selected1),
        content: const Text('目前世界觀 AI 尚未串接照片上傳與辨識。照片不會傳送，也不會扣花花；待世界觀媒體 API 完成後才能正式送出。'),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(AppLocalizations.of(context)!.world_chat_got_it1))],
      ));
    } catch (e) {
      if (mounted) _showCenterNotice('無法開啟手機相簿：$e', isError: true);
    }
  }

  // 世界觀使用同一組拾光檔案卡片，但每個世界的套用狀態和 AI 身分獨立。
  Future<void> _editWorldPlayerIdentity() async {
    await WorldProfilePopup.show(
      context,
      worldId: widget.worldId, sessionId: _sessionId,
      onSaved: () {
        if (mounted) _showCenterNotice('世界觀拾光檔案已同步，下一輪 AI 對話將使用');
      },
    );
  }

  Future<void> _editWorldStatusSettings() async {
    final labels = <String, String>{
      'mood': AppLocalizations.of(context)!.world_chat_mood1, 'outfit': AppLocalizations.of(context)!.world_chat_outfit1, 'relationship': AppLocalizations.of(context)!.world_chat_relationship1, 'thought': AppLocalizations.of(context)!.world_chat_thought1,
      'weather': AppLocalizations.of(context)!.world_chat_weather1, 'currentState': AppLocalizations.of(context)!.world_chat_current_state1, 'action': AppLocalizations.of(context)!.world_chat_action1, 'affinity': AppLocalizations.of(context)!.world_chat_affinity1,
    };
    try {
      final result = await _api.call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId, 'action':'loadStatus'});
      if (!mounted) return;
      final response = Map<String, dynamic>.from(result.data as Map);
      final raw = Map<String, dynamic>.from(response['statusSettings'] as Map? ?? const {});
      final settings = <String, bool>{for (final key in labels.keys) key: raw[key] == true};
      final shouldSave = await showModalBottomSheet<bool>(context: context,
        showDragHandle: true, isScrollControlled: true,
        builder: (ctx) => StatefulBuilder(builder: (ctx, refresh) => SafeArea(
          child: Padding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(AppLocalizations.of(context)!.world_chat_status_settings1, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Flexible(child: ListView(shrinkWrap: true, children: [
                  for (final entry in labels.entries)
                    SwitchListTile(title: Text(entry.value), value: settings[entry.key] ?? false,
                        onChanged: (v) => refresh(() => settings[entry.key] = v)),
                ])),
                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.world_chat_save_settings1)),
              ])),
        )),
      );
      if (shouldSave != true || !mounted) return;
      await _api.call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId, 'action':'saveStatus', 'settings': settings});
      if (mounted) _showCenterNotice(AppLocalizations.of(context)!.world_chat_status_saved1);
    } catch (e) {
      if (mounted) _showCenterNotice('狀態欄設定失敗：$e', isError: true);
    }
  }

  // 互動玩法使用獨立 action=interact，避免被當成一般聊天模式再次扣 12 朵。
  Future<void> _sendWorldInteraction(Map<String,dynamic> event) async {
    if (_loading || _sending || _sessionId == null) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_not_ready1, isError:true);
      return;
    }
    final type = (event['interactionType'] ?? '').toString();
    final gift = (event['giftType'] ?? '').toString();
    final price = type == 'gift' ? const {'heart':1,'flower':1,'sun':1,'confetti':3,'coffee':5,'cake':5}[gift] ?? 0 : 3;
    if (_flowerPoints < price) {
      _showCenterNotice('花花不足，需要 $price 朵', isError:true);
      return;
    }
    _pendingRequestId = 'm_${DateTime.now().microsecondsSinceEpoch}';
    _pendingRequestText = null;
    setState(() { _pendingVisible = false; _pendingFailed = false; });
    await _run('interact', interaction:event);
  }

  Future<void> _openWorldInteraction() async {
    if (_sessionId == null || _sessionId!.isEmpty) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_enter_first1);
      return;
    }
    final result = await Navigator.of(context).push<Map<String,dynamic>>(MaterialPageRoute(
      builder: (_) => WorldInteractionPlayPage(
        worldName: _name,
        characters: Map<String, String>.from(_names),
      ),
    ));
    if (!mounted || result == null) return;
    await _sendWorldInteraction(result);
  }

  Future<void> _openWorldScene() async {
    if (_sessionId == null || _sessionId!.isEmpty) {
      _showCenterNotice(AppLocalizations.of(context)!.world_chat_enter_first1);
      return;
    }
    final result = await Navigator.of(context).push<String>(MaterialPageRoute(
      builder: (_) => WorldScenePage(
        worldId: widget.worldId, sessionId: _sessionId!,
        worldName: _name,
        characters: Map<String, String>.from(_names),
      ),
    ));
    if (!mounted || result == null || result.trim().isEmpty) return;
    // 使用正式世界觀訊息管線，不寫入一般聊天室 rooms / friendshipScore。
    // 劇場狀態尚未由世界觀後端獨立持久化，這是情境開場訊息。
    if (_input.text.trim().isNotEmpty) {
      _showCenterNotice('請先送出目前輸入框內容，再開始劇場');
      return;
    }
    _input.text = result;
    _send();
  }

  Future<void> _openWorldToolUnavailable(String name, String reason) async {
    if (!mounted) return;
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(
      title: Text(name), content: Text(reason),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.world_chat_got_it1))],
    ));
  }

  void _showWorldToolbox() {
    if (!mounted) return;
    _focus.unfocus();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (sheetContext) => _tools(),
    );
  }

  Widget _tools() {
    final theme = Theme.of(context);
    void closeAnd(VoidCallback action) {
      Navigator.of(context).pop();
      WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) action(); });
    }
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          theme.colorScheme.primaryContainer.withValues(alpha: .74),
          theme.colorScheme.surface,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: .18)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(fit: StackFit.expand, children: [
        Positioned(left: -18, top: 90, child: IgnorePointer(child: Opacity(opacity: .06,
            child: Image.asset('assets/images/chat/chat_tool_floral_left_middle_mask.png',
                width: 120, fit: BoxFit.contain, color: theme.colorScheme.primary,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => const SizedBox.shrink())))),
        Positioned(right: -10, bottom: -8, child: IgnorePointer(child: Opacity(opacity: .08,
            child: Image.asset('assets/images/chat/chat_tool_floral_right_bottom_mask.png',
                width: 150, fit: BoxFit.contain, color: theme.colorScheme.primary,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => const SizedBox.shrink())))),
        SafeArea(top: false, child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 42, height: 4, decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: .28),
              borderRadius: BorderRadius.circular(99))),
          const SizedBox(height: 8),
          Expanded(child: GridView.count(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
            crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12,
            childAspectRatio: 1.05, physics: const BouncingScrollPhysics(),
            children: [
              _worldToolItem('assets/images/chat/chat_tool_photo_mask.png', AppLocalizations.of(context)!.world_chat_photo1,
                      () => closeAnd(_pickWorldPlayerPhoto)),
              _worldToolItem('assets/images/chat/chat_tool_archive_mask.png', AppLocalizations.of(context)!.world_chat_profile1,
                      () => closeAnd(_editWorldPlayerIdentity)),
              _worldToolItem('assets/images/chat/chat_tool_interaction_mask.png', AppLocalizations.of(context)!.world_chat_interaction1,
                      () => closeAnd(_openWorldInteraction)),
              _worldToolItem('assets/images/chat/chat_tool_scene_mask.png', AppLocalizations.of(context)!.world_chat_theater1,
                      () => closeAnd(_openWorldScene)),
              _worldToolItem('assets/images/chat/chat_status_bar_mask.webp', AppLocalizations.of(context)!.world_chat_status1,
                      () => closeAnd(_editWorldStatusSettings)),
              _worldToolItem('assets/images/chat/chat_tool_story_mask.png', AppLocalizations.of(context)!.world_chat_secret1,
                      () => closeAnd(() => Navigator.push(context, MaterialPageRoute(builder: (_) => WorldSecretChaptersPage(worldId: widget.worldId, sessionId: _sessionId))))),
            ],
          )),
        ])),
      ]),
    );
  }

  Widget _drawerItem(IconData icon, String label) => ListTile(
    leading: Icon(icon), title: Text(label),
    onTap: () { Navigator.pop(context); _notReady(label); },
  );

  Widget _segment(Map<String,dynamic> value,ThemeData theme, Map<String,dynamic> parent, int segmentIndex) {
    final kind=(value['kind']??'').toString();
    final text=(value['text']??'').toString();
    final rawId=(value['npcId']??'').toString();
    final inlineName=(value['name']??'').toString();
    final id=_officialNpcId(rawId, inlineName);
    final name=_names[id] ?? inlineName;
    final url=_npcs[id]??'';
    if(kind!='npc')return GestureDetector(
        onTap: _worldSelectionMode ? () => _toggleWorldMessage(_worldSegmentKey((parent['id'] ?? '').toString(), segmentIndex)) : null,
        onLongPress: () => _showWorldSegmentOptions(parent, segmentIndex, value),
        child:Container(
          width:double.infinity, margin:const EdgeInsets.symmetric(vertical:5),
          padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(color:_selectedMessageIds.contains(_worldSegmentKey((parent['id'] ?? '').toString(), segmentIndex))
              ? (_worldDeleteMode ? Colors.red.withValues(alpha:.22) : theme.colorScheme.primary.withValues(alpha:.23))
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha:.65),
              borderRadius:BorderRadius.circular(16)),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('世界旁白',style:TextStyle(fontSize:11,color:theme.colorScheme.primary)),
            const SizedBox(height:5),Text(text,style:const TextStyle(height:1.65)),
          ]),
        ));
    return GestureDetector(
        onTap: _worldSelectionMode ? () => _toggleWorldMessage(_worldSegmentKey((parent['id'] ?? '').toString(), segmentIndex)) : null,
        onLongPress: () => _showWorldSegmentOptions(parent, segmentIndex, value),
        child:Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(
          crossAxisAlignment:CrossAxisAlignment.start,children:[
          CircleAvatar(radius:20,backgroundColor:theme.colorScheme.primaryContainer,
              backgroundImage:_worldAvatarProvider(url),
              child:_worldAvatarProvider(url)==null?const Icon(Icons.person_outline):null),
          const SizedBox(width:10),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(mainAxisSize: MainAxisSize.min, children: [
              Flexible(child: Text(name.isEmpty?'NPC':name,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style:GoogleFonts.notoSerifTc(fontSize:12,fontWeight:FontWeight.w600))),
              if (id.isNotEmpty && (_npcs.containsKey(id) || _names.containsKey(id) || _characterAffinity.containsKey(id))) ...[
                const SizedBox(width: 5),
                _characterAffectionBadge(id, theme),
              ],
            ]),
            const SizedBox(height:4),Container(padding:const EdgeInsets.all(12),
                decoration:BoxDecoration(color:_selectedMessageIds.contains(_worldSegmentKey((parent['id'] ?? '').toString(), segmentIndex))
                    ? (_worldDeleteMode ? Colors.red.withValues(alpha:.22) : theme.colorScheme.primary.withValues(alpha:.23))
                    : theme.colorScheme.surface,borderRadius:BorderRadius.circular(14),
                    border:Border.all(color:theme.colorScheme.primary.withValues(alpha:.12))),
                child:Text(text,style:const TextStyle(height:1.6))),
          ])),
        ],
        )));
  }

  // 世界觀狀態欄屬於 AI 回覆附加資訊；不插入台詞、旁白或玩家訊息。
  Widget _worldNpcStatusCards(Map<String, dynamic> message, ThemeData theme) {
    final rawStatuses = message['npcStatuses'];
    if (rawStatuses is! List || rawStatuses.isEmpty) return const SizedBox.shrink();
    final labels = <String, String>{
      'mood': AppLocalizations.of(context)!.world_chat_mood1, 'outfit': AppLocalizations.of(context)!.world_chat_outfit1, 'relationship': AppLocalizations.of(context)!.world_chat_relationship1,
      'thought': AppLocalizations.of(context)!.world_chat_thought1, 'weather': AppLocalizations.of(context)!.world_chat_weather1, 'currentState': AppLocalizations.of(context)!.world_chat_current_state1,
      'action': AppLocalizations.of(context)!.world_chat_action1, 'affinity': AppLocalizations.of(context)!.world_chat_affinity1,
    };
    final cards = <Widget>[];
    for (final raw in rawStatuses) {
      if (raw is! Map) continue;
      final status = Map<String, dynamic>.from(raw);
      final fieldsRaw = status['fields'];
      if (fieldsRaw is! Map) continue;
      final fields = Map<String, dynamic>.from(fieldsRaw);
      final entries = labels.entries.where((entry) =>
      fields[entry.key] != null && fields[entry.key].toString().trim().isNotEmpty).toList();
      if (entries.isEmpty) continue;
      final id = (status['characterId'] ?? '').toString();
      final name = (_names[id] ?? status['name'] ?? 'NPC').toString();
      cards.add(Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.18)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$name · 角色狀態', style: GoogleFonts.notoSerifTc(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          for (final entry in entries) Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text('${entry.value}：${fields[entry.key]}',
                style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
          ),
        ]),
      ));
    }
    if (cards.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 5, 6, 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: cards),
    );
  }

  // Pending player messages look exactly like ordinary messages: no status label.
  Widget _pendingUserBubble(ThemeData theme) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(13),
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .78),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(_pendingRequestText ?? '', style: TextStyle(height: 1.55,
          color: theme.brightness == Brightness.dark ? Colors.black : theme.colorScheme.onPrimaryContainer)),
    ),
  );

  // AI 回覆等待時僅顯示提示文字，不顯示頭像、Icon 或轉圈動畫。
  // 完整劇情生成完成後由訊息清單取代此提示。
  Widget _generatingBubble(ThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        AppLocalizations.of(context)!.world_chat_generating1,
        style: GoogleFonts.notoSerifTc(
          fontSize: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ),
    ),
  );

  String _worldMessageText(Map<String, dynamic> data) {
    if ((data['sender'] ?? '') == 'user') return (data['text'] ?? '').toString();
    return (data['segments'] as List? ?? const []).whereType<Map>().map((s) {
      final segment = Map<String, dynamic>.from(s);
      return '${_speakerName(segment)}：${segment['text'] ?? ''}';
    }).join('\n\n');
  }

  // 玩家以 messageId 選取；AI 以 messageId::segmentIndex 選取，避免整輪綁定。
  String _worldSegmentKey(String messageId, int index) => '$messageId::$index';

  void _toggleWorldMessage(String key) {
    if (key.isEmpty) return;
    setState(() {
      if (!_selectedMessageIds.add(key)) _selectedMessageIds.remove(key);
      if (_selectedMessageIds.isEmpty) _worldSelectionMode = false;
    });
  }

  void _beginWorldSelection(String key, {required bool delete}) {
    HapticFeedback.mediumImpact();
    setState(() {
      _worldSelectionMode = true;
      _worldDeleteMode = delete;
      _selectedMessageIds..clear()..add(key);
    });
  }

  void _exitWorldSelection() => setState(() {
    _worldSelectionMode = false;
    _worldDeleteMode = false;
    _selectedMessageIds.clear();
  });

  Widget _worldActionIcon(String file, {bool danger = false}) => Image.asset(
    'assets/images/chat/chat_msg_${file}_mask.webp',
    width: 36, height: 36, fit: BoxFit.contain,
    color: danger ? Colors.redAccent : Theme.of(context).colorScheme.primary,
    colorBlendMode: BlendMode.srcIn,
    errorBuilder: (_, __, ___) => Icon(danger ? Icons.delete_outline : Icons.more_horiz,
        color: danger ? Colors.redAccent : Theme.of(context).colorScheme.primary),
  );

  Future<void> _reportWorldText(String content) async {
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FeedbackPage(
      category: ReportCategory.aiReply,
      lockCategory: true,
      characterId: widget.worldId,
      characterName: _name,
      sessionId: _sessionId,
      reportedContent: content,
    )));
  }

  // 與設定頁「聯絡我們」共用正式表單，不直接寫 suggestions 集合。
  Future<void> _suggestWorldChat() async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => FeedbackPage(category: ReportCategory.suggestion),
    ));
  }

  void _showWorldSegmentOptions(Map<String,dynamic> parent, int segmentIndex,
      Map<String,dynamic> segment) {
    if (_worldSelectionMode) return;
    final messageId = (parent['id'] ?? '').toString();
    if (messageId.isEmpty) return;
    final speaker = _speakerName(segment);
    final key = _worldSegmentKey(messageId, segmentIndex);
    final content = (segment['text'] ?? '').toString();
    showModalBottomSheet<void>(context: context, builder: (ctx) => SafeArea(child: Wrap(children: [
      ListTile(leading: _worldActionIcon('screenshot'), title: Text(AppLocalizations.of(context)!.world_chat_screenshot1),
          onTap: () { Navigator.pop(ctx); _beginWorldSelection(key, delete: false); }),
      const Divider(),
      ListTile(leading: _worldActionIcon('copy'), title: Text(AppLocalizations.of(context)!.world_chat_copy1),
          onTap: () { Navigator.pop(ctx); Clipboard.setData(ClipboardData(text: content)); _showCenterNotice(AppLocalizations.of(context)!.world_chat_copied1); }),
      ListTile(leading: _worldActionIcon('edit'), title: Text(AppLocalizations.of(context)!.world_chat_edit1),
          onTap: () { Navigator.pop(ctx); _editWorldSegment(messageId, segmentIndex, segment); }),
      ListTile(leading: _worldActionIcon('delete', danger: true),
          title: Text(AppLocalizations.of(context)!.world_chat_delete1, style: TextStyle(color: Colors.redAccent)),
          onTap: () { Navigator.pop(ctx); _beginWorldSelection(key, delete: true); }),
      ListTile(leading: _worldActionIcon('report'), title: Text(AppLocalizations.of(context)!.world_chat_report1),
          onTap: () { Navigator.pop(ctx); _reportWorldText('[$speaker] $content'); }),
      ListTile(leading: _worldActionIcon('feedback'), title: Text(AppLocalizations.of(context)!.world_chat_feedback1),
          onTap: () { Navigator.pop(ctx); _suggestWorldChat(); }),
    ])));
  }

  Future<void> _editWorldSegment(String messageId,int index,Map<String,dynamic> segment) async {
    final controller=TextEditingController(text:(segment['text']??'').toString());
    try {
      final text=await showDialog<String>(context:context,builder:(ctx)=>AlertDialog(
          title:Text(AppLocalizations.of(context)!.world_chat_edit_segment1),
          content:TextField(controller:controller,maxLength:2500,minLines:2,maxLines:8),
          actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:Text(AppLocalizations.of(context)!.world_chat_cancel1)),
            FilledButton(onPressed:()=>Navigator.pop(ctx,controller.text.trim()),child:Text(AppLocalizations.of(context)!.world_chat_save1))]));
      if(text==null||text.isEmpty||text==(segment['text']??'').toString())return;
      await _api.call({'worldId':widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId,'action':'editSegment',
        'messageId':messageId,'segmentIndex':index,'message':text});
      if(mounted)_showCenterNotice('段落已更新');
    }catch(e){if(mounted)_showCenterNotice('編輯失敗：$e',isError:true);}
    finally{controller.dispose();}
  }

  Future<void> _deleteWorldSegment(String messageId,int index,String speaker) async {
    final confirmed=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
        title:Text(AppLocalizations.of(context)!.world_chat_delete_segment1),
        content:Text('確定只刪除「$speaker」的這一段嗎？其他角色與旁白會保留。刪除後無法復原。'),
        actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:Text(AppLocalizations.of(context)!.world_chat_cancel1)),
          FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:Text(AppLocalizations.of(context)!.world_chat_delete1))]));
    if(confirmed!=true)return;
    try{
      await _api.call({'worldId':widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId,'action':'deleteSegment',
        'messageId':messageId,'segmentIndex':index});
      if(mounted)_showCenterNotice(AppLocalizations.of(context)!.world_chat_deleted_segment1);
    }catch(e){if(mounted)_showCenterNotice('刪除失敗：$e',isError:true);}
  }

  Future<void> _editWorldMessage(Map<String, dynamic> data) async {
    if ((data['sender'] ?? '') != 'user') return;
    final id = (data['id'] ?? '').toString();
    final controller = TextEditingController(text:(data['text'] ?? '').toString());
    try {
      final edited = await showDialog<String>(context:context, builder:(ctx) => AlertDialog(
        title:Text(AppLocalizations.of(context)!.world_chat_edit_message1),
        content:TextField(controller:controller,maxLength:2500,minLines:2,maxLines:8,
            decoration:InputDecoration(hintText:AppLocalizations.of(context)!.world_chat_edit_hint1)),
        actions:[
          TextButton(onPressed:()=>Navigator.pop(ctx),child:Text(AppLocalizations.of(context)!.world_chat_cancel1)),
          FilledButton(onPressed:()=>Navigator.pop(ctx,controller.text.trim()),child:Text(AppLocalizations.of(context)!.world_chat_save1)),
        ],
      ));
      if (edited == null || edited.isEmpty || edited == (data['text'] ?? '').toString()) return;
      await _api.call({'worldId':widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId,'action':'edit','messageId':id,'message':edited});
      if (mounted) _showCenterNotice(AppLocalizations.of(context)!.world_chat_updated1);
    } catch (e) {
      if (mounted) _showCenterNotice('編輯失敗：$e',isError:true);
    } finally {controller.dispose();}
  }

  Future<void> _deleteWorldMessages() async {
    final keys = _selectedMessageIds.toList();
    if (keys.isEmpty) return;
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.world_chat_delete_conversation1),
      content: Text('確定刪除選取的 ${keys.length} 段對話？其他未選取的角色與旁白會保留。刪除後無法還原。'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.world_chat_cancel1)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.world_chat_delete1)),
      ],
    ));
    if (confirmed != true) return;
    // 同筆 AI 訊息由大索引開始刪除，確保先前選取索引不位移。
    keys.sort((a, b) {
      final ai = a.lastIndexOf('::');
      final bi = b.lastIndexOf('::');
      final ap = ai >= 0 ? a.substring(0, ai) : a;
      final bp = bi >= 0 ? b.substring(0, bi) : b;
      if (ap != bp) return ap.compareTo(bp);
      final an = ai >= 0 ? int.tryParse(a.substring(ai + 2)) ?? -1 : -1;
      final bn = bi >= 0 ? int.tryParse(b.substring(bi + 2)) ?? -1 : -1;
      return bn.compareTo(an);
    });
    int done = 0;
    for (final key in keys) {
      try {
        final split = key.lastIndexOf('::');
        if (split >= 0) {
          await _api.call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId, 'action': 'deleteSegment',
            'messageId': key.substring(0, split),
            'segmentIndex': int.parse(key.substring(split + 2))});
        } else {
          await _api.call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId':widget.sessionId, 'action': 'delete', 'messageId': key});
        }
        done++;
      } catch (e) {
        if (mounted) _showCenterNotice('已刪除 $done 段，但有部分刪除失敗：$e', isError: true);
        break;
      }
    }
    if (!mounted) return;
    _exitWorldSelection();
    if (done == keys.length) _showCenterNotice('已刪除 $done 段對話');
  }

  List<Map<String, String>> _selectedWorldScreenshotLines() {
    final lines = <Map<String, String>>[];
    for (final raw in _messages) {
      if (raw is! Map) continue;
      final message = Map<String, dynamic>.from(raw);
      final id = (message['id'] ?? '').toString();
      if (message['sender'] == 'user') {
        if (_selectedMessageIds.contains(id)) {
          lines.add({'speaker': '玩家', 'text': (message['text'] ?? '').toString(),
            'avatar': '', 'kind': 'user'});
        }
        continue;
      }
      final segments = message['segments'] as List? ?? const [];
      for (var i = 0; i < segments.length; i++) {
        if (!_selectedMessageIds.contains(_worldSegmentKey(id, i))) continue;
        if (segments[i] is! Map) continue;
        final segment = Map<String, dynamic>.from(segments[i] as Map);
        final npcId = _officialNpcId((segment['npcId'] ?? '').toString(),
            (segment['name'] ?? '').toString());
        final kind = (segment['kind'] ?? '').toString();
        lines.add({'speaker': kind == 'npc' ? (_names[npcId] ?? _speakerName(segment)) : '世界旁白',
          'text': (segment['text'] ?? '').toString(),
          'avatar': kind == 'npc' ? (_npcs[npcId] ?? _worldCoverImage) : _worldCoverImage,
          'kind': kind});
      }
    }
    return lines;
  }

  // 與一般聊天室同一截圖流程：畫面上逐段勾選、預覽長圖、
  // 畫筆循環切換跟隨主題／曜石黑／晨曦白，最後由玩家分享。
  Widget _buildWorldScreenshotCanvas(
      List<Map<String, String>> lines, {
        bool showHeader = true,
        bool showFooter = true,
      }) {
    final theme = Theme.of(context);
    final dark = _worldScreenshotStyle == 1;
    final light = _worldScreenshotStyle == 2;
    final bg = dark ? const Color(0xFF1A1A24)
        : light ? const Color(0xFFF5F6F8) : theme.colorScheme.surface;
    final ink = dark ? Colors.white
        : light ? Colors.black87 : theme.colorScheme.onSurface;
    final accent = dark ? Colors.white70
        : light ? Colors.black54 : theme.colorScheme.primary;
    // 只影響匯出圖片：玩家泡泡採柔和底色，避免主題 primary 過深。
    final userBubbleColor = dark
        ? const Color(0xFF363244)
        : light
        ? const Color(0xFFEAE5F2)
        : theme.colorScheme.primaryContainer;
    final userBubbleText = dark
        ? const Color(0xFFF8F5FC)
        : light
        ? const Color(0xFF37303F)
        : theme.colorScheme.onPrimaryContainer;
    return MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: bg,
          child: Container(
            width: 320,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 16),
            color: bg,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (showHeader) Text('與$_name的專屬時光', textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(fontSize: 20,
                      fontWeight: FontWeight.bold, color: ink)),
              if (showHeader) const SizedBox(height: 24),
              for (final line in lines) Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Row(
                  mainAxisAlignment: line['kind'] == 'user'
                      ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (line['kind'] != 'user') ...[
                      CircleAvatar(radius: 16,
                          backgroundColor: dark ? Colors.white12
                              : theme.colorScheme.primaryContainer,
                          backgroundImage: _worldAvatarProvider(line['avatar'] ?? ''),
                          child: _worldAvatarProvider(line['avatar'] ?? '') == null
                              ? Text((line['speaker'] ?? '世').isEmpty ? '世'
                              : (line['speaker'] ?? '世').substring(0, 1),
                              style: TextStyle(fontSize: 12, color: accent))
                              : null),
                      const SizedBox(width: 8),
                    ],
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: line['kind'] == 'user' ? 284 : 244,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: line['kind'] == 'user'
                                ? userBubbleColor
                                : dark ? const Color(0xFF292631)
                                : light ? Colors.black.withValues(alpha: .06)
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(line['speaker'] ?? '',
                                  style: GoogleFonts.notoSerifTc(fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: line['kind'] == 'user'
                                          ? userBubbleText
                                          : dark ? Colors.white70 : accent)),
                              const SizedBox(height: 5),
                              Text(line['text'] ?? '',
                                  style: GoogleFonts.notoSerifTc(fontSize: 14,
                                      height: 1.55,
                                      color: line['kind'] == 'user'
                                          ? userBubbleText
                                          : dark ? Colors.white : ink)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              if (showFooter) const SizedBox(height: 12),
              if (showFooter) Divider(color: ink.withValues(alpha: .15)),
              if (showFooter) Text('戀戀拾光 · 開放世界',
                  style: GoogleFonts.notoSerifTc(fontSize: 11,
                      color: ink.withValues(alpha: .55))),
            ]),
          ),
        ),
      ),
    );
  }

  /// 將超長對話切成可獨立排版的短訊息；文字內容不刪減。
  List<Map<String, String>> _splitWorldScreenshotLines(
      List<Map<String, String>> original,
      ) {
    final result = <Map<String, String>>[];
    for (final line in original) {
      final points = (line['text'] ?? '').runes.toList();
      if (points.isEmpty) {
        result.add(line);
        continue;
      }
      for (var offset = 0; offset < points.length; offset += 150) {
        final end = (offset + 150 < points.length) ? offset + 150 : points.length;
        result.add(<String, String>{
          ...line,
          'text': String.fromCharCodes(points.sublist(offset, end)),
          'speaker': offset == 0 ? (line['speaker'] ?? '') : '${line['speaker'] ?? ''}（續）',
        });
      }
    }
    return result;
  }

  /// 不依賴目前的螢幕高度：每兩段個別渲染 PNG，最後在同一張畫布上合成長圖。
  Future<Uint8List> _captureWorldLongScreenshot(
      List<Map<String, String>> selected,
      ) async {
    final parts = _splitWorldScreenshotLines(selected);
    final images = <ui.Image>[];
    try {
      for (var i = 0; i < parts.length; i += 2) {
        final end = (i + 2 < parts.length) ? i + 2 : parts.length;
        final png = await _worldScreenshot.captureFromWidget(
          InheritedTheme.captureAll(
            context,
            _buildWorldScreenshotCanvas(
              parts.sublist(i, end),
              showHeader: i == 0,
              showFooter: end == parts.length,
            ),
          ),
          context: context,
          delay: const Duration(milliseconds: 90),
          pixelRatio: 2,
        );
        final codec = await ui.instantiateImageCodec(png);
        try {
          final frame = await codec.getNextFrame();
          images.add(frame.image);
        } finally {
          codec.dispose();
        }
      }
      if (images.isEmpty) throw StateError('沒有可以輸出的對話');
      final width = images.first.width;
      final height = images.fold<int>(0, (sum, img) => sum + img.height);
      // 避免極大量訊息造成裝置圖片緩衝區配置失敗。
      if (height > 16000 || width * height > 18000000) {
        throw StateError('選取的對話太長，請減少勾選段數後再截圖');
      }
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      double top = 0;
      for (final img in images) {
        canvas.drawImage(img, ui.Offset(0, top), ui.Paint());
        top += img.height.toDouble();
      }
      final picture = recorder.endRecording();
      try {
        final merged = await picture.toImage(width, height);
        try {
          final data = await merged.toByteData(format: ui.ImageByteFormat.png);
          if (data == null) throw StateError('長截圖編碼失敗');
          return data.buffer.asUint8List();
        } finally {
          merged.dispose();
        }
      } finally {
        picture.dispose();
      }
    } finally {
      for (final img in images) {
        img.dispose();
      }
    }
  }

  Future<void> _shareWorldScreenshot() async {
    final lines = _selectedWorldScreenshotLines();
    if (lines.isEmpty) return;
    // 使用世界設定的最新正式角色頭像，確保不因舊聊天快取而顯示文字首字。
    final identity = await _latestTranscriptIdentity();
    if (!mounted) return;
    final latestAvatars = identity['avatars'] as Map<String, String>;
    final latestNames = identity['names'] as Map<String, String>;
    for (final line in lines) {
      if (line['kind'] == 'user') {
        line['avatar'] = identity['playerAvatar'] as String;
      } else if (line['kind'] == 'npc') {
        final speaker = line['speaker'] ?? '';
        for (final entry in latestNames.entries) {
          if (entry.value.trim() == speaker.trim()) {
            final avatar = latestAvatars[entry.key] ?? '';
            if (avatar.isNotEmpty) line['avatar'] = avatar;
            break;
          }
        }
      }
    }
    // captureFromWidget 在離屏繪製，圖片必須先解碼到 Flutter image cache。
    for (final avatar in lines.map((line) => line['avatar'] ?? '').toSet()) {
      final provider = _worldAvatarProvider(avatar);
      if (provider == null) continue;
      try {
        await precacheImage(provider, context)
            .timeout(const Duration(seconds: 6));
      } catch (e) {
        debugPrint('截圖頭像預載失敗：$avatar $e');
      }
    }
    if (!mounted) return;
    final theme = Theme.of(context);
    var dialogOpen = false;
    try {
      // 分段離屏截圖再合併：不能把所有長對話直接放進同一個受螢幕
      // 高度限制的 Column，否則部分裝置會 RenderFlex overflow。
      // 每段至多 150 個 Unicode code points，避免單則極長回覆再次溢出。
      Future<Uint8List> capture() => _captureWorldLongScreenshot(lines);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      dialogOpen = true;
      Uint8List bytes = await capture();
      if (!mounted) return;
      Navigator.of(context).pop();
      dialogOpen = false;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (innerContext, updateDialog) {
            return _WorldScreenshotPreview(
              key: ValueKey(_worldScreenshotStyle),
              bytes: bytes,
              primary: theme.colorScheme.primary,
              onRestyle: () async {
                _worldScreenshotStyle = (_worldScreenshotStyle + 1) % 3;
                final updated = await capture();
                if (!innerContext.mounted) return;
                updateDialog(() { bytes = updated; });
              },
              onCancel: () => Navigator.pop(dialogContext),
              onShare: () async {
                Navigator.pop(dialogContext);
                await Share.shareXFiles([
                  XFile.fromData(bytes, mimeType: 'image/png',
                      name: 'lianlian_world_screenshot.png'),
                ], text: '戀戀拾光 · $_name');
                if (mounted) _exitWorldSelection();
              },
            );
          },
        ),
      );
    } catch (e) {
      if (dialogOpen && mounted) Navigator.of(context).pop();
      if (mounted) _showCenterNotice('截圖分享失敗：$e', isError: true);
    }
  }

  void _showWorldMessageOptions(Map<String, dynamic> data) {
    if (_worldSelectionMode) return;
    final id = (data['id'] ?? '').toString();
    if (id.isEmpty || data['sender'] != 'user') return;
    final content = _worldMessageText(data);
    showModalBottomSheet<void>(context: context, builder: (ctx) => SafeArea(child: Wrap(children: [
      ListTile(leading: _worldActionIcon('screenshot'), title: Text(AppLocalizations.of(context)!.world_chat_screenshot1),
          onTap: () { Navigator.pop(ctx); _beginWorldSelection(id, delete: false); }),
      const Divider(),
      ListTile(leading: _worldActionIcon('copy'), title: Text(AppLocalizations.of(context)!.world_chat_copy1),
          onTap: () { Navigator.pop(ctx); Clipboard.setData(ClipboardData(text: content)); _showCenterNotice(AppLocalizations.of(context)!.world_chat_copied1); }),
      ListTile(leading: _worldActionIcon('edit'), title: Text(AppLocalizations.of(context)!.world_chat_edit1),
          onTap: () { Navigator.pop(ctx); _editWorldMessage(data); }),
      ListTile(leading: _worldActionIcon('delete', danger: true),
          title: Text(AppLocalizations.of(context)!.world_chat_delete1, style: TextStyle(color: Colors.redAccent)),
          onTap: () { Navigator.pop(ctx); _beginWorldSelection(id, delete: true); }),
      ListTile(leading: _worldActionIcon('report'), title: Text(AppLocalizations.of(context)!.world_chat_report1),
          onTap: () { Navigator.pop(ctx); _reportWorldText(content); }),
      ListTile(leading: _worldActionIcon('feedback'), title: Text(AppLocalizations.of(context)!.world_chat_feedback1),
          onTap: () { Navigator.pop(ctx); _suggestWorldChat(); }),
    ])));
  }

  Widget _wrapWorldMessage(Map<String,dynamic> data, Widget child) {
    final id = (data['id'] ?? '').toString();
    final isUser = data['sender'] == 'user';
    final selected = _selectedMessageIds.contains(id);
    if (!isUser) return child; // AI 的選取控制在各自的 segment 上。
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => _showWorldMessageOptions(data),
      onTap: _worldSelectionMode ? () => _toggleWorldMessage(id) : null,
      child: Container(
        color: selected ? (_worldDeleteMode ? Colors.red.withValues(alpha: .12)
            : Theme.of(context).colorScheme.primary.withValues(alpha: .12)) : null,
        child: Row(children: [
          if (_worldSelectionMode) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Icon(selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _worldDeleteMode ? Colors.red : Theme.of(context).colorScheme.primary)),
          Expanded(child: child),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    final bgRef = _sessionId == null ? null : FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser?.uid ?? '')
        .collection('chatRoomBackgrounds').doc(ThemeNotifier.worldBackgroundKey(widget.worldId));
    return Scaffold(
      appBar: WorldChatHeader(
        worldName: _name == '開放世界' ? AppLocalizations.of(context)!.world_chat_open_world1 : _name,
        flowerPoints: _flowerPoints,
        onFlowerTap: _openFlowerStore,
        modeId: _selectedMode,
        onModeSelected: (id) => setState(() => _selectedMode = id),
        onBack: () => Navigator.of(context).maybePop(),
        onMenuTap: () => WorldChatSideMenu.show(
          context,
          menu: WorldChatSideMenu(
            worldName: _name,
            onAction: _handleWorldMenuAction,
          ),
        ),
      ),
      body:StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream: bgRef?.snapshots(),
        builder:(context,bgSnapshot) {
          final path=(bgSnapshot.data?.data()?['path'] ?? _initialBackgroundPath ?? '').toString().trim();
          ImageProvider? bgImage;
          if (path.startsWith('https://') || path.startsWith('http://')) {
            bgImage=CachedNetworkImageProvider(path);
          } else if (path.startsWith('assets/')) {
            bgImage=AssetImage(path);
          }
          return Container(
            decoration: bgImage == null ? context.watch<ThemeNotifier>().chatDefaultBackground
                : BoxDecoration(image: DecorationImage(image: bgImage, fit: BoxFit.cover)),
            child: Stack(children: [
              // Match the regular chat's soft washed-out photo treatment.
              // Only cover the picture: message bubbles stay crisp above it.
              if (bgImage != null)
                Positioned.fill(child: IgnorePointer(
                    child: ColoredBox(color: Colors.white.withValues(alpha: 0.55)))),
              SafeArea(child:Column(children:[
                if (_loading) const Expanded(child: SizedBox.expand())
                else Expanded(child: (_messages.isEmpty && !_pendingVisible && !_sending)
                    ? Center(child: Text(_error.isEmpty ? AppLocalizations.of(context)!.world_chat_no_chat1 : '$_error\n可返回後重試',
                    textAlign: TextAlign.center))
                    : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_pendingVisible ? 1 : 0) + (_sending ? 1 : 0),
                  itemBuilder: (context,index) {
                    if (index == _messages.length && _pendingVisible) {
                      return _pendingUserBubble(theme);
                    }
                    if (index == _messages.length + (_pendingVisible ? 1 : 0) && _sending) {
                      return _generatingBubble(theme);
                    }
                    final raw = _messages[index];
                    if (raw is! Map) return const SizedBox.shrink();
                    final data = Map<String,dynamic>.from(raw);
                    if (data['sender'] == 'user') return _wrapWorldMessage(data, Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(13),
                        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .78),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(17)),
                        child: Text((data['text'] ?? '').toString(),
                            style: TextStyle(height: 1.55,
                                color: theme.brightness == Brightness.dark ? Colors.black : theme.colorScheme.onPrimaryContainer)),
                      ),
                    ));
                    return _wrapWorldMessage(data, Column(children: [
                      for (var segmentIndex = 0; segmentIndex < (data['segments'] as List? ?? []).length; segmentIndex++)
                        if ((data['segments'] as List)[segmentIndex] is Map)
                          _segment(Map<String,dynamic>.from((data['segments'] as List)[segmentIndex] as Map),theme,data,segmentIndex),
                      if (data['sender'] == 'ai') _worldNpcStatusCards(data, theme),
                    ]));
                  },
                )),
                if (_worldSelectionMode)
                  SafeArea(top:false,child:Padding(
                    padding:const EdgeInsets.symmetric(horizontal:12,vertical:6),
                    child:Row(children:[
                      IconButton(tooltip:AppLocalizations.of(context)!.world_chat_cancel_select1,onPressed:_exitWorldSelection,
                          icon:const Icon(Icons.close)),
                      Expanded(child:Text('已選 ${_selectedMessageIds.length} 段（可繼續點選）')),
                      FilledButton.icon(
                        onPressed:_selectedMessageIds.isEmpty?null:
                        (_worldDeleteMode?_deleteWorldMessages:_shareWorldScreenshot),
                        icon:Icon(_worldDeleteMode?Icons.delete_outline:Icons.ios_share),
                        label:Text(_worldDeleteMode?AppLocalizations.of(context)!.world_chat_delete1:AppLocalizations.of(context)!.world_chat_screenshot1),
                      ),
                    ]),
                  )),
                // Keep the input compact when unfocused. The action shortcut is
                // visible only while the user is typing, matching regular chat.
                if (_focus.hasFocus)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 2, 22, 2),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: _insertActionParentheses,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 48, minHeight: 24),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: .38),
                              ),
                            ),
                            child: Text('（ ）', style: GoogleFonts.notoSerifTc(
                              fontSize: 12,
                              color: theme.colorScheme.primary.withValues(alpha: .7),
                            )),
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _input,
                          builder: (context, value, _) => Text(
                            '${value.text.length}/900',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 10,
                              color: value.text.length >= 900
                                  ? Colors.redAccent
                                  : theme.colorScheme.onSurface.withValues(alpha: .38),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ChatInputBar(
                  controller: _input,
                  focusNode: _focus,
                  isGenerating: _sending,
                  isLoading: _loading,
                  showCounter: false,
                  hintText: AppLocalizations.of(context)!.world_chat_input_hint1,
                  regeneratingTooltip: '重新生成（每日前 3 次免費，之後依模式扣花花）',
                  continueTooltip: '繼續回覆（依目前模式扣花花）',
                  onChanged: _scheduleDraftSave,
                  onToolbox: _showWorldToolbox,
                  onSticker: null,
                  onRegenerate: _regenerateWorld,
                  onContinue: _continueWorld,
                  onStop: _stopWorldGeneration,
                  onSend: _send,
                ),
              ])),
              // Always keep a visible loading indicator ABOVE the background,
              // message list and input. Both newly created and old rooms use it.
              if (_loading)
                Positioned.fill(
                  child: ColoredBox(
                    color: theme.scaffoldBackgroundColor.withValues(alpha: 0.94),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 3,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            AppLocalizations.of(context)!.world_chat_loading1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 15,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ]),
          );
        },
      ),
    );
  }
}

/// 預覽與三種浮水印主題切換；截圖需由玩家確認後才能分享。
class _WorldScreenshotPreview extends StatefulWidget {
  const _WorldScreenshotPreview({super.key, required this.bytes, required this.primary,
    required this.onRestyle, required this.onCancel, required this.onShare});
  final Uint8List bytes;
  final Color primary;
  final Future<void> Function() onRestyle;
  final VoidCallback onCancel;
  final Future<void> Function() onShare;
  @override
  State<_WorldScreenshotPreview> createState() => _WorldScreenshotPreviewState();
}
class _WorldScreenshotPreviewState extends State<_WorldScreenshotPreview> {
  bool busy = false;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Row(children: [
      Expanded(child: Text(AppLocalizations.of(context)!.world_chat_screenshot_done1,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      IconButton(icon: const Icon(Icons.brush),
          tooltip: AppLocalizations.of(context)!.world_chat_screenshot_style1, color: widget.primary,
          onPressed: busy ? null : () async {
            setState(() => busy = true);
            try { await widget.onRestyle(); }
            finally { if (mounted) setState(() => busy = false); }
          }),
    ]),
    content: SizedBox(width: 400, child: busy
        ? const SizedBox(height: 200,
        child: Center(child: CircularProgressIndicator()))
        : SingleChildScrollView(child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(widget.bytes, fit: BoxFit.contain))),
    ),
    actions: [
      TextButton(onPressed: busy ? null : widget.onCancel,
          child: Text(AppLocalizations.of(context)!.world_chat_reselect1)),
      ElevatedButton.icon(onPressed: busy ? null : widget.onShare,
          style: ElevatedButton.styleFrom(backgroundColor: widget.primary,
              foregroundColor: Colors.white),
          icon: const Icon(Icons.download, size: 18),
          label: Text(AppLocalizations.of(context)!.world_chat_download_share1)),
    ],
  );
}


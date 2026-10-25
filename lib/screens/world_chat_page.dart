import 'dart:async';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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
import 'world_chat_side_menu.dart';
import 'world_chat_search_page.dart';
import 'world_chat_transcript_book_page.dart';
import 'world_chat_records_pages.dart';
import 'world_chat_memos_page.dart';

/// 私人試玩；所有訊息經 Cloud Function 授權、讀取與儲存。
/// 目前僅限世界創作者。正式公開玩家玩法和花花計費尚未開放。
class WorldChatPage extends StatefulWidget {
  const WorldChatPage({super.key, required this.worldId});
  final String worldId;
  @override
  State<WorldChatPage> createState() => _WorldChatPageState();
}

class _WorldChatPageState extends State<WorldChatPage> with WidgetsBindingObserver {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  bool _loading = true;
  bool _sending = false;
  String _name = '開放世界';
  String _error = '';
  String _worldCoverImage = '';
  String _selectedMode = 'story';
  bool _toolPanelOpen = false;
  OverlayEntry? _centerNotice;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _flowerSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _affinitySubscription;
  int _flowerPoints = 0;
  Map<String, int> _characterAffinity = {};
  Timer? _draftTimer;
  String? _sessionId;
  String? _pendingRequestId;
  String? _pendingRequestText;
  bool _hasStreamData = false;
  // Local-only bubble while the server is generating; never written to Firestore by client.
  bool _pendingFailed = false;
  bool _pendingVisible = false;
  String get _draftKey => 'world_chat_draft_${FirebaseAuth.instance.currentUser?.uid ?? 'anon'}_${widget.worldId}';
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
    _run('load');
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
      if (mounted) _showCenterNotice('花花餘額暫時無法同步', isError: true);
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
      setState(() => _characterAffinity = values);
    }, onError: (Object error) {
      // 若尚未開放此子集合的讀取權限，仍顯示初始值，不影響私人試玩。
    });
  }

  String _affectionAsset(int score) {
    if (score < 60) return 'assets/images/affection/affection_stage_1.png';
    if (score < 150) return 'assets/images/affection/affection_stage_2.png';
    if (score < 550) return 'assets/images/affection/affection_stage_3.png';
    if (score < 1720) return 'assets/images/affection/affection_stage_4.png';
    if (score < 2430) return 'assets/images/affection/affection_stage_5.png';
    return 'assets/images/affection/affection_stage_6.png';
  }

  String _legacyFlowerAsset(int score) {
    if (score < 60) return 'assets/images/flower_stage_1.png';
    if (score < 150) return 'assets/images/flower_stage_2.png';
    if (score < 550) return 'assets/images/flower_stage_3.png';
    if (score < 1720) return 'assets/images/flower_stage_4.png';
    if (score < 2430) return 'assets/images/flower_stage_5.png';
    return 'assets/images/flower_stage_6.png';
  }

  int _nextAffectionStage(int score) {
    for (final target in const <int>[60, 150, 550, 1720, 2430, 5000]) {
      if (score < target) return target;
    }
    return 5000;
  }

  Widget _characterAffectionBadge(String characterId, ThemeData theme) {
    final score = _characterAffinity[characterId] ?? 0;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Image.asset(_affectionAsset(score), width: 15, height: 15,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(_legacyFlowerAsset(score),
              width: 15, height: 15, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink())),
      const SizedBox(width: 2),
      Text('$score/${_nextAffectionStage(score)}',
          style: GoogleFonts.notoSerifTc(fontSize: 9,
              color: theme.colorScheme.primary.withValues(alpha: .75))),
    ]);
  }

  void _openFlowerStore() {
    if (kIsWeb) {
      _showCenterNotice('網頁版暫不支援購買花花');
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const StorePage()));
  }

  void _listenMessages(String sessionId) {
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
      final next = docs.map((d) => <String,dynamic>{'id':d.id, ...d.data()}).toList();
      setState(() {
        _messages = next;
        _hasStreamData = true;
        _error = '';
        // The server has committed this exact request. Do not show two user bubbles.
        if (_pendingRequestId != null && next.any((m) => m['id'] == _pendingRequestId)) {
          _pendingVisible = false;
        }
      });
      _scrollToLatest();
    }, onError: (Object error) {
      // The callable remains the read-only fallback if rules have not yet been deployed.
      if (mounted) _showCenterNotice('即時同步暫時不可用，仍可重新進入讀取紀錄', isError: true);
    });
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
      }
    });
  }
  // Best-effort idle summary when the user leaves the world chat.
  // The server applies minimum-turn rules and an idempotent lease.
  void _requestExitSummary() {
    if (_sessionId == null || _sending || _loading) return;
    unawaited(FirebaseFunctions.instanceFor(region: 'asia-east1')
        .httpsCallable('worldStoryMemory', options: HttpsCallableOptions(timeout: const Duration(seconds: 120)))
        .call({'worldId': widget.worldId, 'action': 'generate'})
        .then((_) {}, onError: (Object error) {
      debugPrint('World story summary deferred: $error');
    }));
  }

  @override
  void dispose() {
    _requestExitSummary();
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

  Future<void> _run(String action, {String message='', bool silent=false}) async {
    if(action=='send') {
      if(_sending || _loading)return;
      setState(() { _sending = true; _pendingFailed = false; });
      _scrollToLatest();
    }
    try {
      final result = await _api.call({
        'action':action,'worldId':widget.worldId,
        if(action=='send') 'message':message,
        if(action=='send') 'requestId':_pendingRequestId,
      });
      final data=Map<String,dynamic>.from(result.data as Map);
      if(!mounted)return;
      final npcs = <String,String>{};
      final names = <String,String>{};
      for(final raw in (data['npcs'] as List? ?? [])) {
        if(raw is! Map)continue;
        final n=Map<String,dynamic>.from(raw);
        final id=(n['id']??'').toString();
        if(id.isNotEmpty){npcs[id]=(n['avatarUrl']??'').toString();names[id]=(n['name']??'').toString();}
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
        if (rawAffinity is Map) _characterAffinity = loadedAffinity;
        _name=(data['worldName']??'開放世界').toString();
        _worldCoverImage=(data['coverImage']??'').toString();
        if (!_hasStreamData || _sessionId != sid) {
          _messages=List<dynamic>.from(data['messages'] as List? ?? []);
        }
        _npcs=npcs;_names=names;_loading=false;_error='';
      });
      if (sid.isNotEmpty) _listenMessages(sid);
      if (action == 'send') {
        // Remove optimistic bubble only once the returned result contains the saved request.
        // This works even when the Firestore listener is temporarily unavailable.
        final serverMessages = List<dynamic>.from(data['messages'] as List? ?? []);
        final confirmed = serverMessages.any((m) => m is Map && m['id'] == _pendingRequestId);
        if (confirmed) {
          setState(() {
            _pendingVisible = false;
            // Fallback when the Firestore listener has not delivered the new pair yet.
            if (!_messages.any((m) => m is Map && m['id'] == _pendingRequestId)) {
              _messages = serverMessages;
            }
          });
        }
        // The input was cleared immediately on send. Never clear text typed afterwards.
        _pendingRequestId = null;
        _pendingRequestText = null;
        _pendingFailed = false;
      }
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(mounted && _scroll.hasClients)_scroll.animateTo(_scroll.position.maxScrollExtent,
            duration:const Duration(milliseconds:260),curve:Curves.easeOut);
      });
    } on FirebaseFunctionsException catch(e) {
      if(!mounted)return;
      setState((){
        _loading=false;_error=e.message ?? '連線失敗';
        if (action == 'send') {
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
      if(!mounted)return;
      setState((){
        _loading=false;_error='網路暫時無法連線';
        if (action == 'send') {
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
    } finally {if(mounted && action=='send')setState(()=>_sending=false);}
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
    // The private-test backend still owns generation; no four-mode billing yet.
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
      _showCenterNotice('目前還沒有可以保存的對話');
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
      _showCenterNotice('目前還沒有可以保存的對話');
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
    switch (action) {
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
      case '給世界的備忘錄':
        _openWorldMemo();
        break;
      default:
        _notReady(action);
    }
  }

  Future<void> _openWorldRecords() async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldStorySummaryPage(worldId: widget.worldId, worldName: _name),
    ));
  }

  Future<void> _openWorldRelationships() async {
    final identity = await _latestTranscriptIdentity();
    if (!mounted) return;
    final names = identity['names'] as Map<String, String>;
    final avatars = identity['avatars'] as Map<String, String>;
    final cover = identity['cover'] as String;
    final persons = <WorldRelationshipEntry>[];
    for (final id in _npcs.keys) {
      persons.add(WorldRelationshipEntry(
        id: id,
        name: names[id]?.trim().isNotEmpty == true ? names[id]! : (_names[id] ?? '未命名角色'),
        avatar: avatars[id]?.trim().isNotEmpty == true ? avatars[id]! : cover,
        score: _characterAffinity[id] ?? 0,
      ));
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldChatRelationshipsPage(worldName: _name, characters: persons),
    ));
  }

  Future<void> _openWorldMemo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showCenterNotice('請先登入帳號', isError: true);
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => WorldChatMemosPage(
        worldId: widget.worldId,
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
          const ListTile(title: Text('選擇世界觀模式'),
              subtitle: Text('目前只切換畫面；AI 模型和花花扣點尚未串接')),
          for (final entry in _modes.entries)
            ListTile(
              title: Text(worldModeLabel(entry.key)),
              subtitle: Text('${entry.value} 朵花花／回覆（正式費率，尚未啟用扣點）'),
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

  Widget _toolTile(IconData icon, String title, {VoidCallback? onTap}) => InkWell(
    onTap: onTap ?? () => _notReady(title),
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
      ]),
    ),
  );

  Widget _tools() => Padding(
    padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(child: _toolTile(Icons.bookmark_outline, '收藏')),
        Expanded(child: _toolTile(Icons.auto_stories_outlined, '劇情摘要', onTap: _openWorldRecords)),
        Expanded(child: _toolTile(Icons.image_outlined, '照片')),
      ]),
      Row(children: [
        Expanded(child: _toolTile(Icons.mic_none_outlined, '錄音')),
        Expanded(child: _toolTile(Icons.folder_outlined, '拾光檔案')),
        Expanded(child: _toolTile(Icons.extension_outlined, '互動玩法')),
      ]),
      Row(children: [
        Expanded(child: _toolTile(Icons.theater_comedy_outlined, '劇場')),
        Expanded(child: _toolTile(Icons.fact_check_outlined, '狀態欄')),
        Expanded(child: _toolTile(Icons.lock_open_outlined, '秘密篇章')),
      ]),
    ]),
  );

  Widget _drawerItem(IconData icon, String label) => ListTile(
    leading: Icon(icon), title: Text(label),
    onTap: () { Navigator.pop(context); _notReady(label); },
  );

  Widget _segment(Map<String,dynamic> value,ThemeData theme) {
    final kind=(value['kind']??'').toString();
    final text=(value['text']??'').toString();
    final id=(value['npcId']??'').toString();
    final name=_names[id] ?? (value['name']??'').toString();
    final url=_npcs[id]??'';
    if(kind!='npc')return Container(
      width:double.infinity, margin:const EdgeInsets.symmetric(vertical:5),
      padding:const EdgeInsets.all(14),
      decoration:BoxDecoration(color:theme.colorScheme.surfaceContainerHighest.withValues(alpha:.65),
          borderRadius:BorderRadius.circular(16)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('世界旁白',style:TextStyle(fontSize:11,color:theme.colorScheme.primary)),
        const SizedBox(height:5),Text(text,style:const TextStyle(height:1.65)),
      ]),
    );
    return Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(
      crossAxisAlignment:CrossAxisAlignment.start,children:[
      CircleAvatar(radius:20,backgroundColor:theme.colorScheme.primaryContainer,
          backgroundImage:url.startsWith('https://')?NetworkImage(url):null,
          child:url.startsWith('https://')?null:const Icon(Icons.person_outline)),
      const SizedBox(width:10),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(child: Text(name.isEmpty?'NPC':name,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style:GoogleFonts.notoSerifTc(fontSize:12,fontWeight:FontWeight.w600))),
          if (id.isNotEmpty && _npcs.containsKey(id)) ...[
            const SizedBox(width: 5),
            _characterAffectionBadge(id, theme),
          ],
        ]),
        const SizedBox(height:4),Container(padding:const EdgeInsets.all(12),
            decoration:BoxDecoration(color:theme.colorScheme.surface,borderRadius:BorderRadius.circular(14),
                border:Border.all(color:theme.colorScheme.primary.withValues(alpha:.12))),
            child:Text(text,style:const TextStyle(height:1.6))),
      ])),
    ],
    ));
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
      child: Text(_pendingRequestText ?? '', style: const TextStyle(height: 1.55)),
    ),
  );

  // AI 回覆等待時僅顯示提示文字，不顯示頭像、Icon 或轉圈動畫。
  // 完整劇情生成完成後由訊息清單取代此提示。
  Widget _generatingBubble(ThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '世界正在悄悄運轉…',
        style: GoogleFonts.notoSerifTc(
          fontSize: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Scaffold(
      appBar: WorldChatHeader(
        worldName: _name,
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
      body:SafeArea(child:Column(children:[
        if(_loading)const Expanded(child:Center(child:CircularProgressIndicator()))
        else Expanded(child: (_messages.isEmpty && !_pendingVisible && !_sending)
            ? Center(child: Text(_error.isEmpty ? '尚無對話' : '$_error\n可返回後重試',
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
            if (data['sender'] == 'user') return Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(13),
                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .78),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(17)),
                child: Text((data['text'] ?? '').toString(),
                    style: const TextStyle(height: 1.55)),
              ),
            );
            return Column(children: [
              for (final rawSegment in (data['segments'] as List? ?? []))
                if (rawSegment is Map)
                  _segment(Map<String,dynamic>.from(rawSegment),theme),
            ]);
          },
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
          hintText: '書寫你們的故事…',
          regeneratingTooltip: '重新生成（尚未串接）',
          continueTooltip: '繼續回覆（尚未串接）',
          onChanged: _scheduleDraftSave,
          onToolbox: () => setState(() => _toolPanelOpen = !_toolPanelOpen),
          onSticker: null,
          onRegenerate: () => _notReady('重新生成'),
          onContinue: () => _notReady('繼續回覆'),
          onStop: () => _notReady('停止生成'),
          onSend: _send,
        ),
        if (_toolPanelOpen) _tools(),
      ])),
    );
  }
}
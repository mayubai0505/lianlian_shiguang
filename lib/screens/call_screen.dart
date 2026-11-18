import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'package:audioplayers/audioplayers.dart'; // ✨ 加上這個
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'call_realtime_input.dart';

// 通話介面

class CallOverlay extends StatefulWidget {
  final dynamic character;
  final String? selectedBackgroundUrl;
  final Function(int, List<Map<String, dynamic>>) onCallEnded;
  final String sessionId;
  final String characterId;
  final String selectedLanguage;
  final bool shouldSave;

  const CallOverlay({
    Key? key,
    required this.character,
    this.selectedBackgroundUrl,
    required this.onCallEnded,
    required this.sessionId,
    required this.characterId,
    required this.selectedLanguage,
    required this.shouldSave,
  }) : super(key: key);

  @override
  State<CallOverlay> createState() => _CallOverlayState();
}

// V2 Phase 2A: opt-in debug realtime capture; Phase 1 remains the default.
class _CallOverlayState extends State<CallOverlay> with WidgetsBindingObserver {
  late final stt.SpeechToText _speech;
  late AudioPlayer _audioPlayer;
  final CallRealtimeInput _realtime = CallRealtimeInput();
  bool _realtimeMode = false;
  bool get _callQualityTest => kDebugMode &&
      const bool.fromEnvironment('CALL_REALTIME_TEST') && _supportsAudioRoute;
  bool _rtStarting = false;
  int _rtStopping = 0;
  int _rtEpoch = 0;
  bool _interrupting = false;
  Future<void>? _interruptTask;
  String _heardCandidate = '';
  int _partialHits = 0;
  String _activeSpokenSentence = '';
  AudioPlayer? _configuredRealtimePlayer;
  final List<String> _deliveredSpeech = [];
  final List<String> _recentAudio = [];
  DateTime? _lastAudioAt;
  AudioPlayer? _sfxPlayer;
  final List<Map<String, String>> _callHistory = [];
  final List<Map<String, dynamic>> _inCallMessages = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final int _maxCallTime = 60;
  int _timeElapsed = 0;
  Timer? _timer;
  final Stopwatch _callClock = Stopwatch();
  final Stopwatch _listenClock = Stopwatch();
  Timer? _listenRetry;
  Timer? _recognitionEndTimer;
  bool _closing = false;
  bool _foreground = true;
  bool _turnBusy = false;
  bool _isListening = false;
  bool _listenStarting = false;
  bool _recognitionFinishing = false;
  bool _speechReady = false;
  bool _speechUnavailable = false;
  bool _isMuted = false;
  bool _speakerEnabled = true;
  bool _routeChanging = false;
  bool _isChatMode = false;
  int _recognitionId = 0;
  int _turnId = 0;
  int _recognitionErrors = 0;
  String _recognizedSpeech = '';
  String? _sttText;
  String? _callStatus;
  String _recognitionLocale = 'zh-TW';
  ImageProvider? _callBackgroundImage;
  http.Client? _streamingHttpClient;
  Completer<void>? _activePlayback;

  bool get _live => mounted && !_closing;
  bool get _supportsAudioRoute => !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  bool get _canListen => _live && _foreground && !_realtimeMode && !_turnBusy && !_isMuted &&
      !_speechUnavailable && !_routeChanging;
  bool _turnCurrent(int id) => _live && _turnId == id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _speech = stt.SpeechToText();
    _audioPlayer = AudioPlayer();
    _realtimeMode = _callQualityTest;
    globalActiveCharacterId = widget.character.id;
    _setBackground();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_live) unawaited(_startFirstGreeting());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_live) return;
    _foreground = state == AppLifecycleState.resumed;
    if (!_foreground) {
      // Short-phrase test does not capture audio in background or while app is inactive.
      unawaited(_cancelRecognition());
    } else {
      _scheduleListen();
    }
  }

  Future<void> _quiet(Future<void> Function() operation) async {
    try { await operation(); } catch (e) { debugPrint('call cleanup: $e'); }
  }

  void _finishPlaybackWait() {
    final pending = _activePlayback;
    _activePlayback = null;
    if (pending != null && !pending.isCompleted) pending.complete();
  }

  void _closeResources() {
    _turnId++;
    _recognitionId++;
    _listenRetry?.cancel();
    _recognitionEndTimer?.cancel();
    _timer?.cancel();
    _callClock.stop();
    _listenClock.stop();
    _streamingHttpClient?.close();
    _streamingHttpClient = null;
    _finishPlaybackWait();
    ++_rtEpoch;
    unawaited(_quiet(_realtime.stop));
    unawaited(_quiet(() => _speech.cancel()));
    unawaited(_quiet(() => _audioPlayer.stop()));
    final sfx = _sfxPlayer;
    if (sfx != null) unawaited(_quiet(sfx.stop));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _closing = true;
    _closeResources();
    final sfx = _sfxPlayer;
    _sfxPlayer = null;
    if (sfx != null) unawaited(_quiet(sfx.dispose));
    unawaited(_quiet(_audioPlayer.dispose));
    _chatController.dispose();
    _scrollController.dispose();
    globalActiveCharacterId = null;
    super.dispose();
  }

  // ==================== 🖼️ 背景圖片處理中樞 ====================

  Future<String?> _validateImageUrl(String? rawUrl) async {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    String targetUrl = rawUrl.trim();

    try {
      if (targetUrl.startsWith('/')) {
        targetUrl = await FirebaseStorage.instance.ref(targetUrl).getDownloadURL();
      } else if (targetUrl.startsWith('gs://')) {
        targetUrl = await FirebaseStorage.instance.refFromURL(targetUrl).getDownloadURL();
      }

      final uri = Uri.tryParse(targetUrl);
      if (uri == null || !targetUrl.startsWith('http')) return null;

      final response = await http.head(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode >= 200 && response.statusCode < 400) {
        return targetUrl;
      }
      return null;
    } catch (e) {
      debugPrint("☎️ 通畫圖片檢查失敗：$e");
      return null;
    }
  }

  void _setBackground() async {
    final bgUrl = widget.selectedBackgroundUrl;
    final avatarUrl = widget.character.avatarPath;

    Future<ImageProvider?> resolveImage(String? url) async {
      if (url == null || url.trim().isEmpty) return null;
      if (url.startsWith('http') || url.startsWith('gs://') || url.startsWith('/')) {
        final validUrl = await _validateImageUrl(url);
        if (validUrl != null) return CachedNetworkImageProvider(validUrl);
      } else if (url.startsWith('assets/')) {
        return AssetImage(url);
      }
      return null;
    }

    ImageProvider? finalProvider = await resolveImage(bgUrl);
    if (finalProvider == null) {
      finalProvider = await resolveImage(avatarUrl);
    }

    if (mounted) {
      setState(() {
        _callBackgroundImage = finalProvider;
      });
    }
  }

  // Start at the greeting response headers, as in the old call screen.
  void _startTimer() {
    if (!_live || _timer != null) return;
    _callClock.start();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!_live) return;
      final elapsed = _callClock.elapsed.inSeconds.clamp(0, _maxCallTime).toInt();
      if (elapsed != _timeElapsed) setState(() => _timeElapsed = elapsed);
      if (elapsed >= _maxCallTime) _endCallManually();
    });
  }

  void _endCallManually() {
    if (!_live) return;
    _timeElapsed = _callClock.elapsed.inSeconds.clamp(0, _maxCallTime).toInt();
    if (_callQualityTest && _turnBusy) {
      _saveDeliveredSpeech();
      _deliveredSpeech.clear();
    }
    _closing = true;
    _closeResources();
    // Parent callback retains the original call-ended / optional memory save logic.
    widget.onCallEnded(_timeElapsed,
        _inCallMessages.map((m) => Map<String, dynamic>.from(m)).toList());
  }

  Future<void> _startFirstGreeting() async {
    if (!_live) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _callStatus = l10n.call_connecting);
    _sfxPlayer = AudioPlayer();
    final sfx = _sfxPlayer!;
    unawaited(_quiet(() => sfx.play(AssetSource('audio/pickup.mp3'))));
    // Keep the original 60-second timer semantics; connection is concurrent.
    if (_realtimeMode) _scheduleListen();
    await _startCallStreamingPipeline('', isFirstGreeting: true);
  }

  Future<void> _startCallStreamingPipeline(String userText,
      {bool isFirstGreeting = false}) async {
    if (!_live || _turnBusy) return;
    final l10n = AppLocalizations.of(context)!;
    final int turn = ++_turnId;
    final bool realtimeTurn = _realtimeMode;
    final bool syncTurn = _callQualityTest;
    debugPrint('CALL_INPUT_MODE ${realtimeTurn ? "realtime" : "native"}');
    final client = http.Client();
    _streamingHttpClient = client;
    setState(() {
      _turnBusy = true;
      _sttText = null;
      _callStatus = isFirstGreeting
          ? l10n.call_connecting
          : l10n.character_thinking(widget.character.name);
    });
    // Native phrase recognition pauses during playback; the realtime test does not.
    if (!realtimeTurn) await _cancelRecognition();
    if (!_turnCurrent(turn)) { client.close(); return; }
    final priorHistory = _callHistory.map((m) => Map<String, String>.from(m)).toList();
    _deliveredSpeech.clear();
    if (syncTurn && !isFirstGreeting) _callHistory.add({'role': 'user', 'content': userText.trim()});
    Future<void> audioTail = Future<void>.value();
    String fullReplyForHistory = '';
    bool hasFoundSeparator = false;
    String audioBuffer = '';
    bool voicePlayed = false;
    int queuedSentences = 0;
    bool streamComplete = false;
    final latency = Stopwatch()..start();
    bool loggedFirstText = false;
    bool loggedFirstVoice = false;
    bool loggedFirstPlay = false;
    final spokenSegments = <String>[];
    List<String> translatedSegments = <String>[];
    String translatedTurn = '';
    final subtitleReady = Completer<void>();
    int? playingSegment;

    // Match the existing generateVoice cleanup, and never request TTS for
    // punctuation-only fragments (including split ellipses).
    String cleanSpeech(String value) => value.replaceAll(
        RegExp(r'（[\s\S]*?）|\([\s\S]*?\)|\[[\s\S]*?\]|【[\s\S]*?】|\*[\s\S]*?\*|\{[\s\S]*?\}'), '').trim();
    bool hasSpeech(String value) => value.replaceAll(
        RegExp(r'[\s。！？!?.,，、；;：:…⋯—–\-~～「」『』“”‘’（）()\[\]【】{}*#_`\"\x27|]+'), '').isNotEmpty;
    final terminals = RegExp(r'[。！？!?]+|[.]+|[\r\n]+');
    List<String> splitTranslated(String value) {
      final result = <String>[];
      int start = 0;
      for (final match in terminals.allMatches(value)) {
        // Ellipses are a pause within a sentence, not a TTS request.
        if (match.group(0)!.startsWith('.') && match.end - match.start > 1) continue;
        final part = value.substring(start, match.end).trim();
        if (hasSpeech(part)) result.add(part);
        start = match.end;
      }
      final rest = value.substring(start).trim();
      if (hasSpeech(rest)) result.add(rest);
      return result;
    }
    void showPlayingSubtitle(int index) {
      if (!_turnCurrent(turn) || !syncTurn || playingSegment != index) return;
      String line = '';
      if (streamComplete && translatedSegments.length == spokenSegments.length &&
          translatedSegments.isNotEmpty) {
        line = translatedSegments[index];
      } else if (streamComplete && index == spokenSegments.length - 1) {
        // Do not reveal later dialogue on the first audio segment.
        line = translatedTurn;
      }
      setState(() => _sttText = line.isEmpty ? null : line);
    }
    void trace(String stage) {
      if (syncTurn) debugPrint('CALL_LATENCY turn=$turn stage=$stage ms=${latency.elapsedMilliseconds}');
    }
    String promptText = userText.trim();

    void queueSentence(String sentence) {
      final text = syncTurn ? cleanSpeech(sentence) : sentence.trim();
      if (text.isEmpty || !_turnCurrent(turn)) return;
      if (syncTurn && !hasSpeech(text)) {
        debugPrint('CALL_TTS_SKIPPED_PUNCTUATION');
        return;
      }
      final segmentIndex = spokenSegments.length;
      spokenSegments.add(text);
      if (syncTurn && kDebugMode && const bool.fromEnvironment('CALL_TTS_TRACE')) {
        debugPrint('CALL_TTS_TEXT turn=$turn segment=$segmentIndex text=${jsonEncode(text)}');
      }
      // Start TTS as soon as a complete sentence is available. Await in source
      // order, not network completion order. Errors are handled inside fetch.
      queuedSentences++;
      if (queuedSentences == 1) trace('tts_request');
      final voice = _fetchSentenceVoice(text, client, turn);
      audioTail = audioTail.then((_) async {
        final url = await voice;
        if (url == null || !_turnCurrent(turn)) return;
        if (!loggedFirstVoice) {
          loggedFirstVoice = true;
          trace('first_audio_url_ready');
        }
        if (!voicePlayed) {
          final sfx = _sfxPlayer;
          if (sfx != null) await _quiet(sfx.stop);
        }
        if (!_turnCurrent(turn)) return;
        // Keep subtitles in TW for every selected voice language. TTS is
        // fetched in parallel; wait only if translation has not arrived yet.
        if (syncTurn && !subtitleReady.isCompleted) {
          trace('subtitle_wait');
          await subtitleReady.future;
        }
        if (!_turnCurrent(turn)) return;
        _activeSpokenSentence = text;
        _recentAudio.add(text);
        if (_recentAudio.length > 3) _recentAudio.removeAt(0);
        _lastAudioAt = DateTime.now();
        final played = await _playSentence(url, turn, onStarted: () {
          if (syncTurn) {
            playingSegment = segmentIndex;
            showPlayingSubtitle(segmentIndex);
          }
          if (!loggedFirstPlay) {
            loggedFirstPlay = true;
            trace('first_play_accepted');
          }
        });
        if (_turnCurrent(turn)) {
          if (syncTurn) playingSegment = null;
          _activeSpokenSentence = '';
          _lastAudioAt = DateTime.now();
          if (played) _deliveredSpeech.add(text);
        }
        voicePlayed = voicePlayed || played;
      }).catchError((Object e) { debugPrint('call voice queue: $e'); });
    }

    void flushSentences({bool force = false}) {
      // Do not split every comma: complete sentences retain natural prosody.
      final punctuation = syncTurn ? terminals : RegExp(r'[。！？.!?\n]');
      while (true) {
        Match? boundary;
        for (final match in punctuation.allMatches(audioBuffer)) {
          if (syncTurn && match.group(0)!.startsWith('.')) {
            // A dot at a chunk boundary may be the beginning of an ellipsis.
            if (!force && match.end == audioBuffer.length) break;
            if (match.end - match.start > 1) continue;
          }
          boundary = match;
          break;
        }
        if (boundary == null) break;
        final end = boundary.end;
        queueSentence(audioBuffer.substring(0, end));
        audioBuffer = audioBuffer.substring(end);
      }
      if (force && audioBuffer.trim().isNotEmpty) queueSentence(audioBuffer);
      if (force) audioBuffer = '';
    }

    try {
      if (!_turnCurrent(turn)) return;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw StateError('call authentication required');
      final idToken = await currentUser.getIdToken();
      if (!_turnCurrent(turn)) return;
      // 🧠 終極洗腦口語化 Prompt 系統
      String callOverridePrompt = """
【通話模式最高準則】
你現在正與玩家進行「實時語音通話」。請完全沉浸於角色設定 [characterProfile] 中，並嚴格遵守以下對話規範：

1. 【絕對口語與極短】：每句話嚴格控制在 10~25 個字以內！絕對禁止長篇大論、禁止像在寫作文。像真人講電話一樣，一次只說一兩句就停頓。
2. 【消除機器人感（關鍵）】：請在句子中自然加入人類講電話的習慣與語氣。適當加入短暫的停頓「...」、或微弱的口語猶豫詞（如：呃、那個、唔...）。這對語音生成表現力至關重要。
3. 【語氣與人設】：完全遵守 [toneAndStyle]。
   - 如果人設高冷，禁止使用任何語尾助動詞，語氣簡短冰冷，以「。」結尾。
   - 如果人設溫柔或陽光，請自然使用助詞（如：啦、喔、呢），多用「？」結尾來引導語音引擎產生自然的尾音上揚。
4. 【格式規範】：絕對禁止輸出任何表情符號（如 😊, 😭）。
""";

      callOverridePrompt += """
\n⚠️ 【語言強制覆寫】：
玩家目前選擇的對話語言是：「${widget.selectedLanguage}」。
請你「完全且只使用」${widget.selectedLanguage} 來思考與回答。
即使玩家用中文跟你說話，你也必須用 ${widget.selectedLanguage} 回應，並維持角色個性。
\n⚠️ 【雙語字幕模式（極度重要）】：
語音必須使用：「${widget.selectedLanguage}」。
字幕必須一律使用「台灣繁體中文（zh-TW）」，不受玩家語音、輸入語言、角色背景或語音語言影響。禁止簡體中文字及中國大陸用語；即使輸入是簡體中文，也要以台灣繁體中文提供字幕。
你的回覆「必須」同時包含這兩種語言，並嚴格使用「|」符號隔開！
格式：[${widget.selectedLanguage}語音台詞] | [台灣繁體中文字幕]
絕對禁止破壞此格式，且不要加任何多餘的說明。
""";

      if (syncTurn) {
        callOverridePrompt += "\n【即時語音輸出補充】只輸出真正要說出口的台詞與繁中翻譯；不要輸出括號、方括號、角色名、格式標籤、舞台動作、音效文字或結尾標記。只使用一個半形 | 分隔；兩側句數、順序及句末標點對齊。用逗號或自然語氣表達停頓。";
      }
      if (isFirstGreeting) {
        promptText = '（玩家從目前的文字聊天室撥來電話，角色接起電話。）';
        callOverridePrompt += "\n【通話開場】自然接聽，承接同一聊天室最新已發生的劇情和角色當前行為、地點、情緒。若場景未知，保持未知，不得亂編。不要強迫每次以固定招呼語開場。";
      }

      final request = http.Request(
        'POST',
        Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/directCallAiStream'),
      );
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $idToken';
      request.body = jsonEncode({
        "userMessage": promptText,
        "history": priorHistory,
        "chatMode": "call",
        "memoryScopeVersion": 2,
        "sessionId": widget.sessionId,
        "characterId": widget.characterId,
        "overrideSystemPrompt": callOverridePrompt,
        "characterProfile": {
          "name": widget.character.name,
          "toneAndStyle": widget.character.toneAndStyle?.replaceAll('{{玩家名字}}', '玩家') ?? "",
          "background": widget.character.background?.replaceAll('{{玩家名字}}', '玩家') ?? "",
          "detailedPersonality": widget.character.detailedPersonality?.replaceAll('{{玩家名字}}', '玩家') ?? "",
        },
      });

      final response = await client.send(request).timeout(const Duration(seconds: 20));
      if (!_turnCurrent(turn)) return;
      if (isFirstGreeting) _startTimer();
      if (response.statusCode != 200) {
        throw StateError('call stream HTTP ${response.statusCode}');
      }
      await for (final textChunk in response.stream
          .transform(utf8.decoder).timeout(const Duration(seconds: 20))) {
        if (!_turnCurrent(turn)) break;
        if (!loggedFirstText && textChunk.trim().isNotEmpty) {
          loggedFirstText = true;
          trace('first_ai_text');
        }
        fullReplyForHistory += textChunk;
        final pipe = fullReplyForHistory.indexOf('|');
        if (!syncTurn) {
          if (pipe >= 0) {
            setState(() => _sttText = fullReplyForHistory.substring(pipe + 1).trim());
          } else if (fullReplyForHistory.length > 50) {
            setState(() => _sttText = fullReplyForHistory.trim());
          }
        }
        if (!hasFoundSeparator) {
          final i = textChunk.indexOf('|');
          if (i >= 0) {
            hasFoundSeparator = true;
            audioBuffer += textChunk.substring(0, i);
            flushSentences(force: true);
          } else {
            audioBuffer += textChunk;
            flushSentences();
          }
        }
      }
      if (!_turnCurrent(turn)) return;
      if (fullReplyForHistory.trim().isEmpty) throw StateError('empty call reply');
      flushSentences(force: true);
      streamComplete = true;
      // Phase 1 retains its original subtitle/history behavior.
      if (!syncTurn) {
        if (!isFirstGreeting) _callHistory.add({'role': 'user', 'content': promptText});
        _callHistory.add({'role': 'assistant', 'content': fullReplyForHistory});
      }
      final pipe = fullReplyForHistory.indexOf('|');
      final subtitle = (pipe >= 0
          ? fullReplyForHistory.substring(pipe + 1)
          : fullReplyForHistory).trim();
      if (syncTurn) {
        // The source side is not a TW translation if the required pipe is absent.
        translatedTurn = pipe >= 0 ? subtitle : '';
        translatedSegments = splitTranslated(translatedTurn);
        if (!subtitleReady.isCompleted) subtitleReady.complete();
        final index = playingSegment;
        if (index != null) showPlayingSubtitle(index);
      } else if (_turnCurrent(turn) && subtitle.isNotEmpty) {
        setState(() {
          _sttText = subtitle;
          _inCallMessages.add({'isMe': false, 'isSystem': false, 'text': subtitle});
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('call text stream failed: $e');
      if (_turnCurrent(turn)) {
        setState(() => _callStatus = l10n.bad_signal);
      }
    } finally {
      // Keep the turn locked until all sentence audio has finished. On hangup,
      // both the HTTP client and playback wait are released immediately.
      if (!subtitleReady.isCompleted) subtitleReady.complete();
      if (isFirstGreeting && _turnCurrent(turn)) _startTimer();
      if (_turnCurrent(turn)) {
        await audioTail;
        final sfx = _sfxPlayer;
        if (sfx != null) await _quiet(sfx.stop);
      }
      client.close();
      if (identical(_streamingHttpClient, client)) _streamingHttpClient = null;
      if (_turnCurrent(turn)) {
        if (syncTurn && streamComplete && voicePlayed && _deliveredSpeech.length == queuedSentences) {
          _callHistory.add({'role': 'assistant', 'content': fullReplyForHistory});
          final pipe = fullReplyForHistory.indexOf('|');
          final subtitle = (pipe >= 0 ? fullReplyForHistory.substring(pipe + 1) : fullReplyForHistory).trim();
          if (subtitle.isNotEmpty) _inCallMessages.add({'isMe': false, 'isSystem': false, 'text': subtitle});
        } else if (syncTurn) {
          _saveDeliveredSpeech();
        }
        _deliveredSpeech.clear();
        _activeSpokenSentence = '';
        setState(() {
          _turnBusy = false;
          if (syncTurn) _sttText = null;
          if (!streamComplete || !voicePlayed) _callStatus = l10n.bad_signal;
          else _callStatus = _isMuted ? l10n.silence : l10n.call_listening_auto_send;
        });
        _scrollToBottom();
        _scheduleListen();
      }
    }
  }

  Future<String?> _fetchSentenceVoice(String sentence, http.Client client, int turn) async {
    if (!_turnCurrent(turn)) return null;
    final voiceId = widget.character.voiceId?.toString().trim() ?? '';
    if (voiceId.isEmpty) return null;
    final stability = (widget.character.voiceStability as num?)?.toDouble() ?? 0.40;
    final style = (widget.character.voiceStyle as num?)?.toDouble() ?? 0.75;
    final callStability = _callQualityTest ? stability.clamp(0.60, 1.0).toDouble() : stability;
    final callStyle = _callQualityTest ? style.clamp(0.0, 0.15).toDouble() : style;
    if (_callQualityTest) debugPrint('CALL_VOICE_SETTINGS stability=$callStability style=$callStyle');
    try {
      // Existing voice generation API and creator settings are intentionally
      // unchanged in Phase 1. A new authenticated streaming endpoint is next.
      final response = await client.post(
        Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/generateVoice'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': sentence,
          'voiceId': voiceId,
          'stability': callStability,
          'style': callStyle,
        }),
      ).timeout(const Duration(seconds: 18));
      if (!_turnCurrent(turn) || response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      final url = data is Map ? data['audioUrl'] : null;
      return url is String && url.isNotEmpty ? url : null;
    } catch (e) {
      debugPrint('call TTS failed: $e');
      return null;
    }
  }

  Future<bool> _playSentence(String url, int turn, {void Function()? onStarted}) async {
    if (!_turnCurrent(turn)) return false;
    final completed = Completer<void>();
    _activePlayback = completed;
    bool success = false;
    bool started = false;
    final player = _audioPlayer;
    final positionSub = _callQualityTest ? player.onPositionChanged.listen((position) {
      if (!started && position > Duration.zero && _turnCurrent(turn)) {
        started = true;
        debugPrint('CALL_AUDIO_POSITION_STARTED turn=$turn');
        onStarted?.call();
      }
    }) : null;
    final sub = player.onPlayerComplete.listen((_) {
      success = true;
      if (!completed.isCompleted) completed.complete();
    });
    try {
      try { await _applyAudioRoute(player); } catch (e) { debugPrint('call default audio route: $e'); }
      if (!_turnCurrent(turn)) return false;
      await player.play(UrlSource(url)).timeout(const Duration(seconds: 8));
      if (!_turnCurrent(turn)) {
        await _quiet(player.stop);
        return false;
      }
      if (!_callQualityTest) onStarted?.call();
      await completed.future.timeout(const Duration(seconds: 25));
      return success && _turnCurrent(turn);
    } catch (e) {
      debugPrint('call playback failed: $e');
      if (_turnCurrent(turn)) await _quiet(player.stop);
      return false;
    } finally {
      await positionSub?.cancel();
      await sub.cancel();
      if (identical(_activePlayback, completed)) _activePlayback = null;
    }
  }

  Future<void> _applyAudioRoute([AudioPlayer? target]) async {
    if (!_supportsAudioRoute) return;
    final player = target ?? _audioPlayer;
    if (_realtimeMode) {
      if (identical(_configuredRealtimePlayer, player)) return;
      await player.setAudioContext(AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: _speakerEnabled,
          audioMode: AndroidAudioMode.inCommunication,
          contentType: AndroidContentType.speech,
          usageType: AndroidUsageType.voiceCommunication,
          audioFocus: AndroidAudioFocus.none,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playAndRecord,
          options: {AVAudioSessionOptions.allowBluetooth,
            if (_speakerEnabled) AVAudioSessionOptions.defaultToSpeaker},
        ),
      ));
      if (identical(player, _audioPlayer)) _configuredRealtimePlayer = player;
      return;
    }
    await player.setAudioContext(AudioContextConfig(
      route: _speakerEnabled ? AudioContextConfigRoute.speaker : AudioContextConfigRoute.earpiece,
    ).build());
  }

  Future<void> _toggleSpeaker() async {
    if (!_live || _routeChanging) return;
    if (!_supportsAudioRoute) return;
    final old = _speakerEnabled;
    setState(() {
      _routeChanging = true;
      _speakerEnabled = !old;
      _configuredRealtimePlayer = null;
    });
    // Don't reconfigure the playback audio session while native STT owns it.
    await _cancelRecognition();
    try { if (_live) await _applyAudioRoute(); }
    catch (e) {
      debugPrint('call audio route failed: $e');
      if (_live) setState(() => _speakerEnabled = old);
    } finally {
      if (_live) {
        setState(() => _routeChanging = false);
        _scheduleListen();
      }
    }
  }

  Future<void> _toggleMute() async {
    if (!_live) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isMuted = !_isMuted;
      if (!_turnBusy) _callStatus = _isMuted ? l10n.silence : l10n.call_listening_auto_send;
      if (!_isMuted) {
        _speechUnavailable = false;
        _recognitionErrors = 0;
      }
    });
    if (_isMuted) await _cancelRecognition();
    if (_live && !_isMuted) _scheduleListen();
  }

  Future<void> _cancelRecognition() async {
    ++_rtEpoch;
    _heardCandidate = '';
    _partialHits = 0;
    final stopRealtime = _realtimeMode || _rtStarting;
    if (stopRealtime) _rtStopping++;
    _pendingRealtimeText.clear();
    _recognitionId++;
    _listenRetry?.cancel();
    _recognitionEndTimer?.cancel();
    _listenClock.stop();
    if (_live) setState(() {
      _isListening = false;
      _recognizedSpeech = '';
    });
    else _isListening = false;
    if (stopRealtime) {
      try { await _quiet(_realtime.stop); }
      finally { _rtStopping--; }
    }
    if (_speechReady) await _quiet(() => _speech.cancel());
    if (stopRealtime && _live) _scheduleListen();
  }

  void _scheduleListen([Duration delay = const Duration(milliseconds: 450)]) {
    _listenRetry?.cancel();
    if (_realtimeMode) {
      if (_live && _foreground && !_isMuted && !_routeChanging && !_isListening && !_rtStarting && _rtStopping == 0) {
        _listenRetry = Timer(delay, () => unawaited(_startRealtimeListening()));
      }
      return;
    }
    if (!_canListen || _isListening || _listenStarting || _recognitionFinishing) return;
    _listenRetry = Timer(delay, () {
      if (_canListen) unawaited(_startAutoListening());
    });
  }

  bool get _canRealtime => _realtimeMode && _live && _foreground && !_isMuted && !_routeChanging;

  Future<void> _startRealtimeListening() async {
    if (!_canRealtime || _isListening || _rtStarting || _rtStopping != 0) return;
    final epoch = ++_rtEpoch;
    _rtStarting = true;
    try {
      await _applyAudioRoute();
      if (!_canRealtime || epoch != _rtEpoch) return;
      await _realtime.start(
        sessionId: widget.sessionId,
        characterId: widget.characterId,
        speaker: _speakerEnabled,
        onPartial: (text) { if (epoch == _rtEpoch) _onRealtimePartial(text); },
        onCommitted: (text) { if (epoch == _rtEpoch) unawaited(_onRealtimeCommitted(text)); },
        onDisconnected: () { if (epoch == _rtEpoch) unawaited(_fallbackRealtime()); },
      );
      if (!_canRealtime || epoch != _rtEpoch) return;
      setState(() {
        _isListening = true;
        if (!_turnBusy) _callStatus = AppLocalizations.of(context)!.call_listening_auto_send;
      });
      debugPrint('CALL_REALTIME_CONNECTED');
    } catch (e) {
      debugPrint('CALL_REALTIME_START_FAILED type=${e.runtimeType}');
      if (_live && epoch == _rtEpoch) await _fallbackRealtime();
    } finally {
      _rtStarting = false;
      if (_live && !_isListening) _scheduleListen();
    }
  }

  Future<void> _fallbackRealtime() async {
    if (!_realtimeMode) return;
    debugPrint('CALL_REALTIME_FALLBACK_NATIVE');
    ++_rtEpoch;
    _rtStopping++;
    try { await _quiet(_realtime.stop); } finally { _rtStopping--; }
    if (!_live) return;
    setState(() {
      _realtimeMode = false;
      _isListening = false;
      _recognizedSpeech = '';
      _heardCandidate = '';
      _partialHits = 0;
    });
    _configuredRealtimePlayer = null;
    _scheduleListen();
  }

  String _normalizedSpeech(String text) => text.toLowerCase().replaceAll(RegExp(r'[\s\p{P}\p{S}]', unicode: true), '');

  bool _looksLikePlayback(String text) {
    final last = _lastAudioAt;
    final active = _activeSpokenSentence;
    if (active.isEmpty && (last == null || DateTime.now().difference(last).inMilliseconds > 300)) return false;
    final candidate = _normalizedSpeech(text);
    if (candidate.length < 4) return false;
    final spoken = _normalizedSpeech(active.isNotEmpty ? active : (_recentAudio.isEmpty ? '' : _recentAudio.last));
    return spoken.contains(candidate) || (spoken.length >= 4 && candidate.contains(spoken));
  }

  bool _crediblePartial(String text) {
    final normalized = _normalizedSpeech(text);
    // Very short fillers/noises cannot interrupt; final short commands still work.
    final cjk = RegExp(r'[\u3400-\u9fff\u3040-\u30ff\uac00-\ud7af]').hasMatch(normalized);
    return normalized.length >= (cjk ? 3 : 6) && !_looksLikePlayback(text);
  }

  void _onRealtimePartial(String text) {
    if (!_canRealtime || !_isListening || text.isEmpty) return;
    if (_looksLikePlayback(text)) return;
    setState(() => _recognizedSpeech = text);
    if (!_turnBusy || _interrupting || !_crediblePartial(text)) return;
    final normalized = _normalizedSpeech(text);
    if (normalized == _heardCandidate) return;
    if (_heardCandidate.isNotEmpty && (normalized.startsWith(_heardCandidate) || _heardCandidate.startsWith(normalized))) {
      _partialHits++;
    } else {
      _partialHits = 1;
    }
    _heardCandidate = normalized;
    // A clear phrase can interrupt on its first partial. Short/ambiguous
    // fragments still need two consistent updates; never use PCM loudness alone.
    final cjk = RegExp(r'[\u3400-\u9fff\u3040-\u30ff\uac00-\ud7af]').hasMatch(normalized);
    final clearPhrase = normalized.length >= (cjk ? 4 : 9) ||
        const {'等一下', '等一等', '先等等', '先停下', '等等等', 'holdon', 'waitwait'}.contains(normalized);
    if (clearPhrase || _partialHits >= 2) {
      debugPrint('CALL_LATENCY stage=partial_interrupt');
      unawaited(_interruptCurrentTurn());
    }
  }

  Future<void> _onRealtimeCommitted(String text) async {
    if (!_canRealtime || !_isListening || text.trim().isEmpty) return;
    final echo = _looksLikePlayback(text);
    setState(() => _recognizedSpeech = '');
    _heardCandidate = '';
    _partialHits = 0;
    if (echo) {
      debugPrint('CALL_STT_ECHO_DROPPED');
      return;
    }
    debugPrint('CALL_LATENCY stage=stt_commit');
    _pendingRealtimeText.add(text.trim());
    if (_drainingRealtime) return;
    _drainingRealtime = true;
    try {
      while (_pendingRealtimeText.isNotEmpty && _canRealtime) {
        if (_turnBusy || _interruptTask != null) await _interruptCurrentTurn();
        if (!_canRealtime) break;
        final combined = _pendingRealtimeText.join(' ');
        _pendingRealtimeText.clear();
        // Do not await the whole AI turn here; new speech can interrupt it.
        unawaited(_submitPlayerText(combined));
      }
    } finally {
      _drainingRealtime = false;
      if (!_canRealtime) _pendingRealtimeText.clear();
    }
  }

  final List<String> _pendingRealtimeText = [];
  bool _drainingRealtime = false;

  void _saveDeliveredSpeech() {
    if (_deliveredSpeech.isEmpty) return;
    final spoken = _deliveredSpeech.join(' ').trim();
    if (spoken.isEmpty) return;
    _callHistory.add({'role': 'assistant', 'content': spoken});
    _inCallMessages.add({'isMe': false, 'isSystem': false, 'text': spoken});
  }

  Future<void> _interruptCurrentTurn() {
    final active = _interruptTask;
    if (active != null) return active;
    if (!_live || !_turnBusy) return Future<void>.value();
    _interrupting = true;
    final stopLatency = Stopwatch()..start();
    _startTimer();
    ++_turnId;
    _streamingHttpClient?.close();
    _streamingHttpClient = null;
    _finishPlaybackWait();
    _saveDeliveredSpeech();
    _deliveredSpeech.clear();
    _activeSpokenSentence = '';
    _lastAudioAt = DateTime.now();
    // A late native play() callback may still resolve, so isolate the old player.
    // Do not dispose the replacement or stop its audio from the old turn.
    final old = _audioPlayer;
    _audioPlayer = AudioPlayer();
    _configuredRealtimePlayer = null;
    setState(() {
      _turnBusy = false;
      _sttText = null;
      _callStatus = AppLocalizations.of(context)!.call_listening_auto_send;
    });
    final task = () async {
      await _quiet(old.stop);
      debugPrint('CALL_LATENCY stage=stop_returned ms=${stopLatency.elapsedMilliseconds}');
      await _quiet(old.dispose);
      if (_live) {
        final sfx = _sfxPlayer;
        if (sfx != null) await _quiet(sfx.stop);
      }
      debugPrint('CALL_REALTIME_INTERRUPTED');
    }();
    _interruptTask = task;
    return task.whenComplete(() {
      if (identical(_interruptTask, task)) {
        _interruptTask = null;
        _interrupting = false;
      }
    });
  }

  Future<bool> _ensureSpeechReady() async {
    if (_speechReady) return true;
    if (!_live) return false;
    final permission = await Permission.microphone.request();
    if (!_live) return false;
    if (!permission.isGranted) {
      setState(() {
        _speechUnavailable = true;
        _callStatus = AppLocalizations.of(context)!.chatPageMicrophonePermissionRequired;
      });
      return false;
    }
    final ready = await _speech.initialize(
      onStatus: (status) {
        if (!_live || !_isListening || _recognitionFinishing) return;
        // 'notListening' can arrive BEFORE the final transcript. Wait for
        // 'done' or a short grace period; never submit a UI placeholder.
        if (status == 'done' || status == 'notListening') {
          final id = _recognitionId;
          _recognitionEndTimer?.cancel();
          _recognitionEndTimer = Timer(
            Duration(milliseconds: status == 'done' ? 180 : 1200),
            () => unawaited(_finishRecognition(id)),
          );
        }
      },
      onError: (error) {
        if (!_live || !_isListening || _recognitionFinishing) return;
        final msg = error.errorMsg.toLowerCase();
        final noSpeech = msg.contains('no_match') || msg.contains('speech_timeout');
        if (!noSpeech) _recognitionErrors++;
        if ((!noSpeech && error.permanent) || _recognitionErrors >= 3) {
          _speechUnavailable = true;
        }
        final id = _recognitionId;
        _recognitionEndTimer?.cancel();
        _recognitionEndTimer = Timer(const Duration(milliseconds: 500),
            () => unawaited(_finishRecognition(id, discard: !noSpeech)));
      },
    );
    if (!ready || !_live) return false;
    _speechReady = true;
    try {
      final locales = await _speech.locales();
      for (final locale in locales) {
        if (locale.localeId.replaceAll('_', '-').toLowerCase() == 'zh-tw') {
          _recognitionLocale = locale.localeId;
          break;
        }
      }
    } catch (e) { debugPrint('call STT locales: $e'); }
    return true;
  }

  Future<void> _startAutoListening() async {
    if (!_canListen || _isListening || _listenStarting || _recognitionFinishing) return;
    _listenStarting = true;
    final l10n = AppLocalizations.of(context)!;
    final id = ++_recognitionId;
    try {
      final ready = await _ensureSpeechReady();
      if (!_canListen || id != _recognitionId) return;
      if (!ready) {
        if (_speechUnavailable) return;
        setState(() {
          _speechUnavailable = true;
          _callStatus = l10n.bad_signal;
        });
        return;
      }
      setState(() {
        _isListening = true;
        _recognizedSpeech = '';
        _callStatus = l10n.call_listening_auto_send;
      });
      _listenClock.reset();
      _listenClock.start();
      await _speech.listen(
        onResult: (result) {
          if (!_live || !_isListening || id != _recognitionId || _recognitionFinishing) return;
          // Keep an earlier nonempty partial if platform's final result is blank.
          if (result.recognizedWords.trim().isNotEmpty) {
            setState(() => _recognizedSpeech = result.recognizedWords.trim());
            _recognitionErrors = 0;
          }
          if (result.finalResult) {
            _recognitionEndTimer?.cancel();
            _recognitionEndTimer = Timer(const Duration(milliseconds: 180),
                () => unawaited(_finishRecognition(id)));
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: _recognitionLocale,
          partialResults: true,
          listenMode: stt.ListenMode.dictation,
          pauseFor: const Duration(seconds: 2),
          listenFor: const Duration(seconds: 20),
        ),
      );
      if (!_canListen || id != _recognitionId) {
        if (_speechReady) await _quiet(() => _speech.cancel());
        return;
      }
      // Some devices fail to start without sending an onError event.
      if (!_speech.isListening && _isListening && _recognitionEndTimer?.isActive != true) {
        _recognitionEndTimer = Timer(const Duration(milliseconds: 1200),
            () => unawaited(_finishRecognition(id)));
      }
    } catch (e) {
      debugPrint('call STT start: $e');
      if (_live && id == _recognitionId) {
        _recognitionErrors++;
        setState(() {
          _isListening = false;
          _speechUnavailable = _recognitionErrors >= 3;
          _callStatus = l10n.bad_signal;
        });
      }
    } finally {
      _listenStarting = false;
      if (_canListen && !_isListening && !_recognitionFinishing) {
        _scheduleListen(const Duration(seconds: 1));
      }
    }
  }

  Future<void> _finishRecognition(int id, {bool discard = false}) async {
    if (!_live || !_isListening || _recognitionFinishing || id != _recognitionId) return;
    _recognitionFinishing = true;
    _recognitionEndTimer?.cancel();
    final text = discard ? '' : _recognizedSpeech.trim();
    final quickEmpty = text.isEmpty && _listenClock.elapsedMilliseconds < 350;
    _listenClock.stop();
    setState(() {
      _isListening = false;
      _recognizedSpeech = '';
    });
    await _quiet(() => _speech.stop());
    _recognitionFinishing = false;
    if (!_live || id != _recognitionId) {
      _scheduleListen();
      return;
    }
    if (_canListen && text.isNotEmpty) {
      await _submitPlayerText(text);
      return;
    }
    if (quickEmpty) _recognitionErrors++;
    if (_recognitionErrors >= 3) {
      setState(() {
        _speechUnavailable = true;
        _callStatus = AppLocalizations.of(context)!.bad_signal;
      });
    }
    _scheduleListen(const Duration(milliseconds: 850));
  }

  Future<void> _submitPlayerText(String text) async {
    if (!_live || _turnBusy || text.trim().isEmpty) return;
    setState(() {
      _inCallMessages.add({'isMe': true, 'isSystem': false, 'text': text.trim()});
    });
    _scrollToBottom();
    await _startCallStreamingPipeline(text.trim());
  }

  Future<void> _sendMessage() async {
    if (!_live || _turnBusy || _recognitionFinishing || _interruptTask != null) return;
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    _chatController.clear();
    await _submitPlayerText(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_live && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ==================== 🎨 畫面 UI 渲染中樞 ====================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _endCallManually();
      },
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 底圖或高質感深灰色過場
          _callBackgroundImage != null
              ? Image(image: _callBackgroundImage!, fit: BoxFit.cover)
              : Container(color: const Color(0xFF1E1E1E)),

          // 2. 絲滑毛玻璃濾鏡
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),

          // 3. 根據模式切換 UI
          if (!_isChatMode) _buildCallUI(context) else _buildInCallChatUI(context),
        ],
      ),
      ),
    );
  }

  Widget _buildCallUI(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    String minutesStr = (_timeElapsed / 60).floor().toString().padLeft(2, '0');
    String secondsStr = (_timeElapsed % 60).toString().padLeft(2, '0');

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black45,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                image: _callBackgroundImage != null
                    ? DecorationImage(image: _callBackgroundImage!, fit: BoxFit.cover)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.character.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('$minutesStr:$secondsStr', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 20, letterSpacing: 2)),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Text(_callStatus ?? l10n.call_connecting,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    if ((_sttText ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(_sttText!, textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                    if (_recognizedSpeech.isNotEmpty && _isListening) ...[
                      const SizedBox(height: 8),
                      Text(_recognizedSpeech, textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.primaryContainer, fontSize: 15)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildControlButton(icon: Icons.chat_bubble_rounded, color: Colors.white.withValues(alpha: 0.2), onTap: () => setState(() => _isChatMode = true)),
                  if (_supportsAudioRoute) _buildControlButton(
                    icon: _speakerEnabled ? Icons.volume_up_rounded : Icons.hearing_rounded,
                    color: Colors.white.withValues(alpha: 0.2),
                    onTap: _toggleSpeaker,
                  ),
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: _isMuted ? Colors.white.withValues(alpha: 0.2) : theme.colorScheme.primary,
                    onTap: _toggleMute,
                  ),
                  _buildControlButton(icon: Icons.call_end, color: Colors.redAccent, onTap: _endCallManually),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInCallChatUI(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    String minutesStr = (_timeElapsed / 60).floor().toString().padLeft(2, '0');
    String secondsStr = (_timeElapsed % 60).toString().padLeft(2, '0');

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                  onPressed: () {
                    // 先解除輸入焦點並收起系統鍵盤，再回到通話介面。
                    FocusManager.instance.primaryFocus?.unfocus();
                    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
                    setState(() => _isChatMode = false);
                  },
                ),
                CircleAvatar(radius: 20, backgroundColor: Colors.black45, backgroundImage: _callBackgroundImage),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.character.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('$minutesStr:$secondsStr', style: const TextStyle(color: Colors.greenAccent, fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(_isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      color: _isMuted ? Colors.white54 : Colors.white),
                  onPressed: _toggleMute,
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.redAccent),
                  onPressed: _endCallManually,
                )
              ],
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _inCallMessages.length,
              itemBuilder: (context, index) {
                final msg = _inCallMessages[index];
                if (msg['isSystem'] == true) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: Text(msg['text'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                  );
                }
                bool isMe = msg['isMe'] == true;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg['text'], style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.type_message_hint,
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Image.asset(
                    'assets/images/chat/chat_send_plane_mask.webp',
                    width: 38,
                    height: 38,
                    color: theme.colorScheme.primary,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  onPressed: _turnBusy ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
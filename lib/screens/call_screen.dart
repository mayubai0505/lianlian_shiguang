import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:audioplayers/audioplayers.dart'; // ✨ 加上這個
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';


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

class _CallOverlayState extends State<CallOverlay> {
  StreamSubscription<QuerySnapshot>? _replySubscription;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String? _sttText;

  List<Map<String, String>> _callHistory = [];
  late AudioPlayer _audioPlayer;
  AudioPlayer? _sfxPlayer; // 🌟 新增這行：把音效播放器抓在手上管！
  int _timeElapsed = 0;
  final int _maxCallTime = 60;
  Timer? _timer;
  bool _isPlayerInitialized = false;

  // 🌟 串流與音訊排隊專用變數
  final List<String> _audioPlaybackQueue = []; // 音訊網址排隊長龍
  bool _isAudioQueuePlaying = false;           // 檢查目前是不是正在播佇列音訊
  String _streamTextBuffer = "";               // 文字碎布緩衝區
  http.Client? _streamingHttpClient;           // 方便隨時中斷的 HTTP 客戶端

  ImageProvider? _callBackgroundImage;
  bool _isChatMode = false;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _inCallMessages = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initAudioPlayer();
    globalActiveCharacterId = widget.character.id;
    _setBackground();

    Future.microtask(() {
      if (mounted) {
        _startFirstGreeting();
        _listenToRealAIReply();
      }
    });
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    _isPlayerInitialized = true;

    // 🌟 關鍵修改：給播放器裝上「永久的耳朵」
    // 只要聽到「播完啦」，就自動去叫下一句起床
    _audioPlayer.onPlayerComplete.listen((_) {
      debugPrint("🎵 單句播放完畢，準備播放下一句");
      _playNextInQueue();
    });

    debugPrint("✅ AudioPlayer 換心成功！");
  }

  @override
  void dispose() {
    _streamingHttpClient?.close();
    _timer?.cancel();
    _chatController.dispose();
    _scrollController.dispose();
    _audioPlayer.stop();
    _sfxPlayer?.stop();     // 🛑 確保釋放音效
    _sfxPlayer?.dispose();  // 🛑 確保釋放音效
    if (_isPlayerInitialized) {
      _audioPlayer.dispose();
      _isPlayerInitialized = false;
    }
    globalActiveCharacterId = null;
    _replySubscription?.cancel();
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

  // ==================== ⏱️ 通話計時器中樞 ====================

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeElapsed < _maxCallTime) {
        if (mounted) setState(() => _timeElapsed++);
        if (_timeElapsed == 50) {
          _playGentleHangupVoice();
        }
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    final l10n = AppLocalizations.of(context)!;
    _timer?.cancel();
    if (_isListening) _speech.stop();

    setState(() {
      _inCallMessages.add({'isSystem': true, 'text': l10n.call_ended});
    });

    _scrollToBottom();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) widget.onCallEnded(_timeElapsed, _inCallMessages);
    });
  }

  void _endCallManually() {
    _timer?.cancel();
    if (_isListening) _speech.stop();
    _audioPlayer.stop();
    _sfxPlayer?.stop(); // 🛑 加上這行：掛電話的瞬間，立刻掐斷嘟嘟聲！
    _streamingHttpClient?.close();
    widget.onCallEnded(_timeElapsed, _inCallMessages);
  }

  // ==================== 🚀 核心秒回串流管線 (Streaming Pipeline) ====================

  Future<void> _startCallStreamingPipeline(String userText, {bool isFirstGreeting = false}) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final idToken = await currentUser.getIdToken();

      // 清空上一輪的殘留緩衝與排隊
      _streamTextBuffer = "";
      _audioPlaybackQueue.clear();
      _streamingHttpClient?.close();
      _streamingHttpClient = http.Client();

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
字幕必須使用：「玩家輸入的語言」（請你自動偵測玩家上一句話是用什麼語言打字的。若為開場白，字幕請預設使用繁體中文）。
你的回覆「必須」同時包含這兩種語言，並嚴格使用「|」符號隔開！
格式：[${widget.selectedLanguage}語音台詞] | [玩家輸入語言的字幕台詞]
絕對禁止破壞此格式，且不要加任何多餘的說明。
""";

      String greeting = "Wéi";
      if (widget.selectedLanguage == 'English') greeting = "Hello";
      if (widget.selectedLanguage == '日本語') greeting = "もしもし";
      if (widget.selectedLanguage == '한국어') greeting = "여보세요";
      if (widget.selectedLanguage == 'Tiếng Việt') greeting = "A lô";

      String promptText = userText.trim();

      if (isFirstGreeting) {
        // 🧠 加上判斷：檢查這是不是「真正的」第一次通話
        if (_callHistory.isEmpty) {
          // 情況 A：完全沒有歷史紀錄（真的是第一通電話）
          promptText = "（玩家剛剛接起了你的電話）";
          callOverridePrompt += "\n👉 【特別：開場指令】：必須嚴格遵守以下開場格式：\n$greeting？ + [${widget.selectedLanguage}正文] | 喂？ + [繁體中文正文]";
        } else {
          // 情況 B：記憶晶體有資料（代表是掛斷後又打來，要接續話題）
          promptText = "（玩家再次撥通了你的電話）";
          callOverridePrompt += "\n👉 【特別：開場指令】：玩家又打來了。請閱讀歷史紀錄「直接接續」剛才的話題！絕對【禁止】再說「$greeting」或「喂」等制式開場白。請給出符合人設的自然反應（例如問玩家怎麼又打來了、或是繼續剛才沒說完的事）。";
        }
      }

      final request = http.Request(
        'POST',
        Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/directCallAiStream'),
      );
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $idToken';
      request.body = jsonEncode({
        "userMessage": promptText,
        "history": _callHistory,
        "chatMode": "call",
        "overrideSystemPrompt": callOverridePrompt,
        "characterProfile": {
          "name": widget.character.name,
          "toneAndStyle": widget.character.toneAndStyle?.replaceAll('{{玩家名字}}', '玩家') ?? "",
          "background": widget.character.background?.replaceAll('{{玩家名字}}', '玩家') ?? "",
          "detailedPersonality": widget.character.detailedPersonality?.replaceAll('{{玩家名字}}', '玩家') ?? "",
        },
      });

      // 發送並監聽串流
      // 發送並監聽串流
      final response = await _streamingHttpClient!.send(request);

      String fullReplyForHistory = "";
      bool hasFoundSeparator = false; // 🌟 新增：紀錄是不是已經越過「|」邊界了
      String audioBuffer = "";        // 🌟 新增：只存放要送去發聲的字，不污染畫面字幕

      response.stream.transform(utf8.decoder).listen((textChunk) {
        fullReplyForHistory += textChunk;

        // 🌟 1. 畫面字幕更新 (關鍵修正：沒看到 | 之前，絕對不准把字印在畫面上！)
        if (mounted) {
          if (fullReplyForHistory.contains('|')) {
            // 已經看到分隔線了，安心把後面的中文字幕印出來
            setState(() {
              _sttText = fullReplyForHistory.split('|').last.trim();
            });
          } else if (fullReplyForHistory.length > 50) {
            // 🛡️ 防呆機制：萬一 AI 暴走，寫了 50 個字都沒加 '|' 符號，
            // 為了避免畫面卡死，還是把字印出來
            setState(() {
              _sttText = fullReplyForHistory.trim();
            });
          }
        }

        // 2. 語音斷句處理 (維持原樣)
        if (!hasFoundSeparator) {
          if (textChunk.contains('|')) {
            hasFoundSeparator = true; // 🚨 發現分隔線！關閉語音通道！

            // 把這一個 textChunk 裡，位在 | 前面的殘餘文字抓出來
            int pipeIndex = textChunk.indexOf('|');
            audioBuffer += textChunk.substring(0, pipeIndex);

            // 既然語音部分已經全劇終，把剩下的字一次送去轉語音
            if (audioBuffer.trim().isNotEmpty) {
              _processSentenceToVoice(audioBuffer.trim());
              audioBuffer = ""; // 清空
            }
          } else {
            // 還沒遇到 |，安心把字加進語音緩衝區
            audioBuffer += textChunk;

            // 🎯 遇到標點符號就切斷送出 (跟原本一樣)
            final regExp = RegExp(r'([^，,。！？、\n]+[，,。！？、\n])');
            Iterable<Match> matches = regExp.allMatches(audioBuffer);

            if (matches.isNotEmpty) {
              for (var match in matches) {
                String singleSentence = match.group(0)!;
                audioBuffer = audioBuffer.substring(singleSentence.length);
                _processSentenceToVoice(singleSentence.trim());
              }
            }
          }
        }
      }, onDone: () async {
        // 串流收尾：如果因為最後一句沒加標點符號而卡在緩衝區，做最後清理
        if (audioBuffer.trim().isNotEmpty) {
          _processSentenceToVoice(audioBuffer.trim());
          audioBuffer = "";
        }

        // 把完整帶有 | 的原文塞入歷史紀錄，讓下一次對話有脈絡
        if (!isFirstGreeting) {
          _callHistory.add({"role": "user", "content": promptText});
        }
        _callHistory.add({"role": "assistant", "content": fullReplyForHistory});

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _inCallMessages.removeWhere((msg) => msg['text'] == l10n.character_thinking(widget.character.name));
            _inCallMessages.add({
              'isMe': false,
              'isSystem': false,
              'text': fullReplyForHistory.contains('|') ? fullReplyForHistory.split('|').last.trim() : fullReplyForHistory
            });
          });
          _scrollToBottom();
        }
      });

    } catch (e) {
      debugPrint("串流核心出錯: $e");
    }
  }

  // 🌟 後台默默把單句交給全新的 Cloud Function 後端
  Future<void> _processSentenceToVoice(String sentenceText) async {
    if (sentenceText.trim().isEmpty) return;

    final url = Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/generateVoice');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "text": sentenceText,
          "voiceId": widget.character.voiceId,
          "stability": widget.character.voiceStability ?? 0.40,
          "style": widget.character.voiceStyle ?? 0.75,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String audioUrl = data['audioUrl'];

        _audioPlaybackQueue.add(audioUrl);
        _startQueuePlaybackIfNeeded();
      }
    } catch (e) {
      debugPrint('單句語音排隊生成失敗: $e');
    }
  }

  // 🌟 排隊播放核心：一句播完才能播下一句，充滿真人說話的呼吸節奏
  // 🌟 排隊入口：如果有歌在播就不管，沒歌在播就開始抽號碼牌
  void _startQueuePlaybackIfNeeded() {
    if (_isAudioQueuePlaying || _audioPlaybackQueue.isEmpty) return;
    _isAudioQueuePlaying = true;
    _playNextInQueue();
  }

  // 🌟 專職負責「播下一句」的方法
  Future<void> _playNextInQueue() async {
    if (_audioPlaybackQueue.isEmpty) {
      _isAudioQueuePlaying = false; // 佇列空了，解鎖！
      return;
    }

    // 從排隊長龍中拿出第一句
    String nextAudioUrl = _audioPlaybackQueue.removeAt(0);

    if (mounted) {
      try {
        debugPrint("▶️ 正在播放新句子...");
        // 這裡只要下達 play 指令就好，不要再 await onPlayerComplete 了！
        await _audioPlayer.play(UrlSource(nextAudioUrl));
      } catch (e) {
        debugPrint("播放佇列音訊失敗: $e");
        _playNextInQueue(); // 如果這句網址壞了，直接略過播下一句，不卡死！
      }
    }
  }

  // ==================== 🎤 玩家與系統互動事件 ====================

  Future<void> _startFirstGreeting() async {
    // 🌟 解決文字閃現：一進來就先顯示「接通中」，就不會跑出預設的「請對麥克風說話」了
    setState(() {
      _sttText = '電話接通中...';
    });

    // 使用全域的音效播放器
    _sfxPlayer = AudioPlayer();
    _sfxPlayer!.play(AssetSource('audio/pickup.mp3'));

    // 🚀 開啟秒回串流管線！
    await _startCallStreamingPipeline("", isFirstGreeting: true);

    _startTimer();
  }

  // ==================== 🎤 智能語音辨識中樞 ====================

  void _listen() async {
    if (!_isListening) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;

      // 🌟 升級點 1：加上 onStatus 監聽器，賦予它「察言觀色」的能力
      bool available = await _speech.initialize(
        onStatus: (status) {
          debugPrint("🎤 語音辨識狀態: $status");
          // 偵測到玩家停頓（靜音），系統自動幫忙按下停止並發送！
          if (status == 'done' || status == 'notListening') {
            if (_isListening) {
              _stopAndSend();
            }
          }
        },
        onError: (error) => debugPrint('🎤 語音辨識錯誤: $error'),
      );

      if (available) {
        setState(() {
          _isListening = true;
          // 🌟 升級點 2：給玩家超清晰的指示，不用再疑惑要不要按停止
          _sttText = '正在聆聽... (講完會自動發送)';
        });

        _speech.listen(
          onResult: (val) {
            if (mounted) {
              setState(() => _sttText = val.recognizedWords);
            }
          },
          listenOptions: stt.SpeechListenOptions(localeId: 'zh_TW'),
        );
      }
    } else {
      // 玩家手動按按鈕提早結束 (也是走同一個發送通道)
      _stopAndSend();
    }
  }

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _inCallMessages.add({'isMe': true, 'isSystem': false, 'text': text});
    });

    _chatController.clear();
    _scrollToBottom();

    // 🚀 打字發送：一樣丟進串流大管線，讓它秒回
    await _startCallStreamingPipeline(text, isFirstGreeting: false);
  }

  void _listenToRealAIReply() {
    if (widget.sessionId.isEmpty) return;

    _replySubscription = FirebaseFirestore.instance
        .collection('chat_sessions')
        .doc(widget.sessionId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) return;

      final latestMsg = snapshot.docs.first.data();
      final String text = latestMsg['text'] ?? '';
      final bool isMe = latestMsg['isMe'] ?? false;
      final bool isSystemMessage = latestMsg['isSystem'] == true || latestMsg['type'] == 'system' || text.startsWith('📞');

      if (!isMe && !isSystemMessage && text.isNotEmpty) {
        if (_inCallMessages.isNotEmpty && _inCallMessages.last['text'] == text) return;

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _inCallMessages.removeWhere((msg) => msg['text'] == l10n.character_thinking(widget.character.name));
            _inCallMessages.add({'isMe': false, 'isSystem': false, 'text': text});
          });
          _scrollToBottom();

          // 🚨 兇手就是這行！請把它整行刪掉或加雙斜線註解！
          // _generateAndPlayAudio(text);
        }
      }
    });
  }

  // ==================== 🛠️ 備用與溫柔掛斷 (非串流) ====================

  // 這裡保留原有的非串流呼叫，專門留給第 50 秒的「溫柔道別機制」使用
  Future<String> _fetchAIResponse(String userText, {bool isFirstGreeting = false}) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return l10n.call_interrupted_login;
      final idToken = await currentUser.getIdToken();

      final response = await http.post(
        Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/directCallAi'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $idToken'},
        body: jsonEncode({
          "userMessage": userText,
          "history": _callHistory,
          "chatMode": "call",
          "characterProfile": {"name": widget.character.name}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['reply'] ?? l10n.silence;
      }
      return l10n.bad_signal;
    } catch (e) {
      return AppLocalizations.of(context)!.static_noise;
    }
  }

  Future<void> _generateAndPlayAudio(String text) async {
    if (!_isPlayerInitialized) return;
    final String? voiceId = widget.character.voiceId;
    if (voiceId == null || voiceId.isEmpty) return;

    final url = Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/generateVoice');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "text": text,
          "voiceId": voiceId,
          "stability": widget.character.voiceStability ?? 0.40,
          "style": widget.character.voiceStyle ?? 0.80,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) await _audioPlayer.play(UrlSource(data['audioUrl']));
      }
    } catch (e) {
      debugPrint('備用單次語音播放失敗: $e');
    }
  }

  Future<void> _playGentleHangupVoice() async {
    final prompt = "現在通話即將結束，請根據我們剛才的對話與你的人設（${widget.character.toneAndStyle}），用極度溫柔且不捨的語氣，說一句約 10-15 字的結束語。請確保每次說法都有變化，不要與上次重複。";
    final goodbyeText = await _fetchAIResponse(prompt, isFirstGreeting: false);
    String spokenGoodbye = goodbyeText.contains('|') ? goodbyeText.split('|')[0].trim() : goodbyeText;
    await _generateAndPlayAudio(spokenGoodbye);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startListening() async {
    if (_isListening) return;
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _sttText = '正在聆聽... (鬆開手指發送)';
      });

      _speech.listen(
        onResult: (val) {
          // 🕵️‍♂️ 加上這行超級監視器！只要系統有聽到任何一個字，終端機立刻就會印出來！
          debugPrint("🎤 即時辨識結果: ${val.recognizedWords}");

          if (mounted) setState(() => _sttText = val.recognizedWords);
        },
        // 🌟 關鍵修正：Android 比較認得連字號 (zh-TW)，甚至可以加上 partialResults 確保即時出字
        listenOptions: stt.SpeechListenOptions(
          localeId: 'zh-TW',
          partialResults: true,
        ),
      );
    }
  }

  // 🌟 2. 鬆開手指的瞬間：停止並發送
  Future<void> _stopAndSend() async {
    if (!_isListening) return;

    // 讓子彈飛一會兒，確保語音引擎收到最後一個字
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _isListening = false);
    await _speech.stop();

    String textToSend = _sttText ?? '';
    debugPrint("🛑 準備發送的原始文字: $textToSend"); // 🕵️‍♂️ 監視器 1

    if (textToSend.contains('正在聆聽')) {
      textToSend = ''; // 代表根本沒錄到聲音
    } else {
      textToSend = textToSend.trim();
    }

    // 防呆：如果鬆開時沒錄到任何字，恢復預設文字
    if (textToSend.isEmpty) {
      debugPrint("⚠️ 文字為空，啟動防呆機制，取消發送。"); // 🕵️‍♂️ 監視器 2
      if (mounted) {
        setState(() {
          _sttText = AppLocalizations.of(context)!.press_mic_to_speak;
        });
      }
      return;
    }

    debugPrint("✅ 成功錄取！準備送往雲端: $textToSend"); // 🕵️‍♂️ 監視器 3

    // 成功錄到字，給予發送提示
    setState(() {
      _sttText = '🗣️ $textToSend\n\n(發送中...)';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _sttText = AppLocalizations.of(context)!.character_thinking(widget.character.name);
      });
    }

    // 🚀 正式送進串流管線
    await _startCallStreamingPipeline(textToSend, isFirstGreeting: false);
  }

  // ==================== 🎨 畫面 UI 渲染中樞 ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text(_sttText ?? l10n.press_mic_to_speak, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildControlButton(icon: Icons.chat_bubble_rounded, color: Colors.white.withValues(alpha: 0.2), onTap: () => setState(() => _isChatMode = true)),
                  // 🌟 換成 Listener！絕對不會再被系統誤判成「取消點擊」
                  Listener(
                    onPointerDown: (_) => _startListening(), // 手指碰到螢幕
                    onPointerUp: (_) => _stopAndSend(),      // 手指離開螢幕
                    onPointerCancel: (_) => _stopAndSend(),  // 系統中斷 (例如來電)
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _isListening ? 70 : 60,
                      width: _isListening ? 70 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.redAccent : theme.colorScheme.primary,
                        boxShadow: [if (_isListening) BoxShadow(color: Colors.redAccent.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 5)],
                      ),
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 28),
                    ),
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
                  onPressed: () => setState(() => _isChatMode = false),
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
                    'assets/images/chat/chat_send_plane_mask.png',
                    width: 38,
                    height: 38,
                    color: theme.colorScheme.primary,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
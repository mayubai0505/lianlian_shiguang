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
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  // ✨ 巧妙修改：改成 String?，不用在 initState 寫死中文
  String? _sttText;

  List<Map<String, String>> _callHistory = [];
  late AudioPlayer _audioPlayer;
  int _timeElapsed = 0;
  final int _maxCallTime = 60;
  Timer? _timer;
  bool _isPlayerInitialized = false;

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    _isPlayerInitialized = true;
    debugPrint("✅ AudioPlayer 換心成功！");
  }

  late ImageProvider _callBackgroundImage;
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

    // 因為這兩個函數裡面會用到 l10n，我們用 Future.microtask 確保畫面準備好再執行
    Future.microtask(() {
      if (mounted) {
        _startFirstGreeting();
        _listenToRealAIReply();
      }
    });
  }

  void _setBackground() async {
    String? targetUrl = widget.selectedBackgroundUrl;
    if (targetUrl != null && targetUrl.isNotEmpty) {
      if (targetUrl.startsWith('gs://')) {
        try {
          targetUrl = await FirebaseStorage.instance.refFromURL(targetUrl).getDownloadURL();
        } catch (e) {
          targetUrl = null;
        }
      }
    }
    if (mounted) {
      setState(() {
        if (targetUrl != null && targetUrl.isNotEmpty) {
          _callBackgroundImage = CachedNetworkImageProvider(targetUrl);
        } else {
          _callBackgroundImage = const AssetImage('assets/images/default_avatar.png');
        }
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeElapsed < _maxCallTime) {
        if (mounted) setState(() => _timeElapsed++);

        // ✨ 關鍵邏輯：在第 50 秒觸發溫柔道別 (還剩 10 秒時)
        if (_timeElapsed == 50) {
          _playGentleHangupVoice();
        }

      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    final l10n = AppLocalizations.of(context)!; // ✨ 取得翻譯
    _timer?.cancel();
    if (_isListening) _speech.stop();

    setState(() {
      _inCallMessages.add({'isSystem': true, 'text': l10n.call_ended}); // ✨ 替換：通話已結束
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
    widget.onCallEnded(_timeElapsed, _inCallMessages);
  }

  void _listen() async {
    final l10n = AppLocalizations.of(context)!; // ✨ 取得翻譯
    if (!_isListening) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;

      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _sttText = '';
        });
        _speech.listen(
          onResult: (val) => setState(() => _sttText = val.recognizedWords),
          localeId: 'zh_TW',
        );
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();

      final textToSend = _sttText?.trim() ?? '';
      if (textToSend.isEmpty) return;

      setState(() {
        _sttText = l10n.character_thinking(widget.character.name); // ✨ 替換：正在思考...
      });

      final aiReply = await _fetchAIResponse(textToSend, isFirstGreeting: false);
      if (mounted) {
        setState(() {
          _sttText = aiReply;
        });
      }
      await _generateAndPlayAudio(aiReply);
    }
  }

  Future<String?> _uploadVoiceToStorage(Uint8List audioBytes) async {
    try {
      final String fileName = "call_rec_${widget.characterId}_${DateTime.now().millisecondsSinceEpoch}.mp3";
      final storageRef = FirebaseStorage.instance.ref().child('call_recordings').child(widget.characterId).child(fileName);
      final uploadTask = storageRef.putData(
        audioBytes,
        SettableMetadata(contentType: 'audio/mpeg'),
      );
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
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

    final aiReplyRaw = await _fetchAIResponse(text, isFirstGreeting: false);
    if (aiReplyRaw.isEmpty) return;

    String spokenText = aiReplyRaw;
    String displayText = aiReplyRaw;

    if (aiReplyRaw.contains('|')) {
      final parts = aiReplyRaw.split('|');
      spokenText = parts[0].trim();
      displayText = parts[1].trim();
    }

    if (mounted) {
      setState(() {
        _inCallMessages.add({'isMe': false, 'isSystem': false, 'text': displayText});
      });
      _scrollToBottom();
      await _generateAndPlayAudio(spokenText);
    }
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
            // ✨ 替換並解決 Bug：自動帶入男主名字，不會再死記程安了！
            _inCallMessages.removeWhere((msg) => msg['text'] == l10n.character_thinking(widget.character.name));
            _inCallMessages.add({'isMe': false, 'isSystem': false, 'text': text});
          });
          _scrollToBottom();
          _generateAndPlayAudio(text);
        }
      }
    });
  }

  Future<void> _startFirstGreeting() async {
    final l10n = AppLocalizations.of(context)!; // ✨ 取得翻譯
    setState(() {
      _sttText = l10n.character_picking_up(widget.character.name); // ✨ 替換：正在接起電話...
    });

    final aiReplyRaw = await _fetchAIResponse("", isFirstGreeting: true);
    String spokenText = aiReplyRaw;
    String displayText = aiReplyRaw;

    if (aiReplyRaw.contains('|')) {
      final parts = aiReplyRaw.split('|');
      spokenText = parts[0].trim();
      displayText = parts[1].trim();
    }

    final stopwatch = Stopwatch()..start();
    final sfxPlayer = AudioPlayer();
    sfxPlayer.play(AssetSource('audio/pickup.mp3'));


    int timeLeft = 5000 - stopwatch.elapsedMilliseconds;
    if (timeLeft > 0) {
      await Future.delayed(Duration(milliseconds: timeLeft));
    }

    await _generateAndPlayAudio(spokenText);

    if (mounted) {
      setState(() {
        _sttText = displayText;
      });
    }
    _startTimer();
  }

  Future<String> _fetchAIResponse(String userText, {bool isFirstGreeting = false}) async {
    try {
      final l10n = AppLocalizations.of(context)!; // ✨ 取得翻譯
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return l10n.call_interrupted_login; // ✨ 替換：請先登入喔

      final idToken = await currentUser.getIdToken();

      // ⚠️ 注意：給 AI 的系統提示詞 (Prompt) 必須保持中文，這樣 AI 才能聽懂指令，不需 l10n！
      String callOverridePrompt = """
【通話模式最高準則】
你現在正在跟玩家「講電話」。請根據傳入的 [characterProfile] 進行表演：

1. 【格式規範】：絕對禁止使用表情符號。句子必須簡短（15~30字），嚴禁長篇大論。
2. 【語氣引導】：請完全遵守 [toneAndStyle] 定義的性格。
   - 如果人設是「高冷/嚴肅/禁慾/理智」，請禁止使用語尾助詞。
   - 如果人設是「陽光/活潑/溫柔」,請根據性格自然使用助詞（如：啦、喔、呢）。
3. 【節奏感】：善用「...」表現呼吸、停頓或情緒轉折。
4. 【邏輯防禦】：通話初期嚴禁對玩家的聲音或長相進行具體評價。
5. 【自然收尾】：語句結束時自然停頓，不需刻意轉折。
6. 【語調與句型連動（最高指導）】：
   - 當產生「疑問句」時：句尾必須使用「？」結尾，可適當加入短促的「嗯？」或「對吧？」，以觸發語音引擎的尾音上揚。
   - 當產生「命令句/祈使句」時：必須使用簡短有力的肯定句並以「。」結尾（例如：「過來。」、「去睡覺。」），以觸發堅定、嚴肅的低沉語音。
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
例如 (若玩家打韓文，想聽日文)：[日本語] | [한국어]
絕對禁止破壞此格式，且不要加任何多餘的說明。
""";
      String greeting = "Wéi";
      if (widget.selectedLanguage == 'English') greeting = "Hello";
      if (widget.selectedLanguage == '日本語') greeting = "もしもし";
      if (widget.selectedLanguage == '한국어') greeting = "여보세요";
      if (widget.selectedLanguage == 'Tiếng Việt') greeting = "A lô";

      String promptText = userText.trim();

      if (isFirstGreeting) {
        promptText = "（玩家剛剛接起了你的電話）";
        callOverridePrompt += """
  \n👉 【特別：開場指令】：
  必須嚴格遵守以下開場格式：
  $greeting？ + [${widget.selectedLanguage}正文] | 喂？ + [繁體中文正文]
  """;
      }

      final Map<String, dynamic> requestBody = {
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
      };

      final response = await http.post(
        Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/directCallAi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String rawReply = data['reply'] ?? l10n.silence; // ✨ 替換：沈默

        if (rawReply.contains("回覆中")) return "";

        if (!isFirstGreeting) {
          _callHistory.add({"role": "user", "content": promptText});
        }
        _callHistory.add({"role": "assistant", "content": rawReply});

        return rawReply;
      } else {
        return l10n.bad_signal; // ✨ 替換：訊號不好
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      return l10n.static_noise; // ✨ 替換：沙沙聲聽不清楚
    }
  }

  Future<void> _generateAndPlayAudio(String text) async {
    if (!_isPlayerInitialized) return;

    final String apiKey = 'sk_ac547721d8ff700babefd42c96ae76e4eb685ce2d313f87f';
    final String? voiceId = widget.character.voiceId;

    if (voiceId == null || voiceId.isEmpty) return;

    String cleanAudioText = text.replaceAll(RegExp(r'\(.*?\)|（.*?）|\[.*?\]|【.*?】'), '').trim();
    cleanAudioText = cleanAudioText.replaceFirst(RegExp(r'^嗯'), 'Hm-m... ');
    cleanAudioText = cleanAudioText.replaceAll('你', 'nǐ');
    cleanAudioText = cleanAudioText.replaceAll('妳', 'nǐ');
    cleanAudioText = cleanAudioText.replaceAll('嗯', ' hm-m? ');
    cleanAudioText = cleanAudioText.replaceAll('安安', '');
    cleanAudioText = cleanAudioText.replaceAll('喂', 'Wéi');

    if (cleanAudioText.isEmpty) return;

    final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId?optimize_streaming_latency=3');

    try {
      final response = await http.post(
        url,
        headers: {
          'accept': 'audio/mpeg',
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "text": cleanAudioText,
          "model_id": "eleven_multilingual_v2",
          "voice_settings": {
            "stability": widget.character.voiceStability ?? 0.33,
            "similarity_boost": 0.80,
            "style": widget.character.voiceStyle ?? 0.75,
            "use_speaker_boost": true
          }
        }),
      );

      if (response.statusCode == 200) {
        final audioBytes = response.bodyBytes;
        if (!mounted) return;

        // 🌟 總裁防快取神技：確保每一句通話都是最新鮮的！
        if (kIsWeb) {
          await _audioPlayer.play(BytesSource(audioBytes));
        } else {
          final directory = await getTemporaryDirectory();
          // 🔑 加上時間戳記，確保每句話的實體檔名都不同 (例如: call_voice_171746201823.mp3)
          final String uniqueFileName = 'call_voice_${DateTime.now().millisecondsSinceEpoch}.mp3';
          final file = File('${directory.path}/$uniqueFileName');
          await file.writeAsBytes(audioBytes);
          await _audioPlayer.play(DeviceFileSource(file.path));
        }

        // 🚨 總裁搶救：幫妳把剛剛不小心刪掉的雲端上傳和畫面更新補回來了！
        String? cloudUrl = await _uploadVoiceToStorage(audioBytes);

        if (cloudUrl != null && mounted) {
          setState(() {
            for (var i = _inCallMessages.length - 1; i >= 0; i--) {
              if (_inCallMessages[i]['isMe'] == false && _inCallMessages[i]['text'] == text) {
                _inCallMessages[i]['audioUrl'] = cloudUrl;
                break;
              }
            }
          });
        }
      } // 👈 剛剛就是少了這個括號！
    } catch (e) {
      print('語音處理失敗: $e');
    }
  }

  // 在 _CallOverlayState 內部新增：

// ✨ 新增函數：產生並播放道別台詞
  Future<void> _playGentleHangupVoice() async {
    // 提示詞指令
    final prompt = "現在通話即將結束，請根據我們剛才的對話與你的人設（${widget.character.toneAndStyle}），用極度溫柔且不捨的語氣，說一句約 10-15 字的結束語。請確保每次說法都有變化，不要與上次重複。";

    // 呼叫 AI 生成
    final goodbyeText = await _fetchAIResponse(prompt, isFirstGreeting: false);

    // 清理格式 (只取語音台詞)
    String spokenGoodbye = goodbyeText.contains('|') ? goodbyeText.split('|')[0].trim() : goodbyeText;

    // 播放
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

  @override
  void dispose() {
    _timer?.cancel();
    _chatController.dispose();
    _scrollController.dispose();
    _audioPlayer.stop();
    if (_isPlayerInitialized) {
      _audioPlayer.dispose();
      _isPlayerInitialized = false;
    }
    globalActiveCharacterId = null;
    _replySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: _callBackgroundImage, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
            child: Container(color: Colors.black.withValues(alpha:0.6)),
          ),
          if (!_isChatMode)
            _buildCallUI(context)
          else
            _buildInCallChatUI(context),
        ],
      ),
    );
  }

  Widget _buildCallUI(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!; // ✨ 取得翻譯
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
                border: Border.all(color: Colors.white.withValues(alpha:0.4), width: 2),
                image: DecorationImage(image: _callBackgroundImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text(widget.character.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('$minutesStr:$secondsStr', style: TextStyle(color: Colors.white.withValues(alpha:0.9), fontSize: 20, letterSpacing: 2)),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha:0.15), borderRadius: BorderRadius.circular(16)),
                child: Text(_sttText ?? l10n.press_mic_to_speak, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)), // ✨ 替換：請按下麥克風開始說話
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildControlButton(icon: Icons.chat_bubble_rounded, color: Colors.white.withValues(alpha:0.2), onTap: () => setState(() => _isChatMode = true)),
                  GestureDetector(
                    onTapDown: (_) => _listen(),
                    onTapUp: (_) => _listen(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: _isListening ? 70 : 60, width: _isListening ? 70 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.redAccent : theme.colorScheme.primary,
                        boxShadow: [if (_isListening) BoxShadow(color: Colors.redAccent.withValues(alpha:0.6), blurRadius: 15, spreadRadius: 5)],
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
    final l10n = AppLocalizations.of(context)!; // ✨ 取得翻譯
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
                CircleAvatar(radius: 20, backgroundImage: _callBackgroundImage),
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
          Divider(color: Colors.white.withValues(alpha:0.2), height: 1),
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
                      color: isMe ? theme.colorScheme.primary : Colors.white.withValues(alpha:0.2),
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
            decoration: BoxDecoration(color: Colors.black.withValues(alpha:0.4)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.type_message_hint, // ✨ 替換：輸入文字...
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.5)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha:0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
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
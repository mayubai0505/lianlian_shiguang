import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../services/toast_utils.dart'; // 🌟 用來判斷是不是網頁版 (kIsWeb)
import 'package:cloud_functions/cloud_functions.dart';

// 🌟 回放室：需要動態狀態來播放音樂
class CallMemoryDetailPage extends StatefulWidget {
  final Map<String, dynamic> memoryData;

  const CallMemoryDetailPage({Key? key, required this.memoryData}) : super(key: key);

  @override
  State<CallMemoryDetailPage> createState() => _CallMemoryDetailPageState();
}

class _CallMemoryDetailPageState extends State<CallMemoryDetailPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlayerInitialized = false;
  String? _currentlyPlayingText; // 記錄正在播放哪一句，用來顯示特效
  final Map<String, Uint8List> _voiceAudioCache = {};
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(region: 'asia-east1');
  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  // 🎧 初始化播放器
  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.dispose();
    _isPlayerInitialized = true;
  }

  // 🎙️ 核心功能：呼叫 ElevenLabs 重新播放男神的聲音！
  Future<void> _playVoice(String text) async {
    final l10n = AppLocalizations.of(context)!;

    if (!_isPlayerInitialized) return;

    // ✅ 兼容兩種欄位名稱：voiceId / voice_id
    final String voiceId =
        widget.memoryData['voiceId']?.toString() ??
            widget.memoryData['voice_id']?.toString() ??
            '';

    if (voiceId.isEmpty) {
      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.no_exclusive_voice,
        );
      }
      return;
    }

    String cleanAudioText = text
        .replaceAll(RegExp(r'\(.*?\)|（.*?）|\[.*?\]|【.*?】'), '')
        .trim();

    if (cleanAudioText.isEmpty) {
      if (mounted) {
        setState(() => _currentlyPlayingText = null);
      }
      return;
    }

    final double targetStability =
    (widget.memoryData['voiceStability'] is num)
        ? (widget.memoryData['voiceStability'] as num).toDouble()
        : 0.33;

    final double targetStyle =
    (widget.memoryData['voiceStyle'] is num)
        ? (widget.memoryData['voiceStyle'] as num).toDouble()
        : 0.75;

    final String cacheKey = [
      voiceId,
      targetStability.toStringAsFixed(2),
      targetStyle.toStringAsFixed(2),
      cleanAudioText,
    ].join('|');

    setState(() => _currentlyPlayingText = text);

    try {
      Uint8List audioBytes;

      // ✅ 先看快取，有快取就不呼叫 Cloud Function
      if (_voiceAudioCache.containsKey(cacheKey)) {
        debugPrint("🎧 使用語音快取，不重新呼叫 Cloud Function");
        audioBytes = _voiceAudioCache[cacheKey]!;
      } else {
        debugPrint("☁️ 呼叫 Cloud Function 產生語音");

        final callable = _functions.httpsCallable('testVoiceSettings');

        final result = await callable.call({
          'voiceId': voiceId,
          'text': cleanAudioText,
          'stability': targetStability,
          'style': targetStyle,
        });

        final data = Map<String, dynamic>.from(result.data);

        final String audioBase64 =
            data['audio_base_64']?.toString() ?? '';

        if (audioBase64.isEmpty) {
          throw Exception("Cloud Function 沒有回傳音檔");
        }

        audioBytes = base64Decode(audioBase64);

        _voiceAudioCache[cacheKey] = audioBytes;
        debugPrint("🎧 語音已存入快取");
      }

      try {
        await _audioPlayer.stop();
      } catch (e) {
        debugPrint("停止舊播放器失敗，可忽略: $e");
      }

      // ✅ 網頁版避免播放器卡住，直接換新播放器
      _audioPlayer = AudioPlayer();

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _currentlyPlayingText = null);
          debugPrint("🎵 播完了，解除特效");
        }
      });

      if (kIsWeb) {
        final base64Audio = base64Encode(audioBytes);
        final dataUri = 'data:audio/mpeg;base64,$base64Audio';
        await _audioPlayer.play(UrlSource(dataUri));
      } else {
        await _audioPlayer.play(BytesSource(audioBytes));
      }
    } catch (e) {
      debugPrint('播放發生錯誤: $e');

      if (mounted) {
        setState(() => _currentlyPlayingText = null);

        ToastUtils.showCenterToast(
          context,
          l10n.voice_test_failed,
          isError: true,
        );
      }
    }
  }

  Future<void> _playVoiceForMessage({
    required String sessionId,
    required String messageId,
    required String text,
    String? audioUrl,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (!_isPlayerInitialized) return;

    final voiceId = widget.memoryData['voiceId'];

    if (voiceId == null || voiceId.isEmpty) {
      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.no_exclusive_voice,
        );
      }
      return;
    }

    setState(() => _currentlyPlayingText = text);

    try {
      if (audioUrl != null && audioUrl.isNotEmpty) {
        debugPrint("🎧 已有 audioUrl，直接播放快取語音");

        try {
          await _audioPlayer.stop();
        } catch (e) {}

        _audioPlayer = AudioPlayer();

        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() => _currentlyPlayingText = null);
            debugPrint("🎵 播完了，解除特效");
          }
        });

        await _audioPlayer.play(UrlSource(audioUrl));
        return;
      }

      final double targetStability =
          widget.memoryData['voiceStability']?.toDouble() ?? 0.33;

      final double targetStyle =
          widget.memoryData['voiceStyle']?.toDouble() ?? 0.75;

      final response = await http.post(
        Uri.parse(
          'https://asia-east1-lianlianshiguang.cloudfunctions.net/generateVoice',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'sessionId': sessionId,
          'messageId': messageId,
          'voiceId': voiceId,
          'stability': targetStability,
          'style': targetStyle,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint("語音生成失敗: ${response.body}");

        if (mounted) {
          setState(() => _currentlyPlayingText = null);
          ToastUtils.showCenterToast(
            context,
            l10n.elevenlabs_error(response.statusCode.toString()),
            isError: true,
          );
        }

        return;
      }

      final data = jsonDecode(response.body);
      final String newAudioUrl = data['audioUrl'] ?? '';

      if (newAudioUrl.isEmpty) {
        if (mounted) setState(() => _currentlyPlayingText = null);
        return;
      }

      debugPrint("🎧 取得語音 URL，開始播放。status: ${data['status']}");

      try {
        await _audioPlayer.stop();
      } catch (e) {}

      _audioPlayer = AudioPlayer();

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _currentlyPlayingText = null);
          debugPrint("🎵 播完了，解除特效");
        }
      });

      await _audioPlayer.play(UrlSource(newAudioUrl));
    } catch (e) {
      debugPrint("播放語音發生錯誤: $e");

      if (mounted) {
        setState(() => _currentlyPlayingText = null);
      }
    }
  }

  // 🧹 離開包廂時，記得關掉音樂播放器
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // 🎨 畫出 VIP 包廂的裝潢設計圖
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final messages = List<Map<String, dynamic>>.from(widget.memoryData['messages'] ?? []);
    final characterName = widget.memoryData['characterName'] ?? l10n.unknown_contact;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.call_memory_with(characterName), // ✨ 把名字放進括號裡！
          style: const TextStyle(fontSize: 16),
        ),        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: messages.isEmpty
          ?  Center(child: Text(l10n.no_call_record))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isMe = msg['isMe'] == true;
          final text = msg['text'] ?? '';
          final isPlaying = _currentlyPlayingText == text;

          debugPrint("🎧 msg keys: ${msg.keys.toList()}");
          debugPrint("🎧 msg data: $msg");
          debugPrint("🎧 memoryData keys: ${widget.memoryData.keys.toList()}");

          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? theme.colorScheme.surfaceContainerHighest.withValues(alpha:0.5) : theme.colorScheme.primary.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(16),
                border: isPlaying ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe ? l10n.me : characterName,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isMe ? Colors.grey : theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(text, style: const TextStyle(fontSize: 15)),

                  // 🌟 總裁專屬設定：只有男神的話，下面才會出現「播放按鈕」！
                  if (!isMe) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: isPlaying ? null : () => _playVoice(text), // 呼叫上面的播放功能
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(isPlaying ? Icons.multitrack_audio : Icons.play_arrow_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(isPlaying ? l10n.playing : l10n.listen, style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
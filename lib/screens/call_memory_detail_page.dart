import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../services/toast_utils.dart'; // 🌟 用來判斷是不是網頁版 (kIsWeb)

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
    final voiceId = widget.memoryData['voiceId'];
    if (voiceId == null || voiceId.isEmpty) {
      if (mounted) {
        // ✨ 總裁級：專屬語音從缺的溫柔提醒，用輕盈的視覺回饋安撫聽覺的期待！
        ToastUtils.showCenterToast(
          context,
          l10n.no_exclusive_voice,
        );
      }
      return;
    }

    setState(() => _currentlyPlayingText = text);

    // 🛑 總裁請注意：記得把這裡的 API Key 換成妳自己的！
    final String apiKey = 'sk_ac547721d8ff700babefd42c96ae76e4eb685ce2d313f87f';
    String cleanAudioText = text.replaceAll(RegExp(r'\(.*?\)|（.*?）|\[.*?\]|【.*?】'), '').trim();
    if (cleanAudioText.isEmpty) {
      setState(() => _currentlyPlayingText = null);
      return;
    }

    // ✨✨✨ 關鍵更新：從 memoryData 裡面直接抓出當時存下的「演技數字」！ ✨✨✨
    // 加上 .toDouble() 確保型別安全，若沒抓到則套用霸總預設值 (0.33, 0.75)
    final double targetStability = widget.memoryData['voiceStability']?.toDouble() ?? 0.33;
    final double targetStyle = widget.memoryData['voiceStyle']?.toDouble() ?? 0.75;
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
            // 🌟 完美套用當時的演技設定！
            "stability": targetStability,
            "similarity_boost": 0.80,
            "style": targetStyle,
            "use_speaker_boost": true
          }
        }),
      );

      if (response.statusCode == 200) {
        debugPrint(l10n.voice_download_success);

        final Uint8List audioBytes = response.bodyBytes;

        // 💥【網頁版終極大絕招：鳳凰涅槃】💥
        // 既然舊的播放器在網頁上會卡陰，我們直接換一顆全新的！
        try {
          await _audioPlayer.stop(); // 先嘗試讓舊的閉嘴
        } catch (e) {
          // 壞掉就算了，不管它
        }

        _audioPlayer = AudioPlayer(); // ✨ 暴力解法：直接產生一個全新的播放器實體！
        // 🌟 把播完的監聽器，裝在這個「新心臟」上面
        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() => _currentlyPlayingText = null);
            debugPrint("🎵 播完了，解除特效");
          }
        });

        // 🎵 開始播放！
        if (kIsWeb) {
          final base64Audio = base64Encode(audioBytes);
          final dataUri = 'data:audio/mpeg;base64,$base64Audio';
          await _audioPlayer.play(UrlSource(dataUri));
        } else {
          await _audioPlayer.play(BytesSource(audioBytes));
        }

      } else {
        print('播放失敗，狀態碼: ${response.statusCode}');
        if (mounted) setState(() => _currentlyPlayingText = null);
      }
    } catch (e) {
      print('播放發生錯誤: $e');
      if (mounted) setState(() => _currentlyPlayingText = null);
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
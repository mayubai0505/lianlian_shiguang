import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'promotion_media_platform_stub.dart'
    if (dart.library.io) 'promotion_media_platform_io.dart'
    if (dart.library.js_interop) 'promotion_media_platform_web.dart' as platform;

const promotionMimeByExtension = <String, String>{
  'jpg':'image/jpeg', 'jpeg':'image/jpeg', 'png':'image/png',
  'webp':'image/webp', 'mp4':'video/mp4', 'mov':'video/quicktime',
};
const promotionExtensionByMime = <String, String>{
  'image/jpeg':'jpg', 'image/png':'png', 'image/webp':'webp',
  'video/mp4':'mp4', 'video/quicktime':'mov',
};
int promotionMaxBytes(String mime) => (mime.startsWith('video/') ? 50 : 10) * 1024 * 1024;

Future<void> savePromotionMedia(BuildContext context, Uint8List bytes,
    String name, String mime) => platform.saveOriginal(context, bytes, name, mime);

/// Original file is not recompressed or altered. The preview uses a temporary
/// local copy or an object URL, never a public Firebase download token.
Future<void> showPromotionMediaPreview(BuildContext context, Uint8List bytes,
    String mime, {String title = 'Preview', String error = 'Unable to preview this file. Please download the original.'}) async {
  if (!context.mounted) return;
  await showDialog<void>(context: context, builder: (dialogContext) => Dialog(
    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 680, maxHeight: 700),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 8, 4, 4), child: Row(children: [
          Expanded(child: Text(title, style: Theme.of(dialogContext).textTheme.titleMedium)),
          IconButton(onPressed: () => Navigator.of(dialogContext).pop(), icon: const Icon(Icons.close)),
        ])),
        Flexible(child: Padding(padding: const EdgeInsets.all(12), child: mime.startsWith('image/')
            ? InteractiveViewer(child: Image.memory(bytes, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Center(child: Text(error))))
            : _PromotionVideo(bytes: bytes, mime: mime, error: error))),
      ])),
  ));
}

class _PromotionVideo extends StatefulWidget {
  const _PromotionVideo({required this.bytes, required this.mime, required this.error});
  final Uint8List bytes;
  final String mime, error;
  @override State<_PromotionVideo> createState() => _PromotionVideoState();
}
class _PromotionVideoState extends State<_PromotionVideo> {
  VideoPlayerController? _controller;
  Future<void> Function()? _release;
  bool _failed = false;
  bool _closed = false;
  @override void initState() { super.initState(); _initialize(); }
  Future<void> _initialize() async {
    try {
      final handle = await platform.openOriginalVideo(widget.bytes, widget.mime);
      if (_closed) { await handle.controller.dispose(); await handle.release(); return; }
      _controller = handle.controller;
      _release = handle.release;
      await _controller!.initialize();
      if (_closed || !mounted) return;
      setState(() {});
    } catch (_) { if (mounted && !_closed) setState(() => _failed = true); }
  }
  Future<void> _disposeMedia() async {
    try { await _controller?.dispose(); } finally { await _release?.call(); }
  }
  @override void dispose() {
    _closed = true;
    _disposeMedia();
    super.dispose();
  }
  @override Widget build(BuildContext context) {
    final c = _controller;
    if (_failed) return Center(child: Text(widget.error, textAlign: TextAlign.center));
    if (c == null || !c.value.isInitialized) return const Center(child: CircularProgressIndicator());
    final ratio = c.value.aspectRatio > 0 ? c.value.aspectRatio : 16 / 9;
    return ValueListenableBuilder<VideoPlayerValue>(valueListenable: c, builder: (_, value, __) => Column(
      mainAxisSize: MainAxisSize.min, children: [
        Flexible(child: Center(child: AspectRatio(aspectRatio: ratio, child: VideoPlayer(c)))),
        VideoProgressIndicator(c, allowScrubbing: true),
        IconButton(onPressed: () async {
          if (value.isPlaying) { await c.pause(); }
          else { if (value.position >= value.duration) await c.seekTo(Duration.zero); await c.play(); }
        }, icon: Icon(value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline), iconSize: 38),
      ],
    ));
  }
}

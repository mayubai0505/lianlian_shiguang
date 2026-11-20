import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

Future<void> saveOriginal(BuildContext context, Uint8List bytes, String name, String mime) async {
  if (Platform.isAndroid || Platform.isIOS) {
    // Mobile file exports use the native share/save sheet.
    final box = context.findRenderObject();
    final origin = box is RenderBox && box.hasSize ? box.localToGlobal(Offset.zero) & box.size : null;
    await SharePlus.instance.share(ShareParams(files: [XFile.fromData(bytes, name: name, mimeType: mime)], fileNameOverrides: [name], sharePositionOrigin: origin));
    return;
  }
  final location = await getSaveLocation(suggestedName: name);
  if (location == null) return;
  await File(location.path).writeAsBytes(bytes, flush: true);
}

Future<({VideoPlayerController controller, Future<void> Function() release})> openOriginalVideo(Uint8List bytes, String mime) async {
  if (!(Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
    throw UnsupportedError('Download to preview this video on this platform.');
  }
  final base = await getTemporaryDirectory();
  final folder = await base.createTemp('social_promotion_');
  try {
    final video = File('${folder.path}/original.${mime == 'video/quicktime' ? 'mov' : 'mp4'}');
    await video.writeAsBytes(bytes, flush: true);
    return (controller: VideoPlayerController.file(video), release: () async {
      try { await folder.delete(recursive: true); } catch (_) {}
    });
  } catch (_) {
    try { await folder.delete(recursive: true); } catch (_) {}
    rethrow;
  }
}

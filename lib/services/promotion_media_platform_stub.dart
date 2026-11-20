import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<void> saveOriginal(BuildContext context, Uint8List bytes, String name, String mime) async {
  throw UnsupportedError('Saving files is unavailable on this platform.');
}
Future<({VideoPlayerController controller, Future<void> Function() release})> openOriginalVideo(Uint8List bytes, String mime) async {
  throw UnsupportedError('Video preview is unavailable on this platform.');
}

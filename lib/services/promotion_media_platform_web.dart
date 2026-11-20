import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

String _objectUrl(Uint8List bytes, String mime) => web.URL.createObjectURL(
    web.Blob(<JSAny>[bytes.toJS].toJS, web.BlobPropertyBag(type: mime)));

Future<void> saveOriginal(BuildContext context, Uint8List bytes, String name, String mime) async {
  final url = _objectUrl(bytes, mime);
  final anchor = web.HTMLAnchorElement()..href = url..download = name;
  web.document.body!.appendChild(anchor);
  try { anchor.click(); }
  finally {
    anchor.remove();
    // Let the browser start reading the Blob before releasing the URL.
    Future<void>.delayed(const Duration(seconds: 30), () => web.URL.revokeObjectURL(url));
  }
}
Future<({VideoPlayerController controller, Future<void> Function() release})> openOriginalVideo(Uint8List bytes, String mime) async {
  final url = _objectUrl(bytes, mime);
  return (controller: VideoPlayerController.networkUrl(Uri.parse(url)),
    release: () async { web.URL.revokeObjectURL(url); });
}

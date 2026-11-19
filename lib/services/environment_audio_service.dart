import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Independent preview mixer. Call integration is intentionally deferred.
class EnvironmentAudioService {
  final AudioPlayer _ambient = AudioPlayer();
  final AudioPlayer _effect = AudioPlayer();
  double _ambientVolume = 0.15;
  bool _ducked = false;
  Future<void> play(Uint8List bytes, {required String mime, required bool loop, required double volume}) async {
    final player = loop ? _ambient : _effect;
    await player.stop();
    await player.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
    if (loop) _ambientVolume = volume;
    await player.setVolume(loop && _ducked ? volume * 0.35 : volume);
    final Source source = kIsWeb
        ? UrlSource('data:$mime;base64,${base64Encode(bytes)}')
        : BytesSource(bytes, mimeType: mime);
    await player.play(source);
  }
  Future<void> setDucked(bool value) async {
    _ducked = value;
    await _ambient.setVolume(_ambientVolume * (value ? 0.35 : 1));
  }
  Future<void> stop() async { await Future.wait([_ambient.stop(), _effect.stop()]); }
  Future<void> dispose() async { await Future.wait([_ambient.dispose(), _effect.dispose()]); }
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

/// The optional control line precedes the original voice | subtitle stream.
/// Old servers return only dialogue: pass it through without delaying a turn.
class CallEnvironmentHeader {
  final void Function(String ambient, String effect) onPlan;
  CallEnvironmentHeader(this.onPlan);
  static const _marker = '[[ENV:';
  static final _line = RegExp(r'^\[\[ENV:([a-z0-9_-]{1,80});([a-z0-9_-]{1,80})\]\]$');
  String _pending = '';
  bool _done = false;
  bool _dropping = false;

  String push(String chunk) {
    if (_dropping) {
      final end = chunk.indexOf('\n');
      if (end < 0) return '';
      _dropping = false;
      return chunk.substring(end + 1);
    }
    if (_done) return chunk;
    _pending += chunk;
    final text = _pending.trimLeft();
    if (text.isEmpty && _pending.length <= 256) return '';
    if (text.isNotEmpty && _marker.startsWith(text)) return '';
    if (!text.startsWith(_marker)) {
      _done = true;
      final body = _pending;
      _pending = '';
      return body;
    }
    final end = text.indexOf('\n');
    if (end < 0) {
      if (text.length > 256) {
        _pending = '';
        _done = true;
        _dropping = true;
      }
      return '';
    }
    final match = _line.firstMatch(text.substring(0, end).trim());
    if (match != null) onPlan(match.group(1)!, match.group(2)!);
    _done = true;
    _pending = '';
    return text.substring(end + 1);
  }

  String finish() {
    if (_done) return '';
    _done = true;
    final result = _pending;
    _pending = '';
    final text = result.trimLeft();
    return text.startsWith(_marker) || _marker.startsWith(text) ? '' : result;
  }
}

class _CallSound {
  final String id, type, mime;
  final double volume;
  final Uint8List bytes;
  _CallSound(this.id, this.type, this.mime, this.volume, this.bytes);
  Source get source => kIsWeb
      ? UrlSource('data:$mime;base64,${base64Encode(bytes)}')
      : BytesSource(bytes, mimeType: mime);
}

/// One call owns this mixer. Its cache and playback state never cross rooms.
/// Every task checks its turn/epoch after async work; late downloads cannot
/// restart a hung-up call. Environmental audio is always optional.
class CallEnvironmentAudio {
  CallEnvironmentAudio({required this.sessionId, required this.characterId,
    required this.configurePlayer});
  final String sessionId, characterId;
  final Future<void> Function(AudioPlayer) configurePlayer;
  final _ambient = [AudioPlayer(), AudioPlayer()];
  final _effect = AudioPlayer();
  final _functions = FirebaseFunctions.instanceFor(region: 'us-central1');
  final Map<String, _CallSound> _cache = {};
  final Map<String, Future<_CallSound?>> _loading = {};
  static const _maxBytes = 5 * 1024 * 1024;
  static const _maxCache = 16 * 1024 * 1024;
  static final _validId = RegExp(r'^[a-z0-9_-]{1,80}$');
  int _cachedBytes = 0, _turn = -1, _epoch = 0, _active = -1;
  bool _closed = false, _paused = false, _started = false, _ducked = false;
  bool _suspended = true;
  String _desired = 'none', _pending = 'none', _pendingEffect = 'none';
  _CallSound? _activeSound;
  Future<void> _tail = Future<void>.value();
  Future<void>? _closeTask;

  String get currentAmbientId => _desired;
  double get _gain => _ducked ? 0.35 : 1.0;
  bool _isSound(String id) => id != 'keep' && id != 'none' && _validId.hasMatch(id);
  bool _valid(int epoch) => !_closed && !_suspended && epoch == _epoch;

  Future<void> _safe(Future<void> Function() fn) async {
    try { await fn(); } catch (e) { debugPrint('CALL_ENV_AUDIO_FAILED ${e.runtimeType}'); }
  }
  Future<void> _serial(Future<void> Function() fn) {
    final next = _tail.then((_) => _safe(fn));
    _tail = next;
    return next;
  }

  Future<_CallSound?> _load(String id, String type) async {
    if (_closed || !_isSound(id) || sessionId.isEmpty || characterId.isEmpty) return null;
    final hit = _cache.remove(id);
    if (hit != null) {
      _cache[id] = hit;
      return hit.type == type ? hit : null;
    }
    final existing = _loading[id];
    if (existing != null) {
      final sound = await existing;
      return sound?.type == type ? sound : null;
    }
    final task = () async {
      try {
        final response = await _functions.httpsCallable('getCallEnvironmentSoundUs',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 12)))
          .call({'soundId': id, 'sessionId': sessionId, 'characterId': characterId});
        if (_closed || response.data is! Map) return null;
        final data = response.data as Map;
        final mime = data['contentType'];
        final dataType = data['type'];
        final encoded = data['audioBase64'];
        final volume = data['volume'];
        if (data['soundId'] != id || (mime != 'audio/mpeg' && mime != 'audio/wav') ||
            (dataType != 'ambient' && dataType != 'effect') || encoded is! String ||
            encoded.length > ((_maxBytes + 2) ~/ 3) * 4 || volume is! num || !volume.isFinite) return null;
        final bytes = base64Decode(encoded);
        if (bytes.isEmpty || bytes.length > _maxBytes || _closed) return null;
        // Keep a conservative call mix even if a bank asset is set very loud.
        final limit = dataType == 'ambient' ? 0.25 : 0.45;
        final sound = _CallSound(id, dataType as String, mime as String,
            volume.toDouble().clamp(0.0, limit).toDouble(), bytes);
        while (_cache.isNotEmpty && _cachedBytes + bytes.length > _maxCache) {
          _cachedBytes -= _cache.remove(_cache.keys.first)!.bytes.length;
        }
        _cache[id] = sound;
        _cachedBytes += bytes.length;
        return sound;
      } catch (e) {
        debugPrint('CALL_ENV_DOWNLOAD_FAILED $id ${e.runtimeType}');
        return null;
      }
    }();
    _loading[id] = task;
    try {
      final sound = await task;
      return sound?.type == type ? sound : null;
    } finally {
      if (identical(_loading[id], task)) _loading.remove(id);
    }
  }

  void beginTurn(int turn) {
    if (_closed) return;
    _turn = turn;
    ++_epoch;
    _pending = _desired;
    _pendingEffect = 'none';
    _started = false;
    unawaited(_serial(() async {
      if (_effect.state == PlayerState.playing) await _effect.stop();
    }));
  }

  void select(int turn, String ambient, String effect) {
    if (_closed || turn != _turn || _started) return;
    _pending = ambient == 'none' || _isSound(ambient) ? ambient : _desired;
    _pendingEffect = _isSound(effect) ? effect : 'none';
    // Start downloads at the first metadata chunk; never delay TTS for them.
    if (_isSound(_pending)) unawaited(_load(_pending, 'ambient').then<void>((_) {}));
    if (_isSound(_pendingEffect)) unawaited(_load(_pendingEffect, 'effect').then<void>((_) {}));
    debugPrint('CALL_ENV_PLAN ambient=$_pending effect=$_pendingEffect');
  }

  void speechStarted(int turn) {
    if (_closed || turn != _turn || _started) return;
    _started = true;
    _suspended = false;
    _ducked = true;
    final epoch = ++_epoch;
    _desired = _pending;
    unawaited(_serial(() async {
      if (_valid(epoch) && _active >= 0 && !_paused) {
        await _ambient[_active].setVolume((_activeSound?.volume ?? 0) * _gain);
      }
    }));
    unawaited(_prepareAmbient(epoch, _desired));
    if (_isSound(_pendingEffect)) unawaited(_prepareEffect(epoch, _pendingEffect));
  }

  Future<void> _prepareAmbient(int epoch, String id) async {
    final sound = id == 'none' ? null : await _load(id, 'ambient');
    if (!_valid(epoch)) return;
    if (id != 'none' && sound == null) return;
    await _serial(() => _switchAmbient(epoch, sound));
  }

  Future<void> _switchAmbient(int epoch, _CallSound? sound) async {
    if (!_valid(epoch)) return;
    if (sound != null && _active >= 0 && _activeSound?.id == sound.id) {
      final p = _ambient[_active];
      if (_paused) {
        await configurePlayer(p);
        if (!_valid(epoch)) return;
        await p.setVolume(sound.volume * _gain);
        if (!_valid(epoch)) return;
        await p.resume();
        if (!_valid(epoch)) { await _safe(p.pause); return; }
        _paused = false;
      } else {
        await p.setVolume(sound.volume * _gain);
      }
      return;
    }
    final old = _active;
    final oldVolume = _activeSound?.volume ?? 0.0;
    final oldPaused = _paused;
    final next = sound == null ? -1 : (old == 0 ? 1 : 0);
    bool committed = false;
    try {
      if (next >= 0) {
        final p = _ambient[next];
        await p.stop();
        if (!_valid(epoch)) return;
        await configurePlayer(p);
        if (!_valid(epoch)) return;
        await p.setReleaseMode(ReleaseMode.loop);
        await p.setVolume(0);
        if (!_valid(epoch)) return;
        await p.play(sound!.source);
        if (!_valid(epoch)) return;
      }
      // Crossfade over ~300ms. Re-read gain each step so ducking remains valid.
      for (int step = 1; step <= 6; step++) {
        if (!_valid(epoch)) return;
        final fraction = step / 6;
        if (old >= 0 && !oldPaused) await _ambient[old].setVolume(oldVolume * _gain * (1 - fraction));
        if (next >= 0) await _ambient[next].setVolume(sound!.volume * _gain * fraction);
        if (step < 6) await Future<void>.delayed(const Duration(milliseconds: 60));
      }
      if (!_valid(epoch)) return;
      if (old >= 0) {
        await _ambient[old].stop();
        _active = -1;
        _activeSound = null;
        _paused = false;
      }
      if (!_valid(epoch)) return;
      _active = next;
      _activeSound = sound;
      _paused = false;
      committed = true;
      debugPrint('CALL_ENV_AMBIENT ${sound?.id ?? 'none'}');
    } finally {
      if (!committed) {
        if (next >= 0) await _safe(_ambient[next].stop);
        if (old >= 0 && _active == old && !_closed && !_suspended && !_paused) {
          await _safe(() => _ambient[old].setVolume(oldVolume * _gain));
        }
      }
    }
  }

  Future<void> _prepareEffect(int epoch, String id) async {
    final sound = await _load(id, 'effect');
    if (sound == null || !_valid(epoch) || !_started) return;
    await _serial(() async {
      if (!_valid(epoch) || !_started) return;
      await _effect.stop();
      await configurePlayer(_effect);
      await _effect.setReleaseMode(ReleaseMode.release);
      await _effect.setVolume(sound.volume);
      if (!_valid(epoch) || !_started) return;
      await _effect.play(sound.source);
      if (!_valid(epoch)) await _safe(_effect.stop);
      else debugPrint('CALL_ENV_EFFECT $id');
    });
  }

  void finishTurn(int turn) {
    if (_closed || turn != _turn) return;
    _started = false; // No late new effects after the voice turn.
    _ducked = false;
    unawaited(_serial(() async {
      if (!_closed && !_suspended && _active >= 0 && !_paused) {
        await _ambient[_active].setVolume((_activeSound?.volume ?? 0) * _gain);
      }
    }));
  }

  void interrupt() {
    if (_closed) return;
    ++_epoch;
    _turn = -1;
    _started = false;
    _ducked = false;
    unawaited(_serial(() async {
      if (_closed) return;
      await _effect.stop();
      if (!_suspended && _active >= 0 && !_paused) {
        await _ambient[_active].setVolume((_activeSound?.volume ?? 0) * _gain);
      }
    }));
  }

  // Native speech_to_text has no reliable per-device simultaneous playback
  // guarantee. Pause ambience before it opens the mic; resume at the next voice.
  Future<void> suspend() {
    if (_closed) return Future<void>.value();
    _suspended = true;
    ++_epoch;
    // Pause whatever is currently audible immediately, even if a fade is queued.
    final immediate = Future.wait([_safe(_effect.stop),
      for (final p in _ambient) if (p.state == PlayerState.playing) _safe(p.pause)]);
    return _serial(() async {
      await immediate;
      if (_closed) return;
      await _safe(_effect.stop);
      if (_active >= 0 && !_paused) {
        final player = _ambient[_active];
        try {
          if (player.state == PlayerState.playing) await player.pause();
          if (player.state == PlayerState.paused) {
            _paused = true;
          } else {
            await _safe(player.stop);
            _active = -1;
            _activeSound = null;
          }
        } catch (_) {
          await _safe(player.stop);
          _active = -1;
          _activeSound = null;
        }
      }
    });
  }

  Future<void> updateRoute() => _serial(() async {
    if (_closed) return;
    if (_active >= 0 && !_paused) await configurePlayer(_ambient[_active]);
    if (!_suspended && _effect.state == PlayerState.playing) await configurePlayer(_effect);
  });

  Future<void> close() {
    final closing = _closeTask;
    if (closing != null) return closing;
    _closed = true;
    ++_epoch;
    _cache.clear();
    _cachedBytes = 0;
    // Stop immediately, then stop again after any already-started async play.
    final immediate = Future.wait([for (final p in [..._ambient, _effect]) _safe(p.stop)]);
    final task = _serial(() async {
      await immediate;
      for (final p in [..._ambient, _effect]) {
        await _safe(p.stop);
        await _safe(p.dispose);
      }
    });
    _closeTask = task;
    return task;
  }
}

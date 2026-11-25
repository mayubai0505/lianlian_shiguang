import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Internal V4 Agent transport. The long-lived API key never leaves Functions.
/// One owned chat room, one signed URL, one microphone and one PCM player.
/// No recording files are created. Do not log URLs, prompts or transcripts.
class CallAgentRealtime {
  static const _sampleRate = 16000;
  static const _bytesPerSecond = _sampleRate * 2;
  static const _maxQueuedBytes = _bytesPerSecond * 16;
  static const _chunkBytes = 1600; // 50 ms mono PCM16
  final AudioRecorder _recorder = AudioRecorder();
  final fs.FlutterSoundPlayer _player = fs.FlutterSoundPlayer();
  static const _androidAudio = MethodChannel('lianlian/call_pcm_v41');
  bool get _usesAndroidPcm => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  String? _androidCallId;
  Future<void> _android(String method, [Map<String, Object?> args = const {}]) async {
    await _androidAudio.invokeMethod<void>(method, {'callId': _androidCallId, ...args});
  }

  Future<void> _openPlayback(String callId) async {
    if (_usesAndroidPcm) {
      _androidCallId = callId;
      await _android('open', {'speaker': _speaker});
    } else {
      await _player.openPlayer();
    }
    _opened = true;
  }

  Future<void> _startPlayback() async {
    if (_usesAndroidPcm) {
      await _android('start');
    } else {
      await _player.startPlayerFromStream(codec: fs.Codec.pcm16,
        interleaved: true, numChannels: 1, sampleRate: _sampleRate, bufferSize: 2048);
    }
  }

  Future<void> _feedPlayback(Uint8List pcm) async {
    if (_usesAndroidPcm) {
      await _android('feed', {'pcm': pcm});
    } else {
      await _player.feedUint8FromStream(pcm);
    }
  }

  Future<void> _stopPlayback() async {
    if (_usesAndroidPcm) {
      await _android('flush');
    } else {
      await _player.stopPlayer();
    }
  }

  Future<void> _closePlayback() async {
    if (_usesAndroidPcm) {
      // Recorder has already been disposed; restore the system route last.
      if (_androidCallId != null) await _android('close');
      _androidCallId = null;
    } else if (_opened) {
      try { await _player.stopPlayer(); } finally { await _player.closePlayer(); }
    }
  }
  final Queue<Uint8List> _audio = Queue<Uint8List>();
  final Map<String, String> _soundTypes = <String, String>{};
  WebSocketChannel? _socket;
  StreamSubscription<dynamic>? _socketSub;
  StreamSubscription<Uint8List>? _micSub;
  Completer<void>? _handshake;
  Future<void> _micTail = Future<void>.value();
  Future<void> _playerReset = Future<void>.value();
  Future<void>? _startTask, _closeTask, _pumpTask;
  Completer<void> _generationChanged = Completer<void>();
  Timer? _quietTimer;
  bool _closed = false, _connected = false, _failed = false;
  bool _opened = false, _streamStarted = false, _draining = false;
  bool _recording = false, _muted = false, _speaker = true;
  bool _speaking = false, _oneShotUsed = false, _firstAudioPlayed = false;
  int _queuedBytes = 0, _generation = 0;
  int? _interruptedEventId;
  DateTime? _playUntil, _lastTypedAt;
  String? _lastTyped;
  late final void Function() _onConnected, _onInterrupted, _onFirstAudioPlayed;
  late final Future<void> Function() _onFirstAudioReady;
  late final void Function(String) _onUser, _onAgent, _onDisconnected;
  late final void Function(String, String) _onCorrection, _onEnvironment;
  late final void Function(bool) _onSpeaking;

  bool get connected => _connected && !_closed && !_failed;
  bool get _active => !_closed && !_failed;

  Future<void> start({
    required String callId,
    required String sessionId,
    required String characterId,
    String? agreementId,
    required bool speaker,
    required void Function() onConnected,
    required Future<void> Function() onFirstAudioReady,
    required void Function() onFirstAudioPlayed,
    required void Function() onInterrupted,
    required void Function(String) onUser,
    required void Function(String) onAgent,
    required void Function(String, String) onCorrection,
    required void Function(String, String) onEnvironment,
    required void Function(bool) onSpeaking,
    required void Function(String) onDisconnected,
  }) {
    if (_startTask != null) return _startTask!;
    _speaker = speaker;
    _onConnected = onConnected;
    _onFirstAudioReady = onFirstAudioReady;
    _onFirstAudioPlayed = onFirstAudioPlayed;
    _onInterrupted = onInterrupted;
    _onUser = onUser;
    _onAgent = onAgent;
    _onCorrection = onCorrection;
    _onEnvironment = onEnvironment;
    _onSpeaking = onSpeaking;
    _onDisconnected = onDisconnected;
    final task = _start(callId, sessionId, characterId, agreementId);
    _startTask = task;
    return task;
  }

  Future<void> _start(String callId, String sessionId, String characterId, String? agreementId) async {
    try {
      if (!await _recorder.hasPermission()) {
        throw StateError('microphone_permission');
      }
      if (!_active) return;
      final authorization = FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('prepareCallRealtimeV41Us', options: HttpsCallableOptions(
            timeout: const Duration(seconds: 95),
          )).call({'callId': callId, 'sessionId': sessionId, 'characterId': characterId,
             if (agreementId != null) 'agreementId': agreementId});
      // Start opening PCM playback while the backend prepares the signed URL.
      final playerReady = () async {
        await _openPlayback(callId);
        return null;
      }();
      final results = await Future.wait<dynamic>([authorization, playerReady]);
      final result = results.first;
      if (!_active) return;
      final data = result.data;
      if (data is! Map || data['signedUrl'] is! String || data['initiation'] is! Map ||
          data['maxDurationSeconds'] != 60) {
        throw StateError('invalid_authorization');
      }
      final uri = Uri.parse(data['signedUrl'] as String);
      if (uri.scheme != 'wss' || uri.host != 'api.elevenlabs.io' ||
          uri.path != '/v1/convai/conversation' || uri.userInfo.isNotEmpty) {
        throw StateError('invalid_socket_host');
      }
      final catalog = data['catalog'];
      if (catalog is List) {
        for (final item in catalog.whereType<Map>()) {
          final id = item['id'], type = item['type'];
          if (id is String && (type == 'ambient' || type == 'effect')) {
            _soundTypes[id] = type as String;
          }
        }
      }
      if (!_active) return;
      // Establish native recording before the Agent begins its first utterance.
      // Audio is dropped locally until the first playable PCM chunk is accepted.
      await _serialMic(_restartMic);
      if (!_active) return;
      final handshake = Completer<void>();
      _handshake = handshake;
      // Attach an error handler immediately, as a close can arrive before ready.
      unawaited(handshake.future.then<void>((_) {}, onError: (Object _, StackTrace __) {}));
      final socket = WebSocketChannel.connect(uri);
      _socket = socket;
      _socketSub = socket.stream.listen(_receive,
          onError: (Object _, StackTrace __) => _fail('socket_error'),
          onDone: () => _fail('socket_closed'));
      await socket.ready.timeout(const Duration(seconds: 10));
      if (!_active) return;
      _send(Map<String, dynamic>.from(data['initiation'] as Map));
      await handshake.future.timeout(const Duration(seconds: 12));
    } catch (_) {
      // Cleanup happens in the caller's finalizer or onDisconnected callback.
      // Re-throw without printing the exception: HTTP/WS errors can contain URLs.
      _failed = true;
      rethrow;
    }
  }

  void _send(Map<String, dynamic> data) {
    if (!_active || _socket == null) return;
    try {
      _socket!.sink.add(jsonEncode(data));
    } catch (_) { _fail('socket_send'); }
  }

  void _receive(dynamic raw) {
    if (!_active) return;
    try {
      final decoded = jsonDecode(raw is String ? raw : utf8.decode(raw as List<int>));
      if (decoded is! Map) return;
      switch (decoded['type']) {
        case 'conversation_initiation_metadata':
          final meta = decoded['conversation_initiation_metadata_event'];
          if (meta is! Map || meta['agent_output_audio_format'] != 'pcm_16000' ||
              meta['user_input_audio_format'] != 'pcm_16000') {
            _fail('unexpected_pcm_format');
            return;
          }
          if (_connected) return;
          _connected = true;
          if (_handshake?.isCompleted == false) _handshake!.complete();
          debugPrint('CALL_V4_CONNECTED pcm_16000');
          _onConnected();
          break;
        case 'ping':
          final ping = decoded['ping_event'];
          if (ping is Map && ping['event_id'] is int) {
            _send({'type': 'pong', 'event_id': ping['event_id']});
          }
          break;
        case 'audio':
          if (!connected) return;
          final event = decoded['audio_event'];
          if (event is! Map || event['audio_base_64'] is! String) return;
          final id = event['event_id'];
          if (_interruptedEventId != null && id is int && id <= _interruptedEventId!) return;
          final encoded = event['audio_base_64'] as String;
          if (encoded.length > (_maxQueuedBytes * 4 ~/ 3 + 8)) {
            _fail('audio_buffer_limit'); return;
          }
          final pcm = base64Decode(encoded);
          if (pcm.isEmpty || pcm.length.isOdd) return;
          if (_queuedBytes + pcm.length > _maxQueuedBytes) {
            _fail('audio_buffer_limit'); return;
          }
          for (var i = 0; i < pcm.length; i += _chunkBytes) {
            final end = (i + _chunkBytes < pcm.length) ? i + _chunkBytes : pcm.length;
            _audio.add(Uint8List.sublistView(pcm, i, end));
          }
          _queuedBytes += pcm.length;
          _quietTimer?.cancel();
          _pump();
          break;
        case 'interruption':
          final event = decoded['interruption_event'];
          if (event is Map && event['event_id'] is int) {
            final n = event['event_id'] as int;
            if (_interruptedEventId == null || n > _interruptedEventId!) _interruptedEventId = n;
          }
          _flushAudio();
          _onInterrupted();
          debugPrint('CALL_V4_INTERRUPTED');
          break;
        case 'user_transcript':
          final event = decoded['user_transcription_event'];
          final text = event is Map ? _text(event['user_transcript']) : '';
          if (text.isEmpty) return;
          _oneShotUsed = false;
          if (_lastTyped == text && _lastTypedAt != null &&
              DateTime.now().difference(_lastTypedAt!) < const Duration(seconds: 5)) {
            _lastTyped = null; _lastTypedAt = null; return;
          }
          _onUser(text);
          break;
        case 'agent_response':
          final event = decoded['agent_response_event'];
          final text = event is Map ? _text(event['agent_response']) : '';
          if (text.isNotEmpty) _onAgent(text);
          break;
        case 'agent_response_correction':
          final event = decoded['agent_response_correction_event'];
          if (event is Map) _onCorrection(_text(event['original_agent_response']), _text(event['corrected_agent_response']));
          break;
        case 'agent_response_complete':
          // Completion is generation-complete, not playback-complete.
          // Actual silence is determined by the native PCM buffer estimate.
          break;
        case 'client_tool_call':
          final tool = decoded['client_tool_call'];
          if (tool is Map) _tool(tool);
          break;
        case 'client_error':
        case 'error':
          _fail('provider_error');
          break;
        default:
          break;
      }
    } catch (_) { _fail('event_decode'); }
  }

  String _text(Object? v) {
    if (v is! String) return '';
    return v.replaceAll(RegExp(r'\[(?:laughs?|chuckles?|sighs?|whispers?|breathes?|pauses?|giggles?|clears throat|softly|sadly|excited)[^\]]{0,30}\]', caseSensitive: false), '').trim();
  }

  void _tool(Map tool) {
    if (!connected) return;
    bool ok = false;
    final parameters = tool['parameters'];
    if (tool['tool_name'] == 'lianlian_call_environment_v4' && parameters is Map) {
      final rawAmbient = parameters['ambient'], rawEffect = parameters['effect'];
      final ambient = rawAmbient is String &&
          (rawAmbient == 'none' || rawAmbient == 'keep' || _soundTypes[rawAmbient] == 'ambient')
          ? rawAmbient : 'keep';
      final effect = rawEffect is String && !_oneShotUsed && _soundTypes[rawEffect] == 'effect'
          ? rawEffect : 'none';
      if (effect != 'none') _oneShotUsed = true;
      _onEnvironment(ambient, effect);
      ok = true;
    }
    if (tool['expects_response'] == true && tool['tool_call_id'] is String) {
      _send({'type': 'client_tool_result', 'tool_call_id': tool['tool_call_id'],
        'is_error': !ok, 'result': ok ? 'ok' : 'unsupported tool'});
    }
  }

  void sendText(String value) {
    final text = value.trim();
    if (!connected || !_firstAudioPlayed || text.isEmpty || text.length > 2000) return;
    _lastTyped = text; _lastTypedAt = DateTime.now();
    _oneShotUsed = false;
    _onUser(text);
    _send({'type': 'user_message', 'text': text});
  }

  Future<void> _serialMic(Future<void> Function() action) {
    final task = _micTail.then((_) => action());
    _micTail = task.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return task;
  }

  Future<void> _stopMic() async {
    final sub = _micSub; _micSub = null;
    await sub?.cancel();
    if (_recording) {
      _recording = false;
      await _recorder.stop();
    }
  }

  Future<void> _restartMic() async {
    await _stopMic();
    if (!_active) return;
    if (_muted) {
      if (_usesAndroidPcm && _opened) await _android('route', {'speaker': _speaker});
      return;
    }
    final stream = await _recorder.startStream(RecordConfig(
      encoder: AudioEncoder.pcm16bits, sampleRate: _sampleRate, numChannels: 1,
      echoCancel: true, noiseSuppress: true, autoGain: true,
      androidConfig: AndroidRecordConfig(audioSource: AndroidAudioSource.voiceCommunication,
        speakerphone: _speaker, audioManagerMode: AudioManagerMode.modeInCommunication),
      iosConfig: IosRecordConfig(categoryOptions: [
        if (_speaker) IosAudioCategoryOption.defaultToSpeaker, IosAudioCategoryOption.allowBluetooth,
      ]),
    ));
    _recording = true;
    if (!_active || _muted) { await _stopMic(); return; }
    _micSub = stream.listen((bytes) {
      if (!connected || !_firstAudioPlayed || _muted || bytes.isEmpty) return;
      _send({'user_audio_chunk': base64Encode(bytes)});
    }, onError: (Object _, StackTrace __) => _fail('mic_stream_error'),
       onDone: () { if (_active && _recording && !_muted) _fail('mic_stream_closed'); });
    if (_usesAndroidPcm && _opened && _active) {
      await _android('route', {'speaker': _speaker});
    }
  }

  Future<void> setMuted(bool muted) async {
    _muted = muted;
    if (!_active) return;
    try { await _serialMic(_restartMic); }
    catch (_) { _fail('mic_mute_error'); }
  }

  Future<void> refreshAndroidRoute() async {
    if (!_usesAndroidPcm || !_active || !_opened) return;
    await _serialMic(() async {
      if (_active && _opened) await _android('route', {'speaker': _speaker});
    });
  }

  Future<void> setSpeaker(bool speaker) async {
    final previous = _speaker;
    _speaker = speaker;
    if (!_active) return;
    if (_usesAndroidPcm) {
      try {
        // Communication-device selection routes both capture and playback.
        // Keep the microphone and PCM stream running while switching.
        await _serialMic(() async {
          if (_active && _opened) await _android('route', {'speaker': speaker});
        });
      } catch (_) {
        _speaker = previous;
        if (_active && _opened) {
          try { await _android('route', {'speaker': previous}); } catch (_) {}
        }
        rethrow;
      }
      return;
    }
    try { await _serialMic(_restartMic); }
    catch (_) { _fail('mic_route_error'); }
  }

  void _markSpeaking(bool v) {
    if (_speaking == v) return;
    _speaking = v;
    if (_active) _onSpeaking(v);
  }

  void _pump() {
    if (!_active || _draining || _audio.isEmpty) return;
    _draining = true;
    final task = () async {
      try {
        while (_active && _audio.isNotEmpty) {
          final generation = _generation;
          final interrupted = _generationChanged.future;
          await _playerReset;
          if (!_active || generation != _generation) continue;
          if (!_streamStarted) {
            await _startPlayback();
            _streamStarted = true;
            if (!_active || generation != _generation) {
              await _stopPlayback(); _streamStarted = false; continue;
            }
          }
          if (_audio.isEmpty) break;
          final pcm = _audio.removeFirst(); _queuedBytes -= pcm.length;
          if (!_firstAudioPlayed) {
            await _onFirstAudioReady();
            if (!_active || generation != _generation) continue;
            await refreshAndroidRoute();
            if (!_active || generation != _generation) continue;
          }
          final now = DateTime.now();
          final base = _playUntil != null && _playUntil!.isAfter(now) ? _playUntil! : now;
          _playUntil = base.add(Duration(microseconds: pcm.length * 1000000 ~/ _bytesPerSecond));
          // Documented flow-control primitive. StopPlayer on interruption also
          // clears already queued native PCM. Epoch ignores obsolete completions.
          try {
            final feed = _feedPlayback(pcm);
            // A stop can strand an in-flight native feed. Do not wait for its
            // timeout before playing the next response; the reset gates playback.
            await Future.any<void>([feed, interrupted]).timeout(const Duration(seconds: 4));
            if (!_active || generation != _generation) continue;
            if (!_firstAudioPlayed) {
              _firstAudioPlayed = true;
              debugPrint('CALL_V41_FIRST_PCM');
              _onFirstAudioPlayed();
            }
            _markSpeaking(true);
          } catch (_) {
            if (!_active || generation != _generation) continue;
            rethrow;
          }
        }
      } catch (_) { if (_active) _fail('pcm_playback_error'); }
      finally {
        _draining = false;
        if (_active && _audio.isNotEmpty) { _pump(); }
        else if (_active && _speaking) {
          final wait = (_playUntil ?? DateTime.now()).difference(DateTime.now());
          _quietTimer?.cancel();
          _quietTimer = Timer((wait.isNegative ? Duration.zero : wait) + const Duration(milliseconds: 120), () {
            if (_active && !_draining && _audio.isEmpty) _markSpeaking(false);
          });
        }
      }
    }();
    _pumpTask = task;
    unawaited(task);
  }

  void _flushAudio() {
    _generation++;
    if (!_generationChanged.isCompleted) _generationChanged.complete();
    _generationChanged = Completer<void>();
    _audio.clear(); _queuedBytes = 0; _playUntil = null;
    _quietTimer?.cancel();
    _markSpeaking(false);
    // Initiate native stop immediately, rather than waiting behind queued PCM.
    final hadStream = _streamStarted;
    _streamStarted = false;
    final previous = _playerReset;
    _playerReset = () async {
      await previous;
      if (_opened && hadStream) {
        try { await _stopPlayback(); } catch (_) { if (_active) _fail('pcm_interrupt_error'); }
      }
    }();
  }

  void _fail(String reason) {
    if (!_active) return;
    final wasConnected = _connected;
    _failed = true; _connected = false;
    if (_handshake?.isCompleted == false) _handshake!.completeError(StateError(reason));
    debugPrint('CALL_V4_DISCONNECTED $reason');
    // Caller handles UI, never prints token-bearing URLs or raw events.
    if (wasConnected) _onDisconnected(reason);
    unawaited(close());
  }

  Future<void> close() {
    final existing = _closeTask;
    if (existing != null) return existing;
    _closed = true; _connected = false;
    if (_handshake?.isCompleted == false) _handshake!.completeError(StateError('call_closed'));
    _flushAudio();
    final task = () async {
      final socket = _socket; _socket = null;
      try { await socket?.sink.close(1000).timeout(const Duration(seconds: 2)); } catch (_) {}
      try { await _socketSub?.cancel(); } catch (_) {} _socketSub = null;
      // Wait for opening a native device to settle, but not a slow Callable
      // before closing the already-established socket/mic. Never restart it.
      try { await _serialMic(_stopMic); } catch (_) {}
      try { await _startTask; } catch (_) {}
      try { await _serialMic(_stopMic); } catch (_) {}
      try { await _recorder.dispose(); } catch (_) {}
      try { await _playerReset; } catch (_) {}
      try { await _pumpTask; } catch (_) {}
      if (_opened || _androidCallId != null) {
        try { await _closePlayback(); } catch (_) {}
        _opened = false;
      }
      _soundTypes.clear();
    }();
    _closeTask = task;
    return task;
  }
}

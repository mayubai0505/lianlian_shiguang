import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Internal PCM transport. No audio file is created. Tokens are single use;
/// neither the long-lived API key nor raw transcripts are written to logs.
class CallRealtimeInput {
  Future<void> _tail = Future<void>.value();
  int _epoch = 0;
  AudioRecorder? _recorder;
  WebSocketChannel? _socket;
  StreamSubscription<Uint8List>? _pcmSub;
  StreamSubscription<dynamic>? _socketSub;
  bool _running = false;

  Future<void> _serial(Future<void> Function() fn) {
    final next = _tail.then((_) => fn());
    _tail = next.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return next;
  }

  Future<void> start({
    required String sessionId,
    required String characterId,
    required bool speaker,
    required void Function(String) onPartial,
    required void Function(String) onCommitted,
    required void Function() onDisconnected,
  }) {
    final id = ++_epoch;
    return _serial(() async {
      await _release();
      if (id != _epoch) return;
      final recorder = AudioRecorder();
      _recorder = recorder;
      try {
        if (!await recorder.hasPermission()) {
          throw StateError('microphone unavailable');
        }
        if (id != _epoch) return;
        final result = await FirebaseFunctions.instanceFor(region: 'us-central1')
            .httpsCallable('createCallRealtimeTokenUs', options: HttpsCallableOptions(timeout: const Duration(seconds: 16)))
            .call({'sessionId': sessionId, 'characterId': characterId});
        if (id != _epoch) return;
        final data = result.data;
        final token = data is Map ? data['token'] : null;
        if (token is! String || token.isEmpty) throw StateError('token missing');
        final socket = WebSocketChannel.connect(Uri.https('api.elevenlabs.io',
            '/v1/speech-to-text/realtime', {
          'token': token,
          'model_id': 'scribe_v2_realtime',
          'audio_format': 'pcm_16000',
          'commit_strategy': 'vad',
          'vad_silence_threshold_secs': '0.55',
          'min_speech_duration_ms': '150',
          'min_silence_duration_ms': '250',
          'vad_threshold': '0.20',
          'filter_background_audio': 'true',
        }).replace(scheme: 'wss'));
        _socket = socket;
        final ready = Completer<bool>();
        bool disconnected = false;
        void fail() {
          if (disconnected || id != _epoch) return;
          disconnected = true;
          if (!ready.isCompleted) ready.complete(false);
          if (_running) {
            _running = false;
            onDisconnected();
          }
        }
        _socketSub = socket.stream.listen((event) {
          if (id != _epoch || disconnected) return;
          try {
            final value = jsonDecode(event is String ? event : utf8.decode(event as List<int>));
            if (value is! Map) return;
            final type = value['message_type'];
            if (type == 'session_started') {
              if (!ready.isCompleted) ready.complete(true);
              return;
            }
            if (type == 'warning') return;
            if (type == 'partial_transcript' || type == 'committed_transcript') {
              if (!_running) return;
              final text = value['text']?.toString().trim() ?? '';
              if (type == 'partial_transcript') onPartial(text);
              else if (text.isNotEmpty) onCommitted(text);
              return;
            }
            // Unknown/error events cannot become a transcript. A server error
            // carrying an error field terminates this transport, not the call.
            if (value.containsKey('error') || type == 'error' || type == 'rate_limited' ||
                type == 'quota_exceeded' || type == 'auth_error') fail();
          } catch (_) { fail(); }
        }, onError: (Object _, StackTrace __) => fail(), onDone: fail);
        await socket.ready.timeout(const Duration(seconds: 8));
        if (!await ready.future.timeout(const Duration(seconds: 8)) || disconnected) {
          throw StateError('realtime handshake failed');
        }
        if (id != _epoch) return;
        final stream = await recorder.startStream(RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
          echoCancel: true,
          noiseSuppress: true,
          autoGain: true,
          androidConfig: AndroidRecordConfig(
            audioSource: AndroidAudioSource.voiceCommunication,
            speakerphone: speaker,
            audioManagerMode: AudioManagerMode.modeInCommunication,
          ),
          iosConfig: IosRecordConfig(categoryOptions: [
            if (speaker) IosAudioCategoryOption.defaultToSpeaker,
            IosAudioCategoryOption.allowBluetooth,
          ]),
        ));
        if (id != _epoch || disconnected) {
          await _release();
          if (disconnected) throw StateError('realtime disconnected');
          return;
        }
        _running = true;
        final meter = Stopwatch()..start();
        int pcmPeak = 0;
        int pcmSamples = 0;
        _pcmSub = stream.listen((bytes) {
          if (id != _epoch || !_running || bytes.isEmpty) return;
          try {
            final pcm = ByteData.sublistView(bytes);
            for (int i = 0; i + 1 < bytes.length; i += 2) {
              final sample = pcm.getInt16(i, Endian.little).abs();
              if (sample > pcmPeak) pcmPeak = sample;
              pcmSamples++;
            }
            if (meter.elapsedMilliseconds >= 2000) {
              // No audio or transcript is logged.
              print('CALL_MIC_LEVEL peak=$pcmPeak samples=$pcmSamples');
              meter.reset();
              pcmPeak = 0;
              pcmSamples = 0;
            }
            socket.sink.add(jsonEncode({
              'message_type': 'input_audio_chunk',
              'audio_base_64': base64Encode(bytes),
              'sample_rate': 16000,
            }));
          } catch (_) { fail(); }
        }, onError: (Object _, StackTrace __) => fail(), onDone: fail);
      } catch (_) {
        await _release();
        rethrow;
      } finally {
        if (id != _epoch) await _release();
      }
    });
  }

  Future<void> stop() {
    ++_epoch; // Block outgoing audio immediately, even while start is pending.
    _running = false;
    return _serial(_release);
  }

  Future<void> _safe(Future<dynamic> Function() fn) async {
    try { await fn().timeout(const Duration(seconds: 3)); } catch (_) {}
  }

  Future<void> _release() async {
    _running = false;
    final pcm = _pcmSub; _pcmSub = null;
    final ws = _socket; _socket = null;
    final sub = _socketSub; _socketSub = null;
    final recorder = _recorder; _recorder = null;
    if (pcm != null) await _safe(pcm.cancel);
    if (recorder != null) {
      await _safe(recorder.stop);
      await _safe(recorder.dispose);
    }
    if (sub != null) await _safe(sub.cancel);
    if (ws != null) await _safe(() async { await ws.sink.close(); });
  }
}

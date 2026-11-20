package com.yubaimo.lianlian_shiguang

import android.app.Activity
import android.content.Context
import android.media.AudioAttributes
import android.media.AudioDeviceInfo
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Android V4.1 only: one voice-communication PCM track per call.
 * All methods and nonblocking write retries are serialized on the UI looper.
 * No microphone data, audio bytes, URLs or transcripts are logged.
 */
class CallPcmAudioBridge(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "lianlian/call_pcm_v41")
    private val manager = activity.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    private val handler = Handler(Looper.getMainLooper())
    private var owner: String? = null
    private var track: AudioTrack? = null
    private var pending: Write? = null
    private var savedMode = AudioManager.MODE_NORMAL
    private var savedVolumeStream = AudioManager.USE_DEFAULT_STREAM_TYPE
    private var savedSpeaker = false
    private var savedDeviceId: Int? = null
    private var routeSaved = false

    private class Write(val bytes: ByteArray, val result: MethodChannel.Result) {
        var offset = 0
        val deadline = SystemClock.elapsedRealtime() + 3000
    }

    init {
        channel.setMethodCallHandler { call, result ->
            try {
                val id = call.argument<String>("callId")
                if (id.isNullOrBlank()) {
                    result.error("invalid_call", "Missing call ID", null)
                    return@setMethodCallHandler
                }
                if (call.method == "open") {
                    open(id, call.argument<Boolean>("speaker") ?: true)
                    result.success(null)
                    return@setMethodCallHandler
                }
                // A delayed close from an old call must never affect a new call.
                if (owner != id) {
                    if (call.method == "close" || call.method == "flush") result.success(null)
                    else result.error("inactive_call", "Audio session not active", null)
                    return@setMethodCallHandler
                }
                when (call.method) {
                    "start" -> {
                        val t = track ?: error("Missing PCM track")
                        if (t.playState != AudioTrack.PLAYSTATE_PLAYING) t.play()
                        result.success(null)
                    }
                    "route" -> {
                        route(call.argument<Boolean>("speaker") ?: true)
                        result.success(null)
                    }
                    "feed" -> {
                        val data = call.argument<ByteArray>("pcm")
                        if (data == null || data.isEmpty() || data.size > 1600 || data.size % 2 != 0) {
                            result.error("invalid_pcm", "Invalid PCM chunk", null)
                        } else if (pending != null) {
                            result.error("pcm_busy", "PCM write already pending", null)
                        } else {
                            val write = Write(data, result)
                            pending = write
                            attempt(write)
                        }
                    }
                    "flush" -> {
                        flush()
                        result.success(null)
                    }
                    "close" -> {
                        release()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                Log.w("CallPcmV41", "Audio operation failed: ${call.method} / ${e.javaClass.simpleName}")
                result.error("audio_operation", "Call audio operation failed", null)
            }
        }
    }

    @Suppress("DEPRECATION")
    private fun open(id: String, speaker: Boolean) {
        if (owner == id && track != null) {
            route(speaker)
            return
        }
        check(owner == null) { "Previous call still closing" }
        savedMode = manager.mode
        savedVolumeStream = activity.volumeControlStream
        savedSpeaker = manager.isSpeakerphoneOn
        savedDeviceId = if (Build.VERSION.SDK_INT >= 31) manager.communicationDevice?.id else null
        routeSaved = true
        owner = id
        try {
            route(speaker)
            val size = AudioTrack.getMinBufferSize(16000, AudioFormat.CHANNEL_OUT_MONO,
                AudioFormat.ENCODING_PCM_16BIT)
            check(size > 0) { "PCM format not supported" }
            val t = AudioTrack.Builder()
                .setAudioAttributes(AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build())
                .setAudioFormat(AudioFormat.Builder()
                    .setSampleRate(16000)
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build())
                .setTransferMode(AudioTrack.MODE_STREAM)
                .setBufferSizeInBytes(maxOf(size, 3200))
                .build()
            track = t
            check(t.state == AudioTrack.STATE_INITIALIZED) { "PCM init failed" }
            // Modest fixed attenuation, not dynamic normalization.
            // The phone's voice-call volume remains independently adjustable.
            check(t.setVolume(0.75f) == AudioTrack.SUCCESS) { "PCM gain failed" }
            Log.i("CallPcmV41", "CALL_V41_ANDROID_PCM_READY gain=0.75")
        } catch (e: Exception) {
            release()
            throw e
        }
    }

    @Suppress("DEPRECATION")
    private fun route(speaker: Boolean) {
        manager.mode = AudioManager.MODE_IN_COMMUNICATION
        activity.volumeControlStream = AudioManager.STREAM_VOICE_CALL
        if (Build.VERSION.SDK_INT >= 31) {
            val devices = manager.availableCommunicationDevices
            // Speaker off: keep a connected headset when available, else earpiece.
            val selected = if (speaker) {
                devices.firstOrNull { it.type == AudioDeviceInfo.TYPE_BUILTIN_SPEAKER }
            } else {
                val headsetTypes = setOf(AudioDeviceInfo.TYPE_WIRED_HEADSET,
                    AudioDeviceInfo.TYPE_WIRED_HEADPHONES, AudioDeviceInfo.TYPE_BLUETOOTH_SCO,
                    AudioDeviceInfo.TYPE_USB_HEADSET, AudioDeviceInfo.TYPE_BLE_HEADSET)
                devices.firstOrNull { it.type in headsetTypes }
                    ?: devices.firstOrNull { it.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE }
            }
            if (selected != null) {
                check(manager.setCommunicationDevice(selected)) { "Route rejected" }
            } else if (!speaker) {
                // Tablets without an earpiece may fall back to their default route.
                manager.clearCommunicationDevice()
            } else {
                error("No speaker route")
            }
            Log.i("CallPcmV41", "CALL_V41_AUDIO_ROUTE speaker=$speaker device=${manager.communicationDevice?.type}")
        } else {
            manager.isSpeakerphoneOn = speaker
            Log.i("CallPcmV41", "CALL_V41_AUDIO_ROUTE speaker=$speaker legacy")
        }
    }

    private fun attempt(write: Write) {
        if (pending !== write) return
        try {
            val t = track ?: error("Missing PCM track")
            check(t.playState == AudioTrack.PLAYSTATE_PLAYING) { "PCM not playing" }
            val count = t.write(write.bytes, write.offset, write.bytes.size - write.offset,
                AudioTrack.WRITE_NON_BLOCKING)
            check(count >= 0) { "AudioTrack write failed" }
            write.offset += count
            if (write.offset == write.bytes.size) {
                pending = null
                write.result.success(null)
            } else if (SystemClock.elapsedRealtime() >= write.deadline) {
                pending = null
                write.result.error("pcm_timeout", "PCM write timeout", null)
            } else {
                handler.postDelayed({ attempt(write) }, 5)
            }
        } catch (e: Exception) {
            pending = null
            write.result.error("pcm_write", "PCM write failed", null)
        }
    }

    private fun flush() {
        val write = pending
        pending = null
        // Complete instead of leaving a Dart method call stranded on interruption.
        write?.result?.success(null)
        val t = track ?: return
        if (t.playState == AudioTrack.PLAYSTATE_PLAYING) t.pause()
        t.flush()
    }

    @Suppress("DEPRECATION")
    private fun release() {
        try { flush() } catch (_: Exception) {}
        val t = track
        track = null
        try { t?.release() } catch (_: Exception) {}
        if (routeSaved) {
            if (Build.VERSION.SDK_INT >= 31) {
                try {
                    manager.clearCommunicationDevice()
                    val old = manager.availableCommunicationDevices.firstOrNull { it.id == savedDeviceId }
                    if (old != null && savedMode == AudioManager.MODE_IN_COMMUNICATION) {
                        manager.setCommunicationDevice(old)
                    }
                } catch (_: Exception) {}
            } else {
                try { manager.isSpeakerphoneOn = savedSpeaker } catch (_: Exception) {}
            }
            try { manager.mode = savedMode } catch (_: Exception) {}
            try { activity.volumeControlStream = savedVolumeStream } catch (_: Exception) {}
        }
        routeSaved = false
        owner = null
        Log.i("CallPcmV41", "CALL_V41_AUDIO_CLOSED")
    }

    /** Call from MainActivity.cleanUpFlutterEngine before super. */
    fun dispose() {
        release()
        channel.setMethodCallHandler(null)
        handler.removeCallbacksAndMessages(null)
    }
}

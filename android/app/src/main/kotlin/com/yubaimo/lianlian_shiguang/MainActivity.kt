package com.yubaimo.lianlian_shiguang

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var callPcmAudioBridge: CallPcmAudioBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callPcmAudioBridge?.dispose()
        callPcmAudioBridge = CallPcmAudioBridge(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        callPcmAudioBridge?.dispose()
        callPcmAudioBridge = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}

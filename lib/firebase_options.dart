import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBg3fe_ZSEgzsIYDSqzAISOPKesbkLIjP4',
    appId: '1:892791360631:android:aa3288f48c9d4600db4a72',
    messagingSenderId: '892791360631',
    projectId: 'lianlianshiguang',
    storageBucket: 'lianlianshiguang.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBI_dF1-f8Ue9S5lkX3YRCCC-TxOEKEh4A',
    appId: '1:892791360631:web:b49cee9b7898da95db4a72',
    messagingSenderId: '892791360631',
    projectId: 'lianlianshiguang',
    authDomain: 'lianlianshiguang.firebaseapp.com',
    storageBucket: 'lianlianshiguang.firebasestorage.app',
    measurementId: 'G-QFYWY63W88',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuDXhce0pkX75YAIBXEzroAEhO_harlu4',
    appId: '1:892791360631:ios:ba7a53fb352f7e37db4a72',
    messagingSenderId: '892791360631',
    projectId: 'lianlianshiguang',
    storageBucket: 'lianlianshiguang.firebasestorage.app',
    androidClientId: '892791360631-2764m81poj1m0pbcc8u5tdqqvtaf71f9.apps.googleusercontent.com',
    iosClientId: '892791360631-varecrkcqdis4gfsmsup6s31o13om03b.apps.googleusercontent.com',
    iosBundleId: 'com.yubaimo.lianlianshiguang',
  );

}
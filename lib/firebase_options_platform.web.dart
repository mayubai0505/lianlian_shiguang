// 這個檔案只會在 Web 平台被編譯和使用
part of 'firebase_options_platform.dart';

// 實現 PlatformFirebaseOptionsInterface 接口
class _PlatformFirebaseOptionsWeb implements PlatformFirebaseOptionsInterface {
  // --- 最終聖劍：我們直接把聖旨刻在這裡！ ---
  // 請您把您的 Firebase 金鑰， 딱 한번만 (只要一次)，填寫到下面的引號中
  static final _firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyBI_dF1-f8Ue9S5lkX3YRCCC-TxOEKEh4A', // <--- 在這裡貼上您的 apiKey
    appId: '1:892791360631:web:046ed25c34a2d465db4a72', // <--- 在這裡貼上您的 appId
    messagingSenderId: '892791360631', // <--- 在這裡貼上您的 messagingSenderId
    projectId: 'lianlianshiguang', // <--- 在這裡貼上您的 projectId
    storageBucket:
        'lianlianshiguang.firebaseapp.com', // <--- 在這裡貼上您的 storageBucket (例如：your-project-id.appspot.com)
  );

  @override
  FirebaseOptions get currentPlatformFirebaseOptions => _firebaseOptions;

  @override
  String? get initialAuthToken {
    try {
      // 🌟 2026 現代化寫法：
      // 1. 把 window 轉成一個 JS 物件
      final jsWindow = web.window as JSObject;

      // 2. 獲取自訂屬性，記得要用 .toJS 轉換字串
      final token = jsWindow.getProperty('__initial_auth_token'.toJS);

      // 3. 檢查是不是空的，如果不是就轉回 Dart 字串
      if (token.isDefinedAndNotNull) {
        return (token as JSString).toDart;
      }
    } catch (e) {
      print("抓取 Web Token 失敗：$e");
    }
    return null;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import '../screens/login_page.dart';
import 'package:flutter/material.dart'; // 🌟 加入這一行，紅字就會消失！
import 'package:flutter/foundation.dart' show kIsWeb; // 確保判斷網頁版的工具也在
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:math';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ 1. 迎合 7.0 新版：取消了 GoogleSignIn()，現在強制使用 .instance
  // 改回這個，讓紅線消失
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  // ✅ 2. 迎合 7.0 新版：強制要求在使用前必須呼叫 initialize()
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      // ✨ 關鍵修改：在 initialize 裡面把網頁版的 Client ID 塞進去
      await _googleSignIn.initialize(
        clientId: kIsWeb ? '892791360631-0q8r6c8kh64k7vm208vkrmpt9rm4i6f4.apps.googleusercontent.com' : null,
      );
      _isInitialized = true;
    }
  }

  // Google 登入
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // 準備一個統一的變數來裝結果
      UserCredential userCredential;

      if (kIsWeb) {
        // 🌐 【網頁版專屬通道：繞過 authenticate 限制】
        print("🌐 執行網頁版 Google 登入...");
        GoogleAuthProvider authProvider = GoogleAuthProvider();

        // 直接用 FirebaseAuth 內建的彈出視窗
        userCredential = await _auth.signInWithPopup(authProvider);

      } else {
        // 📱 【手機版專屬通道：維持總裁原本的 7.0 新版邏輯】
        print("📱 執行手機版 Google 登入...");
        await _ensureInitialized();

        final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
          scopeHint: <String>['email', 'profile'],
        ).timeout(const Duration(seconds: 15));

        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      // 🎉 共通後續處理：拿到資料後，統一走妳原本寫好的邏輯
      print("Firebase 登入成功！使用者: ${userCredential.user?.displayName}");

      if (userCredential.user != null) {
        final bool isNewUser = await createNewUser(userCredential.user!);
        return {'user': userCredential.user, 'isNewUser': isNewUser};
      }
      return null;

    } catch (e) {
      print("🔴 Google 登入時發生錯誤: $e");
      return null;
    }
  }

  // ✨ 新增技能 1：使用信箱密碼「註冊」
  Future<Map<String, dynamic>?> registerWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✨✨✨ 關鍵補救：帶新手去資料庫開戶，發放 50 朵花花！ ✨✨✨
      if (userCredential.user != null) {
        await createNewUser(userCredential.user!);
      }

      // 註冊成功，絕對是新玩家
      return {'user': userCredential.user, 'isNewUser': true};
    } on FirebaseAuthException catch (e) {
      print('信箱註冊失敗: ${e.message}');
      rethrow; // 把錯誤往上丟，讓 UI 可以顯示警告
    }
  }

  // ✨ 新增技能 2：使用信箱密碼「登入」
  Future<Map<String, dynamic>?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final bool isNewUser = await createNewUser(userCredential.user!);

        return {
          'user': userCredential.user,
          'isNewUser': isNewUser,
        };
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print('信箱登入失敗: ${e.message}');
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      print("🚀 開始執行強制登出...");

      // ✨ 關鍵：清空本地 SharedPreferences，殺掉所有暫存幽靈
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("❌ 登出發生災難: $e");
    }
  }


  // Facebook 登入
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        print("🌐 執行網頁版 Facebook 登入...");
        FacebookAuthProvider authProvider = FacebookAuthProvider();
        authProvider.addScope('email');
        authProvider.addScope('public_profile');
        userCredential = await _auth.signInWithPopup(authProvider);
      } else {
        print("📱 執行手機版 Facebook 登入...");

        // ✨✨✨ 終極修復：準備兩份通關密語 (原味與加密版)
        final String rawNonce = 'fb_login_${DateTime.now().millisecondsSinceEpoch}';
        final String hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

        // 1. 呼叫 Facebook 原生登入，交出【加密版 (hashedNonce)】
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
          nonce: hashedNonce, // 👈 Facebook 只負責傳遞加密過的鎖頭
        );

        if (result.status == LoginStatus.success) {
          print("🔑 抓到的 FB Token 是: ${result.accessToken!.tokenString}");
          final String token = result.accessToken!.tokenString;

          OAuthCredential credential;
          if (token.startsWith('eyJ')) {
            print("🍎 偵測到 iOS 限定 OIDC 長憑證，切換專屬驗證通道...");
            credential = OAuthProvider('facebook.com').credential(
              idToken: token,
              accessToken: null,
              rawNonce: rawNonce, // ✨✨✨ 關鍵：把【原味版 (rawNonce)】交給 Firebase 解鎖！
            );
          } else {
            print("🤖 偵測到傳統 Facebook 短憑證...");
            credential = FacebookAuthProvider.credential(token);
          }

          userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        } else {
          print("⚠️ Facebook 登入取消或失敗: ${result.message}");
          return null;
        }
      }

      print("🎉 Facebook 登入成功！使用者: ${userCredential.user?.displayName}");

      if (userCredential.user != null) {
        final bool isNewUser = await createNewUser(userCredential.user!);
        return {'user': userCredential.user, 'isNewUser': isNewUser};
      }
      return null;

    } catch (e) {
      print("🔴 Facebook 登入時發生錯誤: $e");
      return null;
    }
  }

  // ✨ Apple 登入
  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthProvider = OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return null;
      }

// ✅ Apple 登入也要建立 users/{uid}，才會送新手 50 點
      final bool isNewUser = await createNewUser(userCredential.user!);

      return {
        'user': userCredential.user,
        'isNewUser': isNewUser,
      };
    } catch (e) {
      print('Apple 登入報錯: $e');
      rethrow;
    }
  }

// ✨ 刪除帳號 (包含資料庫與驗證帳號)
Future<String?> deleteAccount() async {
  try {
    final User? user = _auth.currentUser;
    if (user == null) return "使用者未登入，無法刪除帳號。";

    final String uid = user.uid;

    // 1. 先把他在雲端資料庫 (Firestore) 的資料清空
    await _firestore.collection('users').doc(uid).delete();
    print('已刪除 Firestore 中的使用者資料');

    // 2. 再把他的登入帳號刪除
    await user.delete();
    print('已刪除 Firebase Authentication 中的帳號');

    return null;
  } on FirebaseAuthException catch (e) {
    // 安全機制：刪除帳號是敏感操作，如果他登入太久沒活動，Firebase 會要求重新登入
    if (e.code == 'requires-recent-login') {
      return '為了安全起見，此操作需要您重新登入後再執行。';
    }
    return '刪除帳號時發生錯誤: ${e.message}';
  } catch (e) {
    return '發生未知錯誤，請聯絡官方。';
  }
}

  String _generateRandomPlayerID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();

    return List.generate(
      8,
          (_) => chars[random.nextInt(chars.length)],
    ).join();
  }


// 📡 監聽登入狀態變化 (讓 App 知道現在是誰在線)
Stream<User?> get authStateChanges => _auth.authStateChanges();

// 📝 建立新使用者資料 (當玩家第一次登入《戀戀拾光》時執行)
  Future<bool> createNewUser(User user) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      // 如果資料庫還沒這筆資料，就幫他開一個新的戶頭
      await userDocRef.set({
        'uid': user.uid,
        'displayName': user.displayName ?? "初識的旅人",
        'nickname': user.displayName ?? "初識的旅人",
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),

        // 新手資源
        'flowerPoints': 50,

        // 玩家 ID
        'playerID': _generateRandomPlayerID(),

        // 簽到相關，避免新帳號簽到讀不到欄位
        'lastCheckInDate': '',
        'checkInStreak': 0,
        'dailyCheckInCount': 0,
      });

      return true; // 是新玩家
    }

    // ✅ 舊帳號補洞：如果以前建立過，但缺 flowerPoints 或 playerID，就補上
    final data = userDoc.data() ?? {};
    final Map<String, dynamic> patchData = {};

    if (!data.containsKey('flowerPoints')) {
      patchData['flowerPoints'] = 50;
    }

    final String existingPlayerID = (data['playerID'] ?? '').toString().trim();
    if (existingPlayerID.isEmpty) {
      patchData['playerID'] = _generateRandomPlayerID();
    }

    if (!data.containsKey('displayName')) {
      patchData['displayName'] = user.displayName ?? "初識的旅人";
    }

    if (!data.containsKey('nickname')) {
      patchData['nickname'] = user.displayName ?? "初識的旅人";
    }

    if (!data.containsKey('email')) {
      patchData['email'] = user.email ?? '';
    }

    if (!data.containsKey('photoURL')) {
      patchData['photoURL'] = user.photoURL ?? '';
    }

    if (!data.containsKey('lastCheckInDate')) {
      patchData['lastCheckInDate'] = '';
    }

    if (!data.containsKey('checkInStreak')) {
      patchData['checkInStreak'] = 0;
    }

    if (!data.containsKey('dailyCheckInCount')) {
      patchData['dailyCheckInCount'] = 0;
    }

    if (!data.containsKey('uid')) {
      patchData['uid'] = user.uid;
    }

    if (patchData.isNotEmpty) {
      patchData['updatedAt'] = FieldValue.serverTimestamp();
      await userDocRef.set(patchData, SetOptions(merge: true));
    }

    return false; // 是老玩家
  }
}
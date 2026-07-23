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
import 'package:cloud_functions/cloud_functions.dart';

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
        final bool isNewUser =
        await createNewUser(userCredential.user!);

        return {
          'user': userCredential.user,
          'isNewUser': isNewUser,
        };
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
      debugPrint('🧪 開始信箱註冊 email=$email');

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('✅ Firebase Auth 註冊成功 uid=${userCredential.user?.uid}');

      if (userCredential.user != null) {
        debugPrint('🧪 準備建立 Firestore user document');
        await createNewUser(userCredential.user!);
        debugPrint('✅ Firestore user document 建立/補洞完成');
      }

      return {
        'user': userCredential.user,
        'isNewUser': true,
      };
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ 信箱註冊 FirebaseAuthException code=${e.code}, message=${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ 信箱註冊未知錯誤: $e');
      rethrow;
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
        final bool isNewUser =
        await createNewUser(userCredential.user!);

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
        final bool isNewUser =
        await createNewUser(userCredential.user!);

        return {
          'user': userCredential.user,
          'isNewUser': isNewUser,
        };
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
      final bool isNewUser =
      await createNewUser(userCredential.user!);

      return {
        'user': userCredential.user,
        'isNewUser': isNewUser,
      };
    } catch (e) {
      print('Apple 登入報錯: $e');
      rethrow;
    }
  }

  Future<bool> checkDeleteRequest(String uid) async {

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();


    if (!doc.exists) {
      return false;
    }


    final data = doc.data() ?? {};


    return data['accountDeleteRequested'] == true;
  }

  Future<void> cancelDeleteAccount() async {
    final callable =
    FirebaseFunctions.instance
        .httpsCallable('cancelDeleteAccount');
    await callable.call();

  }

// ✨ 刪除帳號 (包含資料庫與驗證帳號)
  Future<String?> deleteAccount() async {

    try {

      final callable =
      FirebaseFunctions.instance
          .httpsCallable('deleteUserAccount');


      await callable.call();


      print("✅ 帳號刪除完成");

      return null;


    } catch(e){

      print("❌ 刪除失敗: $e");

      return "刪除帳號失敗";

    }
  }

  Future<String?> requestDeleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return "尚未登入";
      }

      final callable = FirebaseFunctions.instance
          .httpsCallable('requestDeleteAccount');
      await callable.call();
      return null;
    } catch (e) {
      print("❌ 申請刪除失敗: $e");
      return "申請刪除帳號失敗，請稍後再試";

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

  Future<void> repairMissingUser({
    required String uid,
    required int flowerPoints,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(uid);

      // 確認玩家文件是否存在
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        print("⚠️ 玩家文件已存在，不需要修復：$uid");
        return;
      }

      // 建立遺失的 users 文件
      await userRef.set({

        'uid': uid,

        'displayName': '初識的旅人',
        'nickname': '初識的旅人',

        'flowerPoints': flowerPoints,

        'email': '',
        'photoURL': '',

        'playerID': '',

        'lastCheckInDate': null,
        'checkInStreak': 0,
        'dailyCheckInCount': 0,

        'isMonthlySubscribed': false,
        'monthlyCardStatus': 'none',

        'updatedAt': FieldValue.serverTimestamp(),

        'dataRepaired': true,
        'repairReason': 'Missing user document recovery',
        'repairedAt': FieldValue.serverTimestamp(),

      });

      print("✅ 玩家資料修復完成 UID=$uid");

    } catch (e) {
      print("❌ 玩家資料修復失敗：$e");
    }
  }

  Future<bool> hasPendingDeleteRequest(String uid) async {

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();


    if (!doc.exists) {
      return false;
    }


    final data = doc.data() ?? {};


    return data['accountDeleteRequested'] == true;
  }

// 📡 監聽登入狀態變化 (讓 App 知道現在是誰在線)
Stream<User?> get authStateChanges => _auth.authStateChanges();

// 📝 建立新使用者資料 (當玩家第一次登入《戀戀拾光》時執行)
  Future<bool> createNewUser(User user) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {

      // 🔍 檢查是否有子集合殘留
      final flowerLogsSnapshot = await userDocRef
          .collection('flower_logs')
          .limit(1)
          .get();

      final aiRequestsSnapshot = await userDocRef
          .collection('aiRequests')
          .limit(1)
          .get();

      final bool hasOldData =
          flowerLogsSnapshot.docs.isNotEmpty ||
              aiRequestsSnapshot.docs.isNotEmpty;

      if (hasOldData) {
        // ⚠️ 有舊資料，但主文件不見
        // 不當新玩家，不發50花
        print("⚠️ 發現玩家資料異常 UID=${user.uid}，存在子集合但 users 文件不存在");


        // ✅ 先根據流水帳重新計算花花
        final repairedFlowerPoints =
        await calculateFlowerPoints(user.uid);

        await userDocRef.set({
          'uid': user.uid,
          'displayName':
          user.displayName ?? "初識的旅人",
          'nickname':
          user.displayName ?? "初識的旅人",
          'email':
          user.email ?? '',
          'photoURL':
          user.photoURL ?? '',
          // ✅ 使用流水帳計算出的花花
          'flowerPoints':
          repairedFlowerPoints,
          'playerID':
          _generateRandomPlayerID(),
          'lastCheckInDate': null,
          'checkInStreak': 0,
          'dailyCheckInCount': 0,
          // 標記人工修復
          'dataRepaired': true,
          'repairReason':
          'Missing user document',
          'createdAt':
          FieldValue.serverTimestamp(),
          'updatedAt':
          FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print(
            "✅ 玩家資料修復完成 UID=${user.uid}, 花花=$repairedFlowerPoints"
        );
        return false;
      }


      // ✅ 真的完全沒有資料，才算新玩家
      await userDocRef.set({
        'uid': user.uid,
        'displayName': user.displayName ?? "初識的旅人",
        'nickname': user.displayName ?? "初識的旅人",
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),

        // 新手50
        'flowerPoints': 50,

        'playerID': _generateRandomPlayerID(),

        'lastCheckInDate': null,
        'checkInStreak': 0,
        'dailyCheckInCount': 0,
      });


      await userDocRef.collection('flower_logs').add({
        'type': 'income',
        'title': '新手禮物',
        'amount': 50,
        'createdAt': FieldValue.serverTimestamp(),
      });


      return true;
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
      patchData['lastCheckInDate'] = null;
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

  Future<int> calculateFlowerPoints(String uid) async {

    int balance = 0;


    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('flower_logs')
        .get();


    for (final doc in snapshot.docs) {

      final data = doc.data();

      final amount = data['amount'] ?? 0;

      balance += (amount as num).toInt();

    }


    return balance;

  }

  Future<bool> checkDeleteStatus(User user) async {

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();


    if (!doc.exists) {
      return false;
    }


    final data = doc.data()!;


    if (data['accountDeleteRequested'] == true) {

      final deleteDate =
      (data['deleteScheduledAt'] as Timestamp)
          .toDate();


      if (DateTime.now().isBefore(deleteDate)) {

        // 還在冷靜期
        return true;
      }
    }


    return false;
  }

}
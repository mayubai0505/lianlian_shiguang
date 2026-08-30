import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/page/inbox_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ✨ 1. 導入 App Check 套件
import 'package:firebase_app_check/firebase_app_check.dart';
import 'services/purchase_service.dart';
import 'screens/login_page.dart';
import 'screens/main_page.dart';
import 'screens/chat_page.dart';
import 'services/theme_notifier.dart';
import 'firebase_options.dart';
import 'services/locale_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 🌟 修改這裡：只保留一個數據來源，並給它一個別名
import 'dart:async';
import 'screens/character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/reminder_notification_service.dart';

String? globalActiveCharacterId;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  '聊天訊息通知',
  description: '用於接收角色的最新回覆與遊戲提醒。',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("👻 [背景小精靈] 成功攔截到背景通知: ${message.notification?.title}");
}

// ==========================================
// 🚀 程式進入點
// ==========================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 15),
    );

  } on TimeoutException {
  } catch (e, stackTrace) {
    debugPrintStack(stackTrace: stackTrace);
  }


  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeNotifier();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return LocaleNotifier();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return PurchaseService()..initialize();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );

  unawaited(
    _initializeBackgroundServices().then((_) {
    }).catchError((e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }),
  );
}

Future<void> _initializeBackgroundServices() async {
  try {
    await ReminderNotificationService.initialize().timeout(
      const Duration(seconds: 10),
    );
  } on TimeoutException {
    debugPrint('⚠️ 通知服務初始化逾時');
  } catch (e, stackTrace) {
    debugPrint('❌ 通知服務初始化失敗：$e');
    debugPrintStack(stackTrace: stackTrace);
  }

  if (kIsWeb && kDebugMode) {
    debugPrint('ℹ️ Web Debug 模式，略過 Firebase App Check');
    return;
  }

  try {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(
        '6LfGqrYsAAAAAJfkhg30_VdjJmfDIWo40I9-izIO',
      ),
      providerAndroid: kReleaseMode
          ? AndroidPlayIntegrityProvider()
          : AndroidDebugProvider(),
      providerApple: kReleaseMode
          ? AppleDeviceCheckProvider()
          : AppleDebugProvider(),
    ).timeout(
      const Duration(seconds: 15),
    );
    debugPrint('✅ Firebase App Check 初始化成功');
  } on TimeoutException {
    debugPrint('⚠️ Firebase App Check 初始化逾時');
  } catch (e, stackTrace) {
    debugPrint('❌ Firebase App Check 初始化失敗：$e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

// ==========================================
// 📱 MyApp 主架構
// ==========================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {



  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addObserver(this);


    WidgetsBinding.instance.addPostFrameCallback((_) {

      unawaited(_initializeAfterAppStarted());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateUserStatus(true);
    } else {
      _updateUserStatus(false);
    }
  }

  void _updateUserStatus(bool isOnline) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
      }).catchError((e) => print("更新在線狀態失敗: $e"));
    }
  }

  Future<void> _initializeAfterAppStarted() async {

    try {
      await setupPushNotifications().timeout(
        const Duration(seconds: 15),
      );

    } on TimeoutException {
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }


    try {
      _updateUserStatus(true);
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, themeNotifier, localeNotifier, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: '戀戀拾光',
          theme: themeNotifier.currentThemeData,
          locale: localeNotifier.locale,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'TW'), Locale('zh', 'CN'), Locale('en', ''),
            Locale('ja', ''), Locale('ko', ''), Locale('vi', ''),
            Locale('id', ''), Locale('th', ''), Locale('ar', ''),
            Locale('fr', ''), Locale('ms', ''), Locale('es', ''),
            Locale('hi', ''), Locale('pt', ''),
          ],

          routes: {
            '/login': (context) => const LoginPage(),
            '/main': (context) => const MainPage(),
          },

          onGenerateRoute: (settings) {
            if (settings.name == '/chat') {
              final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
              final String charId = args?['characterId'] ?? "default_id";
              final String sessionId = args?['sessionId'] ?? "";

              return MaterialPageRoute(
                builder: (context) => ChatLoaderWrapper(
                  charId: charId,
                  sessionId: sessionId.isNotEmpty ? sessionId : "session_$charId",
                ),
              );
            }
            return null;
          },


          // 🏠 把 FutureBuilder 換成這個完美放權版！
          home: FirebaseAuth.instance.currentUser != null
              ? const MainPage()
              : const LoginPage(),
        );
      },
    );
  }
}

// 🌟 總裁專屬：推播導航緩衝區 (保持原樣)
class ChatLoaderWrapper extends StatefulWidget {
  final String charId;
  final String sessionId;

  const ChatLoaderWrapper({super.key, required this.charId, required this.sessionId});

  @override
  State<ChatLoaderWrapper> createState() => _ChatLoaderWrapperState();
}

class _ChatLoaderWrapperState extends State<ChatLoaderWrapper> {
  late Future<Character> _characterFuture;

  @override
  void initState() {
    super.initState();
    _characterFuture = _fetchCharacter();
  }

  Future<Character> _fetchCharacter() async {
    final firestore = FirebaseFirestore.instance;
    final appId = const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang');

    var doc = await firestore.collection('artifacts').doc(appId).collection('public_characters').doc(widget.charId).get();

    if (!doc.exists) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        doc = await firestore.collection('artifacts').doc(appId).collection('users').doc(userId).collection('private_characters').doc(widget.charId).get();
      }
    }

    if (!doc.exists) throw Exception("真的找不到這個人😭");
    return await Character.fromFirestoreAsync(doc);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: _characterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(child: Text("讀取失敗：${snapshot.error}")),
          );
        }

        return ChatPage(
          character: snapshot.data!,
          chatMode: "daily",
          sessionId: widget.sessionId,
          selectedLanguage: '繁體中文',
          // ✨ 最後的補給：從 snapshot.data 裡面把鑰匙拿出來！
          // 如果你的資料模型裡 ID 欄位叫 .id，這樣寫就對了：
          characterId: snapshot.data!.id,
        );
      },
    );
  }
}

// ==========================================
// 💌 推播處理函數 (保持原樣)
// ==========================================
void _handleNotificationClick(RemoteMessage message) {
  final data = message.data;
  debugPrint("🚨 收到推播的 Data 內容: $data");

  // 🌍 路線一：如果是聊天訊息，維持原本的邏輯，去對應的聊天室
  if (data['type'] == 'chat') {
    final String charId = data['characterId']?.toString() ?? '';
    final String sessionId = data['sessionId']?.toString() ?? '';

    if (charId.isEmpty) {
      debugPrint("❌ 嚴重錯誤：找不到有效的 characterId");
      return;
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/chat',
          (route) => route.isFirst,
      arguments: {
        'characterId': charId,
        'sessionId': sessionId,
      },
    );
  }
  // ✨ 總裁新增：路線二！如果是萬能郵差送來的社交互動通知（按讚、留言、關注）
  else if (data['type'] == 'like' || data['type'] == 'comment' || data['type'] == 'follow') {
    debugPrint("📫 玩家點擊了社交通知，準備導向私密信箱頁面");

    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const InboxPage()),
    );
  }
}

Future<void> _saveFcmTokenForCurrentUser(String token) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    debugPrint("⚠️ 尚未登入，略過 FCM token 儲存");
    return;
  }

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  // 1. 保留舊欄位，避免舊版 Cloud Function 仍在讀 fcmToken
  await userRef.set({
    'fcmToken': token,
    'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  // 2. 新增多裝置 token，每台手機 / 平板各一筆
  await userRef.collection('fcmTokens').doc(token).set({
    'token': token,
    'platform': defaultTargetPlatform.name,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));

  debugPrint("✅ FCM token 已儲存：${defaultTargetPlatform.name}");
}

Future<void> setupPushNotifications() async {
  if (kIsWeb) {
    debugPrint("🌐 網頁版：暫不初始化推播（避免 Service Worker 錯誤）");
    return;
  }

  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token;

    try {
      token = await messaging.getToken().timeout(
        const Duration(seconds: 10),
      );
    } on TimeoutException {
      debugPrint('⚠️ 取得 FCM token 逾時，本次略過');
    }

    if (token != null) {
      try {
        await _saveFcmTokenForCurrentUser(token).timeout(
          const Duration(seconds: 10),
        );
      } on TimeoutException {
        debugPrint('⚠️ 儲存 FCM token 逾時，本次略過');
      } catch (e) {
        debugPrint('❌ 儲存 FCM token 失敗：$e');
      }
    }

// Token 有時候會被 Firebase 更新，這裡也要同步存回去
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await _saveFcmTokenForCurrentUser(newToken);
    });

    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _handleNotificationClick(msg);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });
  } catch (e) {
    debugPrint("❌ 推播初始化發生錯誤: $e");
  }
}
import 'package:flutter/material.dart';
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
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart';
import 'screens/splash_loading_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 🌟 修改這裡：只保留一個數據來源，並給它一個別名
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:async';
import 'screens/character_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // 🌟 記得先 add 這個套件
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  // 🗑️ 刪除了 FlutterNativeSplash.preserve(...)
  // 讓系統原生的啟動圖自然結束，直接交接給妳的 SplashLoadingScreen

  tz_data.initializeTimeZones();
  try {
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.toString()));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Asia/Taipei'));
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (kIsWeb && kDebugMode) {
    debugPrint("🚀 網頁開發模式：暫時跳過 App Check 驗證，避免 400 錯誤");
  } else {
    try {
      await FirebaseAppCheck.instance.activate(
        providerWeb: ReCaptchaV3Provider('6LfGqrYsAAAAAJfkhg30_VdjJmfDIWo40I9-izIO'),
        providerAndroid: kReleaseMode ? AndroidPlayIntegrityProvider() : AndroidDebugProvider(),
        providerApple: kReleaseMode ? AppleDeviceCheckProvider() : AppleDebugProvider(),
      );
    } catch (e) {
      debugPrint("App Check 啟動失敗: $e");
    }
  }
  await setupPushNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider(create: (_) => PurchaseService()..initialize()),
      ],
      child: const MyApp(),
    ),
  );
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

  // ✨ 加回這把鎖！用來控制 SplashLoadingScreen 的顯示時間
  late Future<void> _appInitFuture;

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
    WidgetsBinding.instance.addObserver(this);
    _updateUserStatus(true);

    // ✨ 設定 2 秒的展示時間，讓玩家可以看見「正在喚醒《戀戀拾光》的宇宙...」
    // 如果妳覺得 2 秒太長或太短，可以直接改這裡的數字
    _appInitFuture = Future.delayed(const Duration(seconds: 2));
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

          // 🏠 把 FutureBuilder 叫回來！
          home: FutureBuilder(
            future: _appInitFuture,
            builder: (context, snapshot) {
              // ⏳ 在這 2 秒內，顯示妳自訂的「喚醒宇宙」畫面
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashLoadingScreen();
              }
              // ✨ 2 秒結束後，交接給 AuthWrapper 去判斷要進入登入頁還是主頁
              return const AuthWrapper();
            },
          ),
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
          shouldSave: true,
        );
      },
    );
  }
}

// ==========================================
// 🕵️‍♂️ 登入狀態守門員
// ==========================================
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        // 如果還在極短暫的判斷期間，繼續墊著妳的過渡頁，防閃爍
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashLoadingScreen();
        }

        // 判斷要去哪裡
        if (snapshot.hasData) {
          print("🏠 守衛認出妳了！歡迎回來: ${snapshot.data?.displayName}");
          return const MainPage();
        }

        print("🚪 守衛沒看到人，請去登入頁面");
        return const LoginPage();
      },
    );
  }
}

// ==========================================
// 💌 推播處理函數 (保持原樣)
// ==========================================
void _handleNotificationClick(RemoteMessage message) {
  // ...（保持原本的推播邏輯不變）
  final data = message.data;
  debugPrint("🚨 收到推播的 Data 內容: $data");

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

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token = await messaging.getToken();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }

    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _handleNotificationClick(msg);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🤫 收到前景推播，但總裁下令隱藏：${message.notification?.title}");
    });
  } catch (e) {
    debugPrint("❌ 推播初始化發生錯誤: $e");
  }
}
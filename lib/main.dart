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


// 🌟 用來記住玩家現在正在跟誰講電話/聊天
String? globalActiveCharacterId;
// 🌟 1. 全域鑰匙：導航員的萬能鑰匙
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 🌟🌟🌟 新增：推播頻道與本地通知外掛 🌟🌟🌟
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // 頻道 ID，必須跟 XML 裡一致
  '聊天訊息通知', // 使用者在手機設定裡看到的頻道名稱
  description: '用於接收角色的最新回覆與遊戲提醒。',
  importance: Importance.max, // 🚀 關鍵：這就是讓通知變成橫幅彈出來的魔法！
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// 🌟🌟🌟 第一道門：給背景小精靈發「免死金牌」 🌟🌟🌟
// 注意：這個函數一定要放在 main 的外面，而且必須加上這行 pragma！
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 確保 Firebase 在背景也能順利被喚醒
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("👻 [背景小精靈] 成功攔截到背景通知: ${message.notification?.title}");
}

// ==========================================
// 🚀 程式進入點
// ==========================================

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // --- A. 時區初始化 (保留) ---
  // 退一百步的無敵寫法
  tz_data.initializeTimeZones();
  try {
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName.toString())); // 強制轉字串
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Asia/Taipei'));
  }

  // --- B. Firebase 初始化 (保留) ---
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // --- 💣 拆彈一：App Check 防護升級 ---
  // 🌟 策略：如果是網頁版 + 開發模式，我們先「放行」，避免 400 錯誤卡死妳
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

  // 2. 跑起妳的 App
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

  FlutterNativeSplash.remove();
}

// ==========================================
// 📱 MyApp 主架構 (已加上終極防閃爍鎖)
// ==========================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  // ✨ 1. 宣告一把鎖，用來裝「2秒延遲」的任務
  late Future<void> _appInitFuture;

  @override
  void initState() {
    super.initState();
    // 1. 啟動推播特務
    setupPushNotifications();
    // 2. 啟動「在線狀態」觀察員
    WidgetsBinding.instance.addObserver(this);
    _updateUserStatus(true);

    // ✨ 2. 在這裡上鎖！這輩子只會等這一次 2 秒！
    _appInitFuture = _initializeApp();
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

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
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
            '/main': (context) => const MainPage(), // 如果妳有主頁的話
          },

          onGenerateRoute: (settings) {
            if (settings.name == '/chat') {
              final String? charId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (context) => ChatPage(
                  character: getCharacterById(charId ?? "default_id"),
                  chatMode: "daily",
                  sessionId: "session_$charId",
                  selectedLanguage: '繁體中文',
                  shouldSave: false,
                ),
              );
            }
            return null;
          },

          // 🏠 首頁判斷邏輯
          home: FutureBuilder(
            future: _appInitFuture, // ✨ 3. 這裡改用鎖好的變數，不再重複觸發！
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashLoadingScreen();
              }
              return const AuthWrapper();
            },
          ),
        );
      },
    );
  }
}

// ==========================================
// 🕵️‍♂️ 登入狀態守門員 (已升級為有狀態，並加上防閃爍鎖)
// ==========================================
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // ✨ 1. 宣告一把鎖，用來裝登入狀態流
  late Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    // ✨ 2. 在這裡上鎖！這輩子只會綁定這一次！
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  // 在 AuthWrapper 的 build 裡面
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // 👇 🌟 總裁，加上這行列印！
            print("🏠 守衛認出妳了！歡迎回來: ${snapshot.data?.displayName}");
            return const MainPage();
          }
          print("🚪 守衛沒看到人，請去登入頁面");
          return const LoginPage();
        }
        return const SplashLoadingScreen();
      },
    );
  }
}


// ==========================================
// 💌 推播處理函數
// ==========================================
void _handleNotificationClick(RemoteMessage message) {
  final data = message.data;
  debugPrint("🚨 收到推播的 Data 內容: $data");

  if (data['type'] == 'chat') {
    final String charId = data['characterId']?.toString() ?? '';

    if (charId.isEmpty) {
      debugPrint("❌ 嚴重錯誤：找不到有效的 characterId");
      return;
    }

    debugPrint("✅ 成功抓到角色 ID: $charId，準備跳轉...");
    navigatorKey.currentState?.pushNamed('/chat', arguments: charId);
  }
}

Future<void> setupPushNotifications() async {
  // 💣 拆彈：如果是網頁版，目前先直接回傳，避免 Service Worker 報錯
  if (kIsWeb) {
    debugPrint("🌐 網頁版：暫不初始化推播（避免 Service Worker 錯誤）");
    return;
  }

  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 🌟🌟🌟 新增：建立 Android 高權重頻道 🌟🌟🌟
    // 這一步會告訴手機：「這個 App 的通知很重要，請給我彈出橫幅！」
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 🌟🌟🌟 新增：設定前景收到通知時的表現 🌟🌟🌟
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // 允許彈出橫幅
      badge: true, // 允許顯示 APP 右上角紅點
      sound: true, // 允許發出聲音
    );

    // 1. 請求權限
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. 獲取 Token 並存到 Firestore
    String? token = await messaging.getToken();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }

    // 3. 監聽點擊
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _handleNotificationClick(msg);
    });
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

    // 4. 前台收到訊息
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 總裁下令：App 在前台打開時，完全不要顯示任何干擾畫面的通知！
      // 所以這裡我們只要在終端機印出紀錄就好，什麼畫面都不彈。
      print("🤫 收到前景推播，但總裁下令隱藏：${message.notification?.title}");
    });
  } catch (e) {
    debugPrint("❌ 推播初始化發生錯誤: $e");
  }
}
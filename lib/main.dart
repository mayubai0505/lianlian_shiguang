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
import 'services/auth_service.dart';
import 'services/theme_notifier.dart';
import 'firebase_options.dart';
import 'services/locale_notifier.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart'; // <-- 加上這一行
import 'package:flutter/foundation.dart';
import 'screens/splash_loading_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/character_edit_page.dart';
import 'screens/character_profile_page.dart';
// 🌟 修改這裡：只保留一個數據來源，並給它一個別名
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:async';
import 'screens/character_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // 🌟 記得先 add 這個套件
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'screens/character_profile_page.dart';


// 🌟 用來記住玩家現在正在跟誰講電話/聊天
String? globalActiveCharacterId;
// 🌟 1. 全域鑰匙：導航員的萬能鑰匙
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ==========================================
// 🚀 程式進入點
// ==========================================

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // --- A. 時區初始化 (保留) ---
  tz_data.initializeTimeZones();
  try {
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Asia/Taipei'));
  }

  // --- B. Firebase 初始化 (保留) ---
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- 💣 拆彈一：App Check 防護升級 ---
  // 🌟 策略：如果是網頁版 + 開發模式，我們先「放行」，避免 400 錯誤卡死妳
  if (kIsWeb && kDebugMode) {
    debugPrint("🚀 網頁開發模式：暫時跳過 App Check 驗證，避免 400 錯誤");
  } else {
    try {
      await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaV3Provider('6LfGqrYsAAAAAJfkhg30_VdjJmfDIWo40I9-izIO'),
        androidProvider: kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
        appleProvider: (kReleaseMode ? AppleProvider.deviceCheck : AppleProvider.debug) as AppleProvider,
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
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream, // ✨ 3. 使用鎖好的變數，不會再重新檢查了！
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const MainPage();
          }
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
    // 確保 navigatorKey 已經定義在全局
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
      if (globalActiveCharacterId != null) {
        print(
            "🤫 正在跟 ${globalActiveCharacterId} 通話中，自動擋掉重複的推播通知。");
        return; // 這裡直接 return，後面的顯示通知邏輯就不會執行
      }

      // 如果是別人傳的，或者是系統通知，才正常彈出通知
      final currentContext = navigatorKey.currentContext;
      if (currentContext != null) {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(
            content: Text(
                '${message.notification?.title}: ${message.notification
                    ?.body}'),
            action: SnackBarAction(
              label: '查看',
              onPressed: () => _handleNotificationClick(message),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
    // 🌟 2. 妳絕對不能漏掉這個 catch 區塊！
  } catch (e) {
    // 如果初始化失敗（例如模擬器沒裝 Google Play），它會跑來這裡
    debugPrint("❌ 推播初始化發生錯誤: $e");
  }
}
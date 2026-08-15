import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
//主題切換

enum AppTheme {
  pinkGradient,
  light,
  dark,
  blueGradient,
  orangeGradient,
  yellowGradient,
  greenGradient,
  custom, // ✨ 自定義主題
}

// --- ✨✨✨ 核心修正 #1: 將所有主題和背景的定義移到 Class 外部 ---

final ThemeData _lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFFFFBFF),

  // 預設主題的卡片增加淡紫灰色細邊框
  cardTheme: CardThemeData(
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0.5,
    shadowColor: Colors.black.withValues(alpha: 0.06),
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: Color(0xFFE7DDEA),
        width: 0.8,
      ),
    ),
  ),

  // 統一輸入框的淡邊框
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE7DDEA),
        width: 0.8,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF9C73C7),
        width: 1.2,
      ),
    ),
  ),

  // 點擊時的淡淡回饋
  splashColor: const Color(0xFF9C73C7).withValues(alpha: 0.10),
  highlightColor: const Color(0xFF9C73C7).withValues(alpha: 0.05),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
);

final ThemeData _darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF121212),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    surfaceTintColor: Colors.transparent,
  ),
);

final ThemeData _pinkGradientTheme = ThemeData(
  primarySwatch: Colors.pink,
  scaffoldBackgroundColor: const Color(0xFFFFD5E3),
  cardColor: Colors.white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // 強制白底，絕對不透明！
    surfaceTintColor: Colors.transparent, // 擋掉系統亂染色
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF82B1FF),
    primaryContainer: Color(0xFFA892F5),
    secondary: Color(0xFFF48FB1),
    secondaryContainer: Color(0xFFF8BBD0),
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFD5E3),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFD5E3),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

final ThemeData _blueGradientTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: const Color(0xFFD5E3FF),
  cardColor: Colors.white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // 強制白底，絕對不透明！
    surfaceTintColor: Colors.transparent, // 擋掉系統亂染色
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF64B5F6),
    primaryContainer: Color(0xFF9575CD),
    secondary: Color(0xFF4DB6AC),
    secondaryContainer: Color(0xFF81C784),
    onPrimary: Colors.white,
    onSecondaryContainer: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFD5E3FF),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFD5E3FF),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

final ThemeData _orangeGradientTheme = ThemeData(
  primarySwatch: Colors.orange,
  scaffoldBackgroundColor: const Color(0xFFFFE9D5),
  cardColor: Colors.white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // 強制白底，絕對不透明！
    surfaceTintColor: Colors.transparent, // 擋掉系統亂染色
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.deepOrangeAccent,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFE9D5),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFE9D5),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

final ThemeData _yellowGradientTheme = ThemeData(
  primarySwatch: Colors.yellow,
  scaffoldBackgroundColor: const Color(0xFFFFF9D5),
  cardColor: Colors.white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // 強制白底，絕對不透明！
    surfaceTintColor: Colors.transparent, // 擋掉系統亂染色
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.yellow,
    onPrimary: Colors.black,
    secondary: Colors.amber,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFF9D5),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFF9D5),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

final ThemeData _greenGradientTheme = ThemeData(
  primarySwatch: Colors.green,
  scaffoldBackgroundColor: const Color(0xFFD5FFD6),
  cardColor: Colors.white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white, // 強制白底，絕對不透明！
    surfaceTintColor: Colors.transparent, // 擋掉系統亂染色
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    onPrimary: Colors.white,
    secondary: Colors.teal,
    surface: Colors.white,
    onSurface: Colors.black87,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFD5FFD6),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFD5FFD6),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  ),
);

const BoxDecoration _pinkGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD5E3), Colors.white],
  ),
);

const BoxDecoration _blueGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD5E3FF), Color(0xFFE9D5FF)],
  ),
);

const BoxDecoration _orangeGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFE9D5), Color(0xFFFFD5D5)],
  ),
);

const BoxDecoration _yellowGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF9D5), Colors.white],
  ),
);

const BoxDecoration _greenGradientBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD5FFD6), Colors.white],
  ),
);

BoxDecoration _solidBackground(Color color) => BoxDecoration(color: color);


// --- ✨✨✨ 核心修正 #2: Class 內部現在只負責邏輯，不再定義樣式 ---
class ThemeNotifier extends ChangeNotifier {
  AppTheme _currentThemeEnum = AppTheme.blueGradient;
  Color _customColor = Colors.purple;
  String? _backgroundImagePath; // 📸 私藏背景路徑
  String? _activeCharacterBackground;
  AppTheme get currentThemeEnum => _currentThemeEnum;
  Color get customColor => _customColor;
  String? get backgroundImagePath => _backgroundImagePath;
  String? get activeCharacterBackground => _activeCharacterBackground;


  // ✨ 動態生成自定義 ThemeData (按鈕、AppBar 的顏色)
  // ✨ 動態生成自定義 ThemeData (按鈕、AppBar 的顏色)
  ThemeData _buildCustomTheme(Color color) {
    // 讓系統自動算出完美的深淺搭配色
    final ColorScheme customScheme = ColorScheme.fromSeed(seedColor: color);

    return ThemeData(
      useMaterial3: true,
      primaryColor: color,
      scaffoldBackgroundColor: Color.lerp(Colors.white, color, 0.15),
      colorScheme: customScheme,

      // ✨✨✨ 總裁看這裡：全域按鈕服裝規定！ ✨✨✨
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customScheme.primary, // 按鈕背景跟著主題色
          foregroundColor: customScheme.onPrimary, // 文字顏色自動計算 (深色配白字，淺色配黑字)
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Color.lerp(Colors.white, color, 0.25),
        elevation: 0,
        iconTheme: IconThemeData(color: customScheme.onSurface),
        titleTextStyle: TextStyle(color: customScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  ThemeData get currentThemeData {
    switch (_currentThemeEnum) {
      case AppTheme.custom:
        return _buildCustomTheme(_customColor);
      case AppTheme.light: return _lightTheme;
      case AppTheme.dark: return _darkTheme;
      case AppTheme.pinkGradient: return _pinkGradientTheme;
      case AppTheme.blueGradient: return _blueGradientTheme;
      case AppTheme.orangeGradient: return _orangeGradientTheme;
      case AppTheme.yellowGradient: return _yellowGradientTheme;
      case AppTheme.greenGradient: return _greenGradientTheme;
    }
  }

  // ✨ 核心合併邏輯：背景顯示順序
  BoxDecoration get currentBackground {
    // 1. 如果是自定義模式
    if (_currentThemeEnum == AppTheme.custom) {
      if (_backgroundImagePath != null) {
        return BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(_backgroundImagePath!)),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha:0.2),
              BlendMode.darken,
            ),
          ),
        );
      }
      // ✨✨✨ 優先權 B：沒照片，拔掉漸層！改成乾淨的單色透底！ ✨✨✨
      return BoxDecoration(
        color: Color.lerp(Colors.white, _customColor, 0.15),// 只保留一點點淡淡的主題底色
      );
    }

    // 2. 如果不是自定義模式，走預設主題
    switch (_currentThemeEnum) {
      case AppTheme.light: return _solidBackground(Colors.white);
      case AppTheme.dark: return _solidBackground(const Color(0xFF121212));
      case AppTheme.pinkGradient: return _pinkGradientBackground;
      case AppTheme.blueGradient: return _blueGradientBackground;
      case AppTheme.orangeGradient: return _orangeGradientBackground;
      case AppTheme.yellowGradient: return _yellowGradientBackground;
      case AppTheme.greenGradient: return _greenGradientBackground;
      default: return _solidBackground(Colors.white);
    }
  }

  Future<void> setCharacterBackground(String characterName, String path) async {
    final prefs = await SharedPreferences.getInstance();
    // 儲存到本地，鑰匙用角色名字
    await prefs.setString('bg_$characterName', path);

    // 🔥 重要：立刻更新當前變數並通知畫面刷新
    _activeCharacterBackground = path;
    notifyListeners();
  }

  // ✨ 2. 【新增】恢復預設背景功能
  Future<void> resetCharacterBackground(String characterName) async {
    final prefs = await SharedPreferences.getInstance();
    // 移除該角色的背景紀錄
    await prefs.remove('bg_$characterName');

    // 🔥 重要：清空當前變數並通知畫面
    _activeCharacterBackground = null;
    notifyListeners();
  }

  // ✨ 3. 載入特定角色的背景 (進入聊天室時呼叫)
  Future<void> loadCharacterBackground(String characterName) async {
    final prefs = await SharedPreferences.getInstance();
    _activeCharacterBackground = prefs.getString('bg_$characterName');
    notifyListeners();
  }

  // ✨ 4. 智慧背景產生器 (修正顯示邏輯)
  BoxDecoration get characterChatBackground {
    final String path =
    (_activeCharacterBackground ?? '').trim();

    if (path.isNotEmpty) {
      late final ImageProvider imageProvider;

      if (path.startsWith('http://') ||
          path.startsWith('https://')) {
        // Firebase／網路背景：使用磁碟快取
        imageProvider = CachedNetworkImageProvider(path);
      } else if (path.startsWith('assets/')) {
        // App 內建背景
        imageProvider = AssetImage(path);
      } else {
        // 手機本機選擇的背景
        imageProvider = FileImage(
          File(path.replaceFirst('file://', '')),
        );
      }

      return BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.1),
            BlendMode.darken,
          ),
        ),
      );
    }

    // 沒有角色專屬背景，使用全域主題背景
    return currentBackground;
  }
  // 📸 設定背景圖
  Future<void> setBackgroundImage(String path) async {
    _backgroundImagePath = path;
    _currentThemeEnum = AppTheme.custom;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_image_path', path);
    await prefs.setString('app_theme', AppTheme.custom.name);
  }

  // 🔍 【新增】讀取特定角色的專屬聊天背景
  Future<String?> getCharacterBackground(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bg_$characterId'); // 拿他專屬的鑰匙去開置物櫃
  }

  // 🌈 設定自定義顏色
  void setCustomColor(Color color) async {
    _customColor = color;
    _currentThemeEnum = AppTheme.custom;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('custom_color_value', color.toARGB32());
    await prefs.setString('app_theme', AppTheme.custom.name);
  }

  // 🎭 設定預設主題
  void setTheme(AppTheme theme) {
    _currentThemeEnum = theme;
    // 如果切換回預設主題，通常會清空照片路徑的顯示(看個人設計)
    notifyListeners();
    _saveTheme(theme);
  }
  ThemeNotifier() {
    loadTheme();
  }

  // 在 ThemeNotifier 類別裡新增：
  Future<void> resetToDefault() async {
    // 1. 恢復預設數值 (切換回我們剛剛強化的 light 主題)
    _currentThemeEnum = AppTheme.light;
    _backgroundImagePath = null;
    _customColor = Colors.blue;

    // 2. 清除本地儲存紀錄
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('background_image_path');
    await prefs.remove('custom_color_value');
    await prefs.setString('app_theme', _currentThemeEnum.name);

    // 3. ✨ 廣播通知全宇宙換衣服！
    notifyListeners();

    // 給一個成功的震動回饋
    HapticFeedback.vibrate();
  }

  Future<void> _saveTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_theme', theme.name);
  }
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // 載入照片
    _backgroundImagePath = prefs.getString('background_image_path');
    // 載入顏色
    final colorValue = prefs.getInt('custom_color_value');
    if (colorValue != null) _customColor = Color(colorValue);
    // 載入主題類型
    final themeName = prefs.getString('app_theme') ?? AppTheme.light.name;
    _currentThemeEnum = AppTheme.values.firstWhere(
            (e) => e.name == themeName,
        orElse: () => AppTheme.light
    );
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
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

final ThemeData _lightTheme = ThemeData.light().copyWith();
final ThemeData _darkTheme = ThemeData.dark().copyWith();

final ThemeData _pinkGradientTheme = ThemeData(
  primarySwatch: Colors.pink,
  scaffoldBackgroundColor: const Color(0xFFFFD5E3),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF82B1FF),
    primaryContainer: Color(0xFFA892F5),
    secondary: Color(0xFFF48FB1),
    secondaryContainer: Color(0xFFF8BBD0),
    onPrimary: Colors.white,
    surface: Colors.transparent,
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
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF64B5F6),
    primaryContainer: Color(0xFF9575CD),
    secondary: Color(0xFF4DB6AC),
    secondaryContainer: Color(0xFF81C784),
    onPrimary: Colors.white,
    onSecondaryContainer: Colors.white,
    surface: Colors.transparent,
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
  colorScheme: const ColorScheme.light(
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.deepOrangeAccent,
    surface: Colors.transparent,
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
  colorScheme: const ColorScheme.light(
    primary: Colors.yellow,
    onPrimary: Colors.black,
    secondary: Colors.amber,
    surface: Colors.transparent,
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
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    onPrimary: Colors.white,
    secondary: Colors.teal,
    surface: Colors.transparent,
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

  // ✨ 動態生成自定義 ThemeData (按鈕、AppBar 的顏色)
  ThemeData _buildCustomTheme(Color color) {
    return ThemeData(
      primaryColor: color,
      scaffoldBackgroundColor: color.withValues(alpha:0.1),
      colorScheme: ColorScheme.light(
        primary: color,
        secondary: color.withBlue(200),
        surface: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(backgroundColor: color.withValues(alpha:0.2), elevation: 0),
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
      // 優先權 A：如果有照片，顯示照片
      if (_backgroundImagePath != null) {
        return BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(_backgroundImagePath!)),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha:0.2), // 淡淡遮罩避免照片太亮
              BlendMode.darken,
            ),
          ),
        );
      }
      // 優先權 B：沒照片，顯示自定義漸層色
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_customColor.withValues(alpha:0.3), Colors.white],
        ),
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

  // --- 動作方法 ---

  // 📸 設定背景圖
  Future<void> setBackgroundImage(String path) async {
    _backgroundImagePath = path;
    _currentThemeEnum = AppTheme.custom;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_image_path', path);
    await prefs.setString('app_theme', AppTheme.custom.name);
  }

  // ✨ 3. 升級設定背景的功能 (換完背景立刻更新畫面)
  Future<void> setCharacterBackground(String characterName, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bg_$characterName', path);
    _activeCharacterBackground = path; // 立刻換上新的！
    notifyListeners();
  }

  // 🔍 【新增】讀取特定角色的專屬聊天背景
  Future<String?> getCharacterBackground(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bg_$characterId'); // 拿他專屬的鑰匙去開置物櫃
  }

  Future<void> loadCharacterBackground(String characterName) async {
    final prefs = await SharedPreferences.getInstance();
    _activeCharacterBackground = prefs.getString('bg_$characterName');
    notifyListeners(); // 通知畫面更新
  }
  // ✨ 4. 給聊天室用的「超智慧背景產生器」
  BoxDecoration get characterChatBackground {
    // 如果這個角色有專屬背景，就顯示專屬的！
    if (_activeCharacterBackground != null) {
      return BoxDecoration(
        image: DecorationImage(
          // 智慧判斷：是網路圖片還是內建圖片
          image: _activeCharacterBackground!.startsWith('http')
              ? NetworkImage(_activeCharacterBackground!) as ImageProvider
              : AssetImage(_activeCharacterBackground!),
          fit: BoxFit.cover,
        ),
      );
    }
    // 如果他沒有專屬背景，就退回顯示「全域預設背景」
    return currentBackground;
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
    // 1. 恢復預設數值
    _currentThemeEnum = AppTheme.blueGradient; // 或者您想預設為 light
    _backgroundImagePath = null;
    _customColor = Colors.purple; // 恢復預設自定義色
    notifyListeners(); // 通知所有頁面變色
    // 2. 清除本地儲存紀錄
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('background_image_path');
    await prefs.remove('custom_color_value');
    await prefs.setString('app_theme', _currentThemeEnum.name);
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
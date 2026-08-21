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

// 文青淡霧主題：背景以白色為主，只有互動元素與裝飾跟著主題色。
const Color _literaryText = Color(0xFF302B31);
const Color _literarySecondaryText = Color(0xFF83777D);

ThemeData _buildLiteraryLightTheme({
  required Color accent,
  required Color background,
}) {
  final softAccent = Color.lerp(Colors.white, accent, 0.16)!;
  final borderColor = Color.lerp(Colors.white, accent, 0.24)!;

  final scheme = ColorScheme.light(
    primary: accent,
    onPrimary: Colors.white,
    primaryContainer: softAccent,
    onPrimaryContainer: _literaryText,
    secondary: accent,
    onSecondary: Colors.white,
    secondaryContainer: softAccent,
    onSecondaryContainer: _literaryText,
    surface: background,
    onSurface: _literaryText,
    outline: borderColor,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: accent,
    scaffoldBackgroundColor: background,
    colorScheme: scheme,
    dividerColor: accent.withValues(alpha: 0.12),
    splashColor: accent.withValues(alpha: 0.09),
    highlightColor: accent.withValues(alpha: 0.04),
    disabledColor: _literarySecondaryText.withValues(alpha: 0.38),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: _literaryText,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.94),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor, width: 0.8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.92),
      labelStyle: const TextStyle(color: _literarySecondaryText),
      hintStyle: TextStyle(
        color: _literarySecondaryText.withValues(alpha: 0.68),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor, width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accent, width: 1.2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(color: accent.withValues(alpha: 0.72)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: accent),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: background,
      selectedItemColor: accent,
      unselectedItemColor: _literarySecondaryText,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: background,
      indicatorColor: softAccent,
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _literaryText,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: _literaryText,
      displayColor: _literaryText,
    ),
  );
}

final ThemeData _lightTheme = _buildLiteraryLightTheme(
  accent: const Color(0xFF8D76BE),
  background: const Color(0xFFFCFAFE),
);

final ThemeData _pinkGradientTheme = _buildLiteraryLightTheme(
  accent: const Color(0xFFD890A7),
  background: const Color(0xFFFFF9FB),
);

final ThemeData _blueGradientTheme = _buildLiteraryLightTheme(
  accent: const Color(0xFF7899CC),
  background: const Color(0xFFF8FAFE),
);

final ThemeData _orangeGradientTheme = _buildLiteraryLightTheme(
  accent: const Color(0xFFD88967),
  background: const Color(0xFFFEFAF7),
);

final ThemeData _yellowGradientTheme = _buildLiteraryLightTheme(
  accent: const Color(0xFFB49352),
  background: const Color(0xFFFEFCF6),
);

final ThemeData _greenGradientTheme = _buildLiteraryLightTheme(
  accent: const Color(0xFF78A996),
  background: const Color(0xFFF8FCFA),
);

final ThemeData _darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF11182B),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF9EABD8),
    onPrimary: Color(0xFF11182B),
    secondary: Color(0xFFB6BCE0),
    surface: Color(0xFF11182B),
    onSurface: Color(0xFFF5F2FF),
    outline: Color(0xFF46506E),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF11182B),
    foregroundColor: Color(0xFFF5F2FF),
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF11182B),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1B243A),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0xFF36415F), width: 0.8),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1B243A),
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF1B243A),
    surfaceTintColor: Colors.transparent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF11182B),
    selectedItemColor: Color(0xFF9EABD8),
    unselectedItemColor: Color(0xFF9B9DB0),
    elevation: 0,
  ),
);

BoxDecoration _solidBackground(Color color) => BoxDecoration(color: color);


// --- ✨✨✨ 核心修正 #2: Class 內部現在只負責邏輯，不再定義樣式 ---
class ThemeNotifier extends ChangeNotifier {
  // 載入 SharedPreferences 前先顯示拾光紫，避免啟動畫面短暫閃成藍色。
  AppTheme _currentThemeEnum = AppTheme.light;
  Color _customColor = const Color(0xFF8D76BE);
  String? _backgroundImagePath; // 📸 私藏背景路徑
  String? _activeCharacterBackground;
  AppTheme get currentThemeEnum => _currentThemeEnum;
  Color get customColor => _customColor;
  String? get backgroundImagePath => _backgroundImagePath;
  String? get activeCharacterBackground => _activeCharacterBackground;


  // 自定義色彩也遵守同一套文青淡霧規則。
  ThemeData _buildCustomTheme(Color color) {
    return _buildLiteraryLightTheme(
      accent: color,
      background: Color.lerp(Colors.white, color, 0.055)!,
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
      return _solidBackground(
        Color.lerp(Colors.white, _customColor, 0.055)!,
      );
    }

    // 2. 如果不是自定義模式，走預設主題
    switch (_currentThemeEnum) {
      case AppTheme.light:
        return _solidBackground(const Color(0xFFFCFAFE));
      case AppTheme.dark:
        return _solidBackground(const Color(0xFF11182B));
      case AppTheme.pinkGradient:
        return _solidBackground(const Color(0xFFFFF9FB));
      case AppTheme.blueGradient:
        return _solidBackground(const Color(0xFFF8FAFE));
      case AppTheme.orangeGradient:
        return _solidBackground(const Color(0xFFFEFAF7));
      case AppTheme.yellowGradient:
        return _solidBackground(const Color(0xFFFEFCF6));
      case AppTheme.greenGradient:
        return _solidBackground(const Color(0xFFF8FCFA));
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
    _customColor = const Color(0xFF8D76BE);

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

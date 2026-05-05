import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart'; // ✨ 指向您定義 ThemeNotifier 的地方
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart'; // ✨ 導入硬體服務模組
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // 定義卡片的顯示資料
    final List<Map<String, dynamic>> themeOptions = [
      {'theme': AppTheme.pinkGradient, 'name': l10n.theme_sakura_pink, 'colors': [Color(0xFFFFD5E3), Colors.white]},
      {'theme': AppTheme.blueGradient, 'name':l10n.theme_ocean_blue, 'colors': [Color(0xFFD5E3FF), Color(0xFFE9D5FF)]},
      {'theme': AppTheme.orangeGradient, 'name': l10n.theme_sunset_orange, 'colors': [Color(0xFFFFE9D5), Color(0xFFFFD5D5)]},
      {'theme': AppTheme.greenGradient, 'name': l10n.theme_mint_forest, 'colors': [Color(0xFFD5FFD6), Colors.white]},
      {'theme': AppTheme.dark, 'name': l10n.theme_midnight, 'colors': [Colors.black, Colors.grey[900]!]},
    ];
    return Scaffold(
      appBar: AppBar(title:  Text(l10n.change_atmosphere)),
      body: Container(
        decoration: themeNotifier.currentBackground,
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.8,
          ),
          itemCount: themeOptions.length + 1, // +1 是為了最後的自定義卡片
          itemBuilder: (context, index) {
            if (index < themeOptions.length) {
              final option = themeOptions[index];
              return _buildThemeCard(context, option, themeNotifier);
            } else {
              return _buildCustomPickerCard(context, themeNotifier);
            }
          },
        ),
      ),
    );
  }

  // 🎭 普通主題卡片
  Widget _buildThemeCard(BuildContext context, Map<String, dynamic> option, ThemeNotifier notifier) {
    bool isSelected = notifier.currentThemeEnum == option['theme'];
    return InkWell(
      onTap: () => notifier.setTheme(option['theme']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: option['colors'], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 3),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black26, blurRadius: 10)] : [],
        ),
        child: Center(
          child: Text(option['name'], style: TextStyle(
            color: isSelected ? Colors.black : Colors.black54,
            fontWeight: FontWeight.bold, fontSize: 18,
          )),
        ),
      ),
    );
  }

  // 🎨 神祕自定義卡片
  Widget _buildCustomPickerCard(BuildContext context, ThemeNotifier notifier) {
    final l10n = AppLocalizations.of(context)!;
    bool isCustom = notifier.currentThemeEnum == AppTheme.custom;
    return InkWell(
      onTap: () => _showColorPickerDialog(context, notifier),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isCustom ? notifier.customColor : Colors.white54, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 40, color: notifier.customColor),
            const SizedBox(height: 10),
            Text(l10n.custom_color, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, ThemeNotifier notifier) {
    final l10n = AppLocalizations.of(context)!;

    // 先把目前的顏色存起來當初始值
    Color pickedColor = notifier.customColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.custom_color_desc),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickedColor,
            onColorChanged: (color) {
              pickedColor = color; // 當玩家滑動時，暫存顏色
            },
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false, // 關閉透明度，讓顏色更紮實
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
            labelTypes: const [], // 隱藏數值標籤，保持介面簡潔
          ),
        ),
        actions: <Widget>[
          TextButton(
            child:  Text(l10n.cancelButton),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child:  Text(l10n.confirm),
            onPressed: () {
              // ✨ 總裁看這裡：按下確定才正式套用顏色！
              notifier.setCustomColor(pickedColor);
              HapticFeedback.heavyImpact(); // 確定時給一個紮實的震動感
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
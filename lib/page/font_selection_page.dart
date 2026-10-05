import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';

class FontSelectionPage extends StatelessWidget {
  const FontSelectionPage({super.key});

  TextStyle _previewStyle(AppFont font, ThemeData theme) {
    final base = TextStyle(
      fontSize: 18,
      height: 1.6,
      color: theme.colorScheme.onSurface,
    );

    switch (font) {
      case AppFont.notoSerifTc:
        return GoogleFonts.notoSerifTc(textStyle: base);
      case AppFont.notoSansTc:
        return GoogleFonts.notoSansTc(textStyle: base);
      case AppFont.system:
        return base;
    }
  }

  String _fontScaleLabel(double scale) {
    if (scale <= 0.9) return '小';
    if (scale <= 1.0) return '標準';
    if (scale <= 1.1) return '稍大';
    if (scale <= 1.2) return '大';
    return '特大';
  }

  int _fontScaleIndex(double scale) {
    const values = <double>[0.9, 1.0, 1.1, 1.2, 1.35];

    int bestIndex = 0;
    double bestDiff = (scale - values.first).abs();

    for (int i = 1; i < values.length; i++) {
      final diff = (scale - values[i]).abs();
      if (diff < bestDiff) {
        bestIndex = i;
        bestDiff = diff;
      }
    }

    return bestIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = context.watch<ThemeNotifier>();

    return Container(
      decoration: notifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('字體'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
            children: [
              Text(
                '選一種最適合妳閱讀故事與聊天的字體。',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.format_size_rounded),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            '字體大小',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          _fontScaleLabel(notifier.fontScale),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '與你喜歡的他，再次寫下屬於你們的故事。',
                      textScaler: TextScaler.linear(notifier.fontScale),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _fontScaleIndex(notifier.fontScale).toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      label: _fontScaleLabel(notifier.fontScale),
                      onChanged: (value) {
                        const scales = <double>[0.9, 1.0, 1.1, 1.2, 1.35];
                        notifier.setFontScale(scales[value.round()]);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('小'),
                        Text('標準'),
                        Text('稍大'),
                        Text('大'),
                        Text('特大'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              ...AppFont.values.map((font) {
                final selected = notifier.currentFont == font;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: selected
                        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.72)
                        : theme.colorScheme.surface.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        await notifier.setFont(font);
                        if (!context.mounted) return;

                        ToastUtils.showCenterToast(
                          context,
                          '已套用「${font.label}」',
                          customIcon: Icons.text_fields_rounded,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? theme.colorScheme.primary.withValues(alpha: 0.55)
                                : theme.colorScheme.outline.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    font.label,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              font.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.58),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '與你喜歡的他，再次寫下屬於你們的故事。',
                              style: _previewStyle(font, theme),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Text(
                '字體與字級會立即套用並保存在這台裝置；恢復預設外觀時會回到「拾光宋體＋標準大小」。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.46),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

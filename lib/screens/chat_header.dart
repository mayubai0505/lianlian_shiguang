import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showcaseview/showcaseview.dart';

class ChatHeaderModeOption {
  final String id;
  final String label;
  final String? asset;
  final IconData fallbackIcon;

  const ChatHeaderModeOption({
    required this.id,
    required this.label,
    this.asset,
    required this.fallbackIcon,
  });
}

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String characterName;
  final int friendship;
  final int nextThreshold;
  final int flowerPoints;
  final VoidCallback onBack;
  final VoidCallback onFlowerTap;
  final VoidCallback onMenuTap;
  final String currentModeId;
  final String currentModeLabel;
  final List<ChatHeaderModeOption> modeOptions;
  final ValueChanged<String> onModeSelected;
  final String callLabel;
  final VoidCallback onCall;
  final GlobalKey? menuShowcaseKey;
  final String? menuShowcaseDescription;

  const ChatHeader({
    super.key,
    required this.characterName,
    required this.friendship,
    required this.nextThreshold,
    required this.flowerPoints,
    required this.onBack,
    required this.onFlowerTap,
    required this.onMenuTap,
    required this.currentModeId,
    required this.currentModeLabel,
    required this.modeOptions,
    required this.onModeSelected,
    required this.callLabel,
    required this.onCall,
    this.menuShowcaseKey,
    this.menuShowcaseDescription,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62);

  String _affectionStageAsset(int score) {
    if (score < 60) return 'assets/images/affection/affection_stage_1.png';
    if (score < 150) return 'assets/images/affection/affection_stage_2.png';
    if (score < 550) return 'assets/images/affection/affection_stage_3.png';
    if (score < 1720) return 'assets/images/affection/affection_stage_4.png';
    if (score < 2430) return 'assets/images/affection/affection_stage_5.png';
    return 'assets/images/affection/affection_stage_6.png';
  }

  String _legacyFlowerAsset(int score) {
    if (score < 60) return 'assets/images/flower_stage_1.png';
    if (score < 150) return 'assets/images/flower_stage_2.png';
    if (score < 550) return 'assets/images/flower_stage_3.png';
    if (score < 1720) return 'assets/images/flower_stage_4.png';
    if (score < 2430) return 'assets/images/flower_stage_5.png';
    return 'assets/images/flower_stage_6.png';
  }

  String _giftFlowerAsset(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? 'assets/images/flower_gift_dark.png'
        : 'assets/images/flower_gift.png';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final safeNextThreshold = nextThreshold <= 0 ? 1 : nextThreshold;

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.96),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 3, 8, 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Stack(
            children: [
              // 右側保留三條線空間
              Padding(
                padding: const EdgeInsets.only(right: 46),
                child: Row(
                  children: [
                    IconButton(
                      tooltip:
                      MaterialLocalizations.of(context).backButtonTooltip,
                      onPressed: onBack,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 38,
                      ),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: onSurface,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 3),

                    // 角色名字
                    // 角色名字：縮小、減輕字重，並保留最基本顯示空間。
                    Expanded(
                      child: Text(
                        characterName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: onSurface.withValues(alpha: 0.92),
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // 好感度花 + 分數
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        _affectionStageAsset(friendship),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            _legacyFlowerAsset(friendship),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.eco_outlined,
                              size: 14,
                              color: primary.withValues(alpha: 0.72),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$friendship/$safeNextThreshold',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: primary.withValues(alpha: 0.78),
                      ),
                    ),

                    // 稍微拉開好感度與花花的距離，讓好感度整組往左一些。
                    const SizedBox(width: 12),

                    // 花花點數
                    InkWell(
                      onTap: onFlowerTap,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 17,
                              height: 17,
                              child: Image.asset(
                                _giftFlowerAsset(context),
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.local_florist_rounded,
                                  size: 16,
                                  color: primary.withValues(alpha: 0.82),
                                ),
                              ),
                            ),
                            const SizedBox(width: 3),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 48),
                              child: Text(
                                '$flowerPoints',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: onSurface.withValues(alpha: 0.76),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    // 回覆模型：花花右側顯示目前模式；
                    // 展開後保留模式圖片，並把通話放在最下方。
                    PopupMenuButton<String>(
                      tooltip: '回覆模型',
                      initialValue: currentModeId,
                      onSelected: (value) {
                        if (value == '__call__') {
                          onCall();
                          return;
                        }
                        onModeSelected(value);
                      },
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, 5),
                      constraints: const BoxConstraints(
                        minWidth: 188,
                        maxWidth: 220,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      itemBuilder: (context) {
                        final entries = <PopupMenuEntry<String>>[];

                        for (final option in modeOptions) {
                          final bool selected = option.id == currentModeId;

                          entries.add(
                            PopupMenuItem<String>(
                              value: option.id,
                              height: 48,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: option.asset == null
                                        ? Icon(
                                      option.fallbackIcon,
                                      size: 21,
                                      color: primary.withValues(alpha: 0.78),
                                    )
                                        : Image.asset(
                                      option.asset!,
                                      fit: BoxFit.contain,
                                      color: primary,
                                      colorBlendMode: BlendMode.srcIn,
                                      errorBuilder: (_, __, ___) => Icon(
                                        option.fallbackIcon,
                                        size: 21,
                                        color: primary.withValues(alpha: 0.78),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      option.label,
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 13,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: selected ? primary : onSurface,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Icon(
                                      Icons.check_rounded,
                                      size: 17,
                                      color: primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }

                        entries.add(const PopupMenuDivider(height: 1));

                        entries.add(
                          PopupMenuItem<String>(
                            value: '__call__',
                            height: 48,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.asset(
                                    'assets/images/chat/chat_menu_call_mask.png',
                                    fit: BoxFit.contain,
                                    color: primary,
                                    colorBlendMode: BlendMode.srcIn,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.call_outlined,
                                      size: 21,
                                      color: primary.withValues(alpha: 0.78),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    callLabel,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        return entries;
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 42,
                          maxWidth: 62,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 5,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  currentModeLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                    color: onSurface.withValues(alpha: 0.80),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 1),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: onSurface.withValues(alpha: 0.68),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 三條線固定右上角
              Positioned(
                top: 0,
                right: 0,
                child: Builder(
                  builder: (context) {
                    final menuButton = IconButton(
                      tooltip: 'Menu',
                      onPressed: onMenuTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: Icon(
                        Icons.menu_rounded,
                        color: onSurface,
                        size: 26,
                      ),
                    );

                    final showcaseKey = menuShowcaseKey;
                    final showcaseDescription = menuShowcaseDescription;

                    if (showcaseKey == null ||
                        showcaseDescription == null ||
                        showcaseDescription.isEmpty) {
                      return menuButton;
                    }

                    return Showcase(
                      key: showcaseKey,
                      description: showcaseDescription,
                      child: menuButton,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
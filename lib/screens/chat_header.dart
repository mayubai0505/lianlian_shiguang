import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String characterName;
  final int friendship;
  final int nextThreshold;
  final int flowerPoints;
  final VoidCallback onBack;
  final VoidCallback onMenuTap;

  const ChatHeader({
    super.key,
    required this.characterName,
    required this.friendship,
    required this.nextThreshold,
    required this.flowerPoints,
    required this.onBack,
    required this.onMenuTap,
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
                    Flexible(
                      flex: 4,
                      child: Text(
                        characterName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

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
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: primary.withValues(alpha: 0.80),
                      ),
                    ),

                    const Spacer(),

                    // 花花點數
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
                      constraints: const BoxConstraints(maxWidth: 56),
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

              // 三條線固定右上角
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
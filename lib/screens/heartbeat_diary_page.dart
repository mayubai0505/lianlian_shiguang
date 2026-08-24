import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeartbeatDiaryPage extends StatefulWidget {
  final String title;

  final String dailyChatTitle;
  final String dailyChatSubtitle;
  final int dailyChatProgress;
  final bool dailyChatClaimed;
  final Future<void> Function(VoidCallback onSuccess) onClaimDailyChat;

  final String storyTitle;
  final String storySubtitle;
  final int storyProgress;
  final bool storyClaimed;
  final Future<void> Function(VoidCallback onSuccess) onClaimStory;

  final String socialTitle;
  final String socialSubtitle;
  final int socialProgress;
  final bool socialClaimed;
  final Future<void> Function(VoidCallback onSuccess) onClaimSocial;

  final String monthlyTitle;
  final String monthlySubtitle;
  final bool hasActiveMonthlyCard;
  final bool monthlyClaimed;
  final String monthlyLockedText;
  final Future<void> Function(VoidCallback onSuccess) onClaimMonthly;

  final String claimText;
  final String claimedText;
  final String incompleteText;
  final String closeText;

  const HeartbeatDiaryPage({
    super.key,
    required this.title,

    required this.dailyChatTitle,
    required this.dailyChatSubtitle,
    required this.dailyChatProgress,
    required this.dailyChatClaimed,
    required this.onClaimDailyChat,

    required this.storyTitle,
    required this.storySubtitle,
    required this.storyProgress,
    required this.storyClaimed,
    required this.onClaimStory,

    required this.socialTitle,
    required this.socialSubtitle,
    required this.socialProgress,
    required this.socialClaimed,
    required this.onClaimSocial,

    required this.monthlyTitle,
    required this.monthlySubtitle,
    required this.hasActiveMonthlyCard,
    required this.monthlyClaimed,
    required this.monthlyLockedText,
    required this.onClaimMonthly,

    required this.claimText,
    required this.claimedText,
    required this.incompleteText,
    required this.closeText,
  });

  @override
  State<HeartbeatDiaryPage> createState() => _HeartbeatDiaryPageState();
}

class _HeartbeatDiaryPageState extends State<HeartbeatDiaryPage> {
  late bool _dailyChatClaimed;
  late bool _storyClaimed;
  late bool _socialClaimed;
  late bool _monthlyClaimed;

  @override
  void initState() {
    super.initState();

    _dailyChatClaimed = widget.dailyChatClaimed;
    _storyClaimed = widget.storyClaimed;
    _socialClaimed = widget.socialClaimed;
    _monthlyClaimed = widget.monthlyClaimed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // 花草採相對尺寸 + 上限，避免平板時過度放大。
            final double flowerWidth = (width * 0.42).clamp(150.0, 240.0).toDouble();
            // 負值越小，花草會露出更多；這裡比原本 -8% 更往內。
            final double sideFlowerOffset =
            -(width * 0.04).clamp(10.0, 32.0).toDouble();
            final double bottomFlowerOffset =
            -(height * 0.025).clamp(12.0, 28.0).toDouble();

            return Stack(
              children: [
                // ==============================
                // 左下花草
                // ==============================
                Positioned(
                  left: sideFlowerOffset,
                  bottom: bottomFlowerOffset,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.16,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          primary,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/heartbeat_diary/botanical_left.png',
                          width: flowerWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // ==============================
                // 右下花草
                // ==============================
                Positioned(
                  right: sideFlowerOffset,
                  bottom: bottomFlowerOffset,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.16,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          primary,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/heartbeat_diary/botanical_right.png',
                          width: flowerWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // ==============================
                // 主內容
                // ==============================
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    width * 0.055,
                    4,
                    width * 0.055,
                    height * 0.14,
                  ),
                  child: Column(
                    children: [
                      // ==============================
                      // 返回鍵
                      // ==============================
                      SizedBox(
                        height: 52,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.black87,
                                  size: 22,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.045),
                      // ==============================
                      // 任務 1
                      // ==============================
                      _buildTaskCard(
                        context: context,
                        assetPath:
                        'assets/images/heartbeat_diary/task_daily_chat.png',
                        title: widget.dailyChatTitle,
                        subtitle: widget.dailyChatSubtitle,
                        progress: widget.dailyChatProgress,
                        goal: 3,
                        isClaimed: _dailyChatClaimed,
                        onClaim: () async {
                          if (_dailyChatClaimed ||
                              widget.dailyChatProgress < 3) {
                            return;
                          }

                          await widget.onClaimDailyChat(() {
                            if (!mounted) return;
                            setState(() {
                              _dailyChatClaimed = true;
                            });
                          });
                        },
                      ),

                      SizedBox(height: height * 0.018),

                      // ==============================
                      // 任務 2
                      // ==============================
                      _buildTaskCard(
                        context: context,
                        assetPath:
                        'assets/images/heartbeat_diary/task_story.png',
                        title: widget.storyTitle,
                        subtitle: widget.storySubtitle,
                        progress: widget.storyProgress,
                        goal: 1,
                        isClaimed: _storyClaimed,
                        iconScale: 1.22,
                        onClaim: () async {
                          if (_storyClaimed ||
                              widget.storyProgress < 1) {
                            return;
                          }

                          await widget.onClaimStory(() {
                            if (!mounted) return;
                            setState(() {
                              _storyClaimed = true;
                            });
                          });
                        },
                      ),

                      SizedBox(height: height * 0.018),

                      // ==============================
                      // 任務 3
                      // ==============================
                      _buildTaskCard(
                        context: context,
                        assetPath:
                        'assets/images/heartbeat_diary/task_social.png',
                        title: widget.socialTitle,
                        subtitle: widget.socialSubtitle,
                        progress: widget.socialProgress,
                        goal: 3,
                        isClaimed: _socialClaimed,
                        onClaim: () async {
                          if (_socialClaimed ||
                              widget.socialProgress < 3) {
                            return;
                          }

                          await widget.onClaimSocial(() {
                            if (!mounted) return;
                            setState(() {
                              _socialClaimed = true;
                            });
                          });
                        },
                      ),

                      SizedBox(height: height * 0.018),

                      // ==============================
                      // 任務 4：月卡
                      // ==============================
                      _buildTaskCard(
                        context: context,
                        assetPath:
                        'assets/images/heartbeat_diary/task_monthly.png',
                        title: widget.monthlyTitle,
                        subtitle: widget.monthlySubtitle,
                        progress:
                        widget.hasActiveMonthlyCard ? 1 : 0,
                        goal: 1,
                        isClaimed: _monthlyClaimed,
                        customIncompleteText:
                        widget.monthlyLockedText,
                        onClaim: () async {
                          if (!widget.hasActiveMonthlyCard ||
                              _monthlyClaimed) {
                            return;
                          }

                          await widget.onClaimMonthly(() {
                            if (!mounted) return;
                            setState(() {
                              _monthlyClaimed = true;
                            });
                          });
                        },
                      ),

                      SizedBox(height: height * 0.038),

                      // ==============================
                      // 關閉
                      // ==============================
                      SizedBox(
                        width: width * 0.55,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primary,
                            side: BorderSide(
                              color: primary.withValues(alpha: 0.55),
                              width: 1.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(28),
                            ),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.92,
                            ),
                          ),
                          child: Text(
                            widget.closeText,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required BuildContext context,
    required String assetPath,
    required String title,
    required String subtitle,
    required int progress,
    required int goal,
    required bool isClaimed,
    required Future<void> Function() onClaim,
    String? customIncompleteText,
    double iconScale = 1.0,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final displayedProgress = progress > goal ? goal : progress;
    final isCompleted = progress >= goal;
    final canClaim = isCompleted && !isClaimed;

    final String statusText;

    if (isClaimed) {
      statusText = widget.claimedText;
    } else if (canClaim) {
      statusText = widget.claimText;
    } else {
      statusText =
          customIncompleteText ?? widget.incompleteText;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 13, 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.12),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ==============================
              // 任務圖片
              // ==============================
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.035),
                ),
                padding: const EdgeInsets.all(8),
                child: Transform.scale(
                  scale: iconScale,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      primary.withValues(alpha: 0.62),
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // ==============================
              // 任務文字
              // ==============================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$subtitle  ($displayedProgress / $goal)',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11.5,
                        height: 1.45,
                        color: primary.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // ==============================
              // 狀態按鈕
              // ==============================
              GestureDetector(
                onTap: canClaim ? onClaim : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(
                    minWidth: 72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: canClaim
                        ? primary.withValues(alpha: 0.12)
                        : primary.withValues(alpha: 0.055),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primary.withValues(
                        alpha: canClaim ? 0.28 : 0.10,
                      ),
                    ),
                  ),
                  child: Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primary.withValues(
                        alpha: canClaim ? 0.95 : 0.55,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // ==============================
          // 進度條
          // ==============================
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goal <= 0 ? 0 : displayedProgress / goal,
              minHeight: 5,
              backgroundColor:
              primary.withValues(alpha: 0.075),
              valueColor: AlwaysStoppedAnimation<Color>(
                primary.withValues(alpha: 0.72),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSideMenu extends StatefulWidget {
  final String searchLabel;
  final String saveTranscriptLabel;
  final String galleryLabel;
  final String aboutMeLabel;
  final String aboutUsLabel;
  final String memoLabel;
  final String periodLabel;
  final String resetLabel;

  final String modelLabel;
  final String dailyLabel;
  final String storyLabel;
  final String immersiveLabel;
  final String callLabel;
  final String currentModeId;

  final VoidCallback onSearch;
  final VoidCallback onSaveTranscript;
  final VoidCallback onGallery;
  final VoidCallback onAboutMe;
  final VoidCallback onAboutUs;
  final VoidCallback onMemo;
  final VoidCallback onPeriod;
  final VoidCallback onReset;

  final Future<void> Function(String modeId) onModeSelected;
  final VoidCallback onCall;

  const ChatSideMenu({
    super.key,
    required this.searchLabel,
    required this.saveTranscriptLabel,
    required this.galleryLabel,
    required this.aboutMeLabel,
    required this.aboutUsLabel,
    required this.memoLabel,
    required this.periodLabel,
    required this.resetLabel,
    required this.modelLabel,
    required this.dailyLabel,
    required this.storyLabel,
    required this.immersiveLabel,
    required this.callLabel,
    required this.currentModeId,
    required this.onSearch,
    required this.onSaveTranscript,
    required this.onGallery,
    required this.onAboutMe,
    required this.onAboutUs,
    required this.onMemo,
    required this.onPeriod,
    required this.onReset,
    required this.onModeSelected,
    required this.onCall,
  });

  static Future<void> show(
      BuildContext context, {
        required ChatSideMenu menu,
      }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.88,
              child: menu,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(
            opacity: curved,
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<ChatSideMenu> createState() => _ChatSideMenuState();
}

class _ChatSideMenuState extends State<ChatSideMenu> {
  bool _modelExpanded = false;
  late String _selectedModeId;
  bool _switchingMode = false;

  @override
  void initState() {
    super.initState();
    _selectedModeId = widget.currentModeId;
  }

  Future<void> _selectMode(String modeId) async {
    if (_switchingMode || _selectedModeId == modeId) return;

    final previous = _selectedModeId;

    setState(() {
      _selectedModeId = modeId;
      _switchingMode = true;
    });

    try {
      await widget.onModeSelected(modeId);
    } catch (_) {
      if (mounted) {
        setState(() {
          _selectedModeId = previous;
        });
      }
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _switchingMode = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.horizontal(
        left: Radius.circular(26),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 文青角落植物：直接用 mask 跟著主題色染色。
          Positioned(
            top: -18,
            right: -30,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.075,
                child: Image.asset(
                  'assets/images/chat/chat_side_menu_corner_floral_mask.png',
                  width: 260,
                  height: 240,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                  color: primary,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 18, 30),
            children: [
              _SectionTitle(label: '聊天'),

              // 回覆模型直接放在「聊天」第一個，不再另外拉「回覆設定」。
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_model_mask.png',
                fallbackIcon: Icons.tune_rounded,
                label: widget.modelLabel,
                onTap: () {
                  setState(() {
                    _modelExpanded = !_modelExpanded;
                  });
                },
                trailing: AnimatedRotation(
                  turns: _modelExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: primary.withValues(alpha: 0.62),
                  ),
                ),
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: _modelExpanded
                    ? Padding(
                  padding: const EdgeInsets.fromLTRB(12, 2, 0, 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.035),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        _ModeTile(
                          asset:
                          'assets/images/chat/chat_mode_daily_mask.png',
                          fallbackIcon: Icons.chat_bubble_outline_rounded,
                          label: widget.dailyLabel,
                          selected: _selectedModeId == 'daily',
                          disabled: _switchingMode,
                          onTap: () => _selectMode('daily'),
                        ),
                        _ModeTile(
                          asset:
                          'assets/images/chat/chat_mode_story_mask.png',
                          fallbackIcon: Icons.menu_book_rounded,
                          label: widget.storyLabel,
                          selected: _selectedModeId == 'story',
                          disabled: _switchingMode,
                          onTap: () => _selectMode('story'),
                        ),
                        _ModeTile(
                          asset:
                          'assets/images/chat/chat_mode_immersive_mask.png',
                          fallbackIcon: Icons.dark_mode_outlined,
                          label: widget.immersiveLabel,
                          selected: _selectedModeId == 'immersive',
                          disabled: _switchingMode,
                          onTap: () => _selectMode('immersive'),
                        ),
                        const _InnerDivider(),
                        _ModeTile(
                          asset:
                          'assets/images/chat/chat_menu_call_mask.png',
                          fallbackIcon: Icons.call_outlined,
                          label: widget.callLabel,
                          selected: false,
                          disabled: false,
                          onTap: widget.onCall,
                        ),
                      ],
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),

              _MenuTile(
                asset: 'assets/images/chat/chat_menu_search_mask.png',
                fallbackIcon: Icons.search_rounded,
                label: widget.searchLabel,
                onTap: widget.onSearch,
              ),
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_save_mask.png',
                fallbackIcon: Icons.download_outlined,
                label: widget.saveTranscriptLabel,
                onTap: widget.onSaveTranscript,
              ),
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_gallery_mask.png',
                fallbackIcon: Icons.auto_stories_outlined,
                label: widget.galleryLabel,
                onTap: widget.onGallery,
              ),

              const _SoftDivider(),
              _SectionTitle(label: '關係'),
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_related_mask.png',
                fallbackIcon: Icons.person_outline_rounded,
                label: widget.aboutMeLabel,
                onTap: widget.onAboutMe,
              ),
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_about_us_mask.png',
                fallbackIcon: Icons.favorite_border_rounded,
                label: widget.aboutUsLabel,
                onTap: widget.onAboutUs,
              ),
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_memo_mask.png',
                fallbackIcon: Icons.note_alt_outlined,
                label: widget.memoLabel,
                onTap: widget.onMemo,
              ),
              _MenuTile(
                asset: 'assets/images/chat/chat_menu_period_mask.png',
                fallbackIcon: Icons.calendar_month_outlined,
                label: widget.periodLabel,
                onTap: widget.onPeriod,
              ),

              const _SoftDivider(),
              _SectionTitle(label: '記憶管理'),
              _MenuTile(
                asset:
                'assets/images/chat/chat_menu_reset_memory_mask.png',
                fallbackIcon: Icons.restart_alt_rounded,
                label: widget.resetLabel,
                onTap: widget.onReset,
                danger: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;

  const _SectionTitle({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(
        label,
        style: GoogleFonts.notoSerifTc(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String asset;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  final Widget? trailing;

  const _MenuTile({
    required this.asset,
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
    this.danger = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final color = danger ? Colors.redAccent : primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 9,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              height: 46,
              child: Center(
                child: Image.asset(
                  asset,
                  width: 38,
                  height: 38,
                  fit: BoxFit.contain,
                  color: color.withValues(alpha: danger ? 0.92 : 0.86),
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) => Icon(
                    fallbackIcon,
                    size: 25,
                    color: color.withValues(alpha: danger ? 0.92 : 0.80),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: danger
                      ? Colors.redAccent
                      : theme.colorScheme.onSurface.withValues(alpha: 0.86),
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color: danger
                      ? Colors.redAccent.withValues(alpha: 0.50)
                      : primary.withValues(alpha: 0.42),
                ),
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final String asset;
  final IconData fallbackIcon;
  final String label;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _ModeTile({
    required this.asset,
    required this.fallbackIcon,
    required this.label,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 2,
        ),
        padding: const EdgeInsets.fromLTRB(9, 8, 10, 8),
        decoration: BoxDecoration(
          color:
          selected ? primary.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              asset,
              width: 33,
              height: 33,
              fit: BoxFit.contain,
              color: primary.withValues(
                alpha: disabled
                    ? 0.38
                    : selected
                    ? 0.95
                    : 0.74,
              ),
              colorBlendMode: BlendMode.srcIn,
              errorBuilder: (_, __, ___) => Icon(
                fallbackIcon,
                size: 22,
                color: primary.withValues(
                  alpha: disabled
                      ? 0.38
                      : selected
                      ? 0.95
                      : 0.72,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13.5,
                  fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
                  color: disabled
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.40)
                      : selected
                      ? primary
                      : theme.colorScheme.onSurface
                      .withValues(alpha: 0.76),
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
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Divider(
      height: 12,
      thickness: 1,
      color: primary.withValues(alpha: 0.08),
    );
  }
}

class _InnerDivider extends StatelessWidget {
  const _InnerDivider();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Divider(
        height: 8,
        thickness: 1,
        color: primary.withValues(alpha: 0.08),
      ),
    );
  }
}

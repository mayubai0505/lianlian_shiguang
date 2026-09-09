import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import '../utils/image_utils.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key});

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  late AppTheme _previewTheme;
  late Color _previewCustomColor;
  bool _initialized = false;
  bool _isApplying = false;

  static const Color _starlight = Color(0xFF8D76BE);

  static const List<_ThemeOption> _options = [
    _ThemeOption(
      theme: AppTheme.light,
      asset: 'assets/images/theme/theme_card_starlight.png',
      accent: _starlight,
    ),
    _ThemeOption(
      theme: AppTheme.pinkGradient,
      asset: 'assets/images/theme/theme_card_sakura.png',
      accent: Color(0xFFD890A7),
    ),
    _ThemeOption(
      theme: AppTheme.blueGradient,
      asset: 'assets/images/theme/theme_card_ocean.png',
      accent: Color(0xFF7899CC),
    ),
    _ThemeOption(
      theme: AppTheme.orangeGradient,
      asset: 'assets/images/theme/theme_card_sunset.png',
      accent: Color(0xFFD88967),
    ),
    _ThemeOption(
      theme: AppTheme.greenGradient,
      asset: 'assets/images/theme/theme_card_mint.png',
      accent: Color(0xFF78A996),
    ),
    _ThemeOption(
      theme: AppTheme.dark,
      asset: 'assets/images/theme/theme_card_midnight.png',
      accent: Color(0xFF7180B6),
      isDark: true,
    ),
    _ThemeOption(
      theme: AppTheme.custom,
      asset: 'assets/images/theme/theme_card_custom.png',
      accent: _starlight,
      isCustom: true,
    ),
  ];

  String _themeName(AppTheme theme, AppLocalizations l10n) {
    switch (theme) {
      case AppTheme.light:
        return l10n.theme_name_starlight;
      case AppTheme.pinkGradient:
        return l10n.theme_name_sakura;
      case AppTheme.blueGradient:
        return l10n.theme_name_ocean;
      case AppTheme.orangeGradient:
        return l10n.theme_name_sunset;
      case AppTheme.greenGradient:
        return l10n.theme_name_mint;
      case AppTheme.yellowGradient:
        return l10n.theme_name_sunset;
      case AppTheme.dark:
        return l10n.theme_name_midnight;
      case AppTheme.custom:
        return l10n.theme_name_custom;
    }
  }

  _ThemeOption get _selectedOption => _options.firstWhere(
        (option) => option.theme == _previewTheme,
    orElse: () => _options.first,
  );

  Color get _previewColor =>
      _previewTheme == AppTheme.custom ? _previewCustomColor : _selectedOption.accent;

  bool get _isDarkPreview => _selectedOption.isDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final notifier = context.read<ThemeNotifier>();
    _previewTheme = notifier.currentThemeEnum;
    _previewCustomColor = notifier.customColor;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final background = _isDarkPreview
        ? const Color(0xFF11182B)
        : Color.lerp(Colors.white, _previewColor, 0.055)!;
    final foreground = _isDarkPreview ? const Color(0xFFF5F2FF) : const Color(0xFF29283A);
    final secondary = _isDarkPreview
        ? const Color(0xFFBBBBD0)
        : const Color(0xFF777184);

    return Scaffold(
      backgroundColor: background,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
        color: background,
        child: Stack(
          children: [
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(foreground, secondary),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _buildPreviewCard(foreground, secondary),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 34, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: _sectionTitle(
                        l10n.theme_selection_choose_theme,
                        foreground,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.crossAxisExtent;
                        final columns = width >= 720 ? 4 : (width >= 500 ? 3 : 2);
                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) => _buildThemeCard(_options[index]),
                            childCount: _options.length,
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.78,
                          ),
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 38),
                    sliver: SliverToBoxAdapter(
                      child: _buildActions(foreground),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildHeader(Color foreground, Color secondary) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 18),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: foreground, size: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Text(
                  l10n.theme_selection_title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    color: foreground,
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  l10n.theme_selection_description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    color: secondary,
                    fontSize: 13,
                    height: 1.6,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(Color foreground, Color secondary) {
    final cardColor = _isDarkPreview
        ? const Color(0xFF1B243A).withValues(alpha: 0.94)
        : Colors.white.withValues(alpha: 0.88);
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 360),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _previewColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _sectionTitle(l10n.theme_selection_preview, foreground),
          ),
          const SizedBox(height: 12),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: currentUser == null
                ? null
                : FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() ?? const <String, dynamic>{};
              final nickname = data['nickname']?.toString().trim().isNotEmpty == true
                  ? data['nickname'].toString().trim()
                  : (currentUser?.displayName?.trim().isNotEmpty == true
                  ? currentUser!.displayName!.trim()
                  : l10n.app_name);
              final playerId = data['playerID']?.toString().trim().isNotEmpty == true
                  ? data['playerID'].toString().trim()
                  : 'lianlian_shiguang';
              final avatarPath = data['avatarPath']?.toString().trim().isNotEmpty == true
                  ? data['avatarPath'].toString().trim()
                  : (currentUser?.photoURL?.trim().isNotEmpty == true
                  ? currentUser!.photoURL!.trim()
                  : 'assets/images/avatar1.png');
              final flowerPoints = data['flowerPoints'] is num
                  ? (data['flowerPoints'] as num).toInt()
                  : 10923;

              return _buildProfilePreview(
                foreground: foreground,
                secondary: secondary,
                nickname: nickname,
                playerId: playerId,
                avatarPath: avatarPath,
                flowerPoints: flowerPoints,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePreview({
    required Color foreground,
    required Color secondary,
    required String nickname,
    required String playerId,
    required String avatarPath,
    required int flowerPoints,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: _previewColor.withValues(alpha: 0.08),
          backgroundImage: getAvatarImageProvider(avatarPath),
          onBackgroundImageError: (_, __) {},
        ),
        const SizedBox(height: 12),
        Text(
          nickname,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerifTc(
            color: foreground,
            fontSize: 23,
            height: 1.2,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@$playerId',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(color: secondary, fontSize: 12.5),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          runSpacing: 4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tintedProfileAsset(
                  'assets/images/profile/profile_quill_mask.png',
                  size: 21,
                  opacity: 0.80,
                ),
                const SizedBox(width: 5),
                Text(
                  l10n.title_edit_profile,
                  style: GoogleFonts.notoSerifTc(
                    color: _previewColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  _isDarkPreview
                      ? 'assets/images/flower_gift_dark.png'
                      : 'assets/images/flower_gift.png',
                  width: 17,
                  height: 17,
                ),
                const SizedBox(width: 5),
                Text(
                  _formatNumber(flowerPoints),
                  style: TextStyle(
                    color: secondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(Icons.share_outlined, size: 16, color: secondary),
          ],
        ),
        const SizedBox(height: 17),
        Row(
          children: [
            Expanded(child: _previewStat('4', l10n.theme_selection_characters, foreground, secondary)),
            Expanded(child: _previewStat('102', l10n.theme_selection_posts, foreground, secondary)),
            Expanded(child: _previewStat('1', l10n.profile_likes_label, foreground, secondary)),
          ],
        ),
        const SizedBox(height: 17),
        Row(
          children: [
            Expanded(
              child: _previewEditorialShortcut(
                asset: 'assets/images/profile/calendar_base_mask.png',
                overlayAsset: 'assets/images/profile/calendar_check_mask.png',
                title: l10n.profile_check_in_done,
                subtitle: l10n.profile_check_in_done_subtitle,
                foreground: foreground,
                secondary: secondary,
              ),
            ),
            Container(
              width: 1,
              height: 78,
              color: foreground.withValues(alpha: 0.07),
            ),
            Expanded(
              child: _previewEditorialShortcut(
                asset: 'assets/images/profile/heart_diary_mask.png',
                title: l10n.tab_heartbeat_diary,
                subtitle: l10n.profile_heartbeat_diary_subtitle,
                foreground: foreground,
                secondary: secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _previewStat(String value, String label, Color foreground, Color secondary) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.notoSerifTc(color: foreground, fontSize: 20)),
        Text(label, style: GoogleFonts.notoSerifTc(color: secondary, fontSize: 11.5)),
      ],
    );
  }

  Widget _previewEditorialShortcut({
    required String asset,
    required String title,
    required String subtitle,
    required Color foreground,
    required Color secondary,
    String? overlayAsset,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 59,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _tintedProfileAsset(asset, size: 59, opacity: 0.90),
              if (overlayAsset != null)
                _tintedProfileAsset(overlayAsset, size: 59, opacity: 0.74),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(
            color: foreground,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(color: secondary.withValues(alpha: 0.72), fontSize: 9.5),
        ),
      ],
    );
  }

  Widget _tintedProfileAsset(
      String asset, {
        required double size,
        required double opacity,
      }) {
    return Opacity(
      opacity: opacity,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(_previewColor, BlendMode.srcIn),
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  String _formatNumber(int value) {
    final safeValue = value < 0 ? 0 : value;
    return safeValue.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => ',',
    );
  }

  Widget _sectionTitle(String title, Color foreground) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, size: 17, color: _previewColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.notoSerifTc(
            color: foreground,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(_ThemeOption option) {
    final l10n = AppLocalizations.of(context)!;
    final selected = option.theme == _previewTheme;
    final accent = option.isCustom ? _previewCustomColor : option.accent;
    final labelColor = option.isDark ? Colors.white : const Color(0xFF353143);

    return Semantics(
      button: true,
      selected: selected,
      label: _themeName(option.theme, l10n),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          if (option.isCustom) {
            _showColorPicker();
          } else {
            setState(() => _previewTheme = option.theme);
            HapticFeedback.selectionClick();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          decoration: BoxDecoration(
            color: option.isDark ? const Color(0xFF17213A) : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? accent : accent.withValues(alpha: 0.25),
              width: selected ? 1.8 : 0.9,
            ),
            boxShadow: selected
                ? [BoxShadow(color: accent.withValues(alpha: 0.16), blurRadius: 14, offset: const Offset(0, 6))]
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(option.asset, fit: BoxFit.cover, filterQuality: FilterQuality.high),
              Positioned(
                top: 9,
                right: 9,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? accent : Colors.white.withValues(alpha: 0.88),
                    border: Border.all(color: selected ? accent : accent.withValues(alpha: 0.55)),
                  ),
                  child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 15) : null,
                ),
              ),
              Positioned(
                left: 7,
                right: 7,
                bottom: 10,
                child: Text(
                  _themeName(option.theme, l10n),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(Color foreground) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_outlined, color: _previewColor, size: 18),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                l10n.theme_selection_previewing(_themeName(_selectedOption.theme, l10n)),
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifTc(color: foreground.withValues(alpha: 0.76), fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isApplying ? null : _applyTheme,
                  style: FilledButton.styleFrom(
                    backgroundColor: _previewColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _previewColor.withValues(alpha: 0.45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: _isApplying
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(
                    l10n.theme_selection_apply,
                    style: GoogleFonts.notoSerifTc(fontSize: 15.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _isApplying ? null : _restorePreview,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _previewColor,
                    side: BorderSide(color: _previewColor.withValues(alpha: 0.75)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: Text(
                    l10n.theme_selection_restore_default,
                    style: GoogleFonts.notoSerifTc(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showColorPicker() async {
    final l10n = AppLocalizations.of(context)!;
    Color pickedColor = _previewCustomColor;
    final result = await showDialog<Color>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.theme_selection_choose_color,
          style: GoogleFonts.notoSerifTc(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickedColor,
            onColorChanged: (color) => pickedColor = color,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, pickedColor),
            child: Text(l10n.editProfileConfirm),
          ),
        ],
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      _previewCustomColor = result;
      _previewTheme = AppTheme.custom;
    });
    HapticFeedback.selectionClick();
  }

  void _restorePreview() {
    setState(() {
      _previewTheme = AppTheme.light;
      _previewCustomColor = _starlight;
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _applyTheme() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isApplying = true);
    final notifier = context.read<ThemeNotifier>();
    if (_previewTheme == AppTheme.custom) {
      notifier.setCustomColor(_previewCustomColor);
    } else {
      notifier.setTheme(_previewTheme);
    }
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    setState(() => _isApplying = false);
    HapticFeedback.mediumImpact();
    ToastUtils.showCenterToast(
      context,
      l10n.theme_selection_applied(
        _themeName(_selectedOption.theme, l10n),
      ),
      customIcon: Icons.check_rounded,
    );
  }
}

class _ThemeOption {
  const _ThemeOption({
    required this.theme,
    required this.asset,
    required this.accent,
    this.isDark = false,
    this.isCustom = false,
  });

  final AppTheme theme;
  final String asset;
  final Color accent;
  final bool isDark;
  final bool isCustom;

}
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
import 'dart:ui';

class BackgroundSettingsPage extends StatefulWidget {
  final Character character;
  final String characterId;

  const BackgroundSettingsPage({
    super.key,
    required this.character,
    required this.characterId,
  });

  @override
  State<BackgroundSettingsPage> createState() =>
      _BackgroundSettingsPageState();
}

class _BackgroundSettingsPageState extends State<BackgroundSettingsPage> {
  static const String _topRightFloralAsset =
      'assets/images/theme/theme_card_starlight1.png';

  static const String _bottomLeftFloralAsset =
      'assets/images/profile_edit/profile_edit_botanical_left.png';

  final PageController _pageController = PageController();
  int _currentPhotoIndex = 0;
  bool _didPrecacheDecorations = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheDecorations) return;
    _didPrecacheDecorations = true;

    precacheImage(
      const AssetImage(_topRightFloralAsset),
      context,
    ).catchError((_) {});
    precacheImage(
      const AssetImage(_bottomLeftFloralAsset),
      context,
    ).catchError((_) {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        title: Text(
          l10n.chat_menu_gallery,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: () => _showResetDialog(context),
            child: Text(
              l10n.reset_to_default,
              style: GoogleFonts.notoSerifTc(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            right: -18,
            top: 4,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  _topRightFloralAsset,
                  width: 155,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Positioned(
            left: -16,
            bottom: -12,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  _bottomLeftFloralAsset,
                  width: 170,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: currentUserId == null
                ? const Stream<DocumentSnapshot>.empty()
                : FirebaseFirestore.instance
                .collection('users')
                .doc(currentUserId)
                .collection('characters')
                .doc(widget.characterId)
                .snapshots(),
            builder: (context, charSnapshot) {
              int maxGlobalAffection = 0;

              if (charSnapshot.hasData && charSnapshot.data!.exists) {
                final charData =
                charSnapshot.data!.data() as Map<String, dynamic>;
                maxGlobalAffection =
                    (charData['affection'] as num?)?.toInt() ?? 0;
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('artifacts')
                    .doc(
                  const String.fromEnvironment(
                    'APP_ID',
                    defaultValue: 'lianlianshiguang',
                  ),
                )
                    .collection('public_characters')
                    .doc(widget.characterId)
                    .collection('photos')
                    .orderBy('requiredAffection')
                    .snapshots(),
                builder: (context, photoSnapshot) {
                  if (photoSnapshot.connectionState ==
                      ConnectionState.waiting &&
                      !photoSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primary,
                      ),
                    );
                  }

                  final cgList = _resolvePhotoList(context, photoSnapshot);
                  if (cgList.isEmpty) return const SizedBox.shrink();

                  final safeIndex =
                  _currentPhotoIndex.clamp(0, cgList.length - 1);
                  if (safeIndex != _currentPhotoIndex) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      setState(() => _currentPhotoIndex = safeIndex);
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(safeIndex);
                      }
                    });
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    _precacheNearbyPhotos(cgList, safeIndex);
                  });

                  return SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 520,
                            maxHeight: 780,
                          ),
                          child: _buildAlbumCard(
                            context: context,
                            cgList: cgList,
                            maxGlobalAffection: maxGlobalAffection,
                            currentIndex: safeIndex,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<CharacterPhoto> _resolvePhotoList(
      BuildContext context,
      AsyncSnapshot<QuerySnapshot> photoSnapshot,
      ) {
    final l10n = AppLocalizations.of(context)!;

    if (photoSnapshot.hasData && photoSnapshot.data!.docs.isNotEmpty) {
      return photoSnapshot.data!.docs
          .map((doc) => CharacterPhoto.fromFirestore(doc))
          .toList();
    }

    if (widget.character.gallery != null &&
        widget.character.gallery!.isNotEmpty) {
      return List<CharacterPhoto>.from(widget.character.gallery!);
    }

    if (widget.character.avatarPath.trim().isEmpty) {
      return <CharacterPhoto>[];
    }

    return [
      CharacterPhoto(
        imageUrl: widget.character.avatarPath,
        requiredAffection: 0,
        description: l10n.first_encounter,
      ),
    ];
  }

  Widget _buildAlbumCard({
    required BuildContext context,
    required List<CharacterPhoto> cgList,
    required int maxGlobalAffection,
    required int currentIndex,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final hasMultiplePhotos = cgList.length > 1;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: primary.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: cgList.length,
                      onPageChanged: (index) {
                        setState(() => _currentPhotoIndex = index);
                        _precacheNearbyPhotos(cgList, index);
                      },
                      itemBuilder: (context, index) {
                        final cg = cgList[index];
                        final isUnlocked =
                            maxGlobalAffection >= cg.requiredAffection;

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (isUnlocked) {
                              _showConfirmDialog(context, cg);
                            } else {
                              final l10n = AppLocalizations.of(context)!;
                              ToastUtils.showCenterToast(
                                context,
                                l10n.affection_required_to_unlock(
                                  cg.requiredAffection,
                                ),
                                customIcon: Icons.lock_person_rounded,
                              );
                            }
                          },
                          child: _buildPhotoPage(
                            context: context,
                            cg: cg,
                            isUnlocked: isUnlocked,
                          ),
                        );
                      },
                    ),
                    if (hasMultiplePhotos)
                      Positioned(
                        right: 14,
                        top: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.34),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${cgList.length}',
                            style: GoogleFonts.notoSerifTc(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (hasMultiplePhotos && currentIndex > 0)
                      Positioned(
                        left: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _buildArrowButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: () => _goToPhoto(currentIndex - 1),
                          ),
                        ),
                      ),
                    if (hasMultiplePhotos &&
                        currentIndex < cgList.length - 1)
                      Positioned(
                        right: 12,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _buildArrowButton(
                            icon: Icons.chevron_right_rounded,
                            onTap: () => _goToPhoto(currentIndex + 1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 1,
                    color: primary.withValues(alpha: 0.22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '專屬照片',
                    style: GoogleFonts.notoSerifTc(
                      color: onSurface.withValues(alpha: 0.78),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 28,
                    height: 1,
                    color: primary.withValues(alpha: 0.22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPage({
    required BuildContext context,
    required CharacterPhoto cg,
    required bool isUnlocked,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (isUnlocked) {
      return _buildCachedImage(cg.imageUrl);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
          child: _buildCachedImage(cg.imageUrl),
        ),
        Container(color: Colors.black.withValues(alpha: 0.38)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                l10n.unlock_affection_requirement(cg.requiredAffection),
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifTc(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCachedImage(String rawPath) {
    final path = rawPath.trim();

    if (path.isEmpty) {
      return _imageFallback();
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 120),
        fadeOutDuration: const Duration(milliseconds: 80),
        placeholder: (_, __) => Container(
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 1.8),
          ),
        ),
        errorWidget: (_, __, ___) => _imageFallback(),
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => _imageFallback(),
      );
    }

    if (!kIsWeb) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => _imageFallback(),
        );
      }
    }

    return _imageFallback();
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        color: Colors.grey,
        size: 46,
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.82),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: Colors.black.withValues(alpha: 0.62),
            size: 30,
          ),
        ),
      ),
    );
  }

  void _goToPhoto(int index) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  void _precacheNearbyPhotos(
      List<CharacterPhoto> photos,
      int currentIndex,
      ) {
    final indices = <int>{
      currentIndex,
      if (currentIndex > 0) currentIndex - 1,
      if (currentIndex < photos.length - 1) currentIndex + 1,
    };

    for (final index in indices) {
      final path = photos[index].imageUrl.trim();
      if (path.isEmpty) continue;

      ImageProvider? provider;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        provider = CachedNetworkImageProvider(path);
      } else if (path.startsWith('assets/')) {
        provider = AssetImage(path);
      } else if (!kIsWeb) {
        final file = File(path);
        if (file.existsSync()) provider = FileImage(file);
      }

      if (provider != null && mounted) {
        precacheImage(provider, context).catchError((_) {});
      }
    }
  }

  void _showResetDialog(BuildContext pageContext) {
    final l10n = AppLocalizations.of(pageContext)!;

    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.reset_bg_title,
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600),
        ),
        content: Text(
          l10n.reset_bg_content,
          style: GoogleFonts.notoSerifTc(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancelButton,
              style: GoogleFonts.notoSerifTc(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Provider.of<ThemeNotifier>(
                pageContext,
                listen: false,
              ).resetCharacterBackground(widget.character.name);

              Navigator.pop(dialogContext);

              ToastUtils.showCenterToast(
                pageContext,
                l10n.reset_bg_success,
                customIcon: Icons.wallpaper_rounded,
              );
            },
            child: Text(
              l10n.confirm_reset,
              style: GoogleFonts.notoSerifTc(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
      BuildContext pageContext,
      CharacterPhoto cg,
      ) {
    final l10n = AppLocalizations.of(pageContext)!;

    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.change_chat_bg,
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600),
        ),
        content: Text(
          l10n.confirm_change_chat_bg(
            cg.description,
            widget.character.name,
          ),
          style: GoogleFonts.notoSerifTc(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancelButton,
              style: GoogleFonts.notoSerifTc(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ThemeNotifier>(
                pageContext,
                listen: false,
              ).setCharacterBackground(
                widget.character.name,
                cg.imageUrl,
              );

              Navigator.pop(dialogContext);

              if (pageContext.mounted) {
                Navigator.pop(pageContext);
              }
            },
            child: Text(
              l10n.confirm_change,
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        ],
      ),
    );
  }
}
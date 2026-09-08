//封鎖頁面
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/character_block_service.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CharacterManagementPage extends StatelessWidget {
  const CharacterManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final double screenWidth = mediaQuery.size.width;

    // 以你目前調好的 390px 寬畫面為基準，依手機寬度等比例調整。
    // clamp 可避免小手機縮得太小、平板又放得過大。
    final double layoutScale = (screenWidth / 390).clamp(0.84, 1.20);
    final double topFlowerWidth =
    (screenWidth * 0.46).clamp(148.0, 232.0);
    final double bottomFlowerWidth =
    (screenWidth * 0.54).clamp(174.0, 268.0);

    if (uid == null)
      return Scaffold(body: Center(child: Text(l10n.character_management_login_required)));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  Positioned(
                    top: mediaQuery.padding.top + (14 * layoutScale),
                    right: 3 * layoutScale,
                    width: topFlowerWidth,
                    child: Opacity(
                      opacity: isDarkMode ? 0.08 : 0.24,
                      child: Image.asset(
                        'assets/images/blocked/blocked_top_right_botanical.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5 * layoutScale,
                    bottom: -8 * layoutScale,
                    width: bottomFlowerWidth,
                    child: Opacity(
                      opacity: isDarkMode ? 0.08 : 0.22,
                      child: Image.asset(
                        'assets/images/blocked/blocked_bottom_left_botanical.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  _buildHeader(context, theme),
                  _buildManagementTabs(context, theme),
                  const SizedBox(height: 4),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildBlockedCharactersTab(
                          context: context,
                          theme: theme,
                          l10n: l10n,
                          uid: uid,
                        ),
                        _buildBlockedCreatorsTab(
                          context: context,
                          theme: theme,
                          uid: uid,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildManagementTabs(
      BuildContext context,
      ThemeData theme,
      ) {
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.055),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: primary.withValues(alpha: 0.10),
          ),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          labelColor: primary,
          unselectedLabelColor:
          theme.colorScheme.onSurface.withValues(alpha: 0.48),
          labelStyle: GoogleFonts.notoSerifTc(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.notoSerifTc(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs:  [
            Tab(text: l10n.character_management_character_tab),
            Tab(text: l10n.character_management_creator_tab),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockedCharactersTab({
    required BuildContext context,
    required ThemeData theme,
    required AppLocalizations l10n,
    required String uid,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('blockedCharacters')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(l10n.connection_error));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildEmptyState(
            context,
            theme,
            message:l10n.character_management_blocked_characters_empty,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 42),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final charData =
            docs[index].data() as Map<String, dynamic>;
            final String charId = docs[index].id;
            final String avatarPath =
                charData['avatarPath']?.toString().trim() ??
                    charData['avatar']?.toString().trim() ??
                    '';

            return _buildCharacterCard(
              context: context,
              theme: theme,
              l10n: l10n,
              uid: uid,
              charId: charId,
              charData: charData,
              avatarPath: avatarPath,
              isBlocked: true,
            );
          },
        );
      },
    );
  }

  Widget _buildBlockedCreatorsTab({
    required BuildContext context,
    required ThemeData theme,
    required String uid,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('blockedCreators')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              l10n.character_management_blocked_creators_load_failed,
              style: GoogleFonts.notoSerifTc(),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return _buildEmptyState(
            context,
            theme,
            message: l10n.character_management_blocked_creators_empty,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 42),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data =
            docs[index].data() as Map<String, dynamic>;
            final creatorId = docs[index].id;
            final creatorName =
            data['creatorName']?.toString().trim().isNotEmpty == true
                ? data['creatorName'].toString().trim()
                : l10n.character_management_creator_fallback;

            return _buildCreatorCard(
              context: context,
              theme: theme,
              uid: uid,
              creatorId: creatorId,
              creatorName: creatorName,
            );
          },
        );
      },
    );
  }

  Widget _buildCreatorCard({
    required BuildContext context,
    required ThemeData theme,
    required String uid,
    required String creatorId,
    required String creatorName,
  }) {
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: primary.withValues(alpha: 0.16),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: primary.withValues(alpha: 0.09),
              child: Icon(
                Icons.person_outline_rounded,
                color: primary.withValues(alpha: 0.72),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creatorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      color: theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.character_management_blocked_creator_status,
                    style: GoogleFonts.notoSerifTc(
                      color: primary.withValues(alpha: 0.72),
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.character_management_blocked_creator_description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.48),
                      fontSize: 11.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(
                  color: primary.withValues(alpha: 0.55),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                minimumSize: const Size(0, 38),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const StadiumBorder(),
              ),
              onPressed: () => _confirmUnblockCreator(
                context: context,
                uid: uid,
                creatorId: creatorId,
                creatorName: creatorName,
              ),
              child: Text(
                l10n.unblock,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmUnblockCreator({
    required BuildContext context,
    required String uid,
    required String creatorId,
    required String creatorName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final bool confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          l10n.character_management_unblock_creator_title,
          style: GoogleFonts.notoSerifTc(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          l10n.character_management_unblock_creator_confirm(creatorName),
          style: GoogleFonts.notoSerifTc(
            fontSize: 13.5,
            height: 1.65,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.unblock,
              style: GoogleFonts.notoSerifTc(
                color: Theme.of(dialogContext).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirmed) return;

    try {
      final db = FirebaseFirestore.instance;
      final blockedCreatorRef = db
          .collection('users')
          .doc(uid)
          .collection('blockedCreators')
          .doc(creatorId);

      // 只找這位創作者相關的封鎖角色，再於 client 端確認 source，
      // 避免誤刪玩家原本手動封鎖的角色。
      final relatedCharacters = await db
          .collection('users')
          .doc(uid)
          .collection('blockedCharacters')
          .where('creatorId', isEqualTo: creatorId)
          .get();

      final batch = db.batch();
      batch.delete(blockedCreatorRef);

      for (final doc in relatedCharacters.docs) {
        final data = doc.data();
        if (data['source'] == 'creator_block') {
          batch.delete(doc.reference);
        }
      }

      await batch.commit();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.character_management_unblock_creator_success(creatorName),
            style: GoogleFonts.notoSerifTc(),
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ 解除封鎖創作者失敗：$e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.character_management_unblock_creator_failed,
            style: GoogleFonts.notoSerifTc(),
          ),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 24, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.character_management_title,
                  style: GoogleFonts.notoSerifTc(
                    color: theme.colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.character_management_subtitle,
                  style: GoogleFonts.notoSerifTc(
                    color: primary.withValues(alpha: 0.58),
                    fontSize: 13.5,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      ThemeData theme, {
        required String message,
      }) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final imageSize = (screenHeight * 0.27).clamp(190.0, 270.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 58, 28, 40),
      child: Center(
        child: Column(
          children: [
            Opacity(
              opacity: theme.brightness == Brightness.dark ? 0.42 : 0.78,
              child: Image.asset(
                'assets/images/blocked/blocked_empty_state.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                fontSize: 15.5,
                height: 1.7,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard({
    required BuildContext context,
    required ThemeData theme,
    required AppLocalizations l10n,
    required String uid,
    required String charId,
    required Map<String, dynamic> charData,
    required String avatarPath,
    required bool isBlocked,
  }) {
    final primary = theme.colorScheme.primary;
    final String rawName =
    charData['name']?.toString().trim().isNotEmpty == true
        ? charData['name'].toString().trim()
        : (charData['characterName']?.toString().trim() ?? '');
    final name = rawName.isNotEmpty ? rawName : l10n.character_management_character_tab;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: primary.withValues(alpha: 0.16),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showCharDetail(context, charData),
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
          child: Row(
            children: [
              Hero(
                tag: 'avatar_$charId',
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: avatarPath.isNotEmpty
                      ? CachedNetworkImageProvider(avatarPath)
                      : null,
                  child: avatarPath.isEmpty
                      ? Text(
                    name.characters.first,
                    style: GoogleFonts.notoSerifTc(
                      color: primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: theme.colorScheme.onSurface,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isBlocked ? l10n.character_management_blocked_character_status : l10n.status_in_progress,
                      style: GoogleFonts.notoSerifTc(
                        color: primary.withValues(alpha: 0.72),
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.character_management_blocked_character_description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.48),
                        fontSize: 11.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: BorderSide(
                    color: primary.withValues(alpha: 0.55),
                    width: 1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  minimumSize: const Size(0, 38),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                ),
                onPressed: () => _confirmUnblock(
                  context,
                  uid,
                  charId,
                  name,
                ),
                child: Text(
                  l10n.unblock,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✨ 邏輯優化：封鎖前的確認對話框
  Future<void> _confirmUnblock(
      BuildContext context,
      String uid,
      String charId,
      String charName,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unblock),
        content: Text(l10n.character_management_unblock_character_confirm(charName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.unblock),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await CharacterBlockService.unblockCharacter(
        context: context,
        characterId: charId,
      );
    }
  }

  // ✨ 邏輯 B：顯示詳情 (優化行高版)
  void _showCharDetail(BuildContext context, Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 頂部小橫條 (增加細節感)
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)
                ),
              ),
              // 2. 名字
              Text(
                  data['name']?.toString().trim().isNotEmpty == true
                      ? data['name'].toString().trim()
                      : (data['characterName']?.toString() ??l10n.character_management_character_tab),
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              // 3. 介紹文字 (就在這裡加上 height: 1.6 !)
              Text(
                data['desc'] ?? l10n.no_char_info,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6, // ✨ 這就是讓文字呼吸的魔法數字
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
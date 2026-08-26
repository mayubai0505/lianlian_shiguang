// 背包頁面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class BackpackPage extends StatelessWidget {
  final Character character;
  final Function(Map<String, dynamic> eggData) onUseEgg;

  const BackpackPage({
    super.key,
    required this.character,
    required this.onUseEgg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            l10n.please_login_first,
            style: GoogleFonts.notoSerifTc(),
          ),
        ),
      );
    }

    // 指向這個角色的專屬背包
    final backpackRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(character.id)
        .collection('backpack')
        .orderBy('timestamp', descending: true);

    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          l10n.char_exclusive_memory(character.name),
          style: GoogleFonts.notoSerifTc(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: backpackRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primary.withValues(alpha: 0.65),
                  ),
                );
              }

              final eggs = snapshot.data!.docs;

              if (eggs.isEmpty) {
                return _buildEmptyState(context, l10n);
              }

              return _buildMemoryList(
                context: context,
                eggs: eggs,
                l10n: l10n,
              );
            },
          ),

          // 右下角共用花草裝飾
          Positioned(
            right: -20,
            bottom: -8,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/contact/contact_bottom_right_botanical.png',
                  width: 210,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 120),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),

                // 空狀態主圖：使用可染色 mask PNG
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary.withValues(alpha: 0.045),
                      ),
                    ),
                    Image.asset(
                      'assets/images/chat/chat_menu_related_mask.png',
                      width: 128,
                      height: 128,
                      fit: BoxFit.contain,
                      color: primary.withValues(alpha: 0.48),
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 直接沿用既有 localization 文案，不新增功能字串
                Text(
                  l10n.empty_treasure_box,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 17,
                    height: 1.9,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryList({
    required BuildContext context,
    required List<QueryDocumentSnapshot> eggs,
    required AppLocalizations l10n,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 130),
      itemCount: eggs.length,
      itemBuilder: (context, index) {
        final eggDoc = eggs[index];
        final eggData = eggDoc.data() as Map<String, dynamic>;
        final bool isLast = index == eggs.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 淡紫色回憶時間軸
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary.withValues(alpha: 0.72),
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.16),
                            blurRadius: 0,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1,
                          margin: const EdgeInsets.only(top: 8),
                          color: primary.withValues(alpha: 0.15),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildMemoryCard(
                    context: context,
                    eggDoc: eggDoc,
                    eggData: eggData,
                    l10n: l10n,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemoryCard({
    required BuildContext context,
    required QueryDocumentSnapshot eggDoc,
    required Map<String, dynamic> eggData,
    required AppLocalizations l10n,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: primary.withValues(alpha: 0.13),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  eggData['title'] ?? l10n.unknown_story,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 19,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.90),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            eggData['teaser'] ?? '',
            style: GoogleFonts.notoSerifTc(
              fontSize: 15,
              height: 1.75,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: primary.withValues(alpha: 0.10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.auto_awesome,
                  size: 11,
                  color: primary.withValues(alpha: 0.40),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: primary.withValues(alpha: 0.10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: primary.withValues(alpha: 0.065),
                foregroundColor: primary,
                side: BorderSide(
                  color: primary.withValues(alpha: 0.28),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.lock_open_rounded, size: 19),
              label: Text(
                l10n.open_this_memory,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                _showUseMemoryDialog(
                  context: context,
                  eggDoc: eggDoc,
                  eggData: eggData,
                  l10n: l10n,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUseMemoryDialog({
    required BuildContext context,
    required QueryDocumentSnapshot eggDoc,
    required Map<String, dynamic> eggData,
    required AppLocalizations l10n,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: primary.withValues(alpha: 0.12),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.key_rounded,
                size: 18,
                color: primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.open_exclusive_story,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.confirm_use_egg(eggData['title']),
          style: GoogleFonts.notoSerifTc(
            fontSize: 15,
            height: 1.7,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.wait_a_bit,
              style: GoogleFonts.notoSerifTc(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.50),
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: primary.withValues(alpha: 0.90),
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              // 保留原本功能流程：先關閉確認對話框
              Navigator.pop(ctx);

              // 顯示原本的轉場 Toast
              ToastUtils.showCenterToast(
                context,
                '✨ ${l10n.guiding_into_story(eggData['title'])}',
                customIcon: Icons.auto_awesome,
              );

              // 觸發聊天室回呼
              onUseEgg(eggData);

              // 彩蛋為消耗品，沿用原本刪除邏輯
              await eggDoc.reference.delete();

              // 返回聊天室
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(
              l10n.use_now,
              style: GoogleFonts.notoSerifTc(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
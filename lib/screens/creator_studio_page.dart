import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/toast_utils.dart';
import 'character_edit_page.dart';
import 'package:rxdart/rxdart.dart'; // 🌟 記得這個一定要有！
import 'dart:io'; // 🌟 讀取手機本機檔案必備！
import 'character_model.dart';
import '../utils/image_utils.dart';
import 'package:google_fonts/google_fonts.dart';

// 私人工作室
class CreatorStudioPage extends StatelessWidget {
  const CreatorStudioPage({super.key});

  // ✨ 總裁專屬：刪除草稿與清理雲端圖片的邏輯
  Future<void> _deleteDraft(BuildContext context, String docId, String? avatarUrl) async {
    final l10n = AppLocalizations.of(context)!;

    // 1. 彈出確認視窗
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_draft_title),
        content: Text(l10n.confirm_delete_draft_msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm_delete_title, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      // 2. 直接刪除 Firestore 裡的草稿文件
      await FirebaseFirestore.instance
          .collection('draft_characters')
          .doc(docId)
          .delete();

      // ✨ 總裁級：草稿清空後的徹底淨化，用最乾淨的回饋，對應你對資料保全的堅持！
      if (context.mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.draft_cleared_success,
          customIcon: Icons.layers_clear_rounded, // 💡 總裁精選：象徵「清除圖層/草稿」的完美圖示
        );
      }
      debugPrint("♻️ 草稿文件已移除，雲端圖片已安全留存。");
    } catch (e) {
      if (context.mounted) {
        // 💡 總裁級防護：刪除失敗的緊急警告
        ToastUtils.showCenterToast(
          context,
          '刪除失敗: $e',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            l10n.login_required_for_studio,
          ),
        ),
      );
    }

    final draftStream = FirebaseFirestore.instance
        .collection('draft_characters')
        .where(
      'createdBy',
      isEqualTo: user.uid,
    )
        .snapshots();

    final privateStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(
      const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'lianlianshiguang',
      ),
    )
        .collection('users')
        .doc(user.uid)
        .collection('private_characters')
        .snapshots();

    final publicStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(
      const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'lianlianshiguang',
      ),
    )
        .collection('public_characters')
        .where(
      'createdBy',
      isEqualTo: user.uid,
    )
        .snapshots();

    final combinedStream = Rx.combineLatest3(
      draftStream,
      privateStream,
      publicStream,
          (
          QuerySnapshot drafts,
          QuerySnapshot privates,
          QuerySnapshot publics,
          ) {
        return {
          'drafts': drafts.docs,
          'privates': privates.docs,
          'publics': publics.docs,
        };
      },
    );

    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
      IgnorePointer(
      child: Stack(
      children: [
        Positioned(
        top: 20,
        right: -25,
        width: 210,
        child: Opacity(
          opacity: 0.17,
          child: Image.asset(
            'assets/images/studio/studio_top_right.png',
          ),
        ),
      ),
      Positioned(
        left: -25,
        bottom: -10,
        width: 215,
        child: Opacity(
          opacity: 0.16,
          child: Image.asset(
            'assets/images/studio/studio_bottom_left.png',
          ),
        ),
      ),
      ],
    ),
    ),
    SafeArea(
    child: Column(
    children: [
    Padding(
    padding: const EdgeInsets.fromLTRB(8, 10, 16, 4),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    IconButton(
    onPressed: () => Navigator.maybePop(context),
    icon: const Icon(
    Icons.arrow_back_ios_new_rounded,
    size: 22,
    ),
    ),
    Expanded(
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
    Flexible(
    child: Text(
    l10n.my_secret_studio_title,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.notoSerifTc(
    color: theme.colorScheme.onSurface,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.8,
    ),
    ),
    ),
    const SizedBox(width: 7),
    Image.asset(
    'assets/images/studio/studio_title_leaf.png',
    width: 30,
    height: 30,
    fit: BoxFit.contain,
    ),
    ],
    ),
    const SizedBox(height: 5),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '收藏靈感，整理角色，慢慢完成你的作品',
          maxLines: 1,
          style: GoogleFonts.notoSerifTc(
            color: primary.withValues(alpha: 0.62),
            fontSize: 12,
            letterSpacing: 0.4,
          ),
        ),
      ),
    ],
    ),
    ),
    const SizedBox(width: 42),
    ],
    ),
    ),
    Expanded(
    child: StreamBuilder<Map<String, List<QueryDocumentSnapshot>>>(
    stream: combinedStream,
    builder: (context, snapshot) {
    if (snapshot.connectionState ==
    ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(),
    );
    }

    if (snapshot.hasError) {
    return Center(
    child: Text(
    '工作室讀取失敗：${snapshot.error}',
    ),
    );
    }

    final data = snapshot.data ??
    {
    'drafts': <QueryDocumentSnapshot>[],
    'privates': <QueryDocumentSnapshot>[],
    'publics': <QueryDocumentSnapshot>[],
    };

    final drafts =
    data['drafts'] ?? <QueryDocumentSnapshot>[];

    final privates =
    data['privates'] ?? <QueryDocumentSnapshot>[];

    final publics =
    data['publics'] ?? <QueryDocumentSnapshot>[];

    return ListView(
    physics:
    const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(
    18,
    12,
    18,
    64,
    ),
    children: [
    Align(
    alignment: Alignment.centerRight,
    child: OutlinedButton.icon(
    onPressed: () async {
    await Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) =>
    const CharacterEditPage(),
    ),
    );
    },
    icon: const Icon(
    Icons.add_rounded,
    size: 21,
    ),
    label: Text(
    '新增角色',
    style: GoogleFonts.notoSerifTc(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    ),
    ),
    style: OutlinedButton.styleFrom(
    foregroundColor: primary,
    backgroundColor: theme.colorScheme.surface
        .withValues(alpha: 0.78),
    side: BorderSide(
    color: primary.withValues(alpha: 0.32),
    ),
    padding: const EdgeInsets.symmetric(
    horizontal: 17,
    vertical: 10,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
    ),
    ),
    ),
    ),

    const SizedBox(height: 18),

    _buildStudioSection(
    context: context,
    theme: theme,
    title: '公開角色',
    subtitle: '已上架，可被其他玩家認識',
    assetPath: 'assets/images/studio/studio_public.png',
    count: publics.length,
    emptyText: '目前沒有公開角色',
    documents: publics,
    status: 'public',
    ),

    const SizedBox(height: 28),

    _buildStudioSection(
    context: context,
    theme: theme,
    title: '私人角色',
    subtitle: '只有你自己看得到',
    assetPath: 'assets/images/studio/studio_private.png',
    count: privates.length,
    emptyText: '目前沒有私人角色',
    documents: privates,
    status: 'private',
    ),

    const SizedBox(height: 28),

    _buildStudioSection(
    context: context,
    theme: theme,
    title: '草稿',
    subtitle: '尚未完成的創作',
    assetPath: 'assets/images/studio/studio_draft_quill.png',
    count: drafts.length,
    emptyText: '目前沒有尚未完成的草稿',
    documents: drafts,
    status: 'draft',
    ),
    ],
    );
    },
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    );
  }
  Widget _buildStudioSection({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String subtitle,
    required String assetPath,
    required int count,
    required String emptyText,
    required List<QueryDocumentSnapshot> documents,
    required String status,
  }) {
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: 0.17)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                assetPath,
                width: status == 'draft' ? 48 : 58,
                height: status == 'draft' ? 48 : 58,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        color: primary.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withValues(alpha: 0.18)),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (documents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 28,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.58),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: primary.withValues(alpha: 0.11),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    status == 'draft' ? '這裡還沒有草稿' : emptyText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                    ),
                  ),
                  if (status == 'draft') ...[
                    const SizedBox(height: 7),
                    Text(
                      '靈感來了，就先記在這裡吧',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        color: primary.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            ...documents.map(
                  (doc) => _buildStudioCharacterCard(
                context: context,
                theme: theme,
                doc: doc,
                status: status,
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildStudioCharacterCard({
    required BuildContext context,
    required ThemeData theme,
    required QueryDocumentSnapshot doc,
    required String status,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final data =
    doc.data() as Map<String, dynamic>;

    final String characterName =
    (data['name'] ?? l10n.unnamed_draft)
        .toString();

    final String avatarPath =
    (data['avatarPath'] ?? '').toString();

    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'public':
        statusText = '已公開';
        statusIcon = Icons.public_rounded;
        break;

      case 'private':
        statusText = '私人';
        statusIcon = Icons.lock_outline_rounded;
        break;

      case 'draft':
      default:
        statusText = '草稿';
        statusIcon = Icons.edit_note_rounded;
    }

    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      elevation: 0,
      color: theme.colorScheme.surface
          .withValues(alpha: 0.82),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          if (status == 'draft') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CharacterEditPage(
                  draftDoc: doc,
                ),
              ),
            );

            return;
          }

          try {
            final character =
            await Character.fromFirestoreAsync(doc);

            if (!context.mounted) return;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CharacterEditPage(
                  character: character,
                ),
              ),
            );
          } catch (e) {
            debugPrint(
              '❌ 工作室角色開啟失敗：$e',
            );

            if (!context.mounted) return;

            ToastUtils.showCenterToast(
              context,
              '角色資料讀取失敗',
              isError: true,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: Image(
                    image: getAvatarImageProvider(
                      avatarPath.isNotEmpty
                          ? avatarPath
                          : 'assets/images/avatar1.png',
                    ),
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.08),
                        child: Icon(
                          Icons.person_rounded,
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.4),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      characterName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.055),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: 14,
                            color: theme
                                .colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12,
                              color: theme.colorScheme.primary.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (status == 'draft')
                IconButton(
                  tooltip: '刪除草稿',
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    _deleteDraft(
                      context,
                      doc.id,
                      avatarPath,
                    );
                  },
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.35),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorIntroductionCard(
      BuildContext context,
      ThemeData theme, {
        required String nickname,
        required String bio,
        required String avatarPath,
      }) {
    ImageProvider? avatarProvider;

    if (avatarPath.startsWith('http://') ||
        avatarPath.startsWith('https://')) {
      avatarProvider =
          NetworkImage(avatarPath);
    } else if (avatarPath.startsWith('assets/')) {
      avatarProvider =
          AssetImage(avatarPath);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      color: theme.colorScheme.primary
          .withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.primary
              .withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
              theme.colorScheme.primary
                  .withValues(alpha: 0.12),
              backgroundImage: avatarProvider,
              child: avatarProvider == null
                  ? Icon(
                Icons.person_rounded,
                color:
                theme.colorScheme.primary,
              )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname.isEmpty
                        ? '未命名創作者'
                        : nickname,
                    style: TextStyle(
                      color:
                      theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bio.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      bio,
                      style: TextStyle(
                        color: theme
                            .colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    Text(
                      '尚未填寫自我介紹',
                      style: TextStyle(
                        color: theme
                            .colorScheme.onSurface
                            .withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🏷️ 輔助小元件：草稿標籤
  Widget _buildDraftBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(l10n.label_draft, style: const TextStyle(color: Colors.orange, fontSize: 12)),
    );
  }

  // 🌟 新增：私人與公開的標籤 UI
  Widget _buildPrivateBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child:  Text(l10n.private, style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildPublicBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(l10n.status_published, style: const TextStyle(color: Colors.green, fontSize: 12)),
    );
  }

  // 🎨 輔助小元件：空空如也的狀態
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.brush, size: 80, color: theme.colorScheme.primary.withValues(alpha:0.3)),
          const SizedBox(height: 16),
          Text(l10n.studio_empty_title, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(l10n.studio_empty_subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
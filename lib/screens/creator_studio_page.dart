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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.my_secret_studio_title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<Map<String, List<QueryDocumentSnapshot>>>(
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
              16,
              16,
              16,
              40,
            ),
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
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
                  ),
                  label: Text(
                    l10n.create_new_character_btn,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    theme.colorScheme.primary,
                    foregroundColor:
                    theme.colorScheme.onPrimary,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildStudioSection(
                context: context,
                theme: theme,
                title: '公開角色',
                icon: Icons.public_rounded,
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
                icon: Icons.lock_outline_rounded,
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
                icon: Icons.edit_note_rounded,
                count: drafts.length,
                emptyText: '目前沒有尚未完成的草稿',
                documents: drafts,
                status: 'draft',
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildStudioSection({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required IconData icon,
    required int count,
    required String emptyText,
    required List<QueryDocumentSnapshot> documents,
    required String status,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 19,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (documents.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface
                  .withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.07),
              ),
            ),
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.45),
              ),
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
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.onSurface
              .withValues(alpha: 0.07),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
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
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 58,
                  height: 58,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
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
                          style: TextStyle(
                            fontSize: 12,
                            color: theme
                                .colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
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
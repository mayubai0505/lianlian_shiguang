import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'character_edit_page.dart';
import 'package:rxdart/rxdart.dart'; // 🌟 記得這個一定要有！

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

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.draft_cleared_success)),
        );
      }
      debugPrint("♻️ 草稿文件已移除，雲端圖片已安全留存。");
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('刪除失敗: $e')),
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
      return Scaffold(body: Center(child: Text(l10n.login_required_for_studio)));
    }

    // 🌟 總裁級三頻雷達：分別定義三個頻道的監聽器
    final draftStream = FirebaseFirestore.instance
        .collection('draft_characters')
        .where('createdBy', isEqualTo: user.uid)
        .snapshots();

    final privateStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang'))
        .collection('users')
        .doc(user.uid)
        .collection('private_characters')
        .snapshots();

    final publicStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang'))
        .collection('public_characters')
        .where('creatorId', isEqualTo: user.uid)
        .snapshots();

    // 🌟 組合技：將三個雷達畫面疊加在一起！
    final combinedStream = Rx.combineLatest3(
      draftStream,
      privateStream,
      publicStream,
          (QuerySnapshot drafts, QuerySnapshot privates, QuerySnapshot publics) {
        List<Map<String, dynamic>> allMyCharacters = [];

        for (var doc in drafts.docs) {
          allMyCharacters.add({'doc': doc, 'status': 'draft'});
        }
        for (var doc in privates.docs) {
          allMyCharacters.add({'doc': doc, 'status': 'private'});
        }
        for (var doc in publics.docs) {
          allMyCharacters.add({'doc': doc, 'status': 'public'});
        }
        return allMyCharacters;
      },
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.my_secret_studio_title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.create_new_character_btn),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CharacterEditPage()),
          );
        },
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: combinedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final charactersList = snapshot.data ?? [];

          if (charactersList.isEmpty) return _buildEmptyState(context, theme);

          return ListView.builder(
            padding: const EdgeInsets.all(16).copyWith(bottom: 100),
            itemCount: charactersList.length,
            itemBuilder: (context, index) {
              final item = charactersList[index];
              final doc = item['doc'] as QueryDocumentSnapshot;
              final status = item['status'] as String;
              final data = doc.data() as Map<String, dynamic>;

              final characterName = data['name'] ?? l10n.unnamed_draft;
              final avatarUrl = data['avatarPath'];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    backgroundImage: (avatarUrl != null && avatarUrl.startsWith('http'))
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || !avatarUrl.startsWith('http'))
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                  title: Row(
                    children: [
                      Text(characterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 8),
                      if (status == 'draft') _buildDraftBadge(context),
                      if (status == 'private') _buildPrivateBadge(context),
                      if (status == 'public') _buildPublicBadge(context),
                    ],
                  ),
                  subtitle: Text(l10n.click_to_edit_story, style: const TextStyle(color: Colors.grey)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status == 'draft')
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => _deleteDraft(context, doc.id, avatarUrl),
                        ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterEditPage(draftDoc: doc),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('已發布', style: TextStyle(color: Colors.green, fontSize: 12)),
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'character_edit_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

//私人工作室

class CreatorStudioPage extends StatelessWidget {
  const CreatorStudioPage({super.key});

  // ✨ 總裁專屬：刪除草稿與清理雲端圖片的邏輯
  Future<void> _deleteDraft(BuildContext context, String docId, String? avatarUrl) async {
    final l10n = AppLocalizations.of(context)!;
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_draft_title),
        content:Text(l10n.confirm_delete_draft_msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text(l10n.cancelButton, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child:  Text(l10n.confirm_delete_title, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      // 1. 如果有雲端照片，先去把 Storage 裡的照片刪掉，省錢！
      if (avatarUrl != null && avatarUrl.startsWith('http')) {
        try {
          final storageRef = FirebaseStorage.instance.refFromURL(avatarUrl);
          await storageRef.delete();
          print("♻️ 已回收草稿專用的雲端圖片！");
        } catch (e) {
          print("⚠️ 圖片刪除失敗 (可能已被刪除): $e");
        }
      }
      // 2. 刪除 Firestore 裡的文件
      await FirebaseFirestore.instance.collection('draft_characters').doc(docId).delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.draft_cleared_success)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('刪除失敗: $e')));
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
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:Text(l10n.my_secret_studio_title, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      // ✨ 右下角：創造新角色
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.create_new_character_btn),
        onPressed: () {
          // 🚀 導向「全新」的編輯頁面
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CharacterEditPage()),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 🌟 確保這裡的路徑跟您的 _saveToDraft 是一致的
        // 建議統一使用 collection('draft_characters').where('createdBy', isEqualTo: user.uid)
        stream: FirebaseFirestore.instance
            .collection('draft_characters')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return _buildEmptyState(context,theme);
          return ListView.builder(
            padding: const EdgeInsets.all(16).copyWith(bottom: 100),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
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
                    backgroundColor: theme.colorScheme.surfaceVariant,
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
                      _buildDraftBadge(context),
                    ],
                  ),
                  subtitle: Text(l10n.click_to_edit_story, style: TextStyle(color: Colors.grey)),
                  // 👇 把原本的 trailing 替換成這個 Row 👇
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🗑️ 垃圾桶按鈕：按下就會呼叫 _deleteDraft
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => _deleteDraft(context, doc.id, avatarUrl),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey), // 右箭頭提示可以點擊
                    ],
                  ),
                  onTap: () {
                    // 🚀 關鍵動作：跳轉並把「草稿文件」傳過去！
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
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child:Text(l10n.label_draft, style: TextStyle(color: Colors.orange, fontSize: 12)),
    );
  }

  // 🎨 輔助小元件：空空如也的狀態
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.brush, size: 80, color: theme.colorScheme.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(l10n.studio_empty_title, style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(l10n.studio_empty_subtitle, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
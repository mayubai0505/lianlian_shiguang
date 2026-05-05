import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'call_memory_detail_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//點進耳機後會看到的十筆收藏通話
class CallMemoryPage extends StatelessWidget {
  const CallMemoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.call_memory_title, style: const TextStyle(fontSize: 18)), // ✨ 替換標題
        centerTitle: true,
      ),
      body: user == null
          ? Center(child: Text(l10n.please_login_first)) // ✨ 替換未登入提示
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('call_memories')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.headset_off_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.no_call_memories, // ✨ 替換空狀態文字 (裡面已經自帶換行符號了)
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final memories = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: memories.length,
            itemBuilder: (context, index) {
              final data = memories[index].data() as Map<String, dynamic>;
              final name = data['characterName'] ?? l10n.unknown_contact;
              final duration = data['duration'] ?? 0;

              final minutesStr = (duration / 60).floor().toString().padLeft(2, '0');
              final secondsStr = (duration % 60).toString().padLeft(2, '0');
              final timeString = '$minutesStr:$secondsStr';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(data['characterAvatar'] ?? ''),
                    backgroundColor: Colors.grey[300],
                  ),
                  title: Text(l10n.call_with_name(name), style: const TextStyle(fontWeight: FontWeight.bold)), // ✨ 帶入變數的翻譯！
                  subtitle: Text(l10n.call_duration(timeString)), // ✨ 帶入變數的翻譯！

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_circle_fill, color: Colors.pinkAccent, size: 30),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.grey[400], size: 24),
                        onPressed: () {
                          _showDeleteConfirmDialog(context, memories[index].id, name, user.uid);
                        },
                      ),
                    ],
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallMemoryDetailPage(memoryData: data),
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
}

// 🗑️ 第一層：安全鎖確認視窗
void _showDeleteConfirmDialog(BuildContext context, String docId, String name, String uid) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.delete_call_title),
      content: Text(l10n.delete_call_confirm(name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.keep_it)), // ✨ 替換
        TextButton(
          onPressed: () {
            _deleteMemoryInCloud(uid, docId);
            Navigator.pop(context);
          },
          child: Text(l10n.confirm_delete, style: const TextStyle(color: Colors.red)), // ✨ 替換
        ),
      ],
    ),
  );
}

// ☁️ 第二層：後台秘密刪除邏輯
Future<void> _deleteMemoryInCloud(String uid, String docId) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('call_memories')
        .doc(docId)
        .delete();

    debugPrint("🤫 ID: $docId 的通話回憶已在背景秘密銷毀");
  } catch (e) {
    debugPrint("❌ 銷毀失敗: $e");
  }
}
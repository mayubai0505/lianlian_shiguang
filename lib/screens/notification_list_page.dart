import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'moment_detail_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//信件內容

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  // 📝 點擊信件時，標記為已讀
  Future<void> _markAsRead(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('mailbox')
        .doc(docId)
        .update({'isRead': true});
  }

  // ✨ 總裁親自撰寫的：好感度專屬情話系統 (現在支援多國語言啦！)
  String _getAffectionQuote(int score, AppLocalizations l10n) {
    if (score >= 2430) return l10n.affection_quote_lv5;
    if (score >= 1720) return l10n.affection_quote_lv4;
    if (score >= 550)  return l10n.affection_quote_lv3;
    if (score >= 150)  return l10n.affection_quote_lv2;
    if (score >= 60)   return l10n.affection_quote_lv1;
    return l10n.affection_quote_lv0;
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 呼叫翻譯官
    final l10n = AppLocalizations.of(context)!;
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mailbox_title), // 💌 替換標題
        elevation: 0,
      ),
      body: userId == null
          ? Center(child: Text(l10n.please_login_first)) // 💌 替換登入提示
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('mailbox')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(l10n.mailbox_empty, style: const TextStyle(color: Colors.grey))); // 💌 替換空信箱提示
          }

          final mailbox = snapshot.data!.docs;

          return ListView.builder(
            itemCount: mailbox.length,
            itemBuilder: (context, index) {
              final doc = mailbox[index];
              final data = doc.data() as Map<String, dynamic>;

              final bool isRead = data['isRead'] ?? true;
              final String type = data['type'] ?? 'system'; // 通知類型：like, comment, affection
              String title = data['title'] ?? l10n.new_notification;
              String body = data['body'] ?? '';
              if (type == 'follow') {
                title = l10n.mailbox_follow_title;
                final String fromName = data['fromName'] ?? l10n.default_new_player;
                body = l10n.mailbox_follow_body(fromName);
              }
              final Timestamp? createdAt = data['createdAt'];
              final String? postId = data['postId'];

              String timeText = createdAt != null ? DateFormat('MM/dd HH:mm').format(createdAt.toDate()) : '';

              // 🎨 根據信件類型，決定左邊的圖示與顏色
              Widget leadingIcon;
              if (type == 'like') {
                leadingIcon = const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.favorite, color: Colors.pinkAccent));
              } else if (type == 'comment') {
                leadingIcon = const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.chat_bubble_rounded, color: Colors.blueAccent));
              } else if (type == 'affection') {
                leadingIcon = const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.auto_awesome, color: Colors.orangeAccent));
              } else {
                leadingIcon = const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.notifications, color: Colors.grey));
              }

              // ✨ 針對「好感度升級」客製化超華麗卡片
              if (type == 'affection') {
                final int score = data['score'] ?? 0;
                final String charName = data['characterName'] ?? l10n.default_he; // 💌 替換代名詞

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isRead
                          ? [theme.cardColor, theme.cardColor]
                          : [Colors.pink.shade50, Colors.orange.shade50],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.pinkAccent.withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 8)],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Stack(
                      children: [
                        leadingIcon,
                        if (!isRead) Positioned(top: 0, right: 0, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
                      ],
                    ),
                    title: Text(l10n.affection_upgrade_title(charName), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)), // 💌 替換標題與變數
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(_getAffectionQuote(score, l10n), style: TextStyle(color: Colors.grey[800], fontStyle: FontStyle.italic)),
                        const SizedBox(height: 12),
                        // 顯示花花獎勵
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.pinkAccent.shade100)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.flower_reward, style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 12)), // 💌 替換獎勵文字
                            ],
                          ),
                        )
                      ],
                    ),
                    trailing: Text(timeText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    onTap: () => !isRead ? _markAsRead(userId, doc.id) : null,
                  ),
                );
              }

              // 💬 一般的按讚與留言通知卡片
              return Container(
                color: isRead ? Colors.transparent : theme.colorScheme.primaryContainer.withOpacity(0.15),
                child: ListTile(
                  leading: Stack(
                    children: [
                      leadingIcon,
                      if (!isRead) Positioned(top: 0, right: 0, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
                    ],
                  ),
                  title: Text(title, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                  // 留言內容部分會顯示在這裡 (例如：程安 留言：「看起來很好吃...」)
                  subtitle: Text(body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(timeText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  onTap: () async {
                    if (!isRead) {
                      await _markAsRead(userId, doc.id);
                    }

                    if (postId != null && (type == 'like' || type == 'comment')) {
                      if (!context.mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MomentDetailPage(postId: postId),
                        ),
                      );
                      return;
                    }

                    if (type == 'system') {
                      if (!context.mounted) return;

                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: Text(title),
                            content: SingleChildScrollView(
                              child: SelectableText(body),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('確定'),
                              ),
                            ],
                          );
                        },
                      );
                    }
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
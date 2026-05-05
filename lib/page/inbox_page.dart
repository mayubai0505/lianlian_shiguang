import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // 記得確保有 import 這個來格式化時間
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title:Text(l10n.private_mailbox, style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: currentUser == null
          ?  Center(child: Text(l10n.user_info_not_found))
          : StreamBuilder<QuerySnapshot>(
        // 🌟 修正 1：改為去讀取「專屬該使用者的子集合」
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('mailbox')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l10n.load_failed));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(l10n.empty_mailbox, style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          // 本地排序：把最新的通知排在最上面
          docs.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['createdAt'] as Timestamp?;
            final bTime = bData['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final DateTime? date = (data['createdAt'] as Timestamp?)?.toDate();
              final bool isRead = data['isRead'] ?? false; // 判斷已讀/未讀

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                // 未讀的信件，給一個淡淡的粉色背景
                tileColor: isRead ? null : Colors.pinkAccent.withOpacity(0.05),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: isRead ? Colors.grey[200] : Colors.pink[50],
                      // 未讀顯示粉色愛心，已讀顯示灰色信封
                      child: Icon(
                        isRead ? Icons.mark_email_read_outlined : Icons.favorite,
                        color: isRead ? Colors.grey : Colors.pinkAccent,
                      ),
                    ),
                    // 🌟 加入未讀的「小紅點」符號
                    if (!isRead)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                // 🌟 修正 2：對應寄件時的 title 欄位
                title: Text(
                  data['title'] ?? l10n.system_notification,
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold, // 未讀時標題加粗
                    fontSize: 16,
                    color: isRead ? Colors.grey[800] : Colors.black,
                  ),
                ),
                // 🌟 修正 3：像 Email 一樣的兩行式預覽 (內文 + 時間)
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      data['body'] ?? '', // 這裡會顯示 "$playerName 喜歡了..."
                      maxLines: 1, // 限制只顯示一行，太長會變成...
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isRead ? Colors.grey[500] : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date != null ? DateFormat('MM/dd HH:mm').format(date) : '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  // 點擊後，把這封信標記為「已讀」
                  if (!isRead) {
                    FirebaseFirestore.instance
                        .collection('users') // 這裡也要記得改路徑！
                        .doc(currentUser.uid)
                        .collection('mailbox')
                        .doc(docs[index].id)
                        .update({'isRead': true});
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
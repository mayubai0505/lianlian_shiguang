import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // 用來格式化時間：flutter pub add intl
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//系統公告頁面

class AnnouncementListPage extends StatelessWidget {
  const AnnouncementListPage({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title:Text(l10n.system_announcement), elevation: 0),
      body: StreamBuilder<QuerySnapshot>(
        // 🌟 1. 路徑搬家！改對齊 artifacts 新家
        stream: FirebaseFirestore.instance
            .collection('announcements') // 👈 改成直接對應後台的路徑
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 🌟 2. 裝上監視器！如果載入失敗，我們要在 Debug Console 看到死因
          if (snapshot.hasError) {
            print("🚨 公告頁面報錯：${snapshot.error}");
            return Center(child: Text('連線失敗，請檢查網路或權限'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // 🌟 3. 如果資料庫裡真的沒有公告，給個溫馨提示
          if (docs.isEmpty) {
            return Center(
              child: Text(
                '${l10n.empty_announcement} 📢', // 🌟 1. 用引號包起來，並用 ${} 放入變數
                style: const TextStyle(color: Colors.grey), // 🌟 2. style 必須放在 Text 的括號裡面
              ),
            );
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              // 🌟 4. 防呆：避免資料庫裡剛好有某篇公告漏寫 createdAt 導致整個畫面崩潰
              final Timestamp? timestamp = data['createdAt'] as Timestamp?;
              final DateTime date = timestamp?.toDate() ?? DateTime.now();

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  data['title'] ?? l10n.untitled,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    data['content'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
                trailing: Text(
                  DateFormat('MM/dd').format(date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnouncementDetailPage(
                        title: data['title'] ?? l10n.untitled,
                        content: data['content'] ?? l10n.no_content,
                        date: date,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AnnouncementDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;

  const AnnouncementDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.system_announcement)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 公告標題
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            // 發布日期
            Text(
              '發布時間：${DateFormat('yyyy/MM/dd HH:mm').format(date)}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const Divider(height: 32),
            // 完整公告內容
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.6, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
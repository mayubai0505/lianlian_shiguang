import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// 🌟 記得匯入妳的 Moment 模型和卡片 UI (如果有的話)
import '../models/moment_model.dart';
import '../screens/moment_card.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class InteractionHistoryPage extends StatefulWidget {
  final int initialIndex; // 決定一進來要看哪一頁 (0=按讚, 1=收藏)

  const InteractionHistoryPage({super.key, this.initialIndex = 0});

  @override
  State<InteractionHistoryPage> createState() => _InteractionHistoryPageState();
}

class _InteractionHistoryPageState extends State<InteractionHistoryPage> {
  // 🌟 總裁指令：統一對齊總部設定，不要再用 defaultValue 了！
  final String _appId = AppConfig.appId;

  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex, // 🌟 接收總裁的指令，決定起始分頁
      child: Scaffold(
        appBar: AppBar(
          title:Text(l10n.interaction_records, style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom:TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite, color: Colors.redAccent), text: l10n.liked_content),
              Tab(icon: Icon(Icons.bookmark, color: Colors.orangeAccent), text: l10n.my_favorites),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ❤️ 第一頁：按讚清單
            _buildFilteredMomentsList('likedBy'),

            // 🔖 第二頁：收藏清單
            _buildFilteredMomentsList('savedBy'),
          ],
        ),
      ),
    );
  }

  // ✨ 核心邏輯：根據欄位過濾並建立貼文列表
  Widget _buildFilteredMomentsList(String filterField) {
    final l10n = AppLocalizations.of(context)!;
    if (_currentUserId == null) {
      return Center(child: Text(l10n.login_to_view_records));
    }
    return StreamBuilder<QuerySnapshot>(
      // 🚀 去資料庫尋找「這個陣列裡包含我的 UID」的貼文！
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('moments')
          .where(filterField, arrayContains: _currentUserId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('讀取失敗: ${snapshot.error}'));
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    filterField == 'likedBy' ? Icons.favorite_border : Icons.bookmark_border,
                    size: 64, color: Colors.grey[400]
                ), SizedBox(height: 16),
                Text(
                  filterField == 'likedBy' ? l10n.no_likes_yet: l10n.empty_favorites,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          padding: const EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) {
            final doc = docs[index];

            // ✨ 解除封印！呼叫真正的動態卡片！
            final moment = Moment.fromFirestore(doc);
            return MomentCard(
              moment: moment,
              currentUserId: _currentUserId!,
              onLikeTapped: () {}, // 歷史紀錄頁面按讚可以不用傳送每日任務
            );
          },
        );
      },
    );
  }
}
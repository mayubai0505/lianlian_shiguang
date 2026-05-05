import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


// (StorySummary class 的定義保持不變)
class StorySummary {
  final String id;
  final String content;
  final DateTime createdAt;

  StorySummary({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  factory StorySummary.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return StorySummary(
      id: doc.id,
      content: data['content'] ?? '摘要內容為空。',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class StorySummaryPage extends StatefulWidget {  // <--- 名稱 A
  const StorySummaryPage({super.key, required this.character});
  final Character character;

  @override
  // 2. 這裡要對應到 State 類別
  State<StorySummaryPage> createState() => _StorySummaryPageState();
}

class _StorySummaryPageState extends State<StorySummaryPage> {
  // ✨ 新增 #1: 用於控制動畫列表的 Key
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // ✨ 新增 #2: 儲存資料的列表，用於比對異動
  final List<StorySummary> _summaries = [];
  bool _isInitialLoad = true;

  // 🔹 修改：確保 userId 抓取更嚴謹，不建議在 getter 裡寫死測試 ID
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<StorySummary> get _summariesCollection {
    final effectiveUserId = _userId ?? 'anonymous'; // 建議用 anonymous 或導向登入頁
    return FirebaseFirestore.instance
        .collection('users')
        .doc(effectiveUserId)
        .collection('friendships')
        .doc(widget.character.id)
        .collection('summaries')
        .withConverter<StorySummary>(
      fromFirestore: (snapshot, _) => StorySummary.fromFirestore(snapshot),
      toFirestore: (summary, _) => summary.toJson(),
    );
  }

  // 🔹 新增：刪除邏輯
  Future<void> _deleteSummary(String id) async {
    await _summariesCollection.doc(id).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已移除這段回憶')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // 🔹 修正：既然 body 已經有顏色，這裡就不需要透明和 extendBody
      appBar: AppBar(
        title: const Text('我們的故事'),
        centerTitle: true,
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: StreamBuilder<QuerySnapshot<StorySummary>>(
          stream: _summariesCollection
              .orderBy('createdAt', descending: true)
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
                    Icon(Icons.auto_stories_outlined, size: 80,
                        color: colorScheme.outline.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      '你們的故事還沒有開始...\n多聊聊天，讓 ${widget.character
                          .name} \n為你們寫下第一篇回憶吧！',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              );
            }

            // ✨ 新增 #3: 處理 Stream 資料並觸發動畫
            final newDocs = snapshot.data!.docs;
            _handleDataUpdate(newDocs);

            // ✨ 新增 #4: 使用 AnimatedList
            return AnimatedList(
              key: _listKey,
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .padding
                    .top + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              initialItemCount: _summaries.length,
              itemBuilder: (context, index, animation) {
                // 防止 Stream 更新導致索引溢出
                if (index >= _summaries.length) return Container();
                return _buildAnimatedItem(context, index, animation);
              },
            );
          },
        ),
      ),
    );
  }

  // ✨ 新增函數：比對資料並手動插入項目以觸發動畫
  void _handleDataUpdate(List<QueryDocumentSnapshot<StorySummary>> newDocs) {
    if (_isInitialLoad) {
      // 第一次載入，先將資料放入列表，不需播放動畫
      _summaries.addAll(newDocs.map((doc) => doc.data()));
      _isInitialLoad = false;
    } else {
      // 後續更新（通常是新增了一條摘要）
      if (newDocs.length > _summaries.length) {
        // 假設是在最上面新增（因為 orderBy createdAt descending）
        final newSummary = newDocs.first.data();
        // 確保不會重複加入
        if (_summaries.isEmpty || newSummary.id != _summaries.first.id) {
          _summaries.insert(0, newSummary);
          _listKey.currentState?.insertItem(
              0, duration: const Duration(milliseconds: 600));
        }
      }
    }
  }

  // ✨ 整合函數：同時擁有動畫、側滑刪除與時間線視覺
  Widget _buildAnimatedItem(BuildContext context, int index,
      Animation<double> animation) {
    final theme = Theme.of(context);
    final summary = _summaries[index];
    final colorScheme = theme.colorScheme;

    // 1. 定義進場動畫 (由下而上 + 淡入)
    final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: animation,
        // 2. 加入側滑刪除
        child: Dismissible(
          key: Key(summary.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.delete_sweep, color: colorScheme.error),
          ),
          onDismissed: (_) {
            // 注意：這裡除了刪除資料庫，也要處理本地列表
            final removedItem = _summaries.removeAt(index);
            _deleteSummary(removedItem.id);
          },
          // 3. 核心內容：時間線 + 卡片
          child: IntrinsicHeight(
            child: Row(
              children: [
                // 🔹 左側時間線視覺
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: colorScheme.primary, shape: BoxShape.circle),
                      ),
                      Expanded(child: Container(
                          width: 2, color: colorScheme.outlineVariant)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 🔹 右側故事卡片
                Expanded(
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('yyyy/MM/dd').format(
                                    summary.createdAt),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.edit_note, size: 18,
                                  color: colorScheme.outline),
                            ],
                          ),
                          const Divider(height: 24),
                          Text(
                            summary.content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6, // ✨ 小說般的閱讀行高
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
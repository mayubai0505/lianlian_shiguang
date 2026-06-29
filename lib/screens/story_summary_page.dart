import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//劇情摘要
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
      // ✨ 退回最純淨的狀態：找不到就給空字串，不要在這裡用 l10n 或 :
      content: data['content'] ?? '',
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

  DocumentReference<StorySummary> _summaryRef(String summaryId) {
    return _summariesCollection.doc(summaryId);
  }

  // 🔹 新增：刪除邏輯
  Future<void> _deleteSummary(String summaryId) async {
    await _summaryRef(summaryId).delete();
    if (mounted) {
      // ✨ 總裁級：故事摘要刪除後的輕盈回饋，確認動作已完成，不留視覺殘留！
      ToastUtils.showCenterToast(
        context,
        AppLocalizations.of(context)!.story_summary_deleted_toast,
        // 💡 總裁精選：使用 Icons.delete_outline_rounded，帶有「整理與刪除」的意象
        // 若想強調故事的「文稿」屬性，Icons.description_rounded 配上刪除意象也很有質感
        customIcon: Icons.delete_outline_rounded,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // 🔹 修正：既然 body 已經有顏色，這裡就不需要透明和 extendBody
      appBar: AppBar(
        title:Text(l10n.story_summary_title),
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
                        color: colorScheme.outline.withValues(alpha:0.5)),
                    SizedBox(height: 16),
                    Text(l10n.story_summary_empty_list(widget.character.name),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha:0.6),
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

  Future<void> _confirmDeleteSummary(dynamic summary, int index) async {
    final l10n = AppLocalizations.of(context)!;
    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_btn),
        content:  Text(l10n.about_us_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirm_delete_title,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirm) return;

    final removedItem = summary;

    setState(() {
      _summaries.removeWhere((item) => item.id == removedItem.id);
    });

    try {
      await _deleteSummary(removedItem.id);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _summaries.insert(index, removedItem);
      });

      ToastUtils.showCenterToast(
        context,
        l10n.delete_failed_msg,
        isError: true,
      );
    }
  }

  Future<void> _openEditSummaryPage(StorySummary summary) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditStorySummaryPage(
          summaryId: summary.id,
          initialContent: summary.content,
          summaryRef: _summaryRef(summary.id),
        ),
      ),
    );

    if (!mounted) return;

    if (result is Map && result['changed'] == true) {
      await _loadSummaries();
    }
  }

  Future<void> _loadSummaries() async {
    try {
      final snapshot = await _summariesCollection
          .orderBy('createdAt', descending: false)
          .get();

      if (!mounted) return;

      setState(() {
        _summaries
          ..clear()
          ..addAll(snapshot.docs.map((doc) => doc.data()).toList());
      });
    } catch (e) {
      debugPrint('❌ 重新讀取我們的故事失敗: $e');
    }
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
    final l10n = AppLocalizations.of(context)!;
    // 1. 定義進場動畫 (由下而上 + 淡入)
    final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: animation,
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
                          color: colorScheme.outlineVariant.withValues(alpha:0.5)),
                    ),
                    color: colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
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
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.edit_note,
                                  size: 20,
                                  color: colorScheme.outline,
                                ),
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await _openEditSummaryPage(summary);
                                  } else if (value == 'delete') {
                                    await _confirmDeleteSummary(summary, index);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined, size: 18),
                                        SizedBox(width: 8),
                                        Text(l10n.edit_btn),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                                        SizedBox(width: 8),
                                        Text(
                                          l10n.delete_btn,
                                          style: TextStyle(color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }
}

class EditStorySummaryPage extends StatefulWidget {
  final String summaryId;
  final String initialContent;
  final DocumentReference summaryRef;

  const EditStorySummaryPage({
    super.key,
    required this.summaryId,
    required this.initialContent,
    required this.summaryRef,
  });

  @override
  State<EditStorySummaryPage> createState() => _EditStorySummaryPageState();
}

class _EditStorySummaryPageState extends State<EditStorySummaryPage> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final l10n = AppLocalizations.of(context)!;
    final newContent = _controller.text.trim();

    if (newContent.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '故事內容不能是空的',
        isError: true,
      );
      return;
    }

    if (newContent == widget.initialContent.trim()) {
      Navigator.of(context).pop({
        'changed': false,
        'summaryId': widget.summaryId,
      });
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.summaryRef.update({
        'content': newContent,
        'updatedAt': FieldValue.serverTimestamp(),
        'lastEditedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.of(context).pop({
        'changed': true,
        'summaryId': widget.summaryId,
        'content': newContent,
      });
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.save_error_detail(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.edit_btn),
        actions: [
          _isSaving
              ? const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
              : IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '寫下你們的故事...',
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
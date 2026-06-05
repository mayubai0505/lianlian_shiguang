import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//備忘錄

// ✨ 3. 升級 Memo 模型，讓它能和 Firestore 溝通
class Memo {
  final String id;
  final String content;
  final DateTime reminderDate;
  final DateTime createdAt;

  Memo({
    required this.id,
    required this.content,
    required this.reminderDate,
    required this.createdAt,
  });

  // 從 Firestore 文件轉換成 Memo 物件
  factory Memo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Memo(
      id: doc.id,
      content: data['content'] ?? '',
      reminderDate: (data['reminderDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // 將 Memo 物件轉換成可以存入 Firestore 的 Map
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'reminderDate': Timestamp.fromDate(reminderDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class MemoPage extends StatefulWidget {
  // 1. 宣告它接收一個 Character 物件
  final Character character;

  // 2. 修改建構子
  const MemoPage({super.key, required this.character});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  bool _isLoading = false; // <-- 這個可以保留，用於某些操作
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // ✨ 修改後的通用備忘錄路徑
  CollectionReference<Memo> get _memosCollection {
    if (_userId == null) {
      return FirebaseFirestore.instance.collection('dummy').withConverter<Memo>(
        fromFirestore: (snapshot, _) => Memo.fromFirestore(snapshot),
        toFirestore: (memo, _) => memo.toJson(),
      );
    }
    // 🚀 改成這個路徑，這樣所有角色進來看到的都會是一樣的備忘錄！
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('universal_memos') // 統一名稱，不再跟隨 characterId
        .withConverter<Memo>(
      fromFirestore: (snapshot, _) => Memo.fromFirestore(snapshot),
      toFirestore: (memo, _) => memo.toJson(),
    );
  }

  Future<void> _addMemo(String content, DateTime reminderDate) async {
    if (_userId == null) return;
    await _memosCollection.add(Memo(
      id: '', // Firestore 會自動生成 ID
      content: content,
      reminderDate: reminderDate,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> _updateMemo(Memo memo, String newContent, DateTime newReminderDate) async {
    if (_userId == null) return;
    await _memosCollection.doc(memo.id).update({
      'content': newContent,
      'reminderDate': Timestamp.fromDate(newReminderDate),
    });
  }

  Future<void> _deleteMemo(String memoId) async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;
    // 增加一個確認對話框，避免誤刪
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text(l10n.confirm_delete_title),
        content:Text(l10n.memo_delete_confirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child:  Text(l10n.cancelButton
          )),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child:Text(l10n.delete_btn)),
        ],
      ),
    );
    if (confirm == true) {
      await _memosCollection.doc(memoId).delete();
    }
  }

  // --- 優化後的彈窗函數 ---
  Future<void> _showAddEditMemoDialog({Memo? existingMemo}) async {
    final TextEditingController textController =
    TextEditingController(text: existingMemo?.content);
    DateTime selectedDate = existingMemo?.reminderDate ?? DateTime.now();
    final theme = Theme.of(context); // ✨ 抓取主題
    final l10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // ✨ 圓角對齊
              title: Text(
                existingMemo == null ?l10n.memo_add_title : l10n.memo_edit_title,
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: l10n.memo_hint_text(widget.character.name),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        // ✨ 聚焦時的邊框顏色連動
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(l10n.memo_label_reminder_date),
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101),
                              // ✨ DatePicker 也可以透過 Theme 自動連動，通常不用額外設定
                            );
                            if (picked != null) {
                              setStateInDialog(() => selectedDate = picked);
                            }
                          },
                          label: Text(DateFormat('yyyy/MM/dd').format(selectedDate)),
                          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child:Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(l10n.memo_action_save),
                  onPressed: () {
                    final content = textController.text.trim();
                    if (content.isEmpty) {
                      // ✨ 總裁級：備忘錄空白防呆，輕量錯誤提示直接抓回玩家視線！
                      ToastUtils.showCenterToast(context, l10n.memo_error_empty_content, isError: true);
                      return;
                    }

                    if (existingMemo == null) {
                      _addMemo(content, selectedDate);
                    } else {
                      _updateMemo(existingMemo, content, selectedDate);
                    }
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.memo_list_title(widget.character.name)),
        backgroundColor: theme.appBarTheme.backgroundColor?.withOpacity(0.8),
        elevation: 0,
        foregroundColor: theme.colorScheme.onBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddEditMemoDialog(),
          ),
        ],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        // ✨ 5. 使用 StreamBuilder 來即時監聽 Firestore 的資料變化
        child: StreamBuilder<QuerySnapshot<Memo>>(
          stream: _memosCollection.orderBy('createdAt', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('讀取資料時發生錯誤: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  l10n.memo_empty_state,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              );
            }

            final memos = snapshot.data!.docs.map((doc) => doc.data()).toList();

            return ListView.builder(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                left: 16,
                right: 16,
              ),
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final memo = memos[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: theme.cardColor.withOpacity(0.9),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    title: Text(
                      memo.content,
                      style: theme.textTheme.bodyLarge,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        l10n.memo_reminder_date_display(DateFormat('yyyy/MM/dd').format(memo.reminderDate)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_note, color: theme.colorScheme.secondary),
                          onPressed: () => _showAddEditMemoDialog(existingMemo: memo),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                          onPressed: () => _deleteMemo(memo.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
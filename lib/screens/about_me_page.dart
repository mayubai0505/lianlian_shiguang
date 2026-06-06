import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/toast_utils.dart';
import 'character_model.dart'; // 確保您的角色模型路徑正確
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//關於我

class Memory {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isFavorite;

  Memory({
    required this.id,
    required this.text,
    required this.timestamp,
    this.isFavorite = false,
  });

  factory Memory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Memory(
      id: doc.id,
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class AboutMePage extends StatefulWidget {
  final Character character;
  const AboutMePage({super.key, required this.character});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  late final Stream<QuerySnapshot> _memoriesStream;
  late final CollectionReference _memoriesCollection;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _memoriesCollection = FirebaseFirestore.instance
          .collection('users').doc(userId)
          .collection('characters').doc(widget.character.id)
          .collection('memories');
      _memoriesStream = _memoriesCollection
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      _memoriesStream = const Stream.empty();
      _memoriesCollection = FirebaseFirestore.instance.collection('dummy');
    }
  }

  Future<void> _deleteMemory(String memoryId) async {
    final l10n = AppLocalizations.of(context)!;
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:Text(l10n.confirm_delete_title),
          content:Text(l10n.confirm_delete_memory_msg),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancelButton
                  , style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.delete_btn, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await _memoriesCollection.doc(memoryId).delete();
        if (mounted) {
          // ✨ 總裁級：刪除回憶的儀式感，用輕柔的圖示，讓那片葉子飄得更有質感！
          ToastUtils.showCenterToast(
            context,
            l10n.memory_erased_msg + ' 🍃',
            customIcon: Icons.auto_delete_rounded, // 💡 總裁精選：自動刪除圖示，簡潔俐落
            // 💡 總裁秘技：搭配你原本的 '🍃' 文字，這種圖示+文字的雙重慰藉，效果絕佳！
          );
        }
      } catch (e) {
        if (mounted) {
          // ✨ 總裁級防護：刪除失敗的專業接手
          ToastUtils.showCenterToast(
            context,
            '${l10n.delete_failed_msg}: $e',
            isError: true, // 💡 紅色驚嘆號，處理無法刪除的異常狀況
          );
        }
      }
    }
  }

  Future<void> _editMemory(Memory memory) async {
    final TextEditingController editingController = TextEditingController(text: memory.text);
    final l10n = AppLocalizations.of(context)!;

    final String? newText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.edit_memory_title),
          content: TextField(
            controller: editingController,
            autofocus: true,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              hintText: l10n.modify_memory_hint,
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelButton
                  , style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(editingController.text),
              child:Text(l10n.saveButton),
            ),
          ],
        );
      },
    );

    if (newText != null && newText.trim().isNotEmpty && newText.trim() != memory.text) {
      try {
        await _memoriesCollection.doc(memory.id).update({'text': newText.trim()});
        if (mounted) {
          // ✨ 總裁級：記憶重塑的閃耀瞬間，讓星星符號在畫面中央綻放光芒！
          ToastUtils.showCenterToast(
            context,
            l10n.memory_re_recorded_msg + ' ✨',
            customIcon: Icons.auto_awesome_rounded, // 💡 總裁精選：完美的「閃耀/魔法」圖示，與你的 ✨ 完美雙重呼應！
            // 💡 總裁秘技：Duration 已經封裝在 ToastUtils 裡，不用再手動設定，代碼更乾淨！
          );
        }
      } catch (e) {
        if (mounted) {
          // ✨ 總裁級防護：重塑失敗的專業接手，不讓系統報錯破壞畫面
          ToastUtils.showCenterToast(
            context,
            '${l10n.update_failed_msg}: $e',
            isError: true, // 💡 全域統一的紅色驚嘆號，清楚標示異常
          );
        }
      }
    }
  }

  Future<void> _toggleFavoriteStatus(Memory memory) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _memoriesCollection.doc(memory.id).update({
        'isFavorite': !memory.isFavorite
      });
    } catch (e) {
      if (mounted) {
        // ✨ 總裁級防護：收藏失敗的優雅迫降，不讓冰冷的系統錯誤破壞當下的唯美氛圍！
        ToastUtils.showCenterToast(
          context,
          '${l10n.update_favorite_failed_msg}: $e',
          isError: true, // 💡 全域統一的紅色驚嘆號，清楚標示異常狀態
        );
      }
    }
  }

  List<dynamic> _groupMemoriesByDate(List<Memory> memories) {
    if (memories.isEmpty) return [];

    final List<dynamic> items = [];
    final DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
    String? lastDate;

    for (final memory in memories) {
      final String currentDate = dayFormatter.format(memory.timestamp);
      if (currentDate != lastDate) {
        items.add(memory.timestamp);
        lastDate = currentDate;
      }
      items.add(memory);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.char_notebook_title(widget.character.name)),
        backgroundColor: theme.appBarTheme.backgroundColor?.withValues(alpha:0.8),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _memoriesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              // 🌟 記得用引號包起來，並用 ${} 包住 l10n 變數
              child: Text('${l10n.error_loading_memory}: ${snapshot.error}'),
            );
          }
          // ✨ 修復了原本報錯的「無記憶畫面」，變成精美的空狀態
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories, size: 80, color: Colors.grey.withValues(alpha:0.3)),
                  SizedBox(height: 16),
                  Text(
                    l10n.empty_notebook_msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5), fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            );
          }

          final List<Memory> memories = snapshot.data!.docs
              .map((doc) => Memory.fromFirestore(doc))
              .toList();
          final List<dynamic> groupedItems = _groupMemoriesByDate(memories);

          return ListView.builder(
            padding: const EdgeInsets.all(16.0), // 給整個列表一點呼吸空間
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              final item = groupedItems[index];
              if (item is DateTime) {
                return _buildDateHeader(item);
              } else if (item is Memory) {
                return _buildMemoryCard(item, theme);
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha:0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          DateFormat(l10n.date_format_text).format(date),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ✨ 升級版：朋友圈卡片 UI
  Widget _buildMemoryCard(Memory memory, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一層：內文
          Text(
            memory.text,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 16),

          // 第二層：底部工具列 (時間 + 操作按鈕)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 左下角：具體時間
              Text(
                DateFormat('HH:mm').format(memory.timestamp),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),

              // 右下角：互動按鈕區
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      memory.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: memory.isFavorite ? Colors.pinkAccent : Colors.grey.shade400,
                    ),
                    iconSize: 20,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    tooltip: memory.isFavorite ? l10n.remove_special_focus : l10n.mark_special_focus,
                    onPressed: () => _toggleFavoriteStatus(memory),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Colors.grey.shade400),
                    iconSize: 20,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    tooltip: l10n.edit_btn,
                    onPressed: () => _editMemory(memory),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.grey.shade400),
                    iconSize: 20,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    tooltip: l10n.delete_btn,
                    onPressed: () => _deleteMemory(memory.id),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

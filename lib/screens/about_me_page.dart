import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          '與我相關',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onSurface,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 左上飄花：保留原圖顏色，不強制染色。
          Positioned(
            left: -10,
            top: 4,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.10,
                child: Image.asset(
                  'assets/images/contact/contact_floating_petals.png',
                  width: 125,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // 右下花草 mask：跟著主題色變化。
          Positioned(
            right: -20,
            bottom: -14,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  'assets/images/chat/chat_tool_floral_right_bottom_mask.png',
                  width: 178,
                  fit: BoxFit.contain,
                  color: primary,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: _memoriesStream,
            builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primary,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '${l10n.error_loading_memory}: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        color: onSurface.withValues(alpha: 0.65),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: primary.withValues(alpha: 0.22),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          l10n.empty_notebook_msg,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSerifTc(
                            color: onSurface.withValues(alpha: 0.52),
                            fontSize: 15,
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final List<Memory> memories = snapshot.data!.docs
                  .map((doc) => Memory.fromFirestore(doc))
                  .toList();

              final List<dynamic> groupedItems =
              _groupMemoriesByDate(memories);

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 34),
                physics: const BouncingScrollPhysics(),
                itemCount: groupedItems.length,
                itemBuilder: (context, index) {
                  final item = groupedItems[index];

                  if (item is DateTime) {
                    return _buildDateHeader(item);
                  }

                  if (item is Memory) {
                    return _buildMemoryCard(item, theme);
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 1,
            color: primary.withValues(alpha: 0.30),
          ),
          const SizedBox(width: 9),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.085),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: primary.withValues(alpha: 0.16),
              ),
            ),
            child: Text(
              DateFormat(l10n.date_format_text).format(date),
              style: GoogleFonts.notoSerifTc(
                color: onSurface.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryCard(Memory memory, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.11),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 小片淡紫紙膠帶，增加手帳感。
          Positioned(
            top: 0,
            right: 30,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: -0.055,
                child: Container(
                  width: 54,
                  height: 13,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memory.text,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 15.2,
                    height: 1.72,
                    color: onSurface.withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: onSurface.withValues(alpha: 0.34),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('HH:mm').format(memory.timestamp),
                      style: GoogleFonts.notoSerifTc(
                        color: onSurface.withValues(alpha: 0.42),
                        fontSize: 11.5,
                      ),
                    ),
                    const Spacer(),

                    IconButton(
                      tooltip: memory.isFavorite
                          ? l10n.remove_special_focus
                          : l10n.mark_special_focus,
                      onPressed: () => _toggleFavoriteStatus(memory),
                      icon: Icon(
                        memory.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: memory.isFavorite
                            ? primary
                            : onSurface.withValues(alpha: 0.34),
                        size: 21,
                      ),
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                    ),
                    const SizedBox(width: 12),

                    IconButton(
                      tooltip: l10n.edit_btn,
                      onPressed: () => _editMemory(memory),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: onSurface.withValues(alpha: 0.38),
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                    ),
                    const SizedBox(width: 12),

                    IconButton(
                      tooltip: l10n.delete_btn,
                      onPressed: () => _deleteMemory(memory.id),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent.withValues(alpha: 0.70),
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

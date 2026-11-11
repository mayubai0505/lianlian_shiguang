import 'dart:async';
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
  // This reference is the actual Firestore location of this memory.
  // Never assume all memories belong to the legacy character collection.
  final DocumentReference<Map<String, dynamic>> reference;
  final String scope;

  Memory({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.reference,
    required this.scope,
    this.isFavorite = false,
  });

  factory Memory.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String scope,
  ) {
    final data = doc.data();
    final time = data['timestamp'];
    return Memory(
      id: doc.id,
      reference: doc.reference,
      scope: scope,
      text: (data['text'] ?? '').toString(),
      timestamp: time is Timestamp ? time.toDate() : DateTime.fromMillisecondsSinceEpoch(0),
      isFavorite: data['isFavorite'] == true,
    );
  }
}

class AboutMePage extends StatefulWidget {
  final Character character;
  // Pass the current room ID from chat_page.dart so the page can resolve
  // the same profile as the memory reader/writer, not a guessed profile.
  final String? sessionId;
  const AboutMePage({super.key, required this.character, this.sessionId});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  late final Stream<List<Memory>> _memoriesStream;

  @override
  void initState() {
    super.initState();
    _memoriesStream = _watchMemories();
  }

  Stream<List<Memory>> _watchMemories() async* {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      yield <Memory>[];
      return;
    }
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final roomId = widget.sessionId?.trim() ?? '';
    final sources = <String, CollectionReference<Map<String, dynamic>>>{};

    if (roomId.isNotEmpty) {
      final session = FirebaseFirestore.instance
          .collection('artifacts').doc('lianlianshiguang')
          .collection('chat_sessions').doc(roomId);
      final snap = await session.get();
      final data = snap.data();
      if (!snap.exists || data == null || data['userId'] != uid ||
          data['characterId']?.toString() != widget.character.id) {
        throw StateError('聊天室與目前玩家／角色不相符，無法讀取記憶。');
      }
      final profileId = (data['playerProfileId'] ?? '').toString().trim();
      if (profileId.isEmpty) {
        throw StateError('聊天室尚未綁定拾光檔案，無法確認記憶範圍。');
      }
      // Session facts include scene-specific appointments/relationship events.
      sources['session'] = session.collection('memories');
      if (profileId == 'default') {
        // Legacy/default persona: don't intermingle unrelated custom personas.
        sources['legacy'] = userRef.collection('characters')
            .doc(widget.character.id).collection('memories');
      } else {
        final profile = userRef.collection('profile_memories').doc(profileId);
        sources['profile'] = profile.collection('memories');
        sources['character'] = profile.collection('characters')
            .doc(widget.character.id).collection('memories');
      }
    } else {
      // Compatibility until chat_page.dart passes sessionId.
      // Deliberately don't guess the most recent profile or show other personas.
      sources['legacy'] = userRef.collection('characters')
          .doc(widget.character.id).collection('memories');
    }

    final controller = StreamController<List<Memory>>();
    final subscriptions = <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];
    final latest = <String, List<Memory>>{};
    final ready = <String>{};

    void emitIfReady() {
      if (ready.length != sources.length || controller.isClosed) return;
      final seen = <String>{};
      final all = <Memory>[];
      for (final list in latest.values) {
        for (final memory in list) {
          if (seen.add(memory.reference.path)) all.add(memory);
        }
      }
      all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      controller.add(all);
    }

    for (final entry in sources.entries) {
      final sub = entry.value.orderBy('timestamp', descending: true)
          .snapshots().listen((snapshot) {
        latest[entry.key] = snapshot.docs
            .where((doc) => doc.data()['active'] != false &&
                doc.data()['deletedByUser'] != true &&
                (doc.data()['text'] ?? '').toString().trim().isNotEmpty)
            .map((doc) => Memory.fromFirestore(doc, entry.key))
            .toList();
        ready.add(entry.key);
        emitIfReady();
      }, onError: (Object error, StackTrace stack) {
        if (!controller.isClosed) controller.addError(error, stack);
      });
      subscriptions.add(sub);
    }

    controller.onCancel = () async {
      for (final sub in subscriptions) {
        await sub.cancel();
      }
    };
    yield* controller.stream;
  }

  Future<void> _deleteMemory(Memory memory) async {
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
        if (memory.scope == 'legacy') {
          await memory.reference.delete();
        } else {
          // Soft delete: prevents a retrieved memory from resurfacing in RAG.
          await memory.reference.update({
            'active': false,
            'deletedByUser': true,
            'retrievalTerms': <String>[],
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
        if (mounted) {
          ToastUtils.showCenterToast(
            context,
            l10n.memory_erased_msg + ' 🍃',
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
        await memory.reference.update({'text': newText.trim(), 'updatedAt': FieldValue.serverTimestamp()});
        if (mounted) {
          ToastUtils.showCenterToast(
            context,
            l10n.memory_re_recorded_msg + ' ✨',
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
      await memory.reference.update({
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
          l10n.chat_menu_aboutme,
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
                  'assets/images/contact/contact_floating_petals.webp',
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

          StreamBuilder<List<Memory>>(
            stream: _memoriesStream,
            builder: (
                BuildContext context,
                AsyncSnapshot<List<Memory>> snapshot,
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

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

              final List<Memory> memories = snapshot.data!;

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
                      icon: Image.asset(
                        'assets/images/chat/chat_pin_bookmark.webp',
                        width: 21,
                        height: 21,
                        color: memory.isFavorite
                            ? primary
                            : onSurface.withValues(alpha: 0.34),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                    ),
                    const SizedBox(width: 12),

                    IconButton(
                      tooltip: l10n.edit_btn,
                      onPressed: () => _editMemory(memory),
                      icon: Image.asset(
                        'assets/images/profile/profile_quill_mask.webp',
                        width: 20,
                        height: 20,
                        color: onSurface.withValues(alpha: 0.38),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      padding: const EdgeInsets.all(5),
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                    ),
                    const SizedBox(width: 12),

                    IconButton(
                      tooltip: l10n.delete_btn,
                      onPressed: () => _deleteMemory(memory),
                      icon: Image.asset(
                        'assets/images/chat/chat_msg_delete_mask.webp',
                        width: 20,
                        height: 20,
                        color: Colors.redAccent.withValues(alpha: 0.70),
                        colorBlendMode: BlendMode.srcIn,
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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/reminder_notification_service.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
import 'memo_editor_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//備忘錄
class MemoReminderCharacter {
  final String id;
  final String name;
  final String personalityType;

  const MemoReminderCharacter({
    required this.id,
    required this.name,
    required this.personalityType,
  });
}
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
    // 每個角色使用自己的備忘錄集合：
    // users/{uid}/characters/{characterId}/memos
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('characters')
        .doc(widget.character.id)
        .collection('memos')
        .withConverter<Memo>(
      fromFirestore: (snapshot, _) => Memo.fromFirestore(snapshot),
      toFirestore: (memo, _) => memo.toJson(),
    );
  }

  Future<void> _addMemo(
      String content,
      DateTime reminderDate,
      ) async {
    if (_userId == null) return;

    final bool notificationGranted =
    await ReminderNotificationService
        .requestPermission();

    if (!notificationGranted && mounted) {
      ToastUtils.showCenterToast(
        context,
        '尚未開啟通知權限，備忘錄仍會儲存，但不會顯示系統提醒。',
        isError: true,
      );
    }

    // 💌 使用目前聊天室角色作為提醒角色。
    final MemoReminderCharacter
    reminderCharacter =
    await _findMostChattedCharacter();

    final docRef =
    _memosCollection.doc();

    final memo = Memo(
      id: docRef.id,
      content: content,
      reminderDate: reminderDate,
      createdAt: DateTime.now(),
    );

    /*
   * 因為 Memo.toJson() 目前沒有提醒角色欄位，
   * 這裡直接用 Map 寫入額外資料。
   */
    await docRef.set(memo);

    await docRef.update({
      'reminderCharacterId':
      reminderCharacter.id,
      'reminderCharacterName':
      reminderCharacter.name,
      'reminderPersonalityType':
      reminderCharacter.personalityType,
      'notificationEnabled':
      notificationGranted,
    });

    if (notificationGranted) {
      await ReminderNotificationService
          .scheduleMemoNotification(
        memoId: docRef.id,
        reminderDateTime: reminderDate,
        characterName: reminderCharacter.name,
        memoContent: content,
        characterId: reminderCharacter.id,
        personalityType:
        reminderCharacter.personalityType,
      );
    }

    if (!mounted) return;

    ToastUtils.showCenterToast(
      context,
      notificationGranted
          ? '備忘錄已儲存，${reminderCharacter.name} 會提醒你！'
          : '備忘錄已儲存，但尚未開啟通知權限。',
      customIcon:
      Icons.notifications_active_outlined,
    );
    final pending =
    await ReminderNotificationService
        .getPendingNotifications();

    debugPrint(
        '目前通知數量：${pending.length}');

    for (final n in pending) {
      debugPrint(
          '${n.id} ${n.title} ${n.body}');
    }
  }

  Future<MemoReminderCharacter>
  _findMostChattedCharacter() async {
    final String? userId = _userId;

    // 備忘錄現在是角色專屬：
    // 在哪個角色聊天室新增，就由哪個角色負責提醒。
    if (userId == null) {
      return MemoReminderCharacter(
        id: widget.character.id,
        name: widget.character.name,
        personalityType: '',
      );
    }

    String personalityType = '';

    try {
      // 優先讀公開角色資料，保留原本依角色個性產生提醒文案的能力。
      final publicCharacterDoc =
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(
        const String.fromEnvironment(
          'APP_ID',
          defaultValue: 'lianlianshiguang',
        ),
      )
          .collection('public_characters')
          .doc(widget.character.id)
          .get();

      Map<String, dynamic> characterData =
          publicCharacterDoc.data() ?? <String, dynamic>{};

      // 公開角色找不到時，再讀玩家自己的私人角色。
      if (characterData.isEmpty) {
        final privateCharacterDoc =
        await FirebaseFirestore.instance
            .collection('artifacts')
            .doc(
          const String.fromEnvironment(
            'APP_ID',
            defaultValue: 'lianlianshiguang',
          ),
        )
            .collection('users')
            .doc(userId)
            .collection('private_characters')
            .doc(widget.character.id)
            .get();

        characterData =
            privateCharacterDoc.data() ?? <String, dynamic>{};
      }

      final List<String> personalityParts = <String>[];

      final String detailedPersonality =
          characterData['detailedPersonality']
              ?.toString()
              .trim() ??
              '';

      final String toneAndStyle =
          characterData['toneAndStyle']
              ?.toString()
              .trim() ??
              '';

      final String personality =
          characterData['personality']
              ?.toString()
              .trim() ??
              '';

      if (detailedPersonality.isNotEmpty) {
        personalityParts.add(detailedPersonality);
      }

      if (toneAndStyle.isNotEmpty) {
        personalityParts.add(toneAndStyle);
      }

      if (personality.isNotEmpty) {
        personalityParts.add(personality);
      }

      final dynamic rawTags =
      characterData['personalityTags'];

      if (rawTags is List) {
        personalityParts.addAll(
          rawTags
              .map((tag) => tag.toString().trim())
              .where((tag) => tag.isNotEmpty),
        );
      }

      personalityType = personalityParts.join(' ');
    } catch (error, stackTrace) {
      debugPrint(
        '讀取目前角色提醒個性失敗：$error',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );
    }

    return MemoReminderCharacter(
      id: widget.character.id,
      name: widget.character.name,
      personalityType: personalityType,
    );
  }


  Future<void> _updateMemo(
      Memo memo,
      String newContent,
      DateTime newReminderDate,
      ) async {
    if (_userId == null) return;

    final bool permissionGranted =
    await ReminderNotificationService
        .requestPermission();

    final MemoReminderCharacter
    reminderCharacter =
    await _findMostChattedCharacter();

    await _memosCollection
        .doc(memo.id)
        .update({
      'content': newContent,
      'reminderDate':
      Timestamp.fromDate(
        newReminderDate,
      ),
      'reminderCharacterId':
      reminderCharacter.id,
      'reminderCharacterName':
      reminderCharacter.name,
      'reminderPersonalityType':
      reminderCharacter.personalityType,
      'notificationEnabled':
      permissionGranted,
      'updatedAt':
      FieldValue.serverTimestamp(),
    });

    if (permissionGranted) {
      await ReminderNotificationService
          .rescheduleMemoNotification(
        memoId: memo.id,
        reminderDateTime:
        newReminderDate,
        characterName:
        reminderCharacter.name,
        memoContent: newContent,
        characterId:
        reminderCharacter.id,
        personalityType:
        reminderCharacter.personalityType,
      );
    } else {
      // 原本有通知但玩家後來關閉權限時，
      // 至少取消 App 中既有的排程。
      await ReminderNotificationService
          .cancelMemoNotification(
        memo.id,
      );
    }

    if (!mounted) return;

    ToastUtils.showCenterToast(
      context,
      permissionGranted
          ? '備忘錄已更新，${reminderCharacter.name} 會提醒你！'
          : '備忘錄已更新，但目前沒有通知權限。',
      customIcon:
      Icons.notifications_active_outlined,
    );
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
      await ReminderNotificationService
          .cancelMemoNotification(
        memoId,
      );

      await _memosCollection.doc(memoId).delete();
    }
  }

  Future<void> _openMemoEditor({Memo? existingMemo}) async {
    final MemoEditorResult? result =
    await Navigator.push<MemoEditorResult>(
      context,
      MaterialPageRoute(
        builder: (_) => MemoEditorPage(
          characterName: widget.character.name,
          initialContent: existingMemo?.content ?? '',
          initialReminderDate:
          existingMemo?.reminderDate ?? DateTime.now(),
          isEditing: existingMemo != null,
        ),
      ),
    );

    if (result == null || !mounted) return;

    if (existingMemo == null) {
      await _addMemo(
        result.content,
        result.reminderDate,
      );
    } else {
      await _updateMemo(
        existingMemo,
        result.content,
        result.reminderDate,
      );
    }
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
          l10n.memo_list_title(widget.character.name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onSurface,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.memo_add_title,
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: primary,
              size: 30,
            ),
            onPressed: () => _openMemoEditor(),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            right: -22,
            bottom: -16,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  'assets/images/chat/chat_tool_floral_right_bottom_mask.png',
                  width: 185,
                  fit: BoxFit.contain,
                  color: primary,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot<Memo>>(
            stream: _memosCollection
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
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
                      '讀取資料時發生錯誤: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        color: onSurface.withValues(alpha: 0.60),
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return _buildEmptyState(
                  context,
                  l10n,
                );
              }

              final memos = snapshot.data!.docs
                  .map((doc) => doc.data())
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  14,
                  18,
                  36,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: memos.length,
                itemBuilder: (context, index) {
                  final memo = memos[index];
                  return _buildMemoCard(
                    context,
                    memo,
                    l10n,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 20, 32, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.22,
              child: Image.asset(
                'assets/images/chat/chat_menu_memo_mask.png',
                width: 112,
                height: 112,
                fit: BoxFit.contain,
                color: primary,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.menu_book_outlined,
                  size: 82,
                  color: primary,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              l10n.memo_empty_state,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                color: onSurface.withValues(alpha: 0.54),
                fontSize: 15.5,
                height: 1.75,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoCard(
      BuildContext context,
      Memo memo,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.11),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openMemoEditor(
          existingMemo: memo,
        ),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 17, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                memo.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 15.5,
                  height: 1.65,
                  color: onSurface.withValues(alpha: 0.86),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 16,
                    color: primary.withValues(alpha: 0.68),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.memo_reminder_date_display(
                        DateFormat('yyyy/MM/dd HH:mm')
                            .format(memo.reminderDate),
                      ),
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11.8,
                        color: onSurface.withValues(alpha: 0.46),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.memo_edit_title,
                    onPressed: () => _openMemoEditor(
                      existingMemo: memo,
                    ),
                    icon: Image.asset(
                      'assets/images/chat/chat_msg_edit_mask.png',
                      width: 28,
                      height: 28,
                      color: primary,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.delete_btn,
                    onPressed: () => _deleteMemo(memo.id),
                    icon: Image.asset(
                      'assets/images/chat/chat_msg_delete_mask.png',
                      width: 28,
                      height: 28,
                      color: theme.colorScheme.error,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

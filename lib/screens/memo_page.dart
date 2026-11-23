import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

class _MemoPageState extends State<MemoPage> with SingleTickerProviderStateMixin {
  late final TabController _memoTabs;

  // 正式約定與玩家手動備忘完全分離。約定只能由後端在玩家確認後建立。
  CollectionReference<Map<String, dynamic>>? get _agreementsCollection {
    final uid = _userId;
    if (uid == null || uid.isEmpty) return null;
    return FirebaseFirestore.instance
        .collection('role_agreements').doc(uid)
        .collection('characters').doc(widget.character.id).collection('items');
  }

  @override
  void initState() {
    super.initState();
    _memoTabs = TabController(length: 2, vsync: this);
    _memoTabs.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _memoTabs.dispose();
    super.dispose();
  }

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
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;

    final bool notificationGranted =
    await ReminderNotificationService
        .requestPermission();

    if (!notificationGranted && mounted) {
      ToastUtils.showCenterToast(
        context,
        l10n.memo_notification_permission_missing,
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
          ? l10n.memo_saved_with_reminder(reminderCharacter.name)
          : l10n.memo_saved_without_notification,
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
    final l10n = AppLocalizations.of(context)!;
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
          ? l10n.memo_updated_with_reminder(reminderCharacter.name)
          : l10n.memo_updated_without_notification,
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
        bottom: TabBar(
          controller: _memoTabs,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: onSurface.withValues(alpha: 0.54),
          tabs: const [
            Tab(text: '我的備忘'),
            Tab(text: '角色約定'),
          ],
        ),
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _userId == null ? null : FirebaseFirestore.instance
                .collection('users').doc(_userId).snapshots(),
            builder: (context, snapshot) {
              final on = snapshot.data?.data()?['roleAgreementDndEnabled'] == true;
              return IconButton(
                tooltip: on ? '約定勿擾已開啟（23:00–08:00）' : '約定勿擾設定',
                icon: Icon(on ? Icons.bedtime_rounded : Icons.bedtime_outlined,
                  color: on ? primary : onSurface.withValues(alpha: 0.65)),
                onPressed: () async {
                  final uid = _userId;
                  if (uid == null) return;
                  final enable = await showDialog<bool>(context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('角色約定勿擾'),
                      content: Text(on
                        ? '目前已啟用 23:00–08:00 勿擾。此時段到期的約定不會發送提醒或來電；不會延後補打。要關閉嗎？'
                        : '是否啟用 23:00–08:00 勿擾？此時段到期的約定會標示「勿擾時段未發送」，不會補打電話。'),
                      actions: [
                        TextButton(onPressed:()=>Navigator.pop(dialogContext),child:const Text('取消')),
                        FilledButton(onPressed:()=>Navigator.pop(dialogContext,true),
                          child:Text(on?'關閉勿擾':'啟用勿擾')),
                      ],
                    ));
                  if (enable != true) return;
                  try {
                    await FirebaseFirestore.instance.collection('users').doc(uid).set({
                      'roleAgreementDndEnabled': !on,
                      'roleAgreementTimezoneOffsetMinutes':DateTime.now().timeZoneOffset.inMinutes,
                    },SetOptions(merge:true));
                  } catch(e) {
                    if (mounted) ToastUtils.showCenterToast(context,'設定勿擾失敗：$e',isError:true);
                  }
                },
              );
            },
          ),
          if (_memoTabs.index == 0) IconButton(
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
      body: TabBarView(
        controller: _memoTabs,
        children: [
          Stack(
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
                      l10n.memo_load_error(snapshot.error.toString()),
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
          _buildRoleAgreements(),
        ],
      ),
    );
  }

  // 正式取消才更新雲端，刪除本機畫面不等於取消排程。
  Future<void> _cancelRoleAgreement(String agreementId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('取消角色約定？'),
        content: const Text('取消後，這項約定將不再執行。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('返回')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('確認取消')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('cancelRoleAgreement').call({
        'characterId': widget.character.id,
        'agreementId': agreementId,
      });
      if (mounted) ToastUtils.showCenterToast(context, '已取消角色約定');
    } catch (e) {
      if (mounted) ToastUtils.showCenterToast(context, '取消失敗：$e', isError: true);
    }
  }

  // 只讀取正式約定。待同意提案不可顯示在這裡，避免誤導玩家已排程。
  Widget _buildRoleAgreements() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final collection = _agreementsCollection;
    if (collection == null) {
      return const Center(child: Text('請先登入後查看角色約定'));
    }
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: collection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('角色約定載入失敗：${snapshot.error}', textAlign: TextAlign.center),
          ));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: primary, strokeWidth: 2));
        }
        final docs = snapshot.data!.docs.where((doc) {
          final status = doc.data()['status']?.toString() ?? '';
          return status != 'proposal' && status != 'pending_confirmation';
        }).toList();
        docs.sort((a, b) {
          final at = a.data()['scheduledAt'];
          final bt = b.data()['scheduledAt'];
          final aTime = at is Timestamp ? at.millisecondsSinceEpoch : 0;
          final bTime = bt is Timestamp ? bt.millisecondsSinceEpoch : 0;
          return bTime.compareTo(aTime);
        });
        if (docs.isEmpty) {
          return Center(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.event_available_outlined, color: primary.withValues(alpha: .55), size: 56),
              const SizedBox(height: 18),
              Text('還沒有角色約定', style: GoogleFonts.notoSerifTc(
                fontSize: 17, fontWeight: FontWeight.w600, color: onSurface)),
              const SizedBox(height: 10),
              Text('在角色的閒聊模式中，約好提醒時間並完成確認後，約定就會顯示在這裡。',
                textAlign: TextAlign.center, style: TextStyle(color: onSurface.withValues(alpha: .6), height: 1.6)),
            ]),
          ));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data();
            final content = (data['content'] ?? '').toString();
            final scheduledAt = data['scheduledAt'];
            final when = scheduledAt is Timestamp
                ? DateFormat('yyyy/MM/dd HH:mm').format(scheduledAt.toDate())
                : '時間待確認';
            final isCall = data['method'] == 'call';
            final status = (data['status'] ?? 'scheduled').toString();
            final statusText = switch (status) {
              'scheduled' => '已約定',
              'pending_delivery' => '待啟用提醒',
              'completed' => '已完成',
              'cancelled' => '已取消',
              'missed' => '未接聽',
              'ringing' => '等待接聽',
              'accepted' => '通話中',
              'connection_failed' => '連線失敗（已退花）',
              'delivery_failed' => '通知發送失敗',
              'suppressed_dnd' => '勿擾時段未發送',
              _ => '狀態：$status',
            };
            return Card(
              color: theme.colorScheme.surface,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(isCall ? Icons.phone_in_talk_outlined : Icons.notifications_active_outlined,
                      color: primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(isCall ? '角色主動來電' : '訊息提醒',
                      style: TextStyle(color: primary, fontWeight: FontWeight.w600))),
                    Text(statusText, style: TextStyle(color: onSurface.withValues(alpha: .56), fontSize: 12)),
                  ]),
                  const SizedBox(height: 12),
                  Text(content.isEmpty ? '未填寫約定內容' : content,
                    style: GoogleFonts.notoSerifTc(fontSize: 15, color: onSurface)),
                  const SizedBox(height: 9),
                  Text(when, style: TextStyle(color: onSurface.withValues(alpha: .65), fontSize: 12)),
                  if (status == 'pending_delivery' || status == 'scheduled' || status == 'ringing')
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _cancelRoleAgreement(docs[index].id),
                        icon: const Icon(Icons.event_busy_outlined, size: 18),
                        label: const Text('取消約定'),
                      ),
                    ),
                  if (isCall) Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('接聽前確認扣除 20 花花；未接聽不扣費',
                      style: TextStyle(color: onSurface.withValues(alpha: .56), fontSize: 11)),
                  ),
                ]),
              ),
            );
          },
        );
      },
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
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
                      'assets/images/chat/chat_msg_edit_mask.webp',
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
                      'assets/images/chat/chat_msg_delete_mask.webp',
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
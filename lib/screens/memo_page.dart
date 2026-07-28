import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/reminder_notification_service.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
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

    // 💌 找出最近聊天最多的角色。
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

    // 找不到玩家時，使用目前所在角色保底。
    if (userId == null) {
      return MemoReminderCharacter(
        id: widget.character.id,
        name: widget.character.name,
        personalityType: '',
      );
    }

    try {
      final snapshot =
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(
        const String.fromEnvironment(
          'APP_ID',
          defaultValue:
          'lianlianshiguang',
        ),
      )
          .collection('chat_sessions')
          .where(
        'userId',
        isEqualTo: userId,
      )
          .orderBy(
        'updatedAt',
        descending: true,
      )
          .limit(30)
          .get();

      // 沒有聊天資料時，使用目前角色。
      if (snapshot.docs.isEmpty) {
        return MemoReminderCharacter(
          id: widget.character.id,
          name: widget.character.name,
          personalityType: '',
        );
      }

      final Map<String, int>
      scoreByCharacter = <String, int>{};

      final Map<String, String>
      nameByCharacter = <String, String>{};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final String characterId =
            data['characterId']
                ?.toString()
                .trim() ??
                '';

        if (characterId.isEmpty) {
          continue;
        }

        final String characterName =
            data['characterName']
                ?.toString()
                .trim() ??
                '';

        final int messageCount =
            (data['messageCount'] as num?)
                ?.toInt() ??
                1;

        scoreByCharacter[characterId] =
            (scoreByCharacter[characterId] ??
                0) +
                messageCount;

        if (characterName.isNotEmpty) {
          nameByCharacter[characterId] =
              characterName;
        }
      }

      if (scoreByCharacter.isEmpty) {
        return MemoReminderCharacter(
          id: widget.character.id,
          name: widget.character.name,
          personalityType: '',
        );
      }

      final sortedEntries =
      scoreByCharacter.entries.toList()
        ..sort(
              (a, b) =>
              b.value.compareTo(a.value),
        );

      final String topCharacterId =
          sortedEntries.first.key;

      String topCharacterName =
          nameByCharacter[topCharacterId] ??
              '';

      String personalityType = '';

      // 不論聊天室裡有沒有名字，
      // 都讀取角色文件取得個性資料。
      final publicCharacterDoc =
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(
        const String.fromEnvironment(
          'APP_ID',
          defaultValue:
          'lianlianshiguang',
        ),
      )
          .collection(
        'public_characters',
      )
          .doc(topCharacterId)
          .get();

      Map<String, dynamic> characterData =
          publicCharacterDoc.data() ??
              <String, dynamic>{};

      /*
     * 如果公開角色集合找不到，
     * 再嘗試讀取玩家自己的私人角色。
     */
      if (characterData.isEmpty) {
        final privateCharacterDoc =
        await FirebaseFirestore.instance
            .collection('artifacts')
            .doc(
          const String.fromEnvironment(
            'APP_ID',
            defaultValue:
            'lianlianshiguang',
          ),
        )
            .collection('users')
            .doc(userId)
            .collection(
          'private_characters',
        )
            .doc(topCharacterId)
            .get();

        characterData =
            privateCharacterDoc.data() ??
                <String, dynamic>{};
      }

      // chat_sessions 沒有名字時，
      // 改從角色文件取得。
      if (topCharacterName.isEmpty) {
        topCharacterName =
            characterData['name']
                ?.toString()
                .trim() ??
                '';
      }

      final List<String> personalityParts =
      <String>[];

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
        personalityParts.add(
          detailedPersonality,
        );
      }

      if (toneAndStyle.isNotEmpty) {
        personalityParts.add(
          toneAndStyle,
        );
      }

      if (personality.isNotEmpty) {
        personalityParts.add(
          personality,
        );
      }

      final dynamic rawTags =
      characterData['personalityTags'];

      if (rawTags is List) {
        personalityParts.addAll(
          rawTags
              .map(
                (tag) =>
                tag.toString().trim(),
          )
              .where(
                (tag) => tag.isNotEmpty,
          ),
        );
      }

      personalityType =
          personalityParts.join(' ');

      return MemoReminderCharacter(
        id: topCharacterId,
        name: topCharacterName.isEmpty
            ? widget.character.name
            : topCharacterName,
        personalityType:
        personalityType,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '尋找最常聊天角色失敗：$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      // 發生錯誤時使用目前角色，
      // 不讓備忘錄儲存失敗。
      return MemoReminderCharacter(
        id: widget.character.id,
        name: widget.character.name,
        personalityType: '',
      );
    }
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.memo_label_reminder_date,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.calendar_today,
                              size: 18,
                            ),
                            onPressed: () async {
                              final DateTime? pickedDate =
                              await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate == null) return;

                              final TimeOfDay? pickedTime =
                              await showTimePicker(
                                context: context,
                                initialTime:
                                TimeOfDay.fromDateTime(
                                  selectedDate,
                                ),
                              );

                              if (pickedTime == null) return;

                              setStateInDialog(() {
                                selectedDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            },
                            label: Text(
                              DateFormat(
                                'yyyy/MM/dd HH:mm',
                              ).format(selectedDate),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                              theme.colorScheme.primary,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                            ),
                          ),
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
                  onPressed: () async {
                    final content =
                    textController.text.trim();

                    if (content.isEmpty) {
                      ToastUtils.showCenterToast(
                        context,
                        l10n.memo_error_empty_content,
                        isError: true,
                      );
                      return;
                    }

                    if (existingMemo == null) {
                      await _addMemo(
                        content,
                        selectedDate,
                      );
                    } else {
                      await _updateMemo(
                        existingMemo,
                        content,
                        selectedDate,
                      );
                    }

                    if (!dialogContext.mounted) return;

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
                        l10n.memo_reminder_date_display(DateFormat('yyyy/MM/dd HH:mm').format(memo.reminderDate)),
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
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart'; // 記得確保有 import 這個來格式化時間
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../screens/moment_detail_page.dart'; // 🌟 記得匯入這頁！
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool _badgeSyncStarted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _badgeSyncStarted) return;
      _badgeSyncStarted = true;
      _repairLegacyReadFieldsAndSyncBadge();
    });
  }

  Future<void> _syncAppBadge() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable(
        'syncNotificationBadge',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 15),
        ),
      );

      final response = await callable.call();
      final raw = response.data;
      final dynamic countValue = raw is Map ? raw['unreadCount'] : null;
      final int? unreadCount = countValue is num
          ? countValue.toInt()
          : int.tryParse('$countValue');
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS &&
          unreadCount != null && FirebaseAuth.instance.currentUser?.uid == user.uid) {
        await AppBadgePlus.updateBadge(unreadCount < 0 ? 0 : unreadCount);
      }
      debugPrint('✅ App badge 已同步：$unreadCount');
    } on FirebaseFunctionsException catch (e) {
      debugPrint('⚠️ App badge 同步失敗：${e.code} / ${e.message}');
    } catch (e) {
      debugPrint('⚠️ App badge 同步失敗：$e');
    }
  }

  Future<void> _repairLegacyReadFieldsAndSyncBadge() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final mailboxRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('mailbox');

      final snapshot = await mailboxRef.get();

      WriteBatch? batch;
      int repairCount = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final bool? isRead = data['isRead'] is bool
            ? data['isRead'] as bool
            : null;
        final bool? legacyRead = data['read'] is bool
            ? data['read'] as bool
            : null;

        final Map<String, dynamic> updates = <String, dynamic>{};

        if (isRead == true && legacyRead != true) {
          updates['read'] = true;
        } else if (legacyRead == true && isRead != true) {
          updates['isRead'] = true;
        }

        if (updates.isNotEmpty) {
          batch ??= FirebaseFirestore.instance.batch();
          batch.update(doc.reference, updates);
          repairCount++;
        }
      }

      if (batch != null) {
        await batch.commit();
        debugPrint('✅ 已修正 $repairCount 筆舊通知已讀欄位');
      }
    } catch (e) {
      // 舊資料修正失敗不阻擋信箱使用。
      debugPrint('⚠️ 修正舊通知已讀欄位失敗：$e');
    }

    await _syncAppBadge();
  }


  Future<void> _openMailboxItem(
      BuildContext context, {
        required Map<String, dynamic> data,
        required AppLocalizations l10n,
      }) async {
    final String type = (data['type'] ?? '').toString();
    final String reportId = (data['reportId'] ?? '').toString().trim();

    // 一般通知維持原本行為；客服信才進完整信件內容。
    if (type != 'cs_received' && type != 'cs_reply') {
      return;
    }

    Map<String, dynamic> reportData = <String, dynamic>{};

    if (reportId.isNotEmpty) {
      try {
        final reportSnapshot = await FirebaseFirestore.instance
            .collection('reports')
            .doc(reportId)
            .get();

        reportData = reportSnapshot.data() ?? <String, dynamic>{};
      } catch (e) {
        debugPrint('⚠️ 讀取客服案件原始內容失敗：$e');
      }
    }

    if (!context.mounted) return;

    final String reportTitle = (
        reportData['title'] ??
            reportData['subject'] ??
            reportData['categoryLabel'] ??
            reportData['reason'] ??
            ''
    ).toString().trim();

    final String reportReason =
    (reportData['reason'] ?? '').toString().trim();

    final String originalTitle = reportTitle.isNotEmpty
        ? (reportReason.isNotEmpty &&
        reportReason != reportTitle
        ? '$reportTitle－$reportReason'
        : reportTitle)
        : appL10n.inbox_customer_service_report;

    final String originalBody =
    (reportData['content'] ??
        reportData['body'] ??
        reportData['message'] ??
        '')
        .toString()
        .trim();

    final String replyBody =
    type == 'cs_reply'
        ? (data['body'] ?? '').toString().trim()
        : (reportData['adminReply'] ?? '').toString().trim();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        Widget label(String text) {
          return Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          );
        }

        Widget contentText(String text) {
          return SelectableText(
            text.isEmpty ? '—' : text,
            style: TextStyle(
              fontSize: 15,
              height: 1.65,
              color: theme.colorScheme.onSurface,
            ),
          );
        }

        return AlertDialog(
          title: Text(
            type == 'cs_reply' ? '客服回覆' : appL10n.inbox_content_text_message_customer_service_message_send,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  label(appL10n.inbox_content_text_message_player_title_send),
                  const SizedBox(height: 6),
                  contentText(originalTitle),

                  const SizedBox(height: 18),

                  label(appL10n.inbox_content_text_message_player_content_send),
                  const SizedBox(height: 6),
                  contentText(originalBody),

                  if (replyBody.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    const Divider(),
                    const SizedBox(height: 14),

                    label('客服回覆'),
                    const SizedBox(height: 6),
                    contentText(replyBody),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title:Text(l10n.private_mailbox, style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: currentUser == null
          ?  Center(child: Text(l10n.user_info_not_found))
          : StreamBuilder<QuerySnapshot>(
        // 🌟 修正 1：改為去讀取「專屬該使用者的子集合」
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('mailbox')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l10n.load_failed));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Text(l10n.empty_mailbox, style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          // 本地排序：把最新的通知排在最上面
          docs.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['createdAt'] as Timestamp?;
            final bTime = bData['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final DateTime? date = (data['createdAt'] as Timestamp?)?.toDate();
              final bool isRead = data['isRead'] ?? false; // 判斷已讀/未讀
              final String bodyText = (data['body'] ?? '').toString();
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                // 未讀的信件，給一個淡淡的粉色背景
                tileColor: isRead ? null : Colors.pinkAccent.withValues(alpha:0.05),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: isRead ? Colors.grey[200] : Colors.pink[50],
                      // 未讀顯示粉色愛心，已讀顯示灰色信封
                      child: Icon(
                        isRead ? Icons.mark_email_read_outlined : Icons.favorite,
                        color: isRead ? Colors.grey : Colors.pinkAccent,
                      ),
                    ),
                    // 🌟 加入未讀的「小紅點」符號
                    if (!isRead)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                // 🌟 修正 2：對應寄件時的 title 欄位
                title: Text(
                  data['title'] ?? l10n.system_notification,
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold, // 未讀時標題加粗
                    fontSize: 16,
                    color: isRead ? Colors.grey[800] : Colors.black,
                  ),
                ),
                // 🌟 修正 3：像 Email 一樣的兩行式預覽 (內文 + 時間)
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      bodyText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isRead ? Colors.grey[500] : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date != null ? DateFormat('MM/dd HH:mm').format(date) : '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () async {
                  // 1. 點擊後，同步更新新版 isRead 與舊版 read。
                  //    舊版後端曾經用 read 計算 iOS badge，如果只改 isRead，
                  //    桌面紅點就會被舊資料永久卡住。
                  if (!isRead) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .collection('mailbox')
                          .doc(docs[index].id)
                          .update({
                        'isRead': true,
                        'read': true,
                      });

                      await _syncAppBadge();
                    } catch (e) {
                      debugPrint('⚠️ 標記通知已讀失敗：$e');
                    }
                  }

                  // ========================================================
                  // ✨ 點擊信件
                  // ========================================================
                  final String type =
                  (data['type'] ?? '').toString();
                  final String postId =
                  (data['postId'] ?? '').toString();

                  if (type == 'like' ||
                      type == 'comment' ||
                      type == 'new_post') {
                    if (postId.isNotEmpty) {
                      debugPrint(
                        "🚀 傳送門啟動：前往貼文 $postId",
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MomentDetailPage(
                                postId: postId,
                              ),
                        ),
                      );
                    }
                  } else if (type == 'follow') {
                    debugPrint(
                      "🚀 傳送門啟動：有人關注我，看看他是誰",
                    );
                  } else if (type == 'cs_received' ||
                      type == 'cs_reply') {
                    _openMailboxItem(
                      context,
                      data: data,
                      l10n: l10n,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
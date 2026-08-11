import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';

import '../services/toast_utils.dart';
import 'moment_detail_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// 信件內容
class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  bool _isSelectionMode = false;
  bool _isSyncingRewardMail = false;
  final Set<String> _selectedMailIds = <String>{};
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRewardCampaignsToMailbox();
    });
  }

  Future<void> _syncRewardCampaignsToMailbox() async {
    if (_isSyncingRewardMail ||
        FirebaseAuth.instance.currentUser == null) {
      return;
    }

    _isSyncingRewardMail = true;

    try {
      await _functions
          .httpsCallable('syncRewardCampaignsToMailbox')
          .call();
    } on FirebaseFunctionsException catch (error) {
      // 同步活動信失敗不能妨礙玩家閱讀原有信件。
      debugPrint(
        '⚠️ 同步活動禮物信件失敗：'
            '${error.code} ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint('⚠️ 同步活動禮物信件發生錯誤：$error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isSyncingRewardMail = false;
    }
  }

  // 點擊信件時，標記為已讀
  Future<void> _markAsRead(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('mailbox')
        .doc(docId)
        .update({'isRead': true});
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedMailIds.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedMailIds.clear();
    });
  }

  void _toggleMailSelection(String docId) {
    setState(() {
      if (_selectedMailIds.contains(docId)) {
        _selectedMailIds.remove(docId);
      } else {
        _selectedMailIds.add(docId);
      }
    });
  }

  Future<void> _deleteSelectedMails(
      String userId,
      ) async {
    if (_selectedMailIds.isEmpty) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final int deleteCount =
        _selectedMailIds.length;

    // ==========================================
    // 1. 置中確認
    // ==========================================
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return AlertDialog(
              title:  Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 8),
                  Text(l10n.mailDeleteTitle),
                ],
              ),
              content: Text(l10n.mailDeleteConfirm(_selectedMailIds.length),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                    ).pop(false);
                  },
                  child:
                   Text(l10n.cancelButton),
                ),
                FilledButton(
                  style:
                  FilledButton.styleFrom(
                    backgroundColor:
                    Colors.redAccent,
                  ),
                  onPressed: () {
                    Navigator.of(
                      dialogContext,
                    ).pop(true);
                  },
                  child:
                   Text(l10n.delete_btn),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirmed) {
      return;
    }

    try {
      final db =
          FirebaseFirestore.instance;

      final batch = db.batch();

      for (final mailId
      in _selectedMailIds) {
        final mailRef = db
            .collection('users')
            .doc(userId)
            .collection('mailbox')
            .doc(mailId);

        batch.delete(mailRef);
      }

      await batch.commit();

      if (!mounted) return;

      // ==========================================
      // 2. 回復一般信箱模式
      // ==========================================
      setState(() {
        _isSelectionMode = false;
        _selectedMailIds.clear();
      });

      // ==========================================
      // 3. 共用的置中提示
      // ==========================================
      ToastUtils.showCenterToast(
        context,
        l10n.mailDeleteSuccess(_selectedMailIds.length),
        customIcon:
        Icons.delete_outline_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 批次刪除信件失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.mailDeleteFailed,
        isError: true,
      );
    }
  }

  // 好感度專屬情話系統
  String _getAffectionQuote(int score, AppLocalizations l10n) {
    if (score >= 2430) return l10n.affection_quote_lv5;
    if (score >= 1720) return l10n.affection_quote_lv4;
    if (score >= 550) return l10n.affection_quote_lv3;
    if (score >= 150) return l10n.affection_quote_lv2;
    if (score >= 60) return l10n.affection_quote_lv1;
    return l10n.affection_quote_lv0;
  }

  Future<void> _openMailDetail({
    required BuildContext context,
    required String userId,
    required String docId,
    required bool isRead,
    required String title,
    required String body,
    required String caseNumber,
    required String timeText,
    String fromName = '',
  }) async {
    if (!isRead) {
      await _markAsRead(userId, docId);
    }

    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _MailDetailPage(
          title: title,
          body: body,
          caseNumber: caseNumber,
          timeText: timeText,
          fromName: fromName,
        ),
      ),
    );
  }

  Future<void> _openRewardCampaignDetail({
    required String userId,
    required String docId,
    required bool isRead,
    required Map<String, dynamic> data,
    required String timeText,
  }) async {
    if (!isRead) {
      await _markAsRead(userId, docId);
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _RewardCampaignDetailPage(
          campaignId: data['rewardCampaignId']?.toString() ??
              data['campaignId']?.toString() ??
              '',
          title: data['title']?.toString() ?? '活動禮物',
          body: data['body']?.toString() ?? '',
          rewardAmount: (data['rewardAmount'] as num?)?.toInt() ??
              int.tryParse(data['rewardAmount']?.toString() ?? '') ??
              0,
          timeText: timeText,
          endAt: _readMailDateTime(
            data['endAt'] ?? data['expiresAt'],
          ),
          initiallyClaimed:
          data['claimed'] == true || data['isClaimed'] == true,
        ),
      ),
    );
  }

  DateTime? _readMailDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value?.toString() ?? '')?.toLocal();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
          tooltip: l10n.mailCancelSelection,
          icon: const Icon(Icons.close_rounded),
          onPressed: _exitSelectionMode,
        )
            : null,
        title: Text(
          _isSelectionMode
              ? l10n.mailSelectedCount(_selectedMailIds.length)
              : l10n.mailbox_title,
        ),
        elevation: 0,
        actions: [
          if (!_isSelectionMode)
            PopupMenuButton<String>(
              tooltip: l10n.moreOptions,
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                if (value == 'delete') {
                  _enterSelectionMode();
                }
              },
              itemBuilder: (_) =>  [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded),
                      SizedBox(width: 10),
                      Text(l10n.mailDeleteTitle),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: _isSelectionMode &&
          _selectedMailIds.isNotEmpty &&
          userId != null
          ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _deleteSelectedMails(userId),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l10n.mailDeleteSelected(_selectedMailIds.length)),
          ),
        ),
      )
          : null,
      body: userId == null
          ? Center(child: Text(l10n.please_login_first))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('mailbox')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            if (_isSelectionMode || _selectedMailIds.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _exitSelectionMode();
                }
              });
            }

            return Center(
              child: Text(
                l10n.mailbox_empty,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final mailbox = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: mailbox.length,
            itemBuilder: (context, index) {
              final doc = mailbox[index];
              final data = doc.data() as Map<String, dynamic>;

              final bool isRead = data['isRead'] ?? true;
              final String type =
                  data['type']?.toString() ?? 'system';
              String title =
                  data['title']?.toString() ?? l10n.new_notification;
              String body = data['body']?.toString() ?? '';

              final String caseNumber =
                  data['caseNumber']?.toString().trim() ?? '';

              final String storedFromName =
                  data['fromName']?.toString().trim() ?? '';

              final String fromName = storedFromName.isNotEmpty
                  ? storedFromName
                  : type == 'admin_mail'
                  ? l10n.officialManagementTeam
                  : '';

              if (type == 'follow') {
                title = l10n.mailbox_follow_title;
                final String followFromName = data['fromName']?.toString() ??
                    l10n.default_new_player;
                body = l10n.mailbox_follow_body(followFromName);
              }

              final Timestamp? createdAt = data['createdAt'] as Timestamp?;
              final String? postId = data['postId']?.toString();

              final String timeText = createdAt != null
                  ? DateFormat('MM/dd HH:mm').format(createdAt.toDate())
                  : '';

              final bool isSelected = _selectedMailIds.contains(doc.id);

              Widget leadingIcon;
              if (type == 'like') {
                leadingIcon = const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                  ),
                );
              } else if (type == 'comment') {
                leadingIcon = const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.blueAccent,
                  ),
                );
              } else if (type == 'affection') {
                leadingIcon = const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.orangeAccent,
                  ),
                );
              } else if (type == 'cs_reply') {
                leadingIcon = const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    color: Colors.pinkAccent,
                  ),
                );
              } else if (type == 'cs_received') {
                leadingIcon = const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.inbox_rounded,
                    color: Colors.pinkAccent,
                  ),
                );
              } else if (type == 'reward_campaign') {
                leadingIcon = CircleAvatar(
                  backgroundColor: Colors.pink.shade50,
                  child: const Icon(
                    Icons.redeem_rounded,
                    color: Colors.pinkAccent,
                  ),
                );
              } else if (type == 'admin_mail') {
                leadingIcon = CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    color: Colors.blueAccent,
                  ),
                );
              } else {
                leadingIcon = const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.notifications,
                    color: Colors.grey,
                  ),
                );
              }

              Widget buildSelectionLeading() {
                if (_isSelectionMode) {
                  return Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleMailSelection(doc.id),
                  );
                }

                return Stack(
                  children: [
                    leadingIcon,
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
                );
              }

              // 好感度升級卡片
              if (type == 'affection') {
                final int score = data['score'] is num
                    ? (data['score'] as num).toInt()
                    : int.tryParse(data['score']?.toString() ?? '') ?? 0;
                final String charName =
                    data['characterName']?.toString() ?? l10n.default_he;
                final String affectionTitle =
                l10n.affection_upgrade_title(charName);
                final String affectionBody =
                    '${_getAffectionQuote(score, l10n)}\n\n${l10n.flower_reward}';

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isRead
                          ? [theme.cardColor, theme.cardColor]
                          : [
                        Colors.pink.shade50,
                        Colors.orange.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.pinkAccent.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: buildSelectionLeading(),
                    title: Text(
                      affectionTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          _getAffectionQuote(score, l10n),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.pinkAccent.shade100,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.flower_reward,
                                style: const TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: _isSelectionMode
                        ? null
                        : Text(
                      timeText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () async {
                      if (_isSelectionMode) {
                        _toggleMailSelection(doc.id);
                        return;
                      }

                      await _openMailDetail(
                        context: context,
                        userId: userId,
                        docId: doc.id,
                        isRead: isRead,
                        title: affectionTitle,
                        body: affectionBody,
                        caseNumber: '',
                        timeText: timeText,
                      );
                    },
                  ),
                );
              }

              // 一般信件／通知
              return Container(
                color: isRead
                    ? Colors.transparent
                    : theme.colorScheme.primaryContainer
                    .withValues(alpha: 0.15),
                child: ListTile(
                  leading: buildSelectionLeading(),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                      isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: _isSelectionMode
                      ? null
                      : Text(
                    timeText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () async {
                    if (_isSelectionMode) {
                      _toggleMailSelection(doc.id);
                      return;
                    }

                    if (postId != null &&
                        (type == 'like' || type == 'comment')) {
                      if (!isRead) {
                        await _markAsRead(userId, doc.id);
                      }

                      if (!context.mounted) return;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MomentDetailPage(postId: postId),
                        ),
                      );
                      return;
                    }

                    if (type == 'reward_campaign') {
                      await _openRewardCampaignDetail(
                        userId: userId,
                        docId: doc.id,
                        isRead: isRead,
                        data: data,
                        timeText: timeText,
                      );
                      return;
                    }

                    await _openMailDetail(
                      context: context,
                      userId: userId,
                      docId: doc.id,
                      isRead: isRead,
                      title: title,
                      body: body,
                      caseNumber: caseNumber,
                      timeText: timeText,
                      fromName: fromName,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RewardCampaignDetailPage extends StatefulWidget {
  final String campaignId;
  final String title;
  final String body;
  final int rewardAmount;
  final String timeText;
  final DateTime? endAt;
  final bool initiallyClaimed;

  const _RewardCampaignDetailPage({
    required this.campaignId,
    required this.title,
    required this.body,
    required this.rewardAmount,
    required this.timeText,
    required this.endAt,
    required this.initiallyClaimed,
  });

  @override
  State<_RewardCampaignDetailPage> createState() =>
      _RewardCampaignDetailPageState();
}

class _RewardCampaignDetailPageState
    extends State<_RewardCampaignDetailPage> {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  );

  bool _isClaiming = false;
  late bool _isClaimed;

  @override
  void initState() {
    super.initState();
    _isClaimed = widget.initiallyClaimed;
  }

  bool get _isExpired {
    final endAt = widget.endAt;
    return endAt != null && DateTime.now().isAfter(endAt);
  }

  Future<void> _claimReward() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isClaiming || _isClaimed || _isExpired) return;

    if (widget.campaignId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.rewardCampaignMissingData,
        isError: true,
      );
      return;
    }

    setState(() {
      _isClaiming = true;
    });

    try {
      final result = await _functions
          .httpsCallable('claimRewardCampaign')
          .call({
        'campaignId': widget.campaignId,
      });

      final data = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};

      if (!mounted) return;

      setState(() {
        _isClaimed = true;
      });

      final int receivedAmount =
          (data['rewardAmount'] as num?)?.toInt() ?? widget.rewardAmount;

      ToastUtils.showCenterToast(
        context,
        l10n.rewardCampaignClaimSuccess(receivedAmount),
        customIcon: Icons.local_florist_rounded,
      );
    } on FirebaseFunctionsException catch (error) {
      debugPrint(
        '❌ 領取活動禮物失敗：'
            '${error.code} ${error.message}',
      );

      if (!mounted) return;

      // 後端若告知已領過，當作已領取，不再讓玩家重複按。
      if (error.code == 'already-exists') {
        setState(() {
          _isClaimed = true;
        });

        ToastUtils.showCenterToast(
          context,
          l10n.rewardCampaignAlreadyClaimed,
          customIcon: Icons.check_circle_outline_rounded,
        );
        return;
      }

      ToastUtils.showCenterToast(
        context,
        error.message ?? l10n.rewardCampaignClaimFailed,
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ 領取活動禮物發生錯誤：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.rewardCampaignClaimFailed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isClaiming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final endAt = widget.endAt;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rewardCampaignTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.redeem_rounded,
                    size: 42,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                widget.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.timeText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  widget.timeText,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 26),
              SelectableText(
                widget.body,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.75,
                ),
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink.shade50,
                      Colors.purple.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.pinkAccent.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  children: [
                     Text(
                      l10n.rewardCampaignContains,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_florist_rounded,
                          color: Colors.pinkAccent,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          l10n.rewardCampaignFlowerAmount(
                            widget.rewardAmount,
                          ),
                          style: const TextStyle(
                            color: Colors.pinkAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (endAt != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.rewardCampaignDeadline(
                          DateFormat('yyyy/MM/dd HH:mm').format(endAt),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isClaiming || _isClaimed || _isExpired
                      ? null
                      : _claimReward,
                  icon: _isClaiming
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Icon(
                    _isClaimed
                        ? Icons.check_circle_rounded
                        : _isExpired
                        ? Icons.event_busy_rounded
                        : Icons.redeem_rounded,
                  ),
                  label: Text(
                    _isClaiming
                        ? l10n.rewardCampaignClaiming
                        : _isClaimed
                        ? l10n.rewardCampaignClaimed
                        : _isExpired
                        ? l10n.rewardCampaignEnded
                        : l10n.rewardCampaignClaimButton,
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

class _MailDetailPage extends StatelessWidget {
  final String title;
  final String body;
  final String caseNumber;
  final String timeText;
  final String fromName;

  const _MailDetailPage({
    required this.title,
    required this.body,
    required this.caseNumber,
    required this.timeText,
    this.fromName = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mailDetailTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (fromName.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 17,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                          l10n.mailSender(fromName),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.65),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (timeText.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  timeText,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
              if (caseNumber.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.mailCaseNumber,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.55),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SelectableText(
                              caseNumber,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.mailCopyCaseNumber,
                        icon: const Icon(
                          Icons.copy_rounded,
                          size: 20,
                        ),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: caseNumber),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.mailCaseNumberCopied),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
              SelectableText(
                body,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

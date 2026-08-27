import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intl/intl.dart';
import '../services/toast_utils.dart';
import 'moment_detail_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
// 信件內容
class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  bool _isSelectionMode = false;
  bool _isSyncingRewardMail = false;
  bool _showCollectedOnly = false;
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

  Future<void> _toggleMailCollected({
    required String userId,
    required String docId,
    required bool isCollected,
  }) async {
    final mailRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('mailbox')
        .doc(docId);

    if (isCollected) {
      await mailRef.update({
        'isCollected': false,
        'collectedAt': FieldValue.delete(),
      });
    } else {
      await mailRef.update({
        'isCollected': true,
        'collectedAt': FieldValue.serverTimestamp(),
      });
    }
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
        l10n.mailDeleteSuccess(deleteCount),
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
    String originalQuestion = '',
    String fromName = '',
    bool isCollectible = false,
    bool isCollected = false,
    String mailTheme = '',
    String characterAvatarPath = '',
    List<String> interactionDates = const [],
  }) async {
    if (!isRead) {
      await _markAsRead(userId, docId);
    }

    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _MailDetailPage(
          userId: userId,
          docId: docId,
          title: title,
          body: body,
          caseNumber: caseNumber,
          timeText: timeText,
          originalQuestion: originalQuestion,
          fromName: fromName,
          isCollectible: isCollectible,
          initiallyCollected: isCollected,
          mailTheme: mailTheme,
          characterAvatarPath: characterAvatarPath,
          interactionDates: interactionDates,
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
    final l10n = AppLocalizations.of(context)!;
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
          title: data['title']?.toString() ?? l10n.mailActivityGiftFallback,
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


  Widget _buildMailboxBadge(
      String assetPath, {
        double size = 44,
      }) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.08),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 21,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMailboxFilterTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? primary.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: GoogleFonts.notoSerifTc(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected
                  ? primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ),
        ),
      ),
    );
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
          style: GoogleFonts.notoSerifTc(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (!_isSelectionMode)
            PopupMenuButton<String>(
              tooltip: l10n.moreOptions,
              icon: const Icon(Icons.more_vert_rounded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: theme.colorScheme.surface,
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
                      Image.asset(
                        'assets/images/chat/chat_msg_delete_mask.png',
                        width: 22,
                        height: 22,
                        color: Colors.redAccent,
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.mailDeleteTitle,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13,
                          color: Colors.redAccent,
                        ),
                      ),
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
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.redAccent.withValues(alpha: 0.05),
              foregroundColor: Colors.redAccent,
              side: BorderSide(
                color: Colors.redAccent.withValues(alpha: 0.45),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => _deleteSelectedMails(userId),
            icon: Image.asset(
              'assets/images/chat/chat_msg_delete_mask.png',
              width: 21,
              height: 21,
              color: Colors.redAccent,
              colorBlendMode: BlendMode.srcIn,
            ),
            label: Text(
              l10n.mailDeleteSelected(_selectedMailIds.length),
              style: GoogleFonts.notoSerifTc(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      )
          : null,
      body: userId == null
          ? Center(child: Text(l10n.please_login_first))
          : Column(
        children: [
          if (!_isSelectionMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.16),
                  ),
                ),
                child: Row(
                  children: [
                    _buildMailboxFilterTab(
                      label: l10n.mailFilterAll,
                      selected: !_showCollectedOnly,
                      onTap: () {
                        setState(() {
                          _showCollectedOnly = false;
                          _selectedMailIds.clear();
                        });
                      },
                    ),
                    _buildMailboxFilterTab(
                      label: l10n.mailFilterCollected,
                      selected: _showCollectedOnly,
                      onTap: () {
                        setState(() {
                          _showCollectedOnly = true;
                          _selectedMailIds.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                final allMailbox = snapshot.data!.docs;

                final mailbox = _showCollectedOnly
                    ? allMailbox.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['isCollected'] == true;
                }).toList()
                    : allMailbox;

                if (mailbox.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 52,
                          color: theme.colorScheme.primary.withValues(alpha: 0.45),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.mailCollectedEmptyTitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          l10n.mailCollectedEmptyHint,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 14),
                  itemCount: mailbox.length,
                  itemBuilder: (context, index) {
                    final doc = mailbox[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final bool isRead = data['isRead'] ?? true;
                    final String type =
                        data['type']?.toString() ?? 'system';
                    final bool isQixiLetter =
                        type == 'qixi_letter' ||
                            data['theme']?.toString() == 'qixi_2026';

                    final bool isCollected =
                        data['isCollected'] == true;
                    String title =
                        data['title']?.toString() ?? l10n.new_notification;
                    String body = data['body']?.toString() ?? '';

                    final String caseNumber =
                        data['caseNumber']?.toString().trim() ?? '';

                    final String originalQuestion = [
                      data['originalQuestion'],
                      data['question'],
                      data['originalMessage'],
                      data['inquiry'],
                      data['customerQuestion'],
                    ]
                        .map((value) => value?.toString().trim() ?? '')
                        .firstWhere(
                          (value) => value.isNotEmpty,
                      orElse: () => '',
                    );

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

                    if (isQixiLetter) {
                      leadingIcon = Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE9B4CA),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/love.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFFE1779E),
                            );
                          },
                        ),
                      );
                    } else if (type == 'like') {
                      leadingIcon = _buildMailboxBadge(
                        'assets/images/chat/chat_mail_like_badge.png',
                      );
                    } else if (type == 'follow') {
                      leadingIcon = _buildMailboxBadge(
                        'assets/images/chat/chat_mail_follow_badge.png',
                      );
                    } else if (type == 'comment') {
                      leadingIcon = _buildMailboxBadge(
                        'assets/images/chat/chat_mail_comment_badge.png',
                      );
                    } else if (type == 'cs_reply' || type == 'cs_received') {
                      leadingIcon = _buildMailboxBadge(
                        'assets/images/chat/chat_mail_support_badge.png',
                      );
                    } else if (type == 'admin_mail' ||
                        type == 'reward_campaign' ||
                        type == 'affection') {
                      leadingIcon = _buildMailboxBadge(
                        'assets/images/chat/chat_mail_announcement_badge.png',
                      );
                    } else {
                      leadingIcon = _buildMailboxBadge(
                        'assets/images/chat/chat_mail_notification_badge.png',
                      );
                    }

                    Widget buildSelectionLeading() {
                      if (_isSelectionMode) {
                        return Checkbox(
                          value: isSelected,
                          activeColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.surface,
                                    width: 1.5,
                                  ),
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
                              title: title,
                              body: body,
                              caseNumber: caseNumber,
                              timeText: timeText,
                              originalQuestion: originalQuestion,
                              fromName: fromName,
                              isCollectible: data['isCollectible'] == true,
                              isCollected: data['isCollected'] == true,
                              mailTheme: data['theme']?.toString() ?? '',
                              characterAvatarPath:
                              data['characterAvatarPath']?.toString() ?? '',
                              interactionDates: List<String>.from(
                                data['interactionDates'] ?? const <String>[],
                              ),
                            );
                          },
                        ),
                      );
                    }

                    // 一般信件／通知：緊湊文青卡片
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isRead
                            ? theme.colorScheme.surface
                            : Color.alphaBlend(
                          theme.colorScheme.primary
                              .withValues(alpha: 0.055),
                          theme.colorScheme.surface,
                        ),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: isQixiLetter
                              ? const Color(0xFFE8C6D5)
                              : theme.colorScheme.primary
                              .withValues(alpha: isRead ? 0.10 : 0.18),
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17),
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
                            originalQuestion: originalQuestion,
                            fromName: fromName,
                            isCollectible: data['isCollectible'] == true,
                            isCollected: data['isCollected'] == true,
                            mailTheme: data['theme']?.toString().trim() ?? '',
                            characterAvatarPath:
                            data['characterAvatarPath']?.toString().trim() ??
                                '',
                            interactionDates: List<String>.from(
                              data['interactionDates'] ?? const <String>[],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 11, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildSelectionLeading(),
                              const SizedBox(width: 11),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.notoSerifTc(
                                              fontSize: 14,
                                              fontWeight: isQixiLetter || !isRead
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                              color: isQixiLetter
                                                  ? const Color(0xFF68425F)
                                                  : theme
                                                  .colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                        if (!_isSelectionMode) ...[
                                          const SizedBox(width: 8),
                                          Text(
                                            timeText,
                                            style: GoogleFonts.notoSerifTc(
                                              fontSize: 10.5,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.40),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    if (isQixiLetter) ...[
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFEFF5),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color(0xFFE5ABC4),
                                            ),
                                          ),
                                          child: Text(
                                            l10n.mailQixiLimitedBadge,
                                            style: GoogleFonts.notoSerifTc(
                                              color: const Color(0xFF984A6B),
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 3),
                                    Text(
                                      body,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 12.5,
                                        height: 1.45,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.62),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!_isSelectionMode && isCollected) ...[
                                const SizedBox(width: 6),
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Icon(
                                    Icons.bookmark_rounded,
                                    size: 17,
                                    color: Color(0xFFD96391),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
                style: GoogleFonts.notoSerifTc(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
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

class _MailDetailPage extends StatefulWidget {
  final String userId;
  final String docId;
  final String title;
  final String body;
  final String caseNumber;
  final String timeText;
  final String originalQuestion;
  final String fromName;
  final bool isCollectible;
  final bool initiallyCollected;
  final String mailTheme;
  final String characterAvatarPath;
  final List<String> interactionDates;

  const _MailDetailPage({
    required this.userId,
    required this.docId,
    required this.title,
    required this.body,
    required this.caseNumber,
    required this.timeText,
    required this.originalQuestion,
    required this.fromName,
    required this.isCollectible,
    required this.initiallyCollected,
    required this.mailTheme,
    required this.characterAvatarPath,
    required this.interactionDates,
  });

  @override
  State<_MailDetailPage> createState() => _MailDetailPageState();
}

class _MailDetailPageState extends State<_MailDetailPage> {
  late bool _isCollected;
  bool _isUpdatingCollected = false;
  OverlayEntry? _mailToastEntry;
  Timer? _mailToastTimer;
  bool get _isQixiLetter => widget.mailTheme == 'qixi_2026';

  @override
  void initState() {
    super.initState();
    _isCollected = widget.initiallyCollected;
  }

  @override
  void dispose() {
    _mailToastTimer?.cancel();
    _mailToastEntry?.remove();
    _mailToastEntry = null;
    super.dispose();
  }

  Widget _buildMailShareCard({
    ImageProvider<Object>? avatarProvider,
  }) {
    final bool isQixi = _isQixiLetter;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 420,
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isQixi
                ? const [
              Color(0xFFFFEAF2),
              Color(0xFFF0E8FF),
              Color(0xFFFFF9FC),
            ]
                : const [
              Color(0xFFF8F5F7),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isQixi) ...[
              Image.asset(
                'assets/images/love.png',
                width: 82,
                height: 82,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 7),
              Text(
                l10n.mailQixiThreeDayPromise,
                style: TextStyle(
                  color: Color(0xFF68425F),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final bool completed =
                      index < widget.interactionDates.length.clamp(0, 3);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Image.asset(
                      completed
                          ? 'assets/images/qixi_progress_on.png'
                          : 'assets/images/qixi_progress_off.png',
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 28),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isQixi
                      ? const Color(0xFFE6AEC7)
                      : const Color(0xFFE1D9DE),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9E718B).withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (avatarProvider != null) ...[
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFB7D0),
                              Color(0xFFBDA7F2),
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: Image(
                            image: avatarProvider,
                            width: 62,
                            height: 62,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF68425F),
                      fontSize: 23,
                      height: 1.35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.fromName.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      isQixi
                          ? l10n.mailQixiFromCharacter(widget.fromName)
                          : l10n.mailFromCharacter(widget.fromName),
                      style: const TextStyle(
                        color: Color(0xFF806779),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFFE5ABC4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.body,
                    style: const TextStyle(
                      color: Color(0xFF4F414B),
                      fontSize: 16,
                      height: 1.85,
                    ),
                  ),
                  if (isQixi) ...[
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        l10n.mailQixiCollectionLabel,
                        style: TextStyle(
                          color: Color(0xFF9A456A),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.lianlianShiguang,
              style: TextStyle(
                color: Color(0xFF8D7284),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareMailAsImage() async {
    final l10n = AppLocalizations.of(context)!;
    ImageProvider<Object>? avatarProvider;

    try {
      final String avatarPath = widget.characterAvatarPath.trim();

      if (avatarPath.startsWith('http')) {
        avatarProvider = CachedNetworkImageProvider(avatarPath);
      } else if (avatarPath.isNotEmpty) {
        avatarProvider = AssetImage(avatarPath);
      }

      if (avatarProvider != null) {
        await precacheImage(avatarProvider, context);
      }

      if (!mounted) return;

      _showMailCenterToast(
        l10n.mailShareGenerating,
        icon: Icons.auto_awesome_rounded,
      );

      final Uint8List imageBytes =
      await ScreenshotController().captureFromLongWidget(
        InheritedTheme.captureAll(
          context,
          Directionality(
            textDirection: Directionality.of(context),
            child: _buildMailShareCard(
              avatarProvider: avatarProvider,
            ),
          ),
        ),
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        delay: const Duration(milliseconds: 150),
        pixelRatio: 2,
      );

      if (!mounted) return;

      final String safeFileName = widget.title
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
          .trim();

      await Share.shareXFiles(
        [
          XFile.fromData(
            imageBytes,
            mimeType: 'image/png',
            name: safeFileName.isNotEmpty
                ? '$safeFileName.png'
                : 'lianlian_letter.png',
          ),
        ],
        text: _isQixiLetter && widget.fromName.isNotEmpty
            ? l10n.mailShareQixiMessage(widget.fromName)
            : l10n.mailShareDefaultMessage,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ 生成信件分享圖片失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMailCenterToast(
        l10n.mailShareImageFailed,
        isError: true,
      );
    }
  }

  void _showMailCenterToast(
      String message, {
        bool isError = false,
        IconData? icon,
      }) {
    _mailToastTimer?.cancel();
    _mailToastEntry?.remove();
    _mailToastEntry = null;

    final overlay = Overlay.of(context);

    _mailToastEntry = OverlayEntry(
      builder: (_) {
        return Positioned.fill(
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B252A)
                        .withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon ??
                            (isError
                                ? Icons.error_outline_rounded
                                : Icons.bookmark_rounded),
                        color: isError
                            ? Colors.redAccent.shade100
                            : const Color(0xFFFFB7D0),
                        size: 21,
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_mailToastEntry!);

    _mailToastTimer = Timer(
      const Duration(milliseconds: 1500),
          () {
        _mailToastEntry?.remove();
        _mailToastEntry = null;
      },
    );
  }

  Future<void> _toggleCollected() async {
    if (!widget.isCollectible || _isUpdatingCollected) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final bool nextValue = !_isCollected;

    setState(() {
      _isCollected = nextValue;
      _isUpdatingCollected = true;
    });

    try {
      final mailRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('mailbox')
          .doc(widget.docId);

      await mailRef.set(
        {
          'isCollected': nextValue,
          if (nextValue)
            'collectedAt': FieldValue.serverTimestamp()
          else
            'collectedAt': FieldValue.delete(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      _showMailCenterToast(
        nextValue ? l10n.mailCollectedSuccess : l10n.mailCollectedCancelled,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ 更新信件收藏狀態失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isCollected = !nextValue;
      });

      _showMailCenterToast(
        l10n.mailCollectedUpdateFailed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingCollected = false;
        });
      }
    }
  }

  Widget _buildCollectButton({
    required Color color,
  }) {
    if (!widget.isCollectible) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: _isCollected ? l10n.mailRemoveCollectionTooltip : l10n.mailAddCollectionTooltip,
      onPressed: _isUpdatingCollected ? null : _toggleCollected,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _isUpdatingCollected
            ? SizedBox(
          key: const ValueKey('loading'),
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        )
            : Icon(
          _isCollected
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          key: ValueKey(_isCollected),
          color: color,
        ),
      ),
    );
  }

  Widget _buildCaseNumberCard(
      ThemeData theme,
      AppLocalizations l10n,
      ) {
    if (widget.caseNumber.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
                  widget.caseNumber,
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
                ClipboardData(text: widget.caseNumber),
              );

              if (!mounted) return;

              _showMailCenterToast(
                l10n.mailCaseNumberCopied,
                icon: Icons.copy_rounded,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNormalMail(
      ThemeData theme,
      AppLocalizations l10n,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.mailDetailTitle,
          style: GoogleFonts.notoSerifTc(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: '分享信件',
            onPressed: _shareMailAsImage,
            icon: Transform.flip(
              flipX: true,
              child: const Icon(
                Icons.reply_rounded,
              ),
            ),
          ),
          _buildCollectButton(
            color: theme.colorScheme.primary,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.fromName.isNotEmpty) ...[
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
                        l10n.mailSender(widget.fromName),
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
              if (widget.timeText.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  widget.timeText,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
              if (widget.caseNumber.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildCaseNumberCard(theme, l10n),
              ],
              if (widget.originalQuestion.trim().isNotEmpty) ...[
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.055),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '你原本詢問',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 7),
                      SelectableText(
                        widget.originalQuestion,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 14,
                          height: 1.6,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SelectableText(
                widget.body,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 15,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQixiProgress() {
    final int completedCount =
    widget.interactionDates.length.clamp(0, 3);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final bool isCompleted = index < completedCount;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isCompleted
                    ? 'assets/images/qixi_progress_on.png'
                    : 'assets/images/qixi_progress_off.png',
                width: 42,
                height: 42,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Icon(
                    isCompleted
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isCompleted
                        ? const Color(0xFFE777A2)
                        : const Color(0xFF96899C),
                    size: 30,
                  );
                },
              ),
              const SizedBox(height: 2),
              Text(
                l10n.mailQixiDayNumber(index + 1),
                style: TextStyle(
                  color: isCompleted
                      ? const Color(0xFF9A456A)
                      : const Color(0xFF837686),
                  fontSize: 10,
                  fontWeight: isCompleted
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQixiMail(
      ThemeData theme,
      AppLocalizations l10n,
      ) {
    const darkPurple = Color(0xFF68425F);
    const mutedPurple = Color(0xFF806779);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.mailQixiDetailTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: darkPurple,
        actions: [
          IconButton(
            tooltip: l10n.mailQixiShareTooltip,
            onPressed: _shareMailAsImage,
            icon: Transform.flip(
              flipX: true,
              child: const Icon(
                Icons.reply_rounded,
                color: Color(0xFFD75E8E),
              ),
            ),
          ),
          _buildCollectButton(
            color: const Color(0xFFD75E8E),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFEAF2),
              Color(0xFFF1E9FF),
              Color(0xFFFFF9FC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 42),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/qixi_chat_badge.png',
                  width: 68,
                  height: 68,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.nightlight_round,
                      color: Color(0xFFE078A0),
                      size: 52,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.mailQixiThreeDayPromise,
                  style: TextStyle(
                    color: darkPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                _buildQixiProgress(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    26,
                    22,
                    30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE7B5CB)
                          .withValues(alpha: 0.75),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9D6887)
                            .withValues(alpha: 0.13),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.characterAvatarPath.isNotEmpty)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFB7D0),
                                  Color(0xFFBDA7F2),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE88AAE)
                                      .withValues(alpha: 0.22),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: CachedNetworkImage(
                                  imageUrl: widget.characterAvatarPath,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(milliseconds: 180),
                                  placeholder: (_, __) {
                                    return Container(
                                      color: const Color(0xFFF4EAF1),
                                      alignment: Alignment.center,
                                      child: const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFFD8789D),
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (_, __, ___) {
                                    return Container(
                                      color: const Color(0xFFF4EAF1),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: Color(0xFF9B7D91),
                                        size: 32,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.characterAvatarPath.isNotEmpty)
                        const SizedBox(height: 18),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: darkPurple,
                          fontSize: 23,
                          height: 1.35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.fromName.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: Color(0xFFD76A94),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '來自 ${widget.fromName} 的七夕信',
                                style: const TextStyle(
                                  color: mutedPurple,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (widget.timeText.isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Text(
                          widget.timeText,
                          style: const TextStyle(
                            color: Color(0xFF9A8794),
                            fontSize: 11,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      Container(
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0xFFE6AFC7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SelectableText(
                        widget.body,
                        style: const TextStyle(
                          color: Color(0xFF4F414B),
                          fontSize: 16,
                          height: 1.9,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE3EE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFEAB2CA),
                            ),
                          ),
                          child: Text(
                            l10n.mailQixiCollectionLabel,
                            style: TextStyle(
                              color: Color(0xFF9A456A),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_isQixiLetter) {
      return _buildQixiMail(theme, l10n);
    }

    return _buildNormalMail(theme, l10n);
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../repositories/character_repository.dart';
import '../services/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/toast_utils.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../services/help_translation_admin_service.dart';
import '../screens/character_model.dart';
import '../utils/image_utils.dart';

//後台
class AnnouncementNotificationButton extends StatefulWidget {
  const AnnouncementNotificationButton({super.key});

  @override
  State<AnnouncementNotificationButton> createState() =>
      _AnnouncementNotificationButtonState();
}

class _AnnouncementNotificationButtonState
    extends State<AnnouncementNotificationButton> {
  bool _hasNewAnnouncement = false;
  @override
  void initState() {
    super.initState();
    _checkForNewAnnouncements();
  }

  // 🔍 偷偷檢查有沒有新公告
  Future<void> _checkForNewAnnouncements() async {
    try {
      // 1. 從玩家手機抓取「上次看公告的時間」(如果沒看過，預設為 0)
      final prefs = await SharedPreferences.getInstance();
      final int lastReadTime = prefs.getInt('lastReadAnnouncementTime') ?? 0;

      // 2. 去資料庫抓「最新的一篇公告」
      final query = await FirebaseFirestore.instance
          .collection('announcements') // 這裡對應妳發布公告的集合
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // 取得最新公告的時間戳記 (轉成毫秒)
        Timestamp latestPostTime = query.docs.first['createdAt'];
        int latestTimeMs = latestPostTime.millisecondsSinceEpoch;

        // 3. ✨ 終極對決：如果最新公告時間 > 玩家上次看的時間，就亮紅點！
        if (latestTimeMs > lastReadTime) {
          if (mounted) setState(() => _hasNewAnnouncement = true);
        }
      }
    } catch (e) {
      print("檢查新公告失敗: $e");
    }
  }

  // 👆 玩家點擊按鈕時觸發
  Future<void> _openAnnouncementPage() async {
    // 1. 瞬間熄滅紅點，讓玩家覺得反應很快
    setState(() => _hasNewAnnouncement = false);

    // 2. 更新手機裡的「最後閱讀時間」為現在！
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'lastReadAnnouncementTime', DateTime.now().millisecondsSinceEpoch);

    // 3. 🚀 跳轉到妳寫給玩家看的「公告列表頁面」
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerAnnouncementPage()));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // ✨ 關鍵：使用 Flutter 內建的 Badge 來畫小紅點
      icon: Badge(
        isLabelVisible: _hasNewAnnouncement, // 控制紅點要不要出現！
        backgroundColor: Colors.redAccent, // 紅點顏色
        smallSize: 10, // 紅點的大小
        child: const Icon(Icons.campaign_outlined, size: 28), // 喇叭圖示
      ),
      onPressed: _openAnnouncementPage,
    );
  }
}

class AdminAnnouncementPage extends StatefulWidget {
  const AdminAnnouncementPage({super.key});

  @override
  State<AdminAnnouncementPage> createState() => _AdminAnnouncementPageState();
}

class _AdminAnnouncementPageState extends State<AdminAnnouncementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ==========================================
  // 🎁 活動禮物管理
  // ==========================================
  final TextEditingController _rewardTitleController = TextEditingController();
  final TextEditingController _rewardDescriptionController =
  TextEditingController();
  final TextEditingController _rewardAmountController = TextEditingController();

  DateTime _rewardStartAt = DateTime.now();
  DateTime _rewardEndAt = DateTime.now().add(
    const Duration(days: 7),
  );

  bool _isCreatingRewardCampaign = false;
  bool _isLoadingRewardCampaigns = false;
  List<Map<String, dynamic>> _rewardCampaigns = [];
  String _rewardAudience = 'admin_only';

  // 公告用的 Controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _sendNotification = true;
  bool _isPublishing = false;
  bool _isUploadingVoiceBank = false;
  bool _isSyncingCreatorNames = false;
  bool _isBackfillingMomentSearch = false;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  );
  bool _isSyncingHelpTranslation = false;
  String _helpTranslationStatus = '';
  String _selectedHelpLanguage = 'en';

  // 後台 2.0 狀態
  String _supportStatus = 'pending';
  String _supportSearch = '';
  String _playerSearch = '';
  final Map<String, String> _adminNicknameCache = <String, String>{};
  final Map<String, String> _helpLanguages = const {
    'en': 'English',
    'ja': '日本語',
    'ko': '한국어',
  };
  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 7,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        _loadRewardCampaigns();
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _rewardTitleController.dispose();
    _rewardDescriptionController.dispose();
    _rewardAmountController.dispose();
    super.dispose();
  }

  Future<void> _backfillMomentSearchKeywords() async {
    if (_isBackfillingMomentSearch) return;

    final bool confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('補建拾光牆搜尋索引'),
        content: const Text(
          '系統會掃描所有舊公開貼文，並補上搜尋關鍵字。'
              '處理期間請不要關閉後台頁面，也不要重複點擊。\n\n'
              '確定要開始嗎？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.manage_search_rounded),
            label: const Text('開始補建'),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirmed || !mounted) return;

    setState(() {
      _isBackfillingMomentSearch = true;
    });

    try {
      final callable = _functions.httpsCallable(
        'backfillMomentSearchKeywords',
        options: HttpsCallableOptions(
          timeout: const Duration(minutes: 9),
        ),
      );

      final result = await callable.call();
      final data = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};

      final int scannedCount = (data['scannedCount'] as num?)?.toInt() ?? 0;
      final int updatedCount = (data['updatedCount'] as num?)?.toInt() ?? 0;
      final int batchCount = (data['batchCount'] as num?)?.toInt() ?? 0;

      debugPrint(
        '✅ 拾光牆搜尋索引補建完成：'
            'scanned=$scannedCount, '
            'updated=$updatedCount, '
            'batches=$batchCount',
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 10),
              Text('補建完成'),
            ],
          ),
          content: Text(
            '掃描公開貼文：$scannedCount 篇\n'
                '更新搜尋索引：$updatedCount 篇\n'
                '完成批次：$batchCount 批',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('知道了'),
            ),
          ],
        ),
      );
    } on FirebaseFunctionsException catch (error, stackTrace) {
      debugPrint('❌ 拾光牆搜尋索引補建失敗：${error.code}');
      debugPrint('message: ${error.message}');
      debugPrint('details: ${error.details}');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        error.message ?? '搜尋索引補建失敗',
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ 拾光牆搜尋索引補建發生未知錯誤：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '搜尋索引補建失敗：$error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBackfillingMomentSearch = false;
        });
      }
    }
  }

  Future<void> _syncCreatorNames() async {
    if (_isSyncingCreatorNames) return;

    setState(() {
      _isSyncingCreatorNames = true;
    });

    try {
      final db = FirebaseFirestore.instance;

      final charactersSnapshot = await db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .get();

      int updatedCount = 0;
      int skippedCount = 0;
      int failedCount = 0;

      // 快取已讀過的創作者資料，避免同一位創作者被重複讀取。
      final Map<String, String> creatorNameCache = {};

      // Firestore batch 一次最多 500 筆操作，
      // 保守一點每 400 筆提交一次。
      WriteBatch batch = db.batch();
      int batchOperationCount = 0;

      Future<void> commitBatchIfNeeded({
        bool force = false,
      }) async {
        if (batchOperationCount == 0) return;

        if (force || batchOperationCount >= 400) {
          await batch.commit();
          batch = db.batch();
          batchOperationCount = 0;
        }
      }

      for (final characterDoc in charactersSnapshot.docs) {
        try {
          final data = characterDoc.data();

          final String creatorUid = data['createdBy']?.toString().trim() ?? '';

          if (creatorUid.isEmpty) {
            skippedCount++;
            debugPrint(
              '⚠️ 角色 ${characterDoc.id} 沒有 createdBy，略過',
            );
            continue;
          }

          String creatorName = creatorNameCache[creatorUid] ?? '';

          if (!creatorNameCache.containsKey(creatorUid)) {
            final creatorDoc =
            await db.collection('users').doc(creatorUid).get();

            creatorName =
                creatorDoc.data()?['nickname']?.toString().trim() ?? '';

            creatorNameCache[creatorUid] = creatorName;
          }

          if (creatorName.isEmpty) {
            skippedCount++;
            debugPrint(
              '⚠️ 找不到創作者名稱：$creatorUid',
            );
            continue;
          }

          batch.update(characterDoc.reference, {
            'creatorName': creatorName,
            'creatorNameLower': creatorName.toLowerCase(),
            'creatorMetadataUpdatedAt': FieldValue.serverTimestamp(),
          });

          batchOperationCount++;
          updatedCount++;

          await commitBatchIfNeeded();
        } catch (e) {
          failedCount++;
          debugPrint(
            '❌ 更新角色 ${characterDoc.id} 失敗：$e',
          );
        }
      }

      await commitBatchIfNeeded(force: true);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '同步完成：更新 $updatedCount 個，略過 $skippedCount 個，失敗 $failedCount 個',
        customIcon: Icons.sync_rounded,
      );

      debugPrint(
        '✅ 創作者名稱同步完成：'
            'updated=$updatedCount, '
            'skipped=$skippedCount, '
            'failed=$failedCount',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 同步創作者名稱失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '同步失敗：$e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSyncingCreatorNames = false;
        });
      }
    }
  }

  Future<void> _publish() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.isEmpty || _contentController.text.isEmpty)
      return;
    setState(() => _isPublishing = true);
    try {
      final batch = FirebaseFirestore.instance.batch();
      DocumentReference annRef =
      FirebaseFirestore.instance.collection('announcements').doc();
      batch.set(annRef, {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (_sendNotification) {
        DocumentReference notifyRef =
        FirebaseFirestore.instance.collection('system_notifications').doc();
        batch.set(notifyRef, {
          'title': '📢 ${_titleController.text.trim()}',
          'message': _contentController.text.trim(),
          'type': 'global_announcement',
          'announcementId': annRef.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      if (mounted) {
        // ✨ 總裁級：全服公告發布成功的優雅回饋
        ToastUtils.showCenterToast(
          context,
          '✅ 公告與全服通知已發布！',
          customIcon: Icons.campaign_rounded, // 💡 用「廣播/公告」圖示，完美對應公告發布的情境
        );
      }
      _titleController.clear();
      _contentController.clear();
    } catch (e) {
      if (mounted) {
        // ⚠️ 發布失敗：重量級錯誤提示
        ToastUtils.showCenterToast(
          context,
          '❌ 發布失敗: $e',
          isError: true, // 💡 帶上紅驚嘆號，讓管理員第一時間發現異常
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  Future<void> _uploadVoiceBank() async {
    if (_isUploadingVoiceBank) return;

    setState(() {
      _isUploadingVoiceBank = true;
    });

    try {
      final callable = _functions.httpsCallable(
        'uploadVoiceBank',
      );

      final result = await callable.call();

      final data = result.data is Map
          ? Map<String, dynamic>.from(
        result.data as Map,
      )
          : <String, dynamic>{};

      final int count = (data['count'] as num?)?.toInt() ?? 0;

      debugPrint(
        '✅ Voice Bank 同步成功：$data',
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        'Voice Bank 已同步 $count 筆聲音',
        customIcon: Icons.cloud_done_rounded,
      );
    } on FirebaseFunctionsException catch (e, stackTrace) {
      debugPrint(
        '========== uploadVoiceBank 失敗 ==========',
      );
      debugPrint('code: ${e.code}');
      debugPrint('message: ${e.message}');
      debugPrint('details: ${e.details}');
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        e.message ?? 'Voice Bank 同步失敗',
        isError: true,
      );
    } catch (e, stackTrace) {
      debugPrint(
        'Voice Bank 同步未知錯誤：$e',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        'Voice Bank 同步失敗：$e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingVoiceBank = false;
        });
      }
    }
  }

  // ==========================================
  // ✉️ 客服回覆邏輯 (彈出對話框)
  // ==========================================
  Future<void> _showReplyDialog(
      String reportId,
      String reporterId,
      String originalContent,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final replyController = TextEditingController();

    final flowerController = TextEditingController();

    // ==========================================
    // 第一階段：
    // Dialog 只負責收資料
    // 不在 Dialog 裡寫 Firestore
    // ==========================================
    final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('回覆玩家檢舉/建議'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '玩家內容：$originalContent',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: replyController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: '回覆內容',
                    hintText: '輸入回覆內容...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: flowerController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '補償花花點數（選填）',
                    hintText: '不補償可留空，例如：5',
                    prefixIcon: Icon(
                      Icons.local_florist_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '若此案件需要補償玩家，再填寫點數即可；留空則只寄送客服回覆。',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: Text(
                l10n.cancelButton,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final replyText = replyController.text.trim();

                if (replyText.isEmpty) {
                  // Dialog 裡不要再叫 Overlay Toast，
                  // 直接用 SnackBar 或乾脆不關閉。
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text('請先輸入回覆內容'),
                    ),
                  );
                  return;
                }

                final flowerText = flowerController.text.trim();

                final int flowerAmount = flowerText.isEmpty
                    ? 0
                    : int.tryParse(
                  flowerText,
                ) ??
                    -1;

                if (flowerAmount < 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '花花點數請輸入正整數',
                      ),
                    ),
                  );
                  return;
                }

                if (flowerAmount > 100) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '單次客服補償最多 100 點花花',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(
                  dialogContext,
                ).pop({
                  'replyText': replyText,
                  'flowerAmount': flowerAmount,
                });
              },
              child: const Text('確認回覆'),
            ),
          ],
        );
      },
    );

    // 使用者取消
    if (result == null) {
      return;
    }

    if (!mounted) return;

    final String replyText = result['replyText']?.toString().trim() ?? '';

    final int flowerAmount = result['flowerAmount'] as int? ?? 0;

    if (reporterId.trim().isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '找不到玩家 UID，無法處理案件',
        isError: true,
      );
      return;
    }

    // ==========================================
    // 第二階段：
    // Dialog 已經完全關閉後
    // 才開始寫 Firestore
    // ==========================================
    try {
      final db = FirebaseFirestore.instance;

      final batch = db.batch();

      final adminUid = FirebaseAuth.instance.currentUser?.uid ?? '';

      // ==========================================
// 取得案件編號
// ==========================================
      final reportSnapshot = await db.collection('reports').doc(reportId).get();

      final reportData = reportSnapshot.data() ?? {};

      final String caseNumber = reportData['caseNumber']?.toString() ?? '';

      // --------------------------
      // 1. 處理 report
      // --------------------------
      final reportRef = db.collection('reports').doc(reportId);

      batch.update(
        reportRef,
        {
          'status': 'resolved',
          'adminReply': replyText,
          'compensationFlowerPoints': flowerAmount,
          'compensatedBy': adminUid,
          'resolvedAt': FieldValue.serverTimestamp(),
        },
      );

      // --------------------------
      // 2. 寄客服信
      // --------------------------
      final mailboxRef =
      db.collection('users').doc(reporterId).collection('mailbox').doc();

      final String mailboxBody = flowerAmount > 0
          ? '$replyText\n\n'
          '已補償 $flowerAmount 點花花至您的帳號。'
          : replyText;

      batch.set(
        mailboxRef,
        {
          'type': 'cs_reply',

          'title': '客服回覆 💌',

          'body': mailboxBody,

          // ⭐ 新增
          'caseNumber': caseNumber,

          'reportId': reportId,

          'isRead': false,

          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      // --------------------------
      // 3. 有補花花才執行
      // --------------------------
      if (flowerAmount > 0) {
        final userRef = db.collection('users').doc(reporterId);

        batch.update(
          userRef,
          {
            'flowerPoints': FieldValue.increment(
              flowerAmount,
            ),
          },
        );

        // --------------------------
        // 4. 花花明細
        // --------------------------
        final flowerLogRef = userRef
            .collection(
          'flower_logs',
        )
            .doc();

        batch.set(
          flowerLogRef,
          {
            'title': '客服補償',
            'amount': flowerAmount,
            'reason': '客服案件補償',
            'reportId': reportId,
            'adminReply': replyText,
            'adminUid': adminUid,
            'type': 'cs_compensation',
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
      }

      await batch.commit();

      if (!mounted) return;

      // StreamBuilder 可能正因 resolved 而重建，
      // 再讓一個 frame 過去。
      await Future<void>.delayed(
        const Duration(
          milliseconds: 150,
        ),
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        flowerAmount > 0 ? '已處理並補償 $flowerAmount 點花花' : '已處理並寄送回信！',
        customIcon: flowerAmount > 0
            ? Icons.local_florist_rounded
            : Icons.mark_email_read_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 處理客服案件失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '處理失敗，請稍後再試',
        isError: true,
      );
    }
  }

  Widget _buildHelpTranslationAdminCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '遊玩指南翻譯',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '按一次即可將完整中文遊玩指南翻譯，'
                  '並儲存到 Firestore，所有玩家共用。',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedHelpLanguage,
              decoration: const InputDecoration(
                labelText: '目標語言',
                border: OutlineInputBorder(),
              ),
              items: _helpLanguages.entries
                  .map(
                    (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    entry.value,
                  ),
                ),
              )
                  .toList(),
              onChanged: _isSyncingHelpTranslation
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedHelpLanguage = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSyncingHelpTranslation
                    ? null
                    : () => _syncHelpTranslation(
                  context,
                ),
                icon: _isSyncingHelpTranslation
                    ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.cloud_upload_outlined,
                ),
                label: Text(
                  _isSyncingHelpTranslation ? '翻譯同步中...' : '同步遊玩指南翻譯',
                ),
              ),
            ),
            if (_helpTranslationStatus.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _helpTranslationStatus,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _syncHelpTranslation(
      BuildContext context,
      ) async {
    if (_isSyncingHelpTranslation) {
      return;
    }

    setState(() {
      _isSyncingHelpTranslation = true;
      _helpTranslationStatus = '準備開始翻譯...';
    });

    try {
      await HelpTranslationAdminService.syncLanguage(
        targetLanguage: _selectedHelpLanguage,
        onProgress: (message) {
          if (!mounted) return;

          setState(() {
            _helpTranslationStatus = message;
          });
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_helpLanguages[_selectedHelpLanguage]} '
                '遊玩指南同步完成！',
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '同步遊玩指南翻譯失敗：$error',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        _helpTranslationStatus = '同步失敗：$error';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '翻譯同步失敗：$error',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSyncingHelpTranslation = false;
        });
      }
    }
  }

  String _formatRewardDateTime(
      DateTime value,
      ) {
    return DateFormat(
      'yyyy/MM/dd HH:mm',
    ).format(value);
  }

  Future<void> _pickRewardDateTime({
    required bool isStart,
  }) async {
    final DateTime initialValue = isStart ? _rewardStartAt : _rewardEndAt;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime.now().subtract(
        const Duration(days: 1),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 730),
      ),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        initialValue,
      ),
    );

    if (selectedTime == null || !mounted) {
      return;
    }

    final DateTime result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      if (isStart) {
        _rewardStartAt = result;

        if (!_rewardEndAt.isAfter(result)) {
          _rewardEndAt = result.add(
            const Duration(days: 7),
          );
        }
      } else {
        _rewardEndAt = result;
      }
    });
  }

  Future<void> _loadRewardCampaigns() async {
    if (_isLoadingRewardCampaigns) return;

    setState(() {
      _isLoadingRewardCampaigns = true;
    });

    try {
      final callable = _functions.httpsCallable(
        'listRewardCampaigns',
      );

      final result = await callable.call();

      final Map<String, dynamic> data = result.data is Map
          ? Map<String, dynamic>.from(
        result.data as Map,
      )
          : <String, dynamic>{};

      final rawCampaigns = data['campaigns'];

      final List<Map<String, dynamic>> campaigns = rawCampaigns is List
          ? rawCampaigns
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(
          item,
        ),
      )
          .toList()
          : [];

      if (!mounted) return;

      setState(() {
        _rewardCampaigns = campaigns;
      });
    } on FirebaseFunctionsException catch (error) {
      debugPrint(
        '❌ 讀取活動禮物失敗：'
            '${error.code} ${error.message}',
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        error.message ?? '讀取活動禮物失敗',
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '❌ 讀取活動禮物發生錯誤：$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '讀取活動禮物失敗',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRewardCampaigns = false;
        });
      }
    }
  }

  Future<void> _createRewardCampaign() async {
    if (_isCreatingRewardCampaign) return;

    final String title = _rewardTitleController.text.trim();

    final String description = _rewardDescriptionController.text.trim();

    final int? rewardAmount = int.tryParse(
      _rewardAmountController.text.trim(),
    );

    if (title.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '請輸入活動標題',
        isError: true,
      );
      return;
    }

    if (description.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '請輸入寫給玩家的活動說明',
        isError: true,
      );
      return;
    }

    if (rewardAmount == null || rewardAmount <= 0 || rewardAmount > 10000) {
      ToastUtils.showCenterToast(
        context,
        '花花數量請輸入 1～10000 的整數',
        isError: true,
      );
      return;
    }

    if (!_rewardEndAt.isAfter(
      _rewardStartAt,
    )) {
      ToastUtils.showCenterToast(
        context,
        '結束時間必須晚於開始時間',
        isError: true,
      );
      return;
    }

    final bool confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('發布活動禮物'),
          content: Text(
            '活動：$title\n'
                '獎勵：$rewardAmount 朵花花\n'
                '開始：${_formatRewardDateTime(_rewardStartAt)}\n'
                '結束：${_formatRewardDateTime(_rewardEndAt)}\n\n'
                '發布後，符合資格的玩家開啟戀戀信箱即可看到這份禮物。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text('取消'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              icon: const Icon(
                Icons.redeem_rounded,
              ),
              label: const Text('確認發布'),
            ),
          ],
        );
      },
    ) ??
        false;

    if (!confirmed || !mounted) return;

    setState(() {
      _isCreatingRewardCampaign = true;
    });

    try {
      final callable = _functions.httpsCallable(
        'createRewardCampaign',
      );

      await callable.call({
        'title': title,
        'description': description,
        'rewardType': 'flowerPoints',
        'rewardAmount': rewardAmount,
        'audience': _rewardAudience,
        'startAt': _rewardStartAt.toUtc().toIso8601String(),
        'endAt': _rewardEndAt.toUtc().toIso8601String(),
      });

      if (!mounted) return;

      _rewardTitleController.clear();
      _rewardDescriptionController.clear();
      _rewardAmountController.clear();

      setState(() {
        _rewardStartAt = DateTime.now();
        _rewardEndAt = DateTime.now().add(
          const Duration(days: 7),
        );
        _rewardAudience = 'admin_only';
      });

      ToastUtils.showCenterToast(
        context,
        '活動禮物已發布',
        customIcon: Icons.redeem_rounded,
      );

      await _loadRewardCampaigns();
    } on FirebaseFunctionsException catch (error) {
      debugPrint(
        '❌ 發布活動禮物失敗：'
            '${error.code} ${error.message}',
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        error.message ?? '發布活動禮物失敗',
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '❌ 發布活動禮物發生錯誤：$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '發布活動禮物失敗',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingRewardCampaign = false;
        });
      }
    }
  }

  Future<void> _disableRewardCampaign(
      Map<String, dynamic> campaign,
      ) async {
    final String campaignId = campaign['id']?.toString() ?? '';

    final String title = campaign['title']?.toString() ?? '活動禮物';

    if (campaignId.isEmpty) return;

    final bool confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('停止活動'),
          content: Text(
            '確定要停止「$title」嗎？\n\n'
                '停止後，尚未領取的玩家將無法再領取。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text('取消'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text('停止活動'),
            ),
          ],
        );
      },
    ) ??
        false;

    if (!confirmed || !mounted) return;

    try {
      final callable = _functions.httpsCallable(
        'disableRewardCampaign',
      );

      await callable.call({
        'campaignId': campaignId,
      });

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '活動已停止',
        customIcon: Icons.stop_circle_outlined,
      );

      await _loadRewardCampaigns();
    } on FirebaseFunctionsException catch (error) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        error.message ?? '停止活動失敗',
        isError: true,
      );
    } catch (error) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '停止活動失敗：$error',
        isError: true,
      );
    }
  }

  Widget _buildRewardCampaignTab() {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _loadRewardCampaigns,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          80,
        ),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.redeem_rounded,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 9),
                      Text(
                        '發布活動禮物',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '玩家開啟戀戀信箱後，即可看到並領取活動花花。',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _rewardTitleController,
                    decoration: const InputDecoration(
                      labelText: '活動標題',
                      hintText: '例如：夏日相遇禮物',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.celebration_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _rewardDescriptionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: '寫給玩家的內容',
                      hintText: '例如：謝謝你陪伴戀戀拾光，送你一份小禮物。',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _rewardAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '花花數量',
                      hintText: '例如：20',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.local_florist_outlined,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _rewardAudience,
                    decoration: const InputDecoration(
                      labelText: '發送對象',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.groups_2_outlined,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'admin_only',
                        child: Text('僅管理員測試'),
                      ),
                      DropdownMenuItem(
                        value: 'all_users',
                        child: Text('所有玩家'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _rewardAudience = value;
                      });
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.green,
                    ),
                    title: const Text('開始時間'),
                    subtitle: Text(
                      _formatRewardDateTime(
                        _rewardStartAt,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.edit_calendar_rounded,
                    ),
                    onTap: () {
                      _pickRewardDateTime(
                        isStart: true,
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.event_busy_outlined,
                      color: Colors.orange,
                    ),
                    title: const Text('結束時間'),
                    subtitle: Text(
                      _formatRewardDateTime(
                        _rewardEndAt,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.edit_calendar_rounded,
                    ),
                    onTap: () {
                      _pickRewardDateTime(
                        isStart: false,
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isCreatingRewardCampaign
                          ? null
                          : _createRewardCampaign,
                      icon: _isCreatingRewardCampaign
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(
                        Icons.send_rounded,
                      ),
                      label: Text(
                        _isCreatingRewardCampaign ? '發布中…' : '發布活動禮物',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              const Expanded(
                child: Text(
                  '已建立的活動',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: '重新整理',
                onPressed:
                _isLoadingRewardCampaigns ? null : _loadRewardCampaigns,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_isLoadingRewardCampaigns)
            const Padding(
              padding: EdgeInsets.all(28),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_rewardCampaigns.isEmpty)
            const Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      size: 42,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '目前還沒有活動禮物',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._rewardCampaigns.map(
                  (campaign) {
                final String status =
                    campaign['status']?.toString() ?? 'active';

                final DateTime? startAt = DateTime.tryParse(
                  campaign['startAt']?.toString() ?? '',
                )?.toLocal();

                final DateTime? endAt = DateTime.tryParse(
                  campaign['endAt']?.toString() ?? '',
                )?.toLocal();

                final DateTime now = DateTime.now();

                String statusText;
                Color statusColor;

                if (status != 'active') {
                  statusText = '已停止';
                  statusColor = Colors.grey;
                } else if (startAt != null && now.isBefore(startAt)) {
                  statusText = '尚未開始';
                  statusColor = Colors.blue;
                } else if (endAt != null && now.isAfter(endAt)) {
                  statusText = '已結束';
                  statusColor = Colors.orange;
                } else {
                  statusText = '進行中';
                  statusColor = Colors.green;
                }

                final int rewardAmount =
                    (campaign['rewardAmount'] as num?)?.toInt() ?? 0;

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                campaign['title']?.toString() ?? '活動禮物',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          campaign['description']?.toString() ?? '',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_florist_rounded,
                              size: 17,
                              color: Colors.pinkAccent,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$rewardAmount 朵花花',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ],
                        ),
                        if (startAt != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '開始：${_formatRewardDateTime(startAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                        if (endAt != null)
                          Text(
                            '結束：${_formatRewardDateTime(endAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        if (status == 'active') ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                _disableRewardCampaign(
                                  campaign,
                                );
                              },
                              icon: const Icon(
                                Icons.stop_circle_outlined,
                              ),
                              label: const Text('停止活動'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ============================================================
  // 後台 2.0 共用元件
  // ============================================================
  ThemeData _adminTheme(BuildContext context) {
    final base = Theme.of(context);
    final primary = base.colorScheme.primary;

    return base.copyWith(
      textTheme: GoogleFonts.notoSerifTcTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.notoSerifTcTextTheme(base.primaryTextTheme),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: base.colorScheme.surface.withValues(alpha: 0.94),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: primary.withValues(alpha: 0.13),
            width: 0.8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: base.colorScheme.surface.withValues(alpha: 0.78),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary.withValues(alpha: 0.18)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary.withValues(alpha: 0.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary.withValues(alpha: 0.58), width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary.withValues(alpha: 0.10),
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: primary.withValues(alpha: 0.12),
        thickness: 0.7,
      ),
    );
  }

  Widget _adminPageHeader({
    required String title,
    required String subtitle,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primary, size: 22),
            ),
            const SizedBox(width: 13),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.9,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12.5,
                    height: 1.45,
                    color: onSurface.withValues(alpha: 0.52),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminStatCard({
    required String label,
    required String value,
    required IconData icon,
    String? caption,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: primary.withValues(alpha: 0.13), width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: primary.withValues(alpha: 0.78)),
              const Spacer(),
              if (caption != null)
                Text(
                  caption,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 10.5,
                    color: onSurface.withValues(alpha: 0.42),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSerifTc(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSerifTc(
              fontSize: 11.5,
              height: 1.2,
              color: onSurface.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime? _dateFromDynamic(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final db = FirebaseFirestore.instance;
    final today = _startOfToday();
    final sevenDaysAgo = today.subtract(const Duration(days: 6));

    final usersFuture = db.collection('users').get();
    final publicCharactersFuture = db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters')
        .get();
    final pendingCharactersFuture = db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('pending_characters')
        .get();
    final reportsFuture = db.collection('reports').get();
    // chat_sessions 目前可能沒有開放給 App 端管理員直接讀取。
    // 後台總覽不能因為單一集合權限不足就整頁炸掉，所以這裡改成安全讀取。
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessionDocs = [];
    try {
      final sessionsSnapshot = await db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('chat_sessions')
          .where(
        'lastActivity',
        isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo),
      )
          .get();

      sessionDocs = sessionsSnapshot.docs;
    } on FirebaseException catch (e) {
      debugPrint(
        '⚠️ 後台暫時無法讀取 chat_sessions：${e.code} ${e.message}',
      );
    } catch (e) {
      debugPrint('⚠️ 後台讀取 chat_sessions 失敗：$e');
    }

    final results = await Future.wait([
      usersFuture,
      publicCharactersFuture,
      pendingCharactersFuture,
      reportsFuture,
    ]);

    final users = results[0] as QuerySnapshot<Map<String, dynamic>>;
    final characters = results[1] as QuerySnapshot<Map<String, dynamic>>;
    final pendingCharacters = results[2] as QuerySnapshot<Map<String, dynamic>>;
    final reports = results[3] as QuerySnapshot<Map<String, dynamic>>;

    int todayNewUsers = 0;
    int monthlyActive = 0;
    final now = DateTime.now();
    final List<int> userGrowth = List<int>.filled(7, 0);

    for (final doc in users.docs) {
      final data = doc.data();
      final created = _dateFromDynamic(
        data['createdAt'] ?? data['registeredAt'] ?? data['joinedAt'],
      );
      if (created != null) {
        if (!created.isBefore(today)) todayNewUsers++;
        final diff = DateTime(created.year, created.month, created.day)
            .difference(sevenDaysAgo)
            .inDays;
        if (diff >= 0 && diff < 7) userGrowth[diff]++;
      }

      final monthlyEnd = _dateFromDynamic(
        data['monthlySubEndDate'] ?? data['subscriptionEndAt'],
      );
      if (monthlyEnd != null && monthlyEnd.isAfter(now)) monthlyActive++;
    }

    int todayNewCharacters = 0;
    for (final doc in characters.docs) {
      final data = doc.data();
      final created = _dateFromDynamic(
        data['publishedAt'] ?? data['createdAt'] ?? data['updatedAt'],
      );
      if (created != null && !created.isBefore(today)) todayNewCharacters++;
    }

    int pendingReports = 0;
    for (final doc in reports.docs) {
      final status = doc.data()['status']?.toString().trim() ?? '';
      if (status.isEmpty || status == 'pending' || status == 'processing') {
        pendingReports++;
      }
    }

    final Set<String> activeUserIdsToday = <String>{};
    int activeSessionsToday = 0;
    final List<int> chatTrend = List<int>.filled(7, 0);
    final Map<String, int> chatModes = <String, int>{};
    final Map<String, int> characterChatCounts = <String, int>{};

    for (final doc in sessionDocs) {
      final data = doc.data();
      final lastActivity = _dateFromDynamic(data['lastActivity']);
      if (lastActivity == null) continue;

      final dayIndex = DateTime(lastActivity.year, lastActivity.month, lastActivity.day)
          .difference(sevenDaysAgo)
          .inDays;
      if (dayIndex >= 0 && dayIndex < 7) chatTrend[dayIndex]++;

      if (!lastActivity.isBefore(today)) {
        activeSessionsToday++;
        final userId = data['userId']?.toString().trim() ?? '';
        if (userId.isNotEmpty) activeUserIdsToday.add(userId);
      }

      final mode = data['chatMode']?.toString().trim() ?? 'daily';
      chatModes[mode] = (chatModes[mode] ?? 0) + 1;

      final characterId = data['characterId']?.toString().trim() ?? '';
      if (characterId.isNotEmpty) {
        characterChatCounts[characterId] =
            (characterChatCounts[characterId] ?? 0) + 1;
      }
    }

    int flowerGranted = 0;
    int flowerSpent = 0;
    try {
      final logs = await db
          .collectionGroup('flower_logs')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .get();
      for (final doc in logs.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toInt() ?? 0;
        if (amount >= 0) {
          flowerGranted += amount;
        } else {
          flowerSpent += amount.abs();
        }
      }
    } catch (e) {
      debugPrint('⚠️ 後台讀取今日花花明細失敗：$e');
    }

    return {
      'totalUsers': users.docs.length,
      'todayNewUsers': todayNewUsers,
      'todayActiveUsers': activeUserIdsToday.length,
      'publicCharacters': characters.docs.length,
      'todayNewCharacters': todayNewCharacters,
      'pendingCharacters': pendingCharacters.docs.length,
      'pendingReports': pendingReports,
      'todayChatSessions': activeSessionsToday,
      'flowerGranted': flowerGranted,
      'flowerSpent': flowerSpent,
      'monthlyActive': monthlyActive,
      'userGrowth': userGrowth,
      'chatTrend': chatTrend,
      'chatModes': chatModes,
      'characterChatCounts': characterChatCounts,
      'sessions7d': sessionDocs.length,
    };
  }

  Widget _miniBarChart({
    required List<int> values,
    required String title,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final maxValue = values.fold<int>(0, (max, value) => value > max ? value : max);
    final labels = <String>['-6', '-5', '-4', '-3', '-2', '昨天', '今天'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSerifTc(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 132,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  final value = values[index];
                  final ratio = maxValue == 0 ? 0.05 : (value / maxValue).clamp(0.05, 1.0);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '$value',
                            style: GoogleFonts.notoSerifTc(fontSize: 10.5),
                          ),
                          const SizedBox(height: 5),
                          Flexible(
                            child: FractionallySizedBox(
                              heightFactor: ratio,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 18,
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.52),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            labels[index],
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 9.5,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('讀取營運總覽失敗：\n${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }

        final data = snapshot.data ?? <String, dynamic>{};
        String v(String key) => '${data[key] ?? 0}';

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              _adminPageHeader(
                title: '營運總覽',
                subtitle: '今天的戀戀拾光，一眼掌握。部分進階分析會在埋點完成後自動升級。',
                icon: Icons.space_dashboard_outlined,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: MediaQuery.sizeOf(context).width >= 900 ? 5 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.82,
                  children: [
                    _adminStatCard(label: '總玩家數', value: v('totalUsers'), icon: Icons.people_alt_outlined),
                    _adminStatCard(label: '今日新增玩家', value: v('todayNewUsers'), icon: Icons.person_add_alt_1_outlined),
                    _adminStatCard(label: '今日活躍玩家', value: v('todayActiveUsers'), icon: Icons.bolt_outlined, caption: '聊天室活動'),
                    _adminStatCard(label: '目前公開角色', value: v('publicCharacters'), icon: Icons.auto_awesome_outlined),
                    _adminStatCard(label: '今日新增角色', value: v('todayNewCharacters'), icon: Icons.person_pin_circle_outlined),
                    _adminStatCard(label: '待審角色', value: v('pendingCharacters'), icon: Icons.fact_check_outlined),
                    _adminStatCard(label: '待處理客服', value: v('pendingReports'), icon: Icons.support_agent_outlined),
                    _adminStatCard(label: '今日活躍聊天室', value: v('todayChatSessions'), icon: Icons.forum_outlined),
                    _adminStatCard(label: '今日花花發放 / 消耗', value: '${v('flowerGranted')} / ${v('flowerSpent')}', icon: Icons.local_florist_outlined),
                    _adminStatCard(label: '有效月卡人數', value: v('monthlyActive'), icon: Icons.workspace_premium_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _miniBarChart(
                  values: List<int>.from(data['userGrowth'] ?? const [0,0,0,0,0,0,0]),
                  title: '最近 7 天玩家成長',
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _miniBarChart(
                  values: List<int>.from(data['chatTrend'] ?? const [0,0,0,0,0,0,0]),
                  title: '最近 7 天聊天室活動',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _adjustUserFlowerPoints({
    required String uid,
    required String displayName,
  }) async {
    final controller = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('調整 $displayName 的花花'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          decoration: const InputDecoration(
            labelText: '調整數量',
            hintText: '例如 20；扣除請輸入 -20',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              final amount = int.tryParse(controller.text.trim());
              if (amount == null || amount == 0 || amount.abs() > 10000) return;
              Navigator.pop(dialogContext, amount);
            },
            child: const Text('確認調整'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;

    final adminUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final logRef = userRef.collection('flower_logs').doc();

    final batch = FirebaseFirestore.instance.batch();
    batch.update(userRef, {'flowerPoints': FieldValue.increment(result)});
    batch.set(logRef, {
      'title': result > 0 ? '管理後台補發' : '管理後台扣除',
      'amount': result,
      'type': 'admin_adjustment',
      'adminUid': adminUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();

    if (!mounted) return;
    ToastUtils.showCenterToast(
      context,
      result > 0 ? '已補發 $result 點花花' : '已扣除 ${result.abs()} 點花花',
      customIcon: Icons.local_florist_rounded,
    );
  }

  Future<void> _toggleUserAdminRestriction({
    required String uid,
    required String displayName,
    required bool currentlySuspended,
  }) async {
    final reasonController = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(currentlySuspended ? '解除停權' : '停權 $displayName'),
        content: currentlySuspended
            ? const Text('解除後，請確認玩家端已接入 suspended 欄位判斷。')
            : TextField(
          controller: reasonController,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(labelText: '停權原因'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(currentlySuspended ? '解除' : '確認停權'),
          ),
        ],
      ),
    );

    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true || !mounted) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'suspended': !currentlySuspended,
      'suspensionReason': currentlySuspended ? FieldValue.delete() : reason,
      'suspendedAt': currentlySuspended ? FieldValue.delete() : FieldValue.serverTimestamp(),
      'suspendedBy': currentlySuspended
          ? FieldValue.delete()
          : (FirebaseAuth.instance.currentUser?.uid ?? ''),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('admin_actions')
        .add({
      'type': currentlySuspended ? 'unsuspend' : 'suspend',
      'reason': reason,
      'adminUid': FirebaseAuth.instance.currentUser?.uid ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Widget _buildPlayersTab() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        _adminPageHeader(
          title: '玩家管理',
          subtitle: '以 UID、玩家 ID 或暱稱搜尋。可寄信、調整花花與查看帳號狀態。',
          icon: Icons.manage_accounts_outlined,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: '搜尋 UID / 玩家 ID / 暱稱',
            ),
            onChanged: (value) => setState(() => _playerSearch = value.trim().toLowerCase()),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('users').limit(300).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('讀取玩家失敗：${snapshot.error}'));
              }

              final docs = (snapshot.data?.docs ?? []).where((doc) {
                if (_playerSearch.isEmpty) return true;
                final data = doc.data();
                final haystack = [
                  doc.id,
                  data['playerID'],
                  data['nickname'],
                  data['email'],
                ].whereType<Object>().map((e) => e.toString().toLowerCase()).join(' ');
                return haystack.contains(_playerSearch);
              }).toList();

              if (docs.isEmpty) {
                return const Center(child: Text('找不到符合的玩家'));
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data();
                  final nickname = data['nickname']?.toString().trim();
                  final playerId = data['playerID']?.toString().trim() ?? '';
                  final flowers = (data['flowerPoints'] as num?)?.toInt() ?? 0;
                  final monthlyEnd = _dateFromDynamic(data['monthlySubEndDate']);
                  final monthlyActive = monthlyEnd != null && monthlyEnd.isAfter(DateTime.now());
                  final suspended = data['suspended'] == true;
                  final created = _dateFromDynamic(data['createdAt'] ?? data['registeredAt']);

                  return Card(
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      leading: CircleAvatar(
                        backgroundColor: primary.withValues(alpha: 0.10),
                        child: Text(
                          (nickname?.isNotEmpty == true ? nickname!.characters.first : '?'),
                          style: TextStyle(color: primary),
                        ),
                      ),
                      title: Text(
                        nickname?.isNotEmpty == true ? nickname! : '未設定暱稱',
                        style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(playerId.isEmpty ? doc.id : 'ID：$playerId'),
                      trailing: suspended
                          ? const Icon(Icons.block_rounded, color: Colors.redAccent)
                          : null,
                      children: [
                        _adminInfoLine('UID', doc.id),
                        _adminInfoLine('花花餘額', '$flowers'),
                        _adminInfoLine('月卡狀態', monthlyActive ? '有效' : '未啟用 / 已到期'),
                        _adminInfoLine('註冊時間', created == null ? '未記錄' : DateFormat('yyyy/MM/dd HH:mm').format(created)),
                        _adminInfoLine('帳號狀態', suspended ? '已停權' : '正常'),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showSendAdminMailDialog(initialRecipientId: doc.id),
                              icon: const Icon(Icons.mail_outline_rounded),
                              label: const Text('寄信'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _adjustUserFlowerPoints(uid: doc.id, displayName: nickname ?? '玩家'),
                              icon: const Icon(Icons.local_florist_outlined),
                              label: const Text('調整花花'),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: suspended ? primary : Colors.redAccent,
                              ),
                              onPressed: () => _toggleUserAdminRestriction(
                                uid: doc.id,
                                displayName: nickname ?? '玩家',
                                currentlySuspended: suspended,
                              ),
                              icon: Icon(suspended ? Icons.lock_open_rounded : Icons.block_rounded),
                              label: Text(suspended ? '解除停權' : '停權標記'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '註：停權 / 禁言真正生效仍需玩家端登入、聊天、發文流程讀取對應欄位。此頁已先建立管理資料與操作紀錄。',
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 10.5,
                            height: 1.45,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.46),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _adminInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: GoogleFonts.notoSerifTc(fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  String _reportOwnerId(Map<String, dynamic> data) {
    return (data['reporterId'] ?? data['userId'] ?? data['createdBy'] ?? '')
        .toString()
        .trim();
  }

  String _reportDisplayText(Map<String, dynamic> data) {
    final content = data['content']?.toString().trim() ?? '';
    if (content.isNotEmpty) return content;
    final details = data['details']?.toString().trim() ?? '';
    if (details.isNotEmpty) return details;
    final message = data['reportedMessage']?.toString().trim() ?? '';
    if (message.isNotEmpty) return message;
    final blockedName = data['blockedCharacterName']?.toString().trim() ?? '';
    if (blockedName.isNotEmpty) return '封鎖角色：$blockedName';
    return '未提供文字內容';
  }

  String _reportStatusOf(Map<String, dynamic> data) {
    final status = data['status']?.toString().trim() ?? '';
    return status.isEmpty ? 'pending' : status;
  }

  Future<String> _loadAdminNickname(String uid) async {
    if (uid.isEmpty) return '未知玩家';
    final cached = _adminNicknameCache[uid];
    if (cached != null) return cached;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final name = doc.data()?['nickname']?.toString().trim();
      final value = name?.isNotEmpty == true ? name! : '未設定暱稱';
      _adminNicknameCache[uid] = value;
      return value;
    } catch (_) {
      return '未設定暱稱';
    }
  }

  Future<void> _deletePendingReport({
    required String reportId,
    required String preview,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('刪除客服案件'),
        content: Text('確定刪除此未處理案件嗎？\n\n$preview\n\n刪除後不會寄信給玩家。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('取消')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('刪除'),
          ),
        ],
      ),
    ) ??
        false;
    if (!confirmed) return;
    await FirebaseFirestore.instance.collection('reports').doc(reportId).delete();
  }

  Future<void> _setReportStatus(String reportId, String status) async {
    await FirebaseFirestore.instance.collection('reports').doc(reportId).set({
      'status': status,
      'adminUpdatedAt': FieldValue.serverTimestamp(),
      'adminUpdatedBy': FirebaseAuth.instance.currentUser?.uid ?? '',
    }, SetOptions(merge: true));
  }

  Widget _buildSupportCenterTab() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final statusOptions = <String, String>{
      'pending': '待處理',
      'processing': '處理中',
      'resolved': '已完成',
      'rejected': '已駁回',
    };

    return Column(
      children: [
        _adminPageHeader(
          title: '客服案件中心',
          subtitle: '同一位玩家的客服與檢舉會收在同一張卡片裡。每一件仍可獨立回覆、駁回或刪除。',
          icon: Icons.support_agent_outlined,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statusOptions.entries.map((entry) {
                final selected = _supportStatus == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: primary.withValues(alpha: 0.14),
                    side: BorderSide(color: primary.withValues(alpha: selected ? 0.42 : 0.14)),
                    onSelected: (_) => setState(() => _supportStatus = entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: '搜尋 UID / 案件編號 / 客服內容',
            ),
            onChanged: (value) => setState(() => _supportSearch = value.trim().toLowerCase()),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('reports').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('讀取客服案件失敗：${snapshot.error}'));
              }

              final docs = (snapshot.data?.docs ?? []).where((doc) {
                final data = doc.data();
                if (_reportStatusOf(data) != _supportStatus) return false;
                if (_supportSearch.isEmpty) return true;
                final uid = _reportOwnerId(data);
                final caseNo = data['caseNumber']?.toString() ?? '';
                final text = _reportDisplayText(data);
                return '$uid $caseNo $text'.toLowerCase().contains(_supportSearch);
              }).toList();

              docs.sort((a, b) {
                final aDate = _dateFromDynamic(a.data()['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
                final bDate = _dateFromDynamic(b.data()['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0);
                return bDate.compareTo(aDate);
              });

              final groups = <String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>{};
              for (final doc in docs) {
                final uid = _reportOwnerId(doc.data());
                final key = uid.isEmpty ? 'unknown:${doc.id}' : uid;
                groups.putIfAbsent(key, () => []).add(doc);
              }

              if (groups.isEmpty) {
                return Center(child: Text('目前沒有「${statusOptions[_supportStatus]}」案件'));
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 11),
                itemBuilder: (context, index) {
                  final entry = groups.entries.elementAt(index);
                  final uid = entry.key.startsWith('unknown:') ? '' : entry.key;
                  final cases = entry.value;

                  return Card(
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      title: FutureBuilder<String>(
                        future: _loadAdminNickname(uid),
                        builder: (_, nameSnapshot) => Text(
                          nameSnapshot.data ?? (uid.isEmpty ? '未知玩家' : '讀取玩家中…'),
                          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
                        ),
                      ),
                      subtitle: Text(uid.isEmpty ? '${cases.length} 件案件' : 'UID：$uid · ${cases.length} 件'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '${cases.length} 件',
                          style: TextStyle(color: primary, fontSize: 11),
                        ),
                      ),
                      children: List.generate(cases.length, (caseIndex) {
                        final doc = cases[caseIndex];
                        final data = doc.data();
                        final text = _reportDisplayText(data);
                        final created = _dateFromDynamic(data['createdAt']);
                        final caseNo = data['caseNumber']?.toString().trim() ?? '';
                        final imageUrl = data['imageUrl']?.toString().trim() ?? '';
                        final resolved = _reportStatusOf(data) == 'resolved';

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.035),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: primary.withValues(alpha: 0.10)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${caseIndex + 1}.',
                                    style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700, color: primary),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      caseNo.isEmpty ? '客服案件' : '案件 $caseNo',
                                      style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                  ),
                                  if (created != null)
                                    Text(
                                      DateFormat('MM/dd HH:mm').format(created),
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 10.5,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.43),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(text, style: GoogleFonts.notoSerifTc(fontSize: 12.5, height: 1.55)),
                              if (imageUrl.isNotEmpty) ...[
                                const SizedBox(height: 9),
                                Text('含附件圖片', style: TextStyle(fontSize: 11, color: primary)),
                              ],
                              if (resolved && (data['adminReply']?.toString().trim().isNotEmpty ?? false)) ...[
                                const SizedBox(height: 10),
                                Text(
                                  '已回覆：${data['adminReply']}',
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 11.5,
                                    height: 1.45,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 11),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (!resolved)
                                    FilledButton.icon(
                                      onPressed: uid.isEmpty
                                          ? null
                                          : () => _showReplyDialog(doc.id, uid, text),
                                      icon: const Icon(Icons.reply_rounded, size: 17),
                                      label: const Text('回覆'),
                                    ),
                                  if (_supportStatus == 'pending')
                                    OutlinedButton.icon(
                                      onPressed: () => _setReportStatus(doc.id, 'processing'),
                                      icon: const Icon(Icons.hourglass_top_rounded, size: 17),
                                      label: const Text('處理中'),
                                    ),
                                  if (!resolved && _supportStatus != 'rejected')
                                    OutlinedButton.icon(
                                      onPressed: () => _setReportStatus(doc.id, 'rejected'),
                                      icon: const Icon(Icons.do_not_disturb_alt_outlined, size: 17),
                                      label: const Text('駁回'),
                                    ),
                                  if (_supportStatus == 'pending')
                                    TextButton.icon(
                                      style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                                      onPressed: () => _deletePendingReport(reportId: doc.id, preview: text),
                                      icon: const Icon(Icons.delete_outline_rounded, size: 17),
                                      label: const Text('刪除'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentCenterTab() {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          _adminPageHeader(
            title: '內容審核中心',
            subtitle: '角色審核沿用既有完整功能；拾光牆、留言、個人檔案與創作者先統一收入口，後續可再接自動審核與違規紀錄。',
            icon: Icons.verified_user_outlined,
          ),
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '角色'),
              Tab(text: '拾光牆'),
              Tab(text: '留言'),
              Tab(text: '個人檔案'),
              Tab(text: '創作者'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCharacterManagementTab(),
                _buildReportedContentList('moment', '拾光牆貼文'),
                _buildReportedContentList('comment', '留言'),
                _buildReportedContentList('profile', '玩家個人檔案'),
                _buildReportedContentList('creator', '創作者'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportedContentList(String relatedType, String title) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('reports').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) return Center(child: Text('讀取$title檢舉失敗'));
        final docs = (snapshot.data?.docs ?? []).where((doc) {
          final data = doc.data();
          final type = (data['relatedType'] ?? data['type'])?.toString() ?? '';
          return type == relatedType;
        }).toList();
        if (docs.isEmpty) {
          return Center(child: Text('目前沒有$title相關案件'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();
            return Card(
              child: ListTile(
                title: Text(_reportDisplayText(data), maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('狀態：${_reportStatusOf(data)} · UID：${_reportOwnerId(data)}'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _tabController.animateTo(2),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCampaignCenterTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          _adminPageHeader(
            title: '活動與獎勵',
            subtitle: '公告、單一玩家信件與活動花花集中管理。兌換碼與分眾活動已預留位置。',
            icon: Icons.celebration_outlined,
          ),
          const TabBar(
            tabs: [
              Tab(text: '公告與信件'),
              Tab(text: '活動禮物'),
              Tab(text: '兌換碼 / 分眾'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAnnouncementTab(),
                _buildRewardCampaignTab(),
                _buildCampaignSegmentationPlaceholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignSegmentationPlaceholder() {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('分眾活動條件', style: GoogleFonts.notoSerifTc(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    Chip(label: Text('所有玩家')),
                    Chip(label: Text('指定玩家')),
                    Chip(label: Text('新玩家')),
                    Chip(label: Text('回流玩家')),
                    Chip(label: Text('月卡玩家')),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '目前活動禮物已支援「管理員測試 / 所有玩家」。其他分眾條件與兌換碼需要 Cloud Functions 增加 eligibility / redeem 邏輯後才能安全啟用。',
                  style: GoogleFonts.notoSerifTc(fontSize: 12, height: 1.55),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: 0.35, color: primary),
                const SizedBox(height: 8),
                const Text('基礎活動系統已完成，分眾與兌換碼待後端接入。'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data ?? <String, dynamic>{};
        final sessions7d = (data['sessions7d'] as num?)?.toInt() ?? 0;
        final activeToday = (data['todayActiveUsers'] as num?)?.toInt() ?? 0;
        final todaySessions = (data['todayChatSessions'] as num?)?.toInt() ?? 0;
        final avg = activeToday == 0 ? 0.0 : todaySessions / activeToday;
        final modes = Map<String, int>.from(data['chatModes'] ?? <String, int>{});
        final totalMode = modes.values.fold<int>(0, (a, b) => a + b);

        String modePercent(String key) {
          if (totalMode == 0) return '0%';
          return '${((modes[key] ?? 0) / totalMode * 100).toStringAsFixed(1)}%';
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            _adminPageHeader(
              title: '數據分析',
              subtitle: '先使用現有聊天室與會員資料計算可確認的數字；留存與轉換率不會用猜的，等事件埋點後再啟用。',
              icon: Icons.query_stats_outlined,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width >= 800 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                children: [
                  _adminStatCard(label: 'DAU（聊天室活動）', value: '$activeToday', icon: Icons.today_outlined),
                  _adminStatCard(label: '近 7 天活躍聊天室', value: '$sessions7d', icon: Icons.date_range_outlined),
                  _adminStatCard(label: '今日平均活躍聊天室 / 人', value: avg.toStringAsFixed(2), icon: Icons.forum_outlined),
                  _adminStatCard(label: '日常模式占比', value: modePercent('daily'), icon: Icons.chat_bubble_outline),
                  _adminStatCard(label: '劇情模式占比', value: modePercent('story'), icon: Icons.menu_book_outlined),
                  _adminStatCard(label: '沉浸模式占比', value: modePercent('immersive'), icon: Icons.auto_stories_outlined),
                  _adminStatCard(label: 'D1 / D7 / D30 留存', value: '待埋點', icon: Icons.repeat_rounded),
                  _adminStatCard(label: '推薦 → 開聊轉換', value: '待埋點', icon: Icons.route_outlined),
                  _adminStatCard(label: '收入 / 付費玩家 / ARPPU', value: '待金流彙總', icon: Icons.payments_outlined),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Text(
                    '為避免後台顯示錯誤數據，目前沒有足夠事件紀錄的項目會明確標示「待埋點」。下一步可在聊天、推薦曝光、點擊、付費與登入流程寫入 analytics_daily / analytics_events，再讓這些卡片自動變成真實數據。',
                    style: GoogleFonts.notoSerifTc(fontSize: 12, height: 1.6),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSystemHealthTab() {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _adminPageHeader(
            title: '系統健康',
            subtitle: '系統工具已集中在這裡；AI 成功率、錯誤率與成本需由後端寫入日誌後才能可靠顯示。',
            icon: Icons.monitor_heart_outlined,
          ),
          const TabBar(
            tabs: [
              Tab(text: '健康狀態'),
              Tab(text: '系統工具'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 9),
                                Text('監測資料尚未完整接入', style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Gemini 成功率、DeepSeek 成功率、content filter、AI request failure、Functions 錯誤、平均回覆時間、API 用量與預估成本，需要 Cloud Functions / AI gateway 寫入 ai_usage_daily 後才能計算。',
                              style: GoogleFonts.notoSerifTc(fontSize: 12, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: MediaQuery.sizeOf(context).width >= 800 ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.15,
                      children: [
                        _adminStatCard(label: 'Gemini 成功率', value: '待接入', icon: Icons.auto_awesome_outlined),
                        _adminStatCard(label: 'DeepSeek 成功率', value: '待接入', icon: Icons.psychology_alt_outlined),
                        _adminStatCard(label: 'Content Filter', value: '待接入', icon: Icons.shield_outlined),
                        _adminStatCard(label: 'AI Request Failure', value: '待接入', icon: Icons.error_outline_rounded),
                        _adminStatCard(label: 'Functions 錯誤', value: '待接入', icon: Icons.cloud_off_outlined),
                        _adminStatCard(label: '平均回覆時間', value: '待接入', icon: Icons.timer_outlined),
                        _adminStatCard(label: '今日 API 用量', value: '待接入', icon: Icons.data_usage_outlined),
                        _adminStatCard(label: '今日預估 AI 成本', value: '待接入', icon: Icons.attach_money_rounded),
                      ],
                    ),
                  ],
                ),
                _buildVoiceBankTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminTheme = _adminTheme(context);
    final primary = adminTheme.colorScheme.primary;
    final onSurface = adminTheme.colorScheme.onSurface;

    return Theme(
      data: adminTheme,
      child: Scaffold(
        backgroundColor: adminTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 68,
          titleSpacing: 20,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '拾光管理',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.7,
                  color: onSurface,
                ),
              ),
              Text(
                'Administration',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 10.5,
                  letterSpacing: 1.2,
                  color: onSurface.withValues(alpha: 0.38),
                ),
              ),
            ],
          ),
          backgroundColor: adminTheme.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 1.8,
                indicatorColor: primary,
                labelColor: primary,
                unselectedLabelColor: onSurface.withValues(alpha: 0.48),
                labelStyle: GoogleFonts.notoSerifTc(fontSize: 12.5, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.notoSerifTc(fontSize: 12.5),
                tabs: const [
                  Tab(text: '總覽'),
                  Tab(text: '玩家'),
                  Tab(text: '客服'),
                  Tab(text: '內容'),
                  Tab(text: '營運'),
                  Tab(text: '分析'),
                  Tab(text: '系統'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildPlayersTab(),
            _buildSupportCenterTab(),
            _buildContentCenterTab(),
            _buildCampaignCenterTab(),
            _buildAnalyticsTab(),
            _buildSystemHealthTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: '公告標題', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                  labelText: '內容 (支援換行)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder())),
          CheckboxListTile(
            title: const Text('同時傳送小鈴鐺通知'),
            value: _sendNotification,
            onChanged: (val) =>
                setState(() => _sendNotification = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isPublishing ? null : _publish,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[50],
                  foregroundColor: Colors.pinkAccent),
              child: _isPublishing
                  ? const CircularProgressIndicator()
                  : const Text('發布公告並推播'),
            ),
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.forward_to_inbox_rounded),
              ),
              title: const Text('寄送玩家信件'),
              subtitle: const Text('選擇單一玩家，自訂標題與信件內容'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showSendAdminMailDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterManagementTab() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.public_rounded),
                  text: '公開角色',
                ),
                Tab(
                  icon: Icon(Icons.lock_outline_rounded),
                  text: '私人角色',
                ),
                Tab(
                  icon: Icon(Icons.hourglass_top_rounded),
                  text: '審核中',
                ),
                Tab(
                  icon: Icon(Icons.gpp_bad_outlined),
                  text: '違規角色',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPublicCharactersAdminTab(),
                _buildPrivateCharactersAdminTab(),
                _buildPendingCharactersAdminTab(),
                const _AdminCharacterPlaceholder(
                  icon: Icons.gpp_bad_outlined,
                  title: '違規角色',
                  description: '管理已下架或標記違規的角色',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCharactersAdminTab() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('pending_characters')
          .orderBy(
        'submittedAt',
        descending: true,
      )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '讀取待審角色失敗：\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const _AdminCharacterPlaceholder(
            icon: Icons.fact_check_outlined,
            title: '目前沒有待審角色',
            description: '玩家送出角色審核後會顯示在這裡',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final String characterId = doc.id;

            final String name = data['name']?.toString().trim() ?? '未命名角色';

            final String avatar = data['avatarPath']?.toString().trim() ?? '';

            final String creatorName =
                data['creatorName']?.toString().trim() ?? '未知創作者';

            final String creatorId = data['createdBy']?.toString().trim() ?? '';

            final String occupation =
                data['occupation']?.toString().trim() ?? '';

            final Timestamp? submittedTimestamp =
            data['submittedAt'] as Timestamp?;

            final String submittedText = submittedTimestamp == null
                ? '送審時間未知'
                : DateFormat(
              'yyyy/MM/dd HH:mm',
            ).format(
              submittedTimestamp.toDate(),
            );

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color:
                  Theme.of(context).colorScheme.outlineVariant.withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: avatar.isNotEmpty
                          ? getAvatarImageProvider(
                        avatar,
                      )
                          : null,
                      child: avatar.isEmpty
                          ? const Icon(
                        Icons.person_rounded,
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: const Text(
                                  '待審',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (occupation.isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              occupation,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '創作者：$creatorName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(
                                alpha: 0.55,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'UID：$creatorId',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(
                                alpha: 0.40,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_rounded,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                submittedText,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: '審核角色',
                      onSelected: (value) async {
                        switch (value) {
                          case 'approve':
                            await _adminApprovePendingCharacter(
                              characterId: characterId,
                              characterName: name,
                              creatorId: creatorId,
                              characterData: data,
                            );
                            break;

                          case 'reject':
                            await _adminRejectPendingCharacter(
                              characterId: characterId,
                              characterName: name,
                              creatorId: creatorId,
                              characterData: data,
                            );
                            break;

                          case 'violation':
                            await _adminPendingCharacterToViolation(
                              characterId: characterId,
                              characterName: name,
                              creatorId: creatorId,
                              characterData: data,
                            );
                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'approve',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.green,
                            ),
                            title: Text('審核通過'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'reject',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.undo_rounded,
                              color: Colors.orange,
                            ),
                            title: Text('退回修改'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'violation',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.gpp_bad_outlined,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                              '判定違規',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPublicCharactersAdminTab() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '讀取公開角色失敗：\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const _AdminCharacterPlaceholder(
            icon: Icons.public_off_rounded,
            title: '目前沒有公開角色',
            description: '公開角色上架後會顯示在這裡',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final String characterId = doc.id;
            final String name = data['name']?.toString().trim() ?? '未命名角色';
            final String avatar = data['avatarPath']?.toString().trim() ?? '';
            final String creatorName =
                data['creatorName']?.toString().trim() ?? '未知創作者';
            final String creatorId = data['createdBy']?.toString().trim() ?? '';

            final int playCount = (data['playCount'] as num?)?.toInt() ?? 0;
            final int likesCount = (data['likesCount'] as num?)?.toInt() ?? 0;

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.55),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: getAvatarImageProvider(avatar),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '創作者：$creatorName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.65),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'UID：$creatorId',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              _buildAdminCharacterStat(
                                icon: Icons.play_arrow_rounded,
                                value: playCount,
                              ),
                              _buildAdminCharacterStat(
                                icon: Icons.favorite_rounded,
                                value: likesCount,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: '角色管理',
                      onSelected: (value) async {
                        switch (value) {
                          case 'adjustment_notice':
                            await _showSendAdminMailDialog(
                              initialRecipientId: creatorId,
                              initialTitle: '角色「$name」內容調整通知',
                              initialBody:
                              '你好，我們在查看角色「$name」時，發現部分內容可能需要調整。\n\n請在此說明需要調整的內容。',
                            );
                            break;

                          case 'private':
                            await _adminMoveCharacterToPrivate(
                              characterId: characterId,
                              characterName: name,
                              creatorId: creatorId,
                              characterData: data,
                            );
                            break;

                          case 'violation':
                            await _adminMarkCharacterViolation(
                              characterId: characterId,
                              characterName: name,
                              creatorId: creatorId,
                              characterData: data,
                            );
                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'adjustment_notice',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.mark_email_unread_outlined,
                              color: Colors.orangeAccent,
                            ),
                            title: Text('寄送玩家信件'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'private',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.lock_outline),
                            title: Text('轉為私人'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'violation',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.gpp_bad_outlined,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                              '標記違規',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _adminApprovePendingCharacter({
    required String characterId,
    required String characterName,
    required String creatorId,
    required Map<String, dynamic> characterData,
  }) async {
    if (creatorId.trim().isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '找不到角色創作者 UID，無法通過審核',
        isError: true,
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('審核通過'),
          content: Text(
            '確定要讓「$characterName」通過審核並公開嗎？\n\n'
                '通過後，角色會從「審核中」移至「公開角色」。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('確認通過'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final db = FirebaseFirestore.instance;

      final pendingRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('pending_characters')
          .doc(characterId);

      final publicRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId);

      final batch = db.batch();

      final Map<String, dynamic> publicData = {
        ...characterData,

        // 公開狀態
        'isPublic': true,

        // 審核狀態
        'moderationStatus': 'approved',

        // 清掉退回或違規可能留下來的欄位
        'rejectionReason': FieldValue.delete(),
        'violationReason': FieldValue.delete(),

        // 管理後台紀錄
        'adminAction': 'approved',
        'adminUpdatedAt': FieldValue.serverTimestamp(),

        // 正式公開時間
        'publishedAt': FieldValue.serverTimestamp(),

        // 保留創作者
        'createdBy': creatorId,
      };

      // 1. 建立 / 更新公開角色
      batch.set(
        publicRef,
        publicData,
        SetOptions(merge: true),
      );

      // 2. 刪除待審角色
      batch.delete(
        pendingRef,
      );

      await batch.commit();

      // 3. 清角色快取
      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '「$characterName」已通過審核並公開',
        customIcon: Icons.check_circle_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 審核角色通過失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '審核通過失敗：$e',
        isError: true,
      );
    }
  }

  Future<void> _adminRejectPendingCharacter({
    required String characterId,
    required String characterName,
    required String creatorId,
    required Map<String, dynamic> characterData,
  }) async {
    if (creatorId.trim().isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '找不到角色創作者 UID，無法退回修改',
        isError: true,
      );
      return;
    }

    final TextEditingController reasonController = TextEditingController();

    final String? reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('退回修改'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '確定要將「$characterName」退回給創作者修改嗎？',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '退回原因',
                  hintText: '例如：角色描述需要補充、圖片不符合規範、設定內容需調整',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final value = reasonController.text.trim();

                if (value.isEmpty) {
                  ToastUtils.showCenterToast(
                    context,
                    '請先填寫退回原因',
                    isError: true,
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  value,
                );
              },
              child: const Text('確認退回'),
            ),
          ],
        );
      },
    );

    reasonController.dispose();

    if (reason == null || reason.trim().isEmpty) {
      return;
    }

    try {
      final db = FirebaseFirestore.instance;

      final pendingRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('pending_characters')
          .doc(characterId);

      final privateRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(creatorId)
          .collection('private_characters')
          .doc(characterId);

      final batch = db.batch();

      final Map<String, dynamic> privateData = {
        ...characterData,

        'isPublic': false,

        // 退回狀態
        'moderationStatus': 'rejected',
        'rejectionReason': reason.trim(),

        // 後台紀錄
        'adminAction': 'rejected',
        'adminUpdatedAt': FieldValue.serverTimestamp(),
        'rejectedAt': FieldValue.serverTimestamp(),

        // 保留創作者 UID
        'createdBy': creatorId,
      };

      // 搬回創作者私人角色
      batch.set(
        privateRef,
        privateData,
        SetOptions(merge: true),
      );

      // 從待審區移除
      batch.delete(
        pendingRef,
      );

      await batch.commit();

      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將「$characterName」退回修改',
        customIcon: Icons.undo_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 退回角色修改失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '退回修改失敗：$e',
        isError: true,
      );
    }
  }

  Future<void> _adminPendingCharacterToViolation({
    required String characterId,
    required String characterName,
    required String creatorId,
    required Map<String, dynamic> characterData,
  }) async {
    final TextEditingController reasonController = TextEditingController();

    final String? reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('判定違規'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '確定要將「$characterName」判定為違規並封存嗎？',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '違規原因',
                  hintText: '例如：侵權、未成年內容、違反創作者規範',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('取消'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                final value = reasonController.text.trim();

                if (value.isEmpty) {
                  ToastUtils.showCenterToast(
                    context,
                    '請先填寫違規原因',
                    isError: true,
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  value,
                );
              },
              child: const Text('確認判定違規'),
            ),
          ],
        );
      },
    );

    reasonController.dispose();

    if (reason == null || reason.trim().isEmpty) {
      return;
    }

    try {
      final db = FirebaseFirestore.instance;

      final pendingRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('pending_characters')
          .doc(characterId);

      final violationRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('violation_characters')
          .doc(characterId);

      final batch = db.batch();

      final Map<String, dynamic> violationData = {
        ...characterData,
        'isPublic': false,
        'moderationStatus': 'violation',
        'violationReason': reason.trim(),
        'originalOwnerId': creatorId,
        'adminAction': 'pending_to_violation',
        'adminUpdatedAt': FieldValue.serverTimestamp(),
        'violatedAt': FieldValue.serverTimestamp(),
        'createdBy': creatorId,
      };

      // 搬到違規角色區
      batch.set(
        violationRef,
        violationData,
        SetOptions(merge: true),
      );

      // 從待審區移除
      batch.delete(
        pendingRef,
      );

      await batch.commit();

      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將「$characterName」判定為違規並封存',
        customIcon: Icons.gpp_bad_outlined,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 待審角色判定違規失敗：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '判定違規失敗：$e',
        isError: true,
      );
    }
  }

  Widget _buildPrivateCharactersAdminTab() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collectionGroup('private_characters')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '讀取私人角色失敗：\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // collectionGroup 可能讀到其他路徑下同名集合，
        // 所以只保留本 App 的私人角色。
        final docs = (snapshot.data?.docs ?? []).where((doc) {
          final path = doc.reference.path;

          return path.startsWith(
            'artifacts/${AppConfig.appId}/users/',
          );
        }).toList();

        docs.sort((a, b) {
          final aData = a.data();
          final bData = b.data();

          final aTime = aData['adminUpdatedAt'] ??
              aData['updatedAt'] ??
              aData['createdAt'];

          final bTime = bData['adminUpdatedAt'] ??
              bData['updatedAt'] ??
              bData['createdAt'];

          final int aMillis =
          aTime is Timestamp ? aTime.millisecondsSinceEpoch : 0;

          final int bMillis =
          bTime is Timestamp ? bTime.millisecondsSinceEpoch : 0;

          return bMillis.compareTo(aMillis);
        });

        if (docs.isEmpty) {
          return const _AdminCharacterPlaceholder(
            icon: Icons.lock_open_outlined,
            title: '目前沒有私人角色',
            description: '創作者的私人角色會顯示在這裡',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final String characterId = doc.id;

            final String characterName =
                data['name']?.toString().trim() ?? '未命名角色';

            final String avatarPath =
                data['avatarPath']?.toString().trim() ?? '';

            final String creatorName =
                data['creatorName']?.toString().trim() ?? '未知創作者';

            final String createdBy = data['createdBy']?.toString().trim() ?? '';

            // 路徑：
            // artifacts/appId/users/UID/private_characters/characterId
            final String ownerUid =
                doc.reference.parent.parent?.id ?? createdBy;

            final int playCount = (data['playCount'] as num?)?.toInt() ?? 0;

            final int likesCount = (data['likesCount'] as num?)?.toInt() ?? 0;

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.55),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: avatarPath.isNotEmpty
                          ? getAvatarImageProvider(
                        avatarPath,
                      )
                          : null,
                      child: avatarPath.isEmpty
                          ? const Icon(
                        Icons.person_rounded,
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  characterName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '私人',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '創作者：$creatorName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.65),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'UID：$ownerUid',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              _buildAdminCharacterStat(
                                icon: Icons.play_arrow_rounded,
                                value: playCount,
                              ),
                              _buildAdminCharacterStat(
                                icon: Icons.favorite_rounded,
                                value: likesCount,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      tooltip: '角色管理',
                      onSelected: (value) async {
                        switch (value) {
                          case 'public':
                            await _adminRestorePrivateCharacterToPublic(
                              characterId: characterId,
                              characterName: characterName,
                              ownerUid: ownerUid,
                              characterData: data,
                            );
                            break;

                          case 'violation':
                            await _adminMovePrivateCharacterToViolation(
                              characterId: characterId,
                              characterName: characterName,
                              ownerUid: ownerUid,
                              characterData: data,
                            );
                            break;
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'public',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.public_rounded,
                              color: Colors.green,
                            ),
                            title: Text('恢復公開'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'violation',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.gpp_bad_outlined,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                              '標記違規',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdminCharacterStat({
    required IconData icon,
    required int value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 3),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 舊版角色專屬寄信流程先保留，確認通用寄信穩定後可刪除。
  // ignore: unused_element
  Future<void> _sendCharacterAdjustmentNotice({
    required String characterId,
    required String characterName,
    required String creatorId,
  }) async {
    if (creatorId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '此角色沒有 createdBy，無法寄送通知',
        isError: true,
      );
      return;
    }

    final reasonController = TextEditingController();
    bool requirePrivate = true;

    final Map<String, dynamic>? notice = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(width: 9),
                  Expanded(child: Text('寄送角色調整通知')),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('角色：「$characterName」'),
                    const SizedBox(height: 6),
                    Text(
                      '創作者 UID：$creatorId',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: reasonController,
                      minLines: 4,
                      maxLines: 8,
                      maxLength: 1000,
                      decoration: const InputDecoration(
                        labelText: '需要調整的內容',
                        hintText: '例如：角色介紹含有不符合創作者規範的內容，請調整後再公開。',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: requirePrivate,
                      title: const Text('建議先將角色轉為私人'),
                      subtitle: const Text(
                        '這是信件提醒，不會自動將角色下架。',
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          requirePrivate = value ?? true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('取消'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    final reason = reasonController.text.trim();

                    if (reason.isEmpty) {
                      ToastUtils.showCenterToast(
                        context,
                        '請填寫需要調整的內容',
                        isError: true,
                      );
                      return;
                    }

                    Navigator.pop(dialogContext, {
                      'reason': reason,
                      'requirePrivate': requirePrivate,
                    });
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('確認寄送'),
                ),
              ],
            );
          },
        );
      },
    );

    reasonController.dispose();

    if (notice == null || !mounted) return;

    try {
      final callable = _functions.httpsCallable(
        'sendCharacterAdjustmentNotice',
      );

      await callable.call({
        'characterId': characterId,
        'reason': notice['reason'],
        'requirePrivate': notice['requirePrivate'] == true,
      });

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將調整通知寄給「$characterName」的創作者',
        customIcon: Icons.mark_email_read_rounded,
      );
    } on FirebaseFunctionsException catch (error) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        error.message ?? '寄送調整通知失敗',
        isError: true,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ 寄送角色調整通知失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '寄送調整通知失敗，請稍後再試',
        isError: true,
      );
    }
  }

  Future<void> _showSendAdminMailDialog({
    String initialRecipientId = '',
    String initialTitle = '',
    String initialBody = '',
  }) async {
    // 從 PopupMenuButton 進入時，先等選單 Overlay 完全關閉。
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final recipientController = TextEditingController(
      text: initialRecipientId,
    );
    final mailTitleController = TextEditingController(
      text: initialTitle,
    );
    final mailBodyController = TextEditingController(
      text: initialBody,
    );

    String verifiedUid = '';
    String recipientName = '';
    bool isChecking = false;
    bool isSending = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> verifyRecipient() async {
              final uid = recipientController.text.trim();

              if (uid.isEmpty) {
                ToastUtils.showCenterToast(
                  context,
                  '請輸入玩家 UID',
                  isError: true,
                );
                return;
              }

              setDialogState(() => isChecking = true);

              try {
                final result = await _functions
                    .httpsCallable('lookupAdminMailboxRecipient')
                    .call({'recipientUid': uid});

                final data = result.data is Map
                    ? Map<String, dynamic>.from(result.data as Map)
                    : <String, dynamic>{};

                if (!dialogContext.mounted) return;

                if (data['exists'] != true) {
                  setDialogState(() {
                    verifiedUid = '';
                    recipientName = '';
                  });
                  ToastUtils.showCenterToast(
                    context,
                    '找不到這位玩家，請檢查 UID',
                    isError: true,
                  );
                  return;
                }

                setDialogState(() {
                  verifiedUid = uid;
                  recipientName =
                      data['recipientName']?.toString().trim() ?? '未設定暱稱的玩家';
                });
              } on FirebaseFunctionsException catch (error) {
                if (!dialogContext.mounted) return;
                ToastUtils.showCenterToast(
                  context,
                  error.message ?? '查詢玩家失敗',
                  isError: true,
                );
              } finally {
                if (dialogContext.mounted) {
                  setDialogState(() => isChecking = false);
                }
              }
            }

            Future<void> sendMail() async {
              final currentUid = recipientController.text.trim();
              final title = mailTitleController.text.trim();
              final body = mailBodyController.text.trim();

              if (verifiedUid.isEmpty || verifiedUid != currentUid) {
                ToastUtils.showCenterToast(
                  context,
                  '請先查詢並確認收件人',
                  isError: true,
                );
                return;
              }

              if (title.isEmpty || body.isEmpty) {
                ToastUtils.showCenterToast(
                  context,
                  '請填寫信件標題與內容',
                  isError: true,
                );
                return;
              }

              setDialogState(() => isSending = true);

              try {
                await _functions.httpsCallable('sendAdminMailboxMessage').call({
                  'recipientUid': verifiedUid,
                  'title': title,
                  'body': body,
                });

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);

                if (!mounted) return;
                ToastUtils.showCenterToast(
                  this.context,
                  '信件已寄給 $recipientName',
                  customIcon: Icons.mark_email_read_rounded,
                );
              } on FirebaseFunctionsException catch (error) {
                if (!dialogContext.mounted) return;
                ToastUtils.showCenterToast(
                  context,
                  error.message ?? '寄信失敗',
                  isError: true,
                );
              } finally {
                if (dialogContext.mounted) {
                  setDialogState(() => isSending = false);
                }
              }
            }

            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.forward_to_inbox_rounded),
                  SizedBox(width: 8),
                  Text('寄送玩家信件'),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: recipientController,
                        decoration: InputDecoration(
                          labelText: '收件人 UID',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            tooltip: '查詢收件人',
                            onPressed: isChecking ? null : verifyRecipient,
                            icon: isChecking
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(Icons.person_search_rounded),
                          ),
                        ),
                        onChanged: (_) {
                          if (verifiedUid.isNotEmpty) {
                            setDialogState(() {
                              verifiedUid = '';
                              recipientName = '';
                            });
                          }
                        },
                      ),
                      if (verifiedUid.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('✓ 收件人：$recipientName'),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: mailTitleController,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: '信件標題',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: mailBodyController,
                        minLines: 6,
                        maxLines: 12,
                        maxLength: 3000,
                        decoration: const InputDecoration(
                          labelText: '信件內容',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                  isSending ? null : () => Navigator.pop(dialogContext),
                  child: const Text('取消'),
                ),
                FilledButton.icon(
                  onPressed: isSending ? null : sendMail,
                  icon: isSending
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.send_rounded),
                  label: Text(isSending ? '寄送中…' : '寄送信件'),
                ),
              ],
            );
          },
        );
      },
    );

    // 等待 Dialog 關閉動畫完成後再釋放 Controller。
    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    recipientController.dispose();
    mailTitleController.dispose();
    mailBodyController.dispose();
  }

  Future<void> _adminMoveCharacterToPrivate({
    required String characterId,
    required String characterName,
    required String creatorId,
    required Map<String, dynamic> characterData,
  }) async {
    if (creatorId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '此角色沒有 createdBy，無法轉為私人',
        isError: true,
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('轉為私人角色'),
        content: Text(
          '確定要將「$characterName」轉為私人嗎？\n\n'
              '轉換後，角色會從公開區下架，'
              '但仍保留在創作者的私人角色中。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('確認轉為私人'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final publicRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId);

      final privateRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(creatorId)
          .collection('private_characters')
          .doc(characterId);

      final Map<String, dynamic> privateData = {
        ...characterData,
        'isPublic': false,
        'moderationStatus': 'normal',
        'adminUpdatedAt': FieldValue.serverTimestamp(),
        'adminAction': 'moved_to_private',
      };

      batch.set(
        privateRef,
        privateData,
        SetOptions(merge: true),
      );

      batch.delete(publicRef);

      await batch.commit();
      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將「$characterName」轉為私人',
        customIcon: Icons.lock_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 管理員轉私人失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '轉為私人失敗：$e',
        isError: true,
      );
    }
  }

  Future<void> _adminMarkCharacterViolation({
    required String characterId,
    required String characterName,
    required String creatorId,
    required Map<String, dynamic> characterData,
  }) async {
    final TextEditingController reasonController = TextEditingController();

    final String? reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('標記違規角色'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '確定要將「$characterName」標記為違規並下架嗎？',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '違規原因',
                hintText: '例如：侵權、未成年內容、違反創作者規範',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              final value = reasonController.text.trim();

              if (value.isEmpty) {
                return;
              }

              Navigator.pop(
                dialogContext,
                value,
              );
            },
            child: const Text('確認下架'),
          ),
        ],
      ),
    );

    reasonController.dispose();

    if (reason == null || reason.isEmpty) {
      return;
    }

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final publicRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId);

      final violationRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('violation_characters')
          .doc(characterId);

      final Map<String, dynamic> violationData = {
        ...characterData,
        'isPublic': false,
        'moderationStatus': 'violation',
        'violationReason': reason,
        'violatedAt': FieldValue.serverTimestamp(),
        'adminUpdatedAt': FieldValue.serverTimestamp(),
        'originalOwnerId': creatorId,
      };

      batch.set(
        violationRef,
        violationData,
        SetOptions(merge: true),
      );

      batch.delete(publicRef);

      await batch.commit();

      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將「$characterName」標記違規並下架',
        customIcon: Icons.gpp_bad_outlined,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 標記違規失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '標記違規失敗：$e',
        isError: true,
      );
    }
  }

  Future<void> _adminRestorePrivateCharacterToPublic({
    required String characterId,
    required String characterName,
    required String ownerUid,
    required Map<String, dynamic> characterData,
  }) async {
    if (ownerUid.trim().isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '找不到角色創作者 UID，無法恢復公開',
        isError: true,
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('恢復公開角色'),
          content: Text(
            '確定要將「$characterName」恢復公開嗎？\n\n'
                '恢復後會重新出現在公開角色區。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('確認恢復公開'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final privateRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(ownerUid)
          .collection('private_characters')
          .doc(characterId);

      final publicRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId);

      final Map<String, dynamic> publicData = {
        ...characterData,
        'isPublic': true,
        'moderationStatus': 'normal',
        'adminAction': 'restored_to_public',
        'adminUpdatedAt': FieldValue.serverTimestamp(),
        'publishedAt':
        characterData['publishedAt'] ?? FieldValue.serverTimestamp(),
      };

      batch.set(
        publicRef,
        publicData,
        SetOptions(merge: true),
      );

      batch.delete(privateRef);

      await batch.commit();

      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將「$characterName」恢復公開',
        customIcon: Icons.public_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 恢復公開失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '恢復公開失敗：$e',
        isError: true,
      );
    }
  }

  Future<void> _adminMovePrivateCharacterToViolation({
    required String characterId,
    required String characterName,
    required String ownerUid,
    required Map<String, dynamic> characterData,
  }) async {
    final TextEditingController reasonController = TextEditingController();

    final String? reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('標記私人角色違規'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '確定要將「$characterName」標記為違規嗎？',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '違規原因',
                  hintText: '例如：侵權、未成年內容、違反創作者規範',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('取消'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                final value = reasonController.text.trim();

                if (value.isEmpty) {
                  ToastUtils.showCenterToast(
                    context,
                    '請先填寫違規原因',
                    isError: true,
                  );
                  return;
                }

                Navigator.pop(
                  dialogContext,
                  value,
                );
              },
              child: const Text('確認標記違規'),
            ),
          ],
        );
      },
    );

    reasonController.dispose();

    if (reason == null || reason.trim().isEmpty) {
      return;
    }

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final privateRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(ownerUid)
          .collection('private_characters')
          .doc(characterId);

      final violationRef = db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('violation_characters')
          .doc(characterId);

      final Map<String, dynamic> violationData = {
        ...characterData,
        'isPublic': false,
        'moderationStatus': 'violation',
        'violationReason': reason.trim(),
        'originalOwnerId': ownerUid,
        'violatedAt': FieldValue.serverTimestamp(),
        'adminUpdatedAt': FieldValue.serverTimestamp(),
        'adminAction': 'private_to_violation',
      };

      batch.set(
        violationRef,
        violationData,
        SetOptions(merge: true),
      );

      batch.delete(privateRef);

      await batch.commit();

      CharacterRepository.invalidate(
        characterId,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已將「$characterName」標記違規',
        customIcon: Icons.gpp_bad_outlined,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 私人角色標記違規失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '標記違規失敗：$e',
        isError: true,
      );
    }
  }

  Widget _buildVoiceBankTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('voice_bank')
          .orderBy('name')
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 🌍 遊玩指南翻譯同步
            _buildHelpTranslationAdminCard(
              context,
            ),

            const SizedBox(height: 20),

            // 🔎 拾光牆搜尋索引管理
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.manage_search_rounded,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '拾光牆搜尋索引',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '掃描所有舊公開貼文，依貼文內容與作者名稱補上 '
                          'searchKeywords，讓歷史貼文也能在拾光牆被搜尋。'
                          '重複執行會重新整理索引，不會建立重複貼文。',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isBackfillingMomentSearch
                            ? null
                            : _backfillMomentSearchKeywords,
                        icon: _isBackfillingMomentSearch
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(Icons.saved_search_rounded),
                        label: Text(
                          _isBackfillingMomentSearch
                              ? '正在補建搜尋索引...'
                              : '補建舊公開貼文搜尋索引',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 👤 創作者名稱同步
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.manage_accounts_rounded,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '創作者名稱同步',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '根據角色的 createdBy，從 users/{uid} 讀取 nickname，'
                          '並補上 creatorName 與 creatorNameLower。',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                        _isSyncingCreatorNames ? null : _syncCreatorNames,
                        icon: _isSyncingCreatorNames
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(
                          Icons.sync_rounded,
                        ),
                        label: Text(
                          _isSyncingCreatorNames ? '同步創作者名稱中...' : '一鍵同步創作者名稱',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🎤 Voice Bank 管理
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.record_voice_over_rounded,
                          color: Colors.pinkAccent,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Voice Bank 管理',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '同步後端預設的聲音資料到 Firestore。'
                          '同一個文件會更新，不會重複建立。',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed:
                        _isUploadingVoiceBank ? null : _uploadVoiceBank,
                        icon: _isUploadingVoiceBank
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(
                          Icons.cloud_upload_rounded,
                        ),
                        label: Text(
                          _isUploadingVoiceBank ? '同步中...' : '同步 Voice Bank',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '目前共 ${docs.length} 個聲音',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // 下面原本的讀取狀態與 Voice 清單
            if (snapshot.connectionState == ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (snapshot.hasError)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '讀取聲音庫失敗：${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            else if (docs.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        '目前尚未建立 Voice Bank',
                      ),
                    ),
                  ),
                )
              else
                ...docs.map((doc) {
                  // 你原本這裡的內容全部保留
                  final data = doc.data() as Map<String, dynamic>;

                  final String name = data['name']?.toString() ?? '未命名聲音';

                  final String voiceId = data['voiceId']?.toString() ?? '';

                  final String gender = data['gender']?.toString() ?? '';

                  final String age = data['age']?.toString() ?? '';

                  final bool enabled = data['enabled'] == true;

                  final tags = data['tags'] is List
                      ? List<String>.from(
                    data['tags'],
                  )
                      : <String>[];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ListTile(
                      // 你原本 ListTile 內容全部保留
                      title: Text(name),
                    ),
                  );
                }),
          ],
        );
      },
    );
  }

  Widget _buildReportTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reports').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("🚨 檢舉頁面報錯：${snapshot.error}");
          return Center(
              child: Text('載入失敗：\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('目前沒有待處理的案件 ✨'),
          );
        }

        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final status = data['status']?.toString().trim();

          return status == null || status.isEmpty || status == 'pending';
        }).toList();

        if (docs.isEmpty) {
          return const Center(
            child: Text('目前沒有待處理的案件 ✨'),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            final String imageUrl = data['imageUrl']?.toString().trim() ?? '';
            // ✨ 1. 智慧解析檢舉類型與標題
            String typeText = '一般檢舉';
            String targetName = '';
            String displayContent = data['content']?.toString() ?? '無具體文字';

            if (data['type'] == 'character' ||
                data['relatedType'] == 'character') {
              typeText = '🚩 角色檢舉';

              final characterName =
              data['reportedCharacterName']?.toString().trim();

              if (characterName != null && characterName.isNotEmpty) {
                targetName = '角色：$characterName';
              }

              final reason = data['reason']?.toString().trim() ?? '';

              final details = data['details']?.toString().trim() ?? '';

              if (details.isNotEmpty) {
                displayContent = '檢舉原因：$reason\n補充說明：$details';
              } else {
                displayContent = '檢舉原因：$reason';
              }
            } else if (data['type'] == 'block_character') {
              typeText = '🚫 封鎖角色';

              targetName = data['blockedCharacterName'] != null
                  ? '角色：${data['blockedCharacterName']}'
                  : '';
            } else if (data['relatedType'] == 'moment') {
              typeText = '💬 貼文相關';
            } else if (data['reportedMessage'] != null ||
                data['reason'] == '回覆不恰當') {
              typeText = '💬 聊天回覆檢舉';

              if (data['reason'] != null) {
                targetName = '原因：${data['reason']}';
              }

              if (data['reportedMessage'] != null) {
                displayContent = '被檢舉訊息：「${data['reportedMessage']}」';
              }
            }

// 組合顯示的主標題
            String mainTitle =
            targetName.isNotEmpty ? '$typeText - $targetName' : typeText;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  mainTitle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.pinkAccent),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '回報內容：'
                            '${data['content'] ?? '無具體文字'}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '回報者 UID：'
                            '${data['reporterId'] ?? data['userId'] ?? data['createdBy'] ?? '未知'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (imageUrl.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: InteractiveViewer(
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _showReplyDialog(
                      docs[index].id,
                      data['reporterId'] ??
                          data['userId'] ??
                          data['createdBy'] ??
                          '',
                      data['content'] ??
                          data['blockedCharacterName'] ??
                          '該檢舉項目'),
                  child: const Text('處理'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminCharacterPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AdminCharacterPlaceholder({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 50),
        Icon(
          icon,
          size: 68,
          color: theme.colorScheme.primary.withValues(
            alpha: 0.45,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: theme.colorScheme.onSurface.withValues(
              alpha: 0.58,
            ),
          ),
        ),
      ],
    );
  }
}
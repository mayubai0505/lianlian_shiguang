import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  State<AnnouncementNotificationButton> createState() => _AnnouncementNotificationButtonState();
}

class _AnnouncementNotificationButtonState extends State<AnnouncementNotificationButton> {
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
    await prefs.setInt('lastReadAnnouncementTime', DateTime.now().millisecondsSinceEpoch);

    // 3. 🚀 跳轉到妳寫給玩家看的「公告列表頁面」
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerAnnouncementPage()));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // ✨ 關鍵：使用 Flutter 內建的 Badge 來畫小紅點
      icon: Badge(
        isLabelVisible: _hasNewAnnouncement, // 控制紅點要不要出現！
        backgroundColor: Colors.redAccent,   // 紅點顏色
        smallSize: 10,                       // 紅點的大小
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

class _AdminAnnouncementPageState extends State<AdminAnnouncementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // 公告用的 Controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _sendNotification = true;
  bool _isPublishing = false;
  bool _isUploadingVoiceBank = false;
  bool _isSyncingCreatorNames = false;
  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  );
  bool _isSyncingHelpTranslation = false;
  String _helpTranslationStatus = '';
  String _selectedHelpLanguage = 'en';
  final Map<String, String>
  _helpLanguages = const {
    'en': 'English',
    'ja': '日本語',
    'ko': '한국어',
  };
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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

          final String creatorUid =
              data['createdBy']?.toString().trim() ?? '';

          if (creatorUid.isEmpty) {
            skippedCount++;
            debugPrint(
              '⚠️ 角色 ${characterDoc.id} 沒有 createdBy，略過',
            );
            continue;
          }

          String creatorName =
              creatorNameCache[creatorUid] ?? '';

          if (!creatorNameCache.containsKey(creatorUid)) {
            final creatorDoc = await db
                .collection('users')
                .doc(creatorUid)
                .get();

            creatorName =
                creatorDoc.data()?['nickname']
                    ?.toString()
                    .trim() ??
                    '';

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
            'creatorNameLower':
            creatorName.toLowerCase(),
            'creatorMetadataUpdatedAt':
            FieldValue.serverTimestamp(),
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
      DocumentReference annRef = FirebaseFirestore.instance.collection(
          'announcements').doc();
      batch.set(annRef, {
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (_sendNotification) {
        DocumentReference notifyRef = FirebaseFirestore.instance.collection(
            'system_notifications').doc();
        batch.set(notifyRef, {
          'title': '📢 ${l10n.announcement_new}：${_titleController.text.trim()}',
          'message': l10n.mail_notification,
          'type': 'global_announcement',
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

      final int count =
          (data['count'] as num?)?.toInt() ?? 0;

      debugPrint(
        '✅ Voice Bank 同步成功：$data',
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        'Voice Bank 已同步 $count 筆聲音',
        customIcon: Icons.cloud_done_rounded,
      );
    } on FirebaseFunctionsException catch ( e, stackTrace ) {
    debugPrint(
    '========== uploadVoiceBank 失敗 ==========',
    );
    debugPrint('code: ${e.code}');
    debugPrint('message: ${e.message}');
    debugPrint('details: ${e.details}');
    debugPrintStack(stackTrace: stackTrace,);

    if (!mounted) return;

    ToastUtils.showCenterToast(context, e.message ?? 'Voice Bank 同步失敗', isError: true,);

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
    final l10n =
    AppLocalizations.of(context)!;

    final replyController =
    TextEditingController();

    final flowerController =
    TextEditingController();

    // ==========================================
    // 第一階段：
    // Dialog 只負責收資料
    // 不在 Dialog 裡寫 Firestore
    // ==========================================
    final Map<String, dynamic>? result =
    await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
          const Text('回覆玩家檢舉/建議'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
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
                  controller:
                  replyController,
                  maxLines: 4,
                  decoration:
                  const InputDecoration(
                    labelText: '回覆內容',
                    hintText:
                    '輸入回覆內容...',
                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller:
                  flowerController,
                  keyboardType:
                  TextInputType.number,
                  decoration:
                  const InputDecoration(
                    labelText:
                    '補償花花點數（選填）',
                    hintText:
                    '不補償可留空，例如：5',
                    prefixIcon: Icon(
                      Icons
                          .local_florist_outlined,
                    ),
                    border:
                    OutlineInputBorder(),
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
                final replyText =
                replyController.text
                    .trim();

                if (replyText.isEmpty) {
                  // Dialog 裡不要再叫 Overlay Toast，
                  // 直接用 SnackBar 或乾脆不關閉。
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content:
                      Text('請先輸入回覆內容'),
                    ),
                  );
                  return;
                }

                final flowerText =
                flowerController.text
                    .trim();

                final int flowerAmount =
                flowerText.isEmpty
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
                  'replyText':
                  replyText,
                  'flowerAmount':
                  flowerAmount,
                });
              },
              child:
              const Text('確認回覆'),
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

    final String replyText =
        result['replyText']
            ?.toString()
            .trim() ??
            '';

    final int flowerAmount =
        result['flowerAmount']
        as int? ??
            0;

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
      final db =
          FirebaseFirestore.instance;

      final batch =
      db.batch();

      final adminUid =
          FirebaseAuth
              .instance
              .currentUser
              ?.uid ??
              '';

      // --------------------------
      // 1. 處理 report
      // --------------------------
      final reportRef = db
          .collection('reports')
          .doc(reportId);

      batch.update(
        reportRef,
        {
          'status': 'resolved',
          'adminReply': replyText,
          'compensationFlowerPoints':
          flowerAmount,
          'compensatedBy':
          adminUid,
          'resolvedAt':
          FieldValue
              .serverTimestamp(),
        },
      );

      // --------------------------
      // 2. 寄客服信
      // --------------------------
      final mailboxRef = db
          .collection('users')
          .doc(reporterId)
          .collection('mailbox')
          .doc();

      final String mailboxBody =
      flowerAmount > 0
          ? '$replyText\n\n'
          '已補償 $flowerAmount 點花花至您的帳號。'
          : replyText;

      batch.set(
        mailboxRef,
        {
          'type': 'cs_reply',
          'title': '客服回覆 💌',
          'body': mailboxBody,
          'isRead': false,
          'createdAt':
          FieldValue
              .serverTimestamp(),
        },
      );

      // --------------------------
      // 3. 有補花花才執行
      // --------------------------
      if (flowerAmount > 0) {
        final userRef = db
            .collection('users')
            .doc(reporterId);

        batch.update(
          userRef,
          {
            'flowerPoints':
            FieldValue.increment(
              flowerAmount,
            ),
          },
        );

        // --------------------------
        // 4. 花花明細
        // --------------------------
        final flowerLogRef =
        userRef
            .collection(
          'flower_logs',
        )
            .doc();

        batch.set(
          flowerLogRef,
          {
            'title': '客服補償',
            'amount':
            flowerAmount,
            'reason':
            '客服案件補償',
            'reportId':
            reportId,
            'adminReply':
            replyText,
            'adminUid':
            adminUid,
            'type':
            'cs_compensation',
            'createdAt':
            FieldValue
                .serverTimestamp(),
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
        flowerAmount > 0
            ? '已處理並補償 $flowerAmount 點花花'
            : '已處理並寄送回信！',
        customIcon:
        flowerAmount > 0
            ? Icons
            .local_florist_rounded
            : Icons
            .mark_email_read_rounded,
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ 處理客服案件失敗：$e',
      );

      debugPrintStack(
        stackTrace:
        stackTrace,
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
        borderRadius:
        BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.primary
              .withValues(alpha: 0.14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.translate_rounded,
                  color:
                  theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '遊玩指南翻譯',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
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
                color: theme
                    .colorScheme.onSurface
                    .withValues(alpha: 0.65),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedHelpLanguage,
              decoration:
              const InputDecoration(
                labelText: '目標語言',
                border: OutlineInputBorder(),
              ),
              items: _helpLanguages.entries
                  .map(
                    (entry) =>
                    DropdownMenuItem(
                      value: entry.key,
                      child: Text(
                        entry.value,
                      ),
                    ),
              )
                  .toList(),
              onChanged:
              _isSyncingHelpTranslation
                  ? null
                  : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedHelpLanguage =
                      value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                _isSyncingHelpTranslation
                    ? null
                    : () =>
                    _syncHelpTranslation(
                      context,
                    ),
                icon:
                _isSyncingHelpTranslation
                    ? const SizedBox.square(
                  dimension: 18,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.cloud_upload_outlined,
                ),
                label: Text(
                  _isSyncingHelpTranslation
                      ? '翻譯同步中...'
                      : '同步遊玩指南翻譯',
                ),
              ),
            ),
            if (_helpTranslationStatus
                .isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.55),
                  borderRadius:
                  BorderRadius.circular(12),
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
      _helpTranslationStatus =
      '準備開始翻譯...';
    });

    try {
      await HelpTranslationAdminService
          .syncLanguage(
        targetLanguage:
        _selectedHelpLanguage,
        onProgress: (message) {
          if (!mounted) return;

          setState(() {
            _helpTranslationStatus =
                message;
          });
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
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
        _helpTranslationStatus =
        '同步失敗：$error';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '翻譯同步失敗：$error',
          ),
          backgroundColor:
          Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSyncingHelpTranslation =
          false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('📢 拾光管理後台', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.pinkAccent,
          tabs: const [
            Tab(
              icon: Icon(Icons.campaign_outlined),
              text: '發布公告',
            ),
            Tab(
              icon: Icon(Icons.report_problem_outlined),
              text: '未處理檢舉',
            ),
            Tab(
              icon: Icon(Icons.record_voice_over_outlined),
              text: '聲音庫',
            ),
            Tab(
              icon: Icon(Icons.manage_accounts_rounded),
              text: '角色管理',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnnouncementTab(),
          _buildReportTab(),
          _buildVoiceBankTab(),
          _buildCharacterManagementTab(),
        ],
      ),
    );
  }

  Widget _buildAnnouncementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: '公告標題', border: OutlineInputBorder())),
          const SizedBox(height: 20),
          TextField(controller: _contentController, maxLines: 8, decoration: const InputDecoration(labelText: '內容 (支援換行)', alignLabelWithHint: true, border: OutlineInputBorder())),
          CheckboxListTile(
            title: const Text('同時傳送小鈴鐺通知'),
            value: _sendNotification,
            onChanged: (val) => setState(() => _sendNotification = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isPublishing ? null : _publish,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[50], foregroundColor: Colors.pinkAccent),
              child: _isPublishing ? const CircularProgressIndicator() : const Text('發布公告並推播'),
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
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
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

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs =
            snapshot.data?.docs ?? [];

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
          separatorBuilder: (_, __) =>
          const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final String characterId =
                doc.id;

            final String name =
                data['name']
                    ?.toString()
                    .trim() ??
                    '未命名角色';

            final String avatar =
                data['avatarPath']
                    ?.toString()
                    .trim() ??
                    '';

            final String creatorName =
                data['creatorName']
                    ?.toString()
                    .trim() ??
                    '未知創作者';

            final String creatorId =
                data['createdBy']
                    ?.toString()
                    .trim() ??
                    '';

            final String occupation =
                data['occupation']
                    ?.toString()
                    .trim() ??
                    '';

            final Timestamp?
            submittedTimestamp =
            data['submittedAt']
            as Timestamp?;

            final String submittedText =
            submittedTimestamp == null
                ? '送審時間未知'
                : DateFormat(
              'yyyy/MM/dd HH:mm',
            ).format(
              submittedTimestamp
                  .toDate(),
            );

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor:
                      Colors.grey.shade200,
                      backgroundImage:
                      avatar.isNotEmpty
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
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style:
                                  const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),

                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration:
                                BoxDecoration(
                                  color: Colors
                                      .orange
                                      .withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),
                                child:
                                const Text(
                                  '待審',
                                  style:
                                  TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    color:
                                    Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (occupation
                              .isNotEmpty) ...[
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              occupation,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(
                                  context,
                                )
                                    .colorScheme
                                    .onSurface
                                    .withValues(
                                  alpha:
                                  0.65,
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
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              Theme.of(
                                context,
                              )
                                  .colorScheme
                                  .onSurface
                                  .withValues(
                                alpha:
                                0.55,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 2,
                          ),

                          Text(
                            'UID：$creatorId',
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color:
                              Theme.of(
                                context,
                              )
                                  .colorScheme
                                  .onSurface
                                  .withValues(
                                alpha:
                                0.40,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .schedule_rounded,
                                size: 14,
                                color:
                                Colors.grey,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                submittedText,
                                style:
                                const TextStyle(
                                  fontSize: 11,
                                  color:
                                  Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    PopupMenuButton<String>(
                      tooltip: '審核角色',
                      onSelected:
                          (value) async {
                        switch (value) {
                          case 'approve':
                            await _adminApprovePendingCharacter(
                              characterId:
                              characterId,
                              characterName:
                              name,
                              creatorId:
                              creatorId,
                              characterData:
                              data,
                            );
                            break;

                          case 'reject':
                            await _adminRejectPendingCharacter(
                              characterId:
                              characterId,
                              characterName:
                              name,
                              creatorId:
                              creatorId,
                              characterData:
                              data,
                            );
                            break;

                          case 'violation':
                            await _adminPendingCharacterToViolation(
                              characterId:
                              characterId,
                              characterName:
                              name,
                              creatorId:
                              creatorId,
                              characterData:
                              data,
                            );
                            break;
                        }
                      },
                      itemBuilder: (_) =>
                      const [
                        PopupMenuItem(
                          value: 'approve',
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.zero,
                            leading: Icon(
                              Icons
                                  .check_circle_outline_rounded,
                              color:
                              Colors.green,
                            ),
                            title:
                            Text('審核通過'),
                          ),
                        ),

                        PopupMenuItem(
                          value: 'reject',
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.zero,
                            leading: Icon(
                              Icons
                                  .undo_rounded,
                              color:
                              Colors.orange,
                            ),
                            title:
                            Text('退回修改'),
                          ),
                        ),

                        PopupMenuItem(
                          value:
                          'violation',
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.zero,
                            leading: Icon(
                              Icons
                                  .gpp_bad_outlined,
                              color: Colors
                                  .redAccent,
                            ),
                            title: Text(
                              '判定違規',
                              style:
                              TextStyle(
                                color: Colors
                                    .redAccent,
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

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
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
          separatorBuilder: (_, __) =>
          const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final String characterId = doc.id;
            final String name =
                data['name']?.toString().trim() ??
                    '未命名角色';
            final String avatar =
                data['avatarPath']?.toString().trim() ??
                    '';
            final String creatorName =
                data['creatorName']?.toString().trim() ??
                    '未知創作者';
            final String creatorId =
                data['createdBy']?.toString().trim() ??
                    '';

            final int playCount =
                (data['playCount'] as num?)?.toInt() ??
                    0;
            final int likesCount =
                (data['likesCount'] as num?)?.toInt() ??
                    0;

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage:
                      getAvatarImageProvider(avatar),
                      backgroundColor:
                      Colors.grey.shade200,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '創作者：$creatorName',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
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
                            overflow:
                            TextOverflow.ellipsis,
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
                          value: 'private',
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.zero,
                            leading:
                            Icon(Icons.lock_outline),
                            title: Text('轉為私人'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'violation',
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.zero,
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

    final bool? confirmed =
    await showDialog<bool>(
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
      final db =
          FirebaseFirestore.instance;

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
        'adminUpdatedAt':
        FieldValue.serverTimestamp(),

        // 正式公開時間
        'publishedAt':
        FieldValue.serverTimestamp(),

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
        customIcon:
        Icons.check_circle_rounded,
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

    final TextEditingController reasonController =
    TextEditingController();

    final String? reason =
    await showDialog<String>(
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
                final value =
                reasonController.text.trim();

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

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    try {
      final db =
          FirebaseFirestore.instance;

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
        'rejectionReason':
        reason.trim(),

        // 後台紀錄
        'adminAction': 'rejected',
        'adminUpdatedAt':
        FieldValue.serverTimestamp(),
        'rejectedAt':
        FieldValue.serverTimestamp(),

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
        customIcon:
        Icons.undo_rounded,
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
    final TextEditingController reasonController =
    TextEditingController();

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
                final value =
                reasonController.text.trim();

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

    if (reason == null ||
        reason.trim().isEmpty) {
      return;
    }

    try {
      final db =
          FirebaseFirestore.instance;

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
        'violationReason':
        reason.trim(),

        'originalOwnerId':
        creatorId,

        'adminAction':
        'pending_to_violation',

        'adminUpdatedAt':
        FieldValue.serverTimestamp(),

        'violatedAt':
        FieldValue.serverTimestamp(),

        'createdBy':
        creatorId,
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
        customIcon:
        Icons.gpp_bad_outlined,
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

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // collectionGroup 可能讀到其他路徑下同名集合，
        // 所以只保留本 App 的私人角色。
        final docs = (snapshot.data?.docs ?? [])
            .where((doc) {
          final path = doc.reference.path;

          return path.startsWith(
            'artifacts/${AppConfig.appId}/users/',
          );
        }).toList();

        docs.sort((a, b) {
          final aData = a.data();
          final bData = b.data();

          final aTime =
              aData['adminUpdatedAt'] ??
                  aData['updatedAt'] ??
                  aData['createdAt'];

          final bTime =
              bData['adminUpdatedAt'] ??
                  bData['updatedAt'] ??
                  bData['createdAt'];

          final int aMillis = aTime is Timestamp
              ? aTime.millisecondsSinceEpoch
              : 0;

          final int bMillis = bTime is Timestamp
              ? bTime.millisecondsSinceEpoch
              : 0;

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
          separatorBuilder: (_, __) =>
          const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();

            final String characterId = doc.id;

            final String characterName =
                data['name']?.toString().trim() ??
                    '未命名角色';

            final String avatarPath =
                data['avatarPath']?.toString().trim() ??
                    '';

            final String creatorName =
                data['creatorName']?.toString().trim() ??
                    '未知創作者';

            final String createdBy =
                data['createdBy']?.toString().trim() ??
                    '';

            // 路徑：
            // artifacts/appId/users/UID/private_characters/characterId
            final String ownerUid =
                doc.reference.parent.parent?.id ??
                    createdBy;

            final int playCount =
                (data['playCount'] as num?)?.toInt() ??
                    0;

            final int likesCount =
                (data['likesCount'] as num?)?.toInt() ??
                    0;

            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                      Colors.grey.shade200,
                      backgroundImage:
                      avatarPath.isNotEmpty
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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  characterName,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey
                                      .withValues(alpha: 0.12),
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '私人',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight.w600,
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
                            overflow:
                            TextOverflow.ellipsis,
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
                            overflow:
                            TextOverflow.ellipsis,
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
                                icon:
                                Icons.play_arrow_rounded,
                                value: playCount,
                              ),
                              _buildAdminCharacterStat(
                                icon:
                                Icons.favorite_rounded,
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
                            contentPadding:
                            EdgeInsets.zero,
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
                            contentPadding:
                            EdgeInsets.zero,
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

    final bool? confirmed =
    await showDialog<bool>(
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
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
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
        'adminUpdatedAt':
        FieldValue.serverTimestamp(),
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
    final TextEditingController reasonController =
    TextEditingController();

    final String? reason =
    await showDialog<String>(
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
            onPressed: () =>
                Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () {
              final value =
              reasonController.text.trim();

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
        'violatedAt':
        FieldValue.serverTimestamp(),
        'adminUpdatedAt':
        FieldValue.serverTimestamp(),
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
        customIcon:
        Icons.gpp_bad_outlined,
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
        characterData['publishedAt'] ??
            FieldValue.serverTimestamp(),
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
    final TextEditingController reasonController =
    TextEditingController();

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
                final value =
                reasonController.text.trim();

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

            // 👤 創作者名稱同步
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                              fontWeight:
                              FontWeight.bold,
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
                        _isSyncingCreatorNames
                            ? null
                            : _syncCreatorNames,
                        icon:
                        _isSyncingCreatorNames
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(
                          Icons.sync_rounded,
                        ),
                        label: Text(
                          _isSyncingCreatorNames
                              ? '同步創作者名稱中...'
                              : '一鍵同步創作者名稱',
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                              fontWeight:
                              FontWeight.bold,
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
                        _isUploadingVoiceBank
                            ? null
                            : _uploadVoiceBank,
                        icon:
                        _isUploadingVoiceBank
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(
                          Icons.cloud_upload_rounded,
                        ),
                        label: Text(
                          _isUploadingVoiceBank
                              ? '同步中...'
                              : '同步 Voice Bank',
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
            if (snapshot.connectionState ==
                ConnectionState.waiting)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child:
                  CircularProgressIndicator(),
                ),
              )
            else if (snapshot.hasError)
              Padding(
                padding:
                const EdgeInsets.all(20),
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
                  final data =
                  doc.data()
                  as Map<String, dynamic>;

                  final String name =
                      data['name']?.toString() ??
                          '未命名聲音';

                  final String voiceId =
                      data['voiceId']?.toString() ??
                          '';

                  final String gender =
                      data['gender']?.toString() ??
                          '';

                  final String age =
                      data['age']?.toString() ??
                          '';

                  final bool enabled =
                      data['enabled'] == true;

                  final tags =
                  data['tags'] is List
                      ? List<String>.from(
                    data['tags'],
                  )
                      : <String>[];

                  return Card(
                    margin:
                    const EdgeInsets.only(
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
      stream: FirebaseFirestore.instance
          .collection('reports')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("🚨 檢舉頁面報錯：${snapshot.error}");
          return Center(child: Text('載入失敗：\n${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)));
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
          final data =
          doc.data() as Map<String, dynamic>;

          final status =
          data['status']?.toString().trim();

          return status == null ||
              status.isEmpty ||
              status == 'pending';
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
            final String imageUrl =
                data['imageUrl']?.toString().trim() ?? '';
            // ✨ 1. 智慧解析檢舉類型與標題
            String typeText = '一般檢舉';
            String targetName = '';
            String displayContent =
                data['content']?.toString() ??
                    '無具體文字';

            if (data['type'] == 'character' ||
                data['relatedType'] == 'character') {
              typeText = '🚩 角色檢舉';

              final characterName =
              data['reportedCharacterName']
                  ?.toString()
                  .trim();

              if (characterName != null &&
                  characterName.isNotEmpty) {
                targetName =
                '角色：$characterName';
              }

              final reason =
                  data['reason']?.toString().trim() ?? '';

              final details =
                  data['details']?.toString().trim() ?? '';

              if (details.isNotEmpty) {
                displayContent =
                '檢舉原因：$reason\n補充說明：$details';
              } else {
                displayContent =
                '檢舉原因：$reason';
              }
            } else if (data['type'] ==
                'block_character') {
              typeText = '🚫 封鎖角色';

              targetName =
              data['blockedCharacterName'] != null
                  ? '角色：${data['blockedCharacterName']}'
                  : '';
            } else if (data['relatedType'] ==
                'moment') {
              typeText = '💬 貼文相關';
            } else if (
            data['reportedMessage'] != null ||
                data['reason'] == '回覆不恰當') {
              typeText = '💬 聊天回覆檢舉';

              if (data['reason'] != null) {
                targetName =
                '原因：${data['reason']}';
              }

              if (data['reportedMessage'] != null) {
                displayContent =
                '被檢舉訊息：「${data['reportedMessage']}」';
              }
            }

// 組合顯示的主標題
            String mainTitle = targetName.isNotEmpty ? '$typeText - $targetName' : typeText;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  mainTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pinkAccent),
                ),
                subtitle: Padding(
                  padding:
                  const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        '回報內容：'
                            '${data['content'] ?? '無具體文字'}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '回報者 UID：'
                            '${data['reporterId'] ??
                            data['userId'] ??
                            data['createdBy'] ??
                            '未知'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),

                      if (imageUrl.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  backgroundColor:
                                  Colors.transparent,
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
                      data['reporterId'] ??data['userId'] ?? data['createdBy'] ?? '',
                      data['content'] ?? data['blockedCharacterName'] ?? '該檢舉項目'
                  ),
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/toast_utils.dart';
import 'package:cloud_functions/cloud_functions.dart';

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

//公告&檢舉
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

  final FirebaseFunctions _functions =
  FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
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
  void _showReplyDialog(String reportId, String reporterId, String originalContent) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('回覆玩家檢舉/建議'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('玩家內容：$originalContent', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 15),
            TextField(
              controller: replyController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: '輸入回覆內容...', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child:  Text(l10n.cancelButton)),
          ElevatedButton(
            onPressed: () async {
              if (replyController.text.trim().isEmpty) return;
              final batch = FirebaseFirestore.instance.batch();

              // 1. 標記案件已處理
              batch.update(FirebaseFirestore.instance.collection('reports').doc(reportId), {
                'status': 'resolved',
                'adminReply': replyController.text.trim(),
                'resolvedAt': FieldValue.serverTimestamp(),
              });
              batch.set(FirebaseFirestore.instance.collection('users').doc(reporterId).collection('mailbox').doc(), {
                'title': 'cs_reply💌',
                'body': replyController.text.trim(),
                'isRead': false,
                'createdAt': FieldValue.serverTimestamp(),
              });

              await batch.commit();
              if (mounted) {
                Navigator.pop(context);
                // ✨ 總裁級：任務完成的優雅回饋，讓玩家感受到系統的高效率！
                ToastUtils.showCenterToast(
                  context,
                  '✅ 已處理並寄送回信！',
                  customIcon: Icons.mark_email_read_rounded, // 💡 用「已讀郵件/已處理」圖示，比單純勾選更精準！
                );
              }
            },
            child: const Text('確認回覆'),
          ),
        ],
      ),
    );
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnnouncementTab(),
          _buildReportTab(),
          _buildVoiceBankTab(),
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
                        _isUploadingVoiceBank
                            ? null
                            : _uploadVoiceBank,
                        icon: _isUploadingVoiceBank
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

            if (snapshot.connectionState ==
                ConnectionState.waiting)
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
                      leading: CircleAvatar(
                        backgroundColor:
                        enabled
                            ? Colors.green
                            .withValues(
                          alpha: 0.15,
                        )
                            : Colors.grey
                            .withValues(
                          alpha: 0.15,
                        ),
                        child: Icon(
                          gender == 'female'
                              ? Icons.female_rounded
                              : gender == 'male'
                              ? Icons.male_rounded
                              : Icons
                              .record_voice_over,
                          color: enabled
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '$gender · $age',
                          ),
                          Text(
                            voiceId,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          if (tags.isNotEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.only(
                                top: 6,
                              ),
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 4,
                                children: tags
                                    .map(
                                      (tag) => Chip(
                                    label: Text(
                                      tag,
                                      style:
                                      const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    visualDensity:
                                    VisualDensity
                                        .compact,
                                  ),
                                )
                                    .toList(),
                              ),
                            ),
                        ],
                      ),
                      trailing: Switch(
                        value: enabled,
                        onChanged: (value) async {
                          try {
                            await doc.reference.update({
                              'enabled': value,
                              'updatedAt':
                              FieldValue
                                  .serverTimestamp(),
                            });
                          } catch (e) {
                            if (!mounted) return;

                            ToastUtils
                                .showCenterToast(
                              context,
                              '更新聲音狀態失敗：$e',
                              isError: true,
                            );
                          }
                        },
                      ),
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
          .collection('reports') // 👈 確保跟剛剛修正後的一樣是根目錄
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("🚨 檢舉頁面報錯：${snapshot.error}");
          return Center(child: Text('載入失敗：\n${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('目前沒有待處理的案件 ✨'));
        }

        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;

            // ✨ 1. 智慧解析檢舉類型與標題
            String typeText = '一般檢舉';
            String targetName = '';
            String displayContent = data['content'] ?? '無具體文字';

            if (data['type'] == 'block_character') {
              typeText = '🚫 封鎖角色';
              targetName = data['blockedCharacterName'] != null
                  ? '角色：${data['blockedCharacterName']}'
                  : '';
            } else if (data['relatedType'] == 'moment') {
              typeText = '💬 貼文相關';
            } else if (data['reportedMessage'] != null || data['reason'] == '回覆不恰當') {
              // 💡 專門抓出聊天室／訊息回覆檢舉！
              typeText = '💬 聊天回覆檢舉';
              if (data['reason'] != null) {
                targetName = '原因：${data['reason']}';
              }
              // 如果有被檢舉的訊息內容，優先顯示出來
              if (data['reportedMessage'] != null) {
                displayContent = '被檢舉訊息：「${data['reportedMessage']}」';
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
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 顯示玩家原本留下的意見或內容
                      Text('回報內容：${data['content'] ?? '無具體文字'}', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('回報者 UID：${data['reporterId'] ?? data['createdBy'] ?? '未知'}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _showReplyDialog(
                      docs[index].id,
                      data['reporterId'] ?? data['createdBy'] ?? '',
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
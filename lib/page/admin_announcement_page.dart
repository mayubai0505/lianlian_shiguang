import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/toast_utils.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            Tab(text: '發布公告'),
            Tab(text: '未處理檢舉'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- 第一頁：發布公告 (總裁原本的內容) ---
          _buildAnnouncementTab(),

          // --- 第二頁：檢舉處理 (新功能) ---
          _buildReportTab(),
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

  Widget _buildReportTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId) // 例如 'lianlian_shiguang' 或 AppConfig.appId
          .collection('reports')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        // 🚨 1. 裝上監視器！如果被擋住，把死因印在畫面上跟 Console 裡
        if (snapshot.hasError) {
          print("🚨 檢舉頁面報錯：${snapshot.error}");
          return Center(
            child: Text(
              '載入失敗，請看 Console：\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // ⏳ 2. 正常讀取中才轉圈圈
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 📦 3. 讀取完畢，但裡面沒資料
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('目前沒有待處理的案件 ✨'));
        }

        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(data['content'] ?? '無內容'),
                subtitle: Text('來自：${data['reporterId']?.substring(0, 5) ?? '未知'}...'),
                trailing: ElevatedButton(
                  onPressed: () => _showReplyDialog(docs[index].id, data['reporterId'] ?? '', data['content'] ?? ''),
                  child: const Text('回覆'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
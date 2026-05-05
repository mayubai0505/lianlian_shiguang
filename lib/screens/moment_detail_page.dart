//貼文單獨和留言

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'moment_card.dart';
import '../models/moment_model.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class MomentDetailPage extends StatefulWidget {
  final String postId; // 接收從外面傳進來的貼文 ID

  const MomentDetailPage({super.key, required this.postId});

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  Map<String, dynamic>? _replyTarget;
  final TextEditingController _commentController = TextEditingController();
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String? _myNickname;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchMyNickname();
  }

  // 1. 抓取個人暱稱 (留言用)
  Future<void> _fetchMyNickname() async {
    if (_userId.isEmpty) return;
    final doc = await _db.collection('users').doc(_userId).get();
    if (mounted) {
      setState(() {
        _myNickname = doc.data()?['nickname'];
      });
    }
  }

  // 2. 刪除動態邏輯 (連動上一頁)
  Future<bool> _deleteMoment(String momentId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.moment_delete_confirm_title),
          content:Text(l10n.moment_delete_confirm_content),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancelButton)),
            TextButton(onPressed: () => Navigator.pop(context, true), child:Text(l10n.action_confirm_delete, style: TextStyle(color: Colors.red))),
          ],
        ),
      ) ?? false;

      if (confirm) {
        await _db.collection('artifacts').doc(AppConfig.appId).collection('moments').doc(momentId).delete();
        return true;
      }
    } catch (e) {
      print("❌ 刪除失敗: $e");
    }
    return false;
  }

  // 1. 詳情頁的按讚邏輯 (跟大廳完全同步)
  Future<void> _handleLikeTaskProgress(Moment moment) async {
    final l10n = AppLocalizations.of(context)!;
    final String currentNickname = _myNickname ?? l10n.friend_unknown;
    if (_userId.isEmpty) return;

    try {
      final String recipientId = moment.createdBy;

      if (recipientId.isNotEmpty && recipientId != _userId) {
        // ✨ 完美的專屬文案判斷
        String mailBody = moment.isCreatorPost
            ? l10n.moment_like_yours(currentNickname)
            : l10n.moment_like_others(currentNickname, moment.authorName);

        // 🌟 呼叫專屬的寄信函式 (不要借用留言的)
        await _sendNotificationLetter(
          recipientId: recipientId,
          postId: moment.id,
          type: 'like',
          senderName: _myNickname ?? '某位朋友',
          body: mailBody,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(l10n.moment_like_success)));
    } catch (e) {
      print("按讚失敗: $e");
    }
  }

  // 2. 把大廳的 _sendNotificationLetter 也複製過來 (專門處理按讚信件)
  Future<void> _sendNotificationLetter({
    required String recipientId,
    required String postId,
    required String type,
    required String senderName,
    required String body,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recipientId)
          .collection('mailbox')
          .add({
        'type': type,
        'fromId': _userId,
        'title': l10n.moment_notification_new_like, // 專屬按讚標題
        'body': body,
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      print("❌ 投遞信件失敗: $e");
    }
  }

  // 3. ⚠️ 留言邏輯 (這段絕對不能刪掉喔！)
  Future<void> _saveCommentToDb(String content, Moment moment) async {
    if (content.trim().isEmpty) return;
    try {
      // 🚀 存進留言子集合
      await _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('moments')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'content': content.trim(),
        'authorId': _userId,
        'authorName': _myNickname ?? '某位朋友',
        'createdAt': FieldValue.serverTimestamp(),
        'parentCommentId': _replyTarget?['commentId'], // 如果是一般留言，這裡會是 null
        'replyToName': _replyTarget?['authorName'],
      });

      // 🌟 觸發寄信通知 (呼叫 Moment 模型裡的方法)
      await moment.sendCommentNotification(
        commentText: content.trim(),
        senderNickname: _myNickname ?? '某位朋友',
      );

      // 🎯 ✨ 新增：解析留言內容，看看有沒有人被 @Tag！
      await _handleMentions(
        text: content.trim(),
        postId: widget.postId,
      );

      _commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _replyTarget = null; // ✨ 留言成功後，清空回覆狀態！
      });
    } catch (e) {
      print("❌ 留言失敗: $e");
    }
  }

  // ✨ 新增：處理內文的 @Tag 邏輯 (貼文、留言皆可共用)
  Future<void> _handleMentions({
    required String text,
    required String postId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final currentNickname = _myNickname ?? l10n.friend_unknown;
    if (_userId.isEmpty) return;
    // 利用 Regex 抓取所有以 @ 開頭的字串,例如輸入 "@程宇"，會把 "程宇" 這個名字單獨抓出來
    Iterable<RegExpMatch> matches = RegExp(r'@(\S+)').allMatches(text);
    List<String> taggedNames = matches.map((m) => m.group(1)!).toList();
    if (taggedNames.isEmpty) return; // 沒標註任何人就直接結束
    // 2. 針對每個被 Tag 的名字去撈資料庫
    for (String name in taggedNames) {
      try {
        // ⚠️ 這裡要確認妳實際存放「角色」的 collection 路徑
        var query = await _db
            .collection('characters') // 假設角色存在這裡
            .where('name', isEqualTo: name)
            .limit(1)
            .get();
        if (query.docs.isNotEmpty) {
          var characterData = query.docs.first.data();
          // ✨ 關鍵修改：用 createdBy 來當作親媽 UID
          String motherUid = characterData['createdBy'] ?? '';
          // 3. 🎯 核心重點：判斷是否為親媽 Tag 自己的小孩
           if (motherUid.isNotEmpty && motherUid != _userId) {
            // 不是親媽！代表是其他玩家或角色 Tag 的，可以發送通知信！
            String mailBody =l10n.moment_mention_mail_body(currentNickname, name);
            await _sendNotificationLetter(
              recipientId: motherUid, // 信件精準投遞給親媽的 UID
              postId: postId,
              type: 'mention',
              senderName: _myNickname ?? '某位朋友',
              body: mailBody,
            );
            print("💌 已發送 Tag 通知給 $name 的親媽 ($motherUid)");
          } else {
            // 親媽自己 Tag 自己名下的角色（例如大叔程宇的親媽 Tag 程宇），就不發信！
            print("🛑 攔截通知：親媽 (${_userId}) Tag 了自己的角色 ($name)，不重複寄信。");
          }
        }
      } catch (e) {
        print("❌ 處理 Tag 標註失敗: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title:Text(l10n.moment_detail_title)),
      body: FutureBuilder<DocumentSnapshot>(
        future: _db.collection('artifacts').doc(AppConfig.appId).collection('moments').doc(widget.postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || !snapshot.data!.exists) return Center(child: Text(l10n.moment_not_found));

          final moment = Moment.fromFirestore(snapshot.data!);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- A. 動態主體卡片 ---
                      MomentCard(
                        moment: moment,
                        currentUserId: _userId,
                        onLikeTapped: () => _handleLikeTaskProgress(moment),
                        onDeleteTapped: () {
                          _deleteMoment(moment.id).then((success) {
                            if (success && mounted) Navigator.pop(context);
                          });
                        },
                      ),

                      const Divider(thickness: 1, height: 1),

                      // --- B. 留言清單標題 ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Text(l10n.moment_comment_title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),

                      // --- C. 即時留言列表 (StreamBuilder) ---
                      StreamBuilder<QuerySnapshot>(
                        stream: _db
                            .collection('artifacts')
                            .doc(AppConfig.appId)
                            .collection('moments')
                            .doc(widget.postId)
                            .collection('comments')
                            .orderBy('createdAt', descending: false) // 由舊到新排列
                            .snapshots(),
                        builder: (context, commentSnapshot) {
                          if (!commentSnapshot.hasData) return const SizedBox();
                          final docs = commentSnapshot.data!.docs;

                          if (docs.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(child: Text(l10n.moment_comment_empty, style: TextStyle(color: Colors.grey))),
                            );
                          }

                          return ListView.builder( // ✨ 改回 builder 以支援縮排排版
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // 讓外層 SingleChildScrollView 處理滾動
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              final commentId = docs[index].id;

                              // 1. ✨ 回覆邏輯判斷
                              bool isReply = data['parentCommentId'] != null;

                              return Padding(
                                // 🌟 如果是回覆，左邊縮排 40 像素
                                padding: EdgeInsets.only(left: isReply ? 40.0 : 0.0),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    radius: 18,
                                    child: Icon(Icons.person_outline, size: 20),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        data['authorName'] ?? '某位朋友',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      // 🌟 如果是回覆，加上一個小箭頭和 @被回覆的人
                                      if (isReply) ...[
                                        const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                                        Text(
                                          "@${data['replyToName']}",
                                          style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                                        ),
                                      ],
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(data['content'] ?? '', style: const TextStyle(fontSize: 15, color: Colors.black87)),
                                  ),
                                  // 🌟 右側放一個「回覆」按鈕
                                  trailing: TextButton(
                                    style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero),
                                    child:Text(l10n.comment_reply_btn, style: TextStyle(fontSize: 12, color: Colors.pinkAccent)),
                                    onPressed: () {
                                      setState(() {
                                        // ✨ 點擊後，把這則留言的 ID 和名字存起來
                                        _replyTarget = {
                                          'commentId': commentId,
                                          'authorName': data['authorName'] ?? '某位朋友',
                                        };
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 50), // 給底部留點空間
                    ],
                  ),
                ),
              ),

              // --- D. 底部留言輸入區 (包含總裁的回覆提示條) ---
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✨ 總裁指令：回覆提示條
                  if (_replyTarget != null)
                    Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.reply, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            l10n.moment_replying_to(_replyTarget!['authorName']),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _replyTarget = null; // 點擊叉叉取消回覆
                              });
                            },
                            child: const Icon(Icons.close, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                  // ⬇️ 原本的輸入框
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: _replyTarget != null
                                    ? l10n.moment_reply_hint(_replyTarget!['authorName'])
                                    : l10n.moment_leave_comment_hint,
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.pinkAccent),
                            onPressed: () => _saveCommentToDb(_commentController.text, moment),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';
// ⚠️ 總裁請注意：這裡的 import 請替換成您實際的檔案路徑
 import '../models/moment_model.dart';
 import '../models/comment_model.dart';
 import '../utils/image_utils.dart'; // 為了 getAvatarImageProvider
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//留言功能
class CommentBottomSheet extends StatefulWidget {
  final Moment moment;

  const CommentBottomSheet({super.key, required this.moment});
  // ✨ 總裁專用呼叫函式：在動態牆點擊留言圖示時呼叫這行！
  static void show(BuildContext context, Moment moment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允許面板佔用大半個螢幕
      backgroundColor: Colors.transparent, // 讓頂部導角透明
      builder: (context) => CommentBottomSheet(moment: moment),
    );
  }

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  Comment? _replyTarget;
  // 🌟 總裁指令：不管是大寫還是小寫，通通都要聽 AppConfig 的話！
  final String APP_ID = AppConfig.appId;
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _commentSubscription;
  String _currentAuthorId = '';
  String _currentAuthorName = ''; // ✨ 改成空字串，稍後由 l10n 動態處理
  String _currentAuthorAvatar = '';
  List<Comment> _comments = [];
  bool _isLoadingComments = true;
  void _cancelReply() {
    setState(() {
      _replyTarget = null;
      _commentController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    // 延遲一下讓 context 準備好，以便抓取翻譯官
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialIdentity();
    });
    _listenToComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentSubscription?.cancel();
    super.dispose();
  }

  // --- 核心邏輯 ---

  void _listenToComments() {
    _commentSubscription = _db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('moments')
        .doc(widget.moment.id)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots().listen((snapshot) {
      if (mounted) {
        setState(() {
          _comments = snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
          _isLoadingComments = false;
        });
      }
    });
  }

  // ✨ 修改後的身分初始化
  Future<void> _loadInitialIdentity() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        setState(() {
          _currentAuthorName = data['nickname'] ?? l10n.chat_mysterious_player;
          _currentAuthorAvatar = data['avatarPath'] ?? 'assets/images/avatar1.png';
          _currentAuthorId = user.uid;
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nickname', _currentAuthorName);
        await prefs.setString('avatarPath', _currentAuthorAvatar);
      }
    } catch (e) {
      print("讀取留言身分失敗: $e");
    }
  }

  // ✨ 新增：這就是妳缺少的那個「抓角色」函式！
  Future<List<Character>> _fetchMyCharacters() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];
    try {
      final responses = await Future.wait([
        _db.collection('artifacts').doc(AppConfig.appId).collection('public_characters').where('createdBy', isEqualTo: userId).get(),
        _db.collection('artifacts').doc(AppConfig.appId).collection('users').doc(userId).collection('private_characters').get(),
      ]);

      final List<Future<Character>> publicFutures = responses[0].docs
          .map((doc) => Character.fromFirestoreAsync(doc)).toList();

      final List<Future<Character>> privateFutures = responses[1].docs
          .map((doc) => Character.fromFirestoreAsync(doc)).toList();

      final List<Character> publicChars = await Future.wait(publicFutures);
      final List<Character> privateChars = await Future.wait(privateFutures);

      final List<Character> myCharacters = [...publicChars, ...privateChars];

      return myCharacters;
    } catch (e) {
      print("讀取角色失敗: $e");
      return [];
    }
  }

  Future<void> _postComment() async {
    final l10n = AppLocalizations.of(context)!;
    final String text = _commentController.text.trim();
    if (text.isEmpty) return;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final String finalContent = text;
    final String? parentId = _replyTarget?.id;
    final String? replyName = _replyTarget?.authorName;

    _commentController.clear();
    setState(() => _replyTarget = null);
    FocusScope.of(context).unfocus();

    final momentRef = _db.collection('artifacts').doc(AppConfig.appId).collection('moments').doc(widget.moment.id);
    final newCommentRef = momentRef.collection('comments').doc();

    final tempComment = Comment(
      id: newCommentRef.id,
      content: finalContent,
      authorId: _currentAuthorId,
      authorName: _currentAuthorName.isNotEmpty ? _currentAuthorName : l10n.comment_loading_author,
      authorAvatar: _currentAuthorAvatar,
      createdAt: Timestamp.now(),
      parentCommentId: parentId,
      replyToName: replyName,
    );

    setState(() => _comments.add(tempComment));

    try {
      final batch = _db.batch();

      batch.set(newCommentRef, {
        'content': finalContent,
        'authorId': _currentAuthorId,
        'authorName': _currentAuthorName.isNotEmpty ? _currentAuthorName : l10n.comment_loading_author,
        'authorAvatar': _currentAuthorAvatar,
        'createdAt': FieldValue.serverTimestamp(),
        'parentCommentId': parentId,
        'replyToName': replyName,
        'isPlayer': true,
      });

      batch.update(momentRef, {'commentCount': FieldValue.increment(1)});

      await batch.commit();

      await widget.moment.sendCommentNotification(
        commentText: replyName != null ? "@$replyName $finalContent" : finalContent,
        senderNickname: _currentAuthorName.isNotEmpty ? _currentAuthorName : l10n.comment_loading_author,
      );

      print("✅ 留言與通知發送成功！");

    } catch (e) {
      setState(() => _comments.removeWhere((c) => c.id == tempComment.id));
      if (mounted) {
        // ✨ 總裁級：評論發布失敗的輕量錯誤提示，俐落取代刺眼的大紅方塊！
        ToastUtils.showCenterToast(
          context,
          l10n.comment_post_failed(e.toString()),
          isError: true, // 💡 總裁細節：系統自動帶入紅驚嘆號，優雅提示錯誤
        );
      }
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    final l10n = AppLocalizations.of(context)!;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirm_delete_title),
        content: Text(l10n.comment_delete_confirm_desc),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete_btn, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    final int originalIndex = _comments.indexWhere((c) => c.id == comment.id);
    if (originalIndex == -1) return;
    final Comment backupComment = _comments[originalIndex];

    setState(() => _comments.removeAt(originalIndex));

    try {
      final momentRef = _db.collection('artifacts').doc(AppConfig.appId).collection('moments').doc(widget.moment.id);
      final commentRef = momentRef.collection('comments').doc(comment.id);
      final batch = _db.batch();
      batch.delete(commentRef);
      batch.update(momentRef, {'commentCount': FieldValue.increment(-1)});
      await batch.commit();
    } catch (e) {
      if (mounted) {
        // ✨ 總裁級：使用重量級錯誤提示，告知玩家刪除失敗且已復原
        ToastUtils.showCenterToast(
          context,
          l10n.comment_delete_failed,
          isError: true, // 💡 必須帶上紅驚嘆號，這是嚴肅的資料操作錯誤
        );
        setState(() => _comments.insert(originalIndex, backupComment));
      }
    }
  }

  Future<void> _showIdentitySwitcher() async {
    final l10n = AppLocalizations.of(context)!;
    final myCharacters = await _fetchMyCharacters();
    final prefs = await SharedPreferences.getInstance();
    final playerNickname = prefs.getString('nickname') ?? l10n.chat_mysterious_player;
    final playerAvatar = prefs.getString('avatarPath') ?? 'assets/images/avatar1.png';

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(title: Text(l10n.comment_identity_title, style: const TextStyle(fontWeight: FontWeight.bold))),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(l10n.comment_identity_myself),
              onTap: () {
                setState(() {
                  _currentAuthorName = playerNickname;
                  _currentAuthorAvatar = playerAvatar;
                  _currentAuthorId = FirebaseAuth.instance.currentUser?.uid ?? '';
                });
                Navigator.pop(context);
              },
            ),
            ...myCharacters.map((char) => ListTile(
              leading: CircleAvatar(backgroundImage: getAvatarImageProvider(char.avatarPath)),
              title: Text(char.name),
              onTap: () {
                setState(() {
                  _currentAuthorName = char.name;
                  _currentAuthorAvatar = char.avatarPath;
                  _currentAuthorId = char.id;
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _reportComment(Comment comment) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Row(
              children: [
                Text(l10n.comment_report_title),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                      Icons.help_outline, size: 20, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text(l10n.comment_report_rules_title,
                                style: const TextStyle(fontWeight: FontWeight
                                    .bold, fontSize: 18)),
                            content: Text(
                              l10n.comment_report_rules_desc,
                              style: const TextStyle(height: 1.5, fontSize: 14),
                            ),
                            actions: [
                              TextButton(onPressed: () =>
                                  Navigator.pop(context), child: Text(
                                  l10n.comment_report_understood,
                                  style: const TextStyle(
                                      color: Colors.pinkAccent))),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
            content: Text(l10n.comment_report_confirm_desc),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancelButton)),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(l10n.comment_report_submit_btn,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await _db.collection('reports').add({
        'targetId': comment.id,
        'targetType': 'comment',
        'momentId': widget.moment.id,
        'content': comment.content,
        'authorId': comment.authorId,
        'reportedBy': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      // 🌟 檢舉評論後的優雅回饋
      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.comment_report_success,
          customIcon: Icons.verified_user_rounded, // 💡 總裁細節：代表檢舉已受理、系統已納入安全防護
        );
      }
    } catch (e) {
      if (mounted) {
        // ⚠️ 檢舉失敗：使用重量級錯誤提示，告知玩家系統卡住了
        ToastUtils.showCenterToast(
          context,
          l10n.comment_report_failed,
          isError: true, // 💡 紅驚嘆號告知玩家需稍後再試
        );
      }
    }
  }
  void _showCommentOptions(Comment comment) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final bool isMyComment = comment.authorId == currentUser.uid;
    final bool isMomentOwner = widget.moment.createdBy == currentUser.uid;
    final bool canDelete = isMyComment || isMomentOwner;
    final bool canReport = !isMyComment;

    if (!canDelete && !canReport) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (canDelete)
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: Text(l10n.comment_option_delete, style: const TextStyle(color: Colors.red)),
                onTap: () { Navigator.pop(context); _deleteComment(comment); },
              ),
            if (canReport)
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: Text(l10n.comment_option_report, style: const TextStyle(color: Colors.orange)),
                onTap: () { Navigator.pop(context); _reportComment(comment); },
              ),
          ],
        ),
      ),
    );
  }

  // ✨ 將翻譯官傳入時間格式化函式
  String _formatTimestamp(Timestamp timestamp, AppLocalizations l10n) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return l10n.comment_time_days_ago(difference.inDays.toString());
    if (difference.inHours > 0) return l10n.comment_time_hours_ago(difference.inHours.toString());
    if (difference.inMinutes > 0) return l10n.comment_time_mins_ago(difference.inMinutes.toString());
    return l10n.comment_time_just_now;
  }

  // --- UI 渲染區 (底部彈窗面板) ---
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // 動態判斷名字，如果是空的代表還在讀取
    final safeAuthorName = _currentAuthorName.isNotEmpty ? _currentAuthorName : l10n.comment_loading_author;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            height: 4,
            width: 40,
            decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                Text(l10n.comment_sheet_title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: _isLoadingComments
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                ? Center(child: Text(l10n.comment_empty_state))
                : ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                final currentUser = FirebaseAuth.instance.currentUser;

                bool isMe = comment.authorId == currentUser?.uid;
                String displayName = isMe ? safeAuthorName : comment.authorName;
                String displayAvatar = isMe ? _currentAuthorAvatar : comment.authorAvatar;

                bool isReply = comment.parentCommentId != null;

                return Padding(
                  padding: EdgeInsets.only(left: isReply ? 40.0 : 0.0),
                  child: GestureDetector(
                    onLongPress: () => _showCommentOptions(comment),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: getAvatarImageProvider(displayAvatar),
                      ),
                      title: Row(
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          if (isReply) ...[
                            const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                            Text(
                              "@${comment.replyToName}",
                              style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(comment.content),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(comment.createdAt, l10n), // ✨ 傳入 l10n
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: TextButton(
                        style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero),
                        child: Text(l10n.comment_reply_btn, style: const TextStyle(fontSize: 12, color: Colors.pinkAccent)),
                        onPressed: () {
                          setState(() {
                            _replyTarget = comment;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          if (_replyTarget != null)
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    l10n.comment_replying_to(_replyTarget!.authorName), // ✨ 回覆提示
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  // 找到這個如果你有選擇回覆對象時出現的 X 按鈕
                  GestureDetector(
                    onTap: _cancelReply, // 👈 確保只有這幾個字，沒有別的括號或 setState
                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showIdentitySwitcher,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: getAvatarImageProvider(_currentAuthorAvatar),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: l10n.comment_input_hint(safeAuthorName), // ✨ 輸入框提示
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                    onPressed: _postComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider getAvatarImageProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path.isNotEmpty ? path : 'assets/images/avatar1.png');
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  final Set<String> _expandedReplyThreads = <String>{};
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
  bool _isPostingComment = false;
  final ImagePicker _commentImagePicker = ImagePicker();
  XFile? _selectedCommentImage;
  Uint8List? _selectedCommentImageBytes;
  void _cancelReply() {
    setState(() {
      _replyTarget = null;
      _commentController.clear();
      _selectedCommentImage = null;
      _selectedCommentImageBytes = null;
    });
  }

  String _resolveRootCommentId(
      Comment comment,
      Map<String, Comment> commentsById,
      ) {
    Comment current = comment;
    final Set<String> visitedIds = <String>{comment.id};

    while (current.parentCommentId != null &&
        current.parentCommentId!.trim().isNotEmpty) {
      final String parentId = current.parentCommentId!.trim();
      final Comment? parent = commentsById[parentId];

      // 舊資料的父留言若已被刪除，就讓目前留言自行成為主留言，
      // 避免整串留言從畫面消失。
      if (parent == null || !visitedIds.add(parent.id)) {
        return comment.id;
      }

      current = parent;
    }

    return current.id;
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

  Future<void> _pickCommentImage() async {
    if (_isPostingComment) return;
    try {
      final picked = await _commentImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 72,
        maxWidth: 1280,
        maxHeight: 1280,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedCommentImage = picked;
        _selectedCommentImageBytes = bytes;
      });
    } catch (error) {
      if (!mounted) return;
      ToastUtils.showCenterToast(context, '讀取照片失敗：$error', isError: true);
    }
  }

  void _clearSelectedCommentImage() {
    if (!mounted) return;
    setState(() {
      _selectedCommentImage = null;
      _selectedCommentImageBytes = null;
    });
  }

  String _commentImageContentType(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
    return 'image/jpeg';
  }

  Future<Map<String, String>> _uploadCommentImage({
    required String commentId,
    required Uint8List bytes,
    required String originalName,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw StateError('尚未登入');

    final safeName = originalName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final ext = safeName.contains('.') ? safeName.split('.').last : 'jpg';
    final storagePath =
        'moment_comment_images/${widget.moment.id}/$commentId/${DateTime.now().millisecondsSinceEpoch}.$ext';
    final ref = FirebaseStorage.instance.ref(storagePath);

    await ref.putData(
      bytes,
      SettableMetadata(
        contentType: _commentImageContentType(originalName),
        customMetadata: {
          'ownerUserId': currentUser.uid,
          'momentId': widget.moment.id,
          'commentId': commentId,
        },
      ),
    );

    return {
      'imageUrl': await ref.getDownloadURL(),
      'imageStoragePath': storagePath,
    };
  }

  Future<void> _showCommentImage(String imageUrl) async {
    if (imageUrl.trim().isEmpty) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: IconButton.filled(
                onPressed: () => Navigator.of(dialogContext).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postComment() async {
    final l10n = AppLocalizations.of(context)!;

    // 防止連點：一按送出就立刻鎖住，包含照片上傳期間。
    if (_isPostingComment) return;

    final String text = _commentController.text.trim();
    if (text.isEmpty && _selectedCommentImageBytes == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isPostingComment = true;
    });

    final String finalContent = text;
    final Map<String, Comment> commentsById = <String, Comment>{
      for (final Comment comment in _comments) comment.id: comment,
    };
    final String? parentId = _replyTarget == null
        ? null
        : _resolveRootCommentId(_replyTarget!, commentsById);
    final String? replyName = _replyTarget?.authorName;

    final momentRef = _db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('moments')
        .doc(widget.moment.id);

    final newCommentRef = momentRef.collection('comments').doc();
    final String commentId = newCommentRef.id;

    final String safeAuthorId =
    _currentAuthorId.isNotEmpty ? _currentAuthorId : currentUser.uid;

    final String safeAuthorName = _currentAuthorName.isNotEmpty
        ? _currentAuthorName
        : l10n.comment_loading_author;

    String imageUrl = '';
    String imageStoragePath = '';
    Comment? tempComment;

    try {
      final selectedBytes = _selectedCommentImageBytes;
      final selectedImage = _selectedCommentImage;

      if (selectedBytes != null && selectedImage != null) {
        final uploaded = await _uploadCommentImage(
          commentId: commentId,
          bytes: selectedBytes,
          originalName: selectedImage.name,
        );
        imageUrl = uploaded['imageUrl'] ?? '';
        imageStoragePath = uploaded['imageStoragePath'] ?? '';
      }

      tempComment = Comment(
        id: commentId,
        content: finalContent,
        authorId: safeAuthorId,
        authorName: safeAuthorName,
        authorAvatar: _currentAuthorAvatar,
        imageUrl: imageUrl,
        imageStoragePath: imageStoragePath,
        createdAt: Timestamp.now(),
        parentCommentId: parentId,
        replyToName: replyName,
      );

      if (!mounted) return;

      setState(() {
        _replyTarget = null;
        _comments.add(tempComment!);
        if (parentId != null) {
          _expandedReplyThreads.add(parentId);
        }
      });

      _commentController.clear();
      FocusScope.of(context).unfocus();

      final batch = _db.batch();

      batch.set(newCommentRef, {
        'content': finalContent,
        'authorId': safeAuthorId,
        'authorName': safeAuthorName,
        'authorAvatar': _currentAuthorAvatar,
        'imageUrl': imageUrl,
        'imageStoragePath': imageStoragePath,
        'createdAt': FieldValue.serverTimestamp(),
        'parentCommentId': parentId,
        'replyToName': replyName,
        'isPlayer': true,
        'createdBy': currentUser.uid,
      });

      batch.update(momentRef, {
        'commentCount': FieldValue.increment(1),
      });

      await batch.commit();

      if (mounted) {
        setState(() {
          _selectedCommentImage = null;
          _selectedCommentImageBytes = null;
        });
      }

      // 通知失敗不影響留言已成功送出。
      final notificationContent =
      finalContent.isNotEmpty ? finalContent : '📷';
      try {
        await widget.moment.sendCommentNotification(
          commentText: replyName != null
              ? "@$replyName $notificationContent"
              : notificationContent,
          senderNickname: safeAuthorName,
          commentId: commentId,
        );
      } catch (notificationError) {
        debugPrint('⚠️ 留言已送出，但通知發送失敗：$notificationError');
      }

      debugPrint("✅ 留言發送成功");
    } catch (e) {
      if (tempComment != null && mounted) {
        setState(() {
          _comments.removeWhere((c) => c.id == tempComment!.id);
        });
      }

      if (mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.comment_post_failed(e.toString()),
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPostingComment = false;
        });
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

      if (comment.imageStoragePath.trim().isNotEmpty) {
        try {
          await FirebaseStorage.instance.ref(comment.imageStoragePath).delete();
        } catch (error) {
          debugPrint('⚠️ 留言已刪除，但照片 Storage 清理失敗：$error');
        }
      }
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

  Widget _buildCommentTile({
    required Comment comment,
    required bool isReply,
    required String safeAuthorName,
    required AppLocalizations l10n,
  }) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isMe = comment.authorId == currentUser?.uid;
    final String displayName = isMe ? safeAuthorName : comment.authorName;
    final String displayAvatar =
    isMe ? _currentAuthorAvatar : comment.authorAvatar;

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
              Flexible(
                child: Text(
                  displayName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (isReply) ...[
                const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                Flexible(
                  child: Text(
                    '@${comment.replyToName ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              if (comment.content.trim().isNotEmpty)
                Text(comment.content),
              if (comment.imageUrl.trim().isNotEmpty) ...[
                if (comment.content.trim().isNotEmpty) const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showCommentImage(comment.imageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      comment.imageUrl,
                      width: isReply ? 150 : 190,
                      height: isReply ? 150 : 190,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: isReply ? 150 : 190,
                        height: 90,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(comment.createdAt, l10n),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          trailing: TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              setState(() {
                _replyTarget = comment;
              });
            },
            child: Text(
              l10n.comment_reply_btn,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.pinkAccent,
              ),
            ),
          ),
        ),
      ),
    );
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
                : Builder(
              builder: (context) {
                final Map<String, Comment> commentsById =
                <String, Comment>{
                  for (final Comment comment in _comments)
                    comment.id: comment,
                };
                final List<Comment> rootComments = <Comment>[];
                final Map<String, List<Comment>> repliesByRoot =
                <String, List<Comment>>{};

                for (final Comment comment in _comments) {
                  final String rootId =
                  _resolveRootCommentId(comment, commentsById);

                  if (rootId == comment.id) {
                    rootComments.add(comment);
                  } else {
                    repliesByRoot
                        .putIfAbsent(rootId, () => <Comment>[])
                        .add(comment);
                  }
                }

                return ListView.builder(
                  itemCount: rootComments.length,
                  itemBuilder: (context, index) {
                    final Comment rootComment = rootComments[index];
                    final List<Comment> replies =
                        repliesByRoot[rootComment.id] ?? <Comment>[];
                    final bool isExpanded = _expandedReplyThreads.contains(
                      rootComment.id,
                    );
                    final List<Comment> visibleReplies = isExpanded
                        ? replies
                        : replies.isEmpty
                        ? <Comment>[]
                        : <Comment>[replies.last];
                    final int hiddenReplyCount =
                        replies.length - visibleReplies.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCommentTile(
                          comment: rootComment,
                          isReply: false,
                          safeAuthorName: safeAuthorName,
                          l10n: l10n,
                        ),
                        for (final Comment reply in visibleReplies)
                          _buildCommentTile(
                            comment: reply,
                            isReply: true,
                            safeAuthorName: safeAuthorName,
                            l10n: l10n,
                          ),
                        if (replies.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 72,
                              right: 16,
                              bottom: 8,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isExpanded) {
                                      _expandedReplyThreads.remove(
                                        rootComment.id,
                                      );
                                    } else {
                                      _expandedReplyThreads.add(
                                        rootComment.id,
                                      );
                                    }
                                  });
                                },
                                icon: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 18,
                                ),
                                label: Text(
                                  isExpanded
                                      ? l10n.momentCollapseReplies
                                      : l10n.momentViewOtherReplies(hiddenReplyCount),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
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

          if (_selectedCommentImageBytes != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(58, 10, 12, 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _selectedCommentImageBytes!,
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: -10,
                      top: -10,
                      child: Material(
                        color: Theme.of(context).colorScheme.surface,
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _clearSelectedCommentImage,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close_rounded, size: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  const SizedBox(width: 6),
                  IconButton(
                    tooltip: '加入照片',
                    onPressed: _isPostingComment ? null : _pickCommentImage,
                    icon: ImageIcon(
                      const AssetImage(
                        'assets/icons/icon_moment_photo_add.png',
                      ),
                      size: 26,
                      color: _selectedCommentImageBytes != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 2),

                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      enabled: !_isPostingComment,
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
                    tooltip: _isPostingComment ? '傳送中…' : '送出留言',
                    onPressed: _isPostingComment ? null : _postComment,
                    icon: _isPostingComment
                        ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : ImageIcon(
                      const AssetImage(
                        'assets/images/chat/chat_send_plane_mask.png',
                      ),
                      size: 26,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
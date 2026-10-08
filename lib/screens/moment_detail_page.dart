//貼文單獨和留言

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../services/toast_utils.dart';
import 'moment_card.dart';
import '../models/moment_model.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/moment_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character_model.dart';
import '../utils/image_utils.dart';

class MomentDetailPage extends StatefulWidget {
  final String postId; // 接收從外面傳進來的貼文 ID

  const MomentDetailPage({super.key, required this.postId});

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  Map<String, dynamic>? _replyTarget;
  final Set<String> _expandedReplyThreads = <String>{};
  final TextEditingController _commentController = TextEditingController();
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String? _myNickname;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Moment? _moment;
  bool _isLoading = true;
  String _currentAuthorId = '';
  String _currentAuthorName = '';
  String _currentAuthorAvatar = '';
  bool _isPostingComment = false;
  final ImagePicker _commentImagePicker = ImagePicker();
  XFile? _selectedCommentImage;
  Uint8List? _selectedCommentImageBytes;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialIdentity();
    });

    _fetchMomentData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchMomentData() async {
    final doc = await _db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('moments')
        .doc(widget.postId)
        .get();
    if (doc.exists && mounted) {
      setState(() {
        _moment = Moment.fromFirestore(doc);
        _isLoading = false;
      });
    }
  }

  // 1. 抓取個人暱稱 (留言用)
  Future<void> _loadInitialIdentity() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final userDoc = await _db.collection('users').doc(user.uid).get();

      final data = userDoc.data() ?? <String, dynamic>{};

      final String nickname = data['nickname']?.toString().trim() ?? '';

      final String avatarPath = data['avatarPath']?.toString().trim() ?? '';

      if (!mounted) return;

      setState(() {
        _currentAuthorId = user.uid;
        _currentAuthorName =
        nickname.isNotEmpty ? nickname : l10n.chat_mysterious_player;
        _currentAuthorAvatar =
        avatarPath.isNotEmpty ? avatarPath : 'assets/images/avatar1.png';
      });

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'nickname',
        _currentAuthorName,
      );

      await prefs.setString(
        'avatarPath',
        _currentAuthorAvatar,
      );
    } catch (error, stackTrace) {
      debugPrint('讀取詳細頁留言身分失敗：$error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<List<Character>> _fetchMyCharacters() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return <Character>[];
    }

    try {
      final responses = await Future.wait([
        _db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('public_characters')
            .where('createdBy', isEqualTo: userId)
            .get(),
        _db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('users')
            .doc(userId)
            .collection('private_characters')
            .get(),
      ]);

      final publicCharacters = await Future.wait(
        responses[0].docs.map(
              (doc) => Character.fromFirestoreAsync(doc),
        ),
      );

      final privateCharacters = await Future.wait(
        responses[1].docs.map(
              (doc) => Character.fromFirestoreAsync(doc),
        ),
      );

      final characters = <Character>[
        ...publicCharacters,
        ...privateCharacters,
      ];

      characters.sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      return characters;
    } catch (error, stackTrace) {
      debugPrint('讀取詳細頁留言角色失敗：$error');
      debugPrintStack(stackTrace: stackTrace);
      return <Character>[];
    }
  }

  Future<void> _showIdentitySwitcher() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final characters = await _fetchMyCharacters();

    final prefs = await SharedPreferences.getInstance();

    final playerNickname =
        prefs.getString('nickname') ?? l10n.chat_mysterious_player;

    final playerAvatar =
        prefs.getString('avatarPath') ?? 'assets/images/avatar1.png';

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 12),
            children: [
              ListTile(
                title: Text(
                  l10n.comment_identity_title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: getAvatarImageProvider(
                    playerAvatar,
                  ),
                ),
                title: Text(
                  l10n.comment_identity_myself,
                ),
                subtitle: Text(playerNickname),
                onTap: () {
                  setState(() {
                    _currentAuthorId = user.uid;
                    _currentAuthorName = playerNickname;
                    _currentAuthorAvatar = playerAvatar;
                  });

                  Navigator.pop(sheetContext);
                },
              ),
              ...characters.map((character) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: getAvatarImageProvider(
                      character.avatarPath,
                    ),
                  ),
                  title: Text(character.name),
                  subtitle: Text(l10n.identity_character),
                  onTap: () {
                    setState(() {
                      _currentAuthorId = character.id;
                      _currentAuthorName = character.name;
                      _currentAuthorAvatar = character.avatarPath;
                    });

                    Navigator.pop(sheetContext);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // 2. 刪除動態邏輯 (連動上一頁)
  Future<bool> _deleteMoment(String momentId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.moment_delete_confirm_title),
          content: Text(l10n.moment_delete_confirm_content),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancelButton)),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.action_confirm_delete,
                    style: TextStyle(color: Colors.red))),
          ],
        ),
      ) ??
          false;

      if (confirm) {
        await _db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('moments')
            .doc(momentId)
            .delete();
        return true;
      }
    } catch (e) {
      print("❌ 刪除失敗: $e");
    }
    return false;
  }

  Future<String> _getMyPlayerIdDisplayName() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      if (_userId.isEmpty) return l10n.friend_unknown;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      final data = userDoc.data();

      final rawPlayerID = (data?['playerID'] ?? '').toString().trim();

      if (rawPlayerID.isNotEmpty) {
        final cleanPlayerID = rawPlayerID.startsWith('@')
            ? rawPlayerID.substring(1)
            : rawPlayerID;

        return '@$cleanPlayerID';
      }
    } catch (e) {
      debugPrint('取得 playerID 失敗: $e');
    }

    return l10n.friend_unknown;
  }

  // 1. 詳情頁的按讚邏輯 (跟大廳完全同步)
  Future<void> _handleLikeTaskProgress(Moment moment) async {
    final l10n = AppLocalizations.of(context)!;

    if (_userId.isEmpty) return;

    try {
      await MomentNotificationService().createMomentNotification(
        momentId: moment.id,
        type: 'like',
      );

      ToastUtils.showCenterToast(
        context,
        l10n.moment_like_success,
        customIcon: Icons.eco_rounded,
      );
    } catch (e) {
      debugPrint("按讚失敗: $e");
    }
  }

  // 2. 把大廳的 _sendNotificationLetter 也複製過來 (專門處理按讚信件)
  Future<void> _sendNotificationLetter({
    required String recipientId,
    required String postId,
    required String type,
    required String senderName,
    required String body,
    String? commentId,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    // 自己不要寄通知給自己
    if (recipientId == _userId) return;

    try {
      String notificationId;

      if (type == 'like') {
        // 同一個人對同一篇貼文按讚，只會有一封
        notificationId = 'moment_like_${postId}_${_userId}';
      } else if (type == 'comment' && commentId != null) {
        // 同一則留言，只會有一封
        notificationId = 'moment_comment_${postId}_$commentId';
      } else {
        // 其他通知保底
        notificationId =
        '${type}_${postId}_${_userId}_${DateTime.now().millisecondsSinceEpoch}';
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(recipientId)
          .collection('mailbox')
          .doc(notificationId)
          .set({
        'type': type,
        'fromId': _userId,
        'fromName': senderName,
        'title': type == 'like' ? l10n.moment_notification_new_like : l10n.newComment,
        'body': body,
        'postId': postId,
        if (commentId != null) 'commentId': commentId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("❌ 投遞信件失敗: $e");
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
      ToastUtils.showCenterToast(
        context,
        '讀取照片失敗：$error',
        isError: true,
      );
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
    if (currentUser == null) {
      throw StateError('尚未登入');
    }

    final safeName = originalName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final ext = safeName.contains('.') ? safeName.split('.').last : 'jpg';
    final storagePath =
        'moment_comment_images/${widget.postId}/$commentId/${DateTime.now().millisecondsSinceEpoch}.$ext';

    final ref = FirebaseStorage.instance.ref(storagePath);
    await ref.putData(
      bytes,
      SettableMetadata(
        contentType: _commentImageContentType(originalName),
        customMetadata: {
          'ownerUserId': currentUser.uid,
          'momentId': widget.postId,
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

  // 3. ⚠️ 留言邏輯 (這段絕對不能刪掉喔！)
  Future<void> _saveCommentToDb(
      String content,
      Moment moment,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser =
        FirebaseAuth.instance.currentUser;

    final hasImage = _selectedCommentImageBytes != null;
    if (_isPostingComment ||
        currentUser == null ||
        (content.trim().isEmpty && !hasImage)) {
      return;
    }

    final String finalContent = content.trim();

    final String? parentCommentId =
    (_replyTarget?['rootCommentId'] ??
        _replyTarget?['commentId'])
        ?.toString()
        .trim();

    final String? replyToName =
    _replyTarget?['authorName']
        ?.toString()
        .trim();

    final String safeAuthorId =
    _currentAuthorId.isNotEmpty
        ? _currentAuthorId
        : currentUser.uid;

    final String safeAuthorName =
    _currentAuthorName.isNotEmpty
        ? _currentAuthorName
        : l10n.comment_loading_author;

    final String safeAuthorAvatar =
    _currentAuthorAvatar.isNotEmpty
        ? _currentAuthorAvatar
        : 'assets/images/avatar1.png';

    setState(() {
      _isPostingComment = true;
    });

    try {
      final momentRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('moments')
          .doc(widget.postId);

      final commentRef =
      momentRef.collection('comments').doc();

      String imageUrl = '';
      String imageStoragePath = '';
      final selectedBytes = _selectedCommentImageBytes;
      final selectedImage = _selectedCommentImage;

      if (selectedBytes != null && selectedImage != null) {
        final uploaded = await _uploadCommentImage(
          commentId: commentRef.id,
          bytes: selectedBytes,
          originalName: selectedImage.name,
        );
        imageUrl = uploaded['imageUrl'] ?? '';
        imageStoragePath = uploaded['imageStoragePath'] ?? '';
      }

      final batch = _db.batch();

      batch.set(
        commentRef,
        {
          'content': finalContent,
          'authorId': safeAuthorId,
          'authorName': safeAuthorName,
          'authorAvatar': safeAuthorAvatar,
          'imageUrl': imageUrl,
          'imageStoragePath': imageStoragePath,
          'createdAt': FieldValue.serverTimestamp(),
          'parentCommentId':
          parentCommentId?.isNotEmpty == true
              ? parentCommentId
              : null,
          'replyToName':
          replyToName?.isNotEmpty == true
              ? replyToName
              : null,

          // 與朋友圈 CommentBottomSheet 的留言格式一致。
          'isPlayer': true,

          // 保留真正操作留言的帳號，
          // 避免使用角色身分時無法判斷留言擁有者。
          'ownerUserId': currentUser.uid,
        },
      );

      batch.update(
        momentRef,
        {
          'commentCount': FieldValue.increment(1),
        },
      );

      await batch.commit();

      final notificationContent =
      finalContent.isNotEmpty ? finalContent : '📷';

      await moment.sendCommentNotification(
        commentText: replyToName?.isNotEmpty == true
            ? '@$replyToName $notificationContent'
            : notificationContent,
        senderNickname: safeAuthorName,
        commentId: commentRef.id,
      );

      if (finalContent.isNotEmpty) {
        await _handleMentions(
          text: finalContent,
          postId: widget.postId,
          senderName: safeAuthorName,
        );
      }

      _commentController.clear();
      FocusScope.of(context).unfocus();

      if (!mounted) return;

      setState(() {
        if (parentCommentId != null &&
            parentCommentId.isNotEmpty) {
          _expandedReplyThreads.remove(
            parentCommentId,
          );
        }

        _replyTarget = null;
        _selectedCommentImage = null;
        _selectedCommentImageBytes = null;
      });
    } catch (error, stackTrace) {
      debugPrint('❌ 詳細頁留言失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.comment_post_failed(
          error.toString(),
        ),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPostingComment = false;
        });
      }
    }
  }


  bool _isMyDetailComment(Map<String, dynamic> data) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final String uid = currentUser.uid;
    final String authorId = data['authorId']?.toString().trim() ?? '';
    final String ownerUserId = data['ownerUserId']?.toString().trim() ?? '';
    final String createdBy = data['createdBy']?.toString().trim() ?? '';

    return authorId == uid ||
        ownerUserId == uid ||
        createdBy == uid;
  }

  Future<void> _deleteDetailComment(
      QueryDocumentSnapshot commentDoc,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || _moment == null) return;

    final data = commentDoc.data() as Map<String, dynamic>;
    final bool isMyComment = _isMyDetailComment(data);
    final bool isMomentOwner =
        _moment!.createdBy == currentUser.uid;

    if (!isMyComment && !isMomentOwner) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirm_delete_title),
        content: Text(l10n.comment_delete_confirm_desc),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.delete_btn,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final momentRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('moments')
          .doc(widget.postId);

      final batch = _db.batch();

      batch.delete(
        momentRef.collection('comments').doc(commentDoc.id),
      );

      batch.update(
        momentRef,
        {
          'commentCount': FieldValue.increment(-1),
        },
      );

      await batch.commit();

      final imageStoragePath =
          data['imageStoragePath']?.toString().trim() ?? '';
      if (imageStoragePath.isNotEmpty) {
        try {
          await FirebaseStorage.instance.ref(imageStoragePath).delete();
        } catch (error) {
          debugPrint('⚠️ 留言已刪除，但照片 Storage 清理失敗：$error');
        }
      }

      if (!mounted) return;

      if (_replyTarget?['commentId'] == commentDoc.id) {
        setState(() {
          _replyTarget = null;
        });
      }
    } catch (error, stackTrace) {
      debugPrint('❌ 詳細頁刪除留言失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.comment_delete_failed,
        isError: true,
      );
    }
  }

  Future<void> _reportDetailComment(
      QueryDocumentSnapshot commentDoc,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final data = commentDoc.data() as Map<String, dynamic>;

    if (_isMyDetailComment(data)) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.comment_report_title),
        content: Text(l10n.comment_report_confirm_desc),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text(
              l10n.comment_report_submit_btn,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _db.collection('reports').add({
        'targetId': commentDoc.id,
        'targetType': 'comment',
        'momentId': widget.postId,
        'content': data['content']?.toString() ?? '',
        'authorId': data['authorId']?.toString() ?? '',
        'reportedBy': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.comment_report_success,
        customIcon: Icons.verified_user_rounded,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ 詳細頁檢舉留言失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.comment_report_failed,
        isError: true,
      );
    }
  }

  void _showDetailCommentOptions(
      QueryDocumentSnapshot commentDoc,
      ) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || _moment == null) return;

    final data = commentDoc.data() as Map<String, dynamic>;
    final bool isMyComment = _isMyDetailComment(data);
    final bool isMomentOwner =
        _moment!.createdBy == currentUser.uid;
    final bool canDelete = isMyComment || isMomentOwner;
    final bool canReport = !isMyComment;

    if (!canDelete && !canReport) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            if (canDelete)
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  l10n.comment_option_delete,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _deleteDetailComment(commentDoc);
                },
              ),
            if (canReport)
              ListTile(
                leading: const Icon(
                  Icons.flag,
                  color: Colors.orange,
                ),
                title: Text(
                  l10n.comment_option_report,
                  style: const TextStyle(
                    color: Colors.orange,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _reportDetailComment(commentDoc);
                },
              ),
          ],
        ),
      ),
    );
  }

  // ✨ 新增：處理內文的 @Tag 邏輯 (貼文、留言皆可共用)
  Future<void> _handleMentions({
    required String text,
    required String postId,
    required String senderName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
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
            String mailBody =
            l10n.moment_mention_mail_body(senderName, name);
            await _sendNotificationLetter(
              recipientId: motherUid, // 信件精準投遞給親媽的 UID
              postId: postId,
              type: 'mention',
              senderName: senderName,
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

    final String safeAuthorName =
    _currentAuthorName.isNotEmpty
        ? _currentAuthorName
        : l10n.comment_loading_author;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moment_detail_title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- A. 動態主體卡片 ---
                  MomentCard(
                    moment: _moment!,
                    currentUserId: _userId,
                    onLikeTapped: () => _handleLikeTaskProgress(_moment!),
                    onDeleteTapped: () {
                      _deleteMoment(_moment!.id).then((success) {
                        if (success && mounted) Navigator.pop(context);
                      });
                    },
                  ),

                  const Divider(thickness: 1, height: 1),

                  // --- B. 留言清單標題 ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(l10n.moment_comment_title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),

                  // --- C. 即時留言列表（主留言＋回覆分組）---
                  StreamBuilder<QuerySnapshot>(
                    stream: _db
                        .collection('artifacts')
                        .doc(AppConfig.appId)
                        .collection('moments')
                        .doc(widget.postId)
                        .collection('comments')
                        .orderBy(
                      'createdAt',
                      descending: false,
                    )
                        .snapshots(),
                    builder: (context, commentSnapshot) {
                      if (commentSnapshot.hasError) {
                        return  Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              l10n.momentCommentLoadFailed,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      if (!commentSnapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final docs = commentSnapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40,
                          ),
                          child: Center(
                            child: Text(
                              l10n.moment_comment_empty,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      // 建立留言ID對應表，用來處理舊資料中
                      // 「回覆指向另一則回覆」的情況。
                      final docsById = {
                        for (final doc in docs) doc.id: doc,
                      };

                      String resolveRootCommentId(
                          String initialParentId,
                          ) {
                        String currentId = initialParentId;
                        final visitedIds = <String>{};

                        while (currentId.isNotEmpty &&
                            !visitedIds.contains(currentId)) {
                          visitedIds.add(currentId);

                          final parentDoc = docsById[currentId];

                          // 找不到父留言時，保留目前找到的ID。
                          if (parentDoc == null) {
                            return currentId;
                          }

                          final parentData =
                          parentDoc.data() as Map<String, dynamic>;

                          final String? nextParentId =
                          parentData['parentCommentId']
                              ?.toString()
                              .trim();

                          // 目前這則已經是主留言。
                          if (nextParentId == null ||
                              nextParentId.isEmpty) {
                            return currentId;
                          }

                          currentId = nextParentId;
                        }

                        return currentId;
                      }

                      final rootComments = <QueryDocumentSnapshot>[];

                      final repliesByRoot =
                      <String, List<QueryDocumentSnapshot>>{};

                      // 將留言分成主留言與回覆。
                      for (final doc in docs) {
                        final data = doc.data() as Map<String, dynamic>;

                        final String? parentCommentId =
                        data['parentCommentId']?.toString().trim();

                        if (parentCommentId == null ||
                            parentCommentId.isEmpty) {
                          rootComments.add(doc);
                          continue;
                        }

                        final String rootCommentId = resolveRootCommentId(
                          parentCommentId,
                        );

                        // 如果原本的父留言已被刪除，
                        // 不讓這則留言整個消失，暫時當成主留言顯示。
                        if (!docsById.containsKey(rootCommentId)) {
                          rootComments.add(doc);
                          continue;
                        }

                        repliesByRoot
                            .putIfAbsent(
                          rootCommentId,
                              () => <QueryDocumentSnapshot>[],
                        )
                            .add(doc);
                      }

                      Widget buildCommentTile(
                          QueryDocumentSnapshot commentDoc, {
                            required bool isReply,
                          }) {
                        final data =
                        commentDoc.data() as Map<String, dynamic>;

                        final String commentId = commentDoc.id;

                        final String authorName =
                            data['authorName']?.toString() ?? l10n.someFriend;

                        final String replyToName =
                            data['replyToName']?.toString().trim() ?? '';

                        return Padding(
                          padding: EdgeInsets.only(
                            left: isReply ? 40 : 0,
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onLongPress: () =>
                                _showDetailCommentOptions(commentDoc),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: isReply ? 15 : 18,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: getAvatarImageProvider(
                                  data['authorAvatar']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                      true
                                      ? data['authorAvatar'].toString().trim()
                                      : 'assets/images/avatar1.png',
                                ),
                              ),
                              title: Wrap(
                                crossAxisAlignment:
                                WrapCrossAlignment.center,
                                spacing: 4,
                                children: [
                                  Text(
                                    authorName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isReply &&
                                      replyToName.isNotEmpty) ...[
                                    const Icon(
                                      Icons.arrow_right,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '@$replyToName',
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if ((data['content']?.toString().trim() ?? '').isNotEmpty)
                                      Text(
                                        data['content'].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    if ((data['imageUrl']?.toString().trim() ?? '').isNotEmpty) ...[
                                      if ((data['content']?.toString().trim() ?? '').isNotEmpty)
                                        const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _showCommentImage(
                                          data['imageUrl'].toString().trim(),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            data['imageUrl'].toString().trim(),
                                            width: isReply ? 150 : 190,
                                            height: isReply ? 150 : 190,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: isReply ? 150 : 190,
                                              height: 90,
                                              color: theme.colorScheme.surfaceContainerHighest,
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.broken_image_outlined),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  final String? existingParentId =
                                  data['parentCommentId']
                                      ?.toString()
                                      .trim();

                                  final String rootCommentId =
                                  existingParentId != null &&
                                      existingParentId.isNotEmpty
                                      ? resolveRootCommentId(
                                    existingParentId,
                                  )
                                      : commentId;

                                  setState(() {
                                    _replyTarget = {
                                      'commentId': commentId,
                                      'rootCommentId': rootCommentId,
                                      'authorName': authorName,
                                    };
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

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rootComments.length,
                        itemBuilder: (context, index) {
                          final rootComment = rootComments[index];

                          final replies = repliesByRoot[rootComment.id] ??
                              <QueryDocumentSnapshot>[];

                          final bool isExpanded =
                          _expandedReplyThreads.contains(
                            rootComment.id,
                          );

                          // 預設顯示最新一則回覆。
                          // 展開後才顯示全部回覆。
                          final List<QueryDocumentSnapshot>
                          visibleReplies = isExpanded
                              ? replies
                              : replies.isEmpty
                              ? <QueryDocumentSnapshot>[]
                              : <QueryDocumentSnapshot>[
                            replies.last,
                          ];

                          final int hiddenReplyCount =
                              replies.length - visibleReplies.length;

                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: [
                              // 主留言
                              buildCommentTile(
                                rootComment,
                                isReply: false,
                              ),

                              // 預設顯示最新一則，或展開後顯示全部
                              for (final reply in visibleReplies)
                                buildCommentTile(
                                  reply,
                                  isReply: true,
                                ),

                              // 有兩則以上回覆時，顯示展開／收合按鈕
                              if (replies.length > 1)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 72,
                                    right: 16,
                                    bottom: 8,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 0,
                                          vertical: 6,
                                        ),
                                        tapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                        foregroundColor: theme
                                            .colorScheme.onSurfaceVariant,
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
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 1,
                                            color: theme.colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.45),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            isExpanded
                                                ? l10n.momentCollapseReplies
                                                : l10n.momentViewOtherReplies(hiddenReplyCount),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons
                                                .keyboard_arrow_down,
                                            size: 17,
                                          ),
                                        ],
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.reply,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        l10n.moment_replying_to(
                            _replyTarget!['authorName']),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _replyTarget = null; // 點擊叉叉取消回覆
                          });
                        },
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              if (_selectedCommentImageBytes != null)
                Container(
                  width: double.infinity,
                  color: theme.cardColor,
                  padding: const EdgeInsets.fromLTRB(64, 10, 16, 2),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _selectedCommentImageBytes!,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: -10,
                          top: -10,
                          child: Material(
                            color: theme.colorScheme.surface,
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

              // ⬇️ 原本的輸入框
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5))
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Tooltip(
                        message: l10n.momentSwitchCommentIdentity,
                        child: GestureDetector(
                          onTap: _showIdentitySwitcher,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 19,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: getAvatarImageProvider(
                                  _currentAuthorAvatar.isNotEmpty
                                      ? _currentAuthorAvatar
                                      : 'assets/images/avatar1.png',
                                ),
                              ),
                              Positioned(
                                right: -3,
                                bottom: -3,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.cardColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.swap_horiz_rounded,
                                    size: 10,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: '加入照片',
                        onPressed: _isPostingComment ? null : _pickCommentImage,
                        icon: ImageIcon(
                          const AssetImage(
                            'assets/icons/icon_moment_photo_add.png',
                          ),
                          size: 26,
                          color: _selectedCommentImageBytes != null
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          enabled: !_isPostingComment,
                          decoration: InputDecoration(
                            hintText: _replyTarget != null
                                ? l10n.moment_reply_hint(
                              _replyTarget!['authorName'],
                            )
                                : l10n.comment_input_hint(
                              safeAuthorName,
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.55),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: l10n.momentSendCommentTooltip,
                        onPressed: _isPostingComment
                            ? null
                            : () => _saveCommentToDb(
                          _commentController.text,
                          _moment!,
                        ),
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
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

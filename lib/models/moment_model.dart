import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Moment {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String createdBy; // ✨ 1. 新增「創作者ID」欄位
  final String content;
  final List<Map<String, String>> mentions;
  final String? imageUrl;
  final Timestamp createdAt;
  final int likeCount;
  final int commentCount;
  final bool isPublic;
  final String? parentCommentId; // 紀錄它是回覆哪一則留言的 ID
  final String? replyToName;     // 紀錄被回覆的人的名字（方便顯示 @名字）


  Moment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.createdBy, // ✨ 2. 在建構子中加入
    required this.content,
    this.mentions = const [],
    this.imageUrl,
    required this.isPublic,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.parentCommentId,
    this.replyToName,
  });
  bool get isCreatorPost => authorId.startsWith('creator_');

  Future<void> sendCommentNotification({
    required String commentText,
    required String senderNickname,
    required String commentId,
  }) async {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // 門檻檢查：收件人必須存在，寄件人必須存在，且不能是自己留言給自己
    if (createdBy.isEmpty || currentUserId == null || createdBy == currentUserId) {
      return;
    }

    try {
      // ✨ 根據身分決定文案
      final String mailBody = isCreatorPost
          ? '$senderNickname在妳的動態下留言：「$commentText」'
          : '$senderNickname給$authorName留了話：「$commentText」';

      // ✅ 固定通知 ID：同一則留言只會有一封通知
      final String notificationId = 'moment_comment_${id}_$commentId';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(createdBy)
          .collection('mailbox')
          .doc(notificationId)
          .set({
        'type': 'comment',
        'fromId': currentUserId,
        'fromName': senderNickname,
        'title': isCreatorPost ? '動態有新回應！💬' : '角色人氣爆發！🔥',
        'body': mailBody,
        'postId': id,
        'commentId': commentId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      }, SetOptions(merge: true));

      print("📫 留言通知信已寄出！收件人：$createdBy");
    } catch (e) {
      print("❌ 模型內寄信失敗: $e");
    }
  }

  factory Moment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Moment(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Unknown',
      authorAvatar: data['authorAvatar'] ?? 'assets/images/blank_avatar.png',
      createdBy: data['createdBy'] ?? '', // ✨ 3. 從 Firestore 讀取 createdBy
      content: data['content'] ?? '',
      mentions:
      (data['mentions'] as List<dynamic>?)
          ?.map(
            (e) => Map<String, String>.from(e),
      )
          .toList() ??
          const [],
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      isPublic: data['isPublic'] ?? true, // ✨ 預設為 true (公開)
      parentCommentId: data['parentCommentId'],
      replyToName: data['replyToName'],
    );
  }
}
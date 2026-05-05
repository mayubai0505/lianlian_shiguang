import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final Timestamp createdAt;
  final String? parentCommentId; // 紀錄它是回覆哪一則留言的 ID
  final String? replyToName;     // 紀錄被回覆的人的名字

  Comment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    this.parentCommentId,
    this.replyToName,
  });

  // ✨ 完美細節 1：copyWith 方法
  // 讓妳可以輕鬆地更新物件的一部分（例如：只修改內容）
  Comment copyWith({
    String? content,
    String? authorName,
    String? authorAvatar,
    String? parentCommentId, // ✨ 新增
    String? replyToName,     // ✨ 新增
  }) {
    return Comment(
      id: id,
      content: content ?? this.content,
      authorId: authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replyToName: replyToName ?? this.replyToName,
    );
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '神秘玩家',
      authorAvatar: data['authorAvatar'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      // ✨ 這裡也要讀取，解決「Getter isn't defined」報錯
      parentCommentId: data['parentCommentId'],
      replyToName: data['replyToName'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'createdAt': createdAt,
      'parentCommentId': parentCommentId,
      'replyToName': replyToName,
    };
  }
}
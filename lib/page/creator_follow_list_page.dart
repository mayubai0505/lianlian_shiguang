import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/creator_profile_page.dart';
import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import '../screens/creator_profile_page.dart';

enum CreatorFollowListType {
  following,
  followers,
}

class CreatorFollowListPage extends StatelessWidget {
  final CreatorFollowListType type;

  const CreatorFollowListPage({
    super.key,
    required this.type,
  });

  bool get _isFollowingList =>
      type == CreatorFollowListType.following;

  @override
  Widget build(BuildContext context) {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('請先登入'),
        ),
      );
    }

    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection(
      _isFollowingList
          ? 'following'
          : 'followers',
    )
        .orderBy(
      'followedAt',
      descending: true,
    )
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isFollowingList
              ? '我追蹤的創作者'
              : '追蹤我的玩家',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '讀取失敗：${snapshot.error}',
              ),
            );
          }

          final docs =
              snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return _buildEmptyState(
              context,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
            const Divider(
              height: 1,
              indent: 76,
            ),
            itemBuilder: (context, index) {
              final relationDoc =
              docs[index];

              // following 文件 ID 是 creator UID
              // followers 文件 ID 是 follower UID
              final String targetUserId =
                  relationDoc.id;

              return _buildUserTile(
                context: context,
                currentUserId:
                currentUser.uid,
                targetUserId:
                targetUserId,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context,) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isFollowingList
                  ? Icons.person_add_alt_1_outlined
                  : Icons.people_outline_rounded,
              size: 60,
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              _isFollowingList
                  ? '還沒有追蹤創作者'
                  : '目前還沒有追蹤者',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isFollowingList
                  ? '在角色檔案或創作者工作坊追蹤喜歡的創作者吧。'
                  : '當其他玩家追蹤你時，會顯示在這裡。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile({
    required BuildContext context,
    required String currentUserId,
    required String targetUserId,
  }) {
    return FutureBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const ListTile(
            leading: CircleAvatar(),
            title: LinearProgressIndicator(),
          );
        }

        final data =
            snapshot.data?.data() ??
                <String, dynamic>{};

        final String nickname =
        (data['nickname'] ?? '未知玩家')
            .toString();

        final String playerId =
        (data['playerID'] ?? '')
            .toString();

        final String avatarPath =
        (data['avatarPath'] ?? '')
            .toString();

        return ListTile(
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage:
            getAvatarImageProvider(
              avatarPath,
            ),
          ),
          title: Text(
            nickname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            playerId.isNotEmpty
                ? 'ID：$playerId'
                : '尚未設定玩家 ID',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: _isFollowingList
              ? _buildFollowingButton(
            context: context,
            currentUserId:
            currentUserId,
            creatorId:
            targetUserId,
          )
              : const Icon(
            Icons.chevron_right_rounded,
          ),
          onTap: () {
            _openCreatorProfile(
              context: context,
              creatorId: targetUserId,
              creatorName: nickname,
            );
          },
        );
      },
    );
  }

  Widget _buildFollowingButton({
    required BuildContext context,
    required String currentUserId,
    required String creatorId,
  }) {
    return OutlinedButton(
      onPressed: () {
        _confirmUnfollow(
          context: context,
          currentUserId:
          currentUserId,
          creatorId: creatorId,
        );
      },
      style: OutlinedButton.styleFrom(
        visualDensity:
        VisualDensity.compact,
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
      ),
      child: const Text('已追蹤'),
    );
  }

  Future<void> _confirmUnfollow({
    required BuildContext context,
    required String currentUserId,
    required String creatorId,
  }) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext,) {
            return AlertDialog(
              title: const Text('取消追蹤'),
              content: const Text(
                '確定要取消追蹤這位創作者嗎？',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child:
                  const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child: const Text(
                    '取消追蹤',
                    style: TextStyle(
                      color:
                      Colors.redAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirmed) return;

    final db =
        FirebaseFirestore.instance;

    final batch = db.batch();

    batch.delete(
      db
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(creatorId),
    );

    batch.delete(
      db
          .collection('users')
          .doc(creatorId)
          .collection('followers')
          .doc(currentUserId),
    );

    await batch.commit();
  }

  void _openCreatorProfile({
    required BuildContext context,
    required String creatorId,
    required String creatorName,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreatorProfilePage(
              creatorId: creatorId,
              creatorName: creatorName,
            ),
      ),
    );
  }
}
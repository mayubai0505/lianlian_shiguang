import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/creator_profile_page.dart';
import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import '../screens/creator_profile_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


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
    final l10n = AppLocalizations.of(context)!;

    if (currentUser == null) {
      return  Scaffold(
        body: Center(
          child: Text(l10n.profilePagePleaseSignIn),
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
              ? l10n.creator_follow_following_title
              : l10n.creator_follow_followers_title,
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
                l10n.creator_follow_load_failed(snapshot.error.toString()),
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
    final l10n = AppLocalizations.of(context)!;

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
                  ? l10n.creator_follow_empty_following_title
                  : l10n.creator_follow_empty_followers_title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isFollowingList
                  ? l10n.creator_follow_empty_following_description
                  : l10n.creator_follow_empty_followers_description,
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
    final l10n = AppLocalizations.of(context)!;
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
        (data['nickname'] ?? l10n.creator_follow_unknown_player)
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
                ? l10n.creator_follow_player_id(playerId)
                : l10n.creator_follow_no_player_id,
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
    final l10n = AppLocalizations.of(context)!;
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
      child: Text(l10n.creator_follow_following),
    );
  }

  Future<void> _confirmUnfollow({
    required BuildContext context,
    required String currentUserId,
    required String creatorId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext,) {
            return AlertDialog(
              title: Text(l10n.creator_follow_unfollow_title),
              content:  Text(
                l10n.creator_follow_unfollow_confirm,
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
                  Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child:  Text(
                    l10n.creator_follow_unfollow,
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
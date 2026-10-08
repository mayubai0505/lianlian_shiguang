import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';

/// 顯示玩家頭像 + 目前裝備中的活動頭像框。
///
/// [userId] 若不是 users/{uid} 的玩家帳號（例如角色 ID），查不到裝備資料時
/// 就只顯示原本頭像，因此可安全用在「玩家 / 角色混合」的留言列表。
class UserAvatarWithFrame extends StatefulWidget {
  final String userId;
  final ImageProvider? avatarImage;
  final double size;
  final double avatarRadius;
  final Color? backgroundColor;
  final Widget? fallbackChild;
  final BoxFit frameFit;

  const UserAvatarWithFrame({
    super.key,
    required this.userId,
    required this.avatarImage,
    required this.size,
    required this.avatarRadius,
    this.backgroundColor,
    this.fallbackChild,
    this.frameFit = BoxFit.contain,
  });

  @override
  State<UserAvatarWithFrame> createState() => _UserAvatarWithFrameState();
}

class _UserAvatarWithFrameState extends State<UserAvatarWithFrame> {
  late Future<String> _frameFuture;

  @override
  void initState() {
    super.initState();
    _frameFuture = _loadFrameImageUrl();
  }

  @override
  void didUpdateWidget(covariant UserAvatarWithFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _frameFuture = _loadFrameImageUrl();
    }
  }

  Future<String> _loadFrameImageUrl() async {
    final uid = widget.userId.trim();
    if (uid.isEmpty) return '';

    try {
      final db = FirebaseFirestore.instance;
      final userDoc = await db.collection('users').doc(uid).get();

      // 角色 ID 不會有 users/{characterId}，直接視為沒有頭像框。
      if (!userDoc.exists) return '';

      final rawEquipped = userDoc.data()?['equippedAvatarFrame'];
      if (rawEquipped is! Map) return '';

      final equipped = Map<String, dynamic>.from(rawEquipped);
      final eventId = (equipped['eventId'] ?? '').toString().trim();
      final itemId = (equipped['itemId'] ?? '').toString().trim();

      if (eventId.isEmpty || itemId.isEmpty) return '';

      // 若未來 equippedAvatarFrame 直接保存 imageUrl，可直接使用，
      // 同時保留目前 event_progress 的既有結構。
      final directImageUrl =
          (equipped['imageUrl'] ?? '').toString().trim();
      if (directImageUrl.isNotEmpty) return directImageUrl;

      final progressDoc = await db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('event_progress')
          .doc(uid)
          .collection('events')
          .doc(eventId)
          .get();

      final rawOwned = progressDoc.data()?['ownedEventItems'];
      if (rawOwned is! Map || rawOwned[itemId] is! Map) return '';

      final ownedItem =
          Map<String, dynamic>.from(rawOwned[itemId] as Map);

      if ((ownedItem['itemType'] ?? '').toString() != 'avatar_frame') {
        return '';
      }

      return (ownedItem['imageUrl'] ?? '').toString().trim();
    } catch (e) {
      debugPrint('⚠️ 讀取玩家頭像框失敗：$e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: widget.avatarRadius,
      backgroundColor: widget.backgroundColor ??
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      backgroundImage: widget.avatarImage,
      child: widget.avatarImage == null
          ? (widget.fallbackChild ??
              Icon(
                Icons.person_rounded,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.45),
              ))
          : null,
    );

    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          avatar,
          FutureBuilder<String>(
            future: _frameFuture,
            builder: (context, snapshot) {
              final frameUrl = snapshot.data?.trim() ?? '';
              if (frameUrl.isEmpty) {
                return const SizedBox.shrink();
              }

              return Positioned.fill(
                child: IgnorePointer(
                  child: Image(
                    image: getAvatarImageProvider(frameUrl),
                    fit: widget.frameFit,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) =>
                        const SizedBox.shrink(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';

/// 頁面基礎倍率 × 個別框圖補正；只改繪製尺寸，不改頭像或點擊範圍。
double avatarFrameDisplayScale({
  required double baseScale,
  String frameName = '',
}) {
  // 依既有商店品名識別，不依賴下載網址或本機圖片。
  const frameCorrections = <String, double>{
    '秋日南瓜': 1.12,
  };
  return baseScale * (frameCorrections[frameName.trim()] ?? 1.0);
}

class _AvatarFrameData {
  final String url;
  final String name;
  const _AvatarFrameData(this.url, [this.name = '']);
}

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
  // 未指定時維持舊呼叫端的大小及讀取方式。
  final double? frameScale;

  const UserAvatarWithFrame({
    super.key,
    required this.userId,
    required this.avatarImage,
    required this.size,
    required this.avatarRadius,
    this.backgroundColor,
    this.fallbackChild,
    this.frameFit = BoxFit.contain,
    this.frameScale,
  });

  @override
  State<UserAvatarWithFrame> createState() => _UserAvatarWithFrameState();
}

class _UserAvatarWithFrameState extends State<UserAvatarWithFrame> {
  late Future<_AvatarFrameData> _frameFuture;

  @override
  void initState() {
    super.initState();
    _frameFuture = _loadFrameImageUrl();
  }

  @override
  void didUpdateWidget(covariant UserAvatarWithFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        (oldWidget.frameScale == null) != (widget.frameScale == null)) {
      _frameFuture = _loadFrameImageUrl();
    }
  }

  Future<_AvatarFrameData> _loadFrameImageUrl() async {
    final uid = widget.userId.trim();
    if (uid.isEmpty) return const _AvatarFrameData('');

    try {
      final db = FirebaseFirestore.instance;
      final userDoc = await db.collection('users').doc(uid).get();

      // 角色 ID 不會有 users/{characterId}，直接視為沒有頭像框。
      if (!userDoc.exists) return const _AvatarFrameData('');

      final rawEquipped = userDoc.data()?['equippedAvatarFrame'];
      if (rawEquipped is! Map) return const _AvatarFrameData('');

      final equipped = Map<String, dynamic>.from(rawEquipped);
      final eventId = (equipped['eventId'] ?? '').toString().trim();
      final itemId = (equipped['itemId'] ?? '').toString().trim();

      if (eventId.isEmpty || itemId.isEmpty) return const _AvatarFrameData('');

      // 若未來 equippedAvatarFrame 直接保存 imageUrl，可直接使用，
      // 同時保留目前 event_progress 的既有結構。
      final directImageUrl =
      (equipped['imageUrl'] ?? '').toString().trim();
      final equippedName = (equipped['name'] ?? '').toString().trim();
      final needsName = widget.frameScale != null && equippedName.isEmpty;
      if (directImageUrl.isNotEmpty && !needsName) {
        return _AvatarFrameData(directImageUrl, equippedName);
      }

      // 公開頁的訪客無權讀取別人的 event_progress（這是正確的安全規則）。
      // 因此先從活動公開商店目錄取得框圖；不需要讀對方的持有清單。
      try {
        final shopDoc = await db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('events')
            .doc(eventId)
            .collection('shop_items')
            .doc(itemId)
            .get();
        final shop = shopDoc.data();
        if (shop != null &&
            (shop['itemType'] ?? '').toString() == 'avatar_frame') {
          final imageUrl = (shop['imageUrl'] ?? '').toString().trim();
          final shopName = (shop['name'] ?? '').toString().trim();
          final resolvedUrl = directImageUrl.isNotEmpty ? directImageUrl : imageUrl;
          final resolvedName = equippedName.isNotEmpty ? equippedName : shopName;
          if (resolvedUrl.isNotEmpty &&
              (resolvedName.isNotEmpty || widget.frameScale == null ||
                  FirebaseAuth.instance.currentUser?.uid != uid)) {
            return _AvatarFrameData(resolvedUrl, resolvedName);
          }
          if (resolvedUrl.isNotEmpty && directImageUrl.isEmpty) {
            return _AvatarFrameData(resolvedUrl, resolvedName);
          }
        }
      } catch (e) {
        debugPrint('⚠️ 從公開活動商店讀取頭像框失敗：$e');
      }

      // 舊活動可能已不在公開目錄；僅帳號本人才能查自己的私有持有紀錄。
      if (FirebaseAuth.instance.currentUser?.uid != uid) {
        return _AvatarFrameData(directImageUrl, equippedName);
      }
      try {
        final progressDoc = await db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('event_progress')
            .doc(uid)
            .collection('events')
            .doc(eventId)
            .get();

        final rawOwned = progressDoc.data()?['ownedEventItems'];
        if (rawOwned is! Map || rawOwned[itemId] is! Map) {
          return _AvatarFrameData(directImageUrl, equippedName);
        }
        final ownedItem = Map<String, dynamic>.from(rawOwned[itemId] as Map);
        if ((ownedItem['itemType'] ?? '').toString() != 'avatar_frame') {
          return _AvatarFrameData(directImageUrl, equippedName);
        }
        final ownedUrl = (ownedItem['imageUrl'] ?? '').toString().trim();
        final ownedName = (ownedItem['name'] ?? '').toString().trim();
        return _AvatarFrameData(
          directImageUrl.isNotEmpty ? directImageUrl : ownedUrl,
          equippedName.isNotEmpty ? equippedName : ownedName,
        );
      } catch (e) {
        debugPrint('⚠️ 從本人持有紀錄讀取頭像框失敗：$e');
        return _AvatarFrameData(directImageUrl, equippedName);
      }
    } catch (e) {
      debugPrint('⚠️ 讀取玩家頭像框失敗：$e');
      return const _AvatarFrameData('');
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
          ? widget.fallbackChild
          : null,
    );

    return SizedBox.square(
      dimension: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: widget.frameScale == null ? Clip.hardEdge : Clip.none,
        children: [
          avatar,
          FutureBuilder<_AvatarFrameData>(
            future: _frameFuture,
            builder: (context, snapshot) {
              final frameUrl = snapshot.data?.url.trim() ?? '';
              if (frameUrl.isEmpty) {
                return const SizedBox.shrink();
              }

              return Positioned.fill(
                child: IgnorePointer(
                  child: Transform.scale(
                    scale: widget.frameScale == null
                        ? 1.0
                        : avatarFrameDisplayScale(
                            baseScale: widget.frameScale!,
                            frameName: snapshot.data?.name ?? '',
                          ),
                    child: Image(
                      image: getAvatarImageProvider(frameUrl),
                      fit: widget.frameFit,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox.shrink(),
                    ),
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
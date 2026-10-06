import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

class AvatarFramePickerPage extends StatefulWidget {
  final String avatarPath;

  const AvatarFramePickerPage({
    super.key,
    required this.avatarPath,
  });

  @override
  State<AvatarFramePickerPage> createState() => _AvatarFramePickerPageState();
}

class _AvatarFramePickerPageState extends State<AvatarFramePickerPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _savingKey;

  String _frameKey(String eventId, String itemId) => '$eventId::$itemId';

  String _cacheKey(String uid, String field) => 'avatarFrame_${uid}_$field';

  Future<void> _cacheEquippedFrame(
      String uid,
      _OwnedAvatarFrame frame,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cacheKey(uid, 'key'),
      _frameKey(frame.eventId, frame.itemId),
    );
    await prefs.setString(_cacheKey(uid, 'imageUrl'), frame.imageUrl);
    await prefs.setString(_cacheKey(uid, 'name'), frame.name);
  }

  Future<void> _clearEquippedFrameCache(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey(uid, 'key'));
    await prefs.remove(_cacheKey(uid, 'imageUrl'));
    await prefs.remove(_cacheKey(uid, 'name'));
  }

  Future<void> _equipFrame(_OwnedAvatarFrame frame) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _savingKey != null) return;

    final key = _frameKey(frame.eventId, frame.itemId);
    setState(() => _savingKey = key);

    try {
      // 只存「已擁有物品的索引」，不把任意圖片 URL 當成裝備資料。
      // 顯示時仍會回頭驗證 event_progress 裡的所有權。
      await _db.collection('users').doc(user.uid).set({
        'equippedAvatarFrame': {
          'eventId': frame.eventId,
          'itemId': frame.itemId,
        },
        'equippedAvatarFrameUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Firestore 成功後同步本機快取，下次進個人頁可以立即顯示。
      await _cacheEquippedFrame(user.uid, frame);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appL10n.avatar_frame_equipped_message(frame.name))),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('裝備失敗：$e')),
      );
    } finally {
      if (mounted) setState(() => _savingKey = null);
    }
  }

  Future<void> _unequipFrame() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _savingKey != null) return;

    setState(() => _savingKey = '__none__');
    try {
      await _db.collection('users').doc(user.uid).set({
        'equippedAvatarFrame': FieldValue.delete(),
        'equippedAvatarFrameUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _clearEquippedFrameCache(user.uid);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appL10n.avatar_frame_unequip_frame_snackbar)),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('卸下失敗：$e')),
      );
    } finally {
      if (mounted) setState(() => _savingKey = null);
    }
  }

  List<_OwnedAvatarFrame> _parseFrames(
      QuerySnapshot<Map<String, dynamic>> snapshot,
      ) {
    final result = <_OwnedAvatarFrame>[];
    final seen = <String>{};

    for (final eventDoc in snapshot.docs) {
      final data = eventDoc.data();
      final rawOwned = data['ownedEventItems'];
      if (rawOwned is! Map) continue;

      for (final entry in rawOwned.entries) {
        final rawItem = entry.value;
        if (rawItem is! Map) continue;

        final item = Map<String, dynamic>.from(rawItem);
        if ((item['itemType'] ?? '').toString() != 'avatar_frame') continue;

        final eventId = (item['eventId'] ?? eventDoc.id).toString().trim();
        final itemId = (item['itemId'] ?? entry.key).toString().trim();
        final imageUrl = (item['imageUrl'] ?? '').toString().trim();
        final name = (item['name'] ?? appL10n.avatar_frame_unequip_frame_message_event).toString().trim();
        final description = (item['description'] ?? '').toString().trim();

        if (eventId.isEmpty || itemId.isEmpty || imageUrl.isEmpty) continue;

        final key = _frameKey(eventId, itemId);
        if (!seen.add(key)) continue;

        result.add(
          _OwnedAvatarFrame(
            eventId: eventId,
            itemId: itemId,
            name: name.isEmpty ? '活動頭像框' : name,
            imageUrl: imageUrl,
            description: description,
          ),
        );
      }
    }

    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  Widget _avatarPreview({String? frameUrl, double size = 72}) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: size * 0.43,
            backgroundImage: getAvatarImageProvider(widget.avatarPath),
          ),
          if (frameUrl != null && frameUrl.trim().isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: Image(
                  image: getAvatarImageProvider(frameUrl),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('請先登入')),
      );
    }

    final userRef = _db.collection('users').doc(user.uid);
    final progressRef = _db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('event_progress')
        .doc(user.uid)
        .collection('events');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appL10n.avatar_frame_message,
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userRef.snapshots(),
        builder: (context, userSnapshot) {
          final userData = userSnapshot.data?.data() ?? <String, dynamic>{};
          final rawEquipped = userData['equippedAvatarFrame'];
          final equipped = rawEquipped is Map
              ? Map<String, dynamic>.from(rawEquipped)
              : <String, dynamic>{};
          final equippedEventId = (equipped['eventId'] ?? '').toString();
          final equippedItemId = (equipped['itemId'] ?? '').toString();
          final equippedKey = _frameKey(equippedEventId, equippedItemId);

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: progressRef.snapshots(),
            builder: (context, progressSnapshot) {
              if (progressSnapshot.connectionState == ConnectionState.waiting &&
                  !progressSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (progressSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      appL10n.avatar_frame_load_failed(
                        progressSnapshot.error?.toString() ?? '',
                      ),
                    ),
                  ),
                );
              }

              final frames = progressSnapshot.hasData
                  ? _parseFrames(progressSnapshot.data!)
                  : <_OwnedAvatarFrame>[];

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
                children: [
                  Text(
                    appL10n.avatar_frame_parse_frames_message_select,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    appL10n.avatar_frame_parse_frames_message_event,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _FrameOptionCard(
                    selected: equippedEventId.isEmpty || equippedItemId.isEmpty,
                    title: appL10n.avatar_frame_parse_frames_title,
                    subtitle: appL10n.avatar_frame_parse_frames_subtitle_avatar,
                    preview: _avatarPreview(size: 76),
                    busy: _savingKey == '__none__',
                    onTap: _savingKey == null ? _unequipFrame : null,
                  ),
                  const SizedBox(height: 12),
                  if (frames.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.045),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        appL10n.avatar_frame_parse_frames_message_event_shop_redeem_current,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...frames.map((frame) {
                      final key = _frameKey(frame.eventId, frame.itemId);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _FrameOptionCard(
                          selected: key == equippedKey,
                          title: frame.name,
                          subtitle: frame.description.isEmpty
                              ? appL10n.avatar_frame_parse_frames_message_event_variant_b
                              : frame.description,
                          preview: _avatarPreview(
                            frameUrl: frame.imageUrl,
                            size: 76,
                          ),
                          busy: _savingKey == key,
                          onTap: _savingKey == null
                              ? () => _equipFrame(frame)
                              : null,
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _OwnedAvatarFrame {
  final String eventId;
  final String itemId;
  final String name;
  final String imageUrl;
  final String description;

  const _OwnedAvatarFrame({
    required this.eventId,
    required this.itemId,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

class _FrameOptionCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final Widget preview;
  final bool busy;
  final VoidCallback? onTap;

  const _FrameOptionCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.preview,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.075)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              preview,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.35,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (busy)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/app_constants.dart';
import '../services/toast_utils.dart';
import '../utils/image_utils.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

//拾光檔案

// 同一個圖片 URL 在同一個 App session 內只主動預抓一次。
// 網路圖片由 CachedNetworkImageProvider 負責磁碟快取，
// precacheImage 再提前放進 Flutter 記憶體快取，讓切頁時能更快顯示。
final Set<String> _collectionPrecacheRequested = <String>{};

void _precacheCollectionImages(
    BuildContext context,
    Iterable<String> rawUrls,
    ) {
  final urls = rawUrls
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet();

  if (urls.isEmpty) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;

    for (final url in urls) {
      if (!_collectionPrecacheRequested.add(url)) continue;

      final provider = _safeImageProvider(url);
      if (provider == null) continue;

      unawaited(
        precacheImage(provider, context).catchError((Object error) {
          _collectionPrecacheRequested.remove(url);
          debugPrint('⚠️ 拾光收藏圖片預快取失敗：$url / $error');
        }),
      );
    }
  });
}

class EventMemoryCollectionPage extends StatefulWidget {
  const EventMemoryCollectionPage({super.key});

  @override
  State<EventMemoryCollectionPage> createState() =>
      _EventMemoryCollectionPageState();
}

class _EventMemoryCollectionPageState
    extends State<EventMemoryCollectionPage> {
  static const int _collectionIntroVersion = 1;

  Future<void> _showCollectionIntroIfNeeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !mounted) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      final snapshot = await userRef.get();
      final data = snapshot.data() ?? <String, dynamic>{};

      final seenVersion =
          (data['collectionIntroVersion'] as num?)?.toInt() ?? 0;

      if (seenVersion >= _collectionIntroVersion || !mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              appL10n.event_memory_collection_show_collection_intro_if_needed_message_collection,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              appL10n.event_memory_collection_show_collection_intro_if_needed_message_collection_content,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                height: 1.6,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('知道了'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      await userRef.set(
        {
          'collectionIntroVersion': _collectionIntroVersion,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('⚠️ 拾光收藏說明狀態處理失敗：$e');
    }
  }
  Future<void> _backfillLegacyCollectionDates() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable('backfillEventOwnedItemAcquiredAt');

      await callable.call();
    } on FirebaseFunctionsException catch (e) {
      // 日期補正失敗不阻擋玩家使用收藏頁。
      debugPrint(
        '⚠️ 舊活動收藏日期補正失敗：${e.code} / ${e.message}',
      );
    } catch (e) {
      debugPrint('⚠️ 舊活動收藏日期補正失敗：$e');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await _showCollectionIntroIfNeeded();

      if (!mounted) return;
      await _backfillLegacyCollectionDates();
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('拾光收藏')),
        body: Center(child: Text(appL10n.event_memory_collection_text_collection_login)),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '拾光收藏',
            style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
            isScrollable: false,
            labelStyle: GoogleFonts.notoSerifTc(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: GoogleFonts.notoSerifTc(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: appL10n.event_memory_collection_message_memory),
              Tab(text: '頭像框'),
              Tab(text: '貼紙'),
              Tab(text: appL10n.event_memory_collection_message_chat_background),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _MemoryCollectionTab(uid: user.uid),
            _EventItemCollectionTab(
              uid: user.uid,
              acceptedTypes: const {'avatar_frame'},
              emptyTitle: appL10n.event_memory_collection_message_avatar_frame_collection,
              emptySubtitle: appL10n.event_memory_collection_message_avatar_frame,
            ),
            _EventItemCollectionTab(
              uid: user.uid,
              acceptedTypes: const {'sticker', 'stickers'},
              emptyTitle: appL10n.event_memory_collection_message_collection_sticker,
              emptySubtitle: appL10n.event_memory_collection_message_sticker,
            ),
            _EventItemCollectionTab(
              uid: user.uid,
              acceptedTypes: const {
                'background',
                'chat_background',
                'scene_background',
              },
              emptyTitle: appL10n.event_memory_collection_message_collection_chat_background,
              emptySubtitle: appL10n.event_memory_collection_message_chat_background_variant_b,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryCollectionTab extends StatelessWidget {
  final String uid;

  const _MemoryCollectionTab({required this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('event_memories')
          .orderBy('collectedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _CollectionState(
            title: appL10n.event_memory_collection_tab_title_collection_temporary,
            subtitle: '請稍後再試一次。',
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final memories =
        snapshot.data!.docs.map(_CollectedMemory.fromDocument).toList();

        _precacheCollectionImages(
          context,
          memories.map((memory) => memory.characterImageSnapshot),
        );

        if (memories.isEmpty) {
          return _CollectionState(
            title: appL10n.event_memory_collection_tab_title_collection_memory,
            subtitle: appL10n.event_memory_collection_tab_subtitle_limited_memory_complete,
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
                child: Row(
                  children: [
                    Text(
                      '回憶',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${memories.length}',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              sliver: SliverGrid.builder(
                itemCount: memories.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return _MemoryCollectionCard(
                    memory: memory,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EventMemoryCollectionDetailPage(memory: memory),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EventItemCollectionTab extends StatelessWidget {
  final String uid;
  final Set<String> acceptedTypes;
  final String emptyTitle;
  final String emptySubtitle;

  const _EventItemCollectionTab({
    required this.uid,
    required this.acceptedTypes,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('event_progress')
          .doc(uid)
          .collection('events')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _CollectionState(
            title: '暫時讀不到收藏',
            subtitle: '請稍後再試一次。',
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = <_CollectedEventItem>[];

        for (final eventDoc in snapshot.data!.docs) {
          final data = eventDoc.data();
          final rawOwned = data['ownedEventItems'];

          if (rawOwned is! Map) continue;

          for (final entry in rawOwned.entries) {
            if (entry.value is! Map) continue;

            final itemData =
            Map<String, dynamic>.from(entry.value as Map);
            final itemType =
            (itemData['itemType'] ?? '').toString().trim();

            if (!acceptedTypes.contains(itemType)) continue;

            items.add(
              _CollectedEventItem.fromMap(
                eventId: eventDoc.id,
                itemId: entry.key.toString(),
                eventReference: eventDoc.reference,
                data: itemData,
              ),
            );
          }
        }

        items.sort((a, b) {
          final aTime = a.acquiredAt?.millisecondsSinceEpoch ?? 0;
          final bTime = b.acquiredAt?.millisecondsSinceEpoch ?? 0;
          return bTime.compareTo(aTime);
        });

        _precacheCollectionImages(
          context,
          items.map((item) => item.imageUrl),
        );

        if (items.isEmpty) {
          return _CollectionState(
            title: emptyTitle,
            subtitle: emptySubtitle,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _EventItemCard(item: items[index]);
          },
        );
      },
    );
  }
}

class _EventItemCard extends StatefulWidget {
  final _CollectedEventItem item;

  const _EventItemCard({required this.item});

  @override
  State<_EventItemCard> createState() => _EventItemCardState();
}

class _EventItemCardState extends State<_EventItemCard> {
  bool _deleting = false;

  _CollectedEventItem get item => widget.item;

  bool get _isPermanentOwnedItem =>
      item.itemType == 'avatar_frame' ||
          item.itemType == 'background' ||
          item.itemType == 'chat_background' ||
          item.itemType == 'scene_background';

  String get _itemTypeLabel {
    if (item.itemType == 'avatar_frame') return '頭像框';
    if (item.itemType == 'background' ||
        item.itemType == 'chat_background' ||
        item.itemType == 'scene_background') {
      return '聊天室背景';
    }
    return appL10n.event_memory_collection_item_card_label;
  }

  Future<void> _clearAvatarFrameCache(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('avatarFrame_${uid}_key');
      await prefs.remove('avatarFrame_${uid}_imageUrl');
      await prefs.remove('avatarFrame_${uid}_name');
    } catch (e) {
      debugPrint('⚠️ 清除頭像框快取失敗：$e');
    }
  }

  Future<bool> _confirmDeleteOwnedItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            appL10n.event_memory_collection_confirm_delete_owned_item_message_delete,
            textAlign: TextAlign.center,
          ),
          content: Text(
            appL10n.event_memory_collection_confirm_delete_owned_item_message_after_delete_unavailable(_itemTypeLabel) +
                appL10n.event_memory_collection_confirm_delete_owned_item_message_collection +
                appL10n.event_memory_collection_confirm_delete_owned_item_message_unavailable +
                appL10n.event_memory_collection_confirm_delete_owned_item_message_delete_variant_b(item.name),
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(height: 1.6),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('先不要'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('確定刪除'),
            ),
          ],
        );
      },
    );

    return confirmed == true;
  }

  Future<void> _deleteOwnedItem({
    BuildContext? previewDialogContext,
  }) async {
    if (_deleting || !_isPermanentOwnedItem) return;

    final confirmed = await _confirmDeleteOwnedItem();
    if (!confirmed || !mounted) return;

    setState(() => _deleting = true);

    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable('deleteEventOwnedItem');

      final result = await callable.call(<String, dynamic>{
        'eventId': item.eventId,
        'itemId': item.itemId,
      });

      final data = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};

      final user = FirebaseAuth.instance.currentUser;
      if (user != null && data['unequippedAvatarFrame'] == true) {
        await _clearAvatarFrameCache(user.uid);
      }

      if (!mounted) return;

      if (previewDialogContext != null &&
          Navigator.of(previewDialogContext).canPop()) {
        Navigator.of(previewDialogContext).pop();
      }

      ToastUtils.showCenterToast(
        context,
        appL10n.event_memory_collection_confirm_delete_owned_item_message_delete_variant_c,
        customIcon: Icons.delete_outline_rounded,
      );
    } on FirebaseFunctionsException catch (e) {
      debugPrint(
        '❌ 刪除活動限定物品失敗：${e.code} / ${e.message}',
      );

      if (!mounted) return;

      String message = e.message ?? '刪除失敗，請稍後再試';

      if (e.code == 'not-found') {
        message = appL10n.event_memory_collection_confirm_delete_owned_item_message_not_found_delete;
      } else if (e.code == 'failed-precondition') {
        message = e.message ?? appL10n.event_memory_collection_confirm_delete_owned_item_message_collection_current_delete;
      }

      ToastUtils.showCenterToast(
        context,
        message,
        isError: true,
      );
    } catch (e) {
      debugPrint('❌ 刪除活動限定物品失敗：$e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '刪除失敗，請稍後再試',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }

  Future<void> _showPreview(BuildContext context) async {
    final provider = _safeImageProvider(item.imageUrl);
    final theme = Theme.of(context);

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.62),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 36,
          ),
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 430,
              maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.86,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: '關閉',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: provider == null
                          ? Center(
                        child: Text(
                          appL10n.event_memory_collection_show_preview_message,
                          style: GoogleFonts.notoSerifTc(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.45),
                          ),
                        ),
                      )
                          : InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4,
                        child: Center(
                          child: Image(
                            image: provider,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(
                                appL10n.event_memory_collection_show_preview_message_failed_load,
                                style: GoogleFonts.notoSerifTc(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.45),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        height: 1.6,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    item.collectionDateLabel,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 10.5,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.42),
                    ),
                  ),
                  if (_isPermanentOwnedItem) ...[
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _deleting
                          ? null
                          : () => _deleteOwnedItem(
                        previewDialogContext: dialogContext,
                      ),
                      icon: _deleting
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.delete_outline_rounded),
                      label: const Text('刪除'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = _safeImageProvider(item.imageUrl);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showPreview(context),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.07),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  child: provider == null
                      ? Center(
                    child: Text(
                      '圖片準備中',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.40),
                      ),
                    ),
                  )
                      : Image(
                    image: provider,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Text(
                        '圖片載入失敗',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 10.5,
                          height: 1.4,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.50),
                        ),
                      ),
                    ],
                    const SizedBox(height: 7),
                    Text(
                      item.collectionDateLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 9.5,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.42),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoryCollectionCard extends StatelessWidget {
  final _CollectedMemory memory;
  final VoidCallback onTap;

  const _MemoryCollectionCard({
    required this.memory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = _safeImageProvider(memory.characterImageSnapshot);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.07),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (provider != null)
                Image(
                  image: provider,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Color(0xFF201927),
                  ),
                )
              else
                const ColoredBox(color: Color(0xFF201927)),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.76),
                    ],
                    stops: const [0, 0.50, 1],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.memoryTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                        shadows: const [
                          Shadow(color: Colors.black45, blurRadius: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${memory.characterName} × ${memory.playerName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      memory.collectedDateLabel,
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white.withValues(alpha: 0.62),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventMemoryCollectionDetailPage extends StatefulWidget {
  final _CollectedMemory memory;

  const EventMemoryCollectionDetailPage({
    super.key,
    required this.memory,
  });

  @override
  State<EventMemoryCollectionDetailPage> createState() =>
      _EventMemoryCollectionDetailPageState();
}

class _EventMemoryCollectionDetailPageState
    extends State<EventMemoryCollectionDetailPage> {
  final GlobalKey _cardKey = GlobalKey();
  bool _saving = false;
  bool _deleting = false;

  Future<void> _saveToGallery() async {
    if (_saving) return;

    if (kIsWeb) {
      ToastUtils.showCenterToast(
        context,
        appL10n.event_memory_collection_save_to_gallery_message_save_current,
        isError: true,
      );
      return;
    }

    setState(() => _saving = true);

    try {
      bool hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }

      if (!hasAccess) {
        if (!mounted) return;
        ToastUtils.showCenterToast(
          context,
          appL10n.event_memory_collection_save_to_gallery_message_save_memory,
          isError: true,
        );
        return;
      }

      final boundary =
      _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        if (!mounted) return;
        ToastUtils.showCenterToast(
          context,
          appL10n.event_memory_collection_save_to_gallery_message_memory,
          isError: true,
        );
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        if (!mounted) return;
        ToastUtils.showCenterToast(
          context,
          appL10n.event_memory_collection_save_to_gallery_message_failed_memory,
          isError: true,
        );
        return;
      }

      final Uint8List bytes = byteData.buffer.asUint8List();
      final fileName =
          'lianlian_memory_${DateTime.now().millisecondsSinceEpoch}.png';

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      await tempFile.writeAsBytes(bytes, flush: true);

      await Gal.putImage(
        tempFile.path,
        album: '戀戀拾光',
      );

      try {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {}

      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        appL10n.event_memory_collection_save_to_gallery_message_save,
        customIcon: Icons.photo_library_rounded,
      );
    } on GalException catch (e) {
      debugPrint('❌ 收藏回憶儲存失敗：${e.type}');
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        appL10n.event_memory_collection_save_to_gallery_message_save_confirm_failed,
        isError: true,
      );
    } catch (e) {
      debugPrint('❌ 收藏回憶儲存失敗：$e');
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '儲存失敗，請稍後再試',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _deleteCollection() async {
    if (_deleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(appL10n.event_memory_collection_delete_collection_title_collection_cancel),
          content: Text(
            appL10n.event_memory_collection_delete_collection_message_collection_cancel_memory,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('先不要'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('取消收藏'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);

    try {
      await widget.memory.reference.delete();

      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '已取消收藏',
        customIcon: Icons.bookmark_remove_rounded,
      );
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('❌ 取消收藏失敗：$e');
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        appL10n.event_memory_collection_delete_collection_message_try_again_later_collection_cancel_failed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final memory = widget.memory;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appL10n.event_memory_collection_message_collection_memory,
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: RepaintBoundary(
                  key: _cardKey,
                  child: _CollectedMemoryCard(memory: memory),
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: memory.sceneSnapshot.isEmpty
                  ? null
                  : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        _CollectedMemoryReplayPage(memory: memory),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: Text(appL10n.event_memory_collection_label_play),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _saving ? null : _saveToGallery,
              icon: _saving
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.photo_library_outlined),
              label: Text(_saving ? appL10n.event_memory_collection_label_save : appL10n.event_memory_collection_label_save_variant_b),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _deleting ? null : _deleteCollection,
              icon: _deleting
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.bookmark_remove_outlined),
              label: const Text('取消收藏'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectedMemoryCard extends StatelessWidget {
  final _CollectedMemory memory;

  const _CollectedMemoryCard({required this.memory});

  @override
  Widget build(BuildContext context) {
    final provider = _safeImageProvider(memory.characterImageSnapshot);

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (provider != null)
              Image(
                image: provider,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const ColoredBox(color: Color(0xFF201927)),
              )
            else
              const ColoredBox(color: Color(0xFF201927)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.78),
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appL10n.event_memory_collection_collected_card_message_limited_memory,
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    memory.memoryTitle,
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${memory.characterName} × ${memory.playerName}',
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white.withValues(alpha: 0.86),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (memory.finalText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      memory.finalText,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 13,
                        height: 1.65,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    memory.collectedDateCardLabel,
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectedMemoryReplayPage extends StatefulWidget {
  final _CollectedMemory memory;

  const _CollectedMemoryReplayPage({
    required this.memory,
  });

  @override
  State<_CollectedMemoryReplayPage> createState() =>
      _CollectedMemoryReplayPageState();
}

class _CollectedMemoryReplayPageState extends State<_CollectedMemoryReplayPage>
    with SingleTickerProviderStateMixin {
  static String get _openingText => appL10n.event_memory_collection_create_state_message_end_story;

  late final AnimationController _photoMotionController;
  Timer? _typingTimer;
  Timer? _openingTimer;

  bool _opening = true;
  bool _openingVisible = false;
  bool _photoVisible = false;
  bool _typingDone = true;
  int _index = 0;
  String _typedText = '';

  List<_CollectedScene> get _scenes => widget.memory.sceneSnapshot;

  @override
  void initState() {
    super.initState();
    _photoMotionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );

    _startOpening();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _openingTimer?.cancel();
    _photoMotionController.dispose();
    super.dispose();
  }

  String _replaceTokens(String text) {
    return text
        .replaceAll('{{player}}', widget.memory.playerName)
        .replaceAll('{player}', widget.memory.playerName)
        .replaceAll('{{character}}', widget.memory.characterName)
        .replaceAll('{character}', widget.memory.characterName);
  }

  void _startOpening() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _openingVisible = true);
    });

    _openingTimer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted || !_opening) return;
      setState(() => _openingVisible = false);

      _openingTimer = Timer(const Duration(milliseconds: 850), _enterReplay);
    });
  }

  void _enterReplay() {
    if (!mounted || !_opening) return;

    _openingTimer?.cancel();
    setState(() {
      _opening = false;
      _photoVisible = false;
      _index = 0;
    });

    _photoMotionController
      ..reset()
      ..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _photoVisible = true);

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _beginScene();
      });
    });
  }

  void _skipOpening() {
    if (!_opening) return;
    _openingTimer?.cancel();
    setState(() => _openingVisible = false);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && _opening) _enterReplay();
    });
  }

  void _beginScene() {
    _typingTimer?.cancel();

    if (_scenes.isEmpty || _opening) return;

    final text = _replaceTokens(_scenes[_index].text);
    final typewriter = _scenes[_index].animation == 'typewriter';

    if (!typewriter) {
      setState(() {
        _typedText = text;
        _typingDone = true;
      });
      return;
    }

    setState(() {
      _typedText = '';
      _typingDone = false;
    });

    int cursor = 0;

    _typingTimer = Timer.periodic(
      const Duration(milliseconds: 35),
          (timer) {
        if (!mounted || _opening) {
          timer.cancel();
          return;
        }

        cursor++;

        if (cursor >= text.length) {
          timer.cancel();
          setState(() {
            _typedText = text;
            _typingDone = true;
          });
        } else {
          setState(() => _typedText = text.substring(0, cursor));
        }
      },
    );
  }

  void _advance() {
    if (_opening) {
      _skipOpening();
      return;
    }

    if (!_typingDone) {
      _typingTimer?.cancel();
      setState(() {
        _typedText = _replaceTokens(_scenes[_index].text);
        _typingDone = true;
      });
      return;
    }

    if (_index >= _scenes.length - 1) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _index += 1);
    _beginScene();
  }

  @override
  Widget build(BuildContext context) {
    if (_scenes.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(appL10n.event_memory_collection_text_collection)),
      );
    }

    if (_opening) {
      return Scaffold(
        backgroundColor: const Color(0xFF17131E),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _skipOpening,
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: AnimatedOpacity(
                    opacity: _openingVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 900),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _openingText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerifTc(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 20,
                          height: 1.9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 12,
                  child: TextButton(
                    onPressed: _skipOpening,
                    child: Text(
                      appL10n.event_memory_collection_message,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final provider = _safeImageProvider(widget.memory.characterImageSnapshot);
    final scene = _scenes[_index];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _advance,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (provider != null)
              AnimatedOpacity(
                opacity: _photoVisible ? 1 : 0,
                duration: const Duration(milliseconds: 1000),
                child: AnimatedBuilder(
                  animation: _photoMotionController,
                  builder: (context, child) {
                    final t = Curves.easeInOut
                        .transform(_photoMotionController.value);
                    return Transform.translate(
                      offset: Offset(-4 + 8 * t, 2 - 4 * t),
                      child: Transform.scale(
                        scale: 1.025 + 0.018 * t,
                        child: child,
                      ),
                    );
                  },
                  child: Image(
                    image: provider,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: Color(0xFF17131E)),
                  ),
                ),
              )
            else
              const ColoredBox(color: Color(0xFF17131E)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.62),
                  ],
                  stops: const [0, 0.48, 1],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 10, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor:
                            Colors.black.withValues(alpha: 0.25),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.memory.memoryTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifTc(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              shadows: const [
                                Shadow(color: Colors.black54, blurRadius: 8),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '${_index + 1} / ${_scenes.length}',
                          style: GoogleFonts.notoSerifTc(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.48),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.13),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (scene.type == 'dialogue') ...[
                            Text(
                              widget.memory.characterName,
                              style: GoogleFonts.notoSerifTc(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (scene.type == 'ending') ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '回憶',
                                  style: GoogleFonts.notoSerifTc(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            _typedText,
                            style: GoogleFonts.notoSerifTc(
                              color: Colors.white,
                              fontSize: scene.type == 'ending' ? 17 : 15,
                              height: 1.75,
                              fontWeight: scene.type == 'ending'
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _typingDone
                                  ? (_index == _scenes.length - 1
                                  ? appL10n.event_memory_collection_message_end
                                  : appL10n.event_memory_collection_message_continue)
                                  : appL10n.event_memory_collection_message_variant_b,
                              style: GoogleFonts.notoSerifTc(
                                color: Colors.white.withValues(alpha: 0.58),
                                fontSize: 9.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectedMemory {
  final DocumentReference<Map<String, dynamic>> reference;
  final String memoryTitle;
  final String characterName;
  final String characterImageSnapshot;
  final String playerName;
  final String playerProfileName;
  final String finalText;
  final DateTime? collectedAt;
  final List<_CollectedScene> sceneSnapshot;

  const _CollectedMemory({
    required this.reference,
    required this.memoryTitle,
    required this.characterName,
    required this.characterImageSnapshot,
    required this.playerName,
    required this.playerProfileName,
    required this.finalText,
    required this.collectedAt,
    required this.sceneSnapshot,
  });

  factory _CollectedMemory.fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data();
    final rawScenes = data['sceneSnapshot'];

    final scenes = rawScenes is List
        ? rawScenes
        .whereType<Map>()
        .map((item) =>
        _CollectedScene.fromMap(Map<String, dynamic>.from(item)))
        .where((scene) => scene.text.trim().isNotEmpty)
        .toList()
        : <_CollectedScene>[];

    return _CollectedMemory(
      reference: doc.reference,
      memoryTitle: (data['memoryTitle'] ?? '限定回憶').toString(),
      characterName: (data['characterName'] ?? '角色').toString(),
      characterImageSnapshot:
      (data['characterImageSnapshot'] ?? '').toString().trim(),
      playerName: (data['playerName'] ?? '你').toString(),
      playerProfileName: (data['playerProfileName'] ?? '').toString(),
      finalText: (data['finalText'] ?? '').toString(),
      collectedAt: (data['collectedAt'] as Timestamp?)?.toDate(),
      sceneSnapshot: scenes,
    );
  }

  String get collectedDateLabel {
    final value = collectedAt;
    if (value == null) return appL10n.event_memory_collection_collected_label_collection;
    return '${value.year}/${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}';
  }

  String get collectedDateCardLabel {
    final value = collectedAt ?? DateTime.now();
    return '${value.year}.${value.month.toString().padLeft(2, '0')}.${value.day.toString().padLeft(2, '0')}';
  }
}

class _CollectedScene {
  final String type;
  final String text;
  final String animation;

  const _CollectedScene({
    required this.type,
    required this.text,
    required this.animation,
  });

  factory _CollectedScene.fromMap(Map<String, dynamic> data) {
    return _CollectedScene(
      type: (data['type'] ?? 'narration').toString(),
      text: (data['text'] ?? '').toString(),
      animation: (data['animation'] ?? 'fade').toString(),
    );
  }
}

class _CollectedEventItem {
  final String eventId;
  final String itemId;
  final DocumentReference<Map<String, dynamic>> eventReference;
  final String name;
  final String description;
  final String imageUrl;
  final String itemType;
  final DateTime? acquiredAt;

  const _CollectedEventItem({
    required this.eventId,
    required this.itemId,
    required this.eventReference,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.itemType,
    required this.acquiredAt,
  });

  factory _CollectedEventItem.fromMap({
    required String eventId,
    required String itemId,
    required DocumentReference<Map<String, dynamic>> eventReference,
    required Map<String, dynamic> data,
  }) {
    DateTime? acquiredAt;
    final rawTime =
        data['acquiredAt'] ??
            data['redeemedAt'] ??
            data['ownedAt'] ??
            data['collectedAt'] ??
            data['createdAt'];

    if (rawTime is Timestamp) {
      acquiredAt = rawTime.toDate();
    } else if (rawTime is DateTime) {
      acquiredAt = rawTime;
    } else if (rawTime is String) {
      acquiredAt = DateTime.tryParse(rawTime);
    }

    return _CollectedEventItem(
      eventId: eventId,
      itemId: itemId,
      eventReference: eventReference,
      name: (data['name'] ?? '活動收藏').toString(),
      description: (data['description'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString().trim(),
      itemType: (data['itemType'] ?? '').toString().trim(),
      acquiredAt: acquiredAt,
    );
  }

  String get collectionDateLabel {
    final value = acquiredAt;
    if (value == null) return appL10n.event_memory_collection_collected_item_label_collection_date;

    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return appL10n.event_memory_collection_collected_item_label_collection(day, month, value.year);
  }
}

class _CollectionState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CollectionState({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                height: 1.6,
                color:
                theme.colorScheme.onSurface.withValues(alpha: 0.52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ImageProvider? _safeImageProvider(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  try {
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return CachedNetworkImageProvider(
        trimmed,
        maxWidth: 1600,
        maxHeight: 1600,
      );
    }

    return getAvatarImageProvider(trimmed);
  } catch (_) {
    return null;
  }
}

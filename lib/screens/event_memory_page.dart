import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import 'event_memory_character_select_page.dart';

class EventMemoryPage extends StatelessWidget {
  final String eventId;

  const EventMemoryPage({
    super.key,
    required this.eventId,
  });

  DocumentReference<Map<String, dynamic>> _eventRef() {
    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('events')
        .doc(eventId);
  }

  DocumentReference<Map<String, dynamic>>? _progressRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('event_progress')
        .doc(user.uid)
        .collection('events')
        .doc(eventId);
  }

  CollectionReference<Map<String, dynamic>> _memoriesRef() {
    return _eventRef().collection('memories');
  }

  CollectionReference<Map<String, dynamic>> _tasksRef() {
    return _eventRef().collection('tasks');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _eventRef().snapshots(),
      builder: (context, eventSnapshot) {
        if (!eventSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!eventSnapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('找不到活動資料')),
          );
        }

        final eventData = eventSnapshot.data!.data() ?? <String, dynamic>{};
        final visual = _MemoryVisual.fromEvent(context, eventData);
        final progressRef = _progressRef();

        if (progressRef == null) {
          return _buildPage(
            context,
            eventData: eventData,
            visual: visual,
            progressData: const <String, dynamic>{},
          );
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: progressRef.snapshots(),
          builder: (context, progressSnapshot) {
            return _buildPage(
              context,
              eventData: eventData,
              visual: visual,
              progressData: progressSnapshot.data?.data() ??
                  const <String, dynamic>{},
            );
          },
        );
      },
    );
  }

  Widget _buildPage(
      BuildContext context, {
        required Map<String, dynamic> eventData,
        required _MemoryVisual visual,
        required Map<String, dynamic> progressData,
      }) {
    final eventName = (eventData['name'] ?? '期間限定活動').toString();
    final currencyName = (eventData['currencyName'] ?? '活動貨幣').toString();
    final currencyIcon = (eventData['currencyIcon'] ?? '✦').toString();
    final heroUrl = (eventData['heroImageUrl'] ?? '').toString().trim();
    final decorationData = eventData['decorations'] is Map
        ? Map<String, dynamic>.from(eventData['decorations'] as Map)
        : <String, dynamic>{};
    final memoryCardImageUrl =
    (decorationData['memoryCardImageUrl'] ?? '').toString().trim();

    return Scaffold(
      backgroundColor: visual.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _MemoryAppBar(
              title: '限定回憶',
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _tasksRef().snapshots(),
                builder: (context, taskSnapshot) {
                  final taskTargets = <String, int>{};
                  for (final doc in taskSnapshot.data?.docs ??
                      <QueryDocumentSnapshot<Map<String, dynamic>>>[]) {
                    final data = doc.data();
                    final explicit = _intValue(data['target']);
                    if (explicit > 0) {
                      taskTargets[doc.id] = explicit;
                    } else {
                      final title = (data['title'] ?? '').toString();
                      final match = RegExp(r'(\d+)').firstMatch(title);
                      taskTargets[doc.id] =
                          int.tryParse(match?.group(1) ?? '') ?? 1;
                    }
                  }

                  final user = FirebaseAuth.instance.currentUser;

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: user == null
                        ? null
                        : FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('event_memories')
                        .snapshots(),
                    builder: (context, collectedSnapshot) {
                      final collectedMemoryIds = <String>{};

                      for (final collectedDoc
                      in collectedSnapshot.data?.docs ??
                          <QueryDocumentSnapshot<Map<String, dynamic>>>[]) {
                        final collectedData = collectedDoc.data();
                        final collectedEventId =
                        (collectedData['eventId'] ?? '').toString();
                        final collectedMemoryId =
                        (collectedData['memoryId'] ?? '').toString();

                        if (collectedEventId == eventId &&
                            collectedMemoryId.isNotEmpty) {
                          collectedMemoryIds.add(collectedMemoryId);
                        }
                      }

                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: _memoriesRef().orderBy('order').snapshots(),
                        builder: (context, memorySnapshot) {
                          if (memorySnapshot.connectionState ==
                              ConnectionState.waiting &&
                              !memorySnapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: visual.accent,
                                strokeWidth: 2.2,
                              ),
                            );
                          }

                          if (memorySnapshot.hasError) {
                            return Center(
                              child: Text(
                                '限定回憶讀取失敗',
                                style: GoogleFonts.notoSerifTc(),
                              ),
                            );
                          }

                          final memories = (memorySnapshot.data?.docs ?? [])
                              .where((doc) => doc.data()['isActive'] != false)
                              .toList();

                          final unlockedCount = memories.where((doc) {
                            final unlockState = _unlockState(
                              memoryData: doc.data(),
                              progressData: progressData,
                              taskTargets: taskTargets,
                            );
                            final status = _memoryStatus(
                              memoryId: doc.id,
                              unlockState: unlockState,
                              progressData: progressData,
                              collectedMemoryIds: collectedMemoryIds,
                            );
                            return status != _MemoryChapterStatus.locked;
                          }).length;

                          return CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                                sliver: SliverToBoxAdapter(
                                  child: _MemoryHero(
                                    eventName: eventName,
                                    heroImageUrl: memoryCardImageUrl.isNotEmpty
                                        ? memoryCardImageUrl
                                        : heroUrl,
                                    unlockedCount: unlockedCount,
                                    totalCount: memories.length,
                                    accent: visual.accent,
                                    accentSoft: visual.accentSoft,
                                  ),
                                ),
                              ),
                              if (memories.isEmpty)
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _EmptyMemoryState(
                                    accent: visual.accent,
                                  ),
                                )
                              else
                                SliverPadding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 36),
                                  sliver: SliverList.separated(
                                    itemCount: memories.length,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final doc = memories[index];
                                      final data = doc.data();
                                      final unlockState = _unlockState(
                                        memoryData: data,
                                        progressData: progressData,
                                        taskTargets: taskTargets,
                                      );
                                      final status = _memoryStatus(
                                        memoryId: doc.id,
                                        unlockState: unlockState,
                                        progressData: progressData,
                                        collectedMemoryIds: collectedMemoryIds,
                                      );

                                      return _MemoryChapterCard(
                                        index: index,
                                        total: memories.length,
                                        title: (data['title'] ?? '限定回憶').toString(),
                                        subtitle:
                                        (data['subtitle'] ?? '').toString(),
                                        coverImageUrl:
                                        (data['coverImageUrl'] ?? '').toString(),
                                        status: status,
                                        unlockLabel: unlockState.label(
                                          currencyName: currencyName,
                                          currencyIcon: currencyIcon,
                                        ),
                                        accent: visual.accent,
                                        accentSoft: visual.accentSoft,
                                        onTap: () {
                                          if (status == _MemoryChapterStatus.locked) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    unlockState.label(
                                                      currencyName: currencyName,
                                                      currencyIcon: currencyIcon,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            return;
                                          }

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EventMemoryCharacterSelectPage(
                                                    eventId: eventId,
                                                    memoryId: doc.id,
                                                    memoryTitle: (data['title'] ??
                                                        '限定回憶')
                                                        .toString(),
                                                  ),
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _MemoryChapterStatus _memoryStatus({
    required String memoryId,
    required _MemoryUnlockState unlockState,
    required Map<String, dynamic> progressData,
    required Set<String> collectedMemoryIds,
  }) {
    if (collectedMemoryIds.contains(memoryId)) {
      return _MemoryChapterStatus.collected;
    }

    final viewedMemories = _asMap(progressData['viewedMemories']);
    final viewedValue = viewedMemories[memoryId];
    final viewed = viewedValue == true ||
        viewedValue is Timestamp ||
        viewedValue is Map;

    if (viewed) {
      return _MemoryChapterStatus.viewed;
    }

    if (unlockState.unlocked) {
      return _MemoryChapterStatus.unlockedUnviewed;
    }

    return _MemoryChapterStatus.locked;
  }

  _MemoryUnlockState _unlockState({
    required Map<String, dynamic> memoryData,
    required Map<String, dynamic> progressData,
    required Map<String, int> taskTargets,
  }) {
    final unlockType = (memoryData['unlockType'] ?? 'free').toString();
    final unlockValue = _intValue(memoryData['unlockValue']);
    final targetId = (memoryData['unlockTargetId'] ?? '').toString().trim();

    switch (unlockType) {
      case 'total_earned':
        final totalEarned = _intValue(progressData['totalEarned']);
        return _MemoryUnlockState(
          unlocked: totalEarned >= unlockValue,
          type: unlockType,
          requiredValue: unlockValue,
          currentValue: totalEarned,
        );
      case 'task':
        final claimedTasks = _asMap(progressData['claimedTasks']);
        final taskProgress = _asMap(progressData['taskProgress']);
        final target = taskTargets[targetId] ?? 1;
        final current = _intValue(taskProgress[targetId]);
        final completed = claimedTasks[targetId] == true || current >= target;
        return _MemoryUnlockState(
          unlocked: targetId.isNotEmpty && completed,
          type: unlockType,
          targetId: targetId,
          requiredValue: target,
          currentValue: current,
        );
      case 'shop_item':
        final redeemed = _asMap(progressData['redeemedShopItems']);
        final count = _intValue(redeemed[targetId]);
        return _MemoryUnlockState(
          unlocked: targetId.isNotEmpty && count > 0,
          type: unlockType,
          targetId: targetId,
          requiredValue: 1,
          currentValue: count,
        );
      case 'free':
      default:
        return const _MemoryUnlockState(
          unlocked: true,
          type: 'free',
        );
    }
  }

  static int _intValue(dynamic raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  static Map<String, dynamic> _asMap(dynamic raw) {
    return raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
  }
}

class _MemoryUnlockState {
  final bool unlocked;
  final String type;
  final String targetId;
  final int requiredValue;
  final int currentValue;

  const _MemoryUnlockState({
    required this.unlocked,
    required this.type,
    this.targetId = '',
    this.requiredValue = 0,
    this.currentValue = 0,
  });

  String label({
    required String currencyName,
    required String currencyIcon,
  }) {
    if (unlocked) return '已解鎖';

    switch (type) {
      case 'total_earned':
        return '累積 $currencyIcon $requiredValue $currencyName 解鎖（$currentValue / $requiredValue）';
      case 'task':
        return '完成指定活動任務後解鎖';
      case 'shop_item':
        return '兌換指定活動商品後解鎖';
      default:
        return '尚未解鎖';
    }
  }
}

class _MemoryVisual {
  final Color accent;
  final Color accentSoft;
  final Color background;

  const _MemoryVisual({
    required this.accent,
    required this.accentSoft,
    required this.background,
  });

  factory _MemoryVisual.fromEvent(
      BuildContext context,
      Map<String, dynamic> data,
      ) {
    final theme = data['theme'] is Map
        ? Map<String, dynamic>.from(data['theme'] as Map)
        : <String, dynamic>{};
    final colors = Theme.of(context).colorScheme;

    final accent = _hex(theme['accentColor']) ?? colors.primary;
    final accentSoft = _hex(theme['accentColor2'] ??
        theme['accentColorLight']) ??
        Color.lerp(accent, Colors.white, 0.72)!;
    final background = _hex(theme['pageBackgroundColor'] ??
        theme['backgroundColor']) ??
        Color.lerp(colors.surface, accent, 0.035)!;

    return _MemoryVisual(
      accent: accent,
      accentSoft: accentSoft,
      background: background,
    );
  }

  static Color? _hex(dynamic raw) {
    final value = (raw ?? '').toString().trim().replaceAll('#', '');
    if (value.length != 6 && value.length != 8) return null;
    try {
      final number = int.parse(value, radix: 16);
      return Color(value.length == 6 ? 0xFF000000 | number : number);
    } catch (_) {
      return null;
    }
  }
}

class _MemoryAppBar extends StatelessWidget {
  final String title;

  const _MemoryAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoSerifTc(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoryHero extends StatelessWidget {
  final String eventName;
  final String heroImageUrl;
  final int unlockedCount;
  final int totalCount;
  final Color accent;
  final Color accentSoft;

  const _MemoryHero({
    required this.eventName,
    required this.heroImageUrl,
    required this.unlockedCount,
    required this.totalCount,
    required this.accent,
    required this.accentSoft,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = heroImageUrl.trim().isNotEmpty;
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: accentSoft.withValues(alpha: 0.55),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.09),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              CachedNetworkImage(
                imageUrl: heroImageUrl.trim(),
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: hasImage
                      ? [
                    Colors.black.withValues(alpha: 0.02),
                    Colors.black.withValues(alpha: 0.58),
                  ]
                      : [
                    accentSoft.withValues(alpha: 0.20),
                    Colors.white.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: hasImage ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '把只屬於你們的片段，留在這個季節裡。',
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11.5,
                      color: hasImage
                          ? Colors.white.withValues(alpha: 0.88)
                          : Colors.black.withValues(alpha: 0.52),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '限定回憶  $unlockedCount / $totalCount',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: accent,
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

enum _MemoryChapterStatus {
  locked,
  unlockedUnviewed,
  viewed,
  collected,
}

class _MemoryChapterCard extends StatelessWidget {
  final int index;
  final int total;
  final String title;
  final String subtitle;
  final String coverImageUrl;
  final _MemoryChapterStatus status;
  final String unlockLabel;
  final Color accent;
  final Color accentSoft;
  final VoidCallback onTap;

  const _MemoryChapterCard({
    required this.index,
    required this.total,
    required this.title,
    required this.subtitle,
    required this.coverImageUrl,
    required this.status,
    required this.unlockLabel,
    required this.accent,
    required this.accentSoft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final hasImage = coverImageUrl.trim().isNotEmpty;
    final unlocked = status != _MemoryChapterStatus.locked;

    String statusLabel() {
      switch (status) {
        case _MemoryChapterStatus.locked:
          return '尚未解鎖';
        case _MemoryChapterStatus.unlockedUnviewed:
          return '已解鎖・尚未觀看';
        case _MemoryChapterStatus.viewed:
          return '已觀看';
        case _MemoryChapterStatus.collected:
          return '已收藏';
      }
    }

    String footerLabel() {
      switch (status) {
        case _MemoryChapterStatus.locked:
          return unlockLabel;
        case _MemoryChapterStatus.unlockedUnviewed:
          return '可以開始這段回憶';
        case _MemoryChapterStatus.viewed:
          return '可以再次觀看';
        case _MemoryChapterStatus.collected:
          return '已收藏至拾光收藏';
      }
    }

    IconData trailingIcon() {
      switch (status) {
        case _MemoryChapterStatus.locked:
          return Icons.lock_outline_rounded;
        case _MemoryChapterStatus.unlockedUnviewed:
          return Icons.chevron_right_rounded;
        case _MemoryChapterStatus.viewed:
          return Icons.replay_rounded;
        case _MemoryChapterStatus.collected:
          return Icons.bookmark_added_rounded;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: accent.withValues(alpha: unlocked ? 0.15 : 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.055),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 112,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: accentSoft.withValues(alpha: 0.46),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (hasImage)
                          CachedNetworkImage(
                            imageUrl: coverImageUrl.trim(),
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                            const SizedBox.shrink(),
                          ),
                        if (!hasImage)
                          Icon(
                            Icons.collections_bookmark_outlined,
                            color: accent.withValues(alpha: 0.72),
                            size: 34,
                          ),
                        if (!unlocked)
                          ColoredBox(
                            color: Colors.black.withValues(alpha: 0.32),
                            child: const Center(
                              child: Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: SizedBox(
                    height: 112,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1} / $total',
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(
                                  alpha: status == _MemoryChapterStatus.collected
                                      ? 0.18
                                      : (unlocked ? 0.11 : 0.055),
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                statusLabel(),
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: unlocked
                                      ? accent
                                      : onSurface.withValues(alpha: 0.42),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: onSurface,
                          ),
                        ),
                        if (subtitle.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 10.5,
                              height: 1.45,
                              color: onSurface.withValues(alpha: 0.48),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                footerLabel(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 9.5,
                                  height: 1.35,
                                  color: unlocked
                                      ? accent
                                      : onSurface.withValues(alpha: 0.40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              trailingIcon(),
                              color: unlocked
                                  ? accent
                                  : onSurface.withValues(alpha: 0.28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyMemoryState extends StatelessWidget {
  final Color accent;

  const _EmptyMemoryState({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.collections_bookmark_outlined,
              size: 46,
              color: accent.withValues(alpha: 0.55),
            ),
            const SizedBox(height: 12),
            Text(
              '這次活動還沒有公開限定回憶',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.56),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
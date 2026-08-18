import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/app_constants.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class QixiEventPage extends StatefulWidget {
  const QixiEventPage({super.key});

  @override
  State<QixiEventPage> createState() => _QixiEventPageState();
}

class _QixiEventPageState extends State<QixiEventPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Map<String, Future<DocumentSnapshot<Map<String, dynamic>>>>
      _characterFutureCache = {};
  // 台灣時間：2026/8/19 00:00～2026/8/26 23:59。
  static final DateTime _eventStartUtc = DateTime.utc(2026, 8, 18, 16);

  static final DateTime _eventEndUtc = DateTime.utc(2026, 8, 26, 16);

  OverlayEntry? _pageToastEntry;
  Timer? _pageToastTimer;
  final Set<String> _savedCharacterIds = {};
  final Set<String> _pendingCharacterIds = {};

  bool _isLoadingProgress = true;
  bool _isSaving = false;

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  bool get _isEventActive {
    // Debug 測試版可以提前進入活動；
    // 正式發布版仍依照活動時間判斷。
    if (kDebugMode) return true;

    final nowUtc = DateTime.now().toUtc();

    return !nowUtc.isBefore(_eventStartUtc) &&
        nowUtc.isBefore(_eventEndUtc);
  }

  bool get _isBeforeEvent {
    if (kDebugMode) return false;

    return DateTime.now()
        .toUtc()
        .isBefore(_eventStartUtc);
  }
  String _qixiSessionId(
    String userId,
    String characterId,
  ) {
    return 'qixi_2026_${userId}_$characterId';
  }

  int get _selectedCount =>
      _savedCharacterIds.length + _pendingCharacterIds.length;

  DocumentReference<Map<String, dynamic>> get _eventRef {
    return _db
        .collection('users')
        .doc(_userId)
        .collection('events')
        .doc('qixi_2026');
  }

  @override
  void initState() {
    super.initState();
    _loadEventProgress();
  }

  void _removePageToast() {
    _pageToastTimer?.cancel();
    _pageToastTimer = null;

    _pageToastEntry?.remove();
    _pageToastEntry = null;
  }

  void _showPageToast(
    String message, {
    bool isError = false,
    IconData? icon,
  }) {
    if (!mounted) return;

    _removePageToast();

    final overlay = Overlay.of(context);

    _pageToastEntry = OverlayEntry(
      builder: (overlayContext) {
        final theme = Theme.of(overlayContext);

        return Positioned.fill(
          child: IgnorePointer(
            child: SafeArea(
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 320,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: isError
                          ? const Color(0xFF4A2634)
                          : theme.colorScheme.inverseSurface
                              .withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon ??
                              (isError
                                  ? Icons.error_outline_rounded
                                  : Icons.favorite_rounded),
                          color: isError
                              ? const Color(0xFFFFB4C7)
                              : const Color(0xFFFFA7C4),
                          size: 21,
                        ),
                        const SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onInverseSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_pageToastEntry!);

    _pageToastTimer = Timer(
      const Duration(seconds: 2),
      _removePageToast,
    );
  }

  @override
  void dispose() {
    _removePageToast();
    super.dispose();
  }

  Future<void> _loadEventProgress() async {
    final userId = _userId;

    if (userId == null) {
      if (mounted) {
        setState(() {
          _isLoadingProgress = false;
        });
      }
      return;
    }

    try {
      final eventDoc = await _eventRef.get();
      final data = eventDoc.data();

      final selectedIds = List<String>.from(
        data?['selectedCharacterIds'] ?? const <String>[],
      );

      if (!mounted) return;

      setState(() {
        _savedCharacterIds
          ..clear()
          ..addAll(selectedIds.take(3));

        _isLoadingProgress = false;
      });
    } catch (error) {
      debugPrint('讀取七夕活動進度失敗：$error');

      if (!mounted) return;

      setState(() {
        _isLoadingProgress = false;
      });
    }
  }

  void _toggleCharacter(String characterId) {
    if (!_isEventActive || _savedCharacterIds.contains(characterId)) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    if (_pendingCharacterIds.contains(characterId)) {
      setState(() {
        _pendingCharacterIds.remove(characterId);
      });
      return;
    }

    if (_selectedCount >= 3) {
      _showPageToast(
        l10n.qixiMaxThreeFriends,
        isError: true,
      );
      return;
    }

    setState(() {
      _pendingCharacterIds.add(characterId);
    });
  }

  Future<void> _confirmSelection() async {
    final userId = _userId;
    final l10n = AppLocalizations.of(context)!;

    if (userId == null) {
      _showPageToast(
        l10n.qixiLoginRequired,
        isError: true,
      );
      return;
    }

    if (!_isEventActive) {
      _showPageToast(
        l10n.qixiOutsideEventPeriod,
        isError: true,
      );
      return;
    }

    if (_pendingCharacterIds.isEmpty) {
      _showPageToast(
        l10n.qixiSelectAtLeastOne,
        isError: true,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // 先讀取待選角色的正式資料。
      final characterSnapshots = await Future.wait(
        _pendingCharacterIds.map(
          (characterId) => _db
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('public_characters')
              .doc(characterId)
              .get(),
        ),
      );

      final Map<String, Map<String, dynamic>> characterDataMap = {};

      for (final snapshot in characterSnapshots) {
        if (!snapshot.exists) continue;

        characterDataMap[snapshot.id] = snapshot.data() ?? <String, dynamic>{};
      }

      final pendingIds = _pendingCharacterIds.toList();

      final chatSessionsRef = _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('chat_sessions');

      final userCharactersRef =
          _db.collection('users').doc(userId).collection('characters');

      List<String> acceptedIds = [];

      await _db.runTransaction((transaction) async {
        final eventSnapshot = await transaction.get(_eventRef);
        final eventData = eventSnapshot.data();

        final existingIds = List<String>.from(
          eventData?['selectedCharacterIds'] ?? const <String>[],
        );

        final remainingSlots = 3 - existingIds.length;

        if (remainingSlots <= 0) {
          acceptedIds = [];
          return;
        }

        acceptedIds = pendingIds
            .where((id) => !existingIds.contains(id))
            .take(remainingSlots)
            .toList();

        if (acceptedIds.isEmpty) return;

        if (acceptedIds.isEmpty) return;

// Firestore Transaction 規定所有讀取必須先於寫入。
// 讀取玩家與各角色目前保存的全域最高好感度。
        final Map<String, int> globalAffectionMap = {};

        for (final characterId in acceptedIds) {
          final affectionSnapshot = await transaction.get(
            userCharactersRef.doc(characterId),
          );

          final affectionValue = affectionSnapshot.data()?['affection'];

          globalAffectionMap[characterId] =
              affectionValue is num ? affectionValue.toInt() : 0;
        }

        final updatedIds = <String>{
          ...existingIds,
          ...acceptedIds,
        }.take(3).toList();

        transaction.set(
          _eventRef,
          {
            'eventId': 'qixi_2026',
            'selectedCharacterIds': updatedIds,
            'completedCharacterIds':
                eventData?['completedCharacterIds'] ?? <String>[],
            'rewardedCharacterIds':
                eventData?['rewardedCharacterIds'] ?? <String>[],
            'updatedAt': FieldValue.serverTimestamp(),
            if (!eventSnapshot.exists)
              'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );

        for (final characterId in acceptedIds) {
          final roomId = _qixiSessionId(userId, characterId);
          final roomRef = chatSessionsRef.doc(roomId);

          final characterData =
              characterDataMap[characterId] ?? <String, dynamic>{};

          final characterName =
              (characterData['name'] as String?)?.trim() ?? l10n.qixiMysteryCharacter;

          final characterAvatarPath =
              (characterData['avatarPath'] as String?)?.trim() ?? '';

          final globalAffection = globalAffectionMap[characterId] ?? 0;

          final openingStory =
          l10n.qixiOpeningStory(characterName);

          final openingStoryRef =
              roomRef.collection('messages').doc('qixi_opening_story');

          transaction.set(
            roomRef,
            {
              'userId': userId,
              'characterId': characterId,
              'characterName': characterName,
              'characterAvatarPath': characterAvatarPath,

              // 聊天室基本資料。
              'chatMode': 'daily',
              'friendshipScore': globalAffection,
              'createdAt': FieldValue.serverTimestamp(),
              'lastMessage': l10n.qixiRoomOpenedLastMessage,
              'lastActivity': FieldValue.serverTimestamp(),
              'unreadCount': 0,

              // 七夕專屬資料。
              'isQixiRoom': true,
              'eventId': 'qixi_2026',
              'qixiYear': 2026,
              'qixiPinnedUntil': Timestamp.fromDate(
                DateTime.utc(2026, 8, 26, 16),
              ),
              'qixiInteractionDates': <String>[],
              'qixiLetterSent': false,
              'updatedAt': FieldValue.serverTimestamp(),
            },
          );
          transaction.set(
            openingStoryRef,
            {
              'sender': 'system',
              'text': openingStory,
              'type': 'text',
              'path': '',
              'timestamp': FieldValue.serverTimestamp(),
              'orderIndex': 0,
              'isQixiOpeningStory': true,
              'eventId': 'qixi_2026',
            },
          );
        }
      });

      if (!mounted) return;

      if (acceptedIds.isEmpty) {
        _showPageToast(
          l10n.qixiCompanionSlotsFull,
          isError: true,
        );
        return;
      }

      setState(() {
        _savedCharacterIds.addAll(acceptedIds);
        _pendingCharacterIds.removeAll(acceptedIds);
      });

      _showPageToast(
        acceptedIds.length == 1
            ? l10n.qixiSingleRoomOpened
            : l10n.qixiMultipleRoomsOpened(acceptedIds.length),
        icon: Icons.favorite_rounded,
      );
    } catch (error, stackTrace) {
      debugPrint('建立七夕聊天室失敗：$error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showPageToast(
        l10n.qixiCreateRoomFailed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildAvatar(String avatarPath) {
    if (avatarPath.startsWith('http://') || avatarPath.startsWith('https://')) {
      return Image.network(
        avatarPath,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.person_rounded, size: 30);
        },
      );
    }

    if (avatarPath.isNotEmpty) {
      return Image.asset(
        avatarPath,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.person_rounded, size: 30);
        },
      );
    }

    return const Icon(Icons.person_rounded, size: 30);
  }

  Widget _buildStatusCard(ThemeData theme) {
    String statusText;
    IconData statusIcon;
    final l10n = AppLocalizations.of(context)!;

    if (_isBeforeEvent) {
      statusText = l10n.qixiEventStartsAt;
      statusIcon = Icons.schedule_rounded;
    } else if (_isEventActive) {
      statusText = l10n.qixiEventActiveUntil;
      statusIcon = Icons.auto_awesome_rounded;
    } else {
      statusText = l10n.qixiEventEnded;
      statusIcon = Icons.event_busy_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFE4EE),
            Color(0xFFEDE3FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/love.png',
            width: 62,
            height: 62,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.qixiEventHeroTitle,
                  style: TextStyle(
                    color: Color(0xFF6D3F62),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 16,
                      color: const Color(0xFF765E72),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          color: Color(0xFF765E72),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendCard({
    required String characterId,
    required String name,
    required String avatarPath,
  }) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final isSaved = _savedCharacterIds.contains(characterId);
    final isPending = _pendingCharacterIds.contains(characterId);
    final isSelected = isSaved || isPending;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleCharacter(characterId),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFEDF4) : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFE596B7)
                  : theme.dividerColor.withValues(alpha: 0.3),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  width: 54,
                  height: 54,
                  color: const Color(0xFFF3EAF2),
                  child: _buildAvatar(avatarPath),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  name.isNotEmpty ? name : '神秘角色',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isSaved)
                Chip(
                  label: Text(l10n.qixiCharacterSelected),
                  visualDensity: VisualDensity.compact,
                )
              else
                Icon(
                  isPending
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isPending ? const Color(0xFFE56F9F) : Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendList() {
    final userId = _userId;
    final l10n = AppLocalizations.of(context)!;

    if (userId == null) {
      return  Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(l10n.qixiLoginRequired),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _db
          .collection('users')
          .doc(userId)
          .collection('friends')
          .orderBy('addedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return  Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(l10n.qixiFriendListLoadFailed),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final friends = snapshot.data!.docs;

        if (friends.isEmpty) {
          return  Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 46,
                    color: Color(0xFFC59AB4),
                  ),
                  SizedBox(height: 12),
                  Text(
                    l10n.qixiNoFriendCharacters,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(l10n.qixiNoFriendCharactersHint),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: friends.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final friendDoc = friends[index];
            final friendData = friendDoc.data();

            final characterId =
                (friendData['characterId'] as String?) ?? friendDoc.id;

            final savedName = (friendData['name'] as String?)?.trim() ?? '';

            final savedAvatarPath =
                (friendData['avatarPath'] as String?)?.trim() ?? '';

            // 新版好友資料已有名稱與頭像，直接顯示。
            if (savedName.isNotEmpty) {
              return _buildFriendCard(
                characterId: characterId,
                name: savedName,
                avatarPath: savedAvatarPath,
              );
            }

            // 舊版好友資料缺少角色名稱，回角色資料庫補讀。
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _characterFutureCache.putIfAbsent(
                characterId,
                () => _db
                    .collection('artifacts')
                    .doc(AppConfig.appId)
                    .collection('public_characters')
                    .doc(characterId)
                    .get(),
              ),
              builder: (context, characterSnapshot) {
                if (characterSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    height: 78,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 14),
                        Text(l10n.qixiLoadingCharacter),
                      ],
                    ),
                  );
                }

                final characterData = characterSnapshot.data?.data();

                final characterName =
                    (characterData?['name'] as String?)?.trim() ?? '神秘角色';

                final characterAvatarPath =
                    (characterData?['avatarPath'] as String?)?.trim() ??
                        savedAvatarPath;

                return _buildFriendCard(
                  characterId: characterId,
                  name: characterName,
                  avatarPath: characterAvatarPath,
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.qixiEventPageTitle),
      ),
      body: _isLoadingProgress
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusCard(theme),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                          l10n.qixiEventRules,
                          style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.72),
                          fontSize: 12,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.qixiSelectCompanions(_selectedCount),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.qixiSelectionLockedHint,
                      style: TextStyle(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.65),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildFriendList(),
                    const SizedBox(height: 24),
                    if (_isEventActive)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSaving || _pendingCharacterIds.isEmpty
                              ? null
                              : _confirmSelection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE56F9F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.qixiConfirmCompanions,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'event_memory_profile_confirm_page.dart';

class EventMemoryCharacterSelectPage extends StatefulWidget {
  final String eventId;
  final String memoryId;
  final String memoryTitle;

  const EventMemoryCharacterSelectPage({
    super.key,
    required this.eventId,
    required this.memoryId,
    required this.memoryTitle,
  });

  @override
  State<EventMemoryCharacterSelectPage> createState() =>
      _EventMemoryCharacterSelectPageState();
}

class _EventMemoryCharacterSelectPageState
    extends State<EventMemoryCharacterSelectPage> {
  bool _loading = true;
  String? _error;
  final List<_SelectableMemoryCharacter> _myCharacters = [];
  final List<_SelectableMemoryCharacter> _friendCharacters = [];
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  String _avatarFromData(Map<String, dynamic> data) {
    final galleryPaths = data['galleryPaths'];
    if (galleryPaths is List) {
      for (final item in galleryPaths) {
        final value = item?.toString().trim() ?? '';
        if (value.isNotEmpty) return value;
      }
    }

    final gallery = data['gallery'];
    if (gallery is List) {
      for (final item in gallery) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          final value = (map['imageUrl'] ?? map['url'] ?? '')
              .toString()
              .trim();
          if (value.isNotEmpty) return value;
        }
      }
    }

    return (data['avatarPath'] ?? '').toString().trim();
  }

  Future<void> _loadCharacters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '請先登入後再選擇角色';
        });
      }
      return;
    }

    try {
      final db = FirebaseFirestore.instance;
      final Map<String, _SelectableMemoryCharacter> mine = {};
      final Map<String, _SelectableMemoryCharacter> friends = {};

      // 1. 自己建立的公開角色
      final publicSnapshot = await db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .where('createdBy', isEqualTo: user.uid)
          .get();

      for (final doc in publicSnapshot.docs) {
        final data = doc.data();
        mine[doc.id] = _SelectableMemoryCharacter(
          id: doc.id,
          name: (data['name'] ?? '未命名角色').toString(),
          avatarPath: _avatarFromData(data),
          source: _CharacterSource.mine,
          isPrivate: false,
        );
      }

      // 2. 自己建立的私人角色
      final privateSnapshot = await db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(user.uid)
          .collection('private_characters')
          .get();

      for (final doc in privateSnapshot.docs) {
        final data = doc.data();
        mine[doc.id] = _SelectableMemoryCharacter(
          id: doc.id,
          name: (data['name'] ?? '未命名角色').toString(),
          avatarPath: _avatarFromData(data),
          source: _CharacterSource.mine,
          isPrivate: true,
        );
      }

      // 3. 已加好友角色。friends 文件 ID 就是角色 ID。
      final friendSnapshot = await db
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .get();

      for (final friendDoc in friendSnapshot.docs) {
        final characterId = friendDoc.id.trim();
        if (characterId.isEmpty || mine.containsKey(characterId)) continue;

        // 好友角色以目前公開角色文件為準；已刪除 / 已轉私人就略過。
        final publicDoc = await db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('public_characters')
            .doc(characterId)
            .get();

        if (!publicDoc.exists) continue;

        final data = publicDoc.data() ?? <String, dynamic>{};
        final friendData = friendDoc.data();
        friends[characterId] = _SelectableMemoryCharacter(
          id: characterId,
          name: (data['name'] ?? friendData['name'] ?? '未命名角色')
              .toString(),
          avatarPath: _avatarFromData(data).isNotEmpty
              ? _avatarFromData(data)
              : (friendData['avatarPath'] ?? '').toString().trim(),
          source: _CharacterSource.friend,
          isPrivate: false,
        );
      }

      final myList = mine.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      final friendList = friends.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      if (!mounted) return;
      setState(() {
        _myCharacters
          ..clear()
          ..addAll(myList);
        _friendCharacters
          ..clear()
          ..addAll(friendList);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '讀取角色失敗：$e';
      });
    }
  }

  _SelectableMemoryCharacter? get _selectedCharacter {
    final id = _selectedId;
    if (id == null) return null;
    for (final character in [..._myCharacters, ..._friendCharacters]) {
      if (character.id == id) return character;
    }
    return null;
  }

  void _continue() {
    final character = _selectedCharacter;
    if (character == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventMemoryProfileConfirmPage(
          eventId: widget.eventId,
          memoryId: widget.memoryId,
          memoryTitle: widget.memoryTitle,
          characterId: character.id,
          characterName: character.name,
          characterAvatarPath: character.avatarPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '選擇角色',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? _ErrorState(
                message: _error!,
                onRetry: () {
                  setState(() {
                    _loading = true;
                    _error = null;
                  });
                  _loadCharacters();
                },
              )
                  : RefreshIndicator(
                onRefresh: _loadCharacters,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding:
                      const EdgeInsets.fromLTRB(18, 10, 18, 4),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              '選擇想一起留下這段回憶的人',
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '只有你自己建立的角色，以及已加入好友的角色會出現在這裡。',
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 12,
                                height: 1.55,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.52),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                accent.withValues(alpha: 0.08),
                                borderRadius:
                                BorderRadius.circular(999),
                              ),
                              child: Text(
                                widget.memoryTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_myCharacters.isNotEmpty) ...[
                      _SectionHeader(
                        title: '我的角色',
                        count: _myCharacters.length,
                        icon: Icons.auto_awesome_rounded,
                      ),
                      _CharacterGrid(
                        characters: _myCharacters,
                        selectedId: _selectedId,
                        onSelected: (character) {
                          setState(() => _selectedId = character.id);
                        },
                      ),
                    ],
                    if (_friendCharacters.isNotEmpty) ...[
                      _SectionHeader(
                        title: '好友角色',
                        count: _friendCharacters.length,
                        icon: Icons.favorite_border_rounded,
                      ),
                      _CharacterGrid(
                        characters: _friendCharacters,
                        selectedId: _selectedId,
                        onSelected: (character) {
                          setState(() => _selectedId = character.id);
                        },
                      ),
                    ],
                    if (_myCharacters.isEmpty &&
                        _friendCharacters.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_outline_rounded,
                                  size: 48,
                                  color: accent.withValues(alpha: 0.45),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '目前沒有可以選擇的角色',
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '建立自己的角色，或先將喜歡的公開角色加入好友。',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 12,
                                    height: 1.55,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.48),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                  ],
                ),
              ),
            ),
            if (!_loading && _error == null)
              Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  12 + MediaQuery.paddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _selectedCharacter == null ? null : _continue,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      _selectedCharacter == null
                          ? '請先選擇角色'
                          : '與 ${_selectedCharacter!.name} 繼續',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _CharacterSource { mine, friend }

class _SelectableMemoryCharacter {
  final String id;
  final String name;
  final String avatarPath;
  final _CharacterSource source;
  final bool isPrivate;

  const _SelectableMemoryCharacter({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.source,
    required this.isPrivate,
  });
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Icon(icon, size: 19, color: theme.colorScheme.primary),
            const SizedBox(width: 7),
            Text(
              title,
              style: GoogleFonts.notoSerifTc(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '$count',
              style: GoogleFonts.notoSerifTc(
                fontSize: 11,
                color:
                theme.colorScheme.onSurface.withValues(alpha: 0.38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  final List<_SelectableMemoryCharacter> characters;
  final String? selectedId;
  final ValueChanged<_SelectableMemoryCharacter> onSelected;

  const _CharacterGrid({
    required this.characters,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final character = characters[index];
            return _CharacterCard(
              character: character,
              selected: selectedId == character.id,
              onTap: () => onSelected(character),
            );
          },
          childCount: characters.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          // 固定卡片高度，避免系統字體放大時名稱／標籤把 Column 撐爆。
          // 先前使用 childAspectRatio: 0.76，在 1.15x 字級下會 overflow。
          mainAxisExtent: 150,
        ),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final _SelectableMemoryCharacter character;
  final bool selected;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 9),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.70)
                  : theme.colorScheme.outlineVariant,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: accent.withValues(alpha: 0.11),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ]
                : null,
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _Avatar(
                    avatarPath: character.avatarPath,
                    size: 66,
                  ),
                  if (selected)
                    Positioned(
                      right: -3,
                      bottom: -2,
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                character.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  character.source == _CharacterSource.friend
                      ? '好友'
                      : character.isPrivate
                      ? '我的・私人'
                      : '我的角色',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 8.5,
                    color: accent,
                    fontWeight: FontWeight.w600,
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

class _Avatar extends StatelessWidget {
  final String avatarPath;
  final double size;

  const _Avatar({
    required this.avatarPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmed = avatarPath.trim();
    ImageProvider? provider;

    if (trimmed.isNotEmpty) {
      try {
        provider = getAvatarImageProvider(trimmed);
      } catch (_) {
        provider = null;
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.secondaryContainer,
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        image: provider == null
            ? null
            : DecorationImage(
          image: provider,
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: provider == null
          ? Icon(
        Icons.person_rounded,
        size: size * 0.43,
        color: theme.colorScheme.onSecondaryContainer,
      )
          : null,
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 42),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('重新讀取'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'event_memory_profile_confirm_page.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

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
  _CharacterSelectVisual _visual = const _CharacterSelectVisual();
  final List<_SelectableMemoryCharacter> _myCharacters = [];
  final List<_SelectableMemoryCharacter> _friendCharacters = [];
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _loadEventVisual();
    _loadCharacters();
  }

  Future<void> _loadEventVisual() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('events')
          .doc(widget.eventId)
          .get();
      if (!mounted || !doc.exists) return;
      setState(() {
        _visual = _CharacterSelectVisual.fromEvent(
          doc.data() ?? <String, dynamic>{},
        );
      });
    } catch (_) {
      // 配色讀取失敗時保留安全預設，不影響角色選擇流程。
    }
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
          _error = appL10n.event_memory_character_load_characters_message_login_character_select;
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
    final visual = _visual;
    final accent = visual.accent;

    return Scaffold(
      backgroundColor: visual.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: visual.background,
        foregroundColor: visual.textPrimaryColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '選擇角色',
          style: GoogleFonts.notoSerifTc(
            fontWeight: FontWeight.w700,
            color: visual.textPrimaryColor,
          ),
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
                              appL10n.event_memory_character_center_message_memory_select,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: visual.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              appL10n.event_memory_character_center_message_character_friend_add,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 12,
                                height: 1.55,
                                color: visual.textSecondaryColor,
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
                        visual: visual,
                      ),
                      _CharacterGrid(
                        characters: _myCharacters,
                        selectedId: _selectedId,
                        visual: visual,
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
                        visual: visual,
                      ),
                      _CharacterGrid(
                        characters: _friendCharacters,
                        selectedId: _selectedId,
                        visual: visual,
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
                                  appL10n.event_memory_character_center_message_current_character_select,
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: visual.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  appL10n.event_memory_character_center_message_public_character_character_friend_add,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 12,
                                    height: 1.55,
                                    color: visual.textMutedColor,
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
                  color: visual.cardColor,
                  border: Border(
                    top: BorderSide(
                      color: visual.accent.withValues(alpha: 0.16),
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
                          ? appL10n.event_memory_character_message_character_select
                          : appL10n.event_memory_character_message_continue(_selectedCharacter!.name),
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


class _CharacterSelectVisual {
  final Color accent;
  final Color background;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;

  const _CharacterSelectVisual({
    this.accent = const Color(0xFF8D6CC4),
    this.background = const Color(0xFFFBF8FF),
    this.cardColor = const Color(0xFFFFFFFF),
    this.textPrimaryColor = const Color(0xFF3B3340),
    this.textSecondaryColor = const Color(0xFF6F6673),
    this.textMutedColor = const Color(0xFF948A98),
  });

  factory _CharacterSelectVisual.fromEvent(Map<String, dynamic> data) {
    final theme = data['theme'] is Map
        ? Map<String, dynamic>.from(data['theme'] as Map)
        : <String, dynamic>{};
    return _CharacterSelectVisual(
      accent: _hex(theme['accentColor']) ?? const Color(0xFF8D6CC4),
      background: _hex(theme['pageBackgroundColor'] ?? theme['backgroundColor']) ??
          const Color(0xFFFBF8FF),
      cardColor: _hex(theme['cardColor']) ?? const Color(0xFFFFFFFF),
      textPrimaryColor: _hex(theme['textPrimaryColor']) ?? const Color(0xFF3B3340),
      textSecondaryColor: _hex(theme['textSecondaryColor']) ?? const Color(0xFF6F6673),
      textMutedColor: _hex(theme['textMutedColor']) ?? const Color(0xFF948A98),
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
  final _CharacterSelectVisual visual;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.icon,
    this.visual = const _CharacterSelectVisual(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 10),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Icon(icon, size: 19, color: visual.accent),
            const SizedBox(width: 7),
            Text(
              title,
              style: GoogleFonts.notoSerifTc(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: visual.textPrimaryColor,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '$count',
              style: GoogleFonts.notoSerifTc(
                fontSize: 11,
                color: visual.textMutedColor,
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
  final _CharacterSelectVisual visual;
  final ValueChanged<_SelectableMemoryCharacter> onSelected;

  const _CharacterGrid({
    required this.characters,
    required this.selectedId,
    this.visual = const _CharacterSelectVisual(),
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
              visual: visual,
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
  final _CharacterSelectVisual visual;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.selected,
    this.visual = const _CharacterSelectVisual(),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = visual.accent;

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
                : visual.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: 0.70)
                  : visual.accent.withValues(alpha: 0.16),
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
                    accent: visual.accent,
                    cardColor: visual.cardColor,
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
                            color: visual.cardColor,
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
                  color: visual.textPrimaryColor,
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
                      ? appL10n.event_memory_character_card_message_private
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
  final Color accent;
  final Color cardColor;

  const _Avatar({
    required this.avatarPath,
    required this.size,
    this.accent = const Color(0xFF8D6CC4),
    this.cardColor = const Color(0xFFFFFFFF),
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
        color: accent.withValues(alpha: 0.12),
        border: Border.all(
          color: accent.withValues(alpha: 0.18),
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
        color: accent,
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
              label: Text(appL10n.event_memory_character_error_label_load_again),
            ),
          ],
        ),
      ),
    );
  }
}
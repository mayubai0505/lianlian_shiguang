import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'event_memory_performance_page.dart';

class EventMemoryProfileConfirmPage extends StatefulWidget {
  final String eventId;
  final String memoryId;
  final String memoryTitle;
  final String characterId;
  final String characterName;
  final String characterAvatarPath;

  const EventMemoryProfileConfirmPage({
    super.key,
    required this.eventId,
    required this.memoryId,
    required this.memoryTitle,
    required this.characterId,
    required this.characterName,
    required this.characterAvatarPath,
  });

  @override
  State<EventMemoryProfileConfirmPage> createState() =>
      _EventMemoryProfileConfirmPageState();
}

class _EventMemoryProfileConfirmPageState
    extends State<EventMemoryProfileConfirmPage> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic>? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Timestamp? _asTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    return null;
  }

  Future<void> _loadProfiles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '請先登入';
        });
      }
      return;
    }

    try {
      final db = FirebaseFirestore.instance;
      final userDoc = await db.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? <String, dynamic>{};

      final nickname = (data['nickname'] ?? '你').toString().trim();
      final birthday = (data['birthday'] ?? '').toString().trim();

      final List<Map<String, dynamic>> profiles = [
        {
          'id': 'default',
          'profileName': '基礎檔案',
          'name': nickname.isEmpty ? '你' : nickname,
          'birthday': birthday,
          '_isDefault': true,
        },
      ];

      final rawProfiles = data['profiles'];
      if (rawProfiles is List) {
        for (final raw in rawProfiles) {
          if (raw is! Map) continue;
          final profile = Map<String, dynamic>.from(raw);
          final id = (profile['id'] ?? '').toString().trim();
          if (id.isEmpty || id == 'default') continue;
          profiles.add(profile);
        }
      }

      String preferredProfileId = '';

      // 優先找這個角色最近使用過的聊天室 Profile。
      // 只用 userId 查詢，再在前端篩 characterId，避免額外複合索引。
      try {
        final sessions = await db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('chat_sessions')
            .where('userId', isEqualTo: user.uid)
            .limit(80)
            .get();

        final matching = sessions.docs.where((doc) {
          final session = doc.data();
          return (session['characterId'] ?? '').toString().trim() ==
              widget.characterId;
        }).toList();

        matching.sort((a, b) {
          final aData = a.data();
          final bData = b.data();
          final aTime = _asTimestamp(aData['updatedAt']) ??
              _asTimestamp(aData['createdAt']);
          final bTime = _asTimestamp(bData['updatedAt']) ??
              _asTimestamp(bData['createdAt']);
          return (bTime?.millisecondsSinceEpoch ?? 0)
              .compareTo(aTime?.millisecondsSinceEpoch ?? 0);
        });

        for (final doc in matching) {
          final id =
          (doc.data()['playerProfileId'] ?? '').toString().trim();
          if (id.isNotEmpty) {
            preferredProfileId = id;
            break;
          }
        }
      } catch (e) {
        debugPrint('⚠️ 限定回憶讀取最近聊天室 Profile 失敗：$e');
      }

      // 再相容既有 draft 綁定。
      if (preferredProfileId.isEmpty) {
        final roomProfiles = data['roomProfiles'];
        if (roomProfiles is Map) {
          preferredProfileId =
              (roomProfiles['draft_${widget.characterId}'] ?? '')
                  .toString()
                  .trim();
        }
      }

      Map<String, dynamic>? selected;
      if (preferredProfileId.isNotEmpty) {
        for (final profile in profiles) {
          if ((profile['id'] ?? '').toString() == preferredProfileId) {
            selected = profile;
            break;
          }
        }
      }
      selected ??= profiles.first;

      if (!mounted) return;
      setState(() {
        _profiles = profiles;
        _selectedProfile = selected;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '讀取拾光檔案失敗：$e';
      });
    }
  }

  String _profileDisplayName(Map<String, dynamic> profile) {
    final name = (profile['name'] ?? '').toString().trim();
    if (name.isNotEmpty) return name;
    final profileName = (profile['profileName'] ?? '').toString().trim();
    return profileName.isNotEmpty ? profileName : '你';
  }

  String _profileLabel(Map<String, dynamic> profile) {
    final label = (profile['profileName'] ?? '').toString().trim();
    return label.isNotEmpty ? label : '拾光檔案';
  }

  Future<void> _changeProfile() async {
    if (_profiles.isEmpty) return;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
          ),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '更換拾光檔案',
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  itemCount: _profiles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, index) {
                    final profile = _profiles[index];
                    final selected =
                        (profile['id'] ?? '').toString() ==
                            (_selectedProfile?['id'] ?? '').toString();

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      tileColor: selected
                          ? theme.colorScheme.primary.withValues(alpha: 0.08)
                          : null,
                      leading: CircleAvatar(
                        backgroundColor:
                        theme.colorScheme.secondaryContainer,
                        child: Text(
                          _profileDisplayName(profile).isNotEmpty
                              ? _profileDisplayName(profile)[0]
                              : '你',
                        ),
                      ),
                      title: Text(
                        _profileDisplayName(profile),
                        style: GoogleFonts.notoSerifTc(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        _profileLabel(profile),
                        style: GoogleFonts.notoSerifTc(fontSize: 11),
                      ),
                      trailing: selected
                          ? Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                      onTap: () => Navigator.of(sheetContext).pop(profile),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _selectedProfile = result);
    }
  }

  void _startMemory() {
    final profile = _selectedProfile;
    if (profile == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventMemoryPerformancePage(
          eventId: widget.eventId,
          memoryId: widget.memoryId,
          memoryTitle: widget.memoryTitle,
          characterId: widget.characterId,
          characterName: widget.characterName,
          characterAvatarPath: widget.characterAvatarPath,
          playerProfileId: (profile['id'] ?? 'default').toString(),
          playerName: _profileDisplayName(profile),
          playerProfileName: _profileLabel(profile),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = _selectedProfile;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '確認拾光檔案',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!),
          ),
        )
            : profile == null
            ? const Center(child: Text('找不到可使用的拾光檔案'))
            : ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            Text(
              '這段回憶，會以誰的身分留下？',
              style: GoogleFonts.notoSerifTc(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '已優先使用你與這個角色最近使用的拾光檔案，也可以在開始前更換。',
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                height: 1.6,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.52),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MemoryAvatar(
                        path: widget.characterAvatarPath,
                        size: 74,
                      ),
                      Transform.translate(
                        offset: const Offset(-4, 0),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                              theme.colorScheme.outlineVariant,
                            ),
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor:
                          theme.colorScheme.primary
                              .withValues(alpha: 0.10),
                          child: Text(
                            _profileDisplayName(profile).isNotEmpty
                                ? _profileDisplayName(profile)[0]
                                : '你',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    '將以「${_profileDisplayName(profile)}」與'
                        '「${widget.characterName}」留下這段回憶',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '《${widget.memoryTitle}》',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _profileLabel(profile),
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 10.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _changeProfile,
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text('更換拾光檔案'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _startMemory,
              icon: const Icon(Icons.auto_stories_rounded),
              label: const Text('開始回憶'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryAvatar extends StatelessWidget {
  final String path;
  final double size;

  const _MemoryAvatar({
    required this.path,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    final value = path.trim();
    if (value.isNotEmpty) {
      try {
        provider = getAvatarImageProvider(value);
      } catch (_) {}
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondaryContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        image: provider == null
            ? null
            : DecorationImage(image: provider, fit: BoxFit.cover),
      ),
      child: provider == null
          ? const Icon(Icons.person_rounded)
          : null,
    );
  }
}

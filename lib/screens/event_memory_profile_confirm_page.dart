import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'event_memory_performance_page.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

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
  _ProfileConfirmVisual _visual = const _ProfileConfirmVisual();
  List<Map<String, dynamic>> _profiles = [];
  Map<String, dynamic>? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadEventVisual();
    _loadProfiles();
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
        _visual = _ProfileConfirmVisual.fromEvent(
          doc.data() ?? <String, dynamic>{},
        );
      });
    } catch (_) {
      // 活動配色讀取失敗時保留安全預設，不影響流程。
    }
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
        final visual = _visual;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
          ),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: visual.cardColor,
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
                  color: visual.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    appL10n.event_memory_profile_change_profile_message_profile,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: visual.textPrimaryColor,
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
                          ? visual.accent.withValues(alpha: 0.08)
                          : null,
                      leading: CircleAvatar(
                        backgroundColor:
                        visual.accent.withValues(alpha: 0.12),
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
                        color: visual.accent,
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
    final visual = _visual;
    final profile = _selectedProfile;

    return Scaffold(
      backgroundColor: visual.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: visual.background,
        foregroundColor: visual.textPrimaryColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          appL10n.event_memory_profile_message_profile_confirm,
          style: GoogleFonts.notoSerifTc(
            fontWeight: FontWeight.w700,
            color: visual.textPrimaryColor,
          ),
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
            ? Center(child: Text(appL10n.event_memory_profile_center_text_profile_not_found))
            : ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            Text(
              appL10n.event_memory_profile_center_message_memory,
              style: GoogleFonts.notoSerifTc(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: visual.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              appL10n.event_memory_profile_center_message_profile_character_start,
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                height: 1.6,
                color: visual.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: visual.cardColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: visual.accent.withValues(alpha: 0.16),
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
                        accent: visual.accent,
                      ),
                      Transform.translate(
                        offset: const Offset(-4, 0),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: visual.cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: visual.accent.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: visual.accent,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-8, 0),
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor:
                          visual.accent.withValues(alpha: 0.10),
                          child: Text(
                            _profileDisplayName(profile).isNotEmpty
                                ? _profileDisplayName(profile)[0]
                                : '你',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: visual.accent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    appL10n.event_memory_profile_center_message(_profileDisplayName(profile)) +
                        appL10n.event_memory_profile_center_message_memory_variant_b(widget.characterName),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w700,
                      color: visual.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '《${widget.memoryTitle}》',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 12,
                      color: visual.accent,
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
                      color: visual.accent.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _profileLabel(profile),
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 10.5,
                        color: visual.accent,
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
              label: Text(appL10n.event_memory_profile_center_label_memory_start),
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


class _ProfileConfirmVisual {
  final Color accent;
  final Color background;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;

  const _ProfileConfirmVisual({
    this.accent = const Color(0xFF8D6CC4),
    this.background = const Color(0xFFFBF8FF),
    this.cardColor = const Color(0xFFFFFFFF),
    this.textPrimaryColor = const Color(0xFF3B3340),
    this.textSecondaryColor = const Color(0xFF6F6673),
    this.textMutedColor = const Color(0xFF948A98),
  });

  factory _ProfileConfirmVisual.fromEvent(Map<String, dynamic> data) {
    final theme = data['theme'] is Map
        ? Map<String, dynamic>.from(data['theme'] as Map)
        : <String, dynamic>{};
    return _ProfileConfirmVisual(
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

class _MemoryAvatar extends StatelessWidget {
  final String path;
  final double size;
  final Color accent;

  const _MemoryAvatar({
    required this.path,
    required this.size,
    this.accent = const Color(0xFF8D6CC4),
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
        color: accent.withValues(alpha: 0.12),
        border: Border.all(
          color: accent.withValues(alpha: 0.18),
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
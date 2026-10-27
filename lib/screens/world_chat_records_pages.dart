import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/image_utils.dart';

// These pages intentionally consume only the current player's loaded world data.
// They do not write to the world creator's Firestore documents.
class WorldChatRecordsPage extends StatelessWidget {
  const WorldChatRecordsPage({
    super.key,
    required this.worldName,
    required this.entries,
    required this.loadedMessageCount,
  });
  final String worldName;
  final List<Map<String, String>> entries;
  final int loadedMessageCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world_records_summary_title1, style: GoogleFonts.notoSerifTc(fontSize: 17)), centerTitle: true),
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(worldName, style: GoogleFonts.notoSerifTc(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.world_records_loaded_count1(loadedMessageCount),
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context)!.world_records_auto_summary_pending1,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
          ]),
        ),
        const Divider(height: 20),
        Expanded(child: entries.isEmpty
            ? Center(child: Text(AppLocalizations.of(context)!.world_records_empty_story1))
            : ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
          itemCount: entries.length,
          separatorBuilder: (_, __) => const SizedBox(height: 7),
          itemBuilder: (context, index) {
            final entry = entries[index];
            final speaker = entry['speaker'] ?? AppLocalizations.of(context)!.world_records_narrator_name1;
            final description = entry['text'] ?? '';
            return Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(padding: const EdgeInsets.all(12), child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SpeakerAvatar(path: entry['avatar'] ?? '', isNarrator: entry['kind'] == 'narrator'),
                  const SizedBox(width: 11),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(speaker, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                      Text('${index + 1}', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
                    ]),
                    const SizedBox(height: 5),
                    SelectableText(description, style: const TextStyle(height: 1.6, fontSize: 13)),
                  ])),
                ],
              )),
            );
          },
        )),
      ])),
    );
  }
}

class WorldRelationshipEntry {
  const WorldRelationshipEntry({required this.id, required this.name, required this.avatar, required this.score});
  final String id;
  final String name;
  final String avatar;
  final int score;
}

class WorldChatRelationshipsPage extends StatelessWidget {
  const WorldChatRelationshipsPage({super.key, required this.worldName, required this.characters});
  final String worldName;
  final List<WorldRelationshipEntry> characters;

  int _stage(int s) {
    if (s < 60) return 1;
    if (s < 150) return 2;
    if (s < 550) return 3;
    if (s < 1720) return 4;
    if (s < 2430) return 5;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world_records_relationships_title1, style: GoogleFonts.notoSerifTc(fontSize: 17)), centerTitle: true),
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Align(
          alignment: Alignment.centerLeft,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(worldName, style: GoogleFonts.notoSerifTc(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 7),
            Text(AppLocalizations.of(context)!.world_records_affinity_note1,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
          ]),
        )),
        Expanded(child: characters.isEmpty ? Center(child: Text(AppLocalizations.of(context)!.world_records_empty_characters1))
            : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final person = characters[index];
            final stage = _stage(person.score);
            final next = [60, 150, 550, 1720, 2430][(stage - 1).clamp(0, 4)];
            return Card(elevation: 0, color: theme.colorScheme.surfaceContainerLow, child:
            Padding(padding: const EdgeInsets.all(14), child: Row(children: [
              _SpeakerAvatar(path: person.avatar, size: 54),
              const SizedBox(width: 13),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(person.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 5),
                Text(stage < 6 ? AppLocalizations.of(context)!.world_records_affinity_score_with_next1(person.score, next) : AppLocalizations.of(context)!.world_records_affinity_score_only1(person.score), style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 5),
                Text(AppLocalizations.of(context)!.world_records_relationship_stage1(stage), style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              ])),
              Image.asset('assets/images/affection/affection_stage_$stage.png', width: 28, height: 28,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ])),
            );
          },
        )),
      ])),
    );
  }
}

class WorldChatMemoPage extends StatefulWidget {
  const WorldChatMemoPage({super.key, required this.worldId, required this.worldName, required this.userId});
  final String worldId;
  final String worldName;
  final String userId;
  @override
  State<WorldChatMemoPage> createState() => _WorldChatMemoPageState();
}

class _WorldChatMemoPageState extends State<WorldChatMemoPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  bool _changed = false;
  String get _key => 'world_private_memo_v1_${widget.userId}_${widget.worldId}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      _controller.text = prefs.getString(_key) ?? '';
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.world_records_local_memo_read_failed1)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<bool> _save() async {
    if (_saving) return false;
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_key, _controller.text);
      if (!mounted) return success;
      if (success) setState(() => _changed = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? AppLocalizations.of(context)!.world_records_memo_saved_local1 : AppLocalizations.of(context)!.world_records_memo_save_failed1)));
      return success;
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.world_records_memo_save_failed1)));
      return false;
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: !_changed,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldSave = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.world_records_memo_unsaved1 ),
          content: Text(AppLocalizations.of(context)!.world_records_memo_save_before_exit1),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(AppLocalizations.of(context)!.world_records_continue_editing1)),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(AppLocalizations.of(context)!.world_records_save_and_exit1)),
          ],
        ));
        if (shouldSave == true) {
          final saved = await _save();
          if (saved && mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.world_records_world_memo_title1, style: GoogleFonts.notoSerifTc(fontSize: 17)), centerTitle: true,
            actions: [TextButton(onPressed: (_loading || _saving) ? null : _save, child: Text(AppLocalizations.of(context)!.world_records_save1))]),
        body: _loading ? const Center(child: CircularProgressIndicator()) : SafeArea(child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.worldName, style: GoogleFonts.notoSerifTc(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.world_records_memo_local_disclaimer1,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 14),
            Expanded(child: TextField(
              controller: _controller,
              expands: true,
              maxLines: null,
              minLines: null,
              maxLength: 5000,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.world_records_memo_hint1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                contentPadding: const EdgeInsets.all(15),
              ),
              onChanged: (_) { if (!_changed) setState(() => _changed = true); },
            )),
          ]),
        )),
      ),
    );
  }
}

class _SpeakerAvatar extends StatelessWidget {
  const _SpeakerAvatar({required this.path, this.size = 40, this.isNarrator = false});
  final String path;
  final double size;
  final bool isNarrator;
  @override
  Widget build(BuildContext context) {
    if (isNarrator) return SizedBox(width: size, height: size, child: Center(child: Text(AppLocalizations.of(context)!.world_records_narrator_short1,
        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))));
    return ClipOval(child: SizedBox(width: size, height: size,
      child: path.trim().isEmpty
          ? ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest)
          : Image(image: getAvatarImageProvider(path), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest)),
    ));
  }
}


/// 世界觀專屬、伺服器端可信摘要；絕不由前端上傳「自稱已發生」的對話。
class WorldStorySummaryPage extends StatefulWidget {
  const WorldStorySummaryPage({super.key, required this.worldId, required this.worldName});
  final String worldId;
  final String worldName;
  @override
  State<WorldStorySummaryPage> createState() => _WorldStorySummaryPageState();
}

class _WorldStorySummaryPageState extends State<WorldStorySummaryPage> {
  bool _loading = true;
  String _summary = '';
  String? _error;
  late final HttpsCallable _api = FirebaseFunctions.instanceFor(region: 'asia-east1')
      .httpsCallable('worldStoryMemory', options: HttpsCallableOptions(timeout: const Duration(seconds: 120)));

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final result = await _api.call(<String, dynamic>{'worldId': widget.worldId, 'action': 'load'});
      if (!mounted) return;
      final data = Map<String, dynamic>.from(result.data as Map);
      setState(() {
        _summary = (data['summary'] ?? '').toString();
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _loading = false; _error = e is FirebaseFunctionsException && e.code == 'not-found' ? AppLocalizations.of(context)!.world_records_summary_service_missing1 : AppLocalizations.of(context)!.world_records_summary_load_failed1; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world_records_summary_title1, style: GoogleFonts.notoSerifTc(fontSize: 17)), centerTitle: true),
      body: SafeArea(child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(20), children: [
        Text(widget.worldName, style: GoogleFonts.notoSerifTc(fontSize: 21, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Text(AppLocalizations.of(context)!.world_records_summary_intro1,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, height: 1.5)),
        const SizedBox(height: 18),
        Card(elevation: 0, color: theme.colorScheme.surfaceContainerLow,
            child: Padding(padding: const EdgeInsets.all(18), child: SelectableText(
                _summary.isEmpty ? AppLocalizations.of(context)!.world_records_summary_empty1 : _summary,
                style: GoogleFonts.notoSerifTc(fontSize: 14, height: 1.9)))),
        const SizedBox(height: 18),
        if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 12),
            child: Text(_error!, style: TextStyle(color: theme.colorScheme.error))),
      ])),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/app_constants.dart';

/// 世界觀劇場：提供創作者已設定的開場文字或玩家自訂場景。
/// 不寫入一般角色 ScenePage 所使用的 rooms 結構。
class WorldScenePage extends StatefulWidget {
  const WorldScenePage({super.key, required this.worldId, required this.worldName, required this.characters});
  final String worldId;
  final String worldName;
  final Map<String, String> characters;

  @override
  State<WorldScenePage> createState() => _WorldScenePageState();
}

class _WorldScenePageState extends State<WorldScenePage> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  List<Map<String, String>> _creatorScenes = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('artifacts')
          .doc(AppConfig.appId).collection('worlds').doc(widget.worldId).get();
      final data = snap.data() ?? <String, dynamic>{};
      final scenes = <Map<String, String>>[];
      // Only consume an explicitly defined world-scenes array when present.
      for (final raw in (data['scenes'] as List? ?? const [])) {
        if (raw is! Map) continue;
        final title = (raw['title'] ?? raw['name'] ?? '').toString().trim();
        final description = (raw['description'] ?? raw['opening'] ?? '').toString().trim();
        if (title.isNotEmpty && description.isNotEmpty) {
          scenes.add({'title': title, 'description': description});
        }
      }
      if (mounted) setState(() => _creatorScenes = scenes);
    } catch (e) {
      debugPrint('世界觀創作者劇場清單暫時無法讀取：$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() { _title.dispose(); _description.dispose(); super.dispose(); }

  void _start(String title, String description) {
    if (title.trim().isEmpty || description.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.world_scene_required1)));
      return;
    }
    // 目前透過世界觀 AI 的 send 管線啟動場景，不偽稱已儲存獨立劇場狀態。
    Navigator.pop(context, '【世界觀劇場：${title.trim()}】\n'
        '場景：${description.trim()}\n'
        '（請讓世界觀中適合出場的角色依既有人設自然展開此場景；'
        '玩家的選擇、心理與動作應由玩家本人決定，不能替玩家演繹。）');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world_scene_title1, style: GoogleFonts.notoSerifTc())),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(widget.worldName, style: GoogleFonts.notoSerifTc(fontSize: 19, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.world_scene_beta_notice1,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.world_scene_creator_scenes1, style: GoogleFonts.notoSerifTc(fontSize: 17)),
        if (_loading) const Padding(padding: EdgeInsets.all(18), child: Center(child: CircularProgressIndicator())),
        if (!_loading && _creatorScenes.isEmpty)
          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(AppLocalizations.of(context)!.world_scene_no_creator_scenes1)),
        for (final scene in _creatorScenes)
          Card(child: ListTile(title: Text(scene['title']!), subtitle: Text(scene['description']!, maxLines: 3),
              trailing: const Icon(Icons.play_arrow),
              onTap: () => _start(scene['title']!, scene['description']!))),
        const SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.world_scene_custom_scenes1, style: GoogleFonts.notoSerifTc(fontSize: 17)),
        const SizedBox(height: 12),
        TextField(controller: _title, maxLength: 60, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.world_scene_name1, border: const OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _description, maxLines: 6, maxLength: 2000,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.world_scene_setup1, border: const OutlineInputBorder())),
        const SizedBox(height: 12),
        FilledButton(onPressed: () => _start(_title.text, _description.text), child: Text(AppLocalizations.of(context)!.world_scene_start1)),
      ]),
    );
  }
}

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import '../services/toast_utils.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

/// 世界觀秘密篇章：由後端檢查劇情並返回解鎖狀態；未解鎖無標題、內容或條件。
class WorldSecretChaptersPage extends StatefulWidget {
  const WorldSecretChaptersPage({super.key, required this.worldId, this.sessionId});

  final String worldId;
  final String? sessionId;

  @override
  State<WorldSecretChaptersPage> createState() =>
      _WorldSecretChaptersPageState();
}

class _WorldSecretChaptersPageState extends State<WorldSecretChaptersPage> {
  late final HttpsCallable api = FirebaseFunctions.instanceFor(
    region: 'asia-east1',
  ).httpsCallable(
    'worldSecretChapters',
    options: HttpsCallableOptions(timeout: const Duration(seconds: 115)),
  );

  late Future<List<Map<String, dynamic>>> chapters = _load(check: true);
  bool _openingChapter = false;

  Future<List<Map<String, dynamic>>> _load({bool check = false}) async {
    final res = await api.call({
      'worldId': widget.worldId,
      if (widget.sessionId != null) 'sessionId': widget.sessionId,
      'action': check ? 'check' : 'list',
    });
    final data = Map<String, dynamic>.from(res.data as Map);
    return (data['chapters'] as List? ?? [])
        .whereType<Map>()
        .map((v) => Map<String, dynamic>.from(v))
        .toList();
  }

  Future<void> _read(Map<String, dynamic> entry) async {
    if (_openingChapter || !mounted) return;
    if (entry['unlocked'] != true) {
      ToastUtils.showCenterToast(context, '劇情還未解鎖喔~');
      return;
    }
    setState(() => _openingChapter = true);
    try {
      final res = await api.call({
        'worldId': widget.worldId,
      if (widget.sessionId != null) 'sessionId': widget.sessionId,
        'action': 'read',
        'chapterId': entry['id'],
      });
      if (!mounted) return;

      final response = Map<String, dynamic>.from(res.data as Map);
      final rawChapter = response['chapter'];
      if (rawChapter is! Map) {
        throw const FormatException('Missing secret chapter content');
      }
      final chapter = Map<String, dynamic>.from(rawChapter);
      final fallbackTitle = AppLocalizations.of(context)!.world_secret_chapters_title1;
      final title = (chapter['title'] ?? fallbackTitle).toString();
      final content = (chapter['content'] ?? '').toString();

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: SelectableText(content)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(dialogContext)!
                    .world_secret_chapters_close1,
              ),
            ),
          ],
        ),
      );
    } catch (error) {
      debugPrint('讀取秘密篇章失敗：$error');
      if (!mounted) return;
      final message = AppLocalizations.of(context)!
          .world_secret_chapters_read_failed1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _openingChapter = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.world_secret_chapters_title1)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chapters,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () => setState(() => chapters = _load(check: true)),
                child: Text(l10n.world_secret_chapters_retry1),
              ),
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text(l10n.world_secret_chapters_empty1));
          }
          final openedItems = items.where((c) => c['unlocked'] == true).toList();
          final lockedItems = items.where((c) => c['unlocked'] != true).toList();
          Widget chapterTile(Map<String, dynamic> chapter) {
            final opened = chapter['unlocked'] == true;
            return ListTile(
              leading: Icon(opened ? Icons.lock_open : Icons.lock_outline),
              title: Text(opened
                  ? (chapter['title'] ?? '秘密篇章').toString()
                  : l10n.world_secret_chapters_locked_chapter1(
                      (chapter['order'] ?? '?').toString(),
                    )),
              subtitle: Text(opened
                  ? l10n.world_secret_chapters_unlocked1
                  : l10n.world_secret_chapters_locked1),
              trailing: opened ? const Icon(Icons.chevron_right) : null,
              onTap: _openingChapter ? null : () => _read(chapter),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              if (openedItems.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text('已解鎖', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                for (final chapter in openedItems) chapterTile(chapter),
              ],
              if (lockedItems.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
                  child: Text('未解鎖', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                for (final chapter in lockedItems) chapterTile(chapter),
              ],
            ],
          );
        },
      ),
    );
  }
}

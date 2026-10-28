import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import '../services/toast_utils.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

/// 世界觀秘密篇章：未解鎖可見順序及標題；正文由後端 read 授權保護。
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

      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => _WorldSecretChapterReaderPage(
            title: title,
            content: content,
          ),
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
          Widget chapterTile(Map<String, dynamic> chapter) {
            final opened = chapter['unlocked'] == true;
            const chapterNumbers = ['一','二','三','四','五','六','七','八','九','十','十一','十二'];
            final orderNumber = int.tryParse((chapter['order'] ?? '').toString());
            final order = orderNumber != null && orderNumber >= 1 && orderNumber <= chapterNumbers.length
                ? chapterNumbers[orderNumber - 1] : '?';
            final title = (chapter['title'] ?? '未命名篇章').toString();
            return ListTile(
              leading: Icon(opened ? Icons.lock_open : Icons.lock_outline),
              title: Text('第$order篇章　$title'),
              subtitle: Text(opened ? '已解鎖・點擊閱讀' : '????'),
              trailing: opened ? const Icon(Icons.chevron_right) : null,
              onTap: _openingChapter ? null : () => _read(chapter),
            );
          }
          final unlockedCount = items.where((c) => c['unlocked'] == true).length;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Text('已解鎖 $unlockedCount / ${items.length}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              for (final chapter in items) chapterTile(chapter),
            ],
          );
        },
      ),
    );
  }
}


/// 已解鎖秘密篇章的獨立閱讀頁。內容僅能由後端 read 驗證後傳入。
class _WorldSecretChapterReaderPage extends StatelessWidget {
  const _WorldSecretChapterReaderPage({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 36),
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              Divider(color: colors.outlineVariant),
              const SizedBox(height: 18),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'world_discovery_page.dart';
/// 世界遊玩次數：僅顯示後端確實提供的數值，不自行推估。
String _worldPlayCountLabel(Object? raw) {
  if (raw is! num) return '0';
  final n = raw.toInt();
  if (n < 0) return '0';
  if (n < 1000) return '$n';
  if (n < 1000000) {
    final v = n / 1000;
    return '${v >= 100 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)}K';
  }
  final v = n / 1000000;
  return '${v >= 100 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)}M';
}

Widget _worldPlayBadge(Object? playCount) {
  return Positioned(
    top: 10,
    right: 10,
    child: IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 13),
            const SizedBox(width: 5),
            Text(_worldPlayCountLabel(playCount),
                style: const TextStyle(color: Colors.white, fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ),
  );
}

/// 獨立搜尋頁：資料沿用公開目錄，不重新呼叫 worldPublicCatalog。
class WorldSearchPage extends StatefulWidget {
  const WorldSearchPage({super.key, required this.worlds});
  final List<Map<String, dynamic>> worlds;

  @override
  State<WorldSearchPage> createState() => _WorldSearchPageState();
}

class _WorldSearchPageState extends State<WorldSearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  String _norm(Object? value) => (value ?? '').toString().trim().toLowerCase();
  int? _count(Map<String,dynamic> w) => w['playCount'] is num
      ? (w['playCount'] as num).toInt() : null;

  bool _matches(Map<String, dynamic> w) {
    if (_query.isEmpty) return true;
    final tags = w['tags'] is List ? (w['tags'] as List).join(' ') : '';
    final name = (w['creatorName'] ?? '').toString();
    return [w['name'], w['shortPitch'], w['summary'], tags, name]
        .any((field) => _norm(field).contains(_query));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final worlds = widget.worlds.where(_matches).toList();
    // 有遊玩統計的優先，熱門排序；同分維持原始清單次序。
    worlds.sort((a,b) => (_count(b) ?? -1).compareTo(_count(a) ?? -1));
    final recommendations = _query.isEmpty ? worlds.take(12).toList() : worlds;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('搜尋開放世界'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16,12,16,12), child: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() => _query = _norm(v)),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded),
            hintText: '搜尋世界名稱、創作者、標籤',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixIcon: _query.isEmpty ? null : IconButton(
              icon: const Icon(Icons.close),
              onPressed: () { _controller.clear(); setState(() => _query=''); },
            ),
          ),
        )),
        Expanded(child: recommendations.isEmpty
            ? Center(child: Text('找不到符合的開放世界'))
            : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          itemCount: recommendations.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_query.isEmpty ? '熱門探索' : '搜尋結果',
                  style: theme.textTheme.titleMedium),
            );
            final w = recommendations[i-1];
            final id = (w['id'] ?? '').toString().trim();
            final cover = (w['coverImage'] ?? '').toString();
            final tags = w['tags'] is List ? (w['tags'] as List).take(3).join(' · ') : '';
            final author = (w['creatorName'] ?? '').toString();
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: id.isEmpty ? null : () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => WorldDiscoveryPage(worldId: id))),
                child: Padding(padding: const EdgeInsets.all(10), child: Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(
                    width: 94, height: 110,
                    child: Stack(fit: StackFit.expand, children: [
                      cover.isNotEmpty ? CachedNetworkImage(
                        imageUrl: cover, fit: BoxFit.cover, memCacheWidth: 320,
                        errorWidget: (_,__,___) => const Icon(Icons.public),
                      ) : const Icon(Icons.public),
                      _worldPlayBadge(w['playCount']),
                    ]),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text((w['name'] ?? '未命名世界').toString(),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall)),
                    ]),
                    if (author.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text('創作者：$author', style: theme.textTheme.bodySmall),
                    ],
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(tags, style: theme.textTheme.bodySmall,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                    if (_norm(w['shortPitch']).isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(w['shortPitch'].toString(), maxLines: 2,
                          overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                    ],
                  ])),
                ])),
              ),
            );
          },
        )),
      ]),
    );
  }
}

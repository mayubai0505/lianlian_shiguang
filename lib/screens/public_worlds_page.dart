import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'world_search_page.dart';
import 'world_discovery_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

/// 可直接嵌入「邂逅 > 公開世界」Tab 的頁面；所有資料只由後端白名單提供。
class PublicWorldsPage extends StatefulWidget {
  const PublicWorldsPage({super.key});
  @override State<PublicWorldsPage> createState() => _PublicWorldsPageState();
}
class _PublicWorldsPageState extends State<PublicWorldsPage> {
  static List<Map<String,dynamic>>? _cachedWorlds;
  static DateTime? _cachedAt;
  late Future<List<Map<String,dynamic>>> _future = _loadCached();
  void _openSearchPage() async {
    final worlds = await _future;
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => WorldSearchPage(worlds: worlds),
    ));
  }


  Future<List<Map<String,dynamic>>> _loadCached() async {
    if (_cachedWorlds != null && _cachedAt != null &&
        DateTime.now().difference(_cachedAt!) < const Duration(minutes: 5)) {
      return _cachedWorlds!;
    }
    return _load();
  }
  Future<List<Map<String,dynamic>>> _load() async {
    final res = await FirebaseFunctions.instanceFor(region:'asia-east1')
        .httpsCallable('worldPublicCatalog').call();
    final data = Map<String,dynamic>.from(res.data as Map);
    final worlds = (data['worlds'] as List? ?? []).whereType<Map>()
        .map((e) => Map<String,dynamic>.from(e)).toList();
    _cachedWorlds = worlds; _cachedAt = DateTime.now();
    return worlds;
  }
  Future<void> _refresh() async {
    final next = _load();
    setState(() => _future = next);
    await next;

  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.public_worlds_explore_title1),
        actions: [IconButton(
          tooltip: l10n.public_worlds_search_tooltip1,
          icon: const Icon(Icons.search_rounded),
          onPressed: _openSearchPage,
        )],
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<List<Map<String,dynamic>>>(
          future:_future, builder:(context,snapshot) {
        if(snapshot.connectionState!=ConnectionState.done) return const Center(child:CircularProgressIndicator());
        if(snapshot.hasError) return Center(child:Column(mainAxisSize:MainAxisSize.min,children:[
          Text(l10n.public_worlds_load_failed1),TextButton(onPressed:() { _refresh(); },child:Text(l10n.public_worlds_refresh1))]));
        final worlds=snapshot.data??[];
        if(worlds.isEmpty) return Center(child:Text(l10n.public_worlds_empty1));
        return RefreshIndicator(onRefresh:_refresh,child:ListView.builder(
            padding:const EdgeInsets.all(12),itemCount:worlds.length,itemBuilder:(context,index){
          final w=worlds[index], id=(w['id']??'').toString();
          final cover=(w['coverImage']??'').toString();
          final tags=(w['tags'] as List? ?? []).map((v)=>v.toString()).join(' · ');
          return Card(clipBehavior:Clip.antiAlias,margin:const EdgeInsets.only(bottom:12),child:InkWell(
              onTap:id.isEmpty?null:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>WorldDiscoveryPage(worldId:id))),
              child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                if(cover.isNotEmpty) AspectRatio(aspectRatio:4/3,child:Stack(
                    fit: StackFit.expand, children: [
                  CachedNetworkImage(imageUrl:cover,fit:BoxFit.cover,
                      memCacheWidth:1000,placeholder:(_,__) => const Center(child:CircularProgressIndicator(strokeWidth:2)),
                      errorWidget:(_,__,___)=>const Center(child:Icon(Icons.public))),
                  _worldPlayBadge(w['playCount']),
                ])),
                Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text((w['name'] ?? l10n.public_worlds_unnamed1).toString(),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height:6),
                  if ((w['shortPitch']??'').toString().trim().isNotEmpty)
                    Text((w['shortPitch']??'').toString(), maxLines:2,overflow:TextOverflow.ellipsis,
                        style:Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height:4),
                  Text((w['summary']??'').toString(),maxLines:2,overflow:TextOverflow.ellipsis),
                  if(tags.isNotEmpty)...[const SizedBox(height:8),Text(tags,style:Theme.of(context).textTheme.bodySmall)],
                ])),
              ])));
        }));
      }),
    );
  }
}
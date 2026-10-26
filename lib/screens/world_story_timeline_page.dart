import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// 世界觀專屬「我們的故事」，沿用原版時間軸設計。
/// 所有讀寫走 Callable，由後端驗證登入玩家與世界房間擁有權。
class WorldStoryTimelinePage extends StatefulWidget {
  const WorldStoryTimelinePage({super.key, required this.worldId, required this.worldName});
  final String worldId;
  final String worldName;
  @override
  State<WorldStoryTimelinePage> createState() => _WorldStoryTimelinePageState();
}

class _WorldStoryTimelinePageState extends State<WorldStoryTimelinePage> {
  late final HttpsCallable _call = FirebaseFunctions.instanceFor(region: 'asia-east1')
      .httpsCallable('worldStoryMemory', options: HttpsCallableOptions(timeout: const Duration(seconds: 120)));
  bool _loading = true;
  bool _busy = false;
  String? _error;
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {super.initState(); _load();}
  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _call.call({'worldId':widget.worldId, 'action':'listEntries'});
      final data = Map<String,dynamic>.from(result.data as Map);
      final items = (data['entries'] as List? ?? const [])
          .map((e) => Map<String,dynamic>.from(e as Map)).toList();
      if (mounted) setState(() => _entries = items);
    } catch (e) {
      if (mounted) setState(() => _error = '劇情摘要讀取失敗：$e');
    } finally {if (mounted) setState(() => _loading = false);}
  }
  Future<void> _edit(Map<String,dynamic> item) async {
    final controller = TextEditingController(text:'${item['content'] ?? ''}');
    try {
      final content = await showDialog<String>(context:context, builder:(ctx) => AlertDialog(
        title:const Text('編輯劇情摘要'),
        content:TextField(controller:controller, maxLines:8, minLines:4, maxLength:5000),
        actions:[TextButton(onPressed:()=>Navigator.pop(ctx), child:const Text('取消')),
          FilledButton(onPressed:()=>Navigator.pop(ctx,controller.text.trim()), child:const Text('儲存'))],
      ));
      if (content == null || content.isEmpty || !mounted) return;
      setState(() => _busy = true);
      await _call.call({'worldId':widget.worldId,'action':'editEntry','entryId':item['id'],'content':content});
      await _load();
    } catch(e) {if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('儲存失敗：$e')));}
    finally {if(mounted) setState(() => _busy=false); controller.dispose();}
  }
  Future<void> _delete(Map<String,dynamic> item) async {
    final ok = await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
        title:const Text('刪除摘要'),content:const Text('確定刪除這段故事紀錄嗎？'),
        actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),
          TextButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('刪除'))]));
    if (ok!=true || !mounted) return;
    try {setState(() => _busy=true);
    await _call.call({'worldId':widget.worldId,'action':'deleteEntry','entryId':item['id']});
    await _load();
    } catch(e) {if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('刪除失敗：$e')));}
    finally {if(mounted) setState(() => _busy=false);}
  }
  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context), colors=theme.colorScheme;
    return Scaffold(
      appBar:AppBar(centerTitle:true,title:Text('我們的故事',style:GoogleFonts.notoSerifTc(fontSize:22))),
      body:_loading ? const Center(child:CircularProgressIndicator())
          : _error != null ? Center(child:Padding(padding:const EdgeInsets.all(20), child:Column(
          mainAxisSize:MainAxisSize.min,children:[Text(_error!,textAlign:TextAlign.center),
        TextButton(onPressed:_load,child:const Text('重試'))])))
          : _entries.isEmpty ? Center(child:Text('故事還在展開中，累積一些劇情後就會有新的紀錄。',
          textAlign:TextAlign.center,style:theme.textTheme.bodyMedium))
          : RefreshIndicator(onRefresh:_load,child:ListView.builder(
          padding:const EdgeInsets.fromLTRB(16,20,16,24),itemCount:_entries.length,
          itemBuilder:(ctx,index) {
            final item=_entries[index];
            final time=(item['createdAt'] as num?)?.toInt();
            final label=time==null?'近期紀錄':DateFormat('yyyy/MM/dd').format(DateTime.fromMillisecondsSinceEpoch(time));
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 23,
                    child: Column(
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 2,
                            color: colors.primary.withValues(alpha: 0.28),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 24),
                      color: colors.surfaceContainerHighest.withValues(alpha: 0.30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: colors.primary.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: colors.primary,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  enabled: !_busy,
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _edit(item);
                                    } else if (value == 'delete') {
                                      _delete(item);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('編輯'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('刪除'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(
                              '${item['content'] ?? ''}',
                              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
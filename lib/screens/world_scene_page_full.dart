import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_constants.dart';
import 'world_custom_scene_edit_page.dart';

/// 世界觀劇場：沿用一般聊天室兩分頁設計；玩家場景由世界觀後端驗證權限。
class WorldScenePage extends StatefulWidget {
  const WorldScenePage({super.key, required this.worldId, required this.worldName, required this.characters});
  final String worldId;
  final String worldName;
  final Map<String, String> characters;
  @override
  State<WorldScenePage> createState() => _WorldScenePageState();
}

class _WorldScenePageState extends State<WorldScenePage> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final HttpsCallable _api;
  List<Map<String, dynamic>> _custom = [];
  List<Map<String, dynamic>> _creator = [];
  Map<String, dynamic>? _active;
  bool _loading = true;
  bool _busy = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _api = FirebaseFunctions.instanceFor(region: 'asia-east1').httpsCallable('worldPrivateTest');
    _load();
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = ''; });
    try {
      final values = await Future.wait<dynamic>([
        _api.call({'action':'loadScenes','worldId':widget.worldId}),
        FirebaseFirestore.instance.collection('artifacts').doc(AppConfig.appId)
          .collection('worlds').doc(widget.worldId).get(),
      ]);
      final data = Map<String, dynamic>.from((values[0] as HttpsCallableResult).data as Map);
      final world = (values[1] as DocumentSnapshot<Map<String,dynamic>>).data() ?? {};
      final custom = (data['customScenes'] as List? ?? []).whereType<Map>()
          .map((e) => Map<String,dynamic>.from(e)).toList();
      final creator = <Map<String,dynamic>>[];
      for (final raw in (world['scenes'] as List? ?? const [])) {
        if (raw is Map) {
          final scene = Map<String,dynamic>.from(raw);
          if ((scene['title'] ?? scene['name'] ?? '').toString().trim().isNotEmpty) creator.add(scene);
        }
      }
      if (!mounted) return;
      setState(() {
        _custom = custom;
        _creator = creator;
        _active = data['activeScene'] is Map ? Map<String,dynamic>.from(data['activeScene'] as Map) : null;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = '讀取劇場失敗：$e'; });
    }
  }

  Future<void> _edit([Map<String,dynamic>? scene]) async {
    await Navigator.push<void>(context, MaterialPageRoute(builder: (_) => WorldCustomSceneEditPage(
      worldId: widget.worldId, worldName: widget.worldName, sceneDoc: scene)));
    if (mounted) await _load();
  }

  Future<void> _delete(Map<String,dynamic> scene) async {
    final yes = await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title:const Text('刪除劇場'), content:Text('確定刪除「${scene['title']}」嗎？'),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),
        TextButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('刪除'))]));
    if (yes != true || !mounted) return;
    try {
      await _api.call({'action':'deleteCustomScene','worldId':widget.worldId,'sceneId':scene['id']});
      await _load();
    } catch (e) { _notice('刪除劇場失敗：$e'); }
  }

  Future<void> _start(Map<String,dynamic> scene, String type) async {
    if (_busy) return;
    final title = (scene['title'] ?? scene['name'] ?? '').toString().trim();
    final description = (scene['description'] ?? scene['opening'] ?? '').toString().trim();
    if (title.isEmpty || description.isEmpty) { _notice('劇場內容不足，請先補齊標題與場景說明'); return; }
    setState(() => _busy = true);
    try {
      await _api.call({'action':'activateScene','worldId':widget.worldId,
        'sceneType':type,'title':title,'description':description});
      if (!mounted) return;
      Navigator.pop(context, '【世界觀劇場：$title】\n場景：$description\n'
        '請讓合適 NPC 依既有人設進入情節，但不要替玩家決定行動、心理或台詞。');
    } catch (e) { _notice('啟用劇場失敗：$e'); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _end() async {
    final yes = await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title:const Text('結束劇場'),content:const Text('確定結束目前進行中的劇場嗎？'),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),
        TextButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('結束劇場'))]));
    if (yes != true || !mounted) return;
    try {
      await _api.call({'action':'clearScene','worldId':widget.worldId});
      await _load();
    } catch (e) { _notice('結束劇場失敗：$e'); }
  }

  void _notice(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(message)));
  }

  Widget _sceneCard(Map<String,dynamic> scene, {required bool creator}) {
    final theme = Theme.of(context);
    final title = (scene['title'] ?? scene['name'] ?? '未命名劇場').toString();
    final description = (scene['description'] ?? '').toString();
    final opening = (scene['opening'] ?? '').toString();
    return Container(
      margin: const EdgeInsets.only(bottom:14), padding:const EdgeInsets.fromLTRB(18,17,18,14),
      decoration:BoxDecoration(color:theme.colorScheme.surface,borderRadius:BorderRadius.circular(22),
        border:Border.all(color:theme.colorScheme.primary.withValues(alpha:.14))),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(title,style:GoogleFonts.notoSerifTc(fontSize:17,fontWeight:FontWeight.w700)),
        if(description.isNotEmpty) ...[const SizedBox(height:8),Text(description,
          style:GoogleFonts.notoSerifTc(fontSize:13,height:1.65))],
        if(creator && opening.isNotEmpty) ...[const SizedBox(height:8),Text('開場：$opening',
          style:GoogleFonts.notoSerifTc(fontSize:12))],
        const SizedBox(height:12),
        Row(children:[
          if(!creator) ...[
            TextButton(onPressed:_busy ? null : ()=>_edit(scene),child:const Text('編輯')),
            TextButton(onPressed:_busy ? null : ()=>_delete(scene),child:const Text('刪除')),
          ],
          const Spacer(),
          FilledButton(onPressed:_busy ? null : ()=>_start(scene,creator?'creator':'custom'),child:const Text('開始劇場')),
        ]),
      ]),
    );
  }

  Widget _sceneList(bool creator) {
    final records = creator ? _creator : _custom;
    return Stack(children:[
      if(records.isEmpty) Center(child:Text(creator?'目前尚無創作者劇場':'還沒有自行建立的劇場',
        style:GoogleFonts.notoSerifTc()))
      else ListView(padding:const EdgeInsets.fromLTRB(18,18,18,110),children:[for(final s in records)_sceneCard(s,creator:creator)]),
      if(!creator) Positioned(right:20,bottom:22,child:FloatingActionButton.extended(
        heroTag:'add_world_custom_scene',onPressed:_busy?null:()=>_edit(),label:const Text('新增劇場'))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar:AppBar(title:Text('劇場',style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w700)),
        bottom:TabBar(controller:_tabs,tabs:const [Tab(text:'創作者劇場'),Tab(text:'自行創建劇場')])),
      body:Column(children:[
        if(_active != null) Container(width:double.infinity,
          margin:const EdgeInsets.fromLTRB(18,14,18,0),padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(color:theme.colorScheme.primary.withValues(alpha:.06),
            borderRadius:BorderRadius.circular(18)),
          child:Row(children:[Expanded(child:Text('進行中的劇場：${_active!['title'] ?? ''}',
            style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
            TextButton(onPressed:_end,child:const Text('結束劇場'))])),
        Expanded(child:_loading?const Center(child:CircularProgressIndicator())
          :_error.isNotEmpty?Center(child:Text(_error))
          :TabBarView(controller:_tabs,children:[_sceneList(true),_sceneList(false)])),
      ]),
    );
  }
}

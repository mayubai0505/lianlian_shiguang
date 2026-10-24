import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 私人試玩；所有訊息經 Cloud Function 授權、讀取與儲存。
/// 目前僅限世界創作者。正式公開玩家玩法和花花計費尚未開放。
class WorldChatPage extends StatefulWidget {
  const WorldChatPage({super.key, required this.worldId});
  final String worldId;
  @override
  State<WorldChatPage> createState() => _WorldChatPageState();
}

class _WorldChatPageState extends State<WorldChatPage> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _loading = true;
  bool _sending = false;
  String _name = '開放世界';
  String _error = '';
  String _selectedMode = '劇情';
  bool _toolPanelOpen = false;
  static const _modes = <String, int>{'劇情': 5, '沉浸': 7, '共鳴': 10, '互動': 12};
  List<dynamic> _messages = [];
  Map<String,String> _npcs = {};
  Map<String,String> _names = {};
  late final HttpsCallable _api = FirebaseFunctions.instanceFor(region:'asia-east1')
      .httpsCallable('worldPrivateTest', options: HttpsCallableOptions(timeout:const Duration(seconds:170)));

  @override
  void initState() {super.initState();_run('load');}
  @override
  void dispose() {_input.dispose();_scroll.dispose();super.dispose();}

  Future<void> _run(String action, {String message=''}) async {
    if(action=='send') {if(_sending || _loading)return;setState(()=>_sending=true);}
    try {
      final result = await _api.call({
        'action':action,'worldId':widget.worldId,
        if(action=='send') 'message':message,
        if(action=='send') 'requestId':'m_${DateTime.now().microsecondsSinceEpoch}',
      });
      final data=Map<String,dynamic>.from(result.data as Map);
      if(!mounted)return;
      final npcs = <String,String>{};
      final names = <String,String>{};
      for(final raw in (data['npcs'] as List? ?? [])) {
        if(raw is! Map)continue;
        final n=Map<String,dynamic>.from(raw);
        final id=(n['id']??'').toString();
        if(id.isNotEmpty){npcs[id]=(n['avatarUrl']??'').toString();names[id]=(n['name']??'').toString();}
      }
      setState((){
        _name=(data['worldName']??'開放世界').toString();
        _messages=List<dynamic>.from(data['messages'] as List? ?? []);
        _npcs=npcs;_names=names;_loading=false;_error='';
      });
      WidgetsBinding.instance.addPostFrameCallback((_){
        if(mounted && _scroll.hasClients)_scroll.animateTo(_scroll.position.maxScrollExtent,
            duration:const Duration(milliseconds:260),curve:Curves.easeOut);
      });
    } on FirebaseFunctionsException catch(e) {
      if(!mounted)return;
      setState((){_loading=false;_error=e.message ?? '連線失敗';});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(_error)));
    } catch(e) {
      if(!mounted)return;
      setState((){_loading=false;_error='網路暫時無法連線';});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(_error)));
    } finally {if(mounted && action=='send')setState(()=>_sending=false);}
  }

  void _send(){
    final text=_input.text.trim();
    if(text.isEmpty || _sending)return;
    _input.clear();
    // 注意：目前 worldPrivateTest 不接受四模式，先沿用私人試玩的既有生成邏輯。
    _run('send',message:text);
  }

  void _notReady(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 的正式資料與後端尚未串接，目前是聊天室介面預覽')),
    );
  }

  void _pickMode() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(title: Text('選擇世界觀模式'),
              subtitle: Text('目前只切換畫面；AI 模型和花花扣點尚未串接')),
          for (final entry in _modes.entries)
            ListTile(
              title: Text(entry.key),
              subtitle: Text('${entry.value} 朵花花／回覆（正式費率，尚未啟用扣點）'),
              trailing: _selectedMode == entry.key
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                setState(() => _selectedMode = entry.key);
                Navigator.pop(sheetContext);
              },
            ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _toolTile(IconData icon, String title) => InkWell(
    onTap: () => _notReady(title),
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 3),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
      ]),
    ),
  );

  Widget _tools() => Padding(
    padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(child: _toolTile(Icons.bookmark_outline, '收藏')),
        Expanded(child: _toolTile(Icons.auto_stories_outlined, '劇情摘要')),
        Expanded(child: _toolTile(Icons.image_outlined, '照片')),
      ]),
      Row(children: [
        Expanded(child: _toolTile(Icons.mic_none_outlined, '錄音')),
        Expanded(child: _toolTile(Icons.folder_outlined, '拾光檔案')),
        Expanded(child: _toolTile(Icons.extension_outlined, '互動玩法')),
      ]),
      Row(children: [
        Expanded(child: _toolTile(Icons.theater_comedy_outlined, '劇場')),
        Expanded(child: _toolTile(Icons.fact_check_outlined, '狀態欄')),
        Expanded(child: _toolTile(Icons.lock_open_outlined, '秘密篇章')),
      ]),
    ]),
  );

  Widget _drawerItem(IconData icon, String label) => ListTile(
    leading: Icon(icon), title: Text(label),
    onTap: () { Navigator.pop(context); _notReady(label); },
  );

  Widget _segment(Map<String,dynamic> value,ThemeData theme) {
    final kind=(value['kind']??'').toString();
    final text=(value['text']??'').toString();
    final id=(value['npcId']??'').toString();
    final name=_names[id] ?? (value['name']??'').toString();
    final url=_npcs[id]??'';
    if(kind!='npc')return Container(
      width:double.infinity, margin:const EdgeInsets.symmetric(vertical:5),
      padding:const EdgeInsets.all(14),
      decoration:BoxDecoration(color:theme.colorScheme.surfaceContainerHighest.withValues(alpha:.65),
          borderRadius:BorderRadius.circular(16)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('世界旁白',style:TextStyle(fontSize:11,color:theme.colorScheme.primary)),
        const SizedBox(height:5),Text(text,style:const TextStyle(height:1.65)),
      ]),
    );
    return Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(
      crossAxisAlignment:CrossAxisAlignment.start,children:[
      CircleAvatar(radius:20,backgroundColor:theme.colorScheme.primaryContainer,
          backgroundImage:url.startsWith('https://')?NetworkImage(url):null,
          child:url.startsWith('https://')?null:const Icon(Icons.person_outline)),
      const SizedBox(width:10),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(name.isEmpty?'NPC':name,style:GoogleFonts.notoSerifTc(fontSize:12,fontWeight:FontWeight.w600)),
        const SizedBox(height:4),Container(padding:const EdgeInsets.all(12),
            decoration:BoxDecoration(color:theme.colorScheme.surface,borderRadius:BorderRadius.circular(14),
                border:Border.all(color:theme.colorScheme.primary.withValues(alpha:.12))),
            child:Text(text,style:const TextStyle(height:1.6))),
      ])),
    ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(fontSize: 17, fontWeight: FontWeight.w600)),
          const Text('私人試玩 · 介面預覽', style: TextStyle(fontSize: 10)),
        ]),
        actions: [
          TextButton(
            onPressed: _pickMode,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('$_selectedMode ▾', style: TextStyle(color: theme.colorScheme.primary)),
            ]),
          ),
          Builder(builder: (ctx) => IconButton(
            tooltip: '世界觀選單', icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openEndDrawer(),
          )),
        ],
      ),
      endDrawer: Drawer(child: SafeArea(child: ListView(children: [
        ListTile(title: Text(_name, style: GoogleFonts.notoSerifTc(fontSize: 19)),
            subtitle: const Text('開放世界 · 私人試玩')),
        const Divider(),
        _drawerItem(Icons.search, '搜尋對話'),
        _drawerItem(Icons.save_alt, '保存對話紀錄'),
        _drawerItem(Icons.menu_book_outlined, '專屬回憶與背景'),
        const Divider(),
        _drawerItem(Icons.history_edu_outlined, '我的世界紀錄'),
        _drawerItem(Icons.people_outline, '人物關係'),
        _drawerItem(Icons.notifications_none, '給世界的備忘錄'),
        const Divider(),
        _drawerItem(Icons.restart_alt, '重置世界進度'),
      ]))),
      body:SafeArea(child:Column(children:[
        if(_loading)const Expanded(child:Center(child:CircularProgressIndicator()))
        else Expanded(child:_messages.isEmpty
            ?Center(child:Text(_error.isEmpty?'尚無對話':'$_error\n可返回後重試',textAlign:TextAlign.center))
            :ListView.builder(controller:_scroll,padding:const EdgeInsets.all(16),
            itemCount:_messages.length,itemBuilder:(context,index){
              final raw=_messages[index];
              if(raw is! Map)return const SizedBox.shrink();
              final data=Map<String,dynamic>.from(raw);
              if(data['sender']=='user')return Align(alignment:Alignment.centerRight,
                  child:Container(margin:const EdgeInsets.symmetric(vertical:8),padding:const EdgeInsets.all(13),
                      constraints:BoxConstraints(maxWidth:MediaQuery.sizeOf(context).width*.78),
                      decoration:BoxDecoration(color:theme.colorScheme.primaryContainer,
                          borderRadius:BorderRadius.circular(17)),
                      child:Text((data['text']??'').toString(),style:const TextStyle(height:1.55))));
              return Column(children:[for(final rawSegment in (data['segments'] as List? ?? []))
                if(rawSegment is Map)_segment(Map<String,dynamic>.from(rawSegment),theme)]);
            })),
        if (_toolPanelOpen) _tools(),
        Padding(padding:const EdgeInsets.fromLTRB(12,8,12,12),child:Row(children:[
          IconButton(
            tooltip: _toolPanelOpen ? '收起功能' : '開啟功能',
            onPressed: () => setState(() => _toolPanelOpen = !_toolPanelOpen),
            icon: Icon(_toolPanelOpen ? Icons.keyboard_arrow_down : Icons.add_circle_outline),
          ),
          Expanded(child:TextField(controller:_input,enabled:!_sending && !_loading,
              minLines:1,maxLines:5,maxLength:2500,
              decoration:InputDecoration(hintText:'你想說什麼？',counterText:'',
                  border:OutlineInputBorder(borderRadius:BorderRadius.circular(22))))),
          const SizedBox(width:8),IconButton.filled(onPressed:_sending || _loading?null:_send,
              icon:_sending?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2))
                  :const Icon(Icons.send_rounded)),
        ])),
      ])),
    );
  }
}

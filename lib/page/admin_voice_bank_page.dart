import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Independent admin-only page. Authorization is enforced by the callable.
class AdminVoiceBankPage extends StatefulWidget {
  const AdminVoiceBankPage({super.key});
  @override
  State<AdminVoiceBankPage> createState() => _AdminVoiceBankPageState();
}

class _AdminVoiceBankPageState extends State<AdminVoiceBankPage> {
  final _functions = FirebaseFunctions.instanceFor(region: 'us-central1');
  final _player = AudioPlayer();
  final _search = TextEditingController();
  String _language = 'zh';
  String _gender = '';
  bool _taiwan = false;
  bool _busy = false;
  bool _explore = true;
  bool _more = false;
  int _page = 0;
  String? _error;
  String? _playing;
  List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> _bank = [];
  bool _bankLoaded = false;
  String _s(dynamic value) => value?.toString() ?? '';
  List<Map<String, dynamic>> _rows(dynamic data) => (data as List? ?? [])
      .whereType<Map>().map((v) => Map<String, dynamic>.from(v)).toList();
  Future<Map<String, dynamic>> _call(String action, [Map<String, dynamic> args = const {}]) async {
    final result = await _functions.httpsCallable('adminVoiceBankUs',
      options: HttpsCallableOptions(timeout: const Duration(minutes: 4))).call({'action': action, ...args});
    return Map<String, dynamic>.from(result.data as Map);
  }
  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) { if (mounted) setState(() => _playing = null); });
    _loadBank();
  }
  @override
  void dispose() { _search.dispose(); _player.dispose(); super.dispose(); }
  void _message(String message) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); }
  Future<void> _run(Future<void> Function() fn) async {
    if (_busy || !mounted) return;
    setState(() { _busy = true; _error = null; });
    try { await fn(); }
    on FirebaseFunctionsException catch(e) { if(mounted) setState(() => _error = '${e.code}：${e.message ?? ''}'); }
    catch(e) { if(mounted) setState(() => _error = '操作未完成：$e'); }
    finally { if(mounted) setState(() => _busy = false); }
  }
  Future<void> _refreshBank() async {
    final r = await _call('list');
    if(mounted) setState(() { _bank = _rows(r['voices']); _bankLoaded = true; });
  }
  Future<void> _loadBank() => _run(_refreshBank);
  Future<void> _find({bool next = false}) => _run(() async {
    final lang = _language;
    final page = next ? _page + 1 : 0;
    final response = await _call('search', {'language':lang, 'gender':_gender,
      'locale':_taiwan && lang == 'zh' ? 'zh-TW' : '', 'search':_search.text.trim(), 'page':page});
    if(mounted) setState(() {
      _results = next ? [..._results, ..._rows(response['voices'])] : _rows(response['voices']);
      _page = page; _more = response['hasMore'] == true;
    });
  });
  Future<void> _playUrl(String id, String url) async {
    if(url.isEmpty) { _message('沒有現成試聽音檔'); return; }
    try {
      if(_playing == id) { await _player.stop(); if(mounted) setState(() => _playing = null); return; }
      await _player.stop(); if(!mounted) return;
      setState(() => _playing = id);
      await _player.play(UrlSource(url));
    } catch(e) { if(mounted) setState(() => _playing = null); _message('播放失敗：$e'); }
  }
  Future<void> _import(Map<String,dynamic> v) async {
    final yes = await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title: Text('匯入 ${_s(v['name'])}？'),
      content: const Text('將加入 ElevenLabs 帳號及戀戀拾光聲音庫，可能計入聲音操作額度。匯入後預設停止推薦，審核後再啟用。'),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('匯入'))]));
    if(yes!=true || !mounted) return;
    await _run(() async { await _call('import', {'voiceId':v['voiceId'],'ownerId':v['ownerId'],'language':v['language']});
      await _refreshBank(); _message('已匯入，請到我的聲音庫審核'); });
  }
  double _setting(Map<String,dynamic> v,String key,double fallback) {
    final dynamic settings=v['defaultSettings'];
    final dynamic n=settings is Map ? settings[key] : null;
    return n is num ? n.toDouble() : fallback;
  }
  Future<void> _preview(Map<String,dynamic> v,double stability,double style) => _run(() async {
    final result=await _call('preview',{'documentId':v['documentId'],'stability':stability,'style':style});
    final bytes=base64Decode(_s(result['audioBase64']));
    if(bytes.isEmpty) throw StateError('空白音檔');
    if(!mounted)return;
    await _player.stop(); if(!mounted)return;
    setState(()=>_playing=_s(v['voiceId']));
    if(kIsWeb) { await _player.play(UrlSource('data:audio/mpeg;base64,${base64Encode(bytes)}')); }
    else { await _player.play(BytesSource(bytes)); }
  });
  Future<void> _edit(Map<String,dynamic> v) async {
    final result=await showDialog<Map<String,dynamic>>(context:context,builder:(_)=>_VoiceBankEditDialog(voice:v));
    if(result==null || !mounted)return;
    await _run(() async { await _call('update',{'documentId':v['documentId'],...result}); await _refreshBank(); _message('已儲存'); });
  }
  Widget _exploreCard(Map<String,dynamic> v) {
    final id=_s(v['voiceId']);
    final exists=_bank.any((x)=>x['voiceId']==id || x['documentId']=='library_$id');
    return Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(_s(v['name']),style:Theme.of(context).textTheme.titleMedium),
      Text([v['gender'],v['language'],v['accent'],v['locale']].map(_s).where((s)=>s.isNotEmpty).join('・')),
      if(_s(v['description']).isNotEmpty) Text(_s(v['description']),maxLines:3,overflow:TextOverflow.ellipsis),
      Text('費率：${v['rate'] ?? '未回傳'}｜通知期：${v['noticePeriod'] ?? '未回傳'}'),
      Row(children:[TextButton.icon(onPressed:_busy||_s(v['libraryPreviewUrl']).isEmpty?null:()=>_playUrl(id,_s(v['libraryPreviewUrl'])),icon:Icon(_playing==id?Icons.stop:Icons.play_arrow),label:const Text('現成試聽')),
        const Spacer(),FilledButton(onPressed:_busy||exists?null:()=>_import(v),child:Text(exists?'已匯入':'匯入'))]),
    ])));
  }
  Widget _bankCard(Map<String,dynamic> v) {
    final id=_s(v['voiceId']);
    final s=_setting(v,'stability',0.6),t=_setting(v,'style',0.15);
    final previewUrl=_s(v['libraryPreviewUrl']).isNotEmpty?_s(v['libraryPreviewUrl']):_s(v['previewUrl']);
    return Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(children:[Expanded(child:Text(_s(v['name']),style:Theme.of(context).textTheme.titleMedium)),Text(v['enabled']==true?'推薦中':'停止推薦')]),
      Text([v['gender'],v['language'],v['accent']].map(_s).where((s)=>s.isNotEmpty).join('・')),
      Text('穩定度 ${s.toStringAsFixed(2)} / 風格 ${t.toStringAsFixed(2)}'),
      Wrap(spacing:4,children:[
        if(previewUrl.isNotEmpty) TextButton.icon(onPressed:_busy?null:()=>_playUrl(id,previewUrl),icon:Icon(_playing==id?Icons.stop:Icons.play_arrow),label:const Text('現成試聽')),
        TextButton(onPressed:_busy?null:()=>_preview(v,s,t),child:const Text('原參數中文試聽（付費）')),
        TextButton(onPressed:_busy?null:()=>_preview(v,0.6,0.15),child:const Text('自然版中文試聽（付費）')),
        TextButton.icon(onPressed:_busy?null:()=>_edit(v),icon:const Icon(Icons.edit_outlined),label:const Text('編輯')),
      ]),
    ])));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(title:const Text('聲音管理中心'),actions:[IconButton(tooltip:'停止播放',onPressed:() async {await _player.stop(); if(mounted)setState(()=>_playing=null);},icon:const Icon(Icons.stop_circle_outlined))]),
      body:Column(children:[
        Padding(padding:const EdgeInsets.all(12),child:SegmentedButton<bool>(segments: [
          const ButtonSegment(value:true,label:Text('探索聲音'),icon:Icon(Icons.search)),
          ButtonSegment(value:false,label:Text('我的聲音庫 ${_bankLoaded?_bank.length:''}'),icon:const Icon(Icons.library_music_outlined))],selected:{_explore},onSelectionChanged:_busy?null:(v){setState(()=>_explore=v.first);if(!_explore)_loadBank();})),
        if(_busy)const LinearProgressIndicator(),
        if(_error!=null)Padding(padding:const EdgeInsets.all(12),child:Text(_error!,style:TextStyle(color:Theme.of(context).colorScheme.error))),
        Expanded(child:ListView(padding:const EdgeInsets.all(12),children:[
          if(_explore)...[
            TextField(controller:_search,enabled:!_busy,decoration:const InputDecoration(labelText:'搜尋音色',prefixIcon:Icon(Icons.search)),onChanged:(_)=>setState((){_results=[];_more=false;_page=0;}),onSubmitted:(_)=>_find()),
            const SizedBox(height:8),
            Wrap(spacing:16,runSpacing:8,children:[
              DropdownButton<String>(value:_language,items:const [DropdownMenuItem(value:'zh',child:Text('中文')),DropdownMenuItem(value:'ja',child:Text('日文')),DropdownMenuItem(value:'en',child:Text('英文')),DropdownMenuItem(value:'ko',child:Text('韓文')),DropdownMenuItem(value:'',child:Text('所有語言'))],onChanged:_busy?null:(v){if(v!=null)setState((){_language=v;_results=[];_more=false;_page=0;});}),
              DropdownButton<String>(value:_gender,items:const [DropdownMenuItem(value:'',child:Text('不限性別')),DropdownMenuItem(value:'male',child:Text('男聲')),DropdownMenuItem(value:'female',child:Text('女聲'))],onChanged:_busy?null:(v){if(v!=null)setState((){_gender=v;_results=[];_more=false;_page=0;});}),
            ]),
            if(_language=='zh')SwitchListTile(contentPadding:EdgeInsets.zero,title:const Text('台灣地區（zh-TW）'),value:_taiwan,onChanged:_busy?null:(v)=>setState((){_taiwan=v;_results=[];_more=false;_page=0;})),
            const Text('僅查詢無自訂費率、非即時審核、通知期至少 30 天的音色。口音仍須實際試聽。'),
            FilledButton.icon(onPressed:_busy?null:()=>_find(),icon:const Icon(Icons.search),label:const Text('搜尋 ElevenLabs')),
            ..._results.map(_exploreCard),
            if(_more)OutlinedButton(onPressed:_busy?null:()=>_find(next:true),child:const Text('載入更多')),
          ]else...[
            Text('共 ${_bank.length} 種，${_bank.where((v)=>v['enabled']==true).length} 種推薦中。停止推薦不會修改既有角色 Voice ID。'),
            OutlinedButton.icon(onPressed:_busy?null:_loadBank,icon:const Icon(Icons.refresh),label:const Text('重新整理')),
            ..._bank.map(_bankCard),
          ]
        ]))
      ]));
  }
}

class _VoiceBankEditDialog extends StatefulWidget {
  final Map<String,dynamic> voice;
  const _VoiceBankEditDialog({required this.voice});
  @override
  State<_VoiceBankEditDialog> createState()=>_VoiceBankEditDialogState();
}
class _VoiceBankEditDialogState extends State<_VoiceBankEditDialog> {
  late final TextEditingController _name,_tags,_language,_accent;
  late double _stability,_style;
  late bool _enabled;
  @override
  void initState(){super.initState();final v=widget.voice;
    _name=TextEditingController(text:v['name']?.toString()??'');
    _tags=TextEditingController(text:(v['tags'] as List? ?? []).join('、'));
    _language=TextEditingController(text:v['language']?.toString()??'');
    _accent=TextEditingController(text:v['accent']?.toString()??'');
    final s=v['defaultSettings'];
    _stability=((s is Map ? s['stability']:null) as num? ?? 0.6).toDouble().clamp(0.1,0.9).toDouble();
    _style=((s is Map ? s['style']:null) as num? ?? 0.15).toDouble().clamp(0.0,1.0).toDouble();
    _enabled=v['enabled']==true;
  }
  @override
  void dispose(){_name.dispose();_tags.dispose();_language.dispose();_accent.dispose();super.dispose();}
  @override
  Widget build(BuildContext context)=>AlertDialog(title:const Text('編輯聲音'),content:SizedBox(width:420,child:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
    TextField(controller:_name,decoration:const InputDecoration(labelText:'聲音名稱')),
    TextField(controller:_tags,decoration:const InputDecoration(labelText:'標籤（用頓號分隔）')),
    TextField(controller:_language,decoration:const InputDecoration(labelText:'語言（zh、ja 等）')),
    TextField(controller:_accent,decoration:const InputDecoration(labelText:'實際試聽口音')),
    Text('穩定度 ${_stability.toStringAsFixed(2)}'),Slider(value:_stability,min:0.1,max:0.9,onChanged:(v)=>setState(()=>_stability=v)),
    Text('風格 ${_style.toStringAsFixed(2)}'),Slider(value:_style,min:0,max:1,onChanged:(v)=>setState(()=>_style=v)),
    SwitchListTile(title:const Text('推薦給新角色'),value:_enabled,onChanged:(v)=>setState(()=>_enabled=v)),
    TextButton(onPressed:()=>setState((){_stability=0.6;_style=0.15;}),child:const Text('套用自然版參數')),
  ]))),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('取消')),FilledButton(onPressed:(){if(_name.text.trim().isEmpty)return;Navigator.pop(context, <String,dynamic>{'name':_name.text.trim(),'tags':_tags.text.split(RegExp(r'[,，、\n]')),'language':_language.text.trim(),'accent':_accent.text.trim(),'stability':_stability,'style':_style,'enabled':_enabled});},child:const Text('儲存'))]);
}

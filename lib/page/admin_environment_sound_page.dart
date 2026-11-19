import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:typed_data';
import '../services/environment_audio_service.dart';

const _categories = {'indoor':'室內','outdoor':'戶外','weather':'天氣','transport':'交通','action':'動作','other':'其他'};
class AdminEnvironmentSoundPage extends StatefulWidget {
  const AdminEnvironmentSoundPage({super.key});
  @override State<AdminEnvironmentSoundPage> createState() => _AdminEnvironmentSoundPageState();
}
class _AdminEnvironmentSoundPageState extends State<AdminEnvironmentSoundPage> {
  final _functions = FirebaseFunctions.instanceFor(region:'us-central1');
  final _audio = EnvironmentAudioService();
  List<Map<String,dynamic>> _sounds = [];
  bool _busy=false, _ducked=false;
  String _query='', _category='', _error='';
  Future<Map<String,dynamic>> _call(String action, [Map<String,dynamic> data=const {}]) async {
    final result=await _functions.httpsCallable('adminEnvironmentSoundUs',options:HttpsCallableOptions(timeout:const Duration(minutes:2))).call({'action':action,...data});
    return Map<String,dynamic>.from(result.data as Map);
  }
  Future<void> _run(Future<void> Function() f) async {
    if(_busy || !mounted)return;
    setState((){_busy=true;_error='';});
    try {await f();} on FirebaseFunctionsException catch(e){if(mounted)setState(()=>_error='${e.code}：${e.message}');}
    catch(e){if(mounted)setState(()=>_error='操作失敗：$e');}
    finally{if(mounted)setState(()=>_busy=false);}
  }
  Future<void> _refresh() async {final r=await _call('list');if(mounted)setState(()=>_sounds=(r['sounds'] as List).map((v)=>Map<String,dynamic>.from(v as Map)).toList());}
  @override void initState(){super.initState();_run(_refresh);}
  @override void dispose(){_audio.dispose();super.dispose();}
  Future<void> _edit([Map<String,dynamic>? old]) async {
    await _audio.stop(); if(!mounted)return;
    final data=await showDialog<Map<String,dynamic>>(context:context,barrierDismissible:false,builder:(_)=>_SoundDialog(old:old,generate:(text,duration,loop)=>_call('generate',{'text':text,'duration':duration,'loop':loop})));
    if(data==null||!mounted)return;
    await _run(() async {await _call(old==null?'create':'update',data);await _refresh();});
  }
  Future<void> _play(Map<String,dynamic> v)=>_run(() async {
    final r=await _call('preview',{'soundId':v['soundId']}); if(!mounted)return;
    await _audio.play(base64Decode(r['audioBase64'] as String),mime:r['contentType'] as String,volume:(v['volume'] as num).toDouble(),loop:v['loop']==true);
  });
  @override Widget build(BuildContext context){
    final visible=_sounds.where((v)=>(_category.isEmpty||v['category']==_category)&&('${v['name']} ${v['soundId']} ${v['tags']}'.toLowerCase().contains(_query.toLowerCase())));
    return Scaffold(appBar:AppBar(title:const Text('環境音效庫'),actions:[IconButton(tooltip:'停止全部',onPressed:_busy?null:()=>_run(_audio.stop),icon:const Icon(Icons.stop_circle_outlined)),IconButton(tooltip:'重新整理',onPressed:_busy?null:()=>_run(_refresh),icon:const Icon(Icons.refresh))]),
      floatingActionButton:FloatingActionButton.extended(onPressed:_busy?null:()=>_edit(),icon:const Icon(Icons.add),label:const Text('新增音效')),
      body:Column(children:[if(_busy)const LinearProgressIndicator(),if(_error.isNotEmpty)Padding(padding:const EdgeInsets.all(12),child:Text(_error,style:TextStyle(color:Theme.of(context).colorScheme.error))),
        Padding(padding:const EdgeInsets.all(12),child:TextField(decoration:const InputDecoration(prefixIcon:Icon(Icons.search),labelText:'搜尋名稱、ID、標籤'),onChanged:(v)=>setState(()=>_query=v))),
        Padding(padding:const EdgeInsets.symmetric(horizontal:12),child:Wrap(spacing:8,children:[ChoiceChip(label:const Text('全部'),selected:_category=='',onSelected:(_)=>setState(()=>_category='')),..._categories.entries.map((e)=>ChoiceChip(label:Text(e.value),selected:_category==e.key,onSelected:(_)=>setState(()=>_category=e.key)))])),
        SwitchListTile(title:const Text('模擬角色說話時降低環境音'),value:_ducked,onChanged:_busy?null:(v)=>_run(() async {await _audio.setDucked(v);if(mounted)setState(()=>_ducked=v);})),
        Text('共 ${_sounds.length} 個音效｜啟用 ${_sounds.where((v)=>v['enabled']==true).length} 個'),
        Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(12,8,12,88),children:visible.map((v)=>Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('${v['name']}',style:Theme.of(context).textTheme.titleMedium),Text('${v['soundId']}・${_categories[v['category']]??''}・${v['loop']==true?'循環':'單次'}・音量 ${((v['volume'] as num)*100).round()}%'),Text('${v['tags']??[]}'),Wrap(spacing:8,crossAxisAlignment:WrapCrossAlignment.center,children:[TextButton.icon(onPressed:_busy?null:()=>_play(v),icon:const Icon(Icons.play_arrow),label:const Text('試聽')),TextButton.icon(onPressed:_busy?null:()=>_edit(v),icon:const Icon(Icons.edit_outlined),label:const Text('編輯')),Switch(value:v['enabled']==true,onChanged:_busy?null:(enabled)=>_run(() async {await _call('update',{...v,'enabled':enabled});await _refresh();}))])])))).toList()))]));
  }
}
class _SoundDialog extends StatefulWidget {
  final Map<String,dynamic>? old;
  final Future<Map<String,dynamic>> Function(String,double,bool) generate;
  const _SoundDialog({this.old,required this.generate});
  @override State<_SoundDialog> createState()=>_SoundDialogState();
}
class _SoundDialogState extends State<_SoundDialog>{
  late final TextEditingController _id,_name,_tags;
  late String _type,_category;
  late double _volume;
  String? _fileName;
  final _prompt=TextEditingController();
  final _preview=EnvironmentAudioService();
  bool _ai=false, _generating=false;
  double _duration=20;
  bool get _locked=>_picking||_generating;
  Uint8List? _fileBytes;
  String? _extension;
  bool _picking=false;
  String _error='';
  @override void initState(){super.initState();final v=widget.old;_id=TextEditingController(text:v?['soundId'] as String? ?? '');_name=TextEditingController(text:v?['name'] as String? ?? '');_tags=TextEditingController(text:(v?['tags'] as List? ?? []).join(','));_type=v?['type'] as String? ?? 'ambient';_category=v?['category'] as String? ?? 'indoor';_volume=(v?['volume'] as num? ?? 0.15).toDouble();}
  @override void dispose(){_id.dispose();_name.dispose();_tags.dispose();_prompt.dispose();_preview.dispose();super.dispose();}
  Future<void> _pick() async {
    setState(()=>_picking=true);
    try {
      final f=await openFile(acceptedTypeGroups: const [XTypeGroup(label:'Audio', extensions:['mp3','wav'], mimeTypes:['audio/mpeg','audio/wav','audio/x-wav'], uniformTypeIdentifiers:['public.mp3','com.microsoft.waveform-audio'])]);
      if(!mounted||f==null)return;
      final extension=f.name.split('.').last.toLowerCase();
      if(!['mp3','wav'].contains(extension)||await f.length()>5*1024*1024){if(mounted)setState(()=>_error='請選擇 5 MiB 以內的 MP3 / WAV 音檔');return;}
      final bytes=await f.readAsBytes();
      if(!mounted)return;
      if(bytes.isEmpty||bytes.length>5*1024*1024){setState(()=>_error='音檔為空白或超過 5 MiB');return;}
      setState((){_fileName=f.name;_fileBytes=bytes;_extension=extension;_error='';});
    }catch(e){if(mounted)setState(()=>_error='選取失敗：$e');}
    finally{if(mounted)setState(()=>_picking=false);}
  }
  Future<void> _generate() async {
    if(_locked)return;
    final text=_prompt.text.trim();
    if(text.isEmpty||text.length>450){setState(()=>_error='請輸入 1–450 字音效描述');return;}
    final yes=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('確認付費生成'),content:Text('每次生成（含重新生成）均會消耗 ElevenLabs 額度。長度 ${_duration.toStringAsFixed(1)} 秒。'),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('生成'))]));
    if(yes!=true||!mounted)return;
    setState((){_generating=true;_error='';});
    try {
      await _preview.stop();
      final r=await widget.generate(text,_duration,_type=='ambient');
      final bytes=base64Decode(r['audioBase64'] as String);
      if(bytes.isEmpty||bytes.length>5*1024*1024)throw StateError('音檔大小異常');
      if(mounted)setState((){_fileBytes=bytes;_fileName='AI 生成音效.mp3';_extension='mp3';});
    } on FirebaseFunctionsException catch(e){if(mounted)setState(()=>_error='${e.code}：${e.message}');}
    catch(e){if(mounted)setState(()=>_error='生成失敗：$e');}
    finally{if(mounted)setState(()=>_generating=false);}
  }
  Future<void> _listen() async {
    final bytes=_fileBytes;if(bytes==null||_locked)return;
    try{await _preview.play(bytes,mime:_extension=='wav'?'audio/wav':'audio/mpeg',loop:_type=='ambient',volume:_volume);}
    catch(e){if(mounted)setState(()=>_error='試聽失敗：$e');}
  }
  void _save(){if(_locked)return;final id=_id.text.trim(),name=_name.text.trim();final tags=_tags.text.split(RegExp(r'[,，]')).map((s)=>s.trim()).where((s)=>s.isNotEmpty).toList();if(!RegExp(r'^[a-z0-9_-]{1,80}$').hasMatch(id)||name.isEmpty||name.length>80||tags.length>20||tags.any((s)=>s.length>40)||(widget.old==null&&_fileBytes==null)){setState(()=>_error='請填寫有效 ID、名稱、標籤並選擇音檔');return;}Navigator.pop(context,{'soundId':id,'name':name,'tags':tags,'type':_type,'category':_category,'volume':_volume,'enabled':widget.old?['enabled']==true,if(widget.old==null)...{'extension':_extension!,'audioBase64':base64Encode(_fileBytes!)}});}
  @override Widget build(BuildContext context)=>AlertDialog(title:Text(widget.old==null?'新增音效':'編輯音效'),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:_id,enabled:widget.old==null,decoration:const InputDecoration(labelText:'音效 ID（例如 rain_window）')),TextField(controller:_name,decoration:const InputDecoration(labelText:'名稱')),DropdownButtonFormField<String>(initialValue:_type,items:const [DropdownMenuItem(value:'ambient',child:Text('環境音／循環')),DropdownMenuItem(value:'effect',child:Text('動作音／單次'))],onChanged:_locked?null:(v){if(v!=null)setState((){_type=v;_duration=v=='ambient'?20:3;});}),DropdownButtonFormField<String>(initialValue:_category,items:_categories.entries.map((e)=>DropdownMenuItem(value:e.key,child:Text(e.value))).toList(),onChanged:(v){if(v!=null)setState(()=>_category=v);}),TextField(controller:_tags,decoration:const InputDecoration(labelText:'標籤（逗號分隔）')),Text('預設音量 ${(_volume*100).round()}%'),Slider(value:_volume,onChanged:(v)=>setState(()=>_volume=v)),if(widget.old==null)...[
      const SizedBox(height:12),
      SegmentedButton<bool>(segments:const [ButtonSegment(value:false,label:Text('上傳')),ButtonSegment(value:true,label:Text('AI 生成'))],selected:{_ai},onSelectionChanged:_locked?null:(v){_preview.stop();setState((){_ai=v.first;_fileBytes=null;_fileName=null;_extension=null;});}),
      if(_ai)...[
        TextField(controller:_prompt,enabled:!_locked,maxLength:450,maxLines:3,decoration:const InputDecoration(labelText:'音效描述',hintText:'Gentle rain heard through a closed window, no music or speech.')),
        Text('長度 ${_duration.toStringAsFixed(1)} 秒'),
        Slider(min:0.5,max:30,divisions:59,value:_duration,onChanged:_locked?null:(v)=>setState(()=>_duration=v)),
        Text(_type=='ambient'?'無縫循環生成':'單次音效生成'),
        FilledButton.icon(onPressed:_locked?null:_generate,icon:const Icon(Icons.auto_awesome),label:Text(_generating?'生成中…':_fileBytes==null?'生成（付費）':'重新生成（付費）')),
        if(_generating)const LinearProgressIndicator(),
      ]else OutlinedButton.icon(onPressed:_locked?null:_pick,icon:const Icon(Icons.upload_file),label:Text(_fileName??'選擇 MP3 / WAV（5 MiB）')),
      if(_fileBytes!=null)Wrap(children:[TextButton.icon(onPressed:_locked?null:_listen,icon:const Icon(Icons.play_arrow),label:const Text('試聽')),TextButton(onPressed:()=>_preview.stop(),child:const Text('停止'))]),
    ],if(_error.isNotEmpty)Text(_error,style:TextStyle(color:Theme.of(context).colorScheme.error))])),actions:[TextButton(onPressed:_locked?null:()=>Navigator.pop(context),child:const Text('取消')),FilledButton(onPressed:_locked?null:_save,child:const Text('儲存'))]);
}

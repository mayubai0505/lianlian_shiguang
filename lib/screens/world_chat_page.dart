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
    _run('send',message:text);
  }

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
      appBar:AppBar(title:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(_name,style:GoogleFonts.notoSerifTc(fontSize:17,fontWeight:FontWeight.w600)),
        const Text('私人試玩',style:TextStyle(fontSize:11)),
      ])),
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
        Padding(padding:const EdgeInsets.fromLTRB(12,8,12,12),child:Row(children:[
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

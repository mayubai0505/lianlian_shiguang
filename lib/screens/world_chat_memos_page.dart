import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// World-scoped personal memos. All reads/writes are authorized by Cloud Functions.
class WorldChatMemosPage extends StatefulWidget {
  const WorldChatMemosPage({super.key, required this.worldId, required this.worldName});
  final String worldId;
  final String worldName;
  @override
  State<WorldChatMemosPage> createState() => _WorldChatMemosPageState();
}

class _WorldChatMemosPageState extends State<WorldChatMemosPage> {
  late final HttpsCallable _api = FirebaseFunctions.instanceFor(region:'asia-east1')
      .httpsCallable('worldMemo');
  List<Map<String,dynamic>> _memos = [];
  bool _busy = false;
  String? _error;
  @override
  void initState() { super.initState(); _refresh(); }

  Future<void> _refresh() async {
    setState(() { _busy = true; _error = null; });
    try {
      final r = await _api.call({'worldId':widget.worldId,'action':'list'});
      final d = Map<String,dynamic>.from(r.data as Map);
      final items = (d['memos'] as List? ?? const []).whereType<Map>().map((m) => Map<String,dynamic>.from(m)).toList();
      if (mounted) setState(() => _memos = items);
    } catch(e) { if (mounted) setState(() => _error = '備忘錄讀取失敗：$e'); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  DateTime? _dateOf(dynamic milliseconds) => milliseconds is num
      ? DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt()) : null;

  Future<void> _edit([Map<String,dynamic>? memo]) async {
    final controller = TextEditingController(text:(memo?['content'] ?? '').toString());
    DateTime? reminder = _dateOf(memo?['reminderAt']);
    final result = await showDialog<Map<String,dynamic>>(
      context:context, builder:(dialogContext) => StatefulBuilder(builder:(context,update) => AlertDialog(
      title: Text(memo == null ? '新增備忘錄' : '編輯備忘錄'),
      content: SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,children:[
        TextField(controller:controller, maxLength:2000, maxLines:6, minLines:3,
          decoration:const InputDecoration(hintText:'寫下想記住的事情…',border:OutlineInputBorder())),
        ListTile(title:Text(reminder == null ? '選擇提醒日期' : DateFormat('yyyy/MM/dd').format(reminder!)),
          trailing:const Icon(Icons.calendar_today_outlined),onTap:() async {
            final picked = await showDatePicker(context:context,
              initialDate:reminder ?? DateTime.now(),firstDate:DateTime(2020),lastDate:DateTime(2100));
            if(picked != null) update(() => reminder = picked);
          }),
        if (reminder != null) TextButton(onPressed:()=>update(() => reminder=null),child:const Text('清除提醒日期')),
      ])),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('取消')),
        FilledButton(onPressed:() { if(controller.text.trim().isEmpty)return;
          Navigator.pop(context,{'content':controller.text.trim(), 'reminderAt':reminder?.millisecondsSinceEpoch});
        },child:const Text('儲存'))],
    )));
    controller.dispose();
    if (result == null || !mounted) return;
    setState(()=>_busy=true);
    try {
      await _api.call({'worldId':widget.worldId,'action':memo == null ? 'add':'update',
        if(memo != null) 'memoId':memo['id'],...result});
      await _refresh();
    } catch(e) { if(mounted) setState(()=>_error='儲存失敗：$e'); }
    finally { if(mounted)setState(()=>_busy=false); }
  }

  Future<void> _delete(Map<String,dynamic> memo) async {
    final yes = await showDialog<bool>(context:context,builder:(c)=>AlertDialog(
      title:const Text('刪除備忘錄？'),content:const Text('刪除後無法復原。'),
      actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('取消')),
      FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('刪除'))]));
    if(yes != true || !mounted)return;
    setState(()=>_busy=true);
    try {await _api.call({'worldId':widget.worldId,'action':'delete','memoId':memo['id']});await _refresh();}
    catch(e){if(mounted)setState(()=>_error='刪除失敗：$e');}
    finally {if(mounted)setState(()=>_busy=false);}
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:Text('給世界的備忘錄',style:GoogleFonts.notoSerifTc(fontSize:17)),
      actions:[IconButton(onPressed:_busy?null:()=>_edit(),tooltip:'新增備忘錄',icon:const Icon(Icons.add))]),
    body:Column(children:[
      Padding(padding:const EdgeInsets.all(12),child:Text('${widget.worldName}｜個人備忘錄',style:GoogleFonts.notoSerifTc())),
      const Padding(padding:EdgeInsets.symmetric(horizontal:16),child:Text('提醒日期僅作為備忘標記，目前尚未串接系統推播提醒。',style:TextStyle(fontSize:12))),
      if(_error != null) Padding(padding:const EdgeInsets.all(10),child:Text(_error!,style:TextStyle(color:Theme.of(context).colorScheme.error))),
      if(_busy) const LinearProgressIndicator(),
      Expanded(child:_memos.isEmpty ? Center(child:Text(_busy?'正在讀取…':'尚無備忘錄，點擊右上角＋新增'))
       :ListView.separated(itemCount:_memos.length,separatorBuilder:(_,__)=>const Divider(height:1),
        itemBuilder:(context,i){final m=_memos[i];final date=_dateOf(m['reminderAt']);
          return ListTile(title:Text((m['content']??'').toString(),maxLines:5,overflow:TextOverflow.ellipsis),
            subtitle:date==null?null:Text('提醒日期：${DateFormat('yyyy/MM/dd').format(date)}'),
            onTap:_busy?null:()=>_edit(m), trailing:IconButton(icon:const Icon(Icons.delete_outline),
              onPressed:_busy?null:()=>_delete(m)));
        })),
    ]),
    floatingActionButton:FloatingActionButton(onPressed:_busy?null:()=>_edit(),child:const Icon(Icons.add)),
  );
}

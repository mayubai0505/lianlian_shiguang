import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/app_constants.dart';
import '../services/promotion_media.dart';

class AdminSocialPromotionPage extends StatefulWidget {
  const AdminSocialPromotionPage({super.key});
  @override State<AdminSocialPromotionPage> createState() => _AdminSocialPromotionPageState();
}
class _AdminSocialPromotionPageState extends State<AdminSocialPromotionPage> {
  final _db=FirebaseFirestore.instance;
  final _functions=FirebaseFunctions.instanceFor(region:'us-central1');
  final _storage=FirebaseStorage.instance;
  String _filter='pending', _search='', _error='';
  String? _busyId;
  late Stream<QuerySnapshot<Map<String,dynamic>>> _stream;
  final _labels=const {'pending':'待處理','published':'已宣傳','returned':'退回修改','all':'全部紀錄'};
  DocumentReference<Map<String,dynamic>> get _base=>_db.collection('artifacts').doc(AppConfig.appId);
  @override void initState(){super.initState();_setStream();}
  void _setStream(){
    final col=_base.collection('creator_social_promotions');
    _stream=(_filter=='all'?col.where('status',whereIn:['pending','published','returned']):col.where('status',isEqualTo:_filter)).snapshots();
  }
  String _s(Map<String,dynamic> r,String field)=>r[field]?.toString()??'';
  Future<void> _run(String id,Future<void> Function() action) async {
    if(_busyId!=null||!mounted)return;
    setState((){_busyId=id;_error='';});
    try{await action();}catch(e){if(mounted)setState(()=>_error=e is FirebaseFunctionsException?(e.message??e.code):'操作失敗：$e');}
    finally{if(mounted)setState(()=>_busyId=null);}
  }
  Future<Uint8List> _media(Map<String,dynamic> r) async {
    final path=_s(r,'assetPath'), mime=_s(r,'mime'), expected=r['size'];
    if(!path.startsWith('creator_promotion_assets/${_s(r,'creatorUid')}/${_s(r,'workType')}_${_s(r,'workId')}/')||!promotionExtensionByMime.containsKey(mime)||expected is! num||expected<=0||expected>promotionMaxBytes(mime))throw StateError('素材紀錄不完整');
    final bytes=await _storage.ref(path).getData(promotionMaxBytes(mime));
    if(bytes==null||bytes.length!=expected.toInt())throw StateError('無法取得完整素材');
    return bytes;
  }
  String _fileName(Map<String,dynamic> r){
    final name=_s(r,'workName').replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1f]'),'_').trim();
    return '${name.isEmpty?'promotion':name}_${_s(r,'workId')}.${promotionExtensionByMime[_s(r,'mime')]??'bin'}';
  }
  Future<void> _preview(String id, Map<String,dynamic> r)=>_run(id,()async{
    final bytes=await _media(r);if(!mounted)return;
    await showPromotionMediaPreview(context,bytes,_s(r,'mime'),title:'${_s(r,'workName')}・素材預覽',error:'此裝置或瀏覽器無法播放這個格式，請下載原始影片後播放。');
  });
  Future<void> _download(String id,Map<String,dynamic> r)=>_run(id,()async{
    final bytes=await _media(r);if(!mounted)return;
    await savePromotionMedia(context,bytes,_fileName(r),_s(r,'mime'));
  });
  Future<void> _showWork(String id,Map<String,dynamic> r)=>_run(id,()async{
    final world=r['workType']=='world';
    final d=await _base.collection(world?'public_worlds':'public_characters').doc(_s(r,'workId')).get();
    if(!mounted)return;
    final data=d.data()??{};
    final available=d.exists&&(data['createdBy']==r['creatorUid'])&&data['isPublic']!=false&&data['isDraft']!=true&&(!world||data['publicPlayable']==true);
    final description=(world?(data['summary']??data['shortPitch']):(data['worldSetting']??data['background']))?.toString()??'';
    await showDialog<void>(context:context,builder:(ctx)=>AlertDialog(title:Text(_s(r,'workName')),content:SingleChildScrollView(child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text('作品 ID：${_s(r,'workId')}'),const SizedBox(height:8),Text(available?'目前為公開作品':'作品已下架、轉私人或不存在；請勿發布宣傳。',style:TextStyle(color:available?Theme.of(ctx).colorScheme.primary:Theme.of(ctx).colorScheme.error)),if(available&&description.isNotEmpty)...[const SizedBox(height:12),Text(description)],])),actions:[TextButton(onPressed:()=>Navigator.of(ctx).pop(),child:const Text('關閉'))]));
  });
  Future<String?> _reasonDialog() async {
    return showDialog<String>(context:context,builder:(_)=>const _PromotionReturnDialog());
  }
  Future<void> _review(String id,Map<String,dynamic> r,String action) async {
    if(_busyId!=null)return;
    String reason='';
    if(action=='returned'){
      final input=await _reasonDialog();if(input==null||!mounted)return;reason=input;
    }else{
      final yes=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:const Text('確認已完成宣傳'),content:Text('請確認《${_s(r,'workName')}》已在官方社群完成宣傳。確認後將通知創作者，本操作不會自動發布 IG 或 Threads。'),actions:[TextButton(onPressed:()=>Navigator.of(ctx).pop(false),child:const Text('取消')),FilledButton(onPressed:()=>Navigator.of(ctx).pop(true),child:const Text('確認完成'))]));
      if(yes!=true||!mounted)return;
    }
    await _run(id,()async{
      final response=await _functions.httpsCallable('adminSocialPromotionUs',options:HttpsCallableOptions(timeout:const Duration(seconds:40))).call({'action':action,'workType':r['workType'],'workId':r['workId'],'revision':r['revision'],'reason':reason});
      if((response.data as Map)['status']!=action)throw StateError('無法確認處理結果');
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(action=='published'?'已標記完成，並建立創作者通知。':'已退回，並建立修改通知。')));
    });
  }
  int _millis(Map<String,dynamic> r){final value=r['submittedAt'];return value is Timestamp?value.millisecondsSinceEpoch:0;}
  @override Widget build(BuildContext context){
    final theme=Theme.of(context), colors=theme.colorScheme;
    return Scaffold(appBar:AppBar(title:const Text('創作者宣傳申請'),actions:[IconButton(tooltip:'重新整理',onPressed:_busyId!=null?null:()=>setState(_setStream),icon:const Icon(Icons.refresh))]),body:Column(children:[
      Padding(padding:const EdgeInsets.fromLTRB(16,12,16,6),child:Align(alignment:Alignment.centerLeft,child:Text('IG / Threads 免費宣傳投稿｜與推薦橫幅、客服案件分開管理',style:theme.textTheme.bodyMedium))),
      Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:TextField(decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'搜尋創作者、ID、作品或文案',border:OutlineInputBorder()),onChanged:(s)=>setState(()=>_search=s.trim().toLowerCase()))),
      Padding(padding:const EdgeInsets.fromLTRB(12,6,12,4),child:Wrap(spacing:8,children:_labels.entries.map((e)=>ChoiceChip(label:Text(e.value),selected:_filter==e.key,onSelected:_busyId!=null?null:(_){setState((){_filter=e.key;_setStream();});})).toList())),
      if(_busyId!=null)const LinearProgressIndicator(),
      if(_error.isNotEmpty)Padding(padding:const EdgeInsets.all(12),child:SelectableText(_error,style:TextStyle(color:colors.error))),
      Expanded(child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:_stream,builder:(context,snap){
        if(snap.hasError)return Center(child:Padding(padding:const EdgeInsets.all(20),child:SelectableText('讀取宣傳申請失敗：${snap.error}')));
        if(!snap.hasData)return const Center(child:CircularProgressIndicator());
        final docs=snap.data!.docs.where((d){final r=d.data();return _search.isEmpty||['creatorName','creatorId','workName','workId','text'].any((f)=>_s(r,f).toLowerCase().contains(_search));}).toList()..sort((a,b)=>_millis(b.data()).compareTo(_millis(a.data())));
        if(docs.isEmpty)return const Center(child:Text('目前沒有符合條件的宣傳申請。'));
        return ListView.builder(padding:const EdgeInsets.fromLTRB(16,8,16,32),itemCount:docs.length+1,itemBuilder:(context,i){
          if(i==0)return Padding(padding:const EdgeInsets.only(bottom:8),child:Text('共 ${docs.length} 筆${_filter=='pending'?'待處理':''}投稿',style:theme.textTheme.titleSmall));
          final doc=docs[i-1], r=doc.data(), id=doc.id;
          final pending=r['status']=='pending', isVideo=r['mediaType']=='video', busy=_busyId!=null;
          final submitted=r['submittedAt'];
          final date=submitted is Timestamp?DateFormat('yyyy/MM/dd HH:mm').format(submitted.toDate().toLocal()):'—';
          return Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:800),child:Card(margin:const EdgeInsets.only(bottom:14),child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Container(width:62,height:62,decoration:BoxDecoration(color:colors.primaryContainer,borderRadius:BorderRadius.circular(12)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(isVideo?Icons.movie_outlined:Icons.image_outlined,color:colors.onPrimaryContainer,size:27),Text(isVideo?'影片':'圖片',style:TextStyle(fontSize:12,color:colors.onPrimaryContainer))])),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('創作者：${_s(r,'creatorName')}',style:theme.textTheme.titleMedium),Text('創作者 ID：${_s(r,'creatorId')}'),Text('${r['workType']=='world'?'新世界公開':'新角色公開'}｜${_s(r,'workName')}'),Text('送出時間：$date',style:theme.textTheme.bodySmall)])),Chip(label:Text(_labels[r['status']]??'未知'))]),
            const SizedBox(height:14),Text('宣傳內文',style:theme.textTheme.titleSmall),const SizedBox(height:6),Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:colors.surfaceContainerHighest,borderRadius:BorderRadius.circular(10)),child:SelectableText(_s(r,'text'))),
            if(r['status']=='returned')Padding(padding:const EdgeInsets.only(top:10),child:Text('退回原因：${_s(r,'reason')}',style:TextStyle(color:colors.error))),
            const SizedBox(height:8),Text('素材類型：${isVideo?'影片（原始檔）':'圖片（待官方加字）'} · ${((r['size'] as num? ?? 0)/1024/1024).toStringAsFixed(1)} MB',style:theme.textTheme.bodySmall),
            const SizedBox(height:8),Wrap(spacing:8,runSpacing:4,children:[
              OutlinedButton.icon(onPressed:busy?null:()async{await Clipboard.setData(ClipboardData(text:_s(r,'text')));if(mounted)ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content:Text('已複製宣傳文案')));},icon:const Icon(Icons.copy_outlined),label:const Text('複製文案')),
              OutlinedButton.icon(onPressed:busy?null:()=>_preview(id,r),icon:const Icon(Icons.visibility_outlined),label:const Text('預覽素材')),
              OutlinedButton.icon(onPressed:busy?null:()=>_download(id,r),icon:const Icon(Icons.download_outlined),label:Text(isVideo?'下載原始影片':'下載原圖')),
              TextButton.icon(onPressed:busy?null:()=>_showWork(id,r),icon:const Icon(Icons.info_outline),label:const Text('查看作品資訊')),
              if(pending)...[FilledButton.icon(onPressed:busy?null:()=>_review(id,r,'published'),icon:const Icon(Icons.check),label:const Text('標記已宣傳')),TextButton(onPressed:busy?null:()=>_review(id,r,'returned'),child:const Text('退回修改'))],
            ]),
          ])))));
        });
      })),
    ]));
  }
}
class _PromotionReturnDialog extends StatefulWidget{
  const _PromotionReturnDialog();
  @override State<_PromotionReturnDialog> createState()=>_PromotionReturnDialogState();
}
class _PromotionReturnDialogState extends State<_PromotionReturnDialog>{
  final _reason=TextEditingController();
  @override void dispose(){_reason.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>AlertDialog(title:const Text('退回宣傳申請'),content:TextField(controller:_reason,minLines:3,maxLines:5,maxLength:500,decoration:const InputDecoration(hintText:'請輸入需要修改的原因，將通知創作者。'),onChanged:(_)=>setState((){})),actions:[TextButton(onPressed:()=>Navigator.of(context).pop(),child:const Text('取消')),FilledButton(onPressed:_reason.text.trim().isEmpty?null:()=>Navigator.of(context).pop(_reason.text.trim()),child:const Text('確認退回'))]);
}

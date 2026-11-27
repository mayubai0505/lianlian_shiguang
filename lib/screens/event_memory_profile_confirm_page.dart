import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/event_access.dart';
import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'event_memory_performance_page.dart';
import 'event_memory_collection_page.dart';

class EventMemoryProfileConfirmPage extends StatefulWidget {
  final String eventId, memoryId, memoryTitle, characterId, characterName, characterAvatarPath;
  final bool isPrivate;
  const EventMemoryProfileConfirmPage({super.key, required this.eventId, required this.memoryId, required this.memoryTitle, required this.characterId, required this.characterName, required this.characterAvatarPath, this.isPrivate = false});
  @override State<EventMemoryProfileConfirmPage> createState() => _ConfirmState();
}

class _ConfirmState extends State<EventMemoryProfileConfirmPage> {
  bool loading = true, busy = false, pending = false, available = false;
  String? error, notice, selected, existing, _requestId;
  int? cost;
  int count = 0;
  List<String> images = [];
  FirebaseFunctions get functions => FirebaseFunctions.instanceFor(region: 'us-central1');
  Map<String,dynamic> get args => {'eventId':widget.eventId,'memoryId':widget.memoryId,'characterId':widget.characterId,'isPrivate':widget.isPrivate};
  String _prefsKey(String uid) => 'limited_memory_request_v2:${Uri.encodeComponent(uid)}:${Uri.encodeComponent(widget.eventId)}:${Uri.encodeComponent(widget.memoryId)}:${Uri.encodeComponent(widget.characterId)}:${widget.isPrivate}';
  String _newId() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }
  String _friendly(Object e) {
    if (e is FirebaseFunctionsException) {
      switch (e.code) {
        case 'permission-denied':
          return '目前無法生成此回憶，請確認活動及角色資格。';
        case 'failed-precondition':
          return '活動、費用或花花餘額可能已變更，請確認後重試。';
        case 'invalid-argument':
          return '資料已變更，請重新確認角色圖片及活動設定。';
        case 'unauthenticated':
          return '請重新登入後再試。';
      }
    }
    return '暫時無法確認生成結果，請重新查詢狀態。';
  }
  @override void initState(){super.initState(); load();}
  Future<void> load() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if(uid == null) throw StateError('not signed in');
      final prefs = await SharedPreferences.getInstance();
      final prefKey = _prefsKey(uid);
      final rid = prefs.getString(prefKey);
      final root = FirebaseFirestore.instance.collection('artifacts').doc(AppConfig.appId);
      final ref = widget.isPrivate ? root.collection('users').doc(uid).collection('private_characters').doc(widget.characterId) : root.collection('public_characters').doc(widget.characterId);
      final eventRef = root.collection(eventDefinitionCollection(widget.eventId)).doc(widget.eventId);
      final r = await functions.httpsCallable('generateEventMemoryUs').call({...args,'action':'status',if(rid!=null) 'requestId':rid});
      final d = Map<String,dynamic>.from(r.data as Map);
      final requestStatus = d['requestStatus'];
      if(rid!=null && (requestStatus=='ready'||requestStatus=='failed'||requestStatus=='deleted')) await prefs.remove(prefKey);
      if(!mounted)return;
      setState((){
        _requestId=(requestStatus=='ready'||requestStatus=='failed'||requestStatus=='deleted')?null:rid;
        existing=d['imageUrl'] as String?;
        count=(d['count'] as num?)?.toInt()??(existing==null?0:1);
        pending=d['status']=='pending'||requestStatus=='pending';
        notice=requestStatus=='failed'?'上次生成未成功，已完成退款處理。':null;
        error=null;
      });
      // Read the live price and active flags; an older collected card is not overwritten.
      final docs = await Future.wait([ref.get(),eventRef.get(),eventRef.collection('memories').doc(widget.memoryId).get()]);
      final c=docs[0].data()??{}, event=docs[1].data()??{}, mem=docs[2].data()??{};
      final urls=<String>{};
      void add(dynamic v){if(v is String&&v.trim().isNotEmpty)urls.add(v.trim());}
      if(c['galleryPaths'] is List)for(final v in c['galleryPaths']){add(v);}
      if(c['gallery'] is List)for(final v in c['gallery']){if(v is Map)add(v['imageUrl']??v['url']);}
      add(c['avatarPath']);
      final now=DateTime.now();
      final start=event['startAt']; final end=event['endAt'];
      final rawCost=mem['costFlowers'];
      final canGenerate=docs.every((doc)=>doc.exists)&&event['isActive']==true&&event['hasMemory']!=false&&mem['isActive']!=false&&mem['generationMode']=='ai'&&!(start is Timestamp&&now.isBefore(start.toDate()))&&!(end is Timestamp&&now.isAfter(end.toDate()))&&rawCost is int&&rawCost>=0;
      if(!mounted)return;
      setState((){images=urls.toList();if(!images.contains(selected))selected=images.isEmpty?null:images.first;cost=rawCost is int?rawCost:null;available=canGenerate;loading=false;error=null;});
    }catch(e){debugPrint('Limited memory status failed: $e');if(mounted)setState((){loading=false;available=false;error=_friendly(e);});}
  }
  void refresh(){if(loading||busy)return;setState(()=>loading=true);load();}
  Future<void> showCard(String url) async {
    await Navigator.of(context).push(MaterialPageRoute(builder:(_)=>EventMemoryPerformancePage(imageUrl:url,memoryTitle:widget.memoryTitle)));
    if(mounted)refresh();
  }
  Future<void> showCollection() async {
    await Navigator.of(context).push(MaterialPageRoute(builder:(_)=>const EventMemoryCollectionPage()));
    if(mounted)refresh();
  }
  Future<void> generate() async {
    if(busy||loading||pending||!available||selected==null||cost==null)return;
    final source=selected!, expectedCost=cost!;
    final uid=FirebaseAuth.instance.currentUser?.uid;
    if(uid==null)return;
    setState(()=>busy=true);
    try {
      final ok=await showDialog<bool>(context:context,builder:(c)=>AlertDialog(title:Text(count>0?'再次生成限定回憶':'生成限定回憶'),content:Text('本次消耗 $expectedCost 花花。每次生成的卡面可能不同，已收藏的卡片不會被覆蓋；失敗自動退款。確定生成？'),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('取消')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('確認生成'))]));
      if(ok!=true||!mounted)return;
      final prefs=await SharedPreferences.getInstance();
      final prefKey=_prefsKey(uid);
      // Keep the same id after a timeout or app restart; only a terminal job permits a new id.
      final rid=_requestId??prefs.getString(prefKey)??_newId();
      if(!await prefs.setString(prefKey,rid))throw StateError('cannot persist request');
      _requestId=rid;
      if(!mounted||FirebaseAuth.instance.currentUser?.uid!=uid)return;
      final r=await functions.httpsCallable('generateEventMemoryUs',options:HttpsCallableOptions(timeout:const Duration(minutes:7))).call({...args,'action':'generate','requestId':rid,'sourceImageUrl':source,'expectedCost':expectedCost});
      final d=Map<String,dynamic>.from(r.data as Map);
      if(!mounted)return;
      final url=d['status']=='ready'&&d['imageUrl'] is String?d['imageUrl'] as String:null;
      // Reload authoritative status/count. Retain the request id until a terminal result.
      await load();
      if(!mounted)return;
      if(url!=null)showCard(url);
      else if(d['status']=='busy'||d['status']=='pending')setState(()=>notice='已有一張回憶正在處理中，請稍後查詢。');
    }catch(e){
      debugPrint('Limited memory generate failed: $e');
      if(mounted){
        final message=_friendly(e);
        await load();
        if(mounted){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(notice??message)));}
      }
    }finally{if(mounted)setState(()=>busy=false);}
  }
  Widget preview(String url){try {final provider=getAvatarImageProvider(url);if(provider==null)return const Icon(Icons.broken_image);return Image(image:provider,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Icon(Icons.broken_image));}catch(_){return const Icon(Icons.broken_image);}}
  @override Widget build(BuildContext context){
    final theme=Theme.of(context);
    return Scaffold(appBar:AppBar(title:Text(widget.memoryTitle)),body:SafeArea(child:loading?const Center(child:CircularProgressIndicator()):busy?const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[CircularProgressIndicator(),SizedBox(height:20),Text('正在編織專屬回憶…')])):ListView(padding:const EdgeInsets.all(20),children:[
      Text(widget.characterName,style:theme.textTheme.headlineSmall),
      if(existing!=null)...[
        const SizedBox(height:12),Text('已收藏 $count 張專屬限定回憶',style:theme.textTheme.titleMedium),
        OutlinedButton(onPressed:()=>showCard(existing!),child:const Text('查看最近一張回憶')),
        TextButton(onPressed:showCollection,child:const Text('查看所有拾光收藏')),
      ],
      if(notice!=null)Text(notice!),
      if(error!=null)Text(error!),
      if(pending)const Padding(padding:EdgeInsets.symmetric(vertical:12),child:Text('帳號已有一張回憶正在處理中，請稍後重新查詢。請勿重複付款。')),
      if(error!=null||pending||!available)OutlinedButton(onPressed:refresh,child:const Text('重新查詢狀態')),
      if(!pending&&error==null&&available)...[
        const SizedBox(height:16),const Text('選擇角色參考圖片'),const SizedBox(height:12),
        if(images.isEmpty)const Text('這位角色目前沒有可使用的圖片。'),
        Wrap(spacing:10,runSpacing:10,children:images.map((url)=>InkWell(onTap:()=>setState(()=>selected=url),child:Container(width:100,height:120,decoration:BoxDecoration(border:Border.all(color:selected==url?theme.colorScheme.primary:Colors.transparent,width:3)),child:preview(url)))).toList()),
        const SizedBox(height:20),Text('每次生成：$cost 花花'),
        FilledButton(onPressed:selected==null||cost==null?null:generate,child:Text(count>0?'再次生成・$cost 花花':'生成限定回憶・$cost 花花')),
        const Text('活動期間可再次生成，也可於拾光收藏刪除不想保留的卡片。'),
      ],
      if(!available&&error==null&&!pending)const Text('活動或篇章目前未開放生成，既有收藏仍可查看。'),
    ])));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import '../services/app_constants.dart';
import '../utils/image_utils.dart';
import 'event_memory_performance_page.dart';

class EventMemoryProfileConfirmPage extends StatefulWidget {
  final String eventId, memoryId, memoryTitle, characterId, characterName, characterAvatarPath;
  final bool isPrivate;
  const EventMemoryProfileConfirmPage({super.key, required this.eventId, required this.memoryId, required this.memoryTitle, required this.characterId, required this.characterName, required this.characterAvatarPath, this.isPrivate = false});
  @override State<EventMemoryProfileConfirmPage> createState() => _ConfirmState();
}
class _ConfirmState extends State<EventMemoryProfileConfirmPage> {
  bool loading = true, busy = false;
  String? error, selected, existing;
  int? cost;
  bool pending = false;
  List<String> images = [];
  FirebaseFunctions get functions => FirebaseFunctions.instanceFor(region: 'us-central1');
  Map<String,dynamic> get args => {'eventId':widget.eventId,'memoryId':widget.memoryId,'characterId':widget.characterId,'isPrivate':widget.isPrivate};
  @override void initState(){super.initState(); load();}
  Future<void> load() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final root = FirebaseFirestore.instance.collection('artifacts').doc(AppConfig.appId);
      final ref = widget.isPrivate ? root.collection('users').doc(uid).collection('private_characters').doc(widget.characterId) : root.collection('public_characters').doc(widget.characterId);
      final c = (await ref.get()).data() ?? {};
      final mem = (await root.collection('events').doc(widget.eventId).collection('memories').doc(widget.memoryId).get()).data() ?? {};
      final urls = <String>{};
      void add(dynamic v){if(v is String && v.trim().isNotEmpty) urls.add(v.trim());}
      if(c['galleryPaths'] is List) for(final v in c['galleryPaths']) {add(v);}
      if(c['gallery'] is List) for(final v in c['gallery']) {if(v is Map) add(v['imageUrl'] ?? v['url']);}
      add(c['avatarPath']);
      final r = await functions.httpsCallable('generateEventMemoryUs').call({...args,'action':'status'});
      final d = Map<String,dynamic>.from(r.data as Map);
      if(!mounted)return;
      setState((){images=urls.toList();selected=images.isEmpty?null:images.first;cost=(mem['costFlowers'] as num?)?.toInt();existing=d['imageUrl'] as String?;pending=d['status']=='pending';loading=false;error=null;});
    } catch(e){if(mounted)setState((){loading=false;error='讀取失敗：$e';});}
  }
  void showCard(String url){Navigator.of(context).push(MaterialPageRoute(builder:(_)=>EventMemoryPerformancePage(imageUrl:url,memoryTitle:widget.memoryTitle)));}
  Future<void> generate() async {
    if(busy||selected==null||cost==null)return;
    setState(()=>busy=true);
    try {
      final ok=await showDialog<bool>(context:context,builder:(c)=>AlertDialog(title:const Text('生成限定回憶'),content:Text('本次消耗 $cost 花花。AI 生成的造型及文字可能略有差異；失敗自動退款。確定生成？'),actions:[TextButton(onPressed:()=>Navigator.pop(c,false),child:const Text('取消')),FilledButton(onPressed:()=>Navigator.pop(c,true),child:const Text('確認生成'))]));
      if(ok!=true||!mounted)return;
      final r=await functions.httpsCallable('generateEventMemoryUs',options:HttpsCallableOptions(timeout:const Duration(minutes:5))).call({...args,'action':'generate','sourceImageUrl':selected,'expectedCost':cost});
      final d=Map<String,dynamic>.from(r.data as Map);
      if(!mounted)return;
      if(d['imageUrl'] is String){setState(()=>existing=d['imageUrl'] as String);showCard(existing!);}else{setState(()=>pending=true);}
    } catch(e){if(mounted){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('生成未完成：$e。請重新查詢收藏狀態。')));setState(()=>pending=true);}} finally{if(mounted)setState(()=>busy=false);}
  }
  Widget preview(String url){try {final provider=getAvatarImageProvider(url);if(provider==null)return const Icon(Icons.broken_image);return Image(image:provider,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Icon(Icons.broken_image));}catch(_){return const Icon(Icons.broken_image);}}
  @override Widget build(BuildContext context){return Scaffold(appBar:AppBar(title:Text(widget.memoryTitle)),body:SafeArea(child:loading?const Center(child:CircularProgressIndicator()):busy?const Center(child:Column(mainAxisSize:MainAxisSize.min,children:[CircularProgressIndicator(),SizedBox(height:20),Text('正在編織專屬回憶…')])):ListView(padding:const EdgeInsets.all(20),children:[Text(widget.characterName,style:Theme.of(context).textTheme.headlineSmall),if(error!=null) Text(error!),if(error!=null||pending) OutlinedButton(onPressed:(){setState(()=>loading=true);load();},child:const Text('重新查詢狀態')),if(existing!=null) FilledButton(onPressed:()=>showCard(existing!),child:const Text('查看已收藏回憶')),if(existing==null&&!pending&&error==null)...[const Text('選擇角色參考圖片'),const SizedBox(height:12),Wrap(spacing:10,runSpacing:10,children:images.map((url)=>InkWell(onTap:()=>setState(()=>selected=url),child:Container(width:100,height:120,decoration:BoxDecoration(border:Border.all(color:selected==url?Theme.of(context).colorScheme.primary:Colors.transparent,width:3)),child:preview(url)))).toList()),const SizedBox(height:20),Text(cost==null?'此篇尚未開放 AI 生成':'生成費用：$cost 花花'),FilledButton(onPressed:selected==null||cost==null?null:generate,child:const Text('生成限定回憶'))],if(pending) const Text('請稍後查詢，或至拾光收藏查看。請勿重複付款。')])));}
}

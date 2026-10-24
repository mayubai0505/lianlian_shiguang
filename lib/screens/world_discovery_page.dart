import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_constants.dart';
import 'world_chat_page.dart';

/// 公開世界觀資料頁。不呼叫私人試玩 API；正式公共遊玩 API 上線前不允許非擁有者進入。
class WorldDiscoveryPage extends StatefulWidget {
  const WorldDiscoveryPage({super.key, required this.worldId});
  final String worldId;
  @override
  State<WorldDiscoveryPage> createState() => _WorldDiscoveryPageState();
}

class _WorldDiscoveryPageState extends State<WorldDiscoveryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final Future<DocumentSnapshot<Map<String, dynamic>>> _worldFuture;
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _worldFuture = FirebaseFirestore.instance.collection('artifacts')
        .doc(AppConfig.appId).collection('worlds').doc(widget.worldId).get();
  }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  String _s(Map<String, dynamic> d, String key) => (d[key] ?? '').toString();

  Widget _image(String url, {BoxFit fit = BoxFit.cover}) => url.isEmpty
      ? ColoredBox(color:Theme.of(context).colorScheme.surfaceContainerHighest,
          child:const Center(child:Icon(Icons.image_outlined,size:36)))
      : Image.network(url,fit:fit,errorBuilder:(_,__,___)=>
          const Center(child:Icon(Icons.broken_image_outlined)));

  Widget _storyTab(Map<String,dynamic> d) {
    final cover = _s(d,'coverImage');
    final name = _s(d,'name');
    final story = _s(d,'storyOpening');
    final first = _s(d,'firstLine');
    return ListView(padding:const EdgeInsets.fromLTRB(16,20,16,24),children:[
      // 名稱不疊在圖片上；兩行保底 16pt。
      Text(name,maxLines:2,overflow:TextOverflow.visible,
        style:GoogleFonts.notoSerifTc(fontSize:name.runes.length>22 ? 16 :
          name.runes.length>14 ? 20 : 26,fontWeight:FontWeight.w700)),
      const SizedBox(height:18),
      Text('故事開場',style:GoogleFonts.notoSerifTc(fontSize:17,fontWeight:FontWeight.w600)),
      const SizedBox(height:12),
      SelectableText(story.isEmpty?'尚未設定故事開場':story,
        style:const TextStyle(fontSize:14,height:1.8)),
      const SizedBox(height:22),
      Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
        ClipRRect(borderRadius:BorderRadius.circular(12),
          child:SizedBox(width:66,height:66,child:_image(cover))),
        const SizedBox(width:12),
        Expanded(child:Container(
          padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(
            color:Theme.of(context).colorScheme.primary.withValues(alpha:0.07),
            border:Border.all(color:Theme.of(context).colorScheme.primary.withValues(alpha:0.15)),
            borderRadius:BorderRadius.circular(14)),
          child:SelectableText(first.isEmpty?'尚未設定第一句話':first,
            style:const TextStyle(fontSize:14,height:1.7)))),
      ]),
    ]);
  }

  Widget _backgroundTab(Map<String,dynamic> d) {
    final setting=_s(d,'worldSetting');
    final lore=_s(d,'worldLore');
    final era=_s(d,'era');
    return ListView(padding:const EdgeInsets.all(18),children:[
      Text('世界觀背景與說明',style:GoogleFonts.notoSerifTc(
          fontSize:21,fontWeight:FontWeight.w600)),
      if(era.isNotEmpty) ...[const SizedBox(height:12),Text('時空背景：$era')],
      const SizedBox(height:14),
      SelectableText(setting.isEmpty?'尚未設定世界觀背景':setting,
          style:const TextStyle(fontSize:14,height:1.8)),
      if(lore.isNotEmpty) ...[
        const SizedBox(height:22),
        Text('完整世界背景',style:GoogleFonts.notoSerifTc(
            fontSize:17,fontWeight:FontWeight.w600)),
        const SizedBox(height:8),
        SelectableText(lore,style:const TextStyle(fontSize:14,height:1.8)),
      ],
    ]);
  }

  Widget _peopleTab(Map<String,dynamic> d) {
    final raw = d['npcCharacters'];
    final people = raw is List ? raw.whereType<Map>().map((x)=>
        Map<String,dynamic>.from(x)).toList() : <Map<String,dynamic>>[];
    if(people.isEmpty) return const Center(child:Text('尚未設定人物'));
    people.sort((a,b) => (a['kind']=='main'?0:1).compareTo(b['kind']=='main'?0:1));
    return ListView(padding:const EdgeInsets.all(16),children:[
      Text('人物介紹',style:GoogleFonts.notoSerifTc(
          fontSize:21,fontWeight:FontWeight.w600)),
      const SizedBox(height:14),
      for(final person in people)
        Card(margin:const EdgeInsets.only(bottom:12),clipBehavior:Clip.antiAlias,
          child:Padding(padding:const EdgeInsets.all(10),child:Row(
            crossAxisAlignment:CrossAxisAlignment.start,children:[
              SizedBox(width:104,height:134,child:ClipRRect(
                borderRadius:BorderRadius.circular(10),
                child:_image(_s(person,'avatarUrl')))),
              const SizedBox(width:12),
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text(_s(person,'name'),maxLines:2,
                  style:GoogleFonts.notoSerifTc(fontSize:17,fontWeight:FontWeight.bold)),
                if(_s(person,'role').isNotEmpty) ...[
                  const SizedBox(height:4),Text(_s(person,'role'),
                    style:TextStyle(color:Theme.of(context).colorScheme.primary,fontSize:12))],
                const SizedBox(height:8),
                Text(_s(person,'appearance').isEmpty?'未提供外貌特徵':
                  _s(person,'appearance'),style:const TextStyle(fontSize:13,height:1.6)),
              ])),
            ],
          )),
        ),
    ]);
  }

  Widget _creatorTab(Map<String,dynamic> d) {
    final uid=_s(d,'createdBy');
    if(uid.isEmpty)return const Center(child:Text('尚無創作者資料'));
    return FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
      future:FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder:(context,snap){
        if(!snap.hasData)return const Center(child:CircularProgressIndicator());
        final creator=snap.data?.data()??<String,dynamic>{};
        final name=_s(creator,'nickname').isEmpty?'創作者':_s(creator,'nickname');
        final avatar=_s(creator,'avatarPath');
        return ListView(padding:const EdgeInsets.all(18),children:[
          Text('創作者',style:GoogleFonts.notoSerifTc(
              fontSize:21,fontWeight:FontWeight.w600)),
          const SizedBox(height:18),
          Card(child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[
            CircleAvatar(radius:29,backgroundImage:avatar.startsWith('http')
              ? NetworkImage(avatar):null,child:avatar.startsWith('http')
              ?null:const Icon(Icons.person_outline)),
            const SizedBox(width:14),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,
              children:[const Text('創作者',style:TextStyle(fontSize:12)),
                Text(name,style:GoogleFonts.notoSerifTc(fontSize:17,
                  fontWeight:FontWeight.w600))])),
            // 這裡暫不假裝已完成追蹤；需串現有 follow backend。
          ]))),
          if(_s(creator,'bio').isNotEmpty)...[
            const SizedBox(height:20),
            Text(_s(creator,'bio'),style:const TextStyle(height:1.7)),
          ],
        ]);
      });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
    future:_worldFuture,builder:(context,snapshot){
      if(!snapshot.hasData)return const Scaffold(body:Center(child:CircularProgressIndicator()));
      final d=snapshot.data?.data();
      if(d==null || d['isPublic']!=true || d['status']!='public') {
        return Scaffold(appBar:AppBar(),body:const Center(child:Text('此世界觀未公開')));
      }
      final theme=Theme.of(context);
      final images=(d['images'] is List)
        ? (d['images'] as List).map((x)=>x.toString()).where((x)=>x.isNotEmpty).toList()
        : <String>[];
      if(images.isEmpty && _s(d,'coverImage').isNotEmpty)images.add(_s(d,'coverImage'));
      final isOwner=FirebaseAuth.instance.currentUser?.uid==_s(d,'createdBy');
      // 公共聊天後端尚未實作；即使勾選公開也不能呼叫私人試玩函式。
      final canEnter=isOwner;
      return Scaffold(
        appBar:AppBar(title:const Text('開放世界')),
        body:Column(children:[
          AspectRatio(aspectRatio:16/9,child:PageView(children:[
            for(final url in images) ColoredBox(
              color:theme.colorScheme.surfaceContainerHighest,
              child:_image(url,fit:BoxFit.contain)),
            if(images.isEmpty) _image(''),
          ])),
          TabBar(controller:_tabs,labelColor:theme.colorScheme.primary,
            indicatorColor:theme.colorScheme.primary,
            isScrollable:false,labelPadding:EdgeInsets.zero,
            labelStyle:const TextStyle(fontSize:12,fontWeight:FontWeight.w600),
            unselectedLabelStyle:const TextStyle(fontSize:12),
            tabs:const [Tab(text:'故事開場'),Tab(text:'世界背景'),
              Tab(text:'人物介紹'),Tab(text:'創作者')]),
          Expanded(child:TabBarView(controller:_tabs,children:[
            _storyTab(d),_backgroundTab(d),_peopleTab(d),_creatorTab(d),
          ])),
          SafeArea(top:false,child:Padding(
            padding:const EdgeInsets.fromLTRB(16,8,16,12),
            child:SizedBox(width:double.infinity,child:FilledButton(
              onPressed: () {
                if(!canEnter) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:Text('公開世界聊天功能尚未開放；目前只有建立者可以私人試玩。')));
                  return;
                }
                Navigator.push(context,MaterialPageRoute(
                  builder:(_)=>WorldChatPage(worldId:widget.worldId)));
              },child:const Text('進入世界'),
            )),
          )),
        ]),
      );
    },
  );
}

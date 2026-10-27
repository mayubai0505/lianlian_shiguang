import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

/// 世界觀秘密篇章：由後端檢查劇情並返回解鎖狀態；未解鎖無標題、內容或條件。
class WorldSecretChaptersPage extends StatefulWidget {
  const WorldSecretChaptersPage({super.key,required this.worldId});
  final String worldId;
  @override State<WorldSecretChaptersPage> createState()=>_WorldSecretChaptersPageState();
}
class _WorldSecretChaptersPageState extends State<WorldSecretChaptersPage> {
  late final HttpsCallable api=FirebaseFunctions.instanceFor(region:'asia-east1').httpsCallable(
      'worldSecretChapters',options:HttpsCallableOptions(timeout:const Duration(seconds:115)));
  late Future<List<Map<String,dynamic>>> chapters = _load(check:true);
  Future<List<Map<String,dynamic>>> _load({bool check=false}) async {
    final res=await api.call({'worldId':widget.worldId,'action':check?'check':'list'});
    final data=Map<String,dynamic>.from(res.data as Map);
    return (data['chapters'] as List? ?? []).whereType<Map>().map((v)=>Map<String,dynamic>.from(v)).toList();
  }
  Future<void> _read(Map<String,dynamic> entry) async {
    if(entry['unlocked']!=true)return;
    try {
      final res=await api.call({'worldId':widget.worldId,'action':'read','chapterId':entry['id']});
      if(!mounted)return;
      final chapter=Map<String,dynamic>.from(Map<String,dynamic>.from(res.data as Map)['chapter'] as Map);
      await showDialog<void>(context:context,builder:(ctx)=>AlertDialog(
          title:Text((chapter['title']??AppLocalizations.of(context)!.world_secret_chapters_title1).toString()),
          content:SingleChildScrollView(child:SelectableText((chapter['content']??'').toString())),
          actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:Text(AppLocalizations.of(ctx)!.world_secret_chapters_close1))]));
    } catch (_) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocalizations.of(context)!.world_secret_chapters_read_failed1))); }
  }
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(AppLocalizations.of(context)!.world_secret_chapters_title1)),
      body:FutureBuilder<List<Map<String,dynamic>>>(future:chapters,builder:(context,snapshot){
        if(snapshot.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());
        if(snapshot.hasError)return Center(child:TextButton(onPressed:()=>setState(()=>chapters=_load(check:true)),child:Text(AppLocalizations.of(context)!.world_secret_chapters_retry1)));
        final items=snapshot.data??[];
        if(items.isEmpty)return Center(child:Text(AppLocalizations.of(context)!.world_secret_chapters_empty1));
        return ListView.builder(itemCount:items.length,itemBuilder:(context,i){
          final c=items[i], opened=c['unlocked']==true;
          return ListTile(leading:Icon(opened?Icons.lock_open:Icons.lock_outline),
              title:Text(opened?(c['title']??'秘密篇章').toString():AppLocalizations.of(context)!.world_secret_chapters_locked_chapter1((c['order']??i+1).toString())),
              subtitle:Text(opened?AppLocalizations.of(context)!.world_secret_chapters_unlocked1:AppLocalizations.of(context)!.world_secret_chapters_locked1),
              trailing:opened?const Icon(Icons.chevron_right):null,
              onTap:opened?()=>_read(c):null);
        });
      }));
}

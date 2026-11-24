import 'package:flutter/material.dart';
import 'event_memory_collection_page.dart';
class EventMemoryPerformancePage extends StatelessWidget {
  final String imageUrl, memoryTitle;
  const EventMemoryPerformancePage({super.key,required this.imageUrl,required this.memoryTitle});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(memoryTitle)),body:SafeArea(child:Column(children:[Expanded(child:Center(child:InteractiveViewer(child:Image.network(imageUrl,fit:BoxFit.contain,errorBuilder:(_,__,___)=>const Text('圖片暫時無法載入，請至收藏重試'))))),const Padding(padding:EdgeInsets.all(12),child:Text('已永久收藏至拾光檔案')),FilledButton(onPressed:()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>const EventMemoryCollectionPage())),child:const Text('查看收藏')),const SizedBox(height:16)])));
}

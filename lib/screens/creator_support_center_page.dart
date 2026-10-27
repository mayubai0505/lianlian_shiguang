import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/toast_utils.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

final _supportFns = FirebaseFunctions.instanceFor(region: 'asia-east1');
Future<Map<String,dynamic>> _supportCall(String name,[Map<String,dynamic>? data]) async {
 final response=await _supportFns.httpsCallable(name).call(data??<String,dynamic>{});
 return Map<String,dynamic>.from(response.data as Map);
}
const supportCategories=['角色管理問題','AI 角色互動異常','創作者後台問題','合作與權益問題','其他問題'];
const supportLabels={'pending':'pending','in_progress':'in_progress','waiting_creator':'waiting_creator','resolved':'resolved'};

String _supportCategoryText1(BuildContext context, String value) {
 final l10n = AppLocalizations.of(context)!;
 switch (value) {
  case '角色管理問題': return l10n.creator_support_cat_character1;
  case 'AI 角色互動異常': return l10n.creator_support_cat_ai1;
  case '創作者後台問題': return l10n.creator_support_cat_dashboard1;
  case '合作與權益問題': return l10n.creator_support_cat_cooperation1;
  case '其他問題': return l10n.creator_support_cat_other1;
  default: return value;
 }
}
String _supportStatusText1(BuildContext context, dynamic status) {
 final l10n = AppLocalizations.of(context)!;
 switch (status?.toString()) {
  case 'pending': return l10n.creator_support_status_pending1;
  case 'in_progress': return l10n.creator_support_status_progress1;
  case 'waiting_creator': return l10n.creator_support_status_waiting1;
  case 'resolved': return l10n.creator_support_status_resolved1;
  default: return status?.toString() ?? '';
 }
}

class CreatorSupportCenterPage extends StatefulWidget {
 const CreatorSupportCenterPage({super.key});
 @override State<CreatorSupportCenterPage> createState()=>_CreatorSupportCenterState();
}
class _CreatorSupportCenterState extends State<CreatorSupportCenterPage> {
 List<Map<String,dynamic>> cases=[];String? cursor;bool loading=false;String? error;
 @override void initState(){super.initState();_load(true);}
 Future<void> _load(bool reset) async {
  if(loading)return;setState(()=>loading=true);
  try {final r=await _supportCall('listCreatorSupportCases',{'cursor':reset?'':cursor??'','asCreator':true});if(!mounted)return;
  setState(() {final incoming=(r['items'] as List? ??[]).map((e)=>Map<String,dynamic>.from(e as Map)).toList();cases=reset?incoming:[...cases,...incoming];cursor=r['nextCursor']?.toString();error=null;});
  }catch(e){if(mounted)setState(()=>error=e.toString());}finally{if(mounted)setState(()=>loading=false);}
 }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(AppLocalizations.of(context)!.creator_support_page_title1,style:GoogleFonts.notoSerifTc())),body:Column(children:[
  Padding(padding:const EdgeInsets.all(16),child:SizedBox(width:double.infinity,child:FilledButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const _NewCreatorCasePage())).then((_){_load(true);}),child:Text(AppLocalizations.of(context)!.creator_support_new_report1)))),
  if(error!=null)Padding(padding:const EdgeInsets.all(12),child:Text(AppLocalizations.of(context)!.creator_support_error1)),
  Expanded(child:RefreshIndicator(onRefresh:()=>_load(true),child:ListView(children:[
   if(cases.isEmpty&&!loading)Padding(padding:EdgeInsets.all(24),child:Center(child:Text(AppLocalizations.of(context)!.creator_support_no_cases1))),
   for(final item in cases)Card(margin:const EdgeInsets.symmetric(horizontal:14,vertical:5),child:ListTile(title:Text(item['title']?.toString()??''),subtitle:Text('${_supportCategoryText1(context, (item['category']??'').toString())} · ${_supportStatusText1(context, item['status'])}'),trailing:(item['creatorUnreadCount'] as num? ??0)>0?Text(AppLocalizations.of(context)!.creator_support_unread1):const Icon(Icons.chevron_right_rounded),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CreatorSupportCasePage(caseId:item['id'].toString()))).then((_){_load(true); }))),
   if(cursor!=null)TextButton(onPressed:loading?null:()=>_load(false),child:Text(AppLocalizations.of(context)!.creator_support_load_more1)),
   if(loading)Padding(padding:EdgeInsets.all(16),child:Center(child:CircularProgressIndicator())),
  ]))) ]));
}
class _NewCreatorCasePage extends StatefulWidget{const _NewCreatorCasePage();@override State<_NewCreatorCasePage> createState()=>_NewCreatorCaseState();}
class _NewCreatorCaseState extends State<_NewCreatorCasePage>{
 String category=supportCategories.first;String? characterId; final title=TextEditingController();final description=TextEditingController();bool busy=false; final List<Uint8List> screenshots=[];
 Future<void> pickImages()async {
  try {final picked=await ImagePicker().pickMultiImage(imageQuality:70,maxWidth:1400,maxHeight:1400);
  for(final x in picked){if(screenshots.length>=3)break;final bytes=await x.readAsBytes();if(bytes.length>2*1024*1024){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_image_too_large1,isError:true);continue;}screenshots.add(bytes);}
  if(mounted)setState((){});
  }catch(e){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_error1,isError:true);}
 }
 @override void dispose(){title.dispose();description.dispose();super.dispose();}
 Future<void> submit()async{if(busy)return;if(title.text.trim().isEmpty||description.text.trim().isEmpty){ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_fill_title_description1,isError:true);return;}
 setState(()=>busy=true);try{final r=await _supportCall('createCreatorSupportCase',{'category':category,'title':title.text.trim(),'description':description.text.trim(),'characterId':characterId??''});final caseId=r['caseId']?.toString()??'';var failed=0;for(final bytes in screenshots){try{await _supportCall('uploadCreatorSupportImage',{'caseId':caseId,'imageBase64':base64Encode(bytes)});}catch(e){failed++;debugPrint('客服圖片上傳失敗: $e');}}if(!mounted)return;ToastUtils.showCenterToast(context,failed==0?AppLocalizations.of(context)!.creator_support_case_sent1:AppLocalizations.of(context)!.creator_support_case_sent_partial1(failed));Navigator.pop(context,true);}catch(e){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_error1,isError:true);}finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context){final uid=FirebaseAuth.instance.currentUser?.uid;return Scaffold(appBar:AppBar(title:Text(AppLocalizations.of(context)!.creator_support_new_report1)),body:ListView(padding:const EdgeInsets.all(18),children:[
  DropdownButtonFormField<String>(value:category,isExpanded:true,decoration:InputDecoration(labelText:AppLocalizations.of(context)!.creator_support_category_label1,border:OutlineInputBorder()),items:supportCategories.map((e)=>DropdownMenuItem(value:e,child:Text(_supportCategoryText1(context,e)))).toList(),onChanged:busy?null:(v)=>setState(()=>category=v??category)),
  const SizedBox(height:14),if(uid!=null)StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:FirebaseFirestore.instance.collection('artifacts').doc(const String.fromEnvironment('APP_ID',defaultValue:'lianlianshiguang')).collection('public_characters').where('createdBy',isEqualTo:uid).snapshots(),builder:(ctx,s){final docs=s.data?.docs??[];return DropdownButtonFormField<String>(value:docs.any((e)=>e.id==characterId)?characterId:null,isExpanded:true,decoration:InputDecoration(labelText:AppLocalizations.of(context)!.creator_support_character_optional1,border:OutlineInputBorder()),items:[DropdownMenuItem<String>(value:'',child:Text(AppLocalizations.of(context)!.creator_support_no_character1)),...docs.map((e)=>DropdownMenuItem(value:e.id,child:Text((e.data()['name']??e.id).toString(),overflow:TextOverflow.ellipsis)))],onChanged:busy?null:(v)=>setState(()=>characterId=v==''?null:v));}),
  const SizedBox(height:14),TextField(controller:title,maxLength:80,enabled:!busy,decoration:InputDecoration(labelText:AppLocalizations.of(context)!.creator_support_report_title1,border:OutlineInputBorder())),
  const SizedBox(height:14),TextField(controller:description,maxLength:3000,minLines:6,maxLines:10,enabled:!busy,decoration:InputDecoration(labelText:AppLocalizations.of(context)!.creator_support_report_description1,border:OutlineInputBorder())),
  const SizedBox(height:12),OutlinedButton(onPressed:busy||screenshots.length>=3?null:pickImages,child:Text(AppLocalizations.of(context)!.creator_support_select_images1(screenshots.length))),if(screenshots.isNotEmpty)Wrap(spacing:8,children:[for(var i=0;i<screenshots.length;i++) Stack(children:[Image.memory(screenshots[i],width:90,height:90,fit:BoxFit.cover),Positioned(right:0,top:0,child:IconButton.filledTonal(onPressed:busy?null:()=>setState(()=>screenshots.removeAt(i)),icon:const Icon(Icons.close,size:16)))] )]),Text(AppLocalizations.of(context)!.creator_support_images_private1,style:TextStyle(fontSize:12)),
  const SizedBox(height:16),FilledButton(onPressed:busy?null:submit,child:Text(busy?AppLocalizations.of(context)!.creator_support_submitting1:AppLocalizations.of(context)!.creator_support_submit1)),
 ]));}
}
class CreatorSupportCasePage extends StatefulWidget{final String caseId;final bool adminMode;const CreatorSupportCasePage({super.key,required this.caseId,this.adminMode=false});@override State<CreatorSupportCasePage> createState()=>_CreatorSupportCasePageState();}
class _CreatorSupportCasePageState extends State<CreatorSupportCasePage>{Map<String,dynamic>? info;List<Map<String,dynamic>> messages=[];List<Map<String,dynamic>> images=[];final reply=TextEditingController();final note=TextEditingController();bool busy=false;bool uploading=false;String? error; String? _pendingReplyId; final List<Uint8List> pickedImages=[];
@override void initState(){super.initState();load();}
@override void dispose(){reply.dispose();note.dispose();super.dispose();}
Future<void> load()async{try{final r=await _supportCall('getCreatorSupportCase',{'caseId':widget.caseId,'asCreator':!widget.adminMode});if(!mounted)return;setState((){info=Map<String,dynamic>.from(r['case'] as Map);messages=(r['messages'] as List).map((e)=>Map<String,dynamic>.from(e as Map)).toList();images=(r['images'] as List? ??[]).map((e)=>Map<String,dynamic>.from(e as Map)).toList();if(widget.adminMode)note.text=info?['internalNote']?.toString()??'';error=null;});}catch(e){if(mounted)setState(()=>error=e.toString());}}
Future<void> pickReplyImages() async {
 if(busy)return;
 try {
  final selection=await ImagePicker().pickMultiImage(imageQuality:70,maxWidth:1400,maxHeight:1400);
  for(final x in selection){if(pickedImages.length>=3)break;
  final bytes=await x.readAsBytes();
  if(bytes.length>2*1024*1024){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_image_max1,isError:true);continue;}
  // Image picker may return JPG or PNG; validate actual bytes before uploading.
  final png=bytes.length>=8 && bytes[0]==137 && bytes[1]==80 && bytes[2]==78 && bytes[3]==71;
  final jpeg=bytes.length>=3 && bytes[0]==255 && bytes[1]==216 && bytes[2]==255;
  if(!png&&!jpeg){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_jpg_png_only1,isError:true);continue;}
  pickedImages.add(bytes);
  }
  if(mounted)setState((){});
 }catch(e){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_error1,isError:true);}
}
// Keep the request ID after an uncertain timeout: retrying must never create duplicates.
String _newReplyId() {
 final random=math.Random.secure();
 final entropy=List<int>.generate(20,(_)=>random.nextInt(256));
 return base64UrlEncode(entropy).replaceAll('=', '');
}
Future<void> send()async{
 if(busy||(reply.text.trim().isEmpty&&pickedImages.isEmpty))return;
 final content=reply.text.trim();
 _pendingReplyId ??= _newReplyId();
 final requestId=_pendingReplyId!;
 setState(()=>busy=true);
 try{
  final result=await _supportCall('replyCreatorSupportCase',{
   'caseId':widget.caseId,'body':content,'asCreator':!widget.adminMode,
   'hasImages':pickedImages.isNotEmpty,'requestId':requestId,
  });
  final messageId=result['messageId']?.toString()??'';
  if(messageId.isEmpty)throw StateError('後端未回傳訊息 ID，請重新載入案件確認狀態');
  // At this point the text is committed. Never resend it because a later image upload failed.
  _pendingReplyId=null;
  final uploads=List<Uint8List>.from(pickedImages);
  reply.clear();pickedImages.clear();
  var failed=0;
  for(final bytes in uploads){
   try{await _supportCall('uploadCreatorSupportImage',{'caseId':widget.caseId,'messageId':messageId,'imageBase64':base64Encode(bytes)});}
   catch(e){failed++;debugPrint('回覆圖片上傳失敗：$e');}
  }
  try {await load();}catch(e){debugPrint('回覆已儲存，畫面重新載入失敗：$e');}
  if(mounted)ToastUtils.showCenterToast(context,failed==0?AppLocalizations.of(context)!.creator_support_reply_sent1:AppLocalizations.of(context)!.creator_support_reply_sent_partial1(failed),isError:failed>0);
 }catch(e){
  // Preserve the draft and request ID for safe retry if persistence is uncertain.
  if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_error1,isError:true);
 }finally{if(mounted)setState(()=>busy=false);}
}

int _remaining(Map<String,dynamic> m) {
 final t=(m['createdAt'] as num?)?.toInt()??0;
 if(t<=0)return 0;
 return ((60000-(DateTime.now().millisecondsSinceEpoch-t)+999)~/1000).clamp(0,60);
}
bool _mine(Map<String,dynamic> m)=>m['senderId']==FirebaseAuth.instance.currentUser?.uid && m['recalled']!=true;
Future<void> _edit(Map<String,dynamic> m) async {
 if (!mounted) return;
 // The dialog owns its controller and disposes it only after TextField unmounts.
 final result = await showDialog<String>(
  context: context,
  builder: (_) => _SupportEditMessageDialog(initialText: m['body']?.toString() ?? ''),
 );
 if (result == null || !mounted) return;
 if (result.isEmpty) {
  ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.creator_support_empty_content1, isError: true);
  return;
 }
 await _operate(m, 'edit', body: result);
}
Future<void> _operate(Map<String,dynamic> m,String operation,{String? body})async{
 if(operation!='edit'){
  final accepted=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title:Text(operation=='recall'?AppLocalizations.of(context)!.creator_support_recall_message1:AppLocalizations.of(context)!.creator_support_delete_message1),
      content:Text(operation=='recall'?AppLocalizations.of(context)!.creator_support_recall_warning1:AppLocalizations.of(context)!.creator_support_delete_warning1),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:Text(AppLocalizations.of(context)!.creator_support_cancel1)),FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:Text(AppLocalizations.of(context)!.creator_support_confirm1))]));
  if(accepted!=true||!mounted)return;
 }
 try{
  await _supportCall('manageCreatorSupportMessage',{'caseId':widget.caseId,'messageId':m['id'],'operation':operation,'asCreator':!widget.adminMode,if(body!=null)'body':body});
  await load();
  if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_operation_success1);
 }catch(e){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_error1,isError:true);}
}
Future<void> _actions(Map<String,dynamic> m) async {
 if (!_mine(m)) return;
 // A focused reply field causes the system keyboard to appear briefly when
 // another route (bottom sheet / confirmation dialog) is pushed.
 FocusManager.instance.primaryFocus?.unfocus();
 final action = await showModalBottomSheet<String>(
  context: context,
  showDragHandle: true,
  requestFocus: false,
  builder: (sheetContext) => SafeArea(
   child: Column(mainAxisSize: MainAxisSize.min, children: [
    ListTile(
     title: Text(AppLocalizations.of(context)!.creator_support_edit_message1),
     enabled: (m['body']?.toString() ?? '').isNotEmpty,
     onTap: () => Navigator.pop(sheetContext, 'edit'),
    ),
    StreamBuilder<int>(
     stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
     builder: (context, snap) {
      final left = _remaining(m);
      return ListTile(
       title: Text(left > 0
           ? AppLocalizations.of(context)!.creator_support_recall_remaining1(left)
           : AppLocalizations.of(context)!.creator_support_recall_expired1),
       enabled: left > 0,
       onTap: left > 0 ? () => Navigator.pop(sheetContext, 'recall') : null,
      );
     },
    ),
    ListTile(
     title: Text(AppLocalizations.of(context)!.creator_support_delete_message1),
     onTap: () => Navigator.pop(sheetContext, 'delete'),
    ),
    const SizedBox(height: 8),
   ]),
  ),
 );
 if (!mounted || action == null) return;
 if (action == 'edit') {
  await _edit(m);
 } else {
  // The bottom sheet is fully dismissed before opening a confirmation dialog.
  FocusManager.instance.primaryFocus?.unfocus();
  await _operate(m, action);
 }
}
Future<void> update({String? status,bool updateNote=false})async{setState(()=>busy=true);try{await _supportCall('updateCreatorSupportCase',{'caseId':widget.caseId,if(status!=null)'status':status,if(updateNote)'internalNote':note.text.trim()});await load();if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_case_updated1);}catch(e){if(mounted)ToastUtils.showCenterToast(context,AppLocalizations.of(context)!.creator_support_error1,isError:true);}finally{if(mounted)setState(()=>busy=false);}}
@override
Widget build(BuildContext context) => Scaffold(
 appBar: AppBar(
  title: Text(AppLocalizations.of(context)!.creator_support_detail_title1),
  actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh_rounded))],
 ),
 body: info == null
     ? Center(child: Text(error == null ? AppLocalizations.of(context)!.creator_support_loading1 : AppLocalizations.of(context)!.creator_support_error1))
     : Column(
  children: [
   // 案件資訊與官方管理操作都能捲動，避免小視窗或鍵盤擠壓高度。
   Expanded(
    child: ListView(
     padding: const EdgeInsets.only(bottom: 12),
     children: [
      Padding(
       padding: const EdgeInsets.all(14),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(info!['title']?.toString() ?? '',
             style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
         Text('${_supportCategoryText1(context, (info!['category']??'').toString())} · ${_supportStatusText1(context, info!['status'])}'),
         if (widget.adminMode)
          Text(AppLocalizations.of(context)!.creator_support_creator_uid1(info!['creatorId'].toString())),
        ],
       ),
      ),
      if (widget.adminMode)
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
         children: [
          Wrap(
           spacing: 4,
           runSpacing: 4,
           children: supportLabels.entries
               .map((e) => ActionChip(
            label: Text(_supportStatusText1(context, e.key)),
            onPressed: busy ? null : () => update(status: e.key),
           ))
               .toList(),
          ),
          TextField(
           controller: note,
           maxLines: 2,
           decoration: InputDecoration(
               labelText: AppLocalizations.of(context)!.creator_support_internal_note1),
          ),
          TextButton(
           onPressed: busy ? null : () => update(updateNote: true),
           child: Text(AppLocalizations.of(context)!.creator_support_save_internal_note1),
          ),
         ],
        ),
       ),
      if(images.any((img)=>(img['messageId']??'').toString().isEmpty))Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(AppLocalizations.of(context)!.creator_support_case_images1,style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:8),Wrap(spacing:10,runSpacing:10,children:[for(final img in images.where((img)=>(img['messageId']??'').toString().isEmpty))_SupportPrivateImage(caseId:widget.caseId,imageId:img['id'].toString())])])),
      const Divider(),
      for (final m in messages)
       GestureDetector(onLongPress:_mine(m)?()=>_actions(m):null,child:Align(
        alignment: m['senderRole'] == 'creator'
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Card(
         child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text(
             m['senderRole'] == 'admin' ? AppLocalizations.of(context)!.creator_support_official1 : AppLocalizations.of(context)!.creator_support_creator1,
             style: const TextStyle(
                 fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 5),
            if(m['recalled']==true)Text(AppLocalizations.of(context)!.creator_support_recalled1,style:TextStyle(color:Colors.grey,fontStyle:FontStyle.italic))
            else if((m['body']?.toString()??'').isNotEmpty)Text(m['body']?.toString() ?? ''),
            if(m['edited']==true&&m['recalled']!=true)Text(AppLocalizations.of(context)!.creator_support_edited1,style:TextStyle(fontSize:11,color:Colors.grey)),
            if(m['recalled']!=true&&images.any((img)=>img['messageId']==m['id']))Padding(padding:const EdgeInsets.only(top:8),child:Wrap(spacing:8,runSpacing:8,children:[for(final img in images.where((img)=>img['messageId']==m['id'])) _SupportPrivateImage(caseId:widget.caseId,imageId:img['id'].toString())])),
           ],
          ),
         ),
        ),
       )),
     ],
    ),
   ),
   if (info!['status'] != 'resolved' || widget.adminMode)
    SafeArea(
     top: false,
     child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Column(mainAxisSize:MainAxisSize.min,children:[
       if(pickedImages.isNotEmpty)SizedBox(height:72,child:ListView(scrollDirection:Axis.horizontal,children:[for(var i=0;i<pickedImages.length;i++) Padding(padding:const EdgeInsets.only(right:8),child:Stack(children:[Image.memory(pickedImages[i],width:64,height:64,fit:BoxFit.cover),Positioned(right:0,top:0,child:InkWell(onTap:busy?null:()=>setState(()=>pickedImages.removeAt(i)),child:const Icon(Icons.cancel,color:Colors.redAccent)))]))])),
       Row(
        children: [
         Expanded(
          child: TextField(
           controller: reply,
           onChanged: (_) => _pendingReplyId = null,
           minLines: 1,
           maxLines: 2,
           maxLength: 3000,
           // 避免預設字數計數器增加底部固定區塊高度。
           buildCounter: (context, {required currentLength,
            required isFocused, maxLength}) => null,
           decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.creator_support_reply_hint1,
            border: OutlineInputBorder(),
            isDense: true,
           ),
          ),
         ),
         const SizedBox(width: 8),
         IconButton(
          tooltip: AppLocalizations.of(context)!.creator_support_attach_image1,
          onPressed: busy || pickedImages.length >= 3 ? null : pickReplyImages,
          icon: Image.asset(
           'assets/images/chat/chat_tool_photo_mask.png',
           width: 24,
           height: 24,
           fit: BoxFit.contain,
           color: busy || pickedImages.length >= 3
               ? Theme.of(context).disabledColor
               : Theme.of(context).colorScheme.primary,
           colorBlendMode: BlendMode.srcIn,
          ),
         ),
         FilledButton(
          onPressed: busy ? null : send,
          child: Text(AppLocalizations.of(context)!.creator_support_send1),
         ),
        ],
       ),]),
     ),
    ),
  ],
 ),
);
}

class CreatorSupportAdminPage extends StatefulWidget{const CreatorSupportAdminPage({super.key});@override State<CreatorSupportAdminPage> createState()=>_CreatorSupportAdminState();}
class _CreatorSupportAdminState extends State<CreatorSupportAdminPage>{List<Map<String,dynamic>> cases=[];String? cursor;bool loading=false;String? error;
@override void initState(){super.initState();load(true);}
Future<void> load(bool reset)async{if(loading)return;setState(()=>loading=true);try{final r=await _supportCall('listCreatorSupportCases',{'cursor':reset?'':cursor??''});if(!mounted)return;setState((){final incoming=(r['items'] as List? ??[]).map((e)=>Map<String,dynamic>.from(e as Map)).toList();cases=reset?incoming:[...cases,...incoming];cursor=r['nextCursor']?.toString();error=null;});}catch(e){if(mounted)setState(()=>error=e.toString());}finally{if(mounted)setState(()=>loading=false);}}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(AppLocalizations.of(context)!.creator_support_admin_title1)),body:RefreshIndicator(onRefresh:()=>load(true),child:ListView(children:[if(error!=null)Padding(padding:const EdgeInsets.all(18),child:Text(AppLocalizations.of(context)!.creator_support_error1)),for(final item in cases)Card(margin:const EdgeInsets.symmetric(horizontal:12,vertical:5),child:ListTile(title:Text(item['title']?.toString()??''),subtitle:Text('${item['creatorName']} · ${_supportStatusText1(context, item['status'])}'),trailing:(item['adminUnreadCount'] as num? ??0)>0?Text(AppLocalizations.of(context)!.creator_support_new_reply1):const Icon(Icons.chevron_right_rounded),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CreatorSupportCasePage(caseId:item['id'].toString(),adminMode:true))).then((_){load(true);}))),if(cursor!=null)TextButton(onPressed:loading?null:()=>load(false),child:Text(AppLocalizations.of(context)!.creator_support_load_more_cases1)),if(loading)Padding(padding:EdgeInsets.all(18),child:Center(child:CircularProgressIndicator()))])));
}

// Only an authorized creator or administrator can fetch attachment bytes.
class _SupportPrivateImage extends StatefulWidget {final String caseId,imageId;const _SupportPrivateImage({required this.caseId,required this.imageId});@override State<_SupportPrivateImage> createState()=>_SupportPrivateImageState();}
class _SupportPrivateImageState extends State<_SupportPrivateImage>{late final Future<Uint8List> bytes;
@override void initState(){super.initState();bytes=_supportCall('getCreatorSupportImage',{'caseId':widget.caseId,'imageId':widget.imageId}).then((r)=>base64Decode(r['imageBase64'] as String));}
@override Widget build(BuildContext context)=>FutureBuilder<Uint8List>(future:bytes,builder:(ctx,s){if(s.hasError)return SizedBox(width:110,height:110,child:Center(child:Text(AppLocalizations.of(context)!.creator_support_image_load_error1)));if(!s.hasData)return const SizedBox(width:110,height:110,child:Center(child:CircularProgressIndicator()));return InkWell(onTap:()=>showDialog<void>(context:context,builder:(ctx)=>Dialog(child:InteractiveViewer(child:Image.memory(s.data!)))),child:Image.memory(s.data!,width:110,height:110,fit:BoxFit.cover));});
}

// A dedicated widget keeps TextEditingController alive for the entire dialog
// transition; disposing in the calling method can race with the closing frame.
class _SupportEditMessageDialog extends StatefulWidget {
 final String initialText;
 const _SupportEditMessageDialog({required this.initialText});

 @override
 State<_SupportEditMessageDialog> createState() => _SupportEditMessageDialogState();
}

class _SupportEditMessageDialogState extends State<_SupportEditMessageDialog> {
 late final TextEditingController _controller;

 @override
 void initState() {
  super.initState();
  _controller = TextEditingController(text: widget.initialText);
 }

 @override
 void dispose() {
  _controller.dispose();
  super.dispose();
 }

 @override
 Widget build(BuildContext context) => AlertDialog(
  title: Text(AppLocalizations.of(context)!.creator_support_edit_message1),
  content: TextField(
   controller: _controller,
   maxLength: 3000,
   minLines: 1,
   maxLines: 5,
   decoration: InputDecoration(hintText: AppLocalizations.of(context)!.creator_support_edit_hint1),
  ),
  actions: [
   TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.creator_support_cancel1)),
   FilledButton(
    onPressed: () => Navigator.pop(context, _controller.text.trim()),
    child: Text(AppLocalizations.of(context)!.creator_support_save1),
   ),
  ],
 );
}
import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/app_constants.dart';
import '../services/promotion_media.dart';

String promotionText(BuildContext context, String zh, String en) =>
    Localizations.localeOf(context).languageCode == 'zh' ? zh : en;

/// Independently accessible; invitations pass only a published work's identity.
/// All ownership checks, identity snapshots and submission states are server-side.
class CreatorSocialPromotionPage extends StatefulWidget {
  const CreatorSocialPromotionPage({super.key, this.workType, this.workId});
  final String? workType, workId;

  static Future<void> invite(BuildContext context, {required String workType, required String workId}) async {
    if (!context.mounted) return;
    try {
      final accepted = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
        icon: Image.asset('assets/images/butterfly_transparent.webp', height: 70, fit: BoxFit.contain),
        title: Text(promotionText(ctx, '恭喜您成功公開作品！', 'Your work is now public!'), textAlign: TextAlign.center),
        content: Text(promotionText(ctx, '想讓更多玩家認識您的創作嗎？戀戀拾光官方很樂意免費協助您宣傳！', 'Let more players discover your work. We would love to promote it for free!'), textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(promotionText(ctx, '下次再說', 'Maybe later'))),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(promotionText(ctx, '我想讓官方幫忙宣傳！', 'Request promotion'))),
        ],
      ));
      if (accepted == true && context.mounted) {
        await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CreatorSocialPromotionPage(workType: workType, workId: workId)));
      }
    } catch (e) {
      // A promotional invitation must never turn an already saved work into a save failure.
      debugPrint('Social promotion invitation unavailable: ${e.runtimeType}');
    }
  }

  @override State<CreatorSocialPromotionPage> createState() => _CreatorSocialPromotionPageState();
}
class _Work {
  const _Work(this.type, this.id, this.name);
  final String type, id, name;
  String get key => '${type}_$id';
}
class _CreatorSocialPromotionPageState extends State<CreatorSocialPromotionPage> {
  final _text = TextEditingController();
  final _db = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instanceFor(region:'us-central1');
  final _storage = FirebaseStorage.instance;
  List<_Work> _works = [];
  _Work? _work;
  Map<String,dynamic>? _record;
  String _creatorName = '', _creatorId = '', _error = '';
  bool _loading = true, _checking = false, _picking = false, _sending = false, _consent = false;
  int _epoch = 0;
  Uint8List? _bytes;
  String? _mime, _fileName;
  double? _progress;
  UploadTask? _upload;
  bool get _locked => _picking || _sending || _checking;
  String t(String zh, String en) => promotionText(context, zh, en);
  CollectionReference<Map<String,dynamic>> get _root => _db.collection('artifacts').doc(AppConfig.appId).collection('creator_social_promotions');
  @override void initState() { super.initState(); _load(); }
  @override void dispose() {
    _epoch++;
    _upload?.cancel();
    _text.dispose();
    super.dispose();
  }
  bool _eligible(String type, Map<String,dynamic> d, String uid) {
    if(d['createdBy']!=uid || d['isPublic']==false || d['isDraft']==true || d['isCompleted']==false) return false;
    if(type=='world') return d['isPublic']==true && d['publicPlayable']==true && d['status']=='public';
    return !['rejected','violation'].contains(d['moderationStatus']) &&
        ([null,'','published','approved','public'].contains(d['status']) || d['moderationStatus']=='approved');
  }
  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) { if(mounted)setState((){_loading=false;_error='請先登入 / Please sign in.';}); return; }
    if(mounted)setState((){_loading=true;_error='';});
    try {
      final base = _db.collection('artifacts').doc(AppConfig.appId);
      final results = await Future.wait([
        _db.collection('users').doc(uid).get(),
        base.collection('public_characters').where('createdBy',isEqualTo:uid).get(),
        base.collection('worlds').where('createdBy',isEqualTo:uid).get(),
      ]);
      if(!mounted)return;
      final profile=(results[0] as DocumentSnapshot<Map<String,dynamic>>).data()??{};
      final items=<_Work>[];
      void add(String type, QuerySnapshot<Map<String,dynamic>> rows){
        for(final doc in rows.docs){final d=doc.data();if(_eligible(type,d,uid)&&RegExp(r'^[A-Za-z0-9_-]{1,160}$').hasMatch(doc.id)){items.add(_Work(type,doc.id,(d['name']??'').toString()));}}
      }
      add('character',results[1] as QuerySnapshot<Map<String,dynamic>>);
      add('world',results[2] as QuerySnapshot<Map<String,dynamic>>);
      items.sort((a,b)=>a.name.compareTo(b.name));
      final nickname=(profile['nickname']??'').toString().trim();
      setState((){_creatorName=nickname.isNotEmpty?nickname:(profile['displayName']??'').toString().trim();_creatorId=(profile['playerID']??'').toString().trim();_works=items;_loading=false;});
      _Work? selected;
      for(final w in items){if(w.type==widget.workType&&w.id==widget.workId){selected=w;break;}}
      selected ??= items.isEmpty ? null : items.first;
      if(selected!=null)await _select(selected);
    }catch(e){if(mounted)setState((){_loading=false;_error='讀取作品失敗 / Unable to load works: $e';});}
  }
  Future<void> _select(_Work work) async {
    if(_sending||_picking)return;
    final epoch=++_epoch;
    setState((){_work=work;_checking=true;_record=null;_text.clear();_bytes=null;_mime=null;_fileName=null;_consent=false;_error='';});
    try {
      final snap=await _root.doc(work.key).get();
      if(!mounted||epoch!=_epoch)return;
      final d=snap.data();
      setState((){_record=d;_text.text=(d?['rawText']??'').toString();});
    }catch(e){if(mounted&&epoch==_epoch)setState(()=>_error='讀取投稿狀態失敗 / Unable to load submission: $e');}
    finally{if(mounted&&epoch==_epoch)setState(()=>_checking=false);}
  }
  Future<void> _pick() async {
    if(_locked)return;
    setState((){_picking=true;_error='';});
    try {
      final file=await openFile(acceptedTypeGroups:const [XTypeGroup(label:'Image / Video',extensions:['jpg','jpeg','png','webp','mp4','mov'],mimeTypes:['image/jpeg','image/png','image/webp','video/mp4','video/quicktime'],uniformTypeIdentifiers:['public.jpeg','public.png','org.webmproject.webp','public.mpeg-4','com.apple.quicktime-movie'])]);
      if(file==null||!mounted)return;
      final mime=promotionMimeByExtension[file.name.split('.').last.toLowerCase()];
      if(mime==null){setState(()=>_error=t('不支援此格式，請選擇 JPG、PNG、WEBP、MP4 或 MOV。','Unsupported format. Choose JPG, PNG, WEBP, MP4 or MOV.'));return;}
      final size=await file.length();
      if(!mounted)return;
      if(size<=0||size>promotionMaxBytes(mime)){setState(()=>_error=t('圖片最多 10 MB，影片最多 50 MB。','Images: max 10 MB; videos: max 50 MB.'));return;}
      final bytes=await file.readAsBytes();
      if(!mounted)return;
      if(bytes.isEmpty||bytes.length>promotionMaxBytes(mime)){setState(()=>_error=t('素材大小不符合限制。','File size is outside the limit.'));return;}
      setState((){_bytes=bytes;_mime=mime;_fileName=file.name;});
    }catch(e){if(mounted)setState(()=>_error='無法選取素材 / Unable to select media: $e');}
    finally{if(mounted)setState(()=>_picking=false);}
  }
  Future<Map<String,dynamic>> _call(Map<String,dynamic> data) async {
    final result=await _functions.httpsCallable('creatorSocialPromotionUs',options:HttpsCallableOptions(timeout:const Duration(seconds:70))).call(data);
    return Map<String,dynamic>.from(result.data as Map);
  }
  Future<void> _submit() async {
    final work=_work, bytes=_bytes, mime=_mime, text=_text.text.trim();
    if(_locked||work==null)return;
    if(text.isEmpty||text.length>2200||bytes==null||mime==null||!_consent||_creatorName.isEmpty||_creatorId.isEmpty){
      setState(()=>_error=t('請完成文案、素材、創作者名稱與 ID，並勾選授權同意。','Please complete the caption, media, creator name and ID, and consent.'));return;
    }
    setState((){_sending=true;_error='';_progress=null;});
    StreamSubscription<TaskSnapshot>? sub;
    final base={'workType':work.type,'workId':work.id};
    try {
      final prep=await _call({...base,'action':'prepare','mime':mime,'size':bytes.length,'text':text,'consent':true});
      if(!mounted)return;
      final path=prep['storagePath'] as String, ticket=prep['ticket'] as String;
      final authUid=FirebaseAuth.instance.currentUser?.uid;
      if(authUid==null||!path.startsWith('creator_promotion_uploads/$authUid/${work.key}/'))throw StateError('Invalid upload target');
      final task=_storage.ref(path).putData(bytes,SettableMetadata(contentType:mime));
      _upload=task;
      sub=task.snapshotEvents.listen((s){if(mounted&&s.totalBytes>0)setState(()=>_progress=s.bytesTransferred/s.totalBytes);});
      await task;
      if(!mounted)return;
      setState(()=>_progress=null);
      final result=await _call({...base,'action':'submit','ticket':ticket});
      if(!['pending','published'].contains(result['status']))throw StateError('Unconfirmed submission');
      if(!mounted)return;
      setState((){_record={'status':result['status'],'rawText':text};_bytes=null;_mime=null;_fileName=null;_consent=false;});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(t('已送出宣傳申請，謝謝您的創作！','Promotion request submitted. Thank you for creating!'))));
    }catch(e){
      // If the callable response was lost after committing, never upload again blindly.
      try{final snap=await _root.doc(work.key).get(const GetOptions(source:Source.server));final d=snap.data();if(mounted&&['pending','published'].contains(d?['status'])){setState((){_record=d;_bytes=null;_mime=null;_fileName=null;_consent=false;_error='';});return;}}catch(_){}
      if(mounted)setState(()=>_error=e is FirebaseFunctionsException ? (e.message??e.code) : '投稿未完成 / Submission failed: $e');
    }finally{await sub?.cancel();_upload=null;if(mounted)setState((){_sending=false;_progress=null;});}
  }
  @override Widget build(BuildContext context) {
    final theme=Theme.of(context), colors=theme.colorScheme;
    final status=_record?['status']?.toString()??'';
    final readOnly=['pending','published'].contains(status);
    final reason=(_record?['reason']??(_record?['priorReturn'] is Map?(_record!['priorReturn'] as Map)['reason']:null)??'').toString();
    final identityReady=_creatorName.isNotEmpty&&_creatorId.isNotEmpty;
    return PopScope(canPop:!_sending,child:Scaffold(
      appBar:AppBar(title:Text(t('官方宣傳計畫','Official promotion')),actions:[IconButton(tooltip:t('重新整理','Refresh'),onPressed:_locked||_loading?null:()=>_work!=null?_select(_work!):_load(),icon:const Icon(Icons.refresh))]),
      body:_loading?const Center(child:CircularProgressIndicator()):Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:680),child:ListView(padding:const EdgeInsets.fromLTRB(20,16,20,40),children:[
        Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(borderRadius:BorderRadius.circular(26),gradient:LinearGradient(colors:[colors.primary.withValues(alpha:.14),colors.secondary.withValues(alpha:.06)],begin:Alignment.topLeft,end:Alignment.bottomRight),border:Border.all(color:colors.primary.withValues(alpha:.18))),child:Column(children:[
          Image.asset('assets/images/butterfly_transparent.webp',height:100,fit:BoxFit.contain),
          Text(t('讓更多人遇見您的作品','Let more people discover your work'),textAlign:TextAlign.center,style:GoogleFonts.notoSerifTc(fontSize:23,fontWeight:FontWeight.w600,color:colors.onSurface)),
          const SizedBox(height:10),Text(t('每一份創作，都值得被更多人看見。','Every creation deserves to be seen.'),textAlign:TextAlign.center,style:theme.textTheme.bodyMedium),
          const SizedBox(height:12),Wrap(alignment:WrapAlignment.center,spacing:12,children:const [Chip(avatar:Icon(Icons.camera_alt_outlined,size:18),label:Text('Instagram')),Chip(avatar:Icon(Icons.alternate_email,size:18),label:Text('Threads'))]),
        ])),
        const SizedBox(height:18),
        Text(t('感謝您在戀戀拾光創造了獨一無二的故事！如果您願意讓官方免費協助宣傳作品，歡迎填寫以下宣傳內文並上傳素材。文末將自動附上您的創作者名稱及 ID。','Thank you for creating a unique story! If you would like free official promotion, submit a caption and one media file. Your creator name and ID will be appended automatically.')),
        const SizedBox(height:16),
        if(_works.isEmpty) ...[Text(t('目前沒有可投稿的公開作品。請先公開角色或世界。','You have no eligible public works yet. Publish a character or world first.'))]
        else ...[
          Text(t('宣傳作品','Work to promote'),style:theme.textTheme.titleMedium),const SizedBox(height:8),
          DropdownButtonFormField<String>(value:_work?.key,isExpanded:true,decoration:const InputDecoration(border:OutlineInputBorder()),items:_works.map((w)=>DropdownMenuItem(value:w.key,child:Text('${w.type=='world'?t('世界','World'):t('角色','Character')}・${w.name}',overflow:TextOverflow.ellipsis))).toList(),onChanged:_locked?null:(key){if(key!=null)_select(_works.firstWhere((w)=>w.key==key));}),
          if(_checking)const Padding(padding:EdgeInsets.all(16),child:Center(child:CircularProgressIndicator()))
          else if(readOnly) ...[
            const SizedBox(height:16),Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[Icon(status=='published'?Icons.check_circle_outline:Icons.schedule,color:colors.primary),const SizedBox(width:8),Expanded(child:Text(status=='published'?t('已完成宣傳','Promotion completed'):t('已送出，等待官方處理','Submitted · Awaiting review'),style:theme.textTheme.titleMedium))]),
              const SizedBox(height:10),Text((_record?['text']??_record?['rawText']??'').toString()),
            ]))),
          ] else if(_work!=null) ...[
            if(status=='returned'||reason.isNotEmpty)Padding(padding:const EdgeInsets.only(top:12),child:Text('${t('退回原因：','Revision requested: ')}$reason',style:TextStyle(color:colors.error))),
            if(status=='uploading')Padding(padding:const EdgeInsets.only(top:12),child:Text(t('上次投稿尚未完成，請重新選擇素材並送出。','Your previous submission was incomplete. Please select your media again.'))),
            const SizedBox(height:22),Text(t('宣傳內文','Caption'),style:theme.textTheme.titleMedium),const SizedBox(height:8),
            TextField(controller:_text,enabled:!_sending,minLines:5,maxLines:10,maxLength:2200,decoration:InputDecoration(border:const OutlineInputBorder(),hintText:t('在這裡介紹您的角色或世界，讓更多玩家認識您的創作吧！','Tell players about your character or world.'))),
            Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:colors.surfaceContainerHighest,borderRadius:BorderRadius.circular(12)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('${t('創作者','Creator')}：${_creatorName.isEmpty?t('未設定','Not set'):_creatorName}'),Text('${t('創作者 ID','Creator ID')}：${_creatorId.isEmpty?t('未設定','Not set'):_creatorId}'),const SizedBox(height:4),Text(t('將自動附於宣傳文末，無須重複輸入。','Automatically appended to your caption.'),style:theme.textTheme.bodySmall)])),
            if(!identityReady)Padding(padding:const EdgeInsets.only(top:8),child:Text(t('請先至個人主頁設定暱稱與 ID。','Please set your nickname and player ID in your profile.'),style:TextStyle(color:colors.error))),
            const SizedBox(height:22),Text(t('宣傳素材','Media'),style:theme.textTheme.titleMedium),const SizedBox(height:8),
            if(_bytes!=null&&_mime!=null) ...[
              ClipRRect(borderRadius:BorderRadius.circular(14),child:_mime!.startsWith('image/')?Image.memory(_bytes!,height:200,fit:BoxFit.contain,errorBuilder:(_,__,___)=>const Icon(Icons.broken_image_outlined)):Container(height:110,color:colors.surfaceContainerHighest,child:Center(child:Icon(Icons.video_file_outlined,size:48,color:colors.primary)))),
              ListTile(contentPadding:EdgeInsets.zero,title:Text(_fileName??'',maxLines:1,overflow:TextOverflow.ellipsis),subtitle:Text('${_mime!.startsWith('video/')?t('影片','Video'):t('圖片','Image')} · ${(_bytes!.length/1024/1024).toStringAsFixed(1)} MB'),trailing:IconButton(onPressed:_locked?null:()=>setState((){_bytes=null;_mime=null;_fileName=null;}),icon:const Icon(Icons.close))),
              TextButton.icon(onPressed:_locked?null:()=>showPromotionMediaPreview(context,_bytes!,_mime!,title:t('素材預覽','Media preview'),error:t('此裝置無法預覽這個檔案，但仍可上傳原始素材。','This device cannot preview the file, but you can still upload the original.')),icon:const Icon(Icons.visibility_outlined),label:Text(t('預覽原始素材','Preview original'))),
            ],
            OutlinedButton.icon(onPressed:_locked?null:_pick,icon:const Icon(Icons.cloud_upload_outlined),label:Text(_bytes==null?t('上傳一張圖片或一部影片','Upload one image or video'):t('更換素材','Replace media'))),
            Text(t('JPG / PNG / WEBP：10 MB｜MP4 / MOV：50 MB','JPG / PNG / WEBP: 10 MB · MP4 / MOV: 50 MB'),style:theme.textTheme.bodySmall),
            const SizedBox(height:14),Card(elevation:0,child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t('宣傳素材處理說明','How we use your media'),style:theme.textTheme.titleMedium),const SizedBox(height:8),Text(t('圖片：官方將加上「戀戀拾光」、「新角色公開／新世界公開」及您的創作者名稱。','Images: we will add the game title, new character/world announcement, and your creator name.')),const SizedBox(height:6),Text(t('影片：保留您的原始創作，不進行額外修改。素材將用於官方 IG 與 Threads 宣傳。','Videos: your original work is kept unchanged. Media may be posted on our official Instagram and Threads.'))]))),
            CheckboxListTile(contentPadding:EdgeInsets.zero,controlAffinity:ListTileControlAffinity.leading,value:_consent,onChanged:_locked?null:(v)=>setState(()=>_consent=v??false),title:Text(t('我確認擁有素材的使用權利，並同意戀戀拾光官方依上述方式使用本次提交的文案及素材進行社群宣傳。','I confirm I have the rights to the media and agree to the official social promotion described above.'))),
            if(_sending)Padding(padding:const EdgeInsets.symmetric(vertical:12),child:LinearProgressIndicator(value:_progress)),
            FilledButton.icon(onPressed:_locked||!identityReady?null:_submit,icon:const Icon(Icons.campaign_outlined),label:Padding(padding:const EdgeInsets.symmetric(vertical:13),child:Text(_sending?t('投稿處理中，請勿離開','Submitting… Please stay on this page'):t('送出宣傳申請','Submit promotion request')))),
            const SizedBox(height:8),Text(t('免費宣傳・自願參加・由官方審核後安排發布','Free · Optional · Subject to official review'),textAlign:TextAlign.center,style:theme.textTheme.bodySmall),
          ],
        ],
        if(_error.isNotEmpty)Padding(padding:const EdgeInsets.only(top:12),child:Text(_error,style:TextStyle(color:colors.error))),
      ]))),
    ));
  }
}

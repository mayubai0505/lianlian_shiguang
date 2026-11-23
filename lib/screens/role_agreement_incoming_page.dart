import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'character_model.dart';
import 'call_screen.dart';
import '../services/role_agreement_native_calls.dart';

/// Notification-tap incoming call invitation, NOT an OS CallKit/Telecom call.
/// Server alone validates the due call and charges exactly once on acceptance.
class RoleAgreementIncomingPage extends StatefulWidget {
  const RoleAgreementIncomingPage({super.key, required this.characterId, required this.agreementId});
  final String characterId;
  final String agreementId;
  @override
  State<RoleAgreementIncomingPage> createState() => _RoleAgreementIncomingPageState();
}

class _RoleAgreementIncomingPageState extends State<RoleAgreementIncomingPage> {
  late final Future<_RoleAgreementInfo> _info = _loadInfo();
  bool _busy = false;
  bool _opened = false;

  FirebaseFunctions get _functions => FirebaseFunctions.instanceFor(region:'us-central1');
  Future<_RoleAgreementInfo> _loadInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('請先登入');
    final agreement = await FirebaseFirestore.instance.collection('role_agreements').doc(uid)
      .collection('characters').doc(widget.characterId)
      .collection('items').doc(widget.agreementId).get();
    if (!agreement.exists) throw StateError('找不到這筆角色約定');
    final data = agreement.data()!;
    if (data['method'] != 'call' || data['status'] != 'ringing') {
      throw StateError('這通約定來電已結束或尚未到時間');
    }
    final appId = const String.fromEnvironment('APP_ID',defaultValue:'lianlianshiguang');
    final db = FirebaseFirestore.instance;
    var charDoc = await db.collection('artifacts').doc(appId)
      .collection('public_characters').doc(widget.characterId).get();
    if (!charDoc.exists) {
      charDoc = await db.collection('artifacts').doc(appId).collection('users').doc(uid)
        .collection('private_characters').doc(widget.characterId).get();
    }
    if (!charDoc.exists) throw StateError('無法找到來電角色');
    final character = await Character.fromFirestoreAsync(charDoc);
    return _RoleAgreementInfo(character:character,content:(data['content']??'').toString(),
      sessionId:(data['sessionId']??'').toString(),status:(data['status']??'').toString());
  }

  Future<void> _decline() async {
    if (_busy) return;
    setState(()=>_busy=true);
    try {
      await _functions.httpsCallable('declineRoleAgreementCall').call({
        'characterId':widget.characterId,'agreementId':widget.agreementId,
      });
      await RoleAgreementNativeCalls.close(widget.agreementId);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('拒接失敗：$e')));
    } finally {if(mounted)setState(()=>_busy=false);}
  }

  Future<void> _answer(_RoleAgreementInfo info) async {
    if (_busy || _opened) return;
    setState(()=>_busy=true);
    bool charged=false;
    bool audioStarted=false;
    bool finalized=false;
    Future<void> finish() async {
      if (finalized) return;
      finalized=true;
      try {await _functions.httpsCallable('finishRoleAgreementCall').call({
        'characterId':widget.characterId,'agreementId':widget.agreementId,
        'connected':audioStarted,
      });} catch(e) {debugPrint('約定通話結算失敗：$e');}
    }
    try {
      final result=await _functions.httpsCallable('acceptRoleAgreementCall').call({
        'characterId':widget.characterId,'agreementId':widget.agreementId,
      });
      charged=true;
      if (!mounted) {await finish();return;}
      _opened=true;
      await Navigator.of(context).push(MaterialPageRoute<void>(builder:(_) => CallOverlay(
        character:info.character,characterId:widget.characterId,
        sessionId:info.sessionId,selectedLanguage:'繁體中文',shouldSave:false,
        incomingAgreementContent:info.content,
        onFirstAudioStarted:(){audioStarted=true;},
        onCallNotConnected:(){if(Navigator.of(context).canPop())Navigator.of(context).pop();},
        onCallEnded:(duration,messages){if(Navigator.of(context).canPop())Navigator.of(context).pop();},
      )));
      await finish();
      if (mounted) Navigator.of(context).pop();
      debugPrint('角色約定來電已結束：${result.data}');
    } catch(e) {
      if (charged) await finish();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('接聽失敗：$e')));
    } finally {if(mounted)setState(()=>_busy=false);}
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Scaffold(appBar:AppBar(title:const Text('拾光約定來電')),
      body:FutureBuilder<_RoleAgreementInfo>(future:_info,builder:(context,snapshot){
        if(snapshot.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());
        if(snapshot.hasError)return Center(child:Padding(padding:const EdgeInsets.all(24),
          child:Text('無法開啟約定來電：${snapshot.error}',textAlign:TextAlign.center)));
        final info=snapshot.data!;
        return Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:420),
          child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
            Icon(Icons.call_rounded,size:76,color:theme.colorScheme.primary),
            const SizedBox(height:20),
            Text(info.character.name,style:theme.textTheme.headlineSmall),
            const SizedBox(height:12),
            Text(info.content,textAlign:TextAlign.center,style:theme.textTheme.bodyLarge),
            const SizedBox(height:18),
            const Text('確認接聽將扣除 20 花花；拒接或未接聽不扣花。',textAlign:TextAlign.center),
            const SizedBox(height:24),
            Row(children:[Expanded(child:OutlinedButton(onPressed:_busy?null:_decline,
              child:const Text('拒接（免費）'))),const SizedBox(width:12),
              Expanded(child:FilledButton(onPressed:_busy?null:()=>_answer(info),
                child:Text(_busy?'處理中…':'接聽（20 花花）')))]),
          ]))));
      }));
  }
}
class _RoleAgreementInfo {
 final Character character;
 final String content,sessionId,status;
 const _RoleAgreementInfo({required this.character,required this.content,
   required this.sessionId,required this.status});
}

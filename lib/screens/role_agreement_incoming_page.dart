import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
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
  const RoleAgreementIncomingPage({super.key, required this.characterId, required this.agreementId, this.inAppInvitation = false, this.onMissed, this.nativeAcceptedWithPrice = false, this.expectedUid, this.previewName = '', this.previewAvatarUrl = ''});
  final String characterId;
  final String agreementId;
  final bool inAppInvitation;
  final bool nativeAcceptedWithPrice;
  final String? expectedUid;
  final String previewName, previewAvatarUrl;
  final void Function(String reason)? onMissed;
  @override
  State<RoleAgreementIncomingPage> createState() => _RoleAgreementIncomingPageState();
}

class _RoleAgreementIncomingPageState extends State<RoleAgreementIncomingPage> {
  late final Future<_RoleAgreementInfo> _info = _loadInfo();
  bool _busy = false;
  bool _opened = false;
  Timer? _ringTimer;
  bool _missed = false;
  late final Future<_RoleAgreementInfo> _directInfo = _prepareDirectCall();
  bool _directEnding = false;
  Future<void>? _nativeCloseTask;

  void _reportMissed(String reason) {
    if (!mounted || _opened || _busy || _missed) return;
    _missed = true;
    _ringTimer?.cancel();
    widget.onMissed?.call(reason);
    Navigator.of(context).pop();
  }

  Future<void> _closeNativeSafely() => _nativeCloseTask ??= _closeNativeOnce();
  Future<void> _closeNativeOnce() async {
    try { await RoleAgreementNativeCalls.close(widget.agreementId).timeout(const Duration(seconds: 3)); }
    catch (e) { debugPrint('[RA] native close failed: $e'); }
  }

  @override
  void initState() {
    super.initState();
    // Once the confirmation route is visible, dismiss the system call UI.
    // This does not accept the server call or charge flowers.
    if (widget.inAppInvitation) {
      _ringTimer = Timer(const Duration(seconds: 30), () => _reportMissed('unanswered'));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (!widget.nativeAcceptedWithPrice) unawaited(_closeNativeSafely());
      });
    }
  }

  // Already consented on Android: load and close native UI concurrently.
  // Keep one route for preparation and CallOverlay, never push a second route.
  Future<_RoleAgreementInfo> _prepareDirectCall() async {
    final close = _closeNativeSafely();
    final info = await _info.timeout(const Duration(seconds: 20));
    await close;
    if (!mounted || _directEnding || widget.expectedUid == null ||
        FirebaseAuth.instance.currentUser?.uid != widget.expectedUid ||
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      throw StateError('來電已取消，請重新建立約定');
    }
    return info;
  }

  void _endDirectRoute() {
    if (!mounted || _directEnding || ModalRoute.of(context)?.isCurrent != true) return;
    _directEnding = true;
    Navigator.of(context).pop();
  }

  Widget _buildDirectCall(BuildContext context) {
    return FutureBuilder<_RoleAgreementInfo>(future: _directInfo, builder: (context, snapshot) {
      if (snapshot.hasData) {
        final info = snapshot.data!;
        return CallOverlay(
          character: info.character, characterId: widget.characterId,
          sessionId: info.sessionId, selectedLanguage: '繁體中文', shouldSave: false,
          incomingAgreementContent: info.content, incomingAgreementId: widget.agreementId,
          onCallNotConnected: _endDirectRoute,
          onCallEnded: (duration, messages) => _endDirectRoute(),
        );
      }
      final avatar = RoleAgreementNativeCalls.safeAvatarUrl(widget.previewAvatarUrl);
      final name = widget.previewName.trim().isEmpty ? '角色' : widget.previewName.trim();
      return Scaffold(backgroundColor: const Color(0xFF1E1E1E), body: SafeArea(
        child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ClipOval(child: SizedBox(width: 120, height: 120, child: avatar.isEmpty
              ? const Icon(Icons.person_rounded, color: Colors.white54, size: 58)
              : CachedNetworkImage(imageUrl: avatar, fit: BoxFit.cover, memCacheWidth: 360,
                  errorWidget: (_, __, ___) => const Icon(Icons.person_rounded, color: Colors.white54, size: 58)))),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (!snapshot.hasError) const CircularProgressIndicator(color: Colors.white70),
            const SizedBox(height: 16),
            Text(snapshot.hasError ? _friendlyError(snapshot.error!) : '正在連線中…',
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            FilledButton(onPressed: _endDirectRoute,
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: Text(snapshot.hasError ? '關閉' : '取消')),
          ])))));
    });
  }

  String _friendlyError(Object error) {
    if (error is FirebaseFunctionsException) {
      switch (error.code) {
        case 'not-found': return '找不到這通約定來電，請重新建立約定。';
        case 'failed-precondition': return error.message ?? '目前無法接聽，請稍後再試。';
        case 'already-exists': return '這通電話已被接聽。';
        case 'unauthenticated': return '請先登入。';
      }
    }
    if (error is StateError) return error.message.toString();
    return '暫時無法連線，請稍後再試。';
  }

  @override
  void dispose() {
    _ringTimer?.cancel();
    if (!widget.inAppInvitation) _closeNativeSafely();
    super.dispose();
  }

  FirebaseFunctions get _functions => FirebaseFunctions.instanceFor(region:'us-central1');
  Future<_RoleAgreementInfo> _loadInfo() async {
    debugPrint('[RA] confirmation page loading');
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || (widget.expectedUid != null && uid != widget.expectedUid)) throw StateError('請先登入');
    final ref = FirebaseFirestore.instance
      .collection('users').doc(uid)
      .collection('characters').doc(widget.characterId)
      .collection('role_agreements').doc(widget.agreementId);
    var agreement = await ref.get(const GetOptions(source: Source.server));
    // Push may arrive just before the dispatcher commits ringing state.
    for (var attempt = 0; attempt < 5 && agreement.exists &&
        agreement.data()?['status'] == 'scheduled'; attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!mounted) throw StateError('來電頁面已關閉');
      agreement = await ref.get(const GetOptions(source: Source.server));
    }
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
    if (widget.inAppInvitation) { _reportMissed('declined'); return; }
    _missed=true;
    setState(()=>_busy=true);
    try {
      await _functions.httpsCallable('declineRoleAgreementCall').call({
        'characterId':widget.characterId,'agreementId':widget.agreementId,
      });
      await _closeNativeSafely();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _missed=false;
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('拒接失敗：${_friendlyError(e)}')));
    } finally {if(mounted)setState(()=>_busy=false);}
  }

  Future<void> _answer(_RoleAgreementInfo info) async {
    if (_busy || _opened || _missed) return;
    if (widget.expectedUid != null && FirebaseAuth.instance.currentUser?.uid != widget.expectedUid) return;
    _ringTimer?.cancel();
    setState(()=>_busy=true);
    try {
      // Explicit confirmation precedes authorization. V4.1 alone reserves and settles.
      _opened=true;
      if (!widget.inAppInvitation) await _closeNativeSafely();
      if (!mounted) return;
      if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed ||
          (widget.expectedUid != null && FirebaseAuth.instance.currentUser?.uid != widget.expectedUid)) {
        _opened=false;
        return;
      }
      final nav=Navigator.of(context);
      await nav.push(MaterialPageRoute<void>(builder:(_) => CallOverlay(
        character:info.character,characterId:widget.characterId,
        sessionId:info.sessionId,selectedLanguage:'繁體中文',shouldSave:false,
        incomingAgreementContent:info.content,incomingAgreementId:widget.agreementId,
        onCallNotConnected:(){if(nav.canPop())nav.pop();},
        onCallEnded:(duration,messages){if(nav.canPop())nav.pop();},
      )));
      if (mounted) Navigator.of(context).pop();
    } catch(e) {
      debugPrint('[RA] V4.1 navigation failed: ${e.runtimeType}');
      _opened=false;
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('接聽失敗：${_friendlyError(e)}')));
    } finally {if(mounted)setState(()=>_busy=false);}
  }

  Widget _avatar(Character character, Color tint) {
    final path = character.avatarPath.trim();
    final fallback = Icon(Icons.person_rounded, size: 58, color: tint);
    Widget child = fallback;
    if (path.startsWith('https://') || path.startsWith('http://')) {
      child = CachedNetworkImage(imageUrl: path, fit: BoxFit.cover,
        memCacheWidth: 360, placeholder: (_, __) => fallback,
        errorWidget: (_, __, ___) => fallback);
    } else if (path.startsWith('assets/')) {
      child = Image.asset(path, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback);
    }
    return Container(width: 148, height: 148, padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle,
        border: Border.all(color: tint, width: 2)),
      child: ClipOval(child: ColoredBox(color: tint.withOpacity(.12),
        child: SizedBox.expand(child: child))));
  }

  Widget _action(String label, IconData icon, Color color, VoidCallback? onTap) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(width: 68, height: 68, child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: color,
          foregroundColor: Colors.white, shape: const CircleBorder(),
          padding: EdgeInsets.zero), onPressed: onTap, child: Icon(icon, size: 30))),
      const SizedBox(height: 10), Text(label),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nativeAcceptedWithPrice) return _buildDirectCall(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return PopScope(canPop: !widget.inAppInvitation,
      child: Scaffold(body: SafeArea(child: FutureBuilder<_RoleAgreementInfo>(
        future: _info, builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const CircularProgressIndicator(), const SizedBox(height: 20),
              const Text('角色來電・載入中…'), const SizedBox(height: 20),
              TextButton(onPressed: _busy ? null : _decline, child: const Text('拒接')),
            ]));
          }
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('無法開啟約定來電：${_friendlyError(snapshot.error!)}', textAlign: TextAlign.center),
              TextButton(onPressed: () { if (widget.inAppInvitation) _reportMissed('unanswered');
                else Navigator.of(context).pop(); }, child: const Text('關閉')),
            ])));
          final info = snapshot.data!;
          return Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [colors.primaryContainer.withOpacity(.55), colors.surface, colors.surface])),
            child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(28),
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('拾光約定・角色主動來電', style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center), const SizedBox(height: 40),
                  _avatar(info.character, colors.primary), const SizedBox(height: 28),
                  Text(info.character.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center), const SizedBox(height: 24),
                  Text('正在撥打電話給你…', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 14),
                  const Text('接通後將扣除20朵花花', textAlign: TextAlign.center),
                  const SizedBox(height: 48),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    _action('拒接', Icons.call_end_rounded, const Color(0xFFCF5362), _busy ? null : _decline),
                    _action(_busy ? '連線中…' : '接聽', Icons.call_rounded, const Color(0xFF399B72),
                      _busy ? null : () => _answer(info)),
                  ]),
                ])))));
        },
      ))));
  }
}

class _RoleAgreementInfo {
 final Character character;
 final String content,sessionId,status;
 const _RoleAgreementInfo({required this.character,required this.content,
   required this.sessionId,required this.status});
}

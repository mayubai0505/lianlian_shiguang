import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/app_constants.dart';
import 'world_chat_page.dart';
import 'creator_profile_page.dart';
import '../widgets/world_echo_wall.dart';
import '../widgets/user_avatar_with_frame.dart';

//開放世界介紹頁。進入世界時由 worldPrivateTest 後端再次檢查公開遊玩權限。
class WorldDiscoveryPage extends StatefulWidget {
  const WorldDiscoveryPage({super.key, required this.worldId, this.creatorPreview = false});
  final String worldId;
  final bool creatorPreview;
  @override
  State<WorldDiscoveryPage> createState() => _WorldDiscoveryPageState();
}

class _WorldDiscoveryPageState extends State<WorldDiscoveryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late Future<DocumentSnapshot<Map<String, dynamic>>> _worldFuture;
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _worldFuture = _fetchWorld();
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchWorld() =>
      FirebaseFirestore.instance.collection('artifacts')
          .doc(AppConfig.appId).collection('worlds').doc(widget.worldId).get();

  void _retryWorldLoad() {
    setState(() => _worldFuture = _fetchWorld());
  }

  @override
  void didUpdateWidget(covariant WorldDiscoveryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.worldId != widget.worldId) {
      _retryWorldLoad();
    }
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  String _s(Map<String, dynamic> d, String key) => (d[key] ?? '').toString();

  final GlobalKey _shareCardKey = GlobalKey();
  bool _sharing = false;
  bool _creatingRoom = false;
  static const String _downloadLink = 'https://lianlianshiguang.web.app/download/';

  String _shareDescription(Map<String, dynamic> world) {
    for (final key in ['shortPitch', 'summary', 'storyOpening']) {
      final value = _s(world, key).trim();
      if (value.isNotEmpty) return value;
    }
    return AppLocalizations.of(context)!.world_discovery_share_desc1;
  }

  String _shareText(Map<String, dynamic> world) {
    final title = _s(world, 'name').trim();
    final description = _shareDescription(world);
    // 目前下載頁是已存在的公開連結；不捏造尚未支援的世界觀深層連結。
    return AppLocalizations.of(context)!.world_discovery_share_text1(title, description, _downloadLink);
  }

  Widget _shareInvitationCard(Map<String, dynamic> world) {
    final theme = Theme.of(context);
    final name = _s(world, 'name');
    final cover = _s(world, 'coverImage');
    final description = _shareDescription(world);
    return RepaintBoundary(
      key: _shareCardKey,
      child: SizedBox(width: 340, height: 435, child: Material(
        color: theme.colorScheme.surface,
        child: Stack(fit: StackFit.expand, children: [
          _image(cover, fit: BoxFit.cover),
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0x22000000), Color(0x44000000), Color(0xEE170F25)],
            stops: [0.0, 0.40, 1.0],
          ))),
          Positioned(top: 22, left: 20, right: 20, child: Row(children: [
            Text(AppLocalizations.of(context)!.world_discovery_brand1, style: TextStyle(color: Colors.white, fontSize: 17,
                fontWeight: FontWeight.w600, letterSpacing: 2)),
            const Spacer(),
            Text(AppLocalizations.of(context)!.world_discovery_invite1, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10)),
          ])),
          Positioned(bottom: 22, left: 20, right: 20, child: Row(
            crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
                  Container(height: 2, width: 40, color: const Color(0xFFE1C7EA)),
                  const SizedBox(height: 12),
                  Text(name, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 9),
                  Text(description, maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.5)),
                ])),
            const SizedBox(width: 12),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
                  child: QrImageView(data: _downloadLink, size: 65, padding: EdgeInsets.zero,
                      backgroundColor: Colors.white)),
              const SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.world_discovery_scan1, style: TextStyle(color: Colors.white, fontSize: 9)),
            ]),
          ],
          )),
        ]),
      )),
    );
  }

  Future<void> _showSharePreview(Map<String, dynamic> world) async {
    await showDialog<void>(context: context, builder: (dialogContext) {
      final screenWidth = MediaQuery.sizeOf(dialogContext).width;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(child: Center(child: Column(
          mainAxisSize: MainAxisSize.min, children: [
          FittedBox(fit: BoxFit.scaleDown, child: _shareInvitationCard(world)),
          const SizedBox(height: 14),
          SizedBox(width: screenWidth > 380 ? 340 : screenWidth - 32,
              child: Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(dialogContext),
                    child: Text(AppLocalizations.of(context)!.world_discovery_cancel1))),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: FilledButton.icon(
                    onPressed: _sharing ? null : () => _shareWorldCard(world),
                    icon: const Icon(Icons.ios_share_rounded), label: Text(AppLocalizations.of(context)!.world_discovery_share_button1))),
              ])),
        ],
        ))),
      );
    });
  }

  Future<void> _shareWorldCard(Map<String, dynamic> world) async {
    if (_sharing) return;
    _sharing = true;
    try {
      // 先完成 QR / 封面繪製，再截取邀請卡。
      await WidgetsBinding.instance.endOfFrame;
      final boundary = _shareCardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw StateError(AppLocalizations.of(context)!.world_discovery_share_missing_card1);
      final img = await boundary.toImage(pixelRatio: 2.5);
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      img.dispose();
      if (bytes == null) throw StateError(AppLocalizations.of(context)!.world_discovery_share_image_failed1);
      await Clipboard.setData(ClipboardData(text: _downloadLink));
      await SharePlus.instance.share(ShareParams(
        files: [XFile.fromData(bytes.buffer.asUint8List(), mimeType: 'image/png')],
        fileNameOverrides: ['open_world_invitation.png'],
        title: AppLocalizations.of(context)!.world_discovery_invite1, text: _shareText(world),
      ));
    } catch (e) {
      debugPrint('開放世界分享失敗：$e');
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.world_discovery_share_failed1, isError: true);
    } finally {
      _sharing = false;
    }
  }


  Widget _image(String url, {BoxFit fit = BoxFit.cover}) => url.isEmpty
      ? ColoredBox(color:Theme.of(context).colorScheme.surfaceContainerHighest,
      child:const Center(child:Icon(Icons.image_outlined,size:36)))
      : CachedNetworkImage(imageUrl:url,fit:fit,
      placeholder:(_,__) => ColoredBox(color:Theme.of(context).colorScheme.surfaceContainerHighest),
      errorWidget:(_,__,___)=>const Center(child:Icon(Icons.broken_image_outlined)));

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
      Text(AppLocalizations.of(context)!.world_discovery_story_open1,style:GoogleFonts.notoSerifTc(fontSize:17,fontWeight:FontWeight.w600)),
      const SizedBox(height:12),
      SelectableText(story.isEmpty?AppLocalizations.of(context)!.world_discovery_story_unset1:story,
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
            child:SelectableText(first.isEmpty?AppLocalizations.of(context)!.world_discovery_first_unset1:first,
                style:const TextStyle(fontSize:14,height:1.7)))),
      ]),
    ]);
  }

  Widget _backgroundTab(Map<String,dynamic> d) {
    // 玩家／創作者預覽僅顯示公開簡介，絕不展示給 AI 的規則及完整世界設定。
    final summary = _s(d, 'summary').trim();
    final era = _s(d, 'era').trim();
    return ListView(padding: const EdgeInsets.all(18), children: [
      Text(
        AppLocalizations.of(context)!.world_edit_public_summary1,
        style: GoogleFonts.notoSerifTc(fontSize: 21, fontWeight: FontWeight.w600),
      ),
      if (era.isNotEmpty) ...[
        const SizedBox(height: 12),
        Text(AppLocalizations.of(context)!.world_discovery_era1(era)),
      ],
      const SizedBox(height: 14),
      SelectableText(
        summary.isEmpty
            ? AppLocalizations.of(context)!.world_discovery_background_unset1
            : summary,
        style: const TextStyle(fontSize: 14, height: 1.8),
      ),
    ]);
  }

  Widget _peopleTab(Map<String,dynamic> d) {
    final raw = d['npcCharacters'];
    final people = raw is List ? raw.whereType<Map>().map((x)=>
    Map<String,dynamic>.from(x)).toList() : <Map<String,dynamic>>[];
    if(people.isEmpty) return Center(child:Text(AppLocalizations.of(context)!.world_discovery_people_unset1));
    people.sort((a,b) => (a['kind']=='main'?0:1).compareTo(b['kind']=='main'?0:1));
    return ListView(padding:const EdgeInsets.all(16),children:[
      Text(AppLocalizations.of(context)!.world_discovery_people_intro1,style:GoogleFonts.notoSerifTc(
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
              Text(_s(person,'appearance').isEmpty?AppLocalizations.of(context)!.world_discovery_appearance_unset1:
              _s(person,'appearance'),style:const TextStyle(fontSize:13,height:1.6)),
            ])),
          ],
          )),
        ),
    ]);
  }

  Widget _creatorTab(Map<String,dynamic> d) {
    final uid = _s(d, 'createdBy');
    if (uid.isEmpty) return Center(child: Text(AppLocalizations.of(context)!.world_discovery_creator_unset1));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
      children: [
        Text(AppLocalizations.of(context)!.world_discovery_creator1, style: GoogleFonts.notoSerifTc(fontSize: 21, fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snap) {
            if (snap.hasError) return Text(AppLocalizations.of(context)!.world_discovery_creator_load_failed1);
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final creator = snap.data?.data() ?? <String, dynamic>{};
            final name = _s(creator, 'nickname').isEmpty ? AppLocalizations.of(context)!.world_discovery_creator1 : _s(creator, 'nickname');
            final avatar = _s(creator, 'avatarPath');
            void openCreator() => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CreatorProfilePage(
                creatorId: uid,
                creatorName: name,
              ),
            ));
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Card(clipBehavior: Clip.antiAlias, child: InkWell(
                  onTap: openCreator,
                  child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                    UserAvatarWithFrame(
                      // 裝備／卸下頭像框時，透過 users/{uid} 即時更新重建頭框。
                      key: ValueKey('world_creator_${uid}_${creator['equippedAvatarFrame']}'),
                      userId: uid,
                      avatarImage: avatar.startsWith('http')
                          ? CachedNetworkImageProvider(avatar)
                          : null,
                      // 外框維持放大；頭像本身恢復原本半徑 29。
                      size: 73,
                      avatarRadius: 29,
                      fallbackChild: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(AppLocalizations.of(context)!.world_discovery_creator1, style: TextStyle(fontSize: 12)),
                      Text(name, style: GoogleFonts.notoSerifTc(fontSize: 17, fontWeight: FontWeight.w600)),
                    ])),
                    const Icon(Icons.chevron_right_rounded),
                  ]))),
              ),
            ]);
          },
        ),
        if (_s(d, 'creatorMessage').trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context)!.world_discovery_creator_message1, style: GoogleFonts.notoSerifTc(
                  fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              SelectableText(_s(d, 'creatorMessage').trim(),
                  style: const TextStyle(fontSize: 14, height: 1.7)),
            ]),
          ),
        ],
        const SizedBox(height: 24),
        WorldEchoWall(worldId: widget.worldId),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
    future:_worldFuture,builder:(context,snapshot){
    if(snapshot.hasError) {
      debugPrint('公開世界介紹資料載入失敗 worldId=${widget.worldId}: ${snapshot.error}');
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              AppLocalizations.of(context)!.world_discovery_world_load_failed1(snapshot.error.toString()),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _retryWorldLoad,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('重新整理'),
            ),
          ]),
        )),
      );
    }
    if(!snapshot.hasData)return const Scaffold(body:Center(child:CircularProgressIndicator()));
    final d=snapshot.data?.data();
    // 草稿僅允許建立者在個人主頁預覽；一般公開入口仍必須正式公開。
    final previewOwner = widget.creatorPreview && d != null &&
        FirebaseAuth.instance.currentUser?.uid == (d['createdBy'] ?? '').toString();
    if(d==null || (!previewOwner && (d['isPublic']!=true || d['status']!='public'))) {
      return Scaffold(appBar:AppBar(),body:Center(child:Text(AppLocalizations.of(context)!.world_discovery_unpublished1)));
    }
    final theme=Theme.of(context);
    final images=(d['images'] is List)
        ? (d['images'] as List).map((x)=>x.toString()).where((x)=>x.isNotEmpty).toList()
        : <String>[];
    if(images.isEmpty && _s(d,'coverImage').isNotEmpty)images.add(_s(d,'coverImage'));
    final isOwner=FirebaseAuth.instance.currentUser?.uid==_s(d,'createdBy');
    // 非創作者需由公開核准標記允許；後端仍會再次驗證。
    final canEnter=isOwner || d['publicPlayable']==true;
    return Scaffold(
      appBar:AppBar(
        title: Text(_s(d, 'name').trim().isNotEmpty
            ? _s(d, 'name').trim()
            : AppLocalizations.of(context)!.world_discovery_open_world1,
            maxLines: 2, overflow: TextOverflow.ellipsis),
        actions: [IconButton(
          tooltip: AppLocalizations.of(context)!.world_discovery_share_tooltip1,
          onPressed: () => _showSharePreview(d),
          icon: const Icon(Icons.ios_share_rounded),
        )],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        // Keep the cover visible without consuming the full screen height in landscape.
        // In wide layouts the image occupies a separate column, so the tab content
        // and the enter button always have a bounded area of their own.
        final landscape = constraints.maxWidth > constraints.maxHeight &&
            constraints.maxWidth >= 600;
        final gallery = PageView(children:[
          for(final url in images) ColoredBox(
              color:theme.colorScheme.surfaceContainerHighest,
              child:_image(url,fit:BoxFit.cover)),
          if(images.isEmpty) _image(''),
        ]);
        final intro = <Widget>[
          if(_s(d,'shortPitch').trim().isNotEmpty) Padding(
              padding:const EdgeInsets.fromLTRB(18,12,18,12),
              child:Text(_s(d,'shortPitch'),maxLines:landscape ? 2 : 3,
                  overflow:TextOverflow.ellipsis,
                  style:GoogleFonts.notoSerifTc(fontSize:15.5,height:1.5,fontWeight:FontWeight.w500))),
          TabBar(controller:_tabs,labelColor:theme.colorScheme.primary,
              indicatorColor:theme.colorScheme.primary,
              isScrollable:landscape,labelPadding:landscape
                  ? const EdgeInsets.symmetric(horizontal: 14) : EdgeInsets.zero,
              labelStyle:const TextStyle(fontSize:12,fontWeight:FontWeight.w600),
              unselectedLabelStyle:const TextStyle(fontSize:12),
              tabs:[Tab(text:AppLocalizations.of(context)!.world_discovery_story_open1),Tab(text:AppLocalizations.of(context)!.world_discovery_world_background1),
                Tab(text:AppLocalizations.of(context)!.world_discovery_people_intro1),Tab(text:AppLocalizations.of(context)!.world_discovery_creator1)]),
          Expanded(child:TabBarView(controller:_tabs,children:[
            _storyTab(d),_backgroundTab(d),_peopleTab(d),_creatorTab(d),
          ])),
          SafeArea(top:false,child:Padding(
            padding:const EdgeInsets.fromLTRB(16,8,16,12),
            child:SizedBox(width:double.infinity,child:FilledButton(
              onPressed: _creatingRoom ? null : () async {
                if (!canEnter) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:Text(AppLocalizations.of(context)!.world_discovery_not_playable1)));
                  return;
                }
                setState(() => _creatingRoom = true);
                try {
                  final result = await FirebaseFunctions.instanceFor(region: 'asia-east1')
                      .httpsCallable('worldPrivateTest').call({
                    'worldId': widget.worldId, 'action': 'newRoom',
                  });
                  final data = Map<String, dynamic>.from(result.data as Map);
                  final newSessionId = (data['sessionId'] ?? '').toString().trim();
                  if (newSessionId.isEmpty) throw StateError('建立新房間失敗：沒有房間 ID');
                  // Public entry should never use old deterministic 64-character SHA-256 room IDs.
                  // This catches a stale deployment that accidentally returns the legacy room.
                  if (RegExp(r'^[a-f0-9]{64}$').hasMatch(newSessionId)) {
                    throw StateError('後端仍回傳舊版固定房間 ID，請更新 worldPrivateTest');
                  }
                  if (!mounted) return;
                  await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => WorldChatPage(worldId: widget.worldId, sessionId: newSessionId)));
                } catch (e) {
                  debugPrint('開始新世界觀劇情失敗：$e');
                  if (mounted) ToastUtils.showCenterToast(context, '無法建立新故事，請重試', isError: true);
                } finally {
                  if (mounted) setState(() => _creatingRoom = false);
                }
              },child: _creatingRoom ? const SizedBox(height: 20, width: 20,
                child: CircularProgressIndicator(strokeWidth: 2))
                : Text(AppLocalizations.of(context)!.world_discovery_enter1),
            )),
          )),
        ];
        if (landscape) {
          final galleryWidth = (constraints.maxWidth * 0.36).clamp(180.0, 420.0).toDouble();
          return Row(children: [
            SizedBox(width: galleryWidth, height: constraints.maxHeight,
                child: gallery),
            const VerticalDivider(width: 1),
            Expanded(child: Column(children: intro)),
          ]);
        }
        final galleryHeight = (constraints.maxHeight * 0.34)
            .clamp(100.0, constraints.maxWidth * 0.75).toDouble();
        return Column(children: [
          SizedBox(height: galleryHeight, width: double.infinity, child: gallery),
          ...intro,
        ]);
      }),
    );
  },
  );
}
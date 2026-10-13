import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:characters/characters.dart';
import 'store_page.dart';

/// 官方合作創作者專區第一版。
/// 注意：畫面上的權限檢查不能取代 Cloud Functions 的後端驗證。
class OfficialCreatorStudioPage extends StatelessWidget {
  const OfficialCreatorStudioPage({super.key, this.onOpenShop});

  /// 由現有商店入口提供實際導頁方法；未提供時不會猜測路由。
  final VoidCallback? onOpenShop;

  bool _isVerified(Map<String, dynamic> data) => _officialCreatorVerified(data);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('請先登入帳號')));
    }

    return Scaffold(
      appBar: AppBar(title: Text('合作創作者專區',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600))),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('無法驗證合作創作者資格，請稍後再試'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.data!.exists ||
              !_isVerified(snapshot.data!.data() ?? <String, dynamic>{})) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('目前沒有官方合作創作者權限。\n如已完成簽約，請聯繫官方確認開通狀態。',
                  textAlign: TextAlign.center),
            ));
          }

          final primary = theme.colorScheme.primary;
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 48),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withValues(alpha: 0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.verified_rounded, color: primary),
                      const SizedBox(width: 8),
                      Text('已認證合作創作者',
                          style: GoogleFonts.notoSerifTc(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 9),
                    Text('歡迎回到戀戀拾光創作者專區。專屬功能將陸續開放。',
                        style: TextStyle(color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7), height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text('專屬工具', style: GoogleFonts.notoSerifTc(
                  fontSize: 19, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _tool(context, Icons.people_outline_rounded, '粉絲管理', '查看追蹤自己的玩家', onTap: () => _openPage(context, const _OfficialFollowersPage())),
              _tool(context, Icons.bar_chart_rounded, '創作數據', '公開角色與遊玩次數', onTap: () => _openPage(context, const _OfficialCreatorStatsPage())),
              _tool(context, Icons.mail_outline_rounded, '粉絲信件', '寄送訊息給追蹤者', onTap: () => _openPage(context, const _CreatorFanMailPage())),
              _tool(context, Icons.card_giftcard_outlined, '粉絲福利', '贈送自己的花花給追蹤者', onTap: () => _openPage(context, _CreatorFlowerGiftPage(onOpenShop: onOpenShop))),
              _tool(context, Icons.local_florist_outlined, '每月創作獎勵', '當月新建並公開 3 位角色，領取 300 花花', onTap: () => _openPage(context, const _CreatorMonthlyRewardPage())),
              _tool(context, Icons.image_outlined, '專屬橫幅', '設定創作者頁面圖片'),
              _tool(context, Icons.info_outline_rounded, '合作資訊', '查看合作資格與公告'),
              const SizedBox(height: 12),
              Text('創作數據、粉絲名單、粉絲信件及花花福利已加入；專屬橫幅等功能仍在規劃中。',
                  style: TextStyle(fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          );
        },
      ),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  Widget _tool(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: onTap == null
            ? const Text('規劃中', style: TextStyle(fontSize: 12))
            : const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}


// 專屬頁面都再次訂閱資格；撤銷認證後即時停止顯示。
bool _officialCreatorVerified(Map<String, dynamic> data) =>
    data['creatorStatus'] == 'approved' &&
        data['creatorVerified'] == true &&
        data['creatorDashboardEnabled'] == true;

class _CreatorAccessGate extends StatelessWidget {
  final Widget child;
  const _CreatorAccessGate({required this.child});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('請先登入帳號'));
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return const Center(child: Text('資格驗證失敗，請稍後重試'));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (!snap.data!.exists || !_officialCreatorVerified(snap.data!.data() ?? {})) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('目前沒有官方合作創作者權限', textAlign: TextAlign.center),
          ));
        }
        return child;
      },
    );
  }
}

class _OfficialCreatorStatsPage extends StatelessWidget {
  const _OfficialCreatorStatsPage();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('創作數據',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600))),
      body: _CreatorAccessGate(child: uid == null
          ? const Center(child: Text('請先登入帳號'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('artifacts')
            .doc(const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang'))
            .collection('public_characters')
            .where('createdBy', isEqualTo: uid)
            .snapshots(),
        builder: (context, characterSnap) {
          if (characterSnap.hasError) {
            return const Center(child: Text('公開角色資料載入失敗'));
          }
          if (!characterSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final characters = characterSnap.data!.docs;
          final totalPlayCount = characters.fold<int>(0, (sum, doc) {
            final raw = doc.data()['playCount'];
            return sum + (raw is num ? raw.toInt() : 0);
          });
          final sorted = [...characters]..sort((a, b) {
            final aCount = a.data()['playCount'];
            final bCount = b.data()['playCount'];
            return (bCount is num ? bCount.toInt() : 0)
                .compareTo(aCount is num ? aCount.toInt() : 0);
          });
          final followersRef = FirebaseFirestore.instance
              .collection('users').doc(uid).collection('followers');
          return ListView(padding: const EdgeInsets.all(18), children: [
            Text('創作總覽', style: GoogleFonts.notoSerifTc(
                fontSize: 21, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _metricCard(context, '公開角色', '${characters.length}', Icons.menu_book_outlined),
            _metricCard(context, '累計遊玩次數', '$totalPlayCount', Icons.play_circle_outline_rounded),
            FutureBuilder<AggregateQuerySnapshot>(
              future: followersRef.count().get(),
              builder: (context, countSnap) => _metricCard(
                context, '目前追蹤者', countSnap.hasError ? '暫無法取得' :
              countSnap.hasData ? '${countSnap.data!.count ?? 0}' : '讀取中…',
                Icons.people_outline_rounded,
              ),
            ),
            const SizedBox(height: 14),
            Text('各公開角色', style: GoogleFonts.notoSerifTc(
                fontSize: 19, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (sorted.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('還沒有公開角色，發布後就會顯示在這裡。')),
            for (final character in sorted)
              Card(child: ListTile(
                leading: Icon(Icons.auto_stories_outlined, color: theme.colorScheme.primary),
                title: Text((character.data()['name'] ?? '未命名角色').toString()),
                subtitle: const Text('累計遊玩次數（playCount）'),
                trailing: Text('${character.data()['playCount'] is num ? (character.data()['playCount'] as num).toInt() : 0}'),
              )),
            const SizedBox(height: 12),
            Text('數據以資料庫現有欄位為準；累計遊玩次數不等於聊天訊息數、獨立玩家數或收入。',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          ]);
        },
      )),
    );
  }

  Widget _metricCard(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Card(child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [
      Icon(icon, color: theme.colorScheme.primary),
      const SizedBox(width: 12),
      Expanded(child: Text(title)),
      Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
    ])));
  }
}

class _OfficialFollowersPage extends StatelessWidget {
  const _OfficialFollowersPage();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('粉絲管理',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600))),
      body: _CreatorAccessGate(child: uid == null
          ? const Center(child: Text('請先登入帳號'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(uid).collection('followers').limit(100).snapshots(),
        builder: (context, snap) {
          if (snap.hasError) return const Center(child: Text('追蹤者資料載入失敗'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snap.data!.docs;
          if (entries.isEmpty) return const Center(child: Text('目前還沒有追蹤者'));
          return ListView(padding: const EdgeInsets.all(18), children: [
            Text('追蹤者名單', style: GoogleFonts.notoSerifTc(
                fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Text('目前顯示最多 100 位追蹤者；僅展示暱稱，不公開私人聯絡資料。',
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            for (final entry in entries)
              _FollowerItem(followerId: entry.id),
          ]);
        },
      )),
    );
  }
}

class _FollowerItem extends StatelessWidget {
  final String followerId;
  const _FollowerItem({required this.followerId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(followerId).get(),
      builder: (context, snap) {
        final data = snap.data?.data() ?? <String, dynamic>{};
        final nickname = (data['nickname'] ?? '').toString().trim();
        return Card(child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline_rounded)),
          title: Text(nickname.isNotEmpty ? nickname : '玩家'),
          subtitle: snap.hasError ? const Text('無法載入公開資料') : null,
        ));
      },
    );
  }
}


// 官方合作創作者：粉絲站內信（所有真正寄送都走 Cloud Functions）
class _CreatorFanMailPage extends StatefulWidget {
  const _CreatorFanMailPage();
  @override
  State<_CreatorFanMailPage> createState() => _CreatorFanMailPageState();
}

class _CreatorFanMailPageState extends State<_CreatorFanMailPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-east1');
  String _mode = 'broadcast';
  String? _recipientUid;
  String? _requestId;
  bool _sending = false;
  bool _loading = false;
  Map<String, dynamic> _overview = {};
  @override
  void initState() {super.initState(); _refresh();}
  @override
  void dispose() {_title.dispose(); _body.dispose(); super.dispose();}

  Future<void> _refresh() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final response = await _functions.httpsCallable('getCreatorFanMailOverview').call();
      if (!mounted) return;
      setState(() => _overview = Map<String,dynamic>.from(response.data as Map));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('讀取信件額度失敗：$e')));
    } finally {if (mounted) setState(() => _loading = false);}
  }

  Future<void> _send() async {
    if (_sending) return;
    final title = _title.text.trim();
    final body = _body.text.trim();
    // 以使用者感知字元計數，與後端 Intl.Segmenter 一致。
    if (title.isEmpty || title.characters.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('信件標題須在 1～100 字之間')));return;
    }
    if (body.isEmpty || body.characters.length > 5000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('信件內容須在 1～5000 字之間')));return;
    }
    if (_mode=='single' && (_recipientUid==null || _recipientUid!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('請選擇一位追蹤者')));return;
    }
    final accepted = await showDialog<bool>(context: context,builder:(ctx)=>AlertDialog(
      title: const Text('確認寄送粉絲信件'),
      content: Text(_mode=='broadcast' ? '確定寄送給目前的全部追蹤者嗎？這次將使用 1 次群發額度。' : '確定寄送給這位粉絲嗎？這次將使用 1 次單人私信額度。'),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),
        FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('確認寄出'))],
    ));
    if (accepted!=true || !mounted) return;
    setState(()=>_sending=true);
    // 保留識別碼；逾時重試可避免同一封信重複扣額度。
    _requestId ??= '${DateTime.now().microsecondsSinceEpoch}_${FirebaseAuth.instance.currentUser!.uid.hashCode.abs()}';
    try {
      await _functions.httpsCallable('sendCreatorFanMail', options: HttpsCallableOptions(timeout: const Duration(seconds: 60))).call({
        'mode':_mode,'recipientUid':_mode=='single'?_recipientUid:null,
        'title':title,'body':body,'requestId':_requestId,
      });
      if (!mounted) return;
      _requestId=null;_title.clear();_body.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已建立寄送工作；信件將由系統陸續投遞。')));
      await _refresh();
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('寄送未確認成功，請檢查紀錄後重試：$e')));
    } finally {if(mounted)setState(()=>_sending=false);}
  }

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid;
    final primary=Theme.of(context).colorScheme.primary;
    final jobs=(_overview['jobs'] as List?)??[];
    return Scaffold(
      appBar: AppBar(title: Text('粉絲信件',style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
      body: _CreatorAccessGate(child: uid==null?const Center(child:Text('請先登入帳號')):
      RefreshIndicator(onRefresh:_refresh,child:ListView(padding:const EdgeInsets.all(18),children:[
        Row(children:[const Expanded(child:Text('今日寄送額度',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
          IconButton(onPressed:_loading?null:_refresh,icon:const Icon(Icons.refresh_rounded))]),
        Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('單人私信：${_overview['singleUsed']??'—'} / 30 封'),
          const SizedBox(height:8),Text('全體粉絲群發：${_overview['broadcastUsed']??'—'} / 5 次'),
          const SizedBox(height:8),const Text('台灣時間每天 00:00 重置；群發一次可寄送給所有追蹤者。',style:TextStyle(fontSize:12)),
        ]))),
        const SizedBox(height:14),
        SegmentedButton<String>(segments:const [
          ButtonSegment(value:'broadcast',label:Text('全體粉絲'),icon:Icon(Icons.groups_outlined)),
          ButtonSegment(value:'single',label:Text('單一粉絲'),icon:Icon(Icons.person_outline))],
            selected:{_mode},onSelectionChanged:_sending?null:(v)=>setState((){_mode=v.first;_requestId=null;})),
        if(_mode=='single') ...[
          const SizedBox(height:12),StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream:FirebaseFirestore.instance.collection('users').doc(uid).collection('followers').limit(100).snapshots(),
              builder:(ctx,snap){
                if(snap.hasError)return const Text('無法取得粉絲名單');
                if(!snap.hasData)return const LinearProgressIndicator();
                final docs=snap.data!.docs;
                if(docs.isEmpty)return const Text('目前沒有可以寄信的粉絲');
                final value=docs.any((d)=>d.id==_recipientUid)?_recipientUid:null;
                return DropdownButtonFormField<String>(value:value,isExpanded:true,
                    decoration:const InputDecoration(labelText:'選擇追蹤者（前 100 位）',border:OutlineInputBorder()),
                    items:docs.map((d)=>DropdownMenuItem(value:d.id,child:Text(d.data()['nickname']?.toString().trim().isNotEmpty==true
                        ?'${d.data()['nickname']} (${d.id.substring(0,d.id.length>8?8:d.id.length)})':d.id,
                        overflow:TextOverflow.ellipsis))).toList(),
                    onChanged:_sending?null:(v)=>setState((){_recipientUid=v;_requestId=null;}));
              }),
        ],
        const SizedBox(height:14),TextField(controller:_title,maxLength:100,enabled:!_sending,
            inputFormatters:[LengthLimitingTextInputFormatter(100)],
            onChanged:(_)=>_requestId=null,
            decoration:const InputDecoration(labelText:'信件標題',border:OutlineInputBorder())),
        const SizedBox(height:10),TextField(controller:_body,minLines:7,maxLines:12,enabled:!_sending,
            maxLength:5000,inputFormatters:[LengthLimitingTextInputFormatter(5000)],
            onChanged:(_)=>_requestId=null,
            decoration:const InputDecoration(labelText:'信件內容',hintText:'寫一封給粉絲的信……',border:OutlineInputBorder())),
        const SizedBox(height:8),FilledButton.icon(onPressed:_sending?null:_send,
            icon:_sending?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.send_outlined),
            label:Text(_sending?'提交中…':'確認並寄送')),
        const SizedBox(height:25),Text('寄送紀錄',style:GoogleFonts.notoSerifTc(fontSize:19,fontWeight:FontWeight.w600)),
        if(jobs.isEmpty)const Padding(padding:EdgeInsets.all(16),child:Text('還沒有寄送紀錄')),
        for(final raw in jobs) if(raw is Map) Builder(builder:(ctx){
          final j=Map<String,dynamic>.from(raw);
          final status=(j['status'] ?? '').toString();
          final statusLabel={'queued':'排隊中','processing':'投遞中','completed':'已完成','cancelled':'已取消','failed':'寄送失敗'}[status]??status;
          return Card(child:ListTile(leading:Icon(Icons.mark_email_read_outlined,color:primary),
              title:Text((j['title'] ?? '未命名信件').toString()),
              subtitle:Text('${j['mode']=='broadcast'?'全體粉絲':'單一粉絲'} · $statusLabel · 已投遞 ${j['delivered']??0} 人'),
              trailing:status=='failed'?const Icon(Icons.error_outline):null));
        }),
        const SizedBox(height:20),const Text('寄送紀錄顯示近 20 筆；取消合作資格後，新的寄送與未投遞的工作都會停止。',
            style:TextStyle(fontSize:12)),
      ]))),
    );
  }
}

// 官方合作創作者 v1.4：使用自己帳戶花花贈送指定追蹤者。
class _CreatorFlowerGiftPage extends StatefulWidget {
  final VoidCallback? onOpenShop;
  const _CreatorFlowerGiftPage({this.onOpenShop});
  @override
  State<_CreatorFlowerGiftPage> createState() => _CreatorFlowerGiftPageState();
}

class _CreatorFlowerGiftPageState extends State<_CreatorFlowerGiftPage> {
  final _amountController = TextEditingController(text: '10');
  final _noteController = TextEditingController();
  final Set<String> _selected = {};
  final _functions = FirebaseFunctions.instanceFor(region:'asia-east1');
  String? _requestId;
  bool _submitting = false;

  @override
  void dispose() {
    _amountController.dispose(); _noteController.dispose(); super.dispose();
  }

  Future<void> _showShortage(int balance, int total) async {
    if (!mounted) return;
    await showDialog<void>(context:context, builder:(ctx) => AlertDialog(
      title:const Text('花花餘額不足'),
      content:Text('目前餘額：$balance 朵\n本次需要：$total 朵\n尚缺少：${total-balance} 朵\n\n可以前往商店補充花花。'),
      actions:[
        TextButton(onPressed:()=>Navigator.of(ctx).pop(),child:const Text('稍後再說')),
        FilledButton.icon(onPressed:(){
          Navigator.of(ctx).pop();
          // 沿用既有商店入口；沒有外部回呼時直接開啟花花儲值分頁。
          // push 不取代贈送頁，因此回來後表單仍會保留。
          if (widget.onOpenShop != null) {
            widget.onOpenShop!();
          } else {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const StorePage(initialTabIndex: 1),
              ),
            );
          }
        },icon:const Icon(Icons.shopping_bag_outlined),label:const Text('前往商店')),
      ],
    ));
  }

  Future<void> _submit(int balance) async {
    if (_submitting) return;
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount < 1 || amount > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('每位粉絲可贈送 1～1000 朵花花')));return;
    }
    if (_selected.isEmpty || _selected.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('每次請選擇 1～20 位粉絲')));return;
    }
    final total = amount * _selected.length;
    if (total > 5000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('單次贈送最多 5000 朵花花')));return;
    }
    if (_noteController.text.trim().characters.length > 300) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('祝福文字最多 300 字')));return;
    }
    if (balance < total) {await _showShortage(balance, total);return;}
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title:const Text('確認贈送花花'),
      content:Text('即將贈送給 ${_selected.length} 位粉絲，每人 $amount 朵，共扣除 $total 朵花花。\n贈送完成後無法自行撤回。'),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),
        FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('確認贈送'))],
    ));
    if (ok!=true || !mounted) return;
    setState(()=>_submitting=true);
    _requestId ??= FirebaseFirestore.instance.collection('creator_flower_gifts').doc().id;
    try {
      final result=await _functions.httpsCallable('giftCreatorFlowers',
          options:HttpsCallableOptions(timeout:const Duration(seconds:60))).call({
        'requestId':_requestId, 'recipientUids':_selected.toList(),
        'amount':amount,'note':_noteController.text.trim(),
      });
      if (!mounted) return;
      final data=Map<String,dynamic>.from(result.data as Map);
      setState(() {_selected.clear(); _requestId=null; _noteController.clear();});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(
          data['alreadySubmitted']==true?'這筆贈送已完成，沒有重複扣點':'贈送成功！已送出 $total 朵花花。')));
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      final details=e.details;
      if (details is Map && details['reason']=='insufficient_balance') {
        final latest=(details['balance'] as num?)?.toInt()??balance;
        await _showShortage(latest,total);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(
            '贈送未確認成功：${e.message??e.code}。如逾時，請先查詢花花紀錄再重試。')));
      }
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('連線失敗，請確認紀錄後再重試：$e')));
    } finally {if(mounted)setState(()=>_submitting=false);}
  }

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid;
    if(uid==null)return const Scaffold(body:Center(child:Text('請先登入')));
    final primary=Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar:AppBar(title:Text('粉絲福利・花花贈送',style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
      body:_CreatorAccessGate(child:StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder:(context,userSnapshot){
          if(userSnapshot.hasError)return const Center(child:Text('無法讀取花花餘額'));
          if(!userSnapshot.hasData)return const Center(child:CircularProgressIndicator());
          final raw=userSnapshot.data!.data()?['flowerPoints'];
          final balance=raw is num?raw.toInt():0;
          return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
            stream:FirebaseFirestore.instance.collection('users').doc(uid).collection('followers').limit(100).snapshots(),
            builder:(context,snap){
              if(snap.hasError)return const Center(child:Text('無法載入追蹤者'));
              if(!snap.hasData)return const Center(child:CircularProgressIndicator());
              final followers=snap.data!.docs;
              final amount=int.tryParse(_amountController.text.trim())??0;
              final total=amount*_selected.length;
              return ListView(padding:const EdgeInsets.all(18),children:[
                Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,children:[
                  const Text('我的花花餘額',style:TextStyle(fontWeight:FontWeight.w600)),
                  const SizedBox(height:8),Text('$balance 朵 🌸',style:TextStyle(fontSize:25,fontWeight:FontWeight.bold,color:primary)),
                  const SizedBox(height:7),const Text('花花從妳自己的帳戶扣除，不會由平台額外發放。',style:TextStyle(fontSize:12)),
                ]))),
                const SizedBox(height:12),
                Text('選擇粉絲（最多 20 位）',style:GoogleFonts.notoSerifTc(fontSize:18,fontWeight:FontWeight.w600)),
                const SizedBox(height:6),
                const Text('目前展示前 100 位追蹤者；實際送出時由伺服器再次驗證。',style:TextStyle(fontSize:12)),
                if(followers.isEmpty)const Padding(padding:EdgeInsets.all(18),child:Text('目前沒有可以贈送的粉絲')),
                for(final follower in followers)
                  CheckboxListTile(dense:true,controlAffinity:ListTileControlAffinity.leading,
                    value:_selected.contains(follower.id),
                    onChanged:_submitting?null:(v){setState((){
                      if(v==true){if(_selected.length<20)_selected.add(follower.id);}else{_selected.remove(follower.id);}
                      _requestId=null;
                    });},
                    title:Text((follower.data()['nickname']??'').toString().trim().isNotEmpty
                        ?(follower.data()['nickname']).toString():'粉絲 ${follower.id.substring(0,follower.id.length>8?8:follower.id.length)}'),
                  ),
                const SizedBox(height:12),
                TextField(controller:_amountController,keyboardType:TextInputType.number,
                    enabled:!_submitting,inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                    onChanged:(_){setState((){_requestId=null;});},
                    decoration:const InputDecoration(labelText:'每位粉絲贈送花花',hintText:'例如：10',border:OutlineInputBorder())),
                const SizedBox(height:12),TextField(controller:_noteController,maxLines:4,maxLength:300,
                    enabled:!_submitting,onChanged:(_)=>_requestId=null,
                    decoration:const InputDecoration(labelText:'祝福文字（選填）',border:OutlineInputBorder())),
                const SizedBox(height:12),Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(children:[
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('選擇粉絲'),Text('${_selected.length} 位')]),
                  const SizedBox(height:5),Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('預計扣除'),Text('$total 朵')]),
                  if(total>balance)Padding(padding:const EdgeInsets.only(top:8),child:Text('花花餘額不足，尚缺 ${total-balance} 朵',style:const TextStyle(color:Colors.deepOrange))),
                ]))),
                const SizedBox(height:12),FilledButton.icon(
                    onPressed:_submitting||_selected.isEmpty?null:()=>_submit(balance),
                    icon:const Icon(Icons.card_giftcard_outlined),label:Text(_submitting?'處理中…':'確認贈送')),
                const SizedBox(height:8),const Text('每次最多 20 位粉絲，單次最多 5000 朵。已送出紀錄保存在花花明細及玩家信箱。',style:TextStyle(fontSize:12)),
              ]);
            },
          );
        },
      )),
    );
  }
}


/// 官方合作創作者每月創作獎勵：進度由 Cloud Functions 在伺服器驗證。
class _CreatorMonthlyRewardPage extends StatefulWidget {
  const _CreatorMonthlyRewardPage();
  @override
  State<_CreatorMonthlyRewardPage> createState()=>_CreatorMonthlyRewardPageState();
}
class _CreatorMonthlyRewardPageState extends State<_CreatorMonthlyRewardPage> {
  final _functions=FirebaseFunctions.instanceFor(region:'asia-east1');
  Map<String,dynamic>? _data;
  bool _loading=false;
  bool _claiming=false;
  @override
  void initState(){super.initState(); _load();}
  Future<void> _load() async {
    if(_loading)return;
    setState(()=>_loading=true);
    try{
      final result=await _functions.httpsCallable('getCreatorMonthlyReward',options:HttpsCallableOptions(timeout:const Duration(seconds:60))).call();
      if(mounted)setState(()=>_data=Map<String,dynamic>.from(result.data as Map));
    }on FirebaseFunctionsException catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message??'無法讀取每月任務')));
    }catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('讀取進度失敗，請稍後重試')));
    }finally{if(mounted)setState(()=>_loading=false);}
  }
  Future<void> _claim() async {
    if(_claiming || (_data?['claimed']==true))return;
    final confirmed=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
        title:const Text('確認領取創作獎勵'),
        content:const Text('確定要領取本月 300 朵花花嗎？同一月份僅能領取一次。'),
        actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('取消')),
          FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:const Text('確認領取'))]));
    if(confirmed!=true || !mounted)return;
    setState(()=>_claiming=true);
    try{
      final result=await _functions.httpsCallable('claimCreatorMonthlyReward',options:HttpsCallableOptions(timeout:const Duration(seconds:90))).call();
      if(!mounted)return;
      final res=Map<String,dynamic>.from(result.data as Map);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(res['alreadyClaimed']==true?'本月獎勵已領取':'成功領取 300 朵花花！')));
      await _load();
    }on FirebaseFunctionsException catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message??'領取失敗，請稍後重試')));
      await _load();
    }catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('無法確認領取結果，請重新整理紀錄')));
      await _load();
    }finally{if(mounted)setState(()=>_claiming=false);}
  }
  @override
  Widget build(BuildContext context){
    final d=_data;
    final count=((d?['qualifyingCount'] as num?)?.toInt()??0).clamp(0,3);
    final claimed=d?['claimed']==true;
    final month=(d?['month']??'本月').toString();
    final color=Theme.of(context).colorScheme.primary;
    return Scaffold(appBar:AppBar(title:Text('每月創作獎勵',style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
      body:_CreatorAccessGate(child:RefreshIndicator(onRefresh:_load,child:ListView(
          padding:const EdgeInsets.all(20),children:[
        Card(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('$month 創作獎勵',style:GoogleFonts.notoSerifTc(fontSize:20,fontWeight:FontWeight.w600)),
          const SizedBox(height:8),Text('每月新建立並首次公開 3 位不同角色，手動領取 300 朵花花。',style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant,height:1.6)),
          const SizedBox(height:18),Text('本月進度：$count / 3 位',style:const TextStyle(fontWeight:FontWeight.w600)),
          const SizedBox(height:8),LinearProgressIndicator(value:count/3,color:color,minHeight:9,borderRadius:BorderRadius.circular(8)),
          const SizedBox(height:18),SizedBox(width:double.infinity,child:FilledButton.icon(
              onPressed:_loading||_claiming||d==null||claimed||count<3?null:_claim,
              icon:_claiming?const SizedBox(width:17,height:17,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.local_florist_outlined),
              label:Text(claimed?'本月已領取':count<3?'尚差 ${3-count} 位公開角色':'領取 300 朵花花'))),
          if(_loading)const Padding(padding:EdgeInsets.only(top:12),child:LinearProgressIndicator()),
        ]))),
        const SizedBox(height:12),
        Text('規則：僅限已簽約並認證的合作創作者；當月新建、當月首次公開、目前仍公開的不同角色才計入。私人角色、草稿、舊角色重新公開均不計入。台灣時間每月重置，每月限領一次。',
            style:TextStyle(fontSize:12,height:1.7,color:Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height:8),
        Text('如有重複、空白或違反創作規範的角色，官方得依合作條款暫停審查或合作資格。',
            style:TextStyle(fontSize:12,height:1.6,color:Theme.of(context).colorScheme.onSurfaceVariant)),
      ]))),);
  }
}

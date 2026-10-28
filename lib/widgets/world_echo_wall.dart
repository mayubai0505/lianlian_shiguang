import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/app_constants.dart';
import '../services/toast_utils.dart';

/// 世界觀專屬時空迴音：不與 public_characters 的 echoes 混用。
/// Firestore: artifacts/{appId}/public_worlds/{worldId}/echoes/{echoId}
class WorldEchoWall extends StatefulWidget {
  const WorldEchoWall({super.key, required this.worldId});
  final String worldId;
  @override
  State<WorldEchoWall> createState() => _WorldEchoWallState();
}

class _WorldEchoWallState extends State<WorldEchoWall> {
  CollectionReference<Map<String, dynamic>> get _echoes => FirebaseFirestore.instance
      .collection('artifacts').doc(AppConfig.appId)
      .collection('public_worlds').doc(widget.worldId).collection('echoes');

  static const _cards = <String, String>{
    'butterfly': 'assets/images/echo/echo_card_butterfly.webp',
    'flower': 'assets/images/echo/echo_card_flower.webp',
    'starry': 'assets/images/echo/echo_card_starry.webp',
    'planet': 'assets/images/echo/echo_card_planet.webp',
  };
  bool _sending = false;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _echoesStream;

  @override
  void initState() {
    super.initState();
    _echoesStream = _echoes.orderBy('createdAt', descending: true).limit(100).snapshots();
  }
  void _toast(String message, {bool error = false}) {
    if (mounted) ToastUtils.showCenterToast(context, message, isError: error);
  }

  Future<void> _compose() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) { _toast(AppLocalizations.of(context)!.echo_login_to_post1, error: true); return; }
    if (_sending) return;
    try {
      final existing = await _echoes.where('userId', isEqualTo: user.uid).get();
      if (!mounted) return;
      if (existing.docs.length >= 3) {
        _toast(AppLocalizations.of(context)!.echo_limit1, error: true);
        return;
      }
    } catch (e) {
      _toast(AppLocalizations.of(context)!.echo_count_fail1, error: true);
      debugPrint('世界迴音數量讀取失敗：$e');
      return;
    }
    String selected = 'butterfly';
    final input = TextEditingController();
    final result = await showModalBottomSheet<Map<String,String>>(
      context: context, isScrollControlled: true, showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx, change) => SafeArea(top: false, child: Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 18, MediaQuery.viewInsetsOf(ctx).bottom + 18),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppLocalizations.of(context)!.echo_compose_title1, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.echo_compose_desc1),
            const SizedBox(height: 15),
            SizedBox(height: 86, child: ListView(scrollDirection: Axis.horizontal, children: [
              for (final item in _cards.entries) Padding(padding: const EdgeInsets.only(right: 10), child: InkWell(
                  onTap: () => change(() => selected = item.key),
                  child: Container(width: 74, padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: selected == item.key ? Theme.of(ctx).colorScheme.primary : Colors.transparent, width: 2)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(item.value, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.style_outlined))),
                  ))),
            ])),
            const SizedBox(height: 12),
            TextField(controller: input, maxLength: 500, minLines: 3, maxLines: 6,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.echo_compose_hint1, border: OutlineInputBorder())),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: FilledButton(
                onPressed: () {
                  final message = input.text.trim();
                  if (message.isEmpty) return;
                  Navigator.pop(ctx, {'content': message, 'cardType': selected});
                }, child: Text(AppLocalizations.of(context)!.echo_send1))),
          ])),
        )),
      ),
    );
    input.dispose();
    if (!mounted || result == null) return;
    setState(() => _sending = true);
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final d = userDoc.data() ?? {};
      await _echoes.add({
        'userId': user.uid,
        'authorId': user.uid,
        'nickname': (d['nickname'] ?? user.displayName ?? '玩家').toString(),
        'avatarPath': (d['avatarPath'] ?? user.photoURL ?? '').toString(),
        'content': result['content'],
        'cardType': result['cardType'],
        'createdAt': FieldValue.serverTimestamp(),
        'likedBy': <String>[],
        'reporters': <String>[],
      });
      _toast(AppLocalizations.of(context)!.echo_sent1);
    } catch (e) {
      debugPrint('世界迴音新增失敗：$e');
      _toast(AppLocalizations.of(context)!.echo_post_fail1, error: true);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _like(DocumentSnapshot<Map<String,dynamic>> doc) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) { _toast(AppLocalizations.of(context)!.echo_login1, error: true); return; }
    final likedBy = (doc.data()?['likedBy'] is List) ? List<String>.from(doc.data()!['likedBy']) : <String>[];
    try {
      await doc.reference.update({'likedBy': likedBy.contains(uid) ? FieldValue.arrayRemove([uid]) : FieldValue.arrayUnion([uid])});
    } catch (e) { debugPrint('世界迴音按讚失敗：$e'); _toast(AppLocalizations.of(context)!.echo_like_fail1, error: true); }
  }

  Future<void> _delete(DocumentSnapshot<Map<String,dynamic>> doc) async {
    final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.echo_delete_title1), content: Text(AppLocalizations.of(context)!.echo_delete_warning1),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.echo_cancel1)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.echo_delete1))],
    ));
    if (confirmed != true) return;
    try { await doc.reference.delete(); _toast(AppLocalizations.of(context)!.echo_deleted1); }
    catch (e) { debugPrint('世界迴音刪除失敗：$e'); _toast(AppLocalizations.of(context)!.echo_delete_fail1, error: true); }
  }

  Future<void> _report(DocumentSnapshot<Map<String,dynamic>> doc) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) { _toast(AppLocalizations.of(context)!.echo_login1, error: true); return; }
    final reasons = ['不當內容', '騷擾或攻擊', '垃圾訊息', '其他'];
    final reason = await showDialog<String>(context: context,
        builder: (ctx) => SimpleDialog(title: Text(AppLocalizations.of(context)!.echo_report_title1), children: [
          for (final r in reasons) SimpleDialogOption(onPressed: () => Navigator.pop(ctx, r), child: Text(_reportReasonLabel(r))),
        ]));
    if (reason == null) return;
    try {
      final current = await doc.reference.get();
      final reporters = (current.data()?['reporters'] is List) ? List<String>.from(current.data()!['reporters']) : <String>[];
      if (reporters.contains(uid)) { _toast(AppLocalizations.of(context)!.echo_already_reported1); return; }
      await doc.reference.update({
        'reporters': FieldValue.arrayUnion([uid]),
        'reportReasons.$uid': reason,
      });
      _toast(AppLocalizations.of(context)!.echo_report_received1);
    } catch (e) { debugPrint('世界迴音檢舉失敗：$e'); _toast(AppLocalizations.of(context)!.echo_report_fail1, error: true); }
  }

  String _reportReasonLabel(String reason) {
    final l10n = AppLocalizations.of(context)!;
    switch (reason) {
      case '不當內容': return l10n.echo_reason_inappropriate1;
      case '騷擾或攻擊': return l10n.echo_reason_harassment1;
      case '垃圾訊息': return l10n.echo_reason_spam1;
      default: return l10n.echo_reason_other1;
    }
  }

  String _cardAsset(String raw) {
    if (raw == 'sprout') return _cards['flower']!;
    if (raw == 'star') return _cards['starry']!;
    return _cards[raw] ?? _cards['butterfly']!;
  }

  Widget _echoCard(DocumentSnapshot<Map<String, dynamic>> doc, String? currentUid) {
    final theme = Theme.of(context);
    final d = doc.data() ?? <String, dynamic>{};
    final isMine = currentUid != null && (d['userId'] ?? d['authorId']) == currentUid;
    final content = (d['content'] ?? '').toString();
    final style = (d['cardType'] ?? d['cardStyle'] ?? d['theme'] ?? 'butterfly').toString();
    final textSize = content.length > 80 ? 10.5 : content.length > 55 ? 11.5 : content.length > 30 ? 12.5 : 14.0;
    final likes = d['likedBy'] is List ? (d['likedBy'] as List).map((e) => e.toString()).toList() : <String>[];
    final isLiked = currentUid != null && likes.contains(currentUid);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(children: [
        AspectRatio(aspectRatio: 3.15, child: Stack(fit: StackFit.expand, children: [
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(
            _cardAsset(style), fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.20))),
            ),
          )),
          Positioned.fill(child: Padding(
            padding: const EdgeInsets.fromLTRB(34, 24, 38, 18),
            child: Align(alignment: Alignment.centerLeft, child: Text(
              content, maxLines: 6, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.84),
                fontSize: textSize, height: 1.45, fontStyle: FontStyle.italic,
              ),
            )),
          )),
          Positioned(right: 7, top: 4, child: PopupMenuButton<String>(
            tooltip: AppLocalizations.of(context)!.echo_options1,
            color: theme.scaffoldBackgroundColor,
            onSelected: (action) {
              if (action == 'delete') _delete(doc);
              if (action == 'report') _report(doc);
            },
            itemBuilder: (_) => [
              if (isMine) PopupMenuItem(value: 'delete', child: Text(AppLocalizations.of(context)!.echo_delete_option1)),
              if (!isMine) PopupMenuItem(value: 'report', child: Text(AppLocalizations.of(context)!.echo_report_option1)),
            ],
            icon: Icon(Icons.more_horiz_rounded, size: 22, color: theme.colorScheme.onSurface.withValues(alpha: 0.72)),
          )),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: Row(children: [
          Expanded(child: Text(
            (d['nickname'] ?? AppLocalizations.of(context)!.echo_player1).toString(), maxLines: 1, overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSerifTc(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
          )),
          InkWell(onTap: () => _like(doc), borderRadius: BorderRadius.circular(24),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8), child: Row(children: [
                Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 17, color: isLiked ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 5), Text('${likes.length}', style: const TextStyle(fontSize: 12)),
              ]))),
        ])),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(AppLocalizations.of(context)!.echo_wall_title1, style: GoogleFonts.notoSerifTc(
            fontSize: 20, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface))),
        IconButton(onPressed: _sending ? null : _compose,
            tooltip: AppLocalizations.of(context)!.echo_add1, icon: const Icon(Icons.add_rounded)),
      ]),
      const SizedBox(height: 10),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _echoesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Padding(padding: const EdgeInsets.all(16),
              child: Text(AppLocalizations.of(context)!.echo_load_fail1));
          if (!snapshot.hasData) return const Center(child: Padding(
              padding: EdgeInsets.all(22), child: CircularProgressIndicator()));
          if (snapshot.data!.docs.isEmpty) return Padding(
              padding: const EdgeInsets.symmetric(vertical: 46),
              child: Center(child: Column(children: [
                Opacity(opacity: 0.12, child: Image.asset('assets/images/profile/about_botanical.webp',
                    width: 135, errorBuilder: (_, __, ___) => const SizedBox.shrink())),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.echo_empty1,
                    style: GoogleFonts.notoSerifTc(color: theme.colorScheme.onSurfaceVariant, fontSize: 14)),
              ])));
          return Column(children: [
            for (final doc in snapshot.data!.docs) _echoCard(doc, currentUid),
          ]);
        },
      ),
    ]);
  }
}

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import 'package:characters/characters.dart';
import 'store_page.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/toast_utils.dart';
import 'creator_support_center_page.dart';

/// 官方合作創作者專區第一版。
/// 注意：畫面上的權限檢查不能取代 Cloud Functions 的後端驗證。
class OfficialCreatorStudioPage extends StatefulWidget {
  const OfficialCreatorStudioPage({super.key, this.onOpenShop});

  /// 由現有商店入口提供實際導頁方法；未提供時不會猜測路由。
  final VoidCallback? onOpenShop;

  @override
  State<OfficialCreatorStudioPage> createState() => _OfficialCreatorStudioPageState();
}

class _OfficialCreatorStudioPageState extends State<OfficialCreatorStudioPage> {
  bool _introScheduled = false;

  bool _isVerified(Map<String, dynamic> data) => _officialCreatorVerified(data);

  Future<void> _showCreatorIntro({bool manuallyOpened = false}) async {
    if (!mounted) return;
    final bool? seen = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _CreatorStudioIntroDialog(),
    );
    if (!mounted || seen != true) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'creatorStudioTutorialVersion': 1},
        SetOptions(merge: true),
      );
    } catch (error) {
      debugPrint('創作者導覽跨裝置進度儲存失敗：$error');
      if (mounted) {
        ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0011, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    if (user == null) {
      return Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0021)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.official_studio_text_0031,
            style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => _showCreatorIntro(manuallyOpened: true),
            child: Text(AppLocalizations.of(context)!.official_studio_text_0041),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0051));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.data!.exists ||
              !_isVerified(snapshot.data!.data() ?? <String, dynamic>{})) {
            return Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(AppLocalizations.of(context)!.official_studio_text_0061,
                  textAlign: TextAlign.center),
            ));
          }

          if (!_introScheduled) {
            _introScheduled = true;
            final data = snapshot.data!.data() ?? <String, dynamic>{};
            final rawVersion = data['creatorStudioTutorialVersion'];
            final version = rawVersion is num ? rawVersion.toInt() :
            int.tryParse(rawVersion?.toString() ?? '') ?? 0;
            if (version < 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _showCreatorIntro();
              });
            }
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
                      Image.asset(
                        'assets/images/creator/creator_verified_badge.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.official_studio_text_0071,
                          style: GoogleFonts.notoSerifTc(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 9),
                    Text(AppLocalizations.of(context)!.official_studio_text_0081,
                        style: TextStyle(color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7), height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(AppLocalizations.of(context)!.official_studio_text_0091, style: GoogleFonts.notoSerifTc(
                  fontSize: 19, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0101, AppLocalizations.of(context)!.official_studio_text_0111, onTap: () => _openPage(context, const _OfficialFollowersPage())),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0121, AppLocalizations.of(context)!.official_studio_text_0131, onTap: () => _openPage(context, const _OfficialCreatorStatsPage())),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0141, AppLocalizations.of(context)!.official_studio_text_0151, onTap: () => _openPage(context, const _CreatorFanMailPage())),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0161, AppLocalizations.of(context)!.official_studio_text_0171, onTap: () => _openPage(context, _CreatorFlowerGiftPage(onOpenShop: widget.onOpenShop))),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0181, AppLocalizations.of(context)!.official_studio_text_0191, onTap: () => _openPage(context, const _CreatorMonthlyRewardPage())),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0201, AppLocalizations.of(context)!.official_studio_text_0211, onTap: () => _openPage(context, const _CreatorBannerPage())),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0221, AppLocalizations.of(context)!.official_studio_text_0231, onTap: () => _openPage(context, const _CreatorCooperationPage())),
              _tool(context, AppLocalizations.of(context)!.official_studio_text_0241, AppLocalizations.of(context)!.official_studio_text_0251, onTap: () => _openPage(context, const CreatorSupportCenterPage())),
            ],
          );
        },
      ),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  Widget _tool(BuildContext context, String title, String subtitle, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10), elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.16))),
      child: ListTile(onTap: onTap,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded)),
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
    if (user == null) return Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0021));
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0261));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (!snap.data!.exists || !_officialCreatorVerified(snap.data!.data() ?? {})) {
          return Center(child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(AppLocalizations.of(context)!.official_studio_text_0271, textAlign: TextAlign.center),
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.official_studio_text_0121,
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600))),
      body: _CreatorAccessGate(child: uid == null
          ? Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0021))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('artifacts')
            .doc(const String.fromEnvironment('APP_ID', defaultValue: 'lianlianshiguang'))
            .collection('public_characters')
            .where('createdBy', isEqualTo: uid)
            .snapshots(),
        builder: (context, characterSnap) {
          if (characterSnap.hasError) {
            return Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0281));
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
            Text(AppLocalizations.of(context)!.official_studio_text_0291, style: GoogleFonts.notoSerifTc(
                fontSize: 21, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _metricCard(context, AppLocalizations.of(context)!.official_studio_text_1951, '${characters.length}'),
            _metricCard(context, AppLocalizations.of(context)!.official_studio_text_0301, '$totalPlayCount'),
            FutureBuilder<AggregateQuerySnapshot>(
              future: followersRef.count().get(),
              builder: (context, countSnap) => _metricCard(
                context, AppLocalizations.of(context)!.official_studio_text_0311, countSnap.hasError ? AppLocalizations.of(context)!.official_studio_text_0321 :
              countSnap.hasData ? '${countSnap.data!.count ?? 0}' : AppLocalizations.of(context)!.official_studio_text_1961,

              ),
            ),
            const SizedBox(height: 14),
            Text(AppLocalizations.of(context)!.official_studio_text_0331, style: GoogleFonts.notoSerifTc(
                fontSize: 19, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (sorted.isEmpty)
              Padding(padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(AppLocalizations.of(context)!.official_studio_text_0341)),
            for (final character in sorted)
              Card(child: ListTile(
                leading: _StudioAvatar(url: _studioCharacterImage(character.data()), size: 48),
                title: Text((character.data()['name'] ?? AppLocalizations.of(context)!.official_studio_text_0351).toString()),
                subtitle: Text(AppLocalizations.of(context)!.official_studio_text_0361),
                trailing: Text('${character.data()['playCount'] is num ? (character.data()['playCount'] as num).toInt() : 0}'),
              )),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.official_studio_text_0371,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          ]);
        },
      )),
    );
  }

  Widget _metricCard(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    return Card(child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [

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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.official_studio_text_0101,
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600))),
      body: _CreatorAccessGate(child: uid == null
          ? Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0021))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(uid).collection('followers').limit(100).snapshots(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0381));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final entries = snap.data!.docs;
          if (entries.isEmpty) return Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0391));
          return ListView(padding: const EdgeInsets.all(18), children: [
            Text(AppLocalizations.of(context)!.official_studio_text_0401, style: GoogleFonts.notoSerifTc(
                fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Text(AppLocalizations.of(context)!.official_studio_text_0411,
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

  Future<void> _confirmRemoveFollower(BuildContext context, String id, String name) async {
    final accepted = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.official_studio_text_0421),
      content: Text(AppLocalizations.of(context)!.official_studio_text_1771(name)),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.official_studio_text_0431)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.official_studio_text_0441))],
    ));
    if (accepted != true || !context.mounted) return;
    try {
      await FirebaseFunctions.instanceFor(region: 'asia-east1')
          .httpsCallable('removeCreatorFollower').call({'followerUid': id});
      if (context.mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0451);
    } catch (e) {
      if (context.mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0461, isError: true);
      debugPrint('移除粉絲失敗：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(followerId).get(),
      builder: (context, snap) {
        final data = snap.data?.data() ?? <String, dynamic>{};
        final nickname = (data['nickname'] ?? '').toString().trim();
        return Card(child: ListTile(
          leading: _StudioAvatar(url: (data['avatarPath'] ?? data['photoURL'] ?? '').toString(), size: 44),
          title: Text(nickname.isNotEmpty ? nickname : (data['displayName'] ?? AppLocalizations.of(context)!.official_studio_text_0471).toString()),
          subtitle: snap.hasError ? Text(AppLocalizations.of(context)!.official_studio_text_0481) : null,
          trailing: TextButton(
              onPressed: () => _confirmRemoveFollower(context, followerId, nickname.isEmpty ? AppLocalizations.of(context)!.official_studio_text_0491 : nickname),
              child: Text(AppLocalizations.of(context)!.official_studio_text_0421)),
        ));
      },
    );
  }
}


// 共用：角色圖片欄位依目前資料 schema 選擇，遠端圖使用快取。
String _studioCharacterImage(Map<String, dynamic> data) {
  for (final key in ['avatarPath', 'bannerImagePath', 'imageUrl', 'imageURL', 'avatarUrl', 'avatarURL', 'coverImage', 'imagePath', 'image']) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
  }
  final images = data['images'];
  if (images is List && images.isNotEmpty && images.first is String) return (images.first as String).trim();
  return '';
}

class _StudioAvatar extends StatelessWidget {
  final String url;
  final double size;
  const _StudioAvatar({required this.url, this.size = 44});
  @override
  Widget build(BuildContext context) {
    final path = url.trim();
    final fallback = Container(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08));
    return ClipRRect(borderRadius: BorderRadius.circular(size / 2), child: SizedBox(
      width: size, height: size,
      child: path.startsWith('http')
          ? CachedNetworkImage(imageUrl: path, fit: BoxFit.cover,
          placeholder: (_, __) => fallback, errorWidget: (_, __, ___) => fallback)
          : path.isNotEmpty ? Image.asset(path, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback) : fallback,
    ));
  }
}

class _CreatorBannerPage extends StatefulWidget {
  const _CreatorBannerPage();
  @override State<_CreatorBannerPage> createState() => _CreatorBannerPageState();
}
class _CreatorBannerPageState extends State<_CreatorBannerPage> {
  bool _busy = false;
  Future<void> _upload() async {
    if (_busy) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (picked == null || !mounted) return;
      final original = await picked.readAsBytes();
      if (!mounted) return;
      // 先讓使用者確認 2.5:1 裁切範圍；取消不會更新橫幅。
      final cropped = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(builder: (_) => _CreatorBannerCropPage(bytes: original)),
      );
      if (cropped == null || !mounted) return;
      if (cropped.length > 2200000) {
        ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0501, isError: true);
        return;
      }
      setState(() => _busy = true);
      await FirebaseFunctions.instanceFor(region: 'asia-east1')
          .httpsCallable('updateCreatorBanner', options: HttpsCallableOptions(timeout: const Duration(seconds: 90)))
          .call({'imageBase64': base64Encode(cropped), 'operation': 'upload'});
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0511);
    } on FirebaseFunctionsException catch (e, st) {
      final message = (e.message ?? '').trim();
      debugPrint('[CREATOR_BANNER] 上傳失敗 code=${e.code} message=$message details=${e.details}');
      debugPrintStack(stackTrace: st);
      if (mounted) ToastUtils.showCenterToast(context,
          AppLocalizations.of(context)!.official_studio_text_0521, isError: true);
    } catch (e, st) {
      debugPrint('[CREATOR_BANNER] 圖片處理或上傳失敗：$e');
      debugPrintStack(stackTrace: st);
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0521, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  Future<void> _remove() async {
    setState(() => _busy = true);
    try {
      await FirebaseFunctions.instanceFor(region: 'asia-east1')
          .httpsCallable('updateCreatorBanner').call({'operation': 'remove'});
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0531);
    } catch (e) {
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0541, isError: true);
      debugPrint('移除橫幅失敗：$e');
    } finally { if (mounted) setState(() => _busy = false); }
  }
  @override Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(appBar: AppBar(title: Text(AppLocalizations.of(context)!.official_studio_text_0201)),
        body: _CreatorAccessGate(child: uid == null ? Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0551)) :
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            final url = (snapshot.data?.data()?['creatorBannerUrl'] ?? '').toString();
            return ListView(padding: const EdgeInsets.all(20), children: [
              Text(AppLocalizations.of(context)!.official_studio_text_0561, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              AspectRatio(aspectRatio: 2.5, child: ClipRRect(borderRadius: BorderRadius.circular(16),
                  child: url.startsWith('http') ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0571)))
                      : Container(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
                      alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.official_studio_text_0581)))),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.official_studio_text_0591),
              const SizedBox(height: 18),
              FilledButton(onPressed: _busy ? null : _upload, child: Text(_busy ? AppLocalizations.of(context)!.official_studio_text_0601 : AppLocalizations.of(context)!.official_studio_text_0611)),
              if (url.isNotEmpty) TextButton(onPressed: _busy ? null : _remove, child: Text(AppLocalizations.of(context)!.official_studio_text_0621)),
            ]);
          },
        )));
  }
}

// 使用 Flutter 內建 Canvas 裁切，避免額外安裝圖片套件或修改 Android/iOS 設定。
// 固定輸出 960x384 PNG，符合既有 callable 的 2.2MB 上傳限制。
class _CreatorBannerCropPage extends StatefulWidget {
  final Uint8List bytes;
  const _CreatorBannerCropPage({required this.bytes});

  @override
  State<_CreatorBannerCropPage> createState() => _CreatorBannerCropPageState();
}

class _CreatorBannerCropPageState extends State<_CreatorBannerCropPage> {
  ui.Image? _source;
  bool _working = false;
  double _zoom = 1;
  double _gestureStartZoom = 1;
  Offset _offset = Offset.zero;
  Offset _gestureStartOffset = Offset.zero;
  Offset _gestureStartFocal = Offset.zero;

  @override
  void initState() {
    super.initState();
    _decode();
  }

  Future<void> _decode() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.bytes);
      final frame = await codec.getNextFrame();
      codec.dispose();
      if (!mounted) {
        frame.image.dispose();
        return;
      }
      debugPrint('[CREATOR_BANNER] 原圖尺寸=${frame.image.width}x${frame.image.height}');
      setState(() => _source = frame.image);
    } catch (error, stack) {
      debugPrint('[CREATOR_BANNER] 解碼失敗：$error');
      debugPrintStack(stackTrace: stack);
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0631, isError: true);
    }
  }

  @override
  void dispose() {
    _source?.dispose();
    super.dispose();
  }

  double _baseScale(ui.Image image, Size crop) =>
      math.max(crop.width / image.width, crop.height / image.height);

  Offset _clampOffset(ui.Image image, Size crop, double zoom, Offset offset) {
    final scale = _baseScale(image, crop) * zoom;
    final maxX = math.max(0.0, (image.width * scale - crop.width) / 2);
    final maxY = math.max(0.0, (image.height * scale - crop.height) / 2);
    return Offset(
      offset.dx.clamp(-maxX, maxX).toDouble(),
      offset.dy.clamp(-maxY, maxY).toDouble(),
    );
  }

  Future<void> _confirm(Size crop) async {
    final image = _source;
    if (image == null || _working) return;
    setState(() => _working = true);
    try {
      final scale = _baseScale(image, crop) * _zoom;
      final sourceWidth = crop.width / scale;
      final sourceHeight = crop.height / scale;
      final left = (image.width - sourceWidth) / 2 - _offset.dx / scale;
      final top = (image.height - sourceHeight) / 2 - _offset.dy / scale;
      final sourceRect = Rect.fromLTWH(left, top, sourceWidth, sourceHeight);
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawImageRect(
        image,
        sourceRect,
        const Rect.fromLTWH(0, 0, 960, 384),
        Paint()..filterQuality = FilterQuality.high,
      );
      final picture = recorder.endRecording();
      final resultImage = await picture.toImage(960, 384);
      picture.dispose();
      final data = await resultImage.toByteData(format: ui.ImageByteFormat.png);
      resultImage.dispose();
      if (data == null) throw StateError('圖片輸出失敗');
      final result = data.buffer.asUint8List();
      if (!mounted) return;
      if (result.length > 2200000) {
        ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0641, isError: true);
        return;
      }
      Navigator.of(context).pop(result);
    } catch (error, stack) {
      debugPrint('[CREATOR_BANNER] 裁切失敗：$error');
      debugPrintStack(stackTrace: stack);
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_0651, isError: true);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _source;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1D1A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1A20),
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.official_studio_text_0661, style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final cropWidth = math.min(math.max(1.0, constraints.maxWidth - 44), 600.0);
          final crop = Size(cropWidth, cropWidth / 2.5);
          final editorHeight = math.min(
            math.max(crop.height + 60, constraints.maxHeight * 0.52),
            math.max(crop.height + 60, constraints.maxHeight - 180),
          );
          final editorSize = Size(constraints.maxWidth, editorHeight);
          return Column(children: [
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.official_studio_text_0671,
                style: GoogleFonts.notoSerifTc(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.official_studio_text_0681,
                style: const TextStyle(fontSize: 12, color: Color(0xFFEAE4ED))),
            const SizedBox(height: 14),
            SizedBox(
              width: editorSize.width,
              height: editorSize.height,
              child: image == null
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: (details) {
                  _gestureStartZoom = _zoom;
                  _gestureStartOffset = _offset;
                  _gestureStartFocal = details.localFocalPoint;
                },
                onScaleUpdate: (details) {
                  final nextZoom = (_gestureStartZoom * details.scale).clamp(1.0, 5.0).toDouble();
                  final ratio = nextZoom / _gestureStartZoom;
                  final middle = Offset(editorSize.width / 2, editorSize.height / 2);
                  final relative = _gestureStartFocal - middle - _gestureStartOffset;
                  final nextOffset = details.localFocalPoint - middle - relative * ratio;
                  setState(() {
                    _zoom = nextZoom;
                    _offset = _clampOffset(image, crop, _zoom, nextOffset);
                  });
                },
                child: CustomPaint(
                  size: editorSize,
                  painter: _CreatorBannerFramingPainter(
                    image: image,
                    crop: crop,
                    zoom: _zoom,
                    offset: _offset,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(AppLocalizations.of(context)!.official_studio_text_0691,
                style: const TextStyle(fontSize: 12, color: Color(0xFFEAE4ED))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Text(AppLocalizations.of(context)!.official_studio_text_0701, style: TextStyle(fontSize: 12, color: Colors.white)),
                Expanded(child: Slider(
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.28),
                  thumbColor: Theme.of(context).colorScheme.primary,
                  value: _zoom,
                  min: 1,
                  max: 5,
                  onChanged: image == null || _working ? null : (value) => setState(() {
                    _zoom = value;
                    _offset = _clampOffset(image, crop, value, _offset);
                  }),
                )),
                Text('${_zoom.toStringAsFixed(1)}×', style: const TextStyle(fontSize: 12, color: Colors.white)),
              ]),
            ),
            TextButton(
              onPressed: image == null || _working ? null : () => setState(() {
                _zoom = 1;
                _offset = Offset.zero;
              }),
              child: Text(AppLocalizations.of(context)!.official_studio_text_0711, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: Row(children: [
                Expanded(child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).colorScheme.primary)),
                  onPressed: _working ? null : () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.official_studio_text_0431, style: TextStyle(color: Colors.white)),
                )),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(
                  onPressed: image == null || _working ? null : () => _confirm(crop),
                  child: Text(_working ? AppLocalizations.of(context)!.official_studio_text_0721 : AppLocalizations.of(context)!.official_studio_text_0731),
                )),
              ]),
            ),
          ]);
        }),
      ),
    );
  }
}

// 編輯區保留原圖比例；白框是實際輸出區域，框外加深方便取景。
// 畫面繪製和輸出都使用相同的 baseScale/zoom/offset 計算。
class _CreatorBannerFramingPainter extends CustomPainter {
  final ui.Image image;
  final Size crop;
  final double zoom;
  final Offset offset;
  const _CreatorBannerFramingPainter({
    required this.image,
    required this.crop,
    required this.zoom,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFF252329), BlendMode.src);
    final center = Offset(size.width / 2, size.height / 2);
    final factor = math.max(crop.width / image.width, crop.height / image.height) * zoom;
    final pictureSize = Size(image.width * factor, image.height * factor);
    final destination = Rect.fromCenter(
      center: center + offset,
      width: pictureSize.width,
      height: pictureSize.height,
    );
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destination,
      Paint()..filterQuality = FilterQuality.high,
    );
    final focus = Rect.fromCenter(center: center, width: crop.width, height: crop.height);
    final shade = Paint()..color = const Color(0xBB111015);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, focus.top), shade);
    canvas.drawRect(Rect.fromLTWH(0, focus.bottom, size.width, size.height - focus.bottom), shade);
    canvas.drawRect(Rect.fromLTWH(0, focus.top, focus.left, focus.height), shade);
    canvas.drawRect(Rect.fromLTWH(focus.right, focus.top, size.width - focus.right, focus.height), shade);
    canvas.drawRect(focus, Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke);
    final grid = Paint()..color = const Color(0x88FFFFFF)..strokeWidth = 0.65;
    for (var i = 1; i <= 2; i++) {
      final dx = focus.left + focus.width * i / 3;
      final dy = focus.top + focus.height * i / 3;
      canvas.drawLine(Offset(dx, focus.top), Offset(dx, focus.bottom), grid);
      canvas.drawLine(Offset(focus.left, dy), Offset(focus.right, dy), grid);
    }
  }

  @override
  bool shouldRepaint(covariant _CreatorBannerFramingPainter old) =>
      old.image != image || old.crop != crop || old.zoom != zoom || old.offset != offset;
}

class _CreatorCooperationPage extends StatelessWidget {
  const _CreatorCooperationPage();
  @override Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(appBar: AppBar(title: Text(AppLocalizations.of(context)!.official_studio_text_0221)),
        body: _CreatorAccessGate(child: uid == null ? Center(child: Text(AppLocalizations.of(context)!.official_studio_text_0551)) :
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snap) {
            final data = snap.data?.data() ?? <String, dynamic>{};
            final verified = _officialCreatorVerified(data);
            return ListView(padding: const EdgeInsets.all(20), children: [
              Text(AppLocalizations.of(context)!.official_studio_text_0741, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(verified ? AppLocalizations.of(context)!.official_studio_text_0071 : AppLocalizations.of(context)!.official_studio_text_0751),
              const Divider(height: 32),
              Text(AppLocalizations.of(context)!.official_studio_text_0761, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.official_studio_text_0771),
              const Divider(height: 32),
              Text(AppLocalizations.of(context)!.official_studio_text_0181, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.official_studio_text_0781),
              const Divider(height: 32),
              Text(AppLocalizations.of(context)!.official_studio_text_0791, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.official_studio_text_0801),
            ]);
          },
        )));
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.official_studio_text_1881)));
    } finally {if (mounted) setState(() => _loading = false);}
  }

  Future<void> _send() async {
    if (_sending) return;
    final title = _title.text.trim();
    final body = _body.text.trim();
    // 以使用者感知字元計數，與後端 Intl.Segmenter 一致。
    if (title.isEmpty || title.characters.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.official_studio_text_0811)));return;
    }
    if (body.isEmpty || body.characters.length > 5000) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.official_studio_text_0821)));return;
    }
    if (_mode=='single' && (_recipientUid==null || _recipientUid!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.official_studio_text_0831)));return;
    }
    final accepted = await showDialog<bool>(context: context,builder:(ctx)=>AlertDialog(
      title: Text(AppLocalizations.of(context)!.official_studio_text_0841),
      content: Text(_mode=='broadcast' ? AppLocalizations.of(context)!.official_studio_text_0851 : AppLocalizations.of(context)!.official_studio_text_0861),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:Text(AppLocalizations.of(context)!.official_studio_text_0431)),
        FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:Text(AppLocalizations.of(context)!.official_studio_text_0871))],
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.official_studio_text_0881)));
      await _refresh();
    } catch(e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.official_studio_text_1891)));
    } finally {if(mounted)setState(()=>_sending=false);}
  }

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid;
    final primary=Theme.of(context).colorScheme.primary;
    final jobs=(_overview['jobs'] as List?)??[];
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.official_studio_text_0141,style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
      body: _CreatorAccessGate(child: uid==null?Center(child:Text(AppLocalizations.of(context)!.official_studio_text_0021)):
      RefreshIndicator(onRefresh:_refresh,child:ListView(padding:const EdgeInsets.all(18),children:[
        Row(children:[Expanded(child:Text(AppLocalizations.of(context)!.official_studio_text_0891,style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))),
          IconButton(onPressed:_loading?null:_refresh,icon:const Icon(Icons.refresh_rounded))]),
        Card(child:Padding(padding:const EdgeInsets.all(15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(
            AppLocalizations.of(context)!.official_studio_text_1781(
              (_overview['singleUsed'] as num?)?.toInt() ?? 0,
            ),
          ),
          const SizedBox(height:8),
          Text(
            AppLocalizations.of(context)!.official_studio_text_1791(
              (_overview['broadcastUsed'] as num?)?.toInt() ?? 0,
            ),
          ),
          const SizedBox(height:8),Text(AppLocalizations.of(context)!.official_studio_text_0901,style:TextStyle(fontSize:12)),
        ]))),
        const SizedBox(height:14),
        SegmentedButton<String>(segments:[
          ButtonSegment(value:'broadcast',label:Text(AppLocalizations.of(context)!.official_studio_text_0911),icon:Icon(Icons.groups_outlined)),
          ButtonSegment(value:'single',label:Text(AppLocalizations.of(context)!.official_studio_text_0921),icon:Icon(Icons.person_outline))],
            selected:{_mode},onSelectionChanged:_sending?null:(v)=>setState((){_mode=v.first;_requestId=null;})),
        if(_mode=='single') ...[
          const SizedBox(height:12),StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream:FirebaseFirestore.instance.collection('users').doc(uid).collection('followers').limit(100).snapshots(),
              builder:(ctx,snap){
                if(snap.hasError)return Text(AppLocalizations.of(context)!.official_studio_text_0931);
                if(!snap.hasData)return const LinearProgressIndicator();
                final docs=snap.data!.docs;
                if(docs.isEmpty)return Text(AppLocalizations.of(context)!.official_studio_text_0941);
                final value=docs.any((d)=>d.id==_recipientUid)?_recipientUid:null;
                return DropdownButtonFormField<String>(value:value,isExpanded:true,
                    decoration:InputDecoration(labelText:AppLocalizations.of(context)!.official_studio_text_0951,border:OutlineInputBorder()),
                    items:docs.map((d)=>DropdownMenuItem(value:d.id,child:Text(d.data()['nickname']?.toString().trim().isNotEmpty==true
                        ?'${d.data()['nickname']} (${d.id.substring(0,d.id.length>8?8:d.id.length)})':d.id,
                        overflow:TextOverflow.ellipsis))).toList(),
                    onChanged:_sending?null:(v)=>setState((){_recipientUid=v;_requestId=null;}));
              }),
        ],
        const SizedBox(height:14),TextField(controller:_title,maxLength:100,enabled:!_sending,
            inputFormatters:[LengthLimitingTextInputFormatter(100)],
            onChanged:(_)=>_requestId=null,
            decoration:InputDecoration(labelText:AppLocalizations.of(context)!.official_studio_text_0961,border:OutlineInputBorder())),
        const SizedBox(height:10),TextField(controller:_body,minLines:7,maxLines:12,enabled:!_sending,
            maxLength:5000,inputFormatters:[LengthLimitingTextInputFormatter(5000)],
            onChanged:(_)=>_requestId=null,
            decoration:InputDecoration(labelText:AppLocalizations.of(context)!.official_studio_text_0971,hintText:AppLocalizations.of(context)!.official_studio_text_0981,border:OutlineInputBorder())),
        const SizedBox(height:8),FilledButton.icon(onPressed:_sending?null:_send,
            icon:_sending?const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.send_outlined),
            label:Text(_sending?AppLocalizations.of(context)!.official_studio_text_0991:AppLocalizations.of(context)!.official_studio_text_1001)),
        const SizedBox(height:25),Text(AppLocalizations.of(context)!.official_studio_text_1011,style:GoogleFonts.notoSerifTc(fontSize:19,fontWeight:FontWeight.w600)),
        if(jobs.isEmpty)Padding(padding:EdgeInsets.all(16),child:Text(AppLocalizations.of(context)!.official_studio_text_1021)),
        for(final raw in jobs) if(raw is Map) Builder(builder:(ctx){
          final j=Map<String,dynamic>.from(raw);
          final status=(j['status'] ?? '').toString();
          final statusLabel={'queued':AppLocalizations.of(context)!.official_studio_text_1031,'processing':AppLocalizations.of(context)!.official_studio_text_1041,'completed':AppLocalizations.of(context)!.official_studio_text_1051,'cancelled':AppLocalizations.of(context)!.official_studio_text_1061,'failed':AppLocalizations.of(context)!.official_studio_text_1071}[status]??status;
          return Card(child:ListTile(
              title:Text((j['title'] ?? AppLocalizations.of(context)!.official_studio_text_1081).toString()),
              subtitle:Text(AppLocalizations.of(context)!.official_studio_text_1941(j['mode']=='broadcast'?AppLocalizations.of(context)!.official_studio_text_0911:AppLocalizations.of(context)!.official_studio_text_0921, statusLabel, (j['delivered']??0) is num ? (j['delivered'] as num).toInt() : int.tryParse((j['delivered']??0).toString())??0)),
              trailing:status=='failed'?const Icon(Icons.error_outline):null));
        }),
        const SizedBox(height:20),Text(AppLocalizations.of(context)!.official_studio_text_1091,
            style:TextStyle(fontSize:12)),
      ]))),
    );
  }
}

class _CreatorGiftRecipient {
  final String uid;
  final String name;
  final String avatar;
  const _CreatorGiftRecipient({required this.uid, required this.name, required this.avatar});
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
  final _fanSearchController = TextEditingController();
  final List<_CreatorGiftRecipient> _fanResults = [];
  String? _fanCursor;
  bool _fanLoading = false;
  bool _fanHasMore = true;
  String _fanAppliedKeyword = '';
  int _fanSearchGeneration = 0;
  Timer? _fanSearchDebounce;
  final Set<String> _selected = {};
  final _functions = FirebaseFunctions.instanceFor(region:'asia-east1');
  String? _requestId;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadFans(reset: true);
  }

  @override
  void dispose() {
    _fanSearchGeneration++;
    _fanSearchDebounce?.cancel();
    _amountController.dispose();
    _noteController.dispose();
    _fanSearchController.dispose();
    super.dispose();
  }

  void _onFanSearchChanged(String _) {
    _fanSearchDebounce?.cancel();
    _fanSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _loadFans(reset: true);
    });
  }

  Future<void> _loadFans({bool reset = false}) async {
    if (_fanLoading && !reset) return;
    if (!reset && !_fanHasMore) return;
    final generation = reset ? ++_fanSearchGeneration : _fanSearchGeneration;
    final keyword = _fanSearchController.text.trim();
    setState(() {
      _fanLoading = true;
      if (reset) {
        _fanAppliedKeyword = keyword;
        _fanResults.clear();
        _fanCursor = null;
        _fanHasMore = true;
      }
    });
    try {
      final response = await _functions.httpsCallable(
        'searchCreatorGiftFollowers',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
      ).call(<String, dynamic>{
        'keyword': keyword,
        'cursor': reset ? null : _fanCursor,
        'pageSize': 20,
      });
      if (!mounted || generation != _fanSearchGeneration) return;
      final payload = Map<String, dynamic>.from(response.data as Map);
      final rows = (payload['items'] as List? ?? const []);
      final page = rows.whereType<Map>().map((item) {
        final data = Map<String, dynamic>.from(item);
        return _CreatorGiftRecipient(
          uid: (data['uid'] ?? '').toString(),
          name: (data['name'] ?? AppLocalizations.of(context)!.official_studio_text_1101).toString(),
          avatar: (data['avatar'] ?? '').toString(),
        );
      }).where((item) => item.uid.isNotEmpty);
      setState(() {
        final existing = _fanResults.map((e) => e.uid).toSet();
        _fanResults.addAll(page.where((p) => existing.add(p.uid)));
        final next = payload['nextCursor']?.toString();
        _fanCursor = next != null && next.isNotEmpty ? next : null;
        _fanHasMore = _fanCursor != null;
      });
    } catch (error) {
      if (!mounted || generation != _fanSearchGeneration) return;
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1111, isError: true);
      debugPrint('查詢送花粉絲失敗：$error');
    } finally {
      if (mounted && generation == _fanSearchGeneration) {
        setState(() => _fanLoading = false);
      }
    }
  }

  Future<void> _showShortage(int balance, int total) async {
    if (!mounted) return;
    await showDialog<void>(context:context, builder:(ctx) => AlertDialog(
      title:Text(AppLocalizations.of(context)!.official_studio_text_1121),
      content:Text(AppLocalizations.of(context)!.official_studio_text_1921(balance, total, total-balance)),
      actions:[
        TextButton(onPressed:()=>Navigator.of(ctx).pop(),child:Text(AppLocalizations.of(context)!.official_studio_text_1131)),
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
        },icon:const Icon(Icons.shopping_bag_outlined),label:Text(AppLocalizations.of(context)!.official_studio_text_1141)),
      ],
    ));
  }

  Future<void> _submit(int balance) async {
    if (_submitting) return;
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount < 1 || amount > 1000) {
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1151, isError: true);return;
    }
    if (_selected.isEmpty || _selected.length > 20) {
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1161, isError: true);return;
    }
    final total = amount * _selected.length;
    if (total > 5000) {
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1171, isError: true);return;
    }
    if (_noteController.text.trim().characters.length > 300) {
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1181, isError: true);return;
    }
    if (balance < total) {await _showShortage(balance, total);return;}
    final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title:Text(AppLocalizations.of(context)!.official_studio_text_1191),
      content:Text(AppLocalizations.of(context)!.official_studio_text_1931(_selected.length, amount, total)),
      actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:Text(AppLocalizations.of(context)!.official_studio_text_0431)),
        FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:Text(AppLocalizations.of(context)!.official_studio_text_1201))],
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
      ToastUtils.showCenterToast(context, data['alreadySubmitted']==true?AppLocalizations.of(context)!.official_studio_text_1211:AppLocalizations.of(context)!.official_studio_text_1801(total));
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      final details=e.details;
      if (details is Map && details['reason']=='insufficient_balance') {
        final latest=(details['balance'] as num?)?.toInt()??balance;
        await _showShortage(latest,total);
      } else {
        ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1911, isError: true);
      }
    } catch(e) {
      if(mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1901, isError: true);
    } finally {if(mounted)setState(()=>_submitting=false);}
  }

  @override
  Widget build(BuildContext context) {
    final uid=FirebaseAuth.instance.currentUser?.uid;
    if(uid==null)return Scaffold(body:Center(child:Text(AppLocalizations.of(context)!.official_studio_text_0551)));
    final primary=Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar:AppBar(title:Text(AppLocalizations.of(context)!.official_studio_text_1221,style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
      body:_CreatorAccessGate(child:StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder:(context,userSnapshot){
          if(userSnapshot.hasError)return Center(child:Text(AppLocalizations.of(context)!.official_studio_text_1231));
          if(!userSnapshot.hasData)return const Center(child:CircularProgressIndicator());
          final raw=userSnapshot.data!.data()?['flowerPoints'];
          final balance=raw is num?raw.toInt():0;
          final amount=int.tryParse(_amountController.text.trim())??0;
          final total=amount*_selected.length;
          return ListView(padding:const EdgeInsets.all(18),children:[
            Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text(AppLocalizations.of(context)!.official_studio_text_1241,style:TextStyle(fontWeight:FontWeight.w600)),
              const SizedBox(height:8),Text(AppLocalizations.of(context)!.official_studio_text_1811(balance),style:TextStyle(fontSize:25,fontWeight:FontWeight.bold,color:primary)),
              const SizedBox(height:7),Text(AppLocalizations.of(context)!.official_studio_text_1251,style:TextStyle(fontSize:12)),
            ]))),
            const SizedBox(height:12),
            Text(AppLocalizations.of(context)!.official_studio_text_1261,style:GoogleFonts.notoSerifTc(fontSize:18,fontWeight:FontWeight.w600)),
            const SizedBox(height:6),
            Text(AppLocalizations.of(context)!.official_studio_text_1271,style:TextStyle(fontSize:12)),
            const SizedBox(height:12),
            TextField(
              controller: _fanSearchController,
              enabled: !_submitting,
              onChanged: _onFanSearchChanged,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.official_studio_text_1281,
                hintText: AppLocalizations.of(context)!.official_studio_text_1291,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _fanSearchController.text.isEmpty ? null : IconButton(
                  tooltip: AppLocalizations.of(context)!.official_studio_text_1301,
                  onPressed: () { _fanSearchController.clear(); _loadFans(reset: true); },
                  icon: const Icon(Icons.close_rounded),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height:8),
            if (_fanLoading && _fanResults.isEmpty)
              const Padding(padding: EdgeInsets.all(18), child: Center(child: CircularProgressIndicator())),
            if (!_fanLoading && _fanResults.isEmpty)
              Padding(padding: const EdgeInsets.all(18), child: Text(
                  _fanAppliedKeyword.isEmpty ? AppLocalizations.of(context)!.official_studio_text_1311 :
                  (_fanHasMore ? AppLocalizations.of(context)!.official_studio_text_1321 : AppLocalizations.of(context)!.official_studio_text_1331))),
            for (final person in _fanResults)
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                secondary: _StudioAvatar(url: person.avatar, size: 38),
                value: _selected.contains(person.uid),
                onChanged: _submitting ? null : (v) {
                  setState(() {
                    if (v == true) {
                      if (_selected.length < 20) {
                        _selected.add(person.uid);
                      } else {
                        ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.official_studio_text_1341);
                      }
                    } else {
                      _selected.remove(person.uid);
                    }
                    _requestId = null;
                  });
                },
                title: Text(person.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            if (_fanHasMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: OutlinedButton(
                  onPressed: _fanLoading ? null : () => _loadFans(),
                  child: Text(_fanLoading ? AppLocalizations.of(context)!.official_studio_text_1351 :
                  (_fanAppliedKeyword.isEmpty ? AppLocalizations.of(context)!.official_studio_text_1361 : AppLocalizations.of(context)!.official_studio_text_1371)),
                ),
              ),
            if (_fanLoading && _fanResults.isNotEmpty)
              const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
            const SizedBox(height:12),
            TextField(controller:_amountController,keyboardType:TextInputType.number,
                enabled:!_submitting,inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                onChanged:(_){setState((){_requestId=null;});},
                decoration:InputDecoration(labelText:AppLocalizations.of(context)!.official_studio_text_1381,hintText:AppLocalizations.of(context)!.official_studio_text_1391,border:OutlineInputBorder())),
            const SizedBox(height:12),TextField(controller:_noteController,maxLines:4,maxLength:300,
                enabled:!_submitting,onChanged:(_)=>_requestId=null,
                decoration:InputDecoration(labelText:AppLocalizations.of(context)!.official_studio_text_1401,border:OutlineInputBorder())),
            const SizedBox(height:12),Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(children:[
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(AppLocalizations.of(context)!.official_studio_text_1971),Text(AppLocalizations.of(context)!.official_studio_text_1821(_selected.length))]),
              const SizedBox(height:5),Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(AppLocalizations.of(context)!.official_studio_text_1411),Text(AppLocalizations.of(context)!.official_studio_text_1831(total))]),
              if(total>balance)Padding(padding:const EdgeInsets.only(top:8),child:Text(AppLocalizations.of(context)!.official_studio_text_1871(total-balance),style:const TextStyle(color:Colors.deepOrange))),
            ]))),
            const SizedBox(height:12),FilledButton.icon(
                onPressed:_submitting||_selected.isEmpty?null:()=>_submit(balance),
                icon:const Icon(Icons.card_giftcard_outlined),label:Text(_submitting?AppLocalizations.of(context)!.official_studio_text_0601:AppLocalizations.of(context)!.official_studio_text_1201)),
            const SizedBox(height:8),Text(AppLocalizations.of(context)!.official_studio_text_1421,style:TextStyle(fontSize:12)),
          ]);
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
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message??AppLocalizations.of(context)!.official_studio_text_1431)));
    }catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocalizations.of(context)!.official_studio_text_1441)));
    }finally{if(mounted)setState(()=>_loading=false);}
  }
  Future<void> _claim() async {
    if(_claiming || (_data?['claimed']==true))return;
    final confirmed=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
        title:Text(AppLocalizations.of(context)!.official_studio_text_1451),
        content:Text(AppLocalizations.of(context)!.official_studio_text_1461),
        actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:Text(AppLocalizations.of(context)!.official_studio_text_0431)),
          FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:Text(AppLocalizations.of(context)!.official_studio_text_1471))]));
    if(confirmed!=true || !mounted)return;
    setState(()=>_claiming=true);
    try{
      final result=await _functions.httpsCallable('claimCreatorMonthlyReward',options:HttpsCallableOptions(timeout:const Duration(seconds:90))).call();
      if(!mounted)return;
      final res=Map<String,dynamic>.from(result.data as Map);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(res['alreadyClaimed']==true?AppLocalizations.of(context)!.official_studio_text_1481:AppLocalizations.of(context)!.official_studio_text_1491)));
      await _load();
    }on FirebaseFunctionsException catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.message??AppLocalizations.of(context)!.official_studio_text_1501)));
      await _load();
    }catch(e){
      if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocalizations.of(context)!.official_studio_text_1511)));
      await _load();
    }finally{if(mounted)setState(()=>_claiming=false);}
  }
  @override
  Widget build(BuildContext context){
    final d=_data;
    final count=((d?['qualifyingCount'] as num?)?.toInt()??0).clamp(0,3);
    final claimed=d?['claimed']==true;
    final month=(d?['month']??AppLocalizations.of(context)!.official_studio_text_1521).toString();
    final color=Theme.of(context).colorScheme.primary;
    return Scaffold(appBar:AppBar(title:Text(AppLocalizations.of(context)!.official_studio_text_0181,style:GoogleFonts.notoSerifTc(fontWeight:FontWeight.w600))),
      body:_CreatorAccessGate(child:RefreshIndicator(onRefresh:_load,child:ListView(
          padding:const EdgeInsets.all(20),children:[
        Card(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(AppLocalizations.of(context)!.official_studio_text_1841(month),style:GoogleFonts.notoSerifTc(fontSize:20,fontWeight:FontWeight.w600)),
          const SizedBox(height:8),Text(AppLocalizations.of(context)!.official_studio_text_1531,style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant,height:1.6)),
          const SizedBox(height:18),Text(AppLocalizations.of(context)!.official_studio_text_1851(count),style:const TextStyle(fontWeight:FontWeight.w600)),
          const SizedBox(height:8),LinearProgressIndicator(value:count/3,color:color,minHeight:9,borderRadius:BorderRadius.circular(8)),
          const SizedBox(height:18),SizedBox(width:double.infinity,child:FilledButton.icon(
              onPressed:_loading||_claiming||d==null||claimed||count<3?null:_claim,
              icon:_claiming?const SizedBox(width:17,height:17,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.local_florist_outlined),
              label:Text(claimed?AppLocalizations.of(context)!.official_studio_text_1981:count<3?AppLocalizations.of(context)!.official_studio_text_1861(3-count):'領取 300 朵花花'))),
          if(_loading)const Padding(padding:EdgeInsets.only(top:12),child:LinearProgressIndicator()),
        ]))),
        const SizedBox(height:12),
        Text(AppLocalizations.of(context)!.official_studio_text_1541,
            style:TextStyle(fontSize:12,height:1.7,color:Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height:8),
        Text(AppLocalizations.of(context)!.official_studio_text_1551,
            style:TextStyle(fontSize:12,height:1.6,color:Theme.of(context).colorScheme.onSurfaceVariant)),
      ]))),);
  }
}

/// 官方合作創作者四步驟導覽：純文字，不使用 Material Icon。
class _CreatorStudioIntroDialog extends StatefulWidget {
  const _CreatorStudioIntroDialog();

  @override
  State<_CreatorStudioIntroDialog> createState() => _CreatorStudioIntroDialogState();
}

class _CreatorStudioIntroDialogState extends State<_CreatorStudioIntroDialog> {
  int _step = 0;

  List<String> _titles(BuildContext context) => <String>[
    AppLocalizations.of(context)!.official_studio_text_1561,
    AppLocalizations.of(context)!.official_studio_text_1571,
    AppLocalizations.of(context)!.official_studio_text_1581,
    AppLocalizations.of(context)!.official_studio_text_1591,
  ];

  List<String> _subtitles(BuildContext context) => <String>[
    AppLocalizations.of(context)!.official_studio_text_1601,
    AppLocalizations.of(context)!.official_studio_text_1611,
    AppLocalizations.of(context)!.official_studio_text_1621,
    AppLocalizations.of(context)!.official_studio_text_1631,
  ];

  List<String> _descriptions(BuildContext context) => <String>[
    AppLocalizations.of(context)!.official_studio_text_1641,
    AppLocalizations.of(context)!.official_studio_text_1651,
    AppLocalizations.of(context)!.official_studio_text_1661,
    AppLocalizations.of(context)!.official_studio_text_1671,
  ];

  List<String> _notes(BuildContext context) => <String>[
    AppLocalizations.of(context)!.official_studio_text_1681,
    AppLocalizations.of(context)!.official_studio_text_1691,
    AppLocalizations.of(context)!.official_studio_text_1701,
    AppLocalizations.of(context)!.official_studio_text_1711,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      contentPadding: const EdgeInsets.fromLTRB(22, 18, 22, 10),
      actionsPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      title: Row(
        children: [
          Expanded(child: Text(AppLocalizations.of(context)!.official_studio_text_1721, style: GoogleFonts.notoSerifTc(
              fontSize: 18, fontWeight: FontWeight.w600))),
          Text('${_step + 1} / 4', style: TextStyle(
              fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: List.generate(4, (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: index <= _step ? primary : primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ))),
              const SizedBox(height: 24),
              Text(_subtitles(context)[_step], style: TextStyle(
                  fontSize: 12, color: primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(_titles(context)[_step], style: GoogleFonts.notoSerifTc(
                  fontSize: 19, height: 1.45, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              Text(_descriptions(context)[_step], style: TextStyle(
                  fontSize: 14, height: 1.75,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.82))),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_notes(context)[_step], style: TextStyle(
                    fontSize: 12.5, height: 1.6,
                    color: theme.colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.official_studio_text_1731),
        ),
        if (_step > 0)
          TextButton(
            onPressed: () => setState(() => _step--),
            child: Text(AppLocalizations.of(context)!.official_studio_text_1741),
          ),
        FilledButton(
          onPressed: () {
            if (_step == 3) {
              Navigator.of(context).pop(true);
            } else {
              setState(() => _step++);
            }
          },
          child: Text(_step == 3 ? AppLocalizations.of(context)!.official_studio_text_1751 : AppLocalizations.of(context)!.official_studio_text_1761),
        ),
      ],
    );
  }
}

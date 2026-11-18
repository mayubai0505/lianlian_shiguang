import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/app_constants.dart';
import '../services/toast_utils.dart';
import '../utils/character_navigator.dart';
import 'world_discovery_page.dart';

// New labels only; reuse generated AppLocalizations for all existing strings.
// These can be moved into ARB when the full language source set is available.
class _LibraryLabels {
  final String title, bookmarks, likes, empty, unavailable, unlike;
  const _LibraryLabels(this.title, this.bookmarks, this.likes, this.empty, this.unavailable, this.unlike);
  static const _all = <String, _LibraryLabels>{
    'zh': _LibraryLabels('我的收藏與喜愛', '我的收藏', '我的喜愛', '目前沒有作品', '作品已下架或不再公開', '取消喜歡'),
    'zh_Hans': _LibraryLabels('我的收藏与喜爱', '我的收藏', '我的喜爱', '目前没有作品', '作品已下架或不再公开', '取消喜欢'),
    'en': _LibraryLabels('My bookmarks & likes', 'Bookmarks', 'Liked', 'No works yet', 'Work no longer available', 'Unlike'),
    'ar': _LibraryLabels('محفوظاتي وإعجاباتي', 'المحفوظات', 'الإعجابات', 'لا توجد أعمال بعد', 'العمل غير متاح', 'إلغاء الإعجاب'),
    'de': _LibraryLabels('Meine Merkliste & Likes', 'Merkliste', 'Gefällt mir', 'Noch keine Werke', 'Werk nicht mehr verfügbar', 'Gefällt mir nicht mehr'),
    'es': _LibraryLabels('Mis guardados y favoritos', 'Guardados', 'Me gusta', 'Aún no hay obras', 'Obra no disponible', 'Quitar Me gusta'),
    'fr': _LibraryLabels('Mes favoris et mentions J’aime', 'Enregistrés', 'J’aime', 'Aucune œuvre pour le moment', 'Œuvre indisponible', 'Retirer le J’aime'),
    'id': _LibraryLabels('Simpanan dan suka saya', 'Tersimpan', 'Disukai', 'Belum ada karya', 'Karya tidak tersedia', 'Batal suka'),
    'it': _LibraryLabels('I miei salvati e Mi piace', 'Salvati', 'Mi piace', 'Nessuna opera', 'Opera non disponibile', 'Rimuovi Mi piace'),
    'ja': _LibraryLabels('マイコレクションといいね', 'コレクション', 'いいね', 'まだ作品がありません', '公開されていない作品です', 'いいねを取り消す'),
    'ko': _LibraryLabels('내 북마크 및 좋아요', '북마크', '좋아요', '아직 작품이 없어요', '더 이상 공개되지 않는 작품', '좋아요 취소'),
    'pt': _LibraryLabels('Meus salvos e curtidas', 'Salvos', 'Curtidas', 'Ainda não há obras', 'Obra indisponível', 'Descurtir'),
    'ru': _LibraryLabels('Мои закладки и лайки', 'Закладки', 'Понравилось', 'Пока нет работ', 'Работа недоступна', 'Убрать лайк'),
    'th': _LibraryLabels('รายการบันทึกและถูกใจ', 'บันทึก', 'ถูกใจ', 'ยังไม่มีผลงาน', 'ผลงานไม่พร้อมใช้งาน', 'เลิกถูกใจ'),
    'vi': _LibraryLabels('Bộ sưu tập và lượt thích', 'Đã lưu', 'Đã thích', 'Chưa có tác phẩm', 'Tác phẩm không còn công khai', 'Bỏ thích'),
    'tr': _LibraryLabels('Yer işaretlerim ve beğenilerim', 'Kaydedilenler', 'Beğenilenler', 'Henüz eser yok', 'Eser artık erişilebilir değil', 'Beğeniyi kaldır'),
    'ms': _LibraryLabels('Simpanan dan suka saya', 'Disimpan', 'Disukai', 'Belum ada karya', 'Karya tidak tersedia', 'Batal suka'),
  };
  static _LibraryLabels of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    if (lang == 'zh' && (locale.scriptCode == 'Hans' || locale.countryCode == 'CN' || locale.countryCode == 'SG')) {
      return _all['zh_Hans']!;
    }
    return _all[lang] ?? _all['en']!;
  }
}

class SavedWorksPage extends StatefulWidget {
  const SavedWorksPage({super.key});
  static String title(BuildContext context) => _LibraryLabels.of(context).title;
  @override
  State<SavedWorksPage> createState() => _SavedWorksPageState();
}

class _SavedWorksPageState extends State<SavedWorksPage> {
  late final Stream<User?> _auth = FirebaseAuth.instance.authStateChanges();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(SavedWorksPage.title(context))),
      body: StreamBuilder<User?>(
        stream: _auth,
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          final uid = snapshot.data?.uid;
          if (uid == null) return Center(child: Text(l10n.profilePagePleaseSignIn));
          return _SavedWorksBody(key: ValueKey(uid), uid: uid);
        },
      ),
    );
  }
}

class _SavedWorksBody extends StatefulWidget {
  final String uid;
  const _SavedWorksBody({super.key, required this.uid});
  @override
  State<_SavedWorksBody> createState() => _SavedWorksBodyState();
}

class _SavedWorksBodyState extends State<_SavedWorksBody> {
  bool _showLikes = false;
  bool _showWorlds = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _bookmarks;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _likes;
  @override
  void initState() {
    super.initState();
    _bindStreams();
  }
  void _bindStreams() {
    final user = FirebaseFirestore.instance.collection('users').doc(widget.uid);
    _bookmarks = user.collection('bookmarks').snapshots();
    _likes = user.collection('liked_works').snapshots();
  }
  int _stamp(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final value = doc.data()[_showLikes ? 'likedAt' : 'bookmarkedAt'];
    return value is Timestamp ? value.millisecondsSinceEpoch : 0;
  }
  @override
  Widget build(BuildContext context) {
    final labels = _LibraryLabels.of(context);
    final l10n = AppLocalizations.of(context)!;
    final prefix = _showWorlds ? 'world_' : 'character_';
    return SafeArea(top: false, child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), child: Row(children: [
          Expanded(child: ChoiceChip(label: Text(labels.bookmarks, overflow: TextOverflow.ellipsis),
            selected: !_showLikes,
            onSelected: (_) => setState(() => _showLikes = false))),
          const SizedBox(width: 8),
          Expanded(child: ChoiceChip(label: Text(labels.likes, overflow: TextOverflow.ellipsis),
            selected: _showLikes,
            onSelected: (_) => setState(() => _showLikes = true))),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), child: Row(children: [
          Expanded(child: ChoiceChip(label: Text(l10n.profilePageTabCharacters, overflow: TextOverflow.ellipsis),
            selected: !_showWorlds, onSelected: (_) => setState(() => _showWorlds = false))),
          const SizedBox(width: 8),
          Expanded(child: ChoiceChip(label: Text(l10n.profile_page_world_tab1, overflow: TextOverflow.ellipsis),
            selected: _showWorlds, onSelected: (_) => setState(() => _showWorlds = true))),
        ])),
        Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          key: ValueKey(_showLikes),
          stream: _showLikes ? _likes : _bookmarks,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: TextButton.icon(icon: const Icon(Icons.refresh),
                onPressed: () => setState(_bindStreams), label: Text(l10n.common_operation_failed_retry)));
            }
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data!.docs.where((doc) {
              if (!doc.id.startsWith(prefix) || doc.id.length <= prefix.length) return false;
              final data = doc.data();
              final type = data['type'];
              return type == null || type == (_showWorlds ? 'world' : 'character');
            }).toList()..sort((a,b) => _stamp(b).compareTo(_stamp(a)));
            if (docs.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(_showLikes ? Icons.favorite_border : Icons.bookmark_border,
                size: 48, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12), Text(labels.empty),
            ]));
            return GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: _showWorlds ? 340 : 210,
                childAspectRatio: _showWorlds ? 1.24 : 0.75,
                crossAxisSpacing: 10, mainAxisSpacing: 10,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return _SavedWorkCard(
                  key: ValueKey('${_showLikes ? 'like' : 'bookmark'}:${doc.id}'),
                  uid: widget.uid, workId: doc.id.substring(prefix.length),
                  record: doc.reference, isWorld: _showWorlds, isLiked: _showLikes,
                );
              },
            );
          },
        )),
      ]),
    )));
  }
}

class _SavedWorkCard extends StatefulWidget {
  final String uid, workId;
  final DocumentReference<Map<String, dynamic>> record;
  final bool isWorld, isLiked;
  const _SavedWorkCard({super.key, required this.uid, required this.workId,
    required this.record, required this.isWorld, required this.isLiked});
  @override
  State<_SavedWorkCard> createState() => _SavedWorkCardState();
}

class _SavedWorkCardState extends State<_SavedWorkCard> {
  late final Stream<DocumentSnapshot<Map<String,dynamic>>> _publicWork;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _publicWork = FirebaseFirestore.instance.collection('artifacts').doc(AppConfig.appId)
        .collection(widget.isWorld ? 'public_worlds' : 'public_characters')
        .doc(widget.workId).snapshots();
  }
  bool _available(Map<String,dynamic>? data) => data != null && data['isPublic'] == true &&
      (widget.isWorld ? data['status'] == 'public' && data['publicPlayable'] == true
          : data['status'] == 'published');
  String _str(Map<String,dynamic> data, String key) => (data[key] ?? '').toString().trim();
  Future<void> _remove() async {
    if (_busy || FirebaseAuth.instance.currentUser?.uid != widget.uid) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      if (!widget.isLiked) {
        await widget.record.delete();
      } else {
        final result = await FirebaseFunctions.instanceFor(region: 'us-central1')
            .httpsCallable(widget.isWorld ? 'setWorldLike' : 'setCharacterLike')
            .call({if (widget.isWorld) 'worldId': widget.workId else 'characterId': widget.workId, 'liked': false});
        if (result.data is! Map || result.data['success'] != true || result.data['liked'] != false) {
          throw StateError('取消喜歡未確認');
        }
      }
    } catch (e) {
      debugPrint('取消作品收藏／喜歡失敗：$e');
      if (mounted) ToastUtils.showCenterToast(context, l10n.common_operation_failed_retry, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
  Future<void> _open(String name) async {
    if (FirebaseAuth.instance.currentUser?.uid != widget.uid) return;
    if (widget.isWorld) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => WorldDiscoveryPage(worldId: widget.workId)));
    } else {
      await CharacterNavigator.open(context, characterId: widget.workId, fallbackName: name);
    }
  }
  Widget _picture(String url, ThemeData theme) {
    final placeholder = ColoredBox(color: theme.colorScheme.surfaceContainerHighest,
      child: Center(child: Icon(widget.isWorld ? Icons.public : Icons.person_outline, size: 34,
        color: theme.colorScheme.outline)));
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImage(imageUrl: url, fit: BoxFit.cover,
        placeholder: (_, __) => placeholder, errorWidget: (_, __, ___) => placeholder);
    }
    if (url.startsWith('assets/')) return Image.asset(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => placeholder);
    return placeholder;
  }
  @override
  Widget build(BuildContext context) {
    final labels = _LibraryLabels.of(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
      stream: _publicWork,
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final available = !snapshot.hasError && _available(data);
        final loading = !snapshot.hasData && !snapshot.hasError;
        // Do not display the cached bookmark's old name or image after removal
        // or unpublishing. Only live public document data may be shown.
        final name = available ? _str(data!, 'name') :
            snapshot.hasError ? l10n.common_operation_failed_retry : loading ? '' : labels.unavailable;
        String cover = '';
        if (available) {
          cover = _str(data!, widget.isWorld ? 'coverImage' : 'avatarPath');
          if (!widget.isWorld && cover.isEmpty) cover = _str(data!, 'bannerImagePath');
        }
        return Card(clipBehavior: Clip.antiAlias, margin: EdgeInsets.zero,
          child: InkWell(onTap: available && !_busy ? () => _open(name) : null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: loading ? const Center(child: SizedBox(width: 24, height: 24,
                child: CircularProgressIndicator(strokeWidth: 2))) : _picture(cover, theme)),
              Padding(padding: const EdgeInsets.only(left: 9, right: 2), child: Row(children: [
                Expanded(child: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: available ? theme.colorScheme.onSurface : theme.colorScheme.outline))),
                IconButton(
                  tooltip: widget.isLiked ? labels.unlike : l10n.character_profile_remove_bookmark,
                  onPressed: _busy ? null : _remove,
                  icon: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) :
                      Icon(widget.isLiked ? Icons.favorite_rounded : Icons.bookmark_rounded, color: theme.colorScheme.primary, size: 21),
                ),
              ])),
            ]),
          ),
        );
      },
    );
  }
}

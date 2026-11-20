import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:ui';
import '../services/app_constants.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';

class CharacterGalleryWidget extends StatefulWidget {
  final String characterId;
  final Character character;
  final int? currentAffection; // Legacy constructor compatibility; not a room score.
  final Future<void> Function(String)? onBackgroundChanged;
  const CharacterGalleryWidget({
    Key? key,
    required this.character,
    required this.characterId,
    this.currentAffection,
    this.onBackgroundChanged,
  }) : super(key: key);

  @override
  State<CharacterGalleryWidget> createState() => _CharacterGalleryWidgetState();
}

class _CharacterGalleryWidgetState extends State<CharacterGalleryWidget> {
  bool _savingBackground = false;
  DocumentReference<Map<String, dynamic>>? _characterRef;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _characterStream;
  Future<int>? _legacyHighest;

  void _bindCharacter() {
    final user = FirebaseAuth.instance.currentUser;
    _characterRef = user == null ? null : FirebaseFirestore.instance
        .collection('users').doc(user.uid).collection('characters')
        .doc(widget.character.id);
    _characterStream = _characterRef?.snapshots();
    _legacyHighest = null;
  }

  Future<int> _readLegacyHighest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    final rooms = await FirebaseFirestore.instance.collection('artifacts')
        .doc(AppConfig.appId).collection('chat_sessions')
        .where('userId', isEqualTo: user.uid)
        .where('characterId', isEqualTo: widget.character.id).get();
    int highest = 0;
    for (final room in rooms.docs) {
      final score = room.data()['friendshipScore'];
      if (score is num && score.toInt() > highest) highest = score.toInt();
    }
    return highest;
  }
  late Future<List<CharacterPhoto>> _photosFuture;

  @override
  void initState() {
    super.initState();
    _bindCharacter();
    _photosFuture = _initialPhotosFuture();
  }

  @override
  void didUpdateWidget(covariant CharacterGalleryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.characterId != widget.characterId) {
      _bindCharacter();
      _photosFuture = _initialPhotosFuture();
    }
  }

  Future<List<CharacterPhoto>> _initialPhotosFuture() {
    final existingGallery = widget.character.gallery;

    if (existingGallery != null && existingGallery.isNotEmpty) {
      return Future.wait(existingGallery.map((original) async {
        final photo = CharacterPhoto.fromMap(original.toMap());
        if (photo.imageUrl.startsWith('gs://')) {
          try {
            photo.imageUrl = await FirebaseStorage.instance
                .refFromURL(photo.imageUrl).getDownloadURL();
          } catch (_) {}
        }
        return photo;
      }));
    }

    return fetchPhotos(widget.characterId);
  }
  // ☁️ 抓取雲端照片清單
  Future<List<CharacterPhoto>> fetchPhotos(String characterId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId)
          .collection('photos')
          .orderBy('req', descending: false)
          .get();

      // ✨ 關鍵：將 Map 轉為 CharacterPhoto 物件，並同時轉換 gs:// 網址
      List<CharacterPhoto> photoList =
      await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        // 1. 先把資料轉成初步的 CharacterPhoto 物件
        // 注意：這裡的 fromMap 要根據您的類別建構子調整
        var photo = CharacterPhoto.fromMap(data);
        // 2. ⚡️ 執行變身術：把 gs:// 換成 https://
        if (photo.imageUrl.startsWith('gs://')) {
          try {
            photo.imageUrl = await FirebaseStorage.instance
                .refFromURL(photo.imageUrl)
                .getDownloadURL();
          } catch (err) {
            print("相簿單張照片轉換失敗: $err");
          }
        }
        return photo;
      }).toList());

      return photoList;
    } catch (e) {
      print("🚨 fetchPhotos 執行失敗: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_characterRef == null) return const SizedBox.shrink();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _characterStream,
      builder: (context, account) {
        final l10n = AppLocalizations.of(context)!;
        if (account.hasError) return Text(l10n.common_operation_failed_retry);
        if (!account.hasData) return const SizedBox(height: 160,
            child: Center(child: CircularProgressIndicator()));
        final data = account.data!.data();
        final raw = data?['affection'];
        final score = raw is num ? raw.toInt() : 0;
        final selected = data?['callBackgroundUrl'];
        final url = selected is String ? selected : '';
        if (score > 0) return _buildGallery(context, score, url);
        // Existing legacy migration reads the same rooms when no global score exists.
        _legacyHighest ??= _readLegacyHighest();
        return FutureBuilder<int>(
          future: _legacyHighest,
          builder: (context, legacy) {
            if (legacy.hasError) return Text(l10n.common_operation_failed_retry);
            if (!legacy.hasData) return const SizedBox(height: 160,
                child: Center(child: CircularProgressIndicator()));
            return _buildGallery(context, legacy.data!, url);
          },
        );
      },
    );
  }

  Widget _buildGallery(BuildContext context, int currentAffection, String selectedBackground) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    // 🌟 1. 改用 FutureBuilder，並把妳寫好的轉換器 fetchPhotos 放進來！
    return FutureBuilder<List<CharacterPhoto>>(
      future: _photosFuture,
      builder: (context, snapshot) {
        // 2. 當資料還在轉換時，顯示轉圈圈
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // 🚨 防呆：如果轉換失敗或沒資料
        if (snapshot.hasError) {
          return Center(
            child: Text(
              l10n.photo_load_failed(
                snapshot.error?.toString() ?? 'Unknown Error',
              ),
            ),
          );
        }
        // 3. 拿到轉換好的乾淨照片清單
        final gallery = snapshot.data ?? [];
        // 🌟 4. 這裡才開始 return 妳的 UI (Column)，這樣它才能抓到上面最新的 gallery
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題與好感度顯示
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.gallery_title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.gallery_current_affection(
                        currentAffection.toString(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 這裡就是妳的照片 ListView
            SizedBox(
              height: 160,
              child: gallery.isEmpty
                  ? Center(child: Text(l10n.gallery_empty))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  final photo = gallery[index];
                  final String photoUrl = photo.imageUrl;
                  final String photoDesc = photo.description;
                  final int requiredAffection = photo.requiredAffection;
                  final bool isUnlocked =
                      currentAffection >= requiredAffection;
                  final bool isSelected = selectedBackground == photoUrl;
                  // 🛡️ 加上這個防呆守衛！
                  // 如果這筆資料的網址是空的，我們就回傳一個空的隱藏元件，不要讓它去畫圖
                  if (photoUrl.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () async {
                      if (!isUnlocked) {
                        _showLockSnackBar(context, requiredAffection);
                        return;
                      }
                      if (_savingBackground) return;
                      setState(() => _savingBackground = true);
                      final next = isSelected ? '' : photoUrl;
                      final onChanged = widget.onBackgroundChanged;
                      try {
                        await _updateCallBackgroundToCloud(next);
                        // Notify the parent only after the existing cloud field is saved.
                        await onChanged?.call(next);
                        if (!mounted || !context.mounted) return;
                        if (isSelected) {
                          ToastUtils.showCenterToast(context, l10n.gallery_reset_bg);
                        } else {
                          _showSuccessSnackBar(context, photoDesc);
                        }
                      } catch (_) {
                        if (mounted && context.mounted) {
                          ToastUtils.showCenterToast(context,
                              l10n.common_operation_failed_retry, isError: true);
                        }
                      } finally {
                        if (mounted) setState(() => _savingBackground = false);
                      }
                    },
                    child: _buildPhotoCard(photoUrl, photoDesc,
                        isUnlocked, isSelected, requiredAffection, theme),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // 🖼️ 漂亮的相片卡片組件（含模糊邏輯）
  Widget _buildPhotoCard(String url, String desc, bool isUnlocked,
      bool isSelected, int req, ThemeData theme) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🌟 使用 CachedNetworkImage 代替 Image.network
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              memCacheWidth: 420,
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              placeholderFadeInDuration: Duration.zero,
              useOldImageOnUrlChange: true,
              // 這裡就是「快取版」的處理邏輯
              imageBuilder: (context, imageProvider) => ImageFiltered(
                imageFilter: isUnlocked
                    ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                    : ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // 圖片還在下載時顯示的佔位圖（轉圈圈或灰色塊）
              placeholder: (context, url) => Container(
                color: Colors.grey.shade100,
              ),
              // 萬一網址掛掉顯示的錯誤圖
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
              ),
            ),

            // --- 接下來是原本的鎖頭和打勾邏輯，維持不變 ---
            if (!isUnlocked)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline,
                        color: Colors.white, size: 28),
                    Text('$req 💕',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            if (isSelected)
              const Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white, size: 14))),
          ],
        ),
      ),
    );
  }

  // 提示訊息與同步函式（維持總裁原本的專業邏輯）
  void _showSuccessSnackBar(BuildContext context, String desc) {
    final l10n = AppLocalizations.of(context)!;

    // ✨ 總裁級：解鎖成功的優雅回饋，給予玩家滿滿的成就感！
    ToastUtils.showCenterToast(
      context,
      l10n.gallery_unlocked_msg(desc),
    );
  }

  void _showLockSnackBar(BuildContext context, int req) {
    final l10n = AppLocalizations.of(context)!;

    // ✨ 總裁級：未達門檻的溫柔提醒，用鎖頭圖示鼓勵玩家繼續努力！
    ToastUtils.showCenterToast(
      context,
      l10n.gallery_lock_msg(req.toString()),
    );
  }

  Future<void> _updateCallBackgroundToCloud(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('not_signed_in');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('characters')
        .doc(widget.character.id)
        .set({
      'callBackgroundUrl': url,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import 'chat_page.dart';
import 'character_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/character_service.dart';
import 'package:cloud_functions/cloud_functions.dart'; // ✨ 就是這一行！
import '../services/translationService.dart';
import 'creator_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui'; // 🌟 為了 ImageFilter
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/character_report_service.dart';
import '../services/character_block_service.dart';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//角色卡片內容

class CharacterProfilePage extends StatefulWidget {
  final String? sessionId;
  final Character character;
  final String characterId;
  const CharacterProfilePage({
    super.key,
    required this.character,
    required this.characterId,
    this.sessionId,
  });

  @override
  State<CharacterProfilePage> createState() => _CharacterProfilePageState();
}

// ✨ 加上 SingleTickerProviderStateMixin 才能使用 TabController
class _CharacterProfilePageState extends State<CharacterProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // ✨ 總裁新增：用來控制「加好友」狀態與讀取動畫
  bool _isFriend = false;
  bool _isFriendLoading = false;
  bool _isTogglingLike = false;
  bool _hasLiked = false;
  bool _isNavigating = false;
  bool _isFollowing = false; // 放在 State 類別的最上方
  bool _isCharacterBookmarked = false;
  bool _isCharacterBookmarkLoading = false;
  int _currentHeaderPhotoIndex = 0;
  // 🌟 總裁指令：不管是大寫還是小寫，通通都要聽 AppConfig 的話！
  final String APP_ID = AppConfig.appId;
  bool _isTranslating = false;
  String? _translatedBackground;
  List<String>? _translatedLikes;
  List<String>? _translatedDislikes;
  final GlobalKey _characterShareCardKey = GlobalKey();
  List<String>? _translatedTags;
  final LoreTranslateService _loreTranslateService = LoreTranslateService();
  String _playerNickname = '旅人';
  String _currentUserId = "";
  bool _isWorldSettingExpanded = false;
  String _getCharacterShareAppLink() {
    return 'https://lianlianshiguang.web.app/download/';
  }

  String _buildCharacterShareText() {
    final l10n = AppLocalizations.of(context)!;
    final character = widget.character;

    final String characterName = character.name.trim();

    final String firstLine = character.firstLine.trim();

    final String creatorName = character.creatorName.trim();

    final bool hasCreatorName = creatorName.isNotEmpty &&
        creatorName != '神祕創作者' &&
        creatorName != '神秘創作者';

    final String appLink = _getCharacterShareAppLink();

    final buffer = StringBuffer()
      ..writeln(l10n.characterProfileShareInvitation)
      ..writeln()
      ..writeln('「$characterName」')
      ..writeln();

    if (firstLine.isNotEmpty) {
      buffer
        ..writeln(firstLine)
        ..writeln();
    }

    if (hasCreatorName) {
      buffer
        ..writeln(
          l10n.characterProfileShareCreator(creatorName),
        )
        ..writeln();
    }

    buffer.write(
      l10n.characterProfileShareMessage(characterName),
    );

    if (appLink.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..write(appLink);
    }

    return buffer.toString();
  }

  // 🌟 用來存每一則迴音的翻譯結果：key 是 docId，value 是翻譯後的文字
  Map<String, String> _translatedEchoes = {};
// 🌟 用來存哪些迴音正在翻譯中，好顯示小蝴蝶
  Set<String> _translatingEchoIds = {};
  // 動態判斷代名詞 (總裁神邏輯)
  String get _pronoun {
    final l10n = AppLocalizations.of(context)!;
    // ✨ 順便把女生也換成多國語言判斷，這樣最安全！(假設妳的翻譯包裡有 genderFemale)
    if (widget.character.gender.contains(l10n.genderFemale)) return '她';
    if (widget.character.gender.contains(l10n.genderMale)) return '他';
    return '它';
  }

  // 判斷當前使用者是不是創作者
  bool get _isCreator {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == widget.character.createdBy;
  }

// 🔑 1. 新增：時空迴音按鈕的專屬鑰匙
  final GlobalKey _echoKey = GlobalKey();

  // 💡 2. 新增：紀錄迴音氣泡彈過了沒 (預設 true，等翻記事本)
  bool _hasEchoTipShown = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
// 🌟  去翻記事本，看看他以前看過迴音氣泡了沒
    _checkEchoTutorial();
    // 🌟 4. 魔法監聽器：當玩家切換分頁時觸發！
    _tabController.addListener(() {
      // 如果切換到了第三個分頁 (index 2)，而且還沒發射過氣泡
      if (_tabController.index == 2 && !_hasEchoTipShown) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            // 立刻發射氣泡！
            ShowCaseWidget.of(context).startShowCase([_echoKey]);
          } catch (e) {
            print("⚠️ 找不到 ShowCaseWidget");
          }
        });
        // 標記為已發射，避免切來切去重複彈
        _hasEchoTipShown = true;
      }
    });
    // 這能解決 dependOnInheritedWidget 的報錯（因為這時 context 已經準備好了）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchCurrentPlayerName();
        _autoRecordEncounter();
        _checkIfLiked();
        _checkIfFriend();
        _migrateLegacyAffection(); // 啟動搬家小精靈
        _checkCreatorFollowStatus();
        _checkIfCharacterBookmarked();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkEchoTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeen = prefs.getBool('seen_profile_echo_tip') ?? false;

    if (!hasSeen) {
      if (mounted) {
        setState(() {
          _hasEchoTipShown = false; // 允許發射氣泡
        });
      }
      // ✍️ 寫下紀錄，這輩子只彈這一次！
      await prefs.setBool('seen_profile_echo_tip', true);
    }
  }

  DocumentReference<Map<String, dynamic>>? get _characterBookmarkRef {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc('character_${widget.character.id}');
  }

  Future<void> _checkIfCharacterBookmarked() async {
    final ref = _characterBookmarkRef;
    if (ref == null) return;

    try {
      final snapshot = await ref.get();
      if (!mounted) return;

      setState(() {
        _isCharacterBookmarked = snapshot.exists;
      });
    } catch (e) {
      debugPrint('⚠️ 讀取角色收藏狀態失敗：$e');
    }
  }

  Future<void> _toggleCharacterBookmark() async {
    if (_isCharacterBookmarkLoading) return;

    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final ref = _characterBookmarkRef;

    if (user == null || ref == null) {
      ToastUtils.showCenterToast(
        context,
        l10n.profilePagePleaseSignIn,
        isError: true,
      );
      return;
    }

    final bool oldValue = _isCharacterBookmarked;
    final bool newValue = !oldValue;

    setState(() {
      _isCharacterBookmarkLoading = true;
      _isCharacterBookmarked = newValue;
    });

    try {
      if (newValue) {
        await ref.set({
          'type': 'character',
          'characterId': widget.character.id,
          'characterName': widget.character.name,
          'avatarPath': widget.character.avatarPath,
          'bannerImagePath': widget.character.bannerImagePath,
          'bookmarkedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        await ref.delete();
      }
    } catch (e) {
      debugPrint('❌ 更新角色收藏失敗：$e');

      if (mounted) {
        setState(() {
          _isCharacterBookmarked = oldValue;
        });

        ToastUtils.showCenterToast(
          context,
          l10n.common_operation_failed_retry,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCharacterBookmarkLoading = false;
        });
      }
    }
  }

  Future<void> _checkCreatorFollowStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final String creatorId = widget.character.createdBy;

    if (creatorId.isEmpty || currentUser.uid == creatorId) {
      return;
    }

    try {
      final followDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('following')
          .doc(creatorId)
          .get();

      if (!mounted) return;

      setState(() {
        _isFollowing = followDoc.exists;
      });
    } catch (e) {
      debugPrint('❌ 讀取創作者追蹤狀態失敗：$e');
    }
  }

  Future<void> _toggleCreatorFollowFromCharacter({
    required String creatorId,
    required String creatorName,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    final db = FirebaseFirestore.instance;

    String resolvedCreatorName = creatorName.trim();

    // 角色舊資料中的 creatorName 可能仍是「神秘創作者」，
    // 因此每次追蹤都以創作者帳號目前的 nickname 為優先來源。
    try {
      final creatorSnapshot = await db.collection('users').doc(creatorId).get();
      final creatorData = creatorSnapshot.data();

      final possibleNames = <String>[
        creatorData?['nickname']?.toString().trim() ?? '',
        creatorData?['displayName']?.toString().trim() ?? '',
        creatorData?['name']?.toString().trim() ?? '',
      ];

      final accountCreatorName = possibleNames.firstWhere(
            (name) => name.isNotEmpty,
        orElse: () => '',
      );

      if (accountCreatorName.isNotEmpty) {
        resolvedCreatorName = accountCreatorName;
      }
    } catch (e) {
      debugPrint('⚠️ 讀取創作者名稱失敗，暫用角色資料名稱：$e');
    }

    if (resolvedCreatorName.isEmpty ||
        resolvedCreatorName.contains('神秘創作者') ||
        resolvedCreatorName.contains('神祕創作者')) {
      resolvedCreatorName = l10n.profilePageCreator;
    }

    if (currentUser == null) {
      ToastUtils.showCenterToast(
        context,
        l10n.profilePagePleaseSignIn,
        isError: true,
      );
      return;
    }

    if (currentUser.uid == creatorId) {
      ToastUtils.showCenterToast(
        context,
        l10n.follow_own_warning,
        customIcon: Icons.front_hand_rounded,
      );
      return;
    }

    final followingRef = db
        .collection('users')
        .doc(currentUser.uid)
        .collection('following')
        .doc(creatorId);

    final followerRef = db
        .collection('users')
        .doc(creatorId)
        .collection('followers')
        .doc(currentUser.uid);

    final bool wasFollowing = _isFollowing;

    setState(() {
      _isFollowing = !wasFollowing;
    });

    try {
      final batch = db.batch();

      if (wasFollowing) {
        batch.delete(followingRef);
        batch.delete(followerRef);
      } else {
        batch.set(followingRef, {
          'creatorId': creatorId,
          'creatorName': resolvedCreatorName,
          'followedAt': FieldValue.serverTimestamp(),
        });

        batch.set(followerRef, {
          'followerId': currentUser.uid,
          'followerName': _playerNickname,
          'followedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      debugPrint('❌ 追蹤關係寫入失敗：$e');

      if (!mounted) return;

      setState(() {
        _isFollowing = wasFollowing;
      });

      ToastUtils.showCenterToast(
        context,
        l10n.creatorProfileOperationFailed,
        isError: true,
      );
      return;
    }

    if (!mounted) return;

    ToastUtils.showCenterToast(
      context,
      wasFollowing ? l10n.creatorProfileUnfollowed : l10n.creatorProfileFollowedCreator(resolvedCreatorName),
      customIcon: wasFollowing
          ? Icons.person_remove_outlined
          : Icons.person_add_alt_1_rounded,
    );

    // 第二階段：通知失敗不能影響追蹤結果
    if (!wasFollowing) {
      try {
        await db.collection('users').doc(creatorId).collection('mailbox').add({
          'type': 'follow',
          'title': l10n.mailbox_follow_title,
          'body': l10n.mailbox_follow_body(
            _playerNickname,
          ),
          'fromId': currentUser.uid,
          'fromName': _playerNickname,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });

        debugPrint('✅ 追蹤通知寄送成功');
      } catch (e) {
        // 通知寄送失敗，不取消已成功的追蹤
        debugPrint(
          '⚠️ 追蹤已成功，但通知寄送失敗：$e',
        );
      }
    }
  }

  // 🌟 3. 核心函式：去 Firestore 抓取目前玩家的資料
  Future<void> _fetchCurrentPlayerName() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
        // 去 users 集合抓取這則 UID 的文件
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            // 抓取妳資料庫裡存暱稱的欄位（假設叫 'nickname'）
            _playerNickname =
                userDoc.data()?['nickname'] ?? l10n.default_new_player;
          });
        }
      }
    } catch (e) {
      print("抓取玩家暱稱失敗: $e");
    }
  }

  Future<void> _translateProfile(String targetLang) async {
    setState(() => _isTranslating = true);

    try {
      final String sourceBackground = widget.character.background;
      final String sourceLikes = widget.character.likes;
      final String sourceDislikes = widget.character.dislikes;

      // 把要翻譯的東西打包
      final results = await Future.wait([
        FirebaseFunctions.instanceFor(region: 'asia-east1')
            .httpsCallable('translateText')
            .call({
          'text': sourceBackground,
          'targetLanguage': targetLang,
        }),
        FirebaseFunctions.instanceFor(region: 'asia-east1')
            .httpsCallable('translateText')
            .call({
          'text': '$sourceLikes | $sourceDislikes', // 用特殊符號隔開一起翻比較省錢
          'targetLanguage': targetLang,
        }),
      ]);

      final String newBg = results[0].data['translatedText'];
      final String likesAndDislikes = results[1].data['translatedText'];
      final parts = likesAndDislikes.split('|');

      // ✨【方案 B 核心】：寫回 Firestore
      final charDocRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id);

      await charDocRef.set({
        'translations': {
          targetLang: {
            'background': newBg,
            'likes': parts[0].trim(),
            'dislikes': parts.length > 1 ? parts[1].trim() : '',
          }
        }
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _translatedBackground = newBg;
          _translatedLikes = [parts[0].trim()];
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isTranslating = false);
      print("翻譯詳情失敗: $e");
    }
  }

  // ✨ 2. 新增這個查詢函式 (把它放在 initState 下面)
  Future<void> _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 去角色的肚子裡，找一個叫做 likers (按讚者) 的名單，看這玩家在不在裡面
      final doc = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('likers')
          .doc(user.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _hasLiked = true; // 名單裡有他！把愛心亮起來！
        });
      }
    } catch (e) {
      print("檢查按讚狀態失敗: $e");
    }
  }

  Widget _buildCharacterShareCard() {
    final l10n = AppLocalizations.of(context)!;
    final character = widget.character;

    final String characterName = character.name.trim();

    final String firstLine = character.firstLine.trim();

    final String creatorName = character.creatorName.trim();

    final bool hasCreatorName = creatorName.isNotEmpty &&
        creatorName != '神祕創作者' &&
        creatorName != '神秘創作者';

    final String imageUrl = character.bannerImagePath.trim().isNotEmpty
        ? character.bannerImagePath.trim()
        : character.avatarPath.trim();
    final String appLink = _getCharacterShareAppLink();

    return RepaintBoundary(
      key: _characterShareCardKey,
      child: SizedBox(
        width: 360,
        height: 450,
        child: Material(
          color: const Color(0xFF24162E),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 角色圖片
              if (imageUrl.isNotEmpty)
                Image(
                  image: CachedNetworkImageProvider(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB99ACB),
                            Color(0xFF725084),
                            Color(0xFF2B1834),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome,
                          size: 72,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                )
              else
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFB99ACB),
                        Color(0xFF725084),
                        Color(0xFF2B1834),
                      ],
                    ),
                  ),
                ),

              // 圖片整體柔和遮罩
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.0,
                      0.48,
                      0.72,
                      1.0,
                    ],
                    colors: [
                      Color(0x14000000),
                      Color(0x10000000),
                      Color(0xB020102A),
                      Color(0xF21B1022),
                    ],
                  ),
                ),
              ),

              // 上方品牌
              Positioned(
                top: 24,
                left: 24,
                right: 24,
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFE9CFF3),
                      size: 18,
                    ),
                    SizedBox(width: 7),
                    Text(
                      l10n.app_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      l10n.characterProfileInvitationLabel,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 8,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 下方角色資訊＋下載 QR Code
              Positioned(
                left: 24,
                right: 24,
                bottom: 22,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 左側角色資訊
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 2,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDAB7E8),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            characterName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          if (firstLine.isNotEmpty) ...[
                            const SizedBox(height: 9),
                            Text(
                              firstLine,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFF3E8F7),
                                fontSize: 13,
                                height: 1.5,
                                letterSpacing: 0.3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          if (hasCreatorName)
                            Row(
                              children: [
                                const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white70,
                                  size: 13,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    l10n.characterProfileCardCreator(creatorName),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 7),
                          Text(
                            l10n.characterProfileCardSearchHint,
                            style: TextStyle(
                              color: Color(0xFFE2BDEF),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 右側 QR Code
                    if (appLink.isNotEmpty) ...[
                      const SizedBox(width: 14),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: appLink,
                              version: QrVersions.auto,
                              size: 64,
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.characterProfileScanToDownload,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // 精緻細框
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white24,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndShareCharacterCard(
      BuildContext shareButtonContext,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // 等待邀請卡與網路圖片完成目前這一幀
      await WidgetsBinding.instance.endOfFrame;

      final RenderRepaintBoundary? boundary =
      _characterShareCardKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('找不到角色邀請卡');
      }

      final image = await boundary.toImage(
        pixelRatio: 3,
      );

      final byteData = await image.toByteData(
        format: ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('無法產生角色邀請卡');
      }

      final imageBytes = byteData.buffer.asUint8List();

      final String safeCharacterName = widget.character.name
          .replaceAll(
        RegExp(r'[\\/:*?"<>|]'),
        '_',
      )
          .trim();

      final XFile shareFile = XFile.fromData(
        imageBytes,
        mimeType: 'image/png',
      );

      final RenderBox? box =
      shareButtonContext.findRenderObject() as RenderBox?;

      final Rect? sharePositionOrigin = box != null && box.hasSize
          ? box.localToGlobal(
        Offset.zero,
      ) &
      box.size
          : null;

      final String appLink = _getCharacterShareAppLink();

      if (appLink.isNotEmpty) {
        await Clipboard.setData(
          ClipboardData(text: appLink),
        );
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [shareFile],
          fileNameOverrides: [
            'lianlian_${widget.character.name}_invitation.png',
          ],
          text: _buildCharacterShareText(),
          title: l10n.characterProfileShareTitle(
            widget.character.name,
          ),
          subject: l10n.characterProfileShareSubject(
            widget.character.name,
          ),
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (error) {
      debugPrint(
        '❌ 角色邀請卡分享失敗：$error',
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.characterProfileShareFailed,
        isError: true,
      );
    }
  }

  Future<void> _showCharacterSharePreview(
      BuildContext sourceButtonContext,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    if (!widget.character.isPublic) {
      ToastUtils.showCenterToast(
        context,
        l10n.characterProfilePrivateShareUnavailable,
        isError: true,
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final screenWidth = MediaQuery.sizeOf(
          dialogContext,
        ).width;

        final double previewWidth = screenWidth > 440 ? 360 : screenWidth - 48;

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: _buildCharacterShareCard(),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: previewWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },
                          child: Text(
                            l10n.editProfileCancel,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Builder(
                          builder: (shareButtonContext) {
                            return ElevatedButton.icon(
                              onPressed: () {
                                _captureAndShareCharacterCard(
                                  shareButtonContext,
                                );
                              },
                              icon: Transform.flip(
                                flipX: true,
                                child: const Icon(
                                  Icons.reply_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              label:  Text(
                                l10n.characterProfileShareCard,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFF8E63A2,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _prepareCharacterShareImage() async {
    final String imageUrl = widget.character.bannerImagePath.trim().isNotEmpty
        ? widget.character.bannerImagePath.trim()
        : widget.character.avatarPath.trim();

    if (imageUrl.isEmpty || !mounted) return;

    try {
      await precacheImage(
        CachedNetworkImageProvider(imageUrl),
        context,
      );
    } catch (error) {
      debugPrint('⚠️ 分享卡片圖片預載失敗：$error');
    }
  }

  // ==========================================
  // 🫂 總裁新增：好友/聯絡人系統邏輯
  // ==========================================

  // ✨ 1. 檢查是否已經是好友
  Future<void> _checkIfFriend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 💡 總裁提醒：請將 'added_friends' 換成妳實際存好友的集合名稱！
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('friends') // 👈 這裡！
          .doc(widget.character.id)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _isFriend = true; // 已經加過了，點亮按鈕！
        });
      }
    } catch (e) {
      print("檢查好友狀態失敗: $e");
    }
  }

  // ✨ 2. 按鈕點擊：切換好友狀態 (新增/移除)
  Future<void> _toggleFriendStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    if (user == null) return;

    // 啟動按鈕的轉圈圈動畫，防止玩家連點
    setState(() => _isFriendLoading = true);

    try {
      // 💡 總裁提醒：一樣要注意這裡的集合名稱！
      final friendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('friends') // 👈 這裡！
          .doc(widget.character.id);

      if (_isFriend) {
        // ❌ 原本是好友 -> 執行刪除
        try {
          // 1. 執行刪除指令
          await friendRef.delete();

          // 2. 只有在刪除成功後，才更新 UI 與提示
          if (mounted) {
            setState(() {
              _isFriend = false; // 按鈕變回「加好友」狀態
            });

            ToastUtils.showCenterToast(
              context,
              l10n.snackbar_friend_removed(
                  widget.character.name), // 確保妳的 l10n 檔案裡有定義這個 Key
              customIcon: Icons.person_remove_rounded,
            );
          }
        } catch (e) {
          // 3. 🛡️ 防禦工事：如果資料庫刪除失敗，優雅地報錯，不讓玩家誤以為刪成功了
          print("❌ 刪除好友失敗: $e");
          if (mounted) {
            ToastUtils.showCenterToast(
              context,
              l10n.common_delete_network_failed, // 這裡可以用 l10n.common_delete_failed
              isError: true,
            );
          }
        }
      } else {
        // 💖 原本不是好友 -> 執行新增
        await friendRef.set({
          'characterId': widget.character.id,
          'characterName': widget.character.name, // 順便存個名字，以後列表好讀取
          'addedAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          setState(() => _isFriend = true);
          ToastUtils.showCenterToast(
            context,
            l10n.snackbar_friend_added(widget.character.name),
            customIcon: Icons.person_add_alt_1_rounded,
          );
        }
      }
    } catch (e) {
      print("切換好友狀態失敗: $e");
      if (mounted) {
        ToastUtils.showCenterToast(context, l10n.common_operation_failed_retry,
            isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isFriendLoading = false); // 關閉轉圈圈
      }
    }
  }

  Future<void> _migrateLegacyAffection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String userId = user.uid;
    final String charId = widget.character.id;

    // 1. 先看總帳是不是已經有分數了
    final globalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('characters')
        .doc(charId);

    final globalDoc = await globalRef.get();
    if (!mounted) return;
    // 💡 如果已經有分數（大於 0），我們就不動它
    if (globalDoc.exists && (globalDoc.data()?['affection'] ?? 0) > 0) return;

    // 2. 去所有房間找這個角色的最高分
    final sessionsSnapshot = await FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('chat_sessions')
        .where('userId', isEqualTo: userId)
        .where('characterId', isEqualTo: charId)
        .get();
    if (!mounted) return;
    if (sessionsSnapshot.docs.isNotEmpty) {
      // 找出所有房間裡最高的那個分數
      int highest = 0;
      for (var doc in sessionsSnapshot.docs) {
        int score = doc.data()['friendshipScore'] ?? 0;
        if (score > highest) highest = score;
      }

      if (highest > 0) {
        // 3. 領出來，存進總帳！
        await globalRef.set({
          'affection': highest,
          'characterName': widget.character.name,
          'lastUpdate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        print("✅ 成功幫總裁追回舊好感度：$highest 分！");
      }
    }
  }

  Future<void> _autoRecordEncounter() async {
    try {
      await CharacterService.recordEncounter({
        'id': widget.character.id,
        'name': widget.character.name,
        'avatar': widget.character.galleryPaths.isNotEmpty
            ? widget.character.galleryPaths[0]
            : '',
        'desc': widget.character.background,
      });
    } catch (e) {
      print("紀錄足跡失敗: $e");
    }
  }

  Future<void> _translateSingleEcho(String docId, String content) async {
    final l10n = AppLocalizations.of(context)!;
    // 1. 如果已經翻譯過了，就不用再翻，直接清除翻譯（點第二次可以切換回原文）
    if (_translatedEchoes.containsKey(docId)) {
      setState(() => _translatedEchoes.remove(docId));
      return;
    }

    // 2. 顯示讀取中 🦋
    setState(() => _translatingEchoIds.add(docId));

    try {
      print("🌐 正在為翻譯時空迴音: $content");

      // 🚀 這裡呼叫妳的 Grok / OpenAI API
      // 為了示範，我們先寫一個模擬翻譯，總裁之後要把這裡換成真正的 API 呼叫
      await Future.delayed(const Duration(milliseconds: 800)); // 模擬網路延遲
      // 假設這是 AI 回傳的感性譯文
      String translatedText =
      l10n.chat_translation_prefix(content); // 3. 更新翻譯結果
      if (mounted) {
        setState(() {
          _translatedEchoes[docId] = translatedText;
        });
      }
    } catch (e) {
      debugPrint("🔴 迴音翻譯失敗: $e");
    } finally {
      // 4. 停止讀取
      if (mounted) {
        setState(() => _translatingEchoIds.remove(docId));
      }
    }
  }

  void _handleLike() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    // 防止連點造成重複寫入
    if (_isTogglingLike) return;

    if (_isCreator) {
      ToastUtils.showCenterToast(
        context,
        l10n.like_own_char_warning,
        customIcon: Icons.front_hand_rounded,
      );
      return;
    }

    final bool wasLiked = _hasLiked;

    setState(() {
      _isTogglingLike = true;
      _hasLiked = !wasLiked;
    });

    try {
      final charRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id);

      final likerRef = charRef.collection('likers').doc(user.uid);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final playerName = userDoc.data()?['nickname'] ??
          user.displayName ??
          l10n.chat_mysterious_player;

      // 固定通知 ID：同一個玩家對同一個角色按讚，只會有一封通知
      final notificationId =
          'character_like_${widget.character.id}_${user.uid}';

      final notificationRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.character.createdBy)
          .collection('mailbox')
          .doc(notificationId);

      final bool nowLiked = await FirebaseFirestore.instance
          .runTransaction<bool>((transaction) async {
        final likerSnapshot = await transaction.get(likerRef);

        final bool alreadyLikedInDb = likerSnapshot.exists;

        if (!alreadyLikedInDb) {
          transaction.update(charRef, {
            'likesCount': FieldValue.increment(1),
          });

          transaction.set(likerRef, {
            'timestamp': FieldValue.serverTimestamp(),
          });

          transaction.set(
            notificationRef,
            {
              'type': 'like',
              'title': l10n.char_exclusive_guardian,
              'body': l10n.mailbox_like_body(
                playerName,
                widget.character.name,
              ),
              'fromUserId': user.uid,
              'fromName': playerName,
              'characterId': widget.character.id,
              'isRead': false,
              'createdAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true),
          );

          return true;
        } else {
          transaction.update(charRef, {
            'likesCount': FieldValue.increment(-1),
          });

          transaction.delete(likerRef);

          return false;
        }
      });

      if (!mounted) return;

      setState(() {
        _hasLiked = nowLiked;
      });

      ToastUtils.showCenterToast(
        context,
        nowLiked ? l10n.like_success_msg : l10n.unlike_success_msg,
        customIcon: nowLiked ? Icons.favorite : Icons.favorite_border,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasLiked = wasLiked;
        });
      }

      debugPrint("按讚切換失敗: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingLike = false;
        });
      }
    }
  }

  void _navigateToCreatorProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatorProfilePage(
          creatorId: widget.character.createdBy,
          creatorName: widget.character.creatorName,
        ),
      ),
    );
  }

  void _handleFollow() async {
    // 🔒 防禦機制：如果已經關注了，直接擋掉，不要再寄信！
    if (_isFollowing) return;

    // ⚡ 瞬間反應：先讓畫面的按鈕變灰打勾，玩家體驗最好！
    setState(() {
      _isFollowing = true;
    });
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    String playerName = _playerNickname;
    String creatorId = widget.character.createdBy;
    // 寄信給創作者
    await FirebaseFirestore.instance
        .collection('users')
        .doc(creatorId)
        .collection('mailbox')
        .add({
      'type': 'follow', // 🦋 只存代碼，讓信箱去翻譯
      'fromName': _playerNickname, // 🦋 把找不到的 myName 換成 _playerNickname
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    if (mounted) {
      // ✨ 總裁級：追蹤創作者的專屬提示，讓建立連結的瞬間充滿質感！
      ToastUtils.showCenterToast(
        context,
        l10n.followed_creator_msg(widget.character.creatorName),
        customIcon:
        Icons.person_add_alt_1_rounded, // 💡 用帶有「+」號的人物圖示，完美傳達「加入追蹤」的意象！
      );
    }
  }

  void _showDislikeDialog() {
    final l10n = AppLocalizations.of(context)!;

    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          // 💡 注意：這裡的 const 被我拆到裡面的 Icon 和 SizedBox 去了
          title: Row(children: [
            const Icon(Icons.sentiment_very_dissatisfied,
                color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(l10n.dislike_dialog_title) // ✨ 替換：不太喜歡這個角色？
          ]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.dislike_dialog_subtitle, // ✨ 替換：請偷偷告訴我們原因...
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: l10n.dislike_hint, // ✨ 替換：設定太無聊、圖片不適合...
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)))),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancelButton, // 這個總裁原本就寫得很完美了！
                    style: const TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white),
              onPressed: () async {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) return;
                Navigator.pop(context);
                if (mounted) {
                  // ✨ 總裁級：低調且專業的「收到回饋」確認！
                  ToastUtils.showCenterToast(
                    context,
                    l10n.dislike_thanks,
                    customIcon: Icons
                        .feedback_outlined, // 💡 總裁細節：用「意見回饋」的圖示，比直接放一個倒讚 (thumb_down) 讓人感覺更舒服且被尊重！
                  );
                }
                await FirebaseFirestore.instance
                    .collection('admin_feedback')
                    .add({
                  'type': 'character_dislike',
                  'characterId': widget.character.id,
                  'reporterId':
                  FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
                  'reason': reason,
                  'timestamp': FieldValue.serverTimestamp(),
                });
              },
              child: Text(l10n.dislike_submit), // ✨ 替換：悄悄送出
            ),
          ],
        );
      },
    );
  }

  // 📢 檢舉時空迴響 (包含原因選擇)
  Future<void> _reportEcho(String echoId) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1. 準備常見的檢舉選項
    final List<String> reportOptions = [
      l10n.report_opt_1,
      l10n.report_opt_2,
      l10n.report_opt_3,
      l10n.report_opt_4,
      l10n.report_opt_5
    ];

    // 2. 跳出帶有單選按鈕的彈窗
    String? selectedReason = await showDialog<String>(
      context: context,
      builder: (BuildContext c) {
        String? tempReason; // 暫存玩家選中的原因
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.report_title),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.report_subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 12),
                    // 產生單選列表
                    ...reportOptions.map((reason) {
                      return RadioListTile<String>(
                        title:
                        Text(reason, style: const TextStyle(fontSize: 14)),
                        value: reason,
                        groupValue: tempReason,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() => tempReason = value);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(c, null),
                    child: Text(l10n.cancel,
                        style: TextStyle(color: Colors.grey))),
                TextButton(
                  // 🌟 如果沒選原因，按鈕就會反灰不能按
                  onPressed: tempReason == null
                      ? null
                      : () => Navigator.pop(c, tempReason),
                  child: Text(l10n.report_confirm,
                      style: TextStyle(
                          color: tempReason == null
                              ? Colors.grey[300]
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );

    // 如果玩家按了取消，或是沒選原因就關掉彈窗，就中斷執行
    if (selectedReason == null) return;

    // 3. 寫入檢舉紀錄到 Firebase
    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('echoes')
          .doc(echoId)
          .update({
        'reportCount': FieldValue.increment(1),
        'reporters': FieldValue.arrayUnion([user.uid]),
        // 🌟 新增：把玩家選的原因也存進陣列裡！
        'reportReasons': FieldValue.arrayUnion(
            ['${user.uid.substring(0, 5)}: $selectedReason']),
      });

      if (mounted) {
        // ✨ 總裁級：檢舉成功的安心回饋，讓玩家知道我們有在保護社群！
        ToastUtils.showCenterToast(
          context,
          l10n.report_success,
          customIcon: Icons.shield_outlined, // 💡 總裁細節：使用「安全盾牌」圖示，傳遞滿滿的保護與安心感！
        );
      }
    } catch (e) {
      print("檢舉失敗: $e");
      if (mounted) {
        // ✨ 總裁級：檢舉失敗的輕量錯誤提示，用紅驚嘆號俐落告知！
        ToastUtils.showCenterToast(
          context,
          l10n.report_failed,
          isError: true, // 💡 總裁細節：開啟錯誤狀態，讓系統自動帶上紅色的小驚嘆號
        );
      }
    }
  }

  // ✨ 專屬的「刪除記憶碎片」功能與確認彈窗
  Future<void> _deleteLore(String loreId) async {
    // 🛡️ 總裁防呆機制：彈出警告視窗，防止手滑
    final l10n = AppLocalizations.of(context)!;
    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.lore_delete_title),
          content: Text(l10n.lore_delete_content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // 點取消回傳 false
              child: Text(l10n.lore_delete_cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pop(context, true), // 點確定回傳 true
              child: Text(l10n.lore_delete_confirm,
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ) ??
        false; // 如果點擊對話框外面關閉，預設也是 false
    // 如果玩家沒有點擊確定，就直接終止動作
    if (!confirm) return;
    try {
      // 🌟 瞄準目標，發射刪除指令！
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character!.id) // 指向這個角色
          .collection('lores')
          .doc(loreId) // 🎯 瞄準這個碎片
          .delete();

      if (mounted) {
        // ✨ 總裁級：刪除記憶成功的優雅提示，輕盈且不留痕跡
        ToastUtils.showCenterToast(
          context,
          l10n.lore_delete_success,
          customIcon:
          Icons.auto_delete_outlined, // 💡 使用帶有科技感或魔法感的刪除圖示，非常符合「清除記憶」的意境！
        );
      }
    } catch (e) {
      print("刪除記憶失敗: $e");
      if (mounted) {
        // ✨ 總裁級：刪除失敗的輕量錯誤提示，用紅驚嘆號俐落接住例外狀況！
        ToastUtils.showCenterToast(
          context,
          l10n.common_delete_failed_with_err(e.toString()),
          isError: true,
        );
      }
    }
  }

  // ✨ 新增記憶碎片：改為獨立頁面
  Future<void> _showAddLoreDialog(BuildContext context, ThemeData theme) async {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final teaserController = TextEditingController();
    final contentController = TextEditingController();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (pageContext) {
          bool isHidden = false;
          bool isSaving = false;

          return StatefulBuilder(
            builder: (context, setPageState) {
              final pageTheme = Theme.of(context);
              final primary = pageTheme.colorScheme.primary;
              final onSurface = pageTheme.colorScheme.onSurface;

              InputDecoration fieldDecoration({
                required String label,
                required String hint,
              }) {
                return InputDecoration(
                  labelText: label,
                  hintText: hint,
                  labelStyle: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                  hintStyle: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.30),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: primary.withValues(alpha: 0.018),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: primary.withValues(alpha: 0.18),
                      width: 0.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: primary.withValues(alpha: 0.55),
                      width: 1.1,
                    ),
                  ),
                );
              }

              Future<void> saveLore() async {
                if (isSaving) return;

                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ToastUtils.showCenterToast(
                    context,
                    l10n.lore_empty_error,
                    isError: true,
                  );
                  return;
                }

                setPageState(() => isSaving = true);

                try {
                  await FirebaseFirestore.instance
                      .collection('artifacts')
                      .doc(AppConfig.appId)
                      .collection('public_characters')
                      .doc(widget.character.id)
                      .collection('lores')
                      .add({
                    'title': title,
                    'teaser': teaserController.text.trim(),
                    'content': content,
                    'isHidden': isHidden,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  if (!context.mounted) return;

                  ToastUtils.showCenterToast(
                    context,
                    l10n.lore_add_success,
                    customIcon: Icons.library_add_check_rounded,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint('新增碎片失敗: $e');
                  if (context.mounted) {
                    ToastUtils.showCenterToast(
                      context,
                      l10n.common_add_failed,
                      isError: true,
                    );
                  }
                } finally {
                  if (context.mounted) {
                    setPageState(() => isSaving = false);
                  }
                }
              }

              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: pageTheme.scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  title: Text(
                    l10n.lore_add_title,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    Positioned(
                      right: -18,
                      top: 6,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.07,
                          child: Image.asset(
                            'assets/images/language/language_top_right_botanical.png',
                            width: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                            const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: titleController,
                              style: GoogleFonts.notoSerifTc(fontSize: 15),
                              decoration: fieldDecoration(
                                label: l10n.lore_title_label,
                                hint: l10n.lore_title_hint,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: teaserController,
                              maxLines: 3,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 14,
                                height: 1.65,
                              ),
                              decoration: fieldDecoration(
                                label: l10n.lore_teaser_label,
                                hint: l10n.lore_teaser_hint,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: contentController,
                              minLines: 8,
                              maxLines: 14,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 14,
                                height: 1.75,
                              ),
                              decoration: fieldDecoration(
                                label: l10n.lore_content_label,
                                hint: l10n.lore_content_hint,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.018),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: primary.withValues(alpha: 0.16),
                                  width: 0.9,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.lore_lock_label,
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          l10n.lore_lock_desc,
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 11.5,
                                            height: 1.5,
                                            color: onSurface.withValues(
                                              alpha: 0.46,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: isHidden,
                                    activeColor: primary,
                                    side: BorderSide(
                                      color: onSurface.withValues(alpha: 0.38),
                                    ),
                                    onChanged: (value) {
                                      setPageState(() {
                                        isHidden = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isSaving ? null : saveLore,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: primary,
                                  foregroundColor:
                                  pageTheme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  textStyle: GoogleFonts.notoSerifTc(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: isSaving
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(l10n.lore_publish),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🗑️ 刪除時空迴響 (作者本人或管理員)
  Future<void> _deleteEcho(DocumentSnapshot doc) async {
    final l10n = AppLocalizations.of(context)!;
    // 1. 跳出確認視窗防手滑
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.echo_delete_title),
        content: Text(l10n.echo_delete_content),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text(l10n.echo_keep)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.delete_btn,
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. 執行刪除動作
    try {
      await doc.reference.delete(); // 直接對著這份文件的地址按下刪除鍵
      if (mounted) {
        // ✨ 總裁級：清除回音成功的優雅提示，輕盈地拂去痕跡
        ToastUtils.showCenterToast(
          context,
          l10n.echo_clear_success,
          customIcon: Icons
              .delete_sweep_rounded, // 💡 總裁細節：用「輕輕掃去」的圖示，比生硬的垃圾桶更符合 Echo 消散的詩意！
        );
      }
    } catch (e) {
      print("${l10n.delete_failed_msg}: $e");
      if (mounted) {
        // ✨ 總裁級：網路異常導致刪除失敗的輕量錯誤提示
        ToastUtils.showCenterToast(
          context,
          l10n.delete_failed_network,
          isError: true, // 💡 直接帶出小紅驚嘆號，俐落告知玩家網路卡住了
        );
      }
    }
  }

  // ✨ 新增時空迴音：改成選擇卡面縮圖
  void _showAddEchoDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final echoesRef = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters')
        .doc(widget.character.id)
        .collection('echoes');

    final myEchoes = await echoesRef.where('userId', isEqualTo: user.uid).get();
    if (myEchoes.docs.length >= 3 && mounted) {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.echo_energy_full_title),
          content: Text(l10n.echo_energy_full_content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text(l10n.common_got_it),
            ),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;

    String selectedCard = 'butterfly';
    final textController = TextEditingController();

    const echoCards = <Map<String, String>>[
      {
        'id': 'butterfly',
        'asset': 'assets/images/echo/echo_card_butterfly.png',
      },
      {
        'id': 'flower',
        'asset': 'assets/images/echo/echo_card_flower.png',
      },
      {
        'id': 'starry',
        'asset': 'assets/images/echo/echo_card_starry.png',
      },
      {
        'id': 'planet',
        'asset': 'assets/images/echo/echo_card_planet.png',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final primary = theme.colorScheme.primary;

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(26),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.echo_write_title,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.echo_write_subtitle,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.42),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: textController,
                          minLines: 3,
                          maxLines: 4,
                          maxLength: 100,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 14,
                            height: 1.65,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.echo_hint,
                            hintStyle: GoogleFonts.notoSerifTc(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.28),
                            ),
                            filled: true,
                            fillColor: primary.withValues(alpha: 0.018),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: primary.withValues(alpha: 0.18),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(
                                color: primary.withValues(alpha: 0.55),
                                width: 1.1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.echo_theme_label,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3.15,
                          ),
                          itemCount: echoCards.length,
                          itemBuilder: (context, index) {
                            final card = echoCards[index];
                            final isSelected = selectedCard == card['id'];

                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedCard = card['id']!;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                padding: const EdgeInsets.all(2.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                    color: isSelected
                                        ? primary
                                        : primary.withValues(alpha: 0.10),
                                    width: isSelected ? 1.8 : 0.8,
                                  ),
                                  color: isSelected
                                      ? primary.withValues(alpha: 0.035)
                                      : Colors.transparent,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    card['asset']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: primary.withValues(alpha: 0.035),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              textStyle: GoogleFonts.notoSerifTc(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () async {
                              final content = textController.text.trim();
                              if (content.isEmpty) return;

                              Navigator.pop(context);

                              await echoesRef.add({
                                'userId': user.uid,
                                'createdBy': user.uid,
                                'authorId': user.uid,
                                'content': content,
                                'cardStyle': selectedCard,
                                'theme': selectedCard,
                                'timestamp': FieldValue.serverTimestamp(),
                              });

                              try {
                                await FirebaseFirestore.instance
                                    .collection('artifacts')
                                    .doc(AppConfig.appId)
                                    .collection('public_characters')
                                    .doc(widget.character.id)
                                    .update({
                                  'likesCount': FieldValue.increment(10),
                                });
                              } catch (_) {}
                            },
                            child: Text(l10n.echo_publish_btn),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _echoCardAsset(String rawStyle) {
    switch (rawStyle) {
      case 'flower':
      case 'sprout':
        return 'assets/images/echo/echo_card_flower.png';
      case 'starry':
      case 'star':
        return 'assets/images/echo/echo_card_starry.png';
      case 'planet':
        return 'assets/images/echo/echo_card_planet.png';
      case 'butterfly':
      default:
        return 'assets/images/echo/echo_card_butterfly.png';
    }
  }

  Widget _buildThemeSelector(String themeKey, Widget iconWidget, String label,
      String currentTheme, VoidCallback onTap) {
    final isSelected = currentTheme == themeKey;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
            ),
            child: iconWidget, // ✨ 直接塞入 Widget，讓它可以接收各種形式的圖示
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildHeaderPhotoCarousel({
    required bool isDesktop,
  }) {
    final List<String> photoUrls = [];

    // 優先使用完整 gallery，因為裡面有正式照片順序。
    if (widget.character.gallery != null) {
      for (final photo in widget.character.gallery!) {
        final String url = photo.imageUrl.trim();

        if (url.isNotEmpty && !photoUrls.contains(url)) {
          photoUrls.add(url);
        }
      }
    }

    // gallery 沒資料時，用 galleryPaths 保底。
    for (final path in widget.character.galleryPaths) {
      final String url = path.trim();

      if (url.isNotEmpty && !photoUrls.contains(url)) {
        photoUrls.add(url);
      }
    }

    // 最後才用 avatarPath 保底。
    final String avatarUrl = (widget.character.avatarPath ?? '').trim();

    if (avatarUrl.isNotEmpty && !photoUrls.contains(avatarUrl)) {
      photoUrls.insert(0, avatarUrl);
    }

    if (photoUrls.isEmpty) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Icon(
          Icons.person,
          size: 100,
          color: Colors.grey,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: photoUrls.length,
          onPageChanged: (index) {
            if (!mounted) return;

            setState(() {
              _currentHeaderPhotoIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final String imageUrl = photoUrls[index];

            // 第一張公開，第二張以後鎖定。
            final bool isLocked = index > 0;

            return _buildHeaderPhotoItem(
              imageUrl: imageUrl,
              isLocked: isLocked,
              isDesktop: isDesktop,
              photoIndex: index,
            );
          },
        ),

        // 多張照片才顯示頁碼圓點。
        if (photoUrls.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                photoUrls.length,
                    (index) {
                  final bool selected = index == _currentHeaderPhotoIndex;

                  return AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    width: selected ? 18 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(
                        alpha: 0.45,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                },
              ),
            ),
          ),

        // 照片張數提示。
        if (photoUrls.length > 1)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: 0.42,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentHeaderPhotoIndex + 1}'
                    ' / ${photoUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderPhotoItem({
    required String imageUrl,
    required bool isLocked,
    required bool isDesktop,
    required int photoIndex,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      // 手機填滿整個畫面；網頁保留完整圖片比例。
      fit: isDesktop ? BoxFit.contain : BoxFit.cover,

      // 手機稍微偏上，優先保留人物臉部。
      alignment: isDesktop ? Alignment.center : const Alignment(0, -0.18),

      memCacheWidth: isDesktop ? 1400 : 720,

      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => const ColoredBox(
        color: Colors.black,
      ),

      errorWidget: (
          context,
          url,
          error,
          ) {
        return const ColoredBox(
          color: Colors.black,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 80,
              color: Colors.grey,
            ),
          ),
        );
      },
    );

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isDesktop) ...[
            // 網頁版背景鋪滿並模糊，
            // 中間主圖使用 contain，避免人物被裁切。
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              memCacheWidth: 1600,
              errorWidget: (
                  context,
                  url,
                  error,
                  ) =>
                  Container(
                    color: Colors.black,
                  ),
            ),

            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 16,
                sigmaY: 16,
              ),
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.34,
                ),
              ),
            ),

            Center(child: image),
          ] else
          // 手機版直接滿版。
            image,

          // 圖片底部柔霧淡出：讓角色照片像融進下方紙張內容，
          // 不再是圖片與 TabBar 之間的硬切線。
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: isDesktop ? 92 : 112,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                      theme.scaffoldBackgroundColor.withValues(alpha: 0.14),
                      theme.scaffoldBackgroundColor.withValues(alpha: 0.48),
                      theme.scaffoldBackgroundColor.withValues(alpha: 0.82),
                      theme.scaffoldBackgroundColor,
                    ],
                    stops: const [
                      0.00,
                      0.24,
                      0.52,
                      0.78,
                      1.00,
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLocked) ...[
            // 鎖定照片模糊。
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 18,
                    sigmaY: 18,
                  ),
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.28,
                    ),
                  ),
                ),
              ),
            ),

            // 中央鎖頭與提示。
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.48,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                    const SizedBox(height: 9),
                    Text(
                      l10n.exclusive_photo_number(photoIndex + 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      l10n.unlock_after_affection_increase,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: 0.75,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    // ✨ 1. 取得螢幕寬度並判斷是否為大螢幕
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    // ✨ 2. 把原本的 Stack (包含滾動內容與底部按鈕) 提取出來，準備進行寬度限制
    Widget mainContent = Stack(
      children: [
        // 📜 底層：可以滾動的角色資訊 (NestedScrollView)
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                backgroundColor:
                theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha: 0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.38),
                      child: IconButton(
                        tooltip: _isCharacterBookmarked ? '取消收藏' : '收藏角色',
                        onPressed: _isCharacterBookmarkLoading
                            ? null
                            : _toggleCharacterBookmark,
                        icon: _isCharacterBookmarkLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            color: Colors.white,
                          ),
                        )
                            : Icon(
                          _isCharacterBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: _isCharacterBookmarked
                              ? theme.colorScheme.primary
                              : Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  if (widget.character.isPublic)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        4,
                        8,
                        0,
                        8,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(
                          alpha: 0.4,
                        ),
                        child: Builder(
                          builder: (shareButtonContext) {
                            return IconButton(
                              tooltip: l10n.characterProfileShareCharacter,
                              icon: Transform.flip(
                                flipX: true,
                                child: const Icon(
                                  Icons.reply_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              onPressed: () async {
                                await _prepareCharacterShareImage();

                                if (!mounted) return;

                                await _showCharacterSharePreview(
                                  shareButtonContext,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                  // 原本的「⋮」選單
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.4),
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (value) async {
                          switch (value) {
                            case 'report':
                              await CharacterReportService.showReportDialog(
                                context: context,
                                character: widget.character,
                                source: 'character_profile',
                              );
                              break;

                            case 'block':
                              final bool blocked =
                              await CharacterBlockService.showBlockDialog(
                                context: context,
                                character: widget.character,
                              );

                              if (!mounted || !blocked) {
                                return;
                              }

                              // 封鎖成功後直接離開角色頁
                              Navigator.pop(
                                context,
                                true,
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8),
                                Text(l10n.characterProfileReportCharacter),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'block',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.block_char,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeaderPhotoCarousel(
                    isDesktop: isDesktop,
                  ),
                ),
              ),
              // ✨ 吸頂的三個頁籤 TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: theme.colorScheme.primary,
                    indicatorWeight: 2.2,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor:
                    theme.colorScheme.onSurface.withValues(alpha: 0.42),
                    labelStyle: GoogleFonts.notoSerifTc(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: GoogleFonts.notoSerifTc(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.person_outline_rounded, size: 23),
                        text: l10n.tab_private_profile,
                      ),
                      Tab(
                        icon: const Icon(Icons.auto_stories_outlined, size: 23),
                        text: l10n.characterProfileCharacterIntro,
                      ),
                      Tab(
                        icon: const Icon(Icons.public_rounded, size: 23),
                        text: l10n.tab_time_echoes,
                      ),
                    ],
                  ),
                  theme.scaffoldBackgroundColor, // 吸頂時的背景色
                ),
              ),
            ];
          },
          // ✨ 下方的三個頁面內容
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTabProfile(theme), // 頁籤 1
              _buildCharacterIntroTab(theme), // 頁籤 2：角色簡介
              _buildTabEchoes(theme), // 頁籤 3
            ],
          ),
        ),

        // 🔘 頂層：底部固定按鈕區 (覆蓋在滾動視窗上方)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor.withValues(alpha: 0.96),
                  theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.62, 1.0],
              ),
            ),
            child: Row(
              children: [
                // 左：閒聊
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        backgroundColor:
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withValues(alpha: 0.62),
                          width: 1.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: GoogleFonts.notoSerifTc(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        if (_isNavigating) return;
                        setState(() {
                          _isNavigating = true;
                        });
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  character: widget.character,
                                  chatMode: "gemini", // 維持妳的 0元 模式
                                  selectedLanguage:
                                  l10n.ai_chat_language_code,
                                  forceNewRoom: true,
                                  initialText: widget
                                      .character.storyModeFirstLine ??
                                      l10n.default_chat_initial, // ✨ 補上第一句話
                                  characterId: widget.character.id,
                                )));
                        if (mounted) {
                          setState(() {
                            _isNavigating = false;
                          });
                        }
                      },
                      child: Text(l10n.chat_free_btn),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 右：開始劇情
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 2,
                        shadowColor:
                        theme.colorScheme.primary.withValues(alpha: 0.18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: GoogleFonts.notoSerifTc(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () async {
                        if (_isNavigating) return;
                        setState(() {
                          _isNavigating = true;
                        });
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  character: widget.character,
                                  chatMode: "daily",
                                  selectedLanguage: l10n.ai_chat_language,
                                  forceNewRoom: true,
                                  characterId: widget.character.id,
                                )));
                        if (mounted) {
                          setState(() {
                            _isNavigating = false;
                          });
                        }
                      },
                      child: Text(l10n.start_story_btn),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // 角色檔案本身就包含 Showcase 元件，因此在頁面最外層
    // 自己註冊 ShowCaseWidget。這樣不管從邂逅、推薦、搜尋、
    // 個人主頁或其他入口進來，都不會再依賴上一頁是否有包 Showcase。
    return ShowCaseWidget(
      builder: (showCaseContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: themeNotifier.currentBackground, // 保留您精美的全螢幕背景
            child: isDesktop
                ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: mainContent,
              ),
            )
                : mainContent,
          ),
        );
      },
    );
  }

  // ==========================================
  // 🗂️ 頁籤 1：私密檔案
  // ==========================================
  Widget _buildTabProfile(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final String currentLang = Localizations.localeOf(context).languageCode;

    final shared = widget.character.translations?[currentLang];

    final displayLikes = shared?['likes'] ?? widget.character.likes;
    final displayDislikes = shared?['dislikes'] ?? widget.character.dislikes;
    final displayTags = _translatedTags ??
        (shared?['personalityTags'] as List?)?.cast<String>() ??
        widget.character.personalityTags;

    final displayStory = widget.character.initialStory.trim();

    final bool showTranslateBtn =
        (currentLang != (widget.character.contentLanguage ?? 'zh')) &&
            (_translatedBackground == null && shared?['background'] == null);

    final textColor = theme.colorScheme.onSurface;

    return Stack(
      children: [
        Positioned(
          left: -26,
          top: 210,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/store/store_corner_left.png',
                width: 150,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        Positioned(
          right: 18,
          top: 18,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/profile/about_botanical.png',
                width: 74,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 150),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    widget.character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      color: textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              l10n.char_age_occupation(
                widget.character.age.toString(),
                widget.character.occupation,
              ),
              style: GoogleFonts.notoSerifTc(
                color: theme.colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),

            // 喜歡 / 不喜歡 / 好友：做成輕量資訊列，不用三顆厚膠囊。
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _handleLike,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Icon(
                            _hasLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 23,
                            color: _hasLiked
                                ? theme.colorScheme.primary
                                : textColor.withValues(alpha: 0.38),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.like_label,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12.5,
                              color: _hasLiked
                                  ? theme.colorScheme.primary
                                  : textColor.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 34,
                  color: theme.dividerColor.withValues(alpha: 0.35),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _showDislikeDialog,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            size: 22,
                            color: textColor.withValues(alpha: 0.38),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.dislike_label,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12.5,
                              color: textColor.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 34,
                  color: theme.dividerColor.withValues(alpha: 0.35),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _isFriendLoading ? null : _toggleFriendStatus,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          _isFriendLoading
                              ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.7,
                              color: theme.colorScheme.primary,
                            ),
                          )
                              : Icon(
                            _isFriend
                                ? Icons.check_rounded
                                : Icons.person_add_alt_1_outlined,
                            size: 23,
                            color: _isFriend
                                ? theme.colorScheme.primary
                                : textColor.withValues(alpha: 0.38),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.tab_friends,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12.5,
                              color: _isFriend
                                  ? theme.colorScheme.primary
                                  : textColor.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (showTranslateBtn) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _isTranslating
                      ? null
                      : () => _translateProfile(currentLang),
                  icon: _isTranslating
                      ? const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.translate_rounded, size: 15),
                  label: Text(
                    _isTranslating
                        ? l10n.translating_status
                        : l10n.translate_profile_btn,
                    style: GoogleFonts.notoSerifTc(fontSize: 11.5),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            if (displayTags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: displayTags.toSet().map((tag) {
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.025),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                        theme.colorScheme.primary.withValues(alpha: 0.24),
                        width: 0.9,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11.5,
                        color: theme.colorScheme.primary.withValues(alpha: 0.82),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],

            if (widget.character.birthday.isNotEmpty ||
                widget.character.height.isNotEmpty)
              Row(
                children: [
                  if (widget.character.birthday.isNotEmpty) ...[
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 17,
                      color: textColor.withValues(alpha: 0.38),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${l10n.charBirthdayLabel}  ${widget.character.birthday}',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12.5,
                        color: textColor.withValues(alpha: 0.56),
                      ),
                    ),
                  ],
                  if (widget.character.birthday.isNotEmpty &&
                      widget.character.height.isNotEmpty) ...[
                    const SizedBox(width: 14),
                    Container(
                      width: 1,
                      height: 16,
                      color: theme.dividerColor.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 14),
                  ],
                  if (widget.character.height.isNotEmpty) ...[
                    Icon(
                      Icons.straighten_rounded,
                      size: 17,
                      color: textColor.withValues(alpha: 0.38),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${l10n.charHeightLabel}  ${widget.character.height}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 12.5,
                          color: textColor.withValues(alpha: 0.56),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

            if (widget.character.birthday.isNotEmpty ||
                widget.character.height.isNotEmpty)
              const SizedBox(height: 24),

            if (displayLikes.isNotEmpty || displayDislikes.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.76),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.24),
                    width: 0.9,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (displayLikes.isNotEmpty)
                      _buildLiteraryPreferenceLine(
                        theme: theme,
                        icon: Icons.favorite_border_rounded,
                        titleAndContent: l10n.char_likes(displayLikes),
                        accent: theme.colorScheme.primary,
                      ),
                    if (displayLikes.isNotEmpty && displayDislikes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          height: 1,
                          color: theme.dividerColor.withValues(alpha: 0.35),
                        ),
                      ),
                    if (displayDislikes.isNotEmpty)
                      _buildLiteraryPreferenceLine(
                        theme: theme,
                        icon: Icons.heart_broken_outlined,
                        titleAndContent: l10n.char_dislikes(displayDislikes),
                        accent: textColor.withValues(alpha: 0.58),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],

            Row(
              children: [
                Image.asset(
                  'assets/images/profile/about_botanical.png',
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                  color: theme.colorScheme.primary.withValues(alpha: 0.68),
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.auto_stories_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.background_story_title,
                    style: GoogleFonts.notoSerifTc(
                      color: textColor,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              displayStory.isEmpty ? l10n.first_meeting_empty : displayStory,
              style: GoogleFonts.notoSerifTc(
                color: textColor.withValues(alpha: 0.82),
                fontSize: 14,
                height: 1.85,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 32),

            // 原本相簿 / 好感度功能保留。
            StreamBuilder<DocumentSnapshot>(
              stream: (FirebaseAuth.instance.currentUser != null &&
                  widget.sessionId != null)
                  ? FirebaseFirestore.instance
                  .collection('artifacts')
                  .doc(AppConfig.appId)
                  .collection('chat_sessions')
                  .doc(widget.sessionId)
                  .snapshots()
                  : const Stream.empty(),
              builder: (context, snapshot) {
                int realAffection = 0;

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  if (data != null) {
                    realAffection = data['friendshipScore'] ?? 0;
                  }
                }

                return CharacterGalleryWidget(
                  characterId: widget.characterId,
                  character: widget.character,
                  currentAffection: realAffection,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLiteraryPreferenceLine({
    required ThemeData theme,
    required IconData icon,
    required String titleAndContent,
    required Color accent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              titleAndContent,
              style: GoogleFonts.notoSerifTc(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                fontSize: 13,
                height: 1.7,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
// 📖 頁籤 2：角色簡介
// ==========================================
  Widget _buildCharacterIntroTab(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final String worldSetting = widget.character.worldSetting.trim();
    final bool isLongContent = worldSetting.length > 200;

    final String displayedWorldSetting =
    isLongContent && !_isWorldSettingExpanded
        ? '${worldSetting.substring(0, 200).trim()}...'
        : worldSetting;

    return Stack(
      children: [
        Positioned(
          right: -18,
          top: 12,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                'assets/images/store/store_corner_top_right.png',
                width: 180,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 150),
          children: [
            Row(
              children: [
                Text(
                  l10n.characterProfileCharacterIntro,
                  style: GoogleFonts.notoSerifTc(
                    color: theme.colorScheme.onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            if (worldSetting.isEmpty)
              Text(
                l10n.characterProfileNoIntroduction,
                style: GoogleFonts.notoSerifTc(
                  color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.48),
                  fontSize: 14,
                  height: 1.8,
                ),
              )
            else ...[
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Text(
                  displayedWorldSetting,
                  style: GoogleFonts.notoSerifTc(
                    color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.82),
                    fontSize: 14,
                    height: 1.9,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              if (isLongContent) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 6,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isWorldSettingExpanded = !_isWorldSettingExpanded;
                      });
                    },
                    icon: Icon(
                      _isWorldSettingExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 19,
                    ),
                    label: Text(
                      _isWorldSettingExpanded
                          ? l10n.characterProfileCollapse
                          : l10n.characterProfileViewMore,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 30),
            Divider(
              color: theme.colorScheme.primary.withValues(alpha: 0.16),
              height: 1,
            ),
            const SizedBox(height: 18),

            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openLoreListPage(theme),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.74),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.22),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.tab_memory_fragments,
                        style: GoogleFonts.notoSerifTc(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openLoreListPage(ThemeData theme) async {
    final l10n = AppLocalizations.of(context)!;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (pageContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                l10n.tab_memory_fragments,
              ),
            ),
            body: SafeArea(
              child: _buildTabLore(theme),
            ),
          );
        },
      ),
    );
  }
  // ==========================================
// ✉️ 頁籤 2：記憶碎片 (Lore)
// ==========================================

  // ✨ 編輯記憶碎片：改為獨立頁面
  Future<void> _showEditLoreDialog(
      BuildContext context,
      String loreId,
      Map<String, dynamic> existingData,
      ThemeData theme,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final titleController = TextEditingController(
      text: existingData['title'] ?? '',
    );
    final teaserController = TextEditingController(
      text: existingData['teaser'] ?? '',
    );
    final contentController = TextEditingController(
      text: existingData['content'] ?? '',
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (pageContext) {
          bool isHidden = existingData['isHidden'] ?? false;
          bool isSaving = false;

          return StatefulBuilder(
            builder: (context, setPageState) {
              final pageTheme = Theme.of(context);
              final primary = pageTheme.colorScheme.primary;
              final onSurface = pageTheme.colorScheme.onSurface;

              InputDecoration fieldDecoration({
                required String label,
                required String hint,
              }) {
                return InputDecoration(
                  labelText: label,
                  hintText: hint,
                  labelStyle: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.55),
                    fontSize: 13,
                  ),
                  hintStyle: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.30),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: primary.withValues(alpha: 0.018),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: primary.withValues(alpha: 0.18),
                      width: 0.9,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: primary.withValues(alpha: 0.55),
                      width: 1.1,
                    ),
                  ),
                );
              }

              Future<void> saveChanges() async {
                if (isSaving) return;

                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ToastUtils.showCenterToast(
                    context,
                    l10n.lore_empty_error,
                    isError: true,
                  );
                  return;
                }

                setPageState(() => isSaving = true);

                try {
                  await FirebaseFirestore.instance
                      .collection('artifacts')
                      .doc(AppConfig.appId)
                      .collection('public_characters')
                      .doc(widget.character.id)
                      .collection('lores')
                      .doc(loreId)
                      .update({
                    'title': title,
                    'teaser': teaserController.text.trim(),
                    'content': content,
                    'isHidden': isHidden,
                    'updatedAt': FieldValue.serverTimestamp(),
                  });

                  if (!context.mounted) return;

                  ToastUtils.showCenterToast(
                    context,
                    l10n.lore_edit_success,
                    customIcon: Icons.task_alt_rounded,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint('更新碎片失敗: $e');

                  if (context.mounted) {
                    ToastUtils.showCenterToast(
                      context,
                      l10n.common_update_failed,
                      isError: true,
                    );
                  }
                } finally {
                  if (context.mounted) {
                    setPageState(() => isSaving = false);
                  }
                }
              }

              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: pageTheme.scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  title: Text(
                    l10n.lore_edit_title,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    Positioned(
                      right: -18,
                      top: 6,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.07,
                          child: Image.asset(
                            'assets/images/language/language_top_right_botanical.png',
                            width: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                            const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: titleController,
                              style: GoogleFonts.notoSerifTc(fontSize: 15),
                              decoration: fieldDecoration(
                                label: l10n.lore_title_label,
                                hint: l10n.lore_title_hint,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: teaserController,
                              maxLines: 3,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 14,
                                height: 1.65,
                              ),
                              decoration: fieldDecoration(
                                label: l10n.lore_teaser_label,
                                hint: l10n.lore_teaser_hint,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: contentController,
                              minLines: 8,
                              maxLines: 14,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 14,
                                height: 1.75,
                              ),
                              decoration: fieldDecoration(
                                label: l10n.lore_content_label,
                                hint: l10n.lore_content_hint,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.018),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: primary.withValues(alpha: 0.16),
                                  width: 0.9,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.lore_lock_label,
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          l10n.lore_lock_desc,
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 11.5,
                                            height: 1.5,
                                            color: onSurface.withValues(
                                              alpha: 0.46,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: isHidden,
                                    activeColor: primary,
                                    side: BorderSide(
                                      color: onSurface.withValues(alpha: 0.38),
                                    ),
                                    onChanged: (value) {
                                      setPageState(() {
                                        isHidden = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isSaving ? null : saveChanges,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: primary,
                                  foregroundColor:
                                  pageTheme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  textStyle: GoogleFonts.notoSerifTc(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: isSaving
                                    ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(l10n.social_save_changes),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- 1. 主頁籤 UI ---
  Widget _buildTabLore(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('lores')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data?.docs ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 150),
          children: [
            // 創作者專屬：撰寫碎片按鈕
            if (_isCreator) ...[
              SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () => _showAddLoreDialog(context, theme),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.26),
                      width: 0.9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: GoogleFonts.notoSerifTc(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text(l10n.lore_add_btn_limit),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 空狀態處理
            if (docs.isEmpty)
              _buildEmptyLoreState()
            else
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final bool isHidden = data['isHidden'] ?? false;
                final bool canViewDetail = _isCreator || !isHidden;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  color: isHidden
                      ? theme.disabledColor.withValues(alpha: 0.05)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.3)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    leading: isHidden
                        ? Icon(
                      Icons.lock_outline_rounded,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.34),
                      size: 25,
                    )
                        : Image.asset(
                      'assets/images/character_create/character_create_secret_note.png',
                      width: 45,
                      height: 45,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.note_alt_outlined,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      data['title'] ?? l10n.lore_unnamed,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isHidden && !_isCreator
                            ? theme.colorScheme.onSurface
                            .withValues(alpha: 0.38)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: canViewDetail
                          ? Text(
                        data['teaser'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13,
                          height: 1.5,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.55),
                        ),
                      )
                          : Text(
                        l10n.lore_sealed_msg,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 12.5,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                    trailing: _isCreator
                        ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert), // 創作者會看到三個點點
                      onSelected: (value) {
                        if (value == 'edit') {
                          // 呼叫編輯的 Dialog (記得要把舊資料 data 傳進去)
                          _showEditLoreDialog(
                              context, doc.id, data, theme);
                        } else if (value == 'delete') {
                          // 呼叫刪除功能
                          _deleteLore(doc.id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/chat/chat_msg_edit_mask.png',
                                width: 20,
                                height: 20,
                                color: theme.colorScheme.primary,
                                colorBlendMode: BlendMode.srcIn,
                              ),
                              const SizedBox(width: 8),
                              Text(l10n.char_edit_fragment),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/chat/chat_msg_delete_mask.png',
                                width: 20,
                                height: 20,
                                color: Colors.redAccent,
                                colorBlendMode: BlendMode.srcIn,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.delete_btn,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    // 如果不是創作者，有權限就顯示箭頭，沒權限就空著
                        : (canViewDetail
                        ? const Icon(Icons.arrow_forward_ios, size: 14)
                        : null),
                    onTap: canViewDetail
                        ? () => _openLoreDetailPage(
                      loreId: doc.id,
                      data: data,
                    )
                        : () => ToastUtils.showCenterToast(
                      context,
                      l10n.lore_not_open_msg,
                      customIcon: Icons.lock_outline_rounded,
                    ),
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }

// --- 2. 合併後的詳細彈窗 (支援翻譯) ---
  Future<void> _openLoreDetailPage({
    required String loreId,
    required Map<String, dynamic> data,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final translateService = LoreTranslateService();

    final String originalTitle =
    (data['title'] ?? l10n.lore_unnamed).toString();

    final String originalContent =
    (data['content'] ?? data['teaser'] ?? '').toString();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (pageContext) {
          String displayedTitle = originalTitle;
          String displayedContent = originalContent;
          bool isTranslating = false;

          return StatefulBuilder(
            builder: (context, setPageState) {
              final pageTheme = Theme.of(context);

              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    displayedTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    if (isTranslating)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    else
                      IconButton(
                        tooltip: l10n.characterProfileTranslate,
                        icon: const Icon(
                          Icons.translate_rounded,
                        ),
                        onPressed: () async {
                          setPageState(() {
                            isTranslating = true;
                          });

                          try {
                            final String currentLang = Localizations.localeOf(
                              context,
                            ).languageCode;

                            final translationResult =
                            await translateService.translateLore(
                              targetLang: currentLang,
                              title: originalTitle,
                              content: originalContent,
                            );

                            if (!context.mounted) return;

                            setPageState(() {
                              displayedTitle =
                                  translationResult['title'] ?? originalTitle;

                              displayedContent = translationResult['content'] ??
                                  originalContent;
                            });

                            await translateService.saveTranslationToFirebase(
                              appId: AppConfig.appId,
                              characterId: widget.character.id,
                              loreId: loreId,
                              lang: currentLang,
                              result: translationResult,
                            );
                          } catch (error) {
                            if (!context.mounted) return;

                            ToastUtils.showCenterToast(
                              context,
                              l10n.translate_failed(
                                error.toString(),
                              ),
                              isError: true,
                            );
                          } finally {
                            if (context.mounted) {
                              setPageState(() {
                                isTranslating = false;
                              });
                            }
                          }
                        },
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      56,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 720,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color:
                                    pageTheme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.mail_outline_rounded,
                                    color: pageTheme
                                        .colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayedTitle,
                                        style: GoogleFonts.notoSerifTc(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.35,
                                          color: pageTheme.colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        widget.character.name,
                                        style: GoogleFonts.notoSerifTc(
                                          fontSize: 13.5,
                                          color: pageTheme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Divider(
                              color:
                              pageTheme.dividerColor.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 24),
                            SelectableText(
                              displayedContent,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 15,
                                height: 1.9,
                                letterSpacing: 0.3,
                                color: pageTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.82),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

// --- 3. 輔助小元件：空狀態 ---
  Widget _buildEmptyLoreState() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.mail_outline,
                size: 60, color: Colors.grey.withValues(alpha: 0.5)),
            SizedBox(height: 16),
            Text(
                _isCreator
                    ? l10n.lore_write_first(_pronoun)
                    : l10n.char_story_expect(_pronoun),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🪐 頁籤 3：創作者與時空迴音
  // ==========================================
  Widget _buildTabEchoes(ThemeData theme) {
    final String creatorName = widget.character.creatorName;
    final String creatorId = widget.character.createdBy;
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    const String adminUid = 'B71k2kyooubYsOtIO1nkiBwyBXt2';
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('echoes')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        return Stack(
          children: [
            Positioned(
              right: -18,
              top: 80,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.085,
                  child: Image.asset(
                    'assets/images/language/language_top_right_botanical.png',
                    width: 185,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -8,
              bottom: 105,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.06,
                  child: Image.asset(
                    'assets/images/profile/about_botanical.png',
                    width: 105,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
              children: [
                // 創作者列
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color:
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.16),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(creatorId)
                              .get(),
                          builder: (context, userSnapshot) {
                            String displayCreatorName =
                                widget.character.creatorName;
                            String? photoUrl;
                            String? avatarPath;

                            if (userSnapshot.hasData &&
                                userSnapshot.data!.exists) {
                              final userData = userSnapshot.data!.data()
                              as Map<String, dynamic>;
                              displayCreatorName =
                                  userData['nickname'] ?? displayCreatorName;
                              photoUrl = userData['photoURL'] as String?;
                              avatarPath = userData['avatarPath'] as String?;
                            }

                            ImageProvider? imageProvider;

                            if (avatarPath != null && avatarPath.isNotEmpty) {
                              imageProvider = avatarPath.startsWith('http')
                                  ? CachedNetworkImageProvider(avatarPath)
                                  : AssetImage(avatarPath) as ImageProvider;
                            } else if (photoUrl != null &&
                                photoUrl.isNotEmpty) {
                              imageProvider =
                                  CachedNetworkImageProvider(photoUrl);
                            }

                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: _navigateToCreatorProfile,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.08),
                                    backgroundImage: imageProvider,
                                    child: imageProvider == null
                                        ? Icon(
                                      Icons.person_outline_rounded,
                                      color: theme.colorScheme.primary,
                                    )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.creator_label,
                                        style: GoogleFonts.notoSerifTc(
                                          fontSize: 11.5,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.42),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        displayCreatorName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.notoSerifTc(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _isFollowing
                              ? theme.colorScheme.onSurface
                              .withValues(alpha: 0.45)
                              : theme.colorScheme.primary,
                          side: BorderSide(
                            color: _isFollowing
                                ? theme.dividerColor.withValues(alpha: 0.45)
                                : theme.colorScheme.primary
                                .withValues(alpha: 0.42),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: GoogleFonts.notoSerifTc(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          await _toggleCreatorFollowFromCharacter(
                            creatorId: creatorId,
                            creatorName: creatorName,
                          );
                        },
                        icon: Icon(
                          _isFollowing ? Icons.check_rounded : Icons.add_rounded,
                          size: 17,
                        ),
                        label: Text(
                          _isFollowing
                              ? l10n.followed_btn
                              : l10n.follow_btn,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.echo_wall_title,
                        style: GoogleFonts.notoSerifTc(
                          color: theme.colorScheme.onSurface,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Showcase(
                      key: _echoKey,
                      description: l10n.tip_time_echoes,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                        ),
                        onPressed: _showAddEchoDialog,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(
                          l10n.echo_leave_memory,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (docs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 58, bottom: 70),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.12,
                              child: Image.asset(
                                'assets/images/profile/about_botanical.png',
                                width: 135,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          l10n.echo_empty_msg,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSerifTc(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.46),
                            fontSize: 14,
                            height: 1.75,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final String docId = doc.id;
                    final String originalContent = data['content'] ?? '';
                    final String cardStyle =
                    (data['cardStyle'] ?? data['theme'] ?? 'butterfly')
                        .toString();
                    final isMine = data['userId'] == currentUserId;
                    final isAdmin = currentUserId == adminUid;

                    final bool isTranslating =
                    _translatingEchoIds.contains(docId);
                    final bool hasTranslation =
                    _translatedEchoes.containsKey(docId);
                    final String displayContent =
                        _translatedEchoes[docId] ?? originalContent;

                    final String cardAsset = _echoCardAsset(cardStyle);

                    double echoFontSize;
                    if (displayContent.length > 80) {
                      echoFontSize = 10.5;
                    } else if (displayContent.length > 55) {
                      echoFontSize = 11.5;
                    } else if (displayContent.length > 30) {
                      echoFontSize = 12.5;
                    } else {
                      echoFontSize = 14;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AspectRatio(
                        aspectRatio: 3.15,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                cardAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.025),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  34,
                                  24,
                                  34,
                                  18,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    displayContent,
                                    maxLines: 6,
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.notoSerifTc(
                                      color: hasTranslation
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.80),
                                      fontSize: echoFontSize,
                                      height: 1.45,
                                      fontStyle: hasTranslation
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 9,
                              child: isTranslating
                                  ? Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.scaffoldBackgroundColor
                                      .withValues(alpha: 0.72),
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.8,
                                  ),
                                ),
                              )
                                  : PopupMenuButton<String>(
                                tooltip: '',
                                padding: EdgeInsets.zero,
                                color: theme.scaffoldBackgroundColor,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                onSelected: (value) {
                                  if (value == 'translate') {
                                    _translateSingleEcho(
                                      docId,
                                      originalContent,
                                    );
                                  } else if (value == 'delete') {
                                    _deleteEcho(doc);
                                  } else if (value == 'report') {
                                    _reportEcho(docId);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'translate',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.translate_rounded,
                                          size: 18,
                                          color: hasTranslation
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.62),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          l10n.characterProfileTranslate,
                                          style: GoogleFonts.notoSerifTc(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isMine)
                                    PopupMenuItem<String>(
                                      value: 'report',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .report_gmailerrorred_rounded,
                                            size: 18,
                                            color: theme
                                                .colorScheme.onSurface
                                                .withValues(alpha: 0.58),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            l10n.report_title,
                                            style:
                                            GoogleFonts.notoSerifTc(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (isMine || isAdmin)
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/chat/chat_msg_delete_mask.png',
                                            width: 18,
                                            height: 18,
                                            color: Colors.redAccent,
                                            colorBlendMode:
                                            BlendMode.srcIn,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            l10n.delete_btn,
                                            style:
                                            GoogleFonts.notoSerifTc(
                                              fontSize: 13,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: theme.scaffoldBackgroundColor
                                        .withValues(alpha: 0.72),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.10),
                                      width: 0.7,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.more_horiz_rounded,
                                    size: 20,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.58),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ],
        );
      },
    );
  }

}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;
  _SliverAppBarDelegate(this.tabBar, this.backgroundColor);
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 固定在 TabBar 上緣的柔霧銜接。
        // 當角色照片往上滑離畫面時，這層仍會留在 TabBar 上方，
        // 不會突然變成硬切。
        Positioned(
          left: 0,
          right: 0,
          top: -42,
          child: IgnorePointer(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withValues(alpha: 0.0),
                    backgroundColor.withValues(alpha: 0.30),
                    backgroundColor.withValues(alpha: 0.72),
                    backgroundColor,
                  ],
                  stops: const [0.0, 0.38, 0.74, 1.0],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: backgroundColor,
          child: tabBar,
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class CharacterGalleryWidget extends StatefulWidget {
  final String characterId;
  final Character character;
  final int currentAffection;
  const CharacterGalleryWidget({
    Key? key,
    required this.character,
    required this.characterId,
    required this.currentAffection,
  }) : super(key: key);

  @override
  State<CharacterGalleryWidget> createState() => _CharacterGalleryWidgetState();
}

class _CharacterGalleryWidgetState extends State<CharacterGalleryWidget> {
  String? _selectedBackground;
  late Future<List<CharacterPhoto>> _photosFuture;

  @override
  void initState() {
    super.initState();
    _photosFuture = _initialPhotosFuture();
  }

  @override
  void didUpdateWidget(covariant CharacterGalleryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.characterId != widget.characterId) {
      _photosFuture = _initialPhotosFuture();
    }
  }

  Future<List<CharacterPhoto>> _initialPhotosFuture() {
    final existingGallery = widget.character.gallery;

    if (existingGallery != null && existingGallery.isNotEmpty) {
      return Future<List<CharacterPhoto>>.value(
        List<CharacterPhoto>.from(existingGallery),
      );
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
                        widget.currentAffection.toString(),
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
                      widget.currentAffection >= requiredAffection;
                  final bool isSelected = _selectedBackground == photoUrl;
                  // 🛡️ 加上這個防呆守衛！
                  // 如果這筆資料的網址是空的，我們就回傳一個空的隱藏元件，不要讓它去畫圖
                  if (photoUrl.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () async {
                      if (isUnlocked) {
                        if (isSelected) {
                          // ✨ 情況 A：玩家按了「已經被選中」的照片 ➡️ 執行取消！
                          setState(
                                  () => _selectedBackground = ''); // 把選取狀態清空
                          _updateCallBackgroundToCloud(
                              ''); // 傳空字串給 Firebase，代表恢復預設

                          // 這裡妳可以另外寫一個提示，或是直接共用
                          // ✨ 總裁級：背景已重置的優雅回饋，輕巧一閃，不干擾視覺
                          ToastUtils.showCenterToast(
                            context,
                            l10n.gallery_reset_bg,
                            customIcon: Icons
                                .refresh_rounded, // 💡 用「重置/刷新」圖示，與「重置背景」的語意完美對應
                          );
                        } else {
                          // ✨ 情況 B：玩家按了「還沒選中」的照片 ➡️ 執行設定！
                          setState(() => _selectedBackground = photoUrl);
                          _updateCallBackgroundToCloud(photoUrl);
                          _showSuccessSnackBar(context, photoDesc);
                        }
                      } else {
                        // 鎖住的照片，維持跳警告
                        _showLockSnackBar(context, requiredAffection);
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
                child: const Icon(Icons.broken_image, color: Colors.grey),
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
      customIcon: Icons.lock_open_rounded, // 💡 用「解鎖」的圖示，呼應解鎖成功的情境，絕妙！
    );
  }

  void _showLockSnackBar(BuildContext context, int req) {
    final l10n = AppLocalizations.of(context)!;

    // ✨ 總裁級：未達門檻的溫柔提醒，用鎖頭圖示鼓勵玩家繼續努力！
    ToastUtils.showCenterToast(
      context,
      l10n.gallery_lock_msg(req.toString()),
      customIcon: Icons.lock_outline_rounded, // 💡 使用相同的鎖頭圖示，與系統的「鎖定」狀態語彙完全一致
    );
  }

  Future<void> _updateCallBackgroundToCloud(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
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
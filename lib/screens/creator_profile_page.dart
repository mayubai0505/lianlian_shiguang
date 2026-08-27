import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🌟 記得加這個來判斷身分
import 'package:cached_network_image/cached_network_image.dart'; // 🌟 讀取雲端圖片用
import '../services/daily_task_service.dart';
import '../utils/character_navigator.dart';
import 'character_profile_page.dart';
import 'character_model.dart';
import 'creator_studio_page.dart'; // ✨ 總裁的秘密工作室檔案！
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../models/moment_model.dart';
import 'moment_card.dart';
import 'edit_moment_page.dart';
import '../services/toast_utils.dart';
import 'package:google_fonts/google_fonts.dart';

//創作者公開頁面
class CreatorProfilePage extends StatelessWidget {
  final String creatorId;
  final String creatorName;
  final String APP_ID = AppConfig.appId;

  const CreatorProfilePage({
    super.key,
    required this.creatorId,
    this.creatorName = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final String? currentUserId =
        FirebaseAuth.instance.currentUser?.uid;

    final bool isOwner =
        currentUserId == creatorId;

    // 1. 先讀取創作者本人的公開資料
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(creatorId)
          .get(),
      builder: (
          context,
          userSnapshot,
          ) {
        // -----------------------------
        // 創作者顯示資料
        // -----------------------------
        String displayNickname =
        creatorName.trim().isNotEmpty
            ? creatorName.trim()
            : l10n.profilePageCreator;

        String displayPlayerID =
        creatorId.length >= 8
            ? creatorId
            .substring(0, 8)
            .toUpperCase()
            : creatorId.toUpperCase();

        String? photoUrl;
        String? avatarPath;
        String creatorBio = '';

        if (userSnapshot.hasData &&
            userSnapshot.data!.exists) {
          final userData =
          userSnapshot.data!.data()
          as Map<String, dynamic>;

          final String fetchedNickname =
          (userData['nickname'] ?? '')
              .toString()
              .trim();

          final String fetchedDisplayName =
          (userData['displayName'] ?? '')
              .toString()
              .trim();

          if (fetchedNickname.isNotEmpty) {
            displayNickname =
                fetchedNickname;
          } else if (fetchedDisplayName
              .isNotEmpty) {
            displayNickname =
                fetchedDisplayName;
          }

          final String fetchedPlayerID =
          (userData['playerID'] ?? '')
              .toString()
              .trim();

          if (fetchedPlayerID.isNotEmpty) {
            displayPlayerID =
                fetchedPlayerID;
          }

          photoUrl =
          userData['photoURL'] as String?;

          avatarPath =
          userData['avatarPath'] as String?;

          creatorBio =
              (userData['bio'] ?? '')
                  .toString()
                  .trim();

          debugPrint(
            '📝 creatorBio：$creatorBio',
          );
        }

        ImageProvider? imageProvider;

        final String? finalPath =
            avatarPath ?? photoUrl;

        if (finalPath != null &&
            finalPath.isNotEmpty) {
          if (finalPath.startsWith('http')) {
            imageProvider =
                CachedNetworkImageProvider(finalPath);
          } else {
            imageProvider =
                AssetImage(finalPath);
          }
        }

        // =================================================
        // 2. 監聽目前玩家封鎖的角色
        // =================================================
        return StreamBuilder<QuerySnapshot>(
          stream: currentUserId == null
              ? null
              : FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection(
            'blockedCharacters',
          )
              .snapshots(),
          builder: (
              context,
              blockedSnapshot,
              ) {
            final Set<String>
            blockedCharacterIds =
                blockedSnapshot.data?.docs
                    .map(
                      (doc) => doc.id,
                )
                    .toSet() ??
                    <String>{};

            // =================================================
            // 3. 讀取這位創作者建立的公開角色
            // =================================================
            return StreamBuilder<
                List<Character>>(
              stream: FirebaseFirestore
                  .instance
                  .collection('artifacts')
                  .doc(AppConfig.appId)
                  .collection(
                'public_characters',
              )
                  .where(
                'createdBy',
                isEqualTo: creatorId,
              )
                  .snapshots()
                  .asyncMap(
                    (snapshot) async {
                  return Future.wait(
                    snapshot.docs
                        .map(
                          (doc) =>
                          Character
                              .fromFirestoreAsync(
                            doc,
                          ),
                    )
                        .toList(),
                  );
                },
              ),
              builder: (
                  context,
                  characterSnapshot,
                  ) {
                // 原始角色清單
                final List<Character>
                allCharacters =
                    characterSnapshot.data ??
                        <Character>[];

                // 玩家實際可見角色
                final List<Character>
                characters =
                allCharacters
                    .where(
                      (character) =>
                  !blockedCharacterIds
                      .contains(
                    character.id,
                  ),
                )
                    .toList();

                final int totalLikes =
                characters.fold<int>(
                  0,
                      (
                      sum,
                      character,
                      ) =>
                  sum +
                      character.likesCount,
                );

                return Scaffold(
                  backgroundColor: theme.scaffoldBackgroundColor,
                  appBar: AppBar(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      l10n.portfolio_title(displayNickname),
                      style: GoogleFonts.notoSerifTc(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    actions: [
                      if (!isOwner)
                        PopupMenuButton<String>(
                          tooltip: '更多',
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: theme.colorScheme.onSurface,
                          ),
                          onSelected: (value) async {
                            switch (value) {
                              case 'report':
                                await _reportCreator(
                                  context: context,
                                  creatorId: creatorId,
                                  creatorName: displayNickname,
                                );
                                break;
                              case 'block':
                                final blocked = await _blockCreator(
                                  context: context,
                                  creatorId: creatorId,
                                  creatorName: displayNickname,
                                  characters: characters,
                                );
                                if (blocked && context.mounted) {
                                  Navigator.of(context).pop(true);
                                }
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem<String>(
                              value: 'report',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.flag_outlined,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '檢舉創作者',
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'block',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.block_rounded,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '封鎖創作者',
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 13.5,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      Positioned(
                        left: -18,
                        top: -18,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.30,
                            child: Image.asset(
                              'assets/images/creator_public/creator_public_top_left_wash.png',
                              width: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -24,
                        top: 24,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.18,
                            child: Image.asset(
                              'assets/images/creator_public/creator_public_top_right_botanical.png',
                              width: 170,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -26,
                        bottom: 12,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.12,
                            child: Image.asset(
                              'assets/images/creator_public/creator_public_bottom_left_botanical.png',
                              width: 170,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            _buildCreatorHeader(
                              context,
                              theme,
                              creatorId: creatorId,
                              displayNickname: displayNickname,
                              displayPlayerID: displayPlayerID,
                              creatorBio: creatorBio,
                              imageProvider: imageProvider,
                              isOwner: isOwner,
                              workCount: characters.length,
                              totalLikes: totalLikes,
                            ),
                            _buildCreatorMainTabBar(
                              context,
                              theme,
                              l10n,
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  _buildCreatorAboutTab(
                                    context,
                                    theme,
                                    creatorBio,
                                  ),
                                  _buildCreatorWorks(
                                    context,
                                    theme,
                                    l10n,
                                    characters,
                                    isOwner,
                                    characterSnapshot,
                                  ),
                                  _buildCreatorMomentsTab(
                                    context,
                                    theme,
                                    creatorId,
                                    characters,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  Future<void> _reportCreator({
    required BuildContext context,
    required String creatorId,
    required String creatorName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入後再檢舉創作者',
        isError: true,
      );
      return;
    }

    if (user.uid == creatorId) {
      ToastUtils.showCenterToast(
        context,
        '無法檢舉自己的創作者頁面',
        isError: true,
      );
      return;
    }

    final String? reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        Widget reasonTile(String value, String label) {
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              label,
              style: GoogleFonts.notoSerifTc(
                fontSize: 13.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            onTap: () => Navigator.pop(dialogContext, value),
          );
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            '檢舉創作者',
            style: GoogleFonts.notoSerifTc(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '請選擇檢舉「$creatorName」的原因：',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                ),
              ),
              const SizedBox(height: 10),
              reasonTile('inappropriate_content', '不當或違規內容'),
              reasonTile('harassment', '騷擾、攻擊或仇恨內容'),
              reasonTile('impersonation', '冒充他人或偽造身分'),
              reasonTile('spam', '垃圾內容或惡意宣傳'),
              reasonTile('other', '其他'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                '取消',
                style: GoogleFonts.notoSerifTc(),
              ),
            ),
          ],
        );
      },
    );

    if (reason == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('reports')
          .add({
        'type': 'creator',
        'targetType': 'creator',
        'targetId': creatorId,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'reporterId': user.uid,
        'reason': reason,
        'source': 'creator_profile',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        '已收到檢舉，感謝你的回報',
        customIcon: Icons.flag_outlined,
      );
    } catch (e) {
      debugPrint('❌ 檢舉創作者失敗：$e');

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        '檢舉送出失敗，請稍後再試',
        isError: true,
      );
    }
  }

  Future<bool> _blockCreator({
    required BuildContext context,
    required String creatorId,
    required String creatorName,
    required List<Character> characters,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入後再封鎖創作者',
        isError: true,
      );
      return false;
    }

    if (user.uid == creatorId) {
      ToastUtils.showCenterToast(
        context,
        '無法封鎖自己',
        isError: true,
      );
      return false;
    }

    final bool confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.block_rounded,
                color: Colors.redAccent,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                '封鎖創作者',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            '確定要封鎖「$creatorName」嗎？\n\n'
                '封鎖後，你將不會再看到這位創作者的公開頁面，'
                '目前由他建立的公開角色也會一併加入封鎖名單。',
            style: GoogleFonts.notoSerifTc(
              fontSize: 13.5,
              height: 1.65,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                '取消',
                style: GoogleFonts.notoSerifTc(),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                '確認封鎖',
                style: GoogleFonts.notoSerifTc(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    ) ??
        false;

    if (!confirmed) return false;

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final blockedCreatorRef = db
          .collection('users')
          .doc(user.uid)
          .collection('blockedCreators')
          .doc(creatorId);

      batch.set(
        blockedCreatorRef,
        {
          'creatorId': creatorId,
          'creatorName': creatorName,
          'blockedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // 先讀取目前已經手動封鎖的角色。
      // 若玩家之前單獨封鎖過某角色，不覆蓋其 source，
      // 這樣日後「解除封鎖創作者」時不會誤解封該角色。
      final existingBlockedSnapshot = await db
          .collection('users')
          .doc(user.uid)
          .collection('blockedCharacters')
          .get();

      final existingBlockedIds =
      existingBlockedSnapshot.docs.map((doc) => doc.id).toSet();

      // 封鎖創作者時，將「尚未被單獨封鎖」的現有公開角色
      // 加入 creator_block；之後新建立的角色則由 blockedCreators
      // 在邂逅 / 搜尋頁直接依 createdBy 過濾。
      for (final character in characters) {
        if (existingBlockedIds.contains(character.id)) {
          continue;
        }

        final blockedCharacterRef = db
            .collection('users')
            .doc(user.uid)
            .collection('blockedCharacters')
            .doc(character.id);

        batch.set(
          blockedCharacterRef,
          {
            'characterId': character.id,
            'characterName': character.name,
            'name': character.name,
            'avatarPath': character.avatarPath,
            'creatorId': creatorId,
            'blockedAt': FieldValue.serverTimestamp(),
            'source': 'creator_block',
          },
        );
      }

      await batch.commit();

      if (!context.mounted) return true;

      ToastUtils.showCenterToast(
        context,
        '已封鎖「$creatorName」',
        customIcon: Icons.block_rounded,
      );

      return true;
    } catch (e) {
      debugPrint('❌ 封鎖創作者失敗：$e');

      if (!context.mounted) return false;

      ToastUtils.showCenterToast(
        context,
        '封鎖失敗，請稍後再試',
        isError: true,
      );

      return false;
    }
  }

  Widget _buildCreatorMainTabBar(
      BuildContext context,
      ThemeData theme,
      AppLocalizations l10n,
      ) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        TabBar(
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor:
          theme.colorScheme.onSurface.withValues(alpha: 0.48),
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          labelStyle: GoogleFonts.notoSerifTc(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.notoSerifTc(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(text: l10n.profilePageTabBio),
            Tab(text: l10n.profilePageTabCharacters),
            Tab(text: l10n.profilePageTabMoments),
          ],
        ),
        Positioned(
          bottom: 0,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.72,
              child: Image.asset(
                'assets/images/creator_public/creator_public_tab_ornament.png',
                width: 92,
                height: 12,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreatorAboutTab(
      BuildContext context,
      ThemeData theme,
      String creatorBio,
      ) {
    final l10n = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;

    if (creatorBio.trim().isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 40),
        children: [
          const SizedBox(height: 34),
          Center(
            child: Image.asset(
              'assets/images/creator_public/creator_public_avatar_branch.png',
              width: 72,
              fit: BoxFit.contain,
              opacity: const AlwaysStoppedAnimation(0.42),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.creatorProfileNoBio,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.creatorProfileNoBioHint,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              fontSize: 13,
              height: 1.6,
              color: textColor.withValues(alpha: 0.50),
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 42),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary.withValues(alpha: 0.14),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.045),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -2,
                bottom: -8,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.20,
                    child: Image.asset(
                      'assets/images/creator_public/creator_public_bottom_right_ink.png',
                      width: 105,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profilePageAboutMe,
                      style: GoogleFonts.notoSerifTc(
                        color: primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      creatorBio,
                      style: GoogleFonts.notoSerifTc(
                        color: textColor.withValues(alpha: 0.78),
                        fontSize: 13.5,
                        height: 1.85,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreatorMomentsTab(
      BuildContext context,
      ThemeData theme,
      String creatorId,
      List<Character> characters,
      ) {
    final String currentUserId =
        FirebaseAuth.instance.currentUser?.uid ?? '';
    final l10n = AppLocalizations.of(context)!;
    String selectedFilter = 'all';

    return StatefulBuilder(
      builder: (
          context,
          setFilterState,
          ) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCreatorMomentFilter(
                      context: context,
                      label: l10n.profilePageFilterAll,
                      value: 'all',
                      selectedValue: selectedFilter,
                      onSelected: (value) {
                        setFilterState(() {
                          selectedFilter = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCreatorMomentFilter(
                      context: context,
                      label: l10n.profilePageFilterCreator,
                      value: 'creator',
                      selectedValue: selectedFilter,
                      onSelected: (value) {
                        setFilterState(() {
                          selectedFilter = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildCreatorMomentFilter(
                      context: context,
                      label: l10n.profilePageTabCharacters,
                      value: 'character',
                      selectedValue: selectedFilter,
                      onSelected: (value) {
                        setFilterState(() {
                          selectedFilter = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('artifacts')
                    .doc(AppConfig.appId)
                    .collection('moments')
                    .where(
                  'createdBy',
                  isEqualTo: creatorId,
                )
                    .orderBy(
                  'createdAt',
                  descending: true,
                )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    debugPrint(
                      '❌ 公開工作坊動態讀取失敗：'
                          '${snapshot.error}',
                    );

                    return _buildCreatorMomentEmptyState(
                      theme: theme,
                      icon: Icons.error_outline_rounded,
                      title: l10n.profilePageMomentsLoadFailed,
                      description: l10n.profilePageTryAgainLater,
                      isError: true,
                    );
                  }

                  final docs =
                      snapshot.data?.docs ?? [];

                  final Set<String> visibleCharacterIds =
                  characters
                      .map(
                        (character) => character.id,
                  )
                      .toSet();

                  final allMoments = docs
                      .map(
                        (doc) =>
                        Moment.fromFirestore(doc),
                  )
                      .where(
                        (moment) {
                      if (moment.isPublic != true) {
                        return false;
                      }

                      // 創作者本人發文保留
                      if (moment.isCreatorPost) {
                        return true;
                      }

                      // 角色發文只顯示未被封鎖的角色
                      return visibleCharacterIds.contains(
                        moment.authorId,
                      );
                    },
                  )
                      .toList();

                  final filteredMoments =
                  allMoments.where((moment) {
                    switch (selectedFilter) {
                      case 'creator':
                        return moment.isCreatorPost;

                      case 'character':
                        return !moment.isCreatorPost;

                      case 'all':
                      default:
                        return true;
                    }
                  }).toList();

                  if (filteredMoments.isEmpty) {
                    String title;
                    String description;

                    switch (selectedFilter) {
                      case 'creator':
                        title = l10n.creatorProfileNoCreatorMoments;
                        description =
                            l10n.creatorProfileNoCreatorMomentsHint;
                        break;

                      case 'character':
                        title = l10n.creatorProfileNoCharacterMoments;
                        description =
                            l10n.creatorProfileNoCharacterMomentsHint;
                        break;

                      case 'all':
                      default:
                        title = l10n.creatorProfileNoPublicMoments;
                        description =
                            l10n.creatorProfileNoPublicMomentsHint;
                    }

                    return _buildCreatorMomentEmptyState(
                      theme: theme,
                      icon:
                      Icons.dynamic_feed_outlined,
                      title: title,
                      description: description,
                    );
                  }

                  return ListView.builder(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 24,
                    ),
                    itemCount:
                    filteredMoments.length,
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final moment =
                      filteredMoments[index];

                      return MomentCard(
                        key: ValueKey(moment.id),
                        moment: moment,
                        currentUserId:
                        currentUserId,
                        showFeatureTips: false,

                        // MomentCard 自己會處理按讚資料；
                        // 工作坊不另外累加每日任務。
                        onLikeTapped: () async {
                          final result =
                          await DailyTaskService.recordMomentLike(
                            momentId: moment.id,
                          );

                          if (!context.mounted) return;

                          if (result.completedNow) {
                            ToastUtils.showCenterToast(
                              context,
                              AppLocalizations.of(context)!
                                  .task_social_tour_complete,
                              customIcon: Icons.tour_rounded,
                            );
                          }
                        },
                        onEditTapped: () {
                          _editCreatorMoment(
                            context,
                            moment,
                          );
                        },

                        onDeleteTapped: () {
                          _deleteCreatorMoment(
                            context,
                            creatorId,
                            moment.id,
                          );
                        },

                        onAvatarTapped: () {
                          _openCreatorMomentAuthor(
                            context: context,
                            moment: moment,
                            characters: characters,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildCreatorMomentFilter({
    required BuildContext context,
    required String label,
    required String value,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    final theme = Theme.of(context);
    final bool isSelected =
        selectedValue == value;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          onSelected(value);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.10)
              : theme.scaffoldBackgroundColor.withValues(alpha: 0.84),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(
              alpha: isSelected ? 0.32 : 0.12,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSerifTc(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.62),
          ),
        ),
      ),
    );
  }
  Widget _buildCreatorMomentEmptyState({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String description,
    bool isError = false,
  }) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 50),
        Icon(
          icon,
          size: 58,
          color: isError
              ? theme.colorScheme.error
              .withValues(alpha: 0.55)
              : theme.colorScheme.primary
              .withValues(alpha: 0.40),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: theme.colorScheme.onSurface
                .withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
  Future<void> _openCreatorMomentAuthor({
    required BuildContext context,
    required Moment moment,
    required List<Character> characters,
  }) async {
    // 創作者本人發文，目前停留在工作坊即可
    if (moment.isCreatorPost) {
      return;
    }

    await CharacterNavigator.open(
      context,
      characterId: moment.authorId,
      fallbackName: moment.authorName,
    );
  }
  Future<void> _editCreatorMoment(
      BuildContext context,
      Moment moment,
      ) async {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null ||
        moment.createdBy != currentUser.uid) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMomentPage(
          momentToEdit: moment,
        ),
      ),
    );
  }
  Future<void> _deleteCreatorMoment(
      BuildContext context,
      String creatorId,
      String momentId,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null ||
        currentUser.uid != creatorId) {
      return;
    }

    final bool confirm =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title:  Text(l10n.profilePageDeleteMomentTitle),
              content:  Text(
                l10n.profilePageDeleteMomentConfirm,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child:  Text(l10n.cancelButton),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child:  Text(
                    l10n.profilePageDelete,
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirm) return;

    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('moments')
          .doc(momentId)
          .delete();

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.profilePageMomentDeleted,
        customIcon:
        Icons.delete_outline_rounded,
      );
    } catch (e) {
      debugPrint('❌ 刪除工作坊動態失敗：$e');

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.profilePageDeleteFailed,
        isError: true,
      );
    }
  }
  Widget _buildCreatorHeader(
      BuildContext context,
      ThemeData theme, {
        required String creatorId,
        required String displayNickname,
        required String displayPlayerID,
        required String creatorBio,
        required ImageProvider? imageProvider,
        required bool isOwner,
        required int workCount,
        required int totalLikes,
      }) {
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final subTextColor = textColor.withValues(alpha: 0.52);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 104,
                height: 104,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.22),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        child: CircleAvatar(
                          backgroundColor:
                          primaryColor.withValues(alpha: 0.08),
                          backgroundImage: imageProvider,
                          child: imageProvider == null
                              ? Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: primaryColor.withValues(alpha: 0.32),
                          )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -14,
                      bottom: -4,
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.66,
                          child: Image.asset(
                            'assets/images/creator_public/creator_public_avatar_branch.png',
                            width: 58,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayNickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'ID: $displayPlayerID',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12.5,
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      creatorBio.isNotEmpty
                          ? creatorBio
                          : l10n.creatorProfileNoBioHint,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12.2,
                        height: 1.55,
                        color: textColor.withValues(
                          alpha: creatorBio.isNotEmpty ? 0.60 : 0.36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    if (isOwner)
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreatorStudioPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.brush_outlined,
                          size: 15,
                        ),
                        label: Text(
                          l10n.enter_secret_studio,
                          style: GoogleFonts.notoSerifTc(fontSize: 12.5),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          side: BorderSide(
                            color: primaryColor.withValues(alpha: 0.30),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      )
                    else
                      _buildCreatorFollowButton(
                        context: context,
                        creatorId: creatorId,
                        creatorName: displayNickname,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildCreatorStat(
                    theme,
                    value: '$workCount',
                    label: l10n.creatorProfilePublicWorks,
                  ),
                ),
                _buildCreatorStatDivider(theme),
                Expanded(
                  child: _buildCreatorStat(
                    theme,
                    value: '$totalLikes',
                    label: l10n.creatorProfileLikesReceived,
                  ),
                ),
                _buildCreatorStatDivider(theme),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(creatorId)
                        .collection('followers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      final int followerCount =
                          snapshot.data?.docs.length ?? 0;

                      return _buildCreatorStat(
                        theme,
                        value: _formatCreatorCount(followerCount),
                        label: l10n.profilePageFollowers,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorStatDivider(
      ThemeData theme,
      ) {
    return Container(
      width: 1,
      height: 32,
      color: theme.colorScheme.onSurface
          .withValues(alpha: 0.10),
    );
  }
  String _formatCreatorCount(
      int value,
      ) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return '$value';
  }
  Widget _buildCreatorFollowButton({
    required BuildContext context,
    required String creatorId,
    required String creatorName,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.person_add_alt_1_rounded,
          size: 16,
        ),
        label:  Text(l10n.creatorProfileFollow),
      );
    }

    final followingRef =
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('following')
        .doc(creatorId);

    return StreamBuilder<DocumentSnapshot>(
      stream: followingRef.snapshots(),
      builder: (context, snapshot) {
        final bool isFollowing =
            snapshot.data?.exists == true;

        return OutlinedButton.icon(
          onPressed: snapshot.connectionState ==
              ConnectionState.waiting
              ? null
              : () {
            _toggleCreatorFollow(
              context: context,
              creatorId: creatorId,
              creatorName: creatorName,
              currentlyFollowing:
              isFollowing,
            );
          },
          icon: Icon(
            isFollowing
                ? Icons.check_rounded
                : Icons.person_add_alt_1_rounded,
            size: 16,
          ),
          label: Text(
            isFollowing ? l10n.creatorProfileFollowing : l10n.creatorProfileFollow,
            style: GoogleFonts.notoSerifTc(fontSize: 12.5),
          ),
          style: OutlinedButton.styleFrom(
            visualDensity:
            VisualDensity.compact,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            backgroundColor: isFollowing
                ? Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.08)
                : null,
            side: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(
                alpha:
                isFollowing ? 0.28 : 0.65,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
  Future<void> _toggleCreatorFollow({
    required BuildContext context,
    required String creatorId,
    required String creatorName,
    required bool currentlyFollowing,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ToastUtils.showCenterToast(
        context,
        l10n.profilePagePleaseSignIn,
        isError: true,
      );
      return;
    }

    if (currentUser.uid == creatorId) {
      return;
    }

    final db =
        FirebaseFirestore.instance;

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

    try {
      final batch = db.batch();

      if (currentlyFollowing) {
        batch.delete(followingRef);
        batch.delete(followerRef);
      } else {
        batch.set(followingRef, {
          'creatorId': creatorId,
          'creatorName': creatorName,
          'followedAt':
          FieldValue.serverTimestamp(),
        });

        batch.set(followerRef, {
          'followerId': currentUser.uid,
          'followedAt':
          FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        currentlyFollowing
            ? l10n.creatorProfileUnfollowed
            : l10n.creatorProfileFollowedCreator(creatorName),
        customIcon: currentlyFollowing
            ? Icons.person_remove_outlined
            : Icons.person_add_alt_1_rounded,
      );
    } catch (e) {
      debugPrint(
        '❌ 切換創作者追蹤狀態失敗：$e',
      );

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.creatorProfileOperationFailed,
        isError: true,
      );
    }
  }
  Widget _buildCreatorStat(
      ThemeData theme, {
        required String value,
        required String label,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.notoSerifTc(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: GoogleFonts.notoSerifTc(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.50),
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }
  Widget _buildCreatorWorks(
      BuildContext context,
      ThemeData theme,
      AppLocalizations l10n,
      List<Character> characters,
      bool isOwner,
      AsyncSnapshot<List<Character>>
      characterSnapshot,
      ) {
    if (characterSnapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (characterSnapshot.hasError) {
      return Center(
        child: Text(
          l10n.creatorProfileWorksLoadFailed(
            characterSnapshot.error.toString(),
          ),
        ),
      );
    }

    if (characters.isEmpty) {
      return Center(
        child: Text(
          isOwner
              ? l10n.no_public_character_mine
              : l10n.no_public_character_other,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final characterObj =
        characters[index];

        final double cardHeight =
        index.isEven ? 240 : 300;

        final String safeAvatar =
        characterObj.avatarPath.trim();

        final ImageProvider cardImage;

        if (safeAvatar.startsWith('http')) {
          cardImage =
              CachedNetworkImageProvider(
                safeAvatar,
              );
        } else if (safeAvatar
            .startsWith('assets/')) {
          cardImage =
              AssetImage(safeAvatar);
        } else {
          cardImage = const AssetImage(
            'assets/images/default.png',
          );
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CharacterProfilePage(
                      character: characterObj,
                      characterId:
                      characterObj.id,
                    ),
              ),
            );
          },
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(24),
                    gradient:
                    LinearGradient(
                      begin:
                      Alignment.topCenter,
                      end:
                      Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black
                            .withValues(
                          alpha: 0.1,
                        ),
                        Colors.black
                            .withValues(
                          alpha: 0.8,
                        ),
                      ],
                      stops: const [
                        0,
                        0.6,
                        1,
                      ],
                    ),
                  ),
                  padding:
                  const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        characterObj.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.ageAndOccupation(
                          characterObj.age.toString(),
                          characterObj.occupation,
                        ),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          color: Colors.white70,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(
                        alpha: 0.4,
                      ),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${characterObj.likesCount}',
                          style:
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
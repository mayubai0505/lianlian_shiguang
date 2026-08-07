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
            : '創作者';

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
                NetworkImage(finalPath);
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
                  backgroundColor:
                  theme
                      .scaffoldBackgroundColor,
                  appBar: AppBar(
                    title: Text(
                      l10n.portfolio_title(
                        displayNickname,
                      ),
                    ),
                    elevation: 0,
                  ),
                  body:
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        _buildCreatorHeader(
                          context,
                          theme,
                          creatorId:
                          creatorId,
                          displayNickname:
                          displayNickname,
                          displayPlayerID:
                          displayPlayerID,
                          creatorBio:
                          creatorBio,
                          imageProvider:
                          imageProvider,
                          isOwner:
                          isOwner,
                          workCount:
                          characters.length,
                          totalLikes:
                          totalLikes,
                        ),

                        TabBar(
                          labelColor:
                          theme
                              .colorScheme
                              .primary,
                          unselectedLabelColor:
                          theme
                              .colorScheme
                              .onSurface
                              .withValues(
                            alpha: 0.55,
                          ),
                          indicatorColor:
                          theme
                              .colorScheme
                              .primary,
                          indicatorWeight:
                          3,
                          tabs: const [
                            Tab(
                              text:
                              '自我介紹',
                            ),
                            Tab(
                              text:
                              '角色',
                            ),
                            Tab(
                              text:
                              '動態',
                            ),
                          ],
                        ),

                        Expanded(
                          child:
                          TabBarView(
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
                );
              },
            );
          },
        );
      },
    );
  }
  Widget _buildCreatorAboutTab(
      BuildContext context,
      ThemeData theme,
      String creatorBio,
      ) {
    if (creatorBio.trim().isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.person_outline_rounded,
            size: 60,
            color: theme.colorScheme.primary
                .withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            '尚未填寫自我介紹',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '這位創作者還沒有留下介紹。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.55),
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface
                .withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📝 關於我',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                creatorBio,
                style: TextStyle(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.78),
                  fontSize: 13,
                  height: 1.6,
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
                      label: '全部',
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
                      label: '本人',
                      value: 'creator',
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
                      label: '角色',
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
                      title: '動態讀取失敗',
                      description: '請稍後再試一次。',
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
                        title = '創作者還沒有發布動態';
                        description =
                        '以創作者本人身分發布的公開內容會顯示在這裡。';
                        break;

                      case 'character':
                        title = '旗下角色還沒有發布動態';
                        description =
                        '旗下公開角色發布的內容會顯示在這裡。';
                        break;

                      case 'all':
                      default:
                        title = '還沒有公開動態';
                        description =
                        '創作者本人與旗下角色發布的公開動態會顯示在這裡。';
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
              ? theme.colorScheme.primary
              : theme.colorScheme.surface
              .withValues(alpha: 0.75),
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface
                .withValues(alpha: 0.10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface
                .withValues(alpha: 0.65),
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
              title: const Text('刪除動態'),
              content: const Text(
                '確定要永久刪除這篇動態嗎？',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child: const Text(
                    '刪除',
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
        '動態已刪除',
        customIcon:
        Icons.delete_outline_rounded,
      );
    } catch (e) {
      debugPrint('❌ 刪除工作坊動態失敗：$e');

      if (!context.mounted) return;

      ToastUtils.showCenterToast(
        context,
        '刪除失敗，請稍後再試',
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
    final subTextColor =
    textColor.withValues(alpha: 0.58);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        14,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor:
                primaryColor.withValues(alpha: 0.10),
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(
                  Icons.person_rounded,
                  size: 46,
                  color: primaryColor.withValues(
                    alpha: 0.38,
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayNickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'ID: $displayPlayerID',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: subTextColor,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 15,
                          color: primaryColor.withValues(
                            alpha: 0.75,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      creatorBio.isNotEmpty
                          ? creatorBio
                          : '這位創作者還沒有留下介紹。',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: textColor.withValues(
                          alpha: creatorBio.isNotEmpty
                              ? 0.62
                              : 0.38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (isOwner)
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const CreatorStudioPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.brush_outlined,
                          size: 16,
                        ),
                        label: Text(
                          l10n.enter_secret_studio,
                        ),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildCreatorStat(
                  theme,
                  value: '$workCount',
                  label: '公開作品',
                ),
              ),

              _buildCreatorStatDivider(
                theme,
              ),

              Expanded(
                child: _buildCreatorStat(
                  theme,
                  value: '$totalLikes',
                  label: '獲得喜歡',
                ),
              ),

              _buildCreatorStatDivider(
                theme,
              ),

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
                      value: _formatCreatorCount(
                        followerCount,
                      ),
                      label: '追蹤者',
                    );
                  },
                ),
              ),
            ],
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
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.person_add_alt_1_rounded,
          size: 16,
        ),
        label: const Text('追蹤'),
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
            isFollowing ? '已追蹤' : '追蹤',
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
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入',
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
            ? '已取消追蹤'
            : '已追蹤 $creatorName',
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
        '操作失敗，請稍後再試',
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
          style: TextStyle(
            color:
            theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: theme
                .colorScheme
                .onSurface
                .withValues(alpha: 0.52),
            fontSize: 12,
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
          '讀取作品失敗：'
              '${characterSnapshot.error}',
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
              BorderRadius.circular(24),
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
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${characterObj.age}歲 | '
                            '${characterObj.occupation}',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color:
                          Colors.white70,
                          fontSize: 12,
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

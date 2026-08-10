import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_notifier.dart';
import '../models/moment_model.dart';
import '../services/toast_utils.dart';
import '../utils/character_navigator.dart';
import 'character_model.dart';
import 'create_moment_page.dart';
import 'moment_card.dart';
import '../utils/image_utils.dart';
import '../page/interaction_history_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'creator_profile_page.dart';
import '../services/moment_notification_service.dart';
import 'edit_moment_page.dart';
import 'hidden_moments_page.dart';
import 'package:showcaseview/showcaseview.dart'; // 🌟 記得加這行
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/daily_task_service.dart';
import 'moment_search_page.dart';

//動態牆(朋友圈)
class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => MomentsPageState();
}

class MomentsPageState extends State<MomentsPage> {
  String? _nickname;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId = FirebaseAuth.instance.currentUser?.uid;
  final String _appId = AppConfig.appId;
  int _likeProgress = 0;
  bool _isLikeClaimed = false;
  late Stream<QuerySnapshot> _friendsStream;
  late Stream<QuerySnapshot> _followingCreatorsStream;
  int _feedReloadKey = 0;
  bool _isOpeningMoreMenu = false;
  int _pauseMomentCardTipsSignal = 0;
  int _resumeMomentCardTipsSignal = 0;
  // 🔑 新增：專門給右上角選單用的追蹤鑰匙
  final GlobalKey _menuKey = GlobalKey();
  // 💡 新增：用來記錄這次開啟畫面時，氣泡彈過沒
  bool _hasMenuTipShown = true;
  bool _menuTutorialFinished = false;
  BuildContext? _showCaseContext;
  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    _loadDailyTaskProgress();

    // 🌟 2. 剛進畫面時，去翻一下小記事本
    _checkTutorialStatus();

    if (_userId != null) {
      _friendsStream = _db
          .collection('users')
          .doc(_userId!)
          .collection('friends')
          .snapshots();
      _followingCreatorsStream = _db
          .collection('users')
          .doc(_userId!)
          .collection('following')
          .snapshots();
    }
  }

  void dismissFeatureTips() {
    final showCaseContext = _showCaseContext;

    if (showCaseContext == null) return;

    try {
      ShowCaseWidget.of(showCaseContext).dismiss();
      Tooltip.dismissAllToolTips();
    } catch (e) {
      debugPrint('關閉瞬間提示氣泡失敗：$e');
    }
  }

  @override
  void dispose() {
    dismissFeatureTips();
    _showCaseContext = null;
    super.dispose();
  }

  // 🌟 3. 新增這個「翻記事本」的專屬功能
  Future<void> _checkTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // 尋找 'seen_moments_tips'，如果找不到就當作沒看過 (false)
    bool hasSeen = prefs.getBool('seen_moments_tips') ?? false;

    if (!hasSeen) {
      // 如果沒看過，就把開關打開，允許畫面發射氣泡！
      if (mounted) {
        setState(() {
          _hasMenuTipShown = false;
        });
      }
      // ✍️ 立刻在記事本寫下紀錄：他看過了！(下次進來就會是 true)
      await prefs.setBool('seen_moments_tips', true);
    } else {
      // 🌟 如果他以前看過了，我們直接把接力棒解鎖給卡片
      // 這樣即使沒彈右上角氣泡，卡片底下的功能也能正常運作！
      if (mounted) {
        setState(() {
          _menuTutorialFinished = true;
        });
      }
    }
  }

  Future<void> _handleLikeTaskProgress(
    Moment moment,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final result = await DailyTaskService.recordMomentLike(
        momentId: moment.id,
      );

      if (!mounted) return;

      // 同一篇今天已經算過，或已完成任務
      if (!result.counted) {
        setState(() {
          _likeProgress = result.progress;
        });
        return;
      }

      setState(() {
        _likeProgress = result.progress;
      });

      // 按讚通知仍然保留
      await MomentNotificationService().createMomentNotification(
        momentId: moment.id,
        type: 'like',
      );

      if (!mounted) return;

      if (result.completedNow && !_isLikeClaimed) {
        ToastUtils.showCenterToast(
          context,
          l10n.task_social_tour_complete,
          customIcon: Icons.tour_rounded,
        );
      }
    } catch (e) {
      debugPrint(
        '更新社群巡禮進度失敗：$e',
      );
    }
  }

  Future<void> _loadDailyTaskProgress() async {
    if (_userId == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();
      if (doc.exists) {
        final data = doc.data()?['dailyTasks'] ?? {};
        if (mounted) {
          setState(() {
            // 這裡只需要抓朋友圈關心的「按讚」進度就好
            _likeProgress = data['likeProgress'] ?? 0;
            _isLikeClaimed = data['likeClaimed'] ?? false;
          });
        }
      }
    } catch (e) {
      print('朋友圈讀取進度失敗: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // 🌟 1. 最外層包上 ShowCaseWidget 總指揮中心 (修正了 builder 的語法)
    return ShowCaseWidget(
      onFinish: () {
        if (mounted) {
          setState(() {
            _menuTutorialFinished = true; // 🏁 右上角跑完了，解鎖下一棒！
          });
        }
      },
      builder: (showCaseContext) {
        _showCaseContext = showCaseContext;

        // 🚀 2. 畫面一載入，就發射右上角的選單氣泡！
        if (!_hasMenuTipShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            ShowCaseWidget.of(
              showCaseContext,
            ).startShowCase([
              _menuKey,
            ]);
          });

          _hasMenuTipShown = true;
        }

        return DefaultTabController(
          length: 2,
          child: Container(
            decoration: themeNotifier.currentBackground,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    title: Text(l10n.wall_title_shiguang),
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    forceElevated: innerBoxIsScrolled,
                    // ✨ 2. 切換選單 (TabBar)
                    bottom: TabBar(
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor:
                          Theme.of(context).unselectedWidgetColor,
                      tabs: [
                        Tab(text: l10n.wall_tab_explore),
                        Tab(text: l10n.wall_tab_exclusive),
                      ],
                    ),
                    // ✨ 3. 升級版的三條線選單自動導航氣泡
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        tooltip: '搜尋拾光牆',
                        onPressed: _openMomentSearch,
                      ),
                      Showcase(
                        key: _menuKey,
                        description: l10n.tip_moments_wall_menu,
                        child: IconButton(
                          icon: const Icon(Icons.menu, size: 28),
                          tooltip: l10n.more_options,
                          onPressed: () async {
                            if (_isOpeningMoreMenu) return;

                            setState(() {
                              _isOpeningMoreMenu = true;
                              // 暫停第一篇貼文的按讚 / 收藏氣泡
                              _pauseMomentCardTipsSignal++;
                            });

                            await Future.delayed(
                                const Duration(milliseconds: 80));

                            if (!mounted) return;

                            await _showMoreMenuSheet(context);

                            if (!mounted) return;

                            setState(() {
                              _isOpeningMoreMenu = false;
                              // 底部選單關掉後，恢復導覽氣泡
                              _resumeMomentCardTipsSignal++;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ];
              },
              // ✨ body 負責去抓好友名單，然後分配給兩個分頁
              body: _buildBodyWithFriendsStream(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openMomentSearch() async {
    final String? currentUserId = _userId;
    if (currentUserId == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MomentSearchPage(
          currentUserId: currentUserId,
          onAvatarTapped: _navigateToCharacterProfile,
          onLikeTapped: _handleLikeTaskProgress,
          onDeleteTapped: _deleteMoment,
          onEditTapped: _editMoment,
        ),
      ),
    );
  }

  // ✨ 負責抓取好友名單，並顯示兩個分頁的內容
  Widget _buildBodyWithFriendsStream() {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return Center(child: Text(l10n.please_login_first));

    return StreamBuilder<QuerySnapshot>(
      stream:
          _friendsStream, // 💡 修正 1：改用 initState 裡連好線的 _friendsStream，不要再當場 snapshots() 了！
      builder: (context, friendSnapshot) {
        if (friendSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final friendIds =
            friendSnapshot.data?.docs.map((doc) => doc.id).toList() ?? [];
        friendIds.add(_userId!);

        return StreamBuilder<QuerySnapshot>(
          stream: _followingCreatorsStream,
          builder: (context, followingSnapshot) {
            if (followingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final followedCreatorIds =
                followingSnapshot.data?.docs.map((doc) => doc.id).toList() ??
                    <String>[];

            return TabBarView(
              children: [
                PersistentFeed(
                  key: ValueKey('public_$_feedReloadKey'),
                  friendIds: friendIds,
                  followedCreatorIds: followedCreatorIds,
                  isPublicTab: true,
                  userId: _userId!,
                  appId: _appId,
                  showFeatureTips: _menuTutorialFinished,
                  pauseMomentCardTipsSignal: _pauseMomentCardTipsSignal,
                  resumeMomentCardTipsSignal: _resumeMomentCardTipsSignal,
                  onLikeTapped: _handleLikeTaskProgress,
                  onDeleteTapped: _deleteMoment,
                  onAvatarTapped: _navigateToCharacterProfile,
                  onEditTapped: _editMoment,
                ),
                PersistentFeed(
                  key: ValueKey('private_$_feedReloadKey'),
                  friendIds: friendIds,
                  followedCreatorIds: followedCreatorIds,
                  isPublicTab: false,
                  userId: _userId!,
                  appId: _appId,
                  showFeatureTips: false, // 👈 這裡強制改成 false！
                  pauseMomentCardTipsSignal: _pauseMomentCardTipsSignal,
                  resumeMomentCardTipsSignal: _resumeMomentCardTipsSignal,
                  onLikeTapped: _handleLikeTaskProgress,
                  onDeleteTapped: _deleteMoment,
                  onAvatarTapped: _navigateToCharacterProfile,
                  onEditTapped: _editMoment,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editMoment(Moment moment) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditMomentPage(
          momentToEdit: moment,
        ),
      ),
    );

    if (!mounted) return;

    if (result is Map && result['changed'] == true) {
      // 你的 PersistentFeed 是 StreamBuilder，Firestore 更新後通常會自己刷新
      // 這裡 setState 只是保險，讓畫面重新整理一次
      setState(() {});
    }
  }

  // 🗑️ 刪除動態的執行邏輯
  Future<void> _deleteMoment(String momentId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // 彈出確認視窗，防止手滑
      bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.moment_delete_confirm_title),
              content: Text(l10n.delete_warning),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.cancelButton)),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.action_confirm_delete,
                        style: TextStyle(color: Colors.red))),
              ],
            ),
          ) ??
          false;

      if (confirm) {
        await _db
            .collection('artifacts')
            .doc(_appId)
            .collection('moments')
            .doc(momentId)
            .delete();
        // ✨ 總裁級：乾淨俐落的刪除回饋，讓畫面瞬間清爽！
        ToastUtils.showCenterToast(
          context,
          l10n.delete_success,
          customIcon:
              Icons.delete_outline_rounded, // 💡 總裁精選：最直覺的空心垃圾桶圖示，視覺負擔極低
          // 💡 總裁秘技：如果是針對較輕量的元素（例如標籤或小文字），
          // 使用 Icons.clear_all_rounded 或 Icons.backspace_outlined 也能展現極佳的品味！
        );
      }
    } catch (e) {
      print("❌ 刪除失敗: $e");
    }
  }

  // ✉️ 寄送「互動信件」到對方的私密信箱
  Future<void> _sendNotificationLetter({
    required String recipientId,
    required String postId,
    required String type,
    required String senderName,
    String? body,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recipientId)
          .collection('mailbox')
          .add({
        'type': type,
        'fromId': _userId,
        'fromName': senderName,
        'title': type == 'like'
            ? l10n.moment_notification_new_like
            : l10n.notification_new_comment,
        'body': body ?? l10n.notification_like_from_sender(senderName),
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      print("📫 信件已成功投遞至：$recipientId 的信箱");
    } catch (e) {
      print("❌ 投遞信件失敗: $e");
    }
  }

  // 小優化：根據不同頁面顯示不同的空白提示
  Widget _buildEmptyState(bool isPublicTab) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isPublicTab ? Icons.public : Icons.people_alt,
              size: 50, color: Colors.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            isPublicTab
                ? l10n.empty_public_moments_prompt
                : l10n.empty_private_moments_prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<List<Character>> _fetchMyCharacters() async {
    if (_userId == null) return [];
    try {
      // 1. 同時發出兩邊的資料庫請求
      final responses = await Future.wait([
        _db
            .collection('artifacts')
            .doc(_appId)
            .collection('public_characters')
            .where('createdBy', isEqualTo: _userId)
            .get(),
        _db
            .collection('artifacts')
            .doc(_appId)
            .collection('users')
            .doc(_userId!)
            .collection('private_characters')
            .get(),
      ]);

      // 2. ✨ 關鍵：使用 Future.wait 讓所有角色同時進行「圖片網址變身」
      // 我們先分別處理公開與私藏的清單
      final publicChars = await Future.wait(responses[0]
          .docs
          .map((doc) => Character.fromFirestoreAsync(doc))
          .toList());

      final privateChars = await Future.wait(responses[1]
          .docs
          .map((doc) => Character.fromFirestoreAsync(doc))
          .toList());

      // 3. 合併已經變身完成的 Character 物件
      final List<Character> myCharacters = [...publicChars, ...privateChars];

      // 4. 排序（這時候大家都是真正的 Character 了，可以放心比較）
      myCharacters.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return myCharacters;
    } catch (e) {
      print("讀取我創建的角色列表失敗: $e");
      return [];
    }
  }

  // ✨ 總裁專屬：跳轉至角色檔案卡 (含私人/刪除防呆邏輯)
  Future<void> _navigateToCharacterProfile(
    Moment moment,
  ) async {
    // 創作者本人貼文：前往該創作者的作品集。
    if (moment.isCreatorPost) {
      final String creatorId = moment.createdBy.trim();

      if (creatorId.isEmpty) {
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          '找不到這位創作者的資料',
          isError: true,
        );
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CreatorProfilePage(
            creatorId: creatorId,
            creatorName: moment.authorName,
          ),
        ),
      );
      return;
    }

    // 角色貼文：維持原本前往角色檔案的行為。
    await CharacterNavigator.open(
      context,
      characterId: moment.authorId,
      fallbackName: moment.authorName,
    );
  }

  // ✨ 新增：大廳右上角的三條線綜合選單
  Future<void> _showMoreMenuSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 頂部把手與標題
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(l10n.more_options,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),

              // 📝 選項 1：發布新動態 (最常用，放最上面)
              ListTile(
                leading: const Icon(Icons.add_circle_outline,
                    color: Colors.blueAccent),
                title: Text(l10n.moment_create_title,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context); // 先關閉選單
                  _showAuthorSelectionSheet(); // 呼叫妳原本的發文選單
                },
              ),

              // ⏰ 選項 2：排程管家
              ListTile(
                leading:
                    const Icon(Icons.access_alarm, color: Colors.pinkAccent),
                title: Text(l10n.character_post_schedule),
                onTap: () {
                  Navigator.pop(context);
                  _showAutoPostManager(context); // 呼叫妳原本的排程管家
                },
              ),

              const Divider(),

              // ❤️ 選項 3：按讚過的內容
              ListTile(
                leading:
                    const Icon(Icons.eco_outlined, color: Color(0xFFAED581)),
                title: Text(l10n.liked_content),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context); // 關閉底部選單
                  // 🚀 跳轉到互動紀錄牆，並預設打開「按讚(0)」分頁
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const InteractionHistoryPage(initialIndex: 0),
                      ));
                },
              ),

              // 🔖 選項 4：收藏內容
              ListTile(
                leading:
                    const Icon(Icons.park_outlined, color: Color(0xFFA1887F)),
                title: Text(l10n.my_favorites),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context); // 關閉底部選單
                  // 🚀 跳轉到互動紀錄牆，並預設打開「收藏(1)」分頁
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const InteractionHistoryPage(initialIndex: 1),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_off_outlined,
                    color: Colors.blueGrey),
                // ✨ 替換：隱藏的動態 (拿掉 const)
                title: Text(l10n.hidden_moments),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HiddenMomentsPage(),
                    ),
                  ).then((_) {
                    if (!mounted) return;
                    setState(() {
                      _feedReloadKey++;
                    });
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // ✨✨✨ 升級版：身分選擇選單 (加入創作者選項)
  Future<void> _showAuthorSelectionSheet() async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;
    // 1. 先去資料庫抓「創作者本人」的暱稱和頭像
    String creatorName = l10n.creator_self;
    String creatorAvatar = '';
    try {
      final doc = await _db.collection('users').doc(_userId).get();
      if (doc.exists && doc.data() != null) {
        creatorName = doc.data()!['nickname'] ?? creatorName;
        creatorAvatar = doc.data()!['avatarPath'] ?? creatorAvatar;
      }
    } catch (e) {
      print("讀取創作者資料失敗: $e");
    }

    // 2. 抓取角色列表
    final myCharacters = await _fetchMyCharacters();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(l10n.post_identity_prompt,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // ✨ 選項 A：創作者本人
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: getAvatarImageProvider(
                          creatorAvatar,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      title: Text(creatorName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                      subtitle: Text(l10n.identity_creator),
                      trailing:
                          const Icon(Icons.edit_document, color: Colors.blue),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateMomentPage(
                                authorId: 'creator_$_userId', // 標記為創作者 ID
                                authorName: creatorName,
                                authorAvatar: creatorAvatar,
                                isCreatorPost: true, // 🌟 告訴打字房：這是一篇創作者貼文！
                              ),
                            ));
                      },
                    ),
                    const Divider(),
                    // ✨ 選項 B：妳的專屬角色們
                    ...myCharacters.map((character) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: getAvatarImageProvider(
                              character.avatarPath), // 確認妳有這個 helper 函式
                        ),
                        title: Text(character.name),
                        subtitle: Text(l10n.identity_character),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateMomentPage(
                                  authorId: character.id,
                                  authorName: character.name,
                                  authorAvatar: character.avatarPath,
                                  isCreatorPost: false, // 🌟 告訴打字房：這是一篇角色貼文
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ⏰✨✨ 新增：排程管家底部選單
  void _showAutoPostManager(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String _appId = AppConfig.appId;
    if (_userId == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(l10n.decide_post_time_prompt,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.auto_post_schedule_hint,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const Divider(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('artifacts')
                      .doc(AppConfig.appId)
                      .collection('public_characters')
                      // 💡 如果妳連私有角色也要排程，未來這裡可能要改用 FutureBuilder 呼叫 _fetchMyCharacters()
                      .where('createdBy', isEqualTo: _userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text(l10n.no_characters_created_yet));
                    }

                    final characters = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final doc = characters[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final String name =
                            data['name'] ?? l10n.unknownCharacter;
                        final String avatar = data['avatarPath'] ??
                            'assets/images/blank_avatar.png';

                        final bool isEnabled = data['autoPostEnabled'] ?? false;
                        // 🌟 新增：讀取小時與分鐘 (預設 15:00)
                        final int postHour = data['autoPostHour'] ?? 15;
                        final int postMinute = data['autoPostMinute'] ?? 0;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      getAvatarImageProvider(avatar),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),

                                      // 🌟 雙重下拉選單 (小時 : 分鐘)
                                      Row(
                                        children: [
                                          // 🕒 小時選單
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton<int>(
                                              value: postHour,
                                              isDense: true,
                                              items: List.generate(24, (i) {
                                                return DropdownMenuItem(
                                                  value: i,
                                                  child: Text(
                                                      l10n.time_hour(i
                                                          .toString()
                                                          .padLeft(2, '0')),
                                                      style: const TextStyle(
                                                          fontSize: 13)),
                                                );
                                              }),
                                              onChanged: isEnabled
                                                  ? (newHour) {
                                                      doc.reference.update({
                                                        'autoPostHour': newHour
                                                      });
                                                    }
                                                  : null,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Text(':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          // 🕒 分鐘選單 (優化版：每 5 分鐘一跳)
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton<int>(
                                              value:
                                                  postMinute, // 確保資料庫讀出來的值是 5 的倍數，否則會報錯
                                              isDense: true,
                                              // 12 個選項，每個乘以 5 (0, 5, 10, ..., 55)
                                              items: List.generate(12, (index) {
                                                int minuteValue = index * 5;
                                                return DropdownMenuItem(
                                                  value: minuteValue,
                                                  child: Text(
                                                      l10n.time_minute(
                                                          minuteValue
                                                              .toString()
                                                              .padLeft(2, '0')),
                                                      style: const TextStyle(
                                                          fontSize: 13)),
                                                );
                                              }),
                                              onChanged: isEnabled
                                                  ? (newMinute) {
                                                      doc.reference.update({
                                                        'autoPostMinute':
                                                            newMinute
                                                      });
                                                    }
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // 開關
                                Switch(
                                  value: isEnabled,
                                  activeThumbColor: Colors.pinkAccent,
                                  onChanged: (bool newValue) {
                                    doc.reference
                                        .update({'autoPostEnabled': newValue});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ✨ 這是具備「記憶力」且「不會報錯」的動態牆組件
class PersistentFeed extends StatefulWidget {
  final List<String> friendIds;
  final List<String> followedCreatorIds;
  final bool isPublicTab;
  final String userId;
  final String appId;
  final Future<void> Function(
    Moment moment,
  ) onLikeTapped;
  final Function(String) onDeleteTapped;
  final Function(Moment) onAvatarTapped;
  final Function(Moment) onEditTapped;
  final bool showFeatureTips;
  final int pauseMomentCardTipsSignal;
  final int resumeMomentCardTipsSignal;
  const PersistentFeed({
    super.key,
    required this.friendIds,
    required this.followedCreatorIds,
    required this.isPublicTab,
    required this.userId,
    required this.appId,
    required this.onLikeTapped,
    required this.onDeleteTapped,
    required this.onAvatarTapped,
    required this.onEditTapped,
    required this.pauseMomentCardTipsSignal,
    required this.resumeMomentCardTipsSignal,
    this.showFeatureTips = false,
  });

  @override
  State<PersistentFeed> createState() => _PersistentFeedState();
}

class _PersistentFeedState extends State<PersistentFeed>
    with AutomaticKeepAliveClientMixin {
  late Stream<QuerySnapshot> _momentsStream;
  final Set<String> _preloadedMomentImages = {};
  final Set<String> _hiddenMomentIds = {};
  final Set<String> _blockedCharacterIds = {};
  bool _isLoadingBlockedData = true;
  bool _momentFeatureTipsPaused = false;
  StreamSubscription<QuerySnapshot>? _hiddenMomentsSub;
  StreamSubscription<QuerySnapshot>? _blockedCharactersSub;

  bool _hiddenMomentsLoaded = false;
  bool _blockedCharactersLoaded = false;

  // 探索頁只載入最新 50 篇，避免一次讀取整個公開動態牆；
  // 專屬頁則必須讀取完整貼文後再依好友角色篩選，避免很久沒發文的
  // 好友角色被全站最新 50 篇擠掉。
  Stream<QuerySnapshot> _createMomentsStream() {
    Query query = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(widget.appId)
        .collection('moments')
        .orderBy('createdAt', descending: true);

    if (widget.isPublicTab) {
      query = query.limit(50);
    }

    return query.snapshots();
  }

  @override
  void initState() {
    super.initState();

    _momentsStream = _createMomentsStream();

    _listenBlockedData();
  }

  @override
  void dispose() {
    _hiddenMomentsSub?.cancel();
    _blockedCharactersSub?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PersistentFeed oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pauseMomentCardTipsSignal !=
        widget.pauseMomentCardTipsSignal) {
      if (!_momentFeatureTipsPaused && mounted) {
        setState(() {
          _momentFeatureTipsPaused = true;
        });
      }
    }

    if (oldWidget.resumeMomentCardTipsSignal !=
        widget.resumeMomentCardTipsSignal) {
      if (_momentFeatureTipsPaused && mounted) {
        setState(() {
          _momentFeatureTipsPaused = false;
        });
      }
    }
  }

  void _precacheVisibleMoments(
    BuildContext context,
    List<Moment> moments,
  ) {
    for (final moment in moments.take(4)) {
      final urls = <String>[
        moment.authorAvatar,
        moment.imageUrl ?? '',
      ];

      for (final rawUrl in urls) {
        final url = rawUrl.trim();

        if (url.isEmpty ||
            !url.startsWith('http') ||
            _preloadedMomentImages.contains(url)) {
          continue;
        }

        _preloadedMomentImages.add(url);

        precacheImage(
          CachedNetworkImageProvider(url),
          context,
        ).catchError((error) {
          _preloadedMomentImages.remove(url);
          debugPrint('預載動態圖片失敗：$url，$error');
        });
      }
    }
  }

  void _listenBlockedData() {
    _hiddenMomentsSub = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('hiddenMoments')
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;

      setState(() {
        _hiddenMomentIds
          ..clear()
          ..addAll(snapshot.docs.map((doc) => doc.id));

        _hiddenMomentsLoaded = true;
        _isLoadingBlockedData =
            !(_hiddenMomentsLoaded && _blockedCharactersLoaded);
      });
    }, onError: (e) {
      debugPrint('監聽隱藏動態失敗: $e');

      if (!mounted) return;

      setState(() {
        _hiddenMomentsLoaded = true;
        _isLoadingBlockedData =
            !(_hiddenMomentsLoaded && _blockedCharactersLoaded);
      });
    });

    _blockedCharactersSub = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blockedCharacters')
        .snapshots()
        .listen(
      (snapshot) {
        if (!mounted) return;

        setState(() {
          _blockedCharacterIds
            ..clear()
            ..addAll(
              snapshot.docs.map(
                (doc) => doc.id,
              ),
            );

          _blockedCharactersLoaded = true;

          _isLoadingBlockedData =
              !(_hiddenMomentsLoaded && _blockedCharactersLoaded);
        });
      },
      onError: (e) {
        debugPrint(
          '監聽封鎖角色失敗: $e',
        );

        if (!mounted) return;

        setState(() {
          _blockedCharactersLoaded = true;

          _isLoadingBlockedData =
              !(_hiddenMomentsLoaded && _blockedCharactersLoaded);
        });
      },
    );
  }

  Future<void> _hideMoment(Moment moment) async {
    final l10n = AppLocalizations.of(context)!;

    final bool confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.hide_moment_title), // ✨ 替換
            content: Text(l10n.hide_moment_content), // ✨ 替換
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.hide), // ✨ 替換
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('hiddenMoments')
          .doc(moment.id)
          .set({
        'momentId': moment.id,
        'authorId': moment.authorId,
        'authorName': moment.authorName,
        'authorAvatar': moment.authorAvatar,
        'content': moment.content,
        'imageUrl': moment.imageUrl,
        'hiddenAt': FieldValue.serverTimestamp(),
        'source': 'moments',
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        _hiddenMomentIds.add(moment.id);
      });

      ToastUtils.showCenterToast(
        context,
        l10n.hide_moment_success, // ✨ 替換
        customIcon: Icons.visibility_off_outlined,
      );
    } catch (e) {
      debugPrint('隱藏動態失敗: $e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.hide_moment_failed, // ✨ 替換
        customIcon: Icons.error_outline_rounded,
      );
    }
  }

  Future<void> _blockMomentCharacter(Moment moment) async {
    final l10n = AppLocalizations.of(context)!;

    if (moment.authorId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.block_character_not_found, // ✨ 替換
        customIcon: Icons.info_outline_rounded,
      );
      return;
    }

    final bool confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.block_character_title), // ✨ 替換
            content: Text(
              l10n.block_character_content(moment.authorName), // ✨ 替換：帶入角色名稱參數
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  l10n.block,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      final blockedCharacterRef = db
          .collection('users')
          .doc(widget.userId)
          .collection('characters')
          .doc(moment.authorId);

      batch.set(
          blockedCharacterRef,
          {
            'name': moment.authorName,
            'avatar': moment.authorAvatar,
            'isBlocked': true,
            'blockedAt': FieldValue.serverTimestamp(),
            'desc': '',
            'blockedFrom': 'moments',
            'relatedMomentId': moment.id,
          },
          SetOptions(merge: true));

      final alertRef = db.collection('moderationAlerts').doc();

      batch.set(alertRef, {
        'type': 'block_character',
        'blockerUid': widget.userId,
        'blockedCharacterId': moment.authorId,
        'blockedCharacterName': moment.authorName,
        'relatedType': 'moment',
        'relatedMomentId': moment.id,
        'createdBy': moment.createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      await batch.commit();

      if (!mounted) return;

      setState(() {
        _blockedCharacterIds.add(moment.authorId);
      });

      ToastUtils.showCenterToast(
        context,
        l10n.block_character_success(moment.authorName), // ✨ 替換：帶入角色名稱參數
        customIcon: Icons.block_rounded,
      );
    } catch (e) {
      debugPrint('封鎖角色失敗: $e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.block_character_failed, // ✨ 替換
        customIcon: Icons.error_outline_rounded,
      );
    }
  }

  @override
  bool get wantKeepAlive => true; // 🌟 保命符：確保切換分頁或退回時不重刷

  @override
  Widget build(BuildContext context) {
    super.build(context); // 🌟 必須呼叫，否則保命符無效

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _momentsStream = _createMomentsStream();
        });

        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: _momentsStream, // 💡 修正 4：改用綁定好的 _momentsStream
        builder: (context, momentSnapshot) {
          if (_isLoadingBlockedData ||
              momentSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!momentSnapshot.hasData || momentSnapshot.data!.docs.isEmpty) {
            return _buildEmpty();
          }

          final allMoments = momentSnapshot.data!.docs
              .map((doc) => Moment.fromFirestore(doc))
              .toList();

          final filteredMoments = allMoments.where((m) {
            // 隱藏單篇動態：只隱藏這一篇
            if (_hiddenMomentIds.contains(m.id)) {
              return false;
            }

            // 封鎖角色：這個角色的所有動態都不顯示
            if (_blockedCharacterIds.contains(m.authorId)) {
              return false;
            }

            if (widget.isPublicTab) {
              return m.isPublic == true;
            } else {
              final bool isFriendCharacter =
                  widget.friendIds.contains(m.authorId);

              final bool isFollowedCreatorPost = m.isCreatorPost &&
                  m.isPublic == true &&
                  widget.followedCreatorIds.contains(m.createdBy);

              final bool isMyPost = m.createdBy == widget.userId;

              return isFriendCharacter || isFollowedCreatorPost || isMyPost;
            }
          }).toList();

          if (filteredMoments.isEmpty) return _buildEmpty();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            _precacheVisibleMoments(
              context,
              filteredMoments,
            );
          });

          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredMoments.length,
              itemBuilder: (context, index) {
                final moment = filteredMoments[index];

                return MomentCard(
                  moment: moment,
                  currentUserId: widget.userId,
                  showFeatureTips: index == 0 &&
                      widget.showFeatureTips &&
                      !_momentFeatureTipsPaused,
                  onLikeTapped: () async {
                    await widget.onLikeTapped(moment);
                  },
                  onDeleteTapped: () => widget.onDeleteTapped(moment.id),
                  onAvatarTapped: () => widget.onAvatarTapped(moment),
                  onEditTapped: () => widget.onEditTapped(moment),
                  onHideMomentTapped: () => _hideMoment(moment),
                  onBlockCharacterTapped: () => _blockMomentCharacter(moment),
                );
              });
        },
      ),
    );
  }

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
        child: Text(widget.isPublicTab
            ? l10n.empty_public_moments_short
            : l10n.empty_private_moments_short));
  }
}

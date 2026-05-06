import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_notifier.dart';
import '../models/moment_model.dart';
import 'character_model.dart';
import 'create_moment_page.dart';
import 'moment_card.dart';
import '../utils/image_utils.dart';
import 'package:intl/intl.dart';
import '../page/interaction_history_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'character_profile_page.dart';
//動態牆(朋友圈)
class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});
  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  String? _nickname;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId = FirebaseAuth.instance.currentUser?.uid;
  // 🌟 總裁指示：這裡也要對齊總部 AppConfig，不要再用環境變數了！
  final String _appId = AppConfig.appId;
  int _likeProgress = 0;
  bool _isLikeClaimed = false;
  late Stream<QuerySnapshot> _friendsStream;
  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    _loadDailyTaskProgress();

    // ✨ 關鍵：在這裡就先連好線！這樣 build 跑幾次，連線都不會中斷
    if (_userId != null) {
      _friendsStream = _db.collection('users').doc(_userId!).collection('friends').snapshots();
    }
  }


  Future<void> _handleLikeTaskProgress(Moment moment) async {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return;
    setState(() {
      _likeProgress++;
    });
    final userDocRef = _db.collection('users').doc(_userId);

    try {
      // 1. 雲端記帳：幫按讚次數 +1
      await userDocRef.update({
        'dailyTasks.likeProgress': FieldValue.increment(1),
      });
      // 使用妳剛定義好的 moment.createdBy 找出這篇貼文的「親媽」
        final String recipientId = moment.createdBy;

        if (recipientId.isNotEmpty && recipientId != _userId) {

          // ✨ 總裁關鍵判斷：決定信件內容
          String mailBody;
          if (moment.isCreatorPost) {
            // 💡 狀況 A：對方按讚的是妳本人發的動態
            mailBody = l10n.moment_like_self(_nickname ?? "某位朋友");
          } else {
            // 💡 狀況 B：對方按讚的是妳創造的「角色」動態
            // 這裡會抓取 moment.authorName (例如：程宇)
            mailBody = l10n.moment_like_other(_nickname ?? "某位朋友", moment.authorName);
          }

          await _sendNotificationLetter(
            recipientId: recipientId,
            postId: moment.id,
            type: 'like',
            senderName: _nickname ?? l10n.friend_unknown,
            body: mailBody,
          );
        }

      await _loadDailyTaskProgress();
      // 3. 檢查是否達標 (目標 3 次)
      if (_likeProgress == 3 && !_isLikeClaimed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.task_social_tour_complete),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('更新按讚進度失敗: $e');
    }
  }
  Future<void> _loadDailyTaskProgress() async {
    if (_userId == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();
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
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: themeNotifier.currentBackground,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title:Text(l10n.wall_title_shiguang),
                pinned: true,
                floating: true,
                snap: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                forceElevated: innerBoxIsScrolled,
                // ✨ 2. 切換選單 (TabBar)
                bottom: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                  tabs: [
                    Tab(text: l10n.wall_tab_explore),
                    Tab(text: l10n.wall_tab_exclusive),
                  ],
                ),
                // ✨ 三條線選單
                actions: [
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28), // 🍔 三條線圖示
                    tooltip: l10n.more_options,
                    onPressed: () => _showMoreMenuSheet(context),
                  ),
                ],
              ),
            ];
          },
          // ✨ 3. body 負責去抓好友名單，然後分配給兩個分頁
          body: _buildBodyWithFriendsStream(),
        ),
      ),
    );
  }

  // ✨ 負責抓取好友名單，並顯示兩個分頁的內容
  Widget _buildBodyWithFriendsStream() {
    final l10n = AppLocalizations.of(context)!;
    if (_userId == null) return Center(child: Text(l10n.please_login_first));

    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('users').doc(_userId!).collection('friends').snapshots(),
      builder: (context, friendSnapshot) {
        if (friendSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final friendIds = friendSnapshot.data?.docs.map((doc) => doc.id).toList() ?? [];
        friendIds.add(_userId!); // 把自己也加進去名單

        // ✨ 修正：把重複的 return 刪掉，結構更清爽
        return TabBarView(
          children: [
            PersistentFeed(
              friendIds: friendIds,
              isPublicTab: true,
              userId: _userId!,
              appId: _appId,
              onLikeTapped: _handleLikeTaskProgress,
              onDeleteTapped: _deleteMoment,
              onAvatarTapped: _navigateToCharacterProfile, // ✨ 交出跳轉指令！
            ),
            PersistentFeed(
              friendIds: friendIds,
              isPublicTab: false,
              userId: _userId!,
              appId: _appId,
              onLikeTapped: _handleLikeTaskProgress,
              onDeleteTapped: _deleteMoment,
              onAvatarTapped: _navigateToCharacterProfile, // ✨ 交出跳轉指令！
            ),
          ],
        );
      },
    );
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
          content:  Text(l10n.delete_warning),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.action_confirm_delete, style: TextStyle(color: Colors.red))
            ),
          ],
        ),
      ) ?? false;

      if (confirm) {
        await _db
            .collection('artifacts')
            .doc(_appId)
            .collection('moments')
            .doc(momentId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.delete_success))
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
          .collection('mailbox') // 🌟 注意：要跟妳的信箱頁面讀取的資料夾名稱一致喔！
          .add({
        'type': type,
        'fromId': _userId,
        'title': type == 'like' ? l10n.moment_notification_new_like : l10n.notification_new_comment,
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
          Icon(isPublicTab ? Icons.public : Icons.people_alt, size: 50, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            isPublicTab ? l10n.empty_public_moments_prompt : l10n.empty_private_moments_prompt,
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
        _db.collection('artifacts').doc(_appId).collection('public_characters').where('createdBy', isEqualTo: _userId).get(),
        _db.collection('artifacts').doc(_appId).collection('users').doc(_userId!).collection('private_characters').get(),
      ]);

      // 2. ✨ 關鍵：使用 Future.wait 讓所有角色同時進行「圖片網址變身」
      // 我們先分別處理公開與私藏的清單
      final publicChars = await Future.wait(
          responses[0].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      final privateChars = await Future.wait(
          responses[1].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

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
  Future<void> _navigateToCharacterProfile(Moment moment) async {
    final l10n = AppLocalizations.of(context)!;
    // 1. 如果是創作者本人發的文，目前沒有檔案頁，直接跳過
    if (moment.isCreatorPost) return;

    // 2. 顯示讀取中，避免網路慢時玩家點好幾次
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 3. 去公開區撈看看這個角色還在不在
      final doc = await _db
          .collection('artifacts')
          .doc(_appId)
          .collection('public_characters')
          .doc(moment.authorId)
          .get();

      if (mounted) {
        Navigator.pop(context); // 關閉讀取圈圈
      }

      if (doc.exists) {
        // ✨✨✨ 狀況 A：找到角色了！
        // 把資料夾檔案「解壓縮」成完整的 Character 物件
        final character = await Character.fromFirestoreAsync(doc);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterProfilePage(
                character: character,               // 👈 交出角色詳細資料
                characterId: moment.authorId,       // 👈 補上剛才漏交的身分證號碼！
              ),
            ),
          );
        }
      } else {
        // 🔒🔒🔒 狀況 B：找不到角色 (轉私人或已刪除),直接在這裡彈出一個「機密檔案」的絕美彈窗卡片！
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children:  [
                  Icon(Icons.lock_outline, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(l10n.chat_secret_file_title, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 加上半透明黑底的神秘頭像
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: getAvatarImageProvider(moment.authorAvatar),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5), // 神秘的暗色遮罩
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    moment.authorName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                   Text(
                    l10n.profile_archived_or_deleted_message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:Text(l10n.leave_silently, style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("❌ 跳轉角色檔案失敗: $e");
    }
  }

    // ✨ 新增：大廳右上角的三條線綜合選單
    void _showMoreMenuSheet(BuildContext context) {
      final l10n = AppLocalizations.of(context)!;
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 頂部把手與標題
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 4, width: 40,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
                ),
                 Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(l10n.more_options, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),

                // 📝 選項 1：發布新動態 (最常用，放最上面)
                ListTile(
                  leading: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
                  title: Text(l10n.moment_create_title, style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context); // 先關閉選單
                    _showAuthorSelectionSheet(); // 呼叫妳原本的發文選單
                  },
                ),

                // ⏰ 選項 2：排程管家
                ListTile(
                  leading: const Icon(Icons.access_alarm, color: Colors.pinkAccent),
                  title:Text(l10n.character_post_schedule),
                  onTap: () {
                    Navigator.pop(context);
                    _showAutoPostManager(context); // 呼叫妳原本的排程管家
                  },
                ),

                const Divider(),

                // ❤️ 選項 3：按讚過的內容
                ListTile(
                  leading: const Icon(Icons.favorite_border, color: Colors.redAccent),
                  title: Text(l10n.liked_content),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context); // 關閉底部選單
                    // 🚀 跳轉到互動紀錄牆，並預設打開「按讚(0)」分頁
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const InteractionHistoryPage(initialIndex: 0),
                    ));
                  },
                ),

                // 🔖 選項 4：收藏內容
                ListTile(
                  leading: const Icon(Icons.bookmark_border, color: Colors.orangeAccent),
                  title:Text(l10n.my_favorites),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context); // 關閉底部選單
                    // 🚀 跳轉到互動紀錄牆，並預設打開「收藏(1)」分頁
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const InteractionHistoryPage(initialIndex: 1),
                    ));
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
                child: Text(l10n.post_identity_prompt, style: Theme.of(context).textTheme.titleLarge),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // ✨ 選項 A：創作者本人
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: creatorAvatar.isNotEmpty
                            ? (creatorAvatar.startsWith('http') ? NetworkImage(creatorAvatar) : AssetImage(creatorAvatar) as ImageProvider)
                            : const AssetImage('assets/images/blank_avatar.png'),
                        backgroundColor: Colors.blue[100],
                      ),
                      title: Text(creatorName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      subtitle:Text(l10n.identity_creator),
                      trailing: const Icon(Icons.edit_document, color: Colors.blue),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
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
                          backgroundImage: getAvatarImageProvider(character.avatarPath), // 確認妳有這個 helper 函式
                        ),
                        title: Text(character.name),
                        subtitle: Text(l10n.identity_character),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
               Text(l10n.decide_post_time_prompt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      return Center(child: Text(l10n.no_characters_created_yet));
                    }

                    final characters = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        final doc = characters[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final String name = data['name'] ?? l10n.unknownCharacter;
                        final String avatar = data['avatarPath'] ?? 'assets/images/blank_avatar.png';

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
                                  backgroundImage: avatar.startsWith('http')
                                      ? NetworkImage(avatar)
                                      : AssetImage(avatar) as ImageProvider,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

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
                                                  child: Text(l10n.time_hour(i.toString().padLeft(2, '0')), style: const TextStyle(fontSize: 13)),
                                                );
                                              }),
                                              onChanged: isEnabled ? (newHour) {
                                                doc.reference.update({'autoPostHour': newHour});
                                              } : null,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          // 🕒 分鐘選單 (優化版：每 5 分鐘一跳)
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton<int>(
                                              value: postMinute, // 確保資料庫讀出來的值是 5 的倍數，否則會報錯
                                              isDense: true,
                                              // 12 個選項，每個乘以 5 (0, 5, 10, ..., 55)
                                              items: List.generate(12, (index) {
                                                int minuteValue = index * 5;
                                                return DropdownMenuItem(
                                                  value: minuteValue,
                                                  child: Text(l10n.time_minute(minuteValue.toString().padLeft(2, '0')), style: const TextStyle(fontSize: 13)),
                                                );
                                              }),
                                              onChanged: isEnabled ? (newMinute) {
                                                doc.reference.update({'autoPostMinute': newMinute});
                                              } : null,
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
                                  activeColor: Colors.pinkAccent,
                                  onChanged: (bool newValue) {
                                    doc.reference.update({'autoPostEnabled': newValue});
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
  final bool isPublicTab;
  final String userId;
  final String appId;
  final Function(Moment) onLikeTapped;
  final Function(String) onDeleteTapped;
  final Function(Moment) onAvatarTapped; // ✨ 新增：把跳轉功能傳進來

  const PersistentFeed({
    super.key,
    required this.friendIds,
    required this.isPublicTab,
    required this.userId,
    required this.appId,
    required this.onLikeTapped,
    required this.onDeleteTapped,
    required this.onAvatarTapped, // 👈 這裡也要必填
  });

  @override
  State<PersistentFeed> createState() => _PersistentFeedState();
}
class _PersistentFeedState extends State<PersistentFeed> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 🌟 保命符：確保切換分頁或退回時不重刷

  @override
  Widget build(BuildContext context) {
    super.build(context); // 🌟 必須呼叫，否則保命符無效

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('artifacts')
            .doc(widget.appId)
            .collection('moments')
            .orderBy('createdAt', descending: true)
            .limit(50)
            .snapshots(),
        builder: (context, momentSnapshot) {
          if (momentSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!momentSnapshot.hasData || momentSnapshot.data!.docs.isEmpty) {
            return _buildEmpty();
          }

          final allMoments = momentSnapshot.data!.docs
              .map((doc) => Moment.fromFirestore(doc))
              .toList();

          final filteredMoments = allMoments.where((m) {
            if (widget.isPublicTab) {
              return m.isPublic == true;
            } else {
              return widget.friendIds.contains(m.authorId) || m.createdBy == widget.userId;
            }
          }).toList();

          if (filteredMoments.isEmpty) return _buildEmpty();

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredMoments.length,
            itemBuilder: (context, index) {
              final moment = filteredMoments[index];
              return MomentCard(
                moment: moment,
                currentUserId: widget.userId,
                onLikeTapped: () => widget.onLikeTapped(moment),
                onDeleteTapped: () => widget.onDeleteTapped(moment.id),
                // ✨ 這裡最重要：直接執行從爸爸那裡傳過來的指令！
                onAvatarTapped: () => widget.onAvatarTapped(moment),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(child: Text(widget.isPublicTab ? l10n.empty_public_moments_short : l10n.empty_private_moments_short));
  }
}
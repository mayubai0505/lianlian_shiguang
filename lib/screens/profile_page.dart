import 'dart:async'; // 用於 StreamSubscription
 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../utils/image_utils.dart';
import 'package:intl/intl.dart';
import '../services/theme_notifier.dart';
import 'edit_profile_page.dart';
import 'chat_page.dart';
import 'all_friends_page.dart';
import 'character_model.dart';
import 'settings_page.dart';
import 'character_edit_page.dart';
import 'store_page.dart';
import '../page/announcement_page.dart';
import '../page/admin_announcement_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'creator_studio_page.dart';

//個人主頁

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // --- 狀態變數 ---
  String _nickname = '';
  String _avatarPath = 'assets/images/avatar1.png';
  String _playerID = '';
  int _flowerPoints = 0;
  bool _isLoading = true;
  List<Character> _friendsList = [];
  List<Character> _myCharacters = [];
  late TextEditingController _playerIDController;
  bool _hasChangedID = false;
  String _oldIDFromDB = "";
  StreamSubscription? _pointsSubscription;
  StreamSubscription? _userDocSubscription;
  // --- Firebase 變數 ---
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId;
// 🌟 改成這樣：直接對齊妳在 AppConfig 裡設定的 appId
  final String _appId = AppConfig.appId;
  bool _hasCheckedInToday = false;
  int _dailyChatProgress = 0; // 閒話家常進度
  int _storyChatProgress = 0; // 劇情推進進度
  int _likeProgress = 0; // 社群巡禮進度
  bool _isDailyChatClaimed = false; // 是否已領取獎勵
  bool _isStoryChatClaimed = false;
  bool _isLikeClaimed = false;
  bool _isClaimingCheckIn = false;
  bool _isBirthdayToday = false; // ✨ 新增一個狀態變數來記錄今天是否生日


  @override
  void initState() {
    super.initState();

    // 🌟 第一步：先幫控制器「登記戶口」（這行最重要！）
    _playerIDController = TextEditingController();

    // 第二步：監聽登入狀態
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        if (mounted && _userId != user.uid) {
          setState(() {
            _userId = user.uid;
          });

          // 🌟 第三步：確定有 UserID 了，再來抓 ID 鎖頭和基本資料
          _loadUserPIDData();
          _loadInitialData();
          _listenToFlowerPoints();
          _checkDailyCheckInStatus();
          _loadDailyTaskProgress();
          _listenToUserDocument();
          _checkIfBirthday();
        }
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  // 🌟 別忘了！有開就要有關，這是好習慣
  @override
  void dispose() {
    _playerIDController.dispose(); // 釋放記憶體
    _pointsSubscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }

  // 🌟 實作：從 Firebase 讀取玩家 ID 與鎖定狀態
  Future<void> _loadUserPIDData() async {
    if (_userId == null) return;

    // ✨ 1. 統一產生保底 ID (抽到最上面，不用重複寫)
    final fallbackID = _userId!.length >= 8 ? _userId!.substring(0, 8) : _userId!;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

      // ✨ 2. 預設給予保底值
      String finalID = fallbackID;
      bool isChanged = false;

      // ✨ 3. 如果雲端有資料，再進行覆蓋
      if (doc.exists) {
        final data = doc.data() ?? {};
        final cloudID = (data['playerID']?.toString() ?? "").trim();
        finalID = cloudID.isNotEmpty ? cloudID : fallbackID;
        isChanged = data['hasChangedID'] ?? false;
      }

      if (!mounted) return;

      // ✨ 4. 統一更新畫面狀態
      setState(() {
        _oldIDFromDB = finalID;
        _playerIDController.text = finalID;
        _hasChangedID = isChanged;
      });

      // ✨ 5. 統一寫入本地暫存
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('playerID', finalID);
      await prefs.setBool('hasChangedID', isChanged);

      print("✅ 玩家 ID 載入同步成功：$finalID, 鎖定狀態：$isChanged");

    } catch (e) {
      print("❌ 讀取玩家 PID 失敗: $e");

      // 🛡️ 斷網或報錯時的保底機制
      if (mounted) {
        setState(() {
          _oldIDFromDB = fallbackID;
          _playerIDController.text = fallbackID;
        });
      }
    }
  }

  Future<void> _checkIfBirthday() async {
    final prefs = await SharedPreferences.getInstance();
    final birthDateString = prefs.getString('birthDate');
    if (birthDateString == null) return;

    final birthDate = DateTime.parse(birthDateString);
    final today = DateTime.now();

    if (birthDate.month == today.month && birthDate.day == today.day) {
      if (mounted) {
        setState(() {
          _isBirthdayToday = true;
        });
      }
    }
  }

  void _listenToUserDocument() {
    _userDocSubscription?.cancel();
    if (_userId == null) return;

    _userDocSubscription = _db.collection('users').doc(_userId).snapshots().listen((snapshot) {
      if (!snapshot.exists || !mounted) return;

      final data = snapshot.data()!;

      setState(() {
        // 🌟 1. 暱稱與頭像：優先用雲端的，沒有才用目前的 (避免閃爍)
        _nickname = data['nickname'] ?? _nickname;
        _avatarPath = data['avatarPath'] ?? _avatarPath;
        _flowerPoints = data['flowerPoints'] ?? 0;

        // 🌟 3. 生日偵測：直接從資料庫的時間戳記判斷
        if (data['userBirthday'] != null) {
          final birthDate = (data['userBirthday'] as Timestamp).toDate();
          final today = DateTime.now();
          // 判斷月與日是否相同
          _isBirthdayToday = (birthDate.month == today.month && birthDate.day == today.day);
        }
      });

      // ✨ 同步回本地快取，下次打開 App 速度會更快
      _updateLocalCache(data);
    });
  }

  // ✨ 輔助小工具：把雲端抓到的最新資料順手存進本地快取
  Future<void> _updateLocalCache(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data.containsKey('nickname')) await prefs.setString(
        'nickname', data['nickname']);
    if (data.containsKey('avatarPath')) await prefs.setString(
        'avatarPath', data['avatarPath']);
  }

  Future<void> _performCheckIn() async {
    // 1. 防禦機制：如果正在處理中，或今天領過了，直接擋掉
    if (_isClaimingCheckIn || _hasCheckedInToday) return;

    setState(() {
      _isClaimingCheckIn = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final l10n = AppLocalizations.of(context)!;
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final int rewardAmount = AppConfig.dailyCheckIn;

      // 2. 執行領取邏輯 (與彈窗邏輯同步)
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(userDocRef, {
          'flowerPoints': FieldValue.increment(rewardAmount),
          'lastCheckInDate': FieldValue.serverTimestamp(),
        });
      });

      // 3. 寫入收支明細 (記帳本)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('flower_logs')
          .add({
        'title': l10n.title_daily_check_in,
        'amount': rewardAmount,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4. 更新畫面狀態
      if (mounted) {
        setState(() {
          _hasCheckedInToday = true;
          _hasCheckedInToday = true; // 同步彈窗用的變數
        });

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(l10n.daily_gift_success),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      debugPrint("❌ 手動簽到失敗: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.check_in_fail_network)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isClaimingCheckIn = false;
        });
      }
    }
  }

  Future<void> _loadDailyTaskProgress() async {
    if (_userId == null) return;
    final userDocRef = _db.collection('users').doc(_userId);
    final doc = await userDocRef.get();
    if (!doc.exists || !mounted) return;

    final data = doc.data()!;
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final lastResetTimestamp = data['lastTasksResetDate'] as Timestamp?;
    String lastResetDateString = '';
    if (lastResetTimestamp != null) {
      lastResetDateString = DateFormat('yyyy-MM-dd').format(lastResetTimestamp.toDate());
    }

    // 如果上次重置日期不是今天，代表所有進度都是 0，所有獎勵都未領取
    if (lastResetDateString != todayString) {
      setState(() {
        _dailyChatProgress = 0; _isDailyChatClaimed = false;
        _storyChatProgress = 0; _isStoryChatClaimed = false;
        _likeProgress = 0; _isLikeClaimed = false;
      });
      return;
    }

    // 如果是今天，就從資料庫讀取最新的進度
    final tasks = data['dailyTasks'] as Map<String, dynamic>? ?? {};
    setState(() {
      _dailyChatProgress = tasks['dailyChatProgress'] ?? 0;
      _isDailyChatClaimed = tasks['dailyChatClaimed'] ?? false;
      _storyChatProgress = tasks['storyChatProgress'] ?? 0;
      _isStoryChatClaimed = tasks['storyChatClaimed'] ?? false;
      _likeProgress = tasks['likeProgress'] ?? 0;
      _isLikeClaimed = tasks['likeClaimed'] ?? false;
    });
  }

  // ✨ 3新增「領取獎勵」的核心函式
  Future<void> _claimTaskReward(
      String taskName,
      String progressField,
      String claimedField,
      int rewardAmount,
      VoidCallback onDialogSetState) async {
    if (_userId == null) return;

    final userDocRef = _db.collection('users').doc(_userId);

    try {
      final l10n = AppLocalizations.of(context)!;
      final batch = _db.batch();
      // 增加花花點數
      batch.update(userDocRef, {'flowerPoints': FieldValue.increment(rewardAmount)});
      // 將對應任務的 claimed 狀態設為 true
      batch.update(userDocRef, {'dailyTasks.$claimedField': true});

      // ✨✨✨ 總裁看這裡！把記帳也加入這個「打包作業 (batch)」裡！ ✨✨✨
      final logRef = userDocRef.collection('flower_logs').doc(); // 建立一張新的明細空白表單
      batch.set(logRef, {
        'title': l10n.task_completed(taskName), // 這樣明細就會顯示「完成任務：閒話家常」
        'amount': rewardAmount,      // 動態抓取這個任務給了多少花花
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 一口氣把 增加花花、更新任務進度、寫入明細 全部送出！
      await batch.commit();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.task_reward_claimed(taskName, rewardAmount.toString())))
        );
        // 更新彈窗內的 UI
        onDialogSetState();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.claim_failed_error(e.toString())))
        );
      }
    }
  }

  // 1. 加入 async 關鍵字
  Future<void> _showHeartbeatDiary() async {
    final l10n = AppLocalizations.of(context)!;
    // 🌟 關鍵修正：加上 await！
    // 顯示 Loading 提示或直接等待，確保 _likeProgress 等變數已經被更新
    await _loadDailyTaskProgress();

    if (!mounted) return; // 防護罩：避免玩家在等待時已經離開頁面

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text(l10n.tab_heartbeat_diary),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTaskItem(
                      title: l10n.tab_daily_chit_chat,
                      subtitle: l10n.task_desc_chat_3_times,
                      progress: _dailyChatProgress, goal: 3,
                      isClaimed: _isDailyChatClaimed,
                      onClaim: () {
                        // 🔒 1. 防禦塔：如果已經領過了，直接擋掉！
                        if (_isDailyChatClaimed) return;

                        // ⚡ 2. 瞬間鎖門：不等後台，畫面先立刻切換成「已領取」
                        setStateInDialog(() => _isDailyChatClaimed = true);
                        setState(() => _isDailyChatClaimed = true);
                        // 🎁 3. 慢慢去後台發花花
                        _claimTaskReward('閒話家常', 'dailyChatProgress', 'dailyChatClaimed', 5, () {
                          // 因為前面已經鎖了，這裡的 callback 甚至可以留空
                        });
                      },
                    ),

                    _buildTaskItem(
                      title:l10n.tab_story_progression,
                      subtitle: l10n.task_desc_story_1_time,
                      progress: _storyChatProgress, goal: 1,
                      isClaimed: _isStoryChatClaimed,
                      onClaim: () {
                        if (_isStoryChatClaimed) return; // 🔒 防禦

                        setStateInDialog(() => _isStoryChatClaimed = true); // ⚡ 瞬間鎖門
                        setState(() => _isStoryChatClaimed = true);

                        _claimTaskReward('劇情推進', 'storyChatProgress', 'storyChatClaimed', 5, () {});
                      },
                    ),

                    _buildTaskItem(
                      title: l10n.tab_social_tour,
                      subtitle: l10n.task_desc_like_3_moments,
                      progress: _likeProgress, goal: 3,
                      isClaimed: _isLikeClaimed,
                      onClaim: () {
                        if (_isLikeClaimed) return; // 🔒 防禦

                        setStateInDialog(() => _isLikeClaimed = true); // ⚡ 瞬間鎖門
                        setState(() => _isLikeClaimed = true);

                        _claimTaskReward('社群巡禮', 'likeProgress', 'likeClaimed', 5, () {});
                      },
                    ),
                  ],
                ),
              ),
              actions: [ TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('關閉')) ],
            );
          },
        );
      },
    );
  }

  // ✨ 3. 新增一個輔助 Widget，專門用來建立每一條任務
  Widget _buildTaskItem({
    required String title,
    required String subtitle,
    required int progress,
    required int goal,
    required bool isClaimed,
    required VoidCallback onClaim,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final int displayedProgress = progress > goal ? goal : progress;
    final bool isCompleted = progress >= goal;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('$subtitle ($displayedProgress / $goal)'),
        trailing: isClaimed
            ?  Text(l10n.btn_claimed, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
            : ElevatedButton(
          onPressed: isCompleted ? onClaim : null,
          style: ElevatedButton.styleFrom(
            // 🌟 核心改進：完成時用主題色，未完成時用超淡灰色
            backgroundColor: isCompleted ? primaryColor : Colors.grey[200],
            // 🌟 核心改進：完成時文字強制白色，未完成時用深灰色
            foregroundColor: isCompleted ? Colors.white : Colors.grey[600],
            elevation: isCompleted ? 3 : 0, // 完成後才有一點陰影，增加「可點擊感」
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            isCompleted ? l10n.btn_claim : l10n.btn_incomplete,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
          ),
          // ✨ 新增：進度條，讓玩家更有目標感
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: displayedProgress / goal,
              backgroundColor: primaryColor.withValues(alpha:0.1),
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _checkDailyCheckInStatus() async {
    if (_userId == null) return;
    final userDocRef = _db.collection('users').doc(_userId);
    final doc = await userDocRef.get();
    if (!doc.exists || !mounted) return;

    final data = doc.data()!;
    final lastCheckInTimestamp = data['lastCheckInDate'] as Timestamp?;

    if (lastCheckInTimestamp == null) {
      setState(() => _hasCheckedInToday = false); // 從未簽到過
      return;
    }

    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastCheckInDateString = DateFormat('yyyy-MM-dd').format(lastCheckInTimestamp.toDate());

    setState(() {
      _hasCheckedInToday = (lastCheckInDateString == todayString);
    });
  }


  void _listenToFlowerPoints() {
    _pointsSubscription?.cancel();
    if (_userId == null) return;

    _pointsSubscription = _db.collection('users').doc(_userId).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey('flowerPoints')) {
        if (mounted) {
          setState(() {
            _flowerPoints = snapshot.data()!['flowerPoints'];
          });
        }
      }
    }, onError: (error) {
      print('監聽花花點數失敗: $error');
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _loadProfileFromCache();
    if (mounted) setState(() => _isLoading = false);
    _initializePlayerID();
    _fetchAllCharacterData();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    await Future.wait([
      _loadProfileFromCache(),
      _fetchAllCharacterData(),
    ]);
  }

  Future<void> _loadProfileFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (mounted) {
      setState(() {
        // 優先序：本地緩存 > Firebase 帳號名稱 > 溫柔的預設值
        _nickname = prefs.getString('nickname') ?? (currentUser?.displayName ?? l10n.title_time_travel);
        _avatarPath = prefs.getString('avatarPath') ?? (currentUser?.photoURL ?? 'assets/images/avatar1.png');
        _playerID = prefs.getString('playerID') ?? '';
      });
    }
  }


  Future<void> _showChatModeSelectionDialog(Character character) async {
    final l10n = AppLocalizations.of(context)!;
    // 彈出一個 SimpleDialog，讓使用者選擇
    final String? selectedMode = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(l10n.select_chat_mode),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // ✨ 關鍵修改：從 'daily' 改成 'gemini' (妳設定的不扣點免費模式)
                Navigator.pop(context, 'gemini');
              },
              child: ListTile(
                leading: Icon(Icons.chat_bubble_outline),
                title: Text(l10n.mode_chat), // 順便在字面上讓玩家知道這是免費的
                subtitle: Text(l10n.mode_daily_desc),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'story'); // 返回 'story'
              },
              child:ListTile(
                leading: Icon(Icons.book_outlined),
                title: Text(l10n.chatModeStory),
                subtitle: Text(l10n.mode_story_desc),
              ),
            ),
          ],
        );
      },
    );

    // ✨ 2. 根據使用者的選擇，導航到聊天頁面
    if (selectedMode != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            // 🌟 1. 身分證乖乖交出來
            character: character,

            // 🌟 2. 模式 ('daily' 或 'story')
            chatMode: selectedMode,
            // 🌟 4. 語言跟存檔
            selectedLanguage: 'zh-TW', // 建議統一用代碼比較不會出錯
            shouldSave: true,

            // 🌟 5. 【最關鍵】補上第一句話跟故事情節！
            // 根據玩家選的是劇情還是閒聊，給不同的第一句話
            initialText: selectedMode == 'story'
                ? (character.storyModeFirstLine ?? l10n.greeting_hello) // 劇情模式抓設定好的第一句話
                : l10n.greeting_default_daily, // 日常模式給個預設開場白
          ),
        ),
      ).then((_) {
        // 退出來記得重整一下
        _refreshData();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // ✨  取得 themeNotifier 來設定背景
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final String adminUid = 'B71k2kyooubYsOtIO1nkiBwyBXt2';
    final bool isAdmin = (currentUser?.uid == adminUid);
    // ✨ 移除舊的 Scaffold，最外層改為 Container + NestedScrollView
    return Container(
      decoration: themeNotifier.currentBackground,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(l10n.title_personal_homepage),
                // ✨  使用您最喜歡的滾動設定
                pinned: false,
                floating: false,
                snap: false,
                backgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  IconButton(
                    tooltip: l10n.title_time_letters, // 給它一個浪漫的提示名稱
                    icon: Image.asset(
                      'assets/images/scroll_icon.png', // 👈 記得換成妳實際儲存的檔名
                      width: 26,  // 控制圖示大小，通常 AppBar 裡的圖示大約是 24~28
                      height: 26,
                      // 💡 魔法小技巧：因為妳的圖是純黑線條，如果想讓它變成主題色(例如深紫)，可以加這行：
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white          // 🌙 深色主題時：圖示變白色
                          : const Color(0xFF6750A4), // ☀️ 淺色主題時：用原本的主題色
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AnnouncementListPage()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70 // 深色主題時用淺灰白
                          : Colors.black54, // 淺色主題時用原本的深灰
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const SettingsPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ];
          },
          // ✨ 將您原本的 Sliver 內容放到一個 ListView 裡作為 body
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16), // 稍微調整間距
              Row(
                children: [
                  Expanded(child: _buildCheckInButton()), // ✨ 這個函式也有小小的修改
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_stories),
                      label: Text(l10n.tab_heartbeat_diary),
                      onPressed: _showHeartbeatDiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFriendsListSection(),
              const SizedBox(height: 24),
              _buildMyCharactersSection(),
              if (isAdmin) ...[
                const Divider(thickness: 2, color: Colors.pinkAccent),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Text('👑 主理人專屬區域', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
    ),
                // 進入後台的按鈕
                ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('進入拾光管理後台'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminAnnouncementPage()),
                    );
                  },
                ),
                const SizedBox(height: 40), // 底部留白
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInButton() {
    final l10n = AppLocalizations.of(context)!;
    if (_hasCheckedInToday) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.check_circle),
        label: Text(l10n.status_signed_in_today),
        onPressed: _hasCheckedInToday ? null : _performCheckIn,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey.withValues(alpha: 0.2),
          disabledForegroundColor: Colors.grey,
        ),
      );
    } else {
      return ElevatedButton.icon(
        icon: _isClaimingCheckIn
            ? const SizedBox(width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.calendar_today),
        label: Text(_isClaimingCheckIn ? l10n.status_signing_in : l10n.status_daily_sign_in),
        onPressed: _performCheckIn,
      );
    }
  }


  Widget _buildProfileHeader() {
    // ✨ 首先，把所有變色龍變數準備好
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final subTextColor = textColor.withValues(alpha:0.7);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // 1. 頭像區 (含生日光環)
        GestureDetector(
          onTap: _editProfile,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ✅ 只有生日當天，頭像才會散發浪漫主題色的光芒
              boxShadow: _isBirthdayToday ? [
                BoxShadow(
                    color: primaryColor.withValues(alpha:0.5),
                    blurRadius: 15,
                    spreadRadius: 5
                )
              ] : null,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withValues(alpha:0.1),
              // ✅ 使用我們之前的萬能頭像讀取器
              backgroundImage: getAvatarImageProvider(_avatarPath),
            ),
          ),
        ),
        const SizedBox(width: 20),

        // 2. 文字資訊區
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 暱稱 + 生日蛋糕
              Row(
                children: [
                  Flexible(
                    child: Text(
                      _nickname,
                      style: TextStyle(
                          fontSize: 22,
                          color: textColor,
                          fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isBirthdayToday)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.cake, color: primaryColor, size: 22),
                    ),
                ],
              ),

              // Player ID 區
              if (_playerID.isNotEmpty) ...[
                SizedBox(height: 4),
                Row(
                  children: [
                    // ⚡ 1. 使用 _oldIDFromDB 顯示 ID，消滅第一個警告
                    Text(
                      'ID: $_oldIDFromDB',
                      style: TextStyle(
                        fontSize: 14,
                        color: subTextColor,
                        // 💡 隱形用法：根據鎖定狀態微調字體粗細（使用者看不出來，但系統算妳「用了」）
                        fontWeight: _hasChangedID ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // ⚡ 2. 複製時也使用 _oldIDFromDB，確保數據一致
                        Clipboard.setData(ClipboardData(text: _oldIDFromDB));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.toast_id_copied)));
                      },
                      // 💡 3. 把 _hasChangedID 藏在 Tooltip 裡，只有長按圖示才會出現提示
                      child: Tooltip(
                        message: _hasChangedID ? "專屬 ID 已鎖定" : "點擊複製 ID",
                        child: Icon(Icons.copy, size: 14, color: subTextColor),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),

// 3. 花花點數 + 商城入口
              InkWell( // 👈 1. 用 InkWell 包裹，讓整個膠囊都具備點擊效果
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StorePage())
                ),
                borderRadius: BorderRadius.circular(20), // 確保點擊的水波紋也是圓角的
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 稍微增加垂直 padding 更好點擊
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha:isDarkMode ? 0.6 : 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryColor.withValues(alpha:0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 👈 關鍵：膠囊會隨內容寬度自動伸縮
                    children: [
                      Image.asset(
                          isDarkMode ? 'assets/images/flower_gift_dark.png' : 'assets/images/flower_gift.png',
                          height: 20
                      ),
                      const SizedBox(width: 8),
                      // 👇 1. 這裡拿掉 Flexible，不要限制它的生存空間
                      Text(
                        // 🌟 傳進去之前先檢查，如果是負數就傳 0 給它格式化
                        _formatPoints(_flowerPoints < 0 ? 0 : _flowerPoints),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                          Icons.add_circle_outline,
                          size: 16,
                          color: primaryColor.withValues(alpha:0.7)
                      ),
                    ],
                  ),
                ),
              ),
    Text(
      l10n.hint_click_avatar_to_edit,
    style: TextStyle(fontSize: 12, color: subTextColor.withValues(alpha:0.8)),
    ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAllFriends() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllFriendsPage()),
    );
  }

  Future<void> _initializePlayerID() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();

    // 先看雲端有沒有 ID 了
    final userDoc = await _db.collection('users').doc(_userId).get();
    String? cloudID = userDoc.data()?['playerID'];

    if (cloudID != null && cloudID.isNotEmpty) {
      // 雲端有 ID，同步到本地
      setState(() => _playerID = cloudID);
      await prefs.setString('playerID', cloudID);
    } else {
      // 雲端沒 ID，這才生成一個新的
      String newID = _generateRandomID(8);
      try {
        await _db.collection('users').doc(_userId).update({
          'playerID': newID,
        });
        setState(() => _playerID = newID);
        await prefs.setString('playerID', newID);
      } catch (e) {
        print("產生 PlayerID 失敗: $e");
      }
    }
  }

  String _formatPoints(int points) {
    // 🌟 保險絲：如果點數小於 0，強制當作 0 處理，防止 UI 噴灰屏
    final safePoints = points < 0 ? 0 : points;

    // 🌟 千分位魔法：記得檔案最上方要有 import 'package:intl/intl.dart';
    return NumberFormat('#,##0').format(safePoints);
  }

  String _generateRandomID(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> _fetchAllCharacterData() async {
    if (_userId == null) return;
    try {
      // 1. 同時抓取私密與公開角色的原始 Snapshot
      final responses = await Future.wait([
        _db.collection('artifacts').doc(_appId).collection('users').doc(_userId).collection('private_characters').orderBy('createdAt', descending: true).get(),
        _db.collection('artifacts').doc(_appId).collection('public_characters').orderBy('createdAt', descending: true).get(),
      ]);

      if (!mounted) return;

      // 2. ✨ 關鍵變身：將 Snapshot 轉為已換好圖片網址的 Character 物件
      // 使用 Future.wait 確保所有非同步轉換同時進行
      final myPrivateCharacters = await Future.wait(
          responses[0].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      final allPublicCharacters = await Future.wait(
          responses[1].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      // 3. 過濾出我創建的公開角色
      final myPublicCharacters = allPublicCharacters
          .where((char) => char.createdBy == _userId)
          .toList();

      // 4. 合併並排序我的角色列表
      _myCharacters = [...myPrivateCharacters, ...myPublicCharacters];
      _myCharacters.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // 5. 🌟 關鍵修改：先去抓取「我真正加過好友」的 ID 列表
      final friendsSnapshot = await _db.collection('users').doc(_userId).collection('friends').get();
      final Set<String> myFriendIds = friendsSnapshot.docs.map((doc) => doc.id).toSet();

      final allInteractableChars = <String, Character>{};

      // 先加入私密角色 (自己創的，預設就是好友)
      for (var char in myPrivateCharacters) {
        allInteractableChars[char.id] = char;
      }

      // 🌟 只加入「真的有點過+好友」的官方角色
      for (var char in allPublicCharacters) {
        if (myFriendIds.contains(char.id)) {
          allInteractableChars.putIfAbsent(char.id, () => char);
        }
      }

      // 6. 更新好友列表
      _friendsList = allInteractableChars.values.toList();
      _friendsList.sort((a, b) => b.playCount.compareTo(a.playCount));

      // 7. 最後一刻才更新 UI
      setState(() {});

    } catch (e) {
      print('抓取角色資料時發生錯誤: $e');
    }
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    ).then((didUpdate) async { // ✨ 1. 這裡加上 async
      if (didUpdate == true) {

        // ✨ 2. 加上 await！強迫程式在這裡「等」，直到資料確實從暫存拿出來
        await _loadProfileFromCache();

        // ✨ 3. 偷偷印出來檢查，看看有沒有順利抓到水煮蛋的網址或路徑
        print("🕵️‍♀️ 檢查：更新後的頭像路徑是 = $_avatarPath");

        // ✨ 4. 資料準備萬全了，大喊 setState 叫畫面重畫！
        if (mounted) {
          setState(() {});
        }

      }
    });
  }

  void _createCharacter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CharacterEditPage()),
    ).then((_) => _refreshData());
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface));
  }

  Widget _buildFriendsListSection() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(l10n.title_my_friends),
            TextButton(
              onPressed: _showAllFriends,
              child: Text(l10n.action_show_all,
                  style: TextStyle(color: theme.colorScheme.secondary, fontSize: 14)),
            ),
          ],
        ),
        SizedBox(height: 10),
        _friendsList.isEmpty
            ? Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(l10n.noFriendsMessage,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.7)))))
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: _friendsList.length > 6 ? 6 : _friendsList.length,
          itemBuilder: (context, index) {
            final friend = _friendsList[index];
            return _buildCharacterGridItem(friend, isMyCharacter: false);
          },
        ),
      ],
    );
  }

  Widget _buildMyCharactersSection() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🌟 上半部：標題與原本的創建按鈕完美並存
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('我創建的角色'),
            _buildCreateCharacterButton(context), // 原本的按鈕安全回歸！
          ],
        ),
        const SizedBox(height: 10),

        // 🌟 中間部：顯示角色或是空狀態
        _myCharacters.isEmpty
            ? Center(
            child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 20.0),
                child: Text(l10n.empty_no_characters_created,
                    style: TextStyle(color: theme.colorScheme.onSurface
                            .withValues(alpha:0.7)))))
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: _myCharacters.length > 6 ? 6 : _myCharacters.length,
          itemBuilder: (context, index) {
            final character = _myCharacters[index];
            return _buildCharacterGridItem(character, isMyCharacter: true);
          },
        ),

        const SizedBox(height: 16), // 給上方列表一點呼吸空間

        // ✨ 下半部：總裁專屬的超大秘密工作室入口 ✨
        SizedBox(
          width: double.infinity, // 讓按鈕填滿左右寬度，超級大氣
          child: ElevatedButton.icon(
            icon: const Icon(Icons.brush, size: 22),
            label: Text(
                l10n.enter_secret_studio,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // 字體稍微加大，凸顯重點
                  letterSpacing: 1.2, // 加一點字距看起來更有質感
                )
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16), // 增加上下厚度，讓按鈕更好點擊
              backgroundColor: theme.colorScheme.primaryContainer, // 使用主題容器底色
              foregroundColor: theme.colorScheme.onPrimaryContainer, // 使用對應的文字顏色
              elevation: 0, // 扁平化一點看起來比較現代
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // 圓角跟上面的卡片呼應
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatorStudioPage()
                  )
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateCharacterButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: _createCharacter,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Text(
          l10n.createCharacterTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterGridItem(Character character,
      {bool isMyCharacter = false}) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      // ✨✨✨ 核心修改處 ✨✨✨
      onTap: () {
        if (isMyCharacter) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CharacterEditPage(character: character)),
          ).then((didUpdate) {
            if (didUpdate == true) {
              _refreshData();
            }
          });
        } else {
          // ✨✨✨ 點擊別人的角色：直接呼叫我們剛修好的完美彈出視窗！ ✨✨✨
          _showChatModeSelectionDialog(character);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: getAvatarImageProvider(character.avatarPath),
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
          const SizedBox(height: 8),
          Text(
              character.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface
              )
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../services/toast_utils.dart';
import '../utils/image_utils.dart';
import 'package:intl/intl.dart';
import '../services/theme_notifier.dart';
import 'character_profile_page.dart';
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
import 'package:share_plus/share_plus.dart';
import 'private_character_profile_page.dart'; // 我們剛剛建好的私人專屬主頁
import 'character_profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // 🌟 加上這個！
import '../models/moment_model.dart';
import 'moment_card.dart';
import 'edit_moment_page.dart';
import 'create_moment_page.dart';
import '../page/creator_follow_list_page.dart';
//個人主頁

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  // --- 狀態變數 ---
  String _nickname = '';
  String _avatarPath = 'assets/images/avatar1.png';
  String _bio = '';
  String _playerID = '';
  int _flowerPoints = 0;
  bool _isLoading = true;
  List<Character> _friendsList = [];
  List<Character> _myCharacters = [];
  late TabController _profileTabController;
  late TextEditingController _playerIDController;
  bool _hasChangedID = false;
  String _oldIDFromDB = "";
  String _profileMomentFilter = 'all';
  StreamSubscription? _pointsSubscription;
  StreamSubscription? _userDocSubscription;
  // --- Firebase 變數 ---
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? _userId;
  final TextEditingController _inviteCodeController = TextEditingController();
  bool _isBinding = false; // 控制綁定按鈕的載入狀態
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
  bool _isBirthdayToday = false; // ✨ 新進一個狀態變數來記錄今天是否生日
  bool _hasActiveMonthlyCard = false;   // 是否持有有效月卡
  bool _isMonthlyRewardClaimed = false; // 今日月卡任務是否已領取


  @override
  void initState() {
    super.initState();
    _profileTabController = TabController(
      length: 3,
      vsync: this,
    );

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

          // 👇 🔥 第四步：在這裡加上 FB 大頭貼更新器！
          // 我們直接把 user 傳給函數，這樣就不用再抓一次 currentUser 了
          _refreshFacebookAvatar(user);
        }
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

// 👇 把這段 Function 放在 initState 的下面或其他獨立的區塊裡
  Future<void> _refreshFacebookAvatar(User user) async {
    try {
      // 1. 先去資料庫調閱這個人的檔案
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return;

      final String currentAvatar = userDoc.data()?['avatarPath'] ?? '';

      // 🛡️ 如果已經在我們自己的金庫裡，安全撤退，不浪費效能！
      if (currentAvatar.isEmpty || currentAvatar.contains('firebasestorage.googleapis.com')) {
        return;
      }

      // ⚔️ 鎖定目標：只要是 FB 的網址，通通視為獵物
      if (currentAvatar.contains('fbsbx.com') || currentAvatar.contains('facebook.com') || currentAvatar.contains('graph.facebook.com')) {

        debugPrint('🔥 啟動金庫強奪計畫！繞過 Firebase，直接找 FB 總部要人！');

        String? freshUrl;

        try {
          // 🌟 核心關鍵：直接用 FacebookAuth 拿最新鮮的網址！
          final fbUserData = await FacebookAuth.instance.getUserData();
          freshUrl = fbUserData['picture']?['data']?['url'];
        } catch (fbError) {
          // 如果連 FB 的登入憑證都過期了，暗殺部隊只能先撤退
          debugPrint('⚠️ FB 憑證已完全過期，需等玩家下次重新登入才能抓新照片。');
          return;
        }

        // 如果成功拿到新網址，立刻展開綁架！
        if (freshUrl != null) {
          final response = await http.get(Uri.parse(freshUrl));

          if (response.statusCode == 200) {
            // 敲開金庫大門
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_avatars')
                .child('${user.uid}_avatar.jpg');

            // 鎖進金庫
            await storageRef.putData(
              response.bodyBytes,
              SettableMetadata(contentType: 'image/jpeg'),
            );

            // 拿到永久無敵網址
            final String permanentUrl = await storageRef.getDownloadURL();

            // 寫入資料庫
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'avatarPath': permanentUrl});

            debugPrint('✅ 完美綁架！最新 FB 大頭貼已永久鎖進拾光金庫！');

            // 如果需要馬上更新畫面，可以加上 setState
            // if (mounted) setState(() {});
          } else {
            debugPrint('⚠️ 抓取新網址後依然下載失敗，狀態碼: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ 暗殺部隊遭遇不明抵抗: $e');
    }
  }

// 🌟 別忘了！有開就要有關，這是好習慣
  @override
  void dispose() {
    _playerIDController.dispose(); // 釋放記憶體
    _inviteCodeController.dispose(); // ✨ 新增：釋放邀請碼控制器的記憶體，避免漏水！
    _pointsSubscription?.cancel();
    _userDocSubscription?.cancel();
    _profileTabController.dispose();
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
        _bio = data['bio']?.toString().trim() ?? '';
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
    if (data.containsKey('bio')) {
      await prefs.setString(
        'bio',
        data['bio']?.toString() ?? '',
      );
    }
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
      final userDocRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);

      final int rewardAmount = AppConfig.dailyCheckIn;
      final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 2. Transaction：真正防止重複簽到
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDocRef);

        if (!snapshot.exists) {
          throw Exception('找不到玩家資料');
        }

        final data = snapshot.data() as Map<String, dynamic>? ?? {};
        final lastCheckInTimestamp = data['lastCheckInDate'] as Timestamp?;

        if (lastCheckInTimestamp != null) {
          final lastCheckInString = DateFormat('yyyy-MM-dd').format(
            lastCheckInTimestamp.toDate(),
          );

          if (lastCheckInString == todayString) {
            throw Exception('今天已經簽到過了');
          }
        }

        transaction.update(userDocRef, {
          'flowerPoints': FieldValue.increment(rewardAmount),
          'lastCheckInDate': FieldValue.serverTimestamp(),
        });
      });

      // 3. 寫入收支明細
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
      if (!mounted) return;

      setState(() {
        _hasCheckedInToday = true;
      });

      // 5. 顯示恭喜獲得彈窗
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext rewardDialogContext) {
          final theme = Theme.of(rewardDialogContext);

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/flower_gift.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.daily_gift_success,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.reward_points_added(rewardAmount),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(rewardDialogContext).pop();
                    },
                    child: Text(
                      l10n.shop_purchase_awesome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      debugPrint("❌ 手動簽到失敗: $e");

      if (!mounted) return;

      final errorText = e.toString();
      final bool alreadyCheckedIn = errorText.contains('今天已經簽到過了');

      if (alreadyCheckedIn) {
        final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

        setState(() {
          _hasCheckedInToday = true;
        });

        ToastUtils.showCenterToast(
          context,
          '今天已經簽到過囉',
          isError: true,
        );

        return;
      }

      ToastUtils.showCenterToast(
        context,
        l10n.check_in_fail_network,
        isError: true,
      );
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

    DateTime now = DateTime.now();
    bool isCardValid = false;
    if (data['monthlySubEndDate'] != null) {
      isCardValid = DateTime.parse(data['monthlySubEndDate']).isAfter(now);
    }

    final lastResetTimestamp = data['lastTasksResetDate'] as Timestamp?;
    String lastResetDateString = '';
    if (lastResetTimestamp != null) {
      lastResetDateString = DateFormat('yyyy-MM-dd').format(lastResetTimestamp.toDate());
    }

    // 如果上次重置日期不是今天，代表所有進度都是 0，所有獎勵都未領取
    if (lastResetDateString != todayString) {
      await userDocRef.set({
        'lastTasksResetDate': FieldValue.serverTimestamp(),
        'dailyTasks': {
          'dailyChatProgress': 0,
          'dailyChatClaimed': false,
          'storyChatProgress': 0,
          'storyChatClaimed': false,
          'likeProgress': 0,
          'likeClaimed': false,
          'monthlyCardClaimed': false,
        },
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        _dailyChatProgress = 0;
        _isDailyChatClaimed = false;
        _storyChatProgress = 0;
        _isStoryChatClaimed = false;
        _likeProgress = 0;
        _isLikeClaimed = false;
        _hasActiveMonthlyCard = isCardValid;
        _isMonthlyRewardClaimed = false;
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
      _hasActiveMonthlyCard = isCardValid; // 🌟 載入月卡身分
      _isMonthlyRewardClaimed = tasks['monthlyCardClaimed'] ?? false; // 🌟 載入今天領過沒
    });
  }

  // ✨ 3新增「領取獎勵」的核心函式
  Future<void> _claimTaskReward(
      String taskName,
      String progressField,
      String claimedField,
      int rewardAmount,
      VoidCallback onDialogSetState,
      ) async {
    if (_userId == null) return;

    final userDocRef = _db.collection('users').doc(_userId);
    final l10n = AppLocalizations.of(context)!;

    try {
      await _db.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userDocRef);

        if (!userSnapshot.exists) {
          throw Exception('找不到玩家資料');
        }

        final data = userSnapshot.data() ?? {};
        final dailyTasks =
        Map<String, dynamic>.from(data['dailyTasks'] ?? {});

        final bool alreadyClaimed = dailyTasks[claimedField] == true;

        // 🔒 Firebase 層級防重複領取
        if (alreadyClaimed) {
          throw Exception(l10n.task_reward_already_claimed);
        }

        // 1. 增加花花
        transaction.update(userDocRef, {
          'flowerPoints': FieldValue.increment(rewardAmount),
          'dailyTasks.$claimedField': true,
        });

        // 2. 寫入花花明細
        final logRef = userDocRef.collection('flower_logs').doc();

        transaction.set(logRef, {
          'title': l10n.task_completed(taskName),
          'amount': rewardAmount,
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      if (!mounted) return;

      // ✅ 交易成功後，才更新畫面
      onDialogSetState();

      ToastUtils.showCenterToast(
        context,
        l10n.task_reward_claimed(taskName, rewardAmount.toString()),
        customIcon: Icons.emoji_events_rounded,
      );
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.claim_failed_error(
          e.toString().replaceFirst('Exception: ', ''),
        ),
        isError: true,
      );
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
                        if (_isDailyChatClaimed) return;
                        if (_dailyChatProgress < 3) return;

                        _claimTaskReward(
                          l10n.tab_daily_chit_chat,
                          'dailyChatProgress',
                          'dailyChatClaimed',
                          5,
                              () {
                            setStateInDialog(() => _isDailyChatClaimed = true);
                            setState(() => _isDailyChatClaimed = true);
                          },
                        );
                      },
                    ),

                    _buildTaskItem(
                      title:l10n.tab_story_progression,
                      subtitle: l10n.task_desc_story_1_time,
                      progress: _storyChatProgress, goal: 1,
                      isClaimed: _isStoryChatClaimed,
                      onClaim: () {
                        if (_isStoryChatClaimed) return;
                        if (_storyChatProgress < 1) return;

                        _claimTaskReward(
                          l10n.tab_story_progression,
                          'storyChatProgress',
                          'storyChatClaimed',
                          5,
                              () {
                            setStateInDialog(() => _isStoryChatClaimed = true);
                            setState(() => _isStoryChatClaimed = true);
                          },
                        );
                      },
                    ),

                    _buildTaskItem(
                      title: l10n.tab_social_tour,
                      subtitle: l10n.task_like_three_moments,
                      progress: _likeProgress, goal: 3,
                      isClaimed: _isLikeClaimed,
                      onClaim: () {
                        if (_isLikeClaimed) return;
                        if (_likeProgress < 3) return;

                        _claimTaskReward(
                          l10n.tab_social_tour,
                          'likeProgress',
                          'likeClaimed',
                          5,
                              () {
                            setStateInDialog(() => _isLikeClaimed = true);
                            setState(() => _isLikeClaimed = true);
                          },
                        );
                      },
                    ),
                    // 🏆 4. ✨✨✨ 第四個獨立任務（星之契約特權）- 全多國語系版 ✨✨✨
                    _buildTaskItem(
                      title: l10n.task_monthly_title,
                      // 🌟  subtitle 動態切換翻譯
                      subtitle: _hasActiveMonthlyCard
                          ? l10n.task_monthly_subtitle_active
                          : l10n.task_monthly_subtitle_inactive,
                      progress: _hasActiveMonthlyCard ? 1 : 0,
                      goal: 1,
                      isClaimed: _isMonthlyRewardClaimed,
                      customIncompleteText: l10n.task_monthly_locked,
                      onClaim: () {
                        if (!_hasActiveMonthlyCard || _isMonthlyRewardClaimed) return;

                        _claimTaskReward(
                          l10n.task_monthly_log_name,
                          '',
                          'monthlyCardClaimed',
                          10,
                              () {
                            setStateInDialog(() => _isMonthlyRewardClaimed = true);
                            setState(() => _isMonthlyRewardClaimed = true);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [ TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.common_close)) ],
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
    String? customIncompleteText,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    final int displayedProgress = progress > goal ? goal : progress;
    final bool isCompleted = progress >= goal;
    final bool canClaim = isCompleted && !isClaimed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('$subtitle ($displayedProgress / $goal)'),
            trailing: isClaimed
                ? Text(
              l10n.btn_claimed,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            )
                : ElevatedButton(
              onPressed: canClaim ? onClaim : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                canClaim ? primaryColor : Colors.grey[200],
                foregroundColor:
                canClaim ? Colors.white : Colors.grey[600],
                disabledBackgroundColor: Colors.grey[200],
                disabledForegroundColor: Colors.grey[600],
                elevation: canClaim ? 3 : 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                canClaim
                    ? l10n.btn_claim
                    : (customIncompleteText ?? l10n.btn_incomplete),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: goal <= 0 ? 0 : displayedProgress / goal,
              backgroundColor: primaryColor.withValues(alpha: 0.1),
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

    await _fetchAllCharacterData();
  }

  Future<void> _loadProfileFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (mounted) {
      setState(() {
        // 優先序：本地緩存 > Firebase 帳號名稱 > 溫柔的預設值
        _nickname = prefs.getString('nickname') ?? (currentUser?.displayName ?? l10n.title_time_travel);
        _bio = prefs.getString('bio') ?? '';
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

            // ✨ 補上這兩把必備的鑰匙：
            characterId: character.id, // 🔑 補上角色ID

            // 🌟 2. 模式 ('daily' 或 'story')
            chatMode: selectedMode,

            // 🌟 4. 語言跟存檔
            selectedLanguage: 'zh-TW',

            // 🌟 5. 第一句話跟故事情節
            initialText: selectedMode == 'story'
                ? (character.storyModeFirstLine ?? l10n.greeting_hello)
                : l10n.greeting_default_daily,
          ),
        ),
      ).then((_) {
        // 退出來記得重整一下
        _refreshData();
      });
    }
  }

  // ==========================================
  // 🔒 核心防線：輸入邀請碼的後端原子綁定邏輯
  // ==========================================
  Future<void> _bindInviteCode(String inviterId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _isBinding) return;

    final l10n = AppLocalizations.of(context)!;
    final trimmedId = inviterId.trim();

    // 防止空白輸入
    if (trimmedId.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.profile_referral_err_not_found,
        isError: true,
      );
      return;
    }

    // 僅限註冊 72 小時內綁定
    final creationTime =
        user.metadata.creationTime ?? DateTime.now();

    final int hoursSinceCreation =
        DateTime.now().difference(creationTime).inHours;

    if (hoursSinceCreation > 72) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.profile_referral_err_expired,
        isError: true,
      );
      return;
    }

    setState(() {
      _isBinding = true;
    });

    try {
      final db = FirebaseFirestore.instance;

      // 目前登入玩家的 users 文件
      final userRef =
      db.collection('users').doc(user.uid);

      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw Exception('找不到目前玩家資料');
      }

      final currentUserData =
          userDoc.data() ?? <String, dynamic>{};

      // 終身只能綁定一次
      final existingInvitedBy =
          currentUserData['invitedBy']
              ?.toString()
              .trim() ??
              '';

      if (existingInvitedBy.isNotEmpty) {
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.profile_referral_err_duplicate,
          isError: true,
        );
        return;
      }

      // 玩家輸入的是公開 Player ID，
      // 所以要查 users 文件裡的 playerID 欄位
      final inviterQuery = await db
          .collection('users')
          .where(
        'playerID',
        isEqualTo: trimmedId,
      )
          .limit(1)
          .get();

      // 查無此 Player ID
      if (inviterQuery.docs.isEmpty) {
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.profile_referral_err_not_found,
          isError: true,
        );
        return;
      }

      // 找到的文件 ID 就是邀請人的 Firebase UID
      final inviterDoc =
          inviterQuery.docs.first;

      final String inviterUid =
          inviterDoc.id;

      final inviterData =
      inviterDoc.data();

      final String inviterPlayerId =
          inviterData['playerID']
              ?.toString()
              .trim() ??
              trimmedId;

      // 禁止玩家輸入自己的 Player ID
      if (inviterUid == user.uid) {
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          l10n.profile_referral_err_self,
          isError: true,
        );
        return;
      }

      // 正式綁定
      //
      // invitedBy：
      // 存邀請人的 Firebase UID，之後用來發獎。
      //
      // invitedByPlayerID：
      // 存公開 Player ID，方便畫面顯示與後台查詢。
      await userRef.update({
        'invitedBy': inviterUid,
        'invitedByPlayerID': inviterPlayerId,
        'referralRewardClaimed': false,
        'totalChatMessages': 0,
        'inviteBoundAt':
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.profile_referral_success,
        customIcon:
        Icons.handshake_rounded,
      );

      _inviteCodeController.clear();

      // 收起鍵盤
      FocusScope.of(context).unfocus();
    } catch (e, stackTrace) {
      debugPrint(
        '🚨 星之邀約綁定發生錯誤：$e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '綁定失敗，請稍後再試',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBinding = false;
        });
      }
    }
  }
  // ==========================================
// 🎨 視覺演繹：星之邀約輸入橫幅 (極致微縮 32px 版)
// ==========================================
  Widget _buildReferralSection(Map<String, dynamic> userData) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // invitedBy 存的是邀請人的 Firebase UID
    final String inviterUid =
        userData['invitedBy']?.toString().trim() ?? '';

    // 畫面優先顯示公開 Player ID
    final String inviterPlayerId =
        userData['invitedByPlayerID']?.toString().trim() ?? '';

    final bool hasInviter = inviterUid.isNotEmpty;

    final bool isClaimed =
        userData['referralRewardClaimed'] == true;

    final Timestamp? claimedAtTimestamp =
    userData['referralRewardClaimedAt'] as Timestamp?;

    final DateTime? claimedAt =
    claimedAtTimestamp?.toDate();

    final bool completedDisplayExpired =
        isClaimed &&
            claimedAt != null &&
            DateTime.now().difference(claimedAt).inDays >= 7;

    if (completedDisplayExpired) {
      return const SizedBox.shrink();
    }

    final int totalChatMessages =
        (userData['totalChatMessages'] as num?)?.toInt() ?? 0;

    final int displayedProgress =
    totalChatMessages > 15 ? 15 : totalChatMessages;

    final creationTime =
        user.metadata.creationTime ?? DateTime.now();

    final int hoursSinceCreation =
        DateTime.now().difference(creationTime).inHours;

    final bool isNewbie = hoursSinceCreation <= 72;

    // 沒綁定，而且已經超過 72 小時，才隱藏整欄
    if (!hasInviter && !isNewbie) {
      return const SizedBox.shrink();
    }

    // 顯示邀請人的公開 ID；舊資料沒有時才顯示 UID 縮寫
    final String inviterDisplayId = inviterPlayerId.isNotEmpty
        ? inviterPlayerId
        : inviterUid.length > 8
        ? '${inviterUid.substring(0, 8)}...'
        : inviterUid;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.profile_referral_title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // =====================================
          // 狀態一：已完成並已經領取獎勵
          // =====================================
          if (hasInviter && isClaimed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '星之邀約已完成',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          '邀請人：$inviterDisplayId',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.65),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          '雙方已獲得 50 花花',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    '已領取',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )

          // =====================================
          // 狀態二：已綁定，但聊天尚未達標
          // =====================================
          else if (hasInviter)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.mark_chat_read_outlined,
                        color: Colors.amber,
                        size: 17,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          '已綁定邀請人：$inviterDisplayId',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),

                      Text(
                        '$displayedProgress / 15',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: displayedProgress / 15,
                      minHeight: 6,
                      backgroundColor:
                      Colors.amber.withValues(alpha: 0.12),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(
                        Colors.amber,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '完成 15 句聊天後，雙方各獲得 50 花花',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )

          // =====================================
          // 狀態三：尚未綁定，顯示輸入欄
          // =====================================
          else
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: TextField(
                      controller: _inviteCodeController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText:
                        l10n.profile_referral_hint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        filled: true,
                        fillColor: theme.disabledColor.withValues(
                          alpha: 0.03,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: _isBinding
                        ? null
                        : () => _bindInviteCode(
                      _inviteCodeController.text,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.primary,
                      foregroundColor:
                      theme.colorScheme.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                    ),
                    child: _isBinding
                        ? const SizedBox(
                      width: 12,
                      height: 12,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      l10n.profile_referral_bind_btn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (
                          BuildContext dialogContext,
                          ) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.pinkAccent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.profile_referral_rule_title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            l10n.profile_referral_rule_receiver,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(
                                    dialogContext,
                                  ).pop(),
                              child: Text(
                                l10n.common_got_it,
                                style: const TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // 🎒 玩家專屬背包與獎勵收藏夾
  void _showBackpackDialog(BuildContext context, String userId, int totalSpent, bool hasSubmittedAddress) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.backpack_outlined, color: Colors.pink),
              SizedBox(width: 8),
              Text('我的專屬背包與特權'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 💎 累積金額狀態列
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('目前累積浪漫羈絆', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('NT\$ $totalSpent', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('🎁 實體禮盒解鎖狀態：', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),

                  // 👑 10,000 元實體禮盒判定
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: totalSpent >= 10000 ? primaryColor : Colors.grey.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(12),
                      color: totalSpent >= 10000 ? primaryColor.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              totalSpent >= 10000 ? Icons.card_giftcard : Icons.lock_outline,
                              color: totalSpent >= 10000 ? primaryColor : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '【頂級摯愛】實體 VIP 專屬禮盒',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: totalSpent >= 10000 ? primaryColor : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '含：專屬手寫信 + 角色代表娃 + 官方感謝信',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),

                        // 狀態按鈕邏輯
                        if (totalSpent >= 10000) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // 關閉背包
                                _showPhysicalGiftDialog(context, userId); // 打開地址填寫表單
                              },
                              child: Text(hasSubmittedAddress ? '修改收件地址資訊' : '🎉 已解鎖！點此填寫收件資訊'),
                            ),
                          ),
                          if (hasSubmittedAddress)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text('✅ 您已成功登記收件地址，我們會盡快為您準備！', style: TextStyle(fontSize: 11, color: Colors.green)),
                            ),
                        ] else ...[
                          Text(
                            '還差 NT\$ ${10000 - totalSpent} 即可解鎖實體大賞！',
                            style: const TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('💡 提示：其他數位外觀與頭像框可在商店或個人設定中查看與裝備。', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('關閉'),
            ),
          ],
        );
      },
    );
  }

  // 👑 彈出實體禮盒收件資訊填寫表單 (角色改為手動輸入版)
  void _showPhysicalGiftDialog(BuildContext context, String userId) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final characterController = TextEditingController(); // ✨ 改用文字控制器來手動輸入角色名

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.card_giftcard, color: Colors.pink),
                  SizedBox(width: 8),
                  Text('【頂級摯愛】實體禮盒解鎖'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '感謝玩家對《戀戀拾光》的極致守候！\n請填寫以下收件資訊，我們將為您寄送專屬手寫信與角色代表娃娃：',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '收件人真實姓名',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: '聯絡電話',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: addressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: '完整收件地址（含郵遞區號）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: characterController,
                      decoration: const InputDecoration(
                        labelText: '想要收到的角色代表娃名字',
                        hintText: '例如：欲輸入的角色名稱',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('稍後填寫', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // 防呆檢查：包含角色名稱也不能空白
                    if (nameController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        addressController.text.isEmpty ||
                        characterController.text.isEmpty) {
                      ToastUtils.error(
                        context,
                        '請完整填寫收件資訊與心儀的角色名稱喔！',
                      );
                      return;
                    }

                    await FirebaseFirestore.instance.collection('shipping_addresses').doc(userId).set({
                      'userId': userId,
                      'name': nameController.text.trim(),
                      'phone': phoneController.text.trim(),
                      'address': addressController.text.trim(),
                      'favoriteCharacter': characterController.text.trim(), // 儲存手動輸入的角色
                      'status': 'pending_shipment',
                      'createdAt': FieldValue.serverTimestamp(),
                    }, SetOptions(merge: true));

                    Navigator.pop(context);
                    ToastUtils.success(
                      context,
                      '收件資訊已成功送出！請期待我們的實體驚喜！',
                    );
                  },
                  child: const Text('確認送出'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProfileBio() {
    final theme = Theme.of(context);

    return Container(
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
            "📝 關於我",
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _bio,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final String adminUid = 'B71k2kyooubYsOtIO1nkiBwyBXt2';
    final bool isAdmin = currentUser?.uid == adminUid;
    final theme = Theme.of(context);

    return Container(
      decoration: themeNotifier.currentBackground,
      child: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _refreshData,
        child: NestedScrollView(
          headerSliverBuilder: (
              context,
              innerBoxIsScrolled,
              ) {
            return [
              SliverAppBar(
                title: Text(
                  l10n.title_personal_homepage,
                ),
                pinned: true,
                floating: false,
                backgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  if (!isAppleReviewMode)
                    IconButton(
                      tooltip: '我的背包',
                      icon: const Icon(
                        Icons.card_giftcard,
                      ),
                      onPressed: () async {
                        if (currentUser == null) return;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                          const Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                        );

                        try {
                          final userDoc =
                          await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(currentUser.uid)
                              .get();

                          final int totalSpent =
                              userDoc.data()?[
                              'totalSpent'] ??
                                  0;

                          final addressDoc =
                          await FirebaseFirestore
                              .instance
                              .collection(
                            'shipping_addresses',
                          )
                              .doc(currentUser.uid)
                              .get();

                          final bool
                          hasSubmittedAddress =
                              addressDoc.exists;

                          if (mounted) {
                            Navigator.pop(context);
                          }

                          if (mounted) {
                            _showBackpackDialog(
                              context,
                              currentUser.uid,
                              totalSpent,
                              hasSubmittedAddress,
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                          }

                          debugPrint(
                            '讀取背包失敗: $e',
                          );
                        }
                      },
                    ),

                  IconButton(
                    tooltip:
                    l10n.title_time_letters,
                    icon: Image.asset(
                      'assets/images/scroll_icon.png',
                      width: 26,
                      height: 26,
                      color: Theme.of(context)
                          .brightness ==
                          Brightness.dark
                          ? Colors.white
                          : const Color(
                        0xFF6750A4,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AnnouncementListPage(),
                        ),
                      );
                    },
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context)
                          .brightness ==
                          Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SettingsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 8),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    12,
                  ),
                  child:
                  _buildCreatorProfileHeader(),
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate:
                _ProfileTabBarDelegate(
                  TabBar(
                    controller:
                    _profileTabController,
                    labelColor:
                    theme.colorScheme.primary,
                    unselectedLabelColor:
                    theme
                        .colorScheme.onSurface
                        .withValues(
                      alpha: 0.55,
                    ),
                    indicatorColor:
                    theme.colorScheme.primary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: '自我介紹'),
                      Tab(text: '角色'),
                      Tab(text: '動態'),
                    ],
                  ),
                  backgroundColor:
                  Theme.of(context)
                      .scaffoldBackgroundColor,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller:
            _profileTabController,
            children: [
              _buildAboutMeTab(),
              _buildCharactersTab(),
              _buildMomentsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInButton() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_hasCheckedInToday) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.check_circle),
        label: Text(l10n.status_signed_in_today),
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.grey,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    } else {
      return ElevatedButton.icon(
        icon: _isClaimingCheckIn
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.calendar_today),
        label: Text(_isClaimingCheckIn ? l10n.status_signing_in : l10n.status_daily_sign_in),
        onPressed: _isClaimingCheckIn ? null : _performCheckIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.7),
          foregroundColor: theme.colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

Widget _buildCreatorProfileHeader() {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;
  final textColor = theme.colorScheme.onSurface;
  final subTextColor =
  textColor.withValues(alpha: 0.65);
  final l10n = AppLocalizations.of(context)!;

  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _editProfile,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: _isBirthdayToday
                    ? [
                  BoxShadow(
                    color: primaryColor.withValues(
                      alpha: 0.4,
                    ),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ]
                    : null,
              ),
              child: CircleAvatar(
                radius: 46,
                backgroundColor:
                primaryColor.withValues(alpha: 0.1),
                backgroundImage:
                getAvatarImageProvider(_avatarPath),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _nickname,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (_isBirthdayToday)
                      Icon(
                        Icons.cake_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                  ],
                ),

                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String displayID = _oldIDFromDB;
                    String characterName =
                        l10n.profile_fallback_character;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                      displayID =
                          userData['playerID'] ?? _oldIDFromDB;

                      characterName =
                          userData['currentCharacter'] ??
                              l10n.profile_fallback_character;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'ID: $displayID',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subTextColor,
                                  fontWeight: _hasChangedID
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: displayID),
                                );

                                ToastUtils.showCenterToast(
                                  context,
                                  l10n.toast_id_copied,
                                  customIcon: Icons.copy_rounded,
                                );
                              },
                              child: Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                l10n.profile_send_invite_btn,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subTextColor,
                                ),
                              ),
                            ),

                            const SizedBox(width: 5),

                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      title: Row(
                                        children: [
                                          const Icon(
                                            Icons.info_outline,
                                            color: Colors.pinkAccent,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            l10n.profile_referral_rule_title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        l10n.profile_referral_rule_receiver,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext).pop(),
                                          child: Text(
                                            l10n.common_got_it,
                                            style: const TextStyle(
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.help_outline_rounded,
                                size: 15,
                                color: Colors.grey.shade400,
                              ),
                            ),

                            const SizedBox(width: 10),

                            GestureDetector(
                              onTap: () async {
                                final shareText =
                                l10n.profile_share_message(
                                  characterName,
                                  displayID,
                                );

                                await SharePlus.instance.share(
                                  ShareParams(text: shareText),
                                );
                              },
                              child: Icon(
                                Icons.share_rounded,
                                size: 17,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                  ),
                  label: const Text("編輯個人檔案"),
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
            child: _buildProfileStatItem(
              value: _friendsList.length,
              label: '朋友',
            ),
          ),
          Expanded(
            child: _buildProfileStatItem(
              value: _myCharacters.length,
              label: '作品',
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                FirebaseAuth.instance
                    .currentUser?.uid,
              )
                  .collection('following')
                  .snapshots(),
              builder: (context, snapshot) {
                final int followingCount =
                    snapshot.data?.docs.length ?? 0;

                return _buildProfileStatItem(
                  value: followingCount,
                  label: '追蹤',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CreatorFollowListPage(
                          type:
                          CreatorFollowListType
                              .following,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                FirebaseAuth.instance
                    .currentUser?.uid,
              )
                  .collection('followers')
                  .snapshots(),
              builder: (context, snapshot) {
                final int followersCount =
                    snapshot.data?.docs.length ?? 0;

                return _buildProfileStatItem(
                  value: followersCount,
                  label: '追蹤者',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CreatorFollowListPage(
                          type:
                          CreatorFollowListType
                              .followers,
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

      const SizedBox(height: 12),

      Row(
        children: [
          Expanded(
            child: _buildCheckInButton(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showHeartbeatDiary,
              icon: const Icon(
                Icons.auto_stories_outlined,
              ),
              label: const Text('心動日記'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme
                    .colorScheme.surface
                    .withValues(alpha: 0.8),
                foregroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

  void _showMyCharacterActions(
      Character character,
      ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('編輯角色'),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterEditPage(
                        character: character,
                      ),
                    ),
                  );

                  if (!mounted) return;
                  await _refreshData();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.visibility_outlined,
                ),
                title: const Text('預覽角色檔案'),
                onTap: () {
                  Navigator.pop(sheetContext);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        if (character.isPublic) {
                          return CharacterProfilePage(
                            character: character,
                            characterId: character.id,
                          );
                        }

                        return PrivateCharacterProfilePage(
                          character: character,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileStatItem({
    required int value,
    required String label,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Column(
          children: [
            Text(
              _formatPoints(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme
                    .colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMeTab() {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_bio.isNotEmpty)
          _buildProfileBio()
        else
          _buildEmptyBioCard(),

        const SizedBox(height: 16),

        if (currentUser != null)
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  !snapshot.data!.exists) {
                return const SizedBox.shrink();
              }

              final userData =
              snapshot.data!.data()
              as Map<String, dynamic>;

              return _buildReferralSection(userData);
            },
          ),

        const SizedBox(height: 16),

        _buildFriendsListSection(),
      ],
    );
  }
  Widget _buildEmptyBioCard() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: _editProfile,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
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
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 36,
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.65),
            ),
            const SizedBox(height: 8),
            const Text(
              '還沒有自我介紹',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '點一下寫下關於你的介紹。',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCharactersTab() {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ＋ 建立新角色
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                4,
              ),
              child: InkWell(
                onTap: _createCharacter,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 21,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '建立新角色',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_myCharacters.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 64,
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.45),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '還沒有創建角色',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '開始創建你的第一位角色吧。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                24,
              ),
              sliver: SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final character = _myCharacters[index];
                    return _buildMyCharacterCard(character);
                  },
                  childCount: _myCharacters.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildMyCharacterCard(Character character) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final String imagePath =
    character.avatarPath.trim().isNotEmpty
        ? character.avatarPath
        : 'assets/images/avatar1.png';

    final int playCount = character.playCount;
    final int likesCount = character.likesCount;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final result = await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CharacterEditPage(character: character),
          ),
        );

        if (!mounted || result == null) return;

        final bool changed = result['changed'] == true;
        final bool deleted = result['deleted'] == true;

        final String? deletedCharacterId =
        result['characterId']?.toString();

        final String? message =
        result['message']?.toString();

        if (deleted) {
          final idToRemove =
              deletedCharacterId ?? character.id;

          setState(() {
            _myCharacters.removeWhere(
                  (item) => item.id == idToRemove,
            );

            _friendsList.removeWhere(
                  (item) => item.id == idToRemove,
            );
          });

          if (message != null && message.isNotEmpty) {
            ToastUtils.showCenterToast(
              context,
              message,
              customIcon: Icons.person_remove_rounded,
            );
          }

          return;
        }

        if (changed) {
          await _refreshData();

          if (!mounted) return;

          if (message != null && message.isNotEmpty) {
            ToastUtils.showCenterToast(
              context,
              message,
              customIcon: Icons.manage_accounts_rounded,
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface
              .withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface
                .withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: getAvatarImageProvider(imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: primaryColor.withValues(
                          alpha: 0.08,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 56,
                          color: primaryColor.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      );
                    },
                  ),

                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.48),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: '角色操作',
                        visualDensity: VisualDensity.compact,
                        iconSize: 18,
                        color: Colors.white,
                        onPressed: () {
                          _showMyCharacterActions(character);
                        },
                        icon: const Icon(Icons.more_horiz_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                10,
                12,
                12,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: character.isPublic
                          ? Colors.green.withValues(alpha: 0.10)
                          : theme.colorScheme.onSurface
                          .withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          character.isPublic
                              ? Icons.public_rounded
                              : Icons.lock_outline_rounded,
                          size: 12,
                          color: character.isPublic
                              ? Colors.green
                              : theme.colorScheme.onSurface
                              .withValues(alpha: 0.55),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          character.isPublic ? '公開' : '私人',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: character.isPublic
                                ? Colors.green
                                : theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline_rounded,
                        size: 15,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPoints(playCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.58),
                        ),
                      ),

                      const Spacer(),

                      Icon(
                        Icons.favorite_border_rounded,
                        size: 15,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPoints(likesCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showProfileAuthorSelectionSheet() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    String creatorName =
    _nickname.trim().isNotEmpty ? _nickname : '創作者';

    String creatorAvatar = _avatarPath;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final data = userDoc.data();

      if (data != null) {
        creatorName =
        data['nickname']?.toString().trim().isNotEmpty == true
            ? data['nickname'].toString().trim()
            : creatorName;

        creatorAvatar =
        data['avatarPath']?.toString().trim().isNotEmpty == true
            ? data['avatarPath'].toString().trim()
            : creatorAvatar;
      }
    } catch (e) {
      debugPrint('❌ 讀取創作者發布資料失敗：$e');
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
              MediaQuery.of(sheetContext).size.height * 0.72,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Text(
                    '選擇發布身分',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(height: 1),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                          getAvatarImageProvider(creatorAvatar),
                        ),
                        title: Text(
                          creatorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text('以創作者本人發布'),
                        trailing: const Icon(
                          Icons.edit_document,
                        ),
                        onTap: () async {
                          Navigator.pop(sheetContext);

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateMomentPage(
                                authorId:
                                'creator_${currentUser.uid}',
                                authorName: creatorName,
                                authorAvatar: creatorAvatar,
                                isCreatorPost: true,
                              ),
                            ),
                          );
                        },
                      ),

                      if (_myCharacters.isNotEmpty)
                        const Divider(height: 1),

                      ..._myCharacters.map((character) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            getAvatarImageProvider(
                              character.avatarPath,
                            ),
                          ),
                          title: Text(character.name),
                          subtitle: Text(
                            character.isPublic
                                ? '公開角色'
                                : '私人角色',
                          ),
                          trailing: Icon(
                            character.isPublic
                                ? Icons.public_rounded
                                : Icons.lock_outline_rounded,
                            size: 18,
                          ),
                          onTap: () async {
                            Navigator.pop(sheetContext);

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateMomentPage(
                                  authorId: character.id,
                                  authorName: character.name,
                                  authorAvatar:
                                  character.avatarPath,
                                  isCreatorPost: false,
                                ),
                              ),
                            );
                          },
                        );
                      }),
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

  Widget _buildMomentsTab() {
    final theme = Theme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('請先登入'),
      );
    }

    return Column(
      children: [
    Padding(
    padding: const EdgeInsets.fromLTRB(
      16,
      16,
      16,
      8,
    ),

    child: SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
    onPressed: _showProfileAuthorSelectionSheet,
    icon: const Icon(
    Icons.add_rounded,
    size: 21,
    ),
    label: const Text(
    '發布動態',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    ),
    ),
    style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
    vertical: 13,
    ),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
    ),
    ),
    ),
    ),
    ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            8,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildProfileMomentFilterChip(
                  label: '全部',
                  value: 'all',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProfileMomentFilterChip(
                  label: '本人',
                  value: 'creator',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildProfileMomentFilterChip(
                  label: '角色',
                  value: 'character',
                ),
              ),
            ],
          ),
        ),

    Expanded(
    child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('moments')
          .where(
        'createdBy',
        isEqualTo: currentUser.uid,
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
            '❌ 個人動態讀取失敗：${snapshot.error}',
          );

          return ListView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 60),
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: theme.colorScheme.error
                    .withValues(alpha: 0.6),
              ),
              const SizedBox(height: 16),
              const Text(
                '動態讀取失敗',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '請稍後再試一次。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.55),
                ),
              ),
            ],
          );
        }

        final docs = snapshot.data?.docs ?? [];

        final allMoments = docs.map((doc) {
          return Moment.fromFirestore(doc);
        }).toList();

        final moments = allMoments.where((moment) {
          switch (_profileMomentFilter) {
            case 'creator':
              return moment.isCreatorPost;

            case 'character':
              return !moment.isCreatorPost;

            case 'all':
            default:
              return true;
          }
        }).toList();

        if (moments.isEmpty) {
          String emptyTitle;
          String emptyDescription;

          switch (_profileMomentFilter) {
            case 'creator':
              emptyTitle = '本人還沒有發布動態';
              emptyDescription = '以創作者身分發布的內容會顯示在這裡。';
              break;

            case 'character':
              emptyTitle = '旗下角色還沒有發布動態';
              emptyDescription = '以角色身分發布的內容會顯示在這裡。';
              break;

            default:
              emptyTitle = '還沒有動態';
              emptyDescription = '你與旗下角色發布的動態會顯示在這裡。';
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.dynamic_feed_outlined,
                size: 56,
                color: theme.colorScheme.primary
                    .withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emptyDescription,
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

        return ListView.builder(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 24,
          ),
          itemCount: moments.length,
          itemBuilder: (context, index) {
            final moment = moments[index];

            return MomentCard(
              key: ValueKey(moment.id),
              moment: moment,
              currentUserId: currentUser.uid,
              showFeatureTips: false,

              // 個人主頁內仍可正常按讚
              onLikeTapped: () {
                _handleProfileMomentLike(moment);
              },

              // 編輯自己的動態
              onEditTapped: () {
                _editProfileMoment(moment);
              },

              // 刪除自己的動態
              onDeleteTapped: () {
                _deleteProfileMoment(moment.id);
              },

              // 點角色頭像時先沿用原有角色跳轉
              onAvatarTapped: () {
                _openProfileMomentAuthor(moment);
              },
            );
          },
        );
      },
    ),
    ),
      ],
    );
  }
  Widget _buildProfileMomentFilterChip({
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    final bool isSelected =
        _profileMomentFilter == value;

    return InkWell(
      onTap: () {
        if (_profileMomentFilter == value) return;

        setState(() {
          _profileMomentFilter = value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 9,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface
              .withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(20),
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
  Future<void> _editProfileMoment(
      Moment moment,
      ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMomentPage(
          momentToEdit: moment,
        ),
      ),
    );

    if (!mounted) return;

    if (result is Map &&
        result['changed'] == true) {
      setState(() {});
    }
  }
  Future<void> _deleteProfileMoment(
      String momentId,
      ) async {
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
                      color: Colors.red,
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
          .doc(_appId)
          .collection('moments')
          .doc(momentId)
          .delete();

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '動態已刪除',
        customIcon:
        Icons.delete_outline_rounded,
      );
    } catch (e) {
      debugPrint('❌ 刪除動態失敗：$e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '刪除失敗，請稍後再試',
        isError: true,
      );
    }
  }
  Future<void> _handleProfileMomentLike(
      Moment moment,
      ) async {
    final currentUser =
        FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'lastTasksResetDate':
        FieldValue.serverTimestamp(),
        'dailyTasks.likeProgress':
        FieldValue.increment(1),
      }, SetOptions(merge: true));

      await _loadDailyTaskProgress();
    } catch (e) {
      debugPrint(
        '❌ 個人主頁按讚任務更新失敗：$e',
      );
    }
  }
  void _openProfileMomentAuthor(
      Moment moment,
      ) {
    // 創作者本人發布的動態
    if (moment.isCreatorPost) {
      return;
    }

    Character? targetCharacter;

    for (final character in _myCharacters) {
      if (character.id == moment.authorId) {
        targetCharacter = character;
        break;
      }
    }

    if (targetCharacter == null) {
      ToastUtils.showCenterToast(
        context,
        '找不到這個角色的資料',
        isError: true,
      );
      return;
    }

    final character = targetCharacter;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          if (character.isPublic) {
            return CharacterProfilePage(
              character: character,
              characterId: character.id,
            );
          }

          return PrivateCharacterProfilePage(
            character: character,
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final subTextColor = textColor.withValues(alpha:0.7);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        GestureDetector(
          onTap: _editProfile,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
              backgroundImage: getAvatarImageProvider(_avatarPath),
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint('⚠️ 個人檔案大頭貼載入失敗，已自動顯示預設底色');
              },
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              if (_playerID.isNotEmpty) ...[
                const SizedBox(height: 4),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                  builder: (context, snapshot) {
                    String displayID = _oldIDFromDB;
                    String characterName = l10n.profile_fallback_character;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      displayID = userData['playerID'] ?? _oldIDFromDB;
                      characterName = userData['currentCharacter'] ?? l10n.profile_fallback_character;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ID: $displayID',
                              style: TextStyle(
                                fontSize: 14,
                                color: subTextColor,
                                fontWeight: _hasChangedID ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: displayID));
                                ToastUtils.showCenterToast(
                                  context,
                                  l10n.toast_id_copied,
                                  customIcon: Icons.copy_rounded,
                                );
                              },
                              child: Tooltip(
                                message: _hasChangedID ? l10n.profile_id_locked : l10n.profile_copy_id,
                                child: Icon(Icons.copy, size: 14, color: subTextColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              l10n.profile_send_invite_btn,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(Icons.info_outline, color: Colors.pinkAccent),
                                          SizedBox(width: 8),
                                          Text(
                                            l10n.profile_referral_rule_title,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        l10n.profile_referral_rule_receiver,
                                        style: TextStyle(fontSize: 14, height: 1.5),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text(
                                            l10n.common_got_it,
                                            style: TextStyle(
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.help_outline_rounded,
                                size: 13,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                final shareText = l10n.profile_share_message(characterName, displayID);
                                await SharePlus.instance.share(
                                  ShareParams(text: shareText),
                                );
                              },
                              child: Icon(
                                Icons.share_rounded,
                                size: 13,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ],
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StorePage())
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[800]!.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryColor.withValues(alpha:0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                          isDarkMode ? 'assets/images/flower_gift_dark.png' : 'assets/images/flower_gift.png',
                          height: 20
                      ),
                      const SizedBox(width: 8),
                      Text(
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

    final userDoc = await _db.collection('users').doc(_userId).get();
    String? cloudID = userDoc.data()?['playerID'];

    if (cloudID != null && cloudID.isNotEmpty) {
      setState(() => _playerID = cloudID);
      await prefs.setString('playerID', cloudID);
    } else {
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
    final safePoints = points < 0 ? 0 : points;
    return NumberFormat('#,##0').format(safePoints);
  }

  String _generateRandomID(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> _fetchAllCharacterData() async {
    if (_userId == null) return;
    try {
      final responses = await Future.wait([
        _db.collection('artifacts').doc(_appId).collection('users').doc(_userId).collection('private_characters').orderBy('createdAt', descending: true).get(),
        _db.collection('artifacts').doc(_appId).collection('public_characters').orderBy('createdAt', descending: true).get(),
      ]);

      if (!mounted) return;

      final myPrivateCharacters = await Future.wait(
          responses[0].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      final allPublicCharacters = await Future.wait(
          responses[1].docs.map((doc) => Character.fromFirestoreAsync(doc)).toList()
      );

      final myPublicCharacters = allPublicCharacters
          .where((char) => char.createdBy == _userId)
          .toList();

      _myCharacters = [...myPrivateCharacters, ...myPublicCharacters];
      _myCharacters.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final friendsSnapshot = await _db.collection('users').doc(_userId).collection('friends').get();
      final Set<String> myFriendIds = friendsSnapshot.docs.map((doc) => doc.id).toSet();

      final allInteractableChars = <String, Character>{};

      for (var char in myPrivateCharacters) {
        allInteractableChars[char.id] = char;
      }

      for (var char in myPublicCharacters) {
        allInteractableChars[char.id] = char;
      }

      for (var char in allPublicCharacters) {
        if (myFriendIds.contains(char.id)) {
          allInteractableChars.putIfAbsent(char.id, () => char);
        }
      }

      _friendsList = allInteractableChars.values.toList();
      _friendsList.sort((a, b) => b.playCount.compareTo(a.playCount));

      setState(() {});

    } catch (e) {
      print('抓取角色資料時發生錯誤: $e');
    }
  }

  void _editProfile() {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const EditProfilePage(),
      ),
    ).then((didUpdate) async {
      if (didUpdate != true) return;

      await _loadProfileFromCache();

      if (!mounted) return;

      setState(() {});
    });
  }

  Future<void> _createCharacter() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const CharacterEditPage(),
      ),
    );

    if (!mounted || result == null) return;

    if (result['changed'] == true) {
      await _refreshData();
    }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(l10n.my_created_characters),
            _buildCreateCharacterButton(context),
          ],
        ),
        const SizedBox(height: 10),
        _myCharacters.isEmpty
            ? Center(
            child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 20.0),
                child: Text(l10n.empty_no_characters_created,
                    style: TextStyle(color: theme.colorScheme.onSurface
                        .withValues(alpha:0.7)))))
            : SizedBox(
          height: 230,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.25,
            ),
            itemCount: _myCharacters.length,
            itemBuilder: (context, index) {
              final character = _myCharacters[index];
              return _buildCharacterGridItem(character, isMyCharacter: true);
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.brush, size: 22),
            label: Text(
                l10n.enter_secret_studio,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                )
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatorStudioPage(),
                ),
              );

              if (!mounted) return;

              if (result == true) {
                await _refreshData();
              }
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

  Widget _buildCharacterGridItem(
      Character character, {
        bool isMyCharacter = false,
      }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () async {
        if (isMyCharacter) {
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CharacterEditPage(character: character),
            ),
          );

          if (!mounted || result == null) return;

          final bool changed = result['changed'] == true;
          final bool deleted = result['deleted'] == true;
          final String? deletedCharacterId =
          result['characterId']?.toString();
          final String? message =
          result['message']?.toString();

          if (deleted) {
            final idToRemove = deletedCharacterId ?? character.id;

            setState(() {
              _myCharacters.removeWhere((c) => c.id == idToRemove);
              _friendsList.removeWhere((c) => c.id == idToRemove);
            });

            if (message != null && message.isNotEmpty) {
              ToastUtils.showCenterToast(
                context,
                message,
                customIcon: Icons.person_remove_rounded,
              );
            }

            return;
          }

          if (changed) {
            await _refreshData();

            if (!mounted) return;

            if (message != null && message.isNotEmpty) {
              ToastUtils.showCenterToast(
                context,
                message,
                customIcon: Icons.manage_accounts_rounded,
              );
            }
          }
          return;
        } else {
          final currentUser = FirebaseAuth.instance.currentUser;

          if (character.isPublic) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterProfilePage(
                  characterId: character.id,
                  character: character,
                ),
              ),
            ).then((_) {
              _refreshData();
            });
          } else {
            if (currentUser != null && character.createdBy == currentUser.uid) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PrivateCharacterProfilePage(character: character),
                ),
              );
            } else {
              _showSecretDialog(character);
            }
          }
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
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _showSecretDialog(Character character) {
    final l10n = AppLocalizations.of(context)!;
    final avatarPath = character.avatarPath.trim();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(l10n.chat_secret_file_title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey[200],
                backgroundImage: avatarPath.isNotEmpty
                    ? getAvatarImageProvider(avatarPath)
                    : null,
                child: avatarPath.isEmpty
                    ? const Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 40,
                )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                character.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.chat_secret_file_desc,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.chat_understood, style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileTabBarDelegate
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _ProfileTabBarDelegate(
      this.tabBar, {
        required this.backgroundColor,
      });

  @override
  double get minExtent =>
      tabBar.preferredSize.height;

  @override
  double get maxExtent =>
      tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Material(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(
      covariant _ProfileTabBarDelegate oldDelegate,
      ) {
    return oldDelegate.tabBar != tabBar ||
        oldDelegate.backgroundColor !=
            backgroundColor;
  }
}
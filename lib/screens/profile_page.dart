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
  String _bio = '';
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
    if (user == null) return;

    final l10n = AppLocalizations.of(context)!;
    final trimmedId = inviterId.trim();

    if (trimmedId.isEmpty) return;

    // 🌟 總裁防禦第一槍：嚴格審查註冊時間，超過 3 天（72小時）直接無情封殺！
    final creationTime = user.metadata.creationTime ?? DateTime.now();
    final int hoursSinceCreation = DateTime.now().difference(creationTime).inHours;
    if (hoursSinceCreation > 72) {
      if (mounted) { // 💡 若有報錯，請記得替換為 context.mounted
        // ✨ 總裁防禦第一槍：超過新手保護期的輕量提示
        ToastUtils.showCenterToast(
          context,
          l10n.profile_referral_err_expired,
          isError: true, // 💡 紅色驚嘆號，明確告知規則限制
        );
      }
      return;
    }

// 🌟 總裁防禦第二槍：嚴禁自我崇拜（自己填自己）
    if (trimmedId == user.uid) {
      if (mounted) { // 💡 確保安全調用
        // ✨ 總裁級防呆：俐落擋下無效操作
        ToastUtils.showCenterToast(
          context,
          l10n.profile_referral_err_self,
          isError: true, // 💡 紅色驚嘆號，讓玩家馬上知道「這招行不通」
        );
      }
      return;
    }

    setState(() => _isBinding = true);

    try {
      final db = FirebaseFirestore.instance;
      final userRef = db.collection('users').doc(user.uid);
      final userDoc = await userRef.get();

      // 🌟 總裁防禦第三槍：終身限綁一次，有過綁定紀錄者不准再點
      if (userDoc.data()?['invitedBy'] != null) {
        if (mounted) { // 💡 如果有波浪底線記得換 context.mounted
          // ✨ 總裁防禦第三槍：溫柔擋下重複領取的企圖
          ToastUtils.showCenterToast(
            context,
            l10n.profile_referral_err_duplicate,
            isError: true, // 💡 紅色驚嘆號，明確告知「你已經有綁定對象囉」
          );
        }
        return;
      }

// 🌟 總裁防禦第四槍：虛擬代碼實體審查（檢查目標邀請人是否存在）
      final inviterDoc = await db.collection('users').doc(trimmedId).get();
      if (!inviterDoc.exists) {
        if (mounted) { // 💡 同上
          // ✨ 總裁防禦第四槍：查無此人的精準攔截
          ToastUtils.showCenterToast(
            context,
            l10n.profile_referral_err_not_found,
            isError: true, // 💡 紅色驚嘆號，提示玩家檢查是不是不小心打錯字了
          );
        }
        return;
      }

      // 🏆 通過重重考驗，正式締結星之契約
      await userRef.update({
        'invitedBy': trimmedId,
        'referralRewardClaimed': false, // 初始化狀態：已綁定，未達標
        'totalChatMessages': 0,         // 新人計數器初始化歸零
      });

      if (mounted) { // 💡 如果有波浪底線記得換 context.mounted
        // ✨ 總裁級：成功綁定推薦碼的慶祝回饋，完美的雙贏時刻！
        ToastUtils.showCenterToast(
          context,
          l10n.profile_referral_success,
          customIcon: Icons.handshake_rounded, // 💡 用「握手/結盟」的圖示，完美象徵邀請人與被邀請人建立起《戀戀拾光》的羈絆
        );
        _inviteCodeController.clear();
      }
    } catch (e) {
      debugPrint("🚨 總裁，資料庫綁定發生非預期錯誤: $e");
    } finally {
      if (mounted) setState(() => _isBinding = false);
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

    String? invitedBy = userData['invitedBy'];
    bool isClaimed = userData['referralRewardClaimed'] ?? false;

    final creationTime = user.metadata.creationTime ?? DateTime.now();
    final int hoursSinceCreation = DateTime.now().difference(creationTime).inHours;
    final bool isNewbie = hoursSinceCreation <= 72;

    // 測試期間強行現形：如需上線，解開下方註解即可
    if ((invitedBy != null && isClaimed) || (invitedBy == null && !isNewbie)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4), // 左右再往內縮一點
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // 縮減上下白邊 (14 -> 8)
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14), // 更秀氣的微圓角
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.06)), // 超細微邊框
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 小巧標題
          Text(
            l10n.profile_referral_title,
            style: TextStyle(
              fontSize: 12, // 縮小到 12 號字
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 6), // 緊湊間距

          if (invitedBy != null && !isClaimed)
          // 催促狀態同步縮小
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mark_chat_read_outlined, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.profile_referral_pending(
                          invitedBy.length > 5 ? '${invitedBy.substring(0, 5)}...' : invitedBy
                      ),
                      style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.65)),
                    ),
                  ),
                ],
              ),
            )
          else
          // 🌟 核心：極致扁平化的 32px 輸入列
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32, // 🌟 降至 32 像素！極致纖薄
                    child: TextField(
                      controller: _inviteCodeController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: l10n.profile_referral_hint,
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        filled: true,
                        fillColor: theme.disabledColor.withValues(alpha: 0.03),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 🌟 高度同步 32px 的小鈕
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: _isBinding
                        ? null
                        : () => _bindInviteCode(_inviteCodeController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isBinding
                        ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white),
                    )
                        : Text(l10n.profile_referral_bind_btn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6), // 給按鈕和問號一點呼吸空間
                GestureDetector(
                  onTap: () {
                    // 點擊後跳出精緻的說明彈窗
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
                                l10n.profile_copy_success,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          content:Text(
                            l10n.profile_referral_rule_receiver,
                            style: TextStyle(fontSize: 14, height: 1.5),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(), // 關閉彈窗
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
                  child: Container(
                    height: 32, // 配合前方的極致纖薄，讓點擊區域對齊
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 4, right: 4), // 增加手指點擊範圍
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 18,
                      color: Colors.grey.shade400, // 淺灰色完美融入畫面不搶戲
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
    final bool isAdmin = (currentUser?.uid == adminUid);
    final theme = Theme.of(context);

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
                pinned: false,
                floating: false,
                snap: false,
                backgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  // 🍎 終極隱藏術 4：如果是送審模式，直接讓這個背包按鈕人間蒸發！
                  if (!isAppleReviewMode)
                    IconButton(
                      tooltip: '我的背包',
                      icon: const Icon(Icons.card_giftcard),
                      onPressed: () async {
                        if (currentUser == null) return;

                        // 顯示讀取中提示
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          // 1. 去 Firebase 抓取當前玩家的 totalSpent
                          final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
                          int totalSpent = userDoc.data()?['totalSpent'] ?? 0;

                          // 2. 檢查是否已經填寫過實體地址
                          final addressDoc = await FirebaseFirestore.instance.collection('shipping_addresses').doc(currentUser.uid).get();
                          bool hasSubmittedAddress = addressDoc.exists;

                          // 關閉 Loading
                          if (mounted) Navigator.pop(context);

                          // 3. 彈出真正的「背包收藏與 VIP 獎勵總覽」
                          if (mounted) {
                            _showBackpackDialog(context, currentUser.uid, totalSpent, hasSubmittedAddress);
                          }
                        } catch (e) {
                          if (mounted) Navigator.pop(context);
                          debugPrint('讀取背包失敗: $e');
                        }
                      },
                    ),
                  IconButton(
                    tooltip: l10n.title_time_letters,
                    icon: Image.asset(
                      'assets/images/scroll_icon.png',
                      width: 26,
                      height: 26,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF6750A4),
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
                          ? Colors.white70
                          : Colors.black54,
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
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildProfileHeader(),

              if (_bio.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildProfileBio(),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildCheckInButton()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.auto_stories),
                      label: Text(l10n.tab_heartbeat_diary),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha:0.7),
                        foregroundColor: theme.colorScheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: _showHeartbeatDiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SizedBox.shrink();
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  return _buildReferralSection(userData);
                },
              ),
              const SizedBox(height: 12),
              _buildFriendsListSection(),
              const SizedBox(height: 24),
              _buildMyCharactersSection(),
              if (isAdmin) ...[
                const Divider(thickness: 2, color: Colors.pinkAccent),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('👑 主理人專屬區域', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                ),
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
                const SizedBox(height: 40),
              ],
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
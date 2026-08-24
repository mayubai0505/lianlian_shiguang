import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'heartbeat_diary_page.dart';
import '../repositories/character_repository.dart';
import '../services/moment_notification_service.dart';
import '../services/toast_utils.dart';
import '../utils/character_navigator.dart';
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
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // 🌟 加上這個！
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/moment_model.dart';
import 'moment_card.dart';
import 'edit_moment_page.dart';
import 'create_moment_page.dart';
import '../services/daily_task_service.dart';
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
  List<Map<String, String>> _profileLinks = [];
  bool _isBioExpanded = false;
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

  // --- 個人動態快取 ---
  // 第一次抓到後保留在 State 裡，切換 Tab / 滑動畫面時不再閃 loading。
  List<Moment> _cachedProfileMoments = <Moment>[];
  bool _profileMomentsLoaded = false;
  Object? _profileMomentsError;

  StreamSubscription? _pointsSubscription;
  StreamSubscription? _userDocSubscription;
  StreamSubscription<QuerySnapshot>? _profileMomentsSubscription;
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
  bool _isDefaultTheme(BuildContext context) {
    return Provider.of<ThemeNotifier>(
      context,
      listen: false,
    ).currentThemeEnum ==
        AppTheme.light;
  }


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
          _listenToProfileMoments();
          _checkIfBirthday();

          // 👇 🔥 第四步：在這裡加上 FB 大頭貼更新器！
          // 我們直接把 user 傳給函數，這樣就不用再抓一次 currentUser 了
          _refreshFacebookAvatar(user);
        }
      } else if (mounted) {
        _profileMomentsSubscription?.cancel();
        _profileMomentsSubscription = null;

        setState(() {
          _isLoading = false;
          _cachedProfileMoments = <Moment>[];
          _profileMomentsLoaded = false;
          _profileMomentsError = null;
        });
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
    _profileMomentsSubscription?.cancel();
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

        // 個人連結：直接使用玩家儲存在 users/{uid} 的 profileLinks。
        final rawProfileLinks = data['profileLinks'];
        _profileLinks = rawProfileLinks is List
            ? rawProfileLinks
            .whereType<Map>()
            .map(
              (item) => {
            'name': (item['name'] ?? '').toString().trim(),
            'url': (item['url'] ?? '').toString().trim(),
          },
        )
            .where((item) => (item['url'] ?? '').isNotEmpty)
            .toList()
            : <Map<String, String>>[];

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

    if (data.containsKey('profileLinks') && data['profileLinks'] is List) {
      final encoded = (data['profileLinks'] as List)
          .map((item) {
        if (item is Map) {
          return '${(item['name'] ?? '').toString().trim()}\t${(item['url'] ?? '').toString().trim()}';
        }
        return '';
      })
          .where((item) => item.isNotEmpty)
          .join('\n');
      await prefs.setString('profileLinksDisplayCache', encoded);
    }
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
          l10n.profilePageAlreadyCheckedIn,
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
          'likedMomentIds': <String>[],
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

    // 先確保進度是 Firebase 最新資料
    await _loadDailyTaskProgress();

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HeartbeatDiaryPage(
          title: l10n.tab_heartbeat_diary,

          // 這句等 UI 確認後，我們再正式補進多語系 ARB

          // 1. 閒話家常
          dailyChatTitle: l10n.tab_daily_chit_chat,
          dailyChatSubtitle: l10n.task_desc_chat_3_times,
          dailyChatProgress: _dailyChatProgress,
          dailyChatClaimed: _isDailyChatClaimed,
          onClaimDailyChat: (onSuccess) async {
            if (_isDailyChatClaimed || _dailyChatProgress < 3) {
              return;
            }

            await _claimTaskReward(
              l10n.tab_daily_chit_chat,
              'dailyChatProgress',
              'dailyChatClaimed',
              5,
                  () {
                if (mounted) {
                  setState(() {
                    _isDailyChatClaimed = true;
                  });
                }

                onSuccess();
              },
            );
          },

          // 2. 劇情推進
          storyTitle: l10n.tab_story_progression,
          storySubtitle: l10n.task_desc_story_1_time,
          storyProgress: _storyChatProgress,
          storyClaimed: _isStoryChatClaimed,
          onClaimStory: (onSuccess) async {
            if (_isStoryChatClaimed || _storyChatProgress < 1) {
              return;
            }

            await _claimTaskReward(
              l10n.tab_story_progression,
              'storyChatProgress',
              'storyChatClaimed',
              5,
                  () {
                if (mounted) {
                  setState(() {
                    _isStoryChatClaimed = true;
                  });
                }

                onSuccess();
              },
            );
          },

          // 3. 社群巡禮
          socialTitle: l10n.tab_social_tour,
          socialSubtitle: l10n.task_like_three_moments,
          socialProgress: _likeProgress,
          socialClaimed: _isLikeClaimed,
          onClaimSocial: (onSuccess) async {
            if (_isLikeClaimed || _likeProgress < 3) {
              return;
            }

            await _claimTaskReward(
              l10n.tab_social_tour,
              'likeProgress',
              'likeClaimed',
              5,
                  () {
                if (mounted) {
                  setState(() {
                    _isLikeClaimed = true;
                  });
                }

                onSuccess();
              },
            );
          },

          // 4. 星之契約
          monthlyTitle: l10n.task_monthly_title,
          monthlySubtitle: _hasActiveMonthlyCard
              ? l10n.task_monthly_subtitle_active
              : l10n.task_monthly_subtitle_inactive,
          hasActiveMonthlyCard: _hasActiveMonthlyCard,
          monthlyClaimed: _isMonthlyRewardClaimed,
          monthlyLockedText: l10n.task_monthly_locked,
          onClaimMonthly: (onSuccess) async {
            if (!_hasActiveMonthlyCard ||
                _isMonthlyRewardClaimed) {
              return;
            }

            await _claimTaskReward(
              l10n.task_monthly_log_name,
              '',
              'monthlyCardClaimed',
              10,
                  () {
                if (mounted) {
                  setState(() {
                    _isMonthlyRewardClaimed = true;
                  });
                }

                onSuccess();
              },
            );
          },

          claimText: l10n.btn_claim,
          claimedText: l10n.btn_claimed,
          incompleteText: l10n.btn_incomplete,
          closeText: l10n.common_close,
        ),
      ),
    );

    // 從心動日記回來後，再同步一次最新狀態
    if (mounted) {
      await _loadDailyTaskProgress();
    }
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


  void _listenToProfileMoments() {
    _profileMomentsSubscription?.cancel();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 如果是換帳號，先清掉上一個帳號的快取；
    // 同帳號重建 listener 時則保留舊畫面，不讓 UI 閃圈圈。
    if (_userId != user.uid) {
      _cachedProfileMoments = <Moment>[];
      _profileMomentsLoaded = false;
      _profileMomentsError = null;
    }

    _profileMomentsSubscription = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(_appId)
        .collection('moments')
        .where('createdBy', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        final updatedMoments = snapshot.docs
            .map((doc) => Moment.fromFirestore(doc))
            .toList();

        if (!mounted) return;

        setState(() {
          _cachedProfileMoments = updatedMoments;
          _profileMomentsLoaded = true;
          _profileMomentsError = null;
        });
      },
      onError: (error) {
        debugPrint('❌ 個人動態背景同步失敗：$error');

        if (!mounted) return;

        setState(() {
          _profileMomentsLoaded = true;
          _profileMomentsError = error;
        });
      },
    );
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

        final cachedLinks = prefs.getString('profileLinksDisplayCache') ?? '';
        _profileLinks = cachedLinks
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) {
          final parts = line.split('\t');
          return <String, String>{
            'name': parts.isNotEmpty ? parts.first.trim() : '',
            'url': parts.length > 1 ? parts.sublist(1).join('\t').trim() : '',
          };
        })
            .where((item) => (item['url'] ?? '').isNotEmpty)
            .toList();
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
        l10n.profilePageReferralBindFailed,
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
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.profile_referral_title,
            style: GoogleFonts.notoSerifTc(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: 46,
            height: 1.6,
            color: theme.colorScheme.primary.withValues(alpha: 0.65),
          ),
          const SizedBox(height: 18),

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
                        Text(
                          l10n.profilePageReferralCompleted,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          l10n.profilePageInviter(inviterDisplayId),
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.65),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          l10n.profilePageReferralRewardReceived,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    l10n.profilePageClaimed,
                    style: const TextStyle(
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
                          l10n.profilePageInviterBound(inviterDisplayId),
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
                    l10n.profilePageReferralProgressHint,
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
    final l10n = AppLocalizations.of(context)!;
    final bioStyle = GoogleFonts.notoSerifTc(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
      fontSize: 14,
      height: 1.85,
      letterSpacing: 0.35,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -28,
          bottom: -20,
          width: 150,
          height: 270,
          child: IgnorePointer(
            child: Opacity(
              opacity: theme.brightness == Brightness.dark ? 0.07 : 0.16,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  'assets/images/profile/about_botanical_mask.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'zh'
                  ? '關於我'
                  : l10n.profilePageAboutMe,
              style: GoogleFonts.notoSerifTc(
                color: theme.colorScheme.onSurface,
                fontSize: 21,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: 46,
              height: 1.6,
              color: theme.colorScheme.primary.withValues(alpha: 0.65),
            ),
            const SizedBox(height: 22),

            LayoutBuilder(
              builder: (context, constraints) {
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: _bio,
                    style: bioStyle,
                  ),
                  maxLines: 4,
                  textDirection: Directionality.of(context),
                  textScaler: MediaQuery.textScalerOf(context),
                )..layout(maxWidth: constraints.maxWidth);

                final bool hasOverflow =
                    textPainter.didExceedMaxLines;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _bio,
                      maxLines: _isBioExpanded ? null : 4,
                      overflow: _isBioExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: bioStyle,
                    ),
                    if (hasOverflow) ...[
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isBioExpanded = !_isBioExpanded;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                            theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                          child: Text(
                            _isBioExpanded
                                ? l10n.characterProfileCollapse
                                : l10n.characterProfileViewMore,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ],
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

    final profileTheme = theme.copyWith(
      textTheme: GoogleFonts.notoSerifTcTextTheme(theme.textTheme),
      primaryTextTheme:
      GoogleFonts.notoSerifTcTextTheme(theme.primaryTextTheme),
    );

    return Theme(
      data: profileTheme,
      child: Container(
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
                  title: null,
                  toolbarHeight: 54,
                  pinned: true,
                  floating: false,
                  backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor,
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    IconButton(
                      tooltip: '公告',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AnnouncementListPage(),
                          ),
                        );
                      },
                      icon: Transform.translate(
                        offset: const Offset(15, -3),
                        child: _buildTintedProfileAsset(
                          maskAsset:
                          'assets/images/profile/announcement_mask.png',
                          size: 40,
                          color: theme.colorScheme.primary,
                          opacity: 0.62,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: '設定',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                      icon: _buildTintedProfileAsset(
                        maskAsset:
                        'assets/images/profile/top_settings_mask.png',
                        size: 40,
                        color: theme.colorScheme.primary,
                        opacity: 0.62,
                      ),
                    ),

                    // 舊入口保留在程式中，但不顯示在目前版面。
                    if (false) ...[
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

                      // 👑 管理後台（只有管理員）
                      if (isAdmin)
                        IconButton(
                          tooltip: '管理後台',
                          icon: Icon(
                            Icons.admin_panel_settings_rounded,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : const Color(0xFF6750A4),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminAnnouncementPage(),
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
                  ],
                ),

                SliverToBoxAdapter(
                  child: _buildEditorialProfileHeader(),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate:
                  _ProfileTabBarDelegate(
                    TabBar(
                      controller: _profileTabController,

                      labelColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFC9BDF0)
                          : const Color(0xFF9586C7),
                      unselectedLabelColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.42),

                      indicatorColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFC9BDF0)
                          : const Color(0xFF9B86C9),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 1.6,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                      const WidgetStatePropertyAll<Color>(Colors.transparent),

                      labelStyle: GoogleFonts.notoSerifTc(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                      unselectedLabelStyle: GoogleFonts.notoSerifTc(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),

                      tabs: [
                        Tab(height: 48, text: l10n.profilePageTabCharacters),
                        Tab(height: 48, text: l10n.profilePageTabMoments),
                        Tab(
                          height: 48,
                          text: Localizations.localeOf(context).languageCode == 'zh'
                              ? '自我介紹'
                              : l10n.profilePageTabBio,
                        ),
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
                _buildCharactersTab(),
                _buildMomentsTab(),
                _buildAboutMeTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openProfileBackpack(User? currentUser) async {
    if (currentUser == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final int totalSpent =
          (userDoc.data()?['totalSpent'] as num?)?.toInt() ?? 0;
      final addressDoc = await FirebaseFirestore.instance
          .collection('shipping_addresses')
          .doc(currentUser.uid)
          .get();

      if (!mounted) return;
      Navigator.pop(context);
      _showBackpackDialog(
        context,
        currentUser.uid,
        totalSpent,
        addressDoc.exists,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      debugPrint('讀取背包失敗: $e');
    }
  }

  void _showProfileUtilityMenu({
    required User? currentUser,
    required bool isAdmin,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isAppleReviewMode)
                ListTile(
                  leading: const Icon(Icons.card_giftcard_outlined),
                  title: const Text('我的背包'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openProfileBackpack(currentUser);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.mail_outline_rounded),
                title: Text(l10n.title_time_letters),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AnnouncementListPage(),
                    ),
                  );
                },
              ),
              if (isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: const Text('管理後台'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminAnnouncementPage(),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }


  Color _darkenProfileIconColor(
      Color color, {
        double amount = 0.12,
      }) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Widget _buildLayeredProfileIcon({
    required String baseAsset,
    required String outlineAsset,
    required String highlightAsset,
    required String shadowAsset,
    required double size,
    double opacity = 1.0,
  }) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.primary;
    //final outlineColor = _darkenProfileIconColor(baseColor);

    Widget tintedLayer(
        String asset,
        Color color,
        ) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    return Opacity(
      opacity: opacity,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            // 1. 陰影：固定低透明黑，不會跟馬卡龍主題打架
            tintedLayer(
              shadowAsset,
              Colors.black.withValues(alpha: 0.10),
            ),

            // 2. 主體：直接跟著目前主題色
            tintedLayer(
              baseAsset,
              baseColor,
            ),

            // 3. 描邊：先關掉測試，避免雙線
// tintedLayer(
//   outlineAsset,
//   outlineColor,
// ),

            // 4. 高光：不染色，永遠保留原本白色高光
            Image.asset(
              highlightAsset,
              width: size,
              height: size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInButton() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: (_isClaimingCheckIn || _hasCheckedInToday)
          ? null
          : _performCheckIn,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDarkMode
              ? theme.colorScheme.surface.withValues(alpha: 0.72)
              : Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.055),
          ),
          boxShadow: isDarkMode
              ? null
              : [
            BoxShadow(
              color:
              theme.colorScheme.primary.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: Center(
                child: _isClaimingCheckIn
                    ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: theme.colorScheme.primary,
                  ),
                )
                    : _buildLayeredProfileIcon(
                  baseAsset:
                  'assets/images/profile_icons/checkin_base.png',
                  outlineAsset:
                  'assets/images/profile_icons/checkin_outline.png',
                  highlightAsset:
                  'assets/images/profile_icons/checkin_highlight.png',
                  shadowAsset:
                  'assets/images/profile_icons/checkin_shadow.png',
                  size: 34,
                  opacity: _hasCheckedInToday ? 0.58 : 1.0,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  Localizations.localeOf(context).languageCode == 'zh'
                      ? (_hasCheckedInToday ? '已簽到' : '簽到')
                      : (_hasCheckedInToday
                      ? l10n.profilePageAlreadyCheckedIn
                      : l10n.status_daily_sign_in),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _hasCheckedInToday
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.55)
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            if (!_hasCheckedInToday)
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.32),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildTintedProfileAsset({
    required String maskAsset,
    double size = 90,
    Color? color,
    double opacity = 1,
    String? overlayMaskAsset,
    Color? overlayColor,
  }) {
    final theme = Theme.of(context);

    Widget layer(String asset, Color tint) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      );
    }

    return Opacity(
      opacity: opacity,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            layer(
              maskAsset,
              color ?? theme.colorScheme.primary.withValues(alpha: 0.72),
            ),
            if (overlayMaskAsset != null)
              layer(
                overlayMaskAsset,
                overlayColor ?? theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorialProfileHeader() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: 0.52);
    final localeIsChinese = Localizations.localeOf(context).languageCode == 'zh';
    final totalLikes = _myCharacters.fold<int>(
      0,
          (total, character) => total + character.likesCount,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pageWidth = constraints.maxWidth;
                final pageHeight = constraints.maxHeight;

                // 依每支手機的 Header 實際尺寸自動計算，
                // 並加上上下限，避免小螢幕過擠、大螢幕過大。
                final leftWidth =
                (pageWidth * 0.42).clamp(145.0, 180.0).toDouble();
                final rightWidth =
                (pageWidth * 0.44).clamp(150.0, 185.0).toDouble();
                final leftTop =
                (-pageHeight * 0.018).clamp(-18.0, -8.0).toDouble();
                final rightTop =
                (pageHeight * 0.05).clamp(30.0, 48.0).toDouble();
                final bottomInset =
                (pageHeight * 0.014).clamp(8.0, 16.0).toDouble();
                final leftOverflow = -(pageWidth * 0.004);
                final rightOverflow = -(pageWidth * 0.034);

                return Stack(
                  children: [
                    Positioned(
                      left: leftOverflow,
                      top: leftTop,
                      bottom: bottomInset,
                      width: leftWidth,
                      child: Opacity(
                        opacity: isDarkMode ? 0.07 : 0.13,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/profile/botanical_left_mask.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: rightOverflow,
                      top: rightTop,
                      bottom: bottomInset,
                      width: rightWidth,
                      child: Opacity(
                        opacity: isDarkMode ? 0.07 : 0.12,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/profile/botanical_right_mask.png',
                            fit: BoxFit.contain,
                            alignment: Alignment.centerRight,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isBirthdayToday
                      ? [
                    BoxShadow(
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.22),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                      : null,
                ),
                child: CircleAvatar(
                  radius: 47,
                  backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.07),
                  backgroundImage: getAvatarImageProvider(_avatarPath),
                  onBackgroundImageError: (exception, stackTrace) {
                    debugPrint('⚠️ 個人檔案大頭貼載入失敗');
                  },
                ),
              ),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 23,
                        height: 1.2,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (_isBirthdayToday) ...[
                    const SizedBox(width: 7),
                    Icon(
                      Icons.cake_outlined,
                      size: 17,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              StreamBuilder<DocumentSnapshot>(
                stream: currentUser == null
                    ? null
                    : FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String displayID = _oldIDFromDB;
                  String characterName = l10n.profile_fallback_character;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data =
                    snapshot.data!.data() as Map<String, dynamic>;
                    displayID = data['playerID']?.toString() ?? _oldIDFromDB;
                    characterName = data['currentCharacter']?.toString() ??
                        l10n.profile_fallback_character;
                  }

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: displayID));
                          ToastUtils.showCenterToast(
                            context,
                            l10n.toast_id_copied,
                            customIcon: Icons.copy_rounded,
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '@$displayID',
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 12.5,
                                  color: secondaryColor,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.copy_rounded,
                                size: 13,
                                color: secondaryColor.withValues(alpha: 0.72),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 14,
                        runSpacing: 4,
                        children: [
                          InkWell(
                            onTap: _editProfile,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildTintedProfileAsset(
                                    maskAsset: 'assets/images/profile/profile_quill_mask.png',
                                    size: 22,
                                    color: theme.colorScheme.primary,
                                    opacity: 0.78,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    l10n.profilePageEditProfile,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 12.5,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: kIsWeb
                                ? null
                                : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StorePage(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    isDarkMode
                                        ? 'assets/images/flower_gift_dark.png'
                                        : 'assets/images/flower_gift.png',
                                    width: 17,
                                    height: 17,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _formatPoints(
                                      _flowerPoints < 0 ? 0 : _flowerPoints,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final shareText = l10n.profile_share_message(
                                characterName,
                                displayID,
                              );
                              await SharePlus.instance.share(
                                ShareParams(text: shareText),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(
                                Icons.share_outlined,
                                size: 15,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildProfileStatItem(
                      value: _myCharacters.length,
                      label: l10n.profilePageTabCharacters,
                      onTap: () => _profileTabController.animateTo(0),
                    ),
                  ),
                  Expanded(
                    child: _buildProfileStatItem(
                      value: _cachedProfileMoments.length,
                      label: l10n.profilePageTabMoments,
                      onTap: () => _profileTabController.animateTo(1),
                    ),
                  ),
                  Expanded(
                    child: _buildProfileStatItem(
                      value: totalLikes,
                      label: localeIsChinese ? '喜歡' : 'Likes',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildEditorialShortcut(
                      onTap: (_isClaimingCheckIn || _hasCheckedInToday)
                          ? null
                          : _performCheckIn,
                      icon: _isClaimingCheckIn
                          ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.7,
                          color: theme.colorScheme.primary,
                        ),
                      )
                          : _buildTintedProfileAsset(
                        maskAsset:
                        'assets/images/profile/calendar_base_mask.png',
                        overlayMaskAsset: _hasCheckedInToday
                            ? 'assets/images/profile/calendar_check_mask.png'
                            : null,
                        size: 82,
                        opacity: _hasCheckedInToday ? 0.72 : 0.92,
                      ),
                      title: localeIsChinese
                          ? (_hasCheckedInToday ? '已簽到' : '簽到')
                          : (_hasCheckedInToday
                          ? l10n.profilePageAlreadyCheckedIn
                          : l10n.status_daily_sign_in),
                      subtitle: localeIsChinese
                          ? (_hasCheckedInToday ? '今天已留下足跡' : '今日尚未簽到')
                          : null,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 82,
                    color: textColor.withValues(alpha: 0.07),
                  ),
                  Expanded(
                    child: _buildEditorialShortcut(
                      onTap: _showHeartbeatDiary,
                      icon: _buildTintedProfileAsset(
                        maskAsset:
                        'assets/images/profile/heart_diary_mask.png',
                        size: 82,
                        opacity: 0.92,
                      ),
                      title: l10n.profilePageHeartbeatDiary,
                      subtitle: localeIsChinese ? '記下心動瞬間' : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditorialShortcut({
    required Widget icon,
    required String title,
    required VoidCallback? onTap,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      splashColor: theme.colorScheme.primary.withValues(alpha: 0.06),
      highlightColor: theme.colorScheme.primary.withValues(alpha: 0.035),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Column(
          children: [
            SizedBox(height: 82, child: Center(child: icon)),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 11,
                  color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.43),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 26,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
    );
  }

  Widget _buildProfileShortcut({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface.withValues(alpha: 0.72)
              : Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.055),
          ),
          boxShadow: theme.brightness == Brightness.dark
              ? null
              : [
            BoxShadow(
              color:
              theme.colorScheme.primary.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: Center(child: iconWidget),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.32),
            ),
          ],
        ),
      ),
    );
  }


  void _showMyCharacterActions(
      Character character,
      ) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.profilePageEditCharacter),
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
                title: Text(l10n.profilePagePreviewCharacter),
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
              style: GoogleFonts.notoSerifTc(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.notoSerifTc(
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

  Future<void> _openProfileLink(String rawUrl) async {
    String normalized = rawUrl.trim();
    if (normalized.isEmpty) return;

    // 玩家若只輸入 instagram.com/xxx 這種網址，自動補 https://
    if (!normalized.startsWith('http://') &&
        !normalized.startsWith('https://')) {
      normalized = 'https://$normalized';
    }

    final uri = Uri.tryParse(normalized);

    // 個人頁只允許一般網頁連結，避免自訂 scheme / deep link 被濫用。
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '連結格式不正確',
        isError: true,
      );
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ToastUtils.showCenterToast(
          context,
          '無法開啟這個連結',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('❌ 開啟個人連結失敗：$e');

      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '無法開啟這個連結',
        isError: true,
      );
    }
  }

  Widget _buildProfileLinksSection() {
    final theme = Theme.of(context);

    final visibleLinks = _profileLinks
        .where((item) => (item['url'] ?? '').trim().isNotEmpty)
        .toList();

    if (visibleLinks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleLinks.map((item) {
          final name = (item['name'] ?? '').trim();
          final url = (item['url'] ?? '').trim();

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 0,
                  child: Text(
                    name.isEmpty ? '我的連結' : name,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 13,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                    ),
                  ),
                ),
                Text(
                  '：',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 13,
                    height: 1.55,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _openProfileLink(url),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 12.5,
                                height: 1.6,
                                color: theme.colorScheme.primary.withValues(alpha: 0.82),
                                decoration: TextDecoration.underline,
                                decorationColor:
                                theme.colorScheme.primary.withValues(alpha: 0.34),
                                decorationThickness: 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 13,
                            color: theme.colorScheme.primary.withValues(alpha: 0.58),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAboutMeTab() {
    final currentUser =
        FirebaseAuth.instance.currentUser;
    final hasProfileLinks = _profileLinks.any(
          (item) => (item['url'] ?? '').trim().isNotEmpty,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      children: [
        if (_bio.isNotEmpty)
          _buildProfileBio()
        else
          _buildEmptyBioCard(),

        if (hasProfileLinks) ...[
          const SizedBox(height: 22),
          Divider(
            height: 1,
            thickness: 0.7,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.14),
          ),
          const SizedBox(height: 18),

          _buildProfileLinksSection(),

          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 0.7,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.14),
          ),
          const SizedBox(height: 24),
        ] else ...[
          const SizedBox(height: 24),
          Divider(
            height: 1,
            thickness: 0.7,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.14),
          ),
          const SizedBox(height: 24),
        ],

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

        const SizedBox(height: 24),

        _buildFriendsListSection(),
      ],
    );
  }
  Widget _buildEmptyBioCard() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: _editProfile,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 36,
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.65),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profilePageNoBio,
              style: GoogleFonts.notoSerifTc(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.profilePageNoBioHint,
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
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 12, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatorStudioPage(),
                        ),
                      );
                      if (!mounted) return;
                      if (result == true) {
                        await _refreshData();
                      }
                    },
                    icon: Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                    ),
                    label: Text(
                      l10n.enter_secret_studio,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                  const SizedBox(width: 2),
                  IconButton(
                    tooltip: l10n.profilePageCreateCharacter,
                    onPressed: _createCharacter,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.add_rounded,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
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
                      size: 56,
                      color: theme.colorScheme.primary.withValues(alpha: 0.38),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.profilePageNoCharacters,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      l10n.profilePageNoCharactersHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              sliver: SliverGrid(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
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

  Future<void> _openMyCharacterEditor(Character character) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterEditPage(character: character),
      ),
    );

    if (!mounted || result == null) return;

    final changed = result['changed'] == true;
    final deleted = result['deleted'] == true;
    final deletedCharacterId = result['characterId']?.toString();
    final message = result['message']?.toString();

    if (deleted) {
      final idToRemove = deletedCharacterId ?? character.id;
      CharacterRepository.invalidate(idToRemove);
      setState(() {
        _myCharacters.removeWhere((item) => item.id == idToRemove);
        _friendsList.removeWhere((item) => item.id == idToRemove);
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
      CharacterRepository.invalidate(character.id);
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
  }

  Widget _buildMyCharacterCard(Character character) {
    final theme = Theme.of(context);
    final imagePath = character.avatarPath.trim().isNotEmpty
        ? character.avatarPath
        : 'assets/images/avatar1.png';

    return InkWell(
      onTap: () => _openMyCharacterEditor(character),
      borderRadius: BorderRadius.circular(13),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: getAvatarImageProvider(imagePath),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => Container(
                color: theme.colorScheme.primary.withValues(alpha: 0.07),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 52,
                  color: theme.colorScheme.primary.withValues(alpha: 0.32),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.48),
                    ],
                    stops: const [0, 0.62, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 40,
              bottom: 12,
              child: Row(
                children: [
                  Icon(
                    character.isPublic
                        ? Icons.public_rounded
                        : Icons.lock_outline_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                tooltip: AppLocalizations.of(context)!
                    .profilePageCharacterActions,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.20),
                  foregroundColor: Colors.white.withValues(alpha: 0.90),
                ),
                icon: const Icon(Icons.more_horiz_rounded, size: 18),
                onPressed: () => _showMyCharacterActions(character),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyMyCharacterCard(Character character) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
        final result =
        await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CharacterEditPage(
                  character: character,
                ),
          ),
        );

        if (!mounted || result == null) {
          return;
        }

        final bool changed =
            result['changed'] == true;
        final bool deleted =
            result['deleted'] == true;

        final String? deletedCharacterId =
        result['characterId']?.toString();

        final String? message =
        result['message']?.toString();

        if (deleted) {
          final String idToRemove =
              deletedCharacterId ?? character.id;

          // 🧹 刪除後清除角色快取
          CharacterRepository.invalidate(
            idToRemove,
          );

          setState(() {
            _myCharacters.removeWhere(
                  (item) => item.id == idToRemove,
            );

            _friendsList.removeWhere(
                  (item) => item.id == idToRemove,
            );
          });

          if (message != null &&
              message.isNotEmpty) {
            ToastUtils.showCenterToast(
              context,
              message,
              customIcon:
              Icons.person_remove_rounded,
            );
          }

          return;
        }

        if (changed) {
          // 🧹 修改後清除舊角色快取
          CharacterRepository.invalidate(
            character.id,
          );

          await _refreshData();

          if (!mounted) {
            return;
          }

          if (message != null &&
              message.isNotEmpty) {
            ToastUtils.showCenterToast(
              context,
              message,
              customIcon:
              Icons.manage_accounts_rounded,
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
              color: Colors.black.withValues(
                alpha: 0.06,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: getAvatarImageProvider(
                      imagePath,
                    ),
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: primaryColor
                            .withValues(
                          alpha: 0.08,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 56,
                          color: primaryColor
                              .withValues(
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
                      color: Colors.black
                          .withValues(
                        alpha: 0.48,
                      ),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: l10n.profilePageCharacterActions,
                        visualDensity:
                        VisualDensity.compact,
                        iconSize: 18,
                        color: Colors.white,
                        onPressed: () {
                          _showMyCharacterActions(
                            character,
                          );
                        },
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                        ),
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
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color:
                      theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: character.isPublic
                          ? Colors.green.withValues(
                        alpha: 0.10,
                      )
                          : theme
                          .colorScheme.onSurface
                          .withValues(
                        alpha: 0.07,
                      ),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          character.isPublic
                              ? Icons.public_rounded
                              : Icons
                              .lock_outline_rounded,
                          size: 12,
                          color: character.isPublic
                              ? Colors.green
                              : theme
                              .colorScheme
                              .onSurface
                              .withValues(
                            alpha: 0.55,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          character.isPublic
                              ? l10n.profilePagePublic
                              : l10n.profilePagePrivate,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w600,
                            color:
                            character.isPublic
                                ? Colors.green
                                : theme
                                .colorScheme
                                .onSurface
                                .withValues(
                              alpha:
                              0.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons
                            .play_circle_outline_rounded,
                        size: 15,
                        color: theme
                            .colorScheme.onSurface
                            .withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPoints(playCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme
                              .colorScheme.onSurface
                              .withValues(
                            alpha: 0.58,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Icon(
                        Icons.favorite_border_rounded,
                        size: 15,
                        color: theme
                            .colorScheme.onSurface
                            .withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPoints(likesCount),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme
                              .colorScheme.onSurface
                              .withValues(
                            alpha: 0.58,
                          ),
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
    final l10n = AppLocalizations.of(context)!;

    if (currentUser == null) return;

    String creatorName =
    _nickname.trim().isNotEmpty ? _nickname : l10n.profilePageCreator;

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Text(
                    l10n.profilePageSelectPostingIdentity,
                    style: const TextStyle(
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
                        subtitle: Text(l10n.profilePagePostAsCreator),
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
                                ? l10n.profilePagePublicCharacter
                                : l10n.profilePagePrivateCharacter,
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
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text(l10n.profilePagePleaseSignIn),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _showProfileAuthorSelectionSheet,
                  icon: _buildTintedProfileAsset(
                    maskAsset: 'assets/images/profile/profile_quill_mask.png',
                    size: 22,
                    color: theme.colorScheme.primary,
                    opacity: 0.72,
                  ),
                  label: Text(
                    Localizations.localeOf(context).languageCode == 'zh'
                        ? '寫下此刻'
                        : l10n.profilePagePublishMoment,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary.withValues(alpha: 0.78),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                0,
                22,
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildProfileMomentFilterChip(
                      label: l10n.profilePageFilterAll,
                      value: 'all',
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: _buildProfileMomentFilterChip(
                      label: l10n.profilePageFilterCreator,
                      value: 'creator',
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: _buildProfileMomentFilterChip(
                      label: l10n.profilePageFilterCharacter,
                      value: 'character',
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  // 只有 App 這次生命週期中「從來沒有拿到過動態資料」時
                  // 才顯示一次 loading。之後 Tab 重建、左右切換都沿用快取。
                  if (!_profileMomentsLoaded &&
                      _cachedProfileMoments.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // 如果背景同步暫時失敗，但手上還有舊資料，
                  // 繼續顯示舊資料，不讓玩家突然看到錯誤頁。
                  if (_profileMomentsError != null &&
                      _cachedProfileMoments.isEmpty) {
                    debugPrint(
                      '❌ 個人動態讀取失敗：$_profileMomentsError',
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
                        Text(
                          l10n.profilePageMomentsLoadFailed,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.profilePageTryAgainLater,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    );
                  }

                  final moments =
                  _cachedProfileMoments.where((moment) {
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
                        emptyTitle =
                            l10n.profilePageNoCreatorMoments;
                        emptyDescription =
                            l10n.profilePageNoCreatorMomentsHint;
                        break;

                      case 'character':
                        emptyTitle =
                            l10n.profilePageNoCharacterMoments;
                        emptyDescription =
                            l10n.profilePageNoCharacterMomentsHint;
                        break;

                      default:
                        emptyTitle = l10n.profilePageNoMoments;
                        emptyDescription =
                            l10n.profilePageNoMomentsHint;
                    }

                    return ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
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
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      24,
                    ),
                    itemCount: moments.length,
                    itemBuilder: (context, index) {
                      final moment = moments[index];

                      return Column(
                        key: ValueKey(moment.id),
                        children: [
                          MomentCard(
                            moment: moment,
                            currentUserId: currentUser.uid,
                            showFeatureTips: false,

                            onLikeTapped: () async {
                              await _handleProfileMomentLike(moment);
                            },

                            onEditTapped: () {
                              _editProfileMoment(moment);
                            },

                            onDeleteTapped: () {
                              _deleteProfileMoment(moment.id);
                            },

                            onAvatarTapped: () {
                              _openProfileMomentAuthor(moment);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Divider(
                              height: 28,
                              thickness: 0.7,
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.12),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );

        // NestedScrollView 的個人資料區尚未收合時，分頁可用高度可能
        // 暫時小於工具列本身；改為可捲動，避免 RenderFlex overflow。
        if (constraints.maxHeight < 120) {
          return SingleChildScrollView(
            child: SizedBox(
              height: 120,
              child: content,
            ),
          );
        }

        return content;
      },
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
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.only(bottom: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.75)
                  : Colors.transparent,
              width: 1.7,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSerifTc(
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.54),
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
    final l10n = AppLocalizations.of(context)!;
    final bool confirm =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(l10n.profilePageDeleteMomentTitle),
              content: Text(
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
                  child: Text(l10n.profilePageCancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child: Text(
                    l10n.profilePageDelete,
                    style: const TextStyle(
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
        l10n.profilePageMomentDeleted,
        customIcon:
        Icons.delete_outline_rounded,
      );
    } catch (e) {
      debugPrint('❌ 刪除動態失敗：$e');

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.profilePageDeleteFailed,
        isError: true,
      );
    }
  }
  Future<void> _handleProfileMomentLike(
      Moment moment,
      ) async {
    try {
      final result =
      await DailyTaskService.recordMomentLike(
        momentId: moment.id,
      );

      if (!mounted) return;

      setState(() {
        _likeProgress = result.progress;
      });

      // 個人主頁按讚也要發通知
      await MomentNotificationService()
          .createMomentNotification(
        momentId: moment.id,
        type: 'like',
      );

      if (!mounted) return;

      if (result.completedNow &&
          !_isLikeClaimed) {
        final l10n =
        AppLocalizations.of(context)!;

        ToastUtils.showCenterToast(
          context,
          l10n.task_social_tour_complete,
          customIcon: Icons.tour_rounded,
        );
      }
    } catch (e) {
      debugPrint(
        '個人主頁社群巡禮紀錄失敗：$e',
      );
    }
  }
  void _openProfileMomentAuthor(
      Moment moment,
      ) {
    final l10n = AppLocalizations.of(context)!;
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
        l10n.profilePageCharacterNotFound,
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

    final userId = _userId!;

    final privateQuery = _db
        .collection('artifacts')
        .doc(_appId)
        .collection('users')
        .doc(userId)
        .collection('private_characters')
        .orderBy('createdAt', descending: true);

    // ✅ 只查「自己建立的公開角色」，
    // 不再把全平台 public_characters 全部抓回來再過濾。
    final myPublicQuery = _db
        .collection('artifacts')
        .doc(_appId)
        .collection('public_characters')
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    Future<List<Character>> parseCharacters(
        QuerySnapshot<Map<String, dynamic>> snapshot,
        ) async {
      return Future.wait(
        snapshot.docs
            .map((doc) => Character.fromFirestoreAsync(doc))
            .toList(),
      );
    }

    Future<void> applyMyCharacters(
        QuerySnapshot<Map<String, dynamic>> privateSnapshot,
        QuerySnapshot<Map<String, dynamic>> publicSnapshot,
        ) async {
      final privateCharacters =
      await parseCharacters(privateSnapshot);
      final publicCharacters =
      await parseCharacters(publicSnapshot);

      final combined = <Character>[
        ...privateCharacters,
        ...publicCharacters,
      ]..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      if (!mounted) return;

      setState(() {
        _myCharacters = combined;
      });
    }

    // ============================================
    // ① 先讀 Firestore 本機快取
    // ============================================
    // 有快取時幾乎立刻把角色顯示出來，不必等網路。
    try {
      final cachedResponses = await Future.wait([
        privateQuery.get(
          const GetOptions(source: Source.cache),
        ),
        myPublicQuery.get(
          const GetOptions(source: Source.cache),
        ),
      ]);

      if (cachedResponses[0].docs.isNotEmpty ||
          cachedResponses[1].docs.isNotEmpty) {
        await applyMyCharacters(
          cachedResponses[0],
          cachedResponses[1],
        );
      }
    } catch (e) {
      // 第一次安裝或尚未建立 Firestore cache 時很正常，
      // 不顯示錯誤，直接進入伺服器抓取。
      debugPrint('ℹ️ 個人角色本機快取尚未建立：$e');
    }

    // ============================================
    // ② 背景抓最新角色
    // ============================================
    try {
      final serverResponses = await Future.wait([
        privateQuery.get(),
        myPublicQuery.get(),
      ]);

      await applyMyCharacters(
        serverResponses[0],
        serverResponses[1],
      );
    } catch (e) {
      debugPrint('❌ 抓取自己的角色資料時發生錯誤: $e');
    }

    // ============================================
    // ③ 好友列表另外背景更新
    // ============================================
    // 這段不再卡住「我的角色」顯示。
    try {
      final friendsSnapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('friends')
          .get();

      final Set<String> myFriendIds =
      friendsSnapshot.docs.map((doc) => doc.id).toSet();

      // 自己的角色已經在 _myCharacters 裡，直接先放入。
      final allInteractableChars = <String, Character>{
        for (final char in _myCharacters) char.id: char,
      };

      if (myFriendIds.isNotEmpty) {
        // Firestore whereIn 單次數量有限制，因此分批查詢。
        const batchSize = 10;
        final friendIds = myFriendIds.toList();

        for (int i = 0; i < friendIds.length; i += batchSize) {
          final end = (i + batchSize < friendIds.length)
              ? i + batchSize
              : friendIds.length;

          final batch = friendIds.sublist(i, end);

          final friendPublicSnapshot = await _db
              .collection('artifacts')
              .doc(_appId)
              .collection('public_characters')
              .where(FieldPath.documentId, whereIn: batch)
              .get();

          final friendCharacters =
          await parseCharacters(friendPublicSnapshot);

          for (final char in friendCharacters) {
            allInteractableChars.putIfAbsent(
              char.id,
                  () => char,
            );
          }
        }
      }

      final updatedFriends =
      allInteractableChars.values.toList()
        ..sort(
              (a, b) => b.playCount.compareTo(a.playCount),
        );

      if (!mounted) return;

      setState(() {
        _friendsList = updatedFriends;
      });
    } catch (e) {
      debugPrint('⚠️ 好友角色背景更新失敗：$e');
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
        style: GoogleFonts.notoSerifTc(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.onSurface));
  }

  Widget _buildFriendsListSection() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(l10n.title_my_friends),
            TextButton(
              onPressed: _showAllFriends,
              child: Text(
                l10n.action_show_all,
                style: GoogleFonts.notoSerifTc(
                  color: theme.colorScheme.primary.withValues(alpha: 0.72),
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
        Container(
          width: 46,
          height: 1.6,
          color: theme.colorScheme.primary.withValues(alpha: 0.65),
        ),
        const SizedBox(height: 18),
        _friendsList.isEmpty
            ? Center(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(l10n.noFriendsMessage,
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.7)))))
            : SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _friendsList.length > 6 ? 6 : _friendsList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final friend = _friendsList[index];
              return SizedBox(
                width: 86,
                child: _buildCharacterGridItem(
                  friend,
                  isMyCharacter: false,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyCharactersSection() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isDefaultTheme = _isDefaultTheme(context);
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
              backgroundColor: isDefaultTheme
                  ? const Color(0xFFF6EEF9)
                  : theme.colorScheme.primaryContainer,
              foregroundColor: isDefaultTheme
                  ? const Color(0xFF76529E)
                  : theme.colorScheme.onPrimaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isDefaultTheme
                    ? const BorderSide(
                  color: Color(0xFFDECFE7),
                  width: 0.8,
                )
                    : BorderSide.none,
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
    final bool isDefaultTheme = _isDefaultTheme(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: _createCharacter,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isDefaultTheme
              ? const Color(0xFFF6EEF9)
              : null,
          borderRadius: BorderRadius.circular(20),
          border: isDefaultTheme
              ? Border.all(
            color: const Color(0xFFDECFE7),
            width: 0.8,
          )
              : null,
          boxShadow: isDefaultTheme
              ? null
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: isDefaultTheme
              ? null
              : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
        ),
        child: Text(
          l10n.createCharacterTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: isDefaultTheme
                ? const Color(0xFF76529E)
                : theme.colorScheme.onPrimary,
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
          final result =
          await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CharacterEditPage(
                    character: character,
                  ),
            ),
          );

          if (!mounted || result == null) return;

          final bool changed =
              result['changed'] == true;
          final bool deleted =
              result['deleted'] == true;
          final String? deletedCharacterId =
          result['characterId']?.toString();
          final String? message =
          result['message']?.toString();

          if (deleted) {
            final idToRemove =
                deletedCharacterId ?? character.id;

            CharacterRepository.invalidate(
              idToRemove,
            );

            setState(() {
              _myCharacters.removeWhere(
                    (c) => c.id == idToRemove,
              );
              _friendsList.removeWhere(
                    (c) => c.id == idToRemove,
              );
            });

            if (message != null &&
                message.isNotEmpty) {
              ToastUtils.showCenterToast(
                context,
                message,
                customIcon:
                Icons.person_remove_rounded,
              );
            }

            return;
          }

          if (changed) {
            await _refreshData();

            if (!mounted) return;

            if (message != null &&
                message.isNotEmpty) {
              ToastUtils.showCenterToast(
                context,
                message,
                customIcon:
                Icons.manage_accounts_rounded,
              );
            }
          }

          return;
        }

        await CharacterNavigator.open(
          context,
          characterId: character.id,
          fallbackName: character.name,
        );

        if (!mounted) return;
        await _refreshData();
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
import 'world_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
// ✅ 修正：移除重複的 import，保留必要的
import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import 'chat_home_page.dart';
import 'select_chat_page.dart';
import 'moments_page.dart';
import 'profile_page.dart';
import 'recommendation_page.dart';
import 'dart:async'; // ✨ 加上這一行，超時功能就能用了！
import '../services/app_constants.dart';
import '../services/app_update_service.dart';
import 'desktop_widget_service.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
//主介面

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  late int _selectedIndex;
  late List<bool> _isPageActivated;
  bool _hasClaimedToday = false;
  bool _hasCheckedInToday = false;
  bool _isShowingCheckInDialog = false;
  bool _isCheckingDailyCheckIn = false;
  // ✨ 效能優化：紀錄最後一次檢查日期，避免頻繁讀取資料庫
  String _lastCheckedDateString = "";
  final GlobalKey<RecommendationPageState> _recommendationKey = GlobalKey<RecommendationPageState>();
  final GlobalKey<SelectChatPageState> _encounterKey = GlobalKey<SelectChatPageState>();
  final GlobalKey<MomentsPageState> _momentsKey =
  GlobalKey<MomentsPageState>();
  // ✨ 2. 加上 late，並把鑰匙裝進 SelectChatPage
  late final List<Widget> _pages = [
    RecommendationPage(key: _recommendationKey), // 0 推薦
    SelectChatPage(key: _encounterKey), // 1 邂逅
    const ChatHomePage(), // 2 聊天
    MomentsPage(key: _momentsKey), // 3 瞬間
    const ProfilePage(), // 4 個人主頁
  ];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;

    _isPageActivated = List.generate(
      _pages.length,
          (index) => index == widget.initialIndex,
    );

    // 記住玩家上次停留的主分頁；沒有紀錄時維持 initialIndex（預設 0＝推薦）。
    unawaited(_restoreLastMainTab());

    // 1. 註冊監聽器
    WidgetsBinding.instance.addObserver(this);

    // 2. 這是「冷啟動」時的檢查
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _checkDailyCheckIn();
      _checkAndTriggerBirthdayEvent();

      // 桌面小工具：冷啟動時刷新一次。
      unawaited(_refreshDesktopWidgetsOnAppOpen());

      // App 進入主介面後再檢查更新，避免與登入 / 首頁初始化搶畫面。
      AppUpdateService.checkForUpdate(context);
    });
  }

  @override
  void dispose() {
    // 3. 記得移除監聽器，不然會內存洩漏
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ✨✨✨ 關鍵修復：監聽 App 的生命週期狀態變化 ✨✨✨
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      _performDailyTasks();

      // App 從背景回來也要刷新 Widget。
      // 今日一句的 app_open 模式每次都會更新；
      // daily 模式只會在跨日後更新。
      unawaited(_refreshDesktopWidgetsOnAppOpen());
    }
  }
  Future<void> _refreshDesktopWidgetsOnAppOpen() async {
    try {
      await Future.wait<void>([
        DesktopWidgetNativeService.refreshDailyQuoteWidgetsOnAppOpen(),
        DesktopWidgetNativeService.refreshAnniversaryWidgets(),
      ]);
    } catch (error) {
      // Widget 刷新失敗不能影響主頁啟動。
      debugPrint('⚠️ App 開啟刷新桌面小工具失敗：$error');
    }
  }

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  String? get _lastMainTabKey {
    final uid = _currentUserId;
    if (uid == null || uid.isEmpty) return null;
    return 'last_main_tab_$uid';
  }

  Future<void> _restoreLastMainTab() async {
    final key = _lastMainTabKey;
    final uid = _currentUserId;

    if (key == null || uid == null || uid.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(key);

      if (!mounted || savedIndex == null) return;
      if (savedIndex < 0 || savedIndex >= _pages.length) return;

      if (savedIndex != _selectedIndex) {
        setState(() {
          _selectedIndex = savedIndex;
          _isPageActivated[savedIndex] = true;
        });
      }

      // 只有「上次主分頁 = 聊天」時才嘗試回到最後聊天室。
      if (savedIndex != 2) return;

      // 世界觀房間是獨立類型，不能誤當成角色聊天室路由。
      final lastType = prefs.getString('last_chat_type_$uid') ?? '';
      if (lastType == 'world') {
        final worldId = prefs.getString('last_chat_world_$uid')?.trim() ?? '';
        if (worldId.isEmpty) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => WorldChatPage(worldId: worldId),
          ));
        });
        return;
      }

      final characterId =
          prefs.getString('last_chat_character_$uid')?.trim() ?? '';
      final sessionId =
          prefs.getString('last_chat_session_$uid')?.trim() ?? '';

      if (characterId.isEmpty || sessionId.isEmpty) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.of(context).pushNamed(
          '/chat',
          arguments: {
            'characterId': characterId,
            'sessionId': sessionId,
          },
        );
      });
    } catch (e) {
      debugPrint('⚠️ 讀取上次停留位置失敗：$e');
    }
  }

  Future<void> _saveLastMainTab(int index) async {
    final key = _lastMainTabKey;
    if (key == null) return;
    if (index < 0 || index >= _pages.length) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, index);
    } catch (e) {
      debugPrint('⚠️ 儲存上次主頁分頁失敗：$e');
    }
  }

  // 所有裝置共用台灣日界線，避免不同時區的領取日不一致。
  String get _checkInDayKey => DateFormat('yyyy-MM-dd').format(
      DateTime.now().toUtc().add(const Duration(hours: 8)));

  String _checkInDayOf(Timestamp stamp) => DateFormat('yyyy-MM-dd').format(
      stamp.toDate().toUtc().add(const Duration(hours: 8)));

  // --- 每日簽到邏輯 ---
  void _performDailyTasks() {
    final String today = _checkInDayKey;

    // 如果今天在 App 運行期間已經檢查過了，就不再重複檢查
    if (_lastCheckedDateString == today) return;

    print("🔔 執行每日任務檢查 ($today)...");
    _checkDailyCheckIn();
    _checkAndTriggerBirthdayEvent();

    _lastCheckedDateString = today; // 標記今天已檢查
  }
  Future<void> _checkDailyCheckIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !mounted || _isShowingCheckInDialog || _isCheckingDailyCheckIn) return;
    _isCheckingDailyCheckIn = true;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    try {
      // 領取狀態不可用舊的本機快取決定，跨裝置必須以伺服器為準。
      final doc = await userDocRef.get(const GetOptions(source: Source.server));
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != user.uid) return;
      if (!doc.exists) return;
      final last = doc.data()?['lastCheckInDate'];
      bool claimed = last is Timestamp && _checkInDayOf(last) == _checkInDayKey;
      // 若舊版本只成功寫入當日明細，也視為已領取，避免重複彈窗。
      if (!claimed) {
        final today = _checkInDayKey.replaceAll('-', '');
        try {
          final log = await userDocRef.collection('flower_logs')
              .doc('daily_check_in_$today')
              .get(const GetOptions(source: Source.server));
          claimed = log.exists;
        } catch (e) {
          debugPrint('每日贈禮明細檢查未完成: $e');
        }
      }
      debugPrint('每日贈禮狀態：已領取=$claimed，紀錄類型=${last.runtimeType}');
      if (!mounted || FirebaseAuth.instance.currentUser?.uid != user.uid) return;
      setState(() {
        _hasClaimedToday = claimed;
        _hasCheckedInToday = claimed;
      });
      if (!claimed && mounted) await _showCheckInDialog(userDocRef);
    } catch (error, stackTrace) {
      // 伺服器無法驗證時不要顯示「可領」，以免誤導玩家重複領取。
      debugPrint('每日贈禮狀態檢查失敗: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isCheckingDailyCheckIn = false;
    }
  }
  // --- 簽到彈窗 UI ---
  Future<void> _showCheckInDialog(DocumentReference userDocRef) async {
    // 防止兩個入口同時彈出簽到視窗
    if (_isShowingCheckInDialog) return;

    // 如果本地狀態已經知道今天領過，就不要再彈
    if (_hasCheckedInToday || _hasClaimedToday) {
      return;
    }

    _isShowingCheckInDialog = true;

    try {
      final int rewardAmount = AppConfig.dailyCheckIn;
      final bool desktopWeb = kIsWeb && MediaQuery.sizeOf(context).width >= 900;
      bool isClaiming = false;

      final l10n = AppLocalizations.of(context)!;
      final theme = Theme.of(context);
      final primaryColor = theme.colorScheme.primary;

      await showDialog(
        context: context,
        // 尚未領取也可以點視窗外空白處略過本次提示。
        barrierDismissible: true,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setStateInDialog) {
              return AlertDialog(
                // AlertDialog 只有 maxWidth 會依文字的 intrinsic width 收縮。
                // 明確指定最小寬度，避免電腦瀏覽器顯示成狹長直條。
                constraints: BoxConstraints(
                  minWidth: desktopWeb ? 420 :
                  (MediaQuery.sizeOf(dialogContext).width - 80).clamp(0.0, 320.0),
                  maxWidth: desktopWeb ? 420 : 360,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  l10n.daily_gift_title,
                  style: GoogleFonts.notoSerifTc(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: desktopWeb ? 22 : 18,
                  ),
                ),
                content: Text(
                  l10n.daily_login_welcome(
                    l10n.app_name,
                    rewardAmount.toString(),
                  ),
                  style: GoogleFonts.notoSerifTc(
                    fontSize: desktopWeb ? 17 : 14,
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                  ),
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                actions: [
                  if (isClaiming)
                    Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 8),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () async {
                        if (isClaiming) return;

                        setStateInDialog(() {
                          isClaiming = true;
                        });

                        try {
                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null) {
                            throw Exception('使用者未登入');
                          }

                          if (FirebaseAuth.instance.currentUser?.uid != userDocRef.id) {
                            throw StateError('登入帳號已變更，請重新進入頁面');
                          }
                          final todayString = _checkInDayKey;
                          // 固定每日明細 ID，交易重試也只建立一筆明細。
                          final logRef = userDocRef.collection('flower_logs')
                              .doc('daily_check_in_${todayString.replaceAll('-', '')}');
                          await FirebaseFirestore.instance.runTransaction((transaction) async {
                            final snapshot = await transaction.get(userDocRef);
                            if (!snapshot.exists) throw StateError('找不到玩家資料');
                            final data = snapshot.data() as Map<String, dynamic>? ?? {};
                            final last = data['lastCheckInDate'];
                            if (last is Timestamp && _checkInDayOf(last) == todayString) {
                              throw StateError('今天已經簽到過了');
                            }
                            // 使用同一筆交易：點數與花花明細共同成功或共同失敗。
                            transaction.update(userDocRef, {
                              'flowerPoints': FieldValue.increment(rewardAmount),
                              'lastCheckInDate': FieldValue.serverTimestamp(),
                            });
                            transaction.set(logRef, {
                              'title': l10n.title_daily_check_in,
                              'amount': rewardAmount,
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                          });

                          if (!mounted) return;

                          // 3. 更新本地狀態
                          setState(() {
                            _hasClaimedToday = true;
                            _hasCheckedInToday = true;
                            _lastCheckedDateString = todayString;
                          });

                          // 4. 關閉簽到彈窗
                          if (Navigator.of(dialogContext).canPop()) {
                            Navigator.of(dialogContext).pop();
                          }

                          // 5. 顯示恭喜獲得彈窗
                          if (!mounted) return;

                          showDialog(
                            context: context,
                            builder: (rewardDialogContext) {
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
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.success_claim_reward(
                                        rewardAmount.toString(),
                                      ),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(rewardDialogContext).pop();
                                        },
                                        child: Text(
                                          l10n.shop_purchase_awesome,
                                          style: GoogleFonts.notoSerifTc(
                                            fontWeight: FontWeight.w700,
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
                          debugPrint('❌ 簽到失敗: $e');
                          if (e is FirebaseException) {
                            debugPrint('每日贈禮 Firebase 錯誤碼: ${e.code}；訊息: ${e.message}');
                          }

                          if (!mounted) return;

                          final errorText = e.toString();
                          bool alreadyCheckedIn =
                          errorText.contains('今天已經簽到過了');

                          // Web 端可能把交易拒絕包裝成 FirebaseException；
                          // 再向伺服器核對一次，避免已領取卻顯示網路錯誤。
                          if (!alreadyCheckedIn) {
                            try {
                              final latest = await userDocRef.get(
                                const GetOptions(source: Source.server),
                              );
                              final last = latest.data() is Map<String, dynamic>
                                  ? (latest.data() as Map<String, dynamic>)['lastCheckInDate']
                                  : null;
                              alreadyCheckedIn = last is Timestamp &&
                                  _checkInDayOf(last) == _checkInDayKey;
                              if (!alreadyCheckedIn) {
                                final log = await userDocRef.collection('flower_logs')
                                    .doc('daily_check_in_${_checkInDayKey.replaceAll('-', '')}')
                                    .get(const GetOptions(source: Source.server));
                                alreadyCheckedIn = log.exists;
                              }
                            } catch (verifyError) {
                              debugPrint('再次核對每日贈禮狀態失敗: $verifyError');
                            }
                          }
                          if (!mounted || !dialogContext.mounted) return;

                          if (alreadyCheckedIn) {
                            final todayString = _checkInDayKey;

                            setState(() {
                              _hasClaimedToday = true;
                              _hasCheckedInToday = true;
                              _lastCheckedDateString = todayString;
                            });

                            if (Navigator.of(dialogContext).canPop()) {
                              Navigator.of(dialogContext).pop();
                            }

                            ToastUtils.showCenterToast(
                              context,
                              l10n.main_check_in_already_done,
                              isError: true,
                            );

                            return;
                          }

                          ToastUtils.showCenterToast(
                            context,
                            l10n.error_claim_failed,
                            isError: true,
                          );

                          setStateInDialog(() {
                            isClaiming = false;
                          });
                        }
                      },
                      child: Text(
                        l10n.action_claim_now,
                        style: GoogleFonts.notoSerifTc(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: desktopWeb ? 18 : 16,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      );
    } finally {
      _isShowingCheckInDialog = false;
    }
  }

  // --- 生日檢查邏輯 (精簡版) ---
  Future<void> _checkAndTriggerBirthdayEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !mounted) return;

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // 1. 抓取資料 (附帶 5 秒超時防卡死)
      final doc = await userDocRef.get().timeout(const Duration(seconds: 5));

      if (!mounted) return;
      if (!doc.exists || doc.data()?['userBirthday'] == null) return;

      final data = doc.data()!;
      final Timestamp birthdayTimestamp = data['userBirthday'];
      final Timestamp? birthdaySetTimestamp = data['birthdaySetTimestamp'];
      final bool isFirstRewardClaimed = data['isFirstBirthdayRewardClaimed'] ?? false;

      // 2. 日期計算 (保留總裁確認過的安全轉換邏輯)
      final DateTime todayLocal = DateTime.now();
      final DateTime calcBirthDate = birthdayTimestamp.toDate()
          .add(const Duration(hours: 12))
          .add(todayLocal.timeZoneOffset);

      // 3. 判斷是否為生日，不是就直接結束
      if (calcBirthDate.month != todayLocal.month || calcBirthDate.day != todayLocal.day) return;

      // --- 以下為「確認是生日」的發放邏輯 ---

      if (!isFirstRewardClaimed) {
        // 狀態 A：首次領取
        if (mounted) _showBirthdayDialog();

        await userDocRef.update({
          'isFirstBirthdayRewardClaimed': true,
          // ✨ 利用 Dart 語法，如果是 null 才把這一行塞進 Map 裡
          if (birthdaySetTimestamp == null) 'birthdaySetTimestamp': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 3));

        if (!mounted) return;

      } else if (birthdaySetTimestamp != null) {
        // 狀態 B：非首次領取，檢查 30 天冷卻期
        final DateTime eligibilityDate = birthdaySetTimestamp.toDate().add(const Duration(days: 30));
        final DateTime todayDateOnly = DateTime(todayLocal.year, todayLocal.month, todayLocal.day);

        // 如果今天已經「大於或等於」可以再次領取的日期
        if (!todayDateOnly.isBefore(eligibilityDate) && mounted) {
          _showBirthdayDialog();
        }
      }

    } on TimeoutException {
      print('[生日檢查] 警告：連線超時跳過');
    } catch (e) {
      print('[生日檢查] 發生錯誤: $e');
    }
  }
  Future<void> _showBirthdayDialog() async {
    if (!mounted) return;

    // ✨ 在 showDialog 外面先呼叫 l10n，這樣裡面就可以直接用！
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          title: Text(l10n.birthday_dialog_title, style: TextStyle(color: primaryColor)), // ✨ 替換標題
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ 圖示顏色連動
              Icon(Icons.cake, size: 60, color: primaryColor),
              const SizedBox(height: 16),
              // ✨ 替換內文，並記得把原本這裡的 const 拿掉！
              Text(
                l10n.birthday_dialog_content,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // ✅ 按鈕底色連動主題色
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(dialogContext),
                // ✨ 替換按鈕文字，同樣把 const 拿掉！
                child: Text(
                    l10n.birthday_dialog_button, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  // ✨ 3. 更新點擊邏輯
  void _onItemTapped(int index) {
    // 從「瞬間」切往其他頁面時，
    // 主動關閉 Showcase 的提示氣泡。
    if (_selectedIndex == 3 && index != 3) {
      _momentsKey.currentState?.dismissFeatureTips();
    }

    // 同時關閉 Flutter 一般 Tooltip。
    Tooltip.dismissAllToolTips();

    if (_selectedIndex == index) {
      // 已經在推薦頁，再次點擊推薦時換一批。
      if (index == 0) {
        _recommendationKey.currentState?.refreshRecommendations();
      }

      // 已經在邂逅頁，又再次點擊邂逅時刷新角色。
      if (index == 1) {
        _encounterKey.currentState?.refreshEncounters();
      }

      return;
    }

    setState(() {
      _selectedIndex = index;
      _isPageActivated[index] = true;
    });

    unawaited(_saveLastMainTab(index));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;
        return Container(
          decoration: themeNotifier.currentBackground,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              top: false,
              child: IndexedStack(
                index: _selectedIndex,
                children: List.generate(_pages.length, (index) {
                  // ✨ 這裡微調一下邏輯
                  // 如果這頁曾經被啟動過，就永遠保持它的存在，不要讓它變回 SizedBox
                  return _isPageActivated[index]
                      ? _pages[index]
                      : const SizedBox.shrink();
                }),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              // 🌟 這裡會自動幫 ImageIcon 染上玩家自訂的主題色
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha:0.6),
              items: [
                // 1. 推薦
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/nav_recommend_mask.png'),
                    size: 26,
                  ),
                  label: l10n.nav_recommend,
                ),

                // 2. 邂逅
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/nav_encounter_mask.png'),
                    size: 26,
                  ),
                  label: l10n.nav_encounter,
                ),

                // 3. 聊天
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/nav_chat_mask.png'),
                    size: 26,
                  ),
                  label: l10n.mode_chat,
                ),

                // 4. 瞬間
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/nav_moments_mask.png'),
                    size: 26,
                  ),
                  label: l10n.nav_moments,
                ),

                // 5. 個人主頁
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/nav_profile_mask.png'),
                    size: 26,
                  ),
                  label: l10n.title_personal_homepage,
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        );
      },
    );
  }
}
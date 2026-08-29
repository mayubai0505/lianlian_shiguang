import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

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

    // 1. 註冊監聽器
    WidgetsBinding.instance.addObserver(this);

    // 2. 這是「冷啟動」時的檢查
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDailyCheckIn();
      _checkAndTriggerBirthdayEvent();

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
    if (state == AppLifecycleState.resumed) {
      _performDailyTasks();
    }
  }
  // --- 每日簽到邏輯 ---
  void _performDailyTasks() {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 如果今天在 App 運行期間已經檢查過了，就不再重複檢查
    if (_lastCheckedDateString == today) return;

    print("🔔 執行每日任務檢查 ($today)...");
    _checkDailyCheckIn();
    _checkAndTriggerBirthdayEvent();

    _lastCheckedDateString = today; // 標記今天已檢查
  }
  Future<void> _checkDailyCheckIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !mounted) return;
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await userDocRef.get();
    if (!doc.exists) return;
    final data = doc.data()!;
    final lastCheckInTimestamp = data['lastCheckInDate'] as Timestamp?;
    // 🌟 這裡一定要統一用本地時間來抓「今天」的字串
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastCheckInTimestamp != null) {
      // 🌟 這裡就是定義 lastDate 的地方！
      final String lastDate = DateFormat('yyyy-MM-dd').format(lastCheckInTimestamp.toDate());
      if (lastDate == todayString) {
        print("✅ 今天已經簽到過囉！");
        setState(() {
          _hasClaimedToday = true; // 🌟 現在系統認識它了！
        });
        return;
      }
    }
    // 通過檢查，顯示彈窗
    if (mounted) _showCheckInDialog(userDocRef);
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
      bool isClaiming = false;

      final l10n = AppLocalizations.of(context)!;
      final theme = Theme.of(context);
      final primaryColor = theme.colorScheme.primary;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setStateInDialog) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      l10n.daily_gift_title,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  l10n.daily_login_welcome(
                    '戀戀拾光',
                    rewardAmount.toString(),
                  ),
                  style: const TextStyle(height: 1.5),
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

                          final todayString =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());

                          // 1. Transaction：真正防止重複簽到
                          await FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            final snapshot = await transaction.get(userDocRef);

                            if (!snapshot.exists) {
                              throw Exception('找不到玩家資料');
                            }

                            final data =
                                snapshot.data() as Map<String, dynamic>? ?? {};

                            final lastCheckInTimestamp =
                            data['lastCheckInDate'] as Timestamp?;

                            if (lastCheckInTimestamp != null) {
                              final lastCheckInString =
                              DateFormat('yyyy-MM-dd').format(
                                lastCheckInTimestamp.toDate(),
                              );

                              if (lastCheckInString == todayString) {
                                throw Exception('今天已經簽到過了');
                              }
                            }

                            transaction.update(userDocRef, {
                              'flowerPoints':
                              FieldValue.increment(rewardAmount),
                              'lastCheckInDate':
                              FieldValue.serverTimestamp(),
                            });
                          });

                          // 2. 寫入花花明細
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('flower_logs')
                              .add({
                            'title': l10n.title_daily_check_in,
                            'amount': rewardAmount,
                            'createdAt': FieldValue.serverTimestamp(),
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
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
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
                          debugPrint('❌ 簽到失敗: $e');

                          if (!mounted) return;

                          final errorText = e.toString();
                          final bool alreadyCheckedIn =
                          errorText.contains('今天已經簽到過了');

                          if (alreadyCheckedIn) {
                            final todayString =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());

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
                              '今天已經簽到過囉',
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
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                  label: '推薦',
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
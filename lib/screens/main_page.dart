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
import 'dart:async'; // ✨ 加上這一行，超時功能就能用了！
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//主介面

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _selectedIndex = 0; // 預設頁面索引 (0=聊天, 1=邂逅...)
  late List<bool> _isPageActivated;
  bool _hasClaimedToday = false; // 👈 負責記錄今天領過沒
  bool _hasCheckedInToday = false; // 👈 加上這行，它是用來記錄今天是否按過按鈕的
  // ✨ 效能優化：紀錄最後一次檢查日期，避免頻繁讀取資料庫
  String _lastCheckedDateString = "";

  final List<Widget> _pages = [
    const ChatHomePage(), // 0
    const SelectChatPage(), // 1
    const MomentsPage(), // 2
    const ProfilePage(), // 3
  ];

  @override
  void initState() {
    super.initState();
    _isPageActivated = List.generate(_pages.length, (index) => index == 0);
    // 1. 註冊監聽器
    WidgetsBinding.instance.addObserver(this);

    // 2. 這是「冷啟動」(第一次打開 App) 時的檢查
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDailyCheckIn();
      _checkAndTriggerBirthdayEvent();
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
    final int rewardAmount = AppConfig.dailyCheckIn;
    bool isClaiming = false; // 由 StatefulBuilder 管理內部狀態
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Text('✨', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(l10n.daily_gift_title,
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                l10n.daily_login_welcome('戀戀拾光', rewardAmount.toString()),
                style: const TextStyle(height: 1.5),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              actions: [
                if (isClaiming)
                  Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 8),
                    child: SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () async {
                      // 🛡️ 門禁第一關：防止鬼畜連點
                      if (isClaiming) return;
                      setStateInDialog(() => isClaiming = true);
                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) throw Exception("使用者未登入");
                        // 1. 同步執行：更新點數與日期 (Transaction)
                        await FirebaseFirestore.instance.runTransaction((transaction) async {
                          transaction.update(userDocRef, {
                            'flowerPoints': FieldValue.increment(rewardAmount),
                            'lastCheckInDate': FieldValue.serverTimestamp(),
                          });
                        });

                        // 2. 寫入明細帳本 (flower_logs)
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('flower_logs')
                            .add({
                          'title': l10n.title_daily_check_in,
                          'amount': rewardAmount,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        // 3. 成功後的 UI 反饋
                        if (mounted) {
                          // 🌟 一次性更新主頁面狀態
                          setState(() {
                            _hasClaimedToday = true;
                            _hasCheckedInToday = true;
                            _lastCheckedDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
                          });

                          // 先關閉原本的「每日簽到」大彈窗
                          Navigator.pop(dialogContext);

                          // 🌟 總裁補丁：把底下的 SnackBar 刪掉，直接在正中間召喚「恭喜獲得」小彈窗！
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                backgroundColor: Colors.white,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 16),
                                    // 🌸 放上可愛的花花圖示
                                    Image.asset('assets/images/flower_gift.png', height: 80, width: 80),
                                    const SizedBox(height: 16),
                                    // 🎉 恭喜獲得文字
                                    Text(
                                      l10n.success_claim_reward(rewardAmount.toString()),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 24),
                                    // 👆 收下獎勵的確認按鈕
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        ),
                                        onPressed: () => Navigator.pop(context), // 關閉這個恭喜彈窗
                                        child: Text(l10n.shop_purchase_awesome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } catch (e) {
                        print("❌ 簽到失敗: $e");
                        if (mounted) {
                          // ✨ 總裁級防護：領取失敗的優雅迫降，用最高級的視覺回饋安撫玩家的失落！
                          ToastUtils.showCenterToast(
                            context,
                            l10n.error_claim_failed,
                            isError: true, // 💡 全域統一的紅色驚嘆號，清楚告知異常，但不引發焦慮
                          );
                          setStateInDialog(() => isClaiming = false); // 開放按鈕重試
                        }
                      }
                    },
                    child: Text(l10n.action_claim_now,
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
              ],
            );
          },
        );
      },
    );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // ✨ 只要點到那一頁，就把它標記為已啟動
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
              unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
              items: [
                // 1. 聊天
                 BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/chat_icon.png'),
                    size: 24,
                  ),
                  label: l10n.mode_chat,
                ),
                // 2. 邂逅
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/select_chat_icon.png'),
                    size: 24,
                  ),
                  label: l10n.nav_encounter, // ✨ 換成多國語言
                ),
                // 3. 瞬間
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage('assets/images/moment_outline.png'),
                    size: 24,
                  ),
                  label: l10n.nav_moments, // ✨ 換成多國語言
                ),
                // 4. 個人主頁
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/images/profile_icon.png'),
                    size: 24,
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
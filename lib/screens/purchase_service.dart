import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // 確保 navigatorKey 在這裡
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'dart:io';

class ProductDetailsWrapper {
  final ProductDetails productDetails;
  bool isPending = false;

  ProductDetailsWrapper({required this.productDetails});
}

class PurchaseService extends ChangeNotifier with WidgetsBindingObserver {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  StreamSubscription<User?>? _authSubscription;
  Future<void> _queue = Future<void>.value();
  Future<void>? _initialization;
  bool _querying = false;
  bool _disposed = false;
  Timer? _retryTimer;

  String _accountId(String uid) => sha256.convert(utf8.encode(uid)).toString();

  void _enqueue(List<PurchaseDetails> purchases) {
    _queue = _queue.then((_) => _handlePurchaseUpdates(purchases)).catchError((Object e) {
      debugPrint('購買處理未完成，保留交易待重試: ${e.runtimeType}');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(retryPendingPurchases());
  }

  Future<void> retryPendingPurchases() async {
    if (_disposed || _querying || !isStoreAvailable || !Platform.isAndroid ||
        FirebaseAuth.instance.currentUser == null) return;
    _querying = true;
    try {
      final response = await _inAppPurchase
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
          .queryPastPurchases();
      if (response.error != null) throw StateError('查詢未完成購買失敗');
      _enqueue(response.pastPurchases);
    } catch (e) {
      debugPrint('購買補查失敗，稍後重試: ${e.runtimeType}');
    } finally {
      _querying = false;
    }
  }

  bool isStoreAvailable = false;
  List<ProductDetailsWrapper> products = [];
  bool isLoading = true;

  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    WidgetsBinding.instance.addObserver(this);
    _subscription = _inAppPurchase.purchaseStream.listen(_enqueue,
      onError: (Object e) => debugPrint('購買監聽錯誤: ${e.runtimeType}'));
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) unawaited(retryPendingPurchases());
    });
    try {
      isStoreAvailable = await _inAppPurchase.isAvailable();
      if (isStoreAvailable) {
        await _loadProducts();
        await retryPendingPurchases();
        _retryTimer = Timer.periodic(const Duration(minutes: 1), (_) {
          unawaited(retryPendingPurchases());
        });
      }
    } catch (e) {
      debugPrint('商店初始化失敗: ${e.runtimeType}');
    } finally {
      isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    // ✨ 修改 1：換上總裁在 Google 後台設定的「真實暗號」
    const Set<String> productIds = {
      'com_lianlian_monthly_card', // 星光契約月卡
      'com_lianlian_monthly_card_250', // 星光契約月卡
      'com.lianlian.points_90',    // 初見禮包
      'com.lianlian.points_215',   // 曖昧禮包
      'com.lianlian.points_370',   // 心動禮包
      'com.lianlian.points_590',   // 熱戀禮包
      'com.lianlian.points_780',   // 知己禮包
      'com.lianlian.points_1030',  // 守候禮包
      'com.lianlian.points_1420',  // 信賴禮包
      'com.lianlian.points_1650',  // 我愛你禮包
      'com.lianlian.points_2200',  // 蜜月禮包
      'com.lianlian.points_2300',  // 承諾禮包
      'com.lianlian.points_2350',  // 承諾禮包
      'com.lianlian.points_2400',  // 相伴禮包
      'com.lianlian.points_2680',  // 深愛禮包
      'com.lianlian.points_3200',// 長久禮包
      'com.lianlian.points_3400',// 唯一禮包
      'com.lianlian.points_3450',  // 唯一禮包
      'com.lianlian.points_4300',  // 一生一世包
      'com.lianlian.points_6400',  // 誓約禮包
      'com.lianlian.points_10000', // 永恆戀人包
    };

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print("⚠️ 找不到以下商品ID (請檢查 Google Play 後台是否已啟用): ${response.notFoundIDs}");
    }

    products = response.productDetails.map((pd) => ProductDetailsWrapper(productDetails: pd)).toList();

    // 依據價格由低到高排序
// ✨ 修正後的完美排序邏輯
    products.sort((a, b) {
      // 1. 第一關：先比價格 (由低到高)
      int priceCompare = a.productDetails.rawPrice.compareTo(b.productDetails.rawPrice);

      // 如果價格不一樣，第一關就直接分出勝負了！
      if (priceCompare != 0) {
        return priceCompare;
      }

      // 2. 第二關 (延長賽)：如果遇到 Apple 美金同價距，改用「點數數字」來決勝負！
      int getPoints(String id) {
        // ✨ 一樣改成只要包含 monthly_card 就排在最前面
        if (id.contains('monthly_card')) return -1;

        String numStr = id.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(numStr) ?? 0;
      }

      int pointsA = getPoints(a.productDetails.id);
      int pointsB = getPoints(b.productDetails.id);

      // 點數少的排前面
      return pointsA.compareTo(pointsB);
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    final wrapper = products.firstWhere((p) => p.productDetails.id == productDetails.id);
    wrapper.isPending = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError('請先登入再購買');
      final PurchaseParam purchaseParam = Platform.isAndroid
          ? GooglePlayPurchaseParam(productDetails: productDetails,
              applicationUserName: _accountId(user.uid))
          : PurchaseParam(productDetails: productDetails);
      // 🌟 依然使用 buyConsumable，讓玩家能無限疊加
      final started = await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: !Platform.isAndroid);
      if (!started) throw StateError('商店未啟動購買');
    } catch (e) {
      // 🚨 如果呼叫 Google 結帳面板失敗 (例如被阻擋)，立刻關閉轉圈圈
      debugPrint("❌ 呼叫購買面板失敗: $e");
      wrapper.isPending = false;
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      try {
        final wrapper = products.where((p) => p.productDetails.id == purchase.productID).firstOrNull;
        if (wrapper != null) wrapper.isPending = purchase.status == PurchaseStatus.pending;
        if (purchase.status == PurchaseStatus.pending) continue;
        if (purchase.status == PurchaseStatus.error) {
          if (purchase.error != null) _handleError(purchase.error!);
          continue;
        }
        if (purchase.status == PurchaseStatus.canceled) continue;
        if (purchase.status == PurchaseStatus.purchased ||
            (Platform.isAndroid && purchase.status == PurchaseStatus.restored)) {
          if (Platform.isAndroid) {
            await _deliverGooglePurchase(purchase);
          } else {
            await _deliverPurchase(purchase);
          }
          // Only after durable delivery (or a verified prior delivery) may the
          // store transaction be consumed/completed. Errors leave it retryable.
          if (Platform.isAndroid) {
            final result = await _inAppPurchase
                .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
                .consumePurchase(purchase);
            if (result.responseCode != BillingResponse.ok) {
              throw StateError('交易消耗未成功');
            }
          }
          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
        }
        // iOS historical restores retain their existing no-regrant behavior.
      } catch (e) {
        debugPrint('交易尚未完成，等待重試: ${e.runtimeType}');
      }
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> _deliverGooglePurchase(PurchaseDetails purchase) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('登入後才能發放購買');
    final result = await FirebaseFunctions.instanceFor(region: 'asia-east1')
        .httpsCallable('fulfillGooglePlayPurchase').call(<String, dynamic>{
      'productId': purchase.productID,
      'purchaseToken': purchase.verificationData.serverVerificationData,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    if (data['fulfilled'] != true) throw StateError('尚未確認發放');
    if (data['alreadyFulfilled'] != true && !_disposed &&
        FirebaseAuth.instance.currentUser?.uid == user.uid) {
      _showSuccessDialog((data['points'] as num).toInt(),
        isFirstTime: data['isFirstTime'] == true,
        isMonthlyCard: purchase.productID.contains('monthly_card'));
    }
  }

  int _getBasePointsFromProductId(String productId) {
    const Map<String, int> productPointsMap = {
      'com.lianlian.points_90': 90,
      'com.lianlian.points_215': 215,
      'com.lianlian.points_370': 370,
      'com.lianlian.points_590': 590,
      'com.lianlian.points_780': 780,
      'com.lianlian.points_1030': 1030,
      'com.lianlian.points_1420': 1420,
      'com.lianlian.points_1650': 1650,
      'com.lianlian.points_2200': 2200,

      // Apple / Google 同一禮包但不同 productId
      'com.lianlian.points_2300': 2300,
      'com.lianlian.points_2350': 2300,

      'com.lianlian.points_2400': 2400,
      'com.lianlian.points_2680': 2680,
      'com.lianlian.points_3200': 3200,

      // Apple / Google 同一禮包但不同 productId
      'com.lianlian.points_3400': 3400,
      'com.lianlian.points_3450': 3400,

      'com.lianlian.points_4200': 4200,
      'com.lianlian.points_4300': 4300,
      'com.lianlian.points_6400': 6400,
      'com.lianlian.points_10000': 10000,
    };

    return productPointsMap[productId] ?? 0;
  }

  // ✨ 新增：VIP 課條專屬的台幣定價對照表
  int _getPriceFromProductId(String productId) {
    // 1. 如果是月卡，直接回傳 250 元
    if (productId.contains('monthly_card')) {
      return 250;
    }

    // 2. 常駐產品包的對應價格 (對齊總裁的財政緊縮版定價)
    const Map<String, int> productPriceMap = {
      'com.lianlian.points_90': 30,      // 初見禮包
      'com.lianlian.points_215': 70,     // 曖昧禮包
      'com.lianlian.points_370': 120,    // 心動禮包
      'com.lianlian.points_590': 190,    // 熱戀禮包
      'com.lianlian.points_780': 250,    // 知己禮包
      'com.lianlian.points_1030': 330,   // 守候禮包
      'com.lianlian.points_1420': 450,   // 信賴禮包
      'com.lianlian.points_1650': 520,   // 我愛你禮包
      'com.lianlian.points_2200': 690,   // 蜜月禮包
      'com.lianlian.points_2300': 720,   // 承諾禮包
      'com.lianlian.points_2350': 720,   // 承諾禮包 (備用ID)
      'com.lianlian.points_2400': 750,   // 相伴禮包
      'com.lianlian.points_2680': 830,   // 深愛禮包
      'com.lianlian.points_3200': 990,   // 長久禮包
      'com.lianlian.points_3400': 1050,  // 唯一禮包
      'com.lianlian.points_3450': 1050,  // 唯一禮包 (備用ID)
      'com.lianlian.points_4200': 1290,  // 摯愛禮包
      'com.lianlian.points_4300': 1314,  // 一生一世包
      'com.lianlian.points_6400': 1930,  // 誓約禮包
      'com.lianlian.points_10000': 2990, // 永恆戀人包
    };

    return productPriceMap[productId] ?? 0;
  }

  // ✨ 修改 3：完美對接新 ID 的首購雙倍發貨系統
  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('尚未登入，無法發放商品');
    }

    final productId = purchaseDetails.productID;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final purchaseId = purchaseDetails.purchaseID;
    if (purchaseId == null || purchaseId.isEmpty) {
      throw StateError('缺少商店交易編號');
    }
    final transactionKey = sha256.convert(utf8.encode('apple:$purchaseId')).toString();
    final receiptRef = docRef.collection('flower_logs').doc('apple_$transactionKey');
    int grantedPoints = 0;
    bool grantedFirst = false;
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
      grantedPoints = 0;
      grantedFirst = false;
      final receipt = await transaction.get(receiptRef);
      if (receipt.exists) return;
      final docSnapshot = await transaction.get(docRef);
      final data = docSnapshot.data() ?? {};

      List<dynamic> purchaseHistory = data['purchaseHistory'] ?? [];
      bool isFirstTime = !purchaseHistory.contains(productId);

      int pointsToAdd = 0;
      Map<String, dynamic> updateData = {};

      // ✨ 修正後的 _deliverPurchase 片段
      // ✨ 魔法升級：只要 ID 裡面「包含」 monthly_card 這個關鍵字，就當作是買月卡！
      if (productId.contains('monthly_card')) {
        pointsToAdd = 250;

        // 1. 抓出舊的到期日 (如果是第一次買，就以現在為準)
        DateTime now = DateTime.now();
        DateTime currentEndDate = data['monthlySubEndDate'] != null
            ? DateTime.parse(data['monthlySubEndDate'])
            : now;

        // 🕵️‍♂️ 總裁關鍵判斷：購買的這一刻，他的月卡是不是「還在有效期間內」？
        // 如果舊的到期日還在未來，代表他是在有月卡的狀態下續約！
        bool wasAlreadySubscribed = currentEndDate.isAfter(now);

        // 2. 決定「起跳點」：如果已經過期了，從現在開始算；如果還沒過期，從舊到期日往後加
        DateTime baseDate = currentEndDate.isBefore(now) ? now : currentEndDate;
        DateTime newEndDate = baseDate.add(const Duration(days: 30));

        // 3. 總裁的半年封頂條款 (180 天)
        if (newEndDate.difference(now).inDays > 180) {
          newEndDate = now.add(const Duration(days: 180));
          print("⚠️ 已達半年上限，調整到期日為 180 天後");
        }

        updateData['isMonthlySubscribed'] = true;
        updateData['monthlySubEndDate'] = newEndDate.toIso8601String();
        updateData['monthlyCardStatus'] = 'active';

        // 🌟 4. 【新增】重新生成次數的尊爵邏輯！
        updateData['maxRegenerateCount'] = 20; // 只要有月卡，最大上限一律是 20 次

        if (!wasAlreadySubscribed) {
          // 如果他原本「沒有」月卡 (首購，或是過期後才重買)，立刻霸氣把次數補滿！
          updateData['regenerateCount'] = 20;
          print("🎁 玩家首購或重置月卡，重新生成次數已補滿 20 次！");
        } else {
          // 如果他原本就有月卡 (續約)，這行就不執行，保留他在 Firestore 裡面剩餘的次數 (例如 15/20)
          print("🔄 玩家於月卡期間續約，保留當下剩餘的重新生成次數！");
        }
      }
      // 🌟 第二種情況：買的是「一般花花禮包」
      else if (productId.startsWith('com.lianlian.points_')) {
        // 魔法：把前面的字串拔掉，剩下的數字直接轉成整數！
        // 例如 'com.lianlian.points_90' 會直接變成整數 90
        int basePoints = _getBasePointsFromProductId(productId);
        // 首購雙倍判斷！
        pointsToAdd = isFirstTime ? (basePoints * 2) : basePoints;
      }
      if (pointsToAdd > 0) {
        updateData['flowerPoints'] = FieldValue.increment(pointsToAdd);

        int priceSpent = _getPriceFromProductId(productId);
        if (priceSpent > 0) {
          updateData['totalSpent'] = FieldValue.increment(priceSpent);
        }

        if (isFirstTime) {
          updateData['purchaseHistory'] = FieldValue.arrayUnion([productId]);
        }

        transaction.set(docRef, updateData, SetOptions(merge: true));

        // 🌟 獲取全域 Context 與多國語系 (加上防呆機制)
        final context = navigatorKey.currentContext;
        final l10n = context != null ? AppLocalizations.of(context) : null;

        String logTitle = '';

        // ✨ 總裁修正：只要 ID 裡面「包含」 monthly_card，不管是舊版還是 250 版，通通都是星光契約！
        if (productId.contains('monthly_card')) {
          // 如果抓不到翻譯，就給預設中文
          logTitle =
              l10n?.shop_log_monthly_card ?? '啟動：星光契約 (月卡立即贈點) 🌙';
        } else {
          logTitle = isFirstTime
              ? (l10n?.shop_log_top_up_double(pointsToAdd) ??
              '儲值：$pointsToAdd 點 (含首購雙倍 🎁)')
              : (l10n?.shop_log_top_up_normal(pointsToAdd) ??
              '儲值：$pointsToAdd 點');
        }

        transaction.set(receiptRef, {
          'purchaseId': purchaseId,
          'title': logTitle,
          'amount': pointsToAdd,

          'type': 'purchase',
          'provider': Platform.isIOS
              ? 'apple_iap'
              : 'google_play',
          'productId': productId,
          'price': _getPriceFromProductId(productId),
          'currency': 'TWD',

          'createdAt': FieldValue.serverTimestamp(),
        });

        grantedPoints = pointsToAdd;
        grantedFirst = isFirstTime;
      } else {
        throw StateError('未知商品，保留交易供人工確認');
      }
      });
      if (grantedPoints > 0 && !_disposed && FirebaseAuth.instance.currentUser?.uid == user.uid) {
        _showSuccessDialog(grantedPoints, isFirstTime: grantedFirst,
          isMonthlyCard: productId.contains('monthly_card'));
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🌟 彈出成功視窗 (多國語系版)
  // ✨ 把 isFirstTime 變成可選參數，並新增 isMonthlyCard 開關
  void _showSuccessDialog(int points, {bool isFirstTime = false, bool isMonthlyCard = false}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // 取得語系包
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // 🌟 加點圓角讓彈窗更有質感
        title: Row(
          children: [
            // 🌟 替換：月卡標題
            Expanded( // 加上 Expanded 避免文字過長在小螢幕上溢出
              child: Text(isMonthlyCard ? l10n.monthly_card_success_title : l10n.shop_purchase_success_title),
            ),
            if (isFirstTime && !isMonthlyCard) const Text(' 🎉', style: TextStyle(fontSize: 24)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 核心分流：月卡專屬的華麗特權展示
            if (isMonthlyCard) ...[
              // 🌟 替換：月卡副標題
              Text(l10n.monthly_card_success_subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              // 🌟 替換：三大特權內容 (Emoji 保留)
              _buildPerkRow('🌸', l10n.monthly_card_perk_1),
              const SizedBox(height: 10),
              _buildPerkRow('🎁', l10n.monthly_card_perk_2),
              const SizedBox(height: 10),
              _buildPerkRow('💖', l10n.monthly_card_perk_3),
            ]
            // 🌟 原本的單次購買顯示邏輯
            else ...[
              Text(l10n.shop_purchase_success_body(points)),
              if (isFirstTime)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    l10n.shop_purchase_success_double_bonus,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            // 🌟 替換：月卡的按鈕文字
            child: Text(isMonthlyCard ? l10n.monthly_card_start_perks : l10n.shop_purchase_awesome),
          ),
        ],
      ),
    );
  }

// 🌟 總裁御用排版小工具：讓月卡特權列表整齊又美觀
  Widget _buildPerkRow(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(height: 1.4, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // 🌟 彈出失敗視窗 (多國語系版)
  void _handleError(IAPError error) {
    if (error.code == 'canceled') return;       // 忽略 iOS/Android 常見的取消代碼
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shop_purchase_failed_title),
        content: Text(l10n.shop_purchase_failed_body(error.code)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok_button),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _retryTimer?.cancel();
    _authSubscription?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
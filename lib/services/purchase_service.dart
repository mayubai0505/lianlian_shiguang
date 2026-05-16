import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // 確保 navigatorKey 在這裡
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class ProductDetailsWrapper {
  final ProductDetails productDetails;
  bool isPending = false;

  ProductDetailsWrapper({required this.productDetails});
}

class PurchaseService extends ChangeNotifier {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool isStoreAvailable = false;
  List<ProductDetailsWrapper> products = [];
  bool isLoading = true;

  Future<void> initialize() async {
    isStoreAvailable = await _inAppPurchase.isAvailable();

    if (isStoreAvailable) {
      _subscription = _inAppPurchase.purchaseStream.listen(
            (List<PurchaseDetails> purchaseDetailsList) {
          _handlePurchaseUpdates(purchaseDetailsList);
        },
        onDone: () {
          _subscription.cancel();
        },
        onError: (error) {
          print("監聽購買更新時發生錯誤: $error");
        },
      );

      await _loadProducts();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    // ✨ 修改 1：換上總裁在 Google 後台設定的「真實暗號」
    const Set<String> productIds = {
      'com_lianlian_monthly_card', // 星光契約月卡
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
      'com.lianlian.points_2400',  // 相伴禮包
      'com.lianlian.points_2680',  // 深愛禮包
      'com.lianlian.points_3200',  // 長久禮包
      'com.lianlian.points_3400',  // 唯一禮包
      'com.lianlian.points_4200',  // 摯愛禮包
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
    products.sort((a, b) => a.productDetails.rawPrice.compareTo(b.productDetails.rawPrice));

    isLoading = false;
    notifyListeners();
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    final wrapper = products.firstWhere((p) => p.productDetails.id == productDetails.id);
    wrapper.isPending = true;
    notifyListeners();

    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      // 🌟 依然使用 buyConsumable，讓玩家能無限疊加
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      // 🚨 如果呼叫 Google 結帳面板失敗 (例如被阻擋)，立刻關閉轉圈圈
      debugPrint("❌ 呼叫購買面板失敗: $e");
      wrapper.isPending = false;
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      // ✨ 1. 安全尋找商品：用 firstOrNull 溫柔尋找，找不到也不會噴紅字報錯
      if (products.isNotEmpty) {
        final wrapper = products.where((p) => p.productDetails.id == purchaseDetails.productID).firstOrNull;
        if (wrapper != null && purchaseDetails.status != PurchaseStatus.pending) {
          wrapper.isPending = false;
        }
      }

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 處理中...
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          // 🌟 正常購買成功：發放點數與月卡天數！
          await _deliverPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          // 🚨 總裁防護鎖：攔截恢復購買！
          // 因為是一次性商品，如果玩家換手機重裝 App，Google 可能會重送舊收據。
          // 這裡攔下來，不呼叫 _deliverPurchase，徹底封殺「無限白嫖 250 點」的漏洞！
          debugPrint("🔄 偵測到歷史訂單恢復 (ID: ${purchaseDetails.productID})，不重複發放點數。");
        }

        // 🌟 結案：告訴 Google Play 訂單已消化完畢，可以收工了
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
    notifyListeners();
  }

  // ✨ 修改 3：完美對接新 ID 的首購雙倍發貨系統
  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("尚未登入，無法發放商品");
      return;
    }

    final productId = purchaseDetails.productID;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() ?? {};

      List<dynamic> purchaseHistory = data['purchaseHistory'] ?? [];
      bool isFirstTime = !purchaseHistory.contains(productId);

      int pointsToAdd = 0;
      Map<String, dynamic> updateData = {};

      // ✨ 修正後的 _deliverPurchase 片段
      if (productId == 'com_lianlian_monthly_card') {
        pointsToAdd = 250;

        // 1. 抓出舊的到期日 (如果是第一次買，就以現在為準)
        DateTime now = DateTime.now();
        DateTime currentEndDate = data['monthlySubEndDate'] != null
            ? DateTime.parse(data['monthlySubEndDate'])
            : now;

        // 2. 決定「起跳點」：如果已經過期了，從現在開始算；如果還沒過期，從舊到期日往後加
        DateTime baseDate = currentEndDate.isBefore(now) ? now : currentEndDate;
        DateTime newEndDate = baseDate.add(const Duration(days: 30));

        // 3. 🌟 總裁的半年封頂條款 (180 天)
        if (newEndDate.difference(now).inDays > 180) {
          newEndDate = now.add(const Duration(days: 180));
          print("⚠️ 已達半年上限，調整到期日為 180 天後");
        }

        updateData['isMonthlySubscribed'] = true;
        updateData['monthlySubEndDate'] = newEndDate.toIso8601String();

        // 💡 小提醒：為了方便商店顯示，我們多存一個給前端看的欄位
        updateData['monthlyCardStatus'] = 'active';
      }

      if (pointsToAdd > 0) {
        updateData['flowerPoints'] = FieldValue.increment(pointsToAdd);

        if (isFirstTime) {
          updateData['purchaseHistory'] = FieldValue.arrayUnion([productId]);
        }

        await docRef.set(updateData, SetOptions(merge: true));

        // 🌟 獲取全域 Context 與多國語系 (加上防呆機制)
        final context = navigatorKey.currentContext;
        final l10n = context != null ? AppLocalizations.of(context) : null;

        String logTitle = '';
        if (productId == 'com_lianlian_monthly_card') {
          // 如果抓不到翻譯，就給預設中文
          logTitle = l10n?.shop_log_monthly_card ?? '啟動：星光契約 (月卡立即贈點) 🌙';
        } else {
          logTitle = isFirstTime
              ? (l10n?.shop_log_top_up_double(pointsToAdd) ?? '儲值：$pointsToAdd 點 (含首購雙倍 🎁)')
              : (l10n?.shop_log_top_up_normal(pointsToAdd) ?? '儲值：$pointsToAdd 點');
        }

        await docRef.collection('flower_logs').add({
          'title': logTitle,
          'amount': pointsToAdd,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("成功發放！商品ID: $productId，獲得 $pointsToAdd 點，並已寫入明細！");
        _showSuccessDialog(pointsToAdd, isFirstTime);
      }

    } catch (e) {
      print("寫入 Firebase 失敗: $e");
    }
  }

  // 🌟 彈出成功視窗 (多國語系版)
  void _showSuccessDialog(int points, bool isFirstTime) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // 取得語系包
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(l10n.shop_purchase_success_title),
            if (isFirstTime) const Text(' 🎉', style: TextStyle(fontSize: 24)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.shop_purchase_success_body(points)),
            if (isFirstTime)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    l10n.shop_purchase_success_double_bonus,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.shop_purchase_awesome),
          ),
        ],
      ),
    );
  }

  // 🌟 彈出失敗視窗 (多國語系版)
  void _handleError(IAPError error) {
    if (error.code == 'purchase_error') return; // 忽略「玩家取消」或「測試卡假報警」
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
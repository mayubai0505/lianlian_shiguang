import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart'; // 確保 navigatorKey 在這裡
import '../data/store_data.dart';
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
    const Set<String> productIds = {
      'points_package_30', 'points_package_70', 'points_package_120',
      'points_package_190', 'points_package_250', 'points_package_330',
      'points_package_450', 'points_package_520', 'points_package_690',
      'points_package_720', 'points_package_750', 'points_package_830',
      'points_package_990', 'points_package_1050', 'points_package_1290',
      'points_package_1314', 'points_package_1930', 'points_package_2990',
      'monthly_subscription_star_contract',
    };

    //如果你的禮包 ID 後面的數字，不等於實際要給的花花數量（例如：買 package_30 其實是給 100 點），記得要把那段改成用 switch (productId) 來一個一個設定喔

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print("找不到以下商品ID: ${response.notFoundIDs}");
    }

    products = response.productDetails.map((pd) => ProductDetailsWrapper(productDetails: pd)).toList();

    products.sort((a, b) => a.productDetails.rawPrice.compareTo(b.productDetails.rawPrice));

    isLoading = false;
    notifyListeners();
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    final wrapper = products.firstWhere((p) => p.productDetails.id == productDetails.id);
    wrapper.isPending = true;
    notifyListeners();

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    // ✨ 修改 1：區分月卡(非消耗品)與花花(消耗品) ✨
    if (productDetails.id == 'monthly_subscription_star_contract') {
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  // ✨ 修改 2：完整的購買狀態處理 ✨
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {

      // 找到對應的商品，解除 Pending 狀態
      try {
        final wrapper = products.firstWhere((p) => p.productDetails.id == purchaseDetails.productID);
        if (purchaseDetails.status != PurchaseStatus.pending) {
          wrapper.isPending = false;
        }
      } catch (e) {
        print('找不到對應的 ProductDetailsWrapper');
      }

      // 判斷交易狀態
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 正在處理中，UI 已經有轉圈圈了，這裡不用特別做事
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // 購買成功或恢復購買！進行發貨
          await _deliverPurchase(purchaseDetails);
        }

        // ✨ 極度重要：通知 Google Play 交易已完成 ✨
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
    notifyListeners();
  }

  // ✨ 修改 3：真實寫入 Firebase Firestore (升級首購雙倍版) ✨
  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("尚未登入，無法發放商品");
      return;
    }

    final productId = purchaseDetails.productID;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      // 1. 先從 Firebase 讀取玩家目前的資料 (翻開帳本)
      final docSnapshot = await docRef.get();
      final data = docSnapshot.data() as Map<String, dynamic>? ?? {};

      // 取得玩家的購買紀錄，如果沒有這個欄位，就當作空陣列 []
      List<dynamic> purchaseHistory = data['purchaseHistory'] ?? [];

      // 2. 判斷是不是首購：如果帳本裡「沒有」這個商品 ID，就是首購！
      bool isFirstTime = !purchaseHistory.contains(productId);

      int pointsToAdd = 0;
      Map<String, dynamic> updateData = {}; // 準備要寫入 Firebase 的資料包

      // 3. 判斷發放多少點數
      if (productId == 'monthly_subscription_star_contract') {
        pointsToAdd = 250; // 月卡首登送 250
        updateData['isMonthlySubscribed'] = true;
        updateData['monthlySubEndDate'] = DateTime.now().add(const Duration(days: 30)).toIso8601String();
      } else if (productId.startsWith('points_package_')) {

        int basePoints = storeProducts[productId]?.points ?? 0;

        // ✨ 雙倍核心邏輯 ✨
        if (isFirstTime) {
          pointsToAdd = basePoints * 2;
          print("觸發首購雙倍！原本 $basePoints 點，加倍為 $pointsToAdd 點");
        } else {
          pointsToAdd = basePoints;
          print("非首購，正常發放 $basePoints 點");
        }
      }

      // 4. 增加花花餘額並更新帳本
      if (pointsToAdd > 0) {
        updateData['flowerPoints'] = FieldValue.increment(pointsToAdd);

        // 如果是首購，就把這個商品 ID 登記到帳本裡 (arrayUnion 會自動避免重複)
        if (isFirstTime) {
          updateData['purchaseHistory'] = FieldValue.arrayUnion([productId]);
        }

        // 一次性把資料寫入 Firebase (發放花花)
        await docRef.set(updateData, SetOptions(merge: true));

        // ✨✨✨ 總裁請在這裡補上：金流成功後的自動記帳系統 ✨✨✨
        String logTitle = '';
        if (productId == 'monthly_subscription_star_contract') {
          logTitle = '啟動：星光契約 (月卡立即贈點) 🌙';
        } else {
          // 這裡的 pointsToAdd 已經算好首購雙倍的數字了，超級方便！
          logTitle = isFirstTime ? '儲值：$pointsToAdd 點 (含首購雙倍 🎁)' : '儲值：$pointsToAdd 點';
        }

        await docRef.collection('flower_logs').add({
          'title': logTitle,
          'amount': pointsToAdd,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // ✨✨✨ 記帳結束 ✨✨✨

        print("成功發放！商品ID: $productId，獲得 $pointsToAdd 點，並已寫入明細！");
        _showSuccessDialog(pointsToAdd, isFirstTime); // 顯示成功提示
      }

    } catch (e) {
      print("寫入 Firebase 失敗: $e");
    }
  }

  // --- UI 提示輔助方法 (升級版) ---
  void _showSuccessDialog(int points, bool isFirstTime) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('購買成功！ '),
            if (isFirstTime) const Text('🎉', style: TextStyle(fontSize: 24)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('已為您加上 $points 點花花。'),
            if (isFirstTime)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('✨ 恭喜觸發首購雙倍獎勵！', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('太棒了'),
          ),
        ],
      ),
    );
  }

  void _handleError(IAPError error) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('購買取消或失敗'),
        content: Text('尚未扣款。\n\n(錯誤碼: ${error.code})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  // ✨ 作弊專用方法：模擬購買成功 (測試完記得註解掉) ✨
  Future<void> testFakePurchase(String testProductId) async {
    final fakePurchase = PurchaseDetails(
      productID: testProductId,
      purchaseID: 'fake_test_${DateTime.now().millisecondsSinceEpoch}',
      status: PurchaseStatus.purchased,
      transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
      verificationData: PurchaseVerificationData(
          localVerificationData: 'fake_local_data',
          serverVerificationData: 'fake_server_data',
          source: 'google_play'
      ),
    );

    // 直接呼叫發貨邏輯
    await _deliverPurchase(fakePurchase);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
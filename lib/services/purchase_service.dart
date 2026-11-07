import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';
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
  final Set<String> _reportedIssues = {};

  String _accountId(String uid) => sha256.convert(utf8.encode(uid)).toString();

  String _appleAccountToken(String uid) {
    final chars = sha256.convert(utf8.encode('lianlian:apple:$uid')).toString().substring(0, 32).split('');
    chars[12] = '8';
    chars[16] = ((int.parse(chars[16], radix: 16) & 3) | 8).toRadixString(16);
    final value = chars.join();
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-${value.substring(12, 16)}-${value.substring(16, 20)}-${value.substring(20)}';
  }

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
    if (kIsWeb || _disposed || _querying || !isStoreAvailable || !(Platform.isAndroid || Platform.isIOS) ||
        FirebaseAuth.instance.currentUser == null) return;
    _querying = true;
    try {
      if (Platform.isAndroid) {
        final response = await _inAppPurchase
            .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
            .queryPastPurchases();
        if (response.error != null) throw StateError('查詢未完成購買失敗');
        _enqueue(response.pastPurchases);
      } else {
        final transactions = await SK2Transaction.unfinishedTransactions();
        _enqueue(transactions.map((transaction) => SK2PurchaseDetails(
          productID: transaction.productId,
          purchaseID: transaction.id,
          transactionDate: transaction.purchaseDate,
          verificationData: PurchaseVerificationData(
            localVerificationData: transaction.jsonRepresentation ?? '',
            serverVerificationData: transaction.receiptData ?? '',
            source: 'app_store'),
          status: PurchaseStatus.purchased,
          appAccountToken: transaction.appAccountToken,
        )).toList());
      }
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
    try {
      if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
      if (Platform.isIOS) {
        await InAppPurchaseStoreKitPlatform.enableStoreKit2();
      }
      WidgetsBinding.instance.addObserver(this);
      _subscription = _inAppPurchase.purchaseStream.listen(_enqueue,
        onError: (Object e) => debugPrint('購買監聽錯誤: ${e.runtimeType}'));
      _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) unawaited(retryPendingPurchases());
      });
      isStoreAvailable = await _inAppPurchase.isAvailable();
      if (isStoreAvailable) {
        // Product-list failure must not prevent recovery of already paid orders.
        _retryTimer = Timer.periodic(const Duration(minutes: 1), (_) {
          unawaited(retryPendingPurchases());
        });
        await retryPendingPurchases();
        await _loadProducts();
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
          : Sk2PurchaseParam(productDetails: productDetails,
              applicationUserName: _appleAccountToken(user.uid));
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
            (purchase.status == PurchaseStatus.restored)) {
          if (Platform.isAndroid) {
            await _deliverGooglePurchase(purchase);
          } else {
            await _deliverApplePurchase(purchase);
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
          if (Platform.isIOS && purchase is SK2PurchaseDetails) {
            final transactionId = int.tryParse(purchase.purchaseID ?? '');
            if (transactionId == null) throw StateError('缺少 Apple 交易編號');
            // StoreKit 0.4.9 marks restored as not pendingCompletePurchase;
            // finish only after the server has confirmed this exact transaction.
            await SK2Transaction.finish(transactionId);
          } else if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
        }

      } catch (e) {
        debugPrint('交易尚未完成，等待重試: ${e.runtimeType}');
        if (e is FirebaseFunctionsException && !_disposed &&
            _reportedIssues.add('${purchase.purchaseID}:${e.code}')) {
          final context = navigatorKey.currentContext;
          if (context != null && context.mounted) {
            final l10n = AppLocalizations.of(context);
            if (l10n != null) {
              unawaited(showDialog<void>(context: context, builder: (context) => AlertDialog(
                title: Text(l10n.shop_purchase_failed_title),
                content: Text(e.message ?? l10n.shop_purchase_failed_body(e.code)),
                actions: [TextButton(onPressed: () => Navigator.pop(context),
                  child: Text(l10n.ok_button))],
              )));
            }
          }
        }
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

  Future<void> _deliverApplePurchase(PurchaseDetails purchase) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('登入後才能發放購買');
    final result = await FirebaseFunctions.instanceFor(region: 'asia-east1')
        .httpsCallable('fulfillApplePurchase').call(<String, dynamic>{
      'signedTransaction': purchase.verificationData.serverVerificationData,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    if (data['fulfilled'] != true) throw StateError('Apple 交易尚未確認發放');
    if (data['alreadyFulfilled'] != true && !_disposed &&
        FirebaseAuth.instance.currentUser?.uid == user.uid) {
      _showSuccessDialog((data['points'] as num).toInt(),
        isFirstTime: data['isFirstTime'] == true,
        isMonthlyCard: purchase.productID.contains('monthly_card'));
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
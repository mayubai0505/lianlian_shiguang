import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/purchase_service.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    final purchaseService = Provider.of<PurchaseService>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2, // ✨ 雙分頁設定
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title:  Text(l10n.shop_title, style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: Container(
          child: Column(
            children: [
              // --- 1. 上方固定區塊：餘額顯示卡片 ---
              Padding(
                padding: EdgeInsets.only(
                    top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
                    left: 16,
                    right: 16),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: user != null
                      ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots()
                      : null,
                  builder: (context, snapshot) {
                    int currentPoints = 0;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      currentPoints = (snapshot.data!.data() as Map<String, dynamic>?)?['flowerPoints'] ?? 0;
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withValues(alpha:0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.dividerColor.withValues(alpha:0.1)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha:.05), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(l10n.shop_current_points_label,
                              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.6), fontSize: 14)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                isDarkMode ? 'assets/images/flower_gift_dark.png' : 'assets/images/flower_gift.png',
                                width: 44, height: 44,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_florist, size: 44, color: Colors.pink),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '$currentPoints',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // --- 2. 分頁切換選單 (TabBar) ---
              TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: theme.colorScheme.primary,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: l10n.shop_tab_top_up),
                  Tab(text: l10n.shop_tab_history),
                ],
              ),
              // --- 3. 下方滑動區塊：分頁內容 (TabBarView) ---
              Expanded(
                child: TabBarView(
                  children: [
                    // 第一頁：點數儲值商品列表
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildProductList(context, purchaseService),
                    ),

                    // 第二頁：收支明細列表
                    _buildHistoryList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 第一頁：儲值商品列表邏輯
  // ==========================================
  Widget _buildProductList(BuildContext context, PurchaseService service) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    List<dynamic> displayProducts = service.products;
    bool isTestingMode = displayProducts.isEmpty;

    // 如果抓不到真實商品，就用測試假商品展示
    if (isTestingMode) {
      displayProducts = [
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'monthly_subscription_star_contract', price: 'NT\$ 150')),
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'points_package_120', price: 'NT\$ 120')),
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'points_package_520', price: 'NT\$ 520')),
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'points_package_990', price: 'NT\$ 990')),
      ];
    }

    final monthlyCard = displayProducts.firstWhere(
            (p) => p.productDetails.id == 'monthly_subscription_star_contract',
        orElse: () => displayProducts.first
    );
    final regularProducts = displayProducts.where(
            (p) => p.productDetails.id != 'monthly_subscription_star_contract'
    ).toList();

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          List<dynamic> purchaseHistory = [];
          if (snapshot.hasData && snapshot.data!.exists) {
            purchaseHistory = (snapshot.data!.data() as Map<String, dynamic>?)?['purchaseHistory'] ?? [];
          }

          return Column(
            children: [
              if (isTestingMode)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text('⚠️ 目前為商店預覽模式', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),

              // 星光契約月卡
              MonthlyCardBanner(productWrapper: monthlyCard),
              const SizedBox(height: 20),

              // 一般花花禮包
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: regularProducts.length,
                itemBuilder: (context, index) {
                  final p = regularProducts[index];
                  bool isFirst = !purchaseHistory.contains(p.productDetails.id);
                  return ProductCard(productWrapper: p, isFirstPurchase: isFirst);
                },
              ),
            ],
          );
        }
    );
  }

  // ==========================================
  // 第二頁：收支明細列表邏輯
  // ==========================================
  Widget _buildHistoryList() {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('flower_logs')
          .orderBy('createdAt', descending: true) // 新的在最上面
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Text(l10n.shop_empty_history, style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 40),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final String title = data['title'] ?? l10n.shop_unknown_item;
            final int amount = data['amount'] ?? 0;
            final Timestamp? timestamp = data['createdAt'] as Timestamp?;

            String timeString = '';
            if (timestamp != null) {
              final date = timestamp.toDate();
              timeString = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
            }

            final bool isIncome = amount > 0;
            final theme = Theme.of(context);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withValues(alpha:0.05)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha:0.02), blurRadius: 8, offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(timeString, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    isIncome ? '+$amount' : '$amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isIncome ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ==========================================
// ✨ 獨立組件區：月卡橫幅
// ==========================================
class MonthlyCardBanner extends StatelessWidget {
  final dynamic productWrapper;
  const MonthlyCardBanner({super.key, required this.productWrapper});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [primaryColor, theme.colorScheme.secondary.withValues(alpha:0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: primaryColor.withValues(alpha:0.3), blurRadius: 12, offset: const Offset(0, 6))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final purchaseService = Provider.of<PurchaseService>(context, listen: false);
            await purchaseService.buyProduct(productWrapper.productDetails);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.stars_rounded, color: onPrimary, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('星光契約 (月卡)', style: TextStyle(color: onPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('立即得 250 花花，每日領 10 花花', style: TextStyle(color: onPrimary.withValues(alpha:0.85), fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: onPrimary, borderRadius: BorderRadius.circular(12)),
                  child: Text(productWrapper.productDetails.price, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ✨ 獨立組件區：一般商品卡片
// ==========================================
class ProductCard extends StatelessWidget {
  final dynamic productWrapper; // 根據妳的型別定義 (ProductDetailsWrapper)
  final bool isFirstPurchase;

  const ProductCard({
    super.key,
    required this.productWrapper,
    this.isFirstPurchase = false
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      color: theme.cardColor.withValues(alpha:isDarkMode ? 0.4 : 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: primaryColor.withValues(alpha:0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final purchaseService = Provider.of<PurchaseService>(context, listen: false);
          await purchaseService.buyProduct(productWrapper.productDetails);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isDarkMode ? 'assets/images/flower_gift_dark.png' : 'assets/images/flower_gift.png',
                height: 50,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_florist, size: 50, color: Colors.pink),
              ),
              const SizedBox(height: 12),
              Text("${productWrapper.productDetails.id.split('_').last} 點花花", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (isFirstPurchase)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha:0.1), borderRadius: BorderRadius.circular(6)),
                  child:Text(l10n.shop_first_purchase_bonus, style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: primaryColor.withValues(alpha:0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(productWrapper.productDetails.price, textAlign: TextAlign.center, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ✨ 臨時演員：假商品類別 (如果沒有真實商品時使用)
// ==========================================
class ProductDetailsWrapper {
  final dynamic productDetails;
  ProductDetailsWrapper({required this.productDetails});
}

class MockProductDetails {
  final String id;
  final String title = '';
  final String description = '';
  final String price;
  final double rawPrice = 0;
  final String currencyCode = 'TWD';
  final String currencySymbol = 'NT\$';

  MockProductDetails({required this.id, required this.price});
}
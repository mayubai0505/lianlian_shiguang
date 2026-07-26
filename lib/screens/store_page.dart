import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/purchase_service.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';

Future<void> _buyStoreProductByPlatform(
    BuildContext context,
    dynamic productWrapper,
    ) async {

  final purchaseService = Provider.of<PurchaseService>(context, listen: false);
  await purchaseService.buyProduct(productWrapper.productDetails);
}

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
      length: 3, // ✨ 完美擴充為 3 個分頁
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title:  Text(l10n.shop_title, style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: Column(
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
                const Tab(text: '累計福利'), // ✨ 新增專屬的課條分頁
                Tab(text: l10n.shop_tab_history),
              ],
            ),
            // --- 3. 下方滑動區塊：分頁內容 (TabBarView) ---
            Expanded(
              child: TabBarView(
                children: [
                  // 第一頁：點數儲值商品列表
                  StreamBuilder<DocumentSnapshot>(
                    stream: user != null
                        ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots()
                        : null,
                    builder: (context, snapshot) {
                      final userData = (snapshot.data?.data() as Map<String, dynamic>?) ?? {};

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildProductList(context, purchaseService),
                          ],
                        ),
                      );
                    },
                  ),

                  // ✨ 第二頁：專屬 VIP 課條分頁
                  _buildVipTab(),

                  // 第三頁：收支明細列表
                  _buildHistoryList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ✨ 新增區塊：VIP 累計福利 (課條)
  // ==========================================
  // ==========================================
  // ✨ 新增區塊：VIP 累計福利 (課條 3.0 最終定案版)
  // ==========================================
  Widget _buildVipTab() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        int totalSpent = 0;
        if (snapshot.hasData && snapshot.data!.exists) {
          totalSpent = (snapshot.data!.data() as Map<String, dynamic>?)?['totalSpent'] ?? 0;
        }

        // ✨ 總裁定案的 10 階 VIP 尊榮課條
        final List<Map<String, dynamic>> vipTiers = [
          {'amount': 30, 'title': '初見傾心', 'reward': '20 點花花 + 專屬新手稱號', 'icon': Icons.favorite_border},
          {'amount': 70, 'title': '微光悸動', 'reward': '專屬頭像框【微光悸動】', 'icon': Icons.flare},
          {'amount': 250, 'title': '星空呢喃', 'reward': '專屬聊天氣泡 + 50 點花花', 'icon': Icons.chat_bubble_outline},
          {'amount': 520, 'title': '浪漫夕陽', 'reward': '專屬 App 桌面圖示 (Icon)', 'icon': Icons.image_outlined},
          {'amount': 880, 'title': '怦然心動', 'reward': '點擊螢幕特效 (Lottie) + 100 點花花', 'icon': Icons.touch_app_outlined},
          {'amount': 1314, 'title': '永恆誓約', 'reward': '進階動態頭像框 + 200 點花花', 'icon': Icons.diamond_outlined},
          {'amount': 2000, 'title': '靈魂交會', 'reward': '動態聊天氣泡特效 + 專屬進階稱號', 'icon': Icons.chat_outlined},
          {'amount': 3000, 'title': '專屬守候', 'reward': '頂級動態名牌 + 500 點花花', 'icon': Icons.stars_outlined},
          {'amount': 6000, 'title': '璀璨星河', 'reward': '專屬進場 Lottie 特效 + 專屬客服', 'icon': Icons.auto_awesome},
          {'amount': 10000, 'title': '頂級摯愛', 'reward': '【實體 VIP 專屬禮盒】(手寫信+代表娃)', 'icon': Icons.card_giftcard},
        ];

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 40),
          itemCount: vipTiers.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildVipProgressCard(totalSpent, vipTiers, context);
            }
            final tier = vipTiers[index - 1];
            final bool isUnlocked = totalSpent >= tier['amount'];
            return _buildVipTierCard(tier, isUnlocked, context);
          },
        );
      },
    );
  }

  // ✨ 根據累積金額自動切換對應的手繪樹圖片
  String _getTreeImagePath(int totalSpent) {
    if (totalSpent >= 10000) return 'assets/images/tree_star.png';        // 👑 10,000+: 星花
    if (totalSpent >= 3000) return 'assets/images/tree_full_flower.png';  // 🌸 3,000+: 滿花
    if (totalSpent >= 1314) return 'assets/images/tree_blooming.png';     // 🌷 1,314+: 開花
    if (totalSpent >= 880) return 'assets/images/tree_large.png';         // 🌳 880+: 大樹
    if (totalSpent >= 520) return 'assets/images/tree_small.png';         // 🌲 520+: 小樹
    if (totalSpent >= 250) return 'assets/images/tree_sapling.png';       // 🌿 250+: 樹苗
    if (totalSpent >= 30) return 'assets/images/tree_sprout.png';         // 🌱 30+: 發芽
    return 'assets/images/tree_seed.png';                                 // 🌰 0: 種子
  }

  // ✨ VIP 上方總覽卡片 (結合朋友畫的手繪成長樹)
  Widget _buildVipProgressCard(int totalSpent, List<Map<String, dynamic>> tiers, BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    int nextTierAmount = tiers.last['amount'];
    for (var tier in tiers) {
      if (totalSpent < tier['amount']) {
        nextTierAmount = tier['amount'];
        break;
      }
    }
    double progress = totalSpent / nextTierAmount;
    if (progress > 1.0) progress = 1.0;

    String treeImage = _getTreeImagePath(totalSpent);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withValues(alpha: 0.8), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          // 🌳 左側：朋友親手畫的手繪成長樹
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              treeImage,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_florist, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          // 📊 右側：金額、進度條與提示
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('累積浪漫羈絆', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('NT\$ $totalSpent', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  totalSpent >= tiers.last['amount']
                      ? '您已解鎖所有頂級特權！'
                      : '再儲值 NT\$ ${nextTierAmount - totalSpent} 即可解鎖下一階',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✨ VIP 單一階級獎勵卡片
  Widget _buildVipTierCard(Map<String, dynamic> tier, bool isUnlocked, BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnlocked ? primaryColor.withValues(alpha: 0.5) : theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked ? primaryColor.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(tier['icon'], color: isUnlocked ? primaryColor : Colors.grey, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(tier['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isUnlocked ? theme.textTheme.bodyLarge?.color : Colors.grey)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('NT\$ ${tier['amount']}', style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(tier['reward'], style: TextStyle(color: isUnlocked ? primaryColor : Colors.grey, fontSize: 13, fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal)),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(Icons.check_circle, color: primaryColor, size: 24)
          else
            const Icon(Icons.lock_outline, color: Colors.grey, size: 24),
        ],
      ),
    );
  }

  // ==========================================
  // 下方為原有的方法 (維持不變)
  // ==========================================
  int _calculateDaysRemaining(String? endDateStr) {
    if (endDateStr == null) return 0;
    try {
      DateTime endDate = DateTime.parse(endDateStr);
      DateTime now = DateTime.now();
      if (endDate.isBefore(now)) return 0;
      return endDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildProductList(BuildContext context, PurchaseService service) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    List<dynamic> displayProducts = service.products;
    bool isTestingMode = false;

    if (kIsWeb) {
      displayProducts = [
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'com_lianlian_monthly_card_250', price: 'NT\$250')),
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'com_lianlian_points_90', price: 'NT\$30')),
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'com_lianlian_points_215', price: 'NT\$70')),
        ProductDetailsWrapper(productDetails: MockProductDetails(id: 'com_lianlian_points_590', price: 'NT\$170')),
      ];
    } else {
      isTestingMode = displayProducts.isEmpty;
    }

    if (!kIsWeb && displayProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                l10n.shop_restocking,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    final monthlyCard = displayProducts.where((p) => p.productDetails.id.contains('monthly_card')).firstOrNull ?? displayProducts.first;
    final regularProducts = displayProducts.where((p) => !p.productDetails.id.contains('monthly_card')).toList();

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          List<dynamic> purchaseHistory = [];
          String? endDateStr;

          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;
            purchaseHistory = userData?['purchaseHistory'] ?? [];
            endDateStr = userData?['monthlySubEndDate'];
          }

          int daysRemaining = _calculateDaysRemaining(endDateStr);
          bool isLimitReached = daysRemaining > 150;

          final screenWidth = MediaQuery.of(context).size.width;
          final bool isWideScreen = screenWidth > 600;
          final int columns = isWideScreen ? 3 : 2;
          final double cardRatio = isWideScreen ? 1.1 : 0.75;
          final l10n = AppLocalizations.of(context)!;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                children: [
                  if (isTestingMode)
                    Padding(padding: EdgeInsets.only(bottom: 16), child: Text(l10n.shop_preview_mode, style: TextStyle(color: Colors.grey, fontSize: 12))),
                  MonthlyCardBanner(productWrapper: monthlyCard, daysRemaining: daysRemaining, isLimitReached: isLimitReached),
                  const SizedBox(height: 20),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: cardRatio),
                    itemCount: regularProducts.length,
                    itemBuilder: (context, index) {
                      final p = regularProducts[index];
                      bool isFirst = !purchaseHistory.contains(p.productDetails.id);
                      return ProductCard(productWrapper: p, isFirstPurchase: isFirst);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _buildHistoryList() {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('flower_logs').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Text(l10n.shop_empty_history, style: const TextStyle(color: Colors.grey)));
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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.02), blurRadius: 8, offset: const Offset(0, 4))],
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

class MonthlyCardBanner extends StatelessWidget {
  final dynamic productWrapper;
  final int daysRemaining;
  final bool isLimitReached;

  const MonthlyCardBanner({
    super.key,
    required this.productWrapper,
    required this.daysRemaining,
    required this.isLimitReached,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    bool canPurchase = !isLimitReached && !productWrapper.isPending;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [primaryColor, theme.colorScheme.secondary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: onPrimary, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.shop_monthly_card_name, style: TextStyle(color: onPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                        daysRemaining > 0
                            ? l10n.shop_monthly_card_status_active(daysRemaining)
                            : l10n.shop_monthly_card_promo_desc,
                        style: TextStyle(color: onPrimary.withValues(alpha: 0.85), fontSize: 13)
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: canPurchase ? () async { await _buyStoreProductByPlatform(context, productWrapper); } : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        color: canPurchase ? onPrimary : onPrimary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: productWrapper.isPending
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor))
                        : Text(
                        isLimitReached ? l10n.shop_monthly_card_limit_reached : productWrapper.productDetails.price,
                        style: TextStyle(fontWeight: FontWeight.bold, color: canPurchase ? primaryColor : Colors.grey.shade700)
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: onPrimary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          _buildPrivilegeRow(Icons.refresh, l10n.monthly_privilege_reroll_title, l10n.monthly_privilege_reroll_desc, onPrimary),
          const SizedBox(height: 12),
          _buildPrivilegeRow(Icons.favorite, l10n.monthly_privilege_affinity_title, l10n.monthly_privilege_affinity_desc, onPrimary),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Icon(Icons.help_outline, size: 16, color: onPrimary.withValues(alpha: 0.9)),
              label: Text(l10n.monthly_manual_button, style: TextStyle(color: onPrimary.withValues(alpha: 0.9), decoration: TextDecoration.underline, decorationColor: onPrimary.withValues(alpha: 0.9))),
              onPressed: () => _showMonthlyPassManual(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivilegeRow(IconData icon, String title, String subtitle, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: textColor.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: Icon(icon, color: textColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic productWrapper;
  final bool isFirstPurchase;

  const ProductCard({super.key, required this.productWrapper, this.isFirstPurchase = false});

  String _getRomanticName(String id, AppLocalizations l10n) {
    if (id.contains('90')) return l10n.pack_first_meet;
    if (id.contains('215')) return l10n.pack_crush;
    if (id.contains('370')) return l10n.pack_heartbeat;
    if (id.contains('590')) return l10n.pack_passionate;
    if (id.contains('780')) return l10n.pack_soulmate;
    if (id.contains('1030')) return l10n.pack_waiting;
    if (id.contains('1420')) return l10n.pack_trust;
    if (id.contains('1650')) return l10n.pack_iloveyou;
    if (id.contains('2200')) return l10n.pack_honeymoon;
    if (id.contains('2300')) return l10n.pack_promise;
    if (id.contains('2400')) return l10n.pack_companion;
    if (id.contains('2680')) return l10n.pack_deep_love;
    if (id.contains('3200')) return l10n.pack_long_lasting;
    if (id.contains('3400')) return l10n.pack_the_one;
    if (id.contains('4200')) return l10n.pack_beloved;
    if (id.contains('4300')) return l10n.pack_lifetime;
    if (id.contains('6400')) return l10n.pack_vow;
    if (id.contains('10000')) return l10n.pack_eternal;
    return l10n.pack_exclusive;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final String points = productWrapper.productDetails.id.split('_').last;
    final String romanticName = _getRomanticName(productWrapper.productDetails.id, l10n);

    return Card(
      elevation: 0,
      color: theme.cardColor.withValues(alpha:isDarkMode ? 0.4 : 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: primaryColor.withValues(alpha:0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async { await _buyStoreProductByPlatform(context, productWrapper); },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isDarkMode ? 'assets/images/flower_gift_dark.png' : 'assets/images/flower_gift.png',
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_florist, size: 40, color: Colors.pink),
              ),
              const SizedBox(height: 8),
              Text(romanticName, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14)),
              Text(l10n.flowerPointsCount(points.toString()), style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              if (isFirstPurchase)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha:0.1), borderRadius: BorderRadius.circular(6)),
                  child:Text(l10n.shop_first_purchase_bonus, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
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

class ProductDetailsWrapper {
  final dynamic productDetails;
  bool isPending;
  ProductDetailsWrapper({required this.productDetails, this.isPending = false});
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

void _showMonthlyPassManual(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.pinkAccent),
                  const SizedBox(width: 8),
                  Text(l10n.passGuideTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _buildManualItem(icon: Icons.refresh, title: l10n.passGuideRegenerateTitle, content: l10n.passGuideRegenerateContent),
              const SizedBox(height: 16),
              _buildManualItem(icon: Icons.favorite, title: l10n.passGuideAffectionTitle, content: l10n.passGuideAffectionContent),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.passGuideUnlockButton, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildManualItem({required IconData icon, required String title, required String content}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 4),
      Padding(padding: const EdgeInsets.only(left: 4.0), child: Text(content, style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 13))),
    ],
  );
}
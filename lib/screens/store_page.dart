import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/purchase_service.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_fonts/google_fonts.dart';


// 🍎 蘋果審查專用總開關：送審前設為 true (會隱藏VIP頁籤)，審核通過上架後改回 false！
const bool isAppleReviewMode = true;
class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}
class _StorePageState extends State<StorePage> {
  bool _isTapPayProcessing = false;

  Future<void> _buyStoreProductByPlatform(
      BuildContext context,
      dynamic productWrapper,
      ) async {

    // Android / iOS：維持原本的商店內購
    final purchaseService =
    Provider.of<PurchaseService>(
      context,
      listen: false,
    );

    await purchaseService.buyProduct(
      productWrapper.productDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final purchaseService = Provider.of<PurchaseService>(context);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final double maxContentWidth =
              width >= 700 ? 720.0 : width;
              final double sidePadding =
              width >= 700 ? 28.0 : 18.0;

              final double cornerWidth =
              (width * 0.32).clamp(120.0, 220.0).toDouble();
              final double cornerOffset =
              -(width * 0.06).clamp(16.0, 42.0).toDouble();
              final double cornerVerticalOffset =
              -(height * 0.025).clamp(14.0, 30.0).toDouble();

              // 外層花草：寬度、左右與上下偏移都採相對值 + clamp，
              // 手機、長螢幕與平板尺寸都能保持穩定。
              return Stack(
                children: [
                  Positioned(
                    top: cornerVerticalOffset,
                    right: cornerOffset,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.16,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            primary.withValues(alpha: 0.78),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/store/store_corner_top_right.png',
                            width: cornerWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: cornerOffset,
                    bottom: cornerVerticalOffset,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.13,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            primary.withValues(alpha: 0.78),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/store/store_corner_left.png',
                            width: cornerWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(maxWidth: maxContentWidth),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              sidePadding,
                              4,
                              sidePadding,
                              0,
                            ),
                            child: SizedBox(
                              height: 58,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).maybePop(),
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 22,
                                        color: Colors.black87,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Text(
                                    l10n.shop_title,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2.2,
                                      color: primary,
                                    ),
                                  ),
                                  if (user != null)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          final data = snapshot.data?.data()
                                          as Map<String, dynamic>?;
                                          final int points =
                                              data?['flowerPoints'] ?? 0;

                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.94),
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              border: Border.all(
                                                color: primary.withValues(
                                                    alpha: 0.10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: primary.withValues(
                                                      alpha: 0.06),
                                                  blurRadius: 12,
                                                  offset:
                                                  const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'assets/images/store/store_flower_point.png',
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.contain,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  _formatNumber(points),
                                                  style:
                                                  GoogleFonts.notoSerifTc(
                                                    fontSize: 12.5,
                                                    color: primary,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: sidePadding,
                            ),
                            child: _buildBalanceCard(
                              context,
                              user,
                              width,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: sidePadding,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: primary.withValues(alpha: 0.10),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              labelColor: primary,
                              unselectedLabelColor:
                              primary.withValues(alpha: 0.48),
                              indicatorColor: primary,
                              indicatorWeight: 2.5,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelStyle: GoogleFonts.notoSerifTc(
                                fontSize: width < 360 ? 12.5 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                              unselectedLabelStyle:
                              GoogleFonts.notoSerifTc(
                                fontSize: width < 360 ? 12.5 : 14,
                                fontWeight: FontWeight.w400,
                              ),
                              tabs: [
                                Tab(text: _monthlyTabLabel(context)),
                                Tab(text: l10n.shop_tab_top_up),
                                Tab(text: l10n.shop_tab_history),
                              ],
                            ),
                          ),

                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildMonthlyTab(
                                  context,
                                  purchaseService,
                                ),
                                _buildProductList(
                                  context,
                                  purchaseService,
                                ),
                                _buildHistoryList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatNumber(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < raw.length; i++) {
      final remaining = raw.length - i;
      buffer.write(raw[i]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }

  String _monthlyTabLabel(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    const labels = <String, String>{
      'ar': 'قسم البطاقة الشهرية',
      'en': 'Monthly Pass',
      'es': 'Pase mensual',
      'fr': 'Pass mensuel',
      'hi': 'मासिक पास',
      'id': 'Paket Bulanan',
      'ja': '月間パス',
      'ko': '월간 패스',
      'ms': 'Pas Bulanan',
      'pt': 'Passe mensal',
      'th': 'บัตรรายเดือน',
      'vi': 'Thẻ tháng',
      'zh': '月卡專區',
    };

    return labels[languageCode] ?? labels['en']!;
  }

  Widget _buildBalanceCard(
      BuildContext context,
      User? user,
      double screenWidth,
      ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    // 餘額卡內花草：依螢幕寬度做相對定位，並用 clamp 限制，
    // 避免小手機太擠、平板又放得過大。
    final double balanceFlowerWidth =
    (screenWidth * 0.27).clamp(95.0, 165.0).toDouble();
    final double balanceHorizontalOffset =
    -(screenWidth * 0.045).clamp(12.0, 28.0).toDouble();
    final double balanceVerticalOffset =
    -(screenWidth * 0.055).clamp(16.0, 32.0).toDouble();

    return StreamBuilder<DocumentSnapshot>(
      stream: user != null
          ? FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          : null,
      builder: (context, snapshot) {
        final data =
        snapshot.data?.data() as Map<String, dynamic>?;
        final int currentPoints = data?['flowerPoints'] ?? 0;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: screenWidth < 430 ? 180 : 200,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: primary.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: balanceHorizontalOffset,
                bottom: balanceVerticalOffset,
                child: Opacity(
                  opacity: 0.13,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      primary.withValues(alpha: 0.72),
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/store/store_corner_left.png',
                      width: balanceFlowerWidth,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: balanceHorizontalOffset,
                top: balanceVerticalOffset,
                child: Opacity(
                  opacity: 0.13,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      primary.withValues(alpha: 0.72),
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/store/store_corner_top_right.png',
                      width: balanceFlowerWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 26,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.shop_current_points_label,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        letterSpacing: 0.8,
                        color: primary.withValues(alpha: 0.68),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/store/store_flower_point.png',
                          width: 46,
                          height: 46,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _formatNumber(currentPoints),
                              style: GoogleFonts.notoSerifTc(
                                fontSize: screenWidth < 380 ? 45 : 54,
                                height: 1,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                color: primary,
                              ),
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
        );
      },
    );
  }

  List<dynamic> _resolveStoreProducts(
      PurchaseService service,
      ) {
    if (kIsWeb) {
      return [
        ProductDetailsWrapper(
          productDetails: MockProductDetails(
            id: 'com_lianlian_monthly_card_250',
            price: 'NT\$250',
          ),
        ),
        ProductDetailsWrapper(
          productDetails: MockProductDetails(
            id: 'com.lianlian.points_90',
            price: 'NT\$30',
          ),
        ),
        ProductDetailsWrapper(
          productDetails: MockProductDetails(
            id: 'com.lianlian.points_215',
            price: 'NT\$70',
          ),
        ),
        ProductDetailsWrapper(
          productDetails: MockProductDetails(
            id: 'com.lianlian.points_370',
            price: 'NT\$120',
          ),
        ),
        ProductDetailsWrapper(
          productDetails: MockProductDetails(
            id: 'com.lianlian.points_590',
            price: 'NT\$190',
          ),
        ),
      ];
    }

    return service.products;
  }

  Widget _buildMonthlyTab(
      BuildContext context,
      PurchaseService service,
      ) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final displayProducts = _resolveStoreProducts(service);

    if (!kIsWeb && displayProducts.isEmpty) {
      return _buildStoreEmptyState(context);
    }

    final monthlyCandidates = displayProducts
        .where((p) =>
        p.productDetails.id.contains('monthly_card'))
        .toList();

    if (monthlyCandidates.isEmpty) {
      return Center(
        child: Text(
          l10n.shop_restocking,
          style: GoogleFonts.notoSerifTc(
            color: Colors.grey,
          ),
        ),
      );
    }

    final monthlyCard = monthlyCandidates.first;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final userData =
        snapshot.data?.data() as Map<String, dynamic>?;
        final String? endDateStr =
        userData?['monthlySubEndDate'];

        final int daysRemaining =
        _calculateDaysRemaining(endDateStr);
        final bool isLimitReached = daysRemaining > 150;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            44,
          ),
          child: MonthlyCardBanner(
            productWrapper: monthlyCard,
            daysRemaining: daysRemaining,
            isLimitReached: isLimitReached,
            onPurchase: () async {
              await _buyStoreProductByPlatform(
                context,
                monthlyCard,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStoreEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_florist_outlined,
              size: 48,
              color: primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.shop_restocking,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                color: primary.withValues(alpha: 0.55),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ✨ VIP 累計福利 (課條) - 完全保留在此，不用刪除
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

  Widget _buildProductList(
      BuildContext context,
      PurchaseService service,
      ) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final displayProducts = _resolveStoreProducts(service);
    final bool isTestingMode =
        kIsWeb || (!kIsWeb && service.products.isEmpty);

    if (!kIsWeb && displayProducts.isEmpty) {
      return _buildStoreEmptyState(context);
    }

    final regularProducts = displayProducts
        .where((p) =>
    !p.productDetails.id.contains('monthly_card'))
        .toList();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final userData =
            snapshot.data?.data() as Map<String, dynamic>? ??
                {};
        final List<dynamic> purchaseHistory =
            userData['purchaseHistory'] ?? [];

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 700;
            final int columns = isTablet ? 3 : 2;
            final double ratio =
            isTablet ? 1.00 : 0.82;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                18,
                18,
                18,
                44,
              ),
              child: Column(
                children: [
                  if (isTestingMode)
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l10n.shop_preview_mode,
                        style: GoogleFonts.notoSerifTc(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: regularProducts.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: ratio,
                    ),
                    itemBuilder: (context, index) {
                      final p = regularProducts[index];
                      final bool isFirst =
                      !purchaseHistory.contains(
                        p.productDetails.id,
                      );

                      return ProductCard(
                        productWrapper: p,
                        isFirstPurchase: isFirst,
                        onPurchase: () async {
                          await _buyStoreProductByPlatform(
                            context,
                            p,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '✦',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.35),
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

  Widget _buildHistoryList() {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('flower_logs')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Text(
              l10n.shop_empty_history,
              style: GoogleFonts.notoSerifTc(
                color: Colors.grey,
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            44,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data =
            docs[index].data() as Map<String, dynamic>;
            final String title =
                data['title'] ?? l10n.shop_unknown_item;
            final int amount = data['amount'] ?? 0;
            final Timestamp? timestamp =
            data['createdAt'] as Timestamp?;

            String timeString = '';
            if (timestamp != null) {
              final date = timestamp.toDate();
              timeString =
              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
                  "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
            }

            final bool isIncome = amount > 0;

            return _HistoryCard(
              title: title,
              timeString: timeString,
              amount: amount,
              isIncome: isIncome,
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
  final Future<void> Function() onPurchase;

  const MonthlyCardBanner({
    super.key,
    required this.productWrapper,
    required this.daysRemaining,
    required this.isLimitReached,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bool canPurchase =
        !isLimitReached && !productWrapper.isPending;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primary.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isPhone = constraints.maxWidth < 520;

          final Widget heading = Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withValues(alpha: 0.05),
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Image.asset(
                      'assets/images/store/store_icon_star.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.shop_monthly_card_name,
                          maxLines: isPhone ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: isPhone ? 18 : 20,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            letterSpacing: 0.8,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          daysRemaining > 0
                              ? l10n.shop_monthly_card_status_active(
                            daysRemaining,
                          )
                              : l10n.shop_monthly_card_promo_desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 11.5,
                            height: 1.45,
                            color: primary.withValues(alpha: 0.58),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showMonthlyPassManual(context),
                  icon: Icon(
                    Icons.help_outline_rounded,
                    size: 15,
                    color: primary.withValues(alpha: 0.62),
                  ),
                  label: Text(
                    l10n.monthly_manual_button,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11,
                      color: primary.withValues(alpha: 0.62),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                  ),
                ),
              ),
            ],
          );

          final Widget hero = ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: isPhone ? 190 : 250,
            ),
            child: Image.asset(
              'assets/images/store/store_monthly_hero.png',
              fit: BoxFit.contain,
            ),
          );

          final Widget perks = Column(
            children: [
              _PerkTile(
                imagePath:
                'assets/images/store/store_flower_point.png',
                title: l10n.shop_current_points_label,
                subtitle: '+250',
              ),
              const SizedBox(height: 8),
              _PerkTile(
                imagePath:
                'assets/images/store/store_icon_calendar.png',
                title: l10n.monthly_privilege_reroll_title,
                subtitle: l10n.monthly_privilege_reroll_desc,
              ),
              const SizedBox(height: 8),
              _PerkTile(
                imagePath:
                'assets/images/store/store_icon_heart.png',
                title: l10n.monthly_privilege_affinity_title,
                subtitle: l10n.monthly_privilege_affinity_desc,
              ),
            ],
          );

          final Widget purchaseBar = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.035),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    daysRemaining > 0
                        ? l10n.shop_monthly_card_status_active(
                      daysRemaining,
                    )
                        : l10n.shop_monthly_card_promo_desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 10.5,
                      height: 1.35,
                      color: primary.withValues(alpha: 0.56),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: canPurchase ? onPurchase : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      primary.withValues(alpha: 0.24),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                    child: productWrapper.isPending
                        ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      isLimitReached
                          ? l10n.shop_monthly_card_limit_reached
                          : productWrapper.productDetails.price,
                      maxLines: 1,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading,
              const SizedBox(height: 10),

              if (isPhone) ...[
                hero,
                const SizedBox(height: 12),
                perks,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: hero,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 7,
                      child: perks,
                    ),
                  ],
                ),

              const SizedBox(height: 16),
              purchaseBar,
            ],
          );
        },
      ),
    );
  }
}

class _PerkTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _PerkTile({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary.withValues(alpha: 0.09),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.05),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 10.5,
                    height: 1.35,
                    color:
                    primary.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic productWrapper;
  final bool isFirstPurchase;
  final Future<void> Function() onPurchase;

  const ProductCard({
    super.key,
    required this.productWrapper,
    this.isFirstPurchase = false,
    required this.onPurchase,
  });

  String _getRomanticName(
      String id,
      AppLocalizations l10n,
      ) {
    if (id.contains('90')) return l10n.pack_first_meet;
    if (id.contains('215')) return l10n.pack_crush;
    if (id.contains('370')) return l10n.pack_heartbeat;
    if (id.contains('590')) return l10n.pack_passionate;
    if (id.contains('780')) return l10n.pack_soulmate;
    if (id.contains('1030')) return l10n.pack_waiting;
    if (id.contains('1420')) return l10n.pack_trust;
    if (id.contains('1650')) return l10n.pack_iloveyou;
    if (id.contains('2200')) return l10n.pack_honeymoon;
    if (id.contains('2300') || id.contains('2350')) {
      return l10n.pack_promise;
    }
    if (id.contains('2400')) return l10n.pack_companion;
    if (id.contains('2680')) return l10n.pack_deep_love;
    if (id.contains('3200')) {
      return l10n.pack_long_lasting;
    }
    if (id.contains('3400') || id.contains('3450')) {
      return l10n.pack_the_one;
    }
    if (id.contains('4200')) return l10n.pack_beloved;
    if (id.contains('4300')) return l10n.pack_lifetime;
    if (id.contains('6400')) return l10n.pack_vow;
    if (id.contains('10000')) return l10n.pack_eternal;
    return l10n.pack_exclusive;
  }

  String _getFlowerAsset(int points) {
    // 花花禮包視覺階級：
    // 90         -> 單朵花
    // 215~370    -> 小花束
    // 590~1030   -> 中花束
    // 1420~2350  -> 大花束
    // 2400~4300  -> 豪華花束
    // 6400~10000 -> 頂級花束
    if (points <= 90) {
      return 'assets/images/store/store_flower_single.png';
    }
    if (points <= 370) {
      return 'assets/images/store/store_bouquet_small.png';
    }
    if (points <= 1030) {
      return 'assets/images/store/store_bouquet_medium.png';
    }
    if (points <= 2350) {
      return 'assets/images/store/store_bouquet_large.png';
    }
    if (points <= 4300) {
      return 'assets/images/store/store_bouquet_luxury.png';
    }
    return 'assets/images/store/store_bouquet_premium.png';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    final String id = productWrapper.productDetails.id;
    final String pointsText = id.split('_').last;
    final int points = int.tryParse(pointsText) ?? 0;
    final String romanticName =
    _getRomanticName(id, l10n);
    final String imagePath = _getFlowerAsset(points);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () async {
          await onPurchase();
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: primary.withValues(alpha: 0.09),
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.055),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              12,
              10,
              12,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding:
                          const EdgeInsets.all(4),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              romanticName,
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              GoogleFonts.notoSerifTc(
                                fontSize: 13.5,
                                height: 1.25,
                                fontWeight:
                                FontWeight.w600,
                                color: primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.flowerPointsCount(
                                pointsText,
                              ),
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              GoogleFonts.notoSerifTc(
                                fontSize: 10.5,
                                color: primary.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                            ),
                            if (isFirstPurchase) ...[
                              const SizedBox(height: 7),
                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent
                                      .withValues(alpha: 0.07),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l10n
                                      .shop_first_purchase_bonus,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style:
                                  GoogleFonts.notoSerifTc(
                                    color:
                                    Colors.redAccent,
                                    fontSize: 9,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withValues(alpha: 0.86),
                        primary.withValues(alpha: 0.64),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    productWrapper.productDetails.price,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String timeString;
  final int amount;
  final bool isIncome;

  const _HistoryCard({
    required this.title,
    required this.timeString,
    required this.amount,
    required this.isIncome,
  });

  String _resolveIcon() {
    final lower = title.toLowerCase();

    if (title.contains('簽到') ||
        lower.contains('check')) {
      return 'assets/images/store/store_icon_calendar.png';
    }
    if (title.contains('聊天') ||
        lower.contains('chat')) {
      return 'assets/images/store/store_icon_chat.png';
    }
    if (title.contains('月卡') ||
        title.contains('星光契約')) {
      return 'assets/images/store/store_flower_point.png';
    }
    if (title.contains('禮包') ||
        title.contains('儲值') ||
        lower.contains('purchase')) {
      return 'assets/images/store/store_icon_gift_round.png';
    }
    if (title.contains('補償') ||
        lower.contains('compensation')) {
      return 'assets/images/store/store_icon_star.png';
    }

    return isIncome
        ? 'assets/images/store/store_icon_gift.png'
        : 'assets/images/store/store_icon_chat.png';
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.045),
            ),
            padding: const EdgeInsets.all(7),
            child: Image.asset(
              _resolveIcon(),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeString,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 10.5,
                    color: primary.withValues(alpha: 0.46),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isIncome ? '+$amount' : '$amount',
            style: GoogleFonts.notoSerifTc(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isIncome
                  ? Colors.green.shade600
                  : Colors.redAccent,
            ),
          ),
        ],
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
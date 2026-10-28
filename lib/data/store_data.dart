import 'package:lianlian_shiguang/l10n/app_l10n.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
class GameProduct {
  final String id;
  final String name;
  final int points;
  final String? bonusTag; // 右上角的優惠標籤文字, 例如 "+45%"

  const GameProduct({
    required this.id,
    required this.name,
    required this.points,
    this.bonusTag,
  });
}

// ✨ 核心對照表！ ✨
// key 是您在 Google Play Console 設定的商品 ID
// value 是上面定義的 GameProduct 物件
Map<String, GameProduct> get storeProducts => {
  'points_package_30': const GameProduct(id: 'points_package_30', name: '初見禮包', points: 90, bonusTag: '+10%'),
  'points_package_70': const GameProduct(id: 'points_package_70', name: '曖昧禮包', points: 215, bonusTag: '+15%'),
  'points_package_120': const GameProduct(id: 'points_package_120', name: '心動禮包', points: 370, bonusTag: '+20%'),
  'points_package_190': const GameProduct(id: 'points_package_190', name: '熱戀禮包', points: 590, bonusTag: '+25%'),
  'points_package_250': const GameProduct(id: 'points_package_250', name: '知己禮包', points: 780, bonusTag: '+28%'),
  'points_package_330': const GameProduct(id: 'points_package_330', name: '守候禮包', points: 1030, bonusTag: '+30%'),
  'points_package_450': const GameProduct(id: 'points_package_450', name: '信賴禮包', points: 1420, bonusTag: '+32%'),
  'points_package_520': const GameProduct(id: 'points_package_520', name: '我愛你禮包', points: 1650, bonusTag: '+35%'),
  'points_package_690': const GameProduct(id: 'points_package_690', name: '蜜月禮包', points: 2200, bonusTag: '+38%'),
  'points_package_720': const GameProduct(id: 'points_package_720', name: '承諾禮包', points: 2300, bonusTag: '+40%'),
  'points_package_750': const GameProduct(id: 'points_package_750', name: '相伴禮包', points: 2400, bonusTag: '+42%'),
  'points_package_830': const GameProduct(id: 'points_package_830', name: '深愛禮包', points: 2680, bonusTag: '+45%'),
  'points_package_990': const GameProduct(id: 'points_package_990', name: '長久禮包', points: 3200, bonusTag: '+48%'),
  'points_package_1050': const GameProduct(id: 'points_package_1050', name: '唯一禮包', points: 3400, bonusTag: '+50%'),
  'points_package_1290': const GameProduct(id: 'points_package_1290', name: '摯愛禮包', points: 4200, bonusTag: '+52%'),
  'points_package_1314': const GameProduct(id: 'points_package_1314', name: '一生一世包', points: 4300, bonusTag: '+53%'),
  'points_package_1930': const GameProduct(id: 'points_package_1930', name: '誓約禮包', points: 6400, bonusTag: '+55%'),
  'points_package_2990': const GameProduct(id: 'points_package_2990', name: '永恆戀人包', points: 10000, bonusTag: '+60%'),
  // 月卡 (訂閱商品)
  'monthly_subscription_star_contract': GameProduct(id: 'monthly_subscription_star_contract', name: appL10n.subscription_star_contract_name, points: 250),
};

/// 多語系商品清單：商店 UI 應改用此函式，依 App 目前語言顯示名稱。
/// 保留 storeProducts getter 供既有程式使用，避免直接破壞其他引用。
/// 商品 ID、點數、優惠標籤及月卡既有翻譯均不改動。
Map<String, GameProduct> localizedStoreProducts(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final original = storeProducts;
  final names = <String, String>{
    'points_package_30': l10n.store_pack_30_name1,
    'points_package_70': l10n.store_pack_70_name1,
    'points_package_120': l10n.store_pack_120_name1,
    'points_package_190': l10n.store_pack_190_name1,
    'points_package_250': l10n.store_pack_250_name1,
    'points_package_330': l10n.store_pack_330_name1,
    'points_package_450': l10n.store_pack_450_name1,
    'points_package_520': l10n.store_pack_520_name1,
    'points_package_690': l10n.store_pack_690_name1,
    'points_package_720': l10n.store_pack_720_name1,
    'points_package_750': l10n.store_pack_750_name1,
    'points_package_830': l10n.store_pack_830_name1,
    'points_package_990': l10n.store_pack_990_name1,
    'points_package_1050': l10n.store_pack_1050_name1,
    'points_package_1290': l10n.store_pack_1290_name1,
    'points_package_1314': l10n.store_pack_1314_name1,
    'points_package_1930': l10n.store_pack_1930_name1,
    'points_package_2990': l10n.store_pack_2990_name1,
  };
  return original.map((id, product) => MapEntry(
    id,
    GameProduct(
      id: product.id,
      name: names[id] ?? product.name,
      points: product.points,
      bonusTag: product.bonusTag,
    ),
  ));
}

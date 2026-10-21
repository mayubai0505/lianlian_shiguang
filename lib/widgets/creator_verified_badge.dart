import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 全 App 共用的官方合作創作者認證徽章。
///
/// 個人主頁若已在監聽 users/{uid}，可直接傳入 verified，避免重複訂閱；
/// 其他顯示發文者／留言者的頁面則傳入該作者的 userId。
class CreatorVerifiedBadge extends StatelessWidget {
  static const String assetPath =
      'assets/images/creator/creator_verified_badge.png';

  final String? userId;
  final bool? verified;
  final double size;

  const CreatorVerifiedBadge({
    super.key,
    this.userId,
    this.verified,
    this.size = 20,
  }) : assert(userId != null || verified != null);

  /// 與合作創作者工作室的權限條件一致；目前不要求簽署合約。
  static bool isVerifiedCreator(Map<String, dynamic> data) =>
      data['creatorStatus'] == 'approved' &&
      data['creatorVerified'] == true &&
      data['creatorDashboardEnabled'] == true;

  Widget _badge() => Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticLabel: '官方認證創作者',
      );

  @override
  Widget build(BuildContext context) {
    if (verified != null) {
      return verified! ? _badge() : const SizedBox.shrink();
    }

    final uid = userId?.trim() ?? '';
    if (uid.isEmpty) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        if (snapshot.hasError || data == null || !isVerifiedCreator(data)) {
          return const SizedBox.shrink();
        }
        return _badge();
      },
    );
  }
}

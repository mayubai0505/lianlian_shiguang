import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatorProgramPage extends StatefulWidget {
  const CreatorProgramPage({super.key});

  @override
  State<CreatorProgramPage> createState() => _CreatorProgramPageState();
}

class _CreatorProgramPageState extends State<CreatorProgramPage> {
  final _reasonController = TextEditingController();
  final _directionController = TextEditingController();
  final _socialController = TextEditingController();
  bool _submitting = false;

  FirebaseFunctions get _functions =>
      FirebaseFunctions.instanceFor(region: 'asia-east1');

  @override
  void dispose() {
    _reasonController.dispose();
    _directionController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (_submitting) return;

    final reason = _reasonController.text.trim();
    final direction = _directionController.text.trim();
    final socialLink = _socialController.text.trim();

    if (reason.isEmpty || direction.isEmpty) {
      _showMessage('請填寫創作方向與申請原因。', isError: true);
      return;
    }

    setState(() => _submitting = true);

    try {
      final callable = _functions.httpsCallable('submitCreatorApplication');
      await callable.call({
        'reason': reason,
        'direction': direction,
        'socialLink': socialLink,
      });

      if (!mounted) return;
      _showMessage('申請已送出，審核約需 1～3 天。');
      setState(() {});
    } on FirebaseFunctionsException catch (e) {
      if (!mounted) return;
      _showMessage(e.message ?? '申請送出失敗，請稍後再試。', isError: true);
    } catch (_) {
      if (!mounted) return;
      _showMessage('申請送出失敗，請稍後再試。', isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('請先登入後再申請創作者計畫。')),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '創作者計畫',
          style: GoogleFonts.notoSerifTc(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() ?? <String, dynamic>{};
          final status = data['creatorStatus']?.toString().trim() ?? 'none';
          final statusReason =
              data['creatorStatusReason']?.toString().trim() ?? '';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '讓創作被更多人看見',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '只要你有公開創作，就歡迎申請加入《戀戀拾光》創作者計畫。申請送出後，官方會在 1～3 天內完成審核。',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 13.5,
                        height: 1.7,
                        color: onSurface.withValues(alpha: 0.68),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _buildBenefitsCard(theme),
              const SizedBox(height: 18),
              if (status == 'none' || status == 'rejected')
                _buildApplicationForm(theme, statusReason)
              else
                _buildStatusCard(theme, status, statusReason),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBenefitsCard(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    final benefits = <String>[
      '創作者後台：查看粉絲數、公開角色數、總愛心與本月新增粉絲。',
      '粉絲經營：可寄信、管理粉絲，並用自己的花花贈送粉絲福利。',
      '官方曝光：新角色有機會優先登上 IG 與遊戲內創作者推薦。',
      '每月創作獎勵：當月新增並公開至少 3 隻全新角色，次月可獲 520 朵花花。',
      '實體合作：旗下角色若進入官方實體商品／禮盒合作，可依合作企劃獲得現金創作獎勵。',
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '計畫福利',
            style: GoogleFonts.notoSerifTc(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...benefits.map(
                (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 17, color: primary),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 13,
                        height: 1.55,
                        color: onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm(ThemeData theme, String lastReason) {
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lastReason.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '上次審核說明：$lastReason',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 12.5,
                  height: 1.5,
                  color: onSurface.withValues(alpha: 0.72),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            '申請加入',
            style: GoogleFonts.notoSerifTc(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _directionController,
            maxLength: 120,
            decoration: const InputDecoration(
              labelText: '創作方向',
              hintText: '例如：現代戀愛、古風、奇幻、BL、GL…',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            decoration: const InputDecoration(
              labelText: '想加入創作者計畫的原因',
              hintText: '和我們說說你想怎麼經營自己的角色與粉絲。',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _socialController,
            decoration: const InputDecoration(
              labelText: '社群連結（選填）',
              hintText: 'IG、Threads、個人網站等',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submitApplication,
              icon: _submitting
                  ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.send_rounded),
              label: Text(_submitting ? '送出中…' : '送出申請'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '送出前系統會確認帳號目前至少有 1 隻公開角色。',
            style: GoogleFonts.notoSerifTc(
              fontSize: 11.5,
              color: onSurface.withValues(alpha: 0.46),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      ThemeData theme,
      String status,
      String statusReason,
      ) {
    String title;
    String description;
    IconData icon;

    switch (status) {
      case 'pending':
        title = '申請審核中';
        description = '申請已送達，審核約需 1～3 天。完成後會透過戀戀信箱通知你。';
        icon = Icons.hourglass_top_rounded;
        break;
      case 'approved':
        title = '創作者資格已通過 🎉';
        description = '恭喜加入《戀戀拾光》創作者計畫！創作者後台、粉絲管理與推薦橫幅會在接下來的功能中與這個資格連動。';
        icon = Icons.verified_rounded;
        break;
      case 'suspended':
        title = '創作者資格暫停';
        description = '目前暫時無法使用創作者專屬功能。請查看戀戀信箱中的官方通知。';
        icon = Icons.pause_circle_outline_rounded;
        break;
      case 'revoked':
        title = '創作者資格已取消';
        description = '目前無法使用創作者專屬功能。若有疑問，可透過客服聯繫官方。';
        icon = Icons.person_off_outlined;
        break;
      default:
        title = '創作者資格狀態';
        description = '目前狀態：$status';
        icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              fontSize: 13,
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          if (statusReason.isNotEmpty &&
              (status == 'suspended' || status == 'revoked')) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '官方說明：$statusReason',
                style: GoogleFonts.notoSerifTc(fontSize: 12.5, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

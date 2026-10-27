import '../services/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/toast_utils.dart';
import 'character_edit_page.dart';
import 'world_edit_page.dart';
import 'world_chat_page.dart';
import 'official_creator_studio_page.dart';
import 'package:rxdart/rxdart.dart'; // 🌟 記得這個一定要有！
import 'dart:io'; // 🌟 讀取手機本機檔案必備！
import 'character_model.dart';
import '../utils/image_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_functions/cloud_functions.dart';

// 私人工作室
class CreatorStudioPage extends StatefulWidget {
  const CreatorStudioPage({super.key});

  @override
  State<CreatorStudioPage> createState() => _CreatorStudioPageState();
}

class _CreatorStudioPageState extends State<CreatorStudioPage> {
  int _selectedStudioTab = 0;

  // ✨ 總裁專屬：刪除草稿與清理雲端圖片的邏輯
  Future<void> _deleteDraft(BuildContext context, String docId, String? avatarUrl) async {
    final l10n = AppLocalizations.of(context)!;

    // 1. 彈出確認視窗
    final bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_draft_title),
        content: Text(l10n.confirm_delete_draft_msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm_delete_title, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      // 2. 直接刪除 Firestore 裡的草稿文件
      await FirebaseFirestore.instance
          .collection('draft_characters')
          .doc(docId)
          .delete();

      // ✨ 總裁級：草稿清空後的徹底淨化，用最乾淨的回饋，對應你對資料保全的堅持！
      if (context.mounted) {
        ToastUtils.showCenterToast(
          context,
          l10n.draft_cleared_success,
          customIcon: Icons.layers_clear_rounded, // 💡 總裁精選：象徵「清除圖層/草稿」的完美圖示
        );
      }
      debugPrint("♻️ 草稿文件已移除，雲端圖片已安全留存。");
    } catch (e) {
      if (context.mounted) {
        // 💡 總裁級防護：刪除失敗的緊急警告
        ToastUtils.showCenterToast(
          context,
          l10n.creator_dashboard_error1,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            l10n.login_required_for_studio,
          ),
        ),
      );
    }

    final draftStream = FirebaseFirestore.instance
        .collection('draft_characters')
        .where(
      'createdBy',
      isEqualTo: user.uid,
    )
        .snapshots();

    final privateStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(
      const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'lianlianshiguang',
      ),
    )
        .collection('users')
        .doc(user.uid)
        .collection('private_characters')
        .snapshots();

    final publicStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(
      const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'lianlianshiguang',
      ),
    )
        .collection('public_characters')
        .where(
      'createdBy',
      isEqualTo: user.uid,
    )
        .snapshots();

    final combinedStream = Rx.combineLatest3(
      draftStream,
      privateStream,
      publicStream,
          (
          QuerySnapshot drafts,
          QuerySnapshot privates,
          QuerySnapshot publics,
          ) {
        return {
          'drafts': drafts.docs,
          'privates': privates.docs,
          'publics': publics.docs,
        };
      },
    );

    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: -25,
                  width: 210,
                  child: Opacity(
                    opacity: 0.17,
                    child: Image.asset(
                      'assets/images/studio/studio_top_right.png',
                    ),
                  ),
                ),
                Positioned(
                  left: -25,
                  bottom: -10,
                  width: 215,
                  child: Opacity(
                    opacity: 0.16,
                    child: Image.asset(
                      'assets/images/studio/studio_bottom_left.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 16, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    l10n.my_secret_studio_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSerifTc(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Image.asset(
                                  'assets/images/studio/studio_title_leaf.png',
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.creator_studio_subtitle,
                                maxLines: 1,
                                style: GoogleFonts.notoSerifTc(
                                  color: primary.withValues(alpha: 0.62),
                                  fontSize: 12,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 42),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: _studioTabButton(context, l10n.creator_dashboard_my_characters1, 0, Icons.people_outline_rounded)),
                      const SizedBox(width: 10),
                      Expanded(child: _studioTabButton(context, l10n.creator_dashboard_my_worlds1, 1, Icons.public_rounded)),
                    ],
                  ),
                ),
                Expanded(
                  child: _selectedStudioTab == 0
                      ? StreamBuilder<Map<String, List<QueryDocumentSnapshot>>>(
                    stream: combinedStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            l10n.creator_dashboard_error1,
                          ),
                        );
                      }

                      final data = snapshot.data ??
                          {
                            'drafts': <QueryDocumentSnapshot>[],
                            'privates': <QueryDocumentSnapshot>[],
                            'publics': <QueryDocumentSnapshot>[],
                          };

                      final drafts =
                          data['drafts'] ?? <QueryDocumentSnapshot>[];

                      final privates =
                          data['privates'] ?? <QueryDocumentSnapshot>[];

                      final publics =
                          data['publics'] ?? <QueryDocumentSnapshot>[];

                      return ListView(
                        physics:
                        const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          12,
                          18,
                          64,
                        ),
                        children: [
                          // 玩家可由此申請創作者後台，通過審核後進入專區。
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
                            builder: (context, creatorSnapshot) {
                              if (creatorSnapshot.hasError) {
                                return Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(l10n.creator_dashboard_error1));
                              }
                              if (!creatorSnapshot.hasData || !creatorSnapshot.data!.exists) {
                                return const SizedBox.shrink();
                              }
                              final creatorData = creatorSnapshot.data!.data() ?? <String, dynamic>{};
                              final verified = creatorData['creatorStatus'] == 'approved' &&
                                  creatorData['creatorVerified'] == true &&
                                  creatorData['creatorDashboardEnabled'] == true;
                              final status = (creatorData['creatorStatus'] ?? 'none').toString();
                              final int revocationCount = (creatorData['creatorRevocationCount'] is num)
                                  ? (creatorData['creatorRevocationCount'] as num).toInt()
                                  : (status == 'revoked' ? 1 : 0);
                              final rawRevokedAt = creatorData['creatorRevokedAt'] ?? creatorData['creatorStatusUpdatedAt'];
                              final DateTime? revokedAt = rawRevokedAt is Timestamp ? rawRevokedAt.toDate() : null;
                              final DateTime? reapplyAt = revokedAt?.add(const Duration(days: 3));
                              final bool permanentlyBlocked = false; // TEST ONLY: 暫不執行正式五次封鎖
                              final bool withinNoticePeriod = status == 'revoked' &&
                                  (reapplyAt == null || DateTime.now().isBefore(reapplyAt));
                              // TEST ONLY: allow submitting during the 3-day notice period.
                              // Restore !withinNoticePeriod here when enabling production cooldown.
                              final bool canReapplyRevoked = status == 'revoked' && !permanentlyBlocked;
                              final String reapplyDate = reapplyAt == null ? '' :
                              '${reapplyAt.year}/${reapplyAt.month.toString().padLeft(2, '0')}/${reapplyAt.day.toString().padLeft(2, '0')} '
                                  '${reapplyAt.hour.toString().padLeft(2, '0')}:${reapplyAt.minute.toString().padLeft(2, '0')}';
                              final String title = verified
                                  ? l10n.creator_dashboard_access_title1
                                  : (status == 'revoked' && withinNoticePeriod)
                                  ? l10n.creator_dashboard_status_notice_title1
                                  : l10n.creator_dashboard_apply_title1;
                              final String subtitle = verified ? l10n.creator_dashboard_access_subtitle1 :
                              switch (status) {
                                'pending' => l10n.creator_dashboard_pending1,
                                'contract_pending' => l10n.creator_dashboard_legacy_pending1,
                                'approved' => l10n.creator_dashboard_syncing1,
                                'suspended' => l10n.creator_dashboard_suspended1,
                                'revoked' => permanentlyBlocked
                                    ? l10n.creator_dashboard_revoked_limit1
                                    : withinNoticePeriod
                                    ? l10n.creator_dashboard_revoked_notice1
                                    : l10n.creator_dashboard_apply_subtitle1,
                                'rejected' => l10n.creator_dashboard_rejected1,
                                _ => l10n.creator_dashboard_apply_subtitle1,
                              };
                              final canApply = status == 'none' || status.isEmpty ||
                                  status == 'rejected' || canReapplyRevoked;
                              final benefits = !verified && canApply &&
                                  !(status == 'revoked' && withinNoticePeriod);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  color: primary.withValues(alpha: 0.07),
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: verified
                                        ? () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => const OfficialCreatorStudioPage()))
                                        : canApply
                                        ? () async {
                                      final submitted = await Navigator.of(context).push<bool>(
                                        MaterialPageRoute(
                                          builder: (_) => const _CreatorCooperationApplicationPage(),
                                        ),
                                      );

                                      if (!context.mounted || submitted != true) return;

                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (!context.mounted) return;

                                        ToastUtils.showCenterToast(
                                          context,
                                          l10n.creator_dashboard_submitted1,
                                          customIcon: Icons.check_circle_outline_rounded,
                                        );
                                      });
                                    }
                                        : () => showDialog<void>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(title),
                                        content: Text(subtitle),
                                        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.common_got_it))],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                      child: Row(children: [
                                        Icon(verified ? Icons.verified_outlined : Icons.workspace_premium_outlined,
                                            color: primary, size: 30),
                                        const SizedBox(width: 12),
                                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text(title, style: GoogleFonts.notoSerifTc(
                                              fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface, fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text(subtitle, style: TextStyle(fontSize: 12,
                                              color: theme.colorScheme.onSurface.withValues(alpha: 0.65))),
                                          if (benefits) ...[
                                            const SizedBox(height: 12),
                                            Text(l10n.creator_dashboard_benefits_title1, style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 8),
                                            Text(l10n.creator_dashboard_benefit_monthly1, style: const TextStyle(fontSize: 12, height: 1.6)),
                                            Text(l10n.creator_dashboard_benefit_analytics1, style: const TextStyle(fontSize: 12, height: 1.6)),
                                            Text(l10n.creator_dashboard_benefit_mail1, style: const TextStyle(fontSize: 12, height: 1.6)),
                                            Text(l10n.creator_dashboard_benefit_gifts1, style: const TextStyle(fontSize: 12, height: 1.6)),
                                            const SizedBox(height: 7),
                                            Text(l10n.creator_dashboard_reward_note1,
                                                style: TextStyle(fontSize: 11, height: 1.5, color: theme.colorScheme.onSurfaceVariant)),
                                            const SizedBox(height: 8),
                                            Text(l10n.creator_dashboard_apply_cta1, style: TextStyle(fontSize: 12, color: primary, fontWeight: FontWeight.w600)),
                                          ],
                                        ])),
                                        Icon(Icons.chevron_right_rounded, color: primary),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const CharacterEditPage(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add_rounded,
                                size: 21,
                              ),
                              label: Text(
                                l10n.creator_studio_add_character,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primary,
                                backgroundColor: theme.colorScheme.surface
                                    .withValues(alpha: 0.78),
                                side: BorderSide(
                                  color: primary.withValues(alpha: 0.32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 17,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          _buildStudioSection(
                            context: context,
                            theme: theme,
                            title: l10n.creator_studio_public_title,
                            subtitle: l10n.creator_studio_public_subtitle,
                            assetPath: 'assets/images/studio/studio_public.png',
                            count: publics.length,
                            emptyText: l10n.creator_studio_public_empty,
                            documents: publics,
                            status: 'public',
                          ),

                          const SizedBox(height: 28),

                          _buildStudioSection(
                            context: context,
                            theme: theme,
                            title: l10n.creator_studio_private_title,
                            subtitle: l10n.creator_studio_private_subtitle,
                            assetPath: 'assets/images/studio/studio_private.png',
                            count: privates.length,
                            emptyText: l10n.creator_studio_private_empty,
                            documents: privates,
                            status: 'private',
                          ),

                          const SizedBox(height: 28),

                          _buildStudioSection(
                            context: context,
                            theme: theme,
                            title: l10n.creator_studio_draft_title,
                            subtitle: l10n.creator_studio_draft_subtitle,
                            assetPath: 'assets/images/studio/studio_draft_quill.png',
                            count: drafts.length,
                            emptyText: l10n.creator_studio_draft_empty,
                            documents: drafts,
                            status: 'draft',
                          ),
                        ],
                      );
                    },
                  )
                      : _buildWorldStudio(context, theme, user.uid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _studioTabButton(BuildContext context, String label, int index, IconData icon) {
    final selected = _selectedStudioTab == index;
    final theme = Theme.of(context);
    return Material(
      color: selected ? theme.colorScheme.primary.withValues(alpha: 0.12) : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => setState(() => _selectedStudioTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: selected ? 0.48 : 0.18)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, size: 17, color: theme.colorScheme.primary),
            const SizedBox(width: 5),
            Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSerifTc(fontSize: 14, fontWeight: selected ? FontWeight.bold : FontWeight.w500))),
          ]),
        ),
      ),
    );
  }

  Widget _buildWorldStudio(BuildContext context, ThemeData theme, String uid) {
    // 依照 WorldEditPage 實際使用的兩個資料位置，避免與角色資料混用。
    final worldStream = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('worlds')
        .where('createdBy', isEqualTo: uid)
        .snapshots();
    final draftStream = FirebaseFirestore.instance
        .collection('draft_worlds')
        .where('createdBy', isEqualTo: uid)
        .snapshots();
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<Map<String, List<QueryDocumentSnapshot>>>(
      stream: Rx.combineLatest2(worldStream, draftStream,
              (QuerySnapshot worlds, QuerySnapshot drafts) => {
            'worlds': worlds.docs,
            'drafts': drafts.docs,
          }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.creator_dashboard_error1),
          ));
        }
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final worlds = snapshot.data!['worlds'] ?? <QueryDocumentSnapshot>[];
        final drafts = snapshot.data!['drafts'] ?? <QueryDocumentSnapshot>[];
        final publicWorlds = worlds.where((d) {
          final data = d.data() as Map<String, dynamic>;
          return data['status'] == 'public' || data['isPublic'] == true;
        }).toList();
        final privateWorlds = worlds.where((d) {
          final data = d.data() as Map<String, dynamic>;
          return data['status'] != 'public' && data['isPublic'] != true;
        }).toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 64),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const WorldEditPage(),
                )),
                icon: const Icon(Icons.add_rounded),
                label: Text(AppLocalizations.of(context)!.creator_dashboard_create_world1),
              ),
            ),
            const SizedBox(height: 18),
            _worldSection(context, theme, AppLocalizations.of(context)!.creator_dashboard_public_worlds1, AppLocalizations.of(context)!.creator_dashboard_public_worlds_hint1,
                Icons.public_rounded, publicWorlds, 'public'),
            const SizedBox(height: 24),
            _worldSection(context, theme, AppLocalizations.of(context)!.creator_dashboard_private_worlds1, AppLocalizations.of(context)!.creator_dashboard_private_worlds_hint1,
                Icons.lock_outline_rounded, privateWorlds, 'private'),
            const SizedBox(height: 24),
            _worldSection(context, theme, AppLocalizations.of(context)!.creator_dashboard_world_drafts1, AppLocalizations.of(context)!.creator_dashboard_world_drafts_hint1,
                Icons.edit_note_rounded, drafts, 'draft'),
          ],
        );
      },
    );
  }

  Widget _worldSection(BuildContext context, ThemeData theme, String title,
      String subtitle, IconData icon, List<QueryDocumentSnapshot> docs, String status) {
    final primary = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: 0.17)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 34, color: primary),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.notoSerifTc(fontSize: 20, fontWeight: FontWeight.w600)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          ])),
          Text('${docs.length}', style: GoogleFonts.notoSerifTc(fontSize: 17, color: primary)),
        ]),
        const SizedBox(height: 14),
        if (docs.isEmpty)
          Padding(padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text(status == 'draft' ? AppLocalizations.of(context)!.creator_dashboard_no_drafts1 : AppLocalizations.of(context)!.creator_dashboard_no_worlds1,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant))))
        else
          ...docs.map((doc) => _worldCard(context, theme, doc, status)),
      ]),
    );
  }

  Widget _worldCard(BuildContext context, ThemeData theme,
      QueryDocumentSnapshot doc, String status) {
    final data = doc.data() as Map<String, dynamic>;
    final name = (data['name'] ?? '').toString().trim();
    final cover = (data['coverImage'] ?? '').toString();
    final statusText = status == 'draft' ? AppLocalizations.of(context)!.creator_studio_status_draft : status == 'public' ? AppLocalizations.of(context)!.creator_studio_status_public : AppLocalizations.of(context)!.creator_studio_status_private;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(width: 60, height: 60,
              child: cover.startsWith('https://')
                  ? Image.network(cover, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.landscape_outlined))
                  : const Icon(Icons.landscape_outlined, size: 32)),
        ),
        title: Text(name.isEmpty ? AppLocalizations.of(context)!.creator_dashboard_unnamed_world1 : name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(statusText),
        trailing: status == 'draft'
            ? IconButton(
          tooltip: AppLocalizations.of(context)!.creator_dashboard_delete_world_draft1,
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          onPressed: () => _deleteWorldDraft(context, doc.id),
        )
            : status == 'private'
            ? IconButton(
          tooltip: AppLocalizations.of(context)!.creator_dashboard_private_test1,
          icon: Icon(Icons.play_circle_outline_rounded,
              color: theme.colorScheme.primary, size: 29),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => WorldChatPage(worldId: doc.id))),
        )
            : const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => status == 'draft'
              ? WorldEditPage(draftId: doc.id)
              : WorldEditPage(worldId: doc.id),
        )),
      ),
    );
  }

  Future<void> _deleteWorldDraft(BuildContext context, String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.creator_dashboard_delete_world_confirm_title1),
        content: Text(AppLocalizations.of(context)!.creator_dashboard_delete_world_confirm_body1),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.cancelButton)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.delete_btn)),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final ref = FirebaseFirestore.instance.collection('draft_worlds').doc(id);
      final current = await ref.get();
      if (!current.exists || current.data()?['createdBy'] != user.uid) {
        throw StateError('找不到自己的草稿');
      }
      await ref.delete();
      if (context.mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.creator_dashboard_draft_deleted1);
    } catch (e) {
      if (context.mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.creator_dashboard_error1, isError: true);
    }
  }

  Widget _buildStudioSection({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String subtitle,
    required String assetPath,
    required int count,
    required String emptyText,
    required List<QueryDocumentSnapshot> documents,
    required String status,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: 0.17)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                assetPath,
                width: status == 'draft' ? 48 : 58,
                height: status == 'draft' ? 48 : 58,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        color: primary.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.035),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primary.withValues(alpha: 0.18)),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (documents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 28,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.58),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: primary.withValues(alpha: 0.11),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    status == 'draft' ? l10n.creator_studio_draft_empty_title : emptyText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 15,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                    ),
                  ),
                  if (status == 'draft') ...[
                    const SizedBox(height: 7),
                    Text(
                      l10n.creator_studio_draft_empty_hint,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        color: primary.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            ...documents.map(
                  (doc) => _buildStudioCharacterCard(
                context: context,
                theme: theme,
                doc: doc,
                status: status,
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildStudioCharacterCard({
    required BuildContext context,
    required ThemeData theme,
    required QueryDocumentSnapshot doc,
    required String status,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final data =
    doc.data() as Map<String, dynamic>;

    final String characterName =
    (data['name'] ?? l10n.unnamed_draft)
        .toString();

    final String avatarPath =
    (data['avatarPath'] ?? '').toString();

    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'public':
        statusText = l10n.creator_studio_status_public;
        statusIcon = Icons.public_rounded;
        break;

      case 'private':
        statusText = l10n.creator_studio_status_private;
        statusIcon = Icons.lock_outline_rounded;
        break;

      case 'draft':
      default:
        statusText = l10n.creator_studio_status_draft;
        statusIcon = Icons.edit_note_rounded;
    }

    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      elevation: 0,
      color: theme.colorScheme.surface
          .withValues(alpha: 0.82),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          if (status == 'draft') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CharacterEditPage(
                  draftDoc: doc,
                ),
              ),
            );

            return;
          }

          try {
            final character =
            await Character.fromFirestoreAsync(doc);

            if (!context.mounted) return;

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CharacterEditPage(
                  character: character,
                ),
              ),
            );
          } catch (e) {
            debugPrint(
              '❌ 工作室角色開啟失敗：$e',
            );

            if (!context.mounted) return;

            ToastUtils.showCenterToast(
              context,
              l10n.creator_studio_character_load_failed,
              isError: true,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: Image(
                    image: getAvatarImageProvider(
                      avatarPath.isNotEmpty
                          ? avatarPath
                          : 'assets/images/avatar1.png',
                    ),
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.08),
                        child: Icon(
                          Icons.person_rounded,
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.4),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      characterName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.055),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: 14,
                            color: theme
                                .colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12,
                              color: theme.colorScheme.primary.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (status == 'draft')
                IconButton(
                  tooltip: l10n.creator_studio_delete_draft_tooltip,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    _deleteDraft(
                      context,
                      doc.id,
                      avatarPath,
                    );
                  },
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.35),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorIntroductionCard(
      BuildContext context,
      ThemeData theme, {
        required String nickname,
        required String bio,
        required String avatarPath,
      }) {
    final l10n = AppLocalizations.of(context)!;
    ImageProvider? avatarProvider;

    if (avatarPath.startsWith('http://') ||
        avatarPath.startsWith('https://')) {
      avatarProvider =
          NetworkImage(avatarPath);
    } else if (avatarPath.startsWith('assets/')) {
      avatarProvider =
          AssetImage(avatarPath);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      color: theme.colorScheme.primary
          .withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.primary
              .withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
              theme.colorScheme.primary
                  .withValues(alpha: 0.12),
              backgroundImage: avatarProvider,
              child: avatarProvider == null
                  ? Icon(
                Icons.person_rounded,
                color:
                theme.colorScheme.primary,
              )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname.isEmpty
                        ? l10n.creator_studio_unnamed_creator
                        : nickname,
                    style: TextStyle(
                      color:
                      theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bio.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      bio,
                      style: TextStyle(
                        color: theme
                            .colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.creator_studio_no_bio,
                      style: TextStyle(
                        color: theme
                            .colorScheme.onSurface
                            .withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🏷️ 輔助小元件：草稿標籤
  Widget _buildDraftBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(l10n.label_draft, style: const TextStyle(color: Colors.orange, fontSize: 12)),
    );
  }

  // 🌟 新增：私人與公開的標籤 UI
  Widget _buildPrivateBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child:  Text(l10n.private, style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildPublicBadge(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(l10n.status_published, style: const TextStyle(color: Colors.green, fontSize: 12)),
    );
  }

  // 🎨 輔助小元件：空空如也的狀態
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.brush, size: 80, color: theme.colorScheme.primary.withValues(alpha:0.3)),
          const SizedBox(height: 16),
          Text(l10n.studio_empty_title, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(l10n.studio_empty_subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// 創作者後台申請表：只有 Cloud Function 可以將申請狀態設為 pending。
class _CreatorCooperationApplicationPage extends StatefulWidget {
  const _CreatorCooperationApplicationPage();
  @override
  State<_CreatorCooperationApplicationPage> createState() => _CreatorCooperationApplicationPageState();
}

class _CreatorCooperationApplicationPageState extends State<_CreatorCooperationApplicationPage> {
  final _directionController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _directionController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final direction = _directionController.text.trim();
    final reason = _reasonController.text.trim();
    if (direction.length < 2 || direction.length > 100 || reason.length < 10 || reason.length > 500) {
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.creator_dashboard_validation1, isError: true);
      return;
    }
    final accepted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.creator_dashboard_confirm_application_title1),
        content: Text(AppLocalizations.of(context)!.creator_dashboard_confirm_application_body1),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.cancelButton)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.creator_dashboard_confirm_send1)),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    setState(() => _submitting = true);
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'asia-east1')
          .httpsCallable('submitCreatorCooperationApplication',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 30)))
          .call({'creatorDirection': direction, 'creatorApplicationReason': reason});
      if (!mounted) return;
      final success = result.data is Map && result.data['success'] == true;
      if (!success) throw StateError('申請結果未確認');

      Navigator.of(context).pop(true);
    } on FirebaseFunctionsException catch (e) {
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.creator_dashboard_error1, isError: true);
    } catch (e) {
      if (mounted) ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.creator_dashboard_error1, isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.creator_dashboard_apply_title1, style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w600))),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(AppLocalizations.of(context)!.creator_dashboard_form_heading1, style: GoogleFonts.notoSerifTc(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.creator_dashboard_form_description1,
              style: TextStyle(height: 1.7, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 22),
          TextField(controller: _directionController, maxLength: 100, enabled: !_submitting,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.creator_dashboard_direction_label1, hintText: AppLocalizations.of(context)!.creator_dashboard_direction_hint1, border: const OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _reasonController, maxLength: 500, enabled: !_submitting,
              minLines: 5, maxLines: 8,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.creator_dashboard_reason_label1, hintText: AppLocalizations.of(context)!.creator_dashboard_reason_hint1, border: const OutlineInputBorder())),
          const SizedBox(height: 8),
          FilledButton.icon(onPressed: _submitting ? null : _submit,
              icon: _submitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_outlined),
              label: Text(_submitting ? AppLocalizations.of(context)!.creator_dashboard_sending1 : AppLocalizations.of(context)!.creator_dashboard_submit1)),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.creator_dashboard_privacy_note1,
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
        ],
      )),
    );
  }
}
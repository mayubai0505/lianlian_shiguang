import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    final reason = _reasonController.text.trim();
    final direction = _directionController.text.trim();
    final socialLink = _socialController.text.trim();

    if (reason.isEmpty || direction.isEmpty) {
      _showMessage(l10n.creator_program_required_fields, isError: true);
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
      _showMessage(l10n.creator_program_submitted);
      setState(() {});
    } on FirebaseFunctionsException catch (e) {
      debugPrint('創作者申請失敗：${e.code} ${e.message}');
      if (!mounted) return;
      _showMessage(l10n.creator_program_error, isError: true);
    } catch (e) {
      debugPrint('創作者申請失敗：$e');
      if (!mounted) return;
      _showMessage(l10n.creator_program_error, isError: true);
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
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text(l10n.creator_program_login_required)),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.creator_program_title,
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
                      l10n.creator_program_headline,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.creator_program_intro,
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

    final l10n = AppLocalizations.of(context)!;
    final benefits = <String>[
      l10n.creator_program_benefit_dashboard,
      l10n.creator_program_benefit_fans,
      l10n.creator_program_benefit_exposure,
      l10n.creator_program_benefit_monthly,
      l10n.creator_program_benefit_merch,
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
            l10n.creator_program_benefits_title,
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
              child: Text(
                text,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13,
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.72),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm(ThemeData theme, String lastReason) {
    final onSurface = theme.colorScheme.onSurface;
    final l10n = AppLocalizations.of(context)!;

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
                l10n.creator_program_last_review_note(lastReason),
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
            l10n.creator_program_apply_heading,
            style: GoogleFonts.notoSerifTc(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _directionController,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: l10n.creator_program_direction_label,
              hintText: l10n.creator_program_direction_hint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            decoration: InputDecoration(
              labelText: l10n.creator_program_reason_label,
              hintText: l10n.creator_program_reason_hint,
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _socialController,
            decoration: InputDecoration(
              labelText: l10n.creator_program_social_label,
              hintText: l10n.creator_program_social_hint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submitApplication,
              child: _submitting
                  ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(l10n.creator_program_submit),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.creator_program_public_character_note,
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
    final l10n = AppLocalizations.of(context)!;
    String title;
    String description;

    switch (status) {
      case 'pending':
        title = l10n.creator_program_status_pending;
        description = l10n.creator_program_status_pending_desc;
        break;
      case 'approved':
        title = l10n.creator_program_status_approved;
        description = l10n.creator_program_status_approved_desc;
        break;
      case 'suspended':
        title = l10n.creator_program_status_suspended;
        description = l10n.creator_program_status_suspended_desc;
        break;
      case 'revoked':
        title = l10n.creator_program_status_revoked;
        description = l10n.creator_program_status_revoked_desc;
        break;
      default:
        title = l10n.creator_program_status_title;
        description = l10n.creator_program_current_status(status);
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
                l10n.creator_program_official_note(statusReason),
                style: GoogleFonts.notoSerifTc(fontSize: 12.5, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
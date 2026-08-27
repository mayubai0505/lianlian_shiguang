import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';

class HiddenMomentsPage extends StatelessWidget {
  const HiddenMomentsPage({super.key});

  static const String _emptyIllustrationAsset =
      'assets/images/echo/echo_hidden_empty_base.png';

  Future<void> _unhideMoment(
      BuildContext context,
      String uid,
      String momentId,
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.colorScheme.primary;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          l10n.unhide_moment_title,
          style: GoogleFonts.notoSerifTc(
            color: onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          l10n.unhide_moment_content,
          style: GoogleFonts.notoSerifTc(
            color: onSurface.withValues(alpha: 0.62),
            fontSize: 13.5,
            height: 1.7,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.notoSerifTc(
                color: onSurface.withValues(alpha: 0.52),
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.unhide_moment_action,
              style: GoogleFonts.notoSerifTc(
                color: primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('hiddenMoments')
        .doc(momentId)
        .delete();

    if (!context.mounted) return;

    ToastUtils.success(
      context,
      l10n.unhide_moment_success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onSurface = colorScheme.onSurface;

    if (uid == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Text(
            l10n.please_login_first,
            style: GoogleFonts.notoSerifTc(
              color: onSurface.withValues(alpha: 0.56),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: onSurface.withValues(alpha: 0.82),
            size: 23,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.hidden_moments_title,
          style: GoogleFonts.notoSerifTc(
            color: onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('hiddenMoments')
            .orderBy('hiddenAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  l10n.hidden_moments_load_failed,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    color: onSurface.withValues(alpha: 0.52),
                    fontSize: 13.5,
                    height: 1.7,
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: primary.withValues(alpha: 0.62),
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return _buildEmptyState(
              context,
              l10n.hidden_moments_empty,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final String momentId = doc.id;

              final String authorName =
              data['authorName']?.toString().trim().isNotEmpty == true
                  ? data['authorName'].toString()
                  : l10n.hidden_moment_unknown_author;

              final String authorAvatar =
                  data['authorAvatar']?.toString().trim() ?? '';

              final String content =
              data['content']?.toString().trim().isNotEmpty == true
                  ? data['content'].toString()
                  : l10n.hidden_moment_no_preview;

              final String? imageUrl =
              data['imageUrl']?.toString().trim();

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.12),
                    width: 0.9,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.045),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor:
                          primary.withValues(alpha: 0.08),
                          backgroundImage: authorAvatar.isNotEmpty
                              ? _getAvatarImageProvider(authorAvatar)
                              : null,
                          child: authorAvatar.isEmpty
                              ? Icon(
                            Icons.person_outline_rounded,
                            color: primary.withValues(alpha: 0.62),
                            size: 21,
                          )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            authorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifTc(
                              color: onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primary,
                            side: BorderSide(
                              color: primary.withValues(alpha: 0.38),
                            ),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 8,
                            ),
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () => _unhideMoment(
                            context,
                            uid,
                            momentId,
                          ),
                          child: Text(
                            l10n.unhide_moment_action,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: onSurface.withValues(alpha: 0.72),
                        fontSize: 14,
                        height: 1.75,
                      ),
                    ),
                    if (imageUrl != null && imageUrl.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          imageUrl,
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 130,
                              alignment: Alignment.center,
                              color:
                              onSurface.withValues(alpha: 0.035),
                              child: Icon(
                                Icons.broken_image_outlined,
                                color:
                                onSurface.withValues(alpha: 0.28),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context,
      String title,
      ) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Align(
      alignment: const Alignment(0, -0.12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: Image.asset(
                _emptyIllustrationAsset,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                color: onSurface.withValues(alpha: 0.78),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '暫時還沒有被隱藏的動態喔',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                color: onSurface.withValues(alpha: 0.40),
                fontSize: 12.5,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getAvatarImageProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }
}
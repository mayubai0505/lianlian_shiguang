import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';

class HiddenMomentsPage extends StatelessWidget {
  const HiddenMomentsPage({super.key});

  Future<void> _unhideMoment(
      BuildContext context,
      String uid,
      String momentId,
      ) async {
    final l10n = AppLocalizations.of(context)!;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unhide_moment_title),
        content: Text(l10n.unhide_moment_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.unhide_moment_action),
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
    final colorScheme = Theme.of(context).colorScheme;

    if (uid == null) {
      return Scaffold(
        body: Center(child: Text(l10n.please_login_first)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hidden_moments_title),
        centerTitle: true,
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
            return Center(child: Text(l10n.hidden_moments_load_failed));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.visibility_off_outlined,
                    size: 60,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.hidden_moments_empty,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  data['authorAvatar']?.toString() ?? '';

              final String content =
              data['content']?.toString().trim().isNotEmpty == true
                  ? data['content'].toString()
                  : l10n.hidden_moment_no_preview;

              final String? imageUrl = data['imageUrl']?.toString();

              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colorScheme.surfaceVariant,
                            backgroundImage: authorAvatar.isNotEmpty
                                ? _getAvatarImageProvider(authorAvatar)
                                : null,
                            child: authorAvatar.isEmpty
                                ? const Icon(Icons.person_outline)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _unhideMoment(
                              context,
                              uid,
                              momentId,
                            ),
                            child: Text(l10n.unhide_moment_action),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        content,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (imageUrl != null && imageUrl.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                alignment: Alignment.center,
                                color: colorScheme.surfaceVariant,
                                child: const Icon(Icons.broken_image_outlined),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  ImageProvider _getAvatarImageProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }
}
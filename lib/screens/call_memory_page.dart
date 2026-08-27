import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'call_memory_detail_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// 點進耳機後會看到的十筆收藏通話
class CallMemoryPage extends StatelessWidget {
  const CallMemoryPage({Key? key}) : super(key: key);

  // 如果你的花草實際路徑不同，只需要改這一行。
  static const String _cornerBotanicalAsset =
      'assets/images/chat/chat_side_menu_corner_floral_mask.png';

  String _formatMemoryDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return '';
    final dt = timestamp.toDate();
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$mm/$dd · $hh:$min';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          l10n.call_memory_title,
          style: GoogleFonts.notoSerifTc(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: onSurface,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 右上角淡淡的水彩花草，只做背景點綴，不搶內容。
          Positioned(
            top: -18,
            right: -26,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.14,
                child: Image.asset(
                  _cornerBotanicalAsset,
                  width: 190,
                  fit: BoxFit.contain,
                  color: primary,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: user == null
                ? Center(
              child: Text(
                l10n.please_login_first,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 14,
                  color: onSurface.withValues(alpha: 0.58),
                ),
              ),
            )
                : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('call_memories')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: primary,
                      strokeWidth: 2,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState(
                    context,
                    l10n: l10n,
                    theme: theme,
                  );
                }

                final memories = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
                  itemCount: memories.length,
                  itemBuilder: (context, index) {
                    final data =
                    memories[index].data() as Map<String, dynamic>;
                    final name =
                        data['characterName'] ?? l10n.unknown_contact;
                    final duration = data['duration'] ?? 0;
                    final avatarUrl =
                        data['characterAvatar']?.toString() ?? '';
                    final dateText =
                    _formatMemoryDate(data['timestamp']);

                    final minutesStr = (duration / 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    final secondsStr = (duration % 60)
                        .toString()
                        .padLeft(2, '0');
                    final timeString = '$minutesStr:$secondsStr';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface
                            .withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.14),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: onSurface.withValues(alpha: 0.045),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CallMemoryDetailPage(memoryData: data),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              14, 14, 10, 14),
                          child: Row(
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                padding: const EdgeInsets.all(1.2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                    primary.withValues(alpha: 0.20),
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: theme.colorScheme
                                      .surfaceContainerHighest,
                                  backgroundImage: avatarUrl.isNotEmpty
                                      ? CachedNetworkImageProvider(avatarUrl)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.call_with_name(name),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: onSurface,
                                      ),
                                    ),
                                    if (dateText.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        dateText,
                                        style: GoogleFonts.notoSerifTc(
                                          fontSize: 11.5,
                                          color: onSurface.withValues(
                                              alpha: 0.48),
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.call_duration(timeString),
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 12,
                                        color: onSurface.withValues(
                                            alpha: 0.58),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                    primary.withValues(alpha: 0.35),
                                  ),
                                  color: primary.withValues(alpha: 0.035),
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 22,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(width: 3),
                              IconButton(
                                tooltip: l10n.confirm_delete,
                                onPressed: () {
                                  _showDeleteConfirmDialog(
                                    context,
                                    memories[index].id,
                                    name,
                                    user.uid,
                                  );
                                },
                                icon: Image.asset(
                                  'assets/images/chat/chat_msg_delete_mask.png',
                                  width: 23,
                                  height: 23,
                                  color: Colors.redAccent,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, {
        required AppLocalizations l10n,
        required ThemeData theme,
      }) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(36, 40, 36, 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 118,
              height: 118,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.045),
              ),
              child: Image.asset(
                'assets/images/chat/chat_header_headphones.png',
                width: 68,
                height: 68,
                color: primary.withValues(alpha: 0.55),
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              l10n.no_call_memories,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 16,
                height: 1.75,
                fontWeight: FontWeight.w500,
                color: onSurface.withValues(alpha: 0.78),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🗑️ 第一層：安全鎖確認視窗
void _showDeleteConfirmDialog(
    BuildContext context, String docId, String name, String uid) {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(
        l10n.delete_call_title,
        style: GoogleFonts.notoSerifTc(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        l10n.delete_call_confirm(name),
        style: GoogleFonts.notoSerifTc(fontSize: 14, height: 1.6),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.keep_it,
            style: GoogleFonts.notoSerifTc(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            _deleteMemoryInCloud(uid, docId);
            Navigator.pop(context);
          },
          child: Text(
            l10n.confirm_delete,
            style: GoogleFonts.notoSerifTc(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
}

// ☁️ 第二層：後台秘密刪除邏輯
Future<void> _deleteMemoryInCloud(String uid, String docId) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('call_memories')
        .doc(docId)
        .delete();

    debugPrint("🤫 ID: $docId 的通話回憶已在背景秘密銷毀");
  } catch (e) {
    debugPrint("❌ 銷毀失敗: $e");
  }
}
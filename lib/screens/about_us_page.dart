//關於我們
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';
import 'add_shared_memory_page.dart';
import 'edit_shared_memory_page.dart';

class SharedMemory {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final DateTime timestamp;

  SharedMemory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.timestamp,
  });

  factory SharedMemory.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SharedMemory(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      content: data['content'] ?? '',
      timestamp:
      (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class AboutUsPage extends StatefulWidget {
  final String currentUserId;
  final String characterId;

  const AboutUsPage({
    super.key,
    required this.currentUserId,
    required this.characterId,
  });

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  List<SharedMemory> _memories = [];
  bool _isLoading = true;

  CollectionReference get _memoriesRef {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .collection('characters')
        .doc(widget.characterId)
        .collection('shared_memories');
  }

  @override
  void initState() {
    super.initState();
    _fetchMemories();
  }

  Future<void> _fetchMemories() async {
    try {
      final snapshot =
      await _memoriesRef.orderBy('timestamp', descending: true).get();

      if (!mounted) return;

      setState(() {
        _memories = snapshot.docs
            .map((doc) => SharedMemory.fromDocument(doc))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('讀取回憶失敗: $e');

      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openAddMemoryPage() async {
    final l10n = AppLocalizations.of(context)!;

    if (_memories.length >= 10) {
      ToastUtils.showCenterToast(
        context,
        l10n.about_us_limit_error,
      );
      return;
    }

    final bool? added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddSharedMemoryPage(
          currentUserId: widget.currentUserId,
          characterId: widget.characterId,
        ),
      ),
    );

    if (added != true || !mounted) return;

    await _fetchMemories();

    if (!mounted) return;
    ToastUtils.showCenterToast(
      context,
      l10n.about_us_add_button,
    );
  }

  Future<void> _deleteMemory(
      String memoryId,
      AppLocalizations l10n,
      ) async {
    try {
      await _memoriesRef.doc(memoryId).delete();
      await _fetchMemories();

      if (mounted) {
        Navigator.pop(context);
        ToastUtils.showCenterToast(
          context,
          l10n.about_us_delete_success,
        );
      }
    } catch (e) {
      debugPrint('刪除回憶失敗: $e');
    }
  }

  Future<void> _updateMemoryInFirebase(
      String memoryId,
      String title,
      String subtitle,
      String content,
      ) async {
    try {
      await _memoriesRef.doc(memoryId).update({
        'title': title.trim(),
        'subtitle': subtitle.trim(),
        'content': content.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final l10n = AppLocalizations.of(context)!;
      await _fetchMemories();

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.common_update_success,
      );
    } catch (e) {
      debugPrint('修改回憶失敗: $e');

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ToastUtils.showCenterToast(
        context,
        l10n.common_update_failed_try_again,
        isError: true,
      );
    }
  }

  void _showMemoryDetail(
      SharedMemory memory,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final currentTitle = memory.title;
    final currentSubtitle = memory.subtitle;
    final currentContent = memory.content;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, _) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (currentSubtitle.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                currentSubtitle,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 14,
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.about_us_edit_title,
                        onPressed: () async {
                          // 先關閉詳細內容 BottomSheet，再進獨立編輯頁。
                          Navigator.pop(bottomSheetContext);

                          final bool? updated =
                          await Navigator.push<bool>(
                            this.context,
                            MaterialPageRoute(
                              builder: (_) => EditSharedMemoryPage(
                                currentUserId: widget.currentUserId,
                                characterId: widget.characterId,
                                memoryId: memory.id,
                                initialTitle: currentTitle,
                                initialSubtitle: currentSubtitle,
                                initialContent: currentContent,
                              ),
                            ),
                          );

                          if (updated == true && mounted) {
                            await _fetchMemories();
                          }
                        },
                        icon: Image.asset(
                          'assets/images/chat/chat_msg_edit_mask.png',
                          width: 32,
                          height: 32,
                          color: primary,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/chat/chat_msg_delete_mask.png',
                          width: 32,
                          height: 32,
                          color: Colors.redAccent,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                        tooltip: l10n.about_us_delete_tooltip,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                l10n.about_us_delete_title,
                                style: GoogleFonts.notoSerifTc(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: Text(
                                l10n.about_us_delete_confirm,
                                style: GoogleFonts.notoSerifTc(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child: Text(l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteMemory(
                                      memory.id,
                                      l10n,
                                    );
                                  },
                                  child: Text(
                                    l10n.action_confirm_delete,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                        ),
                        onPressed: () =>
                            Navigator.pop(bottomSheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: primary.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        currentContent,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15.5,
                          height: 1.85,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.82),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          l10n.chat_menu_aboutus,
          style: GoogleFonts.notoSerifTc(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.about_us_add_title,
            icon: Icon(
              Icons.add_rounded,
              color: primary,
              size: 28,
            ),
            onPressed: _openAddMemoryPage,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: -18,
            bottom: -14,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.10,
                child: Image.asset(
                  'assets/images/contact/contact_bottom_left_botanical.png',
                  width: 175,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primary,
            ),
          )
              : _memories.isEmpty
              ? _buildEmptyState(l10n)
              : _buildMemoriesList(l10n),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 62,
              color: primary.withValues(alpha: 0.20),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.about_us_empty_hint,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 15,
                height: 1.6,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoriesList(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 36),
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        final memory = _memories[index];

        String displayContent = memory.content;
        if (displayContent.length > 40) {
          displayContent =
          '${displayContent.substring(0, 40)}...';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface
                .withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary.withValues(alpha: 0.11),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showMemoryDetail(memory, l10n),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: onSurface.withValues(alpha: 0.90),
                    ),
                  ),
                  if (memory.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      memory.subtitle,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 13,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    displayContent,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 14.5,
                      height: 1.65,
                      color: onSurface.withValues(alpha: 0.58),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

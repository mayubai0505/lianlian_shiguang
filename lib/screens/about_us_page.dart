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

  Future<bool> _deleteMemory(
      String memoryId,
      AppLocalizations l10n,
      ) async {
    try {
      await _memoriesRef.doc(memoryId).delete();
      await _fetchMemories();

      if (!mounted) return true;

      ToastUtils.showCenterToast(
        context,
        l10n.about_us_delete_success,
      );
      return true;
    } catch (e) {
      debugPrint('刪除回憶失敗: $e');
      return false;
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

  Future<void> _showMemoryDetail(
      SharedMemory memory,
      AppLocalizations l10n,
      ) async {
    final bool? changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => _SharedMemoryDetailPage(
          currentUserId: widget.currentUserId,
          characterId: widget.characterId,
          memory: memory,
          onDelete: () => _deleteMemory(
            memory.id,
            l10n,
          ),
        ),
      ),
    );

    if (changed == true && mounted) {
      await _fetchMemories();
    }
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

class _SharedMemoryDetailPage extends StatefulWidget {
  final String currentUserId;
  final String characterId;
  final SharedMemory memory;
  final Future<bool> Function() onDelete;

  const _SharedMemoryDetailPage({
    required this.currentUserId,
    required this.characterId,
    required this.memory,
    required this.onDelete,
  });

  @override
  State<_SharedMemoryDetailPage> createState() =>
      _SharedMemoryDetailPageState();
}

class _SharedMemoryDetailPageState extends State<_SharedMemoryDetailPage> {
  late String _title;
  late String _subtitle;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.memory.title;
    _subtitle = widget.memory.subtitle;
    _content = widget.memory.content;
  }

  Future<void> _openEditPage() async {
    final bool? updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditSharedMemoryPage(
          currentUserId: widget.currentUserId,
          characterId: widget.characterId,
          memoryId: widget.memory.id,
          initialTitle: _title,
          initialSubtitle: _subtitle,
          initialContent: _content,
        ),
      ),
    );

    if (updated == true && mounted) {
      // 編輯頁已完成 Firebase 更新；回到清單重新抓最新資料，
      // 避免在詳情頁顯示舊文字。
      Navigator.pop(context, true);
    }
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.action_confirm_delete,
              style: GoogleFonts.notoSerifTc(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final bool deleted = await widget.onDelete();
    if (!mounted) return;

    if (deleted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          _title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.notoSerifTc(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.about_us_edit_title,
            onPressed: _openEditPage,
            icon: Image.asset(
              'assets/images/chat/chat_msg_edit_mask.png',
              width: 30,
              height: 30,
              color: primary,
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
          IconButton(
            tooltip: l10n.about_us_delete_tooltip,
            onPressed: _confirmDelete,
            icon: Image.asset(
              'assets/images/chat/chat_msg_delete_mask.png',
              width: 30,
              height: 30,
              color: Colors.redAccent,
              colorBlendMode: BlendMode.srcIn,
            ),
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
                opacity: 0.08,
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
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: onSurface.withValues(alpha: 0.92),
                      height: 1.35,
                    ),
                  ),
                  if (_subtitle.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _subtitle,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primary,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Divider(
                    color: primary.withValues(alpha: 0.12),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _content,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 15.5,
                      height: 1.9,
                      color: onSurface.withValues(alpha: 0.82),
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
}
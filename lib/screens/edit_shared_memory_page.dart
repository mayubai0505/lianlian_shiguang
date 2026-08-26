//編輯關於我們

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';

class EditSharedMemoryPage extends StatefulWidget {
  final String currentUserId;
  final String characterId;
  final String memoryId;
  final String initialTitle;
  final String initialSubtitle;
  final String initialContent;

  const EditSharedMemoryPage({
    super.key,
    required this.currentUserId,
    required this.characterId,
    required this.memoryId,
    required this.initialTitle,
    required this.initialSubtitle,
    required this.initialContent,
  });

  @override
  State<EditSharedMemoryPage> createState() =>
      _EditSharedMemoryPageState();
}

class _EditSharedMemoryPageState extends State<EditSharedMemoryPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _contentController;

  bool _isSaving = false;

  DocumentReference get _memoryRef {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .collection('characters')
        .doc(widget.characterId)
        .collection('shared_memories')
        .doc(widget.memoryId);
  }

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialTitle);
    _subtitleController =
        TextEditingController(text: widget.initialSubtitle);
    _contentController =
        TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    final subtitle = _subtitleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.lore_empty_error,
      );
      return;
    }

    // 沒有更動也直接回上一頁，不多做 Firestore write。
    final hasChanged =
        title != widget.initialTitle.trim() ||
            subtitle != widget.initialSubtitle.trim() ||
            content != widget.initialContent.trim();

    if (!hasChanged) {
      Navigator.pop(context, false);
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _memoryRef.update({
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.common_update_success,
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('修改回憶失敗: $e');

      if (!mounted) return;
      setState(() => _isSaving = false);

      ToastUtils.showCenterToast(
        context,
        l10n.common_update_failed_try_again,
        isError: true,
      );
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
          l10n.about_us_edit_title,
          style: GoogleFonts.notoSerifTc(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: -18,
            bottom: -14,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
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
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(
                    l10n.about_us_field_title,
                    onSurface,
                  ),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _titleController,
                    hintText: l10n.about_us_hint_title,
                    maxLength: 20,
                    primary: primary,
                  ),
                  const SizedBox(height: 18),
                  _buildLabel(
                    l10n.about_us_field_subtitle,
                    onSurface,
                  ),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _subtitleController,
                    hintText: l10n.about_us_hint_subtitle,
                    maxLength: 10,
                    primary: primary,
                  ),
                  const SizedBox(height: 18),
                  _buildLabel(
                    l10n.about_us_field_content,
                    onSurface,
                  ),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _contentController,
                    hintText: l10n.about_us_hint_content,
                    maxLength: 500,
                    minLines: 8,
                    maxLines: 12,
                    primary: primary,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        l10n.about_us_edit_confirm,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
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

  Widget _buildLabel(
      String text,
      Color onSurface,
      ) {
    return Text(
      text,
      style: GoogleFonts.notoSerifTc(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: onSurface.withValues(alpha: 0.65),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hintText,
    required int maxLength,
    required Color primary,
    int minLines = 1,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      style: GoogleFonts.notoSerifTc(
        fontSize: 15,
        height: 1.55,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.notoSerifTc(
          color: theme.colorScheme.onSurface
              .withValues(alpha: 0.32),
        ),
        filled: true,
        fillColor:
        theme.colorScheme.surface.withValues(alpha: 0.96),
        counterStyle: GoogleFonts.notoSerifTc(
          fontSize: 11.5,
          color: theme.colorScheme.onSurface
              .withValues(alpha: 0.38),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: primary.withValues(alpha: 0.13),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: primary.withValues(alpha: 0.55),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
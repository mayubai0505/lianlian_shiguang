import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//劇場編輯
class CreatorSceneEditPage extends StatefulWidget {
  final String characterName;
  final DocumentReference<Map<String, dynamic>> characterRef;
  final DocumentSnapshot<Map<String, dynamic>>? sceneDoc;

  const CreatorSceneEditPage({
    super.key,
    required this.characterName,
    required this.characterRef,
    this.sceneDoc,
  });

  bool get isEditing => sceneDoc != null;

  @override
  State<CreatorSceneEditPage> createState() => _CreatorSceneEditPageState();
}

class _CreatorSceneEditPageState extends State<CreatorSceneEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _openingController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final data = widget.sceneDoc?.data() ?? const <String, dynamic>{};

    _titleController = TextEditingController(
      text: (data['title'] ?? '').toString(),
    );
    _descriptionController = TextEditingController(
      text: (data['description'] ?? '').toString(),
    );
    _openingController = TextEditingController(
      text: (data['opening'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _openingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final opening = _openingController.text.trim();

    if (title.isEmpty) {
      _showMessage('請先填寫劇場標題。');
      return;
    }

    if (description.isEmpty) {
      _showMessage('請先填寫場景說明。');
      return;
    }

    if (opening.isEmpty) {
      _showMessage('請先填寫角色開場。');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.isEditing) {
        await widget.sceneDoc!.reference.set(
          {
            'title': title,
            'description': description,
            'opening': opening,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      } else {
        await widget.characterRef.collection('scenes').add({
          'title': title,
          'description': description,
          'opening': opening,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showMessage('儲存失敗，請稍後再試。');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.notoSerifTc(),
          ),
        ),
      );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required ThemeData theme,
  }) {
    final primary = theme.colorScheme.primary;

    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.notoSerifTc(
        fontSize: 13,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.34),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface.withValues(alpha: 0.98),
      contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: primary.withValues(alpha: 0.48),
          width: 1.2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }

  Widget _buildField({
    required ThemeData theme,
    required String label,
    required String hint,
    required TextEditingController controller,
    int minLines = 1,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSerifTc(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          style: GoogleFonts.notoSerifTc(
            fontSize: 14,
            height: 1.6,
          ),
          decoration: _inputDecoration(
            hintText: hint,
            theme: theme,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text(
          widget.isEditing ? '編輯劇場' : '新增劇場',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.characterName,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.isEditing ? '調整這段故事的入口' : '寫下一個新的故事入口',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 26),
              _buildField(
                theme: theme,
                label: '劇場標題',
                hint: '例如：雨夜重逢',
                controller: _titleController,
                maxLength: 30,
              ),
              const SizedBox(height: 18),
              _buildField(
                theme: theme,
                label: '場景說明',
                hint: '描述故事發生的時間、地點、關係與情境。',
                controller: _descriptionController,
                minLines: 6,
                maxLines: 10,
                maxLength: 1200,
              ),
              const SizedBox(height: 18),
              _buildField(
                theme: theme,
                label: '角色開場',
                hint: '寫下角色進入這段劇情時的第一個反應或第一句話。',
                controller: _openingController,
                minLines: 5,
                maxLines: 9,
                maxLength: 1000,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.055),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '角色開場會作為這段劇場的第一幕；後續對話仍會以角色原本人設為核心繼續。',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12,
                    height: 1.6,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                      : Text(
                    widget.isEditing ? '儲存修改' : '儲存劇場',
                    style: GoogleFonts.notoSerifTc(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

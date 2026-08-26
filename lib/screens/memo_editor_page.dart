//編輯備忘錄

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class MemoEditorResult {
  final String content;
  final DateTime reminderDate;

  const MemoEditorResult({
    required this.content,
    required this.reminderDate,
  });
}

class MemoEditorPage extends StatefulWidget {
  final String characterName;
  final String initialContent;
  final DateTime initialReminderDate;
  final bool isEditing;

  const MemoEditorPage({
    super.key,
    required this.characterName,
    required this.initialContent,
    required this.initialReminderDate,
    required this.isEditing,
  });

  @override
  State<MemoEditorPage> createState() => _MemoEditorPageState();
}

class _MemoEditorPageState extends State<MemoEditorPage> {
  late final TextEditingController _contentController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _contentController =
        TextEditingController(text: widget.initialContent);
    _selectedDate = widget.initialReminderDate;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(DateTime.now())
          ? DateTime.now()
          : _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.memo_error_empty_content),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      MemoEditorResult(
        content: content,
        reminderDate: _selectedDate,
      ),
    );
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
          widget.isEditing
              ? l10n.memo_edit_title
              : l10n.memo_add_title,
          style: GoogleFonts.notoSerifTc(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              l10n.memo_action_save,
              style: GoogleFonts.notoSerifTc(
                color: primary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            right: -22,
            bottom: -16,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  'assets/images/chat/chat_tool_floral_right_bottom_mask.png',
                  width: 185,
                  fit: BoxFit.contain,
                  color: primary,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (_, __, ___) =>
                  const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing
                            ? l10n.memo_edit_title
                            : l10n.memo_add_title,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: onSurface.withValues(alpha: 0.68),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contentController,
                        maxLines: 5,
                        minLines: 3,
                        maxLength: 300,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15,
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText:
                          l10n.memo_hint_text(widget.characterName),
                          hintStyle: GoogleFonts.notoSerifTc(
                            color: onSurface.withValues(alpha: 0.32),
                          ),
                          border: InputBorder.none,
                          counterStyle: GoogleFonts.notoSerifTc(
                            fontSize: 11.5,
                            color: onSurface.withValues(alpha: 0.36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.memo_label_reminder_date,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: onSurface.withValues(alpha: 0.68),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _pickDateTime,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  DateFormat('yyyy/MM/dd HH:mm')
                                      .format(_selectedDate),
                                  style: GoogleFonts.notoSerifTc(
                                    fontSize: 14.5,
                                    color: onSurface.withValues(
                                      alpha: 0.76,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: onSurface.withValues(alpha: 0.38),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

/// 建立／編輯秘密篇章的獨立頁面。
/// 此頁只回傳編輯結果；資料會由 WorldEditPage 的「儲存草稿／發布」
/// 流程寫入 root/world_secrets/{worldId}，避免覆蓋其他世界資料。
class WorldSecretChapterEditorPage extends StatefulWidget {
  const WorldSecretChapterEditorPage({super.key, this.original = const {}});

  final Map<String, String> original;

  @override
  State<WorldSecretChapterEditorPage> createState() =>
      _WorldSecretChapterEditorPageState();
}

class _WorldSecretChapterEditorPageState
    extends State<WorldSecretChapterEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _condition;
  late final TextEditingController _content;

  bool get _isEditing => (widget.original['id'] ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.original['title'] ?? '');
    _condition = TextEditingController(text: widget.original['condition'] ?? '');
    _content = TextEditingController(text: widget.original['content'] ?? '');
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final id = (widget.original['id'] ?? '').trim();
    Navigator.of(context).pop(<String, String>{
      'id': id.isNotEmpty
          ? id
          : DateTime.now().microsecondsSinceEpoch.toString(),
      'title': _title.text.trim(),
      'condition': _condition.text.trim(),
      'content': _content.text.trim(),
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _condition.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String? requiredText(String? value) =>
        value == null || value.trim().isEmpty ? '此欄位不可留白' : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing
            ? l10n.world_edit_edit_secret1
            : l10n.world_edit_add_secret1),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 26),
                  children: [
                    Text(
                      l10n.world_edit_secret_explain1,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _title,
                      maxLength: 80,
                      textInputAction: TextInputAction.next,
                      validator: requiredText,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.world_edit_chapter_title1,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _condition,
                      maxLength: 500,
                      minLines: 3,
                      maxLines: 6,
                      textInputAction: TextInputAction.newline,
                      validator: requiredText,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.world_edit_unlock_condition1,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _content,
                      maxLength: 5000,
                      minLines: 8,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: requiredText,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.world_edit_secret_content1,
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(l10n.world_edit_confirm1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

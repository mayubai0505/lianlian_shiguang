import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


class WorldAboutUsPage extends StatefulWidget {
  const WorldAboutUsPage({super.key, required this.worldId, required this.sessionId});
  final String worldId;
  final String sessionId;

  @override
  State<WorldAboutUsPage> createState() => _WorldAboutUsPageState();
}

class _WorldAboutUsPageState extends State<WorldAboutUsPage> {
  CollectionReference<Map<String, dynamic>>? _collection;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _collection = FirebaseFirestore.instance
          .collection('users').doc(uid)
          .collection('worlds').doc(widget.worldId)
          .collection('sessions').doc(widget.sessionId)
          .collection('shared_memories');
    }
  }

  void _notice(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // 新增／編輯使用獨立路由；控制器由編輯頁自己管理，
  // 避免 Dialog 關閉動畫仍使用 TextField 時先 dispose 導致紅屏。
  Future<void> _edit({String? id, String current = ''}) async {
    final collection = _collection;
    if (collection == null || _saving) return;
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => _WorldSharedMemoryEditorPage(
          collection: collection,
          memoryId: id,
          initialText: current,
        ),
      ),
    );
    if (!mounted) return;
    if (saved == true) {
      _notice(AppLocalizations.of(context)!.worldAboutUsSaved);
    }
  }

  Future<void> _delete(String id) async {
    final collection = _collection;
    final l10n = AppLocalizations.of(context)!;
    if (collection == null || _saving) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.worldAboutUsDeleteConfirmTitle),
        content: Text(l10n.worldAboutUsDeleteConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(l10n.worldAboutUsCancel)),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(l10n.worldAboutUsDelete)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await collection.doc(id).update({
        'active': false,
        'deletedByUser': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _notice(l10n.worldAboutUsDeleted);
    } on FirebaseException catch (error) {
      _notice(l10n.worldAboutUsDeleteFailed(error.message ?? error.code));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final collection = _collection;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.worldAboutUsTitle, style: GoogleFonts.notoSerifTc())),
      floatingActionButton: collection == null ? null : FloatingActionButton.extended(
        onPressed: _saving ? null : () => _edit(),
        icon: const Icon(Icons.add),
        label: Text(l10n.worldAboutUsAddMemory),
      ),
      body: collection == null
          ? Center(child: Text(l10n.worldAboutUsSignInRequired))
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  l10n.worldAboutUsDescription,
                  style: GoogleFonts.notoSerifTc(fontSize: 12.5, height: 1.5,
                    color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
              Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: collection.orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Padding(padding: const EdgeInsets.all(20),
                      child: Text(l10n.worldAboutUsLoadFailed(snapshot.error.toString()))));
                  }
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs.where((doc) {
                    final data = doc.data();
                    return data['active'] != false && data['deletedByUser'] != true &&
                        (data['content'] ?? '').toString().trim().isNotEmpty;
                  }).toList();
                  if (docs.isEmpty) return Center(child: Text(l10n.worldAboutUsEmpty));
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final content = (doc.data()['content'] ?? '').toString();
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 8, 10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(content, style: GoogleFonts.notoSerifTc(fontSize: 14, height: 1.6)),
                            Align(alignment: Alignment.centerRight, child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(tooltip: l10n.worldAboutUsEditTooltip, onPressed: _saving ? null : () => _edit(id: doc.id, current: content),
                                  icon: const Icon(Icons.edit_outlined)),
                                IconButton(tooltip: l10n.worldAboutUsDeleteTooltip, onPressed: _saving ? null : () => _delete(doc.id),
                                  icon: const Icon(Icons.delete_outline)),
                              ],
                            )),
                          ]),
                        ),
                      );
                    },
                  );
                },
              )),
            ]),
    );
  }
}

// 單獨的全頁面新增／編輯畫面；不使用彈窗輸入。
class _WorldSharedMemoryEditorPage extends StatefulWidget {
  const _WorldSharedMemoryEditorPage({
    required this.collection,
    required this.initialText,
    this.memoryId,
  });

  final CollectionReference<Map<String, dynamic>> collection;
  final String? memoryId;
  final String initialText;

  @override
  State<_WorldSharedMemoryEditorPage> createState() =>
      _WorldSharedMemoryEditorPageState();
}

class _WorldSharedMemoryEditorPageState
    extends State<_WorldSharedMemoryEditorPage> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final value = _controller.text.trim();
    if (value.isEmpty || value.runes.length > 500) return;
    if (widget.memoryId != null && value == widget.initialText.trim()) {
      Navigator.of(context).pop(false);
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      if (widget.memoryId == null) {
        await widget.collection.add({
          'content': value,
          'active': true,
          'lockedByUser': true,
          'timestamp': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await widget.collection.doc(widget.memoryId).update({
          'content': value,
          'active': true,
          'lockedByUser': true,
          'embedding': FieldValue.delete(),
          'embeddingVersion': FieldValue.delete(),
          'embeddingContent': FieldValue.delete(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      if (mounted) Navigator.of(context).pop(true);
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.worldAboutUsSaveFailed(error.message ?? error.code) +
              l10n.worldAboutUsSavePermissionHint),
        ));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.worldAboutUsSaveFailed(error.toString())),
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.memoryId != null;
    final isEmpty = _controller.text.trim().isEmpty;
    final unchanged = isEditing &&
        _controller.text.trim() == widget.initialText.trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.worldAboutUsEditSharedMemory
              : l10n.worldAboutUsAddSharedMemory,
          style: GoogleFonts.notoSerifTc(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.worldAboutUsCancel,
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
        ),
        actions: [
          TextButton(
            onPressed: _saving || isEmpty || unchanged ? null : _save,
            child: _saving
                ? const SizedBox(width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.worldAboutUsSave),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.worldAboutUsDescription,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  maxLength: 500,
                  readOnly: _saving,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: l10n.worldAboutUsMemoryHint,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(16),
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

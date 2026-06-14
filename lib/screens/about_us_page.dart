import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


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
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
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
  final Color themeColor = const Color(0xFF7BD1FF);

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
      final snapshot = await _memoriesRef
          .orderBy('timestamp', descending: true)
          .get();

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

  Future<void> _addMemoryToFirebase(
      String title,
      String subtitle,
      String content,
      ) async {
    try {
      await _memoriesRef.add({
        'title': title.trim(),
        'subtitle': subtitle.trim(),
        'content': content.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _fetchMemories();
    } catch (e) {
      debugPrint('新增回憶失敗: $e');
    }
  }

  Future<void> _deleteMemory(String memoryId, AppLocalizations l10n) async {
    try {
      await _memoriesRef.doc(memoryId).delete();
      _fetchMemories();
      if (mounted) Navigator.pop(context); // 關閉閱讀視窗
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.about_us_delete_success)), // ✨ 多國語言化
      );
    } catch (e) {
      debugPrint('刪除回憶失敗: $e');
    }
  }

  void _showAddMemoryDialog(AppLocalizations l10n) {
    if (_memories.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.about_us_limit_error)), // ✨ 多國語言化
      );
      return;
    }
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subtitleController = TextEditingController();
    final TextEditingController controllerContent = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.favorite, color: themeColor),
              const SizedBox(width: 8),
              Text(l10n.about_us_add_title, style: const TextStyle(fontWeight: FontWeight.bold)), // ✨ 多國語言化
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: l10n.about_us_field_title, // ✨ 多國語言化
                    hintText: l10n.about_us_hint_title, // ✨ 多國語言化
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor)),
                  ),
                ),
                TextField(
                  controller: subtitleController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: l10n.about_us_field_subtitle, // ✨ 多國語言化
                    hintText: l10n.about_us_hint_subtitle, // ✨ 多國語言化
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColor)),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerContent,
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: l10n.about_us_field_content, // ✨ 多國語言化
                    hintText: l10n.about_us_hint_content, // ✨ 多國語言化
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: themeColor)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                final subtitle = subtitleController.text.trim();
                final content = controllerContent.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.lore_empty_error)),
                  );
                  return;
                }

                _addMemoryToFirebase(
                  title,
                  subtitle,
                  content,
                );

                Navigator.pop(context);
              },
              child: Text(l10n.about_us_add_button, style: const TextStyle(fontWeight: FontWeight.bold)), // ✨ 多國語言化
            ),
          ],
        );
      },
    );
  }

  void _showMemoryDetail(SharedMemory memory, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
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
                          memory.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        if (memory.subtitle.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            memory.subtitle,
                            style: TextStyle(fontSize: 15, color: themeColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    tooltip: l10n.about_us_delete_tooltip, // ✨ 多國語言化
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.about_us_delete_title), // ✨ 多國語言化
                          content: Text(l10n.about_us_delete_confirm), // ✨ 多國語言化
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _deleteMemory(memory.id, l10n);
                              },
                              child: Text(l10n.action_confirm_delete, style: const TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 32, thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    memory.content,
                    style: const TextStyle(fontSize: 16, height: 1.8, color: Colors.black87, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ✨ 在最前面宣告一次，傳遞給下方使用

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.chat_menu_aboutus, style: const TextStyle(fontWeight: FontWeight.bold)), // ✨ 多國語言化
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_rounded, color: themeColor, size: 28),
            onPressed: () => _showAddMemoryDialog(l10n), // ✨ 傳入 l10n
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: themeColor))
          : _memories.isEmpty
          ? _buildEmptyState(l10n) // ✨ 傳入 l10n
          : _buildMemoriesList(l10n), // ✨ 傳入 l10n
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drafts_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              l10n.about_us_empty_hint, // ✨ 多國語言化
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[500], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoriesList(AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        final memory = _memories[index];
        String displayContent = memory.content;
        if (displayContent.length > 20) {
          displayContent = '${displayContent.substring(0, 20)}...';
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () => _showMemoryDetail(memory, l10n), // ✨ 傳入 l10n
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(memory.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  if (memory.subtitle.isNotEmpty)
                    Text(memory.subtitle, style: TextStyle(fontSize: 13, color: themeColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(displayContent, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_constants.dart';
import '../services/toast_utils.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'world_secret_chapter_editor_page.dart';

/// 獨立世界觀編輯器。與 CharacterEditPage / public_characters 完全分開。
///
/// 備註：正式接入 App 前，須為 worlds、draft_worlds 及 Storage world_images
/// 加上正確的擁有者／公開讀取規則；世界觀聊天室及 AI 串接不在本檔範圍。
class WorldEditPage extends StatefulWidget {
  const WorldEditPage({super.key, this.worldId, this.draftId});

  /// 編輯已建立的世界觀。
  final String? worldId;

  /// 從草稿繼續編輯。
  final String? draftId;

  @override
  State<WorldEditPage> createState() => _WorldEditPageState();
}

class _WorldEditPageState extends State<WorldEditPage>
    with SingleTickerProviderStateMixin {
  static const int maxImages = 6;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late final TabController _tabs;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _setting = TextEditingController();
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _shortPitch = TextEditingController();
  final TextEditingController _era = TextEditingController();
  final TextEditingController _tags = TextEditingController();
  final TextEditingController _lore = TextEditingController();
  static const _suggestedTags = <String>[
    '懸疑', '恐怖', '戀愛', '現代奇幻', '校園', '群像', '冒險', '日常', '推理', '異世界',
  ];
  final TextEditingController _opening = TextEditingController();
  final TextEditingController _firstLine = TextEditingController();

  final List<_WorldImage> _images = [];
  final List<_WorldNpc> _npcs = [];
  final List<Map<String, String>> _secretChapters = [];
  bool _secretReadFailed = false;
  bool _isPublic = false; // 預設私人試玩
  bool _busy = false;
  bool _loading = true;
  bool _leaving = false;
  String? _worldId;
  String? _draftId;

  CollectionReference<Map<String, dynamic>> get _worlds => _db
      .collection('artifacts')
      .doc(AppConfig.appId)
      .collection('worlds');
  CollectionReference<Map<String, dynamic>> get _drafts =>
      _db.collection('draft_worlds');

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _worldId = widget.worldId;
    _draftId = widget.draftId;
    _load();
  }

  Future<void> _load() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError(AppLocalizations.of(context)!.world_edit_login_required1);
      DocumentSnapshot<Map<String, dynamic>>? doc;
      if (_worldId != null) doc = await _worlds.doc(_worldId).get();
      if (_draftId != null) doc = await _drafts.doc(_draftId).get();
      if (doc != null && doc.exists) {
        final data = doc.data()!;
        if (data['createdBy'] != user.uid) throw StateError(AppLocalizations.of(context)!.world_edit_no_edit_permission1);
        _name.text = data['name']?.toString() ?? '';
        _setting.text = data['worldSetting']?.toString() ?? '';
        _summary.text = data['summary']?.toString() ?? '';
        _shortPitch.text = (data['shortPitch'] ?? '').toString();
        _era.text = data['era']?.toString() ?? '';
        final savedTags = data['tags'];
        _tags.text = savedTags is List ? savedTags.map((e) => e.toString()).join('、') : '';
        _lore.text = data['worldLore']?.toString() ?? '';
        _opening.text = data['storyOpening']?.toString() ?? '';
        _firstLine.text = data['firstLine']?.toString() ?? '';
        _isPublic = data['isPublic'] == true;
        final secretId = _worldId ?? _draftId;
        if (secretId != null) {
          try {
            final secretDoc = await _db.collection('world_secrets').doc(secretId).get();
            if (secretDoc.exists) {
              final entries = secretDoc.data()?['chapters'];
              if (entries is List) {
                for (final item in entries) {
                  if (item is Map) {
                    _secretChapters.add({
                      'id': (item['id'] ?? '').toString(),
                      'title': (item['title'] ?? '').toString(),
                      'condition': (item['condition'] ?? '').toString(),
                      'content': (item['content'] ?? '').toString(),
                    });
                  }
                }
              }
            }
          } on FirebaseException catch (e) {
            _secretReadFailed = true;
            debugPrint('世界觀秘密篇章讀取失敗：code=${e.code}, message=${e.message}, worldId=$secretId, uid=${user.uid}');
            _notice(e.code == 'permission-denied'
                ? AppLocalizations.of(context)!.world_edit_secret_permission_error1
                : AppLocalizations.of(context)!.world_edit_secret_read_error_code1(e.code), isError: true);
          } catch (e) {
            _secretReadFailed = true;
            debugPrint('世界觀秘密篇章讀取失敗：$e');
            _notice(AppLocalizations.of(context)!.world_edit_secret_read_error1, isError: true);
          }
        }
        final rawImages = data['images'];
        if (rawImages is List) {
          for (final item in rawImages) {
            if (item is String && item.isNotEmpty) {
              _images.add(_WorldImage(url: item));
            }
          }
        }
        final rawNpcs = data['npcCharacters'];
        if (rawNpcs is List) {
          for (final item in rawNpcs) {
            if (item is Map) _npcs.add(_WorldNpc.fromMap(item));
          }
        }
      }
    } catch (e) {
      if (mounted) _notice(AppLocalizations.of(context)!.world_edit_world_read_error1(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _notice(String value, {bool isError = false}) {
    if (!mounted) return;
    ToastUtils.showCenterToast(context, value, isError: isError);
  }

  Future<void> _pickImages() async {
    if (_busy || _images.length >= maxImages) return;
    try {
      final selected = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1800,
      );
      if (!mounted) return;
      final remaining = maxImages - _images.length;
      setState(() {
        _images.addAll(
          selected.take(remaining).map((file) => _WorldImage(file: file)),
        );
      });
      if (selected.length > remaining) _notice(AppLocalizations.of(context)!.world_edit_image_max1(maxImages));
    } catch (e) {
      _notice(AppLocalizations.of(context)!.world_edit_image_read_error1(e.toString()));
    }
  }

  Future<void> _editNpc({_WorldNpc? oldNpc, int? index, String kind = 'npc'}) async {
    if (_busy) return;
    final edited = await Navigator.push<_WorldNpc>(
      context,
      MaterialPageRoute(
        builder: (_) => _WorldPersonEditor(
          original: oldNpc?.copy() ?? _WorldNpc(kind: kind),
        ),
      ),
    );
    if (!mounted || edited == null) return;
    setState(() {
      if (index == null) {
        _npcs.add(edited);
      } else {
        _npcs[index] = edited;
      }
    });
  }

  Widget _npcAvatar(_WorldNpc npc, {double size = 42}) {
    Widget child = const Icon(Icons.person_outline);
    if (npc.avatarFile != null) {
      child = FutureBuilder<Uint8List>(
        future: npc.avatarFile!.readAsBytes(),
        builder: (context, snap) => snap.hasData
            ? Image.memory(snap.data!, fit: BoxFit.cover)
            : const Icon(Icons.person_outline),
      );
    } else if (npc.avatarUrl.isNotEmpty) {
      child = Image.network(npc.avatarUrl, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person_outline));
    }
    return ClipOval(
      child: SizedBox(width: size, height: size, child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: child,
      )),
    );
  }

  Widget _field(TextEditingController controller, String label,
      {int lines = 1, int? max = 10000}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        minLines: lines,
        maxLines: lines == 1 ? 1 : null,
        maxLength: max,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: lines > 1,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  List<String> get _selectedTags => _tags.text
      .split(RegExp(r'[,，、\n]'))
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toSet()
      .toList();

  String _localizedTag(String tag) {
    final l10n = AppLocalizations.of(context)!;
    switch (tag) {
      case '懸疑': return l10n.world_edit_tag_mystery1;
      case '恐怖': return l10n.world_edit_tag_horror1;
      case '戀愛': return l10n.world_edit_tag_romance1;
      case '現代奇幻': return l10n.world_edit_tag_modern_fantasy1;
      case '校園': return l10n.world_edit_tag_school1;
      case '群像': return l10n.world_edit_tag_ensemble1;
      case '冒險': return l10n.world_edit_tag_adventure1;
      case '日常': return l10n.world_edit_tag_daily1;
      case '推理': return l10n.world_edit_tag_detective1;
      case '異世界': return l10n.world_edit_tag_otherworld1;
      default: return tag;
    }
  }

  Widget _tagPicker() {
    final chosen = _selectedTags;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppLocalizations.of(context)!.world_edit_tag_heading1),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 4, children: [
        for (final tag in _suggestedTags)
          FilterChip(
            label: Text(_localizedTag(tag)), selected: chosen.contains(tag),
            onSelected: _busy ? null : (selected) {
              final next = List<String>.from(_selectedTags);
              if (selected) { next.add(tag); } else { next.remove(tag); }
              setState(() => _tags.text = next.join('、'));
            },
          ),
      ]),
      const SizedBox(height: 8),
      _field(_tags, AppLocalizations.of(context)!.world_edit_tag_custom1, max: null),
    ]);
  }

  /// 一次儲存世界觀與圖像；正式發布需要檢查必填，草稿不需要。
  Future<bool> _save({required bool asDraft}) async {
    if (_busy || _secretReadFailed) {
      if (_secretReadFailed) _notice(AppLocalizations.of(context)!.world_edit_secret_not_ready1);
      return false;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _notice(AppLocalizations.of(context)!.world_edit_login_required1);
      return false;
    }
    if (!asDraft) {
      if (_name.text.trim().isEmpty || _images.isEmpty ||
          _setting.text.trim().isEmpty || _opening.text.trim().isEmpty ||
          _firstLine.text.trim().isEmpty) {
        _notice(AppLocalizations.of(context)!.world_edit_required_publish1);
        return false;
      }
    }
    if (_secretChapters.length > 12 || _secretChapters.any((c) =>
    (c['title'] ?? '').trim().isEmpty ||
        (c['condition'] ?? '').trim().isEmpty ||
        (c['content'] ?? '').trim().isEmpty)) {
      _notice(AppLocalizations.of(context)!.world_edit_secret_validation1);
      return false;
    }
    setState(() => _busy = true);
    try {
      // 同一份草稿發布時沿用 draftId 作 worldId，避免重複建立世界。
      final worldId = _worldId ?? _draftId ?? _worlds.doc().id;
      final urls = <String>[];
      for (var i = 0; i < _images.length; i++) {
        final image = _images[i];
        if (image.file == null) {
          urls.add(image.url);
        } else {
          final ref = _storage.ref(
            'world_images/${user.uid}/$worldId/gallery_${DateTime.now().microsecondsSinceEpoch}_$i.jpg',
          );
          await ref.putData(
            await image.file!.readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'),
          );
          image.url = await ref.getDownloadURL();
          image.file = null;
          urls.add(image.url);
        }
      }
      for (var i = 0; i < _npcs.length; i++) {
        final npc = _npcs[i];
        if (npc.avatarFile == null) continue;
        final ref = _storage.ref(
          'world_images/${user.uid}/$worldId/npc_${DateTime.now().microsecondsSinceEpoch}_$i.jpg',
        );
        await ref.putData(
          await npc.avatarFile!.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        );
        npc.avatarUrl = await ref.getDownloadURL();
        npc.avatarFile = null;
      }
      final data = <String, dynamic>{
        'name': _name.text.trim(),
        'worldSetting': _setting.text.trim(),
        'summary': _summary.text.trim(),
        'shortPitch': _shortPitch.text.trim(),
        'era': _era.text.trim(),
        'tags': _selectedTags,
        'worldLore': _lore.text.trim(),
        'storyOpening': _opening.text.trim(),
        'firstLine': _firstLine.text.trim(),
        'images': urls,
        'coverImage': urls.isNotEmpty ? urls.first : '',
        'npcCharacters': _npcs.map((npc) => npc.toMap()).toList(),
        'isPublic': asDraft ? false : _isPublic,
        'isDraft': asDraft,
        'status': asDraft ? 'draft' : (_isPublic ? 'public' : 'private'),
        'createdBy': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      // 秘密另存 root/world_secrets，絕不放進可公開查詢的 worlds / public_worlds。
      final batch = _db.batch();
      final secretsRef = _db.collection('world_secrets').doc(worldId);
      batch.set(secretsRef, {
        'createdBy': user.uid,
        'chapters': _secretChapters.map((c) => Map<String, String>.from(c)).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (asDraft) {
        _draftId ??= worldId;
        batch.set(_drafts.doc(_draftId), {
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        await batch.commit();
        _notice(AppLocalizations.of(context)!.world_edit_draft_saved1);
      } else {
        batch.set(_worlds.doc(worldId), {
          ...data,
          if (_worldId == null) 'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        await batch.commit();
        _worldId = worldId;
        // 公開資格與公開清單由可信任後端核准與投影，不能讓客戶端直接寫 publicPlayable。
        try {
          final publishResult = await FirebaseFunctions.instanceFor(region: 'asia-east1')
              .httpsCallable('worldPublish')
              .call({'worldId': worldId});
          final published = (publishResult.data is Map)
              ? (publishResult.data as Map)['publicPlayable'] == true
              : false;
          if (_isPublic && !published) {
            throw StateError(AppLocalizations.of(context)!.world_edit_publish_unconfirmed1);
          }
        } on FirebaseFunctionsException catch (e) {
          debugPrint('開放世界發布後端失敗：code=${e.code}, message=${e.message}, worldId=$worldId');
          throw StateError(AppLocalizations.of(context)!.world_edit_publish_backend_error1(e.code, e.message ?? AppLocalizations.of(context)!.world_edit_publish_service_missing1));
        }
        if (_draftId != null) {
          try {
            await _drafts.doc(_draftId).delete();
            _draftId = null;
          } catch (e) {
            debugPrint('草稿清理失敗（世界觀已發布）：$e');
          }
        }
        _notice(_isPublic ? AppLocalizations.of(context)!.world_edit_public_published1 : AppLocalizations.of(context)!.world_edit_private_saved1);
      }
      return true;
    } catch (e) {
      debugPrint('開放世界儲存／發布失敗：$e');
      _notice(AppLocalizations.of(context)!.world_edit_save_publish_failed1(e.toString()), isError: true);
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirmExit() async {
    if (_leaving || _busy) return false;
    // 保持與角色建立頁一致：離開時詢問是否儲存草稿。
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.world_edit_save_draft_question1),
        content: Text(AppLocalizations.of(context)!.world_edit_save_draft_explain1),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: Text(AppLocalizations.of(context)!.world_edit_discard1),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(AppLocalizations.of(context)!.world_edit_cancel1),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: Text(AppLocalizations.of(context)!.world_edit_save_draft1),
          ),
        ],
      ),
    );
    if (choice == 'discard') return true;
    if (choice == 'save') return await _save(asDraft: true);
    return false;
  }

  Future<void> _exit() async {
    if (await _confirmExit() && mounted) {
      _leaving = true;
      Navigator.of(context).pop();
    }
  }

  Widget _basicTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _field(_name, AppLocalizations.of(context)!.world_edit_world_name1, max: 60),
      Text(AppLocalizations.of(context)!.world_edit_world_images1),
      const SizedBox(height: 10),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: _images.length + (_images.length < maxImages ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == _images.length) {
            return InkWell(
              onTap: _pickImages,
              child: const Card(child: Center(child: Icon(Icons.add_photo_alternate_outlined))),
            );
          }
          final img = _images[i];
          return Stack(fit: StackFit.expand, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: img.file == null
                  ? Image.network(img.url, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined))
                  : FutureBuilder<Uint8List>(
                future: img.file!.readAsBytes(),
                builder: (_, snap) => snap.hasData
                    ? Image.memory(snap.data!, fit: BoxFit.cover)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            Positioned(
              top: 0, right: 0,
              child: IconButton.filledTonal(
                icon: const Icon(Icons.close, size: 16),
                onPressed: _busy ? null : () => setState(() => _images.removeAt(i)),
              ),
            ),
            Positioned(
              bottom: 0, left: 0,
              child: i == 0
                  ? Chip(label: Text(AppLocalizations.of(context)!.world_edit_cover1))
                  : IconButton.filledTonal(
                tooltip: AppLocalizations.of(context)!.world_edit_set_cover1,
                icon: const Icon(Icons.vertical_align_top, size: 18),
                onPressed: () => setState(() {
                  final selected = _images.removeAt(i);
                  _images.insert(0, selected);
                }),
              ),
            ),
          ]);
        },
      ),
      const SizedBox(height: 18),
      _field(_shortPitch, AppLocalizations.of(context)!.world_edit_short_pitch1, max: 60),
      _field(_summary, AppLocalizations.of(context)!.world_edit_public_summary1, lines: 3, max: 1200),
      _field(_era, AppLocalizations.of(context)!.world_edit_era1, max: 120),
      _tagPicker(),
      _field(_setting, AppLocalizations.of(context)!.world_edit_world_rules1, lines: 6, max: 10000),
      _field(_lore, AppLocalizations.of(context)!.world_edit_full_lore1, lines: 6, max: 6000),
    ],
  );

  Widget _npcTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(AppLocalizations.of(context)!.world_edit_npc_intro1),
      const SizedBox(height: 18),
      _personSection(AppLocalizations.of(context)!.world_edit_main_characters1, AppLocalizations.of(context)!.world_edit_main_subtitle1, 'main'),
      const SizedBox(height: 24),
      _personSection('NPC', AppLocalizations.of(context)!.world_edit_npc_subtitle1, 'npc'),
    ],
  );

  Widget _personSection(String title, String subtitle, String kind) {
    final entries = <MapEntry<int, _WorldNpc>>[];
    for (var i = 0; i < _npcs.length; i++) {
      if (_npcs[i].kind == kind) entries.add(MapEntry(i, _npcs[i]));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 3),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          )),
          Text(AppLocalizations.of(context)!.world_edit_people_count1(entries.length)),
        ]),
        const SizedBox(height: 9),
        for (final entry in entries)
          Card(child: ListTile(
            leading: _npcAvatar(entry.value, size: 48),
            title: Text(entry.value.name),
            subtitle: Text(entry.value.role.isEmpty ? AppLocalizations.of(context)!.world_edit_role_unset1 : entry.value.role),
            onTap: () => _editNpc(oldNpc: entry.value, index: entry.key),
            trailing: IconButton(
              tooltip: AppLocalizations.of(context)!.world_edit_remove_person1,
              icon: const Icon(Icons.delete_outline),
              onPressed: _busy ? null : () => setState(() => _npcs.removeAt(entry.key)),
            ),
          )),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _editNpc(kind: kind),
          icon: const Icon(Icons.person_add_alt_1),
          label: Text(AppLocalizations.of(context)!.world_edit_add_person1(title)),
        ),
      ],
    );
  }

  Future<void> _editSecret({int? index}) async {
    if (_busy) return;
    final original = index == null
        ? <String, String>{}
        : Map<String, String>.from(_secretChapters[index]);

    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => WorldSecretChapterEditorPage(original: original),
      ),
    );
    if (!mounted || result == null) return;

    setState(() {
      if (index == null) {
        if (_secretChapters.length < 12) _secretChapters.add(result);
      } else if (index < _secretChapters.length) {
        _secretChapters[index] = result;
      }
    });
  }

  Widget _storyTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _field(_opening, AppLocalizations.of(context)!.world_edit_story_opening1, lines: 5, max: 1500),
      _field(_firstLine, AppLocalizations.of(context)!.world_edit_first_line1, lines: 5, max: 3000),
      const SizedBox(height: 12),
      Text(AppLocalizations.of(context)!.world_edit_secret_chapters1, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 6),
      Text(AppLocalizations.of(context)!.world_edit_secret_explain1),
      const SizedBox(height: 10),
      for (var i = 0; i < _secretChapters.length; i++)
        Card(child: ListTile(
          title: Text(_secretChapters[i]['title'] ?? ''),
          subtitle: Text(_secretChapters[i]['condition'] ?? ''),
          onTap: _busy ? null : () => _editSecret(index: i),
          trailing: IconButton(icon: const Icon(Icons.delete_outline),
              onPressed: _busy ? null : () => setState(() => _secretChapters.removeAt(i))),
        )),
      OutlinedButton.icon(onPressed: _busy || _secretChapters.length >= 12 ? null : () => _editSecret(),
          icon: const Icon(Icons.add), label: Text(AppLocalizations.of(context)!.world_edit_add_secret_max1)),
      const Divider(height: 30),
      Text(AppLocalizations.of(context)!.world_edit_publish_settings1, style: TextStyle(fontWeight: FontWeight.bold)),
      RadioListTile<bool>(
        title: Text(AppLocalizations.of(context)!.world_edit_private_world1),
        subtitle: Text(AppLocalizations.of(context)!.world_edit_private_world_desc1),
        value: false,
        groupValue: _isPublic,
        onChanged: _busy ? null : (value) => setState(() => _isPublic = value!),
      ),
      RadioListTile<bool>(
        title: Text(AppLocalizations.of(context)!.world_edit_public_world1),
        subtitle: Text(AppLocalizations.of(context)!.world_edit_public_world_desc1),
        value: true,
        groupValue: _isPublic,
        onChanged: _busy ? null : (value) => setState(() => _isPublic = value!),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _busy ? null : _exit,
          ),
          title: Text(AppLocalizations.of(context)!.world_edit_create_world1),
          bottom: TabBar(
            controller: _tabs,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.world_edit_basic_tab1),
              Tab(text: AppLocalizations.of(context)!.world_edit_characters_tab1),
              Tab(text: AppLocalizations.of(context)!.world_edit_story_tab1),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
          Expanded(
            child: TabBarView(controller: _tabs, children: [
              _basicTab(), _npcTab(), _storyTab(),
            ]),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy
                      ? null
                      : () async {
                    final saved = await _save(asDraft: false);
                    if (saved && mounted) {
                      _leaving = true;
                      Navigator.pop(context, {'changed': true, 'worldId': _worldId});
                    }
                  },
                  child: _busy
                      ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(AppLocalizations.of(context)!.world_edit_publish_world1),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    _name.dispose();
    _setting.dispose();
    _summary.dispose();
    _shortPitch.dispose();
    _era.dispose();
    _tags.dispose();
    _lore.dispose();
    _opening.dispose();
    _firstLine.dispose();
    super.dispose();
  }
}

class _WorldImage {
  _WorldImage({this.url = '', this.file});
  String url;
  XFile? file;
}

class _WorldNpc {
  _WorldNpc({
    String id = '', this.kind = 'npc', this.name = '', this.role = '',
    this.gender = '', this.birthday = '', this.age = '', this.appearance = '',
    this.personality = '', this.background = '', this.speechStyle = '',
    this.relationships = '', this.dialogueExamples = '', this.avatarUrl = '', this.avatarFile,
    this.allowPhotoGeneration = false,
  }) : id = id.isNotEmpty ? id : DateTime.now().microsecondsSinceEpoch.toString();

  String id, kind, name, role, gender, birthday, age, appearance;
  String personality, background, speechStyle, relationships, dialogueExamples, avatarUrl;
  XFile? avatarFile;
  bool allowPhotoGeneration;

  factory _WorldNpc.fromMap(Map data) => _WorldNpc(
    id: data['id']?.toString() ?? '',
    kind: data['kind']?.toString() == 'main' ? 'main' : 'npc',
    name: data['name']?.toString() ?? '',
    role: data['role']?.toString() ?? '',
    gender: data['gender']?.toString() ?? '',
    birthday: data['birthday']?.toString() ?? '',
    age: data['age']?.toString() ?? '',
    appearance: data['appearance']?.toString() ?? '',
    personality: data['personality']?.toString() ?? '',
    background: data['background']?.toString() ?? '',
    speechStyle: data['speechStyle']?.toString() ?? '',
    relationships: data['relationships']?.toString() ?? '',
    dialogueExamples: data['dialogueExamples']?.toString() ?? '',
    avatarUrl: data['avatarUrl']?.toString() ?? '',
    allowPhotoGeneration: data['allowPhotoGeneration'] == true,
  );

  _WorldNpc copy() => _WorldNpc(
    id: id, kind: kind, name: name, role: role, gender: gender,
    birthday: birthday, age: age, appearance: appearance,
    personality: personality, background: background, speechStyle: speechStyle,
    relationships: relationships, dialogueExamples: dialogueExamples,
    avatarUrl: avatarUrl, avatarFile: avatarFile,
    allowPhotoGeneration: allowPhotoGeneration,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'kind': kind, 'name': name, 'role': role,
    'gender': gender, 'birthday': birthday, 'age': age, 'appearance': appearance,
    'personality': personality, 'background': background,
    'speechStyle': speechStyle, 'relationships': relationships,
    'dialogueExamples': dialogueExamples,
    'avatarUrl': avatarUrl,
    'allowPhotoGeneration': allowPhotoGeneration,
  };
}

/// 獨立人物編輯頁；只編輯記憶體中的人物，世界觀主頁儲存時才同步至 Firebase。
class _WorldPersonEditor extends StatefulWidget {
  const _WorldPersonEditor({required this.original});
  final _WorldNpc original;

  @override
  State<_WorldPersonEditor> createState() => _WorldPersonEditorState();
}

class _WorldPersonEditorState extends State<_WorldPersonEditor> {
  late final _WorldNpc person;
  final _picker = ImagePicker();
  late final Map<String, TextEditingController> fields;

  @override
  void initState() {
    super.initState();
    person = widget.original;
    fields = {
      'name': TextEditingController(text: person.name),
      'role': TextEditingController(text: person.role),
      'gender': TextEditingController(text: person.gender),
      'birthday': TextEditingController(text: person.birthday),
      'age': TextEditingController(text: person.age),
      'appearance': TextEditingController(text: person.appearance),
      'personality': TextEditingController(text: person.personality),
      'background': TextEditingController(text: person.background),
      'speechStyle': TextEditingController(text: person.speechStyle),
      'relationships': TextEditingController(text: person.relationships),
      'dialogueExamples': TextEditingController(text: person.dialogueExamples),
    };
  }

  Widget field(String key, String label, {int lines = 1, int max = 120}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: fields[key],
          maxLength: max,
          minLines: lines,
          maxLines: lines == 1 ? 1 : null,
          decoration: InputDecoration(
            labelText: label,
            alignLabelWithHint: lines > 1,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  Widget avatar() {
    Widget image = const Icon(Icons.person_outline, size: 44);
    if (person.avatarFile != null) {
      image = FutureBuilder<Uint8List>(
        future: person.avatarFile!.readAsBytes(),
        builder: (_, snap) => snap.hasData
            ? Image.memory(snap.data!, fit: BoxFit.cover)
            : const Icon(Icons.person_outline),
      );
    } else if (person.avatarUrl.isNotEmpty) {
      image = Image.network(person.avatarUrl, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person_outline));
    }
    return ClipOval(child: SizedBox(width: 94, height: 94,
        child: ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: image)));
  }

  void save() {
    final name = fields['name']!.text.trim();
    if (name.isEmpty) {
      ToastUtils.showCenterToast(context, AppLocalizations.of(context)!.world_edit_name_required1, isError: true);
      return;
    }
    person.name = name;
    person.role = fields['role']!.text.trim();
    person.gender = fields['gender']!.text.trim();
    person.birthday = fields['birthday']!.text.trim();
    person.age = fields['age']!.text.trim();
    person.appearance = fields['appearance']!.text.trim();
    person.personality = fields['personality']!.text.trim();
    person.background = fields['background']!.text.trim();
    person.speechStyle = fields['speechStyle']!.text.trim();
    person.relationships = fields['relationships']!.text.trim();
    person.dialogueExamples = fields['dialogueExamples']!.text.trim();
    Navigator.pop(context, person);
  }

  @override
  Widget build(BuildContext context) {
    final title = person.kind == 'main' ? AppLocalizations.of(context)!.world_edit_main_characters1 : 'NPC';
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world_edit_edit_person1(title))),
      body: SafeArea(child: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(18), children: [
          Center(child: avatar()),
          const SizedBox(height: 10),
          Center(child: OutlinedButton.icon(
            onPressed: () async {
              final picked = await _picker.pickImage(
                source: ImageSource.gallery, imageQuality: 82, maxWidth: 1000,
              );
              if (picked != null && mounted) setState(() => person.avatarFile = picked);
            },
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(AppLocalizations.of(context)!.world_edit_upload_photo1),
          )),
          const SizedBox(height: 16),
          field('name', AppLocalizations.of(context)!.world_edit_name1, max: 60),
          field('gender', AppLocalizations.of(context)!.world_edit_gender1, max: 80),
          field('birthday', AppLocalizations.of(context)!.world_edit_birthday1, max: 60),
          field('age', AppLocalizations.of(context)!.world_edit_age1, max: 30),
          field('role', AppLocalizations.of(context)!.world_edit_role1, max: 120),
          field('appearance', AppLocalizations.of(context)!.world_edit_appearance1, lines: 3, max: 2000),
          field('personality', AppLocalizations.of(context)!.world_edit_personality1, lines: 4, max: 3000),
          field('background', AppLocalizations.of(context)!.world_edit_background1, lines: 4, max: 3000),
          field('relationships', AppLocalizations.of(context)!.world_edit_relationships1, lines: 3, max: 2000),
          field('speechStyle', AppLocalizations.of(context)!.world_edit_speech_style1, lines: 3, max: 1000),
          field('dialogueExamples', AppLocalizations.of(context)!.world_edit_dialogue_examples1, lines: 4, max: 1500),
        ])),
        Padding(padding: const EdgeInsets.all(16), child: SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: save, child: Text(AppLocalizations.of(context)!.world_edit_save_person1)),
        )),
      ])),
    );
  }

  @override
  void dispose() {
    for (final controller in fields.values) { controller.dispose(); }
    super.dispose();
  }
}
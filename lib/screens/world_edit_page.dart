import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_constants.dart';
import '../services/toast_utils.dart';

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
      if (user == null) throw StateError('請先登入');
      DocumentSnapshot<Map<String, dynamic>>? doc;
      if (_worldId != null) doc = await _worlds.doc(_worldId).get();
      if (_draftId != null) doc = await _drafts.doc(_draftId).get();
      if (doc != null && doc.exists) {
        final data = doc.data()!;
        if (data['createdBy'] != user.uid) throw StateError('無權編輯此世界觀');
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
                ? '秘密篇章讀取權限不足，請確認 Firestore Rules 已部署。已暫停儲存以保護原資料。'
                : '秘密篇章讀取失敗（${e.code}），已暫停儲存以保護原資料。', isError: true);
          } catch (e) {
            _secretReadFailed = true;
            debugPrint('世界觀秘密篇章讀取失敗：$e');
            _notice('秘密篇章讀取失敗，已暫停儲存以保護原資料。', isError: true);
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
      if (mounted) _notice('讀取世界觀失敗：$e');
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
      if (selected.length > remaining) _notice('世界觀最多只能放 $maxImages 張圖片');
    } catch (e) {
      _notice('讀取圖片失敗：$e');
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
      {int lines = 1, int max = 10000}) {
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

  Widget _tagPicker() {
    final chosen = _selectedTags;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('主題標籤（最多 5 個）'),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 4, children: [
        for (final tag in _suggestedTags)
          FilterChip(
            label: Text(tag), selected: chosen.contains(tag),
            onSelected: _busy ? null : (selected) {
              final next = List<String>.from(_selectedTags);
              if (selected && next.length >= 5) {
                _notice('最多選擇 5 個標籤');
                return;
              }
              if (selected) { next.add(tag); } else { next.remove(tag); }
              setState(() => _tags.text = next.join('、'));
            },
          ),
      ]),
      const SizedBox(height: 8),
      _field(_tags, '標籤（可自訂，以頓號分隔）', max: 120),
    ]);
  }

  /// 一次儲存世界觀與圖像；正式發布需要檢查必填，草稿不需要。
  Future<bool> _save({required bool asDraft}) async {
    if (_busy || _secretReadFailed) {
      if (_secretReadFailed) _notice('秘密篇章尚未成功讀取，為保護既有內容暫時無法發布。請確認權限並重新開啟頁面。');
      return false;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _notice('請先登入');
      return false;
    }
    if (!asDraft) {
      if (_name.text.trim().isEmpty || _images.isEmpty ||
          _setting.text.trim().isEmpty || _opening.text.trim().isEmpty ||
          _firstLine.text.trim().isEmpty) {
        _notice('請完成世界名稱、至少一張圖片、世界背景、故事開場與第一句話');
        return false;
      }
    }
    if (_selectedTags.length > 5) {
      _notice('主題標籤最多 5 個，請刪減後再儲存');
      return false;
    }
    if (_secretChapters.length > 12 || _secretChapters.any((c) =>
    (c['title'] ?? '').trim().isEmpty ||
        (c['condition'] ?? '').trim().isEmpty ||
        (c['content'] ?? '').trim().isEmpty)) {
      _notice('每章請填寫標題、解鎖條件與秘密內容，最多 12 章');
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
        _notice('開放世界草稿與秘密篇章已儲存');
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
            throw StateError('後端尚未確認公開資格，請稍後再次發布。');
          }
        } on FirebaseFunctionsException catch (e) {
          debugPrint('開放世界發布後端失敗：code=${e.code}, message=${e.message}, worldId=$worldId');
          throw StateError('開放世界資料已儲存，但公開啟用失敗（${e.code}）：${e.message ?? '請確認 worldPublish 已部署'}。修正後可再次按「發布開放世界」。');
        }
        if (_draftId != null) {
          try {
            await _drafts.doc(_draftId).delete();
            _draftId = null;
          } catch (e) {
            debugPrint('草稿清理失敗（世界觀已發布）：$e');
          }
        }
        _notice(_isPublic ? '公開開放世界已發布' : '私人開放世界已儲存');
      }
      return true;
    } catch (e) {
      debugPrint('開放世界儲存／發布失敗：$e');
      _notice('儲存／發布失敗：$e', isError: true);
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
        title: const Text('是否儲存草稿？'),
        content: const Text('離開前要儲存目前的世界觀嗎？未儲存的內容將會遺失。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text('不儲存'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('儲存草稿'),
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
      _field(_name, '開放世界名稱 *', max: 60),
      const Text('世界觀圖片（最多 6 張，第一張為主要封面）'),
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
                  ? const Chip(label: Text('封面'))
                  : IconButton.filledTonal(
                tooltip: '設為封面',
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
      _field(_shortPitch, '卡片一句話介紹（選填，最多 60 字）', max: 60),
      _field(_summary, '世界觀公開簡介（不含劇透）', lines: 3, max: 1200),
      _field(_era, '時空背景（例：架空現代、民國時期）', max: 120),
      _tagPicker(),
      _field(_setting, '世界觀背景與規則 *', lines: 6, max: 10000),
      _field(_lore, '完整世界背景／事件與地點（給 AI 的設定）', lines: 6, max: 6000),
    ],
  );

  Widget _npcTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('主要角色與 NPC 都能設定姓名、外貌、生日、人物關係與照片。玩家仍是自己故事的主角。'),
      const SizedBox(height: 18),
      _personSection('主要角色', '在世界觀中較常登場的重要人物', 'main'),
      const SizedBox(height: 24),
      _personSection('NPC', '其他登場人物，也能隨劇情成為互動焦點', 'npc'),
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
          Text('${entries.length} 位'),
        ]),
        const SizedBox(height: 9),
        for (final entry in entries)
          Card(child: ListTile(
            leading: _npcAvatar(entry.value, size: 48),
            title: Text(entry.value.name),
            subtitle: Text(entry.value.role.isEmpty ? '尚未設定身分／職業' : entry.value.role),
            onTap: () => _editNpc(oldNpc: entry.value, index: entry.key),
            trailing: IconButton(
              tooltip: '移除人物',
              icon: const Icon(Icons.delete_outline),
              onPressed: _busy ? null : () => setState(() => _npcs.removeAt(entry.key)),
            ),
          )),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _editNpc(kind: kind),
          icon: const Icon(Icons.person_add_alt_1),
          label: Text('新增$title'),
        ),
      ],
    );
  }

  Future<void> _editSecret({int? index}) async {
    final original = index == null ? <String, String>{} : _secretChapters[index];
    final title = TextEditingController(text: original['title'] ?? '');
    final condition = TextEditingController(text: original['condition'] ?? '');
    final content = TextEditingController(text: original['content'] ?? '');
    try {
      final result = await showDialog<Map<String, String>>(context: context,
          builder: (ctx) => AlertDialog(
            title: Text(index == null ? '新增秘密篇章' : '編輯秘密篇章'),
            content: SizedBox(width: 520, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: title, maxLength: 80, decoration: const InputDecoration(labelText: '篇章標題 *')),
              TextField(controller: condition, maxLength: 500, maxLines: 3, decoration: const InputDecoration(labelText: '解鎖條件（給後端判定的描述）*')),
              TextField(controller: content, maxLength: 5000, minLines: 5, maxLines: null, decoration: const InputDecoration(labelText: '秘密內容 *')),
            ]))),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
              FilledButton(onPressed: () {
                if (title.text.trim().isEmpty || condition.text.trim().isEmpty || content.text.trim().isEmpty) return;
                Navigator.pop(ctx, {
                  'id': original['id']?.isNotEmpty == true ? original['id']! : DateTime.now().microsecondsSinceEpoch.toString(),
                  'title': title.text.trim(), 'condition': condition.text.trim(), 'content': content.text.trim(),
                });
              }, child: const Text('確認'))],
          ));
      if (!mounted || result == null) return;
      setState(() {if (index == null) {_secretChapters.add(result);} else {_secretChapters[index] = result;}});
    } finally { title.dispose(); condition.dispose(); content.dispose(); }
  }

  Widget _storyTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _field(_opening, '故事開場 *', lines: 5, max: 1500),
      _field(_firstLine, '故事第一句話 *', lines: 5, max: 3000),
      const SizedBox(height: 12),
      Text('秘密篇章', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 6),
      const Text('秘密篇章只儲存在私密資料區。正式公開不會直接公開內容；玩家需在遊玩中達成劇情條件才可解鎖。'),
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
          icon: const Icon(Icons.add), label: const Text('新增秘密篇章（最多 12 章）')),
      const Divider(height: 30),
      const Text('發布設定', style: TextStyle(fontWeight: FontWeight.bold)),
      RadioListTile<bool>(
        title: const Text('私人開放世界'),
        subtitle: const Text('僅自己可以遊玩及測試，其他玩家無法進入'),
        value: false,
        groupValue: _isPublic,
        onChanged: _busy ? null : (value) => setState(() => _isPublic = value!),
      ),
      RadioListTile<bool>(
        title: const Text('公開開放世界'),
        subtitle: const Text('其他玩家可進入遊玩，每位玩家有獨立劇情進度'),
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
          title: const Text('創立開放世界'),
          bottom: TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: '基本設定'),
              Tab(text: '世界觀人物'),
              Tab(text: '故事設定'),
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
                      : const Text('發布開放世界'),
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
      ToastUtils.showCenterToast(context, '請先填寫人物姓名', isError: true);
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
    final title = person.kind == 'main' ? '主要角色' : 'NPC';
    return Scaffold(
      appBar: AppBar(title: Text('編輯$title')),
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
            label: const Text('上傳人物照片（選填）'),
          )),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('允許使用此人物照片生成其他照片'),
            subtitle: const Text(
              '僅在劇情適合時可將此人物的圖片作為生成參考。'
                  '不勾選仍可正常聊天及贈送一般禮物；每位人物獨立設定。',
            ),
            value: person.allowPhotoGeneration,
            onChanged: (allowed) => setState(() {
              person.allowPhotoGeneration = allowed;
            }),
          ),
          const SizedBox(height: 16),
          field('name', '姓名 *', max: 60),
          field('gender', '性別／性別設定', max: 80),
          field('birthday', '生日（例：5月16日）', max: 60),
          field('age', '年齡', max: 30),
          field('role', '身分／職業', max: 120),
          field('appearance', '外貌特徵', lines: 3, max: 2000),
          field('personality', '個性與人物設定', lines: 4, max: 3000),
          field('background', '過去經歷', lines: 4, max: 3000),
          field('relationships', '與其他人物的關係', lines: 3, max: 2000),
          field('speechStyle', '說話方式／口吻', lines: 3, max: 1000),
          field('dialogueExamples', '對話範例（幫助 AI 理解語氣）', lines: 4, max: 1500),
        ])),
        Padding(padding: const EdgeInsets.all(16), child: SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: save, child: const Text('儲存人物設定')),
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
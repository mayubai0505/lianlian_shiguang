import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_constants.dart';

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
  final TextEditingController _opening = TextEditingController();
  final TextEditingController _firstLine = TextEditingController();

  final List<_WorldImage> _images = [];
  final List<_WorldNpc> _npcs = [];
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
        _opening.text = data['storyOpening']?.toString() ?? '';
        _firstLine.text = data['firstLine']?.toString() ?? '';
        _isPublic = data['isPublic'] == true;
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

  void _notice(String value) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
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

  /// 一次儲存世界觀與圖像；正式發布需要檢查必填，草稿不需要。
  Future<bool> _save({required bool asDraft}) async {
    if (_busy) return false;
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
      if (asDraft) {
        _draftId ??= worldId;
        await _drafts.doc(_draftId).set({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        _notice('世界觀草稿已儲存');
      } else {
        await _worlds.doc(worldId).set({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        _worldId = worldId;
        if (_draftId != null) {
          try {
            await _drafts.doc(_draftId).delete();
            _draftId = null;
          } catch (e) {
            debugPrint('草稿清理失敗（世界觀已發布）：$e');
          }
        }
        _notice(_isPublic ? '世界觀已公開' : '私人世界觀已建立');
      }
      return true;
    } catch (e) {
      _notice('儲存失敗：$e');
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
      _field(_name, '世界觀名稱 *', max: 60),
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
      _field(_setting, '世界觀背景與規則 *', lines: 6, max: 10000),
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

  Widget _storyTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      _field(_opening, '故事開場 *', lines: 5, max: 1500),
      _field(_firstLine, '故事第一句話 *', lines: 5, max: 3000),
      const Divider(height: 30),
      const Text('發布設定', style: TextStyle(fontWeight: FontWeight.bold)),
      RadioListTile<bool>(
        title: const Text('私人世界觀'),
        subtitle: const Text('只有創作者本人可進入測試'),
        value: false,
        groupValue: _isPublic,
        onChanged: _busy ? null : (value) => setState(() => _isPublic = value!),
      ),
      RadioListTile<bool>(
        title: const Text('公開世界觀'),
        subtitle: const Text('其他玩家可以遊玩自己的獨立故事'),
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
          title: const Text('創立世界觀'),
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
                      : Text(_isPublic ? '發布世界觀' : '建立私人世界觀'),
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
    this.id = '', this.kind = 'npc', this.name = '', this.role = '',
    this.gender = '', this.birthday = '', this.age = '', this.appearance = '',
    this.personality = '', this.background = '', this.speechStyle = '',
    this.relationships = '', this.avatarUrl = '', this.avatarFile,
  }) : id = id.isNotEmpty ? id : DateTime.now().microsecondsSinceEpoch.toString();

  String id, kind, name, role, gender, birthday, age, appearance;
  String personality, background, speechStyle, relationships, avatarUrl;
  XFile? avatarFile;

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
    avatarUrl: data['avatarUrl']?.toString() ?? '',
  );

  _WorldNpc copy() => _WorldNpc(
    id: id, kind: kind, name: name, role: role, gender: gender,
    birthday: birthday, age: age, appearance: appearance,
    personality: personality, background: background, speechStyle: speechStyle,
    relationships: relationships, avatarUrl: avatarUrl, avatarFile: avatarFile,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'kind': kind, 'name': name, 'role': role,
    'gender': gender, 'birthday': birthday, 'age': age, 'appearance': appearance,
    'personality': personality, 'background': background,
    'speechStyle': speechStyle, 'relationships': relationships,
    'avatarUrl': avatarUrl,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請先填寫人物姓名')),
      );
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

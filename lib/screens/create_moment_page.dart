import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/theme_notifier.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';

import '../services/toast_utils.dart';
import 'character_model.dart';
import '../utils/image_utils.dart';
import '../utils/moment_search_utils.dart';
//發文編輯器 / 創作中心(點擊+後才會出現的頁面)
class CreateMomentPage extends StatefulWidget {
  // ✨ 門禁更新：不強制要求傳入 Character 物件，而是傳入具體的名稱和照片
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final bool isCreatorPost;

  const CreateMomentPage({
    super.key,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.isCreatorPost,
  });

  @override
  State<CreateMomentPage> createState() => _CreateMomentPageState();
}

class _CreateMomentPageState extends State<CreateMomentPage> {
  final TextEditingController _contentController = TextEditingController();
  // 🏷️ @角色候選清單
  final List<Character> _mentionCandidates = [];

// 自己名下角色 ID，用來區分「我的角色／好友角色」
  final Set<String> _myCharacterIds = {};

// 實際選取過的 Tag，發布時存進 Firestore
  final List<Map<String, String>> _selectedMentions = [];

// 是否顯示 @候選清單
  bool _showMentionSuggestions = false;

// 玩家正在輸入的 @關鍵字
  String _mentionQuery = '';

// 目前 @字串開始的位置
  int _mentionStartIndex = -1;

// 是否正在讀取角色
  bool _isLoadingMentionCharacters = false;

  // --- 圖片與 Firebase 變數 ---
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  bool _isPosting = false;
  bool _isPublic = true; // 預設為公開貼文 🌍
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  // 🌟 總裁指令：不管是大寫還是小寫，通通都要聽 AppConfig 的話！
  final String APP_ID = AppConfig.appId;

  @override
  void initState() {
    super.initState();

    _contentController.addListener(
      _handleMentionInput,
    );

    _loadMentionCharacters();
  }

  // ✨ 發布動態的核心邏輯 (恢復單純的發文邏輯)
  Future<void> _postMoment() async {
    final l10n = AppLocalizations.of(context)!;
    final content = _contentController.text.trim();
    _syncTypedMentionsBeforePost();
    if (content.isEmpty && _pickedImage == null) {
      // ✨ 總裁級防呆：動態發佈的溫柔提醒，保護你的 UI 排版不受鍵盤干擾！
      ToastUtils.showCenterToast(
        context,
        l10n.moment_create_error_empty,
        customIcon: Icons.edit_note_rounded, // 💡 總裁精選：用「筆記/編輯」圖示，提醒玩家「輸入一點內容吧！」
        // 💡 總裁秘技：若你想更強調「照片」的重要性，
        // 使用 Icons.add_photo_alternate_rounded 也會非常有引導性喔！
      );
      return;
    }
    if (_userId == null) return;

    setState(() => _isPosting = true);

    try {
      String? imageUrl;
      // 如果有選擇圖片，就先上傳
      if (_pickedImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final ref = _storage.ref().child('moment_images').child(_userId!).child(fileName);
        // ✨ 完美套用我們剛學會的雙平台分流大法
        if (kIsWeb) {
          // 🌐 Web 專用
          final bytes = await _pickedImage!.readAsBytes(); // 變數改成 _pickedImage!
          await ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
        } else {
          // 📱 手機專用
          await ref.putFile(File(_pickedImage!.path), SettableMetadata(contentType: 'image/png'));
        }
        imageUrl = await ref.getDownloadURL();
      }
      // 準備要寫入 Firestore 的資料 (直接使用傳進來的 author 資料)
      await _db.collection('artifacts').doc(AppConfig.appId).collection('moments').add({
        'authorId': widget.authorId,
        'authorName': widget.authorName,
        'authorAvatar': widget.authorAvatar,
        'createdBy': _userId,
        'content': content,
        'searchKeywords': buildMomentSearchKeywords(
          content: content,
          authorName: widget.authorName,
        ),
        'mentions': _selectedMentions,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'likeCount': 0,
        'commentCount': 0,
        'isPublic': _isPublic,
        // 暫時先把這個標記設為 false，等我們改完大廳再來處理身分問題
        'isCreatorPost': widget.isCreatorPost,
      });
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("發布動態失敗: $e");
      if (mounted) {
        // ✨ 總裁級防護：動態發佈失敗的優雅迫降，用紅色驚嘆號建立專業感！
        ToastUtils.showCenterToast(
          context,
          l10n.moment_create_error_failed,
          isError: true, // 💡 全域統一的紅色驚嘆號，清楚傳達異常，但不引發不必要的恐慌
          // 💡 總裁秘技：此時玩家一定很焦慮，CenterToast 能穩穩地顯示在畫面中央，
          // 讓他們第一時間看到提示，而不會因為 SnackBar 被鍵盤擋住而感到疑惑。
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  Future<List<Character>> _fetchMyCharactersForMention() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final Map<String, Character> characterMap = {};

    try {
      // 1. 自己建立的公開角色
      final publicSnapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .where(
        'createdBy',
        isEqualTo: user.uid,
      )
          .get();

      for (final doc in publicSnapshot.docs) {
        try {
          final character =
          await Character.fromFirestoreAsync(doc);

          characterMap[character.id] = character;
        } catch (e) {
          debugPrint(
            '⚠️ 解析公開角色 ${doc.id} 失敗：$e',
          );
        }
      }

      // 2. 自己建立的私人角色
      final privateSnapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(user.uid)
          .collection('private_characters')
          .get();

      for (final doc in privateSnapshot.docs) {
        try {
          final character =
          await Character.fromFirestoreAsync(doc);

          characterMap[character.id] = character;
        } catch (e) {
          debugPrint(
            '⚠️ 解析私人角色 ${doc.id} 失敗：$e',
          );
        }
      }

      final characters = characterMap.values.toList();

      characters.sort(
            (a, b) => a.name.compareTo(b.name),
      );

      debugPrint(
        '🏷️ 可標記角色數量：${characters.length}',
      );

      return characters;
    } catch (e, stackTrace) {
      debugPrint('❌ 讀取可標記角色失敗：$e');
      debugPrintStack(stackTrace: stackTrace);

      return [];
    }
  }

  Future<void> _showMentionCharacterSheet() async {
    FocusScope.of(context).unfocus();

    final characters =
    await _fetchMyCharactersForMention();

    if (!mounted) return;

    if (characters.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        '目前沒有可以標記的角色。',
        customIcon: Icons.person_search_rounded,
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.62,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alternate_email_rounded,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '標記我的角色',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    itemCount: characters.length,
                    separatorBuilder: (_, __) =>
                    const Divider(
                      height: 1,
                      indent: 72,
                    ),
                    itemBuilder: (context, index) {
                      final character = characters[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                          getAvatarImageProvider(
                            character.avatarPath,
                          ),
                        ),
                        title: Text(
                          character.name,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          character.isPublic
                              ? '公開角色'
                              : '私人角色',
                        ),
                        trailing: const Icon(
                          Icons.add_circle_outline_rounded,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);

                          _insertMention(character);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _insertMention(Character character) {
    final String mentionText =
        '@${character.name}';

    final TextEditingValue value =
        _contentController.value;

    final int rawStart =
        value.selection.start;

    final int rawEnd =
        value.selection.end;

    final int start = rawStart < 0
        ? value.text.length
        : rawStart;

    final int end = rawEnd < 0
        ? start
        : rawEnd;

    final String before =
    value.text.substring(0, start);

    final String after =
    value.text.substring(end);

    final bool needsLeadingSpace =
        before.isNotEmpty &&
            !before.endsWith(' ') &&
            !before.endsWith('\n');

    final String insertedText =
        '${needsLeadingSpace ? ' ' : ''}$mentionText ';

    final String newText =
        '$before$insertedText$after';

    final int newCursorPosition =
        before.length + insertedText.length;

    _contentController.value =
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: newCursorPosition,
          ),
        );

    final bool alreadySelected =
    _selectedMentions.any(
          (item) =>
      item['characterId'] == character.id,
    );

    if (!alreadySelected) {
      setState(() {
        _selectedMentions.add({
          'characterId': character.id,
          'name': character.name,
        });
      });
    }
  }

  Future<void> _loadMentionCharacters() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (mounted) {
      setState(() {
        _isLoadingMentionCharacters = true;
      });
    }

    try {
      final Map<String, Character> characterMap = {};

      // =====================================
      // 1. 自己建立的公開角色
      // =====================================
      final publicSnapshot =
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .where(
        'createdBy',
        isEqualTo: user.uid,
      )
          .get();

      for (final doc in publicSnapshot.docs) {
        try {
          final character =
          await Character.fromFirestoreAsync(
            doc,
          );

          characterMap[character.id] = character;
          _myCharacterIds.add(character.id);
        } catch (e) {
          debugPrint(
            '⚠️ 公開角色 ${doc.id} 解析失敗：$e',
          );
        }
      }

      // =====================================
      // 2. 自己建立的私人角色
      // =====================================
      final privateSnapshot =
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('users')
          .doc(user.uid)
          .collection('private_characters')
          .get();

      for (final doc in privateSnapshot.docs) {
        try {
          final character =
          await Character.fromFirestoreAsync(
            doc,
          );

          characterMap[character.id] = character;
          _myCharacterIds.add(character.id);
        } catch (e) {
          debugPrint(
            '⚠️ 私人角色 ${doc.id} 解析失敗：$e',
          );
        }
      }

      // =====================================
      // 3. 玩家已加入好友的角色
      // friends 文件 ID 就是角色 ID
      // =====================================
      final friendsSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .get();

      for (final friendDoc
      in friendsSnapshot.docs) {
        final String characterId =
        friendDoc.id.trim();

        if (characterId.isEmpty) continue;

        // 自己的角色已經加入，不重複讀
        if (characterMap.containsKey(characterId)) {
          continue;
        }

        try {
          final publicDoc =
          await FirebaseFirestore.instance
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('public_characters')
              .doc(characterId)
              .get();

          // 好友角色若已轉私人或刪除，就不顯示
          if (!publicDoc.exists) continue;

          final character =
          await Character.fromFirestoreAsync(
            publicDoc,
          );

          characterMap[character.id] = character;
        } catch (e) {
          debugPrint(
            '⚠️ 好友角色 $characterId 讀取失敗：$e',
          );
        }
      }

      final characters =
      characterMap.values.toList();

      // 我的角色優先，再依名字排序
      characters.sort((a, b) {
        final bool aIsMine =
        _myCharacterIds.contains(a.id);
        final bool bIsMine =
        _myCharacterIds.contains(b.id);

        if (aIsMine != bIsMine) {
          return aIsMine ? -1 : 1;
        }

        return a.name.compareTo(b.name);
      });

      if (!mounted) return;

      setState(() {
        _mentionCandidates
          ..clear()
          ..addAll(characters);

        _isLoadingMentionCharacters = false;
      });

      debugPrint(
        '🏷️ @候選角色共 ${characters.length} 位',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 讀取 @角色失敗：$e');
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        _isLoadingMentionCharacters = false;
      });
    }
  }

  void _handleMentionInput() {
    final TextEditingValue value =
        _contentController.value;

    final int cursorPosition =
        value.selection.baseOffset;

    if (cursorPosition < 0 ||
        cursorPosition > value.text.length) {
      return;
    }

    final String textBeforeCursor =
    value.text.substring(
      0,
      cursorPosition,
    );

    /*
   * 可以偵測：
   * @
   * 今天跟@
   * 今天跟 @花
   *
   * 遇到空白、換行後就結束此次搜尋。
   */
    final RegExp mentionPattern =
    RegExp(r'@([^\s@]*)$');

    final RegExpMatch? match =
    mentionPattern.firstMatch(
      textBeforeCursor,
    );

    if (match == null) {
      if (_showMentionSuggestions) {
        setState(() {
          _showMentionSuggestions = false;
          _mentionQuery = '';
          _mentionStartIndex = -1;
        });
      }

      return;
    }

    final String query =
        match.group(1)?.trim() ?? '';

    final int startIndex = match.start;

    if (!_showMentionSuggestions ||
        _mentionQuery != query ||
        _mentionStartIndex != startIndex) {
      setState(() {
        _showMentionSuggestions = true;
        _mentionQuery = query;
        _mentionStartIndex = startIndex;
      });
    }
  }

  List<Character> get _filteredMentionCharacters {
    final String keyword =
    _mentionQuery.toLowerCase().trim();

    if (keyword.isEmpty) {
      return _mentionCandidates;
    }

    return _mentionCandidates.where((character) {
      return character.name
          .toLowerCase()
          .contains(keyword);
    }).toList();
  }

  void _selectMentionCharacter(
      Character character,
      ) {
    final TextEditingValue value =
        _contentController.value;

    final int cursorPosition =
        value.selection.baseOffset;

    if (_mentionStartIndex < 0 ||
        cursorPosition < _mentionStartIndex) {
      return;
    }

    final String beforeMention =
    value.text.substring(
      0,
      _mentionStartIndex,
    );

    final String afterCursor =
    value.text.substring(
      cursorPosition,
    );

    final String mentionText =
        '@${character.name} ';

    final String newText =
        '$beforeMention$mentionText$afterCursor';

    final int newCursorPosition =
        beforeMention.length +
            mentionText.length;

    // 先關閉清單，避免 listener 又重新打開
    setState(() {
      _showMentionSuggestions = false;
      _mentionQuery = '';
      _mentionStartIndex = -1;
    });

    _contentController.value =
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: newCursorPosition,
          ),
        );

    final bool alreadyAdded =
    _selectedMentions.any(
          (mention) =>
      mention['characterId'] ==
          character.id,
    );

    if (!alreadyAdded) {
      _selectedMentions.add({
        'characterId': character.id,
        'name': character.name,
      });
    }
  }

  Widget _buildMentionSuggestions(
      ThemeData theme,
      ) {
    if (!_showMentionSuggestions) {
      return const SizedBox.shrink();
    }

    final characters =
        _filteredMentionCharacters;

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 230,
      ),
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary
              .withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _isLoadingMentionCharacters
          ? const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child:
          CircularProgressIndicator(),
        ),
      )
          : characters.isEmpty
          ? const Padding(
        padding:
        EdgeInsets.all(20),
        child: Center(
          child: Text(
            '找不到符合的角色',
          ),
        ),
      )
          : ListView.separated(
        shrinkWrap: true,
        padding:
        const EdgeInsets.symmetric(
          vertical: 6,
        ),
        itemCount:
        characters.length,
        separatorBuilder: (_, __) =>
        const Divider(
          height: 1,
          indent: 64,
        ),
        itemBuilder: (
            context,
            index,
            ) {
          final character =
          characters[index];

          final bool isMine =
          _myCharacterIds
              .contains(
            character.id,
          );

          return ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundImage:
              _getAvatarProvider(
                character.avatarPath,
              ),
            ),
            title: Text(
              character.name,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
            ),
            subtitle: Text(
              isMine
                  ? '我的角色'
                  : '好友角色',
              style: TextStyle(
                fontSize: 11,
                color: isMine
                    ? theme
                    .colorScheme
                    .primary
                    : theme
                    .colorScheme
                    .onSurface
                    .withValues(
                  alpha: 0.55,
                ),
              ),
            ),
            trailing: const Icon(
              Icons.alternate_email,
              size: 18,
            ),
            onTap: () {
              _selectMentionCharacter(
                character,
              );
            },
          );
        },
      ),
    );
  }

  void _syncTypedMentionsBeforePost() {
    final String content = _contentController.text;

    final Map<String, List<Character>> charactersByName = {};

    for (final character in _mentionCandidates) {
      charactersByName
          .putIfAbsent(character.name, () => [])
          .add(character);
    }

    for (final entry in charactersByName.entries) {
      final String name = entry.key;
      final List<Character> matches = entry.value;
      final String tag = '@$name';

      // 沒有輸入這個名稱
      if (!content.contains(tag)) {
        continue;
      }

      // 同名角色超過一位，不能自行猜
      if (matches.length != 1) {
        continue;
      }

      final character = matches.first;

      final bool alreadyAdded =
      _selectedMentions.any(
            (mention) =>
        mention['characterId'] == character.id,
      );

      if (!alreadyAdded) {
        _selectedMentions.add({
          'characterId': character.id,
          'name': character.name,
        });
      }
    }
  }

  // 選擇圖片邏輯
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 1080);
    if (image != null && mounted) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  @override
  void dispose() {
    _contentController.removeListener(
      _handleMentionInput,
    );
    _contentController.dispose();
    super.dispose();
  }

  // 終極防呆讀取器
  ImageProvider _getAvatarProvider(String path) {
    if (path.isEmpty) return const AssetImage('assets/images/blank_avatar.png');
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.startsWith('assets/')) return AssetImage(path);

    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    } else {
      return const AssetImage('assets/images/avatar1.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context); // 如果妳沒有用 Provider，這行跟 body 的 decoration 可能要調整
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moment_create_title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _isPosting ? null : _postMoment,
              child: _isPosting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n.moment_create_post_btn, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          // 確保背景顏色有吃到主題，如果報錯可以改成 color: theme.scaffoldBackgroundColor
          decoration: themeNotifier.currentBackground,
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children: [
                // 乾淨的 UI：只顯示傳進來的發文者頭像與名字
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: _getAvatarProvider(widget.authorAvatar),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.authorName,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _contentController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: l10n.moment_create_hint,
                            border: InputBorder.none,
                          ),
                        ),

// 🏷️ 玩家輸入 @ 時出現
                        _buildMentionSuggestions(theme),

                        const SizedBox(height: 16),
                        // 顯示已選擇的圖片預覽
                        if (_pickedImage != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(File(_pickedImage!.path)),
                              ),
                              IconButton(
                                icon: const CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                                onPressed: () => setState(() => _pickedImage = null),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isPublic ? Icons.public : Icons.lock_outline,
                          color: _isPublic ? Colors.lightBlueAccent : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(_isPublic ? l10n.moment_create_visibility_public : l10n.moment_create_visibility_private,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isPublic ? Colors.lightBlueAccent : Colors.grey
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isPublic,
                      activeColor: Colors.lightBlueAccent,
                      onChanged: (val) => setState(() => _isPublic = val),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    IconButton(
                      tooltip: '新增圖片',
                      icon: Icon(
                        Icons.photo_library_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: _pickImage,
                    ),

                    IconButton(
                      tooltip: '標記角色',
                      icon: Icon(
                        Icons.alternate_email_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: _showMentionCharacterSheet,
                    ),
                  ],
                ),
              ]
          ),
        ),
      ),
    );
  }
}
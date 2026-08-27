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
import 'package:google_fonts/google_fonts.dart';

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    4,
                    20,
                    14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alternate_email_rounded,
                        color: Theme.of(sheetContext)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.82),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '標記我的角色',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: Theme.of(sheetContext)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.22),
                ),

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
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSerifTc(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                          ),
                        ),
                        subtitle: Text(
                          character.isPublic
                              ? '公開角色'
                              : '私人角色',
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 11.5,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.46),
                          ),
                        ),
                        trailing: Icon(
                          Icons.add_circle_outline_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.72),
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final l10n = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 68,
        leadingWidth: 54,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 23,
            color: onSurface.withValues(alpha: 0.82),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          l10n.moment_create_title,
          style: GoogleFonts.notoSerifTc(
            color: onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 11, 14, 11),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: theme.colorScheme.onPrimary,
                disabledBackgroundColor:
                primary.withValues(alpha: 0.26),
                elevation: 0,
                minimumSize: const Size(78, 42),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _isPosting ? null : _postMoment,
              child: _isPosting
                  ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: Colors.white,
                ),
              )
                  : Text(
                l10n.moment_create_post_btn,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: themeNotifier.currentBackground,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage:
                                  _getAvatarProvider(widget.authorAvatar),
                                  backgroundColor:
                                  primary.withValues(alpha: 0.08),
                                ),
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.scaffoldBackgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.authorName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSerifTc(
                                      color: onSurface,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        _isPublic
                                            ? Icons.public_rounded
                                            : Icons.lock_outline_rounded,
                                        size: 14,
                                        color:
                                        primary.withValues(alpha: 0.62),
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          _isPublic
                                              ? l10n
                                              .moment_create_visibility_public
                                              : l10n
                                              .moment_create_visibility_private,
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style:
                                          GoogleFonts.notoSerifTc(
                                            color: onSurface.withValues(
                                              alpha: 0.46,
                                            ),
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            minHeight: 260,
                          ),
                          padding: const EdgeInsets.fromLTRB(
                            18,
                            14,
                            18,
                            14,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(
                              alpha: 0.84,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.24),
                              width: 0.9,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.035),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _contentController,
                                minLines: 8,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: GoogleFonts.notoSerifTc(
                                  color: onSurface.withValues(alpha: 0.82),
                                  fontSize: 15,
                                  height: 1.75,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.moment_create_hint,
                                  hintStyle: GoogleFonts.notoSerifTc(
                                    color: onSurface.withValues(
                                      alpha: 0.30,
                                    ),
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),

                              _buildMentionSuggestions(theme),

                              if (_pickedImage != null) ...[
                                const SizedBox(height: 14),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(18),
                                      child: Image.file(
                                        File(_pickedImage!.path),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: InkWell(
                                        borderRadius:
                                        BorderRadius.circular(999),
                                        onTap: () => setState(
                                              () => _pickedImage = null,
                                        ),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.46),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${_contentController.text.length}/2000',
                                  style: GoogleFonts.notoSerifTc(
                                    color: onSurface.withValues(alpha: 0.30),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            12,
                            12,
                            12,
                          ),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.045),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.10),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPublic
                                      ? Icons.public_rounded
                                      : Icons.lock_outline_rounded,
                                  size: 18,
                                  color: primary.withValues(alpha: 0.82),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _isPublic
                                          ? l10n
                                          .moment_create_visibility_public
                                          : l10n
                                          .moment_create_visibility_private,
                                      style: GoogleFonts.notoSerifTc(
                                        color: onSurface.withValues(
                                          alpha: 0.82,
                                        ),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _isPublic
                                          ? '動態將顯示在拾光牆上'
                                          : '只有專屬範圍內可見',
                                      style: GoogleFonts.notoSerifTc(
                                        color: onSurface.withValues(
                                          alpha: 0.40,
                                        ),
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _isPublic,
                                activeThumbColor: Colors.white,
                                activeTrackColor: primary,
                                inactiveThumbColor:
                                onSurface.withValues(alpha: 0.36),
                                inactiveTrackColor:
                                onSurface.withValues(alpha: 0.10),
                                onChanged: (val) =>
                                    setState(() => _isPublic = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    10,
                    22,
                    14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _pickImage,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 23,
                                  color:
                                  primary.withValues(alpha: 0.78),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '添加圖片',
                                  style: GoogleFonts.notoSerifTc(
                                    color: onSurface.withValues(
                                      alpha: 0.66,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 42,
                        color: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.18),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _showMentionCharacterSheet,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.alternate_email_rounded,
                                  size: 23,
                                  color:
                                  primary.withValues(alpha: 0.78),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '提及角色',
                                  style: GoogleFonts.notoSerifTc(
                                    color: onSurface.withValues(
                                      alpha: 0.66,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
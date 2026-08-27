import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // ✨ 引入 Provider
import '../services/theme_notifier.dart'; // ✨ 引入主題背景
import '../services/toast_utils.dart';
import 'chat_page.dart';
import 'character_model.dart';
import 'dart:async';
import 'notification_list_page.dart'; // 記得根據妳的資料夾路徑調整
import 'call_memory_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:showcaseview/showcaseview.dart'; // 🌟 記得加這行
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/reminder_notification_service.dart';
//聊天室的名稱更改
class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot>? _sessionsStream;
  bool _isNavigatingToChat = false;
  bool _isOpeningTopAction = false;
  final String _appId = AppConfig.appId;
  final Map<String, Character> _characterCache = {};
  final Set<String> _preloadedAvatarUrls = {};
  bool _hasHandledInitialNotification =
  false;
  bool _hasCheckedNotification = false;
  // 💡 新增：紀錄這頁的氣泡是否已經彈過
  bool _hasChatHomeTipsShown = true;
// 🔑 新增：專屬這頁的兩個追蹤鑰匙
  final GlobalKey _memoryKey = GlobalKey();
  final GlobalKey _mailboxKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    _checkChatHomeTutorial();

    if (_currentUser != null) {
      _sessionsStream = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('chat_sessions')
          .where(
        'userId',
        isEqualTo: _currentUser.uid,
      )
          .orderBy(
        'lastActivity',
        descending: true,
      )
          .snapshots();
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _checkPendingNotification();
    });
  }

  Future<void> _checkPendingNotification() async {
    if (_hasCheckedNotification ||
        !mounted ||
        _currentUser == null) {
      return;
    }

    _hasCheckedNotification = true;

    final prefs =
    await SharedPreferences.getInstance();

    final String? payload = prefs.getString(
      'pending_notification_payload',
    );

    if (payload == null ||
        payload.trim().isEmpty) {
      return;
    }

    // 先移除，避免每次進聊天首頁都重複跳轉。
    await prefs.remove(
      'pending_notification_payload',
    );

    debugPrint('🔔 處理待跳轉通知：$payload');

    try {
      final params =
      Uri.splitQueryString(payload);

      if (params['type'] != 'memo') {
        return;
      }

      final String characterId =
          params['characterId']?.trim() ?? '';

      if (characterId.isEmpty) {
        return;
      }

      await _openChatFromNotification(
        characterId,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '解析備忘錄通知失敗：$error',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _openChatFromNotification(
      String characterId,
      ) async {
    final user = _currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (user == null || !mounted) {
      return;
    }

    try {
      final snapshot =
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('chat_sessions')
          .where(
        'userId',
        isEqualTo: user.uid,
      )
          .get();

      final matchingDocs =
      snapshot.docs.where((doc) {
        final data =
        doc.data() as Map<String, dynamic>;

        return data['characterId']
            ?.toString()
            .trim() ==
            characterId;
      }).toList();

      if (matchingDocs.isEmpty) {
        debugPrint(
          '找不到通知角色的聊天室：$characterId',
        );

        if (mounted) {
          ToastUtils.showCenterToast(
            context,
            l10n.chatRoomNotFound,
            isError: true,
          );
        }

        return;
      }

      // 有多個聊天室時，找最後活動時間最新的。
      matchingDocs.sort((a, b) {
        final aData =
        a.data() as Map<String, dynamic>;

        final bData =
        b.data() as Map<String, dynamic>;

        final Timestamp? aTime =
        aData['lastActivity'] as Timestamp?;

        final Timestamp? bTime =
        bData['lastActivity'] as Timestamp?;

        if (aTime == null && bTime == null) {
          return 0;
        }

        if (aTime == null) return 1;
        if (bTime == null) return -1;

        return bTime.compareTo(aTime);
      });

      final sessionDoc =
          matchingDocs.first;

      final sessionData =
      sessionDoc.data()
      as Map<String, dynamic>;

      final String avatarUrl =
          sessionData['characterAvatarPath']
              ?.toString() ??
              '';

      if (!mounted) return;

      await _navigateToChat(
        sessionDoc.id,
        characterId,
        avatarUrl,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '從通知尋找聊天室失敗：$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  // 🌟 3. 新增聊天室專屬的「翻記事本」功能
  Future<void> _checkChatHomeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    // 注意這裡的鑰匙名字不一樣喔！叫做 'seen_chat_home_tips'
    bool hasSeen = prefs.getBool('seen_chat_home_tips') ?? false;

    if (!hasSeen) {
      if (mounted) {
        setState(() {
          _hasChatHomeTipsShown = false; // 允許發射氣泡
        });
      }
      // ✍️ 寫下紀錄，下次不再打擾
      await prefs.setBool('seen_chat_home_tips', true);
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final messageDate = timestamp.toDate();
    if (now.day == messageDate.day && now.month == messageDate.month && now.year == messageDate.year) {
      return DateFormat('HH:mm').format(messageDate);
    } else {
      return DateFormat('M/d').format(messageDate);
    }
  }

  String _formatFullTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('yyyy/M/d HH:mm').format(timestamp.toDate());
  }

  // ✨ 將英文的 chatMode 轉換為多國語言標籤
  String _getModeLabel(String? mode, AppLocalizations l10n) {
    switch (mode) {
      case 'daily': return l10n.chat_mode_daily;
      case 'story': return l10n.chat_mode_story;
      case 'immersive': return l10n.chat_mode_immersive;
      case 'gemini': return l10n.chat_mode_gemini;
      default: return l10n.chat_mode_daily;
    }
  }

  // ✨ 長按修改房間名稱的函式
  Future<void> _renameChatRoom(String sessionId, String currentName) async {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: currentName);

    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.edit_note, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(l10n.rename_chat_title),
            ],
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            maxLength: 20,
            decoration: InputDecoration(
              hintText: l10n.rename_chat_hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelButton, style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () => Navigator.of(context).pop(nameController.text.trim()),
              child: Text(l10n.save_tag_btn),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty && newName != currentName) {
      try {
        await FirebaseFirestore.instance
            .collection('artifacts')
            .doc(_appId)
            .collection('chat_sessions')
            .doc(sessionId)
            .update({
          'customRoomName': newName,
        });
        // 成功時的優雅回饋
        if (mounted) {
          ToastUtils.showCenterToast(
            context,
            l10n.room_name_updated,
            customIcon: Icons.drive_file_rename_outline_rounded, // 💡 總裁精選：對應「修改名稱」的畫筆圖示
          );
        }
      } catch (e) {
        // 失敗時的優雅迫降
        if (mounted) {
          ToastUtils.showCenterToast(
            context,
            l10n.update_failed(e.toString()),
            isError: true, // 💡 使用統一的紅驚嘆號，清楚標示錯誤
          );
        }
      }
    }
  }

  Future<void> _deleteChatRoom(String sessionId, String characterName) async {
    final l10n = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l10n.confirm_delete_title),
          content: Text(l10n.confirm_delete_chat(characterName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.delete_btn,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('chat_sessions')
          .doc(sessionId)
          .delete();

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.delete_success,
        customIcon: Icons.delete_outline_rounded,
      );
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.update_failed(e.toString()),
        isError: true,
      );
    }
  }

  void _precacheVisibleAvatars(
      BuildContext context,
      List<QueryDocumentSnapshot> sessionDocs,
      ) {
    for (final doc in sessionDocs.take(6)) {
      final data = doc.data() as Map<String, dynamic>;
      final imageUrl = data['characterAvatarPath'] as String? ?? '';

      if (imageUrl.isEmpty || _preloadedAvatarUrls.contains(imageUrl)) {
        continue;
      }

      _preloadedAvatarUrls.add(imageUrl);

      precacheImage(
        CachedNetworkImageProvider(imageUrl),
        context,
      ).catchError((error) {
        _preloadedAvatarUrls.remove(imageUrl);
        debugPrint('預載聊天室頭像失敗：$imageUrl，$error');
      });
    }
  }

  Future<void> _togglePinChatRoom({
    required String sessionId,
    required bool isPinned,
  }) async {
    final user = _currentUser;
    if (user == null) return;

    final sessionsRef = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(_appId)
        .collection('chat_sessions');

    try {
      if (!isPinned) {
        // 置頂名額最多 3 個；活動聊天室的 qixiPinnedUntil 不計入玩家名額。
        final snapshot = await sessionsRef
            .where('userId', isEqualTo: user.uid)
            .get();

        final pinnedCount = snapshot.docs.where((doc) {
          final data = doc.data();
          return data['isPinned'] == true;
        }).length;

        if (pinnedCount >= 3) {
          if (!mounted) return;
          ToastUtils.showCenterToast(
            context,
            '最多可置頂 3 個聊天室，請先取消其他置頂聊天室。',
          );
          return;
        }

        await sessionsRef.doc(sessionId).update({
          'isPinned': true,
          'pinnedAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        ToastUtils.showCenterToast(context, '已置頂聊天室');
      } else {
        await sessionsRef.doc(sessionId).update({
          'isPinned': false,
          'pinnedAt': FieldValue.delete(),
        });

        if (!mounted) return;
        ToastUtils.showCenterToast(context, '已取消置頂');
      }
    } catch (e) {
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '更新置頂狀態失敗：$e',
        isError: true,
      );
    }
  }

  Future<void> _showChatRoomOptions({
    required String sessionId,
    required String displayRoomName,
    required String characterName,
    required bool isPinned,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        Widget optionIcon(
            String assetPath, {
              required Color color,
              double size = 32,
            }) {
          return Image.asset(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.contain,
            color: color,
            colorBlendMode: BlendMode.srcIn,
          );
        }

        TextStyle optionTextStyle({
          Color? color,
        }) {
          return GoogleFonts.notoSerifTc(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color ?? theme.colorScheme.onSurface,
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                ListTile(
                  minLeadingWidth: 34,
                  leading: optionIcon(
                    'assets/images/chat/chat_pin_bookmark.png',
                    color: primary,
                  ),
                  title: Text(
                    isPinned ? '取消置頂' : '置頂聊天室',
                    style: optionTextStyle(color: primary),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _togglePinChatRoom(
                      sessionId: sessionId,
                      isPinned: isPinned,
                    );
                  },
                ),
                ListTile(
                  minLeadingWidth: 34,
                  leading: optionIcon(
                    'assets/images/profile/profile_quill.png',
                    color: primary,
                  ),
                  title: Text(
                    l10n.rename_chat_title,
                    style: optionTextStyle(),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _renameChatRoom(sessionId, displayRoomName);
                  },
                ),
                ListTile(
                  minLeadingWidth: 34,
                  leading: optionIcon(
                    'assets/images/chat/chat_msg_delete_mask.png',
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    l10n.delete_btn,
                    style: optionTextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _deleteChatRoom(sessionId, characterName);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Character?> _getCharacterById(String characterId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('artifacts').doc(_appId).collection('public_characters').doc(characterId).get();
      if (doc.exists) return Character.fromFirestoreAsync(doc);

      if (_currentUser != null) {
        doc = await FirebaseFirestore.instance.collection('artifacts').doc(_appId).collection('users').doc(_currentUser!.uid).collection('private_characters').doc(characterId).get();
        if (doc.exists) return Character.fromFirestoreAsync(doc);
      }
      return null;
    } catch (e) {
      print("從聊天首頁獲取角色失敗: $e");
      return null;
    }
  }

  Future<void> _openTopActionPage(Widget page) async {
    if (_isOpeningTopAction || !mounted) return;

    setState(() {
      _isOpeningTopAction = true;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );

    if (!mounted) return;

    setState(() {
      _isOpeningTopAction = false;
    });
  }

  Future<void> _navigateToChat(
      String sessionId,
      String characterId,
      String avatarUrl,
      ) async {
    if (_isNavigatingToChat || !mounted) return;

    setState(() {
      _isNavigatingToChat = true;
    });

    final l10n = AppLocalizations.of(context)!;

    // 頭像預載改成背景執行，不阻擋進入聊天室。
    if (avatarUrl.trim().isNotEmpty) {
      unawaited(_precacheCharacterImage(avatarUrl));
    }

    // 已經有快取時，直接進 ChatPage。
    final cachedCharacter = _characterCache[characterId];
    if (cachedCharacter != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            character: cachedCharacter,
            sessionId: sessionId,
            chatMode: 'daily',
            selectedLanguage: l10n.ai_chat_language,
            characterId: cachedCharacter.id,
          ),
        ),
      );

      if (!mounted) return;
      setState(() {
        _isNavigatingToChat = false;
      });
      return;
    }

    // 沒有快取也不要停在聊天室列表等。
    // 立刻切換頁面，角色資料在新頁面內抓取；
    // 抓取期間只顯示聊天室內的 loading。
    final characterFuture = _getCharacterById(characterId);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChatEntryLoader(
          characterFuture: characterFuture,
          sessionId: sessionId,
          characterId: characterId,
          selectedLanguage: l10n.ai_chat_language,
          onCharacterLoaded: (character) {
            _characterCache[character.id] = character;
          },
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _isNavigatingToChat = false;
    });
  }

  Widget _buildCharacterAvatar({
    required String imageUrl,
    required ThemeData theme,
  }) {
    final normalizedUrl = imageUrl.trim();

    if (normalizedUrl.isEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundColor:
        theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.person_rounded,
          color:
          theme.colorScheme.onSecondaryContainer,
        ),
      );
    }

    return SizedBox(
      width: 56,
      height: 56,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: normalizedUrl,
          width: 56,
          height: 56,

          // 保持原圖比例，再從中央裁成正圓
          fit: BoxFit.cover,
          alignment: Alignment.center,

          // 只限制寬度，不同時強制寬高，
          // 避免非正方形原圖在解碼時看起來被壓扁。
          memCacheWidth: 168,

          filterQuality: FilterQuality.medium,

          placeholder: (context, url) {
            return Container(
              width: 56,
              height: 56,
              color:
              theme.colorScheme.secondaryContainer,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          },

          errorWidget: (context, url, error) {
            return Container(
              width: 56,
              height: 56,
              color:
              theme.colorScheme.secondaryContainer,
              alignment: Alignment.center,
              child: Icon(
                Icons.person_rounded,
                color: theme
                    .colorScheme
                    .onSecondaryContainer,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _precacheCharacterImage(String imageUrl) async {
    if (imageUrl.trim().isEmpty || !mounted) return;

    try {
      await precacheImage(
        CachedNetworkImageProvider(imageUrl),
        context,
      );
    } catch (e) {
      debugPrint('預載角色圖片失敗：$imageUrl，$e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final bool isDefaultTheme =
        themeNotifier.currentThemeEnum == AppTheme.light;
    // 🌟 1. 最外層包上總指揮中心
    return ShowCaseWidget(
        builder: (context) {

          // 🚀 2. 畫面一載入自動發射氣泡 (依照陣列順序：先耳機，再信箱)
          if (!_hasChatHomeTipsShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ShowCaseWidget.of(context).startShowCase([_memoryKey, _mailboxKey]);
            });
            _hasChatHomeTipsShown = true;
          }

          return Scaffold(
            backgroundColor: Colors.transparent, // 底色交給 Stack 裡的 Container
            body: Stack(
              children: [
                // 🌟 1. 妳原本的漸層背景層
                Container(
                  decoration: themeNotifier.currentBackground,
                ),

                // 🌟 2. 主內容層：換成 CustomScrollView 掌管滑動
                CustomScrollView(
                  slivers: [
                    // ✨ 3. 會跟著滑動隱藏的 SliverAppBar
                    SliverAppBar(
                      title: Text(
                        l10n.chat_home_title,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      // 💡 關鍵：給 AppBar 一個微透明或實體底色，卡片往上滑才不會透字重疊！
                      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.95),
                      elevation: 0.0,
                      foregroundColor: theme.colorScheme.onBackground,
                      floating: true,
                      pinned: false,
                      actions: [
                        // (原封不動) 耳機按鈕
                        Showcase(
                          key: _memoryKey,
                          description: l10n.tip_call_memory,
                          child: IconButton(
                            tooltip: l10n.call_memory_tooltip,
                            icon: Image.asset(
                              'assets/images/chat/chat_header_headphones.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                              color: theme.colorScheme.primary,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                            onPressed: () {
                              _openTopActionPage(const CallMemoryPage());
                            },
                          ),
                        ),
                        // (原封不動) 信箱按鈕
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
                              .collection('mailbox')
                              .where('isRead', isEqualTo: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            int unreadCount = 0;
                            if (snapshot.hasData) {
                              unreadCount = snapshot.data!.docs.length;
                            }
                            return IconButton(
                              tooltip: l10n.private_mailbox,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                _openTopActionPage(const NotificationListPage());
                              },
                              icon: Badge(
                                label: null,
                                alignment: const AlignmentDirectional(1.8, -0.8),
                                isLabelVisible: unreadCount > 0,
                                backgroundColor: Colors.pinkAccent,
                                smallSize: 10,
                                child: Showcase(
                                  key: _mailboxKey,
                                  description: l10n.tip_chat_notifications,
                                  child: Transform.scale(
                                    scale: 1.0,
                                    child: Image.asset(
                                      'assets/images/chat/chat_header_paper_plane.png',
                                      width: 36,
                                      height: 36,
                                      color: theme.colorScheme.primary,
                                      colorBlendMode: BlendMode.srcIn,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),

                    // ✨ 4. 處理聊天列表與各種狀態
                    _currentUser == null
                    // 在 Sliver 裡面，要置中畫面必須用 SliverFillRemaining 包起來
                        ? SliverFillRemaining(
                      child: Center(child: Text(l10n.login_to_view_chat)),
                    )
                        : StreamBuilder<QuerySnapshot>(
                      stream: _sessionsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError) {
                          return SliverFillRemaining(
                            child: Center(child: Text(l10n.load_chat_failed(snapshot.error.toString()))),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(l10n.chat_list_empty, style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                                  const SizedBox(height: 8),
                                  Text(l10n.go_to_encounter, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        }

                        final sessionDocs =
                        List<QueryDocumentSnapshot>.from(snapshot.data!.docs);

// 玩家手動置頂優先（最多 3 個），接著才是活動置頂；
                        // 同一區域內仍依最後活動時間排序。
                        sessionDocs.sort((a, b) {
                          final aData = a.data() as Map<String, dynamic>;
                          final bData = b.data() as Map<String, dynamic>;

                          final bool aIsPinned = aData['isPinned'] == true;
                          final bool bIsPinned = bData['isPinned'] == true;

                          if (aIsPinned != bIsPinned) {
                            return aIsPinned ? -1 : 1;
                          }

                          final now = DateTime.now();

                          final aPinnedUntil =
                          aData['qixiPinnedUntil'] as Timestamp?;
                          final bPinnedUntil =
                          bData['qixiPinnedUntil'] as Timestamp?;

                          final bool aIsQixiPinned =
                              aData['isQixiRoom'] == true &&
                                  aPinnedUntil != null &&
                                  now.isBefore(aPinnedUntil.toDate());

                          final bool bIsQixiPinned =
                              bData['isQixiRoom'] == true &&
                                  bPinnedUntil != null &&
                                  now.isBefore(bPinnedUntil.toDate());

                          if (aIsQixiPinned != bIsQixiPinned) {
                            return aIsQixiPinned ? -1 : 1;
                          }

                          final aLastActivity =
                          aData['lastActivity'] as Timestamp?;
                          final bLastActivity =
                          bData['lastActivity'] as Timestamp?;

                          if (aLastActivity == null && bLastActivity == null) {
                            return 0;
                          }
                          if (aLastActivity == null) return 1;
                          if (bLastActivity == null) return -1;

                          return bLastActivity.compareTo(aLastActivity);
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          _precacheVisibleAvatars(context, sessionDocs);
                        });

                        // ✨ 5. 原本的 ListView.builder 完美變身 SliverList
                        return SliverPadding(
                          // 💡 關鍵：SliverAppBar 會自動計算頂部高度，所以不用再加 kToolbarHeight 了！
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                // 👇 以下完全是妳原本的卡片邏輯，一字不漏！
                                final sessionData = sessionDocs[index].data() as Map<String, dynamic>;
                                final sessionId = sessionDocs[index].id;
                                final characterName = sessionData['characterName'] ?? l10n.unknownCharacter;
                                final displayRoomName = sessionData['customRoomName'] ?? characterName;
                                final chatMode = sessionData['chatMode'] ?? 'daily';
                                final unreadCount = sessionData['unreadCount'] ?? 0;
                                final avatarUrl = sessionData['characterAvatarPath'] as String? ?? '';
                                final bool isQixiRoom =
                                    sessionData['isQixiRoom'] == true;
                                final bool isPinned =
                                    sessionData['isPinned'] == true;

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.035),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: isDefaultTheme
                                        ? Colors.white.withValues(alpha: 0.98)
                                        : theme.cardColor.withValues(alpha: 0.88),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.13),
                                        width: 0.9,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () => _navigateToChat(
                                        sessionId,
                                        sessionData['characterId'] as String? ?? '',
                                        sessionData['characterAvatarPath'] as String? ?? '',
                                      ),
                                      onLongPress: () => _showChatRoomOptions(
                                        sessionId: sessionId,
                                        displayRoomName: displayRoomName,
                                        characterName: characterName,
                                        isPinned: isPinned,
                                      ),
                                      child: Stack(
                                        children: [
                                          if (isPinned)
                                            Positioned(
                                              left: 10,
                                              top: 0,
                                              child: Image.asset(
                                                'assets/images/chat/chat_pin_bookmark.png',
                                                width: 28,
                                                height: 36,
                                                fit: BoxFit.contain,
                                                color: theme.colorScheme.primary
                                                    .withValues(alpha: 0.82),
                                                colorBlendMode: BlendMode.srcIn,
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              20,
                                              18,
                                              18,
                                              18,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  children: [
                                                    _buildCharacterAvatar(
                                                      imageUrl: avatarUrl,
                                                      theme: theme,
                                                    ),
                                                    if (unreadCount > 0)
                                                      Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: Container(
                                                          constraints:
                                                          const BoxConstraints(
                                                            minWidth: 18,
                                                            minHeight: 18,
                                                          ),
                                                          padding:
                                                          const EdgeInsets.all(3),
                                                          decoration:
                                                          BoxDecoration(
                                                            color: theme
                                                                .colorScheme.primary,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          alignment:
                                                          Alignment.center,
                                                          child: Text(
                                                            '$unreadCount',
                                                            style: GoogleFonts
                                                                .notoSerifTc(
                                                              color: theme
                                                                  .colorScheme
                                                                  .onPrimary,
                                                              fontSize: 9,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              displayRoomName,
                                                              maxLines: 1,
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: GoogleFonts
                                                                  .notoSerifTc(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                color: theme
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          if (isQixiRoom) ...[
                                                            const SizedBox(width: 6),
                                                            Image.asset(
                                                              'assets/images/qixi_chat_badge.png',
                                                              width: 20,
                                                              height: 20,
                                                              fit: BoxFit.contain,
                                                              errorBuilder: (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                  ) {
                                                                return const SizedBox
                                                                    .shrink();
                                                              },
                                                            ),
                                                          ],
                                                          const SizedBox(width: 8),
                                                          Container(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 9,
                                                              vertical: 4,
                                                            ),
                                                            decoration:
                                                            BoxDecoration(
                                                              color: theme
                                                                  .colorScheme.primary
                                                                  .withValues(
                                                                  alpha: 0.08),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                            ),
                                                            child: Text(
                                                              _getModeLabel(
                                                                chatMode,
                                                                l10n,
                                                              ),
                                                              style: GoogleFonts
                                                                  .notoSerifTc(
                                                                fontSize: 11,
                                                                color: theme
                                                                    .colorScheme
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        '時間：${_formatFullTimestamp(sessionData['lastActivity'] as Timestamp?)}',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: GoogleFonts
                                                            .notoSerifTc(
                                                          fontSize: 13,
                                                          color: theme
                                                              .colorScheme.onSurface
                                                              .withValues(alpha: 0.48),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        sessionData['lastMessage']
                                                            ?.toString() ??
                                                            '',
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: GoogleFonts
                                                            .notoSerifTc(
                                                          fontSize: 13.5,
                                                          color: unreadCount > 0
                                                              ? theme.colorScheme
                                                              .onSurface
                                                              .withValues(
                                                              alpha: 0.72)
                                                              : theme.colorScheme
                                                              .onSurface
                                                              .withValues(
                                                              alpha: 0.48),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      _formatTimestamp(
                                                        sessionData['lastActivity']
                                                        as Timestamp?,
                                                      ),
                                                      style:
                                                      GoogleFonts.notoSerifTc(
                                                        fontSize: 13,
                                                        color: theme
                                                            .colorScheme.onSurface
                                                            .withValues(alpha: 0.48),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    if (sessionData[
                                                    'friendshipScore'] !=
                                                        null)
                                                      Text(
                                                        l10n
                                                            .affection_score_short(
                                                          sessionData[
                                                          'friendshipScore']
                                                              .toString(),
                                                        ),
                                                        style: GoogleFonts
                                                            .notoSerifTc(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: theme
                                                              .colorScheme.primary,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                // 👆 卡片邏輯結束
                              },
                              childCount: sessionDocs.length,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),


              ],
            ),
          );
        }
    );
  }
}

class _ChatEntryLoader extends StatelessWidget {
  final Future<Character?> characterFuture;
  final String sessionId;
  final String characterId;
  final String selectedLanguage;
  final ValueChanged<Character> onCharacterLoaded;

  const _ChatEntryLoader({
    required this.characterFuture,
    required this.sessionId,
    required this.characterId,
    required this.selectedLanguage,
    required this.onCharacterLoaded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return FutureBuilder<Character?>(
      future: characterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: themeNotifier.currentBackground,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                foregroundColor: theme.colorScheme.onSurface,
              ),
              body: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        }

        final character = snapshot.data;

        if (snapshot.hasError || character == null) {
          return Container(
            decoration: themeNotifier.currentBackground,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                foregroundColor: theme.colorScheme.onSurface,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Text(
                    l10n.character_not_found,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.58,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          onCharacterLoaded(character);
        });

        return ChatPage(
          character: character,
          sessionId: sessionId,
          chatMode: 'daily',
          selectedLanguage: selectedLanguage,
          characterId: character.id,
        );
      },
    );
  }
}
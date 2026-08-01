import 'package:flutter/material.dart';
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
  bool _isOpeningChat = false;
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
            '找不到這個角色的聊天室',
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

  Future<void> _showChatRoomOptions({
    required String sessionId,
    required String displayRoomName,
    required String characterName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.edit_note_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(l10n.rename_chat_title),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _renameChatRoom(sessionId, displayRoomName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    l10n.delete_btn,
                    style: const TextStyle(color: Colors.redAccent),
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
    if (_isOpeningChat || _isNavigatingToChat || !mounted) return;

    setState(() {
      _isNavigatingToChat = true;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    Character? character;

    // 先從記憶體快取取得角色資料
    if (_characterCache.containsKey(characterId)) {
      character = _characterCache[characterId];
    } else {
      setState(() {
        _isOpeningChat = true;
      });

      character = await _getCharacterById(characterId);

      if (character != null) {
        _characterCache[characterId] = character;
      }

      if (!mounted) return;

      setState(() {
        _isOpeningChat = false;
      });
    }

    if (character == null) {
      if (!mounted) return;

      setState(() {
        _isNavigatingToChat = false;
        _isOpeningChat = false;
      });

      ToastUtils.showCenterToast(
        context,
        l10n.character_not_found,
        isError: true,
      );

      return;
    }

    // 背景預載聊天室頭像，不阻擋頁面跳轉
    if (avatarUrl.trim().isNotEmpty) {
      unawaited(_precacheCharacterImage(avatarUrl));
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          character: character!,
          sessionId: sessionId,
          chatMode: 'daily',
          selectedLanguage: l10n.ai_chat_language,
          characterId: character.id,
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
                      title: Text(l10n.chat_home_title),
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
                            icon: const Icon(Icons.headphones_outlined, size: 26),
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
                                    scale: 1.6,
                                    child: Image.asset(
                                      'assets/images/love_plane_icon.png',
                                      width: 36,
                                      height: 36,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : theme.colorScheme.onBackground,
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

                        final sessionDocs = snapshot.data!.docs;

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

                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: theme.cardColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                    clipBehavior: Clip.antiAlias,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      leading: Stack(
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
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '$unreadCount',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              displayRoomName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: theme.colorScheme.onSurface,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              _getModeLabel(chatMode, l10n),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: theme.colorScheme.onPrimaryContainer,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          sessionData['lastMessage'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: unreadCount > 0
                                                ? theme.colorScheme.onSurface
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formatTimestamp(sessionData['lastActivity'] as Timestamp?),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: unreadCount > 0
                                                  ? theme.colorScheme.primary
                                                  : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (sessionData['friendshipScore'] != null)
                                            Text(
                                              l10n.affection_score_short(
                                                sessionData['friendshipScore'].toString(),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.pinkAccent,
                                              ),
                                            ),
                                        ],
                                      ),
                                      onTap: () => _navigateToChat(
                                        sessionId,
                                        sessionData['characterId'] as String? ?? '',
                                        sessionData['characterAvatarPath'] as String? ?? '',
                                      ),
                                      onLongPress: () => _showChatRoomOptions(
                                        sessionId: sessionId,
                                        displayRoomName: displayRoomName,
                                        characterName: characterName,
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

                // 🌟 6. 載入遮罩層 (維持不變)
                if (_isOpeningChat)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: Colors.pinkAccent),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(24)
                            ),
                            child: Text(
                                l10n.preparing_chat_room,
                                style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.5)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
    );
  }
}
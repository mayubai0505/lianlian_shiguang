import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // ✨ 引入 Provider
import '../services/theme_notifier.dart'; // ✨ 引入主題背景
import 'chat_page.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/page/inbox_page.dart';
import 'dart:async';
import 'notification_list_page.dart'; // 記得根據妳的資料夾路徑調整
import 'call_memory_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

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
  final String _appId = AppConfig.appId;

  @override
  void initState() {
    super.initState();
    if (_currentUser != null) {
      _sessionsStream = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(_appId)
          .collection('chat_sessions')
          .where('userId', isEqualTo: _currentUser!.uid)
          .orderBy('lastActivity', descending: true)
          .snapshots();
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
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.room_name_updated)));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.update_failed(e.toString()))));
      }
    }
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

  Future<void> _navigateToChat(String sessionId, String characterId) async {
    if (_isOpeningChat || !mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isOpeningChat = true);

    final character = await _getCharacterById(characterId);

    if (!mounted) return;
    setState(() => _isOpeningChat = false);

    if (character != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            character: character,
            sessionId: sessionId,
            chatMode: 'daily',
            selectedLanguage: l10n.ai_chat_language,
            shouldSave: true,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.character_not_found)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.chat_home_title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: theme.colorScheme.onBackground,
        actions: [
          IconButton(
            tooltip: l10n.call_memory_tooltip,
            icon: const Icon(Icons.headphones_outlined, size: 26),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : theme.colorScheme.onBackground,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CallMemoryPage()));
            },
          ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationListPage()));
                },
                icon: Badge(
                  label: null,
                  alignment: const AlignmentDirectional(1.8, -0.8),
                  isLabelVisible: unreadCount > 0,
                  backgroundColor: Colors.pinkAccent,
                  smallSize: 10,
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
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: themeNotifier.currentBackground,
            child: _currentUser == null
                ? Center(child: Text(l10n.login_to_view_chat))
                : StreamBuilder<QuerySnapshot>(
              stream: _sessionsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(l10n.load_chat_failed(snapshot.error.toString())));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.chat_list_empty, style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(l10n.go_to_encounter, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      )
                  );
                }

                final sessionDocs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top + 10, bottom: 20),
                  itemCount: sessionDocs.length,
                  itemBuilder: (context, index) {
                    final sessionData = sessionDocs[index].data() as Map<String, dynamic>;
                    final sessionId = sessionDocs[index].id;
                    final characterName = sessionData['characterName'] ?? l10n.unknownCharacter;
                    final displayRoomName = sessionData['customRoomName'] ?? characterName;
                    final chatMode = sessionData['chatMode'] ?? 'daily';
                    final unreadCount = sessionData['unreadCount'] ?? 0;

                    return Dismissible(
                      key: Key(sessionId),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(l10n.confirm_delete_title),
                              content: Text(l10n.confirm_delete_chat(characterName)),
                              actions: <Widget>[
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton)),
                                TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete_btn, style: const TextStyle(color: Colors.red))),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        await FirebaseFirestore.instance
                            .collection('artifacts')
                            .doc(_appId)
                            .collection('chat_sessions')
                            .doc(sessionId)
                            .delete();
                      },
                      background: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                      ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          // 1. 外層 Container 現在只負責「陰影」
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          // 2. 🌟 總裁補丁：加入 Material 畫布
                          child: Material(
                            color: theme.cardColor.withOpacity(0.8), // 顏色搬到這裡
                            borderRadius: BorderRadius.circular(16), // 圓角搬到這裡
                            clipBehavior: Clip.antiAlias,            // 確保水波紋動畫不會超出圓角範圍！

                            child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(sessionData['characterAvatarPath'] ?? ''),
                                backgroundColor: theme.colorScheme.secondaryContainer,
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                    child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                )
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
                                    // 🌟 總裁補丁：強迫名字文字跟著主題走！
                                    // 用 onSurface 保證文字在深淺色背景上都清晰可見
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // ... 後面是聊天模式標籤 ...
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getModeLabel(chatMode, l10n), // ✨ 傳入翻譯官！
                                  style: TextStyle(fontSize: 10, color: theme.colorScheme.onPrimaryContainer),
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
                              style: TextStyle(color: unreadCount > 0 ? theme.colorScheme.onSurface : Colors.grey),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTimestamp(sessionData['lastActivity'] as Timestamp?),
                                style: TextStyle(fontSize: 12, color: unreadCount > 0 ? theme.colorScheme.primary : Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              if (sessionData['friendshipScore'] != null)
                                Text(l10n.affection_score_short(sessionData['friendshipScore'].toString()), style: const TextStyle(fontSize: 10, color: Colors.pinkAccent)),
                            ],
                          ),
                          onTap: () => _navigateToChat(sessionId, sessionData['characterId'] ?? ''),
                          onLongPress: () => _renameChatRoom(sessionId, displayRoomName),
                        ),
                      ),
                        ),
                    );
                  },
                );
              },
            ),
          ),

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
}
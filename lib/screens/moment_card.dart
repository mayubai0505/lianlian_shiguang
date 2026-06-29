import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../models/moment_model.dart';
import '../services/toast_utils.dart';
import '../widgets/feature_tip_keys.dart';
import '../widgets/feature_tip_target.dart';
import 'comment_bottom_sheet.dart';
import 'edit_moment_page.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'chat_page.dart';
import 'character_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'character_profile_page.dart';

class MomentCard extends StatefulWidget {
  final Moment moment;
  final String currentUserId;
  final bool isDetailView;
  final VoidCallback? onLikeTapped;
  final VoidCallback? onDeleteTapped;
  final VoidCallback? onAvatarTapped;
  final VoidCallback? onEditTapped;
  final bool showFeatureTips;

  const MomentCard({
    super.key,
    required this.moment,
    required this.currentUserId,
    this.isDetailView = false,
    this.onLikeTapped,
    this.onDeleteTapped,
    this.onAvatarTapped,
    this.onEditTapped,
    this.showFeatureTips = false,
  });

  @override
  State<MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isLikeStatusLoading = true;
  bool _isBookmarked = false;

  // 🌟 總裁指令：Moments 的參照路徑也要回歸總部管理！
  DocumentReference get _momentRef => FirebaseFirestore.instance
      .collection('artifacts')
      .doc(AppConfig.appId) // 👈 這裡換成總部 ID
      .collection('moments')
      .doc(widget.moment.id);

  DocumentReference get _likeRef => _momentRef.collection('likes').doc(widget.currentUserId);

  DocumentReference get _bookmarkRef => FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUserId)
      .collection('bookmarks')
      .doc(widget.moment.id);

  @override
  void initState() {
    super.initState();
    _likeCount = widget.moment.likeCount;
    _checkIfLiked();
    _checkIfBookmarked();
  }

  // ✨ 輔助函數：處理不同來源的頭像
  ImageProvider getAvatarImageProvider(String path) {
    if (path.isEmpty) return const AssetImage('assets/images/blank_avatar.png');
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  // --- 邏輯處理區 ---

  Future<void> _checkIfLiked() async {
    try {
      final likeDoc = await _likeRef.get();
      if (mounted) {
        setState(() {
          _isLiked = likeDoc.exists;
          _isLikeStatusLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLikeStatusLoading = false);
    }
  }

  Future<void> _toggleLike() async {
    if (_isLikeStatusLoading) return;

    // 🌟 先抓到總裁的 UID (為了寫進陣列)
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final newLikeState = !_isLiked;

    setState(() {
      _isLiked = newLikeState;
      _likeCount += newLikeState ? 1 : -1;
    });

    if (newLikeState) {
      widget.onLikeTapped?.call(); // 觸發任務進度
    }

    try {
      final batch = FirebaseFirestore.instance.batch();
      if (newLikeState) {
        batch.set(_likeRef, {'likedAt': FieldValue.serverTimestamp()});
        // ✨ 合併魔法：同時增加愛心數，並把名字加入陣列！
        batch.update(_momentRef, {
          'likeCount': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([currentUserId]),
        });
      } else {
        batch.delete(_likeRef);
        // ✨ 合併魔法：同時減少愛心數，並把名字從陣列移除！
        batch.update(_momentRef, {
          'likeCount': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([currentUserId]),
        });
      }
      await batch.commit();
    } catch (e) {
      print("按讚失敗: $e");
      if (mounted) {
        setState(() {
          _isLiked = !newLikeState;
          _likeCount = widget.moment.likeCount;
        });
      }
    }
  }

  Future<void> _checkIfBookmarked() async {
    try {
      final doc = await _bookmarkRef.get();
      if (mounted) setState(() => _isBookmarked = doc.exists);
    } catch (e) {
      print("檢查收藏失敗: $e");
    }
  }

  Future<void> _toggleBookmark() async {
    // 🌟 1. 抓取必要的使用者與 APP ID 資訊
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    final String APP_ID = AppConfig.appId;
    // 🌟 2. 定義這篇貼文在大廳的真實位置
    final momentRef = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('moments')
        .doc(widget.moment.id);

    final newStatus = !_isBookmarked;

    // 🌟 3. 先改變畫面狀態，讓按鈕瞬間變色
    setState(() => _isBookmarked = newStatus);

    try {
      // 🌟 4. 開啟批次處理 (Batch)：兩件事要嘛一起成功，要嘛一起失敗！
      final batch = FirebaseFirestore.instance.batch();

      if (newStatus) {
        // [任務 A]：存進總裁原本寫的個人收藏備份
        batch.set(_bookmarkRef, {
          'bookmarkedAt': FieldValue.serverTimestamp(),
          'momentId': widget.moment.id,
          'authorName': widget.moment.authorName,
          'content': widget.moment.content,
        });

        // [任務 B]：✨ 魔法時刻：把名字刻進大廳貼文的 savedBy 陣列裡！
        batch.update(momentRef, {
          'savedBy': FieldValue.arrayUnion([currentUserId])
        });
      } else {
        // [任務 A]：從個人收藏備份刪除
        batch.delete(_bookmarkRef);

        // [任務 B]：✨ 魔法時刻：把名字從大廳貼文的陣列裡抹除！
        batch.update(momentRef, {
          'savedBy': FieldValue.arrayRemove([currentUserId])
        });
      }

      // 🌟 5. 一口氣送出！
      await batch.commit();

    } catch (e) {
      print("更新收藏紀錄失敗: $e");
      // 萬一網路斷線失敗了，就把畫面變回原本的樣子
      if (mounted) {
        setState(() => _isBookmarked = !newStatus);
      }
    }
  }

  Future<List<Character>> fetchCharactersFromDatabase() async {
    try {
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return [];

      // 1. 先抓取「聊過天」的清單 (決定排序)
      QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .orderBy('lastActivity', descending: true) // 最新的排前面
          .get();

      // 2. 抓取「大廳」所有的公開角色
      QuerySnapshot publicSnapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)// ⚠️ 這裡填妳的 appId
          .collection('public_characters')
          .get();

      // 3. 開始「大團圓」合併邏輯
      Map<String, Character> allUniqueCharacters = {};
      List<String> chatOrder = chatSnapshot.docs.map((doc) => doc.id).toList();

      // A. 先處理大廳所有角色，把它們裝進 Map 備用
      for (var doc in publicSnapshot.docs) {
        Character character = await Character.fromFirestoreAsync(doc);
        allUniqueCharacters[character.id] = character;
      }

      // B. 根據「聊天順序」重新排序
      List<Character> sortedList = [];

      // 先放「聊過天」的角色 (按最後聊天時間排)
      for (String charId in chatOrder) {
        if (allUniqueCharacters.containsKey(charId)) {
          sortedList.add(allUniqueCharacters[charId]!);
        }
      }

      // 再放「還沒聊過」的其他角色
      for (var char in allUniqueCharacters.values) {
        if (!chatOrder.contains(char.id)) {
          sortedList.add(char);
        }
      }

      print("📊 總共找回 ${sortedList.length} 個角色！");
      return sortedList;

    } catch (e) {
      print('❌ 抓取失敗: $e');
      return [];
    }
  }
  // ✨ 2. 更新您的轉發選單
  void _showForwardBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    l10n.moment_forward_title, // 💡 改個標題更有感覺
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),

                Expanded(
                  child: FutureBuilder<List<Character>>(
                    // 🌟 這裡確保妳已經把 fetchCharactersFromDatabase 改成抓「聊天室列表」的版本
                    future: fetchCharactersFromDatabase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('讀取失敗：${snapshot.error}'));
                      }

                      // 💡 如果沒聊過天，給一個溫馨提示
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(l10n.moment_forward_empty_state,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey)
                            ),
                          ),
                        );
                      }

                      final characters = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: characters.length,
                        itemBuilder: (context, index) {
                          final Character char = characters[index];
                          return ListTile(
                            leading: CircleAvatar(
                              // 🌟 改用物件的頭像網址
                              backgroundImage: char.avatarPath.startsWith('http')
                                  ? NetworkImage(char.avatarPath) as ImageProvider
                                  : AssetImage(char.avatarPath),
                            ),
                            title: Text(char.name),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                // 1. 先關閉選單，避免 UI 衝突
                                Navigator.pop(context);

                                final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                                if (currentUserId == null) return;

                                // 🌟 核心定義：統一使用角色 ID 作為房間 ID，解決「讀取回憶失敗」
                                final String targetChatId = '${currentUserId}_${char.id}';
                                final forwardMessage = l10n.moment_forward_template(widget.moment.authorName, widget.moment.content);;
                                String targetSessionId = '${currentUserId}_${char.id}';
                                try {
                                  final String appId = 'lianlianshiguang'; // 🌟 確保這跟妳 ChatPage 裡的 _appId 一樣

                                  // 1. 智慧尋找：這次我們要去 chat_sessions 社區找
                                  final existingChats = await FirebaseFirestore.instance
                                      .collection('artifacts')
                                      .doc(appId)
                                      .collection('chat_sessions')
                                      .where('userId', isEqualTo: currentUserId)
                                      .where('characterId', isEqualTo: char.id)
                                      .get();

                                  if (existingChats.docs.isNotEmpty) {
                                    targetSessionId = existingChats.docs.first.id;
                                  }

                                  // 🌟 C. 溫馨提示：讓玩家知道轉發成功了
                                  if (context.mounted) {
                                    // ✨ 總裁級：心意轉發的專屬浪漫！將粉紅大色塊化為輕柔的中央印記！
                                    ToastUtils.showCenterToast(
                                      context,
                                      l10n.moment_forward_success(char.name),
                                      );
                                  }
                                  // 🌟 2. 核心修正：統一使用 chat_sessions 的路徑
                                  final sessionDocRef = FirebaseFirestore.instance
                                      .collection('artifacts')
                                      .doc(appId)
                                      .collection('chat_sessions')
                                      .doc(targetSessionId);

                                  // A. 點亮門牌 (確保房間基本資料都在)
                                  await sessionDocRef.set({
                                    'userId': currentUserId,
                                    'characterId': char.id,
                                    'characterName': char.name,
                                    'avatarPath': char.avatarPath,
                                    'lastActivity': FieldValue.serverTimestamp(),
                                    'lastMessage': '【轉發了一則動態】',
                                    'chatMode': 'daily',
                                    'friendshipScore': 0, // 如果是新房就給 0，舊房會被 merge 掉
                                  }, SetOptions(merge: true));

                                  // --- B. 寫入妳的轉發訊息 ---
                                  await sessionDocRef.collection('messages').add({
                                    'sender': 'user',
                                    'text': forwardMessage,
                                    'timestamp': FieldValue.serverTimestamp(),
                                    'type': 'text',
                                  });

                                  // 🌟 D. 總裁的背景魔法：偷偷喚醒 AI 大腦！(不跳轉也能回覆)
                                  final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

                                  // 準備給 AI 的包裹 (背景轉發版，簡化歷史記憶)
                                  final Map<String, dynamic> requestBody = {
                                    "audioUrl": "",
                                    "userMessage": forwardMessage, // 把動態內容傳給他
                                    "chatMode": "daily",
                                    "sessionId": targetSessionId,
                                    "userProfile": "這是一則來自玩家動態牆的轉發分享。",
                                    "characterProfile": {
                                      "id": char.id,
                                      "name": char.name,
                                      "toneAndStyle": char.toneAndStyle ?? "",
                                    },
                                    "chatHistory": [], // 背景發送暫時不需要載入太多歷史記憶
                                    "aboutMeNotes": [],
                                  };

                                  // 偷偷打 API 給雲端大腦
                                  final response = await http.post(
                                    Uri.parse('https://asia-east1-lianlianshiguang.cloudfunctions.net/getAiResponse'),
                                    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $idToken'},
                                    body: jsonEncode(requestBody),
                                  );

                                  if (response.statusCode == 200) {
                                    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
                                    if (responseData['status'] == 'success') {
                                      final String requestId = responseData['requestId'];

                                      // 🌟 1. 發給狙擊手一個專屬對講機
                                      StreamSubscription<DocumentSnapshot>? subscription;

                                      // 🌟 2. 戴上對講機出任務
                                      subscription = FirebaseFirestore.instance.collection('users').doc(currentUserId)
                                          .collection('aiRequests').doc(requestId)
                                          .snapshots().listen((snapshot) async {
                                        if (!snapshot.exists) return;
                                        final data = snapshot.data() as Map<
                                            String,
                                            dynamic>;

                                        if (data['status'] == 'completed') {
                                          String rawAiContent = data['response'] ?? "";
                                          String finalDisplayText = rawAiContent;

                                          // 🌟 總裁暴力拆箱 2.0 (專治 AI 各種格式出包)
                                          try {
                                            String cleanedJson = rawAiContent.replaceAll('```json', '').replaceAll('```', '').trim();

                                            // 1. 正常解析 JSON：先鎖定大括號範圍，避免前後有廢話
                                            int startIndex = cleanedJson.indexOf('{');
                                            int endIndex = cleanedJson.lastIndexOf('}');

                                            if (startIndex != -1 && endIndex != -1) {
                                              String jsonString = cleanedJson.substring(startIndex, endIndex + 1);
                                              final parsedData = jsonDecode(jsonString);
                                              finalDisplayText = parsedData['response'] ?? rawAiContent;
                                            }
                                          } catch (e) {
                                            print("❌ 正常拆箱失敗，啟動電鋸暴力拆解: $e");
                                            // 2. 暴力備案：如果 JSON 壞了，直接用語法硬挖 "response": 後面的字！
                                            final match = RegExp(r'"response"\s*:\s*"([\s\S]*?)"(?=\s*(?:,|}|$))').firstMatch(rawAiContent);
                                            if (match != null && match.groupCount >= 1) {
                                              // 把跳脫字元換成真正的換行跟引號
                                              finalDisplayText = match.group(1)!.replaceAll(r'\n', '\n').replaceAll(r'\"', '"');
                                            }
                                          }

                                          if (finalDisplayText.isNotEmpty) {
                                            // 🌟 幫 AI 把洗乾淨的回覆寫進聊天室信箱裡！
                                            await sessionDocRef.collection('messages').add({
                                              'sender': 'ai',
                                              'text': finalDisplayText,
                                              'type': 'text',
                                              'timestamp': FieldValue.serverTimestamp(),
                                            });

                                            // 更新大廳列表的最後對話，這樣玩家在外面也會看到他回覆了！
                                            await sessionDocRef.update({
                                              'lastMessage': finalDisplayText,
                                              'lastActivity': FieldValue.serverTimestamp(),
                                            });
                                          }

                                          // 🌟 任務圓滿達成，狙擊手撤退！(放在 completed 的最後面)
                                          subscription?.cancel();

                                        } else if (data['status'] == 'error') {
                                          // 🌟 萬一 AI 發生錯誤，也要叫狙擊手撤退！
                                          subscription?.cancel();
                                        }
                                      });
                                          }
                                  }
                                } catch (e) {
                                  print("❌ 轉發失敗: $e");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              child: Text(l10n.action_send),
                            ),
                          );
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

  void _showMoreOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              // ✨ 只有本人 (或該動態的親媽) 才能編輯與刪除
              if (widget.moment.createdBy == widget.currentUserId) ...[
                ListTile(
                  leading: const Icon(Icons.edit_note_outlined),
                  title: Text(l10n.moment_edit_title),
                  onTap: () {
                    Navigator.pop(context); // 關掉三個點選單
                    widget.onEditTapped?.call(); // 交給外層處理跳頁
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                  title: Text(
                    l10n.moment_action_delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onDeleteTapped?.call();
                  },
                ),
              ] else ...[
                // 🛡️ 如果是別人的動態，顯示這個
                ListTile(
                  leading: const Icon(Icons.report_problem_outlined),
                  title: Text(l10n.moment_action_report),
                  onTap: () {
                    Navigator.pop(context);
                    // 這裡放檢舉邏輯
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteMoment() async {
    final l10n = AppLocalizations.of(context)!;

    final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.confirm_delete_title),
          content: Text(l10n.moment_delete_permanent_confirm),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton
            )),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child:Text(l10n.delete_btn, style: TextStyle(color: Colors.red))),
          ],
        )
    );
    if (confirm == true) {
      await _momentRef.delete();
    }
  }

  void _onSharePressed() {
    final l10n = AppLocalizations.of(context)!;
    final String appName = l10n.app_name;
// TODO: 等雙平台上架後，把這裡換成真正的商店連結或 Firebase Dynamic Link
    final String appLink = "https://your-app-link.com";

    Share.share(
        l10n.moment_external_share_content(
            appName,
            widget.moment.authorName,
            widget.moment.content,
            appLink
        )
    );
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // ✨✨✨ 關鍵修正：把邏輯放在 return (畫畫面) 的前面！
        final bool isMyPost = widget.moment.createdBy == FirebaseAuth.instance.currentUser?.uid;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(l10n.moment_action_share, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),

              // ✨ 第一個按鈕：我們的智慧私訊/轉發系統
              ListTile(
                leading: Icon(isMyPost ? Icons.send : Icons.reply, color: Colors.pinkAccent),
                title: Text(
                  isMyPost ? l10n.moment_forward_hint : l10n.moment_reply_private(widget.moment.authorName),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context); // 先把原本的選項選單收起來
                  if (isMyPost) {
                    // ✨ 呼叫我們新寫好的底部轉發表單
                    _showForwardBottomSheet(context);
                  } else {
                    // ✨ 總裁級：從動態走向私聊的優雅過場，完美避開聊天室底部的輸入框雷區！
                    ToastUtils.showCenterToast(
                      context,
                      l10n.moment_go_to_chat_msg(widget.moment.authorName),
                      customIcon: Icons.chat_bubble_outline_rounded, // 💡 總裁精選：最直覺的對話氣泡，完美預告接下來的聊天情境！
                    );
                  }
                },
              ),

              // 第二個按鈕：分享到外部 App (LINE, IG 等)
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: Text(l10n.moment_share_to_apps),
                onTap: () {
                  Navigator.pop(context);
                  Share.share(
                      l10n.moment_external_share_content(
                          appName,
                          widget.moment.authorName,
                          widget.moment.content,
                          appLink
                      )
                  );
                  },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✨ 總裁專屬：文字 Tag 智慧解析器
  Widget _buildContentWithMentions(String text, ThemeData theme) {
    // 1. 設定要尋找的目標：@加上非空白字元
    final RegExp mentionRegex = RegExp(r'(@\S+)');
    final Iterable<RegExpMatch> matches = mentionRegex.allMatches(text);

    // 如果沒有任何 @標記，就直接回傳原本單純的 Text，省效能！
    if (matches.isEmpty) {
      return Text(
        text,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
      );
    }

    int currentIndex = 0;
    List<TextSpan> spans = [];

    // 2. 把文字切塊，遇到 @ 就換顏色和加上點擊事件
    for (RegExpMatch match in matches) {
      // 處理 @ 前面的普通文字
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: TextStyle(color: theme.colorScheme.primary, fontSize: 15),
        ));
      }

      // 處理 @ 標記本身
      final String mention = match.group(0)!;
      final String characterName = mention.substring(1); // 把 @ 拿掉，剩下名字 (例如: 程宇)
      spans.add(TextSpan(
        text: mention,
        style: const TextStyle(
          color: Colors.pinkAccent, // ✨ 標記顏色：改成妳喜歡的顏色 (粉紅或藍色)
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // 1. 從動態資料中抓出角色的 ID
            // 在 MomentCard 裡，通常是 widget.moment.authorId
            final String targetId = widget.moment.authorId;
            print("🚀 準備跳轉到角色：$targetId 的個人檔案");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterProfilePage(
                  // ✨ 修正一：傳入要求的 characterId
                  characterId: targetId,

                  // ✨ 修正二：呼叫我們剛剛寫好的全域工具函式
                  // 記得要把前面的底線 _ 拿掉，直接呼叫 getCharacterById 喔！
                  character: getCharacterById(targetId),
                ),
              ),
            );
          },
      ));

      currentIndex = match.end;
    }

    // 處理最後剩下的普通文字
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
      ));
    }

    // 3. 把組裝好的文字碎片用 RichText 顯示出來
    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      // ✅ 毛玻璃透明感：連動玩家自訂的主題
      color: theme.cardColor.withOpacity(isDarkMode ? 0.6 : 0.4),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 使用者資訊區
          ListTile(
            // ✨ 用 GestureDetector 把頭像包起來
            leading: GestureDetector(
              onTap: widget.onAvatarTapped, // 👈 這裡加上跳轉指令！
              child: CircleAvatar(
                backgroundImage: getAvatarImageProvider(widget.moment.authorAvatar),
              ),
            ),
            title: Text(
              widget.moment.authorName,
              style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            subtitle: Text(
              DateFormat('M月d日 HH:mm').format(widget.moment.createdAt.toDate()),
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: _showMoreOptions, // ✨ 更多選項
            ),
          ),

          // 2. 內容文字區
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // ✨ 換成我們的智慧渲染器
            child: _buildContentWithMentions(widget.moment.content, theme),
          ),

          // 🖼️ 3. 照片顯示區
          if (widget.moment.imageUrl != null && widget.moment.imageUrl!.isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.black.withValues(alpha: 0.04),
              constraints: const BoxConstraints(
                maxHeight: 520,
              ),
              child: Image.network(
                widget.moment.imageUrl!,
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  );
                },
              ),
            ),

          // 🕹️ 4. 底部操作區
          if (!widget.isDetailView) ...[
            Row(
              children: [
                FeatureTipTarget(
                  enabled: widget.showFeatureTips,
                  scopeKey: 'moments_page',
                  order: 4,
                  tipKey: '${FeatureTipKeys.postLike}_v3',
                  tipText: '按讚後可在\n喜歡內容查看',

                  // 先改 down，確認它一定看得到
                  direction: FeatureTipDirection.down,

                  top: 56,
                  maxWidth: 148,
                  offset: const Offset(160,-10),
                  arrowOffset: -50,

                  child: IconButton(
                    icon: Icon(
                      _isLiked ? Icons.eco : Icons.eco_outlined,
                      color: _isLiked
                          ? const Color(0xFFAED581)
                          : theme.iconTheme.color,
                    ),
                    onPressed: _toggleLike,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // 🚀 關鍵這行：呼叫我們剛剛寫的底部抽屜！
                    CommentBottomSheet.show(context,widget.moment);
                  },
                ),
                Text('${widget.moment.commentCount}'),
                IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: _onSharePressed,
                ),
                const Spacer(),
                FeatureTipTarget(
                  enabled: widget.showFeatureTips,
                  scopeKey: 'moments_page',
                  order: 3,
                  tipKey: '${FeatureTipKeys.postBookmark}_v3',
                  tipText: '收藏後可在\n「我的收藏」查看',

                  // 先改 down，確認它一定看得到
                  direction: FeatureTipDirection.down,

                  top: 56,
                  maxWidth: 148,
                  offset: const Offset(55, -10),
                  arrowOffset: 55,

                  child: IconButton(
                    icon: Icon(
                      _isBookmarked ? Icons.park : Icons.park_outlined,
                      color: _isBookmarked
                          ? const Color(0xFFA1887F)
                          : theme.iconTheme.color,
                    ),
                    onPressed: _toggleBookmark,
                  ),
                ),
              ],
            ),

            // 📊 5. 數據與文字區
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_likeCount > 0)
                    Text(l10n.moment_likes_label(_likeCount.toString()), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 12), // 給底部留點呼吸空間
                ],
              ),
            ),
          ],

          // 分隔細線
          Container(height: 1, color: theme.dividerColor.withOpacity(0.1)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../models/moment_model.dart';
import '../services/toast_utils.dart';
import 'comment_bottom_sheet.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'character_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:showcaseview/showcaseview.dart'; // 🌟 記得在檔案最上方加上這行
import 'package:shared_preferences/shared_preferences.dart';
import 'feedback_page.dart';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/image_utils.dart';
import '../utils/character_navigator.dart';

class MomentCard extends StatefulWidget {
  final Moment moment;
  final String currentUserId;
  final bool isDetailView;
  final Future<void> Function()? onLikeTapped;
  final VoidCallback? onDeleteTapped;
  final VoidCallback? onAvatarTapped;
  final VoidCallback? onEditTapped;
  final VoidCallback? onHideMomentTapped;
  final VoidCallback? onBlockCharacterTapped;
  final VoidCallback? onDismissFeatureTips;
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
    this.onHideMomentTapped,
    this.onBlockCharacterTapped,
    this.onDismissFeatureTips,
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
  bool _isOpeningMomentAction = false;
  // 🔑 宣告 5 把氣泡追蹤鑰匙 (新增在這裡)
  final GlobalKey _likeKey = GlobalKey();
  final GlobalKey _bookmarkKey = GlobalKey();

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

    // 🌟 原本一大串發射程式碼，現在濃縮成這一行！
    if (widget.showFeatureTips) {
      _checkAndShowTips();
    }
  }

  @override
  void didUpdateWidget(covariant MomentCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.showFeatureTips && widget.showFeatureTips) {
      _checkAndShowTips();
    }
  }

  // ✨✨✨ 新增：卡片專屬的記事本檢查功能.具備緩衝機制的氣泡發射器
  Future<void> _checkAndShowTips() async {
    // 1. 如果外層還沒解鎖，不准發射
    if (!widget.showFeatureTips) return;

    // 🌟 2. 緩衝魔法：給系統 0.3 秒，確保三條線的氣泡動畫已經完全收乾淨了
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    bool hasSeen = prefs.getBool('seen_moment_card_tips') ?? false;

    // 4. 真正發射氣泡！(因為已經延遲過了，不需要再用 addPostFrameCallback，直接射！)
    if (!hasSeen) {
      try {
        ShowCaseWidget.of(context).startShowCase([_likeKey, _bookmarkKey]);
        // 寫下紀錄
        await prefs.setBool('seen_moment_card_tips', true);
      } catch (e) {
        print("⚠️ 找不到 ShowCaseWidget: $e");
      }
    }
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

    final String? currentUserId =
        FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) return;

    final bool newLikeState = !_isLiked;

    setState(() {
      _isLiked = newLikeState;
      _likeCount += newLikeState ? 1 : -1;

      if (_likeCount < 0) {
        _likeCount = 0;
      }
    });

    try {
      final batch =
      FirebaseFirestore.instance.batch();

      if (newLikeState) {
        batch.set(
          _likeRef,
          {
            'likedAt':
            FieldValue.serverTimestamp(),
          },
        );

        batch.update(
          _momentRef,
          {
            'likeCount':
            FieldValue.increment(1),
            'likedBy':
            FieldValue.arrayUnion([
              currentUserId,
            ]),
          },
        );
      } else {
        batch.delete(_likeRef);

        batch.update(
          _momentRef,
          {
            'likeCount':
            FieldValue.increment(-1),
            'likedBy':
            FieldValue.arrayRemove([
              currentUserId,
            ]),
          },
        );
      }

      // 先確定按讚真的寫入成功
      await batch.commit();

      // 只有「新增按讚」才通知外層處理任務
      if (newLikeState) {
        await widget.onLikeTapped?.call();
      }
    } catch (e) {
      debugPrint('❌ 按讚失敗：$e');

      if (!mounted) return;

      setState(() {
        _isLiked = !newLikeState;
        _likeCount =
            widget.moment.likeCount;
      });
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

  Future<List<Character>>
  fetchCharactersFromDatabase() async {
    try {
      final currentUser =
          FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        return [];
      }

      final String currentUserId =
          currentUser.uid;

      // 玩家聊過的角色，依最近聊天排序
      final chatSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .orderBy(
        'lastActivity',
        descending: true,
      )
          .get();

      if (chatSnapshot.docs.isEmpty) {
        return [];
      }

      final List<String> chatCharacterIds =
      chatSnapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.trim().isNotEmpty)
          .toList();

      final List<Character> characters = [];

      for (final characterId
      in chatCharacterIds) {
        try {
          // 先找公開角色
          final publicDoc =
          await FirebaseFirestore.instance
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('public_characters')
              .doc(characterId)
              .get();

          if (publicDoc.exists) {
            characters.add(
              await Character
                  .fromFirestoreAsync(
                publicDoc,
              ),
            );
            continue;
          }

          // 公開區沒有，再找玩家自己的私人角色
          final privateDoc =
          await FirebaseFirestore.instance
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('users')
              .doc(currentUserId)
              .collection(
            'private_characters',
          )
              .doc(characterId)
              .get();

          if (privateDoc.exists) {
            characters.add(
              await Character
                  .fromFirestoreAsync(
                privateDoc,
              ),
            );
          }
        } catch (e) {
          debugPrint(
            '⚠️ 讀取聊天角色失敗：'
                '$characterId，$e',
          );
        }
      }

      debugPrint(
        '📤 可分享動態的聊天角色：'
            '${characters.length} 位',
      );

      return characters;
    } catch (e) {
      debugPrint(
        '❌ 讀取聊天角色列表失敗：$e',
      );

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
                              backgroundImage: getAvatarImageProvider(
                                char.avatarPath,
                              ),
                              backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                            title: Text(char.name),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                // 1. 先關閉選單，避免 UI 衝突
                                Navigator.pop(context);

                                final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                                if (currentUserId == null) return;

                                // 🌟 核心定義：統一使用角色 ID 作為房間 ID，解決「讀取回憶失敗」
                                final forwardMessage = l10n.moment_forward_template(widget.moment.authorName, widget.moment.content);;
                                String targetSessionId = '${currentUserId}_${char.id}';
                                try {
                                  final String appId =
                                      AppConfig.appId;

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

                                  if (mounted) {
                                    ToastUtils.showCenterToast(
                                      this.context,
                                      l10n.moment_forward_success(
                                        char.name,
                                      ),
                                      customIcon:
                                      Icons.send_rounded,
                                    );
                                  }

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
                                    final String rawResponse =
                                    utf8.decode(response.bodyBytes);

                                    debugPrint(
                                      '📦 轉發 AI 原始回傳：$rawResponse',
                                    );

                                    final dynamic decoded =
                                    jsonDecode(rawResponse);

                                    if (decoded is! Map<String, dynamic>) {
                                      debugPrint(
                                        '⚠️ 轉發訊息已送出，但 AI 回傳格式不是物件',
                                      );
                                      return;
                                    }

                                    final Map<String, dynamic> responseData =
                                        decoded;

                                    final String status =
                                    (responseData['status'] ?? '')
                                        .toString()
                                        .trim();

                                    final String requestId =
                                    (responseData['requestId'] ?? '')
                                        .toString()
                                        .trim();

                                    final String directResponse =
                                    (responseData['response'] ?? '')
                                        .toString()
                                        .trim();

                                    if (status != 'success') {
                                      debugPrint(
                                        '⚠️ 轉發訊息已送出，但 AI 請求未成功：'
                                            '$responseData',
                                      );
                                      return;
                                    }

                                    // 有些後端會直接把 AI 回覆放在 response，
                                    // 不一定會提供 requestId。
                                    if (directResponse.isNotEmpty) {
                                      debugPrint('🟠 MomentCard 準備寫入 directResponse');
                                      debugPrint(
                                        '✅ AI 已直接回傳內容，交由既有聊天流程寫入：'
                                            '$directResponse',
                                      );
                                      return;
                                    }
                                    // 沒有 requestId 時不能去監聽 aiRequests，
                                    // 但貼文本身已經成功送進聊天室。
                                    if (requestId.isEmpty) {
                                      debugPrint(
                                        '⚠️ 轉發訊息已送出，但後端沒有回 requestId：'
                                            '$responseData',
                                      );
                                      return;
                                    }

                                    // 🌟 1. 發給狙擊手一個專屬對講機
                                    // 🔒 防止同一個 completed 狀態被處理兩次
                                    bool hasHandledAiResponse = false;
                                    StreamSubscription<DocumentSnapshot>?
                                    subscription;

// 🌟 2. 戴上對講機出任務
                                    subscription = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(currentUserId)
                                        .collection('aiRequests')
                                        .doc(requestId)
                                        .snapshots()
                                        .listen((snapshot) async {
                                      if (!snapshot.exists) return;

                                      final data =
                                      snapshot.data()
                                      as Map<String, dynamic>;

                                      if (data['status'] == 'completed') {
                                        debugPrint('🔵 MomentCard 準備寫入 completed response');
                                        if (hasHandledAiResponse) return;

                                        hasHandledAiResponse = true;
                                        await subscription?.cancel();

                                        debugPrint(
                                          '✅ 轉發 AI 請求已完成，'
                                              '不在 MomentCard 重複寫入訊息',
                                        );

                                        return;
                                      } else if (data['status'] == 'error') {
                                        if (hasHandledAiResponse) {
                                          return;
                                        }

                                        hasHandledAiResponse = true;
                                        await subscription?.cancel();
                                      }
                                    });
                                  } else {
                                    debugPrint(
                                      '⚠️ 轉發訊息已送出，但 AI HTTP 失敗：'
                                          '${response.statusCode} '
                                          '${utf8.decode(response.bodyBytes)}',
                                    );
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

  Future<void> _hideTipsThenRun(Future<void> Function() action) async {
    // 如果已經在執行中，或是畫面已經不在了，就擋掉
    if (_isOpeningMomentAction || !mounted) return;

    widget.onDismissFeatureTips?.call();

    // 🔒 1. 鎖上大門，防止玩家狂點
    setState(() {
      _isOpeningMomentAction = true;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) return;

    try {
      // 🏃‍♂️ 2. 執行你的按讚、收藏或開啟選單動作
      await action();
    } finally {
      // 🔓 3. 魔法修復：不管動作成功還是失敗，最後一定要解鎖！
      if (mounted) {
        setState(() {
          _isOpeningMomentAction = false;
        });
      }
    }
  }

  Future<void> _showMoreOptions() async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet(
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
                // 🛡️ 檢舉此動態
                ListTile(
                  leading: const Icon(Icons.report_problem_outlined),
                  title: Text(l10n.moment_action_report),
                  onTap: () {
                    Navigator.pop(context); // 先關閉底部選單
                    _submitReport();        // 🚀 呼叫我們剛剛寫的真實檢舉函式！
                  },
                ),
// 👁️ 只隱藏這一篇
                // 👁️ 只隱藏這一篇
                ListTile(
                  leading: const Icon(Icons.visibility_off_outlined),
                  title: Text(l10n.hide_moment_title), // ✨ 換成多國語系變數，並移除 const
                  onTap: () {
                    Navigator.pop(context);
                    widget.onHideMomentTapped?.call();
                  },
                ),

// 🚫 封鎖此角色
                ListTile(
                  leading: const Icon(Icons.block_rounded, color: Colors.redAccent),
                  title: Text(
                    l10n.block_char,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onBlockCharacterTapped?.call();
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


  // 🛡️ 真實檢舉寫入功能 (多國語系版)
  Future<void> _submitReport() async {
    final String? reporterId =
        FirebaseAuth.instance.currentUser?.uid;

    if (reporterId == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入後再檢舉貼文',
        isError: true,
      );
      return;
    }

    final result =
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackPage(
          category: ReportCategory.moment,
          lockCategory: true,

          momentId: widget.moment.id,

          // 這裡把貼文內容直接當成被回報內容帶過去
          reportedContent:
          widget.moment.content,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ToastUtils.showCenterToast(
        context,
        '檢舉已送出，我們會進行審核',
        customIcon:
        Icons.flag_outlined,
      );
    }
  }

  Future<void> _onSharePressed() async {
    final l10n = AppLocalizations.of(context)!;
    final String appName = l10n.app_name;

    // 🌟 替換開始：智慧判斷雙平台下載連結
    String appLink = "https://lianlianshiguang.com"; // 預設防呆（給你們的官網）

    if (Platform.isIOS) {
      appLink = "https://apps.apple.com/tw/app/戀戀拾光/id6773677178";
    } else if (Platform.isAndroid) {
      // ⚠️ 記得把下面這個 id= 後面的字，換成你 Android 的套件名稱 (applicationId)
      // 通常長得像 com.yourname.lianlianshiguang，你可以去 android/app/build.gradle 裡找
      appLink = "https://play.google.com/store/apps/details?id=填入你的安卓套件名稱";
    }
    // 🌟 替換結束

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  l10n.moment_action_share,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 第一個按鈕：App 內轉發 / 私訊
              ListTile(
                leading: const Icon(
                  Icons.send_outlined,
                  color: Colors.pinkAccent,
                ),
                title: Text(
                  l10n.moment_forward_hint,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  '選擇一位聊過天的角色分享這則動態',
                ),
                onTap: () {
                  Navigator.pop(context);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;

                    _showForwardBottomSheet(this.context);
                  });
                },
              ),

              // 第二個按鈕：分享到外部 App
              ListTile(
                leading: const Icon(Icons.share, color: Colors.blue),
                title: Text(l10n.moment_share_to_apps),
                // 👇 注意這裡加上了 async
                onTap: () async {

                  // 🌟 1. 總裁級防護：在選單消失前，先抓下這個選單目前的座標！
                  final RenderBox? box = context.findRenderObject() as RenderBox?;

                  // 2. 座標到手後，才安心關閉底部選單
                  Navigator.pop(context);

                  // 3. 呼叫分享，並附上剛剛抓到的座標給 iPad 看
                  await Share.share(
                    l10n.moment_external_share_content(
                      appName,
                      widget.moment.authorName,
                      widget.moment.content,
                      appLink,
                    ),
                    // 🔥 iPad 防崩潰補丁
                    sharePositionOrigin: box != null
                        ? box.localToGlobal(Offset.zero) & box.size
                        : null,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openMentionedCharacter(
      String characterName,
      ) async {
    Map<String, String>? matchedMention;

    for (final mention
    in widget.moment.mentions) {
      if (mention['name'] == characterName) {
        matchedMention = mention;
        break;
      }
    }

    if (matchedMention == null) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '這個標記沒有連結到角色檔案',
        isError: true,
      );
      return;
    }

    final String characterId =
        matchedMention['characterId']
            ?.trim() ??
            '';

    if (characterId.isEmpty) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '找不到角色資料',
        isError: true,
      );
      return;
    }

    await CharacterNavigator.open(
      context,
      characterId: characterId,
      fallbackName: characterName,
    );
  }

  // ✨ 總裁專屬：文字 Tag 智慧解析器
  // ✨ 總裁專屬：文字 Tag 智慧解析器
  Widget _buildContentWithMentions(
      String text,
      ThemeData theme,
      ) {
    // 一般文章文字統一跟隨觀看者的主題色
    final normalTextStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontSize: 15,
    );

    // 尋找 @ 加上非空白字元
    final RegExp mentionRegex = RegExp(r'(@\S+)');
    final Iterable<RegExpMatch> matches = mentionRegex.allMatches(text);

    // 沒有任何 Tag 時，整篇文章仍然跟隨觀看者的主題色
    if (matches.isEmpty) {
      return Text(
        text,
        style: normalTextStyle,
      );
    }

    int currentIndex = 0;
    final List<TextSpan> spans = [];

    // 把文字切塊，遇到 @ 就套用粉紅色與點擊事件
    for (final RegExpMatch match in matches) {
      // Tag 前面的普通文字
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(
              currentIndex,
              match.start,
            ),
          ),
        );
      }

      // Tag 本身
      final String mention = match.group(0)!;
      final String characterName = mention.substring(1);

      spans.add(
        TextSpan(
          text: mention,
          style: const TextStyle(
            color: Colors.pinkAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _openMentionedCharacter(characterName);
            },
        ),
      );

      currentIndex = match.end;
    }

    // Tag 後面剩餘的普通文字
    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
        ),
      );
    }

    // 最外層統一套用一般文章主題色
    // 只有 Tag 會自行覆蓋成粉紅色
    return RichText(
      text: TextSpan(
        style: normalTextStyle,
        children: spans,
      ),
    );
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
              onTap: () {
                _hideTipsThenRun(() async {
                  widget.onAvatarTapped?.call();
                });
              },
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
              onPressed: () {
                _hideTipsThenRun(() => _showMoreOptions());
              },
            ),
          ),

          // 2. 內容文字區
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildContentWithMentions(widget.moment.content, theme),
          ),

          // 🖼️ 3. 照片顯示區
          if (widget.moment.imageUrl != null &&
              widget.moment.imageUrl!.trim().isNotEmpty)
            Container(
              width: double.infinity,
              color: Colors.black.withValues(alpha: 0.04),
              constraints: const BoxConstraints(
                maxHeight: 520,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.moment.imageUrl!.trim(),
                fit: BoxFit.contain,
                width: double.infinity,

                // 限制記憶體解碼尺寸，避免大圖完整塞入 RAM。
                memCacheWidth: 1080,

                placeholder: (context, url) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },

                errorWidget: (context, url, error) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                    ),
                  );
                },
              ),
            ),

          // 🕹️ 4. 底部操作區
          if (!widget.isDetailView) ...[
            Row(
              children: [
                // 🍃 1. 按讚 (有氣泡)
                Showcase(
                  key: _likeKey,
                  description: l10n.tip_post_like ?? '喜歡這則動態嗎？給他一點心意吧！',
                  child: IconButton(
                    icon: Icon(
                      _isLiked ? Icons.eco : Icons.eco_outlined,
                      color: _isLiked ? const Color(0xFFAED581) : theme.iconTheme.color,
                    ),
                    onPressed: () {
                      _hideTipsThenRun(() async => await _toggleLike());
                    },
                  ),
                ),

                // 💬 2. 留言按鈕 (保持不變)
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    _hideTipsThenRun(() async {
                      CommentBottomSheet.show(context, widget.moment);
                    });
                  },
                ),
                Text('${widget.moment.commentCount}'),

                // 📤 3. 分享按鈕 (保持不變)
                IconButton(
                  icon: const Icon(Icons.send_outlined),
                  onPressed: () {
                    _hideTipsThenRun(() => _onSharePressed());
                  },
                ),

                const Spacer(),

                // 🌳 4. 收藏 (有氣泡)
                Showcase(
                  key: _bookmarkKey,
                  description: l10n.tip_post_bookmark ?? '把特別的動態悄悄收進口袋裡。',
                  child: IconButton(
                    icon: Icon(
                      _isBookmarked ? Icons.park : Icons.park_outlined,
                      color: _isBookmarked ? const Color(0xFFA1887F) : theme.iconTheme.color,
                    ),
                    onPressed: () {
                      _hideTipsThenRun(() async => await _toggleBookmark());
                    },
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
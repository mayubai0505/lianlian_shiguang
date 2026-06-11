import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import 'chat_page.dart';
import 'character_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/character_service.dart';
import 'package:cloud_functions/cloud_functions.dart'; // ✨ 就是這一行！
import '../services/translationService.dart';
import 'creator_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui'; // 🌟 為了 ImageFilter
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
//角色卡片內容

class CharacterProfilePage extends StatefulWidget {
  final String? sessionId;
  final Character character;
  final String characterId;
  const CharacterProfilePage({super.key, required this.character,required this.characterId,this.sessionId,});

  @override
  State<CharacterProfilePage> createState() => _CharacterProfilePageState();
}

// ✨ 加上 SingleTickerProviderStateMixin 才能使用 TabController
class _CharacterProfilePageState extends State<CharacterProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // ✨ 總裁新增：用來控制「加好友」狀態與讀取動畫
  bool _isFriend = false;
  bool _isFriendLoading = false;
  bool _hasLiked = false;
  bool _isNavigating = false;
  bool _isFollowing = false; // 放在 State 類別的最上方
  // 🌟 總裁指令：不管是大寫還是小寫，通通都要聽 AppConfig 的話！
  final String APP_ID = AppConfig.appId;
  bool _isTranslating = false;
  String? _translatedBackground;
  List<String>? _translatedLikes;
  List<String>? _translatedDislikes;
  List<String>? _translatedTags;
  final LoreTranslateService _loreTranslateService = LoreTranslateService();
  String _playerNickname = '旅人';
  String _currentUserId = "";
  // 🌟 用來存每一則迴音的翻譯結果：key 是 docId，value 是翻譯後的文字
  Map<String, String> _translatedEchoes = {};
// 🌟 用來存哪些迴音正在翻譯中，好顯示小蝴蝶
  Set<String> _translatingEchoIds = {};
  // 動態判斷代名詞 (總裁神邏輯)
  String get _pronoun {
    final l10n = AppLocalizations.of(context)!;
    // ✨ 順便把女生也換成多國語言判斷，這樣最安全！(假設妳的翻譯包裡有 genderFemale)
    if (widget.character.gender.contains(l10n.genderFemale)) return '她';
    if (widget.character.gender.contains(l10n.genderMale)) return '他';
    return '它';
  }

  // 判斷當前使用者是不是創作者
  bool get _isCreator {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == widget.character.createdBy;
  }

  @override
  void initState() {
    super.initState();

    // 1. 同步的初始化（不牽涉 context 或 async 的）可以放外面
    _tabController = TabController(length: 3, vsync: this);

    // 2. ✨ ✨ ✨ 魔法包裝：確保在第一幀畫面畫完後才執行
    // 這能解決 dependOnInheritedWidget 的報錯（因為這時 context 已經準備好了）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchCurrentPlayerName();
        _autoRecordEncounter();
        _checkIfLiked();
        _checkIfFriend();
        _migrateLegacyAffection(); // 啟動搬家小精靈
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 🌟 3. 核心函式：去 Firestore 抓取目前玩家的資料
  Future<void> _fetchCurrentPlayerName() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _currentUserId = user.uid;
        // 去 users 集合抓取這則 UID 的文件
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            // 抓取妳資料庫裡存暱稱的欄位（假設叫 'nickname'）
            _playerNickname = userDoc.data()?['nickname'] ?? l10n.default_new_player;
          });
        }
      }
    } catch (e) {
      print("抓取玩家暱稱失敗: $e");
    }
  }

  Future<void> _translateProfile(String targetLang) async {
    setState(() => _isTranslating = true);

    try {
      final String sourceBackground = widget.character.background;
      final String sourceLikes = widget.character.likes;
      final String sourceDislikes = widget.character.dislikes;

      // 把要翻譯的東西打包
      final results = await Future.wait([
        FirebaseFunctions.instanceFor(region: 'asia-east1').httpsCallable(
            'translateText').call({
          'text': sourceBackground,
          'targetLanguage': targetLang,
        }),
        FirebaseFunctions.instanceFor(region: 'asia-east1').httpsCallable(
            'translateText').call({
          'text': '$sourceLikes | $sourceDislikes', // 用特殊符號隔開一起翻比較省錢
          'targetLanguage': targetLang,
        }),
      ]);

      final String newBg = results[0].data['translatedText'];
      final String likesAndDislikes = results[1].data['translatedText'];
      final parts = likesAndDislikes.split('|');

      // ✨【方案 B 核心】：寫回 Firestore
      final charDocRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id);

      await charDocRef.set({
        'translations': {
          targetLang: {
            'background': newBg,
            'likes': parts[0].trim(),
            'dislikes': parts.length > 1 ? parts[1].trim() : '',
          }
        }
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _translatedBackground = newBg;
          _translatedLikes = [parts[0].trim()];
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isTranslating = false);
      print("翻譯詳情失敗: $e");
    }
  }

  // ✨ 2. 新增這個查詢函式 (把它放在 initState 下面)
  Future<void> _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 去角色的肚子裡，找一個叫做 likers (按讚者) 的名單，看這玩家在不在裡面
      final doc = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('likers')
          .doc(user.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _hasLiked = true; // 名單裡有他！把愛心亮起來！
        });
      }
    } catch (e) {
      print("檢查按讚狀態失敗: $e");
    }
  }

  // ==========================================
  // 🫂 總裁新增：好友/聯絡人系統邏輯
  // ==========================================

  // ✨ 1. 檢查是否已經是好友
  Future<void> _checkIfFriend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 💡 總裁提醒：請將 'added_friends' 換成妳實際存好友的集合名稱！
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('friends') // 👈 這裡！
          .doc(widget.character.id)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _isFriend = true; // 已經加過了，點亮按鈕！
        });
      }
    } catch (e) {
      print("檢查好友狀態失敗: $e");
    }
  }

  // ✨ 2. 按鈕點擊：切換好友狀態 (新增/移除)
  Future<void> _toggleFriendStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    if (user == null) return;

    // 啟動按鈕的轉圈圈動畫，防止玩家連點
    setState(() => _isFriendLoading = true);

    try {
      // 💡 總裁提醒：一樣要注意這裡的集合名稱！
      final friendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('friends') // 👈 這裡！
          .doc(widget.character.id);

      if (_isFriend) {
        // ❌ 原本是好友 -> 執行刪除
        try {
          // 1. 執行刪除指令
          await friendRef.delete();

          // 2. 只有在刪除成功後，才更新 UI 與提示
          if (mounted) {
            setState(() {
              _isFriend = false; // 按鈕變回「加好友」狀態
            });

            ToastUtils.showCenterToast(
              context,
              l10n.snackbar_friend_removed(widget.character.name), // 確保妳的 l10n 檔案裡有定義這個 Key
              customIcon: Icons.person_remove_rounded,
            );
          }
        } catch (e) {
          // 3. 🛡️ 防禦工事：如果資料庫刪除失敗，優雅地報錯，不讓玩家誤以為刪成功了
          print("❌ 刪除好友失敗: $e");
          if (mounted) {
            ToastUtils.showCenterToast(
              context,
              "刪除失敗，請檢查網路後再試", // 這裡可以用 l10n.common_delete_failed
              isError: true,
            );
          }
        }
      }else {
        // 💖 原本不是好友 -> 執行新增
        await friendRef.set({
          'characterId': widget.character.id,
          'characterName': widget.character.name, // 順便存個名字，以後列表好讀取
          'addedAt': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          setState(() => _isFriend = true);
          ToastUtils.showCenterToast(
            context,
            l10n.snackbar_friend_added(widget.character.name),
            customIcon: Icons.person_add_alt_1_rounded,
          );
        }
      }
    } catch (e) {
      print("切換好友狀態失敗: $e");
      if (mounted) {
        ToastUtils.showCenterToast(context, '操作失敗，請稍後再試', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isFriendLoading = false); // 關閉轉圈圈
      }
    }
  }

  Future<void> _migrateLegacyAffection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String userId = user.uid;
    final String charId = widget.character.id;

    // 1. 先看總帳是不是已經有分數了
    final globalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('characters')
        .doc(charId);

    final globalDoc = await globalRef.get();
    if (!mounted) return;
    // 💡 如果已經有分數（大於 0），我們就不動它
    if (globalDoc.exists && (globalDoc.data()?['affection'] ?? 0) > 0) return;

    // 2. 去所有房間找這個角色的最高分
    final sessionsSnapshot = await FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('chat_sessions')
        .where('userId', isEqualTo: userId)
        .where('characterId', isEqualTo: charId)
        .get();
    if (!mounted) return;
    if (sessionsSnapshot.docs.isNotEmpty) {
      // 找出所有房間裡最高的那個分數
      int highest = 0;
      for (var doc in sessionsSnapshot.docs) {
        int score = doc.data()['friendshipScore'] ?? 0;
        if (score > highest) highest = score;
      }

      if (highest > 0) {
        // 3. 領出來，存進總帳！
        await globalRef.set({
          'affection': highest,
          'characterName': widget.character.name,
          'lastUpdate': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        print("✅ 成功幫總裁追回舊好感度：$highest 分！");
      }
    }
  }

  Future<void> _autoRecordEncounter() async {
    try {
      await CharacterService.recordEncounter({
        'id': widget.character.id,
        'name': widget.character.name,
        'avatar': widget.character.galleryPaths.isNotEmpty ? widget.character
            .galleryPaths[0] : '',
        'desc': widget.character.background,
      });
    } catch (e) {
      print("紀錄足跡失敗: $e");
    }
  }

  Future<void> _translateSingleEcho(String docId, String content) async {
    final l10n = AppLocalizations.of(context)!;
    // 1. 如果已經翻譯過了，就不用再翻，直接清除翻譯（點第二次可以切換回原文）
    if (_translatedEchoes.containsKey(docId)) {
      setState(() => _translatedEchoes.remove(docId));
      return;
    }

    // 2. 顯示讀取中 🦋
    setState(() => _translatingEchoIds.add(docId));

    try {
      print("🌐 正在為翻譯時空迴音: $content");

      // 🚀 這裡呼叫妳的 Grok / OpenAI API
      // 為了示範，我們先寫一個模擬翻譯，總裁之後要把這裡換成真正的 API 呼叫
      await Future.delayed(const Duration(milliseconds: 800)); // 模擬網路延遲
      // 假設這是 AI 回傳的感性譯文
      String translatedText = l10n.chat_translation_prefix(content);      // 3. 更新翻譯結果
      if (mounted) {
        setState(() {
          _translatedEchoes[docId] = translatedText;
        });
      }
    } catch (e) {
      debugPrint("🔴 迴音翻譯失敗: $e");
    } finally {
      // 4. 停止讀取
      if (mounted) {
        setState(() => _translatingEchoIds.remove(docId));
      }
    }
  }

  void _handleLike() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    // 🛑 防禦機制 1：創作者不能按自己的讚
    if (_isCreator) {
      // ✨ 總裁級：溫柔的遊戲規則提醒，取代冰冷的系統警告！
      ToastUtils.showCenterToast(
        context,
        l10n.like_own_char_warning,
        customIcon: Icons.front_hand_rounded, // 給個「等等，請停手」的可愛圖示，或用 Icons.info_outline
      );
      return;
    }
    // ✨ 紀錄原本的狀態 (用來判斷現在是要「按讚」還是「收回」)
    final bool wasLiked = _hasLiked;
    // 💡 樂觀更新：不管網路多慢，畫面上的愛心先秒切換，讓玩家覺得超順暢！
    setState(() => _hasLiked = !wasLiked);
    try {
      final charRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id);
      // 這是玩家專屬的「簽到簿」
      final likerRef = charRef.collection('likers').doc(user.uid);
      final batch = FirebaseFirestore.instance.batch();
      if (!wasLiked) {
        // 1. 抓取玩家暱稱
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final playerName = userDoc.data()?['nickname'] ?? user.displayName ??
           l10n.chat_mysterious_player;

        // 2. 總讚數 +1
        batch.update(charRef, {'likesCount': FieldValue.increment(1)});

        // 3. 登記到「已按讚名單」
        batch.set(likerRef, {
          'timestamp': FieldValue.serverTimestamp(),
        });

        // 4. 發送通知給創作者
        final notificationRef = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.character.createdBy)
            .collection('mailbox')
            .doc();

        batch.set(notificationRef, {
          'type': 'like',
          'title': l10n.char_exclusive_guardian,
          'body': l10n.mailbox_like_body(playerName, widget.character.name),
          'fromUserId': user.uid,
          'characterId': widget.character.id,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await batch.commit(); // 🚀 送出包裹

        if (mounted) {
          // ✨ 總裁級：點讚成功的極致回饋！一行程式碼搞定圖示加文字！
          ToastUtils.showCenterToast(
            context,
            l10n.like_success_msg,
            customIcon: Icons.favorite, // 直接傳入愛心圖示，工具會幫你排得漂漂亮亮
          );
        }
      } else {
        // 1. 總讚數 -1 (偷偷扣回來)
        batch.update(charRef, {'likesCount': FieldValue.increment(-1)});

        // 2. 把玩家從「已按讚名單」裡擦掉
        batch.delete(likerRef);

        await batch.commit(); // 🚀 送出包裹

        if (mounted) {
          // ✨ 總裁級：收回讚的優雅提示，輕巧不留痕跡！
          ToastUtils.showCenterToast(
            context,
            l10n.unlike_success_msg,
            customIcon: Icons.favorite_border, // 💡 用空心愛心完美暗示「讚已收回」的狀態！
          );
        }
      }
    } catch (e) {
      // 🚨 如果網路異常導致寫入失敗，就把畫面的愛心「退回」原本的樣子，避免畫面跟資料庫不同步
      if (mounted) setState(() => _hasLiked = wasLiked);
      print("按讚切換失敗: $e");
    }
  }

  void _navigateToCreatorProfile() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) =>
          CreatorProfilePage(
            creatorId: widget.character.createdBy,
            creatorName: widget.character.creatorName,
            characterId: widget.character.id,
          ),
    ));
  }

  void _handleFollow() async {
    // 🔒 防禦機制：如果已經關注了，直接擋掉，不要再寄信！
    if (_isFollowing) return;

    // ⚡ 瞬間反應：先讓畫面的按鈕變灰打勾，玩家體驗最好！
    setState(() {
      _isFollowing = true;
    });
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    String playerName = _playerNickname;
    String creatorId = widget.character.createdBy;
    // 寄信給創作者
    await FirebaseFirestore.instance
        .collection('users')
        .doc(creatorId)
        .collection('mailbox')
        .add({
      'type': 'follow',              // 🦋 只存代碼，讓信箱去翻譯
      'fromName': _playerNickname,   // 🦋 把找不到的 myName 換成 _playerNickname
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    if (mounted) {
      // ✨ 總裁級：追蹤創作者的專屬提示，讓建立連結的瞬間充滿質感！
      ToastUtils.showCenterToast(
        context,
        l10n.followed_creator_msg(widget.character.creatorName),
        customIcon: Icons.person_add_alt_1_rounded, // 💡 用帶有「+」號的人物圖示，完美傳達「加入追蹤」的意象！
      );
    }
  }

  void _showDislikeDialog() {
    final l10n = AppLocalizations.of(context)!;

    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          // 💡 注意：這裡的 const 被我拆到裡面的 Icon 和 SizedBox 去了
          title: Row(children: [
            const Icon(Icons.sentiment_very_dissatisfied, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Text(l10n.dislike_dialog_title) // ✨ 替換：不太喜歡這個角色？
          ]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.dislike_dialog_subtitle, // ✨ 替換：請偷偷告訴我們原因...
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: l10n.dislike_hint, // ✨ 替換：設定太無聊、圖片不適合...
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)))),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancelButton, // 這個總裁原本就寫得很完美了！
                    style: const TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white),
              onPressed: () async {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) return;
                Navigator.pop(context);
                if (mounted) {
                  // ✨ 總裁級：低調且專業的「收到回饋」確認！
                  ToastUtils.showCenterToast(
                    context,
                    l10n.dislike_thanks,
                    customIcon: Icons.feedback_outlined, // 💡 總裁細節：用「意見回饋」的圖示，比直接放一個倒讚 (thumb_down) 讓人感覺更舒服且被尊重！
                  );
                }
                await FirebaseFirestore.instance
                    .collection('admin_feedback')
                    .add({
                  'type': 'character_dislike',
                  'characterId': widget.character.id,
                  'reporterId': FirebaseAuth.instance.currentUser?.uid ??
                      'unknown',
                  'reason': reason,
                  'timestamp': FieldValue.serverTimestamp(),
                });
              },
              child: Text(l10n.dislike_submit), // ✨ 替換：悄悄送出
            ),
          ],
        );
      },
    );
  }

  // 📢 檢舉時空迴響 (包含原因選擇)
  Future<void> _reportEcho(String echoId) async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1. 準備常見的檢舉選項
    final List<String> reportOptions = [
      l10n.report_opt_1,
      l10n.report_opt_2,
      l10n.report_opt_3,
      l10n.report_opt_4,
      l10n.report_opt_5
    ];

    // 2. 跳出帶有單選按鈕的彈窗
    String? selectedReason = await showDialog<String>(
      context: context,
      builder: (BuildContext c) {
        String? tempReason; // 暫存玩家選中的原因
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:Text(l10n.report_title),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.report_subtitle, style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 12),
                    // 產生單選列表
                    ...reportOptions.map((reason) {
                      return RadioListTile<String>(
                        title: Text(reason, style: const TextStyle(fontSize: 14)),
                        value: reason,
                        groupValue: tempReason,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() => tempReason = value);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c, null), child:Text(l10n.cancel, style: TextStyle(color: Colors.grey))),
                TextButton(
                  // 🌟 如果沒選原因，按鈕就會反灰不能按
                  onPressed: tempReason == null ? null : () => Navigator.pop(c, tempReason),
                  child: Text(
                      l10n.report_confirm,
                      style: TextStyle(
                          color: tempReason == null ? Colors.grey[300] : Colors.redAccent,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    // 如果玩家按了取消，或是沒選原因就關掉彈窗，就中斷執行
    if (selectedReason == null) return;

    // 3. 寫入檢舉紀錄到 Firebase
    try {
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('echoes')
          .doc(echoId)
          .update({
        'reportCount': FieldValue.increment(1),
        'reporters': FieldValue.arrayUnion([user.uid]),
        // 🌟 新增：把玩家選的原因也存進陣列裡！
        'reportReasons': FieldValue.arrayUnion(['${user.uid.substring(0, 5)}: $selectedReason']),
      });

      if (mounted) {
        // ✨ 總裁級：檢舉成功的安心回饋，讓玩家知道我們有在保護社群！
        ToastUtils.showCenterToast(
          context,
          l10n.report_success,
          customIcon: Icons.shield_outlined, // 💡 總裁細節：使用「安全盾牌」圖示，傳遞滿滿的保護與安心感！
        );
      }
    } catch (e) {
      print("檢舉失敗: $e");
      if (mounted) {
        // ✨ 總裁級：檢舉失敗的輕量錯誤提示，用紅驚嘆號俐落告知！
        ToastUtils.showCenterToast(
          context,
          l10n.report_failed,
          isError: true, // 💡 總裁細節：開啟錯誤狀態，讓系統自動帶上紅色的小驚嘆號
        );
      }
    }
  }

  // ✨ 專屬的「刪除記憶碎片」功能與確認彈窗
  Future<void> _deleteLore(String loreId) async {
    // 🛡️ 總裁防呆機制：彈出警告視窗，防止手滑
    final l10n = AppLocalizations.of(context)!;
    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text(l10n.lore_delete_title),
          content: Text(l10n.lore_delete_content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // 點取消回傳 false
              child: Text(l10n.lore_delete_cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pop(context, true), // 點確定回傳 true
              child:Text(l10n.lore_delete_confirm, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ) ?? false; // 如果點擊對話框外面關閉，預設也是 false
    // 如果玩家沒有點擊確定，就直接終止動作
    if (!confirm) return;
    try {
      // 🌟 瞄準目標，發射刪除指令！
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character!.id) // 指向這個角色
          .collection('lores')
          .doc(loreId) // 🎯 瞄準這個碎片
          .delete();

      if (mounted) {
        // ✨ 總裁級：刪除記憶成功的優雅提示，輕盈且不留痕跡
        ToastUtils.showCenterToast(
          context,
          l10n.lore_delete_success,
          customIcon: Icons.auto_delete_outlined, // 💡 使用帶有科技感或魔法感的刪除圖示，非常符合「清除記憶」的意境！
        );
      }
    } catch (e) {
      print("刪除記憶失敗: $e");
      if (mounted) {
        // ✨ 總裁級：刪除失敗的輕量錯誤提示，用紅驚嘆號俐落接住例外狀況！
        ToastUtils.showCenterToast(
          context,
          l10n.common_delete_failed_with_err(e.toString()),
          isError: true,
        );
      }
    }
  }

  // ✨ 專屬的「新增記憶碎片」彈窗
  void _showAddLoreDialog(BuildContext context, ThemeData theme) {
    // 🌟 全新的空白輸入框
    final titleController = TextEditingController();
    final teaserController = TextEditingController();
    final contentController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    bool isHidden = false; // 預設公開
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(l10n.lore_add_title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: l10n.lore_title_label, hintText: l10n.lore_title_hint),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: teaserController,
                      decoration: InputDecoration(labelText: l10n.lore_teaser_label, hintText:l10n.lore_teaser_hint),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      decoration:InputDecoration(labelText: l10n.lore_content_label, hintText:l10n.lore_content_hint),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 12),
                    // 鎖定設定
                    CheckboxListTile(
                      title:  Text(l10n.lore_lock_label),
                      subtitle: Text(l10n.lore_lock_desc),
                      value: isHidden,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          isHidden = value ?? false;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();

                    if (title.isEmpty || content.isEmpty) {
                      // ✨ 總裁級防呆：直接用輕量錯誤提示抓住玩家眼球
                      ToastUtils.showCenterToast(context, l10n.lore_empty_error, isError: true);
                      return;
                    }

                    // 關閉 Dialog
                    Navigator.pop(context);

                    try {
                      // 🌟 關鍵新增：使用 .add() 創建一筆全新資料
                      await FirebaseFirestore.instance
                          .collection('artifacts')
                          .doc(AppConfig.appId)
                          .collection('public_characters')
                          .doc(widget.character!.id) // 指向這個角色
                          .collection('lores')
                          .add({
                        'title': title,
                        'teaser': teaserController.text.trim(),
                        'content': content,
                        'isHidden': isHidden,
                        // 🌟 注意：因為妳讀取時是用 orderBy('timestamp')，所以這裡一定要存 timestamp！
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      // 💡 總裁細節：因為前面有 await 加上關閉了 Dialog，這裡務必檢查 mounted
                      if (context.mounted) {
                        // ✨ 總裁級：發布成功的優雅回饋，告別綠色大色塊！
                        ToastUtils.showCenterToast(
                          context,
                          l10n.lore_add_success,
                          customIcon: Icons.library_add_check_rounded, // 💡 用一個代表「成功收錄/發布」的精緻圖示
                        );
                      }
                    } catch (e) {
                      print('新增碎片失敗: $e');
                      if (context.mounted) {
                        // ✨ 總裁級：發布失敗的輕量錯誤提示，告別紅色大色塊！
                        ToastUtils.showCenterToast(
                          context,
                          l10n.common_add_failed,
                          isError: true,
                        );
                      }
                    }
                  },
                  child: Text(l10n.lore_publish),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 🗑️ 刪除時空迴響 (作者本人或管理員)
  Future<void> _deleteEcho(DocumentSnapshot doc) async {
    final l10n = AppLocalizations.of(context)!;
    // 1. 跳出確認視窗防手滑
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.echo_delete_title),
        content:Text(l10n.echo_delete_content),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child:Text(l10n.echo_keep)),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.delete_btn, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 2. 執行刪除動作
    try {
      await doc.reference.delete(); // 直接對著這份文件的地址按下刪除鍵
      if (mounted) {
        // ✨ 總裁級：清除回音成功的優雅提示，輕盈地拂去痕跡
        ToastUtils.showCenterToast(
          context,
          l10n.echo_clear_success,
          customIcon: Icons.delete_sweep_rounded, // 💡 總裁細節：用「輕輕掃去」的圖示，比生硬的垃圾桶更符合 Echo 消散的詩意！
        );
      }
    } catch (e) {
      print("${l10n.delete_failed_msg}: $e");
      if (mounted) {
        // ✨ 總裁級：網路異常導致刪除失敗的輕量錯誤提示
        ToastUtils.showCenterToast(
          context,
          l10n.delete_failed_network,
          isError: true, // 💡 直接帶出小紅驚嘆號，俐落告知玩家網路卡住了
        );
      }
    }
  }

  // ✨ 新增時空迴音 (便條貼) 彈窗
  void _showAddEchoDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    print("🌌 正在存取的時空迴響路徑: artifacts/${AppConfig
        .appId}/public_characters/${widget.character.id}/echoes");
    // 1. 檢查數量是否已達 3 則上限
    final echoesRef = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(
        AppConfig.appId)
        .collection('public_characters')
        .doc(widget.character.id)
        .collection('echoes');
    final myEchoes = await echoesRef.where('userId', isEqualTo: user.uid).get();
    if (myEchoes.docs.length >= 3 && mounted) {
      showDialog(
        context: context,
        builder: (c) =>
            AlertDialog(
              title:Text(l10n.echo_energy_full_title),
              content:Text(
                  l10n.echo_energy_full_content),
              actions: [
                TextButton(onPressed: () => Navigator.pop(c),
                    child: Text(l10n.common_got_it))
              ],
            ),
      );
      return;
    }

    // 2. 數量沒滿，彈出新增視窗
    if (!mounted) return;
    String selectedTheme = 'butterfly';
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✨ 關鍵 1：必須設為 true，彈窗才能隨鍵盤往上頂
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            // ✅ 這裡要回傳 GestureDetector，並把屬性寫在它裡面
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // 點擊收起鍵盤
              behavior: HitTestBehavior.opaque, // 確保透明處也能點擊
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom, // 避開鍵盤
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  // ✨ 關鍵 3：用 SingleChildScrollView 包起來，萬一螢幕太小還能捲動
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 讓內容只佔用必要空間
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.echo_write_title, style: theme.textTheme
                            .titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(l10n.echo_write_subtitle, style: TextStyle(
                            fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: textController,
                          maxLines: 3, // 稍微縮減一點行數，留給鍵盤空間
                          maxLength: 100,
                          decoration:InputDecoration(hintText: l10n.echo_hint,
                              border: OutlineInputBorder()
                          ),
                        ),

                        const SizedBox(height: 16),
                       Text(l10n.echo_theme_label, style: TextStyle(
                            fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        // 主題選擇器
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildThemeSelector('butterfly',
                                Text('🦋', style: TextStyle(fontSize: 24)),
                                l10n.theme_butterfly, selectedTheme, () =>
                                    setModalState(() =>
                                    selectedTheme = 'butterfly')),
                            _buildThemeSelector('sprout', Icon(Icons.eco,
                                color: selectedTheme == 'sprout' ? theme
                                    .colorScheme.primary : Colors.grey), l10n.theme_sprout,
                                selectedTheme, () =>
                                    setModalState(() =>
                                    selectedTheme = 'sprout')),
                            _buildThemeSelector('star', Icon(Icons.star_border,
                                color: selectedTheme == 'star' ? theme
                                    .colorScheme.primary : Colors.grey), l10n.theme_star,
                                selectedTheme, () =>
                                    setModalState(() =>
                                    selectedTheme = 'star')),
                            _buildThemeSelector('planet', Icon(Icons.public,
                                color: selectedTheme == 'planet' ? theme
                                    .colorScheme.primary : Colors.grey), l10n.theme_planet,
                                selectedTheme, () =>
                                    setModalState(() =>
                                    selectedTheme = 'planet')),
                          ],
                        ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16)),
                            onPressed: () async {
                              if (textController.text
                                  .trim()
                                  .isEmpty) return;
                              Navigator.pop(context);
                              // 儲存到 Firestore
                              await echoesRef.add({
                                'userId': user.uid,
                                'content': textController.text.trim(),
                                'theme': selectedTheme,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                              // 無感點讚機制
                              try {
                                await FirebaseFirestore.instance
                                    .collection(
                                    'artifacts')
                                    .doc(AppConfig.appId)
                                    .collection(
                                    'public_characters')
                                    .doc(
                                    widget.character.id)
                                    .update(
                                    {'likesCount': FieldValue.increment(10)});
                              } catch (_) {}
                            },
                            child:Text(l10n.echo_publish_btn),
                          ),
                        ),
                        // ✨ 關鍵 4：底部稍微留一點 padding，避免按鈕貼齊鍵盤邊緣
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildThemeSelector(String themeKey, Widget iconWidget, String label,
      String currentTheme, VoidCallback onTap) {
    final isSelected = currentTheme == themeKey;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Theme
                  .of(context)
                  .colorScheme
                  .primaryContainer : Colors.transparent,
              border: Border.all(color: isSelected ? Theme
                  .of(context)
                  .colorScheme
                  .primary : Colors.grey),
            ),
            child: iconWidget, // ✨ 直接塞入 Widget，讓它可以接收各種形式的圖示
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Theme
              .of(context)
              .colorScheme
              .primary : Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    // ✨ 1. 取得螢幕寬度並判斷是否為大螢幕
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    // ✨ 2. 把原本的 Stack (包含滾動內容與底部按鈕) 提取出來，準備進行寬度限制
    Widget mainContent = Stack(
      children: [
        // 📜 底層：可以滾動的角色資訊 (NestedScrollView)
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha:0.9),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withValues(alpha:0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha:0.4),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (v) {
                          if (v == 'block') {
                            // ✨ 總裁級：封鎖角色的俐落提示，給予玩家掌控社交邊界的安心感！
                            ToastUtils.showCenterToast(
                              context,
                              l10n.char_blocked_msg,
                              customIcon: Icons.person_off_outlined, // 💡 總裁細節：用「人物關閉」或「封鎖」圖示，低調但極度明確地傳達狀態改變
                            );
                          }
                        },
                        itemBuilder: (c) => [
                           PopupMenuItem(
                              value: 'block',
                              child: Row(
                                  children: [
                                    Icon(Icons.block, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(l10n.block_char, style: TextStyle(color: Colors.red))
                                  ]
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.black,
                    // 🌟 總裁的聰明邏輯：決定要顯示哪張網址
                    child: Builder(
                      builder: (context) {
                        // 1. 先預設使用「創建角色的照片」 👉 這裡換成妳專屬的 avatarPath 囉！
                        String targetUrl = widget.character.avatarPath ?? '';
                        // 2. 如果相簿有照片，就蓋過去，改用相簿的第一張
                        if (widget.character.gallery != null &&
                            widget.character.gallery!.isNotEmpty &&
                            widget.character.gallery![0].imageUrl.trim().isNotEmpty) {
                          targetUrl = widget.character.gallery![0].imageUrl;
                        }

                        // 3. 開始畫圖！如果連 avatarPath 都是空的，才顯示灰色圖示
                        if (targetUrl.trim().isEmpty) {
                          return const Center(child: Icon(Icons.person, size: 100, color: Colors.grey));
                        }

                        return Image.network(
                          targetUrl,
                          fit: BoxFit.contain, // 💡 小建議：如果覺得留黑邊不好看，可以改成 BoxFit.cover 讓它填滿
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            print("🚨 背景圖載入失敗，壞掉的網址是: $targetUrl");
                            // 萬一網址壞掉，終極防線：優雅地顯示灰色圖示
                            return const Center(child: Icon(Icons.person, size: 100, color: Colors.grey));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              // ✨ 吸頂的三個頁籤 TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: theme.colorScheme.primary,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(icon: Icon(Icons.person_outline), text: l10n.tab_private_profile),
                      Tab(icon: Icon(Icons.mail_outline), text: l10n.tab_memory_fragments),
                      Tab(icon: Icon(Icons.public), text: l10n.tab_time_echoes),
                    ],
                  ),
                  theme.scaffoldBackgroundColor, // 吸頂時的背景色
                ),
              ),
            ];
          },
          // ✨ 下方的三個頁面內容
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTabProfile(theme), // 頁籤 1
              _buildTabLore(theme),    // 頁籤 2
              _buildTabEchoes(theme),  // 頁籤 3
            ],
          ),
        ),

        // 🔘 頂層：底部固定按鈕區 (覆蓋在滾動視窗上方)
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor.withValues(alpha:0.0)
                  ]
              ),
            ),
            child: Row(
              children: [
                // 🔘 左邊按鈕：日常 (免費)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () async {
                      if (_isNavigating) return;
                      setState(() {
                        _isNavigating = true;
                      });
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                character: widget.character,
                                chatMode: "gemini", // 維持妳的 0元 模式
                                selectedLanguage:l10n.ai_chat_language_code,
                                forceNewRoom: true,
                                initialText: widget.character.storyModeFirstLine ?? l10n.default_chat_initial, // ✨ 補上第一句話
                                characterId: widget.character.id,
                              )
                          )
                      );
                      if (mounted) {
                        setState(() {
                          _isNavigating = false;
                        });
                      }
                    },
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 20),
                          SizedBox(width: 8),
                          Text(l10n.chat_free_btn)
                        ]
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 🔘 右邊按鈕：開始劇情
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () async {
                      if (_isNavigating) return;
                      setState(() {
                        _isNavigating = true;
                      });
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                character: widget.character,
                                chatMode: "daily",
                                selectedLanguage: l10n.ai_chat_language,
                                forceNewRoom: true,
                                characterId: widget.character.id,
                              )
                          )
                      );
                      if (mounted) {
                        setState(() {
                          _isNavigating = false;
                        });
                      }
                    },
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(l10n.start_story_btn)
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: themeNotifier.currentBackground, // 保留您精美的全螢幕背景
        child: isDesktop
            ? Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: mainContent,
          ),
        )
            : mainContent,
      ),
    );
  }
  // ==========================================
  // 🗂️ 頁籤 1：私密檔案
  // ==========================================
  Widget _buildTabProfile(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final String currentLang = Localizations
        .localeOf(context)
        .languageCode;

    // ✨ 方案 B：檢查雲端是否有共享翻譯
    final shared = widget.character.translations?[currentLang];

    // 優先序：本地翻譯 > 共享翻譯 > 原文
    final displayBg = _translatedBackground ?? shared?['background'] ??
        widget.character.background;
    final displayLikes = shared?['likes'] ?? widget.character.likes;
    final displayDislikes = shared?['dislikes'] ?? widget.character.dislikes;
    final displayTags = _translatedTags ??
        (shared?['personalityTags'] as List?)?.cast<String>() ??
        widget.character.personalityTags;
    // 判斷是否顯示按鈕：語言不同且雲端/本地都還沒翻過
    final bool showTranslateBtn = (currentLang !=
        (widget.character.contentLanguage ?? 'zh')) &&
        (_translatedBackground == null && shared?['background'] == null);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 150), // 底部留白避開按鈕
      children: [
        Text(widget.character.name,
            style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(l10n.char_age_occupation(widget.character.age.toString(), widget.character.occupation),
            style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // 喜歡/討厭區
        Row(
          children: [
            InkWell(
              onTap: _handleLike,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: _hasLiked ? Colors.pink.withValues(alpha:0.1) : theme
                        .colorScheme.surfaceVariant.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _hasLiked ? Colors.pink.withValues(alpha:0.5) : Colors
                            .transparent)),
                child: Row(children: [
                  Icon(_hasLiked ? Icons.favorite : Icons.favorite_border,
                      size: 20, color: _hasLiked ? Colors.pink : Colors.grey),
                  SizedBox(width: 6),
                  Text(l10n.like_label, style: TextStyle(
                      color: _hasLiked ? Colors.pink : Colors.grey,
                      fontWeight: FontWeight.bold))
                ]),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: _showDislikeDialog,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withValues(alpha:0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Icon(Icons.thumb_down_off_alt, size: 20,
                      color: Colors.blueGrey),
                  SizedBox(width: 6),
                  Text(l10n.dislike_label, style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold))
                ]),
              ),
            ),
            const Spacer(), // ✨ 把加好友按鈕推到畫面的最右邊！

            // 🫂 總裁新增：加好友按鈕
            InkWell(
              onTap: _isFriendLoading ? null : _toggleFriendStatus,
              // ✨ 秘訣：數值調到 50，確保按鈕永遠是完美的橢圓膠囊形狀
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isFriend ? theme.colorScheme.surfaceVariant.withValues(alpha:0.8) : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(50), // ✨ 這裡也要改成 50
                ),
                child: _isFriendLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Row(
                  children: [
                    Icon(
                      // ✨ 替換圖示：已添加顯示「打勾」，未添加顯示「加號」
                      _isFriend ? Icons.check_rounded : Icons.add_rounded,
                      size: 20,
                      color: _isFriend ? Colors.grey : theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4), // 稍微縮減間距，讓膠囊內的元素更緊湊好看
                    Text(
                      l10n.tab_friends, // ✨ 無論狀態為何，通通只顯示「好友」兩個字
                      style: TextStyle(
                        color: _isFriend ? Colors.grey : theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (showTranslateBtn)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _isTranslating ? null : () =>
                  _translateProfile(currentLang),
              icon: _isTranslating
                  ? const SizedBox(width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.grey))
                  : const Icon(Icons.translate, size: 16),
              label: Text(_isTranslating ? l10n.translating_status : l10n
                  .translate_profile_btn,
                  style: const TextStyle(fontSize: 12)),
            ),
          ),

        const SizedBox(height: 8),
        // 基礎資料
        Row(
          children: [
            if (widget.character.birthday.isNotEmpty) ...[
              Text('${l10n.charBirthdayLabel}：', style: TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(widget.character.birthday,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 16)
            ],
            if (widget.character.height.isNotEmpty)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: l10n.charHeightLabel,
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ${widget.character.height}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 16),

        if (displayTags.isNotEmpty) ...[
          Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: displayTags.toSet().toList().map((t) =>
                  Chip(
                      label: Text(t, style: const TextStyle(fontSize: 12)),
                      backgroundColor: theme.colorScheme.surfaceVariant
                          .withValues(alpha:0.5),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))
              ).toList()
          ),
          const SizedBox(height: 24),
        ],
        // 喜好 (✨ 換成使用 displayLikes / displayDislikes)
        if (displayLikes.isNotEmpty || displayDislikes.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: theme.cardColor.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withValues(alpha:0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (displayLikes.isNotEmpty) Text(
                    l10n.char_likes(displayLikes), style: theme.textTheme.bodyMedium),
                if (displayLikes.isNotEmpty &&
                    displayDislikes.isNotEmpty) const SizedBox(height: 8),
                if (displayDislikes.isNotEmpty) Text(l10n.char_dislikes(displayDislikes),
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        Text(l10n.background_story_title, style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // 背景故事 (✨ 換成使用 displayBg)
        Text(
            displayBg.isEmpty ? l10n.background_story_empty : displayBg,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.7)
        ),
        const SizedBox(height: 32), // 留一點呼吸空間

        // 🌟 找到妳畫面上畫相簿/好感度的那個 StreamBuilder
        StreamBuilder<DocumentSnapshot>(
          // 1. ✨ 關鍵修正：路徑改指向這間聊天室 (sessionId)
          stream: (FirebaseAuth.instance.currentUser != null && widget.sessionId != null)
              ? FirebaseFirestore.instance
              .collection('artifacts')
              .doc(AppConfig.appId)
              .collection('chat_sessions') // 👈 改成去聊天室集合抓
              .doc(widget.sessionId)        // 👈 用這間房的 ID，它才有最新的分數
              .snapshots()
              : const Stream.empty(),

          builder: (context, snapshot) {
            int realAffection = 0;

            // 2. ✨ 如果聊天室資料存在，就把裡面的分數拿出來
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null) {
                // 🌟 注意：在 chat_sessions 裡，妳存的名字叫 'friendshipScore'
                realAffection = data['friendshipScore'] ?? 0;
              }
            }

            // 3. 把真實的數字餵給相簿引擎
            return CharacterGalleryWidget(
              characterId: widget.characterId,
              character: widget.character,
              currentAffection: realAffection, // ✅ 這下子數字就會跟著聊天跳動了！
            );
          },
        ),
      ],
    );
  }
    // ==========================================
// ✉️ 頁籤 2：記憶碎片 (Lore)
// ==========================================

  // ✨ 專屬的「編輯記憶碎片」彈窗
  void _showEditLoreDialog(BuildContext context, String loreId, Map<String, dynamic> existingData, ThemeData theme) {
    // 🌟 1. 回收再利用：把舊資料直接塞進 Controller 的肚子裡當預設值
    final titleController = TextEditingController(text: existingData['title'] ?? '');
    final teaserController = TextEditingController(text: existingData['teaser'] ?? '');
    final contentController = TextEditingController(text: existingData['content'] ?? '');
    final l10n = AppLocalizations.of(context)!;
    // 抓取舊的隱藏狀態
    bool isHidden = existingData['isHidden'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        // 使用 StatefulBuilder 是因為我們要讓 Dialog 裡面的 Checkbox 可以單獨打勾更新畫面
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title:Text(l10n.lore_edit_title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:InputDecoration(labelText: l10n.lore_title_label, hintText: l10n.lore_title_hint),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: teaserController,
                      decoration: InputDecoration(labelText: l10n.lore_teaser_label, hintText: l10n.lore_teaser_hint),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      decoration:InputDecoration(labelText: l10n.lore_content_label, hintText:l10n.lore_content_hint),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 12),
                    // 鎖定設定
                    CheckboxListTile(
                      title:  Text(l10n.lore_lock_label),
                      subtitle:  Text(l10n.lore_lock_desc),
                      value: isHidden,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          isHidden = value ?? false;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();

                    if (title.isEmpty || content.isEmpty) {
                      // ✨ 總裁級防呆：直接用輕量錯誤提示抓住玩家眼球，俐落阻擋無效送出！
                      ToastUtils.showCenterToast(
                        context,
                        l10n.lore_empty_error,
                        isError: true, // 💡 總裁細節：自動帶上紅驚嘆號，讓玩家秒懂哪裡出錯
                      );
                      return;
                    }

                    // 關閉 Dialog
                    Navigator.pop(context);

                    try {
                      // 🌟 2. 關鍵更新：找到指定的 loreId，並使用 update() 覆蓋資料
                      // ⚠️ 記得把下面的 widget.character.id 換成妳實際放角色 ID 的變數
                      await FirebaseFirestore.instance
                          .collection('artifacts')
                          .doc(AppConfig.appId)
                          .collection('public_characters')
                          .doc(widget.character!.id) // 指向這個角色
                          .collection('lores')
                          .doc(loreId) // 🎯 瞄準這個碎片！
                          .update({
                        'title': title,
                        'teaser': teaserController.text.trim(),
                        'content': content,
                        'isHidden': isHidden,
                        'updatedAt': FieldValue.serverTimestamp(), // 標記最後修改時間
                      });
// ✨ 總裁級：更新成功的優雅回饋，告別綠色大色塊！
                      if (mounted) {
                        ToastUtils.showCenterToast(
                          context,
                          l10n.lore_edit_success,
                          customIcon: Icons.task_alt_rounded, // 💡 總裁細節：用「打勾完成」或「儲存」的圖示，給予玩家確實保存的安心感
                        );
                      }
                    } catch (e) {
                      print('更新碎片失敗: $e');
                      // ✨ 總裁級：更新失敗的輕量錯誤提示，俐落取代紅色大色塊！
                      if (mounted) {
                        ToastUtils.showCenterToast(
                          context,
                          l10n.common_update_failed,
                          isError: true, // 💡 直接帶出小紅驚嘆號，優雅提示系統錯誤
                        );
                      }
                    }
                  },
                  child: Text(l10n.social_save_changes),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- 1. 主頁籤 UI ---
  Widget _buildTabLore(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('lores')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data?.docs ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 150),
          children: [
            // 創作者專屬：撰寫碎片按鈕
            if (_isCreator) ...[
              ElevatedButton.icon(
                onPressed: () => _showAddLoreDialog(context, theme),
                icon: const Icon(Icons.add),
                label: Text(l10n.lore_add_btn_limit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 空狀態處理
            if (docs.isEmpty)
              _buildEmptyLoreState()
            else
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final bool isHidden = data['isHidden'] ?? false;
                final bool canViewDetail = _isCreator || !isHidden;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  color: isHidden
                      ? theme.disabledColor.withValues(alpha:0.05)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.dividerColor.withValues(alpha:
                        0.3)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      isHidden ? Icons.lock_outline : Icons.mail_outline,
                      color: isHidden ? Colors.grey : theme.colorScheme.primary,
                      size: 30,
                    ),
                    title: Text(
                      data['title'] ?? l10n.lore_unnamed,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isHidden && !_isCreator ? Colors.grey : null,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: canViewDetail
                          ? Text(data['teaser'] ?? '', maxLines: 2,
                          overflow: TextOverflow.ellipsis)
                          :  Text(l10n.lore_sealed_msg,
                          style: TextStyle(fontSize: 12)),
                    ),
                    trailing: _isCreator
                        ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert), // 創作者會看到三個點點
                      onSelected: (value) {
                        if (value == 'edit') {
                          // 呼叫編輯的 Dialog (記得要把舊資料 data 傳進去)
                          _showEditLoreDialog(context, doc.id, data, theme);
                        } else if (value == 'delete') {
                          // 呼叫刪除功能
                          _deleteLore(doc.id);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(l10n.char_edit_fragment),
                            ],
                          ),
                        ),
                         PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(l10n.delete_btn, style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    )
                    // 如果不是創作者，有權限就顯示箭頭，沒權限就空著
                        : (canViewDetail ? const Icon(Icons.arrow_forward_ios, size: 14) : null),
                    onTap: canViewDetail
                        ? () =>
                        _showLoreDetailDialog(doc.id, data,
                            theme)
                        : () =>
                    // ✨ 總裁級：記憶尚未解鎖的溫柔提醒，用鎖頭圖示增加故事帶入感！
                    ToastUtils.showCenterToast(
                      context,
                      l10n.lore_not_open_msg,
                      customIcon: Icons.lock_outline_rounded, // 💡 總裁細節：用精緻的鎖頭圖示，明確暗示「內容尚未解鎖」，比純文字更有 Fu！
                    )
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }
// --- 2. 合併後的詳細彈窗 (支援翻譯) ---
  void _showLoreDetailDialog(String loreId, Map<String, dynamic> data,
      ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final LoreTranslateService _translateService = LoreTranslateService();
    showDialog(
      context: context,
      builder: (context) {
        final modalTheme = Theme.of(context);
        String displayedTitle = data['title'] ?? l10n.lore_unnamed;
        String displayedContent = data['content'] ?? data['teaser'] ?? '';
        bool isTranslating = false;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: modalTheme.scaffoldBackgroundColor,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: modalTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: modalTheme.dividerColor.withValues(alpha:0.5)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.mail_outline,
                              color: modalTheme.colorScheme.primary, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              displayedTitle,
                              style: modalTheme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold, height: 1.3),
                            ),
                          ),
                          // 🦋 翻譯按鈕
                          isTranslating
                              ? const SizedBox(width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                              : IconButton(
                            icon: const Icon(Icons.translate, size: 20),
                            onPressed: () async {
                              setModalState(() => isTranslating = true);
                              try {
                                //執行 AI 翻譯
                                final String currentLang = Localizations
                                    .localeOf(context)
                                    .languageCode;
                                final translationResult = await _translateService
                                    .translateLore(
                                  targetLang: currentLang,
                                  title: data['title'] ?? '',
                                  content: data['content'] ?? '',
                                );
                                setModalState(() {
                                  displayedTitle =
                                  translationResult['title']!;
                                  displayedContent =
                                  translationResult['content']!;
                                });
                                await _translateService
                                    .saveTranslationToFirebase(
                                  appId: AppConfig.appId,
                                  characterId: widget.character.id,
                                  loreId: loreId,
                                  lang: currentLang,
                                  result: translationResult,
                                );
                              } catch (e) {
                                if (mounted) {
                                  // ✨ 總裁級：翻譯失敗的輕巧提示，用紅驚嘆號俐落接住 API 例外狀況！
                                  ToastUtils.showCenterToast(
                                    context,
                                    l10n.translate_failed(e.toString()),
                                    isError: true, // 💡 總裁細節：自動帶上紅驚嘆號，清楚明瞭
                                  );
                                }
                              }finally {
                                setModalState(() => isTranslating = false);
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        displayedContent,
                        style: modalTheme.textTheme.bodyLarge?.copyWith(
                            height: 1.8, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.lore_collapse, style: TextStyle(
                              color: modalTheme.colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
// --- 3. 輔助小元件：空狀態 ---
  Widget _buildEmptyLoreState() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.mail_outline, size: 60,
                color: Colors.grey.withValues(alpha:0.5)),
            SizedBox(height: 16),
            Text(_isCreator
                ? l10n.lore_write_first(_pronoun)
                : l10n.char_story_expect(_pronoun),
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🪐 頁籤 3：創作者與時空迴音
  // ==========================================
  Widget _buildTabEchoes(ThemeData theme) {
    final String myName = _playerNickname; // 這是玩家
    final String creatorName = widget.character.creatorName; // 這是創作者
    final String creatorId = widget.character.createdBy; // 這是創作者的身分證字號
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    const String adminUid = 'B71k2kyooubYsOtIO1nkiBwyBXt2'; // 🌟 管理員身分證
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.character.id)
          .collection('echoes')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 150),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor.withValues(alpha:0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // 點擊頭像跳轉到創作者主頁
                  Expanded(
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(creatorId)
                          .get(),
                      builder: (context, userSnapshot) {
                        String displayCreatorName = widget.character
                            .creatorName;
                        String? photoUrl;
                        String? avatarPath;
                        if (userSnapshot.hasData && userSnapshot.data!.exists) {
                          final userData = userSnapshot.data!.data() as Map<
                              String,
                              dynamic>;
                          displayCreatorName =
                              userData['nickname'] ?? displayCreatorName;
                          photoUrl = userData['photoURL'] as String?;
                          avatarPath = userData['avatarPath'] as String?;
                        }
                        ImageProvider? imageProvider;
                        if (avatarPath != null && avatarPath.isNotEmpty) {
                          if (avatarPath.startsWith('http')) {
                            imageProvider = NetworkImage(avatarPath);
                          } else {
                            imageProvider = AssetImage(avatarPath);
                          }
                        } else if (photoUrl != null && photoUrl.isNotEmpty) {
                          imageProvider = NetworkImage(photoUrl);
                        }
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () => _navigateToCreatorProfile(),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                backgroundImage: imageProvider,
                                child: imageProvider == null
                                    ? const Icon(
                                    Icons.person, color: Colors.white)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 Text(l10n.creator_label, style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                                  Text(
                                    displayCreatorName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // 關注按鈕
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      // 🌟根據 _isFollowing 狀態決定顏色！
                      backgroundColor: _isFollowing ? Colors.grey.shade400 : theme.colorScheme.primaryContainer,
                      foregroundColor: _isFollowing ? Colors.white : theme.colorScheme.onPrimaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      // 🔒 防禦塔：如果已經變成「已關注」了，按鈕就失去反應，防連點！
                      if (_isFollowing) return;
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null && currentUser.uid == creatorId) {
                        // ✨ 總裁級：溫柔的防呆提示，婉拒「自己追蹤自己」的孤單操作！
                        ToastUtils.showCenterToast(
                          context,
                          l10n.follow_own_warning,
                          customIcon: Icons.front_hand_rounded, // 💡 總裁細節：跟「不能按自己讚」一樣，用小手圖示溫柔擋下這個動作
                        );
                        return;
                      }
                      setState(() {
                        _isFollowing = true;
                      });
                      // ✨ 總裁級：成功追蹤的專屬提示，讓建立羈絆的瞬間充滿質感！
                      ToastUtils.showCenterToast(
                        context,
                        l10n.follow_success_msg(myName, creatorName),
                        customIcon: Icons.person_add_alt_1_rounded, // 💡 總裁細節：用帶加號的人物圖示，或是 Icons.how_to_reg_rounded (已註冊/確認)，完美傳遞「追蹤成功」的意象
                      );
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(creatorId)
                          .collection('mailbox')
                          .add({
                        'type': 'follow',
                        'title': l10n.mailbox_follow_title,
                        'body': l10n.mailbox_follow_body(widget.character.name),
                        'fromName': myName,
                        'createdAt': FieldValue.serverTimestamp(),
                        'isRead': false,
                      });
                    },
                    icon: Icon(_isFollowing ? Icons.check : Icons.add, size: 18),
                    label: Text(_isFollowing ? l10n.followed_btn : '關注', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. 迴音牆標題與按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.echo_wall_title, style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _showAddEchoDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label:Text(l10n.echo_leave_memory),
                )
              ],
            ),
            const SizedBox(height: 12),

            // 3. 迴音牆列表內容
            if (docs.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(l10n.echo_empty_msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final String docId = doc.id;
                final String originalContent = data['content'] ?? '';
                final String themeType = data['theme'] ?? 'butterfly';
                final isMine = data['userId'] == currentUserId;
                final isAdmin = currentUserId == adminUid;

                final bool isTranslating = _translatingEchoIds.contains(docId);
                final bool hasTranslation = _translatedEchoes.containsKey(
                    docId);
                final String displayContent = _translatedEchoes[docId] ??
                    originalContent;

                Color borderColor = Colors.grey;
                Widget themeIconWidget = const Icon(
                    Icons.sticky_note_2, size: 16, color: Colors.grey);
                Color bgColor = theme.cardColor;

                // 便條貼主題判斷
                if (themeType == 'butterfly') {
                  borderColor = Colors.purpleAccent.withValues(alpha:0.5);
                  themeIconWidget =
                  const Text('🦋', style: TextStyle(fontSize: 14));
                  bgColor = Colors.purple.withValues(alpha:0.05);
                } else if (themeType == 'sprout') {
                  borderColor = Colors.green.withValues(alpha:0.5);
                  themeIconWidget = Icon(
                      Icons.eco, size: 16, color: borderColor.withValues(alpha:0.8));
                  bgColor = Colors.green.withValues(alpha:0.05);
                } else if (themeType == 'star') {
                  borderColor = Colors.blue.withValues(alpha:0.5);
                  themeIconWidget = Icon(Icons.star_border, size: 16,
                      color: borderColor.withValues(alpha:0.8));
                  bgColor = Colors.blue.withValues(alpha:0.05);
                } else if (themeType == 'planet') {
                  borderColor = Colors.orange.withValues(alpha:0.5);
                  themeIconWidget = Icon(Icons.public, size: 16,
                      color: borderColor.withValues(alpha:0.8));
                  bgColor = Colors.orange.withValues(alpha:0.05);
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          themeIconWidget,
                          Row(
                            children: [
                              // 🚩  檢舉按鈕 (不是自己寫的才能檢舉)
                              if (!isMine)
                                InkWell(
                                  onTap: () => _reportEcho(docId),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Icon(
                                        Icons.report_gmailerrorred, size: 16,
                                        color: Colors.grey),
                                  ),
                                ),
                              isTranslating
                                  ? const SizedBox(
                                  width: 14, height: 14,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.grey))
                                  : InkWell(
                                onTap: () =>
                                    _translateSingleEcho(
                                        docId, originalContent),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(
                                    Icons.translate,
                                    size: 14,
                                    color: hasTranslation
                                        ? Colors.purpleAccent
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              if (isMine || isAdmin)
                                InkWell(
                                  onTap: () => _deleteEcho(doc),
                                  // 請確保妳有寫好 _deleteEcho 這個函式喔！
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.delete_outline, size: 16,
                                        color: Colors.redAccent),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 顯示留言內容
                      Text(
                        displayContent,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontStyle: hasTranslation
                              ? FontStyle.normal
                              : FontStyle.italic,
                          color: hasTranslation
                              ? theme.colorScheme.primary
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        );
      },
    );
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;
  _SliverAppBarDelegate(this.tabBar, this.backgroundColor);
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor, // 避免往上滑時背後的文字透出來
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
class CharacterGalleryWidget extends StatefulWidget {
  final String characterId;
  final Character character;
  final int currentAffection;
  const CharacterGalleryWidget({
    Key? key,
    required this.character,
    required this.characterId,
    required this.currentAffection,
  }) : super(key: key);

  @override
  State<CharacterGalleryWidget> createState() => _CharacterGalleryWidgetState();
}
class _CharacterGalleryWidgetState extends State<CharacterGalleryWidget> {
  String? _selectedBackground;
  // ☁️ 抓取雲端照片清單
  Future<List<CharacterPhoto>> fetchPhotos(String characterId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(characterId)
          .collection('photos')
          .orderBy('req', descending: false)
          .get();

      // ✨ 關鍵：將 Map 轉為 CharacterPhoto 物件，並同時轉換 gs:// 網址
      List<CharacterPhoto> photoList = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        // 1. 先把資料轉成初步的 CharacterPhoto 物件
        // 注意：這裡的 fromMap 要根據您的類別建構子調整
        var photo = CharacterPhoto.fromMap(data);
        // 2. ⚡️ 執行變身術：把 gs:// 換成 https://
        if (photo.imageUrl.startsWith('gs://')) {
          try {
            photo.imageUrl = await FirebaseStorage.instance.refFromURL(photo.imageUrl).getDownloadURL();
          } catch (err) {
            print("相簿單張照片轉換失敗: $err");
          }
        }
        return photo;
      }).toList());

      return photoList;
    } catch (e) {
      print("🚨 fetchPhotos 執行失敗: $e");
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    // 🌟 1. 改用 FutureBuilder，並把妳寫好的轉換器 fetchPhotos 放進來！
    return FutureBuilder<List<CharacterPhoto>>(
      future: fetchPhotos(widget.characterId), // 👈 這裡！呼叫妳的轉換器
      builder: (context, snapshot) {
        // 2. 當資料還在轉換時，顯示轉圈圈
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // 🚨 防呆：如果轉換失敗或沒資料
        if (snapshot.hasError) {
          return Center(child: Text("讀取照片失敗: ${snapshot.error}"));
        }
        // 3. 拿到轉換好的乾淨照片清單
        final gallery = snapshot.data ?? [];
        // 🌟 4. 這裡才開始 return 妳的 UI (Column)，這樣它才能抓到上面最新的 gallery
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題與好感度顯示
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.gallery_title,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text(l10n.gallery_current_affection(widget.currentAffection.toString()),
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // 這裡就是妳的照片 ListView
            SizedBox(
              height: 160,
              child: gallery.isEmpty
                  ? Center(child: Text(l10n.gallery_empty))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  final photo = gallery[index];
                  final String photoUrl = photo.imageUrl;
                  final String photoDesc = photo.description;
                  final int requiredAffection = photo.requiredAffection;
                  final bool isUnlocked = widget.currentAffection >= requiredAffection;
                  final bool isSelected = _selectedBackground == photoUrl;
                  // 🛡️ 加上這個防呆守衛！
                  // 如果這筆資料的網址是空的，我們就回傳一個空的隱藏元件，不要讓它去畫圖
                  if (photoUrl.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () async {
                      if (isUnlocked) {
                        if (isSelected) {
                          // ✨ 情況 A：玩家按了「已經被選中」的照片 ➡️ 執行取消！
                          setState(() => _selectedBackground = ''); // 把選取狀態清空
                          _updateCallBackgroundToCloud(''); // 傳空字串給 Firebase，代表恢復預設

                          // 這裡妳可以另外寫一個提示，或是直接共用
                          // ✨ 總裁級：背景已重置的優雅回饋，輕巧一閃，不干擾視覺
                          ToastUtils.showCenterToast(
                            context,
                            l10n.gallery_reset_bg,
                            customIcon: Icons.refresh_rounded, // 💡 用「重置/刷新」圖示，與「重置背景」的語意完美對應
                          );
                        } else {
                          // ✨ 情況 B：玩家按了「還沒選中」的照片 ➡️ 執行設定！
                          setState(() => _selectedBackground = photoUrl);
                          _updateCallBackgroundToCloud(photoUrl);
                          _showSuccessSnackBar(context, photoDesc);
                        }
                      } else {
                        // 鎖住的照片，維持跳警告
                        _showLockSnackBar(context, requiredAffection);
                      }
                    },
                    child: _buildPhotoCard(
                        photoUrl,
                        photoDesc,
                        isUnlocked,
                        isSelected,
                        requiredAffection,
                        theme
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // 🖼️ 漂亮的相片卡片組件（含模糊邏輯）
  Widget _buildPhotoCard(String url, String desc, bool isUnlocked, bool isSelected, int req, ThemeData theme) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🌟 使用 CachedNetworkImage 代替 Image.network
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              // 這裡就是「快取版」的處理邏輯
              imageBuilder: (context, imageProvider) => ImageFiltered(
                imageFilter: isUnlocked
                    ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                    : ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // 圖片還在下載時顯示的佔位圖（轉圈圈或灰色塊）
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              // 萬一網址掛掉顯示的錯誤圖
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),

            // --- 接下來是原本的鎖頭和打勾邏輯，維持不變 ---
            if (!isUnlocked)
              Container(
                color: Colors.black.withValues(alpha:0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.white, size: 28),
                    Text('$req 💕', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            if (isSelected)
              const Positioned(top: 8, right: 8, child: CircleAvatar(radius: 10, backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white, size: 14))),
          ],
        ),
      ),
    );
  }

  // 提示訊息與同步函式（維持總裁原本的專業邏輯）
  void _showSuccessSnackBar(BuildContext context, String desc) {
    final l10n = AppLocalizations.of(context)!;

    // ✨ 總裁級：解鎖成功的優雅回饋，給予玩家滿滿的成就感！
    ToastUtils.showCenterToast(
      context,
      l10n.gallery_unlocked_msg(desc),
      customIcon: Icons.lock_open_rounded, // 💡 用「解鎖」的圖示，呼應解鎖成功的情境，絕妙！
    );
  }

  void _showLockSnackBar(BuildContext context, int req) {
    final l10n = AppLocalizations.of(context)!;

    // ✨ 總裁級：未達門檻的溫柔提醒，用鎖頭圖示鼓勵玩家繼續努力！
    ToastUtils.showCenterToast(
      context,
      l10n.gallery_lock_msg(req.toString()),
      customIcon: Icons.lock_outline_rounded, // 💡 使用相同的鎖頭圖示，與系統的「鎖定」狀態語彙完全一致
    );
  }

  Future<void> _updateCallBackgroundToCloud(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('characters').doc(widget.character.id).set({
      'callBackgroundUrl': url,
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
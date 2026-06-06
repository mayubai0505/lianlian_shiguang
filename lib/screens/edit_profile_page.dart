import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:math'; // ✨ 用來生成隨機亂數
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';      // 這一行是為了讓檔案認識 Provider
import '../services/theme_notifier.dart'; // 這一行是為了讓檔案認識你自訂的 ThemeNotifier
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart'; // ✅ 就是這行，讓程式認識 DateFormat
import 'package:image_cropper/image_cropper.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart'; // 雲端硬碟總管
import 'package:http/http.dart' as http;

import '../services/toast_utils.dart'; // 專門用來破解網頁版 blob 網址的工具

//個人檔案

class EditProfilePage extends StatefulWidget {
  // 這個 isCreating 參數非常重要，用來區分是「首次創建」還是「從個人主頁編輯」
  final bool isCreating;
  const EditProfilePage({super.key, this.isCreating = false});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // --- Controllers ---
  final _nicknameController = TextEditingController();
  final _playerIDController = TextEditingController();
  // ✨ 請確保您有在 class 的頂部加上這一行 ✨
  // --- 狀態變數 ---
  String _gender = '未選擇';
  DateTime? _birthDate;
  String _avatarPath = 'assets/images/avatar1.png';
  bool _isAgeEditable = true;
  bool _hasChangedID = false;
  bool _isSaving = false;
  String _originalID = '';

  // --- Services ---
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Future<void> _loadProfileFuture;

  @override
  void initState() {
    super.initState();
    // ✨ 關鍵修復 1：不管是不是首次創建，都先去雲端查有沒有資料！
    // 避免本地資料被清空時，App 誤以為你是新玩家而解鎖生日。
    _loadProfileFuture = _loadProfileData();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _playerIDController.dispose();
    super.dispose();
  }

  // --- 資料處理邏輯 ---

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final l10n = AppLocalizations.of(context)!;
    if (user != null) {
      try {
        final doc = await _db.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          if (mounted) {
            setState(() {
              _nicknameController.text = data['nickname'] ?? '';
              _gender = data['gender'] ?? l10n.genderNotSelected;
              _avatarPath = data['avatarPath'] ?? 'assets/images/avatar1.png';
              final bool isAgeSetCloud = data['isAgeSet'] ?? false;
              _isAgeEditable = !isAgeSetCloud;
              String? birthdayStr = data['birthday'];
              if (birthdayStr != null && birthdayStr != l10n.authMethodUnknown) {
                try {
                  _birthDate = DateTime.parse(birthdayStr);
                } catch (e) { print("日期解析錯誤"); }
              }

              _originalID = data['playerID'] ?? '';
              _playerIDController.text = _originalID;
              _hasChangedID = data['hasChangedID'] ?? false;
            });
          }
          return; // 雲端有資料就結束
        }
      } catch (e) {
        print("讀取雲端資料失敗: $e");
      }
    }
    // 🌟 關鍵修改：如果是新玩家，或是雲端沒資料，就根據情況決定要不要讀暫存
    if (mounted) {
      setState(() {
        // 如果是「第一次創建 (isCreating)」，所有的值都必須是空的或預設值
        _nicknameController.text = widget.isCreating ? '' : (prefs.getString('nickname') ?? '');
        _gender = widget.isCreating ? '未選擇' : (prefs.getString('gender') ??l10n.genderNotSelected);
        _avatarPath = widget.isCreating ? 'assets/images/avatar1.png' : (prefs.getString('avatarPath') ?? 'assets/images/avatar1.png');
        // ... 前面的程式碼不變 ...
        if (widget.isCreating) {
          _birthDate = null;
          _isAgeEditable = true;
          // ✨ 關鍵修改：如果是新玩家，自動給他一組隨機 ID！
          _originalID = _generateRandomID();
          _hasChangedID = false;
        } else {
          String? birthDateStr = prefs.getString('birthDate');
          _birthDate = birthDateStr != null ? DateTime.parse(birthDateStr) : null;
          _isAgeEditable = !(prefs.getBool('isAgeSet') ?? false);
          _originalID = prefs.getString('playerID') ?? '';
          _hasChangedID = prefs.getBool('hasChangedID') ?? false;
        }
        _playerIDController.text = _originalID; // 👈 隨機 ID 就會被塞進框框裡了！
      });
    }
  }

  // ✨ 自動生成 8 碼隨機專屬 ID (大寫英文+數字)
  String _generateRandomID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(
        Iterable.generate(8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)))
    );
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isSaving) return;
    final newNickname = _nicknameController.text.trim();
    final newID = _playerIDController.text.trim();

    if (newNickname.isEmpty) {
      // ✨ 總裁級防呆：精準攔截空白暱稱，完美避開虛擬鍵盤的遮擋！
      ToastUtils.showCenterToast(
        context,
        l10n.error_nickname_empty,
        isError: true, // 💡 紅色警告，讓玩家立刻意識到「名字不能留白」
        // 💡 總裁秘技：如果想讓介面看起來更專屬、更沒有責備感，可以拿掉 isError，改用：
        // customIcon: Icons.drive_file_rename_outline_rounded, // 帶有「重新命名/畫筆」意象的圖示
      );
      return;
    }
    if (!widget.isCreating && !_hasChangedID && newID == _originalID) {
      _showIdNotSetDialog();
    } else {
      // 「首次創建」或「ID已被編輯過」的情況，都直接執行完整儲存
      _performFullSave();
    }
  }

  // --- NEW: 這是只儲存非ID資料的函式 ---
  Future<void> _saveProfileDataOnly(
      {bool popOnSuccess = true, String? newID, bool? hasChangedID}) async {
    if (mounted) setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();
      final l10n = AppLocalizations.of(context)!;
      // 預設為現在畫面上的路徑
      String finalAvatarPath = _avatarPath;
      // 如果這張照片不是預設圖 (assets) 也不是雲端圖 (http)，代表它是玩家剛裁切好的新照片！
      // ✨✨✨ 總裁級雲端上傳 + 舊圖自動清理機制 ✨✨✨
      if (!_avatarPath.startsWith('assets') && !_avatarPath.startsWith('http')) {
        if (user != null) {
          // --- A. 準備清理舊圖 (這段是新增的！) ---
          // 檢查原本的頭像是否已經是雲端網址 (代表有舊圖在 Storage)
          // 這裡我們去 SharedPreferences 拿最準確的「舊網址」
          String oldAvatarUrl = prefs.getString('avatarPath') ?? '';

          if (oldAvatarUrl.startsWith('http')) {
            try {
              // 從網址反向推導出 Storage 的參考路徑並刪除
              final oldStorageRef = FirebaseStorage.instance.refFromURL(oldAvatarUrl);
              await oldStorageRef.delete();
              print("♻️ 舊水煮蛋已成功回收：$oldAvatarUrl");
            } catch (e) {
              // 如果刪除失敗 (例如檔案本來就不存在)，我們印個 log 就好，不卡住存檔流程
              print("⚠️ 舊圖刪除失敗 (可能已被刪除或不存在): $e");
            }
          }

          // --- B. 執行新圖上傳 (跟原本一樣) ---
          final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final storageRef = FirebaseStorage.instance.ref().child('user_avatars').child(fileName);

          if (kIsWeb) {
            final response = await http.get(Uri.parse(_avatarPath));
            final bytes = response.bodyBytes;
            await storageRef.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
          } else {
            await storageRef.putFile(File(_avatarPath));
          }

          finalAvatarPath = await storageRef.getDownloadURL();
          print("☁️ 新圖片上傳成功：$finalAvatarPath");
        }
      }

      // 1. 存入本地 SharedPreferences (這裡存進去的就是完美的 https 網址了！)
      await prefs.setString('nickname', _nicknameController.text.trim());
      await prefs.setString('avatarPath', finalAvatarPath); // 👈 存入真實網址
      await prefs.setString('gender', _gender);

      if (newID != null) {
        await prefs.setString('playerID', newID);
      }
      if (hasChangedID != null) {
        await prefs.setBool('hasChangedID', hasChangedID);
      }

      String birthdayStr = _birthDate != null
          ? "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}"
          : l10n.authMethodUnknown;

      if (_birthDate != null && _isAgeEditable) {
        await prefs.setString('birthDate', _birthDate!.toIso8601String());
        await prefs.setBool('isAgeSet', true);
      }
      await prefs.setBool('isProfileComplete', true);

      // ✨ 2. 同步存入雲端 Firebase Firestore (系統跟 AI 都能看到這張水煮蛋了！)
      if (user != null) {
        Map<String, dynamic> cloudData = {
          'nickname': _nicknameController.text.trim(),
          'avatarPath': finalAvatarPath, // 👈 存入真實網址
          'gender': _gender,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (_birthDate != null && _isAgeEditable) {
          cloudData['birthday'] = birthdayStr;
          cloudData['isAgeSet'] = true;
        }

        if (newID != null) cloudData['playerID'] = newID;
        if (hasChangedID != null) cloudData['hasChangedID'] = hasChangedID;

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            cloudData, SetOptions(merge: true));
      }

      if (mounted && popOnSuccess) {
        // ✨ 總裁級：個人檔案儲存成功的完美過場，提示與退場動畫互不干擾！
        ToastUtils.showCenterToast(
          context,
          l10n.profile_saved_success,
          // 💡 總裁精選：針對「個人檔案」，強烈推薦使用帶有個人專屬質感的圖示
          customIcon: Icons.account_circle_rounded,
          // 💡 總裁秘技：如果想更強調「大功告成/煥然一新」的感覺，
          // Icons.face_retouching_natural_rounded 或是 Icons.how_to_reg_rounded 也會非常有高級感喔！
        );

        Navigator.pop(context, true); // 帶著更新成功的信號，優雅地回到上一頁
      }
    } catch (e) {
      if (mounted) {
        // ✨ 總裁級防護：儲存失敗的優雅迫降，讓不可預期的錯誤訊息不再破壞畫面排版！
        ToastUtils.showCenterToast(
          context,
          '儲存失敗: $e',
          isError: true, // 💡 全域統一的紅色驚嘆號，清楚傳達異常狀態
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // --- 修正後的完整儲存函式 (加入舊 ID 徹底移除機制) ---
  // --- 修正後的完整儲存函式 (讓 ID 變成選填) ---
  Future<void> _performFullSave() async {
    final l10n = AppLocalizations.of(context)!;
    if (mounted) setState(() => _isSaving = true);
    final newID = _playerIDController.text.trim();

    try {
      // ✨ 修改 1：拿掉 newID.isEmpty 的報錯。如果有填寫，才檢查長度
      if (newID.isNotEmpty && newID.length > 20) throw Exception(l10n.error_id_too_long);

      final prefs = await SharedPreferences.getInstance();

      // ✨ 修改 2：只有當「有填寫新 ID」且「跟原本不同」且「還沒被鎖定」時，才執行 Firebase 搬家檢查
      if (newID.isNotEmpty && newID != _originalID && !_hasChangedID) {
        final User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) throw Exception("找不到使用者");

        // A. 檢查新 ID 是否被別人搶走了
        final idDoc = await _db.collection('playerIDs').doc(newID).get();
        if (idDoc.exists) {
          throw Exception(l10n.error_id_already_used);
        }

        // B. 使用 Transaction 確保搬家過程一氣呵成
        await _db.runTransaction((transaction) async {
          final newIdRef = _db.collection('playerIDs').doc(newID);
          // 1. 在 playerIDs 資料表建立新的門牌號碼
          transaction.set(newIdRef, {'uid': currentUser.uid});
          // 2. 如果有舊的 ID，立刻在 playerIDs 裡面把舊門牌拆掉！
          if (_originalID.isNotEmpty && _originalID != newID) {
            final oldIdRef = _db.collection('playerIDs').doc(_originalID);
            transaction.delete(oldIdRef);
            print("♻️ 舊 ID 佔位已自動刪除：$_originalID");
          }
        });
        await prefs.setString('playerID', newID);
        await prefs.setBool('hasChangedID', true);
      }

      // ✨ 修改 3：最後存檔時，判斷一下 ID 是不是空的
      await _saveProfileDataOnly(
        popOnSuccess: true,
        newID: newID.isNotEmpty ? newID : null, // 沒填就不更新 ID
        hasChangedID: (newID.isNotEmpty && newID != _originalID) ? true : null,
      );
    } catch (e) {
      if (mounted) {
        // ✨ 總裁級防護：個人檔案儲存失敗的優雅迫降，搭配你完美的字串修剪！
        ToastUtils.showCenterToast(
          context,
          l10n.profile_save_failed(
              e.toString().replaceFirst("Exception: ", "")),
          isError: true, // 💡 全域統一的紅色驚嘆號，清楚告知錯誤，但不引發焦慮
        );
      }
    }finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- ✨ 新增：稍後編輯按鈕的邏輯 ---
  void _skipEditing() {
    final l10n = AppLocalizations.of(context)!;
    // 這裡我們直接關閉視窗回到上一頁 (通常是主畫面)
    // 或是如果這是第一次建立，則引導玩家進入主畫面
    Navigator.pop(context);

    // ✨ 總裁級：草稿儲存的安心回饋，徹底告別容易被鍵盤擋住的底部彈窗！
    ToastUtils.showCenterToast(
      context, // 💡 若在 async 之後，記得包一層 if (mounted) 喔！
      l10n.draft_saved_success_msg,
      customIcon: Icons.save_rounded, // 💡 總裁精選：最直覺的「儲存/安全」圖示，瞬間消除玩家怕心血白費的焦慮
      // 💡 總裁秘技：如果是偏向「寫信/傳訊息」的草稿，
      // 非常推薦換成 Icons.drafts_rounded 或 Icons.edit_note_rounded，語意會更精準、更有沉浸感！
    );
  }

  // --- NEW: 這是我們的「溫柔提醒」對話框 ---
  void _showIdNotSetDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title:Text(l10n.dialog_reminder_title),
            content:Text(l10n.warning_id_not_edited),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:Text(l10n.action_continue_editing),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _saveProfileDataOnly(); // 只儲存非ID資料
                },
                child: Text(l10n.action_edit_later),
              ),
            ],
          ),
    );
  }

  // --- UI 輔助函式 (保持不變) ---

  Future<void> _selectDate() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_isAgeEditable) {
      // ✨ 總裁級防護：生日鎖定攔截，堅定卻不失優雅的規則宣示！
      ToastUtils.showCenterToast(
        context,
        l10n.error_birthdate_locked,
        customIcon: Icons.lock_rounded, // 💡 總裁精選：最直覺的「上鎖」圖示，清楚傳達規則不可動搖
        // 💡 總裁秘技：如果想更強調「日期」的概念，
        // 也可以換成 Icons.event_busy_rounded (行事曆打叉) 或是 Icons.edit_off_rounded (禁止編輯)！
      );
      return; // 煞車！絕對不准修改！
    }
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('zh', 'TW'),
    );
    if (picked != null && picked != _birthDate && mounted) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _showAvatarSelectionDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title:Text(l10n.action_select_avatar),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(13, (i) {
                    final index = i + 1;
                    final path = 'assets/images/avatar$index.png'; // 先定義路徑
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage(path)),
                      title: Text('頭像 $index'),
                      onTap: () {
                        setState(() {
                          // ⚡ 存入妳在 Class 頂部定義的那個變數，警告就會消失！
                          _avatarPath = path;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title:Text(l10n.action_choose_from_gallery),
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery);
                      if (image != null) {
                        // ✅ 不要直接換，先送去「裁切部門」加工！
                        _cropImage(image.path);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _cropImage(String filePath) async {
    final theme = Theme.of(context);
    // 🛡️ 拿掉驚嘆號，改用安全讀取 (l10n 現在是可空的)
    final l10n = AppLocalizations.of(context);

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 512,
        maxHeight: 512,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            // ✨ 修正 1：加上 `?.` 安全呼叫，並給予保底文字
            toolbarTitle: l10n?.title_adjust_avatar ?? '調整您的時光頭像',
            toolbarColor: theme.colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            // ✨ 修正 2：同樣加上保底文字
            title: l10n?.title_adjust_avatar ?? '調整您的時光頭像',
            cancelButtonTitle: '取消', // 如果 l10n 裡面沒有 cancelButton，可以直接寫死
            doneButtonTitle: '確定',
            aspectRatioLockEnabled: true,
          ),
          // 🌐 Web 介面設定 (終極完美版)
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.page,
          ),
        ],
      );

      if (croppedFile != null && mounted) {
        setState(() {
          _avatarPath = croppedFile.path;
        });
      }
    } catch (e) {
      debugPrint("❌ 裁切部門發生錯誤: $e");
      if (mounted) {
        setState(() {
          _avatarPath = filePath; // 裁切失敗就用原圖保底
        });
        // ✨ 總裁級：大頭貼更新成功的絕美過場，完美守護你的原創畫作！
        ToastUtils.showCenterToast(
          context, // 💡 若在 async 之後，記得包一層 if (mounted)
          l10n?.avatar_updated_success ?? '已為您換上頭像 🍃',
          customIcon: Icons.face_retouching_natural_rounded, // 💡 總裁精選：帶有「煥然一新、精緻臉龐」意涵的完美圖示
          // 💡 總裁秘技：如果想強調「圖片/畫作」的感覺，
          // 換成 Icons.wallpaper_rounded 或 Icons.photo_camera_front_rounded 也非常適合！
        );
      }
    }
  }

  ImageProvider getAvatarImageProvider(String path) {
    // ☁️ 1. 雲端真實網址 (Firebase Storage)
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    }
    // 🏠 2. 內建預設頭像 (assets/ 開頭)
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }
    // 🌐 3. 網頁版頭像 (Chrome 模擬器選出來的 blob: 網址)
    if (kIsWeb) {
      return NetworkImage(path);
    }
    // 📱 4. 手機版剛裁切好的本地端頭像
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      decoration: themeNotifier.currentBackground,
      child: widget.isCreating
          ? _buildPageContent()
          : FutureBuilder<void>(
        future: _loadProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('載入資料失敗: ${snapshot.error}'));
          }
          return _buildPageContent();
        },
      ),
    );
  }

  Widget _buildPageContent() {
    // ✨ 1. 定義變色龍變數 (隨主題自動變色)
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    // 封裝通用的輸入框樣式 (延續妳喜愛的毛玻璃感)
    InputDecoration customInputDecoration(String label, {String? helper}) {
      return InputDecoration(
        labelText: label,
        helperText: helper,
        helperStyle: TextStyle(color: onSurface.withValues(alpha:0.5)),
        filled: true,
        fillColor: theme.cardColor.withValues(alpha:isDarkMode ? 0.6 : 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: primaryColor.withValues(alpha:0.1)),
        ),
        labelStyle: TextStyle(color: onSurface.withValues(alpha:0.8)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.isCreating ? l10n.title_create_profile : l10n.title_edit_profile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 頂部間距 (避開 AppBar)
            SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 20),

            // 2. 頭像區
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55, // 這裡可以調成妳喜歡的大小，55 比原本的 50 再大一點點
                    backgroundColor: Colors.grey[200],
                    // ⚡ 這裡請注意：確認妳用的變數是 _avatarPath 還是 _selectedAvatarPath
                    backgroundImage: getAvatarImageProvider(_avatarPath),
                  ),
                  // 編輯按鈕 (相機圖示)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showAvatarSelectionDialog, // 點擊觸發選單
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 18,
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. 輸入欄位區
            TextField(
              controller: _nicknameController,
              style: TextStyle(color: onSurface),
              decoration: customInputDecoration(l10n.label_your_nickname),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _playerIDController,
              style: TextStyle(color: onSurface),
              readOnly: _hasChangedID, // 已改過就鎖定
              maxLength: 20,
              decoration: customInputDecoration(
                l10n.label_player_exclusive_id,
                helper: _hasChangedID ? l10n.msg_id_locked : l10n.msg_id_change_chance,
              ),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: _gender,
              dropdownColor: theme.cardColor,
              style: TextStyle(color: onSurface),
              decoration: customInputDecoration(l10n.charGenderLabel),
              items: [
                // value 是存進資料庫的固定字串，child 裡面的 Text 才是翻譯後顯示給玩家看的
                DropdownMenuItem(value: '未選擇', child: Text(l10n.genderNotSelected)), // (如果翻譯包有加這句，也可以換成 l10n.notSelected)
                DropdownMenuItem(value: '男', child: Text(l10n.genderMale)),
                DropdownMenuItem(value: '女', child: Text(l10n.genderFemale)),
                DropdownMenuItem(value: '其他', child: Text(l10n.genderOther)),
              ],
              onChanged: (String? newValue) => setState(() => _gender = newValue ?? '未選擇'),
            ),
            const SizedBox(height: 20),

            // 4. 生日選擇器
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha:isDarkMode ? 0.6 : 0.4),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: primaryColor.withValues(alpha:0.1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cake_outlined, color: primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      _birthDate == null
                          ? l10n.action_select_birthdate
                          : l10n.label_birthdate(DateFormat('yyyy-MM-dd').format(_birthDate!)),
                      style: TextStyle(color: onSurface, fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: onSurface.withValues(alpha:0.5)),
                  ],
                ),
              ),
            ),

            if (!_isAgeEditable && !widget.isCreating)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(l10n.msg_birthdate_immutable, style: TextStyle(color: onSurface.withValues(alpha:0.4), fontSize: 12)),
              ),

            const SizedBox(height: 48),

            // 5. 按鈕區 (儲存 + 稍後編輯)
            Center(
              child: _isSaving
                  ? CircularProgressIndicator(color: primaryColor)
                  : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 主要儲存按鈕
                  ElevatedButton(
                    onPressed: _hasChangedID ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 8,
                      shadowColor: primaryColor.withValues(alpha:0.5),
                    ),
                    child: Text(
                      widget.isCreating ? l10n.action_start_journey : l10n.save_changes_button,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 次要按鈕：稍後再編輯 / 取消變更
                  TextButton(
                    onPressed: _skipEditing,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      widget.isCreating ? l10n.action_edit_later_short :l10n.action_cancel_changes,
                      style: TextStyle(
                        color: onSurface.withValues(alpha:0.6),
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // 底部留白
          ],
        ),
      ),
    );
  }
}
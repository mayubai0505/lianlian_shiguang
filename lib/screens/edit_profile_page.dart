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

import '../services/toast_utils.dart';
import 'main_page.dart'; // 專門用來破解網頁版 blob 網址的工具
import '../utils/image_utils.dart';

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
  final _bioController = TextEditingController();
  // ✨ 請確保您有在 class 的頂部加上這一行 ✨
  // --- 狀態變數 ---
  String _gender = '未選擇';
  DateTime? _birthDate;
  String _avatarPath = 'assets/images/avatar1.png';
  bool _isAgeEditable = true;
  bool _hasChangedID = false;
  bool _isSaving = false;
  String _originalID = '';
  String _originalNickname = '';
  String _originalGender = '未選擇';
  String _originalAvatarPath = 'assets/images/avatar1.png';
  DateTime? _originalBirthDate;
  String _originalBio = '';

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
    _bioController.dispose();
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

          // ✅ cloudPlayerID 要放在 data 出現之後
          final String cloudPlayerID =
          (data['playerID'] ?? '').toString().trim();

          if (mounted) {
            setState(() {
              _nicknameController.text = data['nickname'] ?? '';
              _gender = data['gender'] ?? l10n.genderNotSelected;
              _avatarPath = data['avatarPath'] ?? 'assets/images/avatar1.png';
              _bioController.text =
                  data['bio']?.toString() ?? '';
              final bool isAgeSetCloud = data['isAgeSet'] ?? false;
              _isAgeEditable = !isAgeSetCloud;

              String? birthdayStr = data['birthday'];
              if (birthdayStr != null && birthdayStr != l10n.authMethodUnknown) {
                try {
                  _birthDate = DateTime.parse(birthdayStr);
                } catch (e) {
                  print("日期解析錯誤");
                }
              }

              _originalID = cloudPlayerID.isNotEmpty
                  ? cloudPlayerID
                  : (widget.isCreating ? _generateRandomID() : '');

              _playerIDController.text = _originalID;

              _hasChangedID = data['hasChangedID'] ?? false;
              _originalNickname = _nicknameController.text.trim();
              _originalGender = _gender;
              _originalAvatarPath = _avatarPath;
              _originalBirthDate = _birthDate;
              _originalBio = _bioController.text.trim();
            });
          }

          return; // 雲端有資料就結束
        }
      } catch (e) {
        print("讀取雲端資料失敗: $e");
      }
    }

    // 🌟 如果是新玩家，或是雲端沒資料，就根據情況決定要不要讀暫存
    if (mounted) {
      setState(() {
        _nicknameController.text =
        widget.isCreating ? '' : (prefs.getString('nickname') ?? '');
        _bioController.text =
        widget.isCreating
            ? ''
            : (prefs.getString('bio') ?? '');
        _gender = widget.isCreating
            ? '未選擇'
            : (prefs.getString('gender') ?? l10n.genderNotSelected);

        _avatarPath = widget.isCreating
            ? 'assets/images/avatar1.png'
            : (prefs.getString('avatarPath') ?? 'assets/images/avatar1.png');

        if (widget.isCreating) {
          _birthDate = null;
          _isAgeEditable = true;

          // 新玩家自動給一組隨機 ID
          _originalID = _generateRandomID();
          _hasChangedID = false;
        } else {
          String? birthDateStr = prefs.getString('birthDate');
          _birthDate =
          birthDateStr != null ? DateTime.parse(birthDateStr) : null;

          _isAgeEditable = !(prefs.getBool('isAgeSet') ?? false);
          _originalID = prefs.getString('playerID') ?? '';
          _hasChangedID = prefs.getBool('hasChangedID') ?? false;
        }

        _playerIDController.text = _originalID;
        _originalNickname = _nicknameController.text.trim();
        _originalGender = _gender;
        _originalAvatarPath = _avatarPath;
        _originalBirthDate = _birthDate;
        _originalBio = _bioController.text.trim();
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

  Future<String> _ensureValidPlayerIDForCurrentUser() async {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("找不到使用者");
    }

    String currentID = _playerIDController.text.trim();

    // 如果畫面上完全沒有 ID，就自動產生一組沒有被使用過的 ID
    if (currentID.isEmpty) {
      for (int i = 0; i < 10; i++) {
        final candidateID = _generateRandomID();
        final idRef = _db.collection('playerIDs').doc(candidateID);
        final idDoc = await idRef.get();

        if (!idDoc.exists) {
          await idRef.set({
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });

          if (mounted) {
            setState(() {
              _playerIDController.text = candidateID;
              _originalID = candidateID;
            });
          }

          return candidateID;
        }
      }

      throw Exception("產生玩家 ID 失敗，請再試一次");
    }

    // 如果玩家有填 ID，就檢查這個 ID 有沒有被別人用走
    final idRef = _db.collection('playerIDs').doc(currentID);
    final idDoc = await idRef.get();

    if (!idDoc.exists) {
      await idRef.set({
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return currentID;
    }

    final data = idDoc.data();
    final ownerUid = data?['uid'];

    if (ownerUid != user.uid) {
      throw Exception(l10n.error_id_already_used);
    }

    return currentID;
  }

  bool _isSameDate(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasAnyProfileChanged() {
    final currentNickname =
    _nicknameController.text.trim();

    final currentID =
    _playerIDController.text.trim();

    final currentBio =
    _bioController.text.trim();

    return currentNickname != _originalNickname ||
        currentID != _originalID ||
        currentBio != _originalBio ||
        _gender != _originalGender ||
        _avatarPath != _originalAvatarPath ||
        !_isSameDate(
          _birthDate,
          _originalBirthDate,
        );
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;

    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    // =========================
    // 首次建立：允許空白，系統自動補預設值
    // =========================
    if (widget.isCreating) {
      try {
        String nickname = _nicknameController.text.trim();

        if (nickname.isEmpty) {
          nickname = '初識的旅人';
          _nicknameController.text = nickname;
        }

        final String beforeID = _originalID;
        final String finalID = await _ensureValidPlayerIDForCurrentUser();

        // 如果玩家有手動把系統隨機 ID 改成別的，就視為使用過改 ID 機會
        final bool shouldLockID = beforeID.isNotEmpty && finalID != beforeID;

        await _saveProfileDataOnly(
          popOnSuccess: true,
          newID: finalID,
          hasChangedID: shouldLockID,
          targetIndexAfterSave: 0,
        );
      } catch (e) {
        if (mounted) {
          ToastUtils.showCenterToast(
            context,
            l10n.profile_save_failed(
              e.toString().replaceFirst("Exception: ", ""),
            ),
            isError: true,
          );
        }
      }

      return;
    }

    // =========================
    // 一般編輯：維持原本比較嚴格的規則
    // =========================
    final newNickname = _nicknameController.text.trim();
    final newID = _playerIDController.text.trim();

    if (newNickname.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.error_nickname_empty,
        isError: true,
      );
      return;
    }

    if (!_hasAnyProfileChanged()) {
      ToastUtils.showCenterToast(
        context,
        '沒有需要儲存的變更',
        customIcon: Icons.info_outline_rounded,
      );
      return;
    }

    final bool idChanged = newID.isNotEmpty && newID != _originalID;

    // ID 有改，而且玩家還有改 ID 的權限，才走完整 ID 檢查流程
    if (idChanged && !_hasChangedID) {
      await _performFullSave();
      return;
    }

    // ID 沒改，或 ID 已經鎖定，就只儲存其他個人資料
    await _saveProfileDataOnly(
      popOnSuccess: true,
      newID: null,
      hasChangedID: null,
    );
  }

  // --- NEW: 這是只儲存非ID資料的函式 ---
  Future<void> _saveProfileDataOnly({
    bool popOnSuccess = true,
    String? newID,
    bool? hasChangedID,
    int targetIndexAfterSave = 3,
  }) async {
    if (_isSaving) return;

    if (mounted) {
      setState(() {
        _isSaving = true;
      });
    }

    Reference? newlyUploadedStorageRef;

    try {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      // 儲存舊頭像網址。
      // 必須等新圖片上傳、Firestore 更新都成功後，才能刪除舊圖。
      final String oldAvatarUrl =
      (prefs.getString('avatarPath') ?? '').trim();

      // 預設沿用目前畫面上的頭像。
      String finalAvatarPath = _avatarPath.trim();
      bool uploadedNewAvatar = false;

      final bool isAssetAvatar =
      finalAvatarPath.startsWith('assets/');

      final bool isNetworkAvatar =
          finalAvatarPath.startsWith('http://') ||
              finalAvatarPath.startsWith('https://');

      // 不是 Asset、也不是既有網路網址，
      // 代表它是手機本地裁切圖或 Web blob 圖片。
      if (!isAssetAvatar && !isNetworkAvatar) {
        if (user == null) {
          throw Exception('找不到目前登入的使用者');
        }

        final String fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_avatars')
            .child(fileName);

        newlyUploadedStorageRef = storageRef;

        late Uint8List bytes;

        if (kIsWeb) {
          final response = await http.get(
            Uri.parse(finalAvatarPath),
          );

          if (response.statusCode != 200) {
            throw Exception(
              '讀取頭像失敗，狀態碼：${response.statusCode}',
            );
          }

          bytes = response.bodyBytes;
        } else {
          final file = File(finalAvatarPath);

          if (!await file.exists()) {
            throw Exception(
              '找不到選取的頭像檔案：$finalAvatarPath',
            );
          }

          bytes = await file.readAsBytes();
        }

        if (bytes.isEmpty) {
          throw Exception('頭像圖片資料是空的');
        }

        await storageRef.putData(
          bytes,
          SettableMetadata(
            contentType: 'image/jpeg',

            // 每次檔名都有時間戳，所以相同網址的內容不會改變。
            // 適合設定一年長效快取。
            cacheControl:
            'public,max-age=31536000,immutable',
          ),
        );

        finalAvatarPath =
        await storageRef.getDownloadURL();

        uploadedNewAvatar = true;

        debugPrint(
          '☁️ 新頭像上傳成功：$finalAvatarPath',
        );
      }

      final String nickname =
      _nicknameController.text.trim();
      final String bio =
      _bioController.text.trim();
      // 生日資料
      final String birthdayStr = _birthDate != null
          ? '${_birthDate!.year}-'
          '${_birthDate!.month.toString().padLeft(2, '0')}-'
          '${_birthDate!.day.toString().padLeft(2, '0')}'
          : l10n.authMethodUnknown;

      // 先寫 Firestore。
      // 雲端成功後，再更新本機快取，避免本機與雲端不一致。
      if (user != null) {
        final Map<String, dynamic> cloudData = {
          'nickname': nickname,
          'bio': bio,
          'avatarPath': finalAvatarPath,
          'gender': _gender,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (_birthDate != null && _isAgeEditable) {
          cloudData['birthday'] = birthdayStr;
          cloudData['isAgeSet'] = true;
        }

        if (newID != null) {
          cloudData['playerID'] = newID;
        }

        if (hasChangedID != null) {
          cloudData['hasChangedID'] = hasChangedID;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(
          cloudData,
          SetOptions(merge: true),
        );
      }

      // Firestore 儲存成功後，再同步本機資料。
      await prefs.setString(
        'nickname',
        nickname,
      );

      await prefs.setString(
        'bio',
        bio,
      );

      await prefs.setString(
        'avatarPath',
        finalAvatarPath,
      );

      await prefs.setString(
        'gender',
        _gender,
      );

      if (newID != null) {
        await prefs.setString(
          'playerID',
          newID,
        );
      }

      if (hasChangedID != null) {
        await prefs.setBool(
          'hasChangedID',
          hasChangedID,
        );
      }

      if (_birthDate != null && _isAgeEditable) {
        await prefs.setString(
          'birthDate',
          _birthDate!.toIso8601String(),
        );

        await prefs.setBool(
          'isAgeSet',
          true,
        );
      }

      await prefs.setBool(
        'isProfileComplete',
        true,
      );

      // 新頭像與使用者資料都成功儲存後，
      // 最後才清除舊的 Firebase Storage 圖片。
      if (uploadedNewAvatar &&
          oldAvatarUrl.startsWith('http') &&
          oldAvatarUrl != finalAvatarPath) {
        try {
          final oldStorageRef =
          FirebaseStorage.instance.refFromURL(
            oldAvatarUrl,
          );

          await oldStorageRef.delete();

          debugPrint(
            '♻️ 舊頭像已清除：$oldAvatarUrl',
          );
        } catch (e) {
          // 舊圖清理失敗不影響新頭像使用。
          debugPrint(
            '⚠️ 舊頭像清理失敗：$e',
          );
        }
      }

      // 更新目前頁面的狀態，避免尚未跳頁時仍顯示本地暫存路徑。
      _avatarPath = finalAvatarPath;
      _originalAvatarPath = finalAvatarPath;
      _originalNickname = nickname;
      _originalBio = bio;
      _originalGender = _gender;
      _originalBirthDate = _birthDate;

      if (newID != null) {
        _originalID = newID;
      }

      if (hasChangedID != null) {
        _hasChangedID = hasChangedID;
      }

      if (!mounted) return;

      if (popOnSuccess) {
        ToastUtils.showCenterToast(
          context,
          l10n.profile_saved_success,
          customIcon: Icons.account_circle_rounded,
        );

        await Future.delayed(
          const Duration(milliseconds: 300),
        );

        if (!mounted) return;

        if (widget.isCreating) {
          // 第一次建立個人資料時，
          // 才需要進入全新的 MainPage。
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => MainPage(
                initialIndex: targetIndexAfterSave,
              ),
            ),
                (route) => false,
          );
        } else {
          // 一般修改個人資料，只返回原本的個人主頁。
          // 不重建 MainPage，好友與角色清單都會保留。
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {});
      }
    } catch (e) {
      // 如果新圖片已經上傳，但後面的 Firestore 儲存失敗，
      // 嘗試刪掉這張沒有被正式採用的孤兒圖片。
      if (newlyUploadedStorageRef != null) {
        try {
          await newlyUploadedStorageRef.delete();

          debugPrint(
            '♻️ 已清理未完成儲存的新頭像',
          );
        } catch (cleanupError) {
          debugPrint(
            '⚠️ 未完成頭像清理失敗：$cleanupError',
          );
        }
      }

      debugPrint(
        '❌ 個人資料儲存失敗：$e',
      );

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ToastUtils.showCenterToast(
        context,
        l10n.profile_save_failed(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // --- 修正後的完整儲存函式 (加入舊 ID 徹底移除機制) ---
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
  Future<void> _skipEditing() async {
    // 一般編輯模式：直接返回原本的個人主頁
    if (!widget.isCreating) {
      Navigator.of(context).pop(false);
      return;
    }

    // 以下保留首次建立資料的處理
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    try {
      String nickname =
      _nicknameController.text.trim();

      if (nickname.isEmpty) {
        nickname = '初識的旅人';
        _nicknameController.text = nickname;
      }

      final String finalID =
      await _ensureValidPlayerIDForCurrentUser();

      await _saveProfileDataOnly(
        popOnSuccess: true,
        newID: finalID,
        hasChangedID: false,
        targetIndexAfterSave: 0,
      );
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '建立資料失敗: '
            '${e.toString().replaceFirst("Exception: ", "")}',
        isError: true,
      );
    }
  }

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
                    title: Text(l10n.action_choose_from_gallery),
                    onTap: () async {
                      Navigator.pop(context);

                      try {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1024,
                          maxHeight: 1024,
                          imageQuality: 85,
                        );

                        if (image == null) return;

                        await _cropImage(image.path);
                      } catch (e) {
                        debugPrint("❌ 選擇相簿頭像失敗: $e");

                        if (!mounted) return;

                        ToastUtils.showCenterToast(
                          context,
                          '選擇圖片失敗，請重新選擇一張圖片',
                          isError: true,
                        );
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
    if (!mounted) return;

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    try {
      // ✅ 手機版先確認檔案真的存在
      if (!kIsWeb) {
        final file = File(filePath);
        if (!await file.exists()) {
          throw Exception("找不到圖片檔案：$filePath");
        }
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 512,
        maxHeight: 512,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: l10n?.title_adjust_avatar ?? '調整您的時光頭像',
            toolbarColor: theme.colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: l10n?.title_adjust_avatar ?? '調整您的時光頭像',
            cancelButtonTitle: '取消',
            doneButtonTitle: '確定',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
          if (kIsWeb)
            WebUiSettings(
              context: context,
              presentStyle: WebPresentStyle.page,
            ),
        ],
      );

      if (!mounted) return;

      if (croppedFile == null) {
        debugPrint("玩家取消裁切");
        return;
      }

      setState(() {
        _avatarPath = croppedFile.path;
      });

      ToastUtils.showCenterToast(
        context,
        l10n?.avatar_updated_success ?? '已為您換上頭像 🍃',
        customIcon: Icons.face_retouching_natural_rounded,
      );
    } catch (e) {
      debugPrint("❌ 裁切頭像失敗: $e");

      if (!mounted) return;

      // ✅ 不要用原圖保底，避免超大圖造成閃退
      ToastUtils.showCenterToast(
        context,
        '圖片處理失敗，請重新選擇一張圖片',
        isError: true,
      );
    }
  }

  ImageProvider _getEditableAvatarProvider(String path) {
    final normalizedPath = path.trim();

    if (normalizedPath.isEmpty) {
      return const AssetImage(
        'assets/images/avatar1.png',
      );
    }

    // 已上傳的網路圖片，交給共用快取函式
    if (normalizedPath.startsWith('http://') ||
        normalizedPath.startsWith('https://')) {
      return getAvatarImageProvider(normalizedPath);
    }

    // App 內建頭像
    if (normalizedPath.startsWith('assets/')) {
      return AssetImage(normalizedPath);
    }

    // Web 選圖／裁切後的 blob URL
    if (kIsWeb) {
      return NetworkImage(normalizedPath);
    }

    // 手機本地裁切圖片
    final file = File(normalizedPath);

    if (file.existsSync()) {
      return FileImage(file);
    }

    return const AssetImage(
      'assets/images/avatar1.png',
    );
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
                    backgroundImage: _getEditableAvatarProvider(_avatarPath),
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
              controller: _bioController,
              style: TextStyle(
                color: onSurface,
                height: 1.5,
              ),
              minLines: 3,
              maxLines: 5,
              maxLength: 120,
              textInputAction: TextInputAction.newline,
              decoration: customInputDecoration(
                '自我介紹',
                helper: '簡單介紹自己或你的創作風格',
              ).copyWith(
                hintText: '例如：喜歡創作奇幻、病嬌與沉浸式戀愛角色。',
                alignLabelWithHint: true,
                counterText: '',
              ),
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
                    onPressed: _isSaving ? null : _saveProfile,
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
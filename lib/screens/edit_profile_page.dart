import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
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
import 'package:google_fonts/google_fonts.dart';

import '../services/toast_utils.dart';
import '../utils/image_utils.dart';
import 'welcome_guide_page.dart';
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

  // --- 個人連結 ---
  final List<TextEditingController> _linkNameControllers = [];
  final List<TextEditingController> _linkUrlControllers = [];
  List<Map<String, String>> _originalProfileLinks = [];
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
    for (final controller in _linkNameControllers) {
      controller.dispose();
    }
    for (final controller in _linkUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- 個人連結處理 ---
  void _setProfileLinks(dynamic rawLinks) {
    for (final controller in _linkNameControllers) {
      controller.dispose();
    }
    for (final controller in _linkUrlControllers) {
      controller.dispose();
    }

    _linkNameControllers.clear();
    _linkUrlControllers.clear();

    final parsed = <Map<String, String>>[];

    if (rawLinks is List) {
      for (final item in rawLinks) {
        if (item is Map) {
          parsed.add({
            'name': (item['name'] ?? '').toString().trim(),
            'url': (item['url'] ?? '').toString().trim(),
          });
        }
      }
    }

    // 新功能第一次使用時，預設保留 3 格「我的連結」。
    while (parsed.length < 3) {
      parsed.add({
        'name': '我的連結 ${parsed.length + 1}',
        'url': '',
      });
    }

    for (int i = 0; i < parsed.length; i++) {
      final item = parsed[i];
      _linkNameControllers.add(
        TextEditingController(
          text: item['name']!.isEmpty ? '我的連結 ${i + 1}' : item['name'],
        ),
      );
      _linkUrlControllers.add(
        TextEditingController(text: item['url'] ?? ''),
      );
    }

    _originalProfileLinks = _currentProfileLinks();
  }

  List<Map<String, String>> _currentProfileLinks() {
    final result = <Map<String, String>>[];

    for (int i = 0; i < _linkNameControllers.length; i++) {
      result.add({
        'name': _linkNameControllers[i].text.trim(),
        'url': _linkUrlControllers[i].text.trim(),
      });
    }

    return result;
  }

  bool _profileLinksChanged() {
    final current = _currentProfileLinks();

    if (current.length != _originalProfileLinks.length) {
      return true;
    }

    for (int i = 0; i < current.length; i++) {
      if (current[i]['name'] != _originalProfileLinks[i]['name'] ||
          current[i]['url'] != _originalProfileLinks[i]['url']) {
        return true;
      }
    }

    return false;
  }

  void _addProfileLink() {
    setState(() {
      final index = _linkNameControllers.length + 1;
      _linkNameControllers.add(
        TextEditingController(text: '我的連結 $index'),
      );
      _linkUrlControllers.add(TextEditingController());
    });
  }

  void _removeProfileLink(int index) {
    if (index < 0 || index >= _linkNameControllers.length) return;

    setState(() {
      _linkNameControllers.removeAt(index).dispose();
      _linkUrlControllers.removeAt(index).dispose();

      // 至少保留 1 格，避免整個區塊變成空的。
      if (_linkNameControllers.isEmpty) {
        _linkNameControllers.add(
          TextEditingController(text: '我的連結 1'),
        );
        _linkUrlControllers.add(TextEditingController());
      }

      // 刪除後重新整理「系統預設名稱」的編號。
      // 例如刪掉「我的連結 2」後，
      // 原本的「我的連結 3」會自動變成「我的連結 2」。
      // 但玩家自行改過的名稱（例如 Instagram、作品集）不會被改掉。
      for (int i = 0; i < _linkNameControllers.length; i++) {
        final currentName = _linkNameControllers[i].text.trim();
        final isDefaultName =
        RegExp(r'^我的連結\s*\d+$').hasMatch(currentName);

        if (isDefaultName) {
          _linkNameControllers[i].text = '我的連結 ${i + 1}';
        }
      }
    });
  }

  String _profileUiText(String key) {
    final code = Localizations.localeOf(context).languageCode;

    const table = <String, Map<String, String>>{
      'done': {
        'zh': '完成',
        'en': 'Done',
        'ja': '完了',
        'ko': '완료',
        'es': 'Listo',
        'fr': 'Terminé',
        'hi': 'पूर्ण',
        'id': 'Selesai',
        'ms': 'Selesai',
        'pt': 'Concluir',
        'th': 'เสร็จสิ้น',
        'vi': 'Xong',
        'ar': 'تم',
      },
      'socialLinks': {
        'zh': '社群與連結',
        'en': 'Social & Links',
        'ja': 'SNS・リンク',
        'ko': '소셜 및 링크',
        'es': 'Redes y enlaces',
        'fr': 'Réseaux et liens',
        'hi': 'सोशल और लिंक',
        'id': 'Sosial & Tautan',
        'ms': 'Sosial & Pautan',
        'pt': 'Redes e links',
        'th': 'โซเชียลและลิงก์',
        'vi': 'Mạng xã hội & Liên kết',
        'ar': 'الاجتماعي والروابط',
      },
      'addLink': {
        'zh': '新增連結',
        'en': 'Add link',
        'ja': 'リンクを追加',
        'ko': '링크 추가',
        'es': 'Añadir enlace',
        'fr': 'Ajouter un lien',
        'hi': 'लिंक जोड़ें',
        'id': 'Tambah tautan',
        'ms': 'Tambah pautan',
        'pt': 'Adicionar link',
        'th': 'เพิ่มลิงก์',
        'vi': 'Thêm liên kết',
        'ar': 'إضافة رابط',
      },
      'linkNameHint': {
        'zh': '連結名稱',
        'en': 'Link name',
        'ja': 'リンク名',
        'ko': '링크 이름',
        'es': 'Nombre',
        'fr': 'Nom du lien',
        'hi': 'लिंक नाम',
        'id': 'Nama tautan',
        'ms': 'Nama pautan',
        'pt': 'Nome do link',
        'th': 'ชื่อลิงก์',
        'vi': 'Tên liên kết',
        'ar': 'اسم الرابط',
      },
      'linkUrlHint': {
        'zh': '輸入連結',
        'en': 'Enter URL',
        'ja': 'URLを入力',
        'ko': '링크 입력',
        'es': 'Ingresa el enlace',
        'fr': 'Saisir le lien',
        'hi': 'लिंक दर्ज करें',
        'id': 'Masukkan tautan',
        'ms': 'Masukkan pautan',
        'pt': 'Digite o link',
        'th': 'ใส่ลิงก์',
        'vi': 'Nhập liên kết',
        'ar': 'أدخل الرابط',
      },
    };

    final values = table[key];
    if (values == null) return key;
    return values[code] ?? values['en'] ?? key;
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
              _setProfileLinks(data['profileLinks']);
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

        if (widget.isCreating) {
          _setProfileLinks(null);
        } else {
          final rawLinksJson = prefs.getString('profileLinks');
          if (rawLinksJson != null && rawLinksJson.trim().isNotEmpty) {
            try {
              _setProfileLinks(jsonDecode(rawLinksJson));
            } catch (_) {
              _setProfileLinks(null);
            }
          } else {
            _setProfileLinks(null);
          }
        }
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
      throw Exception(l10n.editProfileUserNotFound);
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

      throw Exception(l10n.editProfileGenerateIdFailed);
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
        ) ||
        _profileLinksChanged();
  }


  // --- 生日提醒：首次建立資料時按下「稍後編輯」 ---
  Future<void> _showBirthdayReminderDialog() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editProfileBirthdayReminderTitle),
          content: Text(l10n.editProfileBirthdayReminderContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.editProfileGotIt),
            ),
          ],
        );
      },
    );
  }

  // --- 生日確認：首次建立資料且已選擇生日時 ---
  Future<bool> _showBirthdayConfirmDialog() async {
    if (!mounted) return false;
    final l10n = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editProfileBirthdayConfirmTitle),
          content: Text(l10n.editProfileBirthdayConfirmContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.editProfileReturnToEdit),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.editProfileConfirmSetting),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
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
          nickname = l10n.editProfileDefaultNickname;
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
        l10n.editProfileNoChanges,
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
          throw Exception(l10n.editProfileSignedInUserNotFound);
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
              l10n.editProfileAvatarReadFailed(response.statusCode),
            );
          }

          bytes = response.bodyBytes;
        } else {
          final file = File(finalAvatarPath);

          if (!await file.exists()) {
            throw Exception(
              l10n.editProfileAvatarFileNotFound(finalAvatarPath),
            );
          }

          bytes = await file.readAsBytes();
        }

        if (bytes.isEmpty) {
          throw Exception(l10n.editProfileAvatarEmpty);
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
          'profileLinks': _currentProfileLinks(),
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

        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        debugPrint('🔥 準備儲存個人檔案');
        debugPrint('🔥 uid = ${user.uid}');
        debugPrint('🔥 cloudData = $cloudData');

        final beforeSave = await userRef.get();

        debugPrint('🔥 users 文件存在 = ${beforeSave.exists}');
        debugPrint('🔥 原始資料 = ${beforeSave.data()}');

        await userRef.set(
          cloudData,
          SetOptions(merge: true),
        );

        debugPrint('✅ 個人檔案 Firestore 儲存成功');
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

      await prefs.setString(
        'profileLinks',
        jsonEncode(_currentProfileLinks()),
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
      _originalProfileLinks = _currentProfileLinks();

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
          // 第一次建立完個人資料後，
          // 先進入歡迎導覽，再由導覽前往 MainPage。
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const WelcomeGuidePage(),
            ),
                (route) => false,
          );
        } else {
          // 一般修改個人資料，只返回原本的個人主頁。
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
    final newID = _playerIDController.text.trim();

    try {
      // ✨ 修改 1：拿掉 newID.isEmpty 的報錯。如果有填寫，才檢查長度
      if (newID.isNotEmpty && newID.length > 20) throw Exception(l10n.error_id_too_long);

      final prefs = await SharedPreferences.getInstance();

      // ✨ 修改 2：只有當「有填寫新 ID」且「跟原本不同」且「還沒被鎖定」時，才執行 Firebase 搬家檢查
      if (newID.isNotEmpty && newID != _originalID && !_hasChangedID) {
        final User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) throw Exception(l10n.editProfileUserNotFound);

        // A. 檢查新 ID 是否被別人搶走了
        final idDoc = await _db.collection('playerIDs').doc(newID).get();
        if (idDoc.exists) {
          throw Exception(l10n.error_id_already_used);
        }

        // B. 使用 Transaction 確保搬家過程一氣呵成
        await _db.runTransaction((transaction) async {
          final newIdRef = _db.collection('playerIDs').doc(newID);

          // 先在 transaction 裡再次確認新 ID
          final newIdSnapshot = await transaction.get(newIdRef);

          if (newIdSnapshot.exists) {
            throw Exception(l10n.error_id_already_used);
          }

          DocumentReference<Map<String, dynamic>>? oldIdRef;
          DocumentSnapshot<Map<String, dynamic>>? oldIdSnapshot;

          if (_originalID.isNotEmpty && _originalID != newID) {
            oldIdRef = _db.collection('playerIDs').doc(_originalID);
            oldIdSnapshot = await transaction.get(oldIdRef);
          }

          // 建立新的玩家 ID 對照
          transaction.set(
            newIdRef,
            {'uid': currentUser.uid},
          );

          // 舊 ID 文件真的存在，而且確定是自己的，才刪
          if (oldIdRef != null &&
              oldIdSnapshot != null &&
              oldIdSnapshot.exists &&
              oldIdSnapshot.data()?['uid'] == currentUser.uid) {
            transaction.delete(oldIdRef);
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
    final l10n = AppLocalizations.of(context)!;
    // 一般編輯模式：直接返回原本的個人主頁
    if (!widget.isCreating) {
      Navigator.of(context).pop(false);
      return;
    }

    // 以下保留首次建立資料的處理
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    // 只要這次會「第一次設定生日」，就跳確認
    final bool isSettingBirthdayNow =
        _birthDate != null &&
            _isAgeEditable &&
            !_isSameDate(_birthDate, _originalBirthDate);

    if (isSettingBirthdayNow) {
      final bool confirmed = await _showBirthdayConfirmDialog();

      if (!confirmed || !mounted) {
        return;
      }
    }

    // 首次建立資料按下「稍後編輯」時，先說明生日用途與限制。
    await _showBirthdayReminderDialog();

    if (!mounted) return;

    try {
      String nickname =
      _nicknameController.text.trim();

      if (nickname.isEmpty) {
        nickname = l10n.editProfileDefaultNickname;
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
        l10n.editProfileCreateFailed(
          e.toString().replaceFirst("Exception: ", ""),
        ),
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
      locale: Localizations.localeOf(context),
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
                      title: Text(l10n.editProfileAvatarNumber(index)),
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
                          l10n.editProfileImageSelectionFailed,
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
    final l10n = AppLocalizations.of(context)!;

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
            toolbarTitle: l10n.title_adjust_avatar,
            toolbarColor: theme.colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: l10n.title_adjust_avatar,
            cancelButtonTitle: l10n.editProfileCancel,
            doneButtonTitle: l10n.editProfileConfirm,
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
        l10n.avatar_updated_success,
        customIcon: Icons.face_retouching_natural_rounded,
      );
    } catch (e) {
      debugPrint("❌ 裁切頭像失敗: $e");

      if (!mounted) return;

      // ✅ 不要用原圖保底，避免超大圖造成閃退
      ToastUtils.showCenterToast(
        context,
        l10n.editProfileImageProcessingFailed,
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
    final l10n = AppLocalizations.of(context)!;

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
            return Center(
              child: Text(
                l10n.editProfileLoadFailed(snapshot.error.toString()),
              ),
            );
          }
          return _buildPageContent();
        },
      ),
    );
  }

  Widget _buildPageContent() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final l10n = AppLocalizations.of(context)!;

    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    final double horizontalPadding =
    (screenWidth * 0.065).clamp(20.0, 46.0).toDouble();

    final double labelWidth =
    (screenWidth * 0.22).clamp(84.0, 126.0).toDouble();

    final double topRightFlowerWidth =
    (screenWidth * 0.34).clamp(130.0, 230.0).toDouble();
    final double bottomLeftFlowerWidth =
    (screenWidth * 0.42).clamp(150.0, 280.0).toDouble();

    final double topRightHorizontalOffset =
    -(screenWidth * 0.06).clamp(18.0, 44.0).toDouble();
    final double topRightVerticalOffset =
    -(screenHeight * 0.012).clamp(8.0, 20.0).toDouble();

    final double bottomLeftHorizontalOffset =
    -(screenWidth * 0.08).clamp(22.0, 52.0).toDouble();
    final double bottomLeftVerticalOffset =
    -(screenHeight * 0.012).clamp(8.0, 22.0).toDouble();

    final fieldTextStyle = GoogleFonts.notoSerifTc(
      color: onSurface,
      fontSize: 14,
      height: 1.5,
    );

    final labelStyle = GoogleFonts.notoSerifTc(
      color: Colors.black87,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    InputDecoration lineDecoration({
      String? hintText,
      int? maxLength,
    }) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.notoSerifTc(
          color: onSurface.withValues(alpha: 0.34),
          fontSize: 12,
        ),
        counterStyle: GoogleFonts.notoSerifTc(
          color: onSurface.withValues(alpha: 0.42),
          fontSize: 10.5,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(0, 6, 0, 8),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.22),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.65),
            width: 1.2,
          ),
        ),
      );
    }

    Widget labeledField({
      required String label,
      required Widget child,
      String? helperText,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          const SizedBox(height: 6),
          child,
          if (helperText != null && helperText.trim().isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              helperText,
              style: GoogleFonts.notoSerifTc(
                color: primaryColor.withValues(alpha: 0.58),
                fontSize: 10.5,
              ),
            ),
          ],
        ],
      );
    }

    Widget buildProfileLinkRow(int index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: labelWidth + 54,
              child: TextField(
                controller: _linkNameControllers[index],
                style: GoogleFonts.notoSerifTc(
                  color: onSurface,
                  fontSize: 13,
                ),
                maxLines: 1,
                decoration: lineDecoration(
                  hintText: _profileUiText('linkNameHint'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _linkUrlControllers[index],
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                style: GoogleFonts.notoSerifTc(
                  color: onSurface,
                  fontSize: 12,
                ),
                decoration: lineDecoration(
                  hintText: _profileUiText('linkUrlHint'),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              visualDensity: VisualDensity.compact,
              onPressed: () => _removeProfileLink(index),
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 19,
                color: primaryColor.withValues(alpha: 0.60),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          widget.isCreating
              ? l10n.title_create_profile
              : l10n.title_edit_profile,
          style: GoogleFonts.notoSerifTc(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          if (!widget.isCreating)
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: _isSaving
                  ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
                  : Text(
                _profileUiText('done'),
                style: GoogleFonts.notoSerifTc(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: topRightVerticalOffset,
            right: topRightHorizontalOffset,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.18,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    primaryColor.withValues(alpha: 0.80),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/images/studio/studio_top_right.png',
                    width: topRightFlowerWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: bottomLeftHorizontalOffset,
            bottom: bottomLeftVerticalOffset,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.20,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    primaryColor.withValues(alpha: 0.80),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    'assets/images/heartbeat_diary/botanical_left.png',
                    width: bottomLeftFlowerWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                42,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.10),
                                blurRadius: 20,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor:
                            primaryColor.withValues(alpha: 0.08),
                            backgroundImage:
                            _getEditableAvatarProvider(_avatarPath),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: GestureDetector(
                            onTap: _showAvatarSelectionDialog,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    primaryColor.withValues(alpha: 0.18),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),

                  labeledField(
                    label: l10n.label_your_nickname,
                    child: TextField(
                      controller: _nicknameController,
                      maxLength: 20,
                      style: fieldTextStyle,
                      decoration: lineDecoration(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  labeledField(
                    label: l10n.editProfileBioLabel,
                    child: TextField(
                      controller: _bioController,
                      minLines: 3,
                      maxLines: 8,
                      maxLength: 450,
                      textInputAction: TextInputAction.newline,
                      style: fieldTextStyle,
                      decoration: lineDecoration(
                        hintText: l10n.editProfileBioHint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  labeledField(
                    label: l10n.label_player_exclusive_id,
                    helperText: _hasChangedID
                        ? l10n.msg_id_locked
                        : l10n.msg_id_change_chance,
                    child: TextField(
                      controller: _playerIDController,
                      readOnly: _hasChangedID,
                      maxLength: 20,
                      style: fieldTextStyle,
                      decoration: lineDecoration(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  labeledField(
                    label: l10n.charGenderLabel,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Radio<String>(
                          value: '男',
                          groupValue: _gender,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                        Text(
                          l10n.genderMale,
                          style: GoogleFonts.notoSerifTc(fontSize: 13),
                        ),
                        Radio<String>(
                          value: '女',
                          groupValue: _gender,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                        Text(
                          l10n.genderFemale,
                          style: GoogleFonts.notoSerifTc(fontSize: 13),
                        ),
                        Radio<String>(
                          value: '未選擇',
                          groupValue: _gender,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                        Text(
                          l10n.genderNotSelected,
                          style: GoogleFonts.notoSerifTc(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  labeledField(
                    label: l10n.action_select_birthdate,
                    child: InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cake_outlined,
                              size: 22,
                              color:
                              primaryColor.withValues(alpha: 0.75),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _birthDate == null
                                    ? l10n.action_select_birthdate
                                    : DateFormat('yyyy-MM-dd')
                                    .format(_birthDate!),
                                style: fieldTextStyle,
                              ),
                            ),
                            Icon(
                              _isAgeEditable
                                  ? Icons.edit_rounded
                                  : Icons.lock_outline_rounded,
                              size: 20,
                              color:
                              primaryColor.withValues(alpha: 0.65),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_isAgeEditable && !widget.isCreating)
                    Padding(
                      padding: EdgeInsets.only(
                        left: labelWidth + 12,
                        top: 4,
                      ),
                      child: Text(
                        l10n.msg_birthdate_immutable,
                        style: GoogleFonts.notoSerifTc(
                          color:
                          primaryColor.withValues(alpha: 0.56),
                          fontSize: 11.5,
                        ),
                      ),
                    ),

                  const SizedBox(height: 22),
                  Divider(
                    color: primaryColor.withValues(alpha: 0.16),
                    height: 1,
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Icon(
                        Icons.link_rounded,
                        size: 19,
                        color: primaryColor.withValues(alpha: 0.72),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _profileUiText('socialLinks'),
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                          primaryColor.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...List.generate(
                    _linkNameControllers.length,
                    buildProfileLinkRow,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: _addProfileLink,
                      icon: const Icon(Icons.add_rounded, size: 19),
                      label: Text(
                        _profileUiText('addLink'),
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(
                          color:
                          primaryColor.withValues(alpha: 0.40),
                        ),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),

                  if (widget.isCreating) ...[
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: const StadiumBorder(),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          l10n.action_start_journey,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _skipEditing,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(
                            color:
                            primaryColor.withValues(alpha: 0.55),
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          l10n.action_edit_later_short,
                          style:
                          GoogleFonts.notoSerifTc(fontSize: 14),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
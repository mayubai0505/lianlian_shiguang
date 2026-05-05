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

  // ✨ 發布動態的核心邏輯 (恢復單純的發文邏輯)
  Future<void> _postMoment() async {
    final l10n = AppLocalizations.of(context)!;
    final content = _contentController.text.trim();
    if (content.isEmpty && _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.moment_create_error_empty)),
      );
      return;
    }
    if (_userId == null) return;

    setState(() => _isPosting = true);

    try {
      String? imageUrl;
      // 如果有選擇圖片，就先上傳
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
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(l10n.moment_create_error_failed)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
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
    final themeNotifier = Provider.of<ThemeNotifier>(context); // 如果妳沒有用 Provider，這行跟 body 的 decoration 可能要調整
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moment_create_title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _isPosting ? null : _postMoment,
              child: _isPosting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n.moment_create_post_btn, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          // 確保背景顏色有吃到主題，如果報錯可以改成 color: theme.scaffoldBackgroundColor
          decoration: themeNotifier.currentBackground,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 乾淨的 UI：只顯示傳進來的發文者頭像與名字
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: _getAvatarProvider(widget.authorAvatar),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.authorName,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: l10n.moment_create_hint,
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 顯示已選擇的圖片預覽
                      if (_pickedImage != null)
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(File(_pickedImage!.path)),
                            ),
                            IconButton(
                              icon: const CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                              onPressed: () => setState(() => _pickedImage = null),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isPublic ? Icons.public : Icons.lock_outline,
                        color: _isPublic ? Colors.lightBlueAccent : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(_isPublic ? l10n.moment_create_visibility_public : l10n.moment_create_visibility_private,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isPublic ? Colors.lightBlueAccent : Colors.grey
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isPublic,
                    activeColor: Colors.lightBlueAccent,
                    onChanged: (val) => setState(() => _isPublic = val),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.photo_library_outlined, color: theme.colorScheme.primary),
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
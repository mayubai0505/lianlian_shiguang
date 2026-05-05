import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:async'; // ✨ 加上這個 import 就可以了！
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//圖片上傳

class StorageTestPage extends StatefulWidget {
  const StorageTestPage({super.key});

  @override
  State<StorageTestPage> createState() => _StorageTestPageState();
}

class _StorageTestPageState extends State<StorageTestPage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  XFile? _selectedImage;
  Uint8List? _imageBytes;
  String _status = '請先選擇一張圖片';
  String? _downloadUrl;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    setState(() {
      _status = '正在選擇圖片...';
      _selectedImage = null;
      _imageBytes = null;
      _downloadUrl = null;
    });

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _status = '圖片已選擇！路徑: ${image.path}';
        _selectedImage = image;
        _imageBytes = bytes;
      });
    } else {
      setState(() {
        _status = '已取消選擇';
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) {
      setState(() {
        _status = '錯誤：請先選擇一張圖片才能上傳！';
      });
      return;
    }

    setState(() {
      _status = '上傳中，請稍候...';
      _downloadUrl = null;
    });

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _status = '錯誤：使用者未登入';
      });
      return;
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = _storage
          .ref()
          .child('test_uploads')
          .child(currentUser.uid)
          .child(fileName);
      final metadata = SettableMetadata(contentType: 'image/png');

      print('--- 開始上傳到 Firebase Storage ---');
      await ref
          .putData(_imageBytes!, metadata)
          .timeout(const Duration(seconds: 60));
      print('--- 上傳成功！正在取得下載網址... ---');

      final url = await ref.getDownloadURL();
      print('--- 取得網址成功！URL: $url ---');

      setState(() {
        _status = '上傳成功！';
        _downloadUrl = url;
      });
    } on TimeoutException catch (_) {
      print('!!! 上傳超時 !!!');
      setState(() {
        _status = '錯誤：上傳超時！請檢查網路。';
      });
    } catch (e) {
      print('!!! 上傳失敗: $e');
      setState(() {
        _status = '錯誤：上傳失敗！詳情請見除錯主控台。';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ 關鍵：獲取當前的主題數據
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage 測試'),
        // AppBar 會自動抓取主題，但我們確保背景色跟隨主題
        backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // 🖼️ 預覽區：邊框顏色跟隨主題
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant, // 跟隨主題的次要背景色
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                )
                    : Icon(Icons.image, size: 80, color: colorScheme.outline),
              ),
              const SizedBox(height: 20),

              // 📊 狀態顯示：使用主題的 PrimaryContainer
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.primary.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _status,
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🔘 按鈕區
              if (_isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                )
              else ...[
                // 選擇按鈕：使用 OutlinedButton 增加層次感
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('1. 選擇圖片'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // 上傳按鈕：使用主題的主色 (Primary)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _imageBytes == null ? null : _uploadImage,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('2. 上傳到 Firebase'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      // 禁用時的顏色會由 FilledButton 自動處理
                    ),
                  ),
                ),
              ],

              if (_downloadUrl != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '下載網址：',
                    style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _downloadUrl!,
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

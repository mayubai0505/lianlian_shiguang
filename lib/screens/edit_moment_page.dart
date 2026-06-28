import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // ✨ 1. 引入 Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart';   // ✨ 2. 引入 Firestore
import '../models/moment_model.dart';
import '../services/toast_utils.dart';
import '../utils/image_utils.dart';
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

//編輯動態

class EditMomentPage extends StatefulWidget {
  final Moment momentToEdit;
  const EditMomentPage({super.key, required this.momentToEdit});

  @override
  State<EditMomentPage> createState() => _EditMomentPageState();
}

class _EditMomentPageState extends State<EditMomentPage> {
  // --- 控制器與狀態 ---
  late final TextEditingController _contentController;
  String? _imagePath;         // 當前圖片路徑 (URL 或本地路徑)
  bool _imageChanged = false; // 標記圖片是否有更換
  bool _isSaving = false;     // 儲存狀態鎖
  final ImagePicker _picker = ImagePicker();
  final String APP_ID = AppConfig.appId;
  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.momentToEdit.content);
    _imagePath = widget.momentToEdit.imageUrl;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // 📸 從相簿選擇圖片
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // 降低畫質節省流量
      maxWidth: 1080,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _imageChanged = true;
      });
    }
  }

  // 🚀 核心儲存邏輯
  Future<void> _saveChanges() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isSaving) return;

    final newContent = _contentController.text.trim();

    if (newContent == widget.momentToEdit.content && !_imageChanged) {
      ToastUtils.showCenterToast(
        context,
        l10n.common_no_changes,
        customIcon: Icons.history_edu_rounded,
      );

      if (!mounted) return;

      Navigator.of(context).pop({
        'changed': false,
        'momentId': widget.momentToEdit.id,
      });
      return;
    }

    setState(() => _isSaving = true);

    bool shouldSkipResetSaving = false;

    final String? oldImageUrlToCleanup = widget.momentToEdit.imageUrl;

    // ✅ 重點：放在 try 外面，後面 Navigator.pop 才拿得到
    String? finalImageUrl = widget.momentToEdit.imageUrl;

    try {
      if (_imageChanged) {
        if (_imagePath != null && !_imagePath!.startsWith('http')) {
          final file = File(_imagePath!);
          final ref = FirebaseStorage.instance.ref(
            'moment_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );

          await ref.putFile(file);
          finalImageUrl = await ref.getDownloadURL();
        } else if (_imagePath == null) {
          finalImageUrl = null;
        }
      }

      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('moments')
          .doc(widget.momentToEdit.id)
          .update({
        'content': newContent,
        'imageUrl': finalImageUrl,
        'lastEditedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (_imageChanged &&
          oldImageUrlToCleanup != null &&
          oldImageUrlToCleanup.startsWith('http') &&
          oldImageUrlToCleanup != finalImageUrl) {
        _deleteImageFromStorage(oldImageUrlToCleanup);
      }

      if (!mounted) return;

      shouldSkipResetSaving = true;

      Navigator.of(context).pop({
        'changed': true,
        'momentId': widget.momentToEdit.id,
        'content': newContent,
        'imageUrl': finalImageUrl,
      });
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        l10n.common_save_failed(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted && !shouldSkipResetSaving) {
        setState(() => _isSaving = false);
      }
    }
  }

  // 🗑️ 垃圾車：刪除 Storage 上的檔案
  void _deleteImageFromStorage(String url) async {
    try {
      if (url.contains('firebasestorage.googleapis.com')) {
        await FirebaseStorage.instance.refFromURL(url).delete();
        print("🗑️ 舊圖片已成功銷毀：$url");
      }
    } catch (e) {
      print("⚠️ 刪除舊圖片失敗 (可能本來就不存在): $e");
    }
  }

  // --- UI 組件 ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moment_edit_title),
        actions: [
          _isSaving
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)),
          )
              : IconButton(
            icon: const Icon(Icons.check),
            tooltip: l10n.saveButton,
            onPressed: _isSaving ? null : _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: '分享你的心情...', border: InputBorder.none),
              maxLines: null,
              autofocus: true,
            ),
            const SizedBox(height: 20),
            _buildImagePreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    final l10n = AppLocalizations.of(context)!;
    if (_imagePath == null || _imagePath!.isEmpty) {
      return ElevatedButton.icon(
        icon:Icon(Icons.add_photo_alternate_outlined),
        label:Text(l10n.action_add_image),
        onPressed: _pickImage,
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 420,
            ),
            width: double.infinity,
            color: Colors.black12,
            child: _imagePath!.startsWith('http')
                ? Image.network(
              _imagePath!,
              fit: BoxFit.contain,
            )
                : Image.file(
              File(_imagePath!),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l10n.action_change_image),
              onPressed: _pickImage,
            ),
            const SizedBox(width: 20),
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label:Text(l10n.action_remove_image, style: TextStyle(color: Colors.red)),
              onPressed: () => setState(() {
                _imagePath = null;
                _imageChanged = true;
              }),
            ),
          ],
        )
      ],
    );
  }
}
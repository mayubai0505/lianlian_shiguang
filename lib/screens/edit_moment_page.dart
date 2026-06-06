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

    // 檢查是否有變更，沒變更就直接退回
    if (newContent == widget.momentToEdit.content && !_imageChanged) {
      // ✨ 總裁級防呆：無效修改的溫柔攔截，伴隨完美的過場退場！
      ToastUtils.showCenterToast(
        context,
        l10n.common_no_changes,
        customIcon: Icons.history_edu_rounded, // 💡 總裁精選：帶有「維持原案/筆記」意象的輕柔圖示
        // 💡 總裁秘技：若想表達「一切如常」，也可以使用 Icons.done_all_rounded
        // 或是 Icons.edit_off_rounded，語意會非常精準。
      );
      Navigator.pop(context); // 帶著懸浮提示，行雲流水地滑回上一頁
      return;
    }

    setState(() => _isSaving = true);

    // 🌟 1. 先把「舊圖片網址」記下來，等更新成功後再刪除
    final String? oldImageUrlToCleanup = widget.momentToEdit.imageUrl;

    try {
      String? finalImageUrl = widget.momentToEdit.imageUrl;

      // 🌟 2. 如果圖片有變動，處理上傳或清空
      if (_imageChanged) {
        if (_imagePath != null && !_imagePath!.startsWith('http')) {
          // A. 選了新圖：上傳到 Firebase Storage
          final file = File(_imagePath!);
          final ref = FirebaseStorage.instance.ref('moment_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(file);
          finalImageUrl = await ref.getDownloadURL();
        } else if (_imagePath == null) {
          // B. 點了移除圖片：將 URL 設為 null
          finalImageUrl = null;
        }
      }

      // 🌟 3. 正式更新 Firestore 資料庫
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('moments')
          .doc(widget.momentToEdit.id)
          .update({
        'content': newContent,
        'imageUrl': finalImageUrl,
        'lastEditedAt': FieldValue.serverTimestamp(),
      });

      // 🌟 4. 更新成功！現在才叫垃圾車出動清理舊圖 🚛💨
      if (_imageChanged && oldImageUrlToCleanup != null && oldImageUrlToCleanup.startsWith('http')) {
        _deleteImageFromStorage(oldImageUrlToCleanup);
      }

      if (mounted) {
        // ✨ 總裁級：動態更新成功的完美轉場，徹底告別 SnackBar 跨頁面的閃爍災難！
        ToastUtils.showCenterToast(
          context,
          l10n.moment_updated_success,
          customIcon: Icons.task_alt_rounded, // 💡 總裁精選：帶有「俐落完成、打勾確認」意象的完美圖示
          // 💡 總裁秘技：如果想強調「圖文已經為您修改好囉」，
          // 換成 Icons.edit_note_rounded 或 Icons.photo_filter_rounded 也會非常有質感！
        );

        Navigator.pop(context, true); // 返回上一頁並傳回 true，行雲流水，毫無破綻！
      }
    } catch (e) {
      if (mounted) {
        // ✨ 總裁級防護：通用儲存失敗的終極兜底！妥善包裝未知錯誤，維持系統優雅！
        ToastUtils.showCenterToast(
          context,
          l10n.common_save_failed(e.toString()),
          isError: true, // 💡 全域統一的紅色驚嘆號，清楚傳達異常狀態
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
            onPressed: _saveChanges,
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
          child: _imagePath!.startsWith('http')
              ? Image.network(_imagePath!, fit: BoxFit.cover)
              : Image.file(File(_imagePath!), fit: BoxFit.cover),
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
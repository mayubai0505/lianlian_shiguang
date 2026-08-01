import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import 'package:url_launcher/url_launcher.dart'; // ✨ 1. 引入 url_launcher 套件
import 'package:flutter/services.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

import '../services/toast_utils.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// 意見回饋

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() =>
      _FeedbackPageState();
}

class _FeedbackPageState
    extends State<FeedbackPage> {
  final TextEditingController
  _feedbackController =
  TextEditingController();

  final ImagePicker _imagePicker =
  ImagePicker();

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  bool _isPickingImage = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage ||
        _isSubmitting) {
      return;
    }

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? image =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image == null) return;

      final Uint8List bytes =
      await image.readAsBytes();

      const int maxImageBytes =
          10 * 1024 * 1024;

      if (bytes.lengthInBytes >
          maxImageBytes) {
        if (!mounted) return;

        ToastUtils.showCenterToast(
          context,
          '圖片大小不能超過 10 MB',
          isError: true,
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    } catch (error, stackTrace) {
      debugPrint(
        '選擇回報圖片失敗：$error',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '無法選擇圖片，請稍後再試',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  void _removeSelectedImage() {
    if (_isSubmitting) return;

    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
  }

  String _getFileExtension(
      String fileName,
      ) {
    final int dotIndex =
    fileName.lastIndexOf('.');

    if (dotIndex < 0 ||
        dotIndex ==
            fileName.length - 1) {
      return 'jpg';
    }

    return fileName
        .substring(dotIndex + 1)
        .toLowerCase();
  }

  String _getContentType(
      String extension,
      ) {
    switch (extension) {
      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'gif':
        return 'image/gif';

      case 'heic':
      case 'heif':
        return 'image/heic';

      case 'jpeg':
      case 'jpg':
      default:
        return 'image/jpeg';
    }
  }

  Future<String?> _uploadImage({
    required String reportId,
    required String userId,
  }) async {
    final XFile? image =
        _selectedImage;

    final Uint8List? bytes =
        _selectedImageBytes;

    if (image == null ||
        bytes == null) {
      return null;
    }

    final String extension =
    _getFileExtension(image.name);

    final Reference imageRef =
    FirebaseStorage.instance
        .ref()
        .child('feedback_images')
        .child(userId)
        .child(
      '${reportId}_'
          '${DateTime.now().millisecondsSinceEpoch}'
          '.$extension',
    );

    final SettableMetadata metadata =
    SettableMetadata(
      contentType:
      _getContentType(extension),
      customMetadata: {
        'reportId': reportId,
        'userId': userId,
        'originalFileName':
        image.name,
      },
    );

    await imageRef.putData(
      bytes,
      metadata,
    );

    return imageRef.getDownloadURL();
  }

  Future<void> _submitFeedback() async {
    final l10n =
    AppLocalizations.of(context)!;

    final String feedbackText =
    _feedbackController.text.trim();

    if (feedbackText.isEmpty) {
      ToastUtils.showCenterToast(
        context,
        l10n.error_feedback_empty,
        isError: true,
      );
      return;
    }

    if (_isSubmitting) return;

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      ToastUtils.showCenterToast(
        context,
        '請先登入後再送出回報',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String? uploadedImageUrl;

    try {
      final DocumentReference<
          Map<String, dynamic>>
      reportRef =
      FirebaseFirestore.instance
          .collection('reports')
          .doc();

      uploadedImageUrl =
      await _uploadImage(
        reportId: reportRef.id,
        userId: user.uid,
      );

      final userSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final Map<String, dynamic>
      userData =
          userSnapshot.data() ??
              <String, dynamic>{};

      final String nickname =
          userData['nickname']
              ?.toString()
              .trim() ??
              user.displayName?.trim() ??
              '未命名玩家';

      await reportRef.set({
        'type': 'feedback',
        'relatedType':
        'contact_us',
        'status': 'pending',

        'content': feedbackText,

        'reporterId': user.uid,
        'createdBy': user.uid,
        'reporterName': nickname,
        'reporterEmail':
        user.email ?? '',

        'imageUrl':
        uploadedImageUrl ?? '',
        'hasImage':
        uploadedImageUrl != null,

        'createdAt':
        FieldValue.serverTimestamp(),
        'updatedAt':
        FieldValue.serverTimestamp(),

        'adminReply': '',
      });

      if (!mounted) return;

      _feedbackController.clear();

      setState(() {
        _selectedImage = null;
        _selectedImageBytes = null;
      });

      ToastUtils.showCenterToast(
        context,
        '回報已成功送出，謝謝你的意見！',
        customIcon:
        Icons.mark_email_read_rounded,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '送出玩家回報失敗：$error',
      );
      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '送出失敗，請確認網路後再試',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
    Theme.of(context);

    final ThemeNotifier themeNotifier =
    Provider.of<ThemeNotifier>(
      context,
    );

    final l10n =
    AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.title_contact_us,
        ),
        backgroundColor:
        Colors.transparent,
        elevation: 0,
        foregroundColor:
        theme.colorScheme.onSurface,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
          themeNotifier.currentBackground,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight +
                  MediaQuery.of(context)
                      .padding
                      .top +
                  20,
              left: 24,
              right: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  l10n
                      .title_contact_us_heading,
                  style:
                  theme.textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  l10n.desc_contact_us_body,
                  style: theme
                      .textTheme.bodyLarge
                      ?.copyWith(
                    color: theme
                        .colorScheme.onSurface
                        .withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                TextField(
                  controller:
                  _feedbackController,
                  maxLines: 8,
                  enabled: !_isSubmitting,
                  decoration:
                  InputDecoration(
                    hintText:
                    l10n.hint_enter_feedback,
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.cardColor
                        .withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Icon(
                      Icons
                          .add_photo_alternate_outlined,
                      color: theme
                          .colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '附加圖片（非必填）',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  '回報 Bug 或花花未入帳時，'
                      '可以附上畫面截圖，方便官方確認問題。',
                  style: theme
                      .textTheme.bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme.onSurface
                        .withValues(
                      alpha: 0.6,
                    ),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                if (_selectedImageBytes ==
                    null)
                  OutlinedButton.icon(
                    onPressed:
                    _isPickingImage ||
                        _isSubmitting
                        ? null
                        : _pickImage,
                    icon: _isPickingImage
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(
                      Icons
                          .photo_library_outlined,
                    ),
                    label: Text(
                      _isPickingImage
                          ? '開啟相簿中...'
                          : '從相簿選擇圖片',
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      minimumSize:
                      const Size(
                        double.infinity,
                        50,
                      ),
                    ),
                  )
                else
                  _buildSelectedImagePreview(
                    theme,
                  ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed:
                  _isSubmitting
                      ? null
                      : _submitFeedback,
                  icon: _isSubmitting
                      ? const SizedBox(
                    width: 19,
                    height: 19,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(
                    Icons
                        .send_rounded,
                  ),
                  label: Text(
                    _isSubmitting
                        ? '送出中...'
                        : '送出回報',
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    minimumSize:
                    const Size(
                      double.infinity,
                      50,
                    ),
                    textStyle:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview(
      ThemeData theme,
      ) {
    final Uint8List? imageBytes =
        _selectedImageBytes;

    if (imageBytes == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor
            .withValues(alpha: 0.65),
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline
              .withValues(alpha: 0.18),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.memory(
                  imageBytes,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.black
                      .withValues(
                    alpha: 0.55,
                  ),
                  shape:
                  const CircleBorder(),
                  child: IconButton(
                    tooltip: '移除圖片',
                    onPressed:
                    _isSubmitting
                        ? null
                        : _removeSelectedImage,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              12,
              10,
              12,
              12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedImage?.name ??
                        '已選擇圖片',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed:
                  _isPickingImage ||
                      _isSubmitting
                      ? null
                      : _pickImage,
                  icon: const Icon(
                    Icons.swap_horiz_rounded,
                    size: 18,
                  ),
                  label:
                  const Text('更換'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
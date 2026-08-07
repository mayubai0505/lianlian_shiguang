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

enum ReportCategory {
  feedback,
  bug,
  suggestion,
  flower,
  payment,
  aiReply,
  character,
  moment,
}

class FeedbackPage extends StatefulWidget {
  final ReportCategory category;
  final String? initialReason;
  /// true = 從聊天室／角色／貼文進來，
  /// 類型固定，不讓玩家自己切換。
  final bool lockCategory;

  final String? characterId;
  final String? characterName;

  final String? sessionId;
  final String? messageId;

  final String? momentId;

  /// 例如：被檢舉的 AI 訊息內容
  final String? reportedContent;

  const FeedbackPage({
    super.key,
    this.category = ReportCategory.feedback,
    this.lockCategory = false,
    this.characterId,
    this.characterName,
    this.sessionId,
    this.messageId,
    this.momentId,
    this.reportedContent,
    this.initialReason,
  });

  @override
  State<FeedbackPage> createState() =>
      _FeedbackPageState();
}

class _FeedbackPageState
    extends State<FeedbackPage> {
  final TextEditingController
  _feedbackController =
  TextEditingController();
  late ReportCategory _selectedCategory;
  late String _selectedReason;
  final ImagePicker _imagePicker =
  ImagePicker();

  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;

  bool _isPickingImage = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _selectedCategory =
        widget.category;

    _selectedReason =
        widget.initialReason ?? '';
  }

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

  String _categoryLabel(
      ReportCategory category,
      ) {
    switch (category) {
      case ReportCategory.feedback:
        return '一般問題';

      case ReportCategory.bug:
        return 'Bug 回報';

      case ReportCategory.suggestion:
        return '功能建議';

      case ReportCategory.flower:
        return '花花點數問題';

      case ReportCategory.payment:
        return '儲值／付款問題';

      case ReportCategory.aiReply:
        return 'AI 回覆異常';

      case ReportCategory.character:
        return '角色檢舉';

      case ReportCategory.moment:
        return '貼文檢舉';
    }
  }

  bool get _requiresScreenshot {
    return _selectedCategory ==
        ReportCategory.bug ||
        _selectedCategory ==
            ReportCategory.flower ||
        _selectedCategory ==
            ReportCategory.payment;
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

    if (_requiresScreenshot &&
        _selectedImage == null) {
      ToastUtils.showCenterToast(
        context,
        '此類問題請附上畫面截圖，方便我們確認狀況',
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

        // ⭐ 新的統一分類
        'category':
        _selectedCategory.name,

        'categoryLabel':
        _categoryLabel(
          _selectedCategory,
        ),

        // 保留舊欄位相容後台
        'relatedType':
        _selectedCategory ==
            ReportCategory.aiReply
            ? 'chat'
            : _selectedCategory ==
            ReportCategory.character
            ? 'character'
            : _selectedCategory ==
            ReportCategory.moment
            ? 'moment'
            : 'contact_us',

        'status': 'pending',

        // 玩家補充說明
        'content': feedbackText,
        'reason': _selectedReason,

        // ⭐ 如果是從聊天訊息進來，
        // 把原本被檢舉內容一起保存
        'reportedContent':
        widget.reportedContent ?? '',

        // ⭐ 角色相關
        'characterId':
        widget.characterId ?? '',

        'characterName':
        widget.characterName ?? '',

        // ⭐ 聊天相關
        'sessionId':
        widget.sessionId ?? '',

        'messageId':
        widget.messageId ?? '',

        // ⭐ Moment
        'momentId':
        widget.momentId ?? '',

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

// ⭐ 如果是從聊天室／角色／貼文進來
// 就直接回上一頁
      if (widget.lockCategory &&
          Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        return;
      }

// ⭐ 一般客服中心維持原本行為
      ToastUtils.showCenterToast(
        context,
        '回報已成功送出，謝謝你的意見！',
        customIcon: Icons.mark_email_read_rounded,
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
        // ⭐ 標題搬到下面的 ScrollView
        title: null,
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
                // ⭐ 這個「聯絡我們」現在會跟著內容一起滑
                Text(
                  l10n.title_contact_us,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  l10n.title_contact_us_heading,
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

                Text(
                  '問題類型',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                if (widget.lockCategory)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(
                        alpha: 0.55,
                      ),
                      borderRadius:
                      BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline
                            .withValues(
                          alpha: 0.18,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.support_agent_rounded,
                          color:
                          theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _categoryLabel(
                            _selectedCategory,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  DropdownButtonFormField<
                      ReportCategory>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor:
                      theme.cardColor.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    items: ReportCategory.values
                        .where(
                          (category) =>
                      category !=
                          ReportCategory
                              .aiReply &&
                          category !=
                              ReportCategory
                                  .character &&
                          category !=
                              ReportCategory
                                  .moment,
                    )
                        .map(
                          (category) =>
                          DropdownMenuItem<
                              ReportCategory>(
                            value: category,
                            child: Text(
                              _categoryLabel(
                                category,
                              ),
                            ),
                          ),
                    )
                        .toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                      if (value == null) return;

                      setState(() {
                        _selectedCategory =
                            value;
                      });
                    },
                  ),

                const SizedBox(height: 20),

                if (widget.reportedContent != null &&
                    widget.reportedContent!
                        .trim()
                        .isNotEmpty) ...[
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme
                          .surfaceContainerHighest
                          .withValues(
                        alpha: 0.45,
                      ),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          '被回報的內容',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                            FontWeight.bold,
                            color: theme
                                .colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.reportedContent!,
                          style: const TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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
                    Expanded(
                      child: Text(
                        _requiresScreenshot
                            ? '問題截圖（必填）'
                            : '附加圖片（選填）',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  _requiresScreenshot
                      ? '請附上問題發生時的畫面截圖，方便官方確認實際狀況。'
                      : '若有相關畫面，也可以附上截圖協助官方確認。',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: theme.colorScheme.onSurface
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
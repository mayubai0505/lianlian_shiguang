import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
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
      final db =
          FirebaseFirestore.instance;

      // ==========================================
      // 1. 先建立 report 文件 ID
      // ==========================================
      final DocumentReference<
          Map<String, dynamic>>
      reportRef =
      db.collection('reports').doc();

      // ==========================================
      // 2. 產生案件編號
      // 例如：R-20260807-A1B2C3
      // ==========================================
      final now = DateTime.now();

      final String datePart =
          '${now.year}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}';

      final String shortId =
      reportRef.id
          .substring(0, 6)
          .toUpperCase();

      final String caseNumber =
          'R-$datePart-$shortId';

      // ==========================================
      // 3. 有圖片的話先上傳
      // ==========================================
      uploadedImageUrl =
      await _uploadImage(
        reportId: reportRef.id,
        userId: user.uid,
      );

      // ==========================================
      // 4. 取得玩家資料
      // ==========================================
      final userSnapshot =
      await db
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

      // ==========================================
      // 5. 建立 Batch
      // reports + 系統收件信一起寫入
      // ==========================================
      final batch = db.batch();

      // ==========================================
      // 6. 寫入客服案件
      // ==========================================
      batch.set(
        reportRef,
        {
          'type': 'feedback',

          // ⭐ 案件編號
          'caseNumber':
          caseNumber,

          // ⭐ 統一分類
          'category':
          _selectedCategory.name,

          'categoryLabel':
          _categoryLabel(
            _selectedCategory,
          ),

          // 保留舊欄位，相容後台
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

          // 玩家填寫內容
          'content':
          feedbackText,

          'reason':
          _selectedReason,

          // 被檢舉／回報內容
          'reportedContent':
          widget.reportedContent ?? '',

          // 角色
          'characterId':
          widget.characterId ?? '',

          'characterName':
          widget.characterName ?? '',

          // 聊天
          'sessionId':
          widget.sessionId ?? '',

          'messageId':
          widget.messageId ?? '',

          // Moment
          'momentId':
          widget.momentId ?? '',

          // 玩家
          'reporterId':
          user.uid,

          'createdBy':
          user.uid,

          'reporterName':
          nickname,

          'reporterEmail':
          user.email ?? '',

          // 圖片
          'imageUrl':
          uploadedImageUrl ?? '',

          'hasImage':
          uploadedImageUrl != null,

          // 時間
          'createdAt':
          FieldValue.serverTimestamp(),

          'updatedAt':
          FieldValue.serverTimestamp(),

          // 管理員回覆
          'adminReply': '',
        },
      );

      // ==========================================
      // 7. 寫入「已收到你的回報」系統信
      // ==========================================
      final mailboxRef =
      db
          .collection('users')
          .doc(user.uid)
          .collection('mailbox')
          .doc();

      batch.set(
        mailboxRef,
        {
          'type':
          'cs_received',

          'title': '【案件已建立】已收到你的回報 💌',

          'body':
          '我們已收到你的回報，會盡快協助確認。\n\n'
              '案件編號：$caseNumber\n\n'
              '若客服有進一步回覆，'
              '會再透過戀戀拾光信箱通知你。',

          // ⭐ 方便之後客服回覆對應
          'caseNumber':
          caseNumber,

          'reportId':
          reportRef.id,

          'isRead':
          false,

          'createdAt':
          FieldValue.serverTimestamp(),
        },
      );

      // ==========================================
      // 8. 一次送出
      // ==========================================
      await batch.commit();

      if (!mounted) return;

      // ==========================================
      // 9. 清除畫面內容
      // ==========================================
      _feedbackController.clear();

      setState(() {
        _selectedImage = null;
        _selectedImageBytes = null;
      });

      // ==========================================
      // 10. 聊天／角色／貼文檢舉
      // 送完直接回上一頁
      // ==========================================
      if (widget.lockCategory &&
          Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        return;
      }

      // ==========================================
      // 11. 一般客服中心
      // ==========================================
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
    final theme = Theme.of(context);
    final themeNotifier = context.watch<ThemeNotifier>();
    final l10n = AppLocalizations.of(context)!;
    final mediaQuery = MediaQuery.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    // 以目前 390px 寬手機上的位置為基準，依裝置尺寸等比例縮放。
    // clamp 避免小手機裝飾太小，也避免平板上的花草被放得過大。
    final double layoutScale = (screenWidth / 390).clamp(0.84, 1.20);
    final double topRightBotanicalWidth =
    (screenWidth * 0.58).clamp(190.0, 300.0);
    final double floatingPetalsWidth =
    (screenWidth * 0.74).clamp(230.0, 520.0);
    final double bottomLeftBotanicalWidth =
    (screenWidth * 0.48).clamp(158.0, 250.0);
    final double bottomRightBotanicalWidth =
    (screenWidth * 0.43).clamp(142.0, 224.0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: themeNotifier.currentBackground,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: mediaQuery.padding.top - (18 * layoutScale),
                        right: -42 * layoutScale,
                        width: topRightBotanicalWidth,
                        child: _tintedContactAsset(
                          theme,
                          'assets/images/contact/contact_top_right_botanical.png',
                          opacity: isDarkMode ? 0.11 : 0.25,
                        ),
                      ),
                      Positioned(
                        top: (screenHeight * 0.18).clamp(118.0, 220.0),
                        left: screenWidth * 0.18,
                        width: floatingPetalsWidth,
                        child: _tintedContactAsset(
                          theme,
                          'assets/images/contact/contact_floating_petals.png',
                          opacity: isDarkMode ? 0.045 : 0.09,
                        ),
                      ),
                      Positioned(
                        left: -45 * layoutScale,
                        bottom: -45 * layoutScale,
                        width: bottomLeftBotanicalWidth,
                        child: _tintedContactAsset(
                          theme,
                          'assets/images/contact/contact_bottom_left_botanical.png',
                          opacity: isDarkMode ? 0.08 : 0.17,
                        ),
                      ),
                      Positioned(
                        right: -40 * layoutScale,
                        bottom: -42 * layoutScale,
                        width: bottomRightBotanicalWidth,
                        child: _tintedContactAsset(
                          theme,
                          'assets/images/contact/contact_bottom_right_botanical.png',
                          opacity: isDarkMode ? 0.08 : 0.17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    22,
                    10,
                    22,
                    42 + mediaQuery.viewInsets.bottom,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            tooltip: MaterialLocalizations.of(context)
                                .backButtonTooltip,
                            onPressed: () => Navigator.maybePop(context),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: textColor.withValues(alpha: 0.82),
                              size: 25,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.title_contact_us,
                            style: GoogleFonts.notoSerifTc(
                              color: textColor,
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3.2,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 26,
                                height: 26,
                                child: Opacity(
                                  opacity: 0.82,
                                  child: Image.asset(
                                    'assets/images/contact/contact_section_flower.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.local_florist_outlined,
                                      color: primary.withValues(alpha: 0.78),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  l10n.title_contact_us_heading,
                                  style: GoogleFonts.notoSerifTc(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.desc_contact_us_body,
                            style: GoogleFonts.notoSerifTc(
                              color: textColor.withValues(alpha: 0.64),
                              fontSize: 14,
                              height: 1.75,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildContactSectionTitle(
                            theme,
                            '問題類型',
                            'assets/images/contact/contact_section_leaves.png',
                          ),
                          const SizedBox(height: 10),
                          if (widget.lockCategory)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 17,
                              ),
                              decoration: _contactFieldBox(theme),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.support_agent_rounded,
                                    color: primary,
                                  ),
                                  const SizedBox(width: 11),
                                  Text(
                                    _categoryLabel(_selectedCategory),
                                    style: GoogleFonts.notoSerifTc(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            DropdownButtonFormField<ReportCategory>(
                              value: _selectedCategory,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: primary,
                              ),
                              dropdownColor: theme.colorScheme.surface,
                              style: GoogleFonts.notoSerifTc(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: _contactInputDecoration(theme),
                              items: ReportCategory.values
                                  .where(
                                    (category) =>
                                category != ReportCategory.aiReply &&
                                    category != ReportCategory.character &&
                                    category != ReportCategory.moment,
                              )
                                  .map(
                                    (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(_categoryLabel(category)),
                                ),
                              )
                                  .toList(),
                              onChanged: _isSubmitting
                                  ? null
                                  : (value) {
                                if (value == null) return;
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                            ),
                          if (widget.reportedContent != null &&
                              widget.reportedContent!.trim().isNotEmpty) ...[
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: _contactFieldBox(theme),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '被回報的內容',
                                    style: GoogleFonts.notoSerifTc(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    widget.reportedContent!,
                                    style: GoogleFonts.notoSerifTc(
                                      color: textColor.withValues(alpha: 0.78),
                                      fontSize: 13,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          Stack(
                            children: [
                              TextField(
                                controller: _feedbackController,
                                minLines: 8,
                                maxLines: 12,
                                enabled: !_isSubmitting,
                                style: GoogleFonts.notoSerifTc(
                                  color: textColor,
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                                decoration: _contactInputDecoration(theme)
                                    .copyWith(
                                  hintText: l10n.hint_enter_feedback,
                                  hintStyle: GoogleFonts.notoSerifTc(
                                    color: textColor.withValues(alpha: 0.42),
                                    fontSize: 15,
                                  ),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    20,
                                    20,
                                    28,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                bottom: 8,
                                width: 105,
                                child: IgnorePointer(
                                  child: _tintedContactAsset(
                                    theme,
                                    'assets/images/contact/contact_input_sprig.png',
                                    opacity: isDarkMode ? 0.12 : 0.31,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: primary,
                                size: 27,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  _requiresScreenshot
                                      ? '問題截圖（必填）'
                                      : '附加圖片（選填）',
                                  style: GoogleFonts.notoSerifTc(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
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
                            style: GoogleFonts.notoSerifTc(
                              color: textColor.withValues(alpha: 0.58),
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 14),
                          if (_selectedImageBytes == null)
                            _buildContactUploadArea(theme)
                          else
                            _buildSelectedImagePreview(theme),
                          const SizedBox(height: 28),
                          _buildContactSubmitButton(theme),
                          const SizedBox(height: 16),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  size: 14,
                                  color: primary.withValues(alpha: 0.55),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '您的意見將協助我們持續優化遊戲體驗，謝謝您！',
                                  style: GoogleFonts.notoSerifTc(
                                    color: textColor.withValues(alpha: 0.46),
                                    fontSize: 10.5,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tintedContactAsset(
      ThemeData theme,
      String asset, {
        double opacity = 1,
      }) {
    return Opacity(
      opacity: opacity,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          theme.colorScheme.primary,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildContactSectionTitle(
      ThemeData theme,
      String title,
      String asset,
      ) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: _tintedContactAsset(theme, asset, opacity: 0.82),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: GoogleFonts.notoSerifTc(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  BoxDecoration _contactFieldBox(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    return BoxDecoration(
      color: theme.colorScheme.surface.withValues(
        alpha: isDarkMode ? 0.78 : 0.72,
      ),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: theme.colorScheme.primary.withValues(alpha: 0.25),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.primary.withValues(alpha: 0.055),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  InputDecoration _contactInputDecoration(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: theme.colorScheme.primary.withValues(alpha: 0.27),
        width: 1,
      ),
    );

    return InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surface.withValues(
        alpha: isDarkMode ? 0.78 : 0.72,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 17,
      ),
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.7),
          width: 1.35,
        ),
      ),
    );
  }

  Widget _buildContactUploadArea(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final disabled = _isPickingImage || _isSubmitting;

    return Semantics(
      button: true,
      label: '選擇回報圖片',
      child: InkWell(
        onTap: disabled ? null : _pickImage,
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: _ContactDashedBorderPainter(
            color: primary.withValues(alpha: disabled ? 0.22 : 0.52),
            radius: 20,
          ),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 26,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: _isPickingImage
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                    ),
                  )
                      : Icon(
                    Icons.cloud_upload_outlined,
                    color: primary,
                    size: 31,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  _isPickingImage ? '開啟相簿中…' : '點擊此處選擇圖片上傳',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    color: textColor.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '支援 jpg、png，單張不超過 10 MB',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    color: textColor.withValues(alpha: 0.44),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSubmitButton(ThemeData theme) {
    final primary = theme.colorScheme.primary;

    final lightPrimary = Color.lerp(
      primary,
      Colors.white,
      0.28,
    )!;

    final darkPrimary = Color.lerp(
      primary,
      Colors.black,
      0.08,
    )!;

    return Semantics(
      button: true,
      enabled: !_isSubmitting,
      label: _isSubmitting ? '送出中' : '送出回報',
      child: Opacity(
        opacity: _isSubmitting ? 0.65 : 1,
        child: InkWell(
          onTap: _isSubmitting ? null : _submitFeedback,
          borderRadius: BorderRadius.circular(27),
          child: Container(
            width: double.infinity,

            // 原本是 66
            height: 54,

            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              border: Border.all(
                color: primary.withValues(alpha: 0.48),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.16),
                  blurRadius: 9,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    lightPrimary,
                    primary,
                    darkPrimary,
                  ],
                  stops: const [0, 0.52, 1],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 0.8,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 24,
                    child: Transform.rotate(
                      angle: -0.12,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/contact/contact_section_leaves.png',

                          // 原本是 48 × 30
                          width: 38,
                          height: 22,

                          fit: BoxFit.contain,
                          opacity: const AlwaysStoppedAnimation(0.68),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 24,
                    child: Transform.flip(
                      flipX: true,
                      child: Transform.rotate(
                        angle: -0.12,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/contact/contact_section_leaves.png',
                            width: 38,
                            height: 22,
                            fit: BoxFit.contain,
                            opacity:
                            const AlwaysStoppedAnimation(0.68),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_isSubmitting)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    Text(
                      '送出',
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white,

                        // 原本是 22
                        fontSize: 19,

                        fontWeight: FontWeight.w500,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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

class _ContactDashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _ContactDashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      const dashLength = 7.0;
      const gapLength = 6.0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(
            distance,
            (distance + dashLength)
                .clamp(0.0, metric.length)
                .toDouble(),
          ),
          paint,
        );
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ContactDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
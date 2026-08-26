import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/image_utils.dart';

class ChatTranscriptBookPage extends StatefulWidget {
  final String characterName;
  final String characterAvatarPath;
  final String playerName;
  final String initialStory;

  /// 角色可用照片。第一張會作為預設封面；只有一張時直接使用，
  /// 多張時玩家可在封面頁自行選擇。
  final List<String> characterPhotoPaths;

  /// 傳入「已經依時間正序排列」的聊天訊息。
  /// 每個 message 需有：
  /// id / sender / text / type / path / timestamp / isAI
  final List<dynamic> messages;

  const ChatTranscriptBookPage({
    super.key,
    required this.characterName,
    required this.characterAvatarPath,
    required this.playerName,
    required this.initialStory,
    this.characterPhotoPaths = const [],
    required this.messages,
  });

  @override
  State<ChatTranscriptBookPage> createState() =>
      _ChatTranscriptBookPageState();
}

class _ChatTranscriptBookPageState extends State<ChatTranscriptBookPage> {
  static const String _brandLogoAsset =
      'assets/images/brand/lianlian_butterfly_logo.png';

  static const String _floralBottomLeftAsset =
      'assets/images/studio/studio_bottom_left.png';


  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _isExporting = false;
  bool _didPrecacheBookAssets = false;

  String _resolvedPlayerName = '';
  String _playerAvatarPath = 'assets/images/avatar1.png';

  late final List<String> _coverPhotoPaths;
  late String _coverPhotoPath;

  List<_BookPageData> _pages = const [];

  @override
  void initState() {
    super.initState();
    _resolvedPlayerName = widget.playerName.trim();

    final photos = <String>[
      ...widget.characterPhotoPaths,
      widget.characterAvatarPath,
    ]
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    _coverPhotoPaths = photos.isEmpty
        ? <String>['assets/images/blank_avatar.png']
        : photos;
    _coverPhotoPath = _coverPhotoPaths.first;

    _loadPlayerProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didPrecacheBookAssets) return;
    _didPrecacheBookAssets = true;

    // 預先解碼書頁固定素材，避免第一次翻頁時才載入造成頓一下。
    precacheImage(
      const AssetImage(_floralBottomLeftAsset),
      context,
    ).catchError((_) {});


    precacheImage(
      const AssetImage(_brandLogoAsset),
      context,
    ).catchError((_) {});

    for (final path in _coverPhotoPaths.take(3)) {
      try {
        precacheImage(
          getAvatarImageProvider(path),
          context,
        ).catchError((_) {});
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayerProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String name = _resolvedPlayerName;
    String avatarPath = user.photoURL?.trim() ?? '';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (data != null) {
        final nickname = data['nickname']?.toString().trim() ?? '';
        final savedAvatar = data['avatarPath']?.toString().trim() ?? '';

        if (nickname.isNotEmpty) {
          name = nickname;
        }

        if (savedAvatar.isNotEmpty) {
          avatarPath = savedAvatar;
        }
      }
    } catch (_) {
      // 雲端暫時讀不到時保留目前資料，不中斷閱讀。
    }

    if (!mounted) return;

    if (name.trim().isEmpty) {
      name = '玩家';
    }

    if (avatarPath.trim().isEmpty) {
      avatarPath = 'assets/images/avatar1.png';
    }

    setState(() {
      _resolvedPlayerName = name;
      _playerAvatarPath = avatarPath;
    });

    try {
      await precacheImage(
        getAvatarImageProvider(_playerAvatarPath),
        context,
      );
    } catch (_) {}

    try {
      await precacheImage(
        getAvatarImageProvider(widget.characterAvatarPath),
        context,
      );
    } catch (_) {}
  }

  String _normalizeTranscriptText(String value) {
    return value
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('「', '')
        .replaceAll('」', '')
        .replaceAll('"', '')
        .replaceAll('“', '')
        .replaceAll('”', '')
        .trim();
  }

  /// 有些舊聊天室會把「初始故事」又存成第一則玩家訊息。
  /// 紀念書已經先顯示初始故事，所以這裡只移除那一則重複的開場，
  /// 不影響玩家真正送出的第一句話。
  List<dynamic> _messagesForTranscript() {
    final result = List<dynamic>.from(widget.messages);

    if (result.isEmpty) return result;

    final story = _normalizeTranscriptText(widget.initialStory);
    if (story.isEmpty) return result;

    final first = result.first;
    final isPlayerMessage =
        first.sender == 'user' || first.isAI != true;

    final firstText = _normalizeTranscriptText(
      (first.text ?? '').toString(),
    );

    if (!isPlayerMessage || firstText.isEmpty) {
      return result;
    }

    final isExactDuplicate = firstText == story;

    // 相容部分舊資料：初始故事可能被加上少量前後文後再存進第一則玩家訊息。
    final isNearDuplicate =
        firstText.length >= 20 &&
            story.length >= 20 &&
            (firstText.contains(story) || story.contains(firstText));

    if (isExactDuplicate || isNearDuplicate) {
      result.removeAt(0);
    }

    return result;
  }

  List<_BookPageData> _buildPagesForViewport(Size pageViewport) {
    // PageView 內：外層書頁 padding + 書頁內容 padding。
    final contentWidth = (pageViewport.width - 92).clamp(220.0, 1200.0);
    final contentHeight = (pageViewport.height - 90).clamp(260.0, 1600.0);

    final pages = <_BookPageData>[
      const _BookPageData.cover(),
    ];

    final story = widget.initialStory.trim();
    if (story.isNotEmpty) {
      final storyParts = _paginateStoryByHeight(
        story,
        contentWidth: contentWidth,
        contentHeight: contentHeight,
      );

      for (int i = 0; i < storyParts.length; i++) {
        pages.add(
          _BookPageData.story(
            text: storyParts[i],
            isFirstStoryPage: i == 0,
          ),
        );
      }
    }

    final chatPages = _paginateMessagesByHeight(
      _messagesForTranscript(),
      contentWidth: contentWidth,
      contentHeight: contentHeight,
    );

    for (int i = 0; i < chatPages.length; i++) {
      pages.add(
        _BookPageData.chat(
          messages: chatPages[i],
          isFirstChatPage: i == 0,
        ),
      );
    }

    if (pages.isEmpty) {
      pages.add(
        const _BookPageData.story(
          text: '',
          isFirstStoryPage: true,
        ),
      );
    }

    return pages;
  }

  List<String> _paginateStoryByHeight(
      String text, {
        required double contentWidth,
        required double contentHeight,
      }) {
    final normalized = text
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();

    final style = GoogleFonts.notoSerifTc(
      fontSize: 13.2,
      height: 1.85,
    );

    // 第一頁要扣掉角色名、章節名、分隔線等高度。
    const firstPageHeaderHeight = 116.0;

    final result = <String>[];
    String remaining = normalized;
    bool firstPage = true;

    while (remaining.isNotEmpty) {
      final availableHeight = (contentHeight -
          (firstPage ? firstPageHeaderHeight : 0))
          .clamp(80.0, contentHeight);

      final fitting = _largestTextPrefixThatFits(
        remaining,
        maxWidth: contentWidth,
        maxHeight: availableHeight,
        style: style,
      );

      if (fitting.trim().isEmpty) {
        // 防止極端字型/尺寸造成無限迴圈。
        final fallbackLength =
        _safeUtf16Boundary(
          remaining,
          remaining.length.clamp(1, 120),
        );
        result.add(_safePrefix(remaining, fallbackLength).trim());
        remaining =
            _safeRemainder(remaining, fallbackLength).trimLeft();
      } else {
        result.add(fitting.trim());
        remaining =
            _safeRemainder(remaining, fitting.length).trimLeft();
      }

      firstPage = false;
    }

    return result;
  }

  List<List<_BookMessageSlice>> _paginateMessagesByHeight(
      List<dynamic> messages, {
        required double contentWidth,
        required double contentHeight,
      }) {
    if (messages.isEmpty) return const [];

    final pages = <List<_BookMessageSlice>>[];
    var current = <_BookMessageSlice>[];
    double usedHeight = 0;
    bool firstChatPage = true;

    const firstPageHeaderHeight = 42.0;
    const pageSafetyBottom = 24.0;
    const separatorHeight = 8.0;

    for (final message in messages) {
      final rawText = (message.text ?? '').toString().trim();
      final type = (message.type ?? 'text').toString();

      String remainingText = _displayMessageText(
        text: rawText,
        type: type,
      );

      bool firstSlice = true;

      while (remainingText.isNotEmpty) {
        final headerHeight =
        firstChatPage ? firstPageHeaderHeight : 0.0;

        final pageLimit =
            contentHeight - headerHeight - pageSafetyBottom;

        final remainingPageHeight =
            pageLimit - usedHeight;

        // 如果真的只剩很少空間，就換頁。
        if (remainingPageHeight < 54.0 && current.isNotEmpty) {
          pages.add(current);
          current = <_BookMessageSlice>[];
          usedHeight = 0;
          firstChatPage = false;
          continue;
        }

        // 直接用「整顆訊息 Widget 的估算高度」做二分搜尋，
        // 讓下一則長訊息可以吃掉本頁剩餘空間，而不是整顆被推到下一頁。
        final fitting = _largestMessagePrefixThatFits(
          source: message,
          text: remainingText,
          isContinuation: !firstSlice,
          contentWidth: contentWidth,
          maxTotalHeight: remainingPageHeight,
        );

        if (fitting.isEmpty) {
          // 本頁已有內容但塞不下任何一行 -> 下一頁。
          if (current.isNotEmpty) {
            pages.add(current);
            current = <_BookMessageSlice>[];
            usedHeight = 0;
            firstChatPage = false;
            continue;
          }

          // 空白頁仍無法量出內容時，至少切少量避免無限迴圈。
          final fallbackLength =
          _safeUtf16Boundary(
            remainingText,
            remainingText.length.clamp(1, 40),
          );
          final fallbackText =
          _safePrefix(remainingText, fallbackLength);

          final fallbackSlice = _BookMessageSlice(
            source: message,
            text: fallbackText,
            isContinuation: !firstSlice,
          );

          current.add(fallbackSlice);
          usedHeight += _measureMessageSliceHeight(
            fallbackSlice,
            contentWidth: contentWidth,
          ) +
              separatorHeight;

          remainingText =
              _safeRemainder(
                remainingText,
                fallbackLength,
              ).trimLeft();
          firstSlice = false;

          pages.add(current);
          current = <_BookMessageSlice>[];
          usedHeight = 0;
          firstChatPage = false;
          continue;
        }

        final slice = _BookMessageSlice(
          source: message,
          text: fitting,
          isContinuation: !firstSlice,
        );

        final sliceHeight = _measureMessageSliceHeight(
          slice,
          contentWidth: contentWidth,
        ) +
            separatorHeight;

        current.add(slice);
        usedHeight += sliceHeight;

        remainingText =
            _safeRemainder(
              remainingText,
              fitting.length,
            ).trimLeft();
        firstSlice = false;

        // 只有「這則訊息真的還沒講完」且本頁幾乎用滿時才換頁。
        // 不再無條件把續文強制推到下一頁。
        if (remainingText.isNotEmpty) {
          final nowRemaining = pageLimit - usedHeight;

          if (nowRemaining < 54.0) {
            pages.add(current);
            current = <_BookMessageSlice>[];
            usedHeight = 0;
            firstChatPage = false;
          }
        }
      }
    }

    if (current.isNotEmpty) {
      pages.add(current);
    }

    return pages;
  }

  bool _isHighSurrogate(int codeUnit) =>
      codeUnit >= 0xD800 && codeUnit <= 0xDBFF;

  bool _isLowSurrogate(int codeUnit) =>
      codeUnit >= 0xDC00 && codeUnit <= 0xDFFF;

  /// Dart String.substring() uses UTF-16 code-unit offsets.
  /// Binary-search pagination can otherwise cut an emoji/supplementary
  /// character exactly between its surrogate pair and create invalid UTF-16.
  int _safeUtf16Boundary(
      String text,
      int index, {
        bool forward = false,
      }) {
    if (index <= 0) return 0;
    if (index >= text.length) return text.length;

    final previous = text.codeUnitAt(index - 1);
    final current = text.codeUnitAt(index);

    if (_isHighSurrogate(previous) && _isLowSurrogate(current)) {
      if (forward && index + 1 <= text.length) {
        return index + 1;
      }
      return index - 1;
    }

    return index;
  }

  String _safePrefix(String text, int end) {
    final safeEnd = _safeUtf16Boundary(text, end);
    return text.substring(0, safeEnd);
  }

  String _safeRemainder(String text, int start) {
    final safeStart = _safeUtf16Boundary(text, start);
    return text.substring(safeStart);
  }

  String _largestMessagePrefixThatFits({
    required dynamic source,
    required String text,
    required bool isContinuation,
    required double contentWidth,
    required double maxTotalHeight,
  }) {
    if (text.isEmpty || maxTotalHeight <= 0) return '';

    bool fits(String candidate) {
      final slice = _BookMessageSlice(
        source: source,
        text: candidate,
        isContinuation: isContinuation,
      );

      return _measureMessageSliceHeight(
        slice,
        contentWidth: contentWidth,
      ) <=
          maxTotalHeight;
    }

    if (fits(text)) return text;

    int low = 1;
    int high = text.length;
    int best = 0;

    while (low <= high) {
      final mid = (low + high) >> 1;
      final safeMid = _safeUtf16Boundary(text, mid);
      final candidate = text.substring(0, safeMid);

      if (candidate.isEmpty) {
        low = mid + 1;
        continue;
      }

      if (fits(candidate)) {
        best = safeMid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    if (best <= 0) return '';

    int breakAt = best;

    // 優先找自然斷句點，但不要為了漂亮斷句浪費太多版面。
    final searchStart = (best - 48).clamp(0, best);
    final tail = text.substring(searchStart, best);
    final boundary = tail.lastIndexOf(
      RegExp(r'[\n。！？!?…；;，,\s]'),
    );

    if (boundary >= 0) {
      final candidate = searchStart + boundary + 1;

      // 至少保留本來可放文字的 80%，才採用自然斷句點。
      if (candidate >= best * 0.80) {
        breakAt = candidate;
      }
    }

    return _safePrefix(text, breakAt);
  }

  String _sanitizeUtf16(String input) {
    if (input.isEmpty) return input;

    final units = input.codeUnits;
    final out = StringBuffer();

    for (int i = 0; i < units.length; i++) {
      final unit = units[i];

      if (_isHighSurrogate(unit)) {
        if (i + 1 < units.length && _isLowSurrogate(units[i + 1])) {
          out.writeCharCode(unit);
          out.writeCharCode(units[i + 1]);
          i++;
        } else {
          out.write('\uFFFD');
        }
      } else if (_isLowSurrogate(unit)) {
        out.write('\uFFFD');
      } else {
        out.writeCharCode(unit);
      }
    }

    return out.toString();
  }

  double _measureMessageSliceHeight(
      _BookMessageSlice slice, {
        required double contentWidth,
      }) {
    final maxBubbleTextWidth =
    (contentWidth - 60).clamp(120.0, 900.0);

    final painter = TextPainter(
      text: TextSpan(
        text: _sanitizeUtf16(slice.text),
        style: GoogleFonts.notoSerifTc(
          fontSize: 11.3,
          height: 1.55,
        ),
      ),
      textDirection: _textDirectionFor(slice.text),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: null,
    )..layout(maxWidth: maxBubbleTextWidth);

    // 名稱列 + 間距 + bubble padding + 字型/裝置 rounding 安全值。
    // Avatar 最低高度約 30px，因此整則至少抓 42px。
    return (18 + 6 + painter.height + 20).clamp(46.0, 2000.0);
  }

  String _largestTextPrefixThatFits(
      String text, {
        required double maxWidth,
        required double maxHeight,
        required TextStyle style,
      }) {
    if (text.isEmpty) return '';

    bool fits(String candidate) {
      final painter = TextPainter(
        text: TextSpan(
          text: _sanitizeUtf16(candidate),
          style: style,
        ),
        textDirection: _textDirectionFor(candidate),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: null,
      )..layout(maxWidth: maxWidth);

      return painter.height <= maxHeight;
    }

    if (fits(text)) return text;

    int low = 1;
    int high = text.length;
    int best = 0;

    while (low <= high) {
      final mid = (low + high) >> 1;
      final safeMid = _safeUtf16Boundary(text, mid);
      final candidate = text.substring(0, safeMid);

      if (candidate.isEmpty) {
        low = mid + 1;
        continue;
      }

      if (fits(candidate)) {
        best = safeMid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    if (best <= 0) return '';

    int breakAt = best;

    // 優先在自然標點/空白處斷頁，避免切在句子正中央。
    final searchStart = (best - 90).clamp(0, best);
    final tail = text.substring(searchStart, best);
    final boundary = tail.lastIndexOf(
      RegExp(r'[\n。！？!?…；;，,\s]'),
    );

    if (boundary >= 0) {
      final candidate = searchStart + boundary + 1;
      if (candidate > 0) {
        breakAt = candidate;
      }
    }

    return _safePrefix(text, breakAt);
  }

  ui.TextDirection _textDirectionFor(String text) {
    final rtl = RegExp(r'[\u0590-\u08FF\uFB1D-\uFDFF\uFE70-\uFEFF]');
    return rtl.hasMatch(text)
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Color.lerp(
        theme.colorScheme.surface,
        primary,
        0.035,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: onSurface,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          '對話紀錄',
          style: GoogleFonts.notoSerifTc(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: '匯出 PDF',
            onPressed: _isExporting ? null : _exportPdf,
            icon: _isExporting
                ? SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                color: primary,
              ),
            )
                : Icon(
              Icons.ios_share_rounded,
              size: 21,
              color: primary,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 底部分頁控制列大約 64px，其餘就是 PageView 的實際高度。
          final pageViewport = Size(
            constraints.maxWidth,
            (constraints.maxHeight - 64).clamp(320.0, constraints.maxHeight),
          );

          final measuredPages = _buildPagesForViewport(pageViewport);
          _pages = measuredPages;

          final safeCurrentPage =
          _currentPage.clamp(0, measuredPages.length - 1);

          if (safeCurrentPage != _currentPage) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _currentPage = safeCurrentPage;
              });
              if (_pageController.hasClients) {
                _pageController.jumpToPage(safeCurrentPage);
              }
            });
          }

          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: measuredPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  physics: const PageScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  pageSnapping: true,
                  allowImplicitScrolling: true,
                  itemBuilder: (context, index) {
                    // 讓每張書頁獨立成 repaint layer。
                    // 不再跟著手指每一幀做 Matrix4 / 陰影重算，
                    // 實機會比 3D rotateY 版本明顯順很多。
                    return RepaintBoundary(
                      child: _buildBookPage(
                        context,
                        measuredPages[index],
                        index,
                      ),
                    );
                  },
                ),
              ),
              _buildPageNavigator(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookPage(
      BuildContext context,
      _BookPageData page,
      int index,
      ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    // 書頁直接吃滿 PageView 可用空間，不再用固定 AspectRatio
    // 縮成畫面中央的一張小卡。
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFFFFFEFB),
              primary,
              0.025,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primary.withValues(alpha: 0.11),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 20,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 左側淡淡書脊感
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        primary.withValues(alpha: 0.055),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 左下角花草裝飾
              Positioned(
                left: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.18,
                    child: Image.asset(
                      _floralBottomLeftAsset,
                      width: 158,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) =>
                      const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),



              // 內容
              if (page.kind == _BookPageKind.cover)
                Positioned.fill(
                  child: _buildCoverPage(theme),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    34,
                    32,
                    34,
                    42,
                  ),
                  child: page.kind == _BookPageKind.story
                      ? _buildStoryPage(
                    page,
                    theme,
                  )
                      : _buildChatPage(
                    page,
                    theme,
                  ),
                ),

              // 戀戀拾光品牌水印：純文字，避免小圖示輸出後模糊。
              if (page.kind != _BookPageKind.cover)
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.22,
                      child: Text(
                        '— 戀戀拾光',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 8.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                          color: onSurface.withValues(alpha: 0.70),
                        ),
                      ),
                    ),
                  ),
                ),

              // 頁碼（封面不顯示）
              if (page.kind != _BookPageKind.cover)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12,
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 10,
                      color: onSurface.withValues(alpha: 0.33),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverPage(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image(
          image: getAvatarImageProvider(_coverPhotoPath),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Container(
            color: Color.lerp(
              theme.colorScheme.surface,
              primary,
              0.08,
            ),
          ),
        ),

        // 讓人物照片保留，同時讓標題可讀。
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.55),
                ],
                stops: const [0.0, 0.48, 0.70, 1.0],
              ),
            ),
          ),
        ),

        if (_coverPhotoPaths.length > 1)
          Positioned(
            top: 18,
            right: 18,
            child: Material(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: _showCoverPhotoPicker,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 15,
                        color: primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '更換封面',
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          left: 28,
          right: 28,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.characterName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.30),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '與你的拾光 · 對話紀念書',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 12,
                  letterSpacing: 1.3,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '— 戀戀拾光',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCoverPhotoPicker() async {
    if (_coverPhotoPaths.length <= 1) return;

    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '選擇紀念書封面',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _coverPhotoPaths.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final path = _coverPhotoPaths[index];
                    final selected = path == _coverPhotoPath;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.pop(sheetContext, path),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? primary
                                : primary.withValues(alpha: 0.12),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image(
                              image: getAvatarImageProvider(path),
                              fit: BoxFit.cover,
                            ),
                            if (selected)
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || !mounted) return;

    setState(() {
      _coverPhotoPath = selected;
    });
  }

  Widget _buildStoryPage(
      _BookPageData page,
      ThemeData theme,
      ) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (page.isFirstStoryPage) ...[
          Text(
            widget.characterName,
            style: GoogleFonts.notoSerifTc(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              color: onSurface.withValues(alpha: 0.90),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '初始故事',
            style: GoogleFonts.notoSerifTc(
              fontSize: 11.5,
              color: primary.withValues(alpha: 0.62),
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 48,
            height: 1,
            color: primary.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 18),
        ],
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Text(
              page.storyText,
              textAlign: TextAlign.justify,
              style: GoogleFonts.notoSerifTc(
                fontSize: 13.2,
                height: 1.85,
                color: onSurface.withValues(alpha: 0.84),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatPage(
      _BookPageData page,
      ThemeData theme,
      ) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (page.isFirstChatPage) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.characterName} · 對話紀錄',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: onSurface.withValues(alpha: 0.88),
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 1,
                color: primary.withValues(alpha: 0.22),
              ),
            ],
          ),
          const SizedBox(height: 13),
        ],
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < page.messages.length; i++) ...[
                _buildMessageEntry(
                  page.messages[i],
                  theme,
                ),
                if (i != page.messages.length - 1)
                  SizedBox(height: page.messages.length >= 5 ? 5 : 9),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageEntry(
      _BookMessageSlice slice,
      ThemeData theme,
      ) {
    final message = slice.source;
    final isAi = message.sender == 'ai' || message.isAI == true;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    final baseName = isAi
        ? widget.characterName
        : (_resolvedPlayerName.trim().isNotEmpty
        ? _resolvedPlayerName
        : '玩家');
    final name = slice.isContinuation ? '$baseName · 續' : baseName;

    final avatarPath =
    isAi ? widget.characterAvatarPath : _playerAvatarPath;

    final text = slice.text;
    final type = (message.type ?? 'text').toString();
    final dateTime = _messageDateTime(message);

    final bubbleColor = isAi
        ? theme.colorScheme.surface.withValues(alpha: 0.90)
        : Color.lerp(
      theme.colorScheme.surface,
      primary,
      0.075,
    )!;

    final entry = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
      isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isAi) ...[
          _buildAvatar(avatarPath, primary),
          const SizedBox(width: 8),
        ],
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAi && dateTime != null) ...[
                    Text(
                      _formatTime(dateTime),
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 8.5,
                        color: onSurface.withValues(alpha: 0.34),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: onSurface.withValues(alpha: 0.66),
                      ),
                    ),
                  ),
                  if (isAi && dateTime != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(dateTime),
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 8.5,
                        color: onSurface.withValues(alpha: 0.34),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primary.withValues(
                      alpha: isAi ? 0.12 : 0.18,
                    ),
                  ),
                ),
                child: Text(
                  _displayMessageText(
                    text: text,
                    type: type,
                  ),
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 11.3,
                    height: 1.55,
                    color: onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isAi) ...[
          const SizedBox(width: 8),
          _buildAvatar(avatarPath, primary),
        ],
      ],
    );

    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: entry,
    );
  }

  Widget _buildAvatar(
      String path,
      Color primary,
      ) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primary.withValues(alpha: 0.15),
        ),
      ),
      child: ClipOval(
        child: Image(
          image: getAvatarImageProvider(path),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) => Container(
            color: primary.withValues(alpha: 0.07),
            alignment: Alignment.center,
            child: Icon(
              Icons.person_outline_rounded,
              size: 16,
              color: primary.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageNavigator(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 7, 18, 12),
        child: Row(
          children: [
            IconButton(
              tooltip: '上一頁',
              onPressed: _currentPage <= 0
                  ? null
                  : () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 210),
                  curve: Curves.easeOutQuart,
                );
              },
              icon: Icon(
                Icons.chevron_left_rounded,
                color: _currentPage <= 0
                    ? onSurface.withValues(alpha: 0.18)
                    : primary,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${_currentPage + 1} / ${_pages.length}',
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11,
                      color: onSurface.withValues(alpha: 0.50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      value: (_currentPage + 1) / _pages.length,
                      backgroundColor:
                      primary.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        primary.withValues(alpha: 0.48),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '下一頁',
              onPressed: _currentPage >= _pages.length - 1
                  ? null
                  : () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 210),
                  curve: Curves.easeOutQuart,
                );
              },
              icon: Icon(
                Icons.chevron_right_rounded,
                color: _currentPage >= _pages.length - 1
                    ? onSurface.withValues(alpha: 0.18)
                    : primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _messageDateTime(dynamic message) {
    try {
      final dynamic timestamp = message.timestamp;

      if (timestamp == null) return null;

      if (timestamp is DateTime) {
        return timestamp;
      }

      final converted = timestamp.toDate();

      if (converted is DateTime) {
        return converted;
      }
    } catch (_) {}

    return null;
  }

  String _formatTime(DateTime time) {
    return DateFormat('MM/dd HH:mm').format(time);
  }

  String _displayMessageText({
    required String text,
    required String type,
  }) {
    if (text.isNotEmpty && text != '[語音訊息]') {
      return text;
    }

    switch (type) {
      case 'image':
        return '〔照片〕';
      case 'audio':
        return '〔語音訊息〕';
      default:
        return text.isEmpty ? '〔訊息〕' : text;
    }
  }

  Future<void> _exportPdf() async {
    if (_isExporting) return;

    setState(() {
      _isExporting = true;
    });

    try {
      final bytes = await _buildPdfBytes();

      if (!mounted) return;

      final safeName = widget.characterName
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
          .trim();

      final file = XFile.fromData(
        bytes,
        mimeType: 'application/pdf',
        name: 'lianlian_${safeName}_chat_book.pdf',
      );

      await Share.shareXFiles(
        [file],
        text: '${widget.characterName} · 對話紀錄',
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '匯出 PDF 失敗：$e',
            style: GoogleFonts.notoSerifTc(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<Uint8List> _buildPdfBytes() async {
    final document = pw.Document();

    // PDF 主字體改成與 App 視覺一致的 Serif 系列。
    final regularFont = await PdfGoogleFonts.notoSerifTCRegular();
    final boldFont = await PdfGoogleFonts.notoSerifTCBold();

    // 多語系 fallback：
    // 簡中 / 日文 / 韓文 / 阿拉伯文 / Hindi / 泰文。
    // 拉丁語系（英、西、法、葡、越、印尼、馬來）可由主字體直接涵蓋。
    final fallbackFonts = <pw.Font>[
      await PdfGoogleFonts.notoSerifSCRegular(),
      await PdfGoogleFonts.notoSerifJPRegular(),
      await PdfGoogleFonts.notoSerifKRRegular(),
      await PdfGoogleFonts.amiriRegular(),
      await PdfGoogleFonts.notoSerifDevanagariRegular(),
      await PdfGoogleFonts.notoSerifThaiRegular(),
    ];

    final boldFallbackFonts = <pw.Font>[
      await PdfGoogleFonts.notoSerifSCBold(),
      await PdfGoogleFonts.notoSerifJPBold(),
      await PdfGoogleFonts.notoSerifKRBold(),
      await PdfGoogleFonts.amiriBold(),
      await PdfGoogleFonts.notoSerifDevanagariBold(),
      await PdfGoogleFonts.notoSerifThaiBold(),
    ];

    pw.ImageProvider? characterAvatar;
    pw.ImageProvider? playerAvatar;
    pw.ImageProvider? coverPhoto;
    pw.ImageProvider? brandLogo;

    try {
      characterAvatar = await _loadPdfImage(
        widget.characterAvatarPath,
      );
    } catch (_) {}

    try {
      playerAvatar = await _loadPdfImage(
        _playerAvatarPath,
      );
    } catch (_) {}

    try {
      coverPhoto = await _loadPdfImage(
        _coverPhotoPath,
      );
    } catch (_) {}

    try {
      brandLogo = await imageFromAssetBundle(
        _brandLogoAsset,
        cache: true,
      );
    } catch (_) {
      // Logo 尚未加入 assets 時，PDF 仍可正常輸出文字水印。
    }

    final pdfTheme = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
      fontFallback: fallbackFonts,
    );

    for (int i = 0; i < _pages.length; i++) {
      final page = _pages[i];

      document.addPage(
        pw.Page(
          // 6 x 9 吋小說尺寸，比 A4 橫式更像真正的書。
          pageFormat: PdfPageFormat(
            6 * PdfPageFormat.inch,
            9 * PdfPageFormat.inch,
          ),
          margin: page.kind == _BookPageKind.cover
              ? pw.EdgeInsets.zero
              : const pw.EdgeInsets.fromLTRB(
            22,
            22,
            22,
            18,
          ),
          theme: pdfTheme,
          build: (context) {
            if (page.kind == _BookPageKind.cover) {
              return _buildPdfCoverPage(
                coverPhoto: coverPhoto,
                brandLogo: brandLogo,
                regularFont: regularFont,
                boldFont: boldFont,
                fallbackFonts: fallbackFonts,
                boldFallbackFonts: boldFallbackFonts,
              );
            }

            return pw.Container(
              decoration: pw.BoxDecoration(
                color: const PdfColor.fromInt(0xFFFFFEFB),
                border: pw.Border.all(
                  color: const PdfColor.fromInt(0xFFE8E1EF),
                  width: 0.8,
                ),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              padding: const pw.EdgeInsets.fromLTRB(
                24,
                24,
                24,
                18,
              ),
              child: pw.Stack(
                children: [
                  if (page.kind == _BookPageKind.story)
                    _buildPdfStoryPage(
                      page,
                      regularFont,
                      boldFont,
                      fallbackFonts,
                      boldFallbackFonts,
                    )
                  else
                    _buildPdfChatPage(
                      page,
                      regularFont,
                      boldFont,
                      fallbackFonts,
                      boldFallbackFonts,
                      characterAvatar,
                      playerAvatar,
                    ),
                  pw.Positioned(
                    right: 2,
                    bottom: 0,
                    child: pw.Opacity(
                      opacity: 0.30,
                      child: pw.Text(
                        '— 戀戀拾光',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontFallback: fallbackFonts,
                          fontSize: 7.2,
                          letterSpacing: 0.7,
                          color: const PdfColor.fromInt(0xFF8E8791),
                        ),
                      ),
                    ),
                  ),
                  pw.Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: pw.Text(
                      '$i',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        font: regularFont,
                        fontFallback: fallbackFonts,
                        fontSize: 8,
                        color: const PdfColor.fromInt(0xFFAAA2AC),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return document.save();
  }

  Future<pw.ImageProvider> _loadPdfImage(
      String rawPath,
      ) async {
    final path = rawPath.trim();

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return networkImage(
        path,
        cache: true,
      );
    }

    if (path.startsWith('assets/')) {
      return imageFromAssetBundle(
        path,
        cache: true,
      );
    }

    throw StateError('PDF 不支援此頭像來源');
  }

  pw.Widget _buildPdfCoverPage({
    required pw.ImageProvider? coverPhoto,
    required pw.ImageProvider? brandLogo,
    required pw.Font regularFont,
    required pw.Font boldFont,
    required List<pw.Font> fallbackFonts,
    required List<pw.Font> boldFallbackFonts,
  }) {
    return pw.Stack(
      fit: pw.StackFit.expand,
      children: [
        pw.Container(
          color: const PdfColor.fromInt(0xFFF3EFF6),
          child: coverPhoto == null
              ? pw.SizedBox()
              : pw.Image(
            coverPhoto,
            fit: pw.BoxFit.cover,
          ),
        ),

        // 底部改成較像書封的霧白資訊區，不再像 App Card。
        pw.Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Opacity(
                  opacity: 0.92,
                  child: pw.Container(
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(
                  28,
                  20,
                  28,
                  20,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      widget.characterName,
                      style: pw.TextStyle(
                        font: boldFont,
                        fontFallback: boldFallbackFonts,
                        fontSize: 24,
                        color: const PdfColor.fromInt(0xFF342F36),
                      ),
                    ),
                    pw.SizedBox(height: 7),
                    pw.Text(
                      '與你的拾光 · 對話紀念書',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontFallback: fallbackFonts,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: const PdfColor.fromInt(0xFF746A79),
                      ),
                    ),
                    pw.SizedBox(height: 13),
                    pw.Text(
                      '— 戀戀拾光',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontFallback: fallbackFonts,
                        fontSize: 9,
                        letterSpacing: 1.2,
                        color: const PdfColor.fromInt(0xFF6F6673),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfStoryPage(
      _BookPageData page,
      pw.Font regularFont,
      pw.Font boldFont,
      List<pw.Font> fallbackFonts,
      List<pw.Font> boldFallbackFonts,
      ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (page.isFirstStoryPage) ...[
          pw.Text(
            widget.characterName,
            style: pw.TextStyle(
              font: boldFont,
              fontFallback: boldFallbackFonts,
              fontSize: 18,
              color: const PdfColor.fromInt(0xFF37313A),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            '初始故事',
            style: pw.TextStyle(
              font: regularFont,
              fontFallback: fallbackFonts,
              fontSize: 9,
              letterSpacing: 2,
              color: const PdfColor.fromInt(0xFF8F7AA3),
            ),
          ),
          pw.SizedBox(height: 13),
          pw.Container(
            width: 42,
            height: 0.8,
            color: const PdfColor.fromInt(0xFFCABDD7),
          ),
          pw.SizedBox(height: 14),
        ],
        pw.Expanded(
          child: pw.Text(
            page.storyText,
            textAlign: pw.TextAlign.justify,
            style: pw.TextStyle(
              font: regularFont,
              fontFallback: fallbackFonts,
              fontSize: 11.5,
              lineSpacing: 5.2,
              color: const PdfColor.fromInt(0xFF4D4850),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfChatPage(
      _BookPageData page,
      pw.Font regularFont,
      pw.Font boldFont,
      List<pw.Font> fallbackFonts,
      List<pw.Font> boldFallbackFonts,
      pw.ImageProvider? characterAvatar,
      pw.ImageProvider? playerAvatar,
      ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        if (page.isFirstChatPage) ...[
          pw.Text(
            '${widget.characterName} · 對話紀錄',
            style: pw.TextStyle(
              font: boldFont,
              fontFallback: boldFallbackFonts,
              fontSize: 14,
              color: const PdfColor.fromInt(0xFF3D3740),
            ),
          ),
          pw.SizedBox(height: 12),
        ],
        pw.Expanded(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: page.messages.map((slice) {
              final message = slice.source;
              final isAi =
                  message.sender == 'ai' || message.isAI == true;

              final name = isAi
                  ? widget.characterName
                  : (_resolvedPlayerName.trim().isNotEmpty
                  ? _resolvedPlayerName
                  : '玩家');

              final avatar =
              isAi ? characterAvatar : playerAvatar;

              final text =
              (message.text ?? '').toString().trim();

              final type =
              (message.type ?? 'text').toString();

              final dateTime = _messageDateTime(message);

              return _buildPdfMessageEntry(
                isAi: isAi,
                name: name,
                avatar: avatar,
                time: dateTime == null
                    ? ''
                    : _formatTime(dateTime),
                text: text,
                regularFont: regularFont,
                boldFont: boldFont,
                fallbackFonts: fallbackFonts,
                boldFallbackFonts: boldFallbackFonts,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfMessageEntry({
    required bool isAi,
    required String name,
    required pw.ImageProvider? avatar,
    required String time,
    required String text,
    required pw.Font regularFont,
    required pw.Font boldFont,
    required List<pw.Font> fallbackFonts,
    required List<pw.Font> boldFallbackFonts,
  }) {
    final avatarWidget = pw.Container(
      width: 28,
      height: 28,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: const PdfColor.fromInt(0xFFF0ECF4),
        image: avatar == null
            ? null
            : pw.DecorationImage(
          image: avatar,
          fit: pw.BoxFit.cover,
        ),
      ),
    );

    final content = pw.Flexible(
      child: pw.Column(
        crossAxisAlignment: isAi
            ? pw.CrossAxisAlignment.start
            : pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              if (!isAi && time.isNotEmpty) ...[
                pw.Text(
                  time,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontFallback: fallbackFonts,
                    fontSize: 7,
                    color: const PdfColor.fromInt(0xFFAAA4AC),
                  ),
                ),
                pw.SizedBox(width: 5),
              ],
              pw.Text(
                name,
                style: pw.TextStyle(
                  font: boldFont,
                  fontFallback: boldFallbackFonts,
                  fontSize: 8.8,
                  color: const PdfColor.fromInt(0xFF746C77),
                ),
              ),
              if (isAi && time.isNotEmpty) ...[
                pw.SizedBox(width: 5),
                pw.Text(
                  time,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontFallback: fallbackFonts,
                    fontSize: 7,
                    color: const PdfColor.fromInt(0xFFAAA4AC),
                  ),
                ),
              ],
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Container(
            constraints: const pw.BoxConstraints(
              maxWidth: 300,
            ),
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: pw.BoxDecoration(
              color: isAi
                  ? const PdfColor.fromInt(0xFFFFFEFC)
                  : const PdfColor.fromInt(0xFFF4EFF7),
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(
                color: isAi
                    ? const PdfColor.fromInt(0xFFE5DDEB)
                    : const PdfColor.fromInt(0xFFD9CBE4),
                width: 0.7,
              ),
            ),
            child: pw.Text(
              text,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 9.3,
                lineSpacing: 3.5,
                color: const PdfColor.fromInt(0xFF4C474E),
              ),
            ),
          ),
        ],
      ),
    );

    return pw.Row(
      mainAxisAlignment: isAi
          ? pw.MainAxisAlignment.start
          : pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: isAi
          ? [
        avatarWidget,
        pw.SizedBox(width: 7),
        content,
      ]
          : [
        content,
        pw.SizedBox(width: 7),
        avatarWidget,
      ],
    );
  }
}


class _BookMessageSlice {
  final dynamic source;
  final String text;
  final bool isContinuation;

  const _BookMessageSlice({
    required this.source,
    required this.text,
    this.isContinuation = false,
  });
}


enum _BookPageKind {
  cover,
  story,
  chat,
}

class _BookPageData {
  final _BookPageKind kind;
  final String storyText;
  final List<dynamic> messages;
  final bool isFirstStoryPage;
  final bool isFirstChatPage;

  const _BookPageData._({
    required this.kind,
    this.storyText = '',
    this.messages = const [],
    this.isFirstStoryPage = false,
    this.isFirstChatPage = false,
  });

  const _BookPageData.cover()
      : this._(
    kind: _BookPageKind.cover,
  );

  const _BookPageData.story({
    required String text,
    required bool isFirstStoryPage,
  }) : this._(
    kind: _BookPageKind.story,
    storyText: text,
    isFirstStoryPage: isFirstStoryPage,
  );

  const _BookPageData.chat({
    required List<_BookMessageSlice> messages,
    required bool isFirstChatPage,
  }) : this._(
    kind: _BookPageKind.chat,
    messages: messages,
    isFirstChatPage: isFirstChatPage,
  );
}
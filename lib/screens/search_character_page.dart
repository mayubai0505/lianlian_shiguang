import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_notifier.dart';
import 'character_model.dart';
import 'character_profile_page.dart';
import 'dart:math'; // ✨ 加上這一行就解決了
import '../services/app_constants.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

//搜尋頁面
class SearchCharacterPage extends StatefulWidget {
  const SearchCharacterPage({super.key});

  @override
  State<SearchCharacterPage> createState() => _SearchCharacterPageState();
}

class _SearchCharacterPageState extends State<SearchCharacterPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final String APP_ID = AppConfig.appId;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:  Text(l10n.search_companion_title),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: Column(
          children: [
            // 🔍 搜尋框
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: l10n.search_name_placeholder,
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.5)),
                  prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.cardColor.withValues(alpha:isDarkMode ? 0.6 : 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha:0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha:0.1)),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value.trim()),
              ),
            ),

            // 📜 雙排格網結果
            Expanded(
              child: _buildGridResults(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridResults(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    Query query = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters');

    if (_searchQuery.isEmpty) {
      query = query
          .orderBy('likesCount', descending: true)
          .limit(6);
    } else {
      query = query
          .orderBy('createdAt', descending: true)
          .limit(200);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final allDocs = snapshot.data!.docs;
        final keyword = _searchQuery.toLowerCase();

        final docs = _searchQuery.isEmpty
            ? allDocs
            : allDocs.where((doc) {
          final data =
          doc.data() as Map<String, dynamic>;

          final String name =
              data['name']
                  ?.toString()
                  .toLowerCase() ??
                  '';

          final String creatorName =
              data['creatorName']
                  ?.toString()
                  .toLowerCase() ??
                  '';

          final List<String> tags =
          List<String>.from(
            data['personalityTags'] ?? const [],
          ).map((tag) => tag.toLowerCase()).toList();

          return name.contains(keyword) ||
              creatorName.contains(keyword) ||
              tags.any(
                    (tag) => tag.contains(keyword),
              );
        }).toList();
        if (docs.isEmpty) {
          return Center(
              child: Text(l10n.search_no_match_hint,
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.6)))
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) => _buildCharacterCard(docs[index], theme),
        );
      },
    );
  }

  Widget _buildCharacterCard(
      DocumentSnapshot doc,
      ThemeData theme,
      ) {
    final charData =
    doc.data() as Map<String, dynamic>;

    final primaryColor =
        theme.colorScheme.primary;

    final l10n =
    AppLocalizations.of(context)!;

    final String imageUrl = (
        charData['avatar'] ??
            charData['avatarPath'] ??
            ''
    ).toString().trim();

    return GestureDetector(
      onTap: () async {
        final targetCharacter =
        await Character.fromFirestoreAsync(doc);

        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CharacterProfilePage(
                  character: targetCharacter,
                  characterId: targetCharacter.id,
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withValues(
              alpha: 0.1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.1,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // =========================
              // 角色背景圖片
              // =========================
              if (imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,

                  // 稍微往上取景，避免角色臉部被裁掉。
                  alignment:
                  const Alignment(0, -0.15),

                  // 只限制解碼寬度，避免非正方形圖片被壓扁。
                  memCacheWidth: 720,

                  filterQuality:
                  FilterQuality.medium,

                  placeholder: (
                      context,
                      url,
                      ) {
                    return Container(
                      color: theme.colorScheme
                          .secondaryContainer,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                    );
                  },

                  errorWidget: (
                      context,
                      url,
                      error,
                      ) {
                    return _buildCharacterImageFallback(
                      theme,
                    );
                  },
                )
              else
                _buildCharacterImageFallback(
                  theme,
                ),

              // =========================
              // 底部漸層遮罩
              // =========================
              Align(
                alignment:
                Alignment.bottomCenter,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin:
                      Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: 0.82,
                        ),
                        Colors.black.withValues(
                          alpha: 0.25,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [
                        0,
                        0.55,
                        1,
                      ],
                    ),
                  ),
                ),
              ),

              // =========================
              // 玩家留言彈幕
              // =========================
              AnimatedDanmu(
                characterId: doc.id,
                appId: AppConfig.appId,
              ),

              // =========================
              // 右上角心動數
              // =========================
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${charData['likesCount'] ?? charData['likes'] ?? 0}',
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // =========================
              // 底部角色資料
              // =========================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding:
                  const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        charData['name']
                            ?.toString() ??
                            '',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 18,
                          shadows: [
                            Shadow(
                              color:
                              Colors.black54,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _buildCharacterInfoText(
                          charData,
                          l10n,
                        ),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white
                              .withValues(
                            alpha: 0.9,
                          ),
                          fontSize: 12,
                          shadows: const [
                            Shadow(
                              color:
                              Colors.black54,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCharacterImageFallback(
      ThemeData theme,
      ) {
    return Container(
      color: theme.colorScheme
          .secondaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: 56,
        color: theme.colorScheme
            .onSecondaryContainer,
      ),
    );
  }
  String _buildCharacterInfoText(
      Map<String, dynamic> charData,
      AppLocalizations l10n,
      ) {
    final String age =
        charData['age']?.toString() ?? '??';

    final String occupation =
        charData['occupation']
            ?.toString()
            .trim() ??
            '';

    if (occupation.isNotEmpty) {
      return l10n.character_info_full(
        age,
        occupation,
      );
    }

    return l10n.character_info_age_only(
      age,
    );
  }
}

// 💬 專屬小工具：會自己呼吸、飄浮的限時動態彈幕
class AnimatedDanmu extends StatefulWidget {
  final String characterId; // 接收角色 ID
  final String appId;       // 接收 appId

  const AnimatedDanmu({
    super.key,
    required this.characterId,
    required this.appId,     // ✨ 這樣寫才是正確的接收方式
  });

  @override
  State<AnimatedDanmu> createState() => _AnimatedDanmuState();
}

class _AnimatedDanmuState extends State<AnimatedDanmu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _position;
  bool _isInit = false; // ✨ 專屬防護旗標
  List<String> _echoMessages = []; // ✨ 這裡存放從 Firestore 抓到的留言
  int _currentIndex = 0;
  final Random _random = Random();
  double _top = 20.0;
  double _left = 20.0;

  @override
  void initState() {
    super.initState();

    // 1. 初始化動畫 (這部分保持您的精美設定)
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 15),
    ]).animate(_controller);

    _position = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: const Offset(0, 0.5), end: Offset.zero), weight: 20),
      TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 80),
    ]).animate(_controller);

  }

  void _listenToEchoes() {
    final l10n = AppLocalizations.of(context)!;
    FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('public_characters')
        .doc(widget.characterId)
        .collection('echoes') // 👈 抓取您指定的子集合
        .orderBy('timestamp', descending: true)
        .limit(10) // 抓最新的 10 則來輪播
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return;

      setState(() {
        _echoMessages = snapshot.docs
            .map((doc) => doc.data()['content']?.toString() ?? '')
            .where((content) => content.isNotEmpty)
            .toList();

        // 如果完全沒留言，就給一句預設的
        if (_echoMessages.isEmpty) {
          _echoMessages = [l10n.empty_state_warmth];
        }
      });

      // 如果動畫還沒開始過，就啟動它
      if (!_controller.isAnimating) {
        _startDanmuLoop();
      }
    });
  }

  void _startDanmuLoop() {
    if (!mounted || _echoMessages.isEmpty) return;

    setState(() {
      _currentIndex = _random.nextInt(_echoMessages.length);

      // 🎲 每次發射前，隨機決定出現在卡片的哪個位置！
      // 假設卡片寬高比約 0.75，我們把範圍限制在安全區內
      _top = _random.nextDouble() * 120 + 20;  // 距離頂部 20~140 之間
      _left = _random.nextDouble() * 60 + 10; // 距離左邊 10~70 之間
    });

    _controller.forward(from: 0.0).then((_) {
      if (mounted) {
        Future.delayed(Duration(seconds: _random.nextInt(2) + 1), _startDanmuLoop);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🛡️ 啟動防護罩：確保只在剛進頁面時執行一次
    if (!_isInit) {
      // ✅ 搬到這裡！這時候 context 已經完全準備好，拿翻譯絕對不會崩潰
      _listenToEchoes();

      _isInit = true; // 做完就把門鎖上
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_echoMessages.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: _top,
      left: _left,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _position,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            constraints: const BoxConstraints(maxWidth: 120), // 限制寬度，避免太長超出卡片
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha:0.55),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withValues(alpha:0.15)),
            ),
            child: Text(
              _echoMessages[_currentIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 2)]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
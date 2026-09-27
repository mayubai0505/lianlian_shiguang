import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import '../services/toast_utils.dart';
import '../utils/image_utils.dart';

class EventMemoryPerformancePage extends StatefulWidget {
  final String eventId;
  final String memoryId;
  final String memoryTitle;
  final String characterId;
  final String characterName;
  final String characterAvatarPath;
  final String playerProfileId;
  final String playerName;
  final String playerProfileName;

  const EventMemoryPerformancePage({
    super.key,
    required this.eventId,
    required this.memoryId,
    required this.memoryTitle,
    required this.characterId,
    required this.characterName,
    required this.characterAvatarPath,
    required this.playerProfileId,
    required this.playerName,
    required this.playerProfileName,
  });

  @override
  State<EventMemoryPerformancePage> createState() =>
      _EventMemoryPerformancePageState();
}

enum _MemoryPhase {
  loading,
  opening,
  performance,
  finished,
}

class _EventMemoryPerformancePageState
    extends State<EventMemoryPerformancePage>
    with SingleTickerProviderStateMixin {
  static const String _openingText = '有些瞬間，\n並不會因為故事結束而消失。';

  bool _loading = true;
  String? _error;
  Map<String, dynamic> _memory = {};
  List<_MemoryScene> _scenes = [];
  int _index = 0;
  String _typedText = '';
  Timer? _typingTimer;
  Timer? _openingTimer;
  bool _typingDone = true;
  bool _openingVisible = false;
  bool _photoVisible = false;
  bool _finishing = false;
  bool _saving = false;
  bool _collecting = false;
  bool _isCollected = false;
  bool _markingViewed = false;
  _MemoryPhase _phase = _MemoryPhase.loading;

  late final AnimationController _photoMotionController;
  final GlobalKey _memoryCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _photoMotionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
      lowerBound: 0,
      upperBound: 1,
    );
    _loadMemory();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _openingTimer?.cancel();
    _photoMotionController.dispose();
    super.dispose();
  }

  Future<void> _loadMemory() async {
    try {
      final memoryRef = FirebaseFirestore.instance
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('events')
          .doc(widget.eventId)
          .collection('memories')
          .doc(widget.memoryId);

      final results = await Future.wait([
        memoryRef.get(),
        memoryRef.collection('scenes').orderBy('order').get(),
      ]);

      final memoryDoc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
      final sceneSnapshot =
      results[1] as QuerySnapshot<Map<String, dynamic>>;

      if (!memoryDoc.exists) {
        throw Exception('找不到這篇限定回憶');
      }

      final scenes = sceneSnapshot.docs
          .map((doc) => _MemoryScene.fromMap(doc.id, doc.data()))
          .where((scene) => scene.text.trim().isNotEmpty)
          .toList();

      if (scenes.isEmpty) {
        throw Exception('這篇回憶還沒有演出 Scene');
      }

      if (!mounted) return;
      setState(() {
        _memory = memoryDoc.data() ?? <String, dynamic>{};
        _scenes = scenes;
        _loading = false;
        _phase = _MemoryPhase.opening;
        _index = 0;
      });

      _startOpening();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _phase = _MemoryPhase.finished;
        _error = '載入回憶失敗：$e';
      });
    }
  }

  _MemoryScene get _scene => _scenes[_index];

  String _replaceTokens(String text) {
    return text
        .replaceAll('{{player}}', widget.playerName)
        .replaceAll('{player}', widget.playerName)
        .replaceAll('{{character}}', widget.characterName)
        .replaceAll('{character}', widget.characterName);
  }

  ImageProvider? _characterImageProvider() {
    final value = widget.characterAvatarPath.trim();
    if (value.isEmpty) return null;
    try {
      return getAvatarImageProvider(value);
    } catch (_) {
      return null;
    }
  }

  void _startOpening() {
    _openingTimer?.cancel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _phase != _MemoryPhase.opening) return;
      setState(() => _openingVisible = true);
    });

    _openingTimer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted || _phase != _MemoryPhase.opening) return;
      setState(() => _openingVisible = false);

      _openingTimer = Timer(const Duration(milliseconds: 850), () {
        if (!mounted || _phase != _MemoryPhase.opening) return;
        _enterPerformance();
      });
    });
  }

  void _skipOpening() {
    if (_phase != _MemoryPhase.opening) return;
    _openingTimer?.cancel();
    setState(() => _openingVisible = false);
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted && _phase == _MemoryPhase.opening) {
        _enterPerformance();
      }
    });
  }

  void _enterPerformance() {
    _openingTimer?.cancel();
    setState(() {
      _phase = _MemoryPhase.performance;
      _photoVisible = false;
      _index = 0;
    });

    _photoMotionController
      ..reset()
      ..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _phase != _MemoryPhase.performance) return;
      setState(() => _photoVisible = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted && _phase == _MemoryPhase.performance) {
          _beginScene();
        }
      });
    });
  }

  void _beginScene() {
    _typingTimer?.cancel();
    if (_scenes.isEmpty || _phase != _MemoryPhase.performance) return;

    final scene = _scene;
    final fullText = _replaceTokens(scene.text);
    final useTypewriter = scene.animation == 'typewriter';

    if (!useTypewriter) {
      setState(() {
        _typedText = fullText;
        _typingDone = true;
      });
      return;
    }

    setState(() {
      _typedText = '';
      _typingDone = false;
    });

    int cursor = 0;
    _typingTimer = Timer.periodic(
      const Duration(milliseconds: 35),
          (timer) {
        if (!mounted || _phase != _MemoryPhase.performance) {
          timer.cancel();
          return;
        }

        cursor++;
        if (cursor >= fullText.length) {
          timer.cancel();
          setState(() {
            _typedText = fullText;
            _typingDone = true;
          });
        } else {
          setState(() {
            _typedText = fullText.substring(0, cursor);
          });
        }
      },
    );
  }

  void _advance() {
    if (_phase == _MemoryPhase.opening) {
      _skipOpening();
      return;
    }
    if (_phase != _MemoryPhase.performance || _finishing) return;

    if (!_typingDone) {
      _typingTimer?.cancel();
      setState(() {
        _typedText = _replaceTokens(_scene.text);
        _typingDone = true;
      });
      return;
    }

    if (_index >= _scenes.length - 1) {
      _finish();
      return;
    }

    setState(() => _index += 1);
    _beginScene();
  }

  void _skip() {
    if (_phase == _MemoryPhase.opening) {
      _skipOpening();
      return;
    }
    if (_phase != _MemoryPhase.performance) return;
    _typingTimer?.cancel();
    _finish();
  }

  String get _finalMemoryText {
    if (_scenes.isEmpty) return '';
    return _replaceTokens(_scenes.last.text).trim();
  }

  Future<void> _markMemoryViewed() async {
    if (_markingViewed) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _markingViewed = true;

    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable('markEventMemoryViewed');

      await callable.call(<String, dynamic>{
        'eventId': widget.eventId,
        'memoryId': widget.memoryId,
      });
    } on FirebaseFunctionsException catch (e) {
      // 觀看紀錄失敗不阻擋完成畫面、收藏或相簿儲存。
      debugPrint(
        '⚠️ 記錄限定回憶已觀看失敗：${e.code} / ${e.message}',
      );
    } catch (e) {
      debugPrint('⚠️ 記錄限定回憶已觀看失敗：$e');
    } finally {
      _markingViewed = false;
    }
  }

  Future<void> _finish() async {
    if (!mounted || _finishing) return;
    _finishing = true;
    _typingTimer?.cancel();
    _photoMotionController.stop();

    setState(() => _phase = _MemoryPhase.finished);

    // 不論正常看完或按「跳過」，都視為玩家已觀看這篇回憶。
    await _markMemoryViewed();

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.92,
              ),
              decoration: BoxDecoration(
                color: Theme.of(sheetContext).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(sheetContext).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '這段回憶，留下來了。',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.52,
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: RepaintBoundary(
                              key: _memoryCardKey,
                              child: _MemorySaveCard(
                                imageProvider: _characterImageProvider(),
                                title: widget.memoryTitle,
                                characterName: widget.characterName,
                                playerName: widget.playerName,
                                finalText: _finalMemoryText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '收藏會保留在遊戲內；只有儲存到手機相簿時，才會向系統要求相簿權限。',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11,
                        color: Theme.of(sheetContext)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: (_collecting || _isCollected)
                          ? null
                          : () async {
                        final collected = await _collectMemory();
                        if (!mounted || !sheetContext.mounted) return;
                        if (collected) setSheetState(() {});
                      },
                      icon: _collecting
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Icon(
                        _isCollected
                            ? Icons.bookmark_added_rounded
                            : Icons.bookmark_add_outlined,
                      ),
                      label: Text(
                        _collecting
                            ? '正在收藏…'
                            : (_isCollected ? '已收藏' : '收藏這段回憶'),
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _saving
                          ? null
                          : () async {
                        setState(() => _saving = true);
                        setSheetState(() {});
                        await _saveMemoryCardToGallery();
                        if (!mounted) return;
                        setState(() => _saving = false);
                        if (sheetContext.mounted) {
                          setSheetState(() {});
                        }
                      },
                      icon: _saving
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.photo_library_outlined),
                      label: Text(_saving ? '正在儲存…' : '儲存到手機相簿'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: (_saving || _collecting)
                          ? null
                          : () {
                        Navigator.of(sheetContext).pop();
                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text('完成'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    _finishing = false;
  }

  String _collectionDocumentId() {
    final raw =
        '${widget.eventId}__${widget.memoryId}__${widget.characterId}__${widget.playerProfileId}';
    return raw.replaceAll('/', '_');
  }

  List<Map<String, dynamic>> _sceneSnapshots() {
    return _scenes
        .map(
          (scene) => <String, dynamic>{
        'id': scene.id,
        'type': scene.type,
        'text': scene.text,
        'animation': scene.animation,
        'characterAnimation': scene.characterAnimation,
        'durationMs': scene.durationMs,
        'backgroundImageUrl': scene.backgroundImageUrl,
        'characterImageUrl': scene.characterImageUrl,
      },
    )
        .toList();
  }

  Future<bool> _collectMemory() async {
    if (_collecting || _isCollected) return _isCollected;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showMessage('請先登入後再收藏這段回憶', isError: true);
      return false;
    }

    setState(() => _collecting = true);

    try {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('event_memories')
          .doc(_collectionDocumentId());

      await ref.set({
        'eventId': widget.eventId,
        'memoryId': widget.memoryId,
        'memoryTitle': widget.memoryTitle,
        'characterId': widget.characterId,
        'characterName': widget.characterName,
        'characterImageSnapshot': widget.characterAvatarPath,
        'profileId': widget.playerProfileId,
        'playerName': widget.playerName,
        'playerProfileName': widget.playerProfileName,
        'finalText': _finalMemoryText,
        'sceneSnapshot': _sceneSnapshots(),
        'collectedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return true;

      setState(() => _isCollected = true);
      _showMessage(
        '已收藏這段回憶 ♡',
        customIcon: Icons.bookmark_added_rounded,
      );
      return true;
    } catch (e) {
      debugPrint('❌ 收藏限定回憶失敗：$e');
      _showMessage('收藏失敗，請稍後再試', isError: true);
      return false;
    } finally {
      if (mounted) {
        setState(() => _collecting = false);
      }
    }
  }

  Future<bool> _saveMemoryCardToGallery() async {
    if (kIsWeb) {
      _showMessage('網頁版目前不支援直接儲存到手機相簿', isError: true);
      return false;
    }

    try {
      bool hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }

      if (!hasAccess) {
        _showMessage('需要相簿權限才能儲存這段回憶', isError: true);
        return false;
      }

      final boundary = _memoryCardKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary == null) {
        _showMessage('回憶圖片還沒準備好，請再試一次', isError: true);
        return false;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        _showMessage('產生回憶圖片失敗', isError: true);
        return false;
      }

      final Uint8List bytes = byteData.buffer.asUint8List();

      final fileName =
          'lianlian_memory_${DateTime.now().millisecondsSinceEpoch}.png';

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      await tempFile.writeAsBytes(
        bytes,
        flush: true,
      );

      await Gal.putImage(
        tempFile.path,
        album: '戀戀拾光',
      );

      try {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {}

      _showMessage(
        '已儲存到手機相簿 ♡',
        customIcon: Icons.photo_library_rounded,
      );

      return true;
    } on GalException catch (e) {
      debugPrint('❌ 儲存限定回憶失敗：${e.type}');
      _showMessage('儲存失敗，請確認相簿權限後再試一次', isError: true);
      return false;
    } catch (e) {
      debugPrint('❌ 儲存限定回憶失敗：$e');
      _showMessage('儲存失敗，請稍後再試', isError: true);
      return false;
    }
  }

  void _showMessage(
      String message, {
        bool isError = false,
        IconData? customIcon,
      }) {
    if (!mounted) return;

    ToastUtils.showCenterToast(
      context,
      message,
      isError: isError,
      customIcon: customIcon,
    );
  }

  Widget _buildOpening() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _skipOpening,
      child: ColoredBox(
        color: const Color(0xFF17131E),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedOpacity(
                    opacity: _openingVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeInOut,
                    child: Text(
                      _openingText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 20,
                        height: 1.9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 12,
                child: TextButton(
                  onPressed: _skipOpening,
                  child: const Text(
                    '略過',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovingCharacterPhoto() {
    final provider = _characterImageProvider();
    if (provider == null) {
      return Container(
        color: const Color(0xFF17131E),
        alignment: Alignment.center,
        child: const Icon(
          Icons.person_rounded,
          size: 72,
          color: Colors.white54,
        ),
      );
    }

    return AnimatedOpacity(
      opacity: _photoVisible ? 1 : 0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      child: AnimatedBuilder(
        animation: _photoMotionController,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_photoMotionController.value);
          final scale = 1.025 + (0.018 * t);
          final dx = -4.0 + (8.0 * t);
          final dy = 2.0 - (4.0 * t);

          return Transform.translate(
            offset: Offset(dx, dy),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: SizedBox.expand(
          child: Image(
            image: provider,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF17131E),
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image_outlined,
                size: 64,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textPanel(_MemoryScene scene) {
    final isDialogue = scene.type == 'dialogue';
    final isEnding = scene.type == 'ending';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.13),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDialogue) ...[
            Text(
              widget.characterName,
              style: GoogleFonts.notoSerifTc(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (isEnding) ...[
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '回憶',
                  style: GoogleFonts.notoSerifTc(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            _typedText,
            style: GoogleFonts.notoSerifTc(
              color: Colors.white,
              fontSize: isEnding ? 17 : 15,
              height: 1.75,
              fontWeight: isEnding ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _typingDone
                  ? (_index == _scenes.length - 1 ? '點擊完成' : '點擊繼續')
                  : '點擊顯示全文',
              style: GoogleFonts.notoSerifTc(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 9.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformance() {
    final scene = _scene;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _advance,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildMovingCharacterPhoto(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.62),
                ],
                stops: const [0, 0.48, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 10, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor:
                          Colors.black.withValues(alpha: 0.25),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.memoryTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSerifTc(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                shadows: const [
                                  Shadow(color: Colors.black54, blurRadius: 8),
                                ],
                              ),
                            ),
                            Text(
                              '${_index + 1} / ${_scenes.length}',
                              style: GoogleFonts.notoSerifTc(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _skip,
                        child: const Text(
                          '跳過',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                  child: _textPanel(scene),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _phase == _MemoryPhase.loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF17131E),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_error != null || _scenes.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error ?? '沒有可播放的 Scene'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (_phase) {
        _MemoryPhase.opening => _buildOpening(),
        _MemoryPhase.performance => _buildPerformance(),
        _MemoryPhase.finished => _buildPerformance(),
        _MemoryPhase.loading => const SizedBox.shrink(),
      },
    );
  }
}

class _MemorySaveCard extends StatelessWidget {
  final ImageProvider? imageProvider;
  final String title;
  final String characterName;
  final String playerName;
  final String finalText;

  const _MemorySaveCard({
    required this.imageProvider,
    required this.title,
    required this.characterName,
    required this.playerName,
    required this.finalText,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageProvider != null)
              Image(
                image: imageProvider!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const ColoredBox(color: Color(0xFF201927)),
              )
            else
              const ColoredBox(color: Color(0xFF201927)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.78),
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '戀戀拾光・限定回憶',
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$characterName × $playerName',
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white.withValues(alpha: 0.86),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (finalText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      finalText,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 13,
                        height: 1.65,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    _formatToday(),
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatToday() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}.$month.$day';
  }
}

class _MemoryScene {
  final String id;
  final String type;
  final String text;
  final String animation;
  final String characterAnimation;
  final int durationMs;
  final String backgroundImageUrl;
  final String characterImageUrl;

  const _MemoryScene({
    required this.id,
    required this.type,
    required this.text,
    required this.animation,
    required this.characterAnimation,
    required this.durationMs,
    required this.backgroundImageUrl,
    required this.characterImageUrl,
  });

  factory _MemoryScene.fromMap(String id, Map<String, dynamic> data) {
    return _MemoryScene(
      id: id,
      type: (data['type'] ?? 'narration').toString(),
      text: (data['text'] ?? '').toString(),
      animation: (data['animation'] ?? 'fade').toString(),
      characterAnimation:
      (data['characterAnimation'] ?? 'fadeIn').toString(),
      durationMs: (data['durationMs'] as num?)?.toInt() ?? 800,
      backgroundImageUrl:
      (data['backgroundImageUrl'] ?? '').toString().trim(),
      characterImageUrl:
      (data['characterImageUrl'] ?? '').toString().trim(),
    );
  }
}
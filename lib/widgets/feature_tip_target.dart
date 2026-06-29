import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
const bool kFeatureTipDebugShowAll = false;
enum FeatureTipDirection {
  down,
  up,
  left,
  right,
}

class FeatureTipTarget extends StatefulWidget {
  final String tipKey;
  final String tipText;
  final Widget child;

  /// 同一頁請用同一個 scopeKey。
  /// 例如聊天首頁都用 chat_home，拾光牆都用 moments_page。
  final String scopeKey;

  /// 同一個 scopeKey 裡，order 小的先出現。
  final int order;

  /// 氣泡方向。
  /// down = 顯示在目標下方
  /// up = 顯示在目標上方
  /// left = 顯示在目標左方
  /// right = 顯示在目標右方
  final FeatureTipDirection direction;

  /// 位置微調。
  final Offset offset;

  /// 舊參數保留：往下距離。通常 48～60。
  final double top;

  /// 舊參數保留：微調左右位置。
  final double? left;
  final double? right;

  final Color? color;
  final Color? textColor;
  final bool enabled;

  final double maxWidth;
  final double fontSize;
  final bool debugShowAll;
  final double arrowOffset;
  const FeatureTipTarget({
    super.key,
    required this.tipKey,
    required this.tipText,
    required this.child,
    this.scopeKey = 'global',
    this.order = 999,
    this.direction = FeatureTipDirection.down,
    this.offset = Offset.zero,
    this.top = 56,
    this.left,
    this.right,
    this.color,
    this.textColor,
    this.enabled = true,
    this.maxWidth = 168,
    this.fontSize = 13.5,
    this.arrowOffset = 0,
    this.debugShowAll = false,
  });

  @override
  State<FeatureTipTarget> createState() => _FeatureTipTargetState();
}

class _TipQueueItem {
  final String ownerId;
  final String tipKey;
  final String scopeKey;
  final int order;

  const _TipQueueItem({
    required this.ownerId,
    required this.tipKey,
    required this.scopeKey,
    required this.order,
  });
}

class _FeatureTipTargetState extends State<FeatureTipTarget> {
  final String _instanceId = UniqueKey().toString();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isRegistered = false;

  static final Map<String, List<_TipQueueItem>> _queues = {};
  static final Map<String, String?> _activeOwnerByScope = {};
  static final Map<String, Set<String>> _registeredKeysByScope = {};
  static final Map<String, _FeatureTipTargetState> _states = {};
  static final Set<String> _scheduledScopes = {};

  String get _prefsKey => 'closed_feature_tip_${widget.tipKey}';

  @override
  void initState() {
    super.initState();
    _states[_instanceId] = this;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryRegisterTip();
    });
  }

  @override
  void didUpdateWidget(covariant FeatureTipTarget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool isDebugMode = kFeatureTipDebugShowAll || widget.debugShowAll;

    if (oldWidget.tipKey != widget.tipKey ||
        oldWidget.scopeKey != widget.scopeKey ||
        oldWidget.enabled != widget.enabled ||
        oldWidget.order != widget.order ||
        oldWidget.direction != widget.direction ||
        oldWidget.offset != widget.offset ||
        oldWidget.top != widget.top ||
        oldWidget.left != widget.left ||
        oldWidget.right != widget.right ||
        oldWidget.maxWidth != widget.maxWidth ||
        oldWidget.arrowOffset != widget.arrowOffset ||
        oldWidget.debugShowAll != widget.debugShowAll) {
      _hideOverlay();
      _unregisterTip(promoteNext: false);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _tryRegisterTip();
      });

      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (isDebugMode) {
        _hideOverlay();
        _showOverlay();
        return;
      }

      if (_activeOwnerByScope[widget.scopeKey] == _instanceId) {
        _hideOverlay();
        _showOverlay();
      }
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    _states.remove(_instanceId);
    _unregisterTip(promoteNext: true);
    super.dispose();
  }

  Future<void> _tryRegisterTip() async {
    if (!mounted) return;

    if (!widget.enabled) {
      _unregisterTip();
      return;
    }

    // 開發調位置模式：全部強制顯示，不讀 SharedPreferences，不排隊
    if (kFeatureTipDebugShowAll || widget.debugShowAll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _hideOverlay();
        _showOverlay();
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final hasClosed = prefs.getBool(_prefsKey) ?? false;

    if (!mounted) return;

    if (hasClosed) {
      _unregisterTip();
      return;
    }
    final registeredKeys =
    _registeredKeysByScope.putIfAbsent(widget.scopeKey, () => <String>{});

    // 同一頁同一個 tipKey 只註冊一次。
    // 貼文列表就算每篇都有收藏/按讚，也只會跳第一顆。
    if (registeredKeys.contains(widget.tipKey)) {
      return;
    }

    registeredKeys.add(widget.tipKey);
    _isRegistered = true;

    final queue = _queues.putIfAbsent(widget.scopeKey, () => <_TipQueueItem>[]);

    final item = _TipQueueItem(
      ownerId: _instanceId,
      tipKey: widget.tipKey,
      scopeKey: widget.scopeKey,
      order: widget.order,
    );

    final insertIndex = queue.indexWhere((old) => old.order > widget.order);

    if (insertIndex == -1) {
      queue.add(item);
    } else {
      queue.insert(insertIndex, item);
    }

    _schedulePromoteNext(widget.scopeKey);
  }

  void _unregisterTip({bool promoteNext = true}) {
    if (!_isRegistered) return;

    final queue = _queues[widget.scopeKey];
    queue?.removeWhere((item) => item.ownerId == _instanceId);

    _registeredKeysByScope[widget.scopeKey]?.remove(widget.tipKey);

    _isRegistered = false;

    if (_activeOwnerByScope[widget.scopeKey] == _instanceId) {
      _activeOwnerByScope[widget.scopeKey] = null;
      _hideOverlay();

      if (promoteNext) {
        _schedulePromoteNext(widget.scopeKey);
      }
    }
  }

  static void _schedulePromoteNext(String scopeKey) {
    if (_scheduledScopes.contains(scopeKey)) return;

    _scheduledScopes.add(scopeKey);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduledScopes.remove(scopeKey);
      _promoteNext(scopeKey);
    });

    // 關鍵：確保即使畫面沒有滑動 / 沒有 rebuild，也會觸發下一幀
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  static void _promoteNext(String scopeKey) {
    if (_activeOwnerByScope[scopeKey] != null) return;

    final queue = _queues[scopeKey];
    if (queue == null || queue.isEmpty) return;

    queue.removeWhere((item) {
      final state = _states[item.ownerId];
      return state == null || !state.mounted || !state.widget.enabled;
    });

    if (queue.isEmpty) {
      _activeOwnerByScope[scopeKey] = null;
      return;
    }

    final next = queue.first;
    final nextState = _states[next.ownerId];

    if (nextState == null || !nextState.mounted) {
      queue.removeAt(0);
      _schedulePromoteNext(scopeKey);
      return;
    }

    _activeOwnerByScope[scopeKey] = next.ownerId;
    debugPrint('➡️ promote next tip: ${next.tipKey}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!nextState.mounted) return;
      if (_activeOwnerByScope[scopeKey] != next.ownerId) return;

      nextState._showOverlay();
    });

// 關鍵：讓上面的 addPostFrameCallback 真的被執行
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _closeTip() async {
    // 開發調位置模式：按 X 只暫時關掉，不記錄已關閉
    if (kFeatureTipDebugShowAll || widget.debugShowAll) {
      _hideOverlay();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, true);

    final scopeKey = widget.scopeKey;

    final queue = _queues[scopeKey];
    queue?.removeWhere((item) => item.ownerId == _instanceId);

    _registeredKeysByScope[scopeKey]?.remove(widget.tipKey);

    _isRegistered = false;

    if (_activeOwnerByScope[scopeKey] == _instanceId) {
      _activeOwnerByScope[scopeKey] = null;
    }

    _hideOverlay();

    // 先下一幀推一次
    _schedulePromoteNext(scopeKey);

    // 再延遲一點補推一次，避免 StreamBuilder / AppBar 重建時吃掉
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      _schedulePromoteNext(scopeKey);
    });
  }

  Alignment _targetAnchor() {
    switch (widget.direction) {
      case FeatureTipDirection.down:
        return Alignment.bottomCenter;
      case FeatureTipDirection.up:
        return Alignment.topCenter;
      case FeatureTipDirection.right:
        return Alignment.centerRight;
      case FeatureTipDirection.left:
        return Alignment.centerLeft;
    }
  }

  Alignment _followerAnchor() {
    switch (widget.direction) {
      case FeatureTipDirection.down:
        return Alignment.topCenter;
      case FeatureTipDirection.up:
        return Alignment.bottomCenter;
      case FeatureTipDirection.right:
        return Alignment.centerLeft;
      case FeatureTipDirection.left:
        return Alignment.centerRight;
    }
  }

  Offset _placementOffset() {
    const double estimatedTargetWidth = 48;
    final double verticalGap = (widget.top - 48).clamp(6.0, 80.0);
    const double sideGap = 8;

    double dx = widget.offset.dx;
    double dy = widget.offset.dy;

    // 保留原本 left / right 的使用方式，避免妳已經寫的地方全壞掉。
    if (widget.left != null) {
      dx += ((widget.maxWidth - estimatedTargetWidth) / 2) + widget.left!;
    }

    if (widget.right != null) {
      dx -= ((widget.maxWidth - estimatedTargetWidth) / 2) + widget.right!;
    }

    switch (widget.direction) {
      case FeatureTipDirection.down:
        return Offset(dx, verticalGap + dy);
      case FeatureTipDirection.up:
        return Offset(dx, -verticalGap + dy);
      case FeatureTipDirection.right:
        return Offset(sideGap + dx, dy);
      case FeatureTipDirection.left:
        return Offset(-sideGap + dx, dy);
    }
  }

  void _showOverlay() {
    debugPrint('💬 show overlay: ${widget.tipKey}');
    if (!mounted) return;

    _hideOverlay();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    final theme = Theme.of(context);

    final bubbleColor =
        widget.color ?? theme.colorScheme.primaryContainer;

    final bubbleTextColor =
        widget.textColor ?? theme.colorScheme.onPrimaryContainer;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: _targetAnchor(),
              followerAnchor: _followerAnchor(),
              offset: _placementOffset(),
              child: UnconstrainedBox(
                alignment: Alignment.topLeft,
                child: _NewFeatureTipBubble(
                  text: widget.tipText,
                  color: bubbleColor,
                  textColor: bubbleTextColor,
                  maxWidth: widget.maxWidth,
                  fontSize: widget.fontSize,
                  direction: widget.direction,
                  arrowOffset: widget.arrowOffset,
                  onClose: _closeTip,
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    try {
      _overlayEntry?.remove();
    } catch (_) {
      // 路由切換或熱重載時，避免重複 remove 爆掉。
    }

    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.child,
    );
  }
}

class _NewFeatureTipBubble extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double maxWidth;
  final double fontSize;
  final FeatureTipDirection direction;
  final double arrowOffset;
  final VoidCallback onClose;

  const _NewFeatureTipBubble({
    required this.text,
    required this.color,
    required this.textColor,
    required this.maxWidth,
    required this.fontSize,
    required this.direction,
    required this.arrowOffset,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final double safeArrowOffset = arrowOffset.clamp(
      -(maxWidth / 2) + 10,
      (maxWidth / 2) - 10,
    ).toDouble();

    final bool isHorizontalDirection =
        direction == FeatureTipDirection.left ||
            direction == FeatureTipDirection.right;

    final Widget arrow = isHorizontalDirection
        ? SizedBox(
      width: 8,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12 + safeArrowOffset,
            child: CustomPaint(
              size: const Size(8, 16),
              painter: _TrianglePainter(color, direction),
            ),
          ),
        ],
      ),
    )
        : SizedBox(
      width: maxWidth,
      height: 8,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: (maxWidth / 2) - 8 + safeArrowOffset,
            child: CustomPaint(
              size: const Size(16, 8),
              painter: _TrianglePainter(color, direction),
            ),
          ),
        ],
      ),
    );

    final Widget bubbleBody = Container(
      constraints: BoxConstraints(
        minWidth: 88,
        maxWidth: maxWidth,
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              softWrap: true,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                height: 1.25,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.close_rounded,
                color: textColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );

    Widget content;

    switch (direction) {
      case FeatureTipDirection.down:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            arrow,
            bubbleBody,
          ],
        );
        break;

      case FeatureTipDirection.up:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bubbleBody,
            arrow,
          ],
        );
        break;

      case FeatureTipDirection.right:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            arrow,
            bubbleBody,
          ],
        );
        break;

      case FeatureTipDirection.left:
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            bubbleBody,
            arrow,
          ],
        );
        break;
    }

    return Material(
      color: Colors.transparent,
      child: content,
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final FeatureTipDirection direction;

  _TrianglePainter(this.color, this.direction);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.96);
    final path = Path();

    switch (direction) {
      case FeatureTipDirection.down:
        path
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..close();
        break;

      case FeatureTipDirection.up:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close();
        break;

      case FeatureTipDirection.right:
        path
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..close();
        break;

      case FeatureTipDirection.left:
        path
          ..moveTo(size.width, size.height / 2)
          ..lineTo(0, 0)
          ..lineTo(0, size.height)
          ..close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.direction != direction;
  }
}
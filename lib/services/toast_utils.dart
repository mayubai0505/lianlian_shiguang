import 'dart:async';

import 'package:flutter/material.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

class ToastUtils {
  static OverlayEntry? _overlayEntry;
  static OverlayState? _overlayState;
  static Timer? _dismissTimer;

  static final ValueNotifier<_ToastData?> _toastNotifier =
  ValueNotifier<_ToastData?>(null);

  /// ==========================
  /// 快速呼叫
  /// ==========================

  static void success(
      BuildContext context,
      String message,
      ) {
    showCenterToast(
      context,
      message,
      type: ToastType.success,
    );
  }

  static void error(
      BuildContext context,
      String message,
      ) {
    showCenterToast(
      context,
      message,
      type: ToastType.error,
    );
  }

  static void warning(
      BuildContext context,
      String message,
      ) {
    showCenterToast(
      context,
      message,
      type: ToastType.warning,
    );
  }

  static void info(
      BuildContext context,
      String message,
      ) {
    showCenterToast(
      context,
      message,
      type: ToastType.info,
    );
  }

  /// ==========================
  /// 主方法
  /// 舊 API 仍然可以繼續使用
  /// ==========================

  static void showCenterToast(
      BuildContext context,
      String message, {
        ToastType? type,
        bool isError = false,
        IconData? customIcon,
      }) {
    // 永遠使用最外層 Overlay。
    // 避免 Dialog / PopupMenu / BottomSheet 各自拿到不同 Overlay。
    final OverlayState? overlay =
    Overlay.maybeOf(
      context,
      rootOverlay: true,
    );

    if (overlay == null) {
      return;
    }

    final toastType =
        type ??
            (isError
                ? ToastType.error
                : ToastType.info);

    final toastData = _ToastData(
      message,
      toastType,
      customIcon,
    );

    // 如果 entry 物件還在，
    // 但其實已經不在 widget tree，
    // 先把 static 狀態清乾淨。
    if (_overlayEntry != null &&
        !_overlayEntry!.mounted) {
      _overlayEntry = null;
      _overlayState = null;
    }

    // 已經有 Toast，而且仍掛在同一個 root Overlay
    // → 只更新內容，不建立第二個 OverlayEntry。
    if (_overlayEntry != null &&
        _overlayEntry!.mounted &&
        identical(
          _overlayState,
          overlay,
        )) {
      _toastNotifier.value =
          toastData;

      _restartDismissTimer();
      return;
    }

    // 如果舊 Toast 屬於另一個 Overlay，
    // 先完整移除。
    if (_overlayEntry != null) {
      try {
        if (_overlayEntry!.mounted) {
          _overlayEntry!.remove();
        }
      } catch (e) {
        debugPrint(
          '⚠️ 移除舊 Toast Overlay 失敗：$e',
        );
      }

      _overlayEntry = null;
      _overlayState = null;
    }

    _dismissTimer?.cancel();
    _dismissTimer = null;

    _toastNotifier.value =
        toastData;

    final entry = OverlayEntry(
      builder: (_) {
        return IgnorePointer(
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Center(
                child:
                ValueListenableBuilder<
                    _ToastData?>(
                  valueListenable:
                  _toastNotifier,
                  builder: (
                      context,
                      data,
                      child,
                      ) {
                    if (data == null) {
                      return const SizedBox
                          .shrink();
                    }

                    final style =
                    _styleOf(
                      data.type,
                    );

                    return TweenAnimationBuilder<
                        double>(
                      key: ValueKey(
                        '${data.message}-'
                            '${data.type}-'
                            '${data.customIcon}',
                      ),
                      tween: Tween<double>(
                        begin: 0.88,
                        end: 1,
                      ),
                      duration:
                      const Duration(
                        milliseconds: 220,
                      ),
                      curve:
                      Curves.easeOutBack,
                      builder: (
                          context,
                          scale,
                          child,
                          ) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Container(
                        constraints:
                        const BoxConstraints(
                          maxWidth: 320,
                        ),
                        margin:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 24,
                        ),
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          style.background,
                          borderRadius:
                          BorderRadius
                              .circular(
                            22,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.16,
                              ),
                              blurRadius: 18,
                              offset:
                              const Offset(
                                0,
                                8,
                              ),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize
                              .min,
                          children: [
                            Icon(
                              data.customIcon ??
                                  style.icon,
                              color:
                              style.iconColor,
                              size: 22,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                data.message,
                                textAlign:
                                TextAlign
                                    .center,
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 15.5,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    _overlayEntry = entry;
    _overlayState = overlay;

    // 下一個 frame 再插入，
    // 避免 Dialog / PopupMenu 正在移除 Overlay 的同一 frame 撞車。
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (_overlayEntry != entry) {
        return;
      }

      if (entry.mounted) {
        return;
      }

      try {
        overlay.insert(entry);
        _restartDismissTimer();
      } catch (e) {
        debugPrint(
          '❌ Toast Overlay 插入失敗：$e',
        );

        if (_overlayEntry == entry) {
          _overlayEntry = null;
          _overlayState = null;
          _toastNotifier.value =
          null;
        }
      }
    });
  }

  static void _restartDismissTimer() {
    _dismissTimer?.cancel();

    _dismissTimer = Timer(
      const Duration(milliseconds: 1800),
      _removeToast,
    );
  }

  static void _removeToast() {
    _dismissTimer?.cancel();
    _dismissTimer = null;

    final entry = _overlayEntry;

    _overlayEntry = null;
    _overlayState = null;

    if (entry != null) {
      try {
        if (entry.mounted) {
          entry.remove();
        }
      } catch (e) {
        debugPrint(
          '⚠️ Toast Overlay 移除失敗：$e',
        );
      }
    }

    _toastNotifier.value = null;
  }

  static _ToastStyle _styleOf(
      ToastType type,
      ) {
    switch (type) {
      case ToastType.success:
        return const _ToastStyle(
          background: Color(0xFF59B96A),
          icon: Icons.check_circle_rounded,
          iconColor: Colors.white,
        );

      case ToastType.error:
        return const _ToastStyle(
          background: Color(0xFFE85B6A),
          icon: Icons.error_rounded,
          iconColor: Colors.white,
        );

      case ToastType.warning:
        return const _ToastStyle(
          background: Color(0xFFFFB74D),
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.white,
        );

      case ToastType.info:
        return const _ToastStyle(
          background: Color(0xFF6C8EF5),
          icon: Icons.info_rounded,
          iconColor: Colors.white,
        );
    }
  }
}

class _ToastData {
  final String message;
  final ToastType type;
  final IconData? customIcon;

  const _ToastData(
      this.message,
      this.type,
      this.customIcon,
      );
}

class _ToastStyle {
  final Color background;
  final IconData icon;
  final Color iconColor;

  const _ToastStyle({
    required this.background,
    required this.icon,
    required this.iconColor,
  });
}
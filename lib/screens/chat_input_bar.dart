import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isGenerating;
  final bool isLoading;
  final bool showCounter;
  final String hintText;
  final String regeneratingTooltip;
  final String continueTooltip;

  final ValueChanged<String> onChanged;
  final VoidCallback onToolbox;
  final VoidCallback onRegenerate;
  final VoidCallback onContinue;
  final VoidCallback onStop;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isGenerating,
    required this.isLoading,
    required this.showCounter,
    required this.hintText,
    required this.regeneratingTooltip,
    required this.continueTooltip,
    required this.onChanged,
    required this.onToolbox,
    required this.onRegenerate,
    required this.onContinue,
    required this.onStop,
    required this.onSend,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  bool _toolsExpandedWhileFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChange);
      widget.focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;

    setState(() {
      // 一離開輸入框，就回到「三顆完整顯示」的預設狀態。
      if (!widget.focusNode.hasFocus) {
        _toolsExpandedWhileFocused = false;
      } else {
        // 每次重新點進輸入框，都先自動收起。
        _toolsExpandedWhileFocused = false;
      }
    });
  }

  void _expandTools() {
    if (!mounted) return;
    setState(() {
      _toolsExpandedWhileFocused = true;
    });
  }

  void _collapseToolsFromInputTap() {
    if (!widget.focusNode.hasFocus || !_toolsExpandedWhileFocused) return;

    setState(() {
      _toolsExpandedWhileFocused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final disabled = widget.isGenerating || widget.isLoading;

    final bool showFullToolButtons =
        !widget.focusNode.hasFocus || _toolsExpandedWhileFocused;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: primary.withValues(alpha: 0.10),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: showFullToolButtons
                    ? Row(
                  key: const ValueKey('full-chat-tools'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BareIconButton(
                      tooltip: 'Tools',
                      asset:
                      'assets/images/chat/chat_more_cloud_mask.png',
                      assetSize: 30,
                      onPressed:
                      disabled ? null : widget.onToolbox,
                    ),
                    _BareIconButton(
                      tooltip: widget.regeneratingTooltip,
                      asset:
                      'assets/images/chat/chat_regenerate_vine_mask.png',
                      assetSize: 30,
                      onPressed:
                      disabled ? null : widget.onRegenerate,
                    ),
                    _BareIconButton(
                      tooltip: widget.continueTooltip,
                      asset:
                      'assets/images/chat/chat_continue_vine_mask.png',
                      assetSize: 30,
                      onPressed:
                      disabled ? null : widget.onContinue,
                    ),
                  ],
                )
                    : _BareIconButton(
                  key: const ValueKey('expand-chat-tools'),
                  tooltip: '展開功能',
                  icon: Icons.chevron_right_rounded,
                  iconSize: 29,
                  onPressed: disabled ? null : _expandTools,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.showCounter)
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: widget.controller,
                      builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12, bottom: 3),
                          child: Text(
                            '${value.text.length}/900',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 10,
                              color: value.text.length >= 900
                                  ? Colors.redAccent
                                  : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.38),
                            ),
                          ),
                        );
                      },
                    ),
                  Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      onChanged: (value) {
                        widget.onChanged(value);

                        if (widget.focusNode.hasFocus && _toolsExpandedWhileFocused) {
                          setState(() {
                            _toolsExpandedWhileFocused = false;
                          });
                        }
                      },
                      onTap: _collapseToolsFromInputTap,
                      readOnly: disabled,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 900,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.notoSerifTc(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: GoogleFonts.notoSerifTc(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.36),
                        ),
                        border: InputBorder.none,
                        counterText: '',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            _BareIconButton(
              tooltip: widget.isGenerating ? 'Stop' : 'Send',
              icon: widget.isGenerating
                  ? Icons.stop_circle_outlined
                  : Icons.send_rounded,
              iconColor: widget.isGenerating ? Colors.redAccent : primary,
              onPressed: widget.isGenerating
                  ? widget.onStop
                  : (widget.isLoading ? null : widget.onSend),
            ),
          ],
        ),
      ),
    );
  }
}

class _BareIconButton extends StatelessWidget {
  final String tooltip;
  final IconData? icon;
  final String? asset;
  final double assetSize;
  final double iconSize;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const _BareIconButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.icon,
    this.asset,
    this.assetSize = 30,
    this.iconSize = 25,
    this.iconColor,
  }) : assert(icon != null || asset != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;
    final effectiveColor = onPressed == null
        ? theme.disabledColor
        : color.withValues(alpha: 0.88);

    return SizedBox(
      width: 40,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        splashRadius: 20,
        onPressed: onPressed,
        icon: asset != null
            ? Image.asset(
          asset!,
          width: assetSize,
          height: assetSize,
          fit: BoxFit.contain,
          color: effectiveColor,
          colorBlendMode: BlendMode.srcIn,
        )
            : Icon(
          icon,
          size: iconSize,
          color: effectiveColor,
        ),
      ),
    );
  }
}
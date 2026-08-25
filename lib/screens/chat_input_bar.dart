import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final disabled = isGenerating || isLoading;

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
            _BareIconButton(
              tooltip: 'Tools',
              icon: Icons.home_outlined,
              onPressed: disabled ? null : onToolbox,
            ),
            _BareIconButton(
              tooltip: regeneratingTooltip,
              icon: Icons.refresh_rounded,
              onPressed: disabled ? null : onRegenerate,
            ),
            _BareIconButton(
              tooltip: continueTooltip,
              icon: Icons.fast_forward_rounded,
              onPressed: disabled ? null : onContinue,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showCounter)
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
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
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      readOnly: disabled,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 900,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.notoSerifTc(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: hintText,
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
              tooltip: isGenerating ? 'Stop' : 'Send',
              icon: isGenerating
                  ? Icons.stop_circle_outlined
                  : Icons.send_rounded,
              iconColor: isGenerating ? Colors.redAccent : primary,
              onPressed: isGenerating
                  ? onStop
                  : (isLoading ? null : onSend),
            ),
          ],
        ),
      ),
    );
  }
}

class _BareIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const _BareIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: 40,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        splashRadius: 20,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: onPressed == null
              ? theme.disabledColor
              : color.withValues(alpha: 0.88),
        ),
      ),
    );
  }
}

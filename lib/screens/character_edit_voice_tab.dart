import 'package:flutter/material.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class CharacterEditVoiceTab extends StatelessWidget {
  final List<Map<String, dynamic>> voiceSamples;
  final bool isGeneratingVoice;
  final String? generatedVoiceId;
  final int? selectedSampleIndex;
  final int? playingSampleIndex;
  final int? loadingSampleIndex;
  final bool isTestingSettings;
  final double voiceStability;
  final double voiceStyle;

  final void Function(int index, String? voiceId) onSampleSelected;
  final ValueChanged<int> onPreviewVoiceSample;
  final VoidCallback onRetryVoiceSamples;
  final VoidCallback onConfirmVoiceSelection;
  final VoidCallback onShowVoiceGenerationDialog;
  final VoidCallback onRemakeVoice;
  final ValueChanged<double> onVoiceStabilityChanged;
  final ValueChanged<double> onVoiceStyleChanged;
  final VoidCallback onTestVoiceSettings;

  const CharacterEditVoiceTab({
    super.key,
    required this.voiceSamples,
    required this.isGeneratingVoice,
    required this.generatedVoiceId,
    required this.selectedSampleIndex,
    required this.playingSampleIndex,
    required this.loadingSampleIndex,
    required this.isTestingSettings,
    required this.voiceStability,
    required this.voiceStyle,
    required this.onSampleSelected,
    required this.onPreviewVoiceSample,
    required this.onRetryVoiceSamples,
    required this.onConfirmVoiceSelection,
    required this.onShowVoiceGenerationDialog,
    required this.onRemakeVoice,
    required this.onVoiceStabilityChanged,
    required this.onVoiceStyleChanged,
    required this.onTestVoiceSettings,
  });

  Widget _buildCleanSection({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 19,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title.trim(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    Widget valueLabel(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCleanSection(
            theme: theme,
            title: l10n.section_voice_gen,
            icon: Icons.graphic_eq_rounded,
            children: [
              Text(
                l10n.voice_gen_desc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: muted,
                ),
              ),
              const SizedBox(height: 18),
              if (isGeneratingVoice)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 26),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.voice_generating_status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
              else if (voiceSamples.isNotEmpty && generatedVoiceId == null) ...[
                Text(
                  l10n.voice_select_prompt,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(voiceSamples.length, (index) {
                  final sample = voiceSamples[index];
                  final isSelected = selectedSampleIndex == index;
                  final isPlayingThis = playingSampleIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => onSampleSelected(
                        index,
                        sample['voice_id']?.toString(),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.06)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(alpha: 0.65)
                                : theme.dividerColor.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: theme.colorScheme.primary,
                              size: 21,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.voice_sample_name(index + 1),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.voice_sample_desc,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: loadingSampleIndex == index
                                  ? null
                                  : () => onPreviewVoiceSample(index),
                              icon: loadingSampleIndex == index
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : Icon(
                                isPlayingThis
                                    ? Icons.pause_circle_outline_rounded
                                    : Icons.play_circle_outline_rounded,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onRetryVoiceSamples,
                        child: Text(l10n.voice_retry),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedSampleIndex == null
                            ? null
                            : onConfirmVoiceSelection,
                        child: Text(l10n.voice_confirm_selection),
                      ),
                    ),
                  ],
                ),
              ] else if (generatedVoiceId != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.voice_bind_success_banner,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onRemakeVoice,
                        child: Text(l10n.voice_remake),
                      ),
                    ],
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 19),
                    label: Text(
                      l10n.voice_btn_generate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: onShowVoiceGenerationDialog,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 28),
          _buildCleanSection(
            theme: theme,
            title: l10n.voice_advanced_tuning,
            icon: Icons.tune_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.voice_stability_low,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  valueLabel(
                    l10n.voice_stability_value(
                      voiceStability.toStringAsFixed(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.voice_stability_high,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Slider(
                value: voiceStability,
                min: 0.1,
                max: 0.9,
                activeColor: theme.colorScheme.primary,
                onChanged: onVoiceStabilityChanged,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.voice_style_low,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  valueLabel(
                    l10n.voice_style_value(voiceStyle.toStringAsFixed(2)),
                  ),
                  Expanded(
                    child: Text(
                      l10n.voice_style_high,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Slider(
                value: voiceStyle,
                min: 0.0,
                max: 1.0,
                activeColor: theme.colorScheme.primary,
                onChanged: onVoiceStyleChanged,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: isTestingSettings
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  )
                      : const Icon(Icons.headphones_rounded, size: 19),
                  label: Text(
                    isTestingSettings
                        ? l10n.voice_test_btn_testing
                        : l10n.voice_test_btn,
                  ),
                  onPressed: isTestingSettings ? null : onTestVoiceSettings,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

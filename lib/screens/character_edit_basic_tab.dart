import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class CharacterEditBasicTab extends StatefulWidget {
  final AppLocalizations l10n;

  final Widget bannerSection;
  final Widget imageGallerySection;

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController occupationController;
  final TextEditingController birthdayController;
  final TextEditingController heightController;
  final TextEditingController appearanceController;
  final TextEditingController customRelationshipController;
  final TextEditingController worldSettingController;
  final TextEditingController storySummaryController;
  final TextEditingController storyController;
  final TextEditingController firstLineController;
  final TextEditingController personalityController;
  final TextEditingController coreCharacterSettingController;
  final TextEditingController customOutputFormatController;
  final TextEditingController likesController;
  final TextEditingController dislikesController;
  final TextEditingController secretsController;
  final TextEditingController dialogueExamplesController;
  final TextEditingController extraInputController;

  final String? currentValidGender;
  final List<Map<String, String>> genderOptions;
  final ValueChanged<String?> onGenderChanged;

  final List<String> relationshipKeys;
  final String? selectedRelationship;
  final ValueChanged<String?> onRelationshipChanged;
  final String Function(String key) relationshipLabelForKey;

  final bool isWorldSettingExpanded;
  final VoidCallback onToggleWorldSettingExpanded;
  final bool isCoreCharacterSettingExpanded;
  final VoidCallback onToggleCoreCharacterSettingExpanded;

  final List<String> personalityTags;
  final List<String> defaultPersonalityTags;
  final ValueChanged<String> onTogglePersonalityTag;
  final void Function(String draggedTag, String targetTag) onMovePersonalityTag;
  final VoidCallback onAddCustomPersonalityTag;

  final List<EasterEgg> easterEggs;
  final void Function({EasterEgg? egg, int? index}) onOpenEasterEggEditor;
  final ValueChanged<int> onRemoveEasterEgg;

  final List<String> extraInfoItems;
  final ValueChanged<int> onEditExtraInfoItem;
  final ValueChanged<int> onRemoveExtraInfoItem;
  final VoidCallback onAddExtraInfoItem;

  const CharacterEditBasicTab({
    super.key,
    required this.l10n,
    required this.bannerSection,
    required this.imageGallerySection,
    required this.nameController,
    required this.ageController,
    required this.occupationController,
    required this.birthdayController,
    required this.heightController,
    required this.appearanceController,
    required this.customRelationshipController,
    required this.worldSettingController,
    required this.storySummaryController,
    required this.storyController,
    required this.firstLineController,
    required this.personalityController,
    required this.coreCharacterSettingController,
    required this.customOutputFormatController,
    required this.likesController,
    required this.dislikesController,
    required this.secretsController,
    required this.dialogueExamplesController,
    required this.extraInputController,
    required this.currentValidGender,
    required this.genderOptions,
    required this.onGenderChanged,
    required this.relationshipKeys,
    required this.selectedRelationship,
    required this.onRelationshipChanged,
    required this.relationshipLabelForKey,
    required this.isWorldSettingExpanded,
    required this.onToggleWorldSettingExpanded,
    required this.isCoreCharacterSettingExpanded,
    required this.onToggleCoreCharacterSettingExpanded,
    required this.personalityTags,
    required this.defaultPersonalityTags,
    required this.onTogglePersonalityTag,
    required this.onMovePersonalityTag,
    required this.onAddCustomPersonalityTag,
    required this.easterEggs,
    required this.onOpenEasterEggEditor,
    required this.onRemoveEasterEgg,
    required this.extraInfoItems,
    required this.onEditExtraInfoItem,
    required this.onRemoveExtraInfoItem,
    required this.onAddExtraInfoItem,
  });

  @override
  State<CharacterEditBasicTab> createState() => _CharacterEditBasicTabState();
}

class _CharacterEditBasicTabState extends State<CharacterEditBasicTab> {
  InputDecoration _cleanInputDecoration(
      ThemeData theme, {
        String? hintText,
        Widget? suffixIcon,
      }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.34),
        fontSize: 14,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.55),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.55),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.4,
        ),
      ),
    );
  }

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
              ] else ...[
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(width: 9),
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

  Widget _buildFieldHeading(
      String label,
      ThemeData theme, {
        String? description,
        bool isRequired = false,
        double labelFontSize = 15,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          if (description != null && description.trim().isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                height: 1.45,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        bool isRequired = false,
        String? description,
        String? hintText,
        int? maxLength,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldHeading(
            label,
            theme,
            description: description,
            isRequired: isRequired,
          ),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
            ),
            decoration: _cleanInputDecoration(theme, hintText: hintText),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxedTextField(
      TextEditingController controller,
      String label, {
        required int maxLength,
        String? hintText,
        String? description,
        bool isRequired = false,
        double inputFontSize = 16,
        bool isCollapsible = false,
        bool isExpanded = false,
        VoidCallback? onToggleExpanded,
      }) {
    final theme = Theme.of(context);
    final int currentLength = controller.text.characters.length;
    final int overflow = currentLength - maxLength;
    const int collapseThreshold = 400;

    final bool showExpandButton =
        isCollapsible && currentLength > collapseThreshold;
    final int? effectiveMaxLines =
    showExpandButton && !isExpanded ? 7 : null;

    final numberFormatter = NumberFormat.decimalPattern();
    final formattedCurrentLength = numberFormatter.format(currentLength);
    final formattedMaxLength = numberFormatter.format(maxLength);

    Color counterColor =
    theme.colorScheme.onSurface.withValues(alpha: 0.6);

    if (overflow > 0) {
      counterColor = Colors.red;
    } else if (currentLength >= maxLength - 100) {
      counterColor = Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldHeading(
          label,
          theme,
          description: description,
          isRequired: isRequired,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: inputFontSize,
              color: theme.textTheme.bodyMedium?.color,
            ),
            keyboardType: TextInputType.multiline,
            minLines: isCollapsible ? 5 : null,
            maxLines: effectiveMaxLines,
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.none,
            onChanged: (_) => setState(() {}),
            decoration: _cleanInputDecoration(
              theme,
              hintText: hintText,
            ).copyWith(
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (showExpandButton && onToggleExpanded != null)
              TextButton(
                onPressed: onToggleExpanded,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(
                    isExpanded
                        ? widget.l10n.characterProfileCollapse
                        : widget.l10n.characterProfileViewMore
                ),
              ),
            Text(
              '$formattedCurrentLength / $formattedMaxLength',
              style: theme.textTheme.bodySmall?.copyWith(
                color: counterColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDraggableSelectedTag(String tag, ThemeData theme) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => details.data != tag,
      onAcceptWithDetails: (details) {
        widget.onMovePersonalityTag(details.data, tag);
      },
      builder: (context, candidateData, rejectedData) {
        final isReceiving = candidateData.isNotEmpty;

        final tagButton = AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: isReceiving
                ? [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.28),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : const [],
          ),
          child: ElevatedButton.icon(
            onPressed: () => widget.onTogglePersonalityTag(tag),
            icon: Icon(
              Icons.drag_indicator_rounded,
              size: 17,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.82),
            ),
            label: Text(tag),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isReceiving
                      ? theme.colorScheme.onPrimary
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: isReceiving ? 4 : 2,
            ),
          ),
        );

        return LongPressDraggable<String>(
          data: tag,
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(opacity: 0.92, child: tagButton),
          ),
          childWhenDragging: Opacity(opacity: 0.35, child: tagButton),
          child: tagButton,
        );
      },
    );
  }

  Widget _buildTagButton(String tag, ThemeData theme) {
    return ElevatedButton(
      onPressed: () => widget.onTogglePersonalityTag(tag),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
      ),
      child: Text(tag),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCleanSection(
            theme: theme,
            title: l10n.characterEditCharacterImage,
            icon: Icons.photo_library_outlined,
            children: [
              widget.bannerSection,
              const SizedBox(height: 22),
              widget.imageGallerySection,
            ],
          ),
          _buildCleanSection(
            theme: theme,
            title: l10n.section_basic_info,
            icon: Icons.person_outline_rounded,
            children: [
              _buildTextField(
                widget.nameController,
                l10n.charNameLabel,
                description: l10n.characterEditNameDescription,
                hintText: l10n.characterEditNameHint,
                maxLength: 20,
                isRequired: true,
              ),
              _buildTextField(
                widget.ageController,
                l10n.charAgeLabel,
                description: l10n.characterEditAgeDescription,
                hintText: l10n.characterEditAgeHint,
                maxLength: 20,
              ),
              _buildTextField(
                widget.occupationController,
                l10n.charJobLabel,
                description: l10n.characterEditOccupationDescription,
                hintText: l10n.hint_occupation,
                maxLength: 50,
              ),
              _buildTextField(
                widget.birthdayController,
                l10n.charBirthdayLabel,
                description: l10n.characterEditBirthdayDescription,
                hintText: l10n.characterEditBirthdayHint,
                maxLength: 5,
              ),
              _buildTextField(
                widget.heightController,
                l10n.charHeightLabel,
                description: l10n.characterEditHeightDescription,
                hintText: l10n.characterEditHeightHint,
                maxLength: 10,
              ),
              _buildFieldHeading(
                l10n.charGenderLabel,
                theme,
                description: l10n.characterEditGenderDescription,
                isRequired: true,
              ),
              DropdownButtonFormField<String>(
                value: widget.currentValidGender,
                hint: Text(l10n.genderNotSelected),
                decoration: _cleanInputDecoration(
                  theme,
                  hintText: l10n.genderNotSelected,
                ),
                items: widget.genderOptions.map((g) {
                  return DropdownMenuItem<String>(
                    value: g['id'],
                    child: Text(g['label']!),
                  );
                }).toList(),
                onChanged: widget.onGenderChanged,
              ),
              const SizedBox(height: 18),
              _buildBoxedTextField(
                widget.appearanceController,
                l10n.charAppearanceLabel,
                description: l10n.characterEditAppearanceDescription,
                maxLength: 500,
                hintText: l10n.hint_appearance,
              ),
            ],
          ),
          _buildCleanSection(
            theme: theme,
            title: l10n.section_story_identity,
            icon: Icons.auto_stories_outlined,
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.045),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.13),
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: l10n.advanced_writing_tips_title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: l10n.advanced_writing_tips_1),
                      TextSpan(
                        text: l10n.advanced_writing_tips_2,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: l10n.advanced_writing_tips_3),
                      TextSpan(text: l10n.advanced_writing_tips_4),
                      TextSpan(
                        text: l10n.advanced_writing_tips_5,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: l10n.advanced_writing_tips_6),
                    ],
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.55,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
              ),
              _buildFieldHeading(l10n.charInitialRelationshipLabel, theme),
              DropdownButtonFormField<String>(
                value: widget.relationshipKeys.contains(widget.selectedRelationship)
                    ? widget.selectedRelationship
                    : null,
                hint: Text(l10n.charInitialRelationshipLabel),
                decoration: _cleanInputDecoration(
                  theme,
                  hintText: l10n.charInitialRelationshipLabel,
                ),
                items: widget.relationshipKeys.map((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(widget.relationshipLabelForKey(key)),
                  );
                }).toList(),
                onChanged: widget.onRelationshipChanged,
              ),
              if (widget.selectedRelationship == 'relationship_other') ...[
                const SizedBox(height: 12),
                TextField(
                  controller: widget.customRelationshipController,
                  scrollPadding: const EdgeInsets.only(bottom: 120),
                  decoration: _cleanInputDecoration(
                    theme,
                    hintText: l10n.relationship_other,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              _buildBoxedTextField(
                widget.worldSettingController,
                l10n.characterEditWorldview,
                description: l10n.characterEditWorldviewDescription,
                maxLength: 10000,
                hintText: l10n.characterEditWorldviewHint,
                isRequired: true,
                isCollapsible: true,
                isExpanded: widget.isWorldSettingExpanded,
                onToggleExpanded: widget.onToggleWorldSettingExpanded,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.storySummaryController,
                l10n.story_summary_label,
                description: l10n.characterEditStorySummaryDescription,
                maxLength: 50,
                hintText: l10n.characterEditStorySummaryHint,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.storyController,
                l10n.story_initial_label,
                description: l10n.characterEditInitialStoryDescription,
                maxLength: 1500,
                hintText: l10n.story_initial_hint,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.firstLineController,
                l10n.first_line_label,
                description: l10n.characterEditFirstLineDescription,
                maxLength: 500,
                hintText: l10n.first_line_hint,
              ),
            ],
          ),
          _buildCleanSection(
            theme: theme,
            title: l10n.section_personality_evo,
            icon: Icons.psychology_alt_outlined,
            children: [
              Text(
                l10n.characterEditSelectedTagOrder,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                ),
              ),
              const SizedBox(height: 10),
              Builder(
                builder: (context) {
                  final selectedTags =
                  List<String>.from(widget.personalityTags);
                  final unselectedDefaultTags = widget.defaultPersonalityTags
                      .where((tag) => !widget.personalityTags.contains(tag))
                      .toList();

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...selectedTags.map(
                            (tag) => _buildDraggableSelectedTag(tag, theme),
                      ),
                      ...unselectedDefaultTags.map(
                            (tag) => _buildTagButton(tag, theme),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: widget.personalityController,
                decoration: _cleanInputDecoration(
                  theme,
                  hintText: l10n.charOtherPersonalityTagsHint,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: widget.onAddCustomPersonalityTag,
                  ),
                ),
                onFieldSubmitted: (_) => widget.onAddCustomPersonalityTag(),
              ),
              const SizedBox(height: 18),
              _buildBoxedTextField(
                widget.coreCharacterSettingController,
                l10n.characterEditCoreSetting,
                maxLength: 6000,
                hintText: l10n.characterEditCoreSettingHint,
                isRequired: true,
                isCollapsible: true,
                isExpanded: widget.isCoreCharacterSettingExpanded,
                onToggleExpanded: widget.onToggleCoreCharacterSettingExpanded,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.customOutputFormatController,
                l10n.characterEditCustomStatusBar,
                maxLength: 1500,
                hintText: l10n.characterEditCustomStatusBar,
                description: l10n.characterEditCustomStatusBarDescription,
              ),
            ],
          ),
          _buildCleanSection(
            theme: theme,
            title: l10n.section_habits,
            icon: Icons.favorite_border_rounded,
            children: [
              _buildBoxedTextField(
                widget.likesController,
                l10n.charLikesLabel,
                maxLength: 200,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.dislikesController,
                l10n.charDislikesLabel,
                maxLength: 200,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.secretsController,
                l10n.charSecretsLabel,
                maxLength: 200,
              ),
              const SizedBox(height: 16),
              _buildBoxedTextField(
                widget.dialogueExamplesController,
                l10n.charDialogueExampleLabel,
                maxLength: 500,
                hintText: l10n.dialogue_example_hint,
              ),
            ],
          ),
          _buildCleanSection(
            theme: theme,
            title: l10n.section_easter_eggs,
            icon: Icons.lock_outline_rounded,
            children: [
              if (widget.easterEggs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.55),
                    ),
                  ),
                  child: Text(
                    l10n.no_easter_eggs,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
                    ),
                  ),
                ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.easterEggs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final egg = widget.easterEggs[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.lock_outline_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        egg.keyword,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${egg.title} - ${egg.setScene ?? l10n.no_scene_change}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => widget.onRemoveEasterEgg(index),
                      ),
                      onTap: () => widget.onOpenEasterEggEditor(
                        egg: egg,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => widget.onOpenEasterEggEditor(),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.add_easter_egg_button),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.other_extra_info,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.extraInfoItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(widget.extraInfoItems[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => widget.onEditExtraInfoItem(index),
                    ),
                    onLongPress: () => widget.onRemoveExtraInfoItem(index),
                  );
                },
              ),
              TextFormField(
                controller: widget.extraInputController,
                decoration: _cleanInputDecoration(
                  theme,
                  hintText: l10n.charExtraInfoHint,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_rounded),
                    onPressed: widget.onAddExtraInfoItem,
                  ),
                ),
                onFieldSubmitted: (_) => widget.onAddExtraInfoItem(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

class CharacterEditRelationshipTab extends StatelessWidget {
  final bool isLoading;
  final List<Character> myCharacters;
  final Map<String, String> relationships;
  final VoidCallback onAddRelationship;
  final void Function(
      String targetId,
      String displayName,
      String attitude,
      ) onEditRelationship;
  final ValueChanged<String> onDeleteRelationship;

  const CharacterEditRelationshipTab({
    super.key,
    required this.isLoading,
    required this.myCharacters,
    required this.relationships,
    required this.onAddRelationship,
    required this.onEditRelationship,
    required this.onDeleteRelationship,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/character_create/character_create_social.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  l10n.section_social_circle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.social_circle_desc,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.55,
              color: muted,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: onAddRelationship,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: Text(l10n.social_add_title),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            color: theme.dividerColor.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 10),
          if (relationships.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34),
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.55,
                    child: Image.asset(
                      'assets/images/character_create/character_create_social.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.social_no_drama,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.42),
                    ),
                  ),
                ],
              ),
            ),
          ...relationships.entries.map((entry) {
            final targetId = entry.key;
            final attitude = entry.value;

            Character? targetCharacter;
            try {
              targetCharacter = myCharacters.firstWhere(
                    (character) => character.id == targetId,
              );
            } catch (_) {
              targetCharacter = null;
            }

            final displayName =
            targetCharacter?.name.trim().isNotEmpty == true
                ? targetCharacter!.name.trim()
                : l10n.characterEditUnknownCharacter;
            final occupation = targetCharacter?.occupation.trim() ?? '';
            final avatarUrl = targetCharacter?.avatarPath.trim() ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                      backgroundImage: avatarUrl.startsWith('http')
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: !avatarUrl.startsWith('http')
                          ? Icon(
                        Icons.person_outline_rounded,
                        color: theme.colorScheme.primary,
                      )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (occupation.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              occupation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: muted,
                              ),
                            ),
                          ],
                          if (attitude.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              attitude,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.45,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.72),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz_rounded),
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEditRelationship(
                            targetId,
                            displayName,
                            attitude,
                          );
                        } else if (value == 'delete') {
                          onDeleteRelationship(targetId);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit_outlined, size: 18),
                              const SizedBox(width: 10),
                              Text(l10n.social_save_changes),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(l10n.delete_character_tooltip),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

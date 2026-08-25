import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharacterNpcTab extends StatelessWidget {
  final List<Map<String, dynamic>> npcCharacters;
  final VoidCallback onAddNpc;
  final void Function(int index) onEditNpc;
  final void Function(int index) onDeleteNpc;

  const CharacterNpcTab({
    super.key,
    required this.npcCharacters,
    required this.onAddNpc,
    required this.onEditNpc,
    required this.onDeleteNpc,
  });

  static const String _npcAsset =
      'assets/images/character_create/character_create_npc.png';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final textTheme = theme.textTheme;
    final serif = GoogleFonts.notoSerifTc();

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 150),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              context: context,
              primary: primary,
              serif: serif,
            ),
            const SizedBox(height: 22),

            OutlinedButton(
              onPressed: onAddNpc,
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(
                  color: primary.withValues(alpha: 0.55),
                  width: 1,
                ),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: serif.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('＋ 新增配角'),
            ),

            const SizedBox(height: 28),

            if (npcCharacters.isEmpty)
              _buildEmptyState(
                context: context,
                primary: primary,
                serif: serif,
              )
            else ...[
              Text(
                '已加入的配角  ${npcCharacters.length}',
                style: serif.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              ...npcCharacters.asMap().entries.map((entry) {
                final index = entry.key;
                final npc = entry.value;

                final name =
                npc['name']?.toString().trim().isNotEmpty == true
                    ? npc['name'].toString().trim()
                    : '未命名配角';

                final occupation =
                    npc['occupation']?.toString().trim() ?? '';

                final relationship =
                    npc['relationship']?.toString().trim() ?? '';

                final age = npc['age']?.toString().trim() ?? '';

                return _buildNpcCard(
                  context: context,
                  index: index,
                  name: name,
                  age: age,
                  occupation: occupation,
                  relationship: relationship,
                  primary: primary,
                  serif: serif,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required Color primary,
    required TextStyle serif,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          child: Image.asset(
            _npcAsset,
            width: 38,
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '配角設定',
                style: serif.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '建立會在故事裡登場的重要人物，讓角色世界更完整。',
                style: serif.copyWith(
                  fontSize: 13,
                  height: 1.55,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required BuildContext context,
    required Color primary,
    required TextStyle serif,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 46),
      child: Column(
        children: [
          Opacity(
            opacity: 0.58,
            child: Image.asset(
              _npcAsset,
              width: 86,
              height: 86,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(height: 50),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '目前尚未新增配角',
            style: serif.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '新增後可以在這裡查看、編輯與管理配角設定。',
            textAlign: TextAlign.center,
            style: serif.copyWith(
              fontSize: 13,
              height: 1.55,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNpcCard({
    required BuildContext context,
    required int index,
    required String name,
    required String age,
    required String occupation,
    required String relationship,
    required Color primary,
    required TextStyle serif,
  }) {
    final theme = Theme.of(context);

    final meta = <String>[
      if (age.isNotEmpty) '$age歲',
      if (occupation.isNotEmpty) occupation,
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.16),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onEditNpc(index),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameAvatar(
                name: name,
                primary: primary,
                serif: serif,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: serif.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: serif.copyWith(
                          fontSize: 12.5,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.52),
                        ),
                      ),
                    ],

                    if (relationship.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '與主角色：$relationship',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: serif.copyWith(
                          fontSize: 13,
                          height: 1.45,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 4),

              PopupMenuButton<String>(
                tooltip: '更多',
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
                  size: 22,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEditNpc(index);
                  } else if (value == 'delete') {
                    onDeleteNpc(index);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(
                      '編輯',
                      style: serif.copyWith(fontSize: 14),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(
                      '刪除',
                      style: serif.copyWith(
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameAvatar({
    required String name,
    required Color primary,
    required TextStyle serif,
  }) {
    final displayChar = name.trim().isNotEmpty ? name.trim()[0] : '角';

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: primary.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        displayChar,
        style: serif.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
      ),
    );
  }
}
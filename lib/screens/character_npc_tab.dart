import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: onAddNpc,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('新增配角'),
            ),

            const SizedBox(height: 16),

            if (npcCharacters.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    '目前尚未新增配角',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

            ...npcCharacters.asMap().entries.map((entry) {
              final index = entry.key;
              final npc = entry.value;

              final name =
              npc['name']?.toString().trim().isNotEmpty == true
                  ? npc['name'].toString()
                  : '未命名配角';

              final occupation =
                  npc['occupation']?.toString().trim() ?? '';

              final relationship =
                  npc['relationship']?.toString().trim() ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(name),
                  subtitle: Text(
                    [
                      occupation,
                      relationship,
                    ].where((text) => text.isNotEmpty).join('\n'),
                  ),
                  onTap: () => onEditNpc(index),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => onDeleteNpc(index),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
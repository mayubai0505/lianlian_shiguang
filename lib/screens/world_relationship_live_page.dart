import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/app_constants.dart';

class WorldLiveRelationshipPerson {
  const WorldLiveRelationshipPerson({
    required this.id,
    required this.name,
    required this.avatar,
  });
  final String id;
  final String name;
  final String avatar;
}

/// 每位玩家只讀取自己的世界房間；不依好感度是否為 0 判斷相遇。
/// 舊聊天室若沒有 hasMetPlayer，回溯已儲存的 NPC 發言作顯示備援。
class WorldRelationshipLivePage extends StatelessWidget {
  const WorldRelationshipLivePage({
    super.key,
    required this.worldName,
    required this.sessionId,
    required this.characters,
  });

  final String worldName;
  final String sessionId;
  final List<WorldLiveRelationshipPerson> characters;

  Set<String> _encounteredNpcIds(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) {
    final ids = <String>{};
    final idByUniqueName = <String, String>{};
    final ambiguousNames = <String>{};
    for (final character in characters) {
      final name = character.name.trim();
      if (name.isEmpty) continue;
      if (idByUniqueName.containsKey(name)) ambiguousNames.add(name);
      idByUniqueName[name] = character.id;
    }
    for (final name in ambiguousNames) {
      idByUniqueName.remove(name);
    }

    for (final doc in docs) {
      final data = doc.data();
      if (data['sender'] != 'ai') continue;
      final segments = data['segments'];
      if (segments is! List) continue;
      for (final raw in segments) {
        if (raw is! Map || raw['kind'] != 'npc') continue;
        if ((raw['text'] ?? '').toString().trim().isEmpty) continue;
        final npcId = (raw['npcId'] ?? '').toString().trim();
        if (npcId.isNotEmpty && characters.any((c) => c.id == npcId)) {
          ids.add(npcId);
          continue;
        }
        // 相容舊資料：僅對「唯一同名」的正式 NPC 補認，不把路人當成正式人物。
        final name = (raw['name'] ?? '').toString().trim();
        if (idByUniqueName.containsKey(name)) ids.add(idByUniqueName[name]!);
      }
    }
    return ids;
  }

  Widget _avatar(WorldLiveRelationshipPerson person, ThemeData theme) {
    final url = person.avatar.trim();
    final fallback = CircleAvatar(
      radius: 27,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.person_outline, color: theme.colorScheme.onSurfaceVariant),
    );
    if (!url.startsWith('https://') && !url.startsWith('http://')) {
      return fallback;
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: 54,
        height: 54,
        fit: BoxFit.cover,
        memCacheWidth: 120,
        memCacheHeight: 120,
        placeholder: (_, __) => fallback,
        errorWidget: (_, __, ___) => fallback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roomRef = FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('world_chat_sessions')
        .doc(sessionId);

    return Scaffold(
      appBar: AppBar(title: const Text('人物關係')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: roomRef.collection('character_affinities').snapshots(),
        builder: (context, affinitySnapshot) {
          if (affinitySnapshot.hasError) {
            return const Center(child: Text('關係資料讀取失敗，請檢查 Firestore 權限'));
          }
          if (!affinitySnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final states = {
            for (final doc in affinitySnapshot.data!.docs) doc.id: doc.data(),
          };

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            // 用已儲存的歷史對話補認舊角色，不重新跑 AI、不額外扣花花。
            stream: roomRef.collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(500)
                .snapshots(),
            builder: (context, messageSnapshot) {
              final encountered = messageSnapshot.hasData
                  ? _encounteredNpcIds(messageSnapshot.data!.docs)
                  : <String>{};
              if (characters.isEmpty) {
                return const Center(child: Text('這個世界尚未建立人物'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: characters.length,
                itemBuilder: (context, i) {
                  final person = characters[i];
                  final data = states[person.id] ?? const <String, dynamic>{};
                  final relation = (data['currentRelationship'] ?? '').toString().trim();
                  final thought = (data['currentThought'] ?? '').toString().trim();
                  final hasMet = data['hasMetPlayer'] == true ||
                      encountered.contains(person.id) ||
                      relation.isNotEmpty || thought.isNotEmpty;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _avatar(person, theme),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(person.name, style: theme.textTheme.titleMedium),
                                const SizedBox(height: 8),
                                if (!hasMet)
                                  const Text('目前關係：尚未相遇')
                                else ...[
                                  Text('目前關係：${relation.isEmpty ? '初次相遇' : relation}'),
                                  const SizedBox(height: 9),
                                  Text('對玩家目前的想法', style: theme.textTheme.labelLarge),
                                  const SizedBox(height: 4),
                                  Text(thought.isEmpty ? '尚待後續互動逐漸形成印象' : thought),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
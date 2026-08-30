import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_constants.dart';
import 'creator_scene_edit_page.dart';
//創作者創建劇場
class CreatorScenePage extends StatefulWidget {
  final String characterId;
  final String characterName;
  final bool isPublic;

  const CreatorScenePage({
    super.key,
    required this.characterId,
    required this.characterName,
    required this.isPublic,
  });

  @override
  State<CreatorScenePage> createState() => _CreatorScenePageState();
}

class _CreatorScenePageState extends State<CreatorScenePage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>>? get _characterRef {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return null;

    if (widget.isPublic) {
      return _db
          .collection('artifacts')
          .doc(AppConfig.appId)
          .collection('public_characters')
          .doc(widget.characterId);
    }

    return _db
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('users')
        .doc(uid)
        .collection('private_characters')
        .doc(widget.characterId);
  }

  CollectionReference<Map<String, dynamic>>? get _scenesRef =>
      _characterRef?.collection('scenes');

  Future<void> _openSceneEditor({
    DocumentSnapshot<Map<String, dynamic>>? sceneDoc,
  }) async {
    final characterRef = _characterRef;
    if (characterRef == null) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatorSceneEditPage(
          characterName: widget.characterName,
          characterRef: characterRef,
          sceneDoc: sceneDoc,
        ),
      ),
    );
  }

  Future<void> _deleteScene(
      DocumentSnapshot<Map<String, dynamic>> sceneDoc,
      ) async {
    final title = (sceneDoc.data()?['title'] ?? '').toString().trim();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          '刪除劇場？',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '確定要刪除「${title.isEmpty ? '這個劇場' : title}」嗎？刪除後無法復原。',
          style: GoogleFonts.notoSerifTc(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('取消', style: GoogleFonts.notoSerifTc()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              '刪除',
              style: GoogleFonts.notoSerifTc(
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await sceneDoc.reference.delete();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('刪除失敗，請稍後再試。', style: GoogleFonts.notoSerifTc()),
          ),
        );
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 52, 32, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '還沒有創作者劇場',
              style: GoogleFonts.notoSerifTc(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: onSurface.withValues(alpha: 0.82),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '替 ${widget.characterName} 寫下不同世界線，\n讓玩家可以從另一段故事開始。',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 13,
                height: 1.7,
                color: onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: _openSceneEditor,
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(color: primary.withValues(alpha: 0.35)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
              ),
              child: Text(
                '新增劇場',
                style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneCard(
      ThemeData theme,
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? const <String, dynamic>{};
    final title = (data['title'] ?? '').toString().trim();
    final description = (data['description'] ?? '').toString().trim();
    final opening = (data['opening'] ?? '').toString().trim();

    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? '未命名劇場' : title,
            style: GoogleFonts.notoSerifTc(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: onSurface.withValues(alpha: 0.88),
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(
                fontSize: 13,
                height: 1.65,
                color: onSurface.withValues(alpha: 0.62),
              ),
            ),
          ],
          if (opening.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.055),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '角色開場：$opening',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 12,
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.58),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _openSceneEditor(sceneDoc: doc),
                child: Text(
                  '編輯',
                  style: GoogleFonts.notoSerifTc(
                    color: primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _deleteScene(doc),
                child: Text(
                  '刪除',
                  style: GoogleFonts.notoSerifTc(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scenesRef = _scenesRef;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text(
          '創作者劇場',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
      ),
      body: scenesRef == null
          ? Center(
        child: Text('目前無法讀取角色資料。', style: GoogleFonts.notoSerifTc()),
      )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: scenesRef
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '劇場讀取失敗，請稍後再試。',
                style: GoogleFonts.notoSerifTc(),
              ),
            );
          }

          final docs = snapshot.data?.docs ??
              const <QueryDocumentSnapshot<Map<String, dynamic>>>[];

          if (docs.isEmpty) return _buildEmptyState(theme);

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
            children: [
              Text(
                widget.characterName,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.48),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '為角色建立不同故事入口',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              ...docs.map((doc) => _buildSceneCard(theme, doc)),
            ],
          );
        },
      ),
      floatingActionButton: scenesRef == null
          ? null
          : FloatingActionButton.extended(
        onPressed: _openSceneEditor,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 1,
        label: Text(
          '新增劇場',
          style: GoogleFonts.notoSerifTc(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
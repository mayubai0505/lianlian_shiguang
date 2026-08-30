import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_scene_edit_page.dart';

class ScenePage extends StatefulWidget {
  final String characterId;
  final String characterName;
  final String sessionId;

  const ScenePage({
    super.key,
    required this.characterId,
    required this.characterName,
    required this.sessionId,
  });

  @override
  State<ScenePage> createState() => _ScenePageState();
}

class _ScenePageState extends State<ScenePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _creatorScenesRef {
    return _db
        .collection('artifacts')
        .doc('lianlianshiguang')
        .collection('public_characters')
        .doc(widget.characterId)
        .collection('scenes');
  }

  CollectionReference<Map<String, dynamic>> get _customScenesRef {
    return _db
        .collection('artifacts')
        .doc('lianlianshiguang')
        .collection('chat_sessions')
        .doc(widget.sessionId)
        .collection('scenes');
  }

  DocumentReference<Map<String, dynamic>> get _sessionRef {
    return _db
        .collection('artifacts')
        .doc('lianlianshiguang')
        .collection('chat_sessions')
        .doc(widget.sessionId);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openCustomEditor({
    DocumentSnapshot<Map<String, dynamic>>? sceneDoc,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CustomSceneEditPage(
          sessionId: widget.sessionId,
          characterName: widget.characterName,
          sceneDoc: sceneDoc,
        ),
      ),
    );
  }

  Future<void> _deleteCustomScene(
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
          style: GoogleFonts.notoSerifTc(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '確定要刪除「${title.isEmpty ? '這個劇場' : title}」嗎？刪除後無法復原。',
          style: GoogleFonts.notoSerifTc(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              '取消',
              style: GoogleFonts.notoSerifTc(),
            ),
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
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '刪除失敗，請稍後再試。',
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        );
    }
  }

  Future<void> _startCreatorScene(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) async {
    final data = doc.data() ?? const <String, dynamic>{};
    await _saveActiveScene(
      type: 'creator',
      sceneId: doc.id,
      title: (data['title'] ?? '').toString().trim(),
      description: (data['description'] ?? '').toString().trim(),
      opening: (data['opening'] ?? '').toString().trim(),
    );
  }

  Future<void> _startCustomScene(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) async {
    final data = doc.data() ?? const <String, dynamic>{};
    await _saveActiveScene(
      type: 'custom',
      sceneId: doc.id,
      title: (data['title'] ?? '').toString().trim(),
      description: (data['description'] ?? '').toString().trim(),
      opening: '',
    );
  }

  Future<void> _saveActiveScene({
    required String type,
    required String sceneId,
    required String title,
    required String description,
    required String opening,
  }) async {
    try {
      await _sessionRef.set(
        {
          'activeSceneType': type,
          'activeSceneId': sceneId,
          'activeSceneTitle': title,
          'activeSceneDescription': description,
          'activeSceneOpening': opening,
          'activeSceneUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;
      Navigator.pop(context, {
        'started': true,
        'type': type,
        'sceneId': sceneId,
        'title': title,
        'description': description,
        'opening': opening,
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '目前無法開始劇場，請稍後再試。',
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        );
    }
  }

  Future<void> _endActiveScene() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            '結束劇場？',
            style: GoogleFonts.notoSerifTc(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            '結束後會回到一般聊天，但目前的對話紀錄不會被刪除。',
            style: GoogleFonts.notoSerifTc(
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                '取消',
                style: GoogleFonts.notoSerifTc(),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                '結束劇場',
                style: GoogleFonts.notoSerifTc(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _sessionRef.update({
        'activeSceneType': FieldValue.delete(),
        'activeSceneId': FieldValue.delete(),
        'activeSceneTitle': FieldValue.delete(),
        'activeSceneDescription': FieldValue.delete(),
        'activeSceneOpening': FieldValue.delete(),
        'activeSceneUpdatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '劇場已結束',
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '目前無法結束劇場，請稍後再試。',
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        );
    }
  }

  Widget _buildActiveSceneBanner(ThemeData theme) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _sessionRef.snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final sceneType =
        (data?['activeSceneType'] ?? '').toString().trim();

        final sceneTitle =
        (data?['activeSceneTitle'] ?? '').toString().trim();

        if (sceneType.isEmpty) {
          return const SizedBox.shrink();
        }

        final primary = theme.colorScheme.primary;

        return Container(
          margin: const EdgeInsets.fromLTRB(18, 16, 18, 4),
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '目前正在進行',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.48),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sceneTitle.isEmpty ? '未命名劇場' : sceneTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _endActiveScene,
                child: Text(
                  '結束劇場',
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSceneCard({
    required ThemeData theme,
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required bool isCreator,
  }) {
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
        color: theme.colorScheme.surface.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: primary.withValues(alpha: 0.14),
        ),
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
              style: GoogleFonts.notoSerifTc(
                fontSize: 13,
                height: 1.65,
                color: onSurface.withValues(alpha: 0.62),
              ),
            ),
          ],
          if (isCreator && opening.isNotEmpty) ...[
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
                style: GoogleFonts.notoSerifTc(
                  fontSize: 12,
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.58),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (!isCreator) ...[
                TextButton(
                  onPressed: () => _openCustomEditor(sceneDoc: doc),
                  child: Text(
                    '編輯',
                    style: GoogleFonts.notoSerifTc(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _deleteCustomScene(doc),
                  child: Text(
                    '刪除',
                    style: GoogleFonts.notoSerifTc(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: () => isCreator
                    ? _startCreatorScene(doc)
                    : _startCustomScene(doc),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  '開始劇場',
                  style: GoogleFonts.notoSerifTc(
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

  Widget _buildCreatorTab(ThemeData theme) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _creatorScenesRef
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
              '創作者劇場讀取失敗。',
              style: GoogleFonts.notoSerifTc(),
            ),
          );
        }

        final docs = snapshot.data?.docs ??
            const <QueryDocumentSnapshot<Map<String, dynamic>>>[];

        if (docs.isEmpty) {
          return _emptyState(
            theme,
            title: '目前還沒有創作者劇場',
            body: '這個角色的創作者還沒有建立額外故事。',
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
          children: docs
              .map(
                (doc) => _buildSceneCard(
              theme: theme,
              doc: doc,
              isCreator: true,
            ),
          )
              .toList(),
        );
      },
    );
  }

  Widget _buildCustomTab(ThemeData theme) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _customScenesRef
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
              '自行創建劇場讀取失敗。',
              style: GoogleFonts.notoSerifTc(),
            ),
          );
        }

        final docs = snapshot.data?.docs ??
            const <QueryDocumentSnapshot<Map<String, dynamic>>>[];

        return Stack(
          children: [
            if (docs.isEmpty)
              _emptyState(
                theme,
                title: '還沒有自己的劇場',
                body: '為這間聊天室建立一段只屬於你的故事。',
              )
            else
              ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                children: docs
                    .map(
                      (doc) => _buildSceneCard(
                    theme: theme,
                    doc: doc,
                    isCreator: false,
                  ),
                )
                    .toList(),
              ),
            Positioned(
              right: 20,
              bottom: 22,
              child: FloatingActionButton.extended(
                heroTag: 'add_custom_scene',
                onPressed: _openCustomEditor,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 1,
                label: Text(
                  '新增劇場',
                  style: GoogleFonts.notoSerifTc(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _emptyState(
      ThemeData theme, {
        required String title,
        required String body,
      }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifTc(
                fontSize: 13,
                height: 1.7,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text(
          '劇場',
          style: GoogleFonts.notoSerifTc(
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor:
          theme.colorScheme.onSurface.withValues(alpha: 0.48),
          labelStyle: GoogleFonts.notoSerifTc(
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.notoSerifTc(),
          tabs: const [
            Tab(text: '創作者劇場'),
            Tab(text: '自行創建'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildActiveSceneBanner(theme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCreatorTab(theme),
                _buildCustomTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

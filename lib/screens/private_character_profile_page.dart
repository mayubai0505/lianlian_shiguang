import 'package:flutter/material.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import 'chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/app_constants.dart';
import '../services/toast_utils.dart';
// ⚠️ 記得 import 妳的 Character 模型檔案

class PrivateCharacterProfilePage extends StatefulWidget {
  final Character character;

  const PrivateCharacterProfilePage({
    super.key,
    required this.character,
  });

  @override
  State<PrivateCharacterProfilePage> createState() =>
      _PrivateCharacterProfilePageState();
}

class _PrivateCharacterProfilePageState
    extends State<PrivateCharacterProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Character get character => widget.character;
  DocumentReference<Map<String, dynamic>>?
  get _privateCharacterRef {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('users')
        .doc(user.uid)
        .collection('private_characters')
        .doc(character.id);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 🌟 1. 取得多國語系字典
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black54,
              ),
            ],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // 🟢 1. 用 Stack 取代原本單純的 SingleChildScrollView
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (
                context,
                innerBoxIsScrolled,
                ) {
              return [
                SliverAppBar(
                  expandedHeight: 450,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor:
                  theme.scaffoldBackgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      character.avatarPath,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PrivateProfileTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      indicatorColor:
                      theme.colorScheme.primary,
                      labelColor:
                      theme.colorScheme.primary,
                      unselectedLabelColor:
                      Colors.grey,
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          icon: const Icon(
                            Icons.person_outline,
                          ),
                          text:
                          l10n.tab_private_profile,
                        ),
                        Tab(
                          icon: const Icon(
                            Icons.mail_outline,
                          ),
                          text:
                          l10n.tab_memory_fragments,
                        ),
                      ],
                    ),
                    backgroundColor:
                    theme.scaffoldBackgroundColor,
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildPrivateProfileTab(context),
                _buildPrivateLoreTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateProfileTab(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        // 📜 底層：角色資料
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                  const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            character.name,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent
                                .withValues(alpha: 0.1),
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.pinkAccent
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            l10n.creatorExclusive,
                            style: const TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      l10n.ageAndOccupation(
                        character.age.toString(),
                        character.occupation,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent.shade200,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            l10n.likesLabel,
                            character.likes,
                            Colors.pinkAccent,
                            l10n,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildInfoCard(
                            l10n.dislikesLabel,
                            character.dislikes,
                            Colors.blueGrey,
                            l10n,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          l10n.birthdayLabel(
                            character.birthday,
                          ),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          l10n.heightLabel(
                            character.height.toString(),
                          ),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 40),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                      character.personalityTags.map(
                            (tag) {
                          return Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme
                                  .colorScheme.surfaceVariant,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: theme.colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      l10n.first_meeting_title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      character.initialStory
                          .trim()
                          .isNotEmpty
                          ? character.initialStory
                          : character.background,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔘 底部固定聊天按鈕
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              20,
              16,
              30,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor
                      .withValues(alpha: 0),
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.surfaceVariant,
                      foregroundColor:
                      theme.colorScheme.onSurfaceVariant,
                      elevation: 0,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            character: character,
                            chatMode: 'gemini',
                            selectedLanguage:
                            l10n.ai_chat_language_code,
                            forceNewRoom: true,
                            initialText:
                            character.storyModeFirstLine ??
                                l10n.default_chat_initial,
                            characterId: character.id,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.chat_free_btn),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.primary,
                      foregroundColor:
                      theme.colorScheme.onPrimary,
                      elevation: 4,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(
                            character: character,
                            chatMode: 'daily',
                            selectedLanguage:
                            l10n.ai_chat_language,
                            forceNewRoom: true,
                            characterId: character.id,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.book_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.start_story_btn),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPrivateLoreTab(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final characterRef = _privateCharacterRef;

    if (characterRef == null) {
      return const Center(
        child: Text('請先登入'),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: characterRef
          .collection('lores')
          .orderBy(
        'timestamp',
        descending: true,
      )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '記憶碎片讀取失敗：${snapshot.error}',
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        return ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            150,
          ),
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: docs.length >= 10
                    ? null
                    : () {
                  _showAddPrivateLoreDialog(
                    context,
                    theme,
                  );
                },
                icon: const Icon(
                  Icons.add_rounded,
                ),
                label: Text(
                  '撰寫新的記憶碎片（${docs.length} / 10）',
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            if (docs.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 36,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface
                      .withValues(alpha: 0.65),
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_stories_outlined,
                      size: 48,
                      color: theme.colorScheme.primary
                          .withValues(alpha: 0.42),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '還沒有記憶碎片',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '可以在這裡整理測試設定、故事線索與角色的重要記憶。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...docs.map((doc) {
                final data = doc.data();

                final title =
                (data['title'] ?? '未命名碎片')
                    .toString();

                final teaser =
                (data['teaser'] ?? '')
                    .toString();

                final content =
                (data['content'] ?? '')
                    .toString();

                final isHidden =
                    data['isHidden'] == true;

                return Card(
                  margin:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme
                          .colorScheme.onSurface
                          .withValues(alpha: 0.08),
                    ),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isHidden
                                  ? Icons.lock_outline
                                  : Icons
                                  .auto_stories_outlined,
                              size: 18,
                              color: theme
                                  .colorScheme.primary,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                title,
                                style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditPrivateLoreDialog(
                                    context,
                                    doc.id,
                                    data,
                                    theme,
                                  );
                                }

                                if (value == 'delete') {
                                  _deletePrivateLore(
                                    doc.id,
                                  );
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                      ),
                                      SizedBox(width: 8),
                                      Text('編輯'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color:
                                        Colors.redAccent,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '刪除',
                                        style: TextStyle(
                                          color:
                                          Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        if (teaser.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            teaser,
                            style: TextStyle(
                              color: theme
                                  .colorScheme.primary,
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        Text(
                          content,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: theme
                                .colorScheme.onSurface
                                .withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  void _showAddPrivateLoreDialog(
      BuildContext context,
      ThemeData theme,
      ) {
    final titleController =
    TextEditingController();

    final teaserController =
    TextEditingController();

    final contentController =
    TextEditingController();

    bool isHidden = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              title:
              const Text('新增記憶碎片'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                      titleController,
                      decoration:
                      const InputDecoration(
                        labelText: '標題',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller:
                      teaserController,
                      maxLines: 2,
                      decoration:
                      const InputDecoration(
                        labelText: '簡短提示',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller:
                      contentController,
                      maxLines: 5,
                      decoration:
                      const InputDecoration(
                        labelText: '完整內容',
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding:
                      EdgeInsets.zero,
                      title:
                      const Text('鎖定碎片'),
                      subtitle: const Text(
                        '私人角色目前只有創作者可見，此欄位仍會保留，方便角色公開後沿用。',
                      ),
                      value: isHidden,
                      onChanged: (value) {
                        setDialogState(() {
                          isHidden =
                              value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title =
                    titleController.text
                        .trim();

                    final content =
                    contentController.text
                        .trim();

                    if (title.isEmpty ||
                        content.isEmpty) {
                      ToastUtils.showCenterToast(
                        context,
                        '請填寫標題與內容',
                        isError: true,
                      );
                      return;
                    }

                    final characterRef =
                        _privateCharacterRef;

                    if (characterRef == null) {
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                    );

                    try {
                      await characterRef
                          .collection('lores')
                          .add({
                        'title': title,
                        'teaser':
                        teaserController.text
                            .trim(),
                        'content': content,
                        'isHidden': isHidden,
                        'timestamp': FieldValue
                            .serverTimestamp(),
                      });

                      if (!mounted) return;

                      ToastUtils.showCenterToast(
                        context,
                        '記憶碎片已新增',
                        customIcon: Icons
                            .library_add_check_rounded,
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ToastUtils.showCenterToast(
                        context,
                        '新增失敗，請稍後再試',
                        isError: true,
                      );
                    }
                  },
                  child: const Text('發布'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deletePrivateLore(
      String loreId,
      ) async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title:
              const Text('刪除記憶碎片'),
              content: const Text(
                '確定要永久刪除這則記憶碎片嗎？',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      false,
                    );
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      true,
                    );
                  },
                  child: const Text(
                    '刪除',
                    style: TextStyle(
                      color:
                      Colors.redAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
            false;

    if (!confirm) return;

    final characterRef =
        _privateCharacterRef;

    if (characterRef == null) return;

    try {
      await characterRef
          .collection('lores')
          .doc(loreId)
          .delete();

      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '記憶碎片已刪除',
        customIcon:
        Icons.auto_delete_outlined,
      );
    } catch (e) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '刪除失敗，請稍後再試',
        isError: true,
      );
    }
  }

  void _showEditPrivateLoreDialog(
      BuildContext context,
      String loreId,
      Map<String, dynamic> existingData,
      ThemeData theme,
      ) {
    final titleController =
    TextEditingController(
      text: existingData['title'] ?? '',
    );

    final teaserController =
    TextEditingController(
      text: existingData['teaser'] ?? '',
    );

    final contentController =
    TextEditingController(
      text: existingData['content'] ?? '',
    );

    bool isHidden =
        existingData['isHidden'] == true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              title:
              const Text('編輯記憶碎片'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                      titleController,
                      decoration:
                      const InputDecoration(
                        labelText: '標題',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller:
                      teaserController,
                      maxLines: 2,
                      decoration:
                      const InputDecoration(
                        labelText: '簡短提示',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller:
                      contentController,
                      maxLines: 5,
                      decoration:
                      const InputDecoration(
                        labelText: '完整內容',
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding:
                      EdgeInsets.zero,
                      title:
                      const Text('鎖定碎片'),
                      value: isHidden,
                      onChanged: (value) {
                        setDialogState(() {
                          isHidden =
                              value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final characterRef =
                        _privateCharacterRef;

                    if (characterRef == null) {
                      return;
                    }

                    final title =
                    titleController.text
                        .trim();

                    final content =
                    contentController.text
                        .trim();

                    if (title.isEmpty ||
                        content.isEmpty) {
                      ToastUtils.showCenterToast(
                        context,
                        '請填寫標題與內容',
                        isError: true,
                      );
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                    );

                    await characterRef
                        .collection('lores')
                        .doc(loreId)
                        .update({
                      'title': title,
                      'teaser':
                      teaserController.text
                          .trim(),
                      'content': content,
                      'isHidden': isHidden,
                      'updatedAt': FieldValue
                          .serverTimestamp(),
                    });
                  },
                  child: const Text('儲存'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 🌟 接收 l10n 以便翻譯裡面的「無」
  Widget _buildInfoCard(String title, String content, Color color, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          // 🚀 替換空值顯示的「無」
          Text(content.isEmpty ? l10n.noneLabel : content, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _PrivateProfileTabBarDelegate
    extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _PrivateProfileTabBarDelegate(
      this.tabBar, {
        required this.backgroundColor,
      });

  @override
  double get minExtent =>
      tabBar.preferredSize.height;

  @override
  double get maxExtent =>
      tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Material(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(
      covariant _PrivateProfileTabBarDelegate
      oldDelegate,
      ) {
    return oldDelegate.tabBar != tabBar ||
        oldDelegate.backgroundColor !=
            backgroundColor;
  }
}
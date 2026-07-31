//歡迎介面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'help_page.dart';

class WelcomeGuidePage extends StatefulWidget {
  const WelcomeGuidePage({super.key});

  @override
  State<WelcomeGuidePage> createState() => _WelcomeGuidePageState();
}

class _WelcomeGuidePageState extends State<WelcomeGuidePage> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _isFinishing = false;

  static const int _pageCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToNextPage() async {
    if (_currentPage < _pageCount - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _finishGuide() async {
    if (_isFinishing) return;

    setState(() {
      _isFinishing = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'welcomeGuideCompleted': true,
          'welcomeGuideCompletedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      if (!mounted) return;

      Navigator.of(
        context,
        rootNavigator: true,
      ).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainPage(
            initialIndex: 0,
          ),
        ),
            (route) => false,
      );
    } catch (e) {
      debugPrint('❌ 完成歡迎導覽失敗：$e');

      if (!mounted) return;

      // 即使旗標寫入暫時失敗，也不要把玩家困在導覽頁。
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainPage(
            initialIndex: 0,
          ),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.16),
                colorScheme.secondary.withValues(alpha: 0.10),
                colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: const [
                      _WelcomePage(),
                      _ChatModePage(),
                      _EncounterPage(),
                    ],
                  ),
                ),

                _buildPageIndicator(colorScheme),

                const SizedBox(height: 22),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    0,
                    24,
                    24,
                  ),
                  child: _currentPage == _pageCount - 1
                      ? Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: _isFinishing
                                ? null
                                : () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const HelpPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.menu_book_rounded,
                            ),
                            label: const Text(
                              '遊玩指南',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed:
                            _isFinishing ? null : _finishGuide,
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: _isFinishing
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              '開始旅程',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed:
                      _isFinishing ? null : _goToNextPage,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        '下一步',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pageCount,
            (index) {
          final bool isSelected = index == _currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isSelected ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

class _GuidePageLayout extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;

  const _GuidePageLayout({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        28,
        42,
        28,
        24,
      ),
      child: Column(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 46,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          content,
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _GuidePageLayout(
      icon: Icons.favorite_rounded,
      title: '歡迎來到《戀戀拾光》',
      content: Text(
        '在這裡，每一次相遇，\n'
            '都可能成為一段難忘的故事。\n\n'
            '希望《戀戀拾光》能陪伴你，\n'
            '創造屬於你們的美好回憶。',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.8,
        ),
      ),
    );
  }
}

class _ChatModePage extends StatelessWidget {
  const _ChatModePage();

  @override
  Widget build(BuildContext context) {
    return _GuidePageLayout(
      icon: Icons.chat_bubble_rounded,
      title: '聊天模式',
      content: const Column(
        children: [
          Text(
            '《戀戀拾光》提供多種聊天模式，\n'
                '每種模式都有不同的互動體驗。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),

          SizedBox(height: 24),

          _ModeCard(
            icon: Icons.favorite_outline_rounded,
            title: '閒聊模式',
            description: '陪伴彼此、分享生活，享受輕鬆自在的聊天時光。',
          ),

          SizedBox(height: 12),

          _ModeCard(
            icon: Icons.auto_stories_rounded,
            title: '劇情模式',
            description: '推進角色故事，解鎖更多專屬劇情與互動。',
          ),

          SizedBox(height: 12),

          _ModeCard(
            icon: Icons.theater_comedy_rounded,
            title: '沉浸模式',
            description: '體驗更投入、更有臨場感的對話。',
          ),

          SizedBox(height: 18),

          Text(
            '更多聊天模式介紹，可於「遊戲說明」查看。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EncounterPage extends StatelessWidget {
  const _EncounterPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _GuidePageLayout(
      icon: Icons.local_florist_rounded,
      title: '邂逅',
      content: Column(
        children: [
          Text(
            '每位角色都擁有獨特的個性、故事與聲音。\n\n'
                '遇見喜歡的角色後，可以加入好友，'
                '與他聊天互動、分享生活，'
                '一起創造屬於你們的回憶。',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.8,
            ),
          ),

          const SizedBox(height: 26),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  '更多內容',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '還有收藏、創作者、商城等豐富功能，'
                      '歡迎前往「遊戲說明」了解更多。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//歡迎介面

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_page.dart';
import 'help_page.dart';
import 'preference_selection_page.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


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
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PreferenceSelectionPage(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFinishing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          color: colorScheme.surface,
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
                          child: OutlinedButton(
                            onPressed: _isFinishing
                                ? null
                                : () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const HelpPage(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              l10n.welcome_guide_help,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
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
                                : Text(
                              l10n.welcome_guide_start,
                              style: GoogleFonts.notoSerifTc(
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
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        l10n.welcome_guide_next,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 15,
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
            width: isSelected ? 20 : 7,
            height: 7,
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
  final Widget illustration;
  final String title;
  final Widget content;

  const _GuidePageLayout({
    required this.illustration,
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
        36,
        28,
        24,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 118,
            height: 118,
            child: Center(child: illustration),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              color: colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 20),
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
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return _GuidePageLayout(
      illustration: Image.asset(
        'assets/images/brand/lianlian_butterfly_logo.png',
        width: 92,
        height: 92,
        fit: BoxFit.contain,
      ),
      title: l10n.welcome_guide_welcome_title,
      content: Text(
        l10n.welcome_guide_welcome_description,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSerifTc(
          color: colorScheme.onSurface.withValues(alpha: 0.70),
          fontSize: 15,
          height: 1.9,
        ),
      ),
    );
  }
}

class _ChatModePage extends StatelessWidget {
  const _ChatModePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return _GuidePageLayout(
      illustration: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.chat_bubble_outline_rounded,
          size: 42,
          color: colorScheme.primary,
        ),
      ),
      title: l10n.welcome_guide_chat_title,
      content: Column(
        children: [
          Text(
            l10n.welcome_guide_chat_description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              color: colorScheme.onSurface.withValues(alpha: 0.68),
              fontSize: 14.5,
              height: 1.75,
            ),
          ),
          const SizedBox(height: 22),
           _ModeCard(
            iconAsset: 'assets/images/chat/chat_mode_daily_mask.png',
            title: l10n.welcome_guide_daily_title,
            description: l10n.welcome_guide_daily_description,
          ),
          const SizedBox(height: 12),
          _ModeCard(
            iconAsset: 'assets/images/chat/chat_mode_story_mask.png',
            title: l10n.welcome_guide_story_title,
            description: l10n.welcome_guide_story_description,
          ),
          const SizedBox(height: 12),
          _ModeCard(
            iconAsset: 'assets/images/chat/chat_mode_immersive_mask.png',
            title: l10n.welcome_guide_immersive_title,
            description:l10n.welcome_guide_immersive_description,
          ),
          const SizedBox(height: 18),
          Text(
            l10n.welcome_guide_chat_more,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              color: colorScheme.onSurface.withValues(alpha: 0.42),
              fontSize: 12.5,
              height: 1.6,
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
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return _GuidePageLayout(
      illustration: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.local_florist_outlined,
          size: 42,
          color: colorScheme.primary,
        ),
      ),
      title: l10n.welcome_guide_encounter_title,
      content: Column(
        children: [
          Text(
            l10n.welcome_guide_encounter_description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              color: colorScheme.onSurface.withValues(alpha: 0.68),
              fontSize: 14.5,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              children: [
                Text(
                  l10n.welcome_guide_more_title,
                  style: GoogleFonts.notoSerifTc(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.welcome_guide_more_description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerifTc(
                    color: colorScheme.onSurface.withValues(alpha: 0.58),
                    fontSize: 13,
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
  final String iconAsset;
  final String title;
  final String description;

  const _ModeCard({
    required this.iconAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                iconAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSerifTc(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: GoogleFonts.notoSerifTc(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                    fontSize: 13,
                    height: 1.65,
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
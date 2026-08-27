import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_page.dart';

class PreferenceSelectionPage extends StatefulWidget {
  const PreferenceSelectionPage({super.key});

  @override
  State<PreferenceSelectionPage> createState() =>
      _PreferenceSelectionPageState();
}

class _PreferenceSelectionPageState
    extends State<PreferenceSelectionPage> {
  static const int _minSelection = 3;
  static const int _maxSelection = 5;

  static const List<_PreferenceGroup> _groups = [
    _PreferenceGroup(
      title: '性格氣質',
      tags: [
        '溫柔',
        '高冷',
        '腹黑',
        '傲嬌',
        '忠犬',
        '病嬌',
        '神秘',
        '治癒',
        '反差感',
      ],
    ),
    _PreferenceGroup(
      title: '關係・年齡感',
      tags: [
        '年上',
        '年下',
      ],
    ),
    _PreferenceGroup(
      title: '故事氛圍',
      tags: [
        '霸總',
        '校園',
        '職場',
        '古風',
        '非人',
      ],
    ),
  ];

  final Set<String> _selected = <String>{};
  bool _isSaving = false;

  bool get _canContinue =>
      _selected.length >= _minSelection &&
          _selected.length <= _maxSelection;

  void _toggleTag(String tag) {
    if (_isSaving) return;

    if (_selected.contains(tag)) {
      setState(() => _selected.remove(tag));
      return;
    }

    if (_selected.length >= _maxSelection) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              '最多選擇 $_maxSelection 個偏好。',
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        );
      return;
    }

    setState(() => _selected.add(tag));
  }

  Future<void> _savePreferences() async {
    if (!_canContinue || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'preferredCharacterTags': _selected.toList(),
          'preferenceOnboardingCompleted': true,
          'preferenceOnboardingCompletedAt':
          FieldValue.serverTimestamp(),
          'welcomeGuideCompleted': true,
          'welcomeGuideCompletedAt':
          FieldValue.serverTimestamp(),
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
    } catch (e, stackTrace) {
      debugPrint('❌ 儲存偏好失敗：$e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              '目前無法儲存偏好，請稍後再試。',
              style: GoogleFonts.notoSerifTc(),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final onSurface = colors.onSurface;

    return PopScope(
      canPop: !_isSaving,
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    28,
                    24,
                    120,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 620,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/images/brand/lianlian_butterfly_logo.png',
                              width: 44,
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '你想遇見怎樣的人？',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                              letterSpacing: 0.5,
                              color: onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '選擇 3～5 個你喜歡的類型，'
                                '戀戀會先從這裡開始認識你。',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 14,
                              height: 1.8,
                              color: onSurface.withValues(
                                alpha: 0.56,
                              ),
                            ),
                          ),
                          const SizedBox(height: 34),

                          for (final group in _groups) ...[
                            _buildGroup(
                              context,
                              group,
                            ),
                            if (group != _groups.last)
                              const SizedBox(height: 30),
                          ],

                          const SizedBox(height: 34),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(
                                alpha: 0.045,
                              ),
                              borderRadius:
                              BorderRadius.circular(18),
                              border: Border.all(
                                color: colors.primary.withValues(
                                  alpha: 0.10,
                                ),
                              ),
                            ),
                            child: Text(
                              '之後也會依照你的實際互動，'
                                  '慢慢調整更適合你的推薦。',
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 12.5,
                                height: 1.7,
                                color: onSurface.withValues(
                                  alpha: 0.52,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 固定底部操作區
              Container(
                padding: EdgeInsets.fromLTRB(
                  24,
                  12,
                  24,
                  18 + MediaQuery.paddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.98),
                  border: Border(
                    top: BorderSide(
                      color: colors.outline.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.035,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 620,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 92,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                '已選',
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 11.5,
                                  color: onSurface.withValues(
                                    alpha: 0.44,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_selected.length} / $_maxSelection',
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: _canContinue
                                      ? colors.primary
                                      : onSurface.withValues(
                                    alpha: 0.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed:
                              _canContinue && !_isSaving
                                  ? _savePreferences
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                disabledBackgroundColor:
                                colors.primary.withValues(
                                  alpha: 0.13,
                                ),
                                disabledForegroundColor:
                                onSurface.withValues(
                                  alpha: 0.34,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(22),
                                ),
                              ),
                              child: _isSaving
                                  ? SizedBox(
                                width: 21,
                                height: 21,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: colors.onPrimary,
                                ),
                              )
                                  : Text(
                                '就從這裡開始',
                                style:
                                GoogleFonts.notoSerifTc(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w700,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(
      BuildContext context,
      _PreferenceGroup group,
      ) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.title,
          style: GoogleFonts.notoSerifTc(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
            color: onSurface.withValues(alpha: 0.50),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 11,
          children: group.tags.map((tag) {
            final selected = _selected.contains(tag);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => _toggleTag(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 170),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.primary.withValues(alpha: 0.075)
                        : colors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: selected
                          ? colors.primary.withValues(alpha: 0.72)
                          : colors.outline.withValues(alpha: 0.18),
                      width: selected ? 1.25 : 1,
                    ),
                    boxShadow: selected
                        ? [
                      BoxShadow(
                        color: colors.primary.withValues(
                          alpha: 0.045,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                        : null,
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 14,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selected
                          ? colors.primary
                          : onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PreferenceGroup {
  final String title;
  final List<String> tags;

  const _PreferenceGroup({
    required this.title,
    required this.tags,
  });
}
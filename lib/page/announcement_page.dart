import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

const _bottomBotanical =
    'assets/images/announcement/announcement_botanical_left.png';
const _envelopeBack =
    'assets/images/announcement/announcement_envelope_back.png';
const _letter = 'assets/images/announcement/announcement_letter.png';
const _envelopeBotanical =
    'assets/images/announcement/announcement_botanical.png';
const _envelopeFront =
    'assets/images/announcement/announcement_envelope_front.png';
const _envelopeStars =
    'assets/images/announcement/announcement_stars.png';

Color _themeInk(ThemeData theme, [double blackMix = .30]) {
  return Color.lerp(theme.colorScheme.primary, Colors.black, blackMix)!;
}

class AnnouncementListPage extends StatelessWidget {
  const AnnouncementListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const Positioned.fill(child: _Background()),
        const _BottomBotanical(),
        SafeArea(
          child: Column(children: [
            _Header(title: l10n.system_announcement),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint('公告頁載入失敗：${snapshot.error}');
                    return const _Message('連線失敗，請稍後再試');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }
                  final docs = snapshot.data?.docs ?? const [];
                  if (docs.isEmpty) return _Message(l10n.empty_announcement);

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 120),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final date = (data['createdAt'] as Timestamp?)?.toDate() ??
                          DateTime.now();
                      final rawTitle = (data['title'] as String?)?.trim() ?? '';
                      final title = rawTitle.isEmpty ? l10n.untitled : rawTitle;
                      final content = (data['content'] as String?)?.trim() ?? '';
                      return _AnnouncementCard(
                        title: title,
                        content: content,
                        date: date,
                        isLatest: index == 0,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AnnouncementDetailPage(
                              title: title,
                              content:
                              content.isEmpty ? l10n.no_content : content,
                              date: date,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class AnnouncementDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;

  const AnnouncementDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const Positioned.fill(child: _Background()),
        const _BottomBotanical(),
        SafeArea(
          child: Column(children: [
            _Header(title: l10n.system_announcement),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
                child: _DetailPaper(title: title, content: content, date: date),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return SizedBox(
      height: 112,
      child: Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 8,
          top: 18,
          child: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 31,
              color: _themeInk(theme, .35).withValues(alpha: .82),
            ),
          ),
        ),
        Positioned(
          top: 23,
          child: Column(children: [
            Text(
              title,
              style: GoogleFonts.notoSerifTc(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: _themeInk(theme, .28),
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              _Line(color: primary),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Icon(Icons.auto_awesome, size: 10, color: primary),
              ),
              _Line(color: primary),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _Line extends StatelessWidget {
  final Color color;
  const _Line({required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: 58,
    height: 1,
    color: color.withValues(alpha: .30),
  );
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final bool isLatest;
  final VoidCallback onTap;

  const _AnnouncementCard({
    required this.title,
    required this.content,
    required this.date,
    required this.isLatest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final titleColor = _themeInk(theme, .30);
    final secondaryColor = _themeInk(theme, .48);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(17, 18, 13, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: primary.withValues(alpha: .10)),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: .10),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(children: [
            SizedBox(
              width: 68,
              height: 68,
              child: _ThemedEnvelope(color: primary),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLatest) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '最新',
                        style: GoogleFonts.notoSerifTc(
                          color: primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      color: titleColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(children: [
                    Expanded(
                      child: Text(
                        content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          color: secondaryColor.withValues(alpha: .64),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MM/dd').format(date),
                      style: GoogleFonts.notoSerifTc(
                        color: secondaryColor.withValues(alpha: .60),
                        fontSize: 12.5,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 24,
                      color: primary.withValues(alpha: .58),
                    ),
                  ]),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _DetailPaper extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  const _DetailPaper({
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final titleColor = _themeInk(theme, .28);
    final bodyColor = _themeInk(theme, .40);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 520),
      padding: const EdgeInsets.fromLTRB(24, 29, 24, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: .10)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: .11),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: GoogleFonts.notoSerifTc(
            color: titleColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            height: 1.35,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          '發布時間：${DateFormat('yyyy/MM/dd HH:mm').format(date)}',
          style: GoogleFonts.notoSerifTc(
            color: bodyColor.withValues(alpha: .62),
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: 23),
        Row(children: [
          Expanded(child: _PaperLine(color: primary)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.auto_awesome,
              size: 13,
              color: primary.withValues(alpha: .58),
            ),
          ),
          Expanded(child: _PaperLine(color: primary)),
        ]),
        const SizedBox(height: 27),
        Text(
          content,
          style: GoogleFonts.notoSerifTc(
            color: bodyColor.withValues(alpha: .92),
            fontSize: 15.5,
            height: 2.05,
            letterSpacing: .45,
          ),
        ),
        const SizedBox(height: 42),
        Align(
          alignment: Alignment.center,
          child: Column(children: [
            Icon(
              Icons.eco_outlined,
              size: 22,
              color: primary.withValues(alpha: .48),
            ),
            const SizedBox(height: 7),
            Text(
              '戀戀拾光營運團隊',
              style: GoogleFonts.notoSerifTc(
                color: primary.withValues(alpha: .68),
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _PaperLine extends StatelessWidget {
  final Color color;
  const _PaperLine({required this.color});
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    color: color.withValues(alpha: .28),
  );
}

class _Background extends StatelessWidget {
  const _Background();
  @override
  Widget build(BuildContext context) => const ColoredBox(color: Colors.white);
}

class _BottomBotanical extends StatelessWidget {
  const _BottomBotanical();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 以畫面寬度計算尺寸與位移，避免不同長寬比的手機跑位。
            final botanicalWidth =
            (constraints.maxWidth * .46).clamp(148.0, 218.0);
            final leftOffset = -botanicalWidth * .20;
            final bottomOffset = -botanicalWidth * .10;

            return Stack(
              children: [
                Positioned(
                  left: leftOffset,
                  bottom: bottomOffset,
                  width: botanicalWidth,
                  child: Opacity(
                    opacity: .13,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        _bottomBotanical,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                        const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ThemedEnvelope extends StatelessWidget {
  final Color color;

  const _ThemedEnvelope({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _TintedAsset(asset: _envelopeBack, color: color, opacity: .72),
        Image.asset(
          _letter,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        _TintedAsset(
          asset: _envelopeBotanical,
          color: color,
          opacity: .76,
        ),
        _TintedAsset(asset: _envelopeFront, color: color, opacity: .72),
        // 星星獨立放在最上層，不會再被信紙或信封前景遮住。
        _TintedAsset(asset: _envelopeStars, color: color, opacity: .82),
      ],
    );
  }
}

class _TintedAsset extends StatelessWidget {
  final String asset;
  final Color color;
  final double opacity;

  const _TintedAsset({
    required this.asset,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String message;
  const _Message(this.message);
  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      message,
      style: GoogleFonts.notoSerifTc(
        color: _themeInk(Theme.of(context), .46).withValues(alpha: .58),
        fontSize: 14,
      ),
    ),
  );
}

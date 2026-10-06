import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/toast_utils.dart';
import '../services/app_constants.dart';
import 'event_memory_page.dart';
import 'package:lianlian_shiguang/l10n/app_l10n.dart';

const Color _eventDefaultTextPrimary = Color(0xFF3B3340);
const Color _eventDefaultTextSecondary = Color(0xFF6F6673);
const Color _eventDefaultTextMuted = Color(0xFF948A98);


/// Reusable event page v4
///
/// Event-specific visuals are driven by Firestore config instead of hardcoded
/// Halloween/Christmas copy. Existing events keep working because every new
/// field has a fallback.
class EventPage extends StatelessWidget {
  final String eventId;

  const EventPage({
    super.key,
    required this.eventId,
  });

  DocumentReference<Map<String, dynamic>> _eventRef() {
    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('events')
        .doc(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _eventRef().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primary,
                strokeWidth: 2.2,
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return _EventUnavailablePage(
              message: snapshot.hasError ? appL10n.event_message_failed_load : appL10n.event_message_not_found,
            );
          }

          return _EventContent(
            eventId: eventId,
            data: snapshot.data!.data() ?? <String, dynamic>{},
          );
        },
      ),
    );
  }
}

class _EventVisualStyle {
  final Color accent;
  final Color accent2;
  final Color pageBackground;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;
  final String pageBackgroundImageUrl;
  final String memoryFeatureImageUrl;
  final String shopFeatureImageUrl;
  final String tasksHeaderIconUrl;
  final String milestonesHeaderIconUrl;
  final String infoHeaderIconUrl;
  final String pageTopLeftUrl;
  final String pageTopRightUrl;
  final String progressDecorationUrl;
  final String infoDecorationUrl;
  final String pageBottomLeftUrl;
  final String pageBottomRightUrl;

  const _EventVisualStyle({
    required this.accent,
    required this.accent2,
    required this.pageBackground,
    required this.cardColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.textMutedColor,
    required this.pageBackgroundImageUrl,
    required this.memoryFeatureImageUrl,
    required this.shopFeatureImageUrl,
    required this.tasksHeaderIconUrl,
    required this.milestonesHeaderIconUrl,
    required this.infoHeaderIconUrl,
    required this.pageTopLeftUrl,
    required this.pageTopRightUrl,
    required this.progressDecorationUrl,
    required this.infoDecorationUrl,
    required this.pageBottomLeftUrl,
    required this.pageBottomRightUrl,
  });

  static Map<String, dynamic> _asMap(dynamic raw) {
    return raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
  }

  static Color? _hex(dynamic raw) {
    final text = (raw ?? '').toString().trim().replaceAll('#', '');
    if (text.length != 6 && text.length != 8) return null;
    try {
      final value = int.parse(text, radix: 16);
      return Color(text.length == 6 ? 0xFF000000 | value : value);
    } catch (_) {
      return null;
    }
  }

  factory _EventVisualStyle.fromData(
      BuildContext context,
      Map<String, dynamic> data,
      ) {
    final colors = Theme.of(context).colorScheme;
    final theme = _asMap(data['theme']);
    final decorations = _asMap(data['decorations']);

    String value(String key, [String fallback = '']) {
      final themed = theme[key]?.toString().trim() ?? '';
      if (themed.isNotEmpty) return themed;
      final top = data[key]?.toString().trim() ?? '';
      return top.isNotEmpty ? top : fallback;
    }

    String decorationValue(String key, [String fallback = '']) {
      final decorated = decorations[key]?.toString().trim() ?? '';
      if (decorated.isNotEmpty) return decorated;
      return fallback;
    }

    final accent = _hex(theme['accentColor'] ?? data['accentColor']) ??
        colors.primary;
    final accent2 = _hex(theme['accentColor2'] ?? data['accentColor2']) ??
        Color.lerp(accent, Colors.white, 0.56)!;
    final pageBackground =
        _hex(theme['pageBackgroundColor'] ?? theme['backgroundColor'] ?? data['pageBackgroundColor']) ??
            Color.lerp(colors.surface, accent, 0.035)!;
    final cardColor =
        _hex(theme['cardColor'] ?? data['cardColor']) ?? colors.surface;
    final textPrimaryColor =
        _hex(theme['textPrimaryColor'] ?? data['textPrimaryColor']) ??
            _eventDefaultTextPrimary;
    final textSecondaryColor =
        _hex(theme['textSecondaryColor'] ?? data['textSecondaryColor']) ??
            _eventDefaultTextSecondary;
    final textMutedColor =
        _hex(theme['textMutedColor'] ?? data['textMutedColor']) ??
            _eventDefaultTextMuted;

    return _EventVisualStyle(
      accent: accent,
      accent2: accent2,
      pageBackground: pageBackground,
      cardColor: cardColor,
      textPrimaryColor: textPrimaryColor,
      textSecondaryColor: textSecondaryColor,
      textMutedColor: textMutedColor,
      pageBackgroundImageUrl: value('pageBackgroundImageUrl'),
      memoryFeatureImageUrl: decorationValue(
        'memoryCardImageUrl',
        value('memoryFeatureImageUrl'),
      ),
      shopFeatureImageUrl: decorationValue(
        'shopCardImageUrl',
        value('shopFeatureImageUrl'),
      ),
      tasksHeaderIconUrl: decorationValue('tasksHeaderIconUrl'),
      milestonesHeaderIconUrl: decorationValue('milestonesHeaderIconUrl'),
      infoHeaderIconUrl: decorationValue('infoHeaderIconUrl'),
      pageTopLeftUrl: decorationValue('pageTopLeftUrl'),
      pageTopRightUrl: decorationValue('pageTopRightUrl'),
      progressDecorationUrl: decorationValue('progressDecorationUrl'),
      infoDecorationUrl: decorationValue('infoDecorationUrl'),
      pageBottomLeftUrl: decorationValue('pageBottomLeftUrl'),
      pageBottomRightUrl: decorationValue('pageBottomRightUrl'),
    );
  }
}

class _EventContent extends StatelessWidget {
  final String eventId;
  final Map<String, dynamic> data;

  const _EventContent({
    required this.eventId,
    required this.data,
  });

  CollectionReference<Map<String, dynamic>> _subcollection(String name) {
    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('events')
        .doc(eventId)
        .collection(name);
  }

  DocumentReference<Map<String, dynamic>>? _progressRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('event_progress')
        .doc(user.uid)
        .collection('events')
        .doc(eventId);
  }

  DateTime? _date(dynamic value) => value is Timestamp ? value.toDate() : null;

  String _remaining(DateTime? end) {
    if (end == null) return appL10n.event_remaining_label;
    final d = end.difference(DateTime.now());
    if (d.isNegative) return '活動已結束';
    if (d.inDays >= 1) return appL10n.event_remaining_label_days(d.inDays + 1);
    if (d.inHours >= 1) return appL10n.event_remaining_label_hours(d.inHours);
    return appL10n.event_remaining_label_end;
  }

  String _dateText(DateTime? start, DateTime? end) {
    String f(DateTime d) =>
        '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
    if (start == null && end == null) return '';
    if (start == null) return '~\n${f(end!)}';
    if (end == null) return '${f(start)}\n~';
    return '${f(start)}\n~\n${f(end)}';
  }

  Map<String, dynamic> _uiText() {
    final raw = data['uiText'];
    return raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
  }

  String _text(String key, String fallback) {
    final ui = _uiText();
    final fromUi = ui[key]?.toString().trim() ?? '';
    if (fromUi.isNotEmpty) return fromUi;
    final fromTop = data[key]?.toString().trim() ?? '';
    return fromTop.isNotEmpty ? fromTop : fallback;
  }

  @override
  Widget build(BuildContext context) {
    final style = _EventVisualStyle.fromData(context, data);

    final name = (data['name'] ?? '期間限定活動').toString();
    final subtitle =
    (data['subtitle'] ?? '和他一起留下這個季節的特別回憶。').toString();
    final heroImageUrl =
    (data['heroImageUrl'] ?? data['bannerImageUrl'] ?? '').toString();
    final currencyName = (data['currencyName'] ?? '活動貨幣').toString();
    final currencyIcon = (data['currencyIcon'] ?? '✦').toString();
    final startAt = _date(data['startAt']);
    final endAt = _date(data['endAt']);

    final hasTasks = data['hasTasks'] != false;
    final hasMilestones = data['hasMilestones'] != false;
    final hasShop = data['hasShop'] != false;
    final hasMemory = data['hasMemory'] != false;

    final progressRef = _progressRef();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.pageBackground,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(style.pageBackground, style.accent2, 0.15)!,
            style.pageBackground,
            Color.lerp(style.pageBackground, Colors.white, 0.30)!,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (style.pageBackgroundImageUrl.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.12,
                  child: CachedNetworkImage(
                    imageUrl: style.pageBackgroundImageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          if (style.pageTopLeftUrl.isNotEmpty)
            Positioned(
              left: -18,
              top: 72,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.72,
                  child: _DecorationImage(
                    imageUrl: style.pageTopLeftUrl,
                    width: 112,
                  ),
                ),
              ),
            ),
          if (style.pageTopRightUrl.isNotEmpty)
            Positioned(
              right: -18,
              top: 86,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.72,
                  child: _DecorationImage(
                    imageUrl: style.pageTopRightUrl,
                    width: 112,
                  ),
                ),
              ),
            ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _EventHeroCard(
                  eventId: eventId,
                  progressRef: progressRef,
                  name: name,
                  subtitle: subtitle,
                  heroImageUrl: heroImageUrl,
                  remainingLabel: _remaining(endAt),
                  dateLabel: _dateText(startAt, endAt),
                  currencyIcon: currencyIcon,
                  currencyName: currencyName,
                  hasShop: hasShop,
                  shopHeroImageUrl:
                  (data['shopHeroImageUrl'] ?? '').toString(),
                  style: style,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (hasTasks) ...[
                      const SizedBox(height: 14),
                      _RichSectionShell(
                        style: style,
                        title: _text('tasksTitle', '今日任務'),
                        subtitle: _text(
                          'tasksSubtitle',
                          '完成任務，收集$currencyName，解鎖更多限定內容。',
                        ),
                        child: _TaskList(
                          eventId: eventId,
                          ref: _subcollection('tasks'),
                          currencyIcon: currencyIcon,
                          currencyName: currencyName,
                          accent: style.accent,
                          cardColor: style.cardColor,
                          textPrimaryColor: style.textPrimaryColor,
                          textSecondaryColor: style.textSecondaryColor,
                        ),
                      ),
                    ],
                    if (hasMilestones) ...[
                      const SizedBox(height: 14),
                      _RichSectionShell(
                        style: style,
                        title: _text('milestonesTitle', '累積進度'),
                        subtitle: _text(
                          'milestonesSubtitle',
                          '累積$currencyName，領取活動限定獎勵。',
                        ),
                        trailingDecorationUrl: style.progressDecorationUrl,
                        child: _MilestoneProgress(
                          ref: _subcollection('milestones'),
                          progressRef: progressRef,
                          currencyIcon: currencyIcon,
                          accent: style.accent,
                          textMutedColor: style.textMutedColor,
                        ),
                      ),
                    ],
                    if (hasMemory || hasShop) ...[
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasMemory)
                            Expanded(
                              child: _RichFeatureEntryCard(
                                accent: style.accent,
                                textPrimaryColor: style.textPrimaryColor,
                                textSecondaryColor: style.textSecondaryColor,
                                imageUrl: style.memoryFeatureImageUrl,
                                title: _text('memoryTitle', '限定回憶'),
                                subtitle: _text(
                                  'memorySubtitle',
                                  '留下這次活動的專屬回憶。',
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EventMemoryPage(
                                        eventId: eventId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (hasMemory && hasShop) const SizedBox(width: 10),
                          if (hasShop)
                            Expanded(
                              child: _RichFeatureEntryCard(
                                accent: style.accent,
                                textPrimaryColor: style.textPrimaryColor,
                                textSecondaryColor: style.textSecondaryColor,
                                imageUrl: style.shopFeatureImageUrl,
                                title: _text('shopTitle', '活動商店'),
                                subtitle: _text(
                                  'shopSubtitle',
                                  '使用$currencyName兌換限定獎勵。',
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EventShopPage(
                                        eventId: eventId,
                                        currencyName: currencyName,
                                        currencyIcon: currencyIcon,
                                        shopHeroImageUrl:
                                        (data['shopHeroImageUrl'] ?? '').toString(),
                                        textPrimaryColor: style.textPrimaryColor,
                                        textSecondaryColor: style.textSecondaryColor,
                                        textMutedColor: style.textMutedColor,
                                        accentColor: style.accent,
                                        pageBackgroundColor: style.pageBackground,
                                        cardColor: style.cardColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    _RichEventInfoCard(
                      title: _text('infoTitle', '活動說明'),
                      description: (data['description'] ??
                          '活動期間完成指定任務即可取得活動貨幣。\n兌換的獎勵會依活動規則發放至帳號。\n活動結束後，未使用的活動貨幣將依活動規則處理。')
                          .toString(),
                      accent: style.accent,
                      cardColor: style.cardColor,
                      textPrimaryColor: style.textPrimaryColor,
                      textSecondaryColor: style.textSecondaryColor,
                      decorationImageUrl: style.infoDecorationUrl,
                    ),
                    if (style.pageBottomLeftUrl.isNotEmpty ||
                        style.pageBottomRightUrl.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 76,
                        child: Stack(
                          children: [
                            if (style.pageBottomLeftUrl.isNotEmpty)
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: _DecorationImage(
                                  imageUrl: style.pageBottomLeftUrl,
                                  width: 92,
                                ),
                              ),
                            if (style.pageBottomRightUrl.isNotEmpty)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: _DecorationImage(
                                  imageUrl: style.pageBottomRightUrl,
                                  width: 92,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventHeroCard extends StatelessWidget {
  final String eventId;
  final DocumentReference<Map<String, dynamic>>? progressRef;
  final String name;
  final String subtitle;
  final String heroImageUrl;
  final String remainingLabel;
  final String dateLabel;
  final String currencyIcon;
  final String currencyName;
  final bool hasShop;
  final String shopHeroImageUrl;
  final _EventVisualStyle style;

  const _EventHeroCard({
    required this.eventId,
    required this.progressRef,
    required this.name,
    required this.subtitle,
    required this.heroImageUrl,
    required this.remainingLabel,
    required this.dateLabel,
    required this.currencyIcon,
    required this.currencyName,
    required this.hasShop,
    required this.shopHeroImageUrl,
    required this.style,
  });

  int _intValue(dynamic raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = style.textPrimaryColor;
    final hasImage = heroImageUrl.trim().isNotEmpty;

    Widget balancePill(int amount) {
      final content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currencyIcon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 7),
            Text(
              '$currencyName  $amount',
              style: GoogleFonts.notoSerifTc(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: onSurface,
              ),
            ),
            if (hasShop) ...[
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: onSurface.withValues(alpha: 0.72),
              ),
            ],
          ],
        ),
      );

      if (!hasShop) return content;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EventShopPage(
                  eventId: eventId,
                  currencyName: currencyName,
                  currencyIcon: currencyIcon,
                  shopHeroImageUrl: shopHeroImageUrl,
                  textPrimaryColor: style.textPrimaryColor,
                  textSecondaryColor: style.textSecondaryColor,
                  textMutedColor: style.textMutedColor,
                  accentColor: style.accent,
                  pageBackgroundColor: style.pageBackground,
                  cardColor: style.cardColor,
                ),
              ),
            );
          },
          child: content,
        ),
      );
    }

    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            CachedNetworkImage(
              imageUrl: heroImageUrl.trim(),
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: style.accent.withValues(alpha: 0.05),
              ),
              errorWidget: (_, __, ___) => Container(
                color: style.accent.withValues(alpha: 0.05),
              ),
            )
          else
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    style.accent2.withValues(alpha: 0.22),
                    style.cardColor,
                  ],
                ),
              ),
            ),
          if (hasImage)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x0A000000),
                    Color(0x2E000000),
                    Color(0xA3000000),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 14,
            top: MediaQuery.of(context).padding.top + 10,
            child: Material(
              color: Colors.black.withValues(alpha: 0.36),
              shape: const CircleBorder(),
              child: SizedBox(
                width: 38,
                height: 38,
                child: IconButton(
                  tooltip: appL10n.event_balance_pill_tooltip_back,
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18, MediaQuery.of(context).padding.top + 58, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    _HeroChip(
                      label: remainingLabel,
                      accent: style.accent,
                      textColor: style.textPrimaryColor,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  name,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 29,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: hasImage ? Colors.white : onSurface,
                    shadows: hasImage
                        ? [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 8,
                      ),
                    ]
                        : null,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 12.5,
                    height: 1.6,
                    color: hasImage
                        ? Colors.white.withValues(alpha: 0.92)
                        : style.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (progressRef != null)
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: progressRef!.snapshots(),
                        builder: (context, snapshot) {
                          final amount = _intValue(
                            snapshot.data?.data()?['currency'],
                          );
                          return balancePill(amount);
                        },
                      )
                    else
                      balancePill(0),
                    const Spacer(),
                    if (dateLabel.isNotEmpty)
                      Text(
                        dateLabel,
                        textAlign: TextAlign.right,
                        maxLines: 3,
                        softWrap: false,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 10.5,
                          height: 1.28,
                          color: hasImage
                              ? Colors.white.withValues(alpha: 0.82)
                              : style.textMutedColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;
  final Color accent;
  final Color textColor;

  const _HeroChip({
    required this.label,
    required this.accent,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.notoSerifTc(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorationImage extends StatelessWidget {
  final String imageUrl;
  final double width;

  const _DecorationImage({
    required this.imageUrl,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) return const SizedBox.shrink();
    return CachedNetworkImage(
      imageUrl: imageUrl.trim(),
      width: width,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 120),
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
    );
  }
}

class _RichSectionShell extends StatelessWidget {
  final _EventVisualStyle style;
  final String title;
  final String subtitle;
  final String trailingDecorationUrl;
  final Widget child;

  const _RichSectionShell({
    required this.style,
    required this.title,
    required this.subtitle,
    this.trailingDecorationUrl = '',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = style.textPrimaryColor;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: style.cardColor.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: style.accent.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: style.accent.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (trailingDecorationUrl.trim().isNotEmpty)
            Positioned(
              right: -8,
              top: 2,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.38,
                  child: _DecorationImage(
                    imageUrl: trailingDecorationUrl,
                    width: 88,
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 10.8,
                  height: 1.5,
                  color: style.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskList extends StatefulWidget {
  final String eventId;
  final CollectionReference<Map<String, dynamic>> ref;
  final String currencyIcon;
  final String currencyName;
  final Color accent;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;

  const _TaskList({
    required this.eventId,
    required this.ref,
    required this.currencyIcon,
    required this.currencyName,
    required this.accent,
    required this.cardColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
  });

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  final Set<String> _claimingTaskIds = <String>{};

  DocumentReference<Map<String, dynamic>>? _progressRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('event_progress')
        .doc(user.uid)
        .collection('events')
        .doc(widget.eventId);
  }

  int _intValue(dynamic raw, {int fallback = 0}) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? fallback;
  }

  int _targetForTask(Map<String, dynamic> data) {
    final explicit = _intValue(data['target']);
    if (explicit > 0) return explicit;
    final title = (data['title'] ?? '').toString();
    final match = RegExp(r'(\d+)').firstMatch(title);
    return int.tryParse(match?.group(1) ?? '') ?? 1;
  }

  Future<void> _claimTask(String taskId) async {
    if (_claimingTaskIds.contains(taskId)) return;
    setState(() => _claimingTaskIds.add(taskId));

    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable('claimEventTaskReward');

      final result = await callable.call(<String, dynamic>{
        'eventId': widget.eventId,
        'taskId': taskId,
      });

      final data = result.data is Map
          ? Map<String, dynamic>.from(result.data as Map)
          : <String, dynamic>{};

      if (!mounted) return;

      final reward = _intValue(data['rewardAmount']);
      final currency = _intValue(data['currency']);

      ToastUtils.showCenterToast(
        context,
        reward > 0
            ? appL10n.event_claim_task_message_claim_current(currency, reward, widget.currencyIcon, widget.currencyName)
            : appL10n.event_claim_task_message_reward_claim,
        customIcon: Icons.check_circle_rounded,
      );
    } on FirebaseFunctionsException catch (error) {
      if (!mounted) return;

      String message = error.message ?? appL10n.event_claim_task_message_claim_failed;

      if (error.code == 'already-exists') {
        message = appL10n.event_claim_task_message_task_claim;
      } else if (error.code == 'failed-precondition') {
        message = error.message ?? appL10n.event_claim_task_message_incomplete_task;
      }

      ToastUtils.showCenterToast(
        context,
        message,
        isError: true,
      );
    } catch (error) {
      if (!mounted) return;

      ToastUtils.showCenterToast(
        context,
        '領取失敗：$error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _claimingTaskIds.remove(taskId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressRef = _progressRef();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.ref.orderBy('order').snapshots(),
      builder: (context, taskSnapshot) {
        if (!taskSnapshot.hasData) {
          return _SoftCard(label: appL10n.event_task_list_label_task_load);
        }
        if (taskSnapshot.data!.docs.isEmpty) {
          return _SoftCard(label: appL10n.event_task_list_label_task_current);
        }
        if (progressRef == null) {
          return _SoftCard(label: appL10n.event_task_list_label_task_login_progress);
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: progressRef.snapshots(),
          builder: (context, progressSnapshot) {
            final progressData =
                progressSnapshot.data?.data() ?? <String, dynamic>{};
            final rawTaskProgress = progressData['taskProgress'];
            final taskProgress = rawTaskProgress is Map
                ? Map<String, dynamic>.from(rawTaskProgress)
                : <String, dynamic>{};
            final rawClaimed = progressData['claimedTasks'];
            final claimedTasks = rawClaimed is Map
                ? Map<String, dynamic>.from(rawClaimed)
                : <String, dynamic>{};

            return Column(
              children: taskSnapshot.data!.docs.map((doc) {
                final data = doc.data();
                final reward = _intValue(data['rewardAmount']);
                final target = _targetForTask(data);
                final progress = _intValue(taskProgress[doc.id]).clamp(0, target);
                final claimed = claimedTasks[doc.id] == true;
                final completed = progress >= target;
                final claiming = _claimingTaskIds.contains(doc.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _TaskCard(
                    title: (data['title'] ?? '活動任務').toString(),
                    description: (data['description'] ?? '').toString(),
                    rewardText:
                    '${widget.currencyIcon} ${widget.currencyName} ×$reward',
                    progress: progress,
                    target: target,
                    claimed: claimed,
                    claiming: claiming,
                    accent: widget.accent,
                    cardColor: widget.cardColor,
                    textPrimaryColor: widget.textPrimaryColor,
                    textSecondaryColor: widget.textSecondaryColor,
                    onClaim: completed && !claimed && !claiming
                        ? () => _claimTask(doc.id)
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String rewardText;
  final int progress;
  final int target;
  final bool claimed;
  final bool claiming;
  final Color accent;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final VoidCallback? onClaim;

  const _TaskCard({
    required this.title,
    required this.description,
    required this.rewardText,
    required this.progress,
    required this.target,
    required this.claimed,
    required this.claiming,
    required this.accent,
    required this.cardColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.onClaim,
  });


  @override
  Widget build(BuildContext context) {
    final onSurface = textPrimaryColor;
    final completed = progress >= target;
    final progressValue = target <= 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);

    String buttonText() {
      if (claimed) return '已領取';
      if (completed) return '領取';
      return '進行中';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 10, 11),
      decoration: BoxDecoration(
        color: Color.lerp(cardColor, accent, 0.018),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.09)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                if (description.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 9.8,
                      color: textSecondaryColor,
                    ),
                  ),
                ],
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          minHeight: 5,
                          value: progressValue,
                          backgroundColor: accent.withValues(alpha: 0.10),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            accent.withValues(alpha: 0.70),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '$progress / $target',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  rewardText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.notoSerifTc(
                    fontSize: 9.8,
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 32,
                  child: FilledButton.tonal(
                    onPressed: completed && !claimed ? onClaim : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: completed && !claimed
                          ? accent.withValues(alpha: 0.14)
                          : accent.withValues(alpha: 0.055),
                      foregroundColor: accent,
                    ),
                    child: claiming
                        ? const SizedBox.square(
                      dimension: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      buttonText(),
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _MilestoneProgress extends StatelessWidget {
  final CollectionReference<Map<String, dynamic>> ref;
  final DocumentReference<Map<String, dynamic>>? progressRef;
  final String currencyIcon;
  final Color accent;
  final Color textMutedColor;

  const _MilestoneProgress({
    required this.ref,
    required this.progressRef,
    required this.currencyIcon,
    required this.accent,
    required this.textMutedColor,
  });

  int _intValue(dynamic raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ref.orderBy('order').snapshots(),
      builder: (context, milestoneSnapshot) {
        if (!milestoneSnapshot.hasData) {
          return _CompactSectionMessage(
            label: appL10n.event_milestone_progress_label_reward_load,
            accent: accent,
          );
        }
        final docs = milestoneSnapshot.data!.docs;
        if (docs.isEmpty) {
          return _CompactSectionMessage(
            label: appL10n.event_milestone_progress_label_reward_current,
            accent: accent,
          );
        }

        Widget buildWithTotal(int totalEarned) {
          final targets = docs
              .map((doc) => _intValue(doc.data()['target']))
              .where((value) => value > 0)
              .toList();
          final maxTarget = targets.isEmpty ? 1 : targets.reduce((a, b) => a > b ? a : b);
          final ratio = (totalEarned / maxTarget).clamp(0.0, 1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    appL10n.event_build_with_total_message_current(totalEarned),
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: docs.map((doc) {
                  final data = doc.data();
                  final target = _intValue(data['target']);
                  final title = (data['title'] ?? '限定獎勵').toString();
                  final unlocked = totalEarned >= target;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: unlocked
                                  ? accent.withValues(alpha: 0.16)
                                  : accent.withValues(alpha: 0.055),
                              border: Border.all(
                                color: accent.withValues(alpha: unlocked ? 0.30 : 0.12),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              unlocked ? currencyIcon : '🎁',
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$target',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 9.5,
                              height: 1.3,
                              color: textMutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }

        if (progressRef == null) return buildWithTotal(0);
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: progressRef!.snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data() ?? <String, dynamic>{};
            // totalEarned is deliberate: spending currency must not reduce milestone progress.
            final totalEarned = _intValue(data['totalEarned']);
            return buildWithTotal(totalEarned);
          },
        );
      },
    );
  }
}

class _RichFeatureEntryCard extends StatelessWidget {
  final Color accent;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RichFeatureEntryCard({
    required this.accent,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = textPrimaryColor;
    final hasImage = imageUrl.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: accent.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasImage)
                  SizedBox(
                    height: 82,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl.trim(),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: accent.withValues(alpha: 0.035),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: accent.withValues(alpha: 0.035),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 11, 11, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSerifTc(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 21,
                            color: accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 10.2,
                          height: 1.45,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RichEventInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color accent;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final String decorationImageUrl;

  const _RichEventInfoCard({
    required this.title,
    required this.description,
    required this.accent,
    required this.cardColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    this.decorationImageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = textPrimaryColor;
    final text = description.trim();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.09)),
      ),
      child: Stack(
        children: [
          if (decorationImageUrl.trim().isNotEmpty)
            Positioned(
              right: -10,
              bottom: -12,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.24,
                  child: _DecorationImage(
                    imageUrl: decorationImageUrl,
                    width: 112,
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSerifTc(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              if (text.isNotEmpty) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(
                    right: decorationImageUrl.trim().isNotEmpty ? 72 : 0,
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 11,
                      height: 1.7,
                      color: textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class EventShopPage extends StatefulWidget {
  final String eventId;
  final String currencyName;
  final String currencyIcon;
  final String shopHeroImageUrl;
  final Color accentColor;
  final Color pageBackgroundColor;
  final Color cardColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;

  const EventShopPage({
    super.key,
    required this.eventId,
    required this.currencyName,
    required this.currencyIcon,
    this.shopHeroImageUrl = '',
    required this.accentColor,
    required this.pageBackgroundColor,
    required this.cardColor,
    this.textPrimaryColor = _eventDefaultTextPrimary,
    this.textSecondaryColor = _eventDefaultTextSecondary,
    this.textMutedColor = _eventDefaultTextMuted,
  });

  @override
  State<EventShopPage> createState() => _EventShopPageState();
}

class _EventShopPageState extends State<EventShopPage> {
  final Set<String> _redeemingItemIds = <String>{};

  CollectionReference<Map<String, dynamic>> _itemsRef() {
    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('events')
        .doc(widget.eventId)
        .collection('shop_items');
  }

  DocumentReference<Map<String, dynamic>>? _progressRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return FirebaseFirestore.instance
        .collection('artifacts')
        .doc(AppConfig.appId)
        .collection('event_progress')
        .doc(user.uid)
        .collection('events')
        .doc(widget.eventId);
  }

  Future<void> _redeemItem({
    required String itemId,
    required Map<String, dynamic> data,
    required int price,
  }) async {
    if (_redeemingItemIds.contains(itemId)) return;

    final itemName = (data['name'] ?? '活動商品').toString();
    final itemType = (data['itemType'] ?? 'other').toString();
    final rewardAmount = data['rewardAmount'] is num
        ? (data['rewardAmount'] as num).toInt()
        : int.tryParse('${data['rewardAmount']}') ?? 0;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            appL10n.event_progress_ref_message_redeem_confirm,
            style: GoogleFonts.notoSerifTc(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            itemType == 'flower' && rewardAmount > 0
                ? appL10n.event_progress_ref_message_redeem_flowers(itemName, price, rewardAmount, widget.currencyIcon)
                : appL10n.event_progress_ref_message_redeem(itemName, price, widget.currencyIcon),
            style: GoogleFonts.notoSerifTc(
              height: 1.55,
              color: widget.textPrimaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('確認兌換'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _redeemingItemIds.add(itemId));

    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-east1',
      ).httpsCallable('redeemEventShopItem');

      final result = await callable.call(<String, dynamic>{
        'eventId': widget.eventId,
        'itemId': itemId,
      });

      final resultData = Map<String, dynamic>.from(
        result.data as Map,
      );

      if (!mounted) return;

      final returnedReward = resultData['rewardAmount'] is num
          ? (resultData['rewardAmount'] as num).toInt()
          : 0;

      ToastUtils.showCenterToast(
        context,
        returnedReward > 0
            ? appL10n.event_progress_ref_message_redeem_success_flowers(returnedReward)
            : appL10n.event_progress_ref_message_event_collection_redeem_success_add(itemName),
        customIcon: Icons.check_circle_rounded,
      );
    } on FirebaseFunctionsException catch (error) {
      if (!mounted) return;

      String message = error.message ?? appL10n.event_progress_ref_message_redeem_failed;

      if (error.code == 'already-exists') {
        message = appL10n.event_progress_ref_message_redeem_variant_b;
      } else if (error.code == 'failed-precondition' &&
          message.contains(appL10n.event_progress_ref_message_insufficient)) {
        message = appL10n.event_progress_ref_message_insufficient_variant_b(widget.currencyName);
      }

      ToastUtils.showCenterToast(
        context,
        message,
        isError: true,
      );
    } catch (error) {
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '兌換失敗：$error',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _redeemingItemIds.remove(itemId));
      }
    }
  }

  Future<void> _showShopItemDetail({
    required String itemId,
    required Map<String, dynamic> data,
    required int price,
    required int redeemedCount,
    required int maxRedemptions,
    required bool alreadyRedeemed,
    required bool insufficient,
  }) async {
    final colors = Theme.of(context).colorScheme;
    final imageUrl = (data['imageUrl'] ?? '').toString().trim();
    final name = (data['name'] ?? '限定商品').toString();
    final description = (data['description'] ?? '').toString().trim();
    final itemType = (data['itemType'] ?? 'other').toString();
    final rewardAmount = data['rewardAmount'] is num
        ? (data['rewardAmount'] as num).toInt()
        : int.tryParse('${data['rewardAmount']}') ?? 0;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (dialogContext) {
        String buttonText = appL10n.event_progress_ref_message_redeem_variant_c;
        if (alreadyRedeemed) {
          buttonText = appL10n.event_progress_ref_message_redeem_variant_d;
        } else if (insufficient) {
          buttonText = '${widget.currencyName}不足';
        }

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
              maxHeight: 760,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: colors.surfaceContainerHighest
                            .withValues(alpha: 0.52),
                        child: imageUrl.isNotEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                _ShopFallback(colors: colors),
                          ),
                        )
                            : _ShopFallback(colors: colors),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 20,
                                      height: 1.35,
                                      fontWeight: FontWeight.w800,
                                      color: widget.textPrimaryColor,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: '關閉',
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  icon: const Icon(Icons.close_rounded),
                                ),
                              ],
                            ),
                            if (description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                description,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 12,
                                  height: 1.7,
                                  color: colors.onSurface
                                      .withValues(alpha: 0.62),
                                ),
                              ),
                            ],
                            if (itemType == 'flower' && rewardAmount > 0) ...[
                              const SizedBox(height: 10),
                              Text(
                                appL10n.event_message_redeem_flowers(rewardAmount),
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: widget.accentColor,
                                ),
                              ),
                            ],
                            if (maxRedemptions > 0 || redeemedCount > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                maxRedemptions > 0
                                    ? '已兌換 $redeemedCount / $maxRedemptions 次'
                                    : '已兌換 $redeemedCount 次',
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 10.5,
                                  color: colors.onSurface
                                      .withValues(alpha: 0.48),
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primary
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '${widget.currencyIcon} $price',
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: widget.accentColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                FilledButton(
                                  onPressed: alreadyRedeemed || insufficient
                                      ? null
                                      : () {
                                    Navigator.of(dialogContext).pop();
                                    _redeemItem(
                                      itemId: itemId,
                                      data: data,
                                      price: price,
                                    );
                                  },
                                  child: Text(
                                    buttonText,
                                    style: GoogleFonts.notoSerifTc(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final progressRef = _progressRef();

    return Scaffold(
      backgroundColor: widget.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: widget.pageBackgroundColor,
        foregroundColor: widget.textPrimaryColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '活動商店',
          style: GoogleFonts.notoSerifTc(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: widget.textPrimaryColor,
          ),
        ),
      ),
      body: progressRef == null
          ? Center(
        child: Text(
          appL10n.event_message_event_shop_login,
          style: GoogleFonts.notoSerifTc(
            color: widget.textSecondaryColor,
          ),
        ),
      )
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: progressRef.snapshots(),
        builder: (context, progressSnapshot) {
          final progressData =
              progressSnapshot.data?.data() ?? <String, dynamic>{};

          final currency = progressData['currency'] is num
              ? (progressData['currency'] as num).toInt()
              : int.tryParse('${progressData['currency']}') ?? 0;

          final rawRedeemed = progressData['redeemedShopItems'];
          final redeemedShopItems = rawRedeemed is Map
              ? Map<String, dynamic>.from(rawRedeemed)
              : <String, dynamic>{};

          return Column(
            children: [
              if (widget.shopHeroImageUrl.trim().isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: widget.shopHeroImageUrl.trim(),
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: widget.accentColor.withValues(alpha: 0.04),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: widget.accentColor,
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: widget.accentColor.withValues(alpha: 0.04),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 40,
                            color: widget.accentColor.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(
                  20,
                  widget.shopHeroImageUrl.trim().isNotEmpty ? 0 : 10,
                  20,
                  8,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.accentColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.currencyIcon,
                      style: const TextStyle(fontSize: 21),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.currencyName,
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 12,
                        color:
                        widget.textSecondaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$currency',
                      style: GoogleFonts.notoSerifTc(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: widget.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _itemsRef().orderBy('order').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: widget.accentColor,
                          strokeWidth: 2.2,
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          appL10n.event_message_redeem_current,
                          style: GoogleFonts.notoSerifTc(
                            color: widget.textMutedColor,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding:
                      const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: docs.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data();
                        final price = data['price'] is num
                            ? (data['price'] as num).toInt()
                            : int.tryParse('${data['price']}') ?? 0;
                        final redeemedCount =
                        redeemedShopItems[doc.id] is num
                            ? (redeemedShopItems[doc.id] as num)
                            .toInt()
                            : int.tryParse(
                          '${redeemedShopItems[doc.id]}',
                        ) ??
                            0;
                        final rawMaxRedemptions = data['maxRedemptions'];
                        final int maxRedemptions = rawMaxRedemptions is num
                            ? rawMaxRedemptions.toInt()
                            : int.tryParse(
                          rawMaxRedemptions?.toString() ?? '',
                        ) ??
                            (data['limitOne'] == true ? 1 : 0);
                        final alreadyRedeemed =
                            maxRedemptions > 0 &&
                                redeemedCount >= maxRedemptions;
                        final insufficient = currency < price;

                        return _ShopItemCard(
                          itemId: doc.id,
                          data: data,
                          currencyIcon: widget.currencyIcon,
                          redeemedCount: redeemedCount,
                          maxRedemptions: maxRedemptions,
                          isRedeeming: _redeemingItemIds.contains(doc.id),
                          alreadyRedeemed: alreadyRedeemed,
                          insufficient: insufficient,
                          textPrimaryColor: widget.textPrimaryColor,
                          textSecondaryColor: widget.textSecondaryColor,
                          textMutedColor: widget.textMutedColor,
                          accentColor: widget.accentColor,
                          cardColor: widget.cardColor,
                          onView: () => _showShopItemDetail(
                            itemId: doc.id,
                            data: data,
                            price: price,
                            redeemedCount: redeemedCount,
                            maxRedemptions: maxRedemptions,
                            alreadyRedeemed: alreadyRedeemed,
                            insufficient: insufficient,
                          ),
                          onRedeem: () => _redeemItem(
                            itemId: doc.id,
                            data: data,
                            price: price,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String itemId;
  final Map<String, dynamic> data;
  final String currencyIcon;
  final int redeemedCount;
  final int maxRedemptions;
  final bool isRedeeming;
  final bool alreadyRedeemed;
  final bool insufficient;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;
  final Color accentColor;
  final Color cardColor;
  final VoidCallback onView;
  final VoidCallback onRedeem;

  const _ShopItemCard({
    required this.itemId,
    required this.data,
    required this.currencyIcon,
    required this.redeemedCount,
    required this.maxRedemptions,
    required this.isRedeeming,
    required this.alreadyRedeemed,
    required this.insufficient,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.textMutedColor,
    required this.accentColor,
    required this.cardColor,
    required this.onView,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final imageUrl = (data['imageUrl'] ?? '').toString().trim();
    final description = (data['description'] ?? '').toString().trim();
    final itemType = (data['itemType'] ?? 'other').toString();
    final rewardAmount = data['rewardAmount'] is num
        ? (data['rewardAmount'] as num).toInt()
        : int.tryParse('${data['rewardAmount']}') ?? 0;
    final price = data['price'] is num
        ? (data['price'] as num).toInt()
        : int.tryParse('${data['price']}') ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: null,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.10),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onView,
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (_, __, ___) =>
                          _ShopFallback(colors: colors),
                    )
                        : _ShopFallback(colors: colors),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 9, 12, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data['name'] ?? '限定商品').toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSerifTc(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimaryColor,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 9.8,
                            height: 1.3,
                            color: textMutedColor,
                          ),
                        ),
                      ],
                      if (itemType == 'flower' && rewardAmount > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          appL10n.event_shop_item_card_message_flowers(rewardAmount),
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 10,
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (maxRedemptions > 0 || redeemedCount > 0) ...[
                        const SizedBox(height: 3),
                        Text(
                          maxRedemptions > 0
                              ? '已兌換 $redeemedCount / $maxRedemptions 次'
                              : '已兌換 $redeemedCount 次',
                          style: GoogleFonts.notoSerifTc(
                            fontSize: 9.5,
                            color: textMutedColor,
                          ),
                        ),
                      ],
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Text(
                            '$currencyIcon $price',
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 32,
                            child: FilledButton.tonal(
                              onPressed: isRedeeming || alreadyRedeemed || insufficient
                                  ? null
                                  : onRedeem,
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                ),
                              ),
                              child: isRedeeming
                                  ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                alreadyRedeemed
                                    ? '已兌換'
                                    : insufficient
                                    ? appL10n.event_message_insufficient
                                    : '兌換',
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopFallback extends StatelessWidget {
  final ColorScheme colors;
  const _ShopFallback({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.primary.withValues(alpha: 0.05),
      alignment: Alignment.center,
      child: Icon(
        Icons.card_giftcard_rounded,
        color: colors.primary.withValues(alpha: 0.38),
        size: 36,
      ),
    );
  }
}

class _CompactSectionMessage extends StatelessWidget {
  final String label;
  final Color accent;

  const _CompactSectionMessage({
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSerifTc(
          fontSize: 10.8,
          color: onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final String label;
  const _SoftCard({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 82,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSerifTc(
          fontSize: 11.5,
          color: colors.onSurface.withValues(alpha: 0.46),
        ),
      ),
    );
  }
}

class _EventUnavailablePage extends StatelessWidget {
  final String message;
  const _EventUnavailablePage({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.event_busy_outlined,
            size: 48,
            color: colors.primary.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: GoogleFonts.notoSerifTc(
              fontSize: 14,
              color: colors.onSurface.withValues(alpha: 0.58),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
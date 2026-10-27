import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

/// 世界觀正式互動：延用一般角色聊天室圖片，保留 NPC ID / 事件後端計費。
class WorldInteractionPlayPage extends StatefulWidget {
  const WorldInteractionPlayPage({super.key, required this.worldName, required this.characters});
  final String worldName;
  final Map<String, String> characters;

  @override
  State<WorldInteractionPlayPage> createState() => _WorldInteractionPlayPageState();
}

class _WorldInteractionPlayPageState extends State<WorldInteractionPlayPage> {
  String? _targetId;
  String get _target => widget.characters[_targetId] ?? AppLocalizations.of(context)!.chooseNpc1;

  static const _giftAssets = <String, String>{
    'heart': 'assets/images/chat/chat_gift_heart.png',
    'flower': 'assets/images/chat/chat_gift_flower.png',
    'sun': 'assets/images/chat/chat_gift_sun.png',
    'confetti': 'assets/images/chat/chat_gift_confetti.png',
    'coffee': 'assets/images/chat/chat_menu_model_mask.png',
    'cake': 'assets/images/chat/chat_gift_cake.png',
  };

  Future<void> _chooseTarget() async {
    if (widget.characters.isEmpty) return;
    final id = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(child: ListView(shrinkWrap: true, children: [
        ListTile(title: Text(AppLocalizations.of(context)!.chooseInteractionTarget1)),
        for (final entry in widget.characters.entries)
          ListTile(
            title: Text(entry.value.isEmpty ? AppLocalizations.of(context)!.unnamedCharacter1 : entry.value),
            trailing: entry.key == _targetId ? const Icon(Icons.check) : null,
            onTap: () => Navigator.pop(ctx, entry.key),
          ),
      ])),
    );
    if (id != null && mounted) setState(() => _targetId = id);
  }

  void _finish(String type, {String? gift, Map<String, dynamic>? extra}) {
    if (_targetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.chooseTargetFirst1)),
      );
      return;
    }
    Navigator.pop(context, <String, dynamic>{
      'npcId': _targetId!,
      'interactionType': type,
      if (gift != null) 'giftType': gift,
      if (extra != null) 'extra': extra,
    });
  }

  Future<void> _gift(String id, String name, int cost) async {
    if (_targetId == null) {
      _finish('gift', gift: id);
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmGift1),
        content: Text(AppLocalizations.of(context)!.giftConfirmDetail1(_target, name, cost)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppLocalizations.of(context)!.cancel1)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppLocalizations.of(context)!.send1)),
        ],
      ),
    );
    if (ok == true && mounted) _finish('gift', gift: id);
  }

  Future<void> _location() async {
    if (_targetId == null) {
      _finish('location');
      return;
    }
    final controller = TextEditingController();
    final location = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.sendLocationTitle1),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final place in <(String, String)>[
            ('咖啡廳', AppLocalizations.of(context)!.cafe1),
            ('公園', AppLocalizations.of(context)!.park1),
            ('餐廳', AppLocalizations.of(context)!.restaurant1),
            ('街道', AppLocalizations.of(context)!.street1),
          ])
            ListTile(title: Text(place.$2), onTap: () => Navigator.pop(ctx, place.$1)),
          TextField(
            controller: controller,
            maxLength: 80,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.customLocation1),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel1)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: Text(AppLocalizations.of(context)!.confirm1)),
        ],
      ),
    );
    controller.dispose();
    if (location != null && location.trim().isNotEmpty && mounted) {
      _finish('location', extra: {'location': location.trim()});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final gifts = <(String, String, int)>[
      ('heart', l10n.giftHeart1, 1),
      ('flower', l10n.giftFlower1, 1),
      ('sun', l10n.giftSun1, 1),
      ('confetti', l10n.giftConfetti1, 3),
      ('coffee', l10n.giftCoffee1, 5),
      ('cake', l10n.giftCake1, 5),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.interactionPlayTitle1, style: GoogleFonts.notoSerifTc(fontSize: 21, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 36),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(widget.worldName, style: GoogleFonts.notoSerifTc(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _chooseTarget,
              icon: const Icon(Icons.people_outline),
              label: Text(l10n.interactionTargetLabel1(_target)),
            ),
            const SizedBox(height: 24),
            _SectionTitle(text: l10n.intimateInteraction1, primary: primary),
            const SizedBox(height: 16),
            _FeatureTile(assetPath: 'assets/images/chat/chat_interaction_poke_cheek.png',
                title: l10n.poke1, cost: '3', primary: primary, onTap: () => _finish('poke')),
            const SizedBox(height: 12),
            _FeatureTile(assetPath: 'assets/images/chat/chat_interaction_hug.png',
                title: l10n.hug1, cost: '3', primary: primary, onTap: () => _finish('hug')),
            const SizedBox(height: 12),
            _FeatureTile(assetPath: 'assets/images/chat/chat_interaction_hold_hands.png',
                title: l10n.holdHands1, cost: '3', primary: primary, onTap: () => _finish('holdHands')),
            const SizedBox(height: 34),
            _SectionTitle(text: l10n.gifts1, primary: primary),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gifts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.2,
              ),
              itemBuilder: (ctx, index) {
                final gift = gifts[index];
                return _GiftCard(
                  assetPath: _giftAssets[gift.$1]!,
                  name: gift.$2,
                  cost: '${gift.$3}',
                  primary: primary,
                  onTap: () => _gift(gift.$1, gift.$2, gift.$3),
                );
              },
            ),
            const SizedBox(height: 34),
            _SectionTitle(text: l10n.funActivities1, primary: primary),
            const SizedBox(height: 16),
            _FeatureTile(assetPath: 'assets/images/chat/chat_fun_location.png',
                title: l10n.sendLocation1, cost: '3', primary: primary, onTap: _location),
            const SizedBox(height: 12),
            _FeatureTile(assetPath: 'assets/images/chat/chat_fun_dice.png',
                title: l10n.diceDuel1, cost: '3', primary: primary, onTap: () => _finish('dice')),
          ]),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color primary;

  const _SectionTitle({
    required this.text,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '——  $text  ——',
        style: GoogleFonts.notoSerifTc(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: primary.withValues(alpha: 0.82),
        ),
      ),
    );
  }
}

class _GiftCard extends StatelessWidget {
  final String assetPath;
  final String name;
  final String cost;
  final Color primary;
  final VoidCallback onTap;

  const _GiftCard({
    required this.assetPath,
    required this.name,
    required this.cost,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftTapSurface(
      primary: primary,
      onTap: onTap,
      child: Row(
        children: [
          _TintedAsset(
            assetPath: assetPath,
            size: 30,
            primary: primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.82),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              cost,
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String assetPath;
  final String title;
  final String cost;
  final Color primary;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.assetPath,
    required this.title,
    required this.cost,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftTapSurface(
      primary: primary,
      onTap: onTap,
      child: Row(
        children: [
          _TintedAsset(
            assetPath: assetPath,
            size: 36,
            primary: primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoSerifTc(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.82),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              cost,
              style: GoogleFonts.notoSerifTc(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftTapSurface extends StatelessWidget {
  final Widget child;
  final Color primary;
  final VoidCallback onTap;

  const _SoftTapSurface({
    required this.child,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary.withValues(alpha: 0.035),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: primary.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TintedAsset extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color primary;

  const _TintedAsset({
    required this.assetPath,
    required this.size,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: primary.withValues(alpha: 0.75),
      colorBlendMode: BlendMode.srcIn,
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.circle_outlined,
          size: size * 0.72,
          color: primary.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}


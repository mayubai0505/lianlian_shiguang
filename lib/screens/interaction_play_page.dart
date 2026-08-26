import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';


//互動玩法
class InteractionPlayPage extends StatelessWidget {
  final List<Map<String, dynamic>> gifts;
  final ValueChanged<String> onAction;
  final ValueChanged<Map<String, dynamic>> onGiftTap;
  final VoidCallback onLocationTap;
  final VoidCallback onDiceTap;

  const InteractionPlayPage({
    super.key,
    required this.gifts,
    required this.onAction,
    required this.onGiftTap,
    required this.onLocationTap,
    required this.onDiceTap,
  });

  static const List<String> _giftAssets = [
    'assets/images/chat/chat_gift_heart.png',
    'assets/images/chat/chat_gift_flower.png',
    'assets/images/chat/chat_gift_sun.png',
    'assets/images/chat/chat_gift_confetti.png',
    'assets/images/chat/chat_menu_model_mask.png', // 咖啡：沿用既有素材
    'assets/images/chat/chat_gift_cake.png',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          l10n.chat_interact_title,
          style: GoogleFonts.notoSerifTc(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionTitle(
                text: l10n.chat_interact_action,
                primary: primary,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      assetPath:
                      'assets/images/chat/chat_interaction_poke_cheek.png',
                      label: l10n.chat_action_poke,
                      primary: primary,
                      onTap: () {
                        // 先回聊天室，再沿用原本訊息發送邏輯。
                        Navigator.pop(context);
                        onAction(l10n.chat_action_poke_prompt);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      assetPath: 'assets/images/chat/chat_interaction_hug.png',
                      label: l10n.chat_action_hug,
                      primary: primary,
                      onTap: () {
                        Navigator.pop(context);
                        onAction(l10n.chat_action_hug_prompt);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 56) / 2,
                  child: _ActionCard(
                    assetPath:
                    'assets/images/chat/chat_interaction_hold_hands.png',
                    label: l10n.chat_action_hand,
                    primary: primary,
                    onTap: () {
                      Navigator.pop(context);
                      onAction(l10n.chat_action_hand_prompt);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 34),
              _SectionTitle(
                text: l10n.chat_interact_gift,
                primary: primary,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gifts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  final asset = index < _giftAssets.length
                      ? _giftAssets[index]
                      : 'assets/images/chat/chat_gift_heart.png';

                  return _GiftCard(
                    assetPath: asset,
                    name: gift['name']?.toString() ?? '',
                    cost: gift['cost']?.toString() ?? '',
                    primary: primary,
                    onTap: () {
                      // 先回聊天頁，再執行原本送禮邏輯。
                      // 因此點數不足時，原本的 AlertDialog 也會正常顯示在聊天頁。
                      Navigator.pop(context);
                      onGiftTap(gift);
                    },
                  );
                },
              ),
              const SizedBox(height: 34),
              _SectionTitle(
                text: l10n.chat_dice_btn == l10n.chat_menu_send_location
                    ? l10n.chat_dice_btn
                    : '趣味玩法',
                primary: primary,
              ),
              const SizedBox(height: 16),
              _FeatureTile(
                assetPath: 'assets/images/chat/chat_fun_location.png',
                title: l10n.chat_menu_send_location,
                primary: primary,
                onTap: onLocationTap,
              ),
              const SizedBox(height: 12),
              _FeatureTile(
                assetPath: 'assets/images/chat/chat_fun_dice.png',
                title: l10n.chat_dice_btn,
                primary: primary,
                onTap: onDiceTap,
              ),
            ],
          ),
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

class _ActionCard extends StatelessWidget {
  final String assetPath;
  final String label;
  final Color primary;
  final VoidCallback onTap;

  const _ActionCard({
    required this.assetPath,
    required this.label,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SoftTapSurface(
      primary: primary,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TintedAsset(
            assetPath: assetPath,
            size: 42,
            primary: primary,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.80),
              ),
            ),
          ),
        ],
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
  final Color primary;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.assetPath,
    required this.title,
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
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: primary.withValues(alpha: 0.48),
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

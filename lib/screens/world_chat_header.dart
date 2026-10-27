import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// 世界觀專用的頂部，不影響一般聊天室。
const worldModeCosts = <String, int>{
  'story': 5, 'immersive': 7, 'resonance': 10, 'interaction': 12,
};
String worldModeLabel(String id) {
  switch (id) {
    case 'story': return '劇情';
    case 'immersive': return '沉浸';
    case 'resonance': return '共鳴';
    case 'interaction': return '互動';
    default: return '劇情';
  }
}

// 專供介面顯示使用；保留原 worldModeLabel(String) 供其他頁面呼叫。
String _localizedWorldModeLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'story': return l10n.world_chat_mode_story1;
    case 'immersive': return l10n.world_chat_mode_immersive1;
    case 'resonance': return l10n.world_chat_mode_resonance1;
    case 'interaction': return l10n.world_chat_mode_interaction1;
    default: return l10n.world_chat_mode_story1;
  }
}

class WorldChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const WorldChatHeader({
    super.key,
    required this.worldName,
    required this.modeId,
    required this.flowerPoints,
    required this.onFlowerTap,
    required this.onModeSelected,
    required this.onBack,
    required this.onMenuTap,
  });
  final String worldName;
  final String modeId;
  final int flowerPoints;
  final VoidCallback onFlowerTap;
  final ValueChanged<String> onModeSelected;
  final VoidCallback onBack;
  final VoidCallback onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final flowersAsset = theme.brightness == Brightness.dark
        ? 'assets/images/flower_gift_dark.png'
        : 'assets/images/flower_gift.png';

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: .96),
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 3, 6, 4),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: primary.withValues(alpha: .08)))),
          child: Row(children: [
            IconButton(
              onPressed: onBack, tooltip: l10n.world_chat_back1,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 38),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface, size: 20),
            ),
            const SizedBox(width: 3),
            Expanded(child: Text(worldName,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(fontSize: 15, fontWeight: FontWeight.w500, color: onSurface),
            )),
            const SizedBox(width: 5),
            InkWell(
              onTap: onFlowerTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(flowersAsset, width: 17, height: 17,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  const SizedBox(width: 3),
                  ConstrainedBox(constraints: const BoxConstraints(maxWidth: 43),
                      child: Text('$flowerPoints', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSerifTc(fontSize: 10.5, fontWeight: FontWeight.w600,
                              color: onSurface.withValues(alpha: .76)))),
                ]),
              ),
            ),
            const SizedBox(width: 3),
            PopupMenuButton<String>(
              tooltip: l10n.world_chat_mode_tooltip1,
              initialValue: modeId,
              onSelected: onModeSelected,
              position: PopupMenuPosition.under,
              constraints: const BoxConstraints(minWidth: 180, maxWidth: 230),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              itemBuilder: (context) => worldModeCosts.entries.map((entry) => PopupMenuItem<String>(
                value: entry.key,
                child: Row(children: [
                  Expanded(child: Text(l10n.world_chat_mode_cost1(_localizedWorldModeLabel(l10n, entry.key), entry.value),
                      style: GoogleFonts.notoSerifTc(fontSize: 13))),
                  if (modeId == entry.key) Icon(Icons.check_rounded, color: primary, size: 17),
                ]),
              )).toList(),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(_localizedWorldModeLabel(l10n, modeId), style: GoogleFonts.notoSerifTc(fontSize: 10.5, color: onSurface)),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: primary),
                  ])),
            ),
            IconButton(
              onPressed: onMenuTap, tooltip: l10n.world_chat_menu1,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: Icon(Icons.menu_rounded, color: onSurface, size: 26),
            ),
          ]),
        ),
      ),
    );
  }
}

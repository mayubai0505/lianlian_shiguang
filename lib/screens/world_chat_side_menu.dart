import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 世界觀專用選單：不依賴單一 characterId、一般聊天室的記憶路徑。
class WorldChatSideMenu extends StatelessWidget {
  const WorldChatSideMenu({super.key, required this.worldName, required this.onAction});
  final String worldName;
  final ValueChanged<String> onAction;

  static Future<void> show(BuildContext context, {required WorldChatSideMenu menu}) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: .32),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, _, __) => SafeArea(child: Align(alignment: Alignment.centerRight,
          child: FractionallySizedBox(widthFactor: .88, child: menu))),
      transitionBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: animation, child: child)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    Widget section(String title) => Padding(padding: const EdgeInsets.fromLTRB(4, 16, 4, 7),
        child: Text(title, style: GoogleFonts.notoSerifTc(fontSize: 11, letterSpacing: 1.2,
            color: theme.colorScheme.onSurface.withValues(alpha: .48))));
    Widget tile(String title, String asset, {bool danger = false}) => InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () { Navigator.of(context).pop(); onAction(title); },
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(children: [
            Image.asset(asset, width: 38, height: 38, color: danger ? Colors.redAccent : primary,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => Icon(Icons.circle_outlined,
                    color: danger ? Colors.redAccent : primary)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: GoogleFonts.notoSerifTc(fontSize: 15,
                fontWeight: FontWeight.w600, color: danger ? Colors.redAccent : theme.colorScheme.onSurface))),
            Icon(Icons.chevron_right_rounded, color: primary.withValues(alpha: .45)),
          ])),
    );
    return Material(color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned(top: -18, right: -30, child: IgnorePointer(child: Opacity(opacity: .075,
            child: Image.asset('assets/images/chat/chat_side_menu_corner_floral_mask.png',
                width: 260, height: 240, color: primary, colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => const SizedBox.shrink())))),
        ListView(padding: const EdgeInsets.fromLTRB(22, 26, 18, 30), children: [
          Text(worldName, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSerifTc(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text('開放世界 · 功能逐步開放', style: theme.textTheme.bodySmall),
          section('聊天'),
          tile('搜尋對話', 'assets/images/chat/chat_menu_search_mask.png'),
          tile('保存對話紀錄', 'assets/images/chat/chat_menu_save_mask.png'),
          tile('專屬回憶與背景', 'assets/images/chat/chat_menu_gallery_mask.png'),
          const Divider(), section('世界關係'),
          tile('劇情摘要', 'assets/images/chat/chat_menu_about_us_mask.png'),
          tile('人物關係', 'assets/images/chat/chat_menu_related_mask.png'),
          tile('備忘錄', 'assets/images/chat/chat_menu_memo_mask.png'),
          const Divider(), section('記憶管理'),
          tile('重置世界進度', 'assets/images/chat/chat_menu_reset_memory_mask.png', danger: true),
        ]),
      ]),
    );
  }
}

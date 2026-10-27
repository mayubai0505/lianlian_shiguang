import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/image_utils.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

/// 世界觀專用的完整搜尋頁；僅搜尋呼叫者已讀取的訊息。
/// 不連接普通聊天室、不另行讀取私密世界資料。
class WorldChatSearchPage extends StatefulWidget {
  const WorldChatSearchPage({
    super.key,
    required this.worldName,
    required this.messages,
  });

  final String worldName;
  final List<Map<String, String>> messages;

  @override
  State<WorldChatSearchPage> createState() => _WorldChatSearchPageState();
}

class _WorldChatSearchPageState extends State<WorldChatSearchPage> {
  final TextEditingController _query = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _expandedIndex;

  @override
  void dispose() {
    _query.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final term = _query.text.trim().toLowerCase();
    final matches = <int>[];
    if (term.isNotEmpty) {
      for (var i = 0; i < widget.messages.length; i++) {
        final entry = widget.messages[i];
        final speaker = (entry['speaker'] ?? '').toLowerCase();
        final text = (entry['text'] ?? '').toLowerCase();
        if (speaker.contains(term) || text.contains(term)) matches.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.world_search_title1, style: GoogleFonts.notoSerifTc(fontSize: 17)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.worldName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 12, color: textColor.withValues(alpha: .55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _query,
                    focusNode: _focusNode,
                    autofocus: true,
                    onChanged: (_) => setState(() => _expandedIndex = null),
                    style: GoogleFonts.notoSerifTc(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l10n.world_search_hint1,
                      hintStyle: GoogleFonts.notoSerifTc(fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: term.isEmpty ? null : IconButton(
                        tooltip: l10n.world_search_clear1,
                        onPressed: () {
                          _query.clear();
                          setState(() => _expandedIndex = null);
                          _focusNode.requestFocus();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                      filled: true,
                      fillColor: primary.withValues(alpha: .05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    term.isEmpty ? l10n.world_search_start1 : l10n.world_search_results1(matches.length),
                    style: GoogleFonts.notoSerifTc(fontSize: 12,
                        color: textColor.withValues(alpha: .55)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: term.isEmpty
                  ? Center(child: Text(l10n.world_search_empty_prompt1))
                  : matches.isEmpty
                  ? Center(child: Text(l10n.world_search_no_results1))
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: matches.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, resultIndex) {
                  final index = matches[resultIndex];
                  final entry = widget.messages[index];
                  final expanded = _expandedIndex == index;
                  final speaker = entry['speaker'] ?? l10n.world_search_unknown_speaker1;
                  final body = entry['text'] ?? '';
                  return InkWell(
                    onTap: () {
                      _focusNode.unfocus();
                      setState(() => _expandedIndex = expanded ? null : index);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            if (entry['kind'] != 'narrator') ...[
                              ClipOval(
                                child: SizedBox(
                                  width: 34, height: 34,
                                  child: Image(
                                    image: getAvatarImageProvider(
                                      (entry['avatar'] ?? '').trim().isNotEmpty
                                          ? entry['avatar']! : 'assets/images/avatar1.webp',
                                    ),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        ColoredBox(color: primary.withValues(alpha: .06)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 9),
                            ],
                            Expanded(child: Text(speaker,
                                style: GoogleFonts.notoSerifTc(
                                  fontSize: 13, fontWeight: FontWeight.w600,
                                ))),
                            Text(expanded ? l10n.world_search_collapse1 : l10n.world_search_expand1,
                                style: GoogleFonts.notoSerifTc(fontSize: 11,
                                    color: textColor.withValues(alpha: .48))),
                          ]),
                          const SizedBox(height: 7),
                          Text(body,
                            maxLines: expanded ? null : 3,
                            overflow: expanded ? null : TextOverflow.ellipsis,
                            style: GoogleFonts.notoSerifTc(fontSize: 13, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 9),
              child: Text(l10n.world_search_scope1,
                style: GoogleFonts.notoSerifTc(fontSize: 10.5,
                    color: textColor.withValues(alpha: .46)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
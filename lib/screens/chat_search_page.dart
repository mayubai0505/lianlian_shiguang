import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/image_utils.dart';

class ChatSearchPage extends StatefulWidget {
  final List<dynamic> messages;
  final ImageProvider? characterAvatar;
  final String characterName;
  final String searchHint;
  final String emptyLabel;
  final String youLabel;
  final String himLabel;

  const ChatSearchPage({
    super.key,
    required this.messages,
    required this.characterName,
    required this.searchHint,
    required this.emptyLabel,
    required this.youLabel,
    required this.himLabel,
    this.characterAvatar,
  });

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _query = '';
  String _playerName = '';
  ImageProvider? _playerAvatar;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _focusNode.requestFocus();

      if (widget.characterAvatar != null) {
        precacheImage(widget.characterAvatar!, context).catchError((_) {});
      }
    });

    _loadPlayerProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  Future<void> _loadPlayerProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String playerName = user.displayName?.trim() ?? '';
    String avatarPath = user.photoURL?.trim() ?? '';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (data != null) {
        final nickname = data['nickname']?.toString().trim() ?? '';
        final savedAvatar = data['avatarPath']?.toString().trim() ?? '';

        if (nickname.isNotEmpty) {
          playerName = nickname;
        }

        if (savedAvatar.isNotEmpty) {
          avatarPath = savedAvatar;
        }
      }
    } catch (_) {
      // Firestore 暫時讀不到時，沿用 FirebaseAuth 的名稱／頭像。
    }

    if (!mounted) return;

    final ImageProvider avatarProvider = getAvatarImageProvider(
      avatarPath.isNotEmpty ? avatarPath : 'assets/images/avatar1.png',
    );

    setState(() {
      _playerName = playerName;
      _playerAvatar = avatarProvider;
    });

    // 玩家頭像也先預載；網路圖片由共用 ImageProvider 使用磁碟快取。
    precacheImage(avatarProvider, context).catchError((_) {});
  }

  List<dynamic> get _matches {
    final keyword = _query.trim().toLowerCase();

    if (keyword.isEmpty) return const [];

    return widget.messages.where((message) {
      final text = (message.text ?? '').toString().toLowerCase();
      return text.contains(keyword);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final matches = _matches;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: -35,
              top: 86,
              child: IgnorePointer(
                child: Icon(
                  Icons.local_florist_outlined,
                  size: 120,
                  color: primary.withValues(alpha: 0.035),
                ),
              ),
            ),
            Positioned(
              left: -36,
              bottom: 28,
              child: IgnorePointer(
                child: Icon(
                  Icons.eco_outlined,
                  size: 120,
                  color: primary.withValues(alpha: 0.035),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.055),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.16),
                            ),
                          ),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) {
                              setState(() {
                                _query = value;
                              });
                            },
                            style: GoogleFonts.notoSerifTc(
                              fontSize: 15,
                              color: onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.searchHint,
                              hintStyle: GoogleFonts.notoSerifTc(
                                fontSize: 14,
                                color: onSurface.withValues(alpha: 0.38),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 20,
                                color: primary.withValues(alpha: 0.72),
                              ),
                              suffixIcon: _query.isEmpty
                                  ? null
                                  : IconButton(
                                tooltip: MaterialLocalizations.of(context)
                                    .deleteButtonTooltip,
                                onPressed: () {
                                  _controller.clear();
                                  setState(() {
                                    _query = '';
                                  });
                                  _focusNode.requestFocus();
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 19,
                                  color:
                                  onSurface.withValues(alpha: 0.55),
                                ),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 0.7,
                  color: primary.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: _query.trim().isEmpty
                      ? _buildHint(theme)
                      : matches.isEmpty
                      ? _buildEmpty(theme)
                      : _buildResults(theme, matches),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          widget.searchHint,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerifTc(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          widget.emptyLabel,
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerifTc(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildResults(ThemeData theme, List<dynamic> matches) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
      itemCount: matches.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
            child: Text(
              '${matches.length}',
              style: GoogleFonts.notoSerifTc(
                fontSize: 11,
                color: primary.withValues(alpha: 0.56),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        final message = matches[index - 1];
        final isPlayer = !(message.isAI == true);
        final rawText = (message.text ?? '').toString();

        final parsed = _parseMessageText(rawText);
        final preview = parsed.body.isEmpty ? rawText : parsed.body;
        final dateTime = _messageDateTime(message);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final id = (message.id ?? '').toString();
                if (id.isNotEmpty) {
                  Navigator.pop(context, id);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.13),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(
                        theme,
                        isPlayer: isPlayer,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isPlayer
                                        ? (_playerName.trim().isNotEmpty
                                        ? _playerName
                                        : widget.youLabel)
                                        : widget.characterName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: onSurface.withValues(alpha: 0.82),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (dateTime != null)
                                  Text(
                                    _formatTime(dateTime),
                                    style: GoogleFonts.notoSerifTc(
                                      fontSize: 10,
                                      color: onSurface.withValues(alpha: 0.38),
                                    ),
                                  ),
                              ],
                            ),
                            if (parsed.location.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: primary.withValues(alpha: 0.60),
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      parsed.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.notoSerifTc(
                                        fontSize: 10.5,
                                        color:
                                        primary.withValues(alpha: 0.62),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            _HighlightedText(
                              text: preview,
                              query: _query.trim(),
                              baseStyle: GoogleFonts.notoSerifTc(
                                fontSize: 13.5,
                                color: onSurface.withValues(alpha: 0.82),
                                height: 1.55,
                              ),
                              highlightColor:
                              primary.withValues(alpha: 0.12),
                              highlightTextColor: primary,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: primary.withValues(alpha: 0.48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(
      ThemeData theme, {
        required bool isPlayer,
      }) {
    final primary = theme.colorScheme.primary;

    final ImageProvider? avatarProvider =
    isPlayer ? _playerAvatar : widget.characterAvatar;

    if (avatarProvider != null) {
      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primary.withValues(alpha: 0.18),
          ),
        ),
        child: ClipOval(
          child: Image(
            image: avatarProvider,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => _avatarFallback(
              theme,
              isPlayer: isPlayer,
            ),
          ),
        ),
      );
    }

    return _avatarFallback(
      theme,
      isPlayer: isPlayer,
    );
  }

  Widget _avatarFallback(
      ThemeData theme, {
        required bool isPlayer,
      }) {
    final primary = theme.colorScheme.primary;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primary.withValues(alpha: isPlayer ? 0.08 : 0.12),
        border: Border.all(
          color: primary.withValues(alpha: 0.16),
        ),
      ),
      child: Icon(
        isPlayer ? Icons.person_outline_rounded : Icons.auto_awesome_outlined,
        size: 20,
        color: primary.withValues(alpha: 0.72),
      ),
    );
  }

  DateTime? _messageDateTime(dynamic message) {
    try {
      final dynamic timestamp = message.timestamp;

      if (timestamp == null) return null;

      if (timestamp is DateTime) {
        return timestamp;
      }

      final dynamic converted = timestamp.toDate();

      if (converted is DateTime) {
        return converted;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();

    if (now.year == time.year &&
        now.month == time.month &&
        now.day == time.day) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }

    return '${time.month}/${time.day} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  _ParsedSearchMessage _parseMessageText(String text) {
    String working = text.trim();
    String location = '';

    final locationPattern = RegExp(
      r'(?:地點|地点)\s*[：:]\s*([^\n\r]+)',
      caseSensitive: false,
    );

    final locationMatch = locationPattern.firstMatch(working);

    if (locationMatch != null) {
      location = (locationMatch.group(1) ?? '').trim();
      working = working.replaceFirst(locationMatch.group(0) ?? '', '').trim();
    }

    final timePattern = RegExp(
      r'(?:時間|时间)\s*[：:]\s*[^\n\r]+',
      caseSensitive: false,
    );

    working = working.replaceFirst(timePattern, '').trim();

    return _ParsedSearchMessage(
      location: location,
      body: working,
    );
  }
}

class _ParsedSearchMessage {
  final String location;
  final String body;

  const _ParsedSearchMessage({
    required this.location,
    required this.body,
  });
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;
  final Color highlightColor;
  final Color highlightTextColor;
  final int maxLines;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.highlightColor,
    required this.highlightTextColor,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    final spans = <InlineSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);

      if (index < 0) {
        if (start < text.length) {
          spans.add(
            TextSpan(
              text: text.substring(start),
              style: baseStyle,
            ),
          );
        }
        break;
      }

      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: baseStyle,
          ),
        );
      }

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text.substring(index, index + query.length),
              style: baseStyle.copyWith(
                color: highlightTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );

      start = index + query.length;
    }

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }
}
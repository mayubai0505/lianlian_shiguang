import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/moment_model.dart';
import '../services/app_constants.dart';
import '../utils/moment_search_utils.dart';
import 'moment_card.dart';

class MomentSearchPage extends StatefulWidget {
  final String currentUserId;
  final Future<void> Function(Moment moment) onAvatarTapped;
  final Future<void> Function(Moment moment) onLikeTapped;
  final void Function(String momentId) onDeleteTapped;
  final Future<void> Function(Moment moment) onEditTapped;

  const MomentSearchPage({
    super.key,
    required this.currentUserId,
    required this.onAvatarTapped,
    required this.onLikeTapped,
    required this.onDeleteTapped,
    required this.onEditTapped,
  });

  @override
  State<MomentSearchPage> createState() => _MomentSearchPageState();
}

class _MomentSearchPageState extends State<MomentSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  List<Moment> _results = <Moment>[];
  bool _isSearching = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _search(value);
    });
  }

  Future<void> _search(String rawQuery) async {
    final String normalizedQuery = normalizeMomentSearchText(rawQuery);
    final String lookupKey = buildMomentSearchLookupKey(rawQuery);

    if (normalizedQuery.isEmpty || lookupKey.isEmpty) {
      if (!mounted) return;
      setState(() {
        _results = <Moment>[];
        _isSearching = false;
        _hasSearched = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final results = await Future.wait([
        db
            .collection('artifacts')
            .doc(AppConfig.appId)
            .collection('moments')
            .where('isPublic', isEqualTo: true)
            .where('searchKeywords', arrayContains: lookupKey)
            .limit(100)
            .get(),
        db
            .collection('users')
            .doc(widget.currentUserId)
            .collection('hiddenMoments')
            .get(),
        db
            .collection('users')
            .doc(widget.currentUserId)
            .collection('blockedCharacters')
            .get(),
      ]);

      final QuerySnapshot momentSnapshot = results[0];
      final QuerySnapshot hiddenSnapshot = results[1];
      final QuerySnapshot blockedSnapshot = results[2];
      final Set<String> hiddenMomentIds =
      hiddenSnapshot.docs.map((doc) => doc.id).toSet();
      final Set<String> blockedCharacterIds =
      blockedSnapshot.docs.map((doc) => doc.id).toSet();

      final List<Moment> moments = momentSnapshot.docs
          .map((doc) => Moment.fromFirestore(doc))
          .where((moment) {
        if (hiddenMomentIds.contains(moment.id) ||
            blockedCharacterIds.contains(moment.authorId)) {
          return false;
        }

        final String searchableText = normalizeMomentSearchText(
          '${moment.authorName}${moment.content}',
        );
        return searchableText.contains(normalizedQuery);
      })
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!mounted || _searchController.text.trim() != rawQuery.trim()) return;

      setState(() {
        _results = moments;
        _isSearching = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _results = <Moment>[];
        _isSearching = false;
        _errorMessage = '搜尋暫時無法使用，請稍後再試。';
      });
      debugPrint('搜尋拾光牆失敗：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;
    final Color onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72,
        leadingWidth: 54,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: onSurface.withValues(alpha: 0.80),
            size: 23,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 18),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary.withValues(alpha: 0.20),
              width: 0.9,
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              _onQueryChanged(value);
              setState(() {});
            },
            onSubmitted: _search,
            style: GoogleFonts.notoSerifTc(
              color: onSurface.withValues(alpha: 0.84),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: '搜尋公開貼文、角色或創作者',
              hintStyle: GoogleFonts.notoSerifTc(
                color: onSurface.withValues(alpha: 0.34),
                fontSize: 13.5,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 19,
                color: primary.withValues(alpha: 0.58),
              ),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: onSurface.withValues(alpha: 0.42),
                ),
                onPressed: () {
                  _searchController.clear();
                  _search('');
                  setState(() {});
                },
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final Color primary = theme.colorScheme.primary;
    final Color onSurface = theme.colorScheme.onSurface;

    if (_isSearching) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 1.8,
            color: primary.withValues(alpha: 0.62),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifTc(
              color: theme.colorScheme.error.withValues(alpha: 0.78),
              fontSize: 13.5,
              height: 1.65,
            ),
          ),
        ),
      );
    }

    if (!_hasSearched) {
      return Align(
        alignment: const Alignment(0, -0.28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.045),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.search_rounded,
                  size: 32,
                  color: primary.withValues(alpha: 0.30),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '輸入貼文內容、角色名稱或創作者名稱',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifTc(
                  color: onSurface.withValues(alpha: 0.48),
                  fontSize: 13.5,
                  height: 1.65,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Align(
        alignment: const Alignment(0, -0.28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 42,
                color: primary.withValues(alpha: 0.24),
              ),
              const SizedBox(height: 14),
              Text(
                '找不到相關的公開貼文',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerifTc(
                  color: onSurface.withValues(alpha: 0.48),
                  fontSize: 13.5,
                  height: 1.65,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 20),
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final Moment moment = _results[index];

        return MomentCard(
          moment: moment,
          currentUserId: widget.currentUserId,
          onLikeTapped: () => widget.onLikeTapped(moment),
          onDeleteTapped: () => widget.onDeleteTapped(moment.id),
          onAvatarTapped: () => widget.onAvatarTapped(moment),
          onEditTapped: () => widget.onEditTapped(moment),
        );
      },
    );
  }

}
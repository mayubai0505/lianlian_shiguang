import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.search,
          onChanged: _onQueryChanged,
          onSubmitted: _search,
          decoration: InputDecoration(
            hintText: '搜尋公開貼文、角色或創作者',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                _search('');
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (!_hasSearched) {
      return Center(
        child: Text(
          '輸入貼文內容、角色名稱或創作者名稱',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          '找不到相關的公開貼文',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';
import '../services/reminder_notification_service.dart';

// Session-only cache, isolated by Firebase account and world ID.
// Never persist private memo content into SharedPreferences.
class _WorldMemoSessionCache {
  static final Map<String, List<Map<String, dynamic>>> entries = {};
  static String? key(String? uid, String worldId, String? sessionId) =>
      uid == null ? null : '$uid::$worldId::${sessionId ?? 'legacy'}';
  static List<Map<String, dynamic>> clone(List<Map<String, dynamic>> source) =>
      source.map((m) => Map<String, dynamic>.from(m)).toList();
}

/// World-scoped personal memos. All reads/writes are authorized by Cloud Functions.
class WorldChatMemosPage extends StatefulWidget {
  const WorldChatMemosPage({super.key, required this.worldId, required this.worldName, this.initialMemoId, this.sessionId});
  final String worldId;
  final String worldName;
  final String? initialMemoId;
  final String? sessionId;
  @override
  State<WorldChatMemosPage> createState() => _WorldChatMemosPageState();
}

class _WorldChatMemosPageState extends State<WorldChatMemosPage> {
  late final HttpsCallable _api = FirebaseFunctions.instanceFor(region:'asia-east1')
      .httpsCallable('worldMemo');
  List<Map<String,dynamic>> _memos = [];
  bool _busy = false; // Only blocks writes, not background refreshes.
  bool _initialLoading = false;
  bool _syncing = false;
  String? _error;
  String? _cacheKey;
  int _revision = 0; // Never overwrite newer mutations with older reads.

  @override
  void initState() {
    super.initState();
    _cacheKey = _WorldMemoSessionCache.key(
        FirebaseAuth.instance.currentUser?.uid, widget.worldId, widget.sessionId);
    final cached = _cacheKey == null ? null : _WorldMemoSessionCache.entries[_cacheKey];
    if (cached != null) _memos = _WorldMemoSessionCache.clone(cached);
    _initialLoading = cached == null;
    _refresh();
  }

  void _storeCache() {
    if (_cacheKey != null) {
      _WorldMemoSessionCache.entries[_cacheKey!] =
          _WorldMemoSessionCache.clone(_memos);
    }
  }

  Future<void> _refresh() async {
    if (_syncing) return;
    final readRevision = _revision;
    if (mounted) setState(() {
      _syncing = true;
      // Preserve cached content and avoid replacing it with a loading page.
      if (_memos.isEmpty && _cacheKey != null &&
          !_WorldMemoSessionCache.entries.containsKey(_cacheKey)) {
        _initialLoading = true;
      }
    });
    try {
      final r = await _api.call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId': widget.sessionId, 'action': 'list'});
      final d = Map<String, dynamic>.from(r.data as Map);
      final items = (d['memos'] as List? ?? const [])
          .whereType<Map>()
          .map((m) => Map<String, dynamic>.from(m)).toList();
      if (mounted && _revision == readRevision &&
          _cacheKey == _WorldMemoSessionCache.key(
              FirebaseAuth.instance.currentUser?.uid, widget.worldId, widget.sessionId)) {
        setState(() { _memos = items; _error = null; });
        _storeCache();
      }
    } catch (e) {
      if (mounted) setState(() => _error =
      _memos.isEmpty ? AppLocalizations.of(context)!.world_memo_read_failed1(e.toString()) : AppLocalizations.of(context)!.world_memo_sync_failed1);
    } finally {
      if (mounted) setState(() { _syncing = false; _initialLoading = false; });
    }
  }

  String _notificationMemoId(String memoId) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'signed_out';
    return 'world_${uid}_${widget.worldId}_${widget.sessionId ?? 'legacy'}_$memoId';
  }

  DateTime? _dateOf(dynamic milliseconds) => milliseconds is num
      ? DateTime.fromMillisecondsSinceEpoch(milliseconds.toInt()) : null;

  Future<void> _edit([Map<String,dynamic>? memo]) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => _WorldMemoEditorPage(
        initialContent: (memo?['content'] ?? '').toString(),
        initialReminder: _dateOf(memo?['reminderAt']),
        isEditing: memo != null,
      )),
    );
    if (!mounted || result == null) return;
    setState(() { _busy = true; _error = null; });
    try {
      final response = await _api.call({
        'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId': widget.sessionId,
        'action': memo == null ? 'add' : 'update',
        if (memo != null) 'memoId': memo['id'],
        ...result,
      });
      final data = Map<String, dynamic>.from(response.data as Map);
      final id = (memo?['id'] ?? data['id'] ?? '').toString();
      if (id.isEmpty) throw StateError(AppLocalizations.of(context)!.world_memo_server_no_id1);
      // Server-confirmed write: update visible list without a second full-page load.
      final changed = <String, dynamic>{
        ...?memo, 'id': id, 'content': result['content'],
        'reminderAt': result['reminderAt'],
        'createdAt': memo?['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      };
      if (mounted) setState(() {
        _revision++;
        _memos.removeWhere((m) => m['id'] == id);
        _memos.insert(0, changed);
        _initialLoading = false;
      });
      _storeCache();
      if (memo != null) {
        try {
          await ReminderNotificationService.cancelMemoNotification(
              _notificationMemoId(id));
        } catch (_) { /* Cloud save remains authoritative. */ }
      }
    } catch (e) {
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.world_memo_save_failed1(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(Map<String,dynamic> memo) async {
    final yes = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.world_memo_delete_title1),
      content: Text(AppLocalizations.of(context)!.world_memo_delete_warning1),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: Text(AppLocalizations.of(context)!.world_memo_cancel1)),
        FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(AppLocalizations.of(context)!.world_memo_delete1)),
      ],
    ));
    if (yes != true || !mounted) return;
    setState(() { _busy = true; _error = null; });
    try {
      await _api.call({'worldId': widget.worldId, if (widget.sessionId != null) 'sessionId': widget.sessionId, 'action': 'delete',
        'memoId': memo['id']});
      if (mounted) setState(() {
        _revision++;
        _memos.removeWhere((m) => m['id'] == memo['id']);
      });
      _storeCache();
      try {
        await ReminderNotificationService.cancelMemoNotification(
            _notificationMemoId(memo['id'].toString()));
      } catch (e) {
        if (mounted) setState(() => _error = AppLocalizations.of(context)!.world_memo_cancel_reminder_failed1(e.toString()));
      }
    } catch (e) {
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.world_memo_delete_failed1(e.toString()));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:Text(AppLocalizations.of(context)!.world_memo_title1,style:GoogleFonts.notoSerifTc(fontSize:17))),
    body:Column(children:[
      Padding(padding:const EdgeInsets.all(12),child:Text(AppLocalizations.of(context)!.world_memo_world_personal1(widget.worldName),style:GoogleFonts.notoSerifTc())),
      Padding(padding:const EdgeInsets.symmetric(horizontal:16),child:Text(AppLocalizations.of(context)!.world_memo_sync_notice1,style:const TextStyle(fontSize:12))),
      if(_error != null) Padding(padding:const EdgeInsets.all(10),child:Text(_error!,style:TextStyle(color:Theme.of(context).colorScheme.error))),
      if(_initialLoading || _busy) const LinearProgressIndicator(),
      Expanded(child:_memos.isEmpty ? Center(child:Text(_initialLoading?AppLocalizations.of(context)!.world_memo_loading1:AppLocalizations.of(context)!.world_memo_empty1))
          :ListView.separated(itemCount:_memos.length,separatorBuilder:(_,__)=>const Divider(height:1),
          itemBuilder:(context,i){final m=_memos[i];final date=_dateOf(m['reminderAt']);
          return ListTile(title:Text((m['content']??'').toString(),maxLines:5,overflow:TextOverflow.ellipsis),
              subtitle:date==null?null:Text(AppLocalizations.of(context)!.world_memo_reminder_date1(DateFormat('yyyy/MM/dd HH:mm').format(date))),
              onTap:_busy?null:()=>_edit(m), trailing:IconButton(icon:const Icon(Icons.delete_outline),
                  onPressed:_busy?null:()=>_delete(m)));
          })),
    ]),
    floatingActionButton:FloatingActionButton(onPressed:_busy?null:()=>_edit(),child:const Icon(Icons.add)),
  );
}

/// Full-screen editor for both new and existing world memos.
/// Date/time pickers are system controls; the memo editor itself is not a dialog.
class _WorldMemoEditorPage extends StatefulWidget {
  const _WorldMemoEditorPage({required this.initialContent,
    required this.initialReminder, required this.isEditing});
  final String initialContent;
  final DateTime? initialReminder;
  final bool isEditing;

  @override
  State<_WorldMemoEditorPage> createState() => _WorldMemoEditorPageState();
}

class _WorldMemoEditorPageState extends State<_WorldMemoEditorPage> {
  late final TextEditingController _controller;
  DateTime? _reminder;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
    _reminder = widget.initialReminder;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _chooseReminder() async {
    final now = DateTime.now();
    final seed = _reminder != null && _reminder!.isAfter(now)
        ? _reminder! : now.add(const Duration(minutes: 5));
    final day = await showDatePicker(
      context: context, initialDate: seed,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context, initialTime: TimeOfDay.fromDateTime(seed),
    );
    if (time == null || !mounted) return;
    final next = DateTime(day.year, day.month, day.day, time.hour, time.minute);
    if (!next.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.world_memo_reminder_future1)));
      return;
    }
    setState(() => _reminder = next);
  }

  void _submit() {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.world_memo_content_required1)));
      return;
    }
    Navigator.of(context).pop(<String, dynamic>{
      'content': content,
      'reminderAt': _reminder?.millisecondsSinceEpoch,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? AppLocalizations.of(context)!.world_memo_edit_title1 : AppLocalizations.of(context)!.world_memo_add_title1,
          style: GoogleFonts.notoSerifTc(fontSize: 17))),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text(AppLocalizations.of(context)!.world_memo_content_label1, style: GoogleFonts.notoSerifTc(fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: false,
            minLines: 7, maxLines: 14, maxLength: 2000,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.world_memo_content_hint1,
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.world_memo_reminder_settings1, style: GoogleFonts.notoSerifTc(fontSize: 16)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_month_outlined),
            title: Text(_reminder == null ? AppLocalizations.of(context)!.world_memo_no_reminder1 :
            DateFormat('yyyy/MM/dd HH:mm').format(_reminder!)),
            subtitle: Text(AppLocalizations.of(context)!.world_memo_reminder_choose1),
            trailing: const Icon(Icons.chevron_right),
            onTap: _chooseReminder,
          ),
          if (_reminder != null) Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => setState(() => _reminder = null),
                child: Text(AppLocalizations.of(context)!.world_memo_clear_reminder1)),
          ),
          const SizedBox(height: 28),
          FilledButton(onPressed: _submit, child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12), child: Text(AppLocalizations.of(context)!.world_memo_save1))),
        ],
      )),
    );
  }
}


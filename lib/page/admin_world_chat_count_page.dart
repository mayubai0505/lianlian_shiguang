import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AdminWorldChatCountPage extends StatefulWidget {
  const AdminWorldChatCountPage({super.key});
  @override
  State<AdminWorldChatCountPage> createState() => _AdminWorldChatCountPageState();
}

class _AdminWorldChatCountPageState extends State<AdminWorldChatCountPage> {
  final _functions = FirebaseFunctions.instanceFor(region: 'asia-east1');
  final List<Map<String, dynamic>> _worlds = [];
  final Map<String, Map<String, dynamic>> _jobs = {};
  bool _busy = false;
  bool _stopRequested = false;
  String? _error;
  String _progress = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Map<String, dynamic>> _call(Map<String, dynamic> data) async {
    final result = await _functions.httpsCallable('worldAdminChatCountAudit',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 90))).call(data);
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() { _busy = true; _error = null; _stopRequested = false; });
    try { await action(); }
    catch (e) {
      if (mounted) setState(() => _error = e is FirebaseFunctionsException
          ? (e.message ?? e.code) : '核對失敗：$e');
    } finally {
      if (mounted) setState(() { _busy = false; _progress = ''; });
    }
  }

  Future<void> _load() => _run(() async {
    final rows = <Map<String, dynamic>>[];
    String? cursor;
    do {
      final response = await _call({'action': 'list', if (cursor != null) 'cursor': cursor});
      rows.addAll((response['worlds'] as List? ?? []).whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e)));
      cursor = response['cursor'] as String?;
    } while (cursor != null && mounted && !_stopRequested);
    if (mounted) setState(() { _worlds..clear()..addAll(rows); });
  });

  Future<void> _scanOne(Map<String, dynamic> world) async {
    final id = world['id'] as String;
    final previous = _jobs[id];
    var job = previous != null && previous['status'] == 'scanning'
        ? previous : await _call({'action': 'start', 'worldId': id});
    if (!mounted) return;
    setState(() { _jobs[id] = job; _progress = '正在核對 ${world['name']}'; });
    while (mounted && !_stopRequested && job['status'] == 'scanning') {
      final next = await _call({'action': 'step', 'jobId': job['jobId']});
      job = next;
      if (mounted) setState(() => _jobs[id] = next);
    }
  }

  Future<void> _scanAll() => _run(() async {
    for (final world in _worlds) {
      if (!mounted || _stopRequested) break;
      await _scanOne(world);
    }
  });

  Future<void> _apply(Map<String, dynamic> world, Map<String, dynamic> job) async {
    if (_busy) return;
    final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('確認補正聊天數？'),
      content: Text('${world['name']}\n掃描時已計數：${job['baseline']}\n'
        '可核算訊息：${job['confirmed']}\n本次補正：+${job['delta']}\n\n'
        '掃描期間新增的聊天會保留，同一份結果不會重複補正。'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('確認補正')),
      ],
    ));
    if (confirm != true || !mounted) return;
    await _run(() async {
      final result = await _call({'action': 'apply', 'jobId': job['jobId']});
      if (!mounted) return;
      setState(() { _jobs[world['id']] = result; world['count'] = result['appliedCount']; });
    });
  }

  Widget _worldCard(Map<String, dynamic> world) {
    final job = _jobs[world['id']];
    final status = job?['status'];
    final ready = status == 'ready';
    final delta = (job?['delta'] as num?)?.toInt() ?? 0;
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(world['name']?.toString() ?? '未命名世界', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text('列表讀取時的計數：${world['count'] ?? 0}'),
        if (job != null) ...[
          Text('掃描基準：${job['baseline']}　可核算：${job['confirmed']}'),
          Text('已檢查 ${job['roomsChecked']} 間聊天室、${job['scanned']} 則訊息'),
          if ((job['uncertain'] as num? ?? 0) > 0)
            Text('有 ${job['uncertain']} 則舊格式／缺少日期的訊息待核對，未自動計入。'),
          if (ready) Text(delta > 0 ? '可補正：+$delta' : '無需增加，保留既有計數'),
          if (status == 'scanning') const Text('尚未掃描完，可按繼續掃描。'),
          if (status == 'applied') Text('已完成補正，計數：${job['appliedCount']}'),
        ],
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          OutlinedButton(onPressed: _busy ? null : () => _run(() => _scanOne(world)),
            child: Text(status == 'scanning' ? '繼續掃描' : '掃描此世界')),
          if (ready && delta > 0) FilledButton(
            onPressed: _busy ? null : () => _apply(world, job!), child: const Text('確認補正')),
        ]),
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('開放世界聊天數核對')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('先掃描，再確認補正。只核算公開聊天中的玩家文字訊息；私人試玩、AI 回覆與互動玩法不計入。'),
        const SizedBox(height: 8),
        const Text('已刪除的訊息無法重建；無法判定的舊格式會另外標示，既有計數不會被調低。'),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          FilledButton.icon(onPressed: _busy || _worlds.isEmpty ? null : _scanAll,
            icon: const Icon(Icons.search), label: const Text('掃描全部世界')),
          OutlinedButton(onPressed: _busy ? null : _load, child: const Text('重新載入列表')),
          if (_busy && _progress.startsWith('正在核對')) TextButton(onPressed: () => setState(() => _stopRequested = true), child: const Text('暫停掃描')),
        ]),
        if (_busy) ...[const SizedBox(height: 12), const LinearProgressIndicator(), Text(_progress.isEmpty ? '處理中…' : _progress)],
        if (_error != null) Padding(padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        if (!_busy && _worlds.isEmpty && _error == null) const Text('目前沒有可核對的公開世界。'),
        const SizedBox(height: 12),
        ..._worlds.map(_worldCard),
      ]),
    );
  }
}

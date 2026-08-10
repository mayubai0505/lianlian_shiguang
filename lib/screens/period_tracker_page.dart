import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/theme_notifier.dart';
import '../services/toast_utils.dart';
import 'character_model.dart';

class PeriodRecord {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final bool isOngoing;
  final String mood;

  const PeriodRecord({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.isOngoing = false,
    this.mood = '',
  });

  factory PeriodRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final startDate = (data['startDate'] as Timestamp).toDate();
    final endTimestamp = data['endDate'] as Timestamp?;

    return PeriodRecord(
      id: doc.id,
      startDate: startDate,
      endDate: endTimestamp?.toDate() ?? startDate,
      isOngoing: data['isOngoing'] == true,
      mood: data['mood']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'startDate': Timestamp.fromDate(startDate),
    'endDate': Timestamp.fromDate(endDate),
    'isOngoing': isOngoing,
    'mood': mood,
  };
}

enum _PeriodAction { none, start, continuePeriod, end }

class PeriodTrackerPage extends StatefulWidget {
  final Character character;

  const PeriodTrackerPage({
    super.key,
    required this.character,
  });

  @override
  State<PeriodTrackerPage> createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  _PeriodAction _selectedAction = _PeriodAction.none;

  final Set<String> _selectedMoods = <String>{};
  final Set<String> _selectedSymptoms = <String>{};
  final TextEditingController _customMoodController = TextEditingController();
  final TextEditingController _customSymptomController =
  TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isLoadingDay = false;
  bool _isSaving = false;
  List<DateTime> _predictedDays = <DateTime>[];
  List<DateTime> _currentPeriodForecastDays = <DateTime>[];
  List<DateTime> _previewForecastDays = <DateTime>[];
  int _averageCycleDays = 28;
  int _averagePeriodDays = 5;

  static const List<MapEntry<String, String>> _moods = [
    MapEntry('😊', '還不錯'),
    MapEntry('🥰', '開心'),
    MapEntry('😔', '低落'),
    MapEntry('😫', '難受'),
    MapEntry('😡', '煩躁'),
    MapEntry('😴', '疲倦'),
    MapEntry('😰', '焦慮'),
  ];

  static const List<String> _symptoms = [
    '腹痛',
    '腰痠',
    '頭痛',
    '胸脹',
    '水腫',
    '想睡',
    '食慾增加',
    '腸胃不適',
  ];

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<PeriodRecord> get _recordsCollection =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId ?? 'dummy')
          .collection('characters')
          .doc(widget.character.id)
          .collection('period_tracker')
          .withConverter<PeriodRecord>(
        fromFirestore: (snapshot, _) =>
            PeriodRecord.fromFirestore(snapshot),
        toFirestore: (record, _) => record.toJson(),
      );

  CollectionReference<Map<String, dynamic>> get _dailyLogsCollection =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId ?? 'dummy')
          .collection('characters')
          .doc(widget.character.id)
          .collection('period_daily_logs');

  CollectionReference<Map<String, dynamic>> get _rawRecordsCollection =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_userId ?? 'dummy')
          .collection('characters')
          .doc(widget.character.id)
          .collection('period_tracker');

  String _dayId(DateTime day) => DateFormat('yyyyMMdd').format(day);

  DateTime _dateOnly(DateTime day) => DateTime(day.year, day.month, day.day);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDayLog(_selectedDay);
      await _showFirstUseGuide();
    });
  }

  @override
  void dispose() {
    _customMoodController.dispose();
    _customSymptomController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _showFirstUseGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('seen_period_tracker_guide_v2') ?? false;
    if (!hasSeen && mounted) {
      await _showGuide();
      await prefs.setBool('seen_period_tracker_guide_v2', true);
    }
  }

  Future<void> _showGuide() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.water_drop_outlined,
              color: Colors.redAccent,
              size: 24,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '生理期日記怎麼用？',
                style: TextStyle(fontSize: 19),
              ),
            ),
          ],
        ),
        content: const Text(
          '① 先點選月曆上的日期。\n'
              '② 選擇「今天來了」、「仍在生理期」或「今天結束」。\n'
              '③ 勾選當天心情與身體狀態，也可以自行補充。\n'
              '④ 按下儲存，角色就能在聊天時理解你今天的狀態。\n\n'
              '預測日期會依你的歷史紀錄調整，僅供生活紀錄參考。',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadDayLog(DateTime day) async {
    if (_userId == null) return;
    setState(() {
      _isLoadingDay = true;
      _selectedAction = _PeriodAction.none;
      _selectedMoods.clear();
      _selectedSymptoms.clear();
      _previewForecastDays = <DateTime>[];
      _customMoodController.clear();
      _customSymptomController.clear();
      _noteController.clear();
    });

    try {
      final snapshot = await _dailyLogsCollection.doc(_dayId(day)).get();
      final data = snapshot.data();

      if (!mounted) return;
      setState(() {
        _selectedMoods
          ..clear()
          ..addAll(List<String>.from(data?['moods'] ?? const []));
        _selectedSymptoms
          ..clear()
          ..addAll(List<String>.from(data?['symptoms'] ?? const []));
        _customMoodController.text = data?['customMood']?.toString() ?? '';
        _customSymptomController.text =
            data?['customSymptom']?.toString() ?? '';
        _noteController.text = data?['note']?.toString() ?? '';
        _selectedAction = _PeriodAction.none;
      });
    } catch (e) {
      debugPrint('❌ 讀取生理期單日紀錄失敗：$e');
    } finally {
      if (mounted) setState(() => _isLoadingDay = false);
    }
  }

  void _calculateStatistics(List<PeriodRecord> records) {
    if (records.isEmpty) {
      _averageCycleDays = 28;
      _averagePeriodDays = 5;
      _predictedDays = <DateTime>[];
      _currentPeriodForecastDays = <DateTime>[];
      return;
    }

    final sorted = [...records]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final cycleLengths = <int>[];
    for (var i = 1; i < sorted.length; i++) {
      final days = _dateOnly(sorted[i].startDate)
          .difference(_dateOnly(sorted[i - 1].startDate))
          .inDays;
      if (days >= 15 && days <= 60) cycleLengths.add(days);
    }

    final completedDurations = sorted
        .where((record) => !record.isOngoing)
        .map((record) =>
    _dateOnly(record.endDate)
        .difference(_dateOnly(record.startDate))
        .inDays +
        1)
        .where((days) => days >= 1 && days <= 15)
        .toList();

    _averageCycleDays = cycleLengths.isEmpty
        ? 28
        : (cycleLengths.reduce((a, b) => a + b) / cycleLengths.length)
        .round();
    _averagePeriodDays = completedDurations.isEmpty
        ? 5
        : (completedDurations.reduce((a, b) => a + b) /
        completedDurations.length)
        .round();

    final nextStart = _dateOnly(sorted.last.startDate)
        .add(Duration(days: _averageCycleDays));
    _predictedDays = List.generate(
      _averagePeriodDays,
          (index) => nextStart.add(Duration(days: index)),
    );

    final ongoing = sorted.cast<PeriodRecord?>().firstWhere(
          (record) => record?.isOngoing == true,
      orElse: () => null,
    );
    _currentPeriodForecastDays = ongoing == null
        ? <DateTime>[]
        : List.generate(
      7,
          (index) =>
          _dateOnly(ongoing.startDate).add(Duration(days: index)),
    );
  }

  Future<PeriodRecord?> _findOngoingRecord() async {
    final snapshot = await _recordsCollection
        .orderBy('startDate', descending: true)
        .limit(20)
        .get();

    for (final doc in snapshot.docs) {
      final record = doc.data();
      if (record.isOngoing) return record;
    }
    return null;
  }

  Future<void> _saveDayLog() async {
    if (_userId == null || _isSaving) return;

    final hasContent = _selectedAction != _PeriodAction.none ||
        _selectedMoods.isNotEmpty ||
        _selectedSymptoms.isNotEmpty ||
        _customMoodController.text.trim().isNotEmpty ||
        _customSymptomController.text.trim().isNotEmpty ||
        _noteController.text.trim().isNotEmpty;

    if (!hasContent) {
      ToastUtils.showCenterToast(
        context,
        '請至少選擇一項紀錄',
        isError: true,
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final selectedDate = _dateOnly(_selectedDay);
      final today = _dateOnly(DateTime.now());
      final ongoing = await _findOngoingRecord();
      final batch = FirebaseFirestore.instance.batch();

      if (_selectedAction != _PeriodAction.none &&
          selectedDate.isAfter(today)) {
        throw StateError('未來日期不能標記生理期狀態。');
      }

      switch (_selectedAction) {
        case _PeriodAction.none:
          break;
        case _PeriodAction.start:
          if (ongoing != null) {
            throw StateError('已有一筆進行中的生理期，請先將它結束。');
          }
          final newPeriodRef = _rawRecordsCollection.doc();
          batch.set(newPeriodRef, {
            'startDate': Timestamp.fromDate(selectedDate),
            'endDate': Timestamp.fromDate(selectedDate),
            'isOngoing': true,
            'mood': '',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
          break;
        case _PeriodAction.continuePeriod:
          if (ongoing == null) {
            throw StateError('目前沒有進行中的生理期，請先選擇「今天來了」。');
          }
          if (selectedDate.isBefore(_dateOnly(ongoing.startDate))) {
            throw StateError('日期不能早於本次生理期開始日。');
          }
          batch.update(_rawRecordsCollection.doc(ongoing.id), {
            'endDate': Timestamp.fromDate(selectedDate),
            'isOngoing': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          break;
        case _PeriodAction.end:
          if (ongoing == null) {
            throw StateError('目前沒有進行中的生理期，請先選擇「今天來了」。');
          }
          if (selectedDate.isBefore(_dateOnly(ongoing.startDate))) {
            throw StateError('結束日期不能早於開始日期。');
          }
          batch.update(_rawRecordsCollection.doc(ongoing.id), {
            'endDate': Timestamp.fromDate(selectedDate),
            'isOngoing': false,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          break;
      }

      batch.set(_dailyLogsCollection.doc(_dayId(_selectedDay)), {
        'date': Timestamp.fromDate(_dateOnly(_selectedDay)),
        'moods': _selectedMoods.toList(),
        'symptoms': _selectedSymptoms.toList(),
        'customMood': _customMoodController.text.trim(),
        'customSymptom': _customSymptomController.text.trim(),
        'note': _noteController.text.trim(),
        'periodAction': _selectedAction.name,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      if (!mounted) return;
      setState(() {
        _selectedAction = _PeriodAction.none;
        _previewForecastDays = <DateTime>[];
      });
      ToastUtils.showCenterToast(
        context,
        '${DateFormat('M 月 d 日').format(_selectedDay)}的紀錄已儲存',
        customIcon: Icons.favorite_rounded,
      );
    } on StateError catch (e) {
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        e.message.toString(),
        isError: true,
      );
    } catch (e) {
      debugPrint('❌ 儲存生理期日記失敗：$e');
      if (!mounted) return;
      ToastUtils.showCenterToast(
        context,
        '儲存失敗，請稍後再試（請查看偵錯訊息）',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteRecord(String recordId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除這次生理期紀錄？'),
        content: const Text('刪除後，週期平均與下次預測也會重新計算。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('刪除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _recordsCollection.doc(recordId).delete();
    }
  }

  Widget _buildOverviewCard(
      ThemeData theme,
      List<PeriodRecord> records,
      ) {
    final ongoing = records.cast<PeriodRecord?>().firstWhere(
          (record) => record?.isOngoing == true,
      orElse: () => null,
    );
    final nextDate = _predictedDays.isEmpty ? null : _predictedDays.first;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.85),
            theme.colorScheme.surface.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_rounded, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ongoing == null
                      ? '目前沒有進行中的生理期'
                      : '生理期第 ${DateTime.now().difference(_dateOnly(ongoing.startDate)).inDays + 1} 天',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: '使用說明',
                onPressed: _showGuide,
                icon: const Icon(Icons.help_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _statChip('平均週期', '$_averageCycleDays 天'),
              _statChip('平均經期', '$_averagePeriodDays 天'),
              _statChip(
                '下次預測',
                nextDate == null ? '紀錄後推算' : DateFormat('M/d').format(nextDate),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            records.length < 2
                ? '目前資料不足，暫以 28 天週期、5 天經期推估。'
                : '依現有紀錄推估，日期僅供生活紀錄參考。',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text('$label　$value'),
  );

  Widget _buildActionSelector(
      ThemeData theme,
      List<PeriodRecord> records,
      ) {
    final ongoing = records.cast<PeriodRecord?>().firstWhere(
          (record) => record?.isOngoing == true,
      orElse: () => null,
    );
    final selectedDate = _dateOnly(_selectedDay);
    final today = _dateOnly(DateTime.now());
    final isFutureDate = selectedDate.isAfter(today);
    final isBeforeOngoingStart = ongoing != null &&
        selectedDate.isBefore(_dateOnly(ongoing.startDate));

    // 沒有進行中的週期時，只能開始一筆新紀錄。
    // 週期進行中時隱藏「今天來了」，避免每點一天就重新往後推七天。
    // 未來日期或早於本次開始日的日期，不允許標記仍在生理期或結束。
    final actions = <MapEntry<_PeriodAction, String>>[
      if (ongoing == null && !isFutureDate)
        const MapEntry(_PeriodAction.start, '🩸 今天來了'),
      if (ongoing != null && !isFutureDate && !isBeforeOngoingStart) ...[
        const MapEntry(_PeriodAction.continuePeriod, '仍在生理期'),
        const MapEntry(_PeriodAction.end, '今天結束'),
      ],
    ];

    if (actions.isEmpty) {
      final message = isFutureDate
          ? '這天還沒到喔～'
          : '這一天早於目前生理期的開始日期。';
      return Text(
        message,
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions.map((entry) {
        return ChoiceChip(
          label: Text(entry.value),
          selected: _selectedAction == entry.key,
          onSelected: (selected) {
            setState(() {
              _selectedAction = selected ? entry.key : _PeriodAction.none;

              // 玩家點下「今天來了」後，立即在月曆預覽接下來七天；
              // 正式資料仍會在按下「儲存今日紀錄」後一次寫入。
              if (selected && entry.key == _PeriodAction.start) {
                _previewForecastDays = List.generate(
                  7,
                      (index) =>
                      _dateOnly(_selectedDay).add(Duration(days: index)),
                );
              } else if (!selected && entry.key == _PeriodAction.start) {
                _previewForecastDays = <DateTime>[];
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildMoodSelector() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _moods.map((entry) {
      return FilterChip(
        label: Text('${entry.key} ${entry.value}'),
        selected: _selectedMoods.contains(entry.value),
        onSelected: (selected) {
          setState(() {
            selected
                ? _selectedMoods.add(entry.value)
                : _selectedMoods.remove(entry.value);
          });
        },
      );
    }).toList(),
  );

  Widget _buildSymptomSelector() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _symptoms.map((symptom) {
      return FilterChip(
        label: Text(symptom),
        selected: _selectedSymptoms.contains(symptom),
        onSelected: (selected) {
          setState(() {
            selected
                ? _selectedSymptoms.add(symptom)
                : _selectedSymptoms.remove(symptom);
          });
        },
      );
    }).toList(),
  );

  Widget _sectionCard({
    required ThemeData theme,
    required String title,
    required Widget child,
    String? subtitle,
  }) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('${widget.character.name}的貼心日記'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot<PeriodRecord>>(
          stream: _recordsCollection
              .orderBy('startDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('讀取紀錄失敗，請稍後再試'));
            }

            final records = snapshot.data?.docs
                .map((document) => document.data())
                .toList() ??
                <PeriodRecord>[];
            _calculateStatistics(records);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 36),
              child: Column(
                children: [
                  _buildOverviewCard(theme, records),
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TableCalendar(
                      locale: 'zh_TW',
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2035, 12, 31),
                      focusedDay: _focusedDay,
                      availableGestures: AvailableGestures.horizontalSwipe,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _selectedDay),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = _dateOnly(selectedDay);
                          _focusedDay = focusedDay;
                        });
                        _loadDayLog(selectedDay);
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      daysOfWeekHeight: 32,
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.2,
                        ),
                        weekendStyle: const TextStyle(
                          color: Color(0xFFD47A91),
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        dowBuilder: (context, day) {
                          const labels = <String>[
                            '日',
                            '一',
                            '二',
                            '三',
                            '四',
                            '五',
                            '六',
                          ];
                          final isWeekend = day.weekday == DateTime.saturday ||
                              day.weekday == DateTime.sunday;
                          return Center(
                            child: Text(
                              labels[day.weekday % 7],
                              style: TextStyle(
                                color: isWeekend
                                    ? const Color(0xFFD47A91)
                                    : theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        prioritizedBuilder: (context, date, focusedDay) {
                          final isActualPeriod = records.any(
                                (record) =>
                            !date.isBefore(_dateOnly(record.startDate)) &&
                                !date.isAfter(_dateOnly(record.endDate)),
                          );

                          final isCurrentForecast = [
                            ..._currentPeriodForecastDays,
                            ..._previewForecastDays,
                          ].any((day) => isSameDay(day, date));

                          final isNextPrediction = _predictedDays
                              .any((day) => isSameDay(day, date));

                          if (!isActualPeriod &&
                              !isCurrentForecast &&
                              !isNextPrediction) {
                            return null;
                          }

                          final isSelected = isSameDay(date, _selectedDay);
                          final isPeriodRelated =
                              isActualPeriod || isCurrentForecast;
                          final backgroundColor = isPeriodRelated
                              ? Colors.transparent
                              : primaryColor.withValues(alpha: 0.16);
                          final textColor = isPeriodRelated
                              ? const Color(0xFFB85C74)
                              : primaryColor;

                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                color: primaryColor,
                                width: 2,
                              )
                                  : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isPeriodRelated)
                                  Icon(
                                    Icons.local_florist_rounded,
                                    size: 39,
                                    color: isActualPeriod
                                        ? const Color(0xFFF29AAF)
                                        .withValues(alpha: 0.68)
                                        : const Color(0xFFFFB8C8)
                                        .withValues(alpha: 0.48),
                                  ),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor),
                        ),
                        todayTextStyle: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: DateFormat('yyyy 年 M 月 d 日').format(_selectedDay),
                    subtitle: '選擇狀態後，請按最下方「儲存今日紀錄」才會正式保存。',
                    child: _buildActionSelector(theme, records),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: '今天的心情（可複選）',
                    subtitle: '這些是當天日記，不是貼到月曆上的圖示。',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMoodSelector(),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customMoodController,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            labelText: '其他心情',
                            hintText: '例如：委屈、沒安全感……',
                            prefixIcon: Icon(Icons.add_reaction_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: '今天的身體狀態（可複選）',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSymptomSelector(),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customSymptomController,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            labelText: '其他身體狀態',
                            hintText: '例如：怕冷、沒有胃口……',
                            prefixIcon: Icon(Icons.edit_note_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: '想讓 ${widget.character.name} 知道的事（選填）',
                    child: TextField(
                      controller: _noteController,
                      minLines: 2,
                      maxLines: 4,
                      maxLength: 120,
                      decoration: const InputDecoration(
                        hintText: '例如：今天想安靜休息，不想被催……',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                    child: FilledButton.icon(
                      onPressed: (_isSaving || _isLoadingDay)
                          ? null
                          : _saveDayLog,
                      icon: _isSaving
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.favorite_outline_rounded),
                      label: Text(_isSaving ? '儲存中…' : '儲存今日紀錄'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                      ),
                    ),
                  ),
                  if (records.isNotEmpty) ...[
                    const Divider(indent: 24, endIndent: 24),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '歷史生理期',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ...records.map(
                          (record) => Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.water_drop_rounded,
                            color: Colors.redAccent,
                          ),
                          title: Text(
                            '${DateFormat('yyyy/MM/dd').format(record.startDate)}－${DateFormat('MM/dd').format(record.endDate)}',
                          ),
                          subtitle: Text(
                            record.isOngoing
                                ? '進行中'
                                : '共 ${record.endDate.difference(_dateOnly(record.startDate)).inDays + 1} 天',
                          ),
                          trailing: IconButton(
                            tooltip: '刪除紀錄',
                            onPressed: () => _deleteRecord(record.id),
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


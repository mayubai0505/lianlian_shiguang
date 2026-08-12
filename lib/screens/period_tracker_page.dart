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
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.water_drop_outlined,
              color: Colors.redAccent,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.periodGuideTitle,
                style: const TextStyle(fontSize: 19),
              ),
            ),
          ],
        ),
        content: Text(l10n.periodGuideContent),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.periodGotIt),
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
    final l10n = AppLocalizations.of(context)!;

    final hasContent = _selectedAction != _PeriodAction.none ||
        _selectedMoods.isNotEmpty ||
        _selectedSymptoms.isNotEmpty ||
        _customMoodController.text.trim().isNotEmpty ||
        _customSymptomController.text.trim().isNotEmpty ||
        _noteController.text.trim().isNotEmpty;

    if (!hasContent) {
      ToastUtils.showCenterToast(
        context,
        l10n.periodSelectAtLeastOne,
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
        throw StateError(l10n.periodFutureDateError);
      }

      switch (_selectedAction) {
        case _PeriodAction.none:
          break;
        case _PeriodAction.start:
          if (ongoing != null) {
            throw StateError(l10n.periodAlreadyOngoingError);
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
            throw StateError(l10n.periodNoOngoingError);
          }
          if (selectedDate.isBefore(_dateOnly(ongoing.startDate))) {
            throw StateError(l10n.periodBeforeStartError);
          }
          batch.update(_rawRecordsCollection.doc(ongoing.id), {
            'endDate': Timestamp.fromDate(selectedDate),
            'isOngoing': true,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          break;
        case _PeriodAction.end:
          if (ongoing == null) {
            throw StateError(l10n.periodNoOngoingError);
          }
          if (selectedDate.isBefore(_dateOnly(ongoing.startDate))) {
            throw StateError(l10n.periodEndBeforeStartError);
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
        l10n.periodRecordSaved(
          DateFormat.yMMMd(Localizations.localeOf(context).toString())
              .format(_selectedDay),
        ),
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
        l10n.periodSaveFailed,
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteRecord(String recordId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.periodDeleteTitle),
        content: Text(l10n.periodDeleteContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.periodCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.periodDelete, style: const TextStyle(color: Colors.red)),
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
    final l10n = AppLocalizations.of(context)!;

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
                      ? l10n.periodNoOngoing
                      : l10n.periodDayCount(
                    DateTime.now().difference(_dateOnly(ongoing.startDate)).inDays + 1,
                  ),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.periodHelp,
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
              _statChip(l10n.periodAverageCycle, l10n.periodDays(_averageCycleDays)),
              _statChip(l10n.periodAverageDuration, l10n.periodDays(_averagePeriodDays)),
              _statChip(
                l10n.periodNextPrediction,
                nextDate == null
                    ? l10n.periodCalculatedAfterRecording
                    : DateFormat.yMd(Localizations.localeOf(context).toString()).format(nextDate),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            records.length < 2
                ? l10n.periodInsufficientData
                : l10n.periodPredictionDisclaimer,
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
    final l10n = AppLocalizations.of(context)!;

    // 沒有進行中的週期時，只能開始一筆新紀錄。
    // 週期進行中時隱藏「今天來了」，避免每點一天就重新往後推七天。
    // 未來日期或早於本次開始日的日期，不允許標記仍在生理期或結束。
    final actions = <MapEntry<_PeriodAction, String>>[
      if (ongoing == null && !isFutureDate)
        MapEntry(_PeriodAction.start, l10n.periodStartedToday),
      if (ongoing != null && !isFutureDate && !isBeforeOngoingStart) ...[
        MapEntry(_PeriodAction.continuePeriod, l10n.periodStillOngoing),
        MapEntry(_PeriodAction.end, l10n.periodEndedToday),
      ],
    ];

    if (actions.isEmpty) {
      final message = isFutureDate
          ? l10n.periodDateNotReached
          : l10n.periodDateBeforeStart;
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

  String _localizedMood(String mood) {
    final l10n = AppLocalizations.of(context)!;
    return switch (mood) {
      '還不錯' => l10n.periodMoodOkay,
      '開心' => l10n.periodMoodHappy,
      '低落' => l10n.periodMoodLow,
      '難受' => l10n.periodMoodUnwell,
      '煩躁' => l10n.periodMoodIrritable,
      '疲倦' => l10n.periodMoodTired,
      '焦慮' => l10n.periodMoodAnxious,
      _ => mood,
    };
  }

  String _localizedSymptom(String symptom) {
    final l10n = AppLocalizations.of(context)!;
    return switch (symptom) {
      '腹痛' => l10n.periodSymptomAbdominalPain,
      '腰痠' => l10n.periodSymptomLowerBackPain,
      '頭痛' => l10n.periodSymptomHeadache,
      '胸脹' => l10n.periodSymptomBreastTenderness,
      '水腫' => l10n.periodSymptomSwelling,
      '想睡' => l10n.periodSymptomSleepy,
      '食慾增加' => l10n.periodSymptomIncreasedAppetite,
      '腸胃不適' => l10n.periodSymptomDigestiveDiscomfort,
      _ => symptom,
    };
  }

  Widget _buildMoodSelector() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: _moods.map((entry) {
      return FilterChip(
        label: Text('${entry.key} ${_localizedMood(entry.value)}'),
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
        label: Text(_localizedSymptom(symptom)),
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
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.periodDiaryTitle(widget.character.name)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot<PeriodRecord>>(
          stream: _recordsCollection
              .orderBy('startDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(l10n.periodLoadFailed));
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
                      locale: localeName,
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
                          final labels = <String>[
                            l10n.periodWeekdaySun,
                            l10n.periodWeekdayMon,
                            l10n.periodWeekdayTue,
                            l10n.periodWeekdayWed,
                            l10n.periodWeekdayThu,
                            l10n.periodWeekdayFri,
                            l10n.periodWeekdaySat,
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
                    title: DateFormat.yMMMMd(localeName).format(_selectedDay),
                    subtitle: l10n.periodSaveInstruction,
                    child: _buildActionSelector(theme, records),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: l10n.periodTodayMood,
                    subtitle: l10n.periodMoodDescription,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMoodSelector(),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customMoodController,
                          maxLength: 30,
                          decoration: InputDecoration(
                            labelText: l10n.periodOtherMood,
                            hintText: l10n.periodOtherMoodHint,
                            prefixIcon: const Icon(Icons.add_reaction_outlined),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: l10n.periodTodaySymptoms,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSymptomSelector(),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customSymptomController,
                          maxLength: 30,
                          decoration: InputDecoration(
                            labelText: l10n.periodOtherSymptom,
                            hintText: l10n.periodOtherSymptomHint,
                            prefixIcon: const Icon(Icons.edit_note_rounded),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sectionCard(
                    theme: theme,
                    title: l10n.periodNoteForCharacter(widget.character.name),
                    child: TextField(
                      controller: _noteController,
                      minLines: 2,
                      maxLines: 4,
                      maxLength: 120,
                      decoration: InputDecoration(
                        hintText: l10n.periodNoteHint,
                        border: const OutlineInputBorder(),
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
                      label: Text(_isSaving ? l10n.periodSaving : l10n.periodSaveToday),
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
                          l10n.periodHistory,
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
                                ? l10n.periodOngoing
                                : l10n.periodTotalDays(
                              record.endDate.difference(_dateOnly(record.startDate)).inDays + 1,
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: l10n.periodDeleteRecord,
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
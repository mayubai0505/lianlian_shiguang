import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_notifier.dart';
import 'character_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_notifier.dart';
import 'character_model.dart';
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// ✨ PeriodRecord 模型 (確保資料格式正確)
class PeriodRecord {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String mood;

  PeriodRecord({required this.id, required this.startDate, required this.endDate, this.mood = '😊'});

  factory PeriodRecord.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PeriodRecord(
      id: doc.id,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      mood: data['mood'] ?? '😊',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'mood': mood,
    };
  }
}

class PeriodTrackerPage extends StatefulWidget {
  final Character character;
  const PeriodTrackerPage({super.key, required this.character});

  @override
  State<PeriodTrackerPage> createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDay;
  DateTime? _selectedEndDay;
  String _selectedMood = '😊';
  final List<String> _moods = ['😊', '🥰', '😔', '😫', '😡', '😴'];

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // ✨ 資料庫路徑 (對齊角色子集合)
  CollectionReference<PeriodRecord> get _recordsCollection {
    return FirebaseFirestore.instance
        .collection('users').doc(_userId ?? 'dummy')
        .collection('characters').doc(widget.character.id)
        .collection('period_tracker')
        .withConverter<PeriodRecord>(
      fromFirestore: (snapshot, _) => PeriodRecord.fromFirestore(snapshot),
      toFirestore: (record, _) => record.toJson(),
    );
  }

  // ✨ 預測邏輯
  List<DateTime> _predictedDays = [];
  void _calculatePrediction(List<PeriodRecord> records) {
    if (records.length < 2) return;
    int totalDays = 0;
    for (int i = 0; i < records.length - 1; i++) {
      totalDays += records[i].startDate.difference(records[i + 1].startDate).inDays.abs();
    }
    int avgCycle = totalDays ~/ (records.length - 1);
    DateTime nextStart = records.first.startDate.add(Duration(days: avgCycle));
    _predictedDays = List.generate(5, (index) => nextStart.add(Duration(days: index)));
  }

  // ✨ 儲存紀錄邏輯
  Future<void> _saveRecord() async {
    if (_selectedStartDay == null || _selectedEndDay == null) return;
    final startDate = _selectedStartDay!.isBefore(_selectedEndDay!) ? _selectedStartDay! : _selectedEndDay!;
    final endDate = _selectedStartDay!.isAfter(_selectedEndDay!) ? _selectedStartDay! : _selectedEndDay!;

    await _recordsCollection.add(PeriodRecord(
      id: '', startDate: startDate, endDate: endDate, mood: _selectedMood,
    ));

    setState(() { _selectedStartDay = null; _selectedEndDay = null; });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${widget.character.name}：「我都記下來了，這幾天辛苦妳了，我會一直在妳身邊的。」'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    }
  }

  // ✨ 刪除功能
  Future<void> _deleteRecord(String recordId) async {
    final l10n = AppLocalizations.of(context)!;

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('要刪除這筆紀錄嗎？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child:Text(l10n.cancelButton
          )),
          TextButton(onPressed: () => Navigator.pop(context, true), child:Text(l10n.delete_btn, style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) await _recordsCollection.doc(recordId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final primaryColor = theme.colorScheme.primary;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: themeNotifier.currentBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('${widget.character.name} 的關心日曆'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme.colorScheme.onSurface,
        ),
        body: StreamBuilder<QuerySnapshot<PeriodRecord>>(
          stream: _recordsCollection.orderBy('startDate', descending: true).snapshots(),
          builder: (context, snapshot) {
            List<PeriodRecord> records = [];
            if (snapshot.hasData) {
              records = snapshot.data!.docs.map((doc) => doc.data()).toList();
              _calculatePrediction(records);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  // ✨ 日曆卡片 (毛玻璃感)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(isDarkMode ? 0.7 : 0.4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TableCalendar(
                      locale: 'zh_TW',
                      firstDay: DateTime.utc(2024, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      rangeSelectionMode: RangeSelectionMode.toggledOn,
                      rangeStartDay: _selectedStartDay,
                      rangeEndDay: _selectedEndDay,
                      onRangeSelected: (start, end, focusedDay) => setState(() {
                        _selectedStartDay = start; _selectedEndDay = end; _focusedDay = focusedDay;
                      }),
                      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      calendarBuilders: CalendarBuilders(
                        // 紀錄日標記：小葉子 eco
                        markerBuilder: (context, date, events) {
                          bool isPeriod = records.any((r) =>
                          (date.isAfter(r.startDate) || isSameDay(date, r.startDate)) &&
                              (date.isBefore(r.endDate) || isSameDay(date, r.endDate)));
                          if (isPeriod) {
                            return const Positioned(
                              bottom: 4,
                              child: Icon(Icons.eco, size: 12, color: Colors.green),
                            );
                          }
                          return null;
                        },
                        // 預測日：主題色透明圓圈
                        defaultBuilder: (context, date, _) {
                          if (_predictedDays.any((d) => isSameDay(d, date))) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), shape: BoxShape.circle),
                              child: Center(child: Text('${date.day}', style: TextStyle(color: primaryColor))),
                            );
                          }
                          return null;
                        },
                      ),
                      calendarStyle: CalendarStyle(
                        rangeHighlightColor: primaryColor.withOpacity(0.2),
                        rangeStartDecoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        rangeEndDecoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor.withOpacity(0.5))
                        ),
                      ),
                    ),
                  ),

                  // --- 心情區 (全自動縮放版) ---
                  const Text('今天的心情如何？', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

// ✨ FittedBox 是自動偵測的神器
                  SizedBox(
                    width: double.infinity, // 佔滿螢幕寬度
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // 關鍵：如果太寬就縮小，如果不寬就維持原樣
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _moods.map((m) => GestureDetector(
                          onTap: () => setState(() => _selectedMood = m),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: _selectedMood == m ? theme.colorScheme.primary.withOpacity(0.3) : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(m, style: const TextStyle(fontSize: 26)), // 這裡字體可以設大一點，它會自動縮
                          ),
                        )).toList(),
                      ),
                    ),
                  ),

                  // 儲存按鈕
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('儲存紀錄，讓他照顧妳'),
                      onPressed: (_selectedStartDay != null && _selectedEndDay != null) ? _saveRecord : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: theme.colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                    ),
                  ),

                  const Divider(indent: 32, endIndent: 32),

                  // 歷史紀錄
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final r = records[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(isDarkMode ? 0.4 : 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Text(r.mood, style: const TextStyle(fontSize: 24)),
                          title: Text('${DateFormat('MM/dd').format(r.startDate)} - ${DateFormat('MM/dd').format(r.endDate)}'),
                          onLongPress: () => _deleteRecord(snapshot.data!.docs[index].id),
                          trailing: const Icon(Icons.chevron_right, size: 16),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
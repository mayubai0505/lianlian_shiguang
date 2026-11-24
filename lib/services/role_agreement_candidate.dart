// 拾光約定：統一的時間解析器。解析只提供確認視窗的「預選值」，
// 絕不由玩家訊息或 AI 回覆直接建立／修改 Firestore 排程。
class RoleAgreementCandidate {
  final String id;
  final String content;
  final DateTime scheduledAt;
  const RoleAgreementCandidate(this.id, this.content, this.scheduledAt);
}

class RoleAgreementCandidateDetector {
  static final RegExp _approval = RegExp(
    r'^(?:好(?:啊|呀|的|喔|哦)?|可以(?:啊|呀)?|同意|我同意|我答應(?:你|妳)?|答應(?:你|妳)?|沒問題|就這麼說定了|ok|okay|yes|sure)[！!。．～~ ]*$',
    caseSensitive: false,
  );
  static final RegExp _rejection = RegExp(
    r'^(?:不要|不用|取消|算了|拒絕|不行|不可以|no|nope)[！!。．～~ ]*$',
    caseSensitive: false,
  );
  static bool isApproval(String text) => _approval.hasMatch(text.trim());
  static bool isRejection(String text) => _rejection.hasMatch(text.trim());

  static final RegExp _intent = RegExp(
    r'提醒|叫(?:我|你|妳)起床|叫醒|打(?:個)?電話|來電|打給(?:我|你|妳)|通知|約定|鬧鐘|記得叫|記得提醒',
  );
  static final RegExp _hypothetical = RegExp(r'假設|如果|比方說|舉例|故事裡|劇情裡|夢裡');
  static final RegExp _reschedule = RegExp(r'改(?:成|到|為)?|延(?:到|後)|提前(?:到)?|換(?:成|到)?|調整(?:到|成)?|改時間');
  static final RegExp _timeHint = RegExp(
    r'(?:[0-9零〇○Ｏ一二兩三四五六七八九十]{1,5}\s*[點点時时]|\d{1,2}\s*[:：]\s*\d{1,2}|半夜|正午|中午|午夜)',
  );

  static bool isRescheduleIntent(String text) {
    final t = text.trim();
    return t.length <= 180 && _reschedule.hasMatch(t) &&
        (_timeHint.hasMatch(t) || _relativeHint.hasMatch(t) ||
          RegExp(r'早上|下午|今晚|明天|後天|星期|週|礼拜|禮拜').hasMatch(t)) &&
        !_hypothetical.hasMatch(t);
  }

  static final RegExp _relativeHint = RegExp(
    r'(半|[0-9零〇○一二兩三四五六七八九十]{1,5})\s*(?:個)?\s*(?:小時|小时|鐘頭|钟头|分鐘|分钟)\s*(?:之)?後',
  );

  static bool _shouldOfferManualPicker(String text) {
    final t = text.trim();
    return t.isNotEmpty && t.length <= 180 && !_hypothetical.hasMatch(t) &&
      RegExp(r'早上|上午|中午|下午|晚上|今晚|明天|後天|星期|週|礼拜|禮拜|幾點|几点|下班後|起床時|睡醒|半小時|半小时').hasMatch(t);
  }

  static const _digits = <String, int>{
    '零': 0, '〇': 0, '○': 0, 'Ｏ': 0,
    '一': 1, '二': 2, '兩': 2, '三': 3, '四': 4, '五': 5,
    '六': 6, '七': 7, '八': 8, '九': 9,
  };

  static int? _number(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;
    final asInteger = int.tryParse(raw);
    if (asInteger != null) return asInteger;
    if (raw == '十') return 10;
    if (raw.contains('十')) {
      final p = raw.split('十');
      if (p.length != 2) return null;
      final tens = p[0].isEmpty ? 1 : _digits[p[0]];
      final units = p[1].isEmpty ? 0 : _digits[p[1]];
      return tens == null || units == null ? null : tens * 10 + units;
    }
    // 「二〇二六」之類逐字表達只在數字位置接受。
    var result = 0;
    for (final c in raw.split('')) {
      final n = _digits[c];
      if (n == null) return null;
      result = result * 10 + n;
    }
    return result;
  }

  // 保留完整解析資訊，以免省略日期／上下午時意外猜錯。
  static _ParsedTime? _readTime(String text, {DateTime? original}) {
    // Normalize conversational filler around a period, e.g. 「今天的下午兩點」
    // or 「今天下午點兩點」. This prevents interpreting 2 PM as 02:00.
    final source = text
        .replaceAll('點鐘', '點')
        .replaceAll('点钟', '点')
        .replaceAllMapped(
          RegExp(r'(凌晨|清晨|早上|上午|中午|正午|下午|傍晚|晚上|今晚|半夜|午夜)\s*(?:的)?\s*點(?=\s*[0-9零〇○Ｏ一二兩三四五六七八九十])'),
          (m) => m.group(1)!,
        );
    int? hour;
    int minute = 0;
    String period = '';
    final clock = RegExp(r'(?<!\d)([01]?\d|2[0-3])\s*[:：]\s*([0-5]?\d)(?!\d)').firstMatch(source);
    final spoken = RegExp(
      r'(凌晨|清晨|早上|上午|中午|正午|下午|傍晚|晚上|今晚|半夜|午夜)?\s*(?:的\s*)?([0-9]{1,2}|[零〇○Ｏ一二兩三四五六七八九十]{1,5})\s*[點点時时]\s*(半|一刻|兩刻|三刻|[0-9]{1,2}|[零〇○Ｏ一二兩三四五六七八九十]{1,5})?\s*(?:分(?:鐘|钟)?)?',
    ).firstMatch(source);
    if (spoken != null && (clock == null || spoken.start < clock.start)) {
      hour = _number(spoken.group(2)!);
      period = spoken.group(1) ?? '';
      final m = spoken.group(3) ?? '';
      if (m.isNotEmpty) {
        if (m == '半' || m == '兩刻') minute = 30;
        else if (m == '一刻') minute = 15;
        else if (m == '三刻') minute = 45;
        else {
          final n = _number(m);
          if (n == null) return null;
          minute = n;
        }
      }
    } else if (clock != null) {
      hour = int.parse(clock.group(1)!);
      minute = int.parse(clock.group(2)!);
      final before = source.substring(0, clock.start);
      final beforePeriod = RegExp(r'(凌晨|清晨|早上|上午|中午|下午|傍晚|晚上|今晚|半夜|午夜)\s*$').firstMatch(before);
      period = beforePeriod?.group(1) ?? '';
    } else {
      return null;
    }
    if (hour == null || hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    final hasPeriod = period.isNotEmpty || hour > 12;
    if (period == '下午' || period == '傍晚' || period == '晚上' || period == '今晚') {
      if (hour < 12) hour += 12;
    } else if (period == '中午' || period == '正午') {
      if (hour < 11) hour += 12;
    } else if (period == '凌晨' || period == '半夜' || period == '午夜') {
      if (hour == 12) hour = 0;
    } else if (period == '早上' || period == '上午' || period == '清晨') {
      if (hour == 12) hour = 0;
    } else if (original != null && hour >= 1 && hour <= 12) {
      // 「改一點四十」繼承原約定的上午／下午，不從目前時間猜。
      if (original.hour >= 12 && hour < 12) hour += 12;
      if (original.hour < 12 && hour == 12) hour = 0;
    }
    return _ParsedTime(hour, minute, hasPeriod);
  }

  static _ParsedDate? _readDate(String source, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final full = RegExp(r'(20\d{2})\s*[-/年]\s*(\d{1,2})\s*[-/月]\s*(\d{1,2})\s*日?').firstMatch(source);
    if (full != null) {
      final y = int.parse(full.group(1)!);
      final m = int.parse(full.group(2)!);
      final d = int.parse(full.group(3)!);
      final value = DateTime(y, m, d);
      return value.year == y && value.month == m && value.day == d ? _ParsedDate(value, true) : null;
    }
    final short = RegExp(r'(?<!\d)(\d{1,2})\s*[/月]\s*(\d{1,2})\s*日?(?!\d)').firstMatch(source);
    if (short != null) {
      final m = int.parse(short.group(1)!);
      final d = int.parse(short.group(2)!);
      var value = DateTime(now.year, m, d);
      if (value.month != m || value.day != d) return null;
      if (value.isBefore(today)) value = DateTime(now.year + 1, m, d);
      return _ParsedDate(value, true);
    }
    if (source.contains('大後天')) return _ParsedDate(today.add(const Duration(days: 3)), true);
    if (source.contains('後天') || source.contains('后天')) return _ParsedDate(today.add(const Duration(days: 2)), true);
    if (RegExp(r'明天|明早|明晚|明日').hasMatch(source)) return _ParsedDate(today.add(const Duration(days: 1)), true);
    if (RegExp(r'今天|今晚|今早|今日').hasMatch(source)) return _ParsedDate(today, true);
    // 星期資訊不自行猜測跨週意思；交由使用者在確認視窗選日期。
    return _ParsedDate(today, false);
  }

  static DateTime? _resolve(String text, DateTime now, {DateTime? original}) {
    final relative = _relativeHint.firstMatch(text);
    if (relative != null) {
      final raw = relative.group(1)!;
      final n = raw == '半' ? 0.5 : _number(raw)?.toDouble();
      if (n == null || n <= 0) return null;
      final unit = relative.group(0)!;
      final minutes = (n * (unit.contains('小時') || unit.contains('小时') ||
          unit.contains('鐘頭') || unit.contains('钟头') ? 60 : 1)).round();
      if (minutes < 2 || minutes > 60 * 24 * 365) return null;
      final result = now.add(Duration(minutes: minutes));
      return result;
    }
    final time = _readTime(text, original: original);
    final date = _readDate(text, now);
    if (time == null || date == null) return null;
    var chosen = date.value;
    if (original != null && !date.explicit) {
      chosen = DateTime(original.year, original.month, original.day);
    }
    var at = DateTime(chosen.year, chosen.month, chosen.day, time.hour, time.minute);
    if (at.hour != time.hour || at.minute != time.minute) return null;
    if (!at.isAfter(now.add(const Duration(minutes: 1)))) {
      if (original == null && !date.explicit) {
        // 首次約定未指定日期時可預選最近的未來時段；視窗仍需確認。
        at = at.add(const Duration(days: 1));
      } else {
        // 修改原約定／明說日期卻已過期：不偷換成隔天，交由玩家重新選擇。
        return null;
      }
    }
    if (at.difference(now).inDays > 365) return null;
    return at;
  }

  static DateTime? rescheduledTime(String text, DateTime original, DateTime now) {
    if (!isRescheduleIntent(text)) return null;
    return _resolve(text, now, original: original);
  }

  // 原句明確在約定時間，但規則尚未能安全判讀時，也開啟可手動選時的視窗。
  // 預選不代表 AI 已理解時間；由玩家檢查日期與時間再按確認。
  static RoleAgreementCandidate? extractForConfirmation(String text, String id, DateTime now) {
    final exact = extract(text, id, now);
    if (exact != null) return exact;
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length > 180 || !_intent.hasMatch(normalized) ||
        !_shouldOfferManualPicker(normalized)) return null;
    final fallback = now.add(const Duration(hours: 1));
    final initial = DateTime(fallback.year, fallback.month, fallback.day,
      fallback.hour, ((fallback.minute + 4) ~/ 5 * 5) % 60)
        .add(Duration(hours: fallback.minute >= 56 ? 1 : 0));
    return RoleAgreementCandidate(id, normalized, initial);
  }

  static RoleAgreementCandidate? extract(String text, String id, DateTime now) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.isEmpty || normalized.length > 1000 ||
        !_intent.hasMatch(normalized) || _hypothetical.hasMatch(normalized)) return null;
    final scheduled = _resolve(normalized, now);
    if (scheduled == null) return null;
    return RoleAgreementCandidate(id,
      normalized.length > 180 ? '${normalized.substring(0, 180)}…' : normalized,
      scheduled,
    );
  }
}

class _ParsedDate {
  final DateTime value;
  final bool explicit;
  const _ParsedDate(this.value, this.explicit);
}

class _ParsedTime {
  final int hour;
  final int minute;
  final bool explicitPeriod;
  const _ParsedTime(this.hour, this.minute, this.explicitPeriod);
}

// 拾光約定第二階段：只供一般角色閒聊使用的保守候選提取器。
// 不依靠文字比對直接建立 Firestore 約定；玩家必須再確認視窗中按下確認。
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

  static RoleAgreementCandidate? extract(String text, String id, DateTime now) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.isEmpty || normalized.length > 1000) return null;
    // 防止任意小說敘事被辨識成現實排程：需要明顯的提醒／通話意圖。
    if (!RegExp(r'提醒|叫(?:我|你|妳)起床|叫醒|打(?:個)?電話|來電|打給(?:我|你|妳)|通知|約定|鬧鐘|記得叫|記得提醒').hasMatch(normalized)) {
      return null;
    }
    if (RegExp(r'假設|如果|比方說|舉例|故事裡|劇情裡|夢裡').hasMatch(normalized)) return null;
    DateTime date;
    final absolute = RegExp(r'(20\d{2})[/-](\d{1,2})[/-](\d{1,2})').firstMatch(normalized);
    if (absolute != null) {
      final year = int.parse(absolute.group(1)!);
      final month = int.parse(absolute.group(2)!);
      final day = int.parse(absolute.group(3)!);
      date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) return null;
    } else {
      final today = DateTime(now.year, now.month, now.day);
      if (normalized.contains('後天')) { date = today.add(const Duration(days: 2)); }
      else if (normalized.contains('明天') || normalized.contains('明早') || normalized.contains('明晚')) { date = today.add(const Duration(days: 1)); }
      else if (normalized.contains('今天') || normalized.contains('今晚') || normalized.contains('今早')) { date = today; }
      else { return null; } // 週五／下週等較複雜日期要人工在下一階段處理。
    }

    int? hour, minute;
    final digital = RegExp(r'(?<!\d)([01]?\d|2[0-3]):([0-5]\d)(?!\d)').firstMatch(normalized);
    if (digital != null) {
      hour = int.parse(digital.group(1)!);
      minute = int.parse(digital.group(2)!);
    } else {
      final spoken = RegExp(r'(凌晨|清晨|早上|上午|中午|下午|傍晚|晚上|今晚|明早|明晚)?\s*(\d{1,2})\s*[點时時](?:\s*(半|\d{1,2}分?))?').firstMatch(normalized);
      if (spoken == null) return null;
      hour = int.parse(spoken.group(2)!);
      if (hour > 23) return null;
      final part = spoken.group(1) ?? '';
      if (part == '下午' || part == '傍晚' || part == '晚上' || part == '今晚' || part == '明晚') {
        if (hour < 12) hour += 12;
      } else if (part == '凌晨' && hour == 12) { hour = 0; }
      else if (part == '中午' && hour < 11) { hour += 12; }
      final mins = spoken.group(3) ?? '';
      minute = mins == '半' ? 30 : (int.tryParse(mins.replaceAll('分','')) ?? 0);
      if (minute > 59) return null;
    }
    // 口語 8 點未指明上午下午，要求使用者於確認視窗核對；仍提供時間選擇器。
    final scheduled = DateTime(date.year, date.month, date.day, hour, minute);
    if (!scheduled.isAfter(now.add(const Duration(minutes: 1)))) return null;
    if (scheduled.difference(now).inDays > 365) return null;
    return RoleAgreementCandidate(id, normalized.length > 180 ? '${normalized.substring(0,180)}…' : normalized, scheduled);
  }
}

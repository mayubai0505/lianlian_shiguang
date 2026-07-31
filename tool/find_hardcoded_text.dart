import 'dart:io';

final chineseRegex = RegExp(r'[\u4E00-\u9FFF]');

void main(List<String> args) {
  // 沒指定就掃 lib
  final targetPath = args.isNotEmpty ? args.first : 'lib';

  final target = Directory(targetPath);

  if (!target.existsSync()) {
    print('❌ 找不到資料夾：$targetPath');
    return;
  }

  int total = 0;

  print('📂 掃描：$targetPath\n');

  for (final entity in target.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;

    final lines = entity.readAsLinesSync();

    bool printedFileName = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trim = line.trimLeft();

      // 跳過註解
      if (trim.startsWith('//')) continue;

      // 跳過 import/export
      if (trim.startsWith('import ')) continue;
      if (trim.startsWith('export ')) continue;

      if (!chineseRegex.hasMatch(line)) continue;

      if (!printedFileName) {
        printedFileName = true;
        print('══════════════════════════════');
        print(entity.path.replaceAll('\\', '/'));
      }

      total++;
      print('${i + 1}: $line');
    }

    if (printedFileName) {
      print('');
    }
  }

  print('══════════════════════════════');
  print('🎉 共找到 $total 行包含中文');
}
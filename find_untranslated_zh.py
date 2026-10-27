#!/usr/bin/env python3
"""Find Chinese text in front-end source string literals, without modifying project files.
Usage: python tools/find_untranslated_zh.py [project_root]
Python >= 3.9; no third-party dependencies.
"""
from __future__ import annotations
import argparse
import csv
import os
import re
from pathlib import Path
from collections import Counter

CHINESE = re.compile(r'[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff]')
INCLUDED = {'.dart', '.js', '.jsx', '.ts', '.tsx', '.html', '.vue'}
EXCLUDE_DIRS = {'admin', 'admins', 'admin_panel', 'admin-dashboard', 'admin_dashboard',
                'backoffice', 'back_office', 'dashboard', '.git', '.dart_tool', 'build',
                '.firebase', 'node_modules', 'ios', 'android', 'macos', 'windows', 'linux',
                'coverage', 'test', 'tests', 'integration_test', 'generated', 'gen_l10n',
                'l10n', 'localizations', 'locales', 'translations', 'assets', 'dist', 'out',
                '.next', '.nuxt'}
EXCLUDE_FILENAMES = {'firebase_options.dart', 'app_localizations.dart',
                    'app_localizations_zh.dart', 'app_localizations_en.dart',
                    'app_localizations_zh_tw.dart'}
CODE_EXT = {'.dart', '.js', '.jsx', '.ts', '.tsx'}
# Strings used for developer logging / system wiring aren't necessarily untranslated UI.
LOG_PATTERN = re.compile(r'\b(?:debugPrint|print|console\.(?:log|warn|error|info|debug))\s*\($')


def normalize_excerpt(s: str, maxlen: int = 180) -> str:
    s = s.replace('\r', ' ').replace('\n', ' ↵ ').replace('\t', ' ').strip()
    return s if len(s) <= maxlen else s[:maxlen] + '…'


def line_number(src: str, index: int) -> int:
    return src.count('\n', 0, index) + 1


def iter_strings(src: str, suffix: str):
    """Lightweight lexer: skips line/block comments, emits ordinary/triple/template strings.
    Does not claim to be a full Dart/JS parser; intended to produce human review candidates.
    """
    i, n = 0, len(src)
    while i < n:
        if src.startswith('//', i):
            end = src.find('\n', i + 2)
            i = n if end < 0 else end + 1
            continue
        if src.startswith('/*', i):
            depth, j = 1, i + 2
            while j < n and depth:
                if src.startswith('/*', j) and suffix == '.dart': depth += 1; j += 2
                elif src.startswith('*/', j): depth -= 1; j += 2
                else: j += 1
            i = j
            continue
        # Dart raw string: r'...' or r"..."; allow triple quotes
        raw = (suffix == '.dart' and src[i] in 'rR' and i + 1 < n
               and src[i + 1] in "'\"" and (i == 0 or not (src[i - 1].isalnum() or src[i-1] == '_')))
        start = i
        qi = i + 1 if raw else i
        if qi < n and src[qi] in "'\"`":
            q = src[qi]
            triple = q != '`' and src.startswith(q * 3, qi)
            j = qi + (3 if triple else 1)
            while j < n:
                if not raw and src[j] == '\\': j += 2; continue
                if triple and src.startswith(q * 3, j):
                    yield start, src[qi + 3:j]
                    i = j + 3
                    break
                if not triple and src[j] == q:
                    yield start, src[qi + 1:j]
                    i = j + 1
                    break
                j += 1
            else: i = n
            continue
        i += 1


def is_excluded(p: Path, root: Path) -> bool:
    rel = p.relative_to(root)
    parts = [x.lower() for x in rel.parts[:-1]]
    if any(x in EXCLUDE_DIRS or x.startswith('admin_') or x.endswith('_admin') for x in parts):
        return True
    name = p.name.lower()
    if name in EXCLUDE_FILENAMES or name.endswith('.g.dart') or name.endswith('.freezed.dart'):
        return True
    if any(word in name for word in ('admin_', '_admin', 'dashboard', 'backoffice')):
        return True
    if name.startswith('app_localizations') or name.startswith('intl_'):
        return True
    return False


def classify(src: str, start: int, content: str, suffix: str):
    line = src.rfind('\n', 0, start) + 1
    before = src[max(0, start - 250):start]
    current = src[line:start]
    if re.search(r'\b(?:print|debugPrint|log|logger\.(?:i|d|e|w)|console\.(?:log|warn|error|info|debug))\s*\([^;]*$', before):
        return '記錄／除錯（人工確認）', '低'
    if re.search(r'\b(?:Text|SelectableText|TextSpan|Tooltip|SnackBar|AlertDialog|ListTile|InputDecoration|ToastUtils\.[A-Za-z]+)\s*\([^;]*$', before):
        return '可能直接顯示在介面', '高'
    if re.search(r'\b(?:label|title|hintText|helperText|errorText|subtitle|message|description|content|tooltip|placeholder|buttonText|emptyText)\s*:\s*$', before):
        return '可能直接顯示在介面', '高'
    if suffix in {'.html', '.vue'}:
        return '網頁字串（人工確認）', '中'
    if re.search(r'(?:\.where\(|\.doc\(|\.collection\(|RegExp\(|case\s+)$', current):
        return '資料鍵值／邏輯（人工確認）', '低'
    return '其他中文字串（人工確認）', '中'


def main():
    ap = argparse.ArgumentParser(description='《戀戀拾光》前台疑似未翻譯中文字檢查工具')
    ap.add_argument('root', nargs='?', default='.', help='Flutter 專案根目錄，預設當前資料夾')
    ap.add_argument('--out', default='translation_audit', help='報表輸出資料夾（相對專案根目錄）')
    args = ap.parse_args()
    root = Path(args.root).expanduser().resolve()
    if not root.is_dir(): ap.error(f'找不到專案資料夾：{root}')
    out = (root / args.out).resolve() if not Path(args.out).is_absolute() else Path(args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)
    rows, inspected, skipped = [], 0, 0
    candidate_paths = []
    for directory, folders, filenames in os.walk(root):
        folders[:] = [f for f in folders if f.lower() not in EXCLUDE_DIRS
                      and not f.lower().startswith('admin_')
                      and not f.lower().endswith('_admin')
                      and (Path(directory)/f).resolve() != out]
        for filename in filenames:
            path = Path(directory)/filename
            if path.suffix.lower() in INCLUDED: candidate_paths.append(path)
    for path in candidate_paths:
        if out == path or out in path.parents or is_excluded(path, root):
            skipped += 1; continue
        # Only frontend trees. functions/server scripts may have non-UI prompts and aren't player-visible UI.
        relparts = [x.lower() for x in path.relative_to(root).parts]
        if relparts and relparts[0] in ('functions', 'server', 'backend', 'scripts', 'tools'):
            skipped += 1; continue
        try: src = path.read_text(encoding='utf-8-sig')
        except (OSError, UnicodeError): continue
        inspected += 1
        for start, content in iter_strings(src, path.suffix.lower()):
            if not CHINESE.search(content): continue
            typ, priority = classify(src, start, content, path.suffix.lower())
            rows.append({
                '優先級':priority, '分類':typ, '檔案':path.relative_to(root).as_posix(),
                '行號':line_number(src, start), '中文字串':normalize_excerpt(content),
                '程式碼前後文':normalize_excerpt(src[max(0,start-90):min(len(src),start+len(content)+80)]),
                '狀態':'待人工確認', '建議翻譯Key':'', '備註':''
            })
    # HTML/Vue markup may contain player-facing text outside quoted attributes.
    for path in candidate_paths:
        if path.suffix.lower() not in ('.html', '.vue') or is_excluded(path, root): continue
        relparts = [x.lower() for x in path.relative_to(root).parts]
        if relparts and relparts[0] in ('functions','server','backend','scripts','tools'): continue
        try: original = path.read_text(encoding='utf-8-sig')
        except (OSError, UnicodeError): continue
        # Mask scripts/styles/comments without moving source offsets.
        masked = original
        for pattern in (r'<!--.*?-->', r'<script\b[^>]*>.*?</script\s*>',
                        r'<style\b[^>]*>.*?</style\s*>'):
            masked = re.sub(pattern, lambda m: re.sub(r'[^\n]', ' ', m.group()),
                            masked, flags=re.S | re.I)
        for m in re.finditer(r'>([^<>]+)<', masked, flags=re.S):
            content = m.group(1).strip()
            if not CHINESE.search(content): continue
            rows.append({'優先級':'高', '分類':'HTML/Vue 直接畫面文字',
                         '檔案':path.relative_to(root).as_posix(),
                         '行號':line_number(original,m.start(1)),
                         '中文字串':normalize_excerpt(content),
                         '程式碼前後文':normalize_excerpt(original[max(0,m.start()-90):min(len(original),m.end()+80)]),
                         '狀態':'待人工確認','建議翻譯Key':'','備註':''})
    order = {'高':0,'中':1,'低':2}
    rows.sort(key=lambda r:(order[r['優先級']],r['檔案'],r['行號']))
    csv_path = out/'疑似未翻譯中文字.csv'
    with csv_path.open('w',encoding='utf-8-sig',newline='') as f:
        writer = csv.DictWriter(f,fieldnames=['優先級','分類','檔案','行號','中文字串','程式碼前後文','狀態','建議翻譯Key','備註'])
        writer.writeheader(); writer.writerows(rows)
    summary = Counter(r['檔案'] for r in rows)
    with (out/'掃描摘要.txt').open('w',encoding='utf-8') as f:
        f.write(f'掃描程式檔案數：{inspected}\n排除檔案數：{skipped}\n疑似中文字串數：{len(rows)}\n')
        for p in ('高','中','低'): f.write(f'{p}優先：{sum(r["優先級"]==p for r in rows)}\n')
        f.write('\n按檔案統計（筆數）：\n')
        for fn,num in summary.most_common(): f.write(f'{num:>5}  {fn}\n')
        f.write('\n說明：這是原始碼中文字串掃描，不能百分之百判定未翻譯；部分字串是資料、提示詞或除錯資訊，需人工複核。\n')
        f.write('已排除 admin/後台、generated、l10n、ARB 所在資料夾、註解、build 等。\n')
    print(f'掃描完成：{inspected} 個程式檔，{len(rows)} 筆待確認')
    print(f'CSV：{csv_path}\n摘要：{out / "掃描摘要.txt"}')

if __name__=='__main__': main()

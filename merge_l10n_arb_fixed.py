#!/usr/bin/env python3
"""Merge ChatGPT ARB snippets from ZIP packages into an existing Flutter l10n directory.

Only reads arb_snippets/app_*.json or .arb inside ZIPs; never touches Dart files.
Needs Python 3.9+ only (no pip installs).
"""
import argparse, datetime, json, re, shutil, sys, tempfile, zipfile
from collections import defaultdict
from pathlib import Path

SOURCE_LOCALES = {'zh_TW': 'zh_Hant', 'zh_CN': 'zh_Hans', 'zh_Hant_TW': 'zh_Hant', 'zh_Hans_CN': 'zh_Hans'}
PATTERN = re.compile(r'(?:^|/)arb_snippets/app_([A-Za-z_]+)\.(json|arb)$', re.I)
PLACEHOLDER = re.compile(r'(?<!\{)\{([A-Za-z][A-Za-z0-9_]*)\}(?!\})')

def stop(message):
    raise ValueError(message)

def locale_name(source):
    return SOURCE_LOCALES.get(source, source)

def load_json(data, source):
    try:
        result = json.loads(data.decode('utf-8-sig'))
    except Exception as exc:
        stop(f'JSON 格式有誤：{source}：{exc}')
    if not isinstance(result, dict):
        stop(f'翻譯片段不是 JSON 物件：{source}')
    for key, value in result.items():
        if key.startswith('@@'):
            continue
        elif key.startswith('@'):
            if not isinstance(value, dict): stop(f'@key 設定格式錯誤：{source} / {key}')
        elif not isinstance(value, str):
            stop(f'翻譯必須是字串：{source} / {key}')
        elif '${' in value:
            stop(f'發現 Dart 字串插值（ARB 不接受）：{source} / {key}')
    return result

def validate_merged(merged):
    # Check that a locale's placeholders match its own metadata where metadata is supplied.
    for locale, values in merged.items():
        for key, value in values.items():
            if key.startswith('@') or key.startswith('@@'): continue
            placeholders = set(PLACEHOLDER.findall(value))
            metadata = values.get('@' + key)
            specified = set(metadata.get('placeholders', {})) if isinstance(metadata, dict) else set()
            if placeholders and not specified:
                stop(f'{locale}/{key} 有動態參數 {sorted(placeholders)}，但片段缺少 @key placeholders 定義')
            if specified and placeholders != specified:
                stop(f'{locale}/{key} 的動態參數不一致：文字={sorted(placeholders)}，@key={sorted(specified)}')
    for key in sorted(set().union(*(set(x) for x in merged.values()))):
        if key.startswith('@'): continue
        formats = {}
        for locale, translations in merged.items():
            if key not in translations: continue
            meta = translations.get('@'+key, {})
            formats[locale] = {k: v.get('type', 'String') for k, v in meta.get('placeholders', {}).items()} if isinstance(meta,dict) else {}
        if len({tuple(sorted(x.items())) for x in formats.values()}) > 1:
            stop(f'不同語系的 {key} 參數設定不一致：{formats}')

def main():
    parser = argparse.ArgumentParser(description='一鍵合併翻譯 ZIP 裡的 ARB 片段（不修改 Dart）')
    parser.add_argument('--project', required=True, help=r'Flutter 專案根目錄，如 C:\Projects\lianlian_shiguang')
    parser.add_argument('--source', required=True, help='存放翻譯 ZIP 的資料夾')
    parser.add_argument('--arb-dir', help='自訂 ARB 資料夾，預設 <project>/lib/l10n')
    parser.add_argument('--dry-run', action='store_true', help='只檢查、顯示統計，不寫入')
    args = parser.parse_args()
    project = Path(args.project).expanduser().resolve()
    source = Path(args.source).expanduser().resolve()
    arb_dir = Path(args.arb_dir).expanduser().resolve() if args.arb_dir else project/'lib'/'l10n'
    if not arb_dir.is_dir(): stop(f'找不到 ARB 資料夾：{arb_dir}，請用 --arb-dir 指定')
    if not source.is_dir(): stop(f'找不到 ZIP 資料夾：{source}')
    zips = sorted(source.glob('*.zip'))
    if not zips: stop(f'資料夾中沒有 ZIP：{source}')

    patches = defaultdict(dict)
    included = []
    conflicts = []
    for path in zips:
        with zipfile.ZipFile(path) as zf:
            members = [(n, PATTERN.search(n.replace('\\','/'))) for n in zf.namelist()]
            members = [(n, m) for n,m in members if m and not n.endswith('/')]
            if not members: continue
            included.append(path.name)
            present_locales = {m.group(1) for _, m in members}
            legacy_zh_is_simplified = 'zh' in present_locales and 'zh_Hant' in present_locales and 'zh_Hans' not in present_locales
            for member, matched in members:
                source_locale = matched.group(1)
                locale = 'zh_Hans' if legacy_zh_is_simplified and source_locale == 'zh' else locale_name(source_locale)
                payload = load_json(zf.read(member), f'{path.name}::{member}')
                # ignore @@locale and other top-level ARB settings provided by snippets
                payload = {k: v for k,v in payload.items() if not k.startswith('@@')}
                if legacy_zh_is_simplified and source_locale == 'zh_Hant':
                    # Legacy 14-file packs: zh_Hant is Traditional, zh is Simplified.
                    # Populate both Traditional ARB targets from zh_Hant.
                    target_locales = ['zh', 'zh_Hant']
                else:
                    target_locales = [locale]
                for target_locale in target_locales:
                    for k,v in payload.items():
                        if k in patches[target_locale] and patches[target_locale][k] != v:
                            conflicts.append(f'{target_locale}/{k}：不同 ZIP 翻譯衝突（最新讀取：{path.name}）')
                        patches[target_locale][k] = v
    if not included: stop('ZIP 裡找不到 arb_snippets/app_*.json 或 .arb')
    validate_merged(patches)
    if conflicts:
        print(f'錯誤：發現 {len(conflicts)} 個相同語言與 Key 的衝突，為避免覆蓋錯誤翻譯，已停止合併。', file=sys.stderr)
        for item in conflicts[:30]: print('  -', item, file=sys.stderr)
        stop('請移除重複或舊版翻譯 ZIP，再重新執行。')
    if 'zh_Hans' not in patches or 'zh' not in patches or 'zh_Hant' not in patches:
        stop('中文語系不完整：必須同時包含 zh、zh_Hant、zh_Hans，已停止合併。')

    planned = []
    for locale, patch in sorted(patches.items()):
        dest = arb_dir/f'app_{locale}.arb'
        if not dest.exists():
            stop(f'找不到目標語言檔 {dest}。為避免寫錯語系，請確認專案語系名稱。')
        original = dest.read_bytes()
        obj = load_json(original, str(dest))
        diff = sum(k not in obj or obj[k] != v for k,v in patch.items())
        added = sum(k not in obj for k in patch)
        new = dict(obj)
        new.update(patch)
        planned.append((dest, original, new, diff, added))
    print(f'找到 {len(included)} 個翻譯 ZIP，準備更新 {len(planned)} 個 ARB 檔案')
    for p in included: print('  ZIP:', p)
    for dest, _, _, diff, added in planned:
        print(f'  {dest.name}: {diff} 筆更新／其中 {added} 筆新增')
    if args.dry_run:
        print('預覽完成，沒有修改任何檔案。')
        return
    backup_dir = project/'l10n_merge_backups'/datetime.datetime.now().strftime('%Y%m%d_%H%M%S_%f')
    backup_dir.mkdir(parents=True,exist_ok=False)
    for dest, original, *_ in planned:
        (backup_dir/dest.name).write_bytes(original)
    try:
        for dest, _, new, _, _ in planned:
            # check final JSON serializability before replacing on disk
            encoded = (json.dumps(new, ensure_ascii=False, indent=2)+'\n').encode('utf-8')
            with tempfile.NamedTemporaryFile(dir=dest.parent, delete=False) as f:
                tmp = Path(f.name)
                f.write(encoded)
            tmp.replace(dest)
    except Exception:
        for dest, original, *_ in planned: dest.write_bytes(original)
        raise
    print(f'\n合併完成。備份位置：{backup_dir}')
    print('下一步：在專案根目錄執行 flutter gen-l10n，接著 flutter analyze')

if __name__ == '__main__':
    try: main()
    except (ValueError, FileNotFoundError, zipfile.BadZipFile) as e:
        print(f'錯誤：{e}', file=sys.stderr)
        sys.exit(1)

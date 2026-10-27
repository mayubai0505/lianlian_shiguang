#!/usr/bin/env python3
"""Quarantine migrated Flutter PNG/JPG files, never permanently delete them.

Usage:
  py -u cleanup_migrated_png.py --project .
  py -u cleanup_migrated_png.py --project . --apply
  py -u cleanup_migrated_png.py --project . --restore --quarantine "C:\\Projects\\lianlian_shiguang_png_quarantine_..."
"""
import argparse
import datetime
import json
import os
import re
import shutil
from pathlib import Path

SKIP = {'.git','.dart_tool','build','.idea','.gradle','node_modules','webp_comparison_report',
        'image_compression_backups','webp_migration_backups','l10n_merge_backups','translation_zips'}
EXT = {'.dart','.yaml','.yml','.json','.arb','.xml','.gradle','.kts','.html','.css','.js','.ts'}

def source_texts(root):
    for where, dirs, filenames in os.walk(root):
        dirs[:] = [d for d in dirs if d not in SKIP and not d.startswith('.')]
        for filename in filenames:
            p = Path(where) / filename
            if p.suffix.lower() not in EXT: continue
            try:
                if p.stat().st_size <= 8_000_000:
                    yield p.relative_to(root).as_posix(), p.read_text(encoding='utf-8', errors='replace')
            except OSError: pass

def main():
    ap=argparse.ArgumentParser(description='Safely move old PNG/JPG after WebP conversion out of the Flutter project')
    ap.add_argument('--project',default='.')
    ap.add_argument('--apply', action='store_true', help='Move eligible originals to quarantine folder OUTSIDE project')
    ap.add_argument('--restore', action='store_true', help='Restore files from a quarantine')
    ap.add_argument('--quarantine', help='Specific quarantine directory for restore')
    ap.add_argument('--list-all',action='store_true',help='Print all candidate decisions')
    args=ap.parse_args()
    root=Path(args.project).resolve()
    if not (root/'assets'/'images').is_dir(): ap.error('Cannot find project assets/images')
    if args.restore:
        if not args.quarantine: ap.error('--restore needs --quarantine PATH')
        store=Path(args.quarantine).resolve()
        if not store.is_dir(): ap.error('Quarantine directory missing')
        manifest=store/'quarantine_manifest.json'
        if not manifest.is_file(): ap.error('Missing quarantine_manifest.json')
        rels=json.loads(manifest.read_text(encoding='utf-8'))['moved']
        for rel in rels:
            src=store/rel; dst=root/rel
            if not src.is_file(): print('MISSING in quarantine:',rel); continue
            if dst.exists(): print('SKIP already exists:',rel); continue
            dst.parent.mkdir(parents=True,exist_ok=True)
            shutil.move(str(src),str(dst));print('RESTORED:',rel)
        print('Restore finished.'); return
    backups=root/'webp_migration_backups'
    manifests=sorted(backups.glob('*/manifest.json')) if backups.is_dir() else []
    if not manifests: ap.error('No WebP migration manifest found. Do NOT delete images manually.')
    candidates=set()
    for m in manifests:
        try:
            data=json.loads(m.read_text(encoding='utf-8'))
            candidates.update(data.get('originalFiles',[]))
        except Exception as e:
            print('WARNING: unreadable manifest',m,e)
    sources=list(source_texts(root))
    # pubspec.yaml is included in source_texts because .yaml is scanned.
    # Keep a separate explicit check to protect declared Flutter and native assets.
    pubspec=(root/'pubspec.yaml').read_text(encoding='utf-8',errors='replace') if (root/'pubspec.yaml').exists() else ''
    if not pubspec: ap.error('pubspec.yaml missing or empty; refusing cleanup')
    # Conservative: dynamic path strings ending in .png/.jpg may synthesize filenames.
    dynamic_png=[]
    for name, txt in sources:
        if name.startswith('assets/'): continue
        for line in txt.splitlines():
            if 'assets/images/' in line and ('$' in line or '+ ' in line) and ('.png' in line or '.jpg' in line or 'webp' in line):
                dynamic_png.append((name,line.strip()))
    print(f'Potential dynamic asset references: {len(dynamic_png)}',flush=True)
    for name,line in dynamic_png[:15]: print('DYNAMIC:',name, line[:160])
    print(f'Found {len(manifests)} migration manifest(s), {len(candidates)} converted originals, {len(sources)} source files.',flush=True)
    eligible=[];skipped=[]
    for rel in sorted(candidates):
        old=root/rel
        if not old.is_file(): skipped.append((rel,'original already absent'));continue
        if not rel.startswith('assets/images/') or old.suffix.lower() not in {'.png','.jpg','.jpeg'}:
            skipped.append((rel,'not an original assets/images image'));continue
        new=old.with_suffix('.webp')
        if not new.is_file() or new.stat().st_size==0:
            skipped.append((rel,'WebP file missing or empty'));continue
        # Conservative check: any remaining literal original filename (full path OR basename)
        # may indicate relative-path loading or code-generated paths.
        basename=old.name
        # Full-path and filename references, plus explicit YAML path regardless of scan filters.
        hits=[name for name,txt in sources if rel in txt or basename in txt]
        if rel in pubspec or basename in pubspec: hits.append('pubspec.yaml (explicit)')
        # Fail closed for dynamic filename constructions when they might refer to this original.
        # Extract fixed prefix from assets/images/... before first interpolation.
        for name,line in dynamic_png:
            match=re.search(r'assets/images/([^\"\'\s]*?)(?:\$|\+)',line)
            if match:
                prefix='assets/images/'+match.group(1)
                if rel.startswith(prefix) and ('.png' in line or '.jpg' in line or 'webp' in line):
                    # Dynamic references using a fixed .webp suffix are safe for old PNGs.
                    if '.png' in line or '.jpg' in line:
                        hits.append(name+' (dynamic path)')
        if hits:
            skipped.append((rel,'old filename referenced in '+', '.join(hits[:3])));continue
        eligible.append(rel)
    print(f'Eligible to move: {len(eligible)}; skipped: {len(skipped)}')
    lim=None if args.list_all else 25
    for rel,why in skipped[:lim]: print('KEEP:',rel,'—',why)
    if not args.list_all and len(skipped)>25:print(f'... plus {len(skipped)-25} more kept')
    for rel in eligible[:lim]: print('MOVE:',rel)
    if not args.list_all and len(eligible)>25: print(f'... plus {len(eligible)-25} more eligible')
    if not eligible:
        print('Nothing safe to move automatically. No files changed.');return
    if not args.apply:
        print('PREVIEW ONLY: No files changed. Use --apply to move eligible originals to a folder OUTSIDE the project.')
        print('WARNING: Dynamic paths such as "tree_$stage.png" may be undetectable. Test the entire app after moving.')
        return
    stamp=datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    store=root.parent/(root.name+'_png_quarantine_'+stamp)
    if store.exists(): ap.error('Quarantine already exists: '+str(store))
    store.mkdir(parents=True)
    moved=[]
    try:
        for rel in eligible:
            src=root/rel; dest=store/rel
            dest.parent.mkdir(parents=True,exist_ok=True)
            shutil.move(str(src),str(dest));moved.append(rel)
        (store/'quarantine_manifest.json').write_text(json.dumps({'project':str(root),'moved':moved},ensure_ascii=False,indent=2),encoding='utf-8')
    except Exception:
        for rel in reversed(moved):
            src=store/rel;dest=root/rel;dest.parent.mkdir(parents=True,exist_ok=True)
            if src.exists():shutil.move(str(src),str(dest))
        raise
    print('DONE: moved',len(moved),'old images OUTSIDE project. No permanent deletions.')
    print('QUARANTINE:',store)
    print('Check app screens, then build a release APK. Restore command:')
    print(f'py -u cleanup_migrated_png.py --project . --restore --quarantine "{store}"')
    print('WARNING: dynamic image paths still require in-app checking.')

if __name__=='__main__': main()

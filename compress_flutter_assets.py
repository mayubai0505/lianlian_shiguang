#!/usr/bin/env python3
"""Safe, same-extension compression for a Flutter project's assets/images.

Requires Pillow: py -m pip install pillow
Preview: py compress_flutter_assets.py --project .
Apply:   py compress_flutter_assets.py --project . --apply

This tool deliberately does NOT resize, convert to WebP, or rename files.
"""
import argparse
import io
import shutil
import sys
from datetime import datetime
from pathlib import Path
from PIL import Image, ImageOps, UnidentifiedImageError

EXTS = {'.png', '.jpg', '.jpeg'}


def optimized_bytes(path: Path, jpeg_quality: int) -> bytes | None:
    with Image.open(path) as source:
        if source.format not in {'PNG', 'JPEG'}:
            return None
        out = io.BytesIO()
        if source.format == 'PNG':
            # Lossless deflate optimization; preserve image mode, alpha, dimensions.
            # Avoid APNG, where rewriting frame 0 would destroy animation.
            if getattr(source, 'n_frames', 1) > 1:
                return None
            params = {'format': 'PNG', 'optimize': True, 'compress_level': 9}
            # Preserve embedded metadata where possible.
            if 'icc_profile' in source.info:
                params['icc_profile'] = source.info['icc_profile']
            if 'transparency' in source.info and source.mode not in ('RGBA', 'LA'):
                params['transparency'] = source.info['transparency']
            source.save(out, **params)
        else:
            # JPEG output is lossy but retains pixel dimensions. Avoid orientation
            # changes: EXIF orientation remains attached to the output.
            params = {'format': 'JPEG', 'quality': jpeg_quality, 'optimize': True,
                      'progressive': True, 'subsampling': 0}
            for key in ('icc_profile', 'exif'):
                if source.info.get(key):
                    params[key] = source.info[key]
            source.save(out, **params)
        return out.getvalue()


def main() -> int:
    parser = argparse.ArgumentParser(description='Compress Flutter PNG/JPEG assets without renaming them.')
    parser.add_argument('--project', type=Path, default=Path('.'))
    parser.add_argument('--assets-dir', type=Path, default=Path('assets/images'))
    parser.add_argument('--apply', action='store_true', help='Write smaller images after backing up originals.')
    parser.add_argument('--quality', type=int, default=85, help='JPEG quality (70-95; default 85).')
    parser.add_argument('--min-save', type=float, default=2, help='Minimum percent saved to replace file.')
    args = parser.parse_args()
    if not 70 <= args.quality <= 95:
        parser.error('--quality must be 70..95')
    if not 0 <= args.min_save <= 100:
        parser.error('--min-save must be 0..100')
    project = args.project.expanduser().resolve()
    base = args.assets_dir if args.assets_dir.is_absolute() else project / args.assets_dir
    base = base.resolve()
    if not base.is_dir():
        print(f'ERROR: image folder not found: {base}', file=sys.stderr)
        return 2
    if base == project or project not in base.parents:
        print('ERROR: assets folder must be within the project.', file=sys.stderr)
        return 2
    files = sorted(p for p in base.rglob('*') if p.is_file() and p.suffix.lower() in EXTS)
    backup = project / 'image_compression_backups' / datetime.now().strftime('%Y%m%d_%H%M%S_%f')
    total_before = total_after = changed = skipped = errors = 0
    results = []
    for i, path in enumerate(files, 1):
        before = path.stat().st_size
        total_before += before
        try:
            packed = optimized_bytes(path, args.quality)
            if packed is None:
                skipped += 1
                total_after += before
                continue
            after = len(packed)
            gain = 100 * (before - after) / before if before else 0
            if after >= before or gain < args.min_save:
                skipped += 1
                total_after += before
                continue
            changed += 1
            total_after += after
            results.append((path.relative_to(project).as_posix(), before, after, gain))
            if args.apply:
                dest = backup / path.relative_to(project)
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(path, dest)
                # Stage first; only replace a completed encode.
                temp = path.with_name(path.name + '.compressing_tmp')
                try:
                    temp.write_bytes(packed)
                    temp.replace(path)
                finally:
                    if temp.exists():
                        temp.unlink()
        except (OSError, ValueError, UnidentifiedImageError) as exc:
            errors += 1
            total_after += before
            print(f'WARNING: skipped {path.relative_to(project)}: {exc}')
    for name, b, a, gain in sorted(results, key=lambda x: x[1]-x[2], reverse=True)[:25]:
        print(f'  {b/1024/1024:7.2f} -> {a/1024/1024:7.2f} MB ({gain:5.1f}%): {name}')
    delta = total_before - total_after
    print(f'\nMode: {"APPLIED" if args.apply else "PREVIEW ONLY -- no files changed"}')
    print(f'Images scanned: {len(files)}; smaller: {changed}; unchanged/skipped: {skipped}; errors: {errors}')
    print(f'Scanned files total: {total_before/1024/1024:.2f} MB -> {total_after/1024/1024:.2f} MB')
    print(f'Potential saving: {delta/1024/1024:.2f} MB ({100*delta/total_before if total_before else 0:.1f}%)')
    if args.apply:
        print(f'Originals backed up at: {backup if changed else "not needed"}')
    print('Note: APK/AAB download savings may differ because the build may compress assets too.')
    return 1 if errors else 0

if __name__ == '__main__':
    raise SystemExit(main())

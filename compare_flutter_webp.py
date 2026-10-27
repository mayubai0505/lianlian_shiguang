#!/usr/bin/env python3
"""Read-only Flutter image asset WebP comparison. Requires Pillow."""
import argparse
import csv
import io
from collections import defaultdict
from pathlib import Path
from PIL import Image, UnidentifiedImageError

EXTS = {'.png', '.jpg', '.jpeg'}

def mb(n):
    return f'{n / (1024 * 1024):.2f} MB'

def main():
    parser = argparse.ArgumentParser(description='Compare WebP variants without changing originals')
    parser.add_argument('--project', default='.', help='Flutter project directory')
    parser.add_argument('--images-dir', default='assets/images')
    parser.add_argument('--report-dir', default='webp_comparison_report')
    args = parser.parse_args()
    root = Path(args.project).resolve()
    images = root / args.images_dir
    report = root / args.report_dir
    if not images.is_dir():
        parser.error(f'Image folder not found: {images}')
    paths = sorted(p for p in images.rglob('*') if p.is_file() and p.suffix.lower() in EXTS)
    if not paths:
        parser.error(f'No PNG/JPG/JPEG files in {images}')
    report.mkdir(parents=True, exist_ok=True)
    rows = []
    errors = []
    options = [('lossless', {'lossless': True, 'method': 6}), ('q90', {'quality': 90, 'method': 6}), ('q85', {'quality': 85, 'method': 6})]
    totals = defaultdict(int)
    folders = defaultdict(lambda: defaultdict(int))
    for i, path in enumerate(paths, 1):
        rel = path.relative_to(root).as_posix()
        bucket = path.relative_to(images).parts[0] if len(path.relative_to(images).parts) > 1 else '(root)'
        original = path.stat().st_size
        try:
            with Image.open(path) as im:
                im.load()
                if im.mode not in ('RGB', 'RGBA'):
                    im = im.convert('RGBA' if ('A' in im.getbands() or 'transparency' in im.info) else 'RGB')
                sizes = {}
                for name, kw in options:
                    buf = io.BytesIO()
                    im.save(buf, format='WEBP', **kw)
                    sizes[name] = buf.tell()
                row = {'path': rel, 'folder': bucket, 'width': im.width, 'height': im.height,
                       'original_bytes': original, 'webp_lossless_bytes': sizes['lossless'],
                       'webp_q90_bytes': sizes['q90'], 'webp_q85_bytes': sizes['q85']}
                rows.append(row)
                totals['original'] += original
                folders[bucket]['original'] += original
                for name in sizes:
                    totals[name] += sizes[name]
                    folders[bucket][name] += sizes[name]
        except (OSError, ValueError, UnidentifiedImageError) as exc:
            errors.append(f'{rel}: {exc}')
        if i % 25 == 0 or i == len(paths):
            print(f'Processed {i}/{len(paths)} images')
    csv_path = report / 'image_comparison.csv'
    with csv_path.open('w', encoding='utf-8-sig', newline='') as fp:
        writer = csv.DictWriter(fp, fieldnames=['path', 'folder', 'width', 'height', 'original_bytes', 'webp_lossless_bytes', 'webp_q90_bytes', 'webp_q85_bytes'])
        writer.writeheader()
        writer.writerows(rows)
    lines = ['Flutter WebP image size comparison (READ-ONLY)', '', f'Project: {root}',
             f'Images folder: {images}', f'Images scanned: {len(paths)}', f'Images compared: {len(rows)}',
             f'Errors: {len(errors)}', '', f'Original total: {mb(totals["original"])}']
    for name, label in [('lossless', 'WebP lossless'), ('q90', 'WebP quality 90'), ('q85', 'WebP quality 85')]:
        saving = totals['original'] - totals[name]
        percentage = saving / totals['original'] * 100 if totals['original'] else 0
        lines.append(f'{label}: {mb(totals[name])} | saving {mb(saving)} ({percentage:.1f}%)')
    lines += ['', 'Per-folder comparison (MB, originals -> lossless / q90 / q85):']
    for folder, t in sorted(folders.items(), key=lambda kv: kv[1]['original'], reverse=True):
        lines.append(f'{folder}: {mb(t["original"])} -> {mb(t["lossless"])} / {mb(t["q90"])} / {mb(t["q85"])}')
    lines += ['', 'Important: These figures compare file sizes before APK/AAB packaging.',
              'No source files, paths, Dart code, or Flutter assets have been modified.',
              'Lossy WebP quality must be visually inspected before conversion.']
    if errors:
        lines += ['', 'Errors:', *errors]
    (report / 'summary.txt').write_text('\n'.join(lines) + '\n', encoding='utf-8-sig')
    print('\n'.join(lines))
    print(f'\nReport: {report}')

if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""Conservative Flutter image migration: preview, then WebP conversion and literal path rewrite.
Requires Pillow: py -m pip install pillow
"""
import argparse, csv, datetime, json, re, shutil, sys
from pathlib import Path
from PIL import Image

TEXT_EXTS={'.dart','.yaml','.yml','.json','.arb','.xml','.gradle','.kts','.html','.css','.js','.ts','.md','.txt'}
SKIP_DIRS={'.git','.dart_tool','build','.idea','.gradle','node_modules','webp_comparison_report','image_compression_backups','webp_migration_backups','translation_zips','l10n_merge_backups'}

def main():
 p=argparse.ArgumentParser(description='Preview or migrate Flutter bundled PNG/JPEG images to WebP.')
 p.add_argument('--project',default='.')
 p.add_argument('--apply',action='store_true',help='Perform conversion + update literal references + backup')
 p.add_argument('--quality',type=int,default=90)
 p.add_argument('--min-saving',type=float,default=0.15,help='Minimum fraction saved to convert (default 0.15)')
 p.add_argument('--include',choices=['all','safe'],default='safe',help='safe excludes likely icons/logos/badges/splash/launch assets')
 args=p.parse_args()
 root=Path(args.project).resolve(); folder=root/'assets'/'images'
 if not folder.is_dir(): p.error(f'Images not found: {folder}')
 if not 1<=args.quality<=100 or not 0<=args.min_saving<1: p.error('invalid quality or min-saving')
 images=sorted(p for p in folder.rglob('*') if p.is_file() and p.suffix.lower() in ('.png','.jpg','.jpeg'))
 source_files=[]
 for path in root.rglob('*'):
  if not path.is_file() or path.suffix.lower() not in TEXT_EXTS or any(x in SKIP_DIRS for x in path.relative_to(root).parts): continue
  if path.stat().st_size>8_000_000: continue
  try: source_files.append((path,path.read_text(encoding='utf-8')))
  except UnicodeError: pass
 manifest=[]; choices=[]; unsafe=[]
 risky=re.compile(r'(^|[/_])(icon|icons|logo|badge|splash|launch|adaptive|notification|app_icon)([/_.-]|$)',re.I)
 for image in images:
  rel=image.relative_to(root).as_posix(); new=image.with_suffix('.webp'); newrel=new.relative_to(root).as_posix()
  if new.exists(): manifest.append((rel,'SKIP: webp already exists',0,0)); continue
  if args.include=='safe' and risky.search(rel): manifest.append((rel,'SKIP: protected icon/logo/splash',0,0)); continue
  # Exact literal strings only. Dynamic path assembly must be inspected by developer.
  references=[]
  for file,contents in source_files:
   if rel in contents: references.append(file)
  if not references:
   manifest.append((rel,'SKIP: no literal full path found',0,0)); continue
  try:
   with Image.open(image) as im:
    # Keep alpha and RGB; conversion only for display assets.
    if im.mode not in ('RGB','RGBA'): im=im.convert('RGBA' if ('A' in im.getbands() or 'transparency' in im.info) else 'RGB')
    import io
    buffer=io.BytesIO(); im.save(buffer,format='WEBP',quality=args.quality,method=6)
    blob=buffer.getvalue()
   old=image.stat().st_size; newsize=len(blob); saving=1-newsize/old
   if saving<args.min_saving: manifest.append((rel,'SKIP: not enough saving',old,newsize)); continue
   # Safety: paths that occur only in source refs are safe to rewrite; dynamic assembly cannot be detected automatically.
   choices.append((image,new,rel,newrel,blob,references,old,newsize))
   manifest.append((rel,'CONVERT',old,newsize))
  except Exception as e: manifest.append((rel,'ERROR: '+str(e),0,0))
 total_old=sum(item[-2] for item in choices); total_new=sum(item[-1] for item in choices)
 print(f'Mode: {"APPLY" if args.apply else "PREVIEW"}; scanned {len(images)} images; selected {len(choices)}; saving {(total_old-total_new)/1048576:.2f} MiB (selected only)')
 for image,new,rel,newrel,blob,refs,old,newsize in sorted(choices,key=lambda x:x[-2]-x[-1],reverse=True)[:25]:
  print(f' {old/1048576:5.2f} -> {newsize/1048576:5.2f} MiB  {rel}  ({len(refs)} source files)')
 if not args.apply:
  print('No files modified. NOTE: dynamic paths, other assets and pubspec entries need manual review. Run with --apply after checking.')
  return
 if not choices: print('No candidates.');return
 stamp=datetime.datetime.now().strftime('%Y%m%d_%H%M%S_%f')
 backup=root/'webp_migration_backups'/stamp
 backup.mkdir(parents=True,exist_ok=False)
 # Take complete backups for EVERY affected text file and selected original, to allow rollback.
 selected_rel={item[2]:item[3] for item in choices}
 impacted=[]
 for file,contents in source_files:
  if any(old in contents for old in selected_rel): impacted.append((file,contents))
 try:
  for image,new,rel,newrel,blob,refs,old,newsize in choices:
   dest=backup/image.relative_to(root);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(image,dest)
  for file,contents in impacted:
   dest=backup/file.relative_to(root);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(file,dest)
  (backup/'manifest.json').write_text(json.dumps({'originalFiles':[i[2] for i in choices],'rewrittenFiles':[str(f.relative_to(root).as_posix()) for f,_ in impacted]},ensure_ascii=False,indent=2),encoding='utf-8')
  # Write converted files atomically via temporary filenames.
  for image,new,rel,newrel,blob,refs,old,newsize in choices:
   temp=new.with_name(new.name+'.tmp');temp.write_bytes(blob);temp.replace(new)
  for file,contents in impacted:
   changed=contents
   for old,new in selected_rel.items(): changed=changed.replace(old,new)
   if changed!=contents: file.write_text(changed,encoding='utf-8')
  # Only after references have been updated, remove selected old assets.
  for image,*_ in choices: image.unlink()
 except Exception:
  print('FAILED. Backups available at',backup,'; check for partial changes and restore before retrying.',file=sys.stderr)
  raise
 print('DONE. Backup:',backup)
 print('CHECK: search your project for old .png/.jpg references, including dynamic path construction, and run flutter analyze/build.')
 print('Rollback note: original images and source text files are under the backup folder (same relative paths).')

if __name__=='__main__': main()

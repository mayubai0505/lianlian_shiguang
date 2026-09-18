from pathlib import Path
from PIL import Image
import shutil
import sys
import time

ROOT = Path("assets/images")
BACKUP_ROOT = Path("assets_backup_before_png_compress")

# 先壓最肥的資料夾；想全部壓可把 TARGETS 改成 ["."]
TARGETS = [
    "theme",
    "store",
    "guide",
    "character_create",
    "chat",
]

PNG_EXTS = {".png"}

def human_mb(size: int) -> str:
    return f"{size / 1024 / 1024:.2f} MB"

def backup_file(src: Path):
    rel = src.relative_to(ROOT)
    dst = BACKUP_ROOT / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    if not dst.exists():
        shutil.copy2(src, dst)

def compress_png(path: Path):
    original_size = path.stat().st_size
    backup_file(path)

    temp_path = path.with_suffix(".tmp.png")

    try:
        with Image.open(path) as img:
            # 保留透明背景 / 色彩模式，不改圖片尺寸
            img.load()

            save_kwargs = {
                "optimize": True,
                "compress_level": 9,
            }

            # 保留 ICC / DPI / transparency 等常見資訊
            if "icc_profile" in img.info:
                save_kwargs["icc_profile"] = img.info["icc_profile"]
            if "dpi" in img.info:
                save_kwargs["dpi"] = img.info["dpi"]

            img.save(temp_path, format="PNG", **save_kwargs)

        new_size = temp_path.stat().st_size

        # 只有真的變小才覆蓋，避免越壓越大
        if new_size < original_size:
            temp_path.replace(path)
            return original_size, new_size, True
        else:
            temp_path.unlink(missing_ok=True)
            return original_size, original_size, False

    except Exception as e:
        temp_path.unlink(missing_ok=True)
        return original_size, original_size, f"ERROR: {e}"

def main():
    if not ROOT.exists():
        print(f"❌ 找不到 {ROOT.resolve()}")
        print("請在 Flutter 專案根目錄執行這支程式。")
        sys.exit(1)

    try:
        import PIL  # noqa
    except Exception:
        print("❌ 尚未安裝 Pillow")
        print("請先執行：python -m pip install pillow")
        sys.exit(1)

    files = []
    for target in TARGETS:
        folder = ROOT / target
        if not folder.exists():
            print(f"⚠️ 找不到資料夾，跳過：{folder}")
            continue
        files.extend(
            p for p in folder.rglob("*")
            if p.is_file() and p.suffix.lower() in PNG_EXTS
        )

    files = sorted(set(files))

    if not files:
        print("❌ 沒找到 PNG")
        return

    total_before = sum(p.stat().st_size for p in files)
    total_after = 0
    changed = 0
    skipped = 0
    errors = []

    print(f"找到 {len(files)} 張 PNG")
    print(f"壓縮前總大小：{human_mb(total_before)}")
    print(f"備份位置：{BACKUP_ROOT.resolve()}")
    print()

    start = time.time()

    for i, path in enumerate(files, 1):
        before, after, status = compress_png(path)
        total_after += after

        rel = path.relative_to(ROOT)

        if status is True:
            changed += 1
            saved = before - after
            print(
                f"✅ [{i}/{len(files)}] {rel} | "
                f"{human_mb(before)} → {human_mb(after)} | "
                f"省 {human_mb(saved)}"
            )
        elif status is False:
            skipped += 1
            print(
                f"➖ [{i}/{len(files)}] {rel} | "
                f"已經夠小，跳過"
            )
        else:
            errors.append((str(rel), status))
            print(f"❌ [{i}/{len(files)}] {rel} | {status}")

    elapsed = time.time() - start
    saved_total = total_before - total_after
    percent = (saved_total / total_before * 100) if total_before else 0

    print()
    print("=" * 72)
    print("完成")
    print(f"成功縮小：{changed} 張")
    print(f"無需覆蓋：{skipped} 張")
    print(f"錯誤：{len(errors)} 張")
    print(f"壓縮前：{human_mb(total_before)}")
    print(f"壓縮後：{human_mb(total_after)}")
    print(f"總共省下：{human_mb(saved_total)} ({percent:.1f}%)")
    print(f"耗時：{elapsed:.1f} 秒")
    print("=" * 72)

    if errors:
        print()
        print("錯誤檔案：")
        for name, err in errors:
            print(f"- {name}: {err}")

    print()
    print("接著建議執行：")
    print("flutter clean")
    print("flutter pub get")
    print("flutter build appbundle")
    print()
    print("如果畫面有任何異常，可從 assets_backup_before_png_compress 還原。")

if __name__ == "__main__":
    main()

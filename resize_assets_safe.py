from pathlib import Path
from PIL import Image
import shutil
import sys
import time

ROOT = Path("assets/images")
BACKUP_ROOT = Path("assets_backup_before_resize")

# 這輪先處理最肥、最可能有大圖的資料夾
TARGETS = [
    "theme",
    "store",
    "guide",
    "character_create",
    "chat",
]

# 各資料夾安全上限（長邊像素）
# 手機 UI 基本上 1400~1600 已經很夠用，先保守縮一輪。
MAX_LONG_EDGE_BY_FOLDER = {
    "theme": 1600,
    "store": 1600,
    "guide": 1440,
    "character_create": 1440,
    "chat": 1400,
}

ALLOWED_EXTS = {".png", ".jpg", ".jpeg", ".webp"}

def human_mb(size: int) -> str:
    return f"{size / 1024 / 1024:.2f} MB"

def backup_file(src: Path):
    rel = src.relative_to(ROOT)
    dst = BACKUP_ROOT / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    if not dst.exists():
        shutil.copy2(src, dst)

def get_target_folder(file_path: Path) -> str:
    rel = file_path.relative_to(ROOT)
    parts = rel.parts
    return parts[0] if parts else ""

def resize_dims(width: int, height: int, max_long_edge: int):
    long_edge = max(width, height)
    if long_edge <= max_long_edge:
        return width, height, False

    scale = max_long_edge / long_edge
    new_w = max(1, round(width * scale))
    new_h = max(1, round(height * scale))
    return new_w, new_h, True

def save_image(img: Image.Image, out_path: Path, original_suffix: str):
    suffix = original_suffix.lower()

    save_kwargs = {}
    if "icc_profile" in img.info:
        save_kwargs["icc_profile"] = img.info["icc_profile"]
    if "dpi" in img.info:
        save_kwargs["dpi"] = img.info["dpi"]

    if suffix == ".png":
        img.save(
            out_path,
            format="PNG",
            optimize=True,
            compress_level=9,
            **save_kwargs,
        )
        return

    if suffix in {".jpg", ".jpeg"}:
        # JPEG 不支援透明，如果有 alpha 先鋪白底
        if img.mode in ("RGBA", "LA"):
            bg = Image.new("RGB", img.size, (255, 255, 255))
            if img.mode == "RGBA":
                bg.paste(img, mask=img.getchannel("A"))
            else:
                bg.paste(img)
            img = bg
        else:
            img = img.convert("RGB")

        img.save(
            out_path,
            format="JPEG",
            optimize=True,
            progressive=True,
            quality=88,
            **save_kwargs,
        )
        return

    if suffix == ".webp":
        img.save(
            out_path,
            format="WEBP",
            quality=90,
            method=6,
            **save_kwargs,
        )
        return

    # fallback
    img.save(out_path, **save_kwargs)

def process_file(path: Path):
    folder = get_target_folder(path)
    max_long_edge = MAX_LONG_EDGE_BY_FOLDER.get(folder, 1440)

    original_size = path.stat().st_size
    backup_file(path)

    with Image.open(path) as img:
        img.load()
        original_mode = img.mode
        original_w, original_h = img.size
        new_w, new_h, should_resize = resize_dims(
            original_w,
            original_h,
            max_long_edge,
        )

        if not should_resize:
            return {
                "status": "skip",
                "path": path,
                "reason": f"尺寸已在安全範圍內（{original_w}x{original_h}）",
                "before": original_size,
                "after": original_size,
            }

        # 高品質縮圖
        resized = img.resize((new_w, new_h), Image.LANCZOS)

        temp_path = path.with_suffix(".tmp" + path.suffix)
        save_image(resized, temp_path, path.suffix)
        new_size = temp_path.stat().st_size

        # 只在檔案真的變小時覆蓋，避免越縮越大
        if new_size < original_size:
            temp_path.replace(path)
            return {
                "status": "changed",
                "path": path,
                "before": original_size,
                "after": new_size,
                "old_size": (original_w, original_h),
                "new_size_px": (new_w, new_h),
                "mode": original_mode,
            }
        else:
            temp_path.unlink(missing_ok=True)
            return {
                "status": "skip",
                "path": path,
                "reason": (
                    f"縮圖後檔案未變小（{original_w}x{original_h} -> {new_w}x{new_h}，"
                    f"{human_mb(original_size)} -> {human_mb(new_size)}）"
                ),
                "before": original_size,
                "after": original_size,
            }

def main():
    if not ROOT.exists():
        print(f"❌ 找不到資料夾：{ROOT.resolve()}")
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
        files.extend([
            p for p in folder.rglob("*")
            if p.is_file() and p.suffix.lower() in ALLOWED_EXTS
        ])

    files = sorted(set(files))
    if not files:
        print("❌ 找不到可處理的圖片檔。")
        return

    total_before = sum(p.stat().st_size for p in files)
    total_after = 0
    changed = 0
    skipped = 0
    errors = []

    print(f"找到 {len(files)} 張圖片")
    print(f"處理資料夾：{', '.join(TARGETS)}")
    print(f"壓縮前總大小：{human_mb(total_before)}")
    print(f"備份位置：{BACKUP_ROOT.resolve()}")
    print()

    start = time.time()

    for i, path in enumerate(files, 1):
        rel = path.relative_to(ROOT)
        try:
            result = process_file(path)
        except Exception as e:
            errors.append((str(rel), str(e)))
            size_now = path.stat().st_size
            total_after += size_now
            print(f"❌ [{i}/{len(files)}] {rel} | ERROR: {e}")
            continue

        total_after += result["after"]

        if result["status"] == "changed":
            changed += 1
            old_w, old_h = result["old_size"]
            new_w, new_h = result["new_size_px"]
            saved = result["before"] - result["after"]
            print(
                f"✅ [{i}/{len(files)}] {rel} | "
                f"{old_w}x{old_h} -> {new_w}x{new_h} | "
                f"{human_mb(result['before'])} -> {human_mb(result['after'])} | "
                f"省 {human_mb(saved)}"
            )
        else:
            skipped += 1
            print(
                f"➖ [{i}/{len(files)}] {rel} | "
                f"{result['reason']}"
            )

    elapsed = time.time() - start
    saved_total = total_before - total_after
    percent = (saved_total / total_before * 100) if total_before else 0

    print()
    print("=" * 72)
    print("完成")
    print(f"成功縮小：{changed} 張")
    print(f"略過：{skipped} 張")
    print(f"錯誤：{len(errors)} 張")
    print(f"處理前：{human_mb(total_before)}")
    print(f"處理後：{human_mb(total_after)}")
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
    print("flutter build appbundle --analyze-size --target-platform android-arm64")
    print()
    print("如果畫面有任何異常，可從 assets_backup_before_resize 還原。")

if __name__ == "__main__":
    main()

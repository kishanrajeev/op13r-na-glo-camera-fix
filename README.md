# OnePlus 13R Camera Fix (GLO ROM)

Fixes the stock OplusCamera crash on **OnePlus 13R (CPH2647)** after flashing a **global ROM**.

## The Problem

The stock camera app opens for a split second then silently crashes with:

```
java.lang.UnsatisfiedLinkError: dlopen failed: library "libCombineLutJni.so" not found
```

**Root cause:** The camera app's linker namespace searches `/product/lib64/` and `/system/product/lib64/` but **not** `/my_product/lib64/` — where the actual `.so` files live. On a rooted device, Magisk can't overlay `/my_product/` either.

## What This Module Does

| Component | What | How |
|---|---|---|
| **40 native libraries** | All `.so` files from `/my_product/lib64/` | Magisk overlay → `/system/product/lib64/` |
| **7 ODM tuning configs** | NA-region camera tuning parameters | `mount --bind` at late boot → `/odm/etc/camera/config/` |

Together these give the camera app everything it needs to initialize.

## Compatibility

- **Device:** OnePlus 13R (CPH2647 / CPH2645)
- **ROM:** Global (GLO) — V.R4T3.xxx
- **Android:** 15+
- **Magisk:** v24+ (Zygisk not required)
- **Camera app:** `com.oplus.camera` v6.020.875+

## Verification

```shell
# Camera opens successfully
adb shell am start -n com.oplus.camera/.Camera

# Libraries are in place
adb shell ls -la /system/product/lib64/libCombineLut*

# ODM configs are bound
adb shell mount | grep odm/etc/camera/config
```

## Build from source

```shell
git clone https://github.com/kishanrajeev/op13r-na-glo-camera-fix
cd oneplus-13r-camera-fix
python3 -c "import shutil; shutil.make_archive('camera_fix_oneplus_13r', 'zip', 'module')"
```

## Credits

Based on original research and community debugging of the product-clns-9 linker namespace issue on OnePlus 13R.

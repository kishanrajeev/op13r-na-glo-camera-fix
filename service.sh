#!/system/bin/sh
# Overlay NA ODM camera configs — runs post-boot, no boot delay
MODDIR=${0%/*}
for f in "$MODDIR"/odm/etc/camera/config/*; do
  [ -f "$f" ] && mount --bind "$f" "/odm/etc/camera/config/$(basename "$f")"
done

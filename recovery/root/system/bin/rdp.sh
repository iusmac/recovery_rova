#!/system/bin/sh

if dd if=/dev/block/by-name/system bs=256k count=1|strings|grep mi8937_dynpart > /dev/null; then
    echo >> /system/etc/recovery.fstab
    for p in system system_ext product vendor odm; do
        echo "${p} /${p} ext4 rw,barrier=1,discard wait,logical" >> /system/etc/recovery.fstab
    done
else
    echo >> /system/etc/twrp.flags
    cat /system/etc/twrp.flags.nondynpart >> /system/etc/twrp.flags
fi

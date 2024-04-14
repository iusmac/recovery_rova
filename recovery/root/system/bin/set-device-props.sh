#!/sbin/sh

set_device_codename() {
    resetprop "ro.build.product" "$1"
    resetprop "ro.omni.device" "$1"
    resetprop "ro.product.device" "$1"
    for i in odm product system system_ext vendor; do
        resetprop "ro.product.${i}.device" "$1"
    done
}

set_device_model() {
    resetprop "ro.product.model" "$1"
    for i in odm product system system_ext vendor; do
        resetprop "ro.product.${i}.model" "$1"
    done
}

set_device_codename "$(cat /sys/xiaomi-msm8937-mach/codename)"
set_device_model "$(cat /sys/xiaomi-msm8937-mach/product_name)"

# Workaround GPIO flashlight
echo 1 > /sys/class/leds/flashlight/max_brightness;
echo 0 > /sys/class/leds/flashlight/brightness;

exit 0

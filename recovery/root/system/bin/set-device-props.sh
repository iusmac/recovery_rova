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

case "$(cat /sys/firmware/devicetree/base/model)" in
    "Qualcomm Technologies, Inc. MSM8917-PMI8937 QRD SKU5")
        if [ -e /sys/class/leds/infrared/transmit ]; then
            set_device_codename "rolex"
            set_device_model "Redmi 4A"
        else
            set_device_codename "riva"
            set_device_model "Redmi 5A (Nougat bootloader)"
        fi
        ;;
    "Qualcomm Technologies, Inc. MSM8917 QRD SKU5")
        set_device_codename "riva"
        set_device_model "Redmi 5A (Oreo bootloader)"
        ;;
esac

exit 0

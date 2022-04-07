#!/sbin/sh -e

echo "USB Storage Exporter script by 0xCAFEBABE"
echo

abort() {
    echo "Error: $*"
    exit 1
}

LUN="/config/usb_gadget/g1/functions/mass_storage.0/lun.0"
PARTS="/dev/block/bootdevice/by-name"

if ! [ -d "$LUN" ]; then
    abort "$LUN does not exist"
fi

if [ "$(cat /sys/class/power_supply/usb/present)" == "1" ]; then
    abort "Please disconnect USB and use this script in device's Terminal!"
fi

if [ "$#" -eq 0 ]; then
    echo "Usage 1: "
    echo "  ${0} <cust|system|vendor>"
    echo "    Export cust|system|vendor partition as read-write and removable."
    echo
    echo "Usage 2: "
    echo "  ${0} -f <FILE> -p <PART> [-c] [-n] [-rm] [-ro]"
    echo "    -f <FILE>: Specify the file to export."
    echo "    -p <PART>: Specify the partition to export."
    echo "    -c: Export as CDROM."
    echo "    -n: Ignore FUA flag."
    echo "    -rm: Removable."
    echo "    -ro: Read-only."
    exit 0
fi

FILE=""
PART=""
CDROM=""
NOFUA=""
REMOVABLE=""
RO=""

if [ "${#}" -eq 1 ]; then
    case "${1}" in
        "cust"|"system"|"vendor")
            PART="${1}"
            REMOVABLE="1"
            ;;
        ""|*)
            abort "Unsupported partition: ${1}"
            ;;
    esac
else
    while [ "${#}" -gt 0 ]; do
        case "${1}" in
            -f )
                FILE="${2}"
                shift
                shift
                ;;
            -p )
                PART="${2}"
                shift
                shift
                ;;
            -c )
                CDROM="1"
                shift
                ;;
            -n )
                NOFUA="1"
                shift
                ;;
            -rm )
                REMOVABLE="1"
                shift
                ;;
            -ro )
                RO="1"
                shift
                ;;
            *)
                abort "Invalid parameter: ${1}"
                shift
                ;;
        esac
    done
fi

if [ "$FILE" ]; then
    FILE="$(realpath ${FILE} 2>/dev/null || true)"
fi
if [ "$PART" ]; then
    PART="$(realpath ${PARTS}/${PART} 2>/dev/null || true)"
fi
echo "FILE=${FILE} PART=${PART}"
echo

if [ -z "$FILE" ] && [ -z "$PART" ]; then
    abort "Please specify either a file or a partition"
elif [ "$FILE" ] && [ "$PART" ]; then
    abort "Please specify either file or partition only"
fi

if [ "$PART" ]; then
    if grep "$PART" /proc/mounts; then
        abort "Please unmount the partition first!"
    fi
    FILE="$PART"
fi

USB_CFG="$(getprop sys.usb.config)"
echo "Previous USB config: $USB_CFG"
if [ "$USB_CFG" == "adb" ] || [ "$USB_CFG" == "mtp,adb" ] || [ "$USB_CFG" == "mass_storage,adb" ]; then
    setprop sys.usb.config none || abort "Failed to clear USB configuration"
    sleep 0.2s
    setprop sys.usb.config mass_storage,adb || abort "Failed to set USB config to mass_storage,adb"
else
    setprop sys.usb.config none || abort "Failed to clear USB configuration"
    sleep 0.2s
    setprop sys.usb.config mass_storage || abort "Failed to set USB config to mass_storage"
fi
echo "New USB config: $(getprop sys.usb.config)"
echo

echo > ${LUN}/file || abort "Failed to reset file"
if [ "$NOFUA" ]; then
    echo 1 > ${LUN}/nofua || abort "Failed to set nofua to 1"
else
    echo 0 > ${LUN}/nofua || abort "Failed to set nofua to 0"
fi
if [ "$REMOVABLE" ]; then
    echo 1 > ${LUN}/removable || abort "Failed to set removable to 1"
else
    echo 0 > ${LUN}/removable || abort "Failed to set removable to 0"
fi
if [ "$CDROM" ]; then
    echo 1 > ${LUN}/cdrom || abort "Failed to set cdrom to 1"
else
    echo 0 > ${LUN}/cdrom || abort "Failed to set cdrom to 0"
fi
if [ "$RO" ]; then
    echo 1 > ${LUN}/ro || abort "Failed to set ro to 1"
else
    echo 0 > ${LUN}/ro || abort "Failed to set ro to 0"
fi
echo -n "${FILE}" > ${LUN}/file || abort "Failed to set file to ${FILE}"

echo "Done. To unexport USB Storage, Just toggle any USB related switch."
echo
echo "If this device doesn't get detected, Try replugging USB cable."

exit 0
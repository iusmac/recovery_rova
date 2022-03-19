#!/usr/bin/env bash

# Execute this script from source root directory

function main() {
    for patch in \
        bootable_recovery-DontAlterDT2W.patch \
        bootable_recovery-Fix-keymaster-on-A12.patch
    do
        file="ofox-9.0/$patch"

        __processPatch__ 'bootable/recovery' "$file" || exit $?
    done

    for patch in \
        vendor_recovery-SkipDeviceCheck.patch \
        vendor_recovery-SetMaxBrightness.patch
    do
        file="ofox-9.0/$patch"

        __processPatch__ 'vendor/recovery' "$file" || exit $?
    done

    for patch in \
        system_core-read_FDT_xiaomi_device-ForceADB.patch \
        system_core-read_FDT_xiaomi_device.patch
    do
        __processPatch__ 'system/core' "$patch" || exit $?
    done
}

function __processPatch__() {
    local root="${1-}"
    local file="${2-}"

    if __confirm__ "Apply $file?"; then
        git -C "$root" apply --verbose "$__DIR__/$file" || exit $?
    elif __confirm__ "Revert $file?"; then
        git -C "$root" apply --verbose --reverse "$__DIR__/$file" || exit $?
    fi
}

function __confirm__() {
    while true; do
        read -rp "- ${1-} [Y/n] "

        if [ "$REPLY" = 'Y' ]; then
            return 0
        elif [ "$REPLY" = 'n' ]; then
            return 1
        fi
    done
}

__DIR__="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

main

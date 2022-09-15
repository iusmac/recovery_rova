#!/usr/bin/env bash

# Execute this script from source root directory

function main() {
    for patch in \
        bootable_recovery-Add-FBE-alert.patch \
        bootable_recovery-Fix-the-progress-bar.patch \
        bootable_recovery-Save-screenshot-to-tmp-screenshots-if-sdcard-is-not-mounted.patch \
        bootable_recovery-data-Concatenate-battery-temperature-with-CPU-temperature.patch \
        bootable_recovery-Copy-fox-persist-dependencies-to-ramdisk.patch
    do
        file="ofox-12.1/$patch"

        __processPatch__ 'bootable/recovery' "$file" || exit $?
    done

    for patch in \
        system_core-Build-fastboot-binary.patch
    do
        __processPatch__ 'system/core' "$patch" || exit $?
    done

    for patch in \
        bootable_recovery-Render-UI-at-60-FPS.patch
    do
        __processPatch__ 'bootable/recovery' "$patch" || exit $?
    done

    for patch in \
        vendor_recovery-Copy-fox-dependencies-to-persist.patch
    do
        file="ofox-12.1/$patch"
        __processPatch__ 'vendor/recovery' "$file" || exit $?
    done
}

function __processPatch__() {
    local root="${1-}"
    local file="${2-}"

    if __confirm__ "Apply $file?"; then
        patch --directory="$root" -p1 --verbose < "$__DIR__/$file" || exit $?
    elif __confirm__ "Revert $file?"; then
        patch --directory="$root" -p1 --verbose --reverse < "$__DIR__/$file" || exit $?
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

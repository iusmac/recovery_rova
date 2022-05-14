#!/usr/bin/env bash
# This file is part of the OrangeFox Recovery Project
# Copyright (C) 2018-2022 The OrangeFox Recovery Project
#
# OrangeFox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# OrangeFox is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# This software is released under GPL version 3 or any later version.
# See <http://www.gnu.org/licenses/>.
#
# Please maintain this if you use this script or any part of it

FDEVICE='rova'

if ! [ "$1" = "$FDEVICE" ]; then
    if ! [ "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
        exit 1
    fi
fi

export TW_DEFAULT_LANGUAGE='en'
export OF_DONT_PATCH_ENCRYPTED_DEVICE='1'
export FOX_USE_BASH_SHELL=0
export FOX_ASH_IS_BASH=0
export FOX_REMOVE_BASH=1
export FOX_USE_NANO_EDITOR='1'
export FOX_USE_TAR_BINARY='1'
export FOX_USE_SED_BINARY='1'
export FOX_USE_XZ_UTILS='1'
export FOX_REPLACE_BUSYBOX_PS='1'
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER='1'
export FOX_RECOVERY_VENDOR_PARTITION='/dev/block/bootdevice/by-name/cust'
export OF_CHECK_OVERWRITE_ATTEMPTS='1'
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES='1'
export OF_USE_MAGISKBOOT='1'
export OF_USE_LOCKSCREEN_BUTTON='1'
export OF_NO_MIUI_OTA_VENDOR_BACKUP='1'
export OF_NO_TREBLE_COMPATIBILITY_CHECK='1'
export OF_USE_SYSTEM_FINGERPRINT='1'
export LC_ALL='C'
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_REMOVE_AAPT='1'

# export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION='1';
# Disabling dm-verity causes stability issues with some kernel 4.9 ROMs; but is
# needed for MIUI
export OF_FORCE_DISABLE_DM_VERITY_MIUI='1'
export OF_FORCE_MAGISKBOOT_BOOT_PATCH_MIUI='1'

# OTA for custom ROMs
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES='1'
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR='1'

# Settings for R11
export OF_MAINTAINER=iusmac
export OF_USE_TWRP_SAR_DETECT='1'
export OF_DISABLE_MIUI_OTA_BY_DEFAULT='1'
export OF_QUICK_BACKUP_LIST='/system_root;/vendor;/data;/persist;/boot;'
export FOX_VARIANT='FDE+FBE'

# Magisk
user='topjohnwu'
repo='Magisk'
pattern="$user/$repo/releases/download/[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+\.apk"
url="https://github.com/$user/$repo/releases/latest"

echo 'Searching for latest Magisk...'
html="$(curl --show-error --location "$url")" || {
    code=$?
    echo "Failed to download $url"
    exit $code
}

file_link="$(echo "$html" | grep -iEo "$pattern" | (head -n 1; dd status=none of=/dev/null))"
download_link="https://github.com/$file_link"
file_name="/tmp/$(basename "${file_link/apk/zip}")"

echo "Downloading Magisk from $download_link"
curl \
    --show-error \
    --location "$download_link" \
    --output "$file_name" || {
    code=$?
    echo "Failed to download $download_link"
    exit $code
}
echo "Latest Magisk has been saved to: $file_name"

export FOX_USE_SPECIFIC_MAGISK_ZIP="$file_name"

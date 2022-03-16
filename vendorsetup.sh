#!/usr/bin/env bash
# This file is part of the OrangeFox Recovery Project
# Copyright (C) 2018-2021 The OrangeFox Recovery Project
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

DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

FDEVICE='rova'

if ! [ "$1" = "$FDEVICE" ] && ! [ "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    exit 0
fi

export TW_DEFAULT_LANGUAGE='en'
export OF_DONT_PATCH_ENCRYPTED_DEVICE='1'
export FOX_USE_BASH_SHELL='1'
export FOX_ASH_IS_BASH='1'
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
export OF_SKIP_DECRYPTED_ADOPTED_STORAGE='1'

# export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION='1';
# Disabling dm-verity causes stability issues with some kernel 4.9 ROMs; but is
# needed for MIUI
export OF_FORCE_DISABLE_DM_VERITY_MIUI='1'
export OF_FORCE_MAGISKBOOT_BOOT_PATCH_MIUI='1'

# OTA for custom ROMs
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES='1'
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR='1'

# Settings for R11
export OF_USE_TWRP_SAR_DETECT='1'
export OF_DISABLE_MIUI_OTA_BY_DEFAULT='1'
export OF_QUICK_BACKUP_LIST='/system_root;/vendor;/data;/persist;/boot;'

# Magisk
export FOX_USE_SPECIFIC_MAGISK_ZIP="$DIR/addons/Magisk-v24.3.zip"

for flavor in eng user userdebug; do
    add_lunch_combo omni_"$FDEVICE"-$flavor
done

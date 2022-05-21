#!/usr/bin/env bash
# Copyright (C) 2018-2022 The OrangeFox Recovery Project
#
# OrangeFox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# OrangeFox is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# This software is released under GPL version 3 or any later version.
# See <http://www.gnu.org/licenses/>.
#
# Please maintain this if you use this script or any part of it
#
# ********************************************************************

function main() {
    action="$2"
    case "$action" in
        --first-call) # before ramdisk packing
            FOX_RAMDISK="$1"
            removeFonts
            compressAllPNGs
            addFBEFeatureToPartMgr
            ;;
        --last-call) # before .zip packing
            OF_WORKING_DIR="$1"
            assertRamdiskIsSmallerThan 20 # MiB
            copyVimToZip
    esac
}

function removeFonts() {
    local TWRES_DIR=$FOX_RAMDISK/twres
    local custom_xml=$TWRES_DIR/pages/customization.xml
    local image_xml=$TWRES_DIR/resources/images.xml
    local fonts_dir=$TWRES_DIR/fonts

    echo -e "${ORANGE}-- Removing some fonts from ramdisk... ${NC}"

    # Fonts to be deleted
    declare -A fonts=(
        ['font5']='Chococooky'
        ['font7']='Exo2-Regular'
        ['font8']='MILanPro-Regular'
        ['font9']='Amatic'
    )

    # Remove references to them in resources
    local font file
    for font in "${!fonts[@]}"; do
        file="$fonts_dir/${fonts["$font"]}.ttf"
        rm "$file"

        # Delete the matching line
        if __findMatch__ "$font" "$image_xml"; then
            sed -i "/$font/ d" "$image_xml"
        fi

        # Delete the matching line plus the next 2 lines
        if __findMatch__ "$font" "$custom_xml"; then
            sed -i "/$font/I,+2 d" "$custom_xml"
        fi
    done

    # Those are not mentioned in resources
    rm "$fonts_dir"/{Exo2,MILanPro}-Medium.ttf
    # Remove Japanese and Arab fonts since there's no translations for them
    rm "$fonts_dir"/{ae_Cortoba,NotoSansCJKjp-Regular}.ttf

    # Let FiraCode move to where Chococooky font was to avoid the gap
    if __findMatch__ 'row4_2a_y' "$custom_xml"; then
        sed -i 's/row4_2a_y/row4_1_y/g' "$custom_xml"
    fi
}

function assertRamdiskIsSmallerThan() {
    local max_ramdisk_size="${1-}"
    echo -ne "${ORANGE}-- Checking that recovery ramdisk size does not exceed ${max_ramdisk_size}MiB... ${NC}"

    local ramdisk="$OUT/ramdisk-recovery.img"
    if [ ! -f "$ramdisk" ]; then
        echo -e "${WHITEONRED} FAIL! Cannot find ramdisk file ${NC}"
        echo -e "--- Looked at $ramdisk"
        exit 1
    fi

    local ramdisk_size
    ramdisk_size="$(stat --format='%s' "$ramdisk")"
    local remaining=$((max_ramdisk_size * 1024 ** 2 - ramdisk_size))
    local pretty_rem
    pretty_rem="$(__prettyNumber__ "$remaining")"

    if [ $remaining -lt 0 ]; then
        echo -e "${WHITEONRED} FAIL! Exceeds by ${pretty_rem:1} bytes ${NC}"
        exit 1
    fi

    echo -e "${WHITEONGREEN} OK! Remaining $pretty_rem bytes ${NC}"
}

function compressAllPNGs() {
    echo -ne "${ORANGE}-- Compressing PNGs in ramdisk... ${NC}"

    local optipng="$SCRIPT_DIR/prebuilt/optipng/bin/linux/x64/optipng"
    local total_freed_bytes=0 old_size new_size code pretty_total
    while read -r file; do
        if [ ! -f "$file" ]; then
            continue
        fi

        old_size="$(stat --format='%s' "$file")"

        "$optipng" \
            -o0 \
            -clobber \
            -strip all \
            -quiet \
            "$file"; code=$?

        new_size="$(stat --format='%s' "$file")"
        if [ $code -eq 0 ] && [ "$old_size" -gt "$new_size" ]; then
            total_freed_bytes=$(( total_freed_bytes + (old_size - new_size) ))
        fi
    done <<< "$(find "$FOX_RAMDISK" -type f -name '*.png')"

    echo -e "${WHITEONGREEN} Freed up about $(__prettyNumber__ "$total_freed_bytes") bytes ${NC}"
}

function copyVimToZip() {
    echo -e "${GREY}-- Installing Vim editor... ${NC}"
    cp -a "$SCRIPT_DIR"/prebuilt/vim "$OF_WORKING_DIR/sdcard/Fox/FoxFiles"
}

function addFBEFeatureToPartMgr() {
    echo -e "${GREY}-- Adding FBE feature to Partition Manager... ${NC}"

    local TWRES_DIR=$FOX_RAMDISK/twres
    local wipe_xml=$TWRES_DIR/pages/wipe.xml
    local local_pages="$SCRIPT_DIR/theme/portrait_hdpi/pages"
    local line buttons="$local_pages/wipe-fbe-buttons.xml"
    local page="$local_pages/wipe-fbe-page.xml"
    local hook_format="$local_pages/wipe-fbe-hook-format.xml"
    local hook_detect="$local_pages/wipe-fbe-hook-detect.xml"

    # Remove old changes
    local tag
    for tag in 'buttons' 'page' 'hook-format' 'hook-detect'; do
        sed -i "/<!-- FBE $tag -->/,/<!-- \/FBE $tag -->/ d" "$wipe_xml"
    done

    # Insert buttons right before the 'Format Data' button
    line="$(__getMatchLineNr__ '<button style="btn_raised_warn">' "$wipe_xml")" || exit $?
    sed -i "$((line - 1)) r $buttons" "$wipe_xml"

    # Insert our page after all pages
    line="$(__getMatchLineNr__ '<\/pages>' "$wipe_xml")" || exit $?
    sed -i "$((line - 1)) r $page" "$wipe_xml"

    # Special case: we also need to trigger FBE disabling on data formatting page
    line="$(__getMatchLineNr__ '<data name="tw_confirm_formatdata"\/>' "$wipe_xml")" || exit $?
    sed -i "$line r $hook_format" "$wipe_xml"

    # Insert hook to determine which button to display 'Enable FBE' or 'Disable FBE'
    line="$(__getMatchLineNr__ '<partitionlist style="partitionlist_radio">' "$wipe_xml")" || exit $?
    sed -i "$((line - 1)) r $hook_detect" "$wipe_xml"
}

# Inherit some colour codes form vendor/recovery
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GREY='\033[0;37m'
LIGHTGREY='\033[0;38m'
WHITEONBLACK='\033[0;40m'
WHITEONRED='\033[0;41m'
WHITEONGREEN='\033[0;42m'
WHITEONORANGE='\033[0;43m'
WHITEONBLUE='\033[0;44m'
WHITEONPURPLE='\033[0;46m'
NC='\033[0m'

function __prettyNumber__() {
    # Format the value using thousands separator
    sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1,\2=g;t L' <<< "${1-}"
}

function __sedReplace__() {
    local regex="${1-}" file="${2-}"
    if [ -z "$(sed -i -e "$regex w /dev/stdout" "$file")" ]; then
        echo -e "${GREY}--- caution: cannot apply regex '$regex' in file: $file${NC}"
    fi
}

function __findMatch__() {
    local match="${1-}" file="${2-}"
    if ! grep -q "$match" "$file"; then
        echo -e "${GREY}--- caution: cannot find match '$match' in file: $file${NC}"
        return 1
    fi
}

function __getMatchLineNr__() {
    local pattern="${1-}" file="${2-}" line
    line=$(sed -n "/$pattern/=" "$file")
    if [ -z "$line" ] || [ "$line" -le 0 ]; then
        echo -e "${GREY}--- caution: cannot find match '$pattern' in file: $file${NC}" >&2
        return 1
    fi
    echo "$line"
}


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# This script will be called from vendor/recovery and will receive two args
main "$1" "$2"

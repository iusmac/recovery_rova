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
            : # noop
            ;;
        --last-call) # before .zip packing
            OF_WORKING_DIR="$1"
            : # noop
    esac
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

# This script will be called from vendor/recovery and will receive two args
main "$1" "$2"

#
# Copyright (C) 2017 The Android Open Source Project
# Copyright (C) 2020-2022 OrangeFox Recovery Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/xiaomi/rova

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Platform
TARGET_BOARD_PLATFORM := msm8937

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msm8937
TARGET_NO_BOOTLOADER := true

# Build
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Display
TARGET_SCREEN_WIDTH := 768
TARGET_SCREEN_HEIGHT := 1280

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 androidboot.bootdevice=7824900.sdhci earlycon=msm_hsl_uart,0x78B0000 androidboot.selinux=permissive
BOARD_KERNEL_CMDLINE += androidboot.usbconfigfs=true
BOARD_KERNEL_CMDLINE += audit=0
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_KERNEL_IMAGE_NAME  := Image.gz-dtb
BOARD_RAMDISK_OFFSET := 0x01000000
TARGET_KERNEL_CONFIG := rova_defconfig
TARGET_KERNEL_SOURCE := kernel/xiaomi/rova
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_KERNEL_CLANG_VERSION := r445002

# Encryption
BOARD_USES_QCOM_FBE_DECRYPTION := true
TARGET_CRYPTFS_HW_PATH := $(LOCAL_PATH)/cryptfs_hw
TARGET_HW_DISK_ENCRYPTION := true
TW_INCLUDE_CRYPTO := true
TW_USE_FSCRYPT_POLICY := 1

PLATFORM_VERSION := 127
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# Keymaster
TARGET_PROVIDES_KEYMASTER := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25765043712 # (25765060096 - 16384)
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_VENDORIMAGE_PARTITION_SIZE := 872415232

BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TW_INCLUDE_NTFS_3G := true

TARGET_RECOVERY_DEVICE_MODULES += \
    libxml2 \
    vendor.display.config@1.0 \
    vendor.display.config@2.0

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libxml2.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so

# Qualcomm support
BOARD_USES_QCOM_HARDWARE := true

# TWRP Configuration
TW_SCREEN_BLANK_ON_BOOT := true
TW_CUSTOM_CPU_TEMP_PATH := "/sys/class/thermal/thermal_zone7/temp"
TW_THEME := portrait_hdpi
TW_HAS_EDL_MODE := true
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 100
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_SCREEN_BLANK_ON_BOOT := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
BOARD_SUPPRESS_SECURE_ERASE := true
RECOVERY_SDCARD_ON_DATA := true
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TW_USE_TOOLBOX := true
AB_OTA_UPDATER := false
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_PYTHON := true

# Disable Mouse Cursor
TW_INPUT_BLACKLIST := "hbtp_vm"

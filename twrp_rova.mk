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

# Release name
PRODUCT_RELEASE_NAME := rova

# Inherit from those products. Most specific first
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_minimal.mk)

# Inherit common product files
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from device
$(call inherit-product, device/xiaomi/$(PRODUCT_RELEASE_NAME)/device.mk)

# Device identifier. This must come after all inclusions
BOARD_VENDOR := Xiaomi
PRODUCT_BRAND := $(BOARD_VENDOR)
PRODUCT_DEVICE := $(PRODUCT_RELEASE_NAME)
PRODUCT_NAME := twrp_$(PRODUCT_RELEASE_NAME)
PRODUCT_MANUFACTURER := $(BOARD_VENDOR)
PRODUCT_MODEL := Redmi 4A/5A
TARGET_VENDOR := $(BOARD_VENDOR)

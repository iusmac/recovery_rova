# Unified DT for Xiaomi Redmi 4A/5A (rolex/riva) devices

### Building
You can find all the necessary infos on requirements, dependencies & build guidelines on the Official OrangeFox Wiki page:
https://wiki.orangefox.tech/en/dev/building

If you don't have enough technical knowledge (or are simply too lazy 😌), you can also use the all-in-one automatic Rova Builder based on Docker container:
1. **Install Docker on your system:**
    ```console
    $ curl -fsSL https://get.docker.com | sudo sh -
    ```

2. **Clone Rova Builder:**
    ```console
    $ git clone --depth=1 https://github.com/iusmac/rova_builder.git -b orfox-10.0
    $ cd rova_builder
    ```

3. **Sync sources:**

    _(wait for Docker to prepare the container if running for the first time)_
    ```console
    $ ./orangefox_builder.sh
    — Init OrangeFox repo scripts? [Y/n] Y
    [...]
    — Sync sources? [Y/n] Y
    [...]
    — Build recovery? [Y/n] n
    ```
    **DO NOT BUILD NOW, RESPOND _n_**

4. **Apply patches to sources:**
    ```console
    $ cd src/
    $ ./device/xiaomi/rova/patches/apply.sh
    — Apply system_core-Build-fastboot-binary.patch? [Y/n] Y
    — Apply [...]? [Y/n] Y
    ```
    **RESPOND _Y_ TO ALL PATCHES**

5. **Build:**
    ```console
    $ ./orangefox_builder.sh
    — Init OrangeFox repo scripts? [Y/n] n
    — Sync sources? [Y/n] n
    — Build recovery? [Y/n] Y
    ```

### Dependencies
- *Kernel*: https://github.com/iusmac/kernel_rova
_(place to kernel/xiaomi/rova)_
- *Clang*: https://gitlab.com/iusmac/android_prebuilts_clang_host_linux-x86_clang-r437112b
_(place to prebuilts/clang/host/linux-x86/clang-r437112b)_
- *QCOM commonsys*: https://github.com/TeamWin/android_vendor_qcom_opensource_commonsys
_(place to vendor/qcom/opensource/commonsys)_

_NOTE: those are automatically downloaded when using Rova Builder_

### Device specifications
Basic                   | Spec Sheet
-----------------------:|:-------------------------
SoC                     | Qualcomm MSM8917 Snapdragon 425
CPU                     | Quad-core 1.4 GHz ARM® Cortex™ A53
GPU                     | Adreno 308
Memory                  | 2/3 GB RAM
Shipped Android Version | 6.0.1 for Redmi 4A and 7.0.1 for Redmi 5A
Storage                 | 16/32 GB
MicroSD                 | Up to 256 GB
Battery                 | Non-removable Li-Ion 3120 mAh battery
Dimensions              | 139.9 x 70.4 x 8.5 mm
Display                 | 720 x 1280 pixels, 5.0 inches (~296 ppi pixel density)
Rear Camera             | 13 MP, f/2.2, autofocus, LED flash
Front Camera            | 5 MP, f/2.2

### Appearance
Xiaomi Redmi 4A (rolex)                                 | Xiaomi Redmi 5A (riva)
--------------------------------------------------------|--------------------------
![Redmi 4A](https://i.imgur.com/nGI3iNI.png "Redmi 4A") | ![Redmi 5A](https://i.imgur.com/taCm6F4.png "Redmi 5A")

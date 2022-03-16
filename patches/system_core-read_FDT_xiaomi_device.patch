diff --git a/init/property_service.cpp b/init/property_service.cpp
index 53229eb..5d1c762 100644
--- a/init/property_service.cpp
+++ b/init/property_service.cpp
@@ -683,6 +683,15 @@ static void update_sys_usb_config() {
 }
 
 void property_load_boot_defaults() {
+    std::string xiaomi_device;
+    if (ReadFileToString("/proc/device-tree/xiaomi,device", &xiaomi_device)) {
+        property_set("ro.build.product", xiaomi_device);
+        property_set("ro.product.device", xiaomi_device);
+        property_set("ro.product.odm.device", xiaomi_device);
+        property_set("ro.product.system.device", xiaomi_device);
+        property_set("ro.product.vendor.device", xiaomi_device);
+    }
+
     if (!load_properties_from_file("/system/etc/prop.default", NULL)) {
         // Try recovery path
         if (!load_properties_from_file("/prop.default", NULL)) {

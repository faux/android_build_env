#!/bin/bash
OUT=${ANDROID_PRODUCT_OUT}
META_INF="META-INF/com/google/android"
cd ${OUT}
echo `pwd`
OUT_FULLPATH=$(pwd)

mkdir -p ${META_INF}
make-update-script ./system ./android-info.txt > ${META_INF}/update-script

cd ${OUT_FULLPATH}/${META_INF}
# patch update-script to not flash the radio image
patch <<EOF
--- update-script
+++ update-script.noradioimg
@@ -3,6 +3,5 @@
 show_progress 0.1 0
-write_radio_image PACKAGE:radio.img
-show_progress 0.5 0
 format SYSTEM:
 copy_dir PACKAGE:system SYSTEM:
+show_progress 0.5 0
 set_perm_recursive 0 0 0755 0644 SYSTEM:
EOF
cat update-script | less

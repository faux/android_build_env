#!/bin/bash
WD=$(pwd)
echo WD=${WD}
OUT=${ANDROID_PRODUCT_OUT}

echo cleaning old files
rm -v update.zip update-signed.zip

cd ${OUT}

echo building update.zip
cat <(find {META-INF,system,data}/ -type d) <(find {META-INF,system,data}/ -type f) <(echo boot.img) | zip -@ ${WD}/update.zip

cd ${WD}
echo ${WD}
echo $(pwd)

echo signing update.zip "->" update-signed.zip
java -jar ${ANDROID_BUILD_TOP}/out/host/linux-x86/framework/signapk.jar ${ANDROID_BUILD_TOP}/build/target/product/security/testkey.x509.pem ${ANDROID_BUILD_TOP}/build/target/product/security/testkey.pk8 update.zip update-signed.zip


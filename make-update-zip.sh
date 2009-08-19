#!/bin/bash
WD=$(pwd)
echo WD=${WD}
OUT=${ANDROID_PRODUCT_OUT}


add_tag(){
    TAG=$1
    FILE=$2

    D=$(dirname ${FILE})
    BN=$(basename ${FILE})
    EXT=$(sed 's/^.*\.//' <<< ${BN})
    BN=$(sed "s/.${EXT}$//" <<< ${BN})
    echo "${D}/${BN}-signed.${EXT}"
}

sign_file(){
    TAG=signed
    FILE=$1
    OUT_FILE=$(add_tag ${TAG} ${FILE})
    echo "Signing: $FILE -> $OUT_FILE"
    java -jar ${ANDROID_BUILD_TOP}/out/host/linux-x86/framework/signapk.jar ${ANDROID_BUILD_TOP}/build/target/product/security/testkey.x509.pem ${ANDROID_BUILD_TOP}/build/target/product/security/testkey.pk8 ${FILE} ${OUT_FILE}
}

case "$1" in
    sign)
        shift
        sign_file $*
        ;;
    package)
        echo cleaning old files
        rm -v update.zip update-signed.zip

        cd ${OUT}

        echo building update.zip
        cat <(find {META-INF,system,data}/ -type d) <(find {META-INF,system,data}/ -type f) <(echo boot.img) | zip -@ ${WD}/update.zip

        cd ${WD}
        echo ${WD}
        echo $(pwd)

        echo signing update.zip "->" update-signed.zip
        ;;
    *)
        usage
        ;;
esac


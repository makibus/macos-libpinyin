#!/bin/sh

TMP_DIR=.temp

if [ ! -d $TMP_DIR ]
then
    if [ -f $TMP_DIR ]
    then
        echo "[Error] Please save your work and remove $TMP_DIR file"
        exit 1
    fi
    mkdir -p $TMP_DIR
fi

ARCH=x86_64
OS_STRING=mojave
INFIX=mojave

download_bottle_from_homebrew()
{
    TEMPLATE_URL="https://bintray.com/homebrew/bottles/download_file?file_path="
    echo "Downloading" "$1"."$2".bottle.tar.gz "to" $3
    curl -L "$TEMPLATE_URL""$1"."$2".bottle.tar.gz --output $3
}

extract_bottle_of_homebrew()
{
    echo "Extracting" $1
    tar -xf $1 --directory $2
}

determine_arch()
{
    ARCH=$(uname -m)
}

determine_os_string()
{
    SYS_VERS=$(sw_vers -productVersion)
    echo "Detected sys version: $SYS_VERS"
    SYS_VERS_MAJOR=$(echo $SYS_VERS | cut -d"." -f1)
    SYS_VERS_MINOR=$(echo $SYS_VERS | cut -d"." -f2)
    case $SYS_VERS_MAJOR in
        11)
            OS_STRING=big_sur
            ;;
        10)
            case $SYS_VERS_MINOR in
                16)
                    OS_STRING=big_sur
                    ;;
                15)
                    OS_STRING=catalina
                    ;;
                14)
                    OS_STRING=mojave
                    ;;
                *)
                    echo "[Error] Unsupport macOS/OSX version"
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "[Error] Unsupport macOS/OSX version"
            exit 1
            ;;
    esac
}

determine_arch
determine_os_string

# Determine Homebrew download infix
if [ "$ARCH" == "arm64" ]
then
    INFIX="$ARCH"_"$OS_STRING"
else
    INFIX="$OS_STRING"
fi

LIBS="glib-2.66.7 libpinyin-2.6.0 openssl@1.1-1.1.1j gettext-0.21 berkeley-db-18.1.32_1"
TARGET_LIBS="libpinyin.a libglib-2.0.a libdb.a libintl.a libssl.a libcrypto.a"

for LIB in $LIBS
do
    if [ ! -f $TMP_DIR/$LIB.tar.gz ]
    then
        download_bottle_from_homebrew $LIB $INFIX "$TMP_DIR/$LIB.tar.gz"
    fi
    extract_bottle_of_homebrew "$TMP_DIR/$LIB.tar.gz" $TMP_DIR
done

LIB_VER=$(echo $1 | rev | cut -d'-' -f 1 | rev)

copy_static_lib()
{
    # Find and copy target to target dir
    files=$(find $3 -name $1)
    for file in $files
    do
        echo "Copying" $file "to" $2
        cp -f $file $2
        break   # Only copy the first one
    done
}

copy_libpinyin_data()
{
    # Find and copy libpinyin data to target dir
    files=$(find $1 -name data)
    for file in $files
    do
        echo "Copying" $file "to" $2
        cp -f $file/* $2
        break   # Only copy the first one
    done
}

copy_libpinyin_headers()
{
    # Find and copy libpinyin data to target dir
    files=$(find $1 -name *.h)
    for file in $files
    do
        echo "Copying" $file "to" $2
        cp -f $file $2
    done
}

patch_libpinyin_headers_without_glib()
{
    # Find and copy libpinyin data to target dir
    files=$(find $1 -name *.h)
    for file in $files
    do
        filename=$(echo $file | rev | cut -d'/' -f 1 | rev)
        patch=$2/"$filename".patch
        if [ -f $patch ]
        then
            echo "Patching" $filename
            patch $file $patch
        fi
    done
}

for TARGET_LIB in $TARGET_LIBS
do
    copy_static_lib $TARGET_LIB "lib" $TMP_DIR
done

copy_libpinyin_data "$TMP_DIR/libpinyin" "data"
copy_libpinyin_headers "$TMP_DIR/libpinyin" "include"
patch_libpinyin_headers_without_glib "include" "include/patch"

echo "Done!"

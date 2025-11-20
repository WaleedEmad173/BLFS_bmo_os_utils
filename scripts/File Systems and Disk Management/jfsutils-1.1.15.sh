#!/bin/bash
# set -E
# trap 'echo "❌ Error: command failed at line $LINENO"; exit 1' ERR

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/jfsutils-1.1.15-gcc10_fix-1.patch --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../jfsutils-1.1.15-gcc10_fix-1.patch
    sed -i "/unistd.h/a#include <sys/types.h>"    fscklog/extract.c &&
    sed -i "/ioctl.h/a#include <sys/sysmacros.h>" libfs/devices.c

   echo "🔧 Running configure..."
    if ! ./configure; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

fi

echo "🎉 FINISHED :)"

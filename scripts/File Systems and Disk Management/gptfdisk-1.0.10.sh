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
    wget https://www.linuxfromscratch.org/patches/blfs/12.4/gptfdisk-1.0.10-convenience-1.patch --no-check-certificate
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.10.tar.gz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../gptfdisk-1.0.10-convenience-1.patch &&
    sed -i 's|ncursesw/||' gptcurses.cc &&
    sed -i 's|sbin|usr/sbin|' Makefile


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

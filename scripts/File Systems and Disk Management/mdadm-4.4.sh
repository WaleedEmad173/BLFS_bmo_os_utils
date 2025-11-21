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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-4.4.tar.xz
    echo "✅ the package downloaded successfully"

    sed -e "s/__u8 signature\[4\]/& __attribute__ ((nonstring))/" \
    -i platform-intel.h


    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make BINDIR=/usr/sbin install; then
        echo "❌ Error: make failed!"
        exit 1
    fi



fi


echo "🎉 FINISHED :)"


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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://sourceware.org/ftp/lvm2/LVM2.2.03.34.tgz
    echo "✅ the package downloaded successfully"

    PATH+=:/usr/sbin                \

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr       \
            --enable-cmdlib     \
            --enable-pkgconfig  \
            --enable-udev_sync; then
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

    echo "⚙️ installing..."
    if ! make install_systemd_units; then
        echo "❌ Error: make failed!"
        exit 1
    fi    

    sed -e '/locking_dir =/{s/#//;s/var/run/}' \
    -i /etc/lvm/lvm.conf

fi


echo "🎉 FINISHED :)"


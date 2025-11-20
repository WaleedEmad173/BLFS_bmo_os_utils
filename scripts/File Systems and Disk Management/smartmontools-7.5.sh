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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/smartmontools/smartmontools-7.5.tar.gz
    echo "✅ the package downloaded successfully"

    

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/smartmontools-7.5 ; then
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

    systemctl enable smartd

fi


echo "🎉 FINISHED :)"

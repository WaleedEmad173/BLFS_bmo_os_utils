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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.15.0.tar.xz
    echo "✅ the package downloaded successfully"

    

    echo "⚙️  Running make..."
    if ! make  DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root \
     LOCAL_CONFIGURE_OPTIONS="--localstatedir=/var"; then
        echo "❌ Error: make failed!"
        exit 1
    fi

        
    
    echo "⚙️ installing..."
    if ! make PKG_DOC_DIR=/usr/share/doc/xfsprogs-6.15.0 install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    if ! make PKG_DOC_DIR=/usr/share/doc/xfsprogs-6.15.0 install-dev; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    rm -rfv /usr/lib/libhandle.{a,la}

fi


echo "🎉 FINISHED :)"

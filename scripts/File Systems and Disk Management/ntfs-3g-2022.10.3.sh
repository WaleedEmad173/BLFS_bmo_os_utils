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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/tuxera/ntfs-3g/archive/2022.10.3/ntfs-3g-2022.10.3.tar.gz
    echo "✅ the package downloaded successfully"

    ./autogen.sh

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr        \
            --disable-static     \
            --with-fuse=internal \
            --docdir=/usr/share/doc/ntfs-3g-2022.10.3 ; then
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

    ln -svf ../bin/ntfs-3g /usr/sbin/mount.ntfs &&
    ln -svf ntfs-3g.8 /usr/share/man/man8/mount.ntfs.8




fi


echo "🎉 FINISHED :)"
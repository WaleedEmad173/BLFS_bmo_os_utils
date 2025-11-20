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
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://ftp.gnu.org/gnu/parted/parted-3.6.tar.xz
    echo "✅ the package downloaded successfully"

    sed -i 's/do_version ()/do_version (PedDevice** dev, PedDisk** diskp)/' parted/parted.c

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    if ! make -C doc html || \
       ! makeinfo --html -o doc/html doc/parted.texi || \
       ! makeinfo --plaintext -o doc/parted.txt doc/parted.texi; then
        echo "❌ Error: Documentation build failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    install -v -m755 -d /usr/share/doc/parted-3.6/html &&
    install -v -m644    doc/html/* \
                        /usr/share/doc/parted-3.6/html &&
    install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                        /usr/share/doc/parted-3.6

fi


echo "🎉 FINISHED :)"

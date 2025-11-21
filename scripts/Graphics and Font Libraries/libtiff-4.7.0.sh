#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.osgeo.org/libtiff/tiff-4.7.0.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir -p libtiff-build &&
    cd       libtiff-build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr ..     \
        -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -G Ninja                            \
        -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.7.0; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running ninja..."
    if ! ninja; then
        echo "❌ Error: ninja failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: ninja-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"

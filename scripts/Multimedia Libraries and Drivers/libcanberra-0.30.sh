#!/bin/bash   

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

     wget  https://www.linuxfromscratch.org/patches/blfs/12.4/libcanberra-0.30-wayland-1.patch --no-check-certificate
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz
    echo "✅ the package downloaded successfully"

    patch -Np1 -i ../libcanberra-0.30-wayland-1.patch

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-oss; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make docdir=/usr/share/doc/libcanberra-0.30 install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"

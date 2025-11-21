#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://download.gnome.org/sources/librsvg/2.61/librsvg-2.61.0.tar.xz
    echo "✅ the package downloaded successfully"

   # <An Internet connection is needed for building this package. The system certificate store may need to be set up with make-ca-1.16.1 before building this package>

   echo "🔧 fix the installation path of the API ..."
    if ! sed -e "/OUTDIR/s|,| / 'librsvg-2.61.0', '--no-namespace-dir',|" \
        -e '/output/s|Rsvg-2.0|librsvg-2.61.0|'                      \
        -i doc/meson.build; then
        echo "❌ Error: fix the installation path of the API  failed!"
        exit 1
    fi

    mkdir build &&
    cd    build 

    echo "🔧 Running configure..."
    if ! meson setup --prefix=/usr --buildtype=release ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi


    echo "⚙️  Running ninja..."
    if ! ninja; then
        echo "❌ Error: ninja failed!"
        exit 1
    fi


    echo "⚙️ ninja testing..."
    if ! ninja test; then
        echo "❌ Error: ninja-test failed!"
        exit 1
    fi

    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: ninja-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"

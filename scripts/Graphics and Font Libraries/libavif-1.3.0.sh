#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/AOMediaCodec/libavif/archive/v1.3.0/libavif-1.3.0.tar.gz
    echo "✅ the package downloaded successfully"

   # <An Internet connection is needed for some tests of this package. The system certificate store may need to be set up with make-ca-1.16.1 before testing this package>


    mkdir build &&
    cd    build 

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D AVIF_CODEC_AOM=SYSTEM     \
      -D AVIF_BUILD_GDK_PIXBUF=ON  \
      -D AVIF_LIBYUV=OFF           \
      -G Ninja ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    echo "⚙️ test package..."
    if ! cmake .. -D AVIF_GTEST=LOCAL -D AVIF_BUILD_TESTS=ON &&
        ninja && ninja test; then
        echo "❌ Error: test package failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make-install failed!"
        exit 1
    fi

    gdk-pixbuf-query-loaders --update-cache

fi


echo "🎉 FINISHED :)"

#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/google/woff2/archive/v1.0.2/woff2-1.0.2.tar.gz
    echo "✅ the package downloaded successfully"

    # <First, fix a problem when building with gcc-15>
    echo "🔧 fixing..."
    if ! sed -i '/output.h/i #include <cstdint>' src/woff2_out.cc; then
        echo "❌ Error: fixiing failed!"
        exit 1
    fi

    mkdir out                                 &&
    cd    out

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr        \
        -D CMAKE_BUILD_TYPE=Release         \
        -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -D CMAKE_SKIP_INSTALL_RPATH=ON ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make install>; then
        echo "❌ Error: make-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"

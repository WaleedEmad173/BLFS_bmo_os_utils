#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget https://github.com/opencv/opencv_contrib/archive/4.12.0/opencv_contrib-4.12.0.tar.gz --no-check-certificate


    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/opencv/opencv/archive/4.12.0/opencv-4.12.0.tar.gz
    echo "✅ the package downloaded successfully"

    # <One additional file that starts with "ippicv" (integrated performance primitives) will be automatically downloaded during the cmake portion of the build procedure. This download is specific to the system architecture>

    #If you downloaded the optional modules

    echo "🔧 download..."
    if ! tar -xf ../opencv_contrib-4.12.0.tar.gz; then
        echo "❌ Error: dowmload failed!"
        exit 1
    fi

    mkdir build &&
    cd    build 

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=/usr        \
      -D CMAKE_BUILD_TYPE=Release         \
      -D ENABLE_CXX11=ON                  \
      -D BUILD_PERF_TESTS=OFF             \
      -D WITH_XINE=ON                     \
      -D BUILD_TESTS=OFF                  \
      -D ENABLE_PRECOMPILED_HEADERS=OFF   \
      -D CMAKE_SKIP_INSTALL_RPATH=ON      \
      -D BUILD_WITH_DEBUG_INFO=OFF        \
      -D OPENCV_GENERATE_PKGCONFIG=ON     \
      -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -W no-dev  ..; then
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
        echo "❌ Error: make-install failed!"
        exit 1
    fi


fi


echo "🎉 FINISHED :)"

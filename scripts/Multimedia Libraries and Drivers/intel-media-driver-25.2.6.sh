#!/bin/bash   

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    # wget <LINK> --no-check-certificate
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/lfs-book/intel-media-driver/archive/v25.2.6/intel-media-driver-25.2.6.tar.gz
    echo "✅ the package downloaded successfully"

    
    echo "⚙️  Running make..."
    if !  grep -ri 'RegisterDevice(0x9a49'; then
        echo "❌ Error:grep failed!"
        exit 1 
    fi    

    mkdir build
    cd    build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_INSTALL_PREFIX=$XORG_PREFIX \
      -D CMAKE_POLICY_VERSION_MINIMUM=3.5  \
      -D INSTALL_DRIVER_SYSCONF=OFF        \
      -D BUILD_TYPE=Release                \
      -D MEDIA_BUILD_FATAL_WARNINGS=OFF    \
      -G Ninja                             \
      -W no-dev .. ; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! ninja; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! ninja install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>

fi


echo "🎉 FINISHED :)"

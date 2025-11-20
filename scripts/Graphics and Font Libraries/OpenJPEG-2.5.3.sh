#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/uclouvain/openjpeg/archive/v2.5.3/openjpeg-2.5.3.tar.gz
    echo "✅ the package downloaded successfully"

    mkdir -v build &&
    cd       build

   echo "🔧 Running configure..."
    if ! cmake -D CMAKE_BUILD_TYPE=Release  \
        -D CMAKE_INSTALL_PREFIX=/usr \
        -D BUILD_STATIC_LIBS=OFF ..; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    #If you wish to run the tests, some additional files are required. Download these files and run the tests using the following commands, but note that 8 tests are known to fail
    echo "⚙️  testing make..."
    if ! git clone https://github.com/uclouvain/openjpeg-data.git --depth 1 &&
        OPJ_DATA_ROOT=$PWD/openjpeg-data cmake -D BUILD_TESTING=ON ..      &&
        make                                                               &&
        make test; then
        echo "❌ Error: make-test failed!"
        exit 1
    fi

    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make-install failed!"
        exit 1
    fi

    cp -rv ../doc/man -T /usr/share/man

fi


echo "🎉 FINISHED :)"

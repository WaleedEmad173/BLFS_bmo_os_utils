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

    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.gz
    echo "✅ the package downloaded successfully"

   sed -i '/typedef int bool;/d' src/encoder.h
   cd build/generic
   sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    echo "⚙️  Running make..."
    if ! make; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1nstal
    fi

    chmod -v 755 /usr/lib/libxvidcore.so.4.3 
    install -v -m755 -d /usr/share/doc/xvidcore-1.3.7/examples 
    install -v -m644 ../../doc/* /usr/share/doc/xvidcore-1.3.7 
    install -v -m644 ../../examples/* \
        /usr/share/doc/xvidcore-1.3.7/examples

fi


echo "🎉 FINISHED :)"

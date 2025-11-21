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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://distfiles.adelielinux.org/source/a52dec/a52dec-0.8.0.tar.gz
    echo "✅ the package downloaded successfully"

    # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --enable-shared         \
            --disable-static        \
            CFLAGS="${CFLAGS:--g -O3} -fPIC"; then
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
        echo "❌ Error: make failed!"
        exit 1
    fi

    cp liba52/a52_internal.h /usr/include/a52dec
    install -v -m644 -D doc/liba52.txt \
    /usr/share/doc/liba52-0.8.0/liba52.txt

fi


echo "🎉 FINISHED :)"

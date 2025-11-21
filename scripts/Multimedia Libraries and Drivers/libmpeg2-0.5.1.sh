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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://download.videolan.org/contrib/libmpeg2/libmpeg2-0.5.1.tar.gz
    echo "✅ the package downloaded successfully"

    sed -i 's/static const/static/' libmpeg2/idct_mmx.c

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static; then
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

    install -v -m755 -d /usr/share/doc/libmpeg2-0.5.1
    install -v -m644 README doc/libmpeg2.txt \
                    /usr/share/doc/libmpeg2-0.5.1 

fi


echo "🎉 FINISHED :)"

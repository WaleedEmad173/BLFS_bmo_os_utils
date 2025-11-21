#!/bin/bash   

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else

    wget  https://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+2.0.2.tar.bz2 --no-check-certificate
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://ftp.gnu.org/gnu/libcdio/libcdio-2.1.0.tar.bz2
    echo "✅ the package downloaded successfully"

    sed '/CDIO_LSEEK/s/lseek64/lseek/' -i lib/driver/_cdio_generic.c

   echo "🔧 Running configure..."
    if ! ./configure --prefix=/usr --disable-static; then
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
        exit 1nstal
    fi

    tar -xf ../libcdio-paranoia-10.2+2.0.2.tar.bz2 &&
    cd libcdio-paranoia-10.2+2.0.2


    echo "🔧 Running configure-libcdio-paranoia... "
    if ! ./configure --prefix=/usr --disable-static; then
        echo "❌ Error: configure libcdio-paranoia failed!"
        exit 1
    fi


    echo "⚙️  Running make-libcdio-paranoia..."
    if ! make; then
        echo "❌ Error: make libcdio-paranoia failed!"
        exit 1
    

    echo "⚙️ installing-libcdio-paranoia..."
    if ! make install; then
        echo "❌ Error: make libcdio-paranoia failed!"
        exit 1
    fi

    

fi


echo "🎉 FINISHED :)"

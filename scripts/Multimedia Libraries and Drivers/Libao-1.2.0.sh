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
    
    . ./../BLFS_bmo_os_utils/scripts/installer.sh  https://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz
    echo "✅ the package downloaded successfully"

    sed -i '/limits.h/a #include <time.h>' src/plugins/pulse/ao_pulse.c

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
    
    echo "⚙️ installing..."
    if ! make install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

    install -v -m644 README /usr/share/doc/libao-1.2.0          #Configuring Libao Config Files
                                                                     #/etc/libao.conf and ~/.libao 
                                                                     #ايه ده هل هو تبع configure الكلام ده ظهر تحت braket بتاع make install 

fi


echo "🎉 FINISHED :)"

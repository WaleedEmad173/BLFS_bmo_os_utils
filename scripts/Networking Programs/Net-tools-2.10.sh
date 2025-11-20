#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://downloads.sourceforge.net/project/net-tools/net-tools-2.10.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>
   export BINDIR='/usr/bin' SBINDIR='/usr/bin'

    echo "⚙️  Running make..."
    if ! yes "" | make -j1; then
        echo "❌ Error: make failed!"
        exit 1
    fi
    
    echo "⚙️ installing..."
    if ! make DESTDIR=$PWD/install -j1 install; then
        echo "❌ Error: make failed!"
        exit 1
    fi

   # <ETC>
    rm    install/usr/bin/{nis,yp}domainname    
    rm    install/usr/bin/{hostname,dnsdomainname,domainname,ifconfig} 
    rm -r install/usr/share/man/man1            
    rm    install/usr/share/man/man8/ifconfig.8 
    unset BINDIR SBINDIR
    chown -R root:root install
    cp -a install/* /

fi


echo "🎉 FINISHED :)"

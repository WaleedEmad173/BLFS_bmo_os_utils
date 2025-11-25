#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://www.kernel.org/pub/software/network/iw/iw-6.9.tar.xz
    echo "✅ the package downloaded successfully"

   # <MORE_COMMAND_IF_EXISTS_WITH_IF_STATEMENT>

   echo "🔧 Running configure..."
    if ! [*] Networking support --->                                                [NET]
  [*] Wireless --->                                                   [WIRELESS]
    <*/M>   cfg80211 - wireless configuration API                     [CFG80211]
    < /*/M>   Generic IEEE 802.11 Networking Stack (mac80211)         [MAC80211]

Device Drivers --->
  [*] Network device support --->                                   [NETDEVICES]
    [*] Wireless LAN --->                                                 [WLAN]; then
        echo "❌ Error: configure failed!"
        exit 1
    fi

    sed -i "/INSTALL.*gz/s/.gz//" Makefile

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

   # <ETC>

fi


echo "🎉 FINISHED :)"

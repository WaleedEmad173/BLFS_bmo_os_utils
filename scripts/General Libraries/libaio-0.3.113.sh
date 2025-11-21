#!/bin/bash
# set -E
# trap 'echo "❌ Error: command failed at line $LINENO"; exit 1' ERR

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://pagure.io/libaio/archive/libaio-0.3.113/libaio-0.3.113.tar.gz
    echo "✅ the package downloaded successfully"

    sed -i '/install.*libaio.a/s/^/#/' src/Makefile

    case "$(uname -m)" in
    i?86) sed -e "s/off_t/off64_t/" -i harness/cases/23.t ;;
    esac


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

fi

echo "🎉 FINISHED :)"


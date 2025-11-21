#!/bin/bash

cd ~/sources/BLFS || exit 1

folder_name=$(basename "$0" .sh)

# Convert to lowercase
folder_name=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]')

if [ -d "$folder_name" ]; then
    echo "✅ Folder '$folder_name' exists."
    exit 1
else
    . ./../BLFS_bmo_os_utils/scripts/installer.sh https://github.com/g-truc/glm/archive/1.0.1/glm-1.0.1.tar.gz
    echo "✅ the package downloaded successfully"

   # <This package is unusual as it includes its functionality in header files. We just copy them into position>

   echo "🔧 include..."
    if ! cp -r glm /usr/include/; then
        echo "❌ Error: include failed!"
        exit 1
    fi

    echo "⚙️  share..."
    if ! cp -r doc /usr/share/doc/glm-1.0.1; then
        echo "❌ Error: share failed!"
        exit 1
    fi
    


fi


echo "🎉 FINISHED :)"

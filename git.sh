#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Check if .gitmodules file exists
if [ ! -f .gitmodules ]; then
    echo ".gitmodules file not found!"
    exit 1
fi

# Parse .gitmodules to extract submodule information
submodules=$(awk '/\[submodule /{flag=1;next}/\[/{flag=0}flag' .gitmodules)

# Change to the apps directory
cd apps

# Iterate over each submodule
while read -r line; do
    if [[ $line == path* ]]; then
        # Extract the submodule name and path
        submodule_path=$(echo $line | cut -d' ' -f3)
        submodule_name=$(basename $submodule_path)
    elif [[ $line == url* ]]; then
        # Extract the submodule URL
        submodule_url=$(echo $line | cut -d' ' -f3)
        
        # Clone the submodule repository
        echo "Cloning $submodule_name from $submodule_url..."
        if ! git clone $submodule_url $submodule_name; then
            echo "Failed to clone $submodule_name. Removing directory..."
            rm -rf $submodule_name
            continue
        fi
    fi
done <<< "$submodules"

echo "Submodule cloning process completed."


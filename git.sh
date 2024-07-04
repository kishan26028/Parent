#!/bin/bash

# Ensure the script is run from the root directory of the repository
if [ ! -f ".gitmodules" ]; then
  echo ".gitmodules file not found in the current directory."
  exit 1
fi

# Read the .gitmodules file
git submodule init

# Navigate to the apps directory
cd apps || { echo "Directory 'apps' not found."; exit 1; }

# Iterate through the submodules
for submodule in $(grep path ../.gitmodules | awk '{print $3}'); do
  # Get the URL of the submodule repository
  submodule_url=$(git config --file ../.gitmodules --get submodule."$submodule".url)

  # Clone the submodule repository
  echo "Cloning submodule: $submodule from $submodule_url"
  git clone "$submodule_url" "$submodule" || { echo "Failed to clone $submodule. Skipping."; continue; }
  git checkout main
done

echo "Submodule cloning process completed."

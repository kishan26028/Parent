#!/bin/bash

# Command 1: Initialize submodules
git submodule init

# Command 2: Update submodules
git submodule update --recursive --remote

# Command 3: Checkout submodule branch from ".invalid" to "main"
git submodule foreach -q --recursive '
    if [ "$(git rev-parse --abbrev-ref HEAD)" = ".invalid" ]; then
        git checkout main || echo "Failed to switch branch for $name"
    fi
'

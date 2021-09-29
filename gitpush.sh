#!/bin/bash

# gitpush.sh
# Hussein Esmail
# Created: 2021 08 27
# Updated: 2021 08 27
# Description: This script makes it faster to push files to git repositories

DIR=$(pwd)                  # Default dir to push is current directory
if [ ! -z "$1" ]; then 
    DIR="$1"                # If argument is given, it is the file path to push
    cd "$DIR"               # Go to directory being pushed
fi
git add .
git commit
git push --quiet

exit 0

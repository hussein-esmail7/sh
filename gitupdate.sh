#!/bin/bash

# [FILE NAME]
# [CREATOR]
# Created: 2021 12 28
# Updated: 2021 12 28
# Description: This goes through your git folder and pulls each subfolder

cd ~/git
for folder in . ; do
	cd "$folder"
	if [ -f .git/ ] ; then
		git pull
	fi
	cd ../
done

exit 0


#!/bin/bash

# newsboaturlupdate.sh
# Hussein Esmail
# Created: 2021 10 27
# Updated: 2021 10 27
# Description: Conversion program for local RSS feeds from Linux file system
#	to macOS file system and vice versa

# TODO: Currently does not work: Overrides urls file on mac and leaves blank file
OS=$(uname) # Figure out if running on a mac of Linux computer

# Change directories to wherever the urls file is
if [ $OS == "Darwin" ]; then
	cd "/Users/$(whoami)/.newsboat/"
	sed "s/\/home\//\/Users\//g" "urls" > "urls"
elif [ $OS == "Linux" ]; then
	cd "/home/$(whoami)/.config/newsboat/"
	sed "s/\/Users\//\/home\//g" "urls" > "urls"
fi

echo "Program completed"

exit 0

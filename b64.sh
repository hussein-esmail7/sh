#!/bin/bash

# === PROGRAM DESCRIPTION ===
# This program decodes a base64 
# string into a readable string.
# If the readable string is a URL, 
# it automatically opens the URL in
# the default browser.

if [ ! -z "$1" ]; then
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    convert=$(echo "$1" | base64 --decode)
    echo $convert
    if [[ $convert =~ $regex ]] then
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then # linux
            xdg-open "$convert"
	elif [[ "$OSTYPE" == "darwin"* ]]; then # macOS
            open "$convert"
	else
	    echo "$OSTYPE: Don't know how to open links for this OS."
	fi
    fi	
fi
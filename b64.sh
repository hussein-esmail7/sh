#!/bin/bash

# b64.sh
# Hussein Esmail
# Created: 2021 01 03
# Updated: 2021 08 27
# Description: This program decodes a base64 string into a readable string. If
#	the readable string is a URL, it automatically opens the URL in the default
#	browser.

if [ ! -z "$1" ]; then
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    convert=$(echo "$1" | base64 --decode)
    echo "$convert"
    if [[ "$convert" =~ $regex && "$convert" != *$'\r'* ]]; then
    	# If it matches the URL regex (and is not multiple lines)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then # linux
            if [[ $(whoami | tr '[:upper:]' '[:lower:]') == *"hussein"* ]]; then
            	# If username has "hussein" (me only)
            	# Pass the output into determine_browser.sh
            	# Useful for opening https://mega.nz URLs directly from b64
                ${HOME}/git/sh/determine_browser.sh "$convert"
            else
            	# If you are not Hussein and want to open the URL
                xdg-open "$convert"
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then # macOS
        	# Catch-all default command in macOS
            open "$convert"
        else
            echo "$OSTYPE: Don't know how to open links for this OS."
			# If it ever reaches this and you have a solution, please submit a
			# pull request! I also want to make my code usable for others,
			# regardless of your operating system.
        fi
    fi
fi

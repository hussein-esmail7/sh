#!/bin/bash

# determine_browser.sh
# Hussein Esmail
# Created: 2021 04 13
# Updated: 2021 04 13
# Description: This program determines what application to open depending on the type of URL (specifically made for newsboat on Linux)

NOTIFY_ON_OPEN=1

PROGRAM_IMAGE="gwenview"
PROGRAM_VIDEO="mpv"
PROGRAM_OTHER="brave"

NO_OUTPUT="&> /dev/null 2>&1"

URL="$1"
YT_Check_1="youtube.com/watch?v="
YT_Check_2="youtu.be/"
Opened_app="null"

if [[ "$URL" == *".png"* || "$URL" == *".jpg"* || "$URL" == *".jpeg"* || "$URL" == *".gif"* || "$URL" == *".tiff"* || "$URL" == *".bmp"*]]; then
    eval "$PROGRAM_IMAGE $URL $NO_OUTPUT" 
    Opened_app="$PROGRAM_IMAGE"
elif [[ "$URL" == *"$YT_Check_1"* || "$URL" == *"$YT_Check_2"* ]]; then
    eval " $PROGRAM_VIDEO $URL $NO_OUTPUT"
    Opened_app="$PROGRAM_VIDEO"
else
    eval "$PROGRAM_OTHER $URL $NO_OUTPUT"
    Opened_app="$PROGRAM_OTHER"
fi

if [ $NOTIFY_ON_OPEN -eq 1 ]; then
    notify-send "Opened in $Opened_app: $URL"
fi

exit 0

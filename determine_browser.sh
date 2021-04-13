#!/bin/bash

# determine_browser.sh
# Hussein Esmail
# Created: 2021 04 13
# Updated: 2021 04 13
# Description: This program determines what application to open depending on the type of URL (specifically made for newsboat on Linux)

NOTIFY_ON_OPEN=1

PROGRAM_IMAGE="gwenview"
PROGRAM_VIDEO="mpv --no-terminal --keep-open=yes --osd-level=1 -osd-font-size=18 --geometry=100%:50% --autofit=50%"
PROGRAM_OTHER="brave"
# TODO: mp3 for podcasts

NO_OUTPUT="& 2>/dev/null"

URL="$1"
YT_Check_1="youtube.com/watch?v="
YT_Check_2="youtu.be/"
Opened_app="null"

if [[ "$URL" == *".png"* || "$URL" == *".jpg"* || "$URL" == *".jpeg"* || "$URL" == *".gif"* || "$URL" == *".tiff"* || "$URL" == *".bmp"* ]]; then
    eval "$PROGRAM_IMAGE $URL $NO_OUTPUT" 
    Opened_app="$PROGRAM_IMAGE"
elif [[ "$URL" == *"$YT_Check_1"* || "$URL" == *"$YT_Check_2"* ]]; then
    eval "$PROGRAM_VIDEO $URL & 2>/dev/null"
    Opened_app="mpv"
else
    eval "$PROGRAM_OTHER $URL &> /dev/null 2>&1"
    Opened_app="brave"
fi

if [ $NOTIFY_ON_OPEN -eq 1 ]; then
    notify-send "Opened in $Opened_app: $URL"
fi

exit 0

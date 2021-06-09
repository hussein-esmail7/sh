#!/bin/bash

# determine_browser.sh
# Hussein Esmail
# Created: 2021 04 13
# Updated: 2021 04 13
# Description: This program determines what application to open depending on the type of URL (specifically made for newsboat on Linux)

NOTIFY_ON_OPEN=0

PROGRAM_IMAGE="mpv --no-terminal --keep-open=yes --osd-level=1 -osd-font-size=18 --geometry=100%:50% --autofit=50% --pause"
PROGRAM_VIDEO="mpv --no-terminal --keep-open=yes --osd-level=1 -osd-font-size=18 --geometry=100%:50% --autofit=50%"
# TODO: mp3 for podcasts

NO_OUTPUT="&>/dev/null &"

URL="$1"
YT_Check_1="youtube.com/watch?v="
YT_Check_2="youtu.be/"
Opened_app="null"

if [[ "$URL" == *".png"* || "$URL" == *".jpg"* || "$URL" == *".jpeg"* || "$URL" == *".gif"* || "$URL" == *".tiff"* || "$URL" == *".bmp"* ]]; then
    # If it is an image
    if [[ "$URL" == *"preview.redd.it/"* ]]; then   # Support for https://preview.redd.it/... URLs
        URL=${URL/preview/i}                        # Replace "preview" with "i" since it is an image
        URL=$(echo "$URL" | cut -f1 -d"?")          # Get rid of the display arguments and just pass the image link
    fi
    eval "$PROGRAM_IMAGE $URL $NO_OUTPUT" 
    Opened_app=$(echo "$PROGRAM_IMAGE" | head -n1 | cut -d " " -f1)
elif [[ "$URL" == *"reddit.com/gallery/"* ]]; then  # Reddit Gallery images
    


elif [[ "$URL" == *"$YT_Check_1"* ||  "$URL" == *"videos.lukesmith.xyz"* || "$URL" == *"peertube"* || "$URL" == *"v.redd.it/"* ]]; then
    # if it is a YouTube video, on a PeerTube instance, or a Reddit video
    # Used to be: "$URL" == *"$YT_Check_2"* || $(curl -s $URL | grep -ic "PeerTube") -ge 1 but it took too long to process each time
    eval "$PROGRAM_VIDEO $URL & 2>/dev/null"
    Opened_app=$(echo "$PROGRAM_VIDEO" | head -n1 | cut -d " " -f1)
else
    eval "$BROWSER $URL &> /dev/null 2>&1 &"
    Opened_app=$(echo "$BROWSER" | head -n1 | cut -d " " -f1)
fi

if [ $NOTIFY_ON_OPEN -eq 1 ]; then
    notify-send "Opened in $Opened_app: $URL"
fi

exit 0

#!/bin/bash

# determine_browser.sh
# Hussein Esmail
# Created: 2021 04 13
# Updated: 2021 06 20
# Description: This program determines what application to open depending on the type of URL (specifically made for newsboat on Linux)

NOTIFY_ON_OPEN=0    # 1 for notification
VID_SCREEN=2        # Open on 3rd monitor

PROG_IMG="feh -q. -g 1000x1000"
PROG_VID="mpv --screen=$VID_SCREEN --no-terminal --keep-open=yes --osd-level=1 -osd-font-size=18 --geometry=0:0 --autofit=100%"
PROG_AUDIO="mpv --screen=$VID_SCREEN --no-terminal --keep-open=yes --osd-level=1 -osd-font-size=18 --geometry=85%:80% --autofit=60% --force-window=yes"

NO_OUTPUT="&>/dev/null"
PATH_REDDIT_GALLERY_PY="$HOME/git/sh/reddit_gallery.py"
PATH_IMGUR_GALLERY_PY="$HOME/git/sh/imgur_gallery.py"

# URL without the arguments after '?'
URL="$1"
# URL=$(echo "$1" | cut -f1 -d"?")

Opened_app="null"

if [[ "$OSTYPE" == "darwin"* ]]; then 
    PROG_IMG="open"   # Was having issues on macos, so will use the default app
fi

if [[ "$URL" == *".png"* || "$URL" == *".jpg"* || "$URL" == *".jpeg"* || "$URL" == *".gif"* || "$URL" == *".tiff"* || "$URL" == *".bmp"* ]]; then
    # If it is an image
    if [[ "$URL" == *"preview.redd.it/"* ]]; then   # Support for https://preview.redd.it/... URLs
        URL=${URL/preview/i}                        # Replace "preview" with "i" since it is an image
        URL=$(echo "$URL" | cut -f1 -d"?")          # Get rid of the display arguments and just pass the image link
    fi
    eval "$PROG_IMG $URL $NO_OUTPUT &" 
    Opened_app=$(echo "$PROG_IMG" | head -n1 | cut -d " " -f1)
elif [[ "$URL" == *"reddit.com/gallery/"* ]]; then  # Reddit Gallery images
    # Get the individual image URLs and open them all in one image viewer window
    eval "$PROG_IMG $(python3 $PATH_REDDIT_GALLERY_PY $URL) $NO_OUTPUT &"
    Opened_app=$(echo "$PROG_IMG" | head -n1 | cut -d " " -f1)
elif [[ "$URL" == *"imgur.com/gallery/"* ]]; then  # Imgur Gallery images
    # Get the individual image URLs and open them all in one image viewer window
    
    # TODO: FEH currently does not open .webp images, which Imgur returns. Find some way around this later.
    # eval "$PROG_IMG $(python3 $PATH_IMGUR_GALLERY_PY $URL) $NO_OUTPUT &"
    # Opened_app=$(echo "$PROG_IMG" | head -n1 | cut -d " " -f1)

    # These lines are here until the aboce lines are fixed.
    eval "$BROWSER $URL &> /dev/null 2>&1 &"
    Opened_app=$(echo "$BROWSER" | head -n1 | cut -d " " -f1)
elif [[ "$URL" == *"youtube.com/watch?v="* || "$URL" == *"youtu.be/"* ||  "$URL" == *"videos."* || "$URL" == *"peertube"* || "$URL" == *"v.redd.it/"* ]]; then
    # if it is a YouTube video, on a PeerTube instance, or a Reddit video
    # Used to be: "$URL" == *"youtu.be/"* || $(curl -s $URL | grep -ic "PeerTube") -ge 1 but it took too long to process each time
    eval "$PROG_VID $URL & 2>/dev/null"
    Opened_app=$(echo "$PROG_VID" | head -n1 | cut -d " " -f1)
elif [[ "$URL" == *".mp3"* ||  "$URL" == *".flac"* || "$URL" == *".m4a"* || "$URL" == *".wav"* || "$URL" == *".wma"* || "$URL" == *".aac"* ]]; then
    # Audio, mainly for podcasts
    eval "$PROG_AUDIO $URL & 2>/dev/null"
    Opened_app=$(echo "$PROG_AUDIO" | head -n1 | cut -d " " -f1)
else
    eval "$BROWSER $URL &> /dev/null 2>&1 &"
    Opened_app=$(echo "$BROWSER" | head -n1 | cut -d " " -f1)
fi

if [ $NOTIFY_ON_OPEN -eq 1 ]; then
    notify-send "Opened in $Opened_app: $URL"
fi

exit 0

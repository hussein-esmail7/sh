#!/bin/bash

# Program description:
# This program takes a YouTube URL and runs yt-dlp to get the audio only
string="$1"
if [ -z $1 ] ; then
	# If no argument given
    echo -n "URL: "
    read string
    if [ "$string" == "exit" ] || [ "$string" == "q" ] || [ "$string" == "q" ] ; then
        exit 1
    fi
fi

string=${string#"https://www.youtube.com/watch?v="} || echo -n ""
# echo "$string"
yt-dlp -ic -R 100 -x --no-check-certificate \
--yes-playlist --skip-unavailable-fragments --restrict-filenames \
--no-warnings --no-part -f best --audio-format mp3 -o \
"%(title)s.%(ext)s" "$string"
# Run yt-dlp with 100 retries, get audio only, download all in a playlist if it
# is one, do not use part files, and output the best quality to .mp3

exit 0

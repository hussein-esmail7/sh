#!/bin/bash

# Program description:
# This program takes a YouTube URL and runs yt-dlp to get the audio only
string="$@"
if [ -z "$string" ] ; then
	# If string is empty, exit
	echo "No input given."
    exit 1
fi

yt-dlp -ic -R 100 -x --no-check-certificate \
--yes-playlist --skip-unavailable-fragments --restrict-filenames \
--no-warnings --no-part -f best --audio-format mp3 -o \
"%(title)s.%(ext)s" "$string"
# Run yt-dlp with 100 retries, get audio only, download all in a playlist if it
# is one, do not use part files, and output the best quality to .mp3

exit 0

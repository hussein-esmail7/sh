#!/bin/bash

# Program description:
# This program takes a YouTube URL and runs yt-dlp to get the audio only
string="$@"
if [ -z "$string" ] ; then
	# If string is empty, exit
	echo "No input given."
    exit 1
fi

yt-dlp -ic -R 100 --no-check-certificate --yes-playlist \
--skip-unavailable-fragments --restrict-filenames --no-warnings --no-part \
-f best --embed-subs --embed-subs --write-auto-subs --sub-lang "en.*" -S \
vcodec:h264,res,acodec:m4a --recode mp4 \
-o "%(channel)s/%(upload_date>%Y)s %(upload_date>%m)s %(upload_date>%d)s %(title)s.%(ext)s" "$string"

# Run yt-dlp with 100 retries
# download all in a playlist if it is one, do not use part files

exit 0

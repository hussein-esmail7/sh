#!/bin/bash

# Program description:
# This program takes a YouTube URL and runs yt-dlp to get the audio only
string="$@"
if [ -z "$string" ] ; then
	# If string is empty, exit
	echo "No input given."
    exit 1
fi

if [ ${#string} -ge 100 ] ; then
	echo "$string" > .test
	echo $(head -c 100 .test)
	rm -f .test
fi

if [ ${#string} -le 100 ] ; then
	echo "Good"
fi

# yt-dlp -R 100 --no-check-certificate --yes-playlist --skip-unavailable-fragments --embed-subs --write-auto-subs --sub-lang "en.*" -S vcodec:h264,res,acodec:m4a --recode mp4 -o "%(upload_date>%Y)s %(upload_date>%m)s %(upload_date>%d)s %(title)s.%(ext)s" "$string"

# -R: Run with 100 retries
# --yes-playlist: If a video playlist link is given get the whole playlist
# Put all available subtitles in video as well
# H264, MP4

exit 0

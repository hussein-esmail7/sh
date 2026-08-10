#!/bin/bash

# Program description:
# This program takes a YouTube URL and runs yt-dlp with various checks

string="$@"
if [ -z "$string" ] ; then
	# If string is empty, exit
	echo "No input given."
    exit 1
fi

yt-dlp \ 
	--no-check-certificate \
	-R 100 \
	--no-warnings \
	--yes-playlist \
	--trim-filenames 127 \
	--embed-subs \
	--write-automatic-subs \
	--sub-lang "en.*" \
	-S vcodec:h264,res,acodec:m4a \
	--recode mp4 \
	-o "%(upload_date>%Y)s %(upload_date>%m)s %(upload_date>%d)s %(title)s.%(ext)s"

# --no-check-certificate: Suppress HTTPS certificate validation
# -R 100: Run with 100 retries
# --no-warnings: Self-explanatory. Keeps progress bars
# --yes-playlist: If a playlist URL was given, download the entire playlist
# --trim-filenames 127: If a video's filename will be more than 127 characters, just use the first 127 characters
# --embed-subs: If there are subtitles, embed them into the video
# --write-automatic-subs: Write automatically generated subtitle file
# --sub-lang "en.*": Get English subtitles
# -S vcodec:h264,res,acodec:m4a: h264 and m4a codec
# --recode mp4: Use the mp4 filetype as oppose to mkv (mp4 is more compatible among operating systems)
# -o "%(upload_date>%Y)s %(upload_date>%m)s %(upload_date>%d)s %(title)s.%(ext)s": File name structure

# Some sites download *.unknown_video in addition to the video.
# The command below deletes any file type with that extension if any were created
find . -name "*.unknown_video" -type f -delete

# TODO: If the downloaded file contains "4.9K views · 66 reactions ｜ " or similar (make regex out of this)
# get rid of it. When FaceBook Reels are downloaded, this is at the start of the title before the caption

exit 0

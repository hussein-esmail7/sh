#!/bin/bash

# Program description:
# This program takes a YouTube URL and runs yt-dlp with various checks

string="$@"
if [ -z "$string" ] ; then
	# If string is empty, exit
	echo "No input given."
    exit 1
fi

vid_title=$(yt-dlp --no-update --print "%(upload_date>%Y)s %(upload_date>%m)s %(upload_date>%d)s %(uploader)s - %(title)s.%(ext)s" --skip-download "$string")
vid_id=$(yt-dlp --no-update --print "%(upload_date>%Y)s %(upload_date>%m)s %(upload_date>%d)s %(uploader)s - %(id)s.%(ext)s" --skip-download "$string")

# String replacements for $vid_title
# This is before the character limit check as it may impact that
# PATTERN 1: For "74K views · 2.7K reactions ｜ " and "3.4K views · 5 comments ｜ " at video title prefix for FaceBook Reels
regex_pattern1='[0-9]+(\.[0-9]+)?[KM]? views · [0-9]+(\.[0-9]+)?[KM]? (reactions|comments) \| '
# PATTERN 2 and 3: For "Follow @USERNAME for more content". Treating them as 2 patterns to keep the username (and the "@")
regex_pattern2="Follow @" # Replace with "@" to keep the username identifier there but just used to find the string
regex_pattern3=" for more content" # Usually with "Follow @USERNAME for more content"
regex_pattern4=" on Reels\." # Replace with "." which is the fine extension separator (used as my way of end of string when the file extension is still in the string)
regex_pattern5=" \| " # Replace with " - " for less special characters
vid_title=$(sed -E "s/$regex_pattern1//" <<< "$vid_title")
vid_title=$(sed -E "s/$regex_pattern2/@/" <<< "$vid_title")
vid_title=$(sed -E "s/$regex_pattern3//" <<< "$vid_title")
vid_title=$(sed -E "s/$regex_pattern4/./" <<< "$vid_title")
vid_title=$(sed -E "s/$regex_pattern5/ - /" <<< "$vid_title")

if [[ ${#vid_title} -gt 100 ]]; then
    # Title is longer than 100 characters
	# This statement is to avoid Error #36 from yt-dlp: Title too long
	echo "-------------- File name is long, will be downloaded as $vid_id"
	yt-dlp --no-check-certificate -R 100 -q --progress --newline --yes-playlist --embed-subs --write-automatic-subs --sub-lang "en.*" -S vcodec:h264,res,acodec:m4a --recode mp4 -o "$vid_id" "$string" # Pass the actual URL
else
	yt-dlp --no-check-certificate -R 100 -q --progress --newline --yes-playlist --embed-subs --write-automatic-subs --sub-lang "en.*" -S vcodec:h264,res,acodec:m4a --recode mp4 -o "$vid_title" "$string" # Pass the actual URL
fi




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

#!/bin/bash

sort=$(ss -tp | grep "plex" | awk '{s+=$3} END {printf "%.0f\n", s}')
# About this command: get the processes from networ, find the ones with "plex" in it, then add all the third columns together (3rd column = upload bytes), then print the sum.

if [[ $sort -ge 100000 ]]; then
    # If uploading more than 100kb/s
    echo "1"
else
    echo "0"
fi
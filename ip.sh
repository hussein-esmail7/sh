#!/bin/bash

local=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')
ext=$(curl -s ipinfo.io/ip)
echo "External: $ext
Local:    $local"

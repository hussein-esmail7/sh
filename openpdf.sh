#!/bin/bash

# [FILE NAME]
# [CREATOR]
# Created: 2021 11 28
# Updated: 2021 11 28
# Description: [DESCRIPTION]

[ -z "$1" ] ; exit 1
PDF_OPEN=$(echo "$1" | sed "s/tex/pdf/g")
echo "$PDF_OPEN"
zathura "$PDF_OPEN" &> /dev/null 2>&1 &

exit 0

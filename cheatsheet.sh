#!/bin/bash

# cheatsheet.sh
# Hussein Esmail
# Created: 2021 01 03
# Updated: 2021 08 27
# Description: This program just prints a block of text that is used as a reference sheet for writing specific files

SHEET_OPTIONS[0]="vim"
SHEET_OPTIONS[1]="groff"

if [ ! -z "$1" ] ; then     # If an arg is given, it is which cheatsheet to open
    SHEET_PROGRAM="$1"
    [[ ! " ${SHEET_OPTIONS[*]} " =~ " ${SHEET_PROGRAM} " ]] ; echo "'${SHEET_PROGRAM}' is not an option" ; exit 1
else                        # If no args are given, ask using fzf
    SHEET_PROGRAM=$(for explain in ${SHEET_OPTIONS[@]}; do echo "${explain}"; done | fzf)
    [[ "$SHEET_PROGRAM" == "" ]] ; exit 0
fi

if [[ "$SHEET_PROGRAM" == "groff" ]] ; then
    echo ".TL - title"
    echo ".AU - author"
    echo ".AI - author's institution"
    echo ".DA - date in footer"
    echo ""
    echo ".PP - indented paragraph"
    echo ".LP - unindented paragraph"
    echo ".QP - blockquote"
    echo ".NH  - numbered heading"
    echo ".SH - regular heading"
    echo ""
    echo ".B \"text\" - bold"
    echo ".I \"text\" - italic"
    echo ".UL \"text\" - underline"
    echo ".CW text - monospace"
    echo ".BX text - box around text"
    echo ".LG .SM - large/small text (can nest)"
    echo ""
    echo ".IP marker - list \[bu]"
    echo ".1C/2C - column mode"
    echo "\\\" - comment"
    echo "\*Q, \*U - produce quotes"
elif [[ "$SHEET_PROGRAM" == "vim" ]] ; then
    echo "=== NORMAL MODE ==="
    echo "h -> Left"
    echo "j -> Down"
    echo "k -> Up"
    echo "l -> Right"
    echo "w -> Move forward 1 word"
    echo "b -> Move backwards 1 word"
    echo "D -> Delete from cursor to end of line"
    echo "G -> Go to last line in file"
    echo "gg -> Go to first line in file"
    echo "gqq -> Split line before textwidth limit"
    echo "o -> Insert on new line below cursor"
    echo "O -> Insert on new line above cursor"
    echo "~ -> Switch case of character"
    echo "H - Puts the cursor at the top of the screen"
    echo "M - Puts the cursor in the middle of the screen"
    echo "L - Puts the cursor at the bottom of the screen"
    echo "<Num>G -> Go to specific line number"
    echo ""
    echo "=== COMMAND LINE ==="
    echo ":vsp <file> -> Open file to the left"
    echo ":ter -> Open Terminal below"
    echo ""
    echo "=== VISUAL MODE (V) ==="
    echo "gq -> Split lines before textwidth limit in selection"
fi

exit 0

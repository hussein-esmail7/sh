#!/bin/bash

# === PROGRAM DESCRIPTION ===
# This program just prints a block
# of text that is used as a reference
# sheet for writing in groff/.ms files

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

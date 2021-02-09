#!/bin/bash

# === PROGRAM DESCRIPTION ===
# This program generates a groff
# template file named 'template.ms'
# in the current directory that 
# can be used to add text.

if test -f template.ms;         # If the template file exists
    then
    : > template.ms
else                        # If the template file does not exist
    touch template.ms
fi

echo ".TL" >> template.ms
echo "Title here" >> template.ms
echo ".AU" >> template.ms
echo "Hussein Esmail" >> template.ms
echo ".PP" >> template.ms
echo "This is a generic paragraph" >> template.ms
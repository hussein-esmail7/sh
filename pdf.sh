#!/bin/bash

# === PROGRAM DESCRIPTION ===
# This program converts a .ms (groff/troff) file into a .pdf file
# It is run by typing "pdf filename.ms"
# The pdf filename is the .ms filename automatically.
# The reason why you can type "pdf" and not ./pdf.sh is because I have
# an alias in my terminal config file to this shell script.

if [ ! -z "$1" ];                               # If the first argument ($1) is not a null string (""). Aka if the filename argument exists
    then                                        # Start of the if statement
    filename="$1"                               # Set this variable to the inputted filename
    name="${filename%.*}"                       # Set this to the 
    groff -ms -e -t -p "$filename" > temp.ps    # Converts the .ms into post script
    cupsfilter temp.ps > "$name.pdf"            # Converts post script file into PDF
    rm temp.ps                                  # Remove the temporary file
    open "$name.pdf"                            # Open the just-made pdf.
    fi                                          # End of the if statement
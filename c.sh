#!/bin/bash

# c.sh
# Hussein Esmail
# Created: 2021 01 09
# Updated: 2021 09 29
# Description: This script will compile or run other finishing operation on a
# document. It determines what to do based on the document type
# - .tex files: Compiles to pdf. Including bibtex/makeglossaries if nessesary
# - .c files: Compiles via whatever compiler is set to cc. Usually gcc.
# - .py files: Runs via python command
# - All others: Open in default application

if [ -z "$1" ] ; then         # If no arguments are given
    echo "usage: c <files>"
    echo ""
    echo "This program compiles given file names."
    echo ""
    echo ".c: Compiles using gcc"
    echo ".cpp: Compiles using g++"
    echo ".html: Uses 'open' command"
    echo ".java: Runs using 'java' command"
    echo ".ms: Converts Groff to PDF via PostScript"
    echo ".py: Runs using python3"
    echo ".sh: Runs in terminal"
    echo ".tex: Converts to PDF (with BibTeX, makeglossaries) if necessary."
    echo "All other file extensions: uses 'open' command"
    echo ""
    echo "See https://github.com/hussein-esmail7/sh for more info."
    exit 1
fi

for file in "$@" # file = given argument. You can pass multiple files at the same time.
do
    
    if [ ! -f "$1" ] ; then   # If file is not in the current dir or does not exist if given the full path
        echo "File does not exist in directory!"
        exit 1
    fi
    dir=$(dirname "$file")  # Directory of the file
    base="${file##*.}"      # File extension only
    shebang="${file%.*}"    # File name before the extension

    case "$file" in
        *\.c) gcc -o "$shebang" "$file" ; chmod +x "$shebang" ; ./"$shebang" ;;
        *\.cpp) g++ -o "$shebang" "$file" ; chmod +x "$shebang" ; ./"$shebang" ;;
        *\.html) open "$file" ;;
        *\.java) java "$file" ;;
        *\.ms) 
            groff -ms -e -t -p "$file" > ".${file%.*}.ps"    # Converts the .ms into post script
            cupsfilter temp.ps > "${file%.*}.pdf"            # Converts post script file into PDF
            rm -f ".${file%.*}.ps"                           # Remove the temporary file
        ;;
        *\.py) python3 "$file" ;;
        *\.sh) chmod +x "$file" && ./"$file" ;; 
        *\.tex) 
			# \usepackage{lua-ul}
			if [[ $(grep "\usepackage{lua-ul}" "$file" | wc -l) -ge 1 ]] ; then
				LATEX_ENGINE="lualatex"
			else
				LATEX_ENGINE="lualatex"
			fi
			echo "===================="
			echo "USING $LATEX_ENGINE"
			echo "===================="
            $LATEX_ENGINE --interaction=batchmode "$file"
            [[ $(grep "\cite{" "$file" | wc -l) -ge 1 || $(grep "\bibitem{" "$file" | wc -l) -ge 1 || $(grep "\bibliorgraphy{" "$file" | wc -l) -ge 1 || $(grep "\bibliographystyle{" "$file" | wc -l) -ge 1 ]]; bibtex "$shebang"
            [[ $(grep "\newglossaryentry" "$file" | wc -l) -ge 1 ]]; makeglossaries "$shebang"
            $LATEX_ENGINE --interaction=batchmode "$file"
            rm -f "__latexindent_temp.tex" "${shebang}.fdb_latexmk" "${shebang}.fls" "${shebang}.log" "${shebang}.aux" "${shebang}.synctex.gz" "${shebang}.out" "${shebang}.toc" "${shebang}.run.xml" "${shebang}.bbl" "${shebang}.blg" "${shebang}.bcf" "${shebang}.mx1"
			# .toc: Used to make table of contents
			# .bbl: Used for bibliographies
			# .mx1: Used for musictex library (typing sheetmusic)
        ;;
        *) open "$file" ;; # Default statement
    esac
done
exit 0

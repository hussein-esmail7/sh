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


OPEN_OUTPUT=0 # Do not open output file. True if you pass "-o"

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
    echo ".pdf: Opens the PDF in the default application"
    echo ".py: Runs using python3"
    echo ".sh: Runs in terminal"
    echo ".tex: Converts to PDF (with BibTeX, makeglossaries) if necessary."
    echo "All other file extensions: uses 'open' command"
    echo ""
    echo "See https://github.com/hussein-esmail7/sh for more info."
    exit 1
fi

# Checking for command arguments
while getopts ":oh:" opt; do
	case $opt in
		o) OPEN_OUTPUT=1 ;;
		h)	echo "usage: c <files>"
    		echo ""
    		echo "This program compiles given file names."
    		echo ""
    		echo ".c: Compiles using gcc"
    		echo ".cpp: Compiles using g++"
    		echo ".html: Uses 'open' command"
    		echo ".java: Runs using 'java' command"
    		echo ".ms: Converts Groff to PDF via PostScript"
    		echo ".pdf: Opens the PDF in the default application"
    		echo ".py: Runs using python3"
    		echo ".sh: Runs in terminal"
    		echo ".tex: Converts to PDF (with BibTeX, makeglossaries) if necessary."
    		echo "All other file extensions: uses 'open' command"
    		echo ""
    		echo "See https://github.com/hussein-esmail7/sh for more info."
    		exit 1 ;;
    	\?) help;exit 1 ;;
    esac
done
shift



for file in "$@" # file = given argument. You can pass multiple files at the same time.
do

    # if [ ! -f "$1" ] ; then   # If file is not in the current dir or does not exist if given the full path
    #     echo "File does not exist in directory!"
    #     exit 1
    # fi
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
        *\.py) python3 "$file" "${@:2}" ;;
        *\.pdf)
        	# Open the PDF file
        	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        		# If you are opening the PDF in Linux
				echo "Opening PDF in Okular"
				okular "$file" & > /dev/null
        	elif [[ "$OSTYPE" == "darwin"* ]]; then
        		# If you are opening the PDF in macOS
        		open "$file" # Will open in default PDF application
        	else
        		echo "ERROR: I don't know how to open PDFs in this OS: $OSTYPE"
        		# If it ever reaches this and you have a solution, please submit
        		# a pull request! I also want to make my code usable for others,
        		# regardless of your operating system.
        	fi
			;;
        *\.sh) chmod +x "$file" && ./"$file" ;;
		*\.tex) # LaTeX files (compile)
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
            [[ $(grep "\cite{" "$file" | wc -l) -ge 1 || $(grep "\bibitem{" "$file" | wc -l) -ge 1 || $(grep "\bibliography{" "$file" | wc -l) -ge 1 || $(grep "\bibliographystyle{" "$file" | wc -l) -ge 1  ]]; biber "$shebang"
            [[ $(grep "\newglossaryentry" "$file" | wc -l) -ge 1 ]]; makeglossaries "$shebang"
            $LATEX_ENGINE --interaction=batchmode "$file"
            rm -f "__latexindent_temp.tex" "${shebang}.fdb_latexmk" "${shebang}.fls" "${shebang}.log" "${shebang}.aux" "${shebang}.synctex.gz" "${shebang}.out" "${shebang}.toc" "${shebang}.run.xml" "${shebang}.bbl" "${shebang}.blg" "${shebang}.bcf" "${shebang}.mx1" "${shebang}.nav" "${shebang}.snm" "${shebang}.tdo" "${shebang}.lot" "${shebang}.lof"
			# .toc: Used to make table of contents
			# .bbl: Used for bibliographies
			# .mx1: Used for musictex library (typing sheetmusic)
			# .nav: beamer temporary table of contents file
			# .snm: Used with beamer, don't know what this is for. Empty file
			# .tdo: Used by todonotes package
			# .lot: Used to generate list of tables
			# .lof: Used to generate list of figures
			if [ $OPEN_OUTPUT -eq 1 ] ; then
				if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        			# If you are opening the PDF in Linux
					echo "Opening PDF in Okular"
					okular "${shebang}.pdf" & > /dev/null
        		elif [[ "$OSTYPE" == "darwin"* ]]; then
        			# If you are opening the PDF in macOS
        			open "${shebang}.pdf" # Will open in default PDF application
        		else
        			echo "ERROR: I don't know how to open PDFs in this OS: $OSTYPE"
        			# If it ever reaches this and you have a solution, please submit
        			# a pull request! I also want to make my code usable for others,
        			# regardless of your operating system.
        		fi
			fi
        ;;
		*)
			if [[ "$OSTYPE" == "linux-gnu"* ]]; then
				echo "I don't know what to do with $file!" ; exit 1
        	elif [[ "$OSTYPE" == "darwin"* ]]; then
				open "$file"
        	else
				echo "I don't know what to do with $file!" ; exit 1
        	fi
        	;; # Default statement
    esac
done
exit 0

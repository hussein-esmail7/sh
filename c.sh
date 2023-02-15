#!/bin/bash

# c.sh
# Hussein Esmail
# Created: 2021 01 09
# Description: This script will compile or run other finishing operation on a
# document. It determines what to do based on the document type
# - .tex files: Compiles to pdf. Including bibtex/makeglossaries if nessesary
# - .c files: Compiles via whatever compiler is set to cc. Usually gcc.
# - .py files: Runs via python command
# - All others: Open in default application

# TODO: If running the program with a full path as the file name, output in the same folder. At the moment it outputs in the current directory

CONFIG_OPEN_OUTPUT=0 # Do not open output file. True if you pass "-o"
CONFIG_KEEP_TEMP_FILES=0 # Do not keep temp files unless you pass "-k"
CONFIG_QUIET=0 # Quiet mode. Not quiet unless you pass "-q"

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
while getopts ":okqh:" opt; do
	case $opt in
		o)  # Open output file after compiling (if there is an output file)
			CONFIG_OPEN_OUTPUT=1
			shift
			;;
		k)  # Keep temporary files
			CONFIG_KEEP_TEMP_FILES=1
			shift
			;;
		q)  # Quiet mode
			CONFIG_QUIET=1
			shift
			;;
		h)  # Help message
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
    		exit 1 ;;
    	\?)
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
    		;;
    esac
done



for file in "$@" # file = given argument. You can pass multiple files at the same time.
do
	# If file does not exist in directory, inform user
    # [ ! -f "$file" ] ; echo "File '$file' does not exist in directory!" ; exit 1
    # TODO: Convert `exit 1` to just skop this iteration of the loop.
    #		Example: If the 2nd of 3 files does not exist only, program will
    #		exit, not completing file 3. By skipping the iteration, file 3 will
    #		still be compiled

    dir=$(dirname "$file")  # Directory of the file
    base="${file##*.}"      # File extension only
    front="${file%.*}"		# File name before the extension

    case "$file" in
        *\.c) gcc -o "$front" "$file" ; chmod +x "$front" ; ./"$front" ;;
        *\.cpp) g++ -o "$front" "$file" ; chmod +x "$front" ; ./"$front" ;;
        *\.html) open "$file" ;;
        *\.java) java "$file" ;;
        *\.ms)
            groff -ms -e -t -p "$file" > ".${file%.*}.ps"	# .ms to PostScript
            cupsfilter temp.ps > "${file%.*}.pdf"			# PostScript to PDF
			if [ $CONFIG_KEEP_TEMP_FILES -eq 0 ] ; then
				rm -f ".${file%.*}.ps" # Delete PostScript file
			fi
        ;;
        *\.py) python3 "$file" "${@:2}" ;;
        *\.pdf)
        	# Open the PDF file
			# This does the same as if `-o` was given. This does the same
			# because there would be no other way to treat PDFs
        	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        		# If you are opening the PDF in Linux
				if [ $CONFIG_QUIET -eq 0 ] ; then
					echo "Opening PDF in Okular"
				fi
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
			if [ $CONFIG_QUIET -eq 0 ] ; then
				echo "c.sh: Compiling using $LATEX_ENGINE"
			fi
            $LATEX_ENGINE --interaction=batchmode "$file"
            [[ $(grep "\cite{" "$file" | wc -l) -ge 1 || $(grep "\bibitem{" "$file" | wc -l) -ge 1 || $(grep "\bibliography{" "$file" | wc -l) -ge 1 || $(grep "\bibliographystyle{" "$file" | wc -l) -ge 1  ]]; biber "$front"
            [[ $(grep "\newglossaryentry" "$file" | wc -l) -ge 1 ]]; makeglossaries "$front"
            $LATEX_ENGINE --interaction=batchmode "$file"
            $LATEX_ENGINE --interaction=batchmode "$file" # Run a third time
			if [ $CONFIG_KEEP_TEMP_FILES -eq 0 ] ; then
				rm -f "${front}.aux" # Default output file
            	rm -f "${front}.bbl" # Used for bibliographies
            	rm -f "${front}.bcf"
            	rm -f "${front}.blg"
            	rm -f "${front}.fdb_latexmk"
            	rm -f "${front}.fls"
            	rm -f "${front}.lof" # Used to generate list of figures
            	rm -f "${front}.log" # Default output file
            	rm -f "${front}.lot" # Used to generate list of tables
            	rm -f "${front}.mx1" # Created when musictex package is used
            	rm -f "${front}.nav" # beamer temporary table of contents file
            	rm -f "${front}.out" # Default output file
            	rm -f "${front}.run.xml" # Default output file
				rm -f "${front}.snm" # Created when beamer is used (somehow)
            	rm -f "${front}.synctex.gz" # Default output file
            	rm -f "${front}.tdo" # Used by todonotes package
            	rm -f "${front}.toc" # Used to make table of contents
            	rm -f "__latexindent_temp.tex" # Default output file
			fi
			if [ $CONFIG_OPEN_OUTPUT -eq 1 ] ; then
				if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        			# If you are opening the PDF in Linux
					if [ $CONFIG_QUIET -eq 0 ] ; then
						echo "Opening PDF in Okular"
					fi
					okular "${front}.pdf" & > /dev/null
        		elif [[ "$OSTYPE" == "darwin"* ]]; then
        			# If you are opening the PDF in macOS
        			open "${front}.pdf" # Will open in default PDF application
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
				echo "ERROR: I don't know what to do with $file!" ; exit 1
        	elif [[ "$OSTYPE" == "darwin"* ]]; then
				open "$file"
        	else
				echo "ERROR: I don't know what to do with $file!" ; exit 1
        	fi
        	;; # Default statement
    esac
done
exit 0

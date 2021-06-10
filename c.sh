#!/bin/bash

# c.sh
# Hussein Esmail
# Created: 2021 01 09
# Updated: 2021 05 14
# Description: This script will compile or run other finishing operation on a
# document.  
# tex files: Compiles to pdf. Including bibliography if nessesary
# c files: Compiles via whatever compiler is set to cc. Usually gcc.
# py files: Runs via python command
# All others: Open in default application

if [ -z $1 ] ; then # If no filename is given
    echo "Filename required."
    exit 1
elif [ ! -z $2 ] ; then # If too many arguments are given
    echo "Too many arguments! If your file has spaces, use quotation marks or '\'."
    exit 1
fi

file="$1"               # First (and only) input
dir=$(dirname "$file")  # Directory of the file
base="${file##*.}"      # File extension only
shebang="${file%.*}"    # File name before the extension

cd "$dir" || exit 1 # If the terminal is not in an existing directory, exit the program

case "$file" in
    *\.c) gcc -o "$shebang" "$file" ; chmod +x "$shebang" ; "$dir"/"$shebang" ;;
    *\.cpp) g++ -o "$shebang" "$file" ; chmod +x "$shebang" ; "$dir"/"$shebang" ;;
    *\.html) open "$file" ;;
    *\.java) java "$file" ;;
    *\.py) python3 "$file" ;;
    *\.sh) chmod +x "$file" && ./"$file" ;; 
    *\.tex) 
        output=$(pdflatex -halt-on-error "$file" | grep '^!.*' -A200 --color=always)
        # grep -c -e "fi" -e "if" c.sh
        [[ grep -c -e "\cite{" -e "\bibitem{" -e "\bibliorgraphy{" -e "\bibliographystyle{" "$file" ]]; bibtex "$file"
        output=$(pdflatex -halt-on-error "$file" | grep '^!.*' -A200 --color=always)
        for i in {1..2}; do # Sometimes it needs to be compiled twice
            output=$(pdflatex -halt-on-error "$file" | grep '^!.*' -A200 --color=always)
            if [ -n "$output" ] ; then # If output is not blank
                echo "$output"
                exit 1
            fi
        done
        # Remove all the junk/log files that were also created.
        # If there is an error in the .tex document then the program would end before this happens
        rm -f "__latexindent_temp.tex" "${shebang}.fdb_latexmk" "${shebang}.fls" \
			"${shebang}.log" "${shebang}.aux" "${shebang}.synctex.gz" \
			"${shebang}.out" "${shebang}.toc"
		
    ;;
    *) open "$file" ;; # Default statement
esac

exit 0

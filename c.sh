#!/bin/bash

# c.sh
# Hussein Esmail
# Created: 2021 01 09
# Updated: 2021 08 22
# Description: This script will compile or run other finishing operation on a
# document. It determines what to do based on the document type
# - tex files: Compiles to pdf. Including bibtex/makeglossaries if nessesary
# - c files: Compiles via whatever compiler is set to cc. Usually gcc.
# - py files: Runs via python command
# - All others: Open in default application

if [ -z $1 ] ; then         # If no filename is given
    echo "Filename required."
    exit 1
elif [ ! -z $2 ] ; then     # If too many arguments are given
    echo "Too many arguments! If your file has spaces, use quotation marks or '\'."
    exit 1
elif [ ! -f "$1" ] ; then
    echo "File does not exist in directory!"
    exit 1
fi

for file in "$@" # file = given argument. You can pass multiple files at the same time.
do
    dir=$(dirname "$file")  # Directory of the file
    base="${file##*.}"      # File extension only
    shebang="${file%.*}"    # File name before the extension

    case "$file" in
        *\.c) gcc -o "$shebang" "$file" ; chmod +x "$shebang" ; ./"$shebang" ;;
        *\.cpp) g++ -o "$shebang" "$file" ; chmod +x "$shebang" ; ./"$shebang" ;;
        *\.html) open "$file" ;;
        *\.java) java "$file" ;;
        *\.py) python3 "$file" ;;
        *\.sh) chmod +x "$file" && ./"$file" ;; 
        *\.tex) 
            pdflatex --interaction=batchmode "$file"
            [[ $(grep "\cite{" "$file" | wc -l) -ge 1 || $(grep "\bibitem{" "$file" | wc -l) -ge 1 || $(grep "\bibliorgraphy{" "$file" | wc -l) -ge 1 || $(grep "\bibliographystyle{" "$file" | wc -l) -ge 1 ]]; bibtex "$shebang"
            [[ $(grep "\newglossaryentry" "$file" | wc -l) -ge 1 ]]; makeglossaries "$shebang"
            pdflatex --interaction=batchmode "$file"
            rm -f "__latexindent_temp.tex" "${shebang}.fdb_latexmk" "${shebang}.fls" "${shebang}.log" "${shebang}.aux" "${shebang}.synctex.gz" "${shebang}.out" "${shebang}.toc" "${shebang}.run.xml" "${shebang}.bbl" "${shebang}.blg" "${shebang}.bcf"
        ;;
        *) open "$file" ;; # Default statement
    esac
done
exit 0

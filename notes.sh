#!/bin/bash

# notes.sh
# Hussein Esmail
# Created: 2022 03 05
# Updated: 2022 03 05
# Description: Opens specific note file that you specify
#	Example command: `notes 3221` opens the .tex note in your editor that
#	matches the `3221` string. If there are multiple matches, it will list the
#	possible matches, and make you run the program again and to be more
#	specific. If there's `MATH3221` and `EECS3221`, you can type
#	`notes MATH3221` or `notes MATH 3221` (will return same result)

MODE_Q=0 # 1 if program is in quiet mode
MODW_F=0 # 1 if program is in filename-only mode
MODE_EDITOR="$EDITOR" # changed if user uses "editor" command

# Get the options
while getopts ":hqf:" option; do
	case $option in
		h)	# display help message
			echo "Syntax: notes [-h|q|f]"
			echo "options:"
			echo "h		Print this help message."
			echo "q		Open file without printing anything"
			echo "f		Print filename only without opening"
			echo ""
			exit;;
		q) # Quiet mode - open file without printing anything
			MODE_Q=1 ;;
		f)	# Print file name only without opening
			echo "File mode"
			MODW_F=1 ;;
		\?)	# Invalid option
			echo "Error: '$OPTARG' is an invalid option"
			exit ;;
	esac
done

if [ -z "$1" ] ; then
	# If no additional arguments given, cd into the school folder
	cd "${HOME}/git/school-notes/"
elif [ ! -z "$1" ] ; then
	NOTES_DIR="${HOME}/git/school-notes"
	input="$*" # Join all arguments together in case there are spaces
	input=${input%$'\n'} # Get rid of newline character
	input="$(echo "$input" | tr -d ' ' | tr '[:lower:]' '[:upper:]')"
	# ^ Convert all lowercase characters to uppercase and no spaces
	if [[ "$input" =~ "(\w{2,4})?\h?\d{4}\b" ]] ; then
		# Regex explanation:
		#	\w: Any letter, regardless of case (upper/lower)
		#	{2,4}: Minimum of 2, max of 4. This is because York University
		#		letter codes can have 2-4 letters. Ex. EN 1001 is for
		#		English, ENG 1001 is for Engineering, etc.
		#	\h?: An optional horizontal space character. Horizontal so
		#		new lines can't count. Optional because EECS1001 and
		#		EECS 1001 are the same thing.
		#	\d: Any digit
		#	\b: End of word
		input="$(echo "$input" | tr '[:lower:]' '[:upper:]')"
		file_name=$(echo "$input.tex" | sed 's/ //g') # Get rid of spaces
	fi
	[[ $(echo "$input" | tr '[:upper:]' '[:lower:]') == "vcp" ]] ; file_name="VCP.tex"
	if [ ! -z "$file_name" ] ; then
		# Only look for .tex (LaTeX) files
		suffix=".tex"
		# Put the 2 strings together
		file_name=$input$suffix
		cd "$NOTES_DIR"
		file_results=$(find . -name "*$file_name")
		if [ -z "$file_results" ] ; then
			# If there are no results
			echo "No results found"
		elif [ $(echo "$file_results" | wc -l) == 1 ] ; then
			# If there is 1 matching file (line in this case) and is not empty
			# Print what file is being opened (full path while in its dir)
			echo "Opening $(pwd)${file_results:1}"
			# Actually open the file
			exec $EDITOR "$file_results"
		else
			# If there are multiple results, list them so the user can be more
			# specific next time this program is run
			echo "Multiple results!"
			echo "$file_results"
		fi
		# Go back to whatever the directory was after the file is closed
		# /dev/null is there because `cd -` prints the target dir
		cd - > /dev/null
	fi
fi

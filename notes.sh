#!/bin/bash

# notes.sh
# Hussein Esmail
# Created: 2022 03 05
# Updated: 2022 03 23
# Description: Opens specific note file that you specify
#	Example command: `notes 3221` opens the .tex note in your editor that
#	matches the `3221` string. If there are multiple matches, it will list the
#	possible matches, and make you run the program again and to be more
#	specific. If there's `MATH3221` and `EECS3221`, you can type
#	`notes MATH3221` or `notes MATH 3221` (will return same result)


# User-configurable variables
NOTES_DIR="${HOME}/git/school-notes"
# TODO: Make this into a config file
suffix=".tex" # Only look for .tex (LaTeX) files
# TODO: Later on, implement functionality for multiple file types,
#		or even regex
FILE_REGEX="(\w{2,4})?\h?\d{4}\b"
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

MODE_Q=0 # 1 if program is in quiet mode
MODE_F=0 # 1 if program is in filename-only mode
MODE_EDITOR="$EDITOR" # changed if user uses "editor" command
NUM_ARGS="$#" # Number of arguments passed

# Get the "-" option arguments, if any
while getopts ":hqf:" option; do
	case $option in
		h)	# display help message
			echo "Syntax: notes [-h|q|f]"
			echo "options:"
			echo "-h		Print this help message."
			echo "-q		Open file without printing anything"
			echo "-f		Print filename only without opening (overrides -q)"
			echo ""
			;;
		q) # Quiet mode - open file without printing anything
			shift # remove -q argument from "$@" since we used it up
			MODE_Q=1 ;;
		f)	# Print file name only without opening
			# echo "File mode"
			shift # remove -f argument from "$@" since we used it up
			MODE_F=1 ;;
		\?)	# Invalid option
			echo "Error: '$OPTARG' is an invalid option"
			;;
	esac
done

if [[ $MODE_Q == 1 && $MODE_F == 1 ]] ; then
	# If there are conflicting options ("-q" and "-f"), "-f" wins
	MODE_Q=0
fi

if [ "$#" -ge 1 ] ; then # If there is at least 1 argument
	input="$*" # Join all arguments together in case there are spaces
	input=${input%$'\n'} # Get rid of newline character
	input="$(echo "$input" | tr -d ' ' | tr '[:lower:]' '[:upper:]')"
	# ^ Convert all lowercase characters to uppercase and no spaces
	if [[ "$input" =~ "$FILE_REGEX" ]] ; then
		input="$(echo "$input" | tr '[:lower:]' '[:upper:]')"
		file_name=$(echo "$input.tex" | sed 's/ //g') # Get rid of spaces
	fi
	[[ $(echo "$input" | tr '[:upper:]' '[:lower:]') == "vcp" ]] ; file_name="VCP.tex"
	if [ ! -z "$file_name" ] ; then
		# Put the 2 strings together
		file_name=$input$suffix
		cd "$NOTES_DIR"
		file_results=$(find . -name "*$file_name")
		if [[ -z "$file_results" && $MODE_Q -eq 0 ]] ; then
			# If there are no results
			echo "No results found"
		elif [ $(echo "$file_results" | wc -l) == 1 ] ; then
				# If there is 1 matching file (line in this case) and is not empty
			if [[ $MODE_F -eq 0 ]]; then
				# If user wants to open the file
				if [[ $MODE_Q -eq 0 ]] ; then
					# Print what file is being opened
					echo "$(pwd)${file_results:1}"
				fi
				# Actually open the file
				exec $EDITOR "$file_results"
			else
				# If user just wants the file path (without opening)
				echo "$(pwd)${file_results:1}"
			fi
		else
			# If there are multiple results, list them so the user can be more
			# specific next time this program is run
			echo "Multiple results!"
			echo "$file_results"
		fi
		# Go back to whatever the directory was after the file is closed
		# Go back to the previous directory
		if [[ $NUM_ARGS -ne 0 ]]; then
			exec cd $OLDPWD
		fi
	fi
else
	# If no arguments were given
	echo "ERROR: You have to provide an input file shortcut!"
	echo "See the help message for more information"
fi

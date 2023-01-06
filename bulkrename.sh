#!/bin/bash

# bulk.sh
# Hussein Esmail
# Created: 2022 01 17
# Updated: 2022 01 17
# Description: This script puts all items in the CWD into your editor where
#	you can rename them, and it will do so depending on the order of the files

# TODO: This command does not work on macOS as of 2023 01 06.
# Error given: "readarray: command not found"

# VARIABLES
FILE_OLD=".rename_old"
FILE_NEW=".rename_new"

ls -1pd "$PWD/"* > "$FILE_OLD"
# ls explanations:
# -1: 1 item per line
# -p: Add "/" at the end for directories
# -d: If a dir in this folder contains something, do not list it on its own line
# "$PWD/"*: List it in this format, so full path shows

cp "$FILE_OLD" "$FILE_NEW"
$EDITOR "$FILE_NEW" # Edit file, and the next command will run after this finishes

# If lengths of both files do not match
LEN_OLD=$(cat "$FILE_OLD" | wc -l) # Line length of old file
LEN_NEW=$(cat "$FILE_NEW" | wc -l) # Line length of new file

if [ $LEN_OLD -eq $LEN_NEW ] ; then
	# From this point on, the file lengths are the same which is required
	readarray CONTENTS_OLD < "$FILE_OLD"
	readarray CONTENTS_NEW < "$FILE_NEW"
	# Loop through each line of old file and make the mv commands
	for (( i=0; i<${LEN_OLD}; i++)); do
		if [[ "${CONTENTS_OLD[$i]}" != "${CONTENTS_NEW[$i]}" ]] ; then
			# Do not bother changing if it's the exact same name
			# mv will throw an error that cannot be silenced
			CONTENTS_OLD[$i]=$(echo ${CONTENTS_OLD[$i]} | tr -d '\n')
			CONTENTS_NEW[$i]=$(echo ${CONTENTS_NEW[$i]} | tr -d '\n')
			# tr -d '\n': Gets rid of newline character at the end of the entry
			# Print what was done in case something goes wrong
			echo "mv \"${CONTENTS_OLD[$i]}\" \"${CONTENTS_NEW[$i]}\""
			mv -i "${CONTENTS_OLD[$i]}" "${CONTENTS_NEW[$i]}"
		fi
	done
else
	# Throw this error if the amount of lines have changed
	echo "File lengths changed!"
	exit 1
fi

# Remove temporary files
rm -f "$FILE_OLD"
rm -f "$FILE_NEW"

exit 0

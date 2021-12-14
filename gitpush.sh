#!/bin/bash

# gitpush.sh
# Hussein Esmail
# Created: 2021 08 27
# Updated: 2021 12 14
# Description: This script makes it faster to push files to git repositories

# Get the options
while getopts ":hdm:" option; do
	case $option in
		h)	# display help message
			echo "Syntax: gitpush [-h|d|m]"
			echo "options:"
			echo "h		Print this help message."
			echo "d		Run in different directory."
			echo "m		Custom commit message."
			echo ""
			exit;;
		d)	# Change dir
			cd "$OPTARG";;
		m)	# Enter a name
			commit_msg="$OPTARG";;
		\?)	# Invalid option
			echo "Error: Invalid option"
			exit;;
	esac
done

# Filling in empty variables
[ -z "$commit_msg" ] ; commit_msg="modified file"

git add .
git commit --quiet --message="$commit_msg"
git push --quiet

exit 0

#!/bin/bash

# update.sh
# Hussein Esmail
# Created: 2021 01 03
# Updated: 2026 01 25
# Description: This program performes all various update commands so I don't
# have to worry about updating specific apps

YN_BREW=0
YN_GIT=0
YN_MSOFFICE=0
YN_NEWSBOAT=0
YN_PACMAN=0
YN_PIP=0
YN_TLMGR=0

# This command outputs what OS this is running on (since there are different
# update commands per OS).
os=$(uname -a | awk '{print $(1);}')
# macOS = "Darwin"
# Linux = "Linux"

# Ask user which things they want to update at the very beginning
if [[ "$os" == "Linux" ]]; then # Linux System
	if command -v newsboat &> /dev/null ; then # If newsboat is installed
	    while true; do
	        read -p "Update newsboat [y/n]? " yn
	        case $yn in
	            [Yy]* ) YN_NEWSBOAT=1 ; break;;
	            [Nn]* ) break ;;
	            * ) echo "Please answer yes or no.";;
	        esac
	    done
	fi
	if command -v pacman &> /dev/null ; then # Linux System
	    while true; do
	        read -p "Update pacman packages [y/n]? " yn
	        case $yn in
	            [Yy]* ) YN_PACMAN=1 ; break;;
	            [Nn]* ) break ;;
	            * ) echo "Please answer yes or no.";;
	        esac
	    done
	fi
elif [[ "$os" == "Darwin" ]]; then # macOS System
	# if command -v newsboat &> /dev/null ; then # If newsboat is installed
	#     while true; do
	#         read -p "Update newsboat [y/n]? " yn
	#         case $yn in
	#             [Yy]* ) YN_NEWSBOAT=1 ; break;;
	#             [Nn]* ) break ;;
	#             * ) echo "Please answer yes or no.";;
	#         esac
	#     done
	# fi
	if command -v brew &> /dev/null ; then # If brew/homebrew is installed
    	YN_BREW=1
		# while true; do
    	#     read -p "Update brew packages [y/n]? " yn
    	#     case $yn in
    	#         [Yy]* ) YN_BREW=1 ; break;;
    	#         [Nn]* ) break ;;
    	#         * ) echo "Please answer yes or no.";;
    	#     esac
    	# done
	fi
	if command -v tlmgr &> /dev/null ; then
		# If tlmgr (LaTeX package manager) is installed
    	YN_TLMGR=1
		# while true; do
    	#     read -p "Update brew packages [y/n]? " yn
    	#     case $yn in
    	#         [Yy]* ) YN_BREW=1 ; break;;
    	#         [Nn]* ) break ;;
    	#         * ) echo "Please answer yes or no.";;
    	#     esac
    	# done
	fi
    # while true; do
    #     read -p "Update Microsoft applications [y/n]? " yn
    #     case $yn in
    #         [Yy]* ) YN_MSOFFICE=1 ; break;;
    #         [Nn]* ) break ;;
    #         * ) echo "Please answer yes or no.";;
    #     esac
    # done
fi
if command -v python3 &> /dev/null ; then # If python3/pip is installed
	YN_PIP=1
	# while true; do
	#     read -p "Update pip packages [y/n]? " yn
	#     case $yn in
	#         [Yy]* ) YN_PIP=1 ; break;;
	#         [Nn]* ) break ;;
	#         * ) echo "Please answer yes or no.";;
	#     esac
	# done
fi

# Updates that require the use of 'sudo' first so the user can walk away later
# on while things update.
if [[ $YN_TLMGR -eq "1" ]] ; then
	echo "If a password is asked below, it is for 'sudo tlmgr update --all'"
	sudo tlmgr update --all
	# sudo tlmgr update --all > /dev/null;
fi
if [[ $YN_PACMAN -eq "1" ]] ; then # Linux System
	echo "If a password is asked below, it is for 'sudo pacman -S archlinux-keyring && sudo pacman -Syyu'"
    sudo pacman -S archlinux-keyring && sudo pacman -Syyu
    yay -Syyu --devel   # Update AUR packages + git dependencies
fi
# Updates that don't require sudo below
if [[ $YN_NEWSBOAT -eq "1" ]] ; then
	# If 'update newsboat' is 'yes' and newsboat is installed
	# Reload newsboat articles
	newsboat -x reload
	echo "Newsboat updated."
fi
if [[ $YN_BREW -eq "1" ]] ; then
	# If 'update brew packages' is 'yes' and brew is installed
	brew update > /dev/null; brew upgrade > /dev/null
fi

if [[ $YN_MSOFFICE -eq "1" ]] ; then # Update MS Office on Mac
    /Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps MSWD2019 XCEL2019 PPT32019 > /dev/null
fi

if [[ $YN_PIP -eq "1" ]] ; then # Update MS Office on Mac
    pip3 --quiet --no-input install --upgrade pip
    python3 -m pip install --upgrade pip
    /usr/bin/python -m pip install --upgrade pip
    # Update all pip packages
    pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U
    python3 -m pip freeze --user | cut -d'=' -f1 | xargs -n1 python3 -m pip install -U
fi

exit 0

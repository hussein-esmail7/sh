#!/bin/bash


# PROGRAM DESCRIPTION
# This program performes all various update commands so I
# dont have to worry about updating specific apps
#
YN_PACMAN=0
YN_NEWSBOAT=0
YN_BREW=0
YN_MSOFFICE=0
YN_PIP=0
YN_GIT=0

os=$(uname -a | awk '{print $(1);}') # This command works on macOS and Linux

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
	if command -v brew &> /dev/null ; then # If brew/homebrew is installed
		while true; do
    	    read -p "Update brew packages [y/n]? " yn
    	    case $yn in
    	        [Yy]* ) YN_BREW=1 ; break;;
    	        [Nn]* ) break ;;
    	        * ) echo "Please answer yes or no.";;
    	    esac
    	done
	fi
    while true; do
        read -p "Update Microsoft applications [y/n]? " yn
        case $yn in
            [Yy]* ) YN_MSOFFICE=1 ; break;;
            [Nn]* ) break ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi
if command -v python3 &> /dev/null ; then # If python3/pip is installed
	while true; do
	    read -p "Update pip packages [y/n]? " yn
	    case $yn in
	        [Yy]* ) YN_PIP=1 ; break;;
	        [Nn]* ) break ;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
fi

# Reload newsboat articles
if $YN_NEWSBOAT -eq 1 ; then
	# If 'update newsboat' is 'yes' and newsboat is installed
	newsboat -x reload
	echo "Newsboat updated."
fi
if $YN_BREW -eq 1 ; then
	# If 'update brew packages' is 'yes' and brew is installed
	brew update > /dev/null; brew upgrade > /dev/null
fi

if $YN_PACMAN -eq 1 ; then # Linux System
    sudo pacman -S archlinux-keyring && sudo pacman -Syyu
    yay -Syyu --devel   # Update AUR packages + git dependencies
fi
if $YN_MSOFFICE -eq 1 ; then # Update MS Office on Mac
    /Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps MSWD2019 XCEL2019 PPT32019 > /dev/null; break;;
fi

if $YN_PIP -eq 1 ; then # Update MS Office on Mac
    pip3 --quiet --no-input install --upgrade pip
    python3 -m pip install --upgrade pip
    /usr/bin/python -m pip install --upgrade pip
    # Update all pip packages
    pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U
    python3 -m pip freeze --user | cut -d'=' -f1 | xargs -n1 python3 -m pip install -U
fi

exit 0

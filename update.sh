#! /bin/bash

# === PROGRAM DESCRIPTION ===
# This program performes all 
# various update commands so 
# I don't have to worry about 
# updating specific apps

os=$(uname -a | awk '{print $(1);}') # This command works on macOS and Linux

if [[ os ~= "Linux" ]]; then # Linux update lines
    newsboat -x reload  # Update newsboat feeds
    sudo pacman -Syyu   # Update pacman packages
    yay -Syyu --devel   # Update AUR packages + git dependencies
    pip install --upgrade pip # Upgrade pip
elif [[ os ~= "Darwin" ]]; then # macOS update lines
    brew -q upgrade     # Update Homebrew packages
    pip3 -q --no-input install --upgrade pip # Upgrade pip
    python3 -m pip install --upgrade pip
    /Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps MSWD2019 XCEL2019 PPT32019 > /dev/null
fi

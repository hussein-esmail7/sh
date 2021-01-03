#! /bin/bash

# === PROGRAM DESCRIPTION ===
# This program performes all 
# various update commands so 
# I don't have to worry about 
# updating specific apps

brew -q upgrade
pip3 -q --no-input install --upgrade pip
python3 -m pip install --upgrade pip
/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps MSWD2019 XCEL2019 PPT32019 > /dev/null
#!/bin/bash


# PROGRAM DESCRIPTION
# This program performes all various update commands so I
# dont have to worry about updating specific apps

# Reload newsboat articles
newsboat -x reload
echo "Newsboat updated."

os=$(uname -a | awk '{print $(1);}') # This command works on macOS and Linux

if [[ "$os" == "Linux" ]]; then # Linux System
    sudo pacman -Syyu
    yay -Syyu --devel   # Update AUR packages + git dependencies
elif [[ "$os" == "Darwin" ]]; then # macOS System
    # Update homebrew packages and apps
    while true; do
        read -p "Update brew packages [y/n]? " yn
        case $yn in
            [Yy]* ) brew update > /dev/null; brew upgrade > /dev/null; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    # Update Microsoft Office Applications
    while true; do
        read -p "Update Microsoft applications [y/n]? " yn
        case $yn in
            [Yy]* ) /Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps MSWD2019 XCEL2019 PPT32019 > /dev/null; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

while true; do
    read -p "Update pip packages [y/n]? " yn
    case $yn in
        [Yy]* )
            # Update pip
            pip3 --quiet --no-input install --upgrade pip
            python3 -m pip install --upgrade pip
            /usr/bin/python -m pip install --upgrade pip
            # Update all pip packages
            pip freeze --user | cut -d'=' -f1 | xargs -n1 pip install -U
            python3 -m pip freeze --user | cut -d'=' -f1 | xargs -n1 python3 -m pip install -U
            break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Update git clones [y/n]? " yn
    case $yn in
        [Yy]* )
            IFS=$'\n' git_locations=($(find $HOME -name ".git"))
            for i in "${git_locations[@]}" ; do
                cd "${i%.*}" ; echo "Updating git folder $i" ; git pull || echo "Could not update $i"
            done
            cd
            break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

exit 0

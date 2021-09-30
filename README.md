# sh
A collection of shell scripts that I made for myself. Maybe they can help you too!

## Table of Contents
- [Table of Contents](#table-of-contents)
- [Installation](#Installation)
- [File Descriptions](#file-descriptions)
	- [Base64 Converter](#b64.sh)
	- [Cheetsheet](#cheetsheet.sh)
    - [Compile!](#c.sh)
    - [Open in that program](determine_browser.sh)
    - [Get image links from Bibliogram](gallery_bibliogram.py)
    - [Get image links from Imgur](gallery_imgur.py)
    - [Get image links from Reddit](gallery_reddit.py)
    - [Send to Github!](#gitpush.sh)
    - [What is my IP?](#ip.sh)
    - [Is someone watching something on Plex?](plex.sh)
	- [What was that update command again?](#update.sh)
- [Donate](#donate)

## Installation
Copy and paste this command to download this repository after you've changed directories to the folder you want.
```
git clone https://github.com/hussein-esmail7/sh
```
Then change directories into that folder.
```
cd sh
```
You can either make all the files executable or run them via bash by typing one of the two lines.
Option 1
```
bash <filename>.sh
```
Option 2
```
chmod +x *
./<filename>.sh
```

## File Descriptions
Here is a list of the file descriptions in this repository.

### b64.sh
This program decodes a base64 string into a readable string. If the readable string is a URL, it automatically opens the URL in the default browser.

### c.sh
This program compiles files. Instead of trying to remember which program to use to do it or if you need multiple lines, I have this program look at the given file extension and let it do the work. Currently it works with these extensions: `.c`, `.cpp`, `.html`, `.java`, `.ms`, `.py`, `.sh`, `.tex`, and possibly more if I forget to update this README file...

### determine_browser.sh
This program looks at what the given URL is, and determine what to open it in. I mainly use this to open image and audio links in `feh`, videos in `mpv`, and the rest in the default browser.

### gallery_bibliogram.py
This scrapes the given Bibliogram URL and returns each image link using selenium.

### gallery_imgur.py
This scrapes the given Imgur URL and returns each image link using selenium.

### gallery_reddit.py 
This program prints the individual Reddit image URLs from a Reddit Gallery link. It uses selenium, and prints the URLs all in one line, separated by a space.

### gitpush.sh
Instead of typing `git add .`, `git commit`, and `git push` each time I want to send something to my repository, I just type `gitpush` to send it to Github. I'm even going to use this right after I finish typing this sentence. 

### ip.sh
This program outputs your local and public IP address.

### plex.sh

### update.sh
This program is a collection of update commands so that I don't have to worry about updating individual items and I just have to run this.

## Donate
[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/husseinesmail)
# sh
A collection of shell scripts that I made for myself. Maybe they can help you too!

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Installation](#Installation)
- [File Descriptions](#file-descriptions)
	- [Base64 Converter](#b64.sh)
	- [Groff Cheetsheet](#groff-cheetsheet.sh)
	- [Groff Template](#groff-template.sh)
	- [What is my IP?](#ip.sh)
	- [Groff to PDF](#pdf.sh)
	- [What was that update command again?](#update.sh)
    - [Convert Reddit Gallery URLs to images](#reddit_gallery.py)

# Installation
Copy and paste this command to download this repository after you've changed directories to the folder you want.
```
git clone https://github.com/hussein-esmail7/sh
```
Then change directories into that folder.
```
cd sh
```
You can either make all the files execultable or run them via bash by typing one of the two lines.
Option 1
```
bash <filename>.sh
```
Option 2
```
chmod +x *
./<filename>.sh
```

# File Descriptions
Here is a list of the file descriptions in this repository.

## b64.sh
This program decodes a base64 string into a readable string. If the readable string is a URL, it automatically opens the URL in the default browser.

## groff-cheetsheet.sh
This program just prints a block of text that is used as a reference sheet for writing in groff/.ms files.

## groff-template.sh
This program generates a groff template file named 'template.ms' in the current directory that can be used to add text.

## ip.sh
This program outputs your local and public IP address.

## pdf.sh
This program converts a .ms (groff/troff) file into a .pdf file. It is run by typing "pdf filename.ms". The pdf filename is the .ms filename automatically. The reason why you can type "pdf" and not ./pdf.sh is because I have an alias in my terminal config file to this shell script.

## update.sh
This program is a collection of update commands so that I don't have to worry about updating individual items and I just have to run this.

## reddit_gallery.py
This program prints the individual Reddit image URLs from a Reddit Gallery link. It uses selenium, and prints the URLs all in one line, separated by a space.

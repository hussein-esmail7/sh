# TODO.md

## Vim autocompile
Make a new script specifically for VIM autocompile
Currently F5 is mapped to just c.sh
New method for this script:
- Recompile still using c.sh
- If Zathura is not open, open it with an & at the end of the command
	How: ps -aux | grep "zathura {filename}". Will return 1 or 0 lines
- If Zathura is open, do nothing for the rest of the program

## Bulkrename To Do
- Add "-q" argument if you don't want to show each file name that has changed
	afterwards
- Add "-s" or something for short file names while in vim


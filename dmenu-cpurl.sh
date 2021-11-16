#!/bin/bash
$(cat ~/.zsh_history | tail -n 1 | awk -F ';' 'NR==1 {$1="";print$0 }') | egrep -o '((http|https)://|www\.)[a-zA-Z1-9.+-/]*' | dmenu -p "copy url" -l 10 | xclip -selection clipboard

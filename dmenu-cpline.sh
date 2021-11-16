#!/bin/bash
$(cat ~/.zsh_history | tail -n 2 | awk -F ';' 'NR==1 {$1="";print$0 }') | dmenu -p "copy line" -l 10 | xclip -selection clipboard

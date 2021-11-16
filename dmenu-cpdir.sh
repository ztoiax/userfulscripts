#!/bin/bash
dir="bin|boot|dev|etc|home|lib|lib64|lost+found|mnt|opt|proc|root|run|sbin|srv|sys|tmp|usr|var"
$(cat ~/.zsh_history | tail -n 1 | awk -F ';' 'NR==1 {$1="";print$0 }') | egrep -o "/($dir)/[a-zA-Z0-9/.]*" | dmenu -p "copy dir" -l 10 | xclip -selection clipboard

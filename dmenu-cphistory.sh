#!/bin/bash
    history | sort -nr | awk '{$1="";print $0}' | dmenu -p "copy history" -l 10 | xclip -selection clipboard

#!/bin/zsh

function cpline {
    $(echo $line | awk '{$1="";print $0}') | dmenu -p "copy line" -l 10 | xclip -selection clipboard
}

function cphistory {
    hs=$(history)
    echo $hs | awk '{$1="";print $0}' | dmenu -p "copy history" -l 10 | xclip -selection clipboard
}

function cpcommand {
    hs=$(history)
    content=$(echo $hs | awk '{$1="";print $0}' | dmenu -p "copy content" -l 10)
    $(echo $content) | xclip -selection clipboard
}

function checkfile {
    grep '^#' /usr/include/X11/keysymdef.h | dmenu -p "XK" -l 15 | awk '{ print $2 }' | xclip -selection clipboard
}

choices=$(history)
chosen=`echo -e $choices | dmenu`

case "$chosen" in
    command) history > /home/tz/123;;
    line) cpline;;
esac

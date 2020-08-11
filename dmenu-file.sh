#!/bin/sh
function checkfile {
    grep '^#' /usr/include/X11/keysymdef.h | dmenu -p "XK" -l 15 | awk '{ print $2 }' | xclip -selection clipboard
}

choices="XK\ncommand\nline"
chosen=`echo -e $choices | dmenu`

case "$chosen" in
    XK) grep '^#' /usr/include/X11/keysymdef.h | dmenu -l 15;;
    command) ;;
    line) ;;
esac

#!/bin/sh

# x11
# cat ~/.zsh_history | tac | awk -F ';' '{$1=""; print$0 }' | dmenu -p "copy history" -l 10 | xclip -selection clipboard

# wayland
cat ~/.zsh_history | tac | awk -F ';' '{$1=""; print$0 }' | dmenu -p "copy history" -l 10 | wl-copy

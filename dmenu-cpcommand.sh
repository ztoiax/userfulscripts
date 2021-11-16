#!/bin/bash
$(cat ~/.zsh_history | tac | awk -F ';' '{$1=""; print$0 }) | dmenu -p "copy content" -l 10` | xclip -selection clipboard

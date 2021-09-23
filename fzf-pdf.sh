#!/bin/bash
select=$(rga "$1" . --rga-adapters=pandoc,poppler | fzf )
file_name=$(echo $select | awk -F : '{print $1}')
file_context=$(echo $select | awk '{print $3}')
zathura $file_name -f $file_context &

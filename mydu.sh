#!/bin/bash
if [ $# == 0 ]; then
     sudo du -cha --max-depth=1 . | grep -E "M|G" | sort -h
else
    for i in $@ ; do
        sudo du -cha --max-depth=1 $i | grep -E "M|G" | sort -h
        echo \n
    done
fi

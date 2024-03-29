#!/bin/bash

if [ $# -eq 0 ]; then
    if [ $PWD == "/" ];then
        du -cha --max-depth=1 \
            --exclude=mnt \
            --exclude=proc \
            --exclude=sys \
            . | grep -E "M|G" | sort -h
    else
        du -cha --max-depth=1 . | grep -E "M|G" | sort -h
    fi
else
    for i in $@ ; do
        du -cha --max-depth=1 $i | grep -E "M|G" | sort -h
        echo \n
    done
fi

#!/bin/bash
for i in "$@";do
    if [ -f "/tmp/$i" ];then
        rename=$i-$(date +"%Y-%m-%d:%H:%M:%S")
        echo "/tmp/$i if exists,rename append date"
        echo "$rename"
        mv $i /tmp/$rename
    else
        mv $i /tmp/$i
    fi
done

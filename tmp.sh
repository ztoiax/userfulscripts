#!/bin/bash
for i in "$@";do
    if [ -f /tmp/$i ];then
        mv $i /tmp/$i`date`
    else
        mv $i /tmp/$i
    fi
done

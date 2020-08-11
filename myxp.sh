#!/bin/bash
for i in $@;do
 case $i in
    *.gif)      mv $i{,.bak}; convert "$i.bak" -fuzz -20% -layers Optimize $i;;
    *)          echo "$i压缩格式还没收录"
esac
done

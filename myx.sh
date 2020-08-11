#!/bin/bash
for i in $@;do
 case $i in
    *.tar)      tar xvf $i;;
    *.tar.xz)   tar xvf $i;;
    *.tar.bz2)  tar xvjf $i;;
    *.tar.gz)   tar xvzf $i;;
    *.tbz)      tar xvjf $i;;
    *.tbz2)     tar xvjf $i;;
    *.tgz)      tar xvzf $i;;
    *.gz)       gunzip $i;;
    *.xz)       xz -d $i;;
    *.bz2)      bunzip2 $i;;
    *.zip)      unzip $i;;
    *.Z)        uncompress $i;;
    *.7z)       7z e $i;;
    *.tar.7z)   7z e $i -o ${i%%.*} && tar xvf ${i%%.*};;
    *)          echo "$i压缩格式还没收录"
esac
done

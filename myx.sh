#!/bin/bash
for i in $@;do
 case $i in
    *.tar)      tar xvf $i;;
    *.tar.xz)   tar xvf $i;;
    *.tar.bz)   tar xvjf $i;;
    *.tar.bz2)  tar xvjf $i;;
    *.tar.gz)   tar xvzf $i;;
    *.tbz)      tar xvjf $i;;
    *.tbz2)     tar xvjf $i;;
    *.tgz)      tar xvzf $i;;

    # nk保留原来的名字,并且不删除压缩文件
    *.gz)       gzip -dnk $i;;
    # xz,bz2没有n参数,不能保留原来的名字
    *.xz)       xz -dk $i;;
    *.bz)       bzip2 -dk $i;;
    *.bz2)      bzip2 -dk $i;;
    *.zip)      unzip $i;;
    *.Z)        uncompress $i;;
    *.7z)       7z e $i;;
    # *.tar.7z)   7z e $i -o ${i%%.*} && tar xvf ${i%%.*};;
    *)          echo "$i压缩格式还没收录"
esac
done

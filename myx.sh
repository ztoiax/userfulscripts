#!/bin/bash
# This is a fast decompression script

# check pigz command
if which pigz &> /dev/null;then
    gz="pigz -dNk"
    xgz="tar -I pigz -xvkf"
else
    gz="gzip -dnk"
    xgz="tar xvzf"
fi

if which pbzip2 &> /dev/null;then
    bz2="pbzip2 -dk"
    xbz2="tar -I pbzip2 -xvkf"
    # xbz2="pbzip2 -dc FOOBAR1.tar.bz2 | tar x"
else
    bz2="bzip2 -dk"
    xbz2="tar -jcpvf "
fi

if which pixz &> /dev/null;then
    xz="pixz -dk"
    xxz="tar -I pixz -xvkf"
    # xxz="pixz -dc FOOBAR1.tar.xz | tar x"
else
    xz="xz -dk"
    xxz="tar xvf"
fi
##### main ######
for i in $@;do
 case $i in
    *.tar)      tar xvf $i;;
    *.tar.gz)   $xgz  $i;;
    *.tar.bz)   $xbz2 $i;;
    *.tar.bz2)  $xbz2 $i;;
    *.tar.xz)   $xxz  $i;;
    *.tar.lz4)  tar -I lz4 -xvf $i;;
    *.tar.zst)  tar -I zstd -xvf $i;;
    *.tgz)      $xgz $i;;
    *.tbz)      $xbz2 $i;;
    *.tbz2)     $xbz2 $i;;
    *.txz)      $xxz $i;;
    *.tlz4)     tar -I lz4 -xvf $i;;
    *.tzst)     tar -I zstd -xvf $i;;

    # nk保留原来的名字,并且不删除压缩文件
    *.gz)       $gz $i;;
    # xz,bz2,lz4没有n参数,不能保留原来的名字
    *.xz)       $xz $i;;
    *.bz)       $bz2 $i;;
    *.bz2)      $bz2 $i;;
    *.zip)      unzip $i;;
    *.Z)        uncompress $i;;
    *.7z)       7z e $i;;
    *.lz4)      lz4 -dk $i;;
    *.zst)      zstd -dk $i;;
    # *.tar.7z)   7z e $i -o ${i%%.*} && tar xvf ${i%%.*};;
    *)          echo "$i压缩格式还没收录"
esac
done

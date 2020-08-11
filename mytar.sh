#!/bin/bash
yasuo(){
    case $1 in
        *.tar)     tar -cpvf $1 $2;;
        *.tar.gz)  tar -zcpvf $1 $2;;
        *.tar.bz2) tar -jcpvf $1 $2;;
        *.tar.xz)  tar -Jcvf $1 $2;;
        *.tar.7z)  tar -cpvf ${1%.*} $2 && echo ${1%.*};echo $1&& 7z a $1 ${1%.*};;

        *rar)  rar $1 $2;;
        *zip)  zip -r $1 $2;;
        *gz)   gzip -c $2 > $1;;
        *bz2)  bzip2 -c $2 > $1;;
        *xz)   xz -c $2 > $1;;
        *7z)   7z a $1 $2;;
        * ) echo "还没有收录$1的压缩格式"
    esac
}
echo ${0%/*}
if [ $# == 1 ]; then
    tar -tvf $1
elif [ $# == 2 ]; then
    yasuo $1 $2
else
    bak=$1
    shift
    for i in $@; do
        file="$file $i"
    done
    yasuo $bak "$file"
fi

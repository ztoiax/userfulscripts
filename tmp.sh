#!/bin/bash
for i in "$@";do
    # 如果有路径,则提取文件
    name=$(echo $i | awk -F '/' '{print $NF}')

    # 如果tmp路径下已经存在该文件,则重命名文件
    if [ -f "/tmp/$i" ];then
        rename=$name-$(date +"%Y-%m-%d:%H:%M:%S")
        echo "/tmp/$name if exists,rename append date"
        echo "$rename"
        mv $i /tmp/$rename
    else
        mv $i /tmp/$name
    fi
done

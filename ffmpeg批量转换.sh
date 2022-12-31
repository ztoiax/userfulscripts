#!/bin/bash
### 读取指定目录下文件，使用ffmpeg进行格式转换后，删除原文件

# 参数小于3就退出
if [[ $# < 3 ]];then
    echo "使用方法：ffmpeg.sh 目录 原格式 要转换的格式"
    echo "    例子1：ffmpeg.sh . mp4 mkv"
    echo "    例子2：ffmpeg.sh /tmp mp4 webm"
    exit 2
fi

# 转换
for file in $1/*;do
    if [[ $file == *.$2 ]]; then
        echo -e "开始转换\033[31m $file \033[0m"
        ffmpeg -i $file $file.$3
        # ffmpeg -i $file $file.$3 && rm $file
    fi
done

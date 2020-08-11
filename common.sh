#!/bin/bash
diff -Naur now last > last.diff
patch now < last.diff
#查看当前目录谁在使用
fuser -vm .
#列出子目录的大小，并统计总大小
du -cha --max-depth=1 . | grep -E "M|G" | sort -h

#
curl -sL

#!/bin/bash
# 用户可以输入任意数量的参数，利用for循环，可以读取每一个参数。

for i in "$@"; do
  echo $i
done

#2 Solution
echo "一共输入了 $# 个参数"

while [ "$1" != "" ]; do
  echo "剩下 $# 个参数"
  echo "参数：$1"
  shift
done

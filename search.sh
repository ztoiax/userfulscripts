#!/bin/bash
# set -x

search[0]="https://github.com/search?utf8=✓&q="
search[1]="https://developer.ibm.com/zh?s="
search[2]="https://support.huawei.com/enterprisesearch/?lang=zh#lang=zh&type=ALL&keyword="
search[3]="https://www.google.com/search?q=site:gitbook.com "
search[4]="https://developer.aliyun.com/search?q="
search[5]="https://wiki.archlinux.org/index.php?search="
search[6]="https://www.jianshu.com/search?q="
search[7]="https://quark.sm.cn/s?q="
search[8]="https://search.h3c.com/basesearch.aspx?q0="
search[9]="https://search.cisco.com/search?query="
search[10]="https://pkgs.org/search/?q="
search[11]="https://www.baidu.com/s?wd=site:linux.cn "
search[12]="https://pypi.org/search/?q="

name[1]="Github"
name[2]="IBM developer"
name[3]="华为技术支持"
name[4]="Gitbook"
name[5]="阿里云社区"
name[6]="archwiki"
name[7]="简书"
name[8]="夸克"
name[9]="华三技术支持"
name[10]="思科"
name[11]="pkgs"
name[12]="linux中国"
name[13]="python pypi"

lengh=${#name[*]}
declare -i lengh2=${#name[*]}

search(){
for ((i=1; i<=$lengh; i=i+1));do
    echo -e "[\033[33m$i\033[0m] ${name[$i]}"
done
read -p "输入0则全部打开，输入编号则打开的搜索引擎: " n
if [ $n == "0" ]; then
    for ((i=0; i<$lengh; i=i+1));do
        xdg-open "${search[$i-1]}$1" &> /dev/null
    done
elif (( n <= $lengh2 )) && (( n >= 0 )); then
    xdg-open "${search[$n-1]}$1" &> /dev/null
else
    echo -e "\033[31m ERROR \033[0m请输入1到$lengh的编号"
    return 1
fi
}

while getopts 'ha:' OPTION; do
  case "$OPTION" in
    h)
      echo "目前有${#name[*]}个搜索引擎"
      ;;

    a)
      avalue="$OPTARG"
      read -p "请输入要添加的搜索引擎: " s
      if ! curl -o /dev/null --connect-timeout 3 -s -w "%{http_code}" $s &>/dev/null; then
          echo "Warning: $s Access failure!"
          exit 1
      fi
      read -p "请输入要添加的搜索引擎的名字: " n
      if ! [ n ]; then
          echo "名字不能为空"
          exit 1
      fi
      sed -i "/^search\[$[$lengh-1]\]/asearch[$lengh]=\"$s\"" ~/.bin/search.sh
      sed -i "/^name\[$lengh\]/aname[$[$lengh+1]]=\"$n\"" ~/.bin/search.sh
      ;;
    ?)
      echo "script usage: $(basename $0) [-l] [-h] [-a somevalue]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND - 1))"

for i in $@; do
    search $i
done

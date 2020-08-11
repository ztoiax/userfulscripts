#!/bin/bash
    name[0]="[0]Github"
    name[1]="[1]IBM developer"
    name[2]="[2]华为技术支持"
    name[3]="[3]Gitbook"
    name[4]="[4]阿里云社区"
    name[5]="[5]archwiki"
    name[6]="[6]简书"
    name[7]="[7]夸克"
    name[8]="[8]华三技术支持"
    name[9]="[9]思科"
    name[10]="[10]pkgs"
    name[11]="[11]linux中国"
    name[12]="[12]python pypi"
    lengh=${#name[*]}

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

    for ((i=0; i<$lengh; i=i+1));do
        engine="$engine${name[$i]}\n"
    done
    n=$(echo -e $engine | dmenu -p 'engine' -l 15)

    for ((i=0; i<$lengh; i=i+1));do
        if [ "$n" == "${name[$i]}" ];then
            e=$(echo 'input' | dmenu)
            xdg-open "${search[$i]}$e" &> /dev/null
            break
        fi
    done

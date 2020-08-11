#!/bin/bash
    name[0]="[0]Github"
    name[1]="[1]Google"
    name[2]="[2]Bind"
    name[3]="[3]Baidu"
    name[4]="[4]IBM developer"
    name[5]="[5]华为技术支持"
    name[6]="[6]Gitbook"
    name[7]="[7]阿里云社区"
    name[8]="[8]Archwiki"
    name[9]="[9]简书"
    name[10]="[10]夸克"
    name[11]="[11]华三技术支持"
    name[12]="[12]思科"
    name[13]="[13]Pkgs"
    name[14]="[14]Linux中国"
    name[15]="[15]Python Pypi"
    name[16]="[16]Bilibli"
    lengh=${#name[*]}

    search[0]="https://github.com/search?utf8=✓&q="
    search[1]="https://www.google.com/search?q="
    search[2]="https://cn.bing.com/search?q="
    search[3]="https://www.baidu.com/s?wd="
    search[4]="https://developer.ibm.com/zh?s="
    search[5]="https://support.huawei.com/enterprisesearch/?lang=zh#lang=zh&type=ALL&keyword="
    search[6]="https://www.google.com/search?q=site:gitbook.com "
    search[7]="https://developer.aliyun.com/search?q="
    search[8]="https://wiki.archlinux.org/index.php?search="
    search[9]="https://www.jianshu.com/search?q="
    search[10]="https://quark.sm.cn/s?q="
    search[11]="https://search.h3c.com/basesearch.aspx?q0="
    search[12]="https://search.cisco.com/search?query="
    search[13]="https://pkgs.org/search/?q="
    search[14]="https://www.baidu.com/s?wd=site:linux.cn "
    search[15]="https://pypi.org/search/?q="
    search[16]="https://search.bilibili.com/all?keyword="

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

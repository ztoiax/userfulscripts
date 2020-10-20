#!/bin/bash
    name[0]="[0]Github"
    name[1]="[1]Google"
    name[2]="[2]Bind"
    name[3]="[3]Baidu"
    name[4]="[4]IBM developer"
    name[5]="[5]Huawei"
    name[6]="[6]Gitbook"
    name[7]="[7]aliyun"
    name[8]="[8]Archwiki"
    name[9]="[9]jianshu"
    name[10]="[10]夸克"
    name[11]="[11]H3C"
    name[12]="[12]Cisco"
    name[13]="[13]Pkgs"
    name[14]="[14]Linux中国"
    name[15]="[15]Python Pypi"
    name[16]="[16]Bilibli"
    name[17]="[17]Zhihu"
    name[18]="[18]Douban"
    name[19]="[19]Linux command"
    name[20]="[20]Weibo"
    name[21]="[21]Youtube"
    name[22]="[22]Reddit"
    name[23]="[23]ruanyif"
    name[24]="[24]mutilinux"
    name[25]="[25]mutisearch"
    name[26]="[25]Gitee"

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
    search[17]="https://www.zhihu.com/search?type=content&q="
    search[18]="https://www.douban.com/search?source=suggest&q="
    search[19]="https://man.linuxde.net/"
    search[20]="https://s.weibo.com/weibo/"
    search[21]="https://www.youtube.com/results?search_query="
    search[22]="https://www.reddit.com/search/?q="
    search[23]="https://www.baidu.com/s?wd=site:www.ruanyifeng.com "
    search[26]="https://search.gitee.com/?skin=rec&type=repository&q="

    lengh=${#name[*]}

    for ((i=0; i<$lengh; i=i+1));do
        engine="$engine${name[$i]}\n"
    done
    n=$(echo -e $engine | dmenu -p 'engine' -l 15)

    for ((i=0; i<$lengh; i=i+1));do
        if [ "$n" == "${name[$i]}" ];then
            e=$(echo 'input' | dmenu)
            # 当输入为空时(==input)，搜索剪切板的内容
            if [ "$e" == "input" ];then
                # 获取剪切板
                clip=$(xsel -o -b)
                xdg-open "${search[$i]}$clip" &> /dev/null
            else
                xdg-open "${search[$i]}$e" &> /dev/null
            fi
            break
        # muti linux
        elif [ "$n" == "${name[24]}" ];then
            e=$(echo 'input' | dmenu)
            xdg-open "${search[23]}$e" &> /dev/null
            xdg-open "${search[4]}$e"  &> /dev/null
            xdg-open "${search[0]}$e"  &> /dev/null
            xdg-open "${search[14]}$e" &> /dev/null
            xdg-open "${search[8]}$e"  &> /dev/null
            xdg-open "${search[7]}$e"  &> /dev/null
            break
        # muti search
        elif [ "$n" == "${name[25]}" ];then
            e=$(echo 'input' | dmenu)
            xdg-open "${search[1]}$e"  &> /dev/null
            xdg-open "${search[2]}$e"  &> /dev/null
            xdg-open "${search[3]}$e"  &> /dev/null
            xdg-open "${search[10]}$e" &> /dev/null
            xdg-open "${search[17]}$e" &> /dev/null
            xdg-open "${search[20]}$e" &> /dev/null
            break
        fi
    done
    # 如果没有选择搜索引擎，默认使用github搜索
        xdg-open "${search[0]}$n"  &> /dev/null

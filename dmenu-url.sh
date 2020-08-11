#!/bin/bash
    name[1]="[1]oh-my-fish"
    name[2]="[2]ranger"
    name[3]="[3]fzf"
    name[4]="[4]zyplay"
    name[5]="[5]miniet"
    name[6]="[6]termux"
    name[7]="[7]图解git"
    name[8]="[8]正则表达式"
    name[9]="[9]zinit"
    name[10]="[10]vim set config"
    name[11]="[11]dwm"
    name[12]="[12]git guide"
    lengh=${#name[*]}

    url[1]="https://linux.cn/article-9515-1.html?pr"
    url[2]="http://ranger.github.io/"
    url[3]="https://github.com/junegunn/fzf"
    url[4]="https://github.com/Hunlongyu/ZY-Player"
    url[5]="https://developer.ibm.com/zh/articles/1404-luojun-sdnmininet/"
    url[6]="https://www.sqlsec.com/2018/05/termux.html"
    url[7]="https://marklodato.github.io/visual-git-guide/index-zh-cn.html"
    url[8]="https://blog.robertelder.org/regular-expression-visualizer/"
    url[9]="https://www.jianshu.com/p/2e098dfecf4a"
    url[10]="https://www.shortcutfoo.com/blog/top-50-vim-configuration-options/"
    url[11]="http://www.glinkus.com/2020/07/12/Dwm%E7%9A%84%E7%AE%80%E5%8D%95%E4%BB%8B%E7%BB%8D/"
    url[12]="https://www.progit.cn/"

    bashurl[1]="https://wangdoc.com/bash/intro.html"
    bashurl[2]="https://developer.ibm.com/zh/tutorials/l-lpic1-map/"

    bashname[1]="ruanyif"
    bashname[2]="IBM"
    for ((i=0; i<$lengh; i=i+1));do
        engine="$engine${name[$i]}\n"
    done
    n=$(echo -e $engine | dmenu -p 'engine' -l 15)

    for ((i=0; i<$lengh; i=i+1));do
        if [ "$n" == "${name[$i]}" ];then
                xdg-open "${url[$i]}" &> /dev/null
                break
        fi
    done

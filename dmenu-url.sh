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
    name[13]="[13]bash ruanyif"
    name[14]="[14]bash IBM"
    name[15]="[15]openstack 官方"
    name[16]="[16]openstack 百家号"
    name[17]="[17]vim ruanyif"
    name[18]="[18]vim插件推荐"
    name[19]="[19]分布式架构演变"
    name[20]="[20]awesome soft"
    name[21]="[21]rime"
    name[22]="[22]rime2"
    name[23]="[23]zabbix"
    name[24]="[24]regular"
    name[25]="[25]马哥linux"
    name[26]="[26]mutivim"
    name[27]="[27]mutibash"
    name[28]="[28]mutigit"
    name[29]="[29]markdown in vim"
    name[30]="[30]这才是真正的Git——Git内部原理揭秘！"
    name[31]="[31]这才是真正的Git——Git实用技巧"
    name[32]="[32]bash腾讯技术"

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
    url[13]="https://wangdoc.com/bash/intro.html"
    url[14]="https://developer.ibm.com/zh/tutorials/l-lpic1-map/"
    url[15]="https://www.rdoproject.org/install/packstack/"
    url[16]="https://baijiahao.baidu.com/s?id=1617520630408423500&wfr=spider&for=pc%20in%205%20mins"
    url[17]="http://www.ruanyifeng.com/blog/2018/09/vimrc.html"
    url[18]="https://zhuanlan.zhihu.com/p/58816186"
    url[19]="https://segmentfault.com/a/1190000018626163"
    url[20]="https://linux.cn/article-10171-1.html"
    url[21]="https://github.com/LEOYoon-Tsaw/Rime_collections/blob/master/Rime_description.md"
    url[22]="https://github.com/rime/home/wiki/RimeWithSchemata"
    url[23]="https://linux.cn/article-4305-weixin.html"
    url[24]="https://www.regular-expressions.info/quickstart.html"
    url[25]="https://www.magedu.com/74163.html?linux_wenzhang_zhihu_jinke_tiaocaobibei40ti_33967414"
    url[29]="https://www.zhihu.com/search?type=content&q=markdown%20vim"
    url[30]="https://zhuanlan.zhihu.com/p/96631135"
    url[31]="https://zhuanlan.zhihu.com/p/192961725"
    url[32]="https://zhuanlan.zhihu.com/p/123989641"

    lengh=${#name[*]}

    for ((i=1; i<=$lengh; i=i+1));do
        engine="$engine${name[$i]}\n"
    done
    n=$(echo -e $engine | dmenu -p 'url' -l 15)

    for ((i=0; i<$lengh; i=i+1));do
        if [ "$n" == "${name[$i]}" ];then
                xdg-open "${url[$i]}" &> /dev/null
                break
        # muti vim
        elif [ "$n" == "${name[26]}" ];then
                xdg-open "${url[10]}" &> /dev/null
                xdg-open "${url[17]}" &> /dev/null
                xdg-open "${url[18]}" &> /dev/null
                xdg-open "${url[29]}" &> /dev/null
                break
        # muti bash
        elif [ "$n" == "${name[27]}" ];then
                xdg-open "${url[13]}" &> /dev/null
                xdg-open "${url[14]}" &> /dev/null
                xdg-open "${url[32]}" &> /dev/null
                break
        # muti git
        elif [ "$n" == "${name[28]}" ];then
                xdg-open "${url[7]}"  &> /dev/null
                xdg-open "${url[12]}" &> /dev/null
                xdg-open "${url[30]}" &> /dev/null
                xdg-open "${url[31]}" &> /dev/null
                break
        fi
    done

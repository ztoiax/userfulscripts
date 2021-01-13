#!/bin/bash
    name[0]="[0]Github"
    name[1]="[1]Google"
    name[2]="[2]Bind"
    name[3]="[3]Baidu"
    name[4]="[4]IBM developer"
    name[5]="[5]Huawei"
    name[6]="[6]Gitbook"
    name[7]="[7]Aliyun"
    name[8]="[8]Arch"
    name[9]="[9]jianshu"
    name[10]="[10]KuaKe"
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
    name[24]="[24]MutiLinux"
    name[25]="[25]MutiSearch"
    name[26]="[26]Gitee"
    name[27]="[27]WeiXin"
    name[28]="[28]TaoBao"
    #学术
    name[29]="[29]BaiduXueShu"
    name[30]="[30]GoogleXueShu"
    name[31]="[31]MicrosoftXueShu"
    name[32]="[32]nstl国家科技图书文献中心"
    name[33]="[33]Open Access library"
    name[34]="[34]MutiXueShu"
    #书
    name[35]="[35]zlibrary"
    #
    name[36]="[36]Wiki"
    name[37]="[37]LWM"
    name[38]="[38]Net"


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
    search[27]="https://weixin.sogou.com/weixin?type=2&s_from=input&query="
    search[28]="https://s.taobao.com/search?q="
    #学术
    search[29]="https://xueshu.baidu.com/s?wd="
    search[30]="https://scholar.google.com/scholar?hl=zh-CN&as_sdt=0%2C5&q="
    search[31]="https://academic.microsoft.com/search?q="
    search[32]="http://oar.nstl.gov.cn/Paper/Search?searchKey="
    #书
    search[33]="https://zh.b-ok.cc/s/"
    search[36]="https://en.wikipedia.org/wiki/"
    search[37]="https://www.google.com/search?q=site:lwn.net "
    search[38]="https://www.google.com/search?q=site:netbeez.net "


    lengh=${#name[*]}
    function mutilinux(){
        xdg-open "${search[23]}$1" &> /dev/null
        xdg-open "${search[4]}$1"  &> /dev/null
        xdg-open "${search[0]}$1"  &> /dev/null
        xdg-open "${search[14]}$1" &> /dev/null
        xdg-open "${search[8]}$1"  &> /dev/null
        xdg-open "${search[7]}$1"  &> /dev/null
    }
    function mutisearch(){
        xdg-open "${search[1]}$1"  &> /dev/null
        xdg-open "${search[2]}$1"  &> /dev/null
        xdg-open "${search[3]}$1"  &> /dev/null
        xdg-open "${search[10]}$1" &> /dev/null
        xdg-open "${search[17]}$1" &> /dev/null
        xdg-open "${search[20]}$1" &> /dev/null
    }
    function mutixueshu(){
        xdg-open "${search[29]}$1"  &> /dev/null
        xdg-open "${search[30]}$1"  &> /dev/null
        xdg-open "${search[31]}$1"  &> /dev/null
        xdg-open "${search[32]}$1" &> /dev/null
    }

    # 显示搜索引擎
    for ((i=0; i<$lengh; i=i+1));do
        engine="$engine${name[$i]}\n"
    done
    # 选择搜索引擎
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
            exit 0
        # muti linux
        elif [ "$n" == "${name[24]}" ];then
            e=$(echo 'input' | dmenu)
            if [ "$e" == "input" ];then
                # 获取剪切板
                clip=$(xsel -o -b)
                mutilinux $clip
            else
                mutilinux $e
            fi
            exit 0
        # muti search
        elif [ "$n" == "${name[25]}" ];then
            e=$(echo 'input' | dmenu)
            if [ "$e" == "input" ];then
                # 获取剪切板
                clip=$(xsel -o -b)
                mutisearch $clip
            else
                mutisearch $e
            fi
            exit 0
        # muti xueshu
        elif [ "$n" == "${name[34]}" ];then
            e=$(echo 'input' | dmenu)
            if [ "$e" == "input" ];then
                # 获取剪切板
                clip=$(xsel -o -b)
                mutixueshu $clip
            else
                mutixueshu $e
            fi
            exit 0
        fi
    done
    # 如果没有选择搜索引擎，默认使用github搜索
        if [ "$n" ];then
            echo ${search[0]}$n > /tmp/test
            xdg-open "${search[0]}$n"  &> /dev/null
        fi

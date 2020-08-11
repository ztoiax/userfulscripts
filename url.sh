#!/bin/bash
#url
urlopenstack(){
openstack[0]="https://www.rdoproject.org/install/packstack/"
openstack[1]="https://baijiahao.baidu.com/s?id=1617520630408423500&wfr=spider&for=pc%20in%205%20mins"
name[1]="官方"
name[2]="百家号"
lengh=${#name[*]}
lengh2="[1-${#name[*]}]"

for ((i=1; i<=$lengh; i=i+1));do
    echo -e "[\033[33m$i\033[0m] ${name[$i]}"
done
read -p "输入0则全部打开，输入编号则打开对应网址: " n
if [ $n == "0" ]; then
    for ((i=0; i<$lengh; i=i+1));do
        xdg-open "${openstack[$i]}" &> /dev/null
    done
elif [[ $n =~ $lengh2 ]]; then
    xdg-open "${openstack[$n-1]}" &> /dev/null
else
    echo -e "[\033[31m ERROR \033[0m请输入0到$lengh的编号"
    return 1
fi
}

urlbash(){
bash[0]="https://wangdoc.com/bash/intro.html"
bash[1]="https://developer.ibm.com/zh/tutorials/l-lpic1-map/"

name[1]="ruanyif"
name[2]="IBM"
lengh=${#name[*]}
declare -i lengh2=${#name[*]}

for ((i=1; i<=$lengh; i=i+1));do
    echo -e "[\033[33m$i\033[0m] ${name[$i]}"
done
read -p "输入0则全部打开，输入编号则打开对应网址: " n
if [ $n == "0" ]; then
    for ((i=0; i<$lengh; i=i+1));do
        xdg-open "${bash[$i]}" &> /dev/null
    done
elif (( n <= $lengh2 )) && (( n >= 0 )); then
    xdg-open "${bash[$n-1]}" &> /dev/null
else
    echo -e "[\033[31m ERROR \033[0m请输入0到$lengh的编号"
    return 1
fi
}
urlnvim(){
url[1]="https://zhuanlan.zhihu.com/p/58816186"
}

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

name[1]="oh-my-fish"
name[2]="ranger"
name[3]="fzf"
name[4]="zyplay"
name[5]="miniet"
name[6]="termux"
name[7]="图解git"
name[8]="正则表达式"
name[9]="zinit"
name[10]="vim set config"
name[11]="dwm"
name[12]="git guide"

declare -i lengh=${#name[*]}

if [ $# == 0 ];then
    for ((i=1; i<=$lengh; i++));do
        echo "[$i] ${name[$i]}"
    done
    read -p "请输入编号: " n

    xdg-open "${url[$n]}" &> /dev/null
elif [ $# == 1 ];then
    case $1 in
        bash ) urlbash;;
        openstack ) urlopenstack;;
        * ) echo -e "\033[31m ERROR \033[0m$1还没有收录"
    esac
fi

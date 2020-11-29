#!/bin/bash

# 源修改
# 中科大源使用帮助 https://mirrors.ustc.edu.cn/help/dockerhub.html

##### function ######

dockersource(){
    echo " Replacing docker aliyun source..."
    # 中科大
    # i='"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]'

    # docker 阿里源
    i='"registry-mirrors": ["https://pee6w651.mirror.aliyuncs.com"]'

    sudo sed -i "/registry-mirrors/c$i" /etc/docker/daemon.json

    DOCKER_OPTS=$i
    sudo systemctl restart docker
}

pipsource(){
if [ ! -f ~/.pip/pip.conf ]; then
    echo " Replacing pip aliyun source..."
    if [ ! -d ~/.pip ]; then
        mkdir ~/.pip
    fi
    aliyun="[global]\n
    trusted-host=mirrors.aliyun.com\n
    index-url=https://mirrors.aliyun.com/pypi/simple/"
    echo -e $aliyun > ~/.pip/pip.conf
fi
}

npmsource() {
    echo " Replacing npm taobao source..."
    # npm install -g cnpm --registry=https://registry.npm.taobao.org
    npm config set registry https://registry.npm.taobao.org
    # npm config set registry https://mirrors.huaweicloud.com/repository/npm/
    # npm config set sass_binary_site https://mirrors.huaweicloud.com/node-sass
    # npm config set disturl https://mirrors.huaweicloud.com/nodejs
    npm cache clean -f
}

yumsource(){
    echo " Replacing yum aliyun source..."
    release=$(cat /etc/redhat-release | awk '{ print $4 }' | cut -c1)

    if [ ! -f /etc/yum.repo.d.bak ];then
        echo "This is red hat $release version"
        mv /etc/yum.repo.d/ /etc/yum.repo.d.bak
        mkdri /etc/yum.repo.d
        curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-$release.repo
    fi

    echo "install epel source"
    yum install -y epel-release

    echo " Replacing epel aliyun source..."
    cp /etc/yum.repo.d/epel.repo /etc/yum.repo.d/epel.repo.bak
    sed -i 'baseurl/cbaseurl=https://mirrors.aliyun.com/epel/$release/Everything/$basearch' /etc/yum.repos.d/epel.repo
    sed -i 'metalink/c#metalink' /etc/yum.repos.d/epel.repo

    yum clean all
    yum makecache
}

epelsource(){
    echo " Replacing epel aliyun source..."
    cp /etc/yum.repo.d/epel.repo /etc/yum.repo.d/epel.repo.bak
    sed -i 'baseurl/cbaseurl=https://mirrors.aliyun.com/epel/$release/Everything/$basearch' /etc/yum.repos.d/epel.repo
    sed -i 'metalink/c#metalink' /etc/yum.repos.d/epel.repo
}

pacmansource(){
    echo " Replacing pacman aliyun source..."
    aliyun=Server = https://mirrors.aliyun.com/archlinuxcn/$arch
    echo aliyun >> /etc/pacman.conf
    #导入GPG key。
    archlinuxcn-keyring
}

yaysource(){
    echo "install yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    echo " Replacing yay tuna source..."
    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
    yay -P -g
    cat ~/.config/yay/config.json

    #gpg: keyserver receive failed: General error
    #gpg --keyserver pool.sks-keyservers.net --recv-keys 6C37DC12121A5006BC1DB804DF6FD971306037D9
}

##### main ######

case $1 in
    npm*) npmsource ;;
    pip*) pipsource ;;
    docker*) dockersource ;;
    yum*) yumsource ;;
    epel*) epelsource ;;
    pacman*) pacmansource ;;
    yay*) yaysource ;;

    list ) set | grep "()";;
    * ) echo "$i 源还有收录";;
esac

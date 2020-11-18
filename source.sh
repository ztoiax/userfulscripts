#!/bin/bash
# 源修改

# 中科大源使用帮助
# https://mirrors.ustc.edu.cn/help/dockerhub.html

dockersource(){
    # 中科大
    # i='"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn/"]'

    # docker 中国区源
    i='"registry-mirrors": ["https://registry.docker-cn.com"]'

    sudo sed -i "/registry-mirrors/c$i" /etc/docker/daemon.json

    DOCKER_OPTS=$i
    sudo systemctl restart docker
}

pipsource(){
if [ ! -f ~/.pip/pip.conf ]; then
    echo "正在更换pip源"
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
    echo "正在更换npm源"
npm config set registry https://mirrors.huaweicloud.com/repository/npm/
npm config set sass_binary_site https://mirrors.huaweicloud.com/node-sass
npm config set disturl https://mirrors.huaweicloud.com/nodejs
npm cache clean -f
}

debsource() {
    echo "正在更换ubuntu18.04源"
cp /etc/apt/sources.list sources.list.bak
sudo echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" > /etc/apt/sources.list 
}

case $1 in
    npm*) npmsource ;;
    pip*) pipsource ;;
    * ) echo "$i还有收录";;
esac

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

    baidu="[global]\ntrusted-host=mirrors.baidu.com\nindex-url=https://mirror.baidu.com/pypi/simple/"
    echo -e $baidu > ~/.pip/pip.conf
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
    # 获取版本号。7、8
    release=$(awk '{ print $4 }' /etc/redhat-release | cut -c1)

    dir=/etc/yum.repos.d
    backup=/etc/yum.repos.d.bak

    if [ ! -f "$backup" ];then
        echo "This is red hat $release version"
        mv $dir $backup
        mkdir $dir
        cd $dir

        # 下载阿里云的源
        # curl -LO https://mirrors.aliyun.com/repo/Centos-7.repo
        # curl -LO https://mirrors.aliyun.com/repo/Centos-8.repo
        curl -LO https://mirrors.aliyun.com/repo/Centos-$release.repo
    fi

    echo "install epel source"
    yum install -y epel-release

    echo " Replacing epel aliyun source..."
    mv $dir/epel.repo $backup/epel.repo.bak
    mv $dir/epel-testing.repo $backup/epel-testing.repo.bak

    if [ "$release" == "8" ];then
        sed -i 's|^#baseurl=https://download.fedoraproject.org/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
        sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
    else
        yum install -y wget
        curl -LO http://mirrors.aliyun.com/repo/epel-$release.repo
        mv /etc/yum.repos.d/epel-$release.repo /etc/yum.repos.d/epel.repo
    fi

    yum clean all
    yum makecache
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
zyppersource(){
    zypper mr -da
    echo " Replacing pacman aliyun source..."
    zypper ar -fc https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/oss openSUSE-Aliyun-OSS
    zypper ar -fc https://mirrors.aliyun.com/opensuse/distribution/leap/15.2/repo/non-oss openSUSE-Aliyun-NON-OSS
    zypper ar -fc https://mirrors.aliyun.com/opensuse/update/leap/15.2/oss openSUSE-Aliyun-UPDATE-OSS
    zypper ar -fc https://mirrors.aliyun.com/opensuse/update/leap/15.2/non-oss openSUSE-Aliyun-UPDATE-NON-OSS
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
    zypper*) zyppersource;;

    list ) set | grep "()";;
    * ) echo "$i 源还有收录";;
esac

#!/bin/bash
#openstack
baseinstall(){
echo  "LANG=en_US.utf-8" > /etc/environment
echo  "LC_ALL=en_US.utf-8" >> /etc/environment
if [ -f /etc/yum/.repos.d/CentOS-Base.repo.backup ]; then
    echo "已存在repo.backup"
else
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
fi

systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network
sed -i 's/=enforcing/=disabled/' /etc/selinux/config
}

centos7(){
echo "正在安装openstack"
baseinstall
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum install https://rdoproject.org/repos/rdo-release.rpm -y
yum install centos-release-openstack-rocky -y
yum install openstack-packstack -y
}

centos8(){
echo "正在安装openstack"
baseinstall
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
dnf install network-scripts -y
dnf config-manager --enable PowerTools
dnf install -y centos-release-openstack-ussuri
dnf update -y
dnf install -y openstack-packstack
packstack --allinone
}

openstackinstall(){
if ! egrep '(vmx|svm)' /proc/cpuinfo | wc -l;; then
    echo "cpu没有开启虚拟化"
    return 1
fi
if rpm -q openstack; then
    echo "openstack已安装"
    return 1
fi
v=`cat /etc/redhat-release`
c7="CentOS Linux release 7*"
c8="CentOS Linux release 8*"
case $v in
   $c7 )  centos7install;;
   $c8 )  centos8install;;
   *)     echo "找不到版本 $v 的安装"
esac
}


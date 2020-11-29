#!/bin/bash

# check and set env

##### variable ######

programs="~/Downloads/Programs"

##### check linux release ######

if [ -f /usr/bin/lsb_release ]; then
    # debian like
    install="apt-get"
    check="dpkg -l"
    echo "This is Debian like"
elif [ -f /etc/redhat-release ];then
    # red hat
    install="yum -y"
    check="rpm -q"
    release=$(cat /etc/redhat-release | awk '{ print $4 }' | cut -c1)
    echo "This is red hat $release version"
elif [ which pacman ];then
    # arch
    install="pacman -S"
    # check="rpm -q"
    echo "This is Arch"
elif uname -a | grep Android;then
    # android
    install="pkg"
    check="pkg show"
    echo "This is Android"
fi

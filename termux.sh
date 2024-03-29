#!/bin/bash
#换源
qinghua(){
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
    sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
    sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-root-packages-24/ root stable" > $PREFIX/etc/apt/sources.list.d/root.list
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-root-packages-24/ unstable main" > $PREFIX/etc/apt/sources.list.d/unstable.list
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-root-packages-24/ x11 main" > $PREFIX/etc/apt/sources.list.d/x11.list
    # sed -i 's@^\(deb.*root stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/root-packages-24 root stable@' $PREFIX/etc/apt/sources.list.d/root.list
    # sed -i 's@^\(deb.*unstable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/unstable-packages-24 unstable main@' $PREFIX/etc/apt/sources.list.d/unstable.list
    # sed -i 's@^\(deb.*x11 main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/x11-packages-24 x11 main@' $PREFIX/etc/apt/sources.list.d/x11.list
apt update && apt upgrade
}

ustc(){
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.ustc.edu.cn/termux stable main@' $PREFIX/etc/apt/sources.list
}

atilo(){
git clone https://github.com/YadominJinta/atilo
pip install tqdm
pip install prettytable
pip install bs4

cd /usr/atilo/CN
chmod +x atilo_cn
}
other(){
pkg install cmatrix
pkg install screenfetch
}

kali(){
wget -O install-nethunter-termux https://offs.ec/2MceZWr
chmod +x install-nethunter-termux
./install-nethunter-termux

wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh && bash kali.sh
}

zsh(){
    pkg install zsh
    # zinit
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
}

termux(){
#install
ustc
pkg install tsu -y
# ssh
passwd
pkg install openssh -y
tsu
ssh-keygen -A
sshd
nmap 127.0.0.1
ssh root@192.168.1.111
}

apt install neovim wget git make silversearcher-ag tree openssl proot -y
apt install lsof nmap -y
apt install nodejs golang python3 python3-pip npm -y
apt install fish zsh ranger fzf exa -y
apt install p7zip lz4 zstd pigz pbzip2 pixz
apt install pv
apt install sqlite3 redis default-mysql-server

pip3 install ptpython litecli iredis mycli

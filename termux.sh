#!/bin/bash
#换源
aptsource(){
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
}
zhongkeda(){
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.ustc.edu.cn/termux/dists/ stable main@' $PREFIX/etc/apt/sources.list
}
waiguoyu(){
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.bfsu.edu.cn/ stable main@' $PREFIX/etc/apt/sources.list
}

echo "[1] 清华源"
echo "[2] 中科大"
echo "[3] 北京外国语大学"
read -p "请输入源" n
case n in
    1 ) qinghua;;
    2 ) zhongkeda;;
    3 ) waiguoyu;;
    * ) echo "输入错误";return 1;;
esac
apt update && apt upgrade
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
#install
pkg install neovim wget git tree tsu openssl proot -y
pkg install openssh -y && sshd
pkg install lsof nmap htop -y
pkg install python -y
pkg install nodejs -y
pkg install ranger -y
pkg install fish -y

pip install ipython -y
#config
nvimconfig
fishconfig

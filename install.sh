#!/bin/bash
base(){
#源修改
sudo add-apt-repository ppa:mmstick76/alacritty 		#alacritty
sudo add-apt-repository ppa:dobey/redshift-daily		#护眼redshift
sudo add-apt-repository ppa:kelleyk/emacs
sudo add-apt-repository ppa:lazygit-team/release        #gitgui
#google源
 sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
 wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -

#base install
sudo apt-get -y install vim
sudo apt-get -y install zsh
sudo apt-get -y install git
sudo apt-get -y install aria2
sudo apt-get -y install curl
sudo apt-get -y install tree
sudo apt-get -y install npm
sudo apt-get -y install silversearcher-ag
sudo apt-get -y install net-tools nmcli macchanger #network tool
sudo apt-get -y install python-pip python-sdl2 python3-pip python3-sdl2
sudo apt-get -y install highlight
sudo apt-get -y install global
sudo apt-get -y install ctags
sudo apt-get -y install make
sudo apt-get -y install clang
sudo apt-get -y install qemu qemu-kvm libvirt-bin libvirt-clients libvirt-daemon-system virt-manager #kvm
sudo apt-get -y install emacs25
sudo apt-get -y install vim
sudo apt-get -y install docker
#systemctl
sudo systemctl enable fstrim                    #开启ssd trim
#https://zhuanlan.zhihu.com/p/34683444

#spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d -b develop

#nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

monitor(){
sudo apt-get -y netdata						    #系统监视
sudo apt-get -y install lazygit                 #gitgui
sudo apt-get -y install sysstat                 #sar
sudo apt-get -y install htop
sudo apt-get -y install atop
sudo apt-get -y install iftop
sudo apt-get -y install iotop
sudo apt-get -y install glances
sudo apt-get -y install pybootchartgui          #启动时间记录
sudo apt-get -y install trace-cmd               #函数跟踪
sudo apt-get -y install fio                     #块io测试
sudo apt-get -y install bpfcc-tools linux-headers-$(uname -r) #bcc

pip install s-tui                               #cpu monitor
#perf
sudo apt-get -y install linux-tools-common
sudo apt-get -y install linux-tools-generic
sudo apt-get -y install linux-cloud-tools-generic
#https://www.ibm.com/developerworks/cn/linux/l-cn-perf1/index.html
}
gui(){
sudo apt-get -y install synaptic				#新立得包管理
sudo apt-get -y install albert					#alt+space窗口
sudo apt-get -y install unetbootin				#usb镜像制作
snap install scrcpy                             #Android投屏
#gnome
sudo apt-get -y install gnome-tweak-tool
#空格文件预览
sudo apt-get -y install gnome-sushi
sudo apt-get -y install gnome-shell-extensions

#sougou
sudo apt-get -y install fcitx-table-wbpy fcitx-config-gtk
im-config -n fcitx
wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb?st=ryCwKkvb-0zXvtBlhw5q4Q&e=1529739124&fn=sogoupinyin_2.2.0.0108_amd64.deb
sudo dpkg -i sogoupinyin_2.2.0.0108_amd64.deb
}
cli(){
sudo apt-get -y install keynav					#键盘控制鼠标
sudo apt-get -y install ansiweather             #天气
#网易云音乐cli
sudo apt-get -y install mpg123
sudo pip install NetEase-MusicBox
#窗口管理器
sudo apt-get -y install libx11-dev				#libX11
sudo apt-get -y install libxft-dev				#libxft
sudo apt-get -y install alacritty				#终端模拟器
sudo apt-get -y install compton					#透明效果
sudo apt-get -y install ranger					#文件浏览器
sudo apt-get -y install cmatrix					#黑客帝国效果
sudo apt-get -y install neofetch				#系统信息显示
sudo apt-get -y install xdotool                 #鼠标模拟
#pip
pip install tldr
pip install PyGTK
sudo snap refresh cointop --stable              #实时查看币圈
#when-changed
pip install https://github.com/joh/when-changed/archive/master.zip
pip install scapy
pip install -U pure-python-adb                  #adb
pip install pyinstaller                         #打包成可执行程序
pip install you-get                             #下载工具

sudo npm install -g nrm                         #源列表
sudo npm install -g fanyi                       #翻译

#v2ray
bash <(curl -L -s https://install.direct/go.sh)
#bbr
sudo bash -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
sudo bash -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'
sudo sysctl -p
sudo sysctl net.ipv4.tcp_available_congestion_control

}
other(){
#deepin-wine
git clone https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu.git

#android
#QEMU Android模拟器的库
qemu-img create -f qcow2 android.img 15G
#首次运行
sudo qemu-system-x86_64 -m 2048 -boot d -enable-kvm -smp 3 -net nic -net user -hda android.img -cdrom /home/mhsabbagh/android-x86_64-8.1-r1.iso
#启动
sudo qemu-system-x86_64 -m 2048 -boot d -enable-kvm -smp 3 -net nic -net user -hda android.img

#firacode Font
https://raw.githubusercontent.com/tonsky/FiraCode/master/distr/ttf/FiraCode-Retina.ttf 
#cascadia Font
https://github.com/microsoft/cascadia-code
#source-code Font
https://github.com/adobe-fonts/source-code-pro
#网易云音乐
https://music.163.com/
#Motrix下载软件
https://motrix.app/zh-CN/
#wps
https://www.wps.cn/product/wpslinux
#ocr
https://sourceforge.net/projects/lios/
#ubuntu驱动安装
sudo ubuntu-drivers autoinstall
#exa alias ls
https://the.exa.website/#installation
#broot 目录树
https://dystroy.org/broot/documentation/installation/
#BleanchBit清理缓存
https://www.bleachbit.org/download
#FDM
https://www.freedownloadmanager.org/zh/
#Anaconda
https://repo.anaconda.com/archive/
#android
#sipleperf
#https://android.googlesource.com/platform/prebuilts/simpleperf/+archive/master.tar.gz
}
set -x
while getopts 'bcga:' OPTION; do
  case "$OPTION" in
    a)
      echo "all install"
      base()
      gui()
      cli()
      ;;

    b)
      echo "base install"
      base()
      ;;

    c)
      echo "cli install"
      cli()
      ;;

    g)
      echo "gui install"
      gli()
      ;;
    ?)
      echo "script usage: $(basename $0) [-a] [-b] [-c] [-g]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND - 1))"

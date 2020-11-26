#!/bin/bash
# set -x

# $install tlp #它能帮你的设备省点电
mysql(){
    $install mycli                # 更友好的cli
    $install mydumper             # 更友好的mysqldump
    $install xtrabackup           # 支持增量备份
    $install innotop              # 性能监控tui
    $install percona-toolkit      # 运维工具cli
    $install workbench            # 官方gui
    $install undrop-for-innodb    # 恢复误删除数据
    $install mitzasql             # vim key tui

    # binlog2sql
    git clone https://github.com/danfengcao/binlog2sql.git && cd binlog2sql
    pip install -r requirements.txt

    # canal_client
    curl -LO https://github.com/liukelin/canal_mysql_nosql_sync/files/442171/canal_client_1.0.22.2.zip
    # canal.deployer
    curl -LO https://github.com/alibaba/canal/releases/download/canal-1.1.4/canal.deployer-1.1.4.tar.gz
}

bspwm(){
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
}

log(){
$install rsyslog
}

chinese(){
cat >> ~/.xprofile << "EOF"
# 设置中文界面
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
EOF

cat >> /etc/locale.conf << "EOF"
# 设置中文界面
#这个变量的值会覆盖掉所有未设置的 LC_* 变量的值.
LANG=zh_CN.UTF-8
EOF
# 立即启用
sudo locale-gen
unset LANG
source /etc/profile.d/locale.sh
}

code(){
$install sourcetrail
$install vscode
}

kvm(){
    # web ui console
    dnf install cockpit cockpit-machines
    systemctl start cockpit.socket
    systemctl enable cockpit.socket
    systemctl status cockpit.socket

    firewall-cmd --add-service=cockpit --permanent
    firewall-cmd --reload

    # kvm
    dnf install qemu-kvm libvirt virt-install virt-viewer

    # $install libvirt libvirt-daemon  libvirt-client  libvirt-daemon-driver-qemu
    # $install qemu-kvm  virt-install  virt-viewer virt-v2v
    # gui
    # $install virt-manager
    # $install dnsmasq ebtables dmidecode ovmf

    # 设置开机启动
    echo "设置开机启动"
    systemctl enable libvirtd
    systemctl start libvirtd

    #开启日志
    echo "开启日志"
    systemctl enable virtlogd.service
    systemctl start virtlogd.service

    systemctl status libvirtd.service
    lsmod | grep kvm
}

hackintosh(){
    git clone https://github.com/foxlet/macOS-Simple-KVM.git
    cd macOS-Simple-KVM
    ./jumpstart.sh --mojave
}

char(){
    $install thefuck
    $install how2
    $install tldr
    $install asciinema #终端屏幕录制
    $install csvkit #https://csvkit.readthedocs.io/en/1.0.3/
    $install entr   #事件监控
    $install pet    #CLI Snippet Manager
    # yay -S ripgrep-all
}

instead(){
    # https://linux.cn/article-4042-1.html
    $install advcp             # instead cp mv
    $install silversearcher-ag # instead grep
    $install bat               # instead cat
    $install diff-so-fancy     # instead git diff
    $install fd                # instead find
    $install cfdisk            # instead fdisk
    $install bit               # instead git cli
    $install exa               # instead ls
    $install cheat             # instead man
    $install prettyping        # instead ping
    $install gping             # instead ping
    $install dfc               # instead df
    $install duf               # instead detailed df
    $install ncdu              # instead ncdu
}

filemanage(){
    $install mc                # file manage with support mouse
    $install broot             # file manage
}

git-advance(){
    $install git-extras
    npm i -g cli-github
    npm i -g git-stats
    npm i -g commitizen # git cz 代码提交规范
}

nnn(){
    # plugin preview-tabbed
    $install tabbed
    $install sxiv
    $install lsix
}

ranger(){
$install ranger-git
$install ffmpegthumbnailer ueberzug

#fzf
git clone https://github.com/laggardkernel/ranger-fzf-marks.git ~/.config/ranger/plugins/fzf-marks
mv ~/.config/ranger/plugins/fzf-marks/*.py ..

#icon
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
cd ~/.config/ranger/plugins/ranger_devicons && make install
echo "default_linemode devicons" >> ~/.config/ranger/plugins/ranger_devicons

#autojump
#https://github.com/fdw/ranger-autojump
}

navi(){
git clone https://github.com/denisidoro/navi ~/.navi
cd ~/.navi
make install
}

shortcutinstall(){
git clone https://github.com/mt-empty/shortcut-c-client
cd shortcut-c-client
make install
}

grub(){
    echo "installing grub"
    $install os-prober
    grub-mkconfig -o /boot/grub/grub.cfg
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
}

st(){
    git clone https://git.suckless.org/st
    cd st
    sed -i '/X11INC = \/usr\/X11R6\/include/cX11INC = /usr/include/X11' config.mk
    sed -i '/X11LIB = \/usr\/X11R6\/lib/cX11LIB = /usr/include/X11' config.mk
    sudo make clean install
}

sshserver(){
    $install install -y openssh

    echo "PermitRootLogin yes
    StrictModes no
    RSAAuthentication yes
    PubkeyAuthentication yes
    PasswordAuthentication no"

    sed -i '/PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config
    sed -i '/PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
    sed -i "/^PermitRootLogin/cPermitRootLogin yes" /etc/ssh/sshd_config
    sed -i '/RSAAuthentication/cRSAAuthentication yes' /etc/ssh/sshd_config
    sed -i '/StrictModes/cStrictModes no' /etc/ssh/sshd_config
}

sshclient(){
    echo "ssh免密码登录正在安装"
    read -p "enter serverip: " serverip
    ssh-keygen -t rsa
    # scp ~/.ssh/id_rsa.pub root@$serverip:/root/.ssh/authorized_keys
    ssh-copy-id $serverip
}

other(){
    $install alsa-utils # 声卡驱动sound
    $install kdeconnect nodejs subversion
}

base(){

    $install ntfs-3g
    $install openssh
    $install git wget make
    $install python2 python3 python-pip python3-pip
    $install tree
    $install vidir
    $install proxychains # proxy

    # Mount Android
    # yay -S simple-mtpfs

    # time
    # sudo timedatectl set-local-rtc true
}

nvim(){
# if [ $release == 7 ]; then
    echo "installing neovim"
    # yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    $install neovim python3-neovim
# fi
}

fish(){
    echo "installing fish"
    $install fish && echo "installing oh-my-fish" && \
    curl -L https://get.oh-my.fish | fish
}

fzf(){
    if type fzf; then
        echo "fzf id installed"
        return 1
    fi
    echo "installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

monitorinstall() {
# 综合
$install atop htop
$install netdata
$install dstat
sudo cnpm install -g gtop
bashtop(){
git clone https://github.com/aristocratos/bashtop.git
cd bashtop
sudo make install
}
bashtop
# CPU
sudo pip3 install s-tui
}

tui(){
# lazydocker
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
# lazygit
    $install lazygit
}

phoronixinstall(){
# phoronix http://www.phoronix-test-suite.com/
echo "正在下载phoronix"
wget https://phoronix-test-suite.com/releases/phoronix-test-suite-9.8.0.tar.gz
echo "正在解压phoronix"
tar xzf phoronix-test-suite-9.8.0.tar.gz
rm phoronix-test-suite-9.8.0.tar.gz
cd phoronix-test-suite
echo "正在安装phoronix"
sudo ./install-sh
echo "开始phoronix"

$install php-cli php-xml
}

iozoneinstall(){
# iozone http://www.iozone.org/
if type dpkg;then
wget http://launchpadlibrarian.net/154969760/iozone3_420-3_amd64.deb
--2020-07-27 17:29:47--  http://launchpadlibrarian.net/154969760/iozone3_420-3_amd64.deb
sudo dpkg -i iozone3_420-3_amd64.deb && rm iozone3_420-3_amd64.deb
elif type rpm;then
wget http://www.iozone.org/src/current/iozone-3-490.src.rpm
rpm -ivh iozone-3-490.src.rpm && rm iozone-3-490.src.rpm
fi
}



########## main ##########

# check linux release
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

for i in "$@"; do
    case $i in
        # personal customization
        fzf ) fzf;;
        fish ) fish;;
        base ) base;;
        grub ) grub;;
        nvim ) nvim;;
        instead ) instead;;
        other ) other;;

        # server
        kvm ) kvm;;
        sshserver ) sshserver;;
        sshclient ) sshclient;;
        monitor ) monitorinstall;;
        phoronix ) phoronixinstall;;

        openstack ) source openstack.sh && openstackinstall;;

        # config
        *config ) source ${0%/*}/config.sh && config.sh $i;;
        *source ) source ${0%/*}/source.sh && source.sh $i;;

        # other
        list ) set | grep "()";;
        * ) read -p "$i暂时没收录，是否使用$install安装:[y/n] " y
            if [ $y == y ]; then
                sudo $install install -y $i
            else
                exit 1
            fi
            ;;
    esac
done
# https://github.com/orangbus/Tool

#!/bin/bash
# set -x
char(){
$install thefuck
$install how2
$install tldr
}

ohterinstall(){
$install netease-cloud-music
$install baidupcs-go
yay -S lanzou-gui   #蓝奏云
yay -S timeshift    #backup
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

nvminstall(){
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
}

fzfinstall(){
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
}

grubinstall(){
$install os-prober
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
}

stinstall(){
git clone https://git.suckless.org/st
cd st
sed -i '/X11INC = \/usr\/X11R6\/include/cX11INC = /usr/include/X11' config.mk
sed -i '/X11LIB = \/usr\/X11R6\/lib/cX11LIB = /usr/include/X11' config.mk
sudo make clean install
}
sshserver(){
if rpm -q openssh; then
    echo "ssh已安装,免密码正在安装"
else
    echo "正在安装ssh"
    $install install -y openssh
fi
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
    # scp ~/.ssh/id_rsa.pub root@$serverip:/root/.ssh/
    ssh-copy-id $serverip
}
epelinstall(){
if rpm -q epel-release; then
    echo "epel已安装"
    return
fi
echo "正在安装epel"
yum install -y epel-release
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# yum clean all
# yum makecache
}

# base
baseinstall(){
$install alsa-utils ntfs-3g
$install git wget make nodejs subversion
$install python2 python3 python-pip python3-pip
$install bat silversearcher-ag
$install tree
pip3 install ranger-fm

npm install -g cnpm --registry=https://registry.npm.taobao.org

#Mount Android
yay -S simple-mtpfs
sudo simple-mtpfs --device 1 /mnt/android/
sudo fusermount -u /mnt/android

# time
# sudo timedatectl set-local-rtc true
}

# extra
extra(){
rimeinstall
}
nvim(){
if [ $release == 7 ]; then
    echo "正在安装neovim"
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum install -y neovim python3-neovim
fi
}
#fish
fishinstall(){
if [ $release == 7 ]; then
    echo "正在安装fish"
    cd /etc/yum.repos.d/
    wget https://download.opensuse.org/repositories/shells:fish:release:2/RedHat_RHEL-6/shells:fish:release:2.repo
    yum install -y fish
elif [ $release == 8 ]; then
    echo "正在安装fish"
    cd /etc/yum.repos.d/
    wget https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_8/shells:fish:release:3.repo
    yum install -y fish
fi
}
oh-my-fishinstall(){
    curl -L https://get.oh-my.fish | fish
}
fzfinstall(){
if type fzf; then
    echo "fzf已安装"
    return 1
fi
echo "正在安装fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
}

adbconnect(){
adb -s 192.168.1.111:5555 connect 192.168.1.111:5555
sleep 1
adb -s 192.168.1.111:5555 forward tcp:10808 tcp:10808
export ALL_PROXY=socks5://127.0.0.1:10808
export NO_PROXY="mirrors.aliyun.com,registry.npm.taobao.org,npm.taobao.org,docker.mirrors.ustc.edu.cn,mirrors.aliyuncs.com,mirrors.cloud.aliyuncs.com"
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

if [ -f /usr/bin/lsb_release ]; then
    install="apt-get"
    check="dpkg -l"
elif [ -f /etc/redhat-release ];then
    install="yum"
    check="rpm -q"
elif uname -a | grep Android;then
    install="pkg"
    check="pkg show"
fi
# 系统版本
release=$(cat /etc/redhat-release | awk '{ print $4 }' | cut -c1)

for i in "$@"; do
    case $i in
        adb ) adbconnect;;
        fzf ) fzfinstall;;
        epel ) epelinstall;;
        fish ) fishinstall;;
        base ) baseinstall;;
        monitor ) monitorinstall;;
        phoronix ) phoronixinstall;;
        sshserver ) sshserver;;
        sshclient ) sshclient;;
        openstack ) source openstack.sh && openstackinstall;;

        *config ) source ${0%/*}/config.sh && config.sh $i;;
        *source ) source ${0%/*}/source.sh && source.sh $i;;
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

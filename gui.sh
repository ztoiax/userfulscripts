#!/bin/bash
echo "gtk-key-theme-name = Emacs" >> ~/.config/gtk-3.0/settings.ini

other(){
    $install keynav     #键盘控制鼠标
    $install electronic-wechat-bin
    $install netease-cloud-music
    $install baidupcs-go
    yay -S lanzou-gui   #蓝奏云
    yay -S timeshift    #backup
    yay -S zfs-linux
    yay -S procdump
    yay -S qt-scrcpy
    pip3 install -u guiscrcpy
    $install bleachbit  #清理垃圾
    $install stacer     #电脑管家
    $install testdisk   #恢复删除文件
    $install xunlei-bin #迅雷
    $install d-feet     #调试dbus
    $install filelight  #树目录大小
    $install gitkraken  #git gui
    $install qv2ray     #v2ray-gui
    $install gparted    #part-gui
    $install deepin.com.qq.im.light #wine qq light
}

awesomechar(){
    $install figlet                 #beautiful char
    $install cmatrix				#黑客帝国效果
    $install neofetch				#系统信息显示
    $install cpufetch				#cpu信息显示
}

font(){
    #biaoqing
    noto-fonts-emoji
    libxft-bgra

    # emoji
    paru -S noto-fonts-emoji
    #font
    paru -S ttf-sourcecodepro-nerd
    #or
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts && sudo curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
}

#pdf
zathura(){
    $install zathura
    $install zathura-pdf-poppler
}

rimefctix(){
$install fcitx-im fcitx-confitool fcitx-rime vim-fcitx
# fcitx
cat >> ~/.xprofile << "EOF"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

export QT4_IM_MODULE=fcitx
export QT5_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
EOF
#theme
git clone https://github.com/winjeg/fcitx-skins.git
cd fcitx-skins
chmod a+x ./install.sh
./install.sh
}

fcitx5(){
yay -S fcitx5 fcitx5-chinese-addons fcitx5-table-extra fcitx5-configtool fcitx5-qt fcitx5-gtk gnome-shell-extension-kimpanel-git
# spell
sudo pacman -Sy hunspell
# 萌娘百科，中文维基百科词库 成语词库
yay -S fcitx5-pinyin-moegirl-rime fcitx5-pinyin-zhwiki fcitx5-pinyin-chinese-idiom
# 皮肤
yay -S fcitx5-material-color
yay -S fcitx5-gruvbox-dark-theme-git
paru -S fcitx5-skin-fluentlight-git

# kde
yay -S kcm-fcitx5-git
# rime输入法
yay -S fcitx5-rime-git

cat >> ~/.pam_environment << "EOF"
INPUT_METHOD  DEFAULT=fcitx5
GTK_IM_MODULE DEFAULT=fcitx5
QT_IM_MODULE  DEFAULT=fcitx5
XMODIFIERS    DEFAULT=\@im=fcitx5
EOF

cat > ~/.config/fcitx5/conf/classicui.conf << "EOF"
# 垂直候选列表
Vertical Candidate List=False

# 按屏幕 DPI 使用
PerScreenDPI=True

# Font (设置成你喜欢的字体)
Font="思源黑体 CN Medium 16"

# 主题
Theme=Material-Color-Brown
EOF
}

rimeibus(){
$install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4
$install ibus-rime
# 简体
$install librime-data-pinyin-simp
# 粵拼
$install librime-data-jyutping
ibus restart
ibus engine rime
}

surf(){
$install gcr
$install webkit2gtk
}

sddm(){
$install sddm
sudo sddm --example-config > /etc/sddm.conf
#sddm theme
sudo pacman -S gst-libav phonon-qt5-gstreamer gst-plugins-good qt5-quickcontrols qt5-graphicaleffects qt5-multimedia
cd /usr/share/sddm/themes
sudo git clone https://github.com/3ximus/aerial-sddm-theme.git
sudo sed -i  "/Current=/cCurrent=aerial-sddm-theme" /etc/sddm.conf
#auto login
sudo mkdir /etc/sddm.conf.d
sudo cat > /etc/sddm.conf.d/autologin.conf << "EOF"
[Autologin]
User=tz
Session=dwm.desktop
EOF

sudo systemctl enable sddm.service
}

lightdm(){
sudo pacman -S --needed lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan

sudo sed -i '/#greeter-session/cgreeter-session=lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm.service
}

lightdm-autologin(){
sudo pacman -S lightdm lightdm-gtk-greeter
sudo sed -i 's/#autologin-user=/autologin-user=tz/' /etc/lightdm/lightdm.conf

sudo sed -i '/#background=/cbackground=/home/tz/Pictures/wallpaper/wallpaper-34.jpg' /etc/lightdm/lightdm-gtk-greeter.conf
# 启动自动登陆
sudo groupadd autologin
sudo gpasswd -a tz autologin
# 启用无密码交互登录
sudo sed -i  "2iauth        sufficient  pam_succeed_if.so user ingroup nopasswdlogin" /etc/pam.d/lightdm
sudo groupadd -r nopasswdlogin
sudo gpasswd -a username nopasswdlogin
sudo systemctl enable lightdm.service
}

icon(){
    yay -S la-capitaine-icon-theme
    yay -S flat-remix
}

xorg(){
    $install feh #wallpaper
    $install eog #image viewer
    $install dunst #notifications
    $install screenkey #show key input
    $install deepin-screen-recorder #screen-recorder
    $install peek #screen-recorder
    $install wal #set termianl colorscheme from wallpaper
    $install compton #alpha
    $install grub-customizer # grub
    $install wmctrl # show id of windows
    # $install transmission-gtk # torrnet download
    # $install conky #menu
    # $install noti #notifications process
    # $install variety #wallpaper config
    # $install simplescreenrecorder #screen recorder

    # $install lxappearance     # gtk config
    # $install pcman-gtk3       # gtk file manager
    # $install orchis-theme-git # gtk theme

    # $install qt5ct        # qt config
    # $install pcman-qt     # qt file manager
}

dwm(){
$install xdotool
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
        sddm ) sddm;;
        xorg ) xorg;;
        font ) font;;
        fcitx5 ) fcitx5;;
        zathura ) zathura;;
        other ) other;;
        awesomechar ) awesomechar;;

        # other
        list ) set | grep "()";;
        * ) read -p "$i暂时没收录，是否使用$install安装:[y/n] " y
            if [ $y == y ]; then
                sudo $install $i
            else
                exit 1
            fi
            ;;
    esac
done
# https://github.com/orangbus/Tool

#!/bin/bash
echo "gtk-key-theme-name = Emacs" >> ~/.config/gtk-3.0/settings.ini

awesomechar(){
$install figlet                 #beautiful char
$install cmatrix				#黑客帝国效果
$install neofetch				#系统信息显示
}

font(){
#biaoqing
noto-fonts-emoji
libxft-bgra
#font
yay -S nerd-fonts-source-code-pro
cd ~/.local/share/fonts && sudo curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
}

zathura(){
#pdf
$install zathura
$install zathura-pdf-poppler
}

rimefctixinstall(){
$install fcitx-im fcitx-confitool fcitx-rime
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
gti clone https://github.com/winjeg/fcitx-skins.git
cd fcitx-skins
chmod a+x ./install.sh
./install.sh
}

rimeibusinstall(){
$install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4
$install ibus-rime
# 简体
$install librime-data-pinyin-simp
# 粵拼
$install librime-data-jyutping
ibus restart
ibus engine rime
}

sddminstall(){
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
}

iconinstall(){
yay -S la-capitaine-icon-theme
yay -S flat-remix
}

xorginstall(){
#notifications
$install dunst
#notifications process
$install noti
#screen-recorder
$install deepin-screen-recorder
#set termianl colorscheme from wallpaper
$install wal
#alpha
$install compton
#menu
$install dmenu
$install conky
#themes
$install lxappearance
#wallpaper
$install feh
#wallpaper config
$install variety

#show key input
$install screenkey
#screen recorder
$install simplescreenrecorder
#download
$install transmission
}
dwminstall(){
$install xdotool
}

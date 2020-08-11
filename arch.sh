archinstall(){
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
# 编辑/etc/locale.gen 然后移除需要的 地区 前的注释符号
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo "LC_ALL=en_US.utf-8" >> /etc/environment
pacman -Sy dhcpcd
pacman -Sy networkmanager
systemctl enable dhcpcd
systemctl enable NetworkManager
pacman -Sy zsh fish git wget bash-completion go base-devel python-pip the_silver_searcher inetutils
passwd
}

aur(){
# git clone https://aur.archlinux.org/aurman.git
# cd aurman
# makepkg -si
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
}

bspwm(){
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
}

deepininstall(){
pacman -S deepin deepin-extra file-roller firefox
useradd -m -g wheel tz
passwd tz
# systemctl enable lightdm
}

ip(){
$ip='
interface=eth0\n
address=192.168.1.221\n
netmask=255.255.255.0\n
broadcast=192.168.1.255\n
gateway=192.168.1.1
'
echo -e $ip >> /etc/rc.conf

$dns='
nameserver 223.5.5.5\n
nameserver 114.114.114.114
'
echo -e $dns >> /etc/resolv.conf
}

hosts(){
hosts=\
'
#<ip-address>	<hostname.domain.org>	<hostname> \n
127.0.0.1	localhost.localdomain	localhost	 myhostname\n
::1		localhost.localdomain	localhost	 myhostname
'
echo -e $hosts >> /etc/hosts
}

nvidia(){
#https://computingforgeeks.com/easiest-way-to-install-nvidia-3d-graphics-acceleration-driver-on-archlinux/
pacman -S nvidia
#Once installed, confirm that the nouveau module is blacklisted.
cat /usr/lib/modprobe.d/nvidia.conf
}

proxy(){
ln -s /usr/share/goagent/local/CA.crt /etc/ca-certificates/trust-source/anchors/GoAgent.crt
trust extract-compat
}

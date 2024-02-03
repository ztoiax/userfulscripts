#!/bin/bash
preparation(){
    # 1.磁盘分区，并挂载到/mnt 和/mnt/boot
    # 2.连接wifi
    iwctl station 设备名 connect "wifi名字"
    # 3.换源
    # 4.安装
    pacstrap -K /mnt base linux linux-firmware
    pacstrap -K iwd zsh fish vi vim neovim
    # 5.chroot
    arch-chroot /mnt
}

arch(){
    # arch-chroot，并配置好网络和换源后。执行如下操作
    echo "install arch..."
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc
    # 注释en_US.UTF-8 UTF-8和zh_CN.UTF-8
    vim /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo "LC_ALL=en_US.UTF-8" >> /etc/locale.conf
    pacman -Sy archlinux-keyring # 更新pgp
    pacman -Sy dhcpcd
    pacman -Sy networkmanager
    pacman -Sy pacman-contrib #paccache
    systemctl enable dhcpcd
    systemctl enable NetworkManager
    pacman -S firewalld # 动态防火墙
    systemctl enable firewalld
    pacman -Sy zsh fish git wget bash-completion go base-devel python-pip the_silver_searcher inetutils expac ranger arch-install-scripts
    # 如果是笔记本，查看电量需要安装acpi。通过acpi -b可以查看电量
    pacman -S acpi acpid
    passwd

    # 新建用户。-m自动创建/home/tz目录
    useradd -m tz
    passwd tz

    # 让用户可以使用sudo。
    usermod -aG wheel tz
    # 注销wheel的一行
    visudo
}

key(){
# :: File /var/cache/pacman/pkg/db5.3-5.3.28-2-x86_64.pkg.tar.zst is corrupted (invalid or corrupted package (PGP signature)).
# Do you want to delete it? [Y/n] y
# error: jack2: signature from "Frederik Schwan <frederik.schwan@linux.com>" is unknown trust
# 如果使用pacman -S 安装时，遇到以上问题。解决方法如下
  rm -rf /etc/pacman.d/gnupg/*
  pacman-key --init
  pacman-key --populate archlinux
  pacman -Sy archlinux-keyring # 更新pgp
}

yay(){
    echo "install yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    echo "setting tuna souce"
    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
    yay -P -g
    cat ~/.config/yay/config.json
}

deepininstall(){
    echo "install deepin..."
    pacman -S deepin deepin-extra file-roller
    useradd -m -g wheel tz
    passwd tz
    # systemctl enable lightdm
}

ip(){
    echo "setting ip and dns..."
    $ip='
    interface=eth0\n
    address=192.168.1.222\n
    netmask=255.255.255.0\n
    broadcast=192.168.1.255\n
    gateway=192.168.1.1
    '
    echo -e $ip >> /etc/rc.conf

    $dns='
    nameserver 211.162.52.209\n
    nameserver 223.5.5.5
    '
    echo -e $dns >> /etc/resolv.conf
}

hosts(){
    echo "setting /etc/hosts ..."
    hosts=\
    '
    #<ip-address>	<hostname.domain.org>	<hostname> \n
    127.0.0.1	localhost.localdomain	localhost	 myhostname\n
    ::1		localhost.localdomain	localhost	 myhostname
    '
    echo -e $hosts >> /etc/hosts
}

nvidia(){
    echo "install nvidia..."
    #https://computingforgeeks.com/easiest-way-to-install-nvidia-3d-graphics-acceleration-driver-on-archlinux/
    pacman -S nvidia nvidia-settings
    #Once installed, confirm that the nouveau module is blacklisted.
    cat /usr/lib/modprobe.d/nvidia.conf
}

proxy(){
    ln -s /usr/share/goagent/local/CA.crt /etc/ca-certificates/trust-source/anchors/GoAgent.crt
    trust extract-compat
}

for i in "$@"; do
    case $i in
        yay ) yay;
        arch ) arch;
        proxy ) proxy;;
        nvidia ) nvidia;;
        ip ) ip;;
        host ) host;
        deepininstall ) deepininstall;
        nvidia ) nvidia;

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

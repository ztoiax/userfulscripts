#/bin/bash
arch(){
    echo "install arch..."
    pacstrap /mnt base linux linux-firmware
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc
    # 编辑/etc/locale.gen 然后移除需要的 地区 前的注释符号
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    echo "LC_ALL=en_US.utf-8" >> /etc/environment
    pacman -Sy archlinux-keyring # 更新pgp
    pacman -Sy dhcpcd
    pacman -Sy networkmanager
    pacman -Sy pacman-contrib #paccache
    systemctl enable dhcpcd
    systemctl enable NetworkManager
    pacman -Sy zsh fish git wget bash-completion go base-devel python-pip the_silver_searcher inetutils expac
    passwd
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

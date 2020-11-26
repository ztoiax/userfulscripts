#/bin/bash
br(){
    echo "setting br0..."
    nmcli connection add type bridge autoconnect yes con-name br0 ifname br0
    nmcli connection modify br0 ipv4.addresses 192.168.1.222/24
    nmcli connection modify br0 ipv4.gateway 192.168.1.1
    nmcli connection modify br0 ipv4.dns 211.162.52.209 +ipv4.dns 223.5.5.5
    nmcli connection del enp27s0
    nmcli connection add type bridge-slave autoconnect yes con-name br0 ifname br0 master enp27s0

    systemctl restart NetworkManager
    nmcli connection show
    bridge link show br0
}

net(){
    echo "create bridge.xml..."
    cat > arch-bridge.xml << 'EOF'
    <network>
    <name>host-bridge</name>
    <forward mode="bridge"/>
    <bridge name="br0"/>
    </network>
EOF
    echo "setting bridge.xml..."
    virsh net-define arch-bridge.xml
    virsh net-autostart arch-bridge

    virsh net-list --all
    virsh net-dhcp-leases default
}

arch(){
    virt-install \
    --virt-type=kvm \
    --name arch \
    --memory 4096 \
    --vcpus=11 \
    --os-type=linux \
    --os-variant=archlinux \
    --cdrom=/root/archlinux-2020.11.01-x86_64.iso \
    --network network=default \
    --disk path=/mnt/vm/arch.qcow2,size=50,format=qcow2  \
    --graphics=vnc -v

    #--console pty,target_type=serial -v \
    #--graphics vnc,port=5900,listen=0.0.0.0

    #ssh ssh -L 127.0.0.1:5905:127.0.0.1:5900 -N root@192.169.122.1

    #check variant
    #osinfo-query os

    #--extra-args console=ttyS0 -v
    #--cdrom=/root/archlinux-2020.11.01-x86_64.iso \

    #--autostart -v \
    # 重定向到终端 --extra-args console=ttyS0
    #--graphics type=vnc -v

    # virsh console arch
    # virsh vncdisplay arch

    virsh list --all
    # virsh dominfo arch
}
# virsh autostart arch

for i in "$@"; do
    case $i in
        br ) br;;
        arch ) arch;;
        net ) net;;

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

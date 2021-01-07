#!/bin/bash
configzfs(){
    read -p "请输入设备: " dev
    zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O acltype=posixacl -O atime=off -O xattr=sa -m none -R /mnt/gentoo tank $dev
    zfs create tank/gentoo
    zfs create -o mountpoint=/ tank/gentoo/os
    zpool status
    zfs list
}

configmount(){
    read -p "请输入stage3的路径: " dir
    dir="/mnt/windows/iso/linux/stage3-amd64-systemd-20210103T214503Z.tar.xz"
    cd /mnt/gentoo
    mkdir -p boot/efi
    mount /dev/nvme0n1p1 /mnt/gentoo/boot/efi
    tar xpvf $dir -C /mnt/gentoo


    mkdir etc/zfs
    cp /etc/zfs/zpool.cache etc/zfs
    cp /etc/resolv.conf etc/

    mount --rbind /dev dev
    mount --rbind /proc proc
    mount --rbind /sys sys
    mount --make-rslave dev
    mount --make-rslave proc
    mount --make-rslave sys
}

configfile(){
cd /mnt/gentoo
echo "config make.conf"
cat >> /mnt/gentoo/etc/portage/make.conf << "EOF"
USE="-branding"

# This should be your number of processors + 1
MAKEOPTS="-j12"

EMERGE_DEFAULT_OPTS="--with-bdeps=y --keep-going=y"
FEATURES="buildpkg"
L10N="en en_US zh_CN en zh"
LINGUAS="en en_US zh_CN en zh"
GENTOO_MIRRORS="http://mirrors.aliyun.com/gentoo/"
VIDEO_CARDS="nouveau"

# This is required so that when we compile GRUB later, EFI support is built.
GRUB_PLATFORMS="efi-64"
EOF

# sed -i s/COMMON_FLAGS="-O3 -pipe"/COMMON_FLAGS="-march=native -O3 -pipe"/g  /mnt/gentoo/etc/portage/make.conf

echo "config gentoo-portage"
cp /usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf
cat >> /mnt/gentoo/etc/portage/repos.conf << 'EOF'
[DEFAULT]
main-repo = gentoo

[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage
auto-sync = yes
sync-rsync-verify-jobs = 1
sync-rsync-verify-metamanifest = yes
sync-rsync-verify-max-age = 24
sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc
sync-openpgp-key-refresh-retry-count = 40
sync-openpgp-key-refresh-retry-overall-timeout = 1200
sync-openpgp-key-refresh-retry-delay-exp-base = 2
sync-openpgp-key-refresh-retry-delay-max = 60
sync-openpgp-key-refresh-retry-delay-mult = 4
EOF

    cat >> /mnt/gentoo/etc/portage/package.use << 'EOF'
*/* PYTHON_TAGETS: -python2_7
*/* PYTHON_COMPAT: python3_7 python3_8 python3_9
EOF

#    cat >> /mnt/gentoo/etc/fstab << 'EOF'
#UUID=9418-C880  /boot/efi       vfat    umask=0077      0       1
#EOF
}

configchroot(){
    configzfs
    configmount
    configfile
    env -i HOME=/root TERM=$TERM chroot /mnt/gentoo bash -l
}

# zpool import -d /dev/nvme0n1p8
for i in "$@"; do
    case $i in
        configzfs ) configzfs;;
        configmount ) configmount;;
        configfile ) configfile;;
        configchroot ) configchroot;;
        *) echo "error";;
    esac
done

# env -i HOME=/root TERM=$TERM chroot /mnt/gentoo bash -l
# emerge-webrsync
# emerge --sync


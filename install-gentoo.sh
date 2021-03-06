#!/bin/bash
configzfs(){
    read -p "请输入设备: " dev
    zpool create -f -o ashift=12 -o cachefile= -O compression=lz4 -O acltype=posixacl -O atime=off -O xattr=sa -m none -R /mnt/gentoo tank $dev
    zfs create tank/gentoo
    zfs create -o mountpoint=/ tank/gentoo/os
    zpool status
    zfs list
}

configzfs2(){
    read -p "请输入设备: " dev
    zpool create -f -o ashift=12 -o cachefile=/tmp/zpool.cache -O normalization=formD -O compression=lz4 -m none -R /mnt/gentoo tz $dev
	zfs create -o mountpoint=none -o canmount=off tz/ROOT
	zfs create -o mountpoint=/ tz/ROOT/gentoo
	zfs create -o mountpoint=/boot tz/ROOT/boot
	zpool set bootfs=tz/ROOT/boot tz
	zfs create -V 2G -b $(getconf PAGESIZE) -o logbias=throughput -o sync=always -o primarycache=metadata tz/SWAP
	mkswap /dev/zvol/tz/SWAP
	swapon /dev/zvol/tz/SWAP

	zfs list -t all
	zpool get bootfs tz
}
configmount(){
    read -p "请输入stage3的路径: " dir
    dir="/mnt/windows/iso/linux/stage3-amd64-systemd-20210103T214503Z.tar.xz"
    cd /mnt/gentoo
    mkdir -p boot/efi
    mount /dev/nvme0n1p1 /mnt/gentoo/boot/efi
    tar xpvf $dir -C /mnt/gentoo


    mkdir -p /mnt/gentoo/etc/zfs
    cp /tmp/zpool.cache /mnt/gentoo/etc/zfs/zpool.cache
    cp /etc/resolv.conf /mnt/gentoo/etc/

    mount --rbind /dev dev
    mount --rbind /proc proc
    mount --rbind /sys sys
    mount --make-rslave dev
    mount --make-rslave proc
    mount --make-rslave sys
}

configfile(){
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

sed -i 's/COMMON_FLAGS="-O2 -pipe"/COMMON_FLAGS="-march=native -O3 -pipe"/g'  /mnt/gentoo/etc/portage/make.conf

echo "config gentoo-portage"
cp /usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf
cat > /mnt/gentoo/etc/portage/repos.conf << 'EOF'
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

    cat > /mnt/gentoo/etc/portage/package.use << 'EOF'
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

configgentoo(){
	cat >> /etc/fstab << 'EOF'
/dev/zvol/rpool/SWAP    none            swap            sw                     0 0
EOF

	echo ">=sys-apps/util-linux-2.30.2 static-libs" > /etc/portage/package.use/util-linux
	echo "sys-fs/zfs" >> /etc/portage/package.accept_keywords
	echo "sys-fs/zfs-kmod" >> /etc/portage/package.accept_keywords

	echo "sys-boot/grub libzfs" > /etc/portage/package.use/grub
	emerge --sync
	etc-update
	emerge bliss-initramfs grub zfs
	bliss-initramfs -k 4.1.8-FC.01
	mv initrd-4.1.8-FC.01 /boot

    emerge os-prober
	grub-install --efi-directory=/boot/efi
	grub-mkconfig -o /boot/grub/grub.cfg

	systemctl enable zfs.target
	systemctl enable zfs-import-cache
	systemctl enable zfs-mount
	systemctl enable zfs-import.target

	rc-update add zfs-import boot
	rc-update add zfs-mount boot
	rc-update add zfs-share default
	rc-update add zfs-zed default
}

for i in "$@"; do
    case $i in
        configzfs ) configzfs;;
        configmount ) configmount;;
        configfile ) configfile;;
        configchroot ) configchroot;;
        configgentoo ) configgentoo;;
        *) echo "error";;
    esac
done

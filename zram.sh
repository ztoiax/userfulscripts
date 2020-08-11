echo "zram" > /etc/modules-load.d/zram.conf
echo "options zram num_devices=1" > /etc/modprobe.d/zram.conf
echo 'KERNEL=="zram0", ATTR{disksize}="2G",TAG+="systemd"' > /etc/udev/rules.d/99-zram.rules
echo "[Unit]\nDescription=Swap with zram\nAfter=multi-user.target\n\n[Service]\nType=oneshot \nRemainAfterExit=true\nExecStartPre=/sbin/mkswap /dev/zram0\nExecStart=/sbin/swapon /dev/zram0\nExecStop=/sbin/swapoff /dev/zram0\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/zram.service
systemctl enable zram

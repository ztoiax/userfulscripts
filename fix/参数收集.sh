#!/bin/bash
# create log file folder
test -e /var/log/ecsanalyse || mkdir /var/log/ecsanalyse;
datetime=$(date +%Y%m%d-%H-%M-%S-%N)
log_filename=ecs_analyse_${datetime}.log
log_file=/var/log/ecsanalyse/$log_filename

# script start------------
echo "##*problem_total_analyse" >> $log_file 2>&1
echo "###dos-ff" >> $log_file 2>&1
file /etc/passwd >> $log_file 2>&1
file /etc/shadow >> $log_file 2>&1
file /etc/pam.d/* >> $log_file 2>&1
echo "###limits" >> $log_file 2>&1
cat /etc/security/limits.conf | grep -Ev "^$|[#;]" >> $log_file 2>&1
echo "###virtio-net-multiqueue" >> $log_file 2>&1
for i in $(ip link | grep -E "^[0-9]+: .*:" -o | cut -d ":" -f 2 | grep -v lo); do echo $i >> $log_file 2>&1; ethtool -l $i 2>/dev/null | grep Combined >> $log_file 2>&1; done
echo "###passwd" >> $log_file 2>&1
cat /etc/passwd >> $log_file 2>&1
echo "###cpu-top-5" >> $log_file 2>&1
top -b -n 1 | grep "%Cpu(s):" >> $log_file 2>&1
ps -eT -o%cpu,pid,tid,ppid,comm | grep -v CPU | sort -n -r | head -5 >> $log_file 2>&1
echo "###ssh-perm" >> $log_file 2>&1
echo "***centos" >> $log_file 2>&1
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow /var/empty/* /etc/securetty* /etc/security/* /etc/ssh/* >> $log_file 2>&1
echo "***ubuntu" >> $log_file 2>&1
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/securetty* /etc/security/* /etc/ssh/* >> $log_file 2>&1
echo "***debian" >> $log_file 2>&1
ls -l /etc/passwd /etc/shadow /etc/group /etc/gshadow /etc/securetty* /etc/security/* /etc/ssh/* >> $log_file 2>&1
echo "###blkid" >> $log_file 2>&1
blkid >> $log_file 2>&1
echo "###osinfo" >> $log_file 2>&1
if test -f "/etc/os-release"; then
cat /etc/os-release | egrep "^NAME=|^VERSION=" >> $log_file 2>&1
else
echo "no os-release" >> $log_file 2>&1
echo "no os-release" >> $log_file 2>&1
fi
if test -f "/etc/redhat-release" ; then
echo "redhat-release:" $(cat /etc/redhat-release) >> $log_file 2>&1
else
echo "no redhat-release" >> $log_file 2>&1
fi
echo "uname: " $(uname -a) >> $log_file 2>&1
echo "uname short\: " $(uname -r) >> $log_file 2>&1
echo "###softlink" >> $log_file 2>&1
ls -l / | grep "\->" >> $log_file 2>&1
echo "###iptables" >> $log_file 2>&1
echo "***centos-5" >> $log_file 2>&1
service iptables status >> $log_file 2>&1
echo "***centos-6" >> $log_file 2>&1
service iptables status >> $log_file 2>&1
echo "***centos-7" >> $log_file 2>&1
firewall-cmd --state >> $log_file 2>&1
echo "***ubuntu" >> $log_file 2>&1
ufw status >> $log_file 2>&1
echo "***default" >> $log_file 2>&1
iptables -L >> $log_file 2>&1
echo "###sysctl" >> $log_file 2>&1
cat /etc/sysctl.conf | grep nr_hugepages >> $log_file 2>&1
echo -e "net.ipv4.tcp_tw_recycle=\c" >> $log_file 2>&1 && cat /proc/sys/net/ipv4/tcp_tw_recycle >> $log_file 2>&1
echo -e "net.ipv4.tcp_timestamps=\c" >> $log_file 2>&1 && cat /proc/sys/net/ipv4/tcp_timestamps >> $log_file 2>&1
echo -e "fs.nr_open=\c" >> $log_file 2>&1 && cat /proc/sys/fs/nr_open >> $log_file 2>&1
echo -e "net.ipv4.tcp_sack=\c" >> $log_file 2>&1 && cat /proc/sys/net/ipv4/tcp_sack >> $log_file 2>&1
echo "###fstab" >> $log_file 2>&1
cat /etc/fstab | grep -Ev "^$|[#;]" >> $log_file 2>&1
echo "###dmesg" >> $log_file 2>&1
cat /proc/uptime >> $log_file 2>&1
dmesg | grep "invoked oom-killer" | tail -n 1 >> $log_file 2>&1
echo "###port-usage" >> $log_file 2>&1
netstat -tapn | grep LISTEN | grep -E 'sshd' >> $log_file 2>&1
echo "###selinux" >> $log_file 2>&1
echo "***default" >> $log_file 2>&1
getenforce >> $log_file 2>&1
echo "***ubuntu" >> $log_file 2>&1
service selinux status > /dev/null; echo $? >> $log_file 2>&1
echo "***debian" >> $log_file 2>&1
service selinux status > /dev/null; echo $? >> $log_file 2>&1
echo "###meminfo" >> $log_file 2>&1
cat /proc/meminfo | grep Hugepagesize >> $log_file 2>&1
cat /proc/meminfo | grep MemTotal >> $log_file 2>&1
# script end------------

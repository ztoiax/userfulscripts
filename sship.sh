#!/bin/bash
# 类似于fail2ban
# 将超过10次连接ssh失败的ip,写入/etc/hosts.deny屏蔽掉

date >> /var/log/ipblack.list

# 统计所有连接ssh failed的ip 写入/var/log/ipblack.list
awk '/Failed/{print $(NF-5)}' /var/log/secure | sort | uniq -c | awk '{ print $2"="$1}' >> /var/log/ipblack.list

for i in $(cat /var/log/ipblack.list);do
    ip=$(echo $i | awk -F "=" '{ print $1}')
    declare -i num=$(echo $i | awk -F "=" '{ print $2}')
    if [ $num -gt 10 ];then
        grep $ip /etc/host.deny > /dev/null
        if [ $? -ne 0 ];then
            echo "sshd:"$ip":deny" >> /etc/host.deny
        fi
    fi
done
echo "已写入/etc/host.deny"

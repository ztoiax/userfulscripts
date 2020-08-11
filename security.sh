#!/bin/bash
#先解析域名ip以防止ip欺骗
echo "nospoof on" >> /etc/host.conf

# 以下输出有成功，表示支持tcp wrapper，程序连接时会按顺序检查以下文件
# /etc/hosts.deny
# /etc/hosts.allow
ldd $(which sshd) | grep -i wrap.so
strings $(which sshd) | grep "hosts_access"

# 查看打开当前目录文件的进程
fuser -vm .

# 监控用户行为
psacct

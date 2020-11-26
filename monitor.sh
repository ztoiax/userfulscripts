#!/bin/bash
#cpu
slabtop

#io
iostat
iotop
fio

# process
ps aux
# 查看线程
ps -T -p <pid>
top -H -p <pid>

#第三方
#综合
stacer #qt-app
sysstat
dstat #结合了vmstat，iostat，ifstat，netstat以及更多的信息
phoronix
atop
htop
gtop
bashtop

#cpu
s-tui
sensors #温度

#io
ncdu
iozone
hddtemp #sata硬盘温度
nvme-cli #可nvme温度等

#net https://linux.cn/article-5461-weixin.html
traceroute #追踪
tcptraceroute #追踪
tcpdump
ntop # 网页版流量监控，port:3000
ntopng # 下一代ntop. https://linux.cn/article-5664-weixin.html
mtr #（即“My Traceroute”的缩写）继承了强大的traceroute功能，并集成了 ping 的功能
prettyping
iperf
netperf
bmon
pktstat

#gui
#cpu
psenstor #温度
#disk
gnome-disk-utility
duf

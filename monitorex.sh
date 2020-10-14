#进程
ps -aux
#查看线程
ps -eLf
#统计socket
ll /proc/$pid/task/*/fd/ |grep socket |wc -l
#统计fd
ll /proc/$pid/task/*/fd/ | wc -l

#NIC
#查看队列个数
ethtool -l eth0 | grep Combined

#查看中断号对应的cpu处理
for i in {0..100}; do cat /proc/irq/$i/smp_affinity_list 2> /dev/null; done

#MEM
#释放缓存
sync && echo 2 > /proc/sys/vm/drop_caches
#IO
#每隔 3 秒采集一次磁盘 io,输出时间,一共采集 30 次
iostat -d 3 -k -x -t 30
#每隔 3 秒采集一次进程io,一共采集 30 次
sudo iotop -b -o -d 3 -t -qqq -n 30
sudo iotop -b -o -d 1 -qqq |awk '{ print $0"\t" strftime("%Y-%m-%d-%H:%M:%S",systime()) } '
#硬盘温度
sudo hddtemp SATA:/dev/sda
sudo nvme smart-log /dev/nvme0 | grep temperature
#IO性能测试
fio -direct=1 -iodepth=128 -rw=randwrite -ioengine=libaio -bs=1k -size=1G -numjobs=1 -runtime=1000 -group_reporting -filename=iotest -name=Rand_

#FILE
#追踪ifup eth0命令打开的文件
strace -f -e open ifup eth0

#NET
#查看服务端口
cat /etc/services
#找出来哪个 pid 的 socket 比较多,对/proc/pid/fd 目录做批量扫描
for d in /proc/[0-9]*;do pid=$(basename $d);s=$(ls -l $d/fd | egrep -i socket | wc -l 2>/dev/null); [ -n "$s" ] && echo "$s $pid";done | sort -n |
tail -20
#
sudo netstat -tunlp
#扫描网段
nmap -sL 192.168.1.0/24
#查看端口
nmap -sC 192.168.1.1 -p 80

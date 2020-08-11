#!/bin/bash
## CPU
us=$(vmstat |awk 'NR==3 {print $13}')
sy=$(vmstat |awk 'NR==3 {print $14}')
use=$(($us+$sy))
idle=$(vmstat |awk 'NR==3 {print $15}')
wait=$(vmstat |awk 'NR==3 {print $16}')
cs=$(vmstat |awk 'NR==3 {print $12}')
in=$(vmstat |awk 'NR==3 {print $11}')

    echo "
    CPU:
    用户时间:       $us
    内核时间:       $sy
    所有时间:       $use
    空闲时间:       $idle
    等待io时间:     $wait
    每秒中断次数:   $in
    每秒上下文切换: $cs"

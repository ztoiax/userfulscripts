#!/bin/bash
#Benchmark
#https://openbenchmarking.org/

phoronix(){
if ! type phoronix-test-suite; then
    echo "phoronix没有安装"
    ./install2.sh phoronix
    return 1
fi

name[1]="phoronix-test-suite benchmark smallpt #cpu测试"
name[2]="phoronix-test-suite benchmark ramspeed #内存测试"
name[3]="phoronix-test-suite benchmark apache #Apache测试"
name[4]="phoronix-test-suite benchmark tiobench #io测试"
lengh=${#name[*]}
lengh2="[1-${#name[*]}]"
for ((i=1;i<=lengh;i++));do
    echo "[$i] ${name[$i]}"
done
read -p "请输入测试编号: " n
if [[ $n =~ $lengh2 ]];then
    ${name[$n]}
fi
}
#netperf


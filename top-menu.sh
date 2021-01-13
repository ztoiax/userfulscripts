#!/bin/bash
name[1]="htop"
name[2]="glances"
name[3]="bpytop"
name[4]="nvtop"
name[5]="iotop"
name[6]="iftop"
name[7]="speedometer"
name[8]="bmon"
name[9]="pidstat"
name[10]="dstat"
name[11]="mpstat"
name[12]="nmon"
name[12]="s-tui"

lengh=${#name[*]}

for ((i=1; i<=$lengh; i=i+1));do
    echo -e "${name[$i]}"
done

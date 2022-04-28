#!/bin/bash
name[1]="htop"
name[2]="glances"
name[3]="btop"
name[4]="bpytop"
name[5]="nvtop"
name[6]="iotop"
name[7]="iftop"
name[8]="speedometer"
name[9]="bmon"
name[10]="pidstat"
name[11]="dstat"
name[12]="mpstat"
name[13]="nmon"
name[13]="s-tui"
name[14]="tiptop"

lengh=${#name[*]}

for ((i=1; i<=$lengh; i=i+1));do
    echo -e "${name[$i]}"
done

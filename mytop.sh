#!/bin/bash
select=$(top-menu.sh | fzf)

case "$select" in
    pidstat)
        process= ps aux | awk '{print $NF}' | fzf
        pidstat --human -udrw -C $(pgrep -of $processname) 1
        ;;

    mpstat) mpstat -P ALL 1;;
    dstat) dstat --vmstat;;
    speedometer) speedometer -rx enp27s0;;
    $select) $select;;
    *) echo "error";;
esac

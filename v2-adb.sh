#!/bin/bash
systemctl is-active --quiet v2ray.service && sudo systemctl stop v2ray

# 在android 里启动启动端口
# setprop service.adb.tcp.port 5555
# stop adbd
# start adbd

function usb(){
    adb devices
    sleep 1
    adb forward tcp:10808 tcp:10808
}

function wifi(){
    adb -s 192.168.1.111:5555 connect 192.168.1.111:5555
    sleep 1
    adb -s 192.168.1.111:5555 forward tcp:10808 tcp:10808
}

case $1 in
    wifi ) wifi;;
    * ) usb;;
esac

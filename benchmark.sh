#!/bin/bash

all-have(){
    $install sysdig
    sudo sysdig-probe-loader

    $install perf-tool
}

process(){
    $install htop bashtop glance
}

file(){
   $install inotify-tools
}

net(){
    $install speedometer
    $install gping
    $install termshark
}

gpu(){
    $install gmonitor-git
}

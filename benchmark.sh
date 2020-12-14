#!/bin/bash
pg=~/Downloads/Programs

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
    $install wireshark
}
blktrace(){
    $install blktrace
    # install seekwatcher
    # generates graphs from blktrace
    git clone https://github.com/tnm/seekwatcher.git $pg/seekwatcher
    cd $pg/seekwatcher
    python3 setup.py install
}

disk(){
    $install ncdu
}
gpu(){
    $install gmonitor-git
}

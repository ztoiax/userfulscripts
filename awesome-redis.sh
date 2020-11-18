#!/bin/bash

# redis-rdb-tools
# https://github.com/sripathikrishnan/redis-rdb-tools
rdb(){
    pip install rdbtools python-lzf
    cd ~
    git clone https://github.com/sripathikrishnan/redis-rdb-tools
    cd redis-rdb-tools
    sudo python setup.py install
}

# redis-memory-analyzer
rma(){
    pip3 install rma
}

# AnotherRedisDesktopManager
redis-gui(){
    wget https://gitee.com/qishibo/AnotherRedisDesktopManager/attach_files/471373/download/Another-Redis-Desktop-Manager.1.3.8.AppImage
}

# iredis
iredis(){
    pip3 install iredis
}

redis-shake(){
    curl -LO https://github.com/alibaba/RedisShake/releases/download/release-v2.0.3-20200724/redis-shake-v2.0.3.tar.gz
    tar xvzf redis-shake-v2.0.3.tar.gz
    cd redis-shake-v2.0.3
    # ./start.sh redis-shake.conf sync
}

rdb
rma
redis-gui
iredis
redis-shake

#!/bin/bash
#CONFIG_HZ 是 Linux 内核中的一个重要参数，决定了 CPU 主频的切换间隔，数值固定为 100、300 不等，越大则切换间隔越短,这个数值改为 300 可以将间隔从 10ms 降低为 3.33ms
cat /boot/config-* | grep HZ

grep "Out of memory" /var/log/*

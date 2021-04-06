#!/bin/python3
import psutil
import subprocess
import time
import nvidia_smi
from datetime import datetime

def disk_available(p):
    return format(psutil.disk_usage(p)[2] / 1024 / 1024 / 1024, '.2f')

def network(old, interface = 'enp27s0'):
    new = psutil.net_io_counters(pernic=True)[interface]
    sent = (new[0] - old[0]) / 1024 // 8
    recv = (new[1] - old[1]) / 1024 // 8
    return (sent, recv)

def diskio(old):
    new = psutil.disk_io_counters()
    rc = new[0] - old[0]
    wc = new[1] - old[1]
    rb = (new[2] - old[2]) / 1024 // 8
    wb = (new[3] - old[3]) / 1024 // 8
    return (rc, wc, rb, wb)

def Gpu():
    nvidia_smi.nvmlInit()
    handle = nvidia_smi.nvmlDeviceGetHandleByIndex(0)
    r = nvidia_smi.nvmlDeviceGetUtilizationRates(handle)
    return r

def sound():
    p = subprocess.check_output('amixer get Master', shell=True)
    return p.split()[-3].decode().strip('[]')

if __name__ == '__main__':
    interface = 'enp27s0'
    old_net = psutil.net_io_counters(pernic=True)[interface]
    old_io = psutil.disk_io_counters()

    while True:
        net = network(old_net)
        io = diskio(old_io)
        gpu = Gpu()
        # psutil.sensors_temperatures()

        arg = f' {psutil.cpu_percent(1)}%  {gpu.gpu}%  {psutil.virtual_memory()[2]}% {gpu.memory}% ﰬ {net[1]}KB/s ﰵ {net[0]}KB/s  R {io[0]} {io[2]}KB/s W {io[1]} {io[3]}KB/s {disk_available("/")}G {disk_available("/home/tz")}G  {sound()}  {datetime.now().strftime("%Y/%m/%d %H:%M")}'

        subprocess.call(['xsetroot', '-name', f'{arg}'])
        time.sleep(1)

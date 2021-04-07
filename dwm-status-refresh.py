#!/bin/python3
import psutil
import subprocess
import time
import nvidia_smi
import datetime
import asyncio
from threading import Thread


def disk_available(p):
    return format(psutil.disk_usage(p)[2] / 1024 / 1024 / 1024, '.2f')


def Gpu():
    nvidia_smi.nvmlInit()
    handle = nvidia_smi.nvmlDeviceGetHandleByIndex(0)
    r = nvidia_smi.nvmlDeviceGetUtilizationRates(handle)
    return r


def sound():
    p = subprocess.check_output('amixer get Master', shell=True)
    return p.split()[-3].decode().strip('[]')


class next(object):
    def __init__(self, func):
        self.func = func
        self.next = eval(self.func)

    def next_to_last(self):
        self.last = self.next
        self.next = eval(self.func)

    def net(self):
        self.next_to_last()
        self.sent = (self.next[0] - self.last[0]) / 1024 // 8
        self.recv = (self.next[1] - self.last[1]) / 1024 // 8
        return (self.sent, self.recv)

    def io(self):
        self.next_to_last()
        self.rc = self.next[0] - self.last[0]
        self.wc = self.next[1] - self.last[1]
        self.rb = (self.next[2] - self.last[2]) / 1024 // 8
        self.wb = (self.next[3] - self.last[3]) / 1024 // 8
        return (self.rc, self.wc, self.rb, self.wb)


def one_minute():
    while True:
        global time_global
        time_global = datetime.datetime.now().strftime("%Y/%m/%d %H:%M")
        time.sleep(60)


def one_second():
    while True:
        net = net_class.net()
        io = io_class.io()
        gpu = Gpu()
        # psutil.sensors_temperatures()

        arg = f' {psutil.cpu_percent(1)}%  {gpu.gpu}%  {psutil.virtual_memory()[2]}% {gpu.memory}% ﰬ {net[1]}KB/s ﰵ {net[0]}KB/s  R {io[0]} {io[2]}KB/s W {io[1]} {io[3]}KB/s {disk_available("/")}G {disk_available("/home/tz")}G  {sound()}  {time_global}'

        subprocess.call(['xsetroot', '-name', f'{arg}'])
        time.sleep(1)

if __name__ == '__main__':
    interface = 'enp27s0'
    net_class = next('psutil.net_io_counters(pernic=True)[interface]')
    io_class = next('psutil.disk_io_counters()')
    one_second()
    one_minute_thread = Thread(target=one_minute)
    one_minute_thread.start()

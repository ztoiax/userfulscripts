#!/bin/python3
import psutil
import subprocess
import time
import pynvml as N
import datetime
import asyncio
from threading import Thread


def bytes2human(n):
    # http://code.activestate.com/recipes/578019
    # >>> bytes2human(10000)
    # '9.8K'
    # >>> bytes2human(100001221)
    # '95.4M'
    symbols = ('K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y')
    prefix = {}
    for i, s in enumerate(symbols):
        prefix[s] = 1 << (i + 1) * 10
    for s in reversed(symbols):
        if n >= prefix[s]:
            value = float(n) / prefix[s]
            return '%.1f%s' % (value, s)
    return "%sB" % n


def disk_available(p):
    return format(bytes2human(psutil.disk_usage(p)[2]))


def Gpu():
    import pynvml as N
    N.nvmlInit()
    handle = N.nvmlDeviceGetHandleByIndex(0)
    utilization = N.nvmlDeviceGetUtilizationRates(handle)
    mem = N.nvmlDeviceGetMemoryInfo(handle)
    temperature = N.nvmlDeviceGetTemperature(
        handle, N.NVML_TEMPERATURE_GPU
    )
    N.nvmlShutdown()
    return (utilization.gpu, temperature, format(mem.used / mem.total, '.1%'))


def sound():
    p = subprocess.check_output('amixer get Master', shell=True)
    return p.split()[-3].decode().strip('[]%')


class next(object):
    def __init__(self, func):
        self.func = func
        self.next = eval(self.func)

    def next_to_last(self):
        self.last = self.next
        self.next = eval(self.func)

    def net(self):
        self.next_to_last()
        self.sent = bytes2human(self.next[0] - self.last[0])
        self.recv = bytes2human(self.next[1] - self.last[1])
        return (self.sent, self.recv)

    def io(self):
        self.next_to_last()
        self.rc = self.next[0] - self.last[0]
        self.wc = self.next[1] - self.last[1]
        self.rb = bytes2human(self.next[2] - self.last[2])
        self.wb = bytes2human(self.next[3] - self.last[3])
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

        arg = f' {psutil.cpu_percent(1)}%  {gpu[0]}% {gpu[1]}°C  {psutil.virtual_memory()[2]}% {gpu[2]} ﰬ {net[1]}/s ﰵ {net[0]}/s  R {io[0]} {io[2]} W {io[1]} {io[3]} {disk_available("/")} {disk_available("/home/tz")}  {sound()}  {time_global}'

        subprocess.call(['xsetroot', '-name', f'{arg}'])
        time.sleep(1)


if __name__ == '__main__':
    interface = 'enp27s0'
    net_class = next('psutil.net_io_counters(pernic=True)[interface]')
    io_class = next('psutil.disk_io_counters()')
    one_minute_thread = Thread(target=one_minute)
    one_minute_thread.start()
    one_second()

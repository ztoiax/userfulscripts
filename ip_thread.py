#!/bin/python3
'''
扫描端口: -n

指定ip:
ip_thread 192.168.1.1 192.168.1.111
ip_thread -n 192.168.1.1 192.168.1.111

指定文件内的ip:
ip_thread.py $(cat ip_file)

指定网段:
ip_thread 192.168.1.0/24 192.168.2.0/24
'''
import os
import subprocess
import threading
from queue import Queue
from queue import Empty
from IPy import IP
from telnetlib import Telnet

def call_ping(ip):
    if subprocess.call(f'ping -c 1 -W 1 {ip}', shell=True, stdout=subprocess.PIPE):
        print(f'{ip} fail')
        pass
    else:
        print(f'{ip} success')

def call_nmap(ip):
    for port in range(1, 65535):
        try:
            if Telnet(str(ip), port, timeout=1):
               print(f'{ip}:{port}  success')
        except ConnectionRefusedError:
            # print(f'{port}  fail')
            pass

def pool_thread(q):
    try:
        while True:
            ip = q.get_nowait()
            eval(call_func)
    except Empty:
        pass

if __name__ == "__main__":
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option('-n', '--nmap', action='store_true',
                      help="nmap mode")
    args, positional = parser.parse_args()

    q = Queue()
    global call_func

    if args.nmap:
        call_func = 'call_nmap(ip)'
    else:
        call_func = 'call_ping(ip)'

    for i in positional:
        ip = IP(i)
        for j in ip:
            q.put(j)

    threads = []
    cpus = os.cpu_count() - 1
    for i in range(cpus):
        thr = threading.Thread(target=pool_thread, args=(q,))
        thr.start()
        threads.append(thr)

    for i in threads:
        i.join()

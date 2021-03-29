#!/bin/python3
import re
import sys
import subprocess
import dmenu

# 导入数据
from dmenu-searchdata import *

class search(object):
    def __init__(self):
        self.menu = 'dmenu'
        self.category_list = ['sousuo', 'xueshu', 'social', 'waiguosocial', 'video', 'shop', 'linux', 'network']
        self.engine_list()
        self.clip()


    def clip(self):
        # 判断剪切板是否为url,如果是则直接打开
        cmd = 'xclip -selection clipboard -o'
        self.clip = subprocess.check_output(cmd, shell=True, universal_newlines=True)
        if re.search(r'^http.*', self.clip):
            self.engine = self.clip
            subprocess.call(f'xdg-open {self.engine}', shell=True)
        else:
            self.engine = ''


    def input(self):
        self.input = dmenu.show(['input'])
        if self.input == '':
            self.input = self.clip


    def select(self):
        self.engine = dmenu.show(lines=15, items=self.engine_list)
        self.input()
        def url():
            for value in engine.values():
                for key in value:
                    if self.engine == key:
                        self.url = value[self.engine]
        url()
        subprocess.call(f'xdg-open {self.url}{self.input}', shell=True)


    def engine_list(self):
        self.engine_list = []
        for value in engine.values():
            for i in value.keys():
                self.engine_list = self.engine_list + [i]


    def category(self):
        self.category = dmenu.show(lines=15, items=self.category_list)
        self.engine = dmenu.show(lines = 15, items=engine[self.category].keys())
        self.url = engine[self.category][self.engine]
        self.input()
        subprocess.call(f'xdg-open {self.url}{self.input}', shell=True)


if __name__ == "__main__":
    instance = search()

    if len(sys.argv) == 1:
        instance.select()
    else:
        if sys.argv[1] == '-l':
            instance.category()

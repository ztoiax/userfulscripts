#!/bin/python3
import re
import sys
import subprocess
import dmenu
import iterfzf


class search(object):
    def __init__(self):
        self.clip()
        self.menu = 'dmenu'
        self.engine = ''

    def clip(self):
        cmd = 'xclip -selection clipboard -o'
        self.clip = subprocess.check_output(cmd, shell=True, universal_newlines=True)

    def cmd(self, text):
        if 'dmenu' == self.menu:
            r = dmenu.show(lines=15, items=text)
        elif 'fzf' == self.menu:
            r = iterfzf.iterfzf(text)
        return r

    def input(self):
        if 'dmenu' == self.menu:
            self.input = dmenu.show(prompt='input', items=['input'])
        elif 'fzf' == self.menu:
            self.input = input('input: ')

        if 'input' == self.input:
            self.input = self.clip

    def select(self):
        # 判断剪切板是否为url,如果是则放在首选项
        if re.search(r'^http.*', self.clip):
            self.engine_list.insert(0, self.clip)

        self.engine = self.cmd(self.engine_list)

        # 如果选择了剪切板的url,则直接打开
        if self.engine == self.clip:
            subprocess.call(['xdg-open', f'{self.engine}'])
            exit(0)

        self.input()
        # 获取引擎url
        def url():
            for value in engine.values():
                for key in value:
                    if self.engine == key:
                        self.url = value[self.engine]
        url()
        subprocess.call(['xdg-open', f'{self.url}{self.input}'])

    def file_load(self):
        self.engine_list = []
        for value in engine.values():
            for i in value.keys():
                self.engine_list = self.engine_list + [i]

    def category(self):
        self.category_list = engine.keys()
        self.category = self.cmd(self.category_list)
        self.engine = self.cmd(engine[self.category].keys())
        self.url = engine[self.category][self.engine]
        self.input()
        subprocess.call(['xdg-open', f'{self.url}{self.input}'])

    def redis_store(self):
        import redis
        r = redis.Redis()

        # list, hash store
        for i, v in engine.items():
            r.hset('engine', i, i)
            for k in engine[i]:
                r.hset(i, k, v[k])

    def redis_load(self):
        import redis
        r = redis.Redis()

        redis_engine = r.hgetall('engine')
        global engine
        engine = {}
        self.engine_list = []
        for category in redis_engine:
            ca = r.hgetall(category)
            # binary转换utf
            def dcode(ca):
                kv = {}
                for i, v in ca.items():
                    kv[i.decode()] = v.decode()
                return kv
            ca = dcode(ca)
            # 设置category
            exec(f"{category.decode()} = {ca}")
            # 设置engine
            engine[category.decode()] = ca
            # 设置self.engine_list
            for k, v in r.hgetall(category).items():
                self.engine_list = self.engine_list + [k.decode()]


if __name__ == "__main__":
    instance = search()

    for i in sys.argv:
        if 'file' == i:
            from searchdata import *
            instance.file_load()
        elif 'redis' == i:
            instance.redis_load()
        elif '-l' == i:
            category=True

    if ['file', 'redis'] not in sys.argv:
        from searchdata import *
        instance.file_load()

    if 'category' in locals():
        instance.category()
    else:
        instance.select()

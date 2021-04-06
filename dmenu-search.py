#!/bin/python3
import re
import sys
import subprocess
import dmenu
from threading import Thread


class search(object):
    def __init__(self):
        self.clip = ''
        self.menu = 'dmenu'
        self.engine = ''
        self.url = None
        self.input = ''

    def clipboard(self):
        cmd = 'xclip -selection clipboard -o'
        self.clip = subprocess.check_output(cmd, shell=True, universal_newlines=True)

    def cmd(self, text):
        if 'dmenu' == self.menu:
            r = dmenu.show(lines=15, items=text)
        elif 'fzf' == self.menu:
            r = iterfzf.iterfzf(text)
        return r

    def input_text(self):
        if 'dmenu' == self.menu:
            self.input = dmenu.show(prompt='input', items=['input'])
        elif 'fzf' == self.menu:
            self.input = input('input: ')

        if 'input' == self.input:
            self.input = self.clip

    def select(self):
        clip_thread.join()
        if re.search(r'^http.*', self.clip):
            # 判断剪切板是否为url,如果是则放在首选项
            self.engine_list.insert(0, self.clip)

        if self.url == None:
            # 测试模式
            load_thread.join()
            self.engine = self.cmd(self.engine_list)

            if self.engine == self.clip:
                # 如果选择了剪切板的url,则直接打开
                subprocess.call(['xdg-open', f'{self.engine}'])
                exit(0)

            self.input_text()
            def url():
                # 获取引擎url
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
        load_thread.join()
        self.category_list = engine.keys()

        if self.url == None:
            # 测试模式
            self.category = self.cmd(self.category_list)
            self.engine = self.cmd(engine[self.category].keys())
            self.url = engine[self.category][self.engine]
            self.input_text()

        subprocess.call(['xdg-open', f'{self.url}{self.input}'])

    def redis_store(self):
        import redis
        r = redis.Redis()

        # list, hash store
        for category, v in engine.items():
            r.hset('engine', category, category)
            for k in engine[category]:
                r.hset(category, k, v[k])

    def redis_load(self):
        import redis
        r = redis.Redis()

        try:
            redis_engine = r.hgetall('engine')
        except:
            print('redis_load() false,turn to sqlite_load()')
            self.sqlite_load()
            return 1

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

    def sqlite_store(self):
        import sqlite3
        import pathlib
        filepath = pathlib.Path(__file__).parent.absolute()
        con = sqlite3.connect(f'{filepath}/search.db')
        cur = con.cursor()

        cur.execute('CREATE TABLE IF NOT EXISTS engine (key)')
        for table in engine:
            cur.execute(f"INSERT INTO engine (key) VALUES('{table}')")
            cur.execute(f"CREATE TABLE IF NOT EXISTS {table} (key, value)")

        for table, context in engine.items():
            for k, v in context.items():
                cur.execute(f"INSERT INTO {table} (key, value) VALUES('{k}', '{v}')")

        con.commit()
        con.close()

    def sqlite_load(self):
        import sqlite3
        import pathlib
        filepath = pathlib.Path(__file__).parent.absolute()
        con = sqlite3.connect(f'{filepath}/search.db')
        cur = con.cursor()
        engine = {}

        try:
            category = cur.execute('SELECT * FROM engine')
        except:
            # 无法from
            # print('sqlite_load() false,turn to file_load()')
            # from searchdata import *
            # self.file_load()
            return 1

        # 如果for i in category, 到第二次循环.i就变成了空值,跳出循环
        ca = []
        for i in category:
            ca.append(i[0])

        for i in ca:
            table_name = i
            table = cur.execute(f'SELECT * FROM {table_name}')

            kv = {}
            for ii in table:
                kv.update(dict([ii]))

            exec(f'{table_name} = {kv}')
            engine.update({table_name: kv})

        con.close()

    def test(self):
        self.url = engine['search']['Baidu']
        self.input = 'test'


if __name__ == "__main__":
    instance = search()
    clip_thread = Thread(target=instance.clipboard)
    clip_thread.start()

    for i in sys.argv:
        if '-h' == i:
            print('''
          2种选择模式:
          dmenu-search.py
          dmenu-search.py -l

          3种数据加载模式:
          dmenu-search.py file
          dmenu-search.py redis
          dmenu-search.py sqlite

          menu:
          dmenu-search.py fzf

          测试:
          dmenu-serach.py -t

          以上可以组合使用:
          dmenu-search.py -l redis fzf''')
            exit(0)
        elif 'file' == i:
            from searchdata import *
            load_thread = Thread(target=instance.file_load)
            load_thread.start()
        elif 'redis' == i:
            load_thread = Thread(target=instance.redis_load)
            load_thread.start()
            # instance.redis_load()
        elif 'sqlite' == i:
            load_thread = Thread(target=instance.sqlite_load)
            load_thread.start()
        elif '-l' == i:
            category=True
        elif '-t' == i:
            test=True
        elif 'fzf' == i:
            import iterfzf
            instance.menu = i

    if ['file', 'redis', 'sqlite'] not in sys.argv:
        from searchdata import *
        load_thread = Thread(target=instance.file_load)
        load_thread.start()

    if 'test' in locals():
        instance.test()

    if 'category' in locals():
        instance.category()
    else:
        instance.select()

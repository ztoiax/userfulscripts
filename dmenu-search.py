#!/bin/python3
import re
import sys
import subprocess
import dmenu
from threading import Thread


def dcode(ca):
    # binary转换utf
    kv = {}
    for i, v in ca.items():
        kv[i.decode()] = v.decode()
    return kv


class search(object):
    def __init__(self):
        self.clip = ''
        self.menu = 'dmenu'
        self.engine = ''
        self.url = None
        self.input = ''

    def clipboard(self):
        cmd = 'xclip -selection clipboard -o'
        tmp = subprocess.check_output(cmd, shell=True, universal_newlines=True)
        self.clip = tmp.strip()

    def cmd(self, text):
        if 'dmenu' == self.menu:
            r = dmenu.show(lines=15, items=text)
        elif 'fzf' == self.menu:
            r = iterfzf.iterfzf(text)
        return r

    def input_text(self):
        if 'dmenu' == self.menu:
            self.input = dmenu.show(prompt='input', lines=15, items=self.history)
        elif 'fzf' == self.menu:
            self.input = iterfzf.iterfzf(self.history)

        if self.input is None:
            exit(1)
        else:
            history_thread = Thread(target=self.history_input)
            history_thread.start()

    def redis_output(self):
        import redis
        r = redis.Redis()
        try:
            history = r.hgetall('history')
        except redis.exceptions.ConnectionError:
            self.history = [self.clip]
            return 1
        history = dcode(history)
        # sort
        history1 = sorted(history, key=history.get, reverse=True)
        self.history = [self.clip]
        self.history.extend([k for k in history1])

    def redis_input(self):
        import redis
        r = redis.Redis()
        try:
            r.client()
        except redis.exceptions.ConnectionError:
            r.close()
            return 1

        if self.input in self.history:
            r.hincrby('history', f'{self.input}', 1)
        else:
            r.hset('history', f'{self.input}', 1)

    def sqlite_output(self):
        import sqlite3
        import pathlib
        filepath = pathlib.Path(__file__).parent.absolute()
        con = sqlite3.connect(f'{filepath}/history.db')
        cur = con.cursor()
        try:
            history_tuple = cur.execute("SELECT * FROM history")
        except sqlite3.OperationalError:
            con.commit()
            con.close()
            self.history = [self.clip]
            return 1

        # tuple convert to dict
        history = {}
        for i in history_tuple:
            history.update({i[0]: i[1]})
        # sort
        history1 = sorted(history, key=history.get, reverse=True)
        self.history = [self.clip]
        self.history.extend([k for k in history1])
        con.commit()
        con.close()

    def sqlite_input(self):
        import sqlite3
        import pathlib
        filepath = pathlib.Path(__file__).parent.absolute()
        con = sqlite3.connect(f'{filepath}/history.db')
        cur = con.cursor()
        cur.execute('CREATE TABLE IF NOT EXISTS history (input, count)')
        history_tuple = cur.execute(f"SELECT * FROM history WHERE input='{self.input}'")
        return_code = history_tuple.fetchall()
        if return_code == []:
            cur.execute(f"INSERT INTO history (input, count) VALUES('{self.input}', 1)")
        else:
            count = return_code[0][1] + 1
            cur.execute(f"UPDATE history SET count={count} WHERE input='{self.input}'")

        con.commit()
        con.close()

    def select(self):
        clip_thread.join()
        if re.search(r'^http.*', self.clip):
            # 判断剪切板是否为url,如果是则放在首选项
            self.engine_list.insert(0, self.clip)

        if self.url is None:
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

        if self.url is None:
            # 测试模式
            self.category = self.cmd(self.category_list)
            self.engine = self.cmd(engine[self.category].keys())
            self.url = engine[self.category][self.engine]
            self.input_text()

        subprocess.call(['xdg-open', f'{self.url}{self.input}'])

    def redis_store(self):
        import redis
        r = redis.Redis()
        try:
            r.client()
        except redis.exceptions.ConnectionError:
            r.close()
            return 1
        # list, hash store
        for category, v in engine.items():
            r.hset('engine', category, category)
            for k in engine[category]:
                r.hset(category, k, v[k])

        r.close()

    def redis_load(self):
        import redis
        r = redis.Redis()

        try:
            redis_engine = r.hgetall('engine')
        except redis.exceptions.ConnectionError:
            print('redis_load() false,turn to sqlite_load()')
            r.close()
            self.sqlite_load()
            self.history_output = self.sqlite_output
            history_thread = Thread(target=self.history_output)
            history_thread.start()
            return 1

        global engine
        engine = {}
        self.engine_list = []
        for category in redis_engine:
            ca = r.hgetall(category)
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
        global engine
        engine = {}

        try:
            category = cur.execute('SELECT * FROM engine')
        except sqlite3.OperationalError:
            print('sqlite_load() false,turn to file_load() and exec sqlite_store()')
            import searchdata
            engine = searchdata.engine
            self.file_load()
            self.sqlite_store()
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

        self.file_load()
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
        elif 'redis' == i:
            store = i
        elif 'sqlite' == i:
            store = i
        elif '-l' == i:
            category = True
        elif '-t' == i:
            test = True
        elif 'fzf' == i:
            import iterfzf
            instance.menu = i

    if 'store' in locals():
        if store == 'redis':
            instance.history_input = instance.redis_input
            instance.history_output = instance.redis_output
            load_thread = Thread(target=instance.redis_load)
        elif store == 'sqlite':
            instance.history_input = instance.sqlite_input
            instance.history_output = instance.sqlite_output
            load_thread = Thread(target=instance.sqlite_load)
    else:
        import searchdata
        engine = searchdata.engine
        instance.history_input = instance.redis_input
        instance.history_output = instance.redis_output
        load_thread = Thread(target=instance.file_load)

    history_thread = Thread(target=instance.history_output)
    history_thread.start()
    load_thread.start()

    if 'test' in locals():
        instance.test()

    if 'category' in locals():
        instance.category()
    else:
        instance.select()

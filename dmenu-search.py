#!/bin/python3
import re
import sys
import subprocess
import dmenu
import pathlib
import json
import webbrowser
import logging
from threading import Thread


def get(func):
    for category_key, category_v in engine.items():
        for key, value in category_v.items():
            func(key, value, category_key)


def json_load():
    global engine
    with open(f'{filepath}/search.json', 'r') as f:
        engine = json.load(f)


def dcode(ca):
    # binary转换utf
    kv = {}
    for i, v in ca.items():
        kv[i.decode()] = v.decode()
    return kv


def redis_operation(cmd):
    import redis
    r = redis.Redis()
    try:
        eval(cmd)
    except redis.exceptions.ConnectionError:
        logging.warning('error: ' + cmd)
        r.close()
        return 1
    r.close()


def sqlite_operation(cmd):
    import sqlite3
    con = sqlite3.connect(f'{filepath}/search.db')
    cur = con.cursor()
    cur.execute(cmd)
    con.commit()
    con.close()


class search(object):
    def __init__(self):
        self.clip = ''
        self.menu = 'dmenu'
        self.engine = ''
        self.url = None
        self.input = ''
        self.engine_list = []

    def clipboard(self):
        cmd = 'xclip -selection clipboard -o'
        try:
            output = subprocess.check_output(cmd, shell=True, universal_newlines=True)
        except:
            pass
        else:
            self.clip = output.strip()

    def cmd(self, text):
        if 'dmenu' == self.menu:
            r = dmenu.show(lines=15, items=text)
        elif 'fzf' == self.menu:
            r = iterfzf.iterfzf(text)
        elif 'normal' == self.menu:
            for i in text:
                print(i)
            r = input('input: ')
        return r

    def input_text(self):
        if 'dmenu' == self.menu:
            self.input = dmenu.show(prompt='input', lines=15, items=self.history)
        elif 'fzf' == self.menu:
            self.input = iterfzf.iterfzf(self.history)
        elif 'normal' == self.menu:
            for i in self.history:
                print(i)
            self.input = input('input: ')

        if self.input is None:
            exit(1)
        else:
            history_thread = Thread(target=self.history_input)
            history_thread.start()

    def redis_output(self):
        logging.info('in redis_output()')
        import redis
        r = redis.Redis()
        try:
            history = r.hgetall('history')
        except redis.exceptions.ConnectionError:
            print('redis_output() false,turn to sqlite_output()')
            self.history_input = self.sqlite_input
            self.history_output = self.sqlite_output
            self.history_output()
            return 1
        history = dcode(history)
        # sort
        history1 = sorted(history, key=history.get, reverse=True)
        if self.clip != '':
            self.history = [self.clip]
        self.history.extend([k for k in history1])

    def redis_input(self):
        logging.info('in redis_input()')
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
        logging.info('in sqlite_output()')
        import sqlite3
        con = sqlite3.connect(f'{filepath}/history.db')
        cur = con.cursor()
        try:
            history_tuple = cur.execute("SELECT * FROM history")
        except sqlite3.OperationalError:
            logging.warning('sqlite_output() false,turn to file_output()')
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
        logging.info('in sqlite_input()')
        import sqlite3
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
                webbrowser.open(self.engine)
                exit(0)

            if self.engine is None:
                exit(1)

            @get
            def get_url(key, value, category_key):
                # 获取引擎url
                if self.engine == key:
                    global get_url
                    self.url = value
                    get_url = True

            if self.url:
                self.input_text()
            else:
                # 获取失败,则为Github
                self.url = engine['Linux']['Github']
                self.input = self.engine
            webbrowser.open(self.url + self.input)

    def file_load(self):
        for value in engine.values():
            for i in value.keys():
                self.engine_list = self.engine_list + [i]

    # @get
    # def file_load(key, value, category_key):
    #     self.engine_list = self.engine_list + [key]

    def category(self):
        load_thread.join()
        self.category_list = engine.keys()

        if self.url is None:
            # 测试模式
            self.category = self.cmd(self.category_list)
            self.engine = self.cmd(engine[self.category].keys())
            self.url = engine[self.category][self.engine]
            self.input_text()

        webbrowser.open(self.url + self.input)

    def redis_store(self):
        import redis
        r = redis.Redis()
        try:
            r.flushdb()
        except redis.exceptions.ConnectionError:
            print('redis_store() error')
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
        import os
        try:
            os.remove(f'{filepath}/search.db')
        except FileNotFoundError:
            pass

        con = sqlite3.connect(f'{filepath}/search.db')
        cur = con.cursor()

        cur.execute('CREATE TABLE IF NOT EXISTS engine (key)')
        for table in engine:
            cur.execute(f"INSERT INTO engine (key) VALUES('{table}')")
            cur.execute(f"CREATE TABLE IF NOT EXISTS {table} (key, value)")

        @get
        def insert(key, value, category_key):
            cur.execute(f"INSERT INTO {category_key} (key, value) VALUES('{key}', '{value}')")

        con.commit()
        con.close()

    def sqlite_load(self):
        import sqlite3
        con = sqlite3.connect(f'{filepath}/search.db')
        cur = con.cursor()
        global engine
        engine = {}

        try:
            category = cur.execute('SELECT * FROM engine')
        except sqlite3.OperationalError:
            print('sqlite_load() false,turn to file_load() and exec sqlite_store()')
            json_load()
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

    def add_item(self):
        category = self.cmd(engine.keys())
        key = dmenu.show('')
        value = dmenu.show('')

        kv = {key: value}
        engine[category].update(kv)
        with open(f'{filepath}/search.json', 'w') as file:
            json.dump(engine, file)

        redis_cmd = f"r.hset('{category}', '{key}', '{value}')"
        redis_operation_thread = Thread(target=redis_operation, args=(redis_cmd,))
        redis_operation_thread.start()

        sqlite_cmd = (f"INSERT INTO {category} (key, value) VALUES('{key}', '{value}')")
        sqlite_operation_thread = Thread(target=sqlite_operation, args=(sqlite_cmd,))
        sqlite_operation_thread.start()

    def del_item(self):
        self.file_load()
        key = self.cmd(self.engine_list)

        @get
        def get_category(k, value, category_key):
            if key == k:
                global category
                category = category_key

        engine[category].pop(key)
        with open(f'{filepath}/search.json', 'w') as file:
            json.dump(engine, file)

        redis_cmd = f"r.hdel('{category}', '{key}')"
        redis_operation_thread = Thread(target=redis_operation, args=(redis_cmd,))
        redis_operation_thread.start()

        sqlite_cmd = (f"DELETE FROM {category} WHERE key = '{key}'")
        sqlite_operation_thread = Thread(target=sqlite_operation, args=(sqlite_cmd,))
        sqlite_operation_thread.start()


if __name__ == "__main__":

    filepath = pathlib.Path(__file__).parent.absolute()

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
        elif 'dmenu' == i:
            import dmenu
            instance.menu = i
        elif 'normal' == i:
            instance.menu = i
        elif 'sync' == i:
            json_load()
            instance.redis_store()
            instance.sqlite_store()
            exit(0)
        elif 'add' == i:
            json_load()
            instance.add_item()
            exit(0)
        elif 'del' == i:
            json_load()
            instance.del_item()
            exit(0)

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
        json_load()
        instance.history_input = instance.redis_input
        instance.history_output = instance.redis_output
        load_thread = Thread(target=instance.file_load)

    logging.basicConfig(format='%(name)s - %(levelname)s - %(message)s')
    history_thread = Thread(target=instance.history_output)
    history_thread.start()
    load_thread.start()

    if 'test' in locals():
        instance.test()

    if 'category' in locals():
        instance.category()
    else:
        instance.select()

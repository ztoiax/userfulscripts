#!/bin/python3
import pyinotify
import sqlite3
import pathlib
import sys
import os

filepath = pathlib.Path(__file__).parent.absolute()
db = f'{filepath}/pyinotify.db'
if os.path.exists(db):
    os.remove(db)

mask_name = ['DELETE', 'CREATE', 'ACCESS', 'MODIFY']
mask = 0
for i in mask_name:
    mask += getattr(pyinotify, f'IN_{i}')
    # mask += eval(f'pyinotify.IN_{i}')
# mask = pyinotify.IN_DELETE | pyinotify.IN_CREATE | pyinotify.IN_ACCESS | pyinotify.IN_MODIFY

def start():
    notifier = pyinotify.ThreadedNotifier(wm, EventHandler())
    wdd = wm.add_watch(path, mask, rec=True)
    notifier.start()

def sqlite_operation(func, table=None, event=None):
    con = sqlite3.connect(db)
    cur = con.cursor()
    func(cur, table, event)
    con.commit()
    con.close()


def sqlite_incre(cur, table, event):
    value = cur.execute(f"SELECT * FROM '{table}' WHERE path='{event.pathname}'")
    return_code = value.fetchall()
    if return_code == []:
        cur.execute(f"INSERT INTO '{table}' (path, count) VALUES('{event.pathname}', 1)")
    else:
        count = return_code[0][1] + 1
        cur.execute(f"UPDATE '{table}' SET count={count} WHERE path='{event.pathname}'")


@sqlite_operation
def sqlite_init(cur, table, event):
    for i in mask_name:
        cur.execute(f"CREATE TABLE IF NOT EXISTS '{i}' (path, count)")


class EventHandler(pyinotify.ProcessEvent):
    def process_IN_CREATE(self, event):
        print("Creating: ", event.pathname)
        sqlite_operation(sqlite_incre, 'create', event)

    def process_IN_DELETE(self, event):
        print("Deleting: ", event.pathname)
        sqlite_operation(sqlite_incre, 'delete', event)

    def process_IN_MODIFY(self, event):
        print("Modifing: ", event.pathname)
        sqlite_operation(sqlite_incre, 'modify', event)

    def process_IN_ACCESS(self, event):
        print("Acceing: ", event.pathname)
        sqlite_operation(sqlite_incre, 'access', event)


if __name__ == '__main__':
    '''
    useage: inotify.py path path1
    除了输出外, 还会保存至pyinotify.sql, 并统计次数
    '''
    wm = pyinotify.WatchManager()
    if 1 == len(sys.argv):
        path = '.'
        start()
    else:
        for path in sys.argv[1:]:
            start()

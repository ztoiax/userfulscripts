#!/bin/python3
import re
import sys
import subprocess

# 导入数据
from searchdata import *

# 选择menu程序
if len(sys.argv) == 1:
    menu = 'dmenu'
else:
    menu = sys.argv[1]
    if sys.argv[1] == 'rofi':
        menu = 'rofi -dmenu'


def getClipboard():
    cmd = 'xclip -selection clipboard -o'
    output = subprocess.check_output(cmd, shell=True, universal_newlines=True)
    return output


def selectUrl():
    # 判断剪切板是否为url
    url = getClipboard()
    if re.search(r'^http.*', url):
        str_engine = url
    else:
        str_engine = ''
    return str_engine


def showEngine(category=None):
    # 设置字符串
    str_engine = selectUrl()
    # 只显示分类
    if category is not None:
        for i in engine[category]:
            str_engine = str_engine + i + '\n'
    # 显示所有
    else:
        for value in engine.values():
            for i in value.keys():
                str_engine = str_engine + i + '\n'
    return str_engine


def showCategory():
    str_engine = selectUrl()
    for i in category:
        str_engine = str_engine + i + '\n'
    return str_engine


def selectEngine(str_engine, menu):
    if menu == 'fzf':
        cmd_engine = "echo -e '{0}' | {1}".format(str_engine, menu)
    else:
        cmd_engine = "echo -e '{0}' | {1} -p 'engine' -l 15".format(
                str_engine, menu)

    select_engine = subprocess.check_output(
            cmd_engine, shell=True, universal_newlines=True)
    return select_engine.rstrip()


def input(menu):
    if menu == 'fzf':
        cmd_input = menu
    else:
        cmd_input = "echo input | " + menu
    input_text = subprocess.check_output(
            cmd_input, shell=True, universal_newlines=True)

    # 如果没有输入,便等于剪切板
    if input_text == 'input\n':
        input_text = getClipboard()
    return input_text.rstrip()



def checkUrl(select_engine):
    # 如果剪切板是url, 则直接打开url
    if re.search(r'^http.*', select_engine):
        subprocess.call('xdg-open {0}'.format(select_engine), shell=True)
        return True


def openEngine():
    # 选择engine
    select_engine = selectEngine(showEngine(), menu)
    if checkUrl(select_engine):
        return 0
    else:
        input_text = input(menu)
        for value in engine.values():
            for key in value:
                if select_engine == key:
                    cmd = 'xdg-open {0}{1}'.format(value[select_engine], input_text)
                    subprocess.call(cmd, shell=True)


def openCategory():
    # 选择engine
    select_category = selectEngine(showCategory(), menu)
    if checkUrl(select_category):
        return 0
    else:
        select_engine = selectEngine(showEngine(select_category), menu)
        input_text = input(menu)
        cmd = 'xdg-open {0}{1}'.format(engine[select_category][select_engine], input_text)
        subprocess.call(cmd, shell=True)



openEngine()
# openCategory()

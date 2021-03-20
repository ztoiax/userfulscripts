#!/bin/python3
import re
import sys
import subprocess

if sys.argv[1] != '':
    menu = sys.argv[1]
    if sys.argv[1] == 'rofi':
        menu = 'rofi -dmenu'
else:
    menu = 'dmenu'

google = 'https://www.google.com/search?q='
baidu = 'https://www.baidu.com/s?wd='
sousuo = {'google': google,'baidu': baidu}

googlexueshu = 'https://scholar.google.com/scholar?hl=zh-CN&as_sdt=0%2C5&q='
baiduxueshu = 'https://xueshu.baidu.com/s?wd='
xueshu = {'googlexueshu': googlexueshu, 'baiduxueshu': baiduxueshu}

engine = [sousuo, xueshu]

category= ['sousuo', 'xueshu']
menulist = ['dmenu', 'rofi -dmenu', 'fzf']

def getClipboard():
    cmd = 'xclip -selection clipboard -o'
    output = subprocess.check_output(cmd, shell=True, universal_newlines=True)
    return output

def showEngine():
    # 判断剪切板是否为url
    url = getClipboard()
    if re.search(r'^http.*', url):
        str_engine = url
    else:
        str_engine = ''

    for value in engine:
        for i in value.keys():
            str_engine = str_engine + i + '\n'
    return str_engine

def selectEngine(str_engine, menu):
    if menu == 'fzf':
        cmd_engine = "echo -e '{0}' | {1}".format(str_engine, menu)
    else:
        cmd_engine = "echo -e '{0}' | {1} -p 'engine' -l 15".format(str_engine, menu)

    select_engine = subprocess.check_output(cmd_engine, shell=True, universal_newlines=True)
    return select_engine.rstrip()

def input(menu):
    if menu == 'fzf':
        cmd_input = menu
    else:
        cmd_input = "echo input | " + menu
    input_text = subprocess.check_output(cmd_input, shell=True, universal_newlines=True)
    # 如果没有输入,便等于剪切板
    if input_text == 'input\n':
        input_text = getClipboard()
    return input_text.rstrip()

# 选择engine
select_engine = selectEngine(showEngine(), menu)

# 如果剪切板是url, 直接打开url
if re.search(r'^http.*', select_engine):
    subprocess.call('xdg-open {0}'.format(select_engine), shell=True)
else:
    input_text = input(menu)
    for value in engine:
        for key in value:
            if select_engine == key:
                cmd = 'xdg-open {0}{1}'.format(value[select_engine], input_text)
                subprocess.call(cmd, shell=True)

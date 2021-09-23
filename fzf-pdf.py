#!/bin/python3
import subprocess
import sys

'''
useage:
    fzf-pdf.py
    fzf-pdf.py -a
    fzf-pdf.py 搜索词
'''

def process(select):
    # fzf
    try:
        output = subprocess.check_output(select, shell=True)
    except subprocess.CalledProcessError:
        exit(0)

    # 将binary转换为utf-8
    output = output.decode('utf-8').rstrip()
    file_name = output.rsplit(':')[0]
    file_context = output.rsplit()[-1]

    # zathura
    command = 'zathura {0} -f {1} &'.format(file_name, file_context)
    subprocess.call(command, shell=True)

if __name__ == "__main__":
    if 1 == len(sys.argv):
        select = f'rga . --rga-adapters=pandoc,poppler | fzf'
        process(select)
    elif '-a' == sys.argv[1] or '--all' == sys.argv[1]:
        select = f'rga . --rga-adapters=pandoc,poppler | fzf'
        while True:
            process(select)
    else:
        select = f'rga {sys.argv[1]} . --rga-adapters=pandoc,poppler | fzf'
        process(select)

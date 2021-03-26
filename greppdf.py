#!/bin/python3
import subprocess
import sys

select = 'rga "%s" . --rga-adapters=pandoc,poppler | fzf' % (sys.argv[1])
output = subprocess.check_output(select, shell=True)
# 将binary转换为utf-8
output = output.decode('utf-8').rstrip()
file_name = output.rsplit(':')[0]
file_context = output.rsplit()[-1]
command = 'zathura {0} -f {1}'.format(file_name, file_context)
subprocess.call(command, shell=True)

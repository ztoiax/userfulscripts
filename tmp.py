#!/usr/bin/python3
#mv file tmp
from __future__ import print_function
import os
import sys

tmp = ' /tmp'
n = sys.argv
for i in range(len(n) - 1):
    os.popen('mv ' + sys.argv[i+1] + tmp)

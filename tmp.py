#!/usr/bin/python3
'''
mv file /tmp
'''

import os
import sys
from datetime import datetime

now = datetime.now()
now = now.strftime("%Y-%m-%d:%H:%M:%S")

for filename in sys.argv[1:]:
    if os.path.exists(f'/tmp/{filename}'):
        os.popen(f'mv {filename} /tmp/{filename}.{now}')
        print(f'mv {filename} /tmp/{filename}.{now}')
    else:
        os.popen(f'mv {filename} /tmp')
        print(f'mv {filename} /tmp')

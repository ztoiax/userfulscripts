#!/bin/python3
import requests
r = requests.get("http://baidu.com/")

print(r.status_code)
print(r.headers)
print(r.content)

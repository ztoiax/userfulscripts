#!/bin/python3
import sys
import re
import requests
import bs4
'''
useage:
    get_stargazers.py https://github.com/planetopendata/awesome-sqlite
'''

def stargazers(url):
    r = requests.get(url)
    soup = bs4.BeautifulSoup(r.content, "html5lib")

    p = soup.select('.follow-list-info')
    for i in p:
        if not re.match(r'.*Joined', i.text):
            print(i.text)
            people_list.append(i.text)

    # next star page
    next = soup.find_all("a", {"class":"btn btn-outline BtnGroup-item"})
    if 1 == len(next) and 'Previous' == next[0].text:
        return people_list

    for i in next:
        if 'Next' == i.text:
            next_url = i.get('href')
            print('##### next star page #####')
            stargazers(next_url)

if __name__ == '__main__':
    url = sys.argv[1]
    if not re.match(r'htt(p|ps)://github.com/\w*/\w*', url):
        print('error github url')
        exit(1)

    star = '/stargazers'
    people_list = []
    stargazers(url + star)
    print(people_list)

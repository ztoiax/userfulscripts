#!/bin/python3
from gevent import monkey; monkey.patch_all()

import gevent
import requests
import bs4
import re
import sys
import dmenu
import os
from time import time

def get_soup(url):
    r = requests.get(url=url, headers=headers)
    return bs4.BeautifulSoup(r.content, "html5lib")

def img_download(name, img_url):
    file = f'{dir}/{name}.jpg'
    if os.path.exists(file):
        print(f'Exists {file}')
    else:
        print(f'Downloading {file}')
        r = requests.get(url=img_url, headers=headers)
        gevent.sleep(0)
        open(file, 'wb').write(r.content)

def save_url(page_dict):
    import yaml
    f = f'{dir}/page_dict.yaml'
    if not os.path.exists(f):
        os.mknod(f)

    with open(f, 'r') as file:
        try:
            page_dict |= yaml.load(file)
        except:
            pass

    with open(f, 'w') as file:
        yaml.dump(page_dict, file, allow_unicode=True)
        print(f'finish {f}')

class spider(object):
    def __init__(self, url):
        self.url = url
        self.category = {}

        self.soup_list =[]
        self.page_dict = {}

        soup = get_soup(self.url)
        self.get_category(soup)
        self.get_menu()
        self.get_first()
        self.get_pages()

    def get_category(self, soup):
        div = soup.select('.area')
        a = div[0].find_all('a')
        for i in a:
            self.category |= {i.text: url + i.get('href') }

    def get_menu(self):
        select_category = dmenu.show(lines=15, items=self.category.keys())
        self.select_category = self.category[select_category]

    def get_first(self):
        self.first_soup = get_soup(self.select_category)

        div = self.first_soup.select('.panel')
        text = div[-2].text.split('/')[-1]
        count = text.split('页')[0]
        self.count = dmenu.show('',prompt=count)

    def get_gevent_soup(self, url):
        r = requests.get(url=url, headers=headers)
        gevent.sleep(0)
        return bs4.BeautifulSoup(r.content, "html5lib")
        # self.soup_list.append(bs4.BeautifulSoup(r.content, "html5lib"))

    def get_content(self, soup):
        div = soup.select('.thumbnail-group')

        a = div[0].find_all('a')
        page_dict = {}
        for i in a:
            text = re.sub('.html','play-1-1.html', i.get('href'))
            page_dict |= {i.text: self.url + text}

        img = div[0].find_all('img')
        for i in img:
            name = i.get('alt')
            img_url = i.get('data-src')
            img_download(name, img_url)
            gevent.sleep(0)

        return page_dict
        # self.page_dict |= page_dict

    def get_pages(self):
        page_dict = {}
        time_list = []

        start = time()
        page_dict |= self.get_content(self.first_soup)
        end = time()
        endtime='%.12f秒' % (end - start)
        print(endtime)
        time_list.append(endtime)

        page_template = re.sub('.html','', self.select_category)
        for i in range(2, int(self.count) + 1):
            start = time()

            page = f'{page_template}-{i}.html'
            print(page)
            soup = self.get_gevent_soup(page)
            page_dict |= self.get_content(soup)

            end = time()
            endtime='%.12f秒' % (end - start)
            print(endtime)
            time_list.append(endtime)

        # from time import time
        # start = time()
        # threads = [gevent.spawn(self.get_gevent_soup, f'{page_template}-{i}.html') for i in range(2, int(self.count) + 1)]
        # gevent.joinall(threads)

        # get_countent_threads = [gevent.spawn(self.get_content, i) for i in self.soup_list]
        # gevent.joinall(get_countent_threads)
        # end = time()
        # print('%.12f秒' % (end - start))

        print(time_list)
        save_url(page_dict)
        # save_url(self.page_dict)

if __name__ == "__main__":
    dir = '/mnt/E/迅雷下载/.m/imgs'
    if not os.path.exists(dir):
        os.mkdir(dir)

    url = sys.argv[1]
    headers={'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64)' 'AppleWebKit/537.36 (KHTML, like Gecko)' 'Chrome/90.0.4430.85 Safari/537.36'}

    spider(url)

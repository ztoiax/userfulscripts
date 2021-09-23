#!/bin/python3
import requests
import bs4
import sys
import re

def get_soup(url):
    r = requests.get(url=url, headers=headers)
    print(url)
    return bs4.BeautifulSoup(r.content, "html5lib")

def get_category():
    soup = get_soup(url)
    div = soup.div.find_all('a')
    category = {}
    for i in div:
        try:
            children = re.search('/.*/', i.get('href')).group()
            category |= {i.contents[0] : children}
        except:
            pass
    return category

def get_page(url, imgs=False):
    soup = get_soup(url)
    a = soup.select('p > a')

    dict1 = {}
    for i in a:
        try:
            number = re.search(r'\d+', i.get('href')).group()
            url = f'https://www.yyss102.com/Msp/play/{number}_play.html'
            name = i.contents[1]['alt']
            dict1 |= {name : url}

            if imgs:
                img_url = i.contents[1]['data-original']
                # file = f'/mnt/E/迅雷下载/.m/imgs/{name}.jpg'
                file = f'{dir}/{name}.jpg'
                import os
                if os.path.exists(file):
                    print(f'Exists {file}')
                else:
                    print(f'Downloading {file}')
                    r = requests.get(url=img_url, headers=headers)
                    open(file, 'wb').write(r.content)
        except:
            pass

    return dict1

def get_content(select_category, count):
    dict1 = {}
    select_url = url + select_category + 'index.html'
    dict1 |= get_page(select_url, imgs=True)

    if not count:
        soup = get_soup(select_url)
        count = soup.select('.page-link')[-2]
        count = count.contents[0].strip('.')

    for i in range(2, count + 1):
        select_url = f'{url}{select_category}index_{i}.html'
        # dict1 |= get_page(select_url)
        dict1 |= get_page(select_url, imgs=True)

    return dict1

def grep_content(dict1, pattern):
    for k, v in dict1.items():
        if re.search(pattern, k, re.IGNORECASE):
            print(k)
            print(v)

if __name__ == "__main__":
    # url = sys.argv[1]
    url = 'https://www.yyss102.com'

    headers={'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64)' 'AppleWebKit/537.36 (KHTML, like Gecko)' 'Chrome/90.0.4430.85 Safari/537.36'}
    dir = '/mnt/E/迅雷下载/.m/imgs'

    category = get_category()

    import dmenu
    select_category = dmenu.show(lines=15, items=category.keys())
    select_category = category[select_category]
    dict1 = get_content(select_category, 2)

    import yaml
    f = f'{dir}/dict1.yaml'
    with open(f, 'rw') as file:
        dict1 |= yaml.load(file)
        yaml.dump(dict1, file, allow_unicode=True)
        print(f)

    import json
    f = f'{dir}/dict1.json'
    with open(f, 'rw') as file:
        json.dump(dict1, file, ensure_ascii=False)
        print(f)

    grep_content(dict1, 'massage')

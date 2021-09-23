#!/bin/python3
# -*- coding: utf-8 -*-
# @Author: login part by CriseLYJ
# @Date:   2020-08-14 12:13:11

import re
import requests
import click
import bs4


class GithubLogin(object):

    def __init__(self, email, password):
        # 初始化信息
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36',
            'Referer': 'https://github.com/',
            'Host': 'github.com'
        }

        self.session = requests.Session()
        self.url = 'https://github.com'
        self.login_url = 'https://github.com/login'
        self.post_url = 'https://github.com/session'
        self.email = email
        self.password = password

    def login_GitHub(self):
        # 登录入口
        post_data = {
            'commit': 'Sign in',
            'utf8': '✓',
            'authenticity_token': self.get_token(),
            'login': self.email,
            'password': self.password
        }
        resp = self.session.post(
            self.post_url, data=post_data, headers=self.headers)
        self.resp = resp
        print('StatusCode:', resp.status_code)
        if resp.status_code != 200:
            print('Login Fail')
        match = re.search(r'"user-login" content="(.*?)"', resp.text)
        self.user_name = match.group(1)
        print('UserName:', self.user_name)



    # Get login token
    def get_token(self):

        response = self.session.get(self.login_url, headers=self.headers)

        if response.status_code != 200:
            print('Get token fail')
            return None
        match = re.search(
            r'name="authenticity_token" value="(.*?)"', response.text)
        if not match:
            print('Get Token Fail')
            return None
        return match.group(1)


    # Get your stars
    def get_stars(self, url):
        response = requests.get(url)
        soup = bs4.BeautifulSoup(response.content, "html5lib")
        stars = soup.find_all("div", {"class": "col-12 d-block width-full py-4 border-bottom color-border-secondary"})
        self.stars_list = []
        for i in stars:
            try:
                a = i.find_all('a')
                s = i.find_all("span", {"itemprop":"programmingLanguage"})
                dict1 = {
                        'link': self.url + a[0].get('href'),
                        'stars': a[1].text.strip(),
                        'forks': a[2].text.strip(),
                        'language': s[0].text
                        }
                print(dict1)
                self.stars_list.append(dict1)
            except IndexError:
                pass

            # next star page
            next = soup.find_all("a", {"class":"btn btn-outline BtnGroup-item"})
            if 1 == len(next) and 'Previous' == next[0].text:
                return 0
            for i in next:
                if 'Next' == i.text:
                    next_url = i.get('href')
                    print('##### next star page #####')
                    self.get_stars(next_url)

# @click.command()
# @click.option("--account", prompt="Account", help="The person to greet.")
# @click.option('--password', prompt=True, hide_input=True)
# def main(account, password):
#     login = GithubLogin(account, password)
#     login.login_GitHub()
#     login.get_stars()

if __name__ == '__main__':
    # main()
    account = input('Account:')
    from getpass import getpass
    password = getpass()

    login = GithubLogin(account, password)
    login.login_GitHub()

    url = f'https://github.com/{login.user_name}?tab=stars'
    login.get_stars(url)

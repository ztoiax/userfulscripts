# search
google = 'https://www.google.com/search?q='
baidu  = 'https://www.baidu.com/s?wd='
kuake  = "https://quark.sm.cn/s?q="
bind   = "https://cn.bing.com/search?q="
wiby   = 'https://www.wiby.me/?q='
duckduckgo = 'https://duckduckgo.com/?q='
wolframalpha = 'https://www.wolframalpha.com/input/?i='

search = {
        'Google' : google,
        'Baidu'  : baidu,
        'Kuake'  : kuake,
        'Bind'   : bind,
        'Wiby'   : wiby,
        'Duckduckgo'   : duckduckgo,
        'WolframAlpha'   : wolframalpha
        }

wk   = "https://en.wikipedia.org/wiki/"
baiduwiki = 'https://baike.baidu.com/item/'
wiki = {
        'Wiki'   : wk,
        'BaiduWiki' : baiduwiki
        }

# social
jianshu = "https://www.jianshu.com/search?q="
zhihu   = "https://www.zhihu.com/search?q="
douban  = "https://www.douban.com/search?q="
weibo   = "https://s.weibo.com/weibo/"
weixin  = "https://weixin.sogou.com/weixin?query="

social = {
        'jianshu' : jianshu,
        'zhihu'   : zhihu,
        'douban'  : douban,
        'weibo'   : weibo,
        'weixin'  : weixin 
        }

# waiguosocial
reddit   = "https://www.reddit.com/search/?q="
twitter  = "https://twitter.com/search?q="
facebook = "https://www.facebook.com/search/top/?q="
goodread = "https://www.goodreads.com/search?q="

waiguosocial = {
        'reddit'   : reddit,
        'twitter'  : twitter,
        'facebook' : facebook,
        'goodread' : goodread
        }

# xueshu
googlexueshu = 'https://scholar.google.com/scholar?q='
baiduxueshu = 'https://xueshu.baidu.com/s?wd='
nstl = "http://oar.nstl.gov.cn/Paper/Search?searchKey="
downloadxueshu = "http://jour.gzlib.org/searchJour?sw"
chaoxing = "http://qikan.chaoxing.com/searchjour?sw="
aisixiang = "http://www.aisixiang.com/data/search.php?keyWords="
semanticscholar = 'https://www.semanticscholar.org/search?q='
xueshu = {
        'GoogleXueShu': googlexueshu,
        'BaiduXueShu': baiduxueshu,
        'nstl国家科技图书文献中心': nstl,
        'DownloadXueShu': downloadxueshu,
        'ChaoXing': chaoxing,
        'aisixiang(爱思想)': aisixiang,
        'semanticscholar(外国学术)': semanticscholar
        }

# library
zhongshan = 'http://opac.zslib.com.cn:8991/F/?func=find-b&find_code=WRD&find_base=KJSK&request='
guangzhou = 'http://opac.gzlib.org.cn/opac/search?q='
library = {
        'ZhongShan' : zhongshan,
        'GuangZhou' : guangzhou
        }

# video
youtube   = "https://www.youtube.com/results?search_query="
bilibli   = "https://search.bilibili.com/all?keyword="
youku     = "https://so.youku.com/search_video/q_"
tengxun   = "https://v.qq.com/x/search/?q="
aiqiyi    = "https://so.iqiyi.com/so/q_"
yunketang = "https://study.163.com/courses-search?keyword="
gongkaike = "https://open.163.com/newview/search/"

video = {
        'Youtube'   : youtube,
        'Bilibli'   : bilibli,
        'Youku'     : youku,
        'TengXun'   : tengxun,
        'Aiqiyi'    : aiqiyi,
        'YunKeTang' : yunketang,
        'GongKaiKe' : gongkaike
        }

# shop
taobao = "https://s.taobao.com/search?q="
jd     = "https://search.jd.com/Search?keyword="

shop = {
        'Taobao' : taobao,
        'Jd'     : jd
        }

# linux
github        = "https://github.com/search?q="
gitee         = "https://search.gitee.com/?q="
gitbook       = "https://www.google.com/search?q=site:gitbook.com%20"
linux_china   = "https://www.baidu.com/s?wd=site:linux.cn%20"
linux_command = "https://man.linuxde.net/"
ruanyif       = "https://www.baidu.com/s?wd=site:www.ruanyifeng.com%20"
lwm           = "https://www.google.com/search?q=site:lwn.net%20"
arch          = "https://wiki.archlinux.org/index.php?search="
arch_man      = "https://man.archlinux.org/search?q="
ibm           = "https://developer.ibm.com/zh?s="
aliyun        = "https://developer.aliyun.com/search?q="
pkgs          = "https://pkgs.org/search/?q="

linux = {
        'Github'        : github,
        'Gitee'         : gitee,
        'Gitbook'       : gitbook,
        'Linux_China'   : linux_china,
        'Linux_Command' : linux_command,
        'Ruanyif'       : ruanyif,
        'Lwm'           : lwm,
        'Arch'          : arch,
        'Arch_man'      : arch_man,
        'IBM'           : ibm,
        'Aliyun'        : aliyun,
        'Pkgs'          : pkgs
        }


# network
h3c     = "https://search.h3c.com/basesearch.aspx?q0="
huawei  = "https://support.huawei.com/enterprisesearch/?lang=zh#keyword="
cisco   = "https://search.cisco.com/search?query="
netbeez = "https://www.google.com/search?q=site:netbeez.net%20"

network = {
        'H3C'     : h3c,
        'Huawei'  : huawei,
        'Cisco'   : cisco,
        'Netbeez' : netbeez
        }

engine = {'linux': linux, 'xueshu': xueshu, 'library': library, 'social': social, 'waiguosocial': waiguosocial, 'video': video, 'shop': shop, 'search': search, 'wiki': wiki, 'network': network}

menulist = ['dmenu', 'rofi -dmenu', 'fzf']

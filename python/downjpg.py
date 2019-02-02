#coding=utf-8
import requests
from pyquery import PyQuery as pq
url = "https://movie.douban.com/top250"
#download
res = requests .get(url)
for i in pq(res.text).find('.item'):
#    print( pq(i).find('img').attr('src'))
    img_url = pq(i).find('img').attr('src')
    r = requests.get(img_url)
    with open(img_url.split('/')[-1],'wb+') as f:
        f.write(r.content)
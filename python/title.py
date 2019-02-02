#coding=utf-8
import requests
from pyquery import PyQuery as pq
url = "https://movie.douban.com/top250"
#download
res = requests .get(url)
for i in pq(res.text).find('.hd'):
#    print (pq(i).find('.title').html())
#    print(pq(i).find('.title').eq(1).html())
    print(pq(i).find('.other').html())
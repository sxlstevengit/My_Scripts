#coding=utf-8
import requests
from pyquery import PyQuery as pq
url = "https://movie.douban.com/top250"
#download
res = requests .get(url)
print (res.text)
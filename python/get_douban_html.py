#coding=utf-8
import requests
from pyquery import pyquery as pq
url = "https://movie.douban.com/top250"

res = requests.get(url)
print (res.text)
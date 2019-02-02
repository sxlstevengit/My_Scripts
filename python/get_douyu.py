# coding:utf-8
import requests
import json
import os

# 用findder来获取斗鱼某一类型的实际请求URL
url = "https://www.douyu.com/gapi/rkc/directory/2_201/0"
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}
#获取请求数据
response = requests.get(url,headers=headers)
# print(response.text)
# 将json数据转化成python格式，抽取我们想要的数据：图片链接、主播名
py_data = json.loads(response.text)
os.mkdir("douyu")
for i in py_data['data']['rl']:
    print (i['nn'],i['rs16'])
    content = requests.get(i['rs16'],headers=headers).content
    filename = "douyu\\" + i['nn'] + ".jpg"
    print( "正在存储图片:" + filename )
    #保存图片到磁盘
    with open(filename,"wb") as f:
        f.write(content)
f.close()





# coding:utf-8
#请求 模拟用户请求
import requests
#查询
from pyquery import PyQuery as pd
import os
headers = { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

lastpage = int(input("Enter the page number what you want:"))
for j in range(1,lastpage):
    url = "http://www.bbsnet.com/page/" + str(j)

    # text文本、context内容 、json 数据格式
    request = requests.get(url,headers=headers).text
    # print (request)

    #初始化
    doc = pd(request)
    #过滤、使用类选择器
    ret = doc('.thumbnail a').items()
    for i in ret:
        # print(i.attr('href'))
        url_img = i.attr('href')
        title_img = i.attr('title')
        request_url = requests.get(url_img,headers=headers).text
        second_doc = pd(request_url)
        second_ret = second_doc('#post_content p img').items()
        count = 0
        for n in second_ret:
            print("开始保存第%s张图片" %count)
            img_gif = n.attr('src')
            img_request = requests.get(img_gif,headers=headers).content
            with open("doutu\\" + title_img + str(count) + '.gif','wb') as f:
                f.write(img_request)
            count+=1
            f.close()


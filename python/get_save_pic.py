# coding=utf-8
import requests
import os

url = "https://slide.cdn.myslide.cn/4ba8eaf56046419662a1ee61412574a0ff19a357/slide-01.jpg"
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"}

res = requests.get(url,headers=headers)
content = res.content

with open("1.jpg","wb") as f:
    f.write(content)
print("图片保存成功")

# if __name__ == "__main__":


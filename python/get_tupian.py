# 第一部分: 获取网页源代码
#导入模块
import requests
#定义变量
url = "http://www.lanrentuku.com/"

# 设置请求headers，让python模拟浏览去获取数据
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

#发起请求，获取数据
result = requests.get(url,headers=headers)

#设置数据的字符编码为utf-8，由于之前数据汉字显示为乱码
res = result.content.decode("gbk")

#打印结果
# print(res)

#第二部分
from lxml import etree
tt = etree.HTML(res)
img_list = tt.xpath("//dd/a/img/@src")

for i in img_list:
    name = i[-10:]
    # if "/" not in name:
    if "/" in name:
        name = name.split('/')[-1]
    else:
        pass
    with open('img/' + name,'wb') as f:
        pic = requests.get(i)
        f.write(pic.content)
        f.close()
    # else:
    #     pass
print (img_list)



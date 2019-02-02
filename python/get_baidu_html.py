# 第一部分: 获取网页源代码

#导入模块
import requests

#定义变量
url = "https://www.baidu.com/"

# 设置请求headers，让python模拟浏览去获取数据
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

#发起请求，获取数据
result = requests.get(url,headers=headers)

#设置数据的字符编码为utf-8，由于之前数据汉字显示为乱码
res = result.content.decode()

#打印结果
#print(res)

# 第二部分：利用xpath获取到自己需要的数据
from lxml import etree

#把数据XML类型
t = etree.HTML(res)

#xpath过滤
# ret = r.xpath("//div[@id='u1']/a[1]")
# ret = t.xpath("//div[@id='u1']/a/@href")
# ret = t.xpath("//div[@id='u1']/a/text()")
# f = open("baidu.txt",'w')
# for i in ret:
#     f.write(i+"\n")
# f.close()
# print(ret)






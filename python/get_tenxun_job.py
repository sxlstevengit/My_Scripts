import requests
from lxml import etree
import json


class Spider:


    def __init__(self):
        self.headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}
    # url = "https://hr.tencent.com/position.php?&start=0#a"
    def start_request(self,x):
        self.response = requests.get(x,headers = self.headers)
        html = etree.HTML(self.response.text)
        # print (self.response.text)
        self.xpath_data(html)

    def xpath_data(self,html):
        tit_list = html.xpath("//table[@class='tablelist']/tr/td/a/text()")
        typ_list = html.xpath("//table[@class='tablelist']/tr/td[2]/text()")[1:]
        num_list = html.xpath("//table[@class='tablelist']/tr/td[3]/text()")[1:]
        pos_list = html.xpath("//table[@class='tablelist']/tr/td[4]/text()")[1:]
        pub_list = html.xpath("//table[@class='tablelist']/tr/td[5]/text()")[1:]
        # print(tit_list,typ_list,num_list,pos_list,pub_list)
        for tit,typ,num,pos,pub in zip(tit_list,typ_list,num_list,pos_list,pub_list):
            items = { "招聘名称":tit,"招聘类型":typ,"招聘数量":num,"招聘地点":pos,"发布时间":pub }
            # print(tit,typ,num,pos,pub)
            # print(items)
            content = json.dumps(items,ensure_ascii=False) + ",\n"
            with open("tenxun_job.json","a") as f:
                f.write(content)
# url= "https://hr.tencent.com/position.php?&start=0#a"
spider = Spider()
for i in range(0,2871,10):
    url = "https://hr.tencent.com/position.php?&start=" + str(i) + "#a"
    spider.start_request(url)
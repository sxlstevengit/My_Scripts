# coding=utf-8
import requests
import os

# 使用requests爬取该页面所有的图片，并保存到本地
# 网页： https://myslide.cn/slides/4254
# 通过分析该页面的图片地址格式：https://slide.cdn.myslide.cn/4ba8eaf56046419662a1ee61412574a0ff19a357/slide-01.jpg
# 最后一张： https://slide.cdn.myslide.cn/4ba8eaf56046419662a1ee61412574a0ff19a357/slide-35.jpg
# 只需要修改最后数字即可。

class Sina_Docker_Pic(object):
    def __init__(self):
        self.url = "https://slide.cdn.myslide.cn/4ba8eaf56046419662a1ee61412574a0ff19a357/slide-{}.jpg"
        self.headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"}

    # 构造url列表
    def get_url_list(self):
        url_list = [self.url.format(str(0) + str(i)) if i < 10 else self.url.format(i) for i in range(1,36)]
        # print(url_list)
        return url_list

    # 请求资源
    def get_content(self,pic_url):
        result = requests.get(pic_url,headers=self.headers)
        return result.content

    # 保存资源
    def save_html(self,pic_content,page_num):
        name = "sina_docker"
        if not os.path.exists(name):
           os.mkdir(name)
        with open(os.path.join(name,"{}.jpg".format(page_num)),"wb") as f:
            f.write(pic_content)
        print("第%s张图片-保存成功" %page_num)

    # 主要逻辑
    def mainfun(self):
        url_list = self.get_url_list()
        for i in url_list:
            result = self.get_content(i)
            self.save_html(result,url_list.index(i)+1)

def main():
    sina_docker_pic = Sina_Docker_Pic()
    sina_docker_pic.mainfun()

if __name__ == "__main__":
    main()
import requests

# 面向过程
# v1
# def get_tieba():
#     url = "http://tieba.baidu.com/f?kw=python&ie=utf-8&pn={}"
#     url_list = [url.format(i*50) for i in range(50)]
#     for i in url_list:
#         result_html = requests.get(i).content.decode()
#         file_name = "baidu\\" + "python" + "第{}页" + ".html"
#         page_num = url_list.index(i)+1
#         file_name= file_name.format(page_num)
#         with open(file_name,'w',encoding="utf8") as f:
#             f.write(result_html)
#         f.close()


# v2
# tb_name = input("请输入贴吧名称:")
# def get_tieba():
#     url = "http://tieba.baidu.com/f?kw=" + tb_name +"&ie=utf-8&pn={}"
#     url_list = [url.format(i*50) for i in range(50)]
#     for i in url_list:
#         result_html = requests.get(i).content.decode()
#         file_name = "baidu\\" + tb_name + "第{}页" + ".html"
#         page_num = url_list.index(i)+1
#         file_name= file_name.format(page_num)
#         with open(file_name,'w',encoding="utf8") as f:
#             f.write(result_html)
#         f.close()

# v3
# tieba = input("请输入贴吧名称:")
# def get_tieba(x):
#     tb_name = x
#     url = "http://tieba.baidu.com/f?kw=" + tb_name +"&ie=utf-8&pn={}"
#     url_list = [url.format(i*50) for i in range(50)]
#     for i in url_list:
#         result_html = requests.get(i).content.decode()
#         file_name = "baidu\\" + tb_name + "第{}页" + ".html"
#         page_num = url_list.index(i)+1
#         file_name= file_name.format(page_num)
#         with open(file_name,'w',encoding="utf8") as f:
#             f.write(result_html)
#         f.close()
# spider = get_tieba(tieba)

# 面向对象

#定义类Tb_Spider
class Tb_Spider:
    """类初始化，即构造函数__init__，这个类实例化时，会自动执行。 一般里面会定义一些变量。self表示实例自身。
       如self.tb_name表示给实例一个tb_name的属性，可以直接调用。类实例化时，传入的参数，会直接给到这个构造函数。
    """
    def __init__(self,tb_name):
        self.tb_name = tb_name
        #{}表示占位符,在后面会从别处引用值
        self.url = "http://tieba.baidu.com/f?kw=" + tb_name + "&ie=utf-8&pn={}"

    # 定义一个类函数，函数作用是生成一个url列表，此处.format()里的值，正好被上面｛｝所引用.
    def get_Url_List(self):
        url_list = [self.url.format(i*50) for i in range(50)]
        #return的作用是把值返回。便于别处引用.
        return url_list

    #定义一个类函数，函数作用：请求url，然后返回html格式的内容，并进行解码. (content返回是二进制数据)
    def request_Url(self,realurl):
        ret = requests.get(realurl).content.decode()
        return ret

    #定义一个类函数，作用：保存html内容到磁盘。 此处需要给出两个变量。 所以在run函数中，需要把这两个变量定义好。
    def save_Html(self,html_str,page_num):
        file_name = "baidu\\" + "{}_第{}页.html"
        file_name = file_name.format(self.tb_name,page_num)
        with open(file_name,"w",encoding="utf8") as f:
            f.write(html_str)
        print("保存成功")

    # 定义类函数,此函数引用了上面所有定义的函数。作用：遍历得到的url列表，分别请求并保存。
    # 引用上面的函数时: self.函数名。不然会报错：找不到此函数。
    def run(self):
        url_li = self.get_Url_List()
        for i in url_li:
            html_str = self.request_Url(i)
            page_num = url_li.index(i) + 1
            self.save_Html(html_str,page_num)

if __name__ == '__main__':
    spider = Tb_Spider("python")
    spider.run()

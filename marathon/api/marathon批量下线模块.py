# coding:utf8
# 此程序功能是批量停止marathon上的应用

# version:v1
# from marathon import MarathonClient
# server = "http://10.30.0.6:8080"
#
# maraclient = MarathonClient(servers=server)
#
# appList = []
# with open(r"applist_offline.txt",encoding="utf-8",mode="r") as f:
#     for i in f:
#         i = i.rstrip( "\n" )
#         appName = "/java/" + i
#         appList.append(appName)
#
#
# for i in appList:
#     try:
#         res = maraclient.kill_tasks(i,scale=True)
#     except Exception as e:
#         print("出错了,错误代码%s" %e)
#         print("应用%s已经停止或者不存在" %i)
#     else:
#         print("应用%s停止成功"%i)



# # version:v2
#
# from marathon import MarathonClient
# server = "http://10.30.0.6:8080"
#
# #实例化
# maraclient = MarathonClient(servers=server)
#
# # 获取marathon的应用模块列表
# allapp = maraclient.list_apps()
#
# # 提取应用模块的名称,即id
# allapp_list = [str(i.id) for i in allapp]
# #print(allapp_list)
#
#
# # 定义一个待下线空列表
# offline_list = []
#
# # 读取待下线模块文本，一行一个,但是不带分组.
# with open(r"applist_offline.txt",encoding="utf-8",mode="r") as f:
#     # 遍历读取的文本,并判断是否在应用模块列表中,如果存在则把应用模块加入到待下线列表中。
#     # 为什么不直接读取模块文本时，做为待下线app_id，因为文本中的名称不带分组，则名称不完整。如果完整的情况下，是可以直接拿来用的。
#     for i in f:
#         i = i.rstrip("\n")
#         for j in allapp_list:
#             temp_name = j.split("/")[-1]
#             # 此步骤就是为了构建完整的名称。
#             if i == temp_name:
#                 offline_list.append(j)
#
# # 遍历下线列表，直接下线，这个遍历有点多余。其实直接在上面的遍历时,直接执行即可。
# for i in offline_list:
#     try:
#         res = maraclient.kill_tasks(i,scale=True)
#     except Exception as e:
#         print("出错了,错误代码%s" %e)
#         print("应用%s已经停止或者不存在" %i)
#     else:
#         print("应用%s停止成功"%i)



# version:v3
from marathon import MarathonClient
server = "http://10.30.0.6:8080"

#实例化
maraclient = MarathonClient(servers=server)

# 获取marathon的应用模块列表
allapp = maraclient.list_apps()

# 提取应用模块的名称,即id
allapp_list = [str(i.id) for i in allapp]
#print(allapp_list)


# 读取待下线模块文本，一行一个,但是不带分组.
with open(r"applist_offline.txt",encoding="utf-8",mode="r") as f:
    for i in f:
        i = i.rstrip("\n")
        for j in allapp_list:
            temp_name = j.split("/")[-1]
            # 此步骤就是为了构建完整的模块名称。
            if i == temp_name:
                try:
                    res = maraclient.kill_tasks(j,scale=True)
                except Exception as e:
                    # print("出错了,错误代码%s" %e)
                    print("应用%s已经停止或者不存在" %j)
                else:
                    print("应用%s停止成功"%j)


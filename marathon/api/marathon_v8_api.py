from marathon import MarathonClient
import json
import pandas as pd

#参考链接：https://github.com/thefactory/marathon-python

server = "http://10.20.0.3:8080"

maraclient = MarathonClient(servers=server)

# 显示所有app信息
app_list = maraclient.list_apps()
#print(type(app_list))

app_calc_list = []
for i in app_list:
    # print(i)
    # break
    #print(i.id,i.instances,i.mem)
    temp_id = str(i.id).split("/")[-1]
    dict_calc = {
        "模块名称": temp_id,
        "实例数量": i.instances,
        "内存": i.mem,
        "总内存": i.instances * i.mem
    }
    app_calc_list.append(dict_calc)
    #print("模块名称: %s,数量: %d,总内存占用: %d" %(i.id,i.instances,i.instances * i.mem))
print(app_calc_list)

df = pd.DataFrame(app_calc_list)
df.to_excel("app_calc.xlsx")
print(df)

#appId = "/java/activity-view"
# 获取app信息
#app_info = maraclient.get_app(app_id=appId)
#print(app_info)
#print(app_info.instances)
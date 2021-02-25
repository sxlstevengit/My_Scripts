from marathon import MarathonClient
import json


#参考链接：https://github.com/thefactory/marathon-python

server = "http://10.30.0.6:8080"

maraclient = MarathonClient(servers=server)

# 显示所有app信息
applist = maraclient.list_apps()
#print(applist)

appId = "/java/activity-view"

# 获取app信息
app_info = maraclient.get_app(app_id=appId)
#print(app_info)
print(app_info.instances)

# 重启APP
#maraclient.restart_app(app_id=appId)


from marathon.models import MarathonApp

#创建APP
#maraclient.create_app("/web/nginx",MarathonApp(mem=256, cpus=0.1)

#扩缩容APP
#maraclient.scale_app("nginx",instances=1)
#maraclient.scale_app("nginx",delta=-1)

# 列出task
# tasks = maraclient.list_tasks("nginx")
# print(tasks)

# 杀死某个task，某个应用可能有多个实例，则表示有多个task,注意此处的scale，如果设置
# 为True，表示进行杀死之后，不在恢复(实例数会减少)
# 为False,表示杀死之后，还会恢复(实例数不减少),默认是False
# taskid = "nginx.8b8dcb3b-771b-11eb-bf57-024256e7a552"
# result = maraclient.kill_task("nginx",task_id=taskid,scale=False)
# print(result)

# 杀死所有该应用的task,停止应用用这个方法。
res = maraclient.kill_tasks("nginx",scale=True)
print(res)

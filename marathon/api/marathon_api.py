# coding:utf8


#测试marathon官方提供的API
import requests,json

url = server + "/v2/apps"

# 获取apps资源： /v2/apps
# response = requests.get(url=url)
# result = json.loads(response.content.decode())


# 创建apps
data={
  "id": "nginx",
  "cmd": None,
  "cpus": 0.01,
  "mem":0,
  "disk": 0,
  "instances": 1,
  "acceptedResourceRoles": ["*"],
  "container": {"type": "DOCKER","volumes": [],
    "docker": {
    "image": "nginx:latest",
    "portMappings": [{"containerPort": 80,"hostPort": 0,"servicePort": 0,"protocol": "tcp","labels": {}}],
    "privileged": False,
    "parameters": [ {"key": "rm","value": "true"}],
    "forcePullImage": False
    }
  },
"networks": [
    {
        "name": "stag-net",
        "mode": "container"
    }
],
  "healthChecks": [{"gracePeriodSeconds": 300,"intervalSeconds": 60,"timeoutSeconds": 20,"maxConsecutiveFailures": 3,"port": 80,"protocol": "TCP"}],
  "labels": {"HAPROXY_GROUP": "external"},
  "portDefinitions": []
}
response = requests.post(url=url,data=json.dumps(data))
result_dict = json.loads(response.content.decode())
print(response.status_code)
if response.status_code == 409:
    print("应用%s已存在" %data['id'])
else:
    print("APP创建成功,app_id是:",result_dict["id"])

# 删除APP
app_id = "/nginx"
del_app_url = server + "/v2/apps" + app_id

# response = requests.delete(url=del_app_url)
# result = json.loads(response.content.decode())
# print(result)


# 重启APP
# restart_app_url = server + "/v2/apps" + app_id + "/restart"
# response = requests.post(url=restart_app_url)
# result = json.loads(response.content.decode())
# print(result)


# 查看版本号
ver_url = server + "/v2/apps/{}/versions"
response = requests.get(ver_url.format(app_id))
result = json.loads(response.content.decode())
print(result)
oldest_ver = result["versions"][1]
print(oldest_ver)

# 获取版本号的具体内容
ver_con_url = server + "/v2/apps/{}/versions/{}"
res = requests.get(ver_con_url.format(app_id,oldest_ver))
r_con = json.loads(res.content.decode())
#print(r_con)


# 版本回退
# 官方并没有直接提供这个API接口；可以先获取版本号及内容，然后直接把内容直接PUT请求到/v2/apps/{app_id}，
# 这样这个版本会直接替换现在的版本， 间接达到版本回退。
rollback_url = server + "/v2/apps/{}"
ver_data = json.dumps({"version": "2020-12-22T09:48:31.505Z"})
params = {'force': 'force'}
req = requests.put(rollback_url.format(app_id),data=ver_data,params=params)
rr = req.json()
print(rr)







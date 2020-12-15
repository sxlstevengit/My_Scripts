# coding:utf8
# 此脚本主要用于通过调用gitlabapi创建项目和删除项目、创建分支和删除分支、创建组和删除组、创建和删除用户、block和unblock用户、deactivate和activate用户等。
# version: v1
# 基于GitLab Community Edition 13.4.3 开发

import requests
import json

gitlab_url = "http://192.168.10.74:9080/api/v4/projects"
admin_token = "FCq1uYzu9isp73hbX2ETAp"
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36",
           "PRIVATE-TOKEN": admin_token
           }


# 创建项目
def create_project(project_name):
    data = {"name": project_name, "namespace_id": 7}
    response = requests.post(gitlab_url,headers=headers,data=data)
    result_dict = json.loads(response.content.decode())
    if "has already been taken" in str(result_dict):
        print("该名称空间中项目已存在,请确认或者修改项目名称")
    else:
        print("项目%s创建成功,请保存下面的信息" %project_name)
        for i in result_dict:
            if i == "id" or i == "web_url" or i == "ssh_url_to_repo" or i == "http_url_to_repo":
                print("%s: %s" %(i, result_dict[i]))

#删除项目
def delete_project(project_name):
    project_id = get_project_id(project_name)
    del_url = gitlab_url + "/" + str(project_id)
    response = requests.delete(url=del_url,headers=headers)
    result_list = json.loads(response.content.decode())
    print(result_list)
    if "202 Accepted" in str(result_list):
        print("项目删除成功")

#获取项目的project_id
# 1: 注意项目名称类似test、test11，如果查询test，则test11也会查询出来，已修复此问题。
# 2：如果是多个名称空间下面的项目名相同，查询会全部显示出来，所以需要结合名称空间(namespace_id)才能唯一确定该项目。已修复
def get_project_id(project_name):
    namespace_id = 7
    id_url = gitlab_url + "?search={}"
    response = requests.get(url=id_url.format(project_name), headers=headers)
    result_list = json.loads(response.content.decode() )
    print(result_list[0])
    if not result_list:
        print("项目不存在")
    else:
        for i in result_list:
            if i["name"] == project_name and i["namespace"]["id"] == namespace_id:
                project_id = i["id"]
                print("项目id是:%d" % project_id)
                return project_id

# 创建分支
def create_branch(project_name,branch_name):
    data = {"branch": branch_name, "ref": "master"}
    project_id = get_project_id(project_name)
    # 创建分支
    branch_url = gitlab_url + "/{}/repository/branches"
    result = requests.post(url=branch_url.format(project_id),headers=headers,data=data)
    res_dict = json.loads(result.content.decode())
    if "Branch already exists" in str(res_dict):
        print("分支已存在")
        exit (1)
    print("分支%s创建成功,地址:%s" %(branch_name,res_dict["web_url"]))

# 删除分支
def delete_branch(project_name,branch_name):
    project_id = get_project_id(project_name)
    delete_branch_url = gitlab_url + "/{}/repository/branches/{}"
    response = requests.delete(url=delete_branch_url.format(project_id,branch_name),headers=headers)
    result = response.content.decode()
    if not result:
        print("分支{}删除成功".format(branch_name))

# 创建组group
def create_group(group_name,group_path):
    group_url = "http://192.168.10.74:9080/api/v4/groups"
    data = {"path": group_path, "name": group_name}
    response = requests.post(group_url,headers=headers,data=data)
    result_dict = json.loads(response.content.decode())
    print("组%s创建成功，请保存下面的信息:" %group_name)
    for i in result_dict:
        if i == "id"  or i == "name" or i == "web_url":
            print("{}: {}".format(i,result_dict[i]))


def get_group_id(group_name):
    get_url = "http://192.168.10.74:9080/api/v4/groups"
    response = requests.get(get_url,headers=headers)
    result_list = json.loads(response.content.decode())
    if group_name not in str(result_list):
        print("%s组不存在" %group_name)
    else:
        for i in range(len(result_list)):
            #print(result_list[i])
            if result_list[i]["name"] == group_name:
                print(result_list[i]["id"])
                return result_list[i]["id"]


# 删除组group
def delete_group(group_name):
    group_name_id = get_group_id(group_name)
    del_group_url = "http://192.168.10.74:9080/api/v4/groups/" + str(group_name_id)
    response = requests.delete(url=del_group_url,headers=headers)
    result = json.loads(response.content.decode())
    if "202 Accepted" in str(result):
        print("组%s删除成功" %group_name)

def create_user(username,name,password,email):
    create_user_url = "http://192.168.10.74:9080/api/v4/users"
    data = {
        "username": username,
        "name": name,
        "password": password,
        "email": email
        # 一般创建用户之后需要电子邮箱确认，不确认是无法登录的；通过下面的参数可以跳过确认，直接登录。
        # 如果设置为true,则创建用户后无法deactivate用户。
        #"skip_confirmation": "true"
    }
    response = requests.post(url=create_user_url,headers=headers,data=data)
    result = json.loads(response.content.decode())
    if "active" in str(result):
        print("用户%s创建成功" %username)
    else:
        print("用户已存在或者其它原因")

def get_user_id(name):
    get_user_url = "http://192.168.10.74:9080/api/v4/users"
    response = requests.get(url=get_user_url,headers=headers)
    result = json.loads(response.content.decode())
    if name not in str(result):
        print("%s用户不存在"%name)
    else:
        for i in result:
            if i["name"] == name:
                print(i["id"])
                return i["id"]

# 阻止用户(block_user和unblock_user是一对反向操作命令)
# 一般来说在任何情况下都可以block_user和unblock_user.
def block_user(name):
    user_id = get_user_id(name)
    block_user_url = "http://192.168.10.74:9080/api/v4/users/" + str(user_id) + "/block"
    response = requests.post(url=block_user_url,headers=headers)
    result = response.content.decode()
    if result == "true":
        print("%s用户block成功" %name)
    else:
        print("%s用户已经block" %name)

#解除阻止
def unblock_user(name):
    user_id = get_user_id(name)
    unblock_user_url = "http://192.168.10.74:9080/api/v4/users/" + str(user_id) + "/unblock"
    response = requests.post(url=unblock_user_url,headers=headers)
    result = response.content.decode()
    if result == "true":
        print("%s用户unblock成功" %name)
    else:
        print("%s用户已经unblock" %name)


# 禁用用户(deactivate和activate是一对，反向操作)
# 基本上刚创建的用户，还未确认和激活，才可以禁用。
def deactivate_user(name):
    """
    基本上刚创建的用户，还未确认和激活，才可以禁用。
    201 OK on success.

    404 User Not Found if user cannot be found.

    403 Forbidden when trying to deactivate a user:
    Blocked by admin or by LDAP synchronization.
    That has any activity in past 180 days. These users cannot be deactivated.
    :param name: 用户名
    :return:
    """
    user_id = get_user_id(name)
    deactivate_user_url = "http://192.168.10.74:9080/api/v4/users/" + str(user_id) + "/deactivate"
    response = requests.post(url=deactivate_user_url,headers=headers)
    result = response.content.decode()
    if result == "true":
        print("%s用户deactivate成功" %name)
    elif str(404) in str(result):
        print("%s未找到" %name)
    else:
        print("该用户180内已激活或者被管理员block")

#启用用户
def activate_user(name):
    user_id = get_user_id(name)
    activate_user_url = "http://192.168.10.74:9080/api/v4/users/" + str( user_id ) + "/activate"
    response = requests.post( url=activate_user_url, headers=headers )
    result = response.content.decode()
    if result == "true":
        print( "%s用户activate成功" %name )
    elif str( 404 ) in str( result ):
        print( "%s未找到" % name )
    else:
        print( "该用户被管理员block" )


def delete_user(name):
    user_id = get_user_id(name)
    del_user_url = "http://192.168.10.74:9080/api/v4/users" + "/" + str(user_id)
    response = requests.delete(url=del_user_url,headers=headers)
    result = response.content.decode()
    if not result:
        print("用户%s删除成功" %name)

# 程序入口
if __name__ == "__main__":
    project_name = "buorg"
    # create_project(project_name)
    # branch_name = "ryv4"
    #create_project(project_name)
    #delete_project(project_name)
    #create_branch(project_name,branch_name)
    get_project_id(project_name)
    # delete_branch(project_name,branch_name)
    group_name = "shanghai"
    group_path = "shanghai"
    #create_group(group_name,group_path)
    # get_group_id(group_name)
    # delete_group(group_name)
    username = "tom"
    name = "jim"
    password = "Adminroot123"
    email = "abc@qq.com"
    #create_user(username,name,password,email)
    #get_user_id(name)
    #delete_user(name)
    #block_user(name)
    #unblock_user(name)
    #deactivate_user(name)
    #activate_user(name)



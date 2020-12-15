# coding:utf8
# 此脚本主要用于通过调用gitlabapi创建项目和删除项目、创建分支和删除分支、创建组和删除组、创建和删除用户、block和unblock用户、deactivate和activate用户等。
# version: v2
# 基于GitLab Community Edition 13.4.3 开发

import requests
import json


class GitLab_api():
    def __init__(self,gitlab_url,admin_token,namespace_id):
        """
        :param gitlab_url: 请提供gitlab_api_url,类似 http://192.168.10.74:9080/api/v4
        :param admin_token: 请提供管理员token
        Gitlab项目的权限控制是基于命名空间来做的。命名空间包括群组和用户两种。此类API包括命名空间的查询、群组的增删改查等。
        :param namespace_id: 可以按群组id或者用户id提供。
        """
        self.gitlab_url = gitlab_url
        self.admin_token = admin_token
        self.namespace_id = namespace_id
        self.headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36",
    "PRIVATE-TOKEN": admin_token
    }

    #创建项目
    def create_project(self,project_name):
        """
        :param project_name: 项目名称
        Gitlab项目的权限控制是基于命名空间来做的。命名空间包括群组和用户两种。此类API包括命名空间的查询、群组的增删改查等。
        :param namespace_id: 可以按群组id或者用户id提供。
        :return:
        """
        data = {"name": project_name, "namespace_id": self.namespace_id}
        project_url = self.gitlab_url + "/projects"
        response = requests.post(url=project_url, headers=self.headers, data=data )
        result_dict = json.loads( response.content.decode() )
        if "has already been taken" in str( result_dict ):
            print( "该名称空间中项目已存在,请确认或者修改项目名称" )
        else:
            print( "项目%s创建成功,请保存下面的信息" % project_name )
            for i in result_dict:
                if i == "id" or i == "web_url" or i == "ssh_url_to_repo" or i == "http_url_to_repo":
                    print( "%s: %s" % (i, result_dict[i]) )

    #删除项目
    def delete_project(self,project_name):
        project_id = self.get_project_id(project_name)
        del_url = self.gitlab_url + "/{}/{}"
        response = requests.delete(url=del_url.format("projects",project_id),headers=self.headers)
        result_dict = json.loads(response.content.decode())
        if "202 Accepted" in str( result_dict ):
            print( "项目删除成功" )

    # 获取项目id
    # 1: 注意项目名称类似test、test11，如果查询test，则test11也会查询出来，已修复此问题。
    # 2：如果是多个名称空间下面的项目名相同，查询会全部显示出来，所以需要结合名称空间(namespace_id)才能唯一确定该项目。已修复
    def get_project_id(self,project_name):
        id_url = self.gitlab_url + "/{}" + "?search={}"
        response = requests.get(url=id_url.format("projects",project_name),headers=self.headers)
        result_list = json.loads(response.content.decode())
        if not result_list:
            print( "项目不存在" )
        else:
            for i in result_list:
                if i["name"] == project_name and i["namespace"]["id"] == self.namespace_id:
                    project_id = i["id"]
                    print( "项目id是:%d" % project_id )
                    return project_id

    # 创建分支
    def create_brance(self,project_name,branch_name):
        data = {"branch": branch_name,"ref": "master"}
        project_id = self.get_project_id(project_name)
        branch_url = gitlab_url + "/projects/{}/repository/branches"
        result = requests.post( url=branch_url.format(project_id), headers=self.headers, data=data )
        res_dict = json.loads(result.content.decode())
        if "Branch already exists" in str(res_dict):
            print( "分支已存在" )
            exit( 1 )
        print("分支%s创建成功,地址:%s" % (branch_name, res_dict["web_url"]) )

    # 删除分支
    def delete_branch(self,project_name, branch_name):
        project_id = self.get_project_id(project_name)
        delete_branch_url = self.gitlab_url + "/projects/{}/repository/branches/{}"
        response = requests.delete(url=delete_branch_url.format(project_id,branch_name), headers=self.headers )
        result = response.content.decode()
        if not result:
            print( "分支{}删除成功".format( branch_name ) )


    # 创建组group
    def create_group(self,group_name,group_path):
        group_url = self.gitlab_url + "/groups"
        data = {"path": group_path, "name": group_name}
        response = requests.post(url=group_url,headers=self.headers,data=data)
        result_dict = json.loads(response.content.decode())
        print("组%s创建成功，请保存下面的信息:" %group_name)
        for i in result_dict:
            if i == "id"  or i == "name" or i == "web_url":
                print("{}: {}".format(i,result_dict[i]))

    # 获取组id
    def get_group_id(self,group_name):
        get_url = self.gitlab_url + "/groups"
        response = requests.get(url= get_url,headers=self.headers)
        result_list = json.loads(response.content.decode())
        if group_name not in str( result_list ):
            print( "%s组不存在" % group_name )
        else:
            for i in range(len(result_list)):
                if result_list[i]["name"] == group_name:
                    print("组id是: ",result_list[i]["id"])
                    return result_list[i]["id"]

    # 删除组group
    def delete_group(self,group_name):
        group_name_id = self.get_group_id(group_name)
        del_group_url = self.gitlab_url + "/groups/" + str(group_name_id)
        response = requests.delete(url=del_group_url,headers=self.headers)
        result = json.loads(response.content.decode())
        if "202 Accepted" in str(result):
            print("组%s删除成功" %group_name)

    #创建用户
    def create_user(self,username,name,password,email):
        create_user_url = self.gitlab_url + "/users"
        data = {
            "username": username,
            "name": name,
            "password": password,
            "email": email
            # 一般创建用户之后需要电子邮箱确认，不确认是无法登录的；通过下面的参数可以跳过确认，直接登录。
            # 如果设置为true,则创建用户后无法deactivate用户。
            #"skip_confirmation": "true"
        }
        response = requests.post(url=create_user_url,headers=self.headers,data=data)
        result = json.loads(response.content.decode())
        if "active" in str(result):
            print("用户%s创建成功" %username)
        else:
            print("用户已存在或者其它原因")

    # 获取用户id
    def get_user_id(self,name):
        get_user_url = self.gitlab_url + "/users"
        response = requests.get(url=get_user_url,headers=self.headers)
        result = json.loads(response.content.decode())
        if name not in str( result ):
            print( "%s用户不存在" % name )
        else:
            for i in result:
                if i["name"] == name:
                    print("用户{}的id是: {}".format(name,i["id"]))
                    return i["id"]

    # 阻止用户(block_user和unblock_user是一对反向操作命令)
    # 一般来说在任何情况下都可以block_user和unblock_user.
    def block_user(self,name):
        user_id = self.get_user_id(name)
        block_user_url = self.gitlab_url + "/users/" + str( user_id ) + "/block"
        response = requests.post(url=block_user_url,headers=self.headers)
        result = response.content.decode()
        if result == "true":
            print("%s用户block成功" % name)
        else:
            print( "%s用户已经block" % name )

    # 解除阻止
    def unblock_user(self,name):
        user_id = self.get_user_id(name)
        unblock_user_url = self.gitlab_url + "/users/" + str(user_id) + "/unblock"
        response = requests.post(url=unblock_user_url,headers=self.headers)
        result = response.content.decode()
        if result == "true":
            print( "%s用户unblock成功" % name )
        else:
            print( "%s用户已经unblock" % name )

    # 禁用用户(deactivate和activate是一对，反向操作)
    # 基本上刚创建的用户，还未确认和激活，才可以禁用。
    def deactivate_user(self,name):
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
        user_id = self.get_user_id( name )
        deactivate_user_url = self.gitlab_url + "/users/" + str(user_id) + "/deactivate"
        response = requests.post(url=deactivate_user_url, headers=self.headers )
        result = response.content.decode()
        if result == "true":
            print( "%s用户deactivate成功" % name )
        elif str( 404 ) in str( result ):
            print( "%s未找到" % name )
        else:
            print( "该用户180内已激活或者被管理员block" )

    # 启用用户
    def activate_user(self,name):
        user_id = self.get_user_id( name )
        activate_user_url = self.gitlab_url + "/users/" + str(user_id) + "/activate"
        response = requests.post( url=activate_user_url, headers=self.headers )
        result = response.content.decode()
        if result == "true":
            print( "%s用户activate成功" % name )
        elif str( 404 ) in str( result ):
            print( "%s未找到" % name )
        else:
            print( "该用户被管理员block" )

    # 删除用户
    def delete_user(self,name):
        user_id = self.get_user_id(name)
        del_user_url = self.gitlab_url + "/users/" + str(user_id)
        response = requests.delete(url=del_user_url,headers=self.headers)
        result = response.content.decode()
        if not result:
            print("用户%s删除成功" %name)

# 程序入口
if __name__ == "__main__":
    project_name = "xxl_job"
    branch_name = "ryv4"
    gitlab_api = GitLab_api(gitlab_url,admin_token,namespace_id)
    #gitlab_api.create_project(project_name)
    #gitlab_api.get_project_id(project_name)
    #gitlab_api.delete_project(project_name)
    #gitlab_api.create_brance(project_name,branch_name)
    # gitlab_api.delete_branch(project_name,branch_name)
    group_name = "jack"
    group_path = "tom"
    # gitlab_api.create_group(group_name,group_path)
    # gitlab_api.delete_group(group_name)
    username = name = "zhangsan11"
    password = "Aootadmin123"
    email = "root@qq.com"
    #gitlab_api.get_user_id(name)
    #gitlab_api.get_group_id(group_name)
    #gitlab_api.create_user(username,name,password,email)
    # gitlab_api.delete_user(name)



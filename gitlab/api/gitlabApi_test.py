# coding:utf8

from gitlabApi_v2 import GitLab_api

gitlab_url = "http://192.168.10.74:9080/api/v4"
admin_token = "FCq1uYzu9isp73hbX2ETEKA"
namespace_id = 7
username = name = "zhangsan123"
password = "Aootadmin123"
email = "root123@qq.com"

if __name__ == '__main__':
    apitest = GitLab_api(gitlab_url,admin_token,namespace_id)
    # apitest.create_project("yunwei")
    #apitest.create_user(username,name,password,email)
    # apitest.delete_user(name)
    # apitest.block_user(name)
    # apitest.unblock_user(name)
    #apitest.deactivate_user(name)
    # apitest.activate_user(name)



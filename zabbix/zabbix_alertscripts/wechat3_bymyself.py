#!/usr/bin/env python
# coding=utf-8
# Author:sxl_youcun@qq.com
import requests, json, sys

corp_id = "XXXXXXXXXXXXXXXXX"
corp_secret = "XXXXXXXXXXXXXXXXX"
agent_id = "1000015"
url = "https://qyapi.weixin.qq.com/cgi-bin/"
#to_user = "OOXX"
to_user = sys.argv[1]
subject = sys.argv[2]
#to_party='3|4|5|6'

def get_access_token():
    get_token_url = "%sgettoken?corpid=%s&corpsecret=%s" %(url,corp_id,corp_secret)
 #   print(get_token_url)
 #   return get_token_url
    content = requests.get(get_token_url).text
    token = json.loads(content)['access_token']
    return token

def send_message():
    access_token = get_access_token()
    send_url = "%smessage/send?access_token=%s" %(url,access_token)
    # print(send_url)
    message=sys.argv[3]
    #message = "This a test message"
    #message = "机房着火了，快点来啊"
    message_params = {
        "touser" : to_user,
#		"toparty" : to_party
        "msgtype" : "text",
        "agentid" : agent_id,
        "text":{
            "content" : message
        },
        "safe" : 0
    }
    ret = requests.post(send_url,data=json.dumps(message_params))
send_message()


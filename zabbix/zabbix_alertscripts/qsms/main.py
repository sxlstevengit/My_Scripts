#! /usr/bin/env python
# encoding:utf-8

import json,sys
import Qcloud.Sms.sms as SmsSender
from Qcloud.Sms.voice import VoiceSender
from Qcloud.Sms.voice import VoicePromptSender
#import os,time

def sms(senduser='all',p1='10.10.0.3',p2='告警测试'):
    # 请根据实际 appid 和 appkey 进行开发，以下只作为演示 sdk 使用
    # appid,appkey,templId申请方式可参考接入指南https://www.qcloud.com/document/product/382/3785#5-.E7.9F.AD.E4.BF.A1.E5.86.85.E5.AE.B9.E9.85.8D.E7.BD.AE
    appid = XXXXXXXXXXXXXX
    appkey = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    phone_number1 = "XXXXX"  #telephone1
    phone_number2 = "XXXXX" #telephone2
    phone_number3 = "XXXXX" #telephone3
    phone_number4 = "XXXXX" #telephone4
    phone_number5 = "XXXXX" #telephone5
    phone_numbers = [phone_number1, phone_number2, phone_number3, phone_number4, phone_number5]
    templ_id = XXXX


    if senduser != 'all':
        single_sender = SmsSender.SmsSingleSender(appid, appkey)

        # 普通单发
        #result = single_sender.send(0, "86", phone_number2, "测试短信，普通单发，深圳，小明，上学。", "", "")
        #rsp = json.loads(result)
        #print result

        # 指定模板单发
        params = [p1,p2]
        result = single_sender.send_with_param("86", senduser, templ_id, params, "", "", "")
        rsp = json.loads(result)
        print result
    else:
    #if senduser == 'all':
        multi_sender = SmsSender.SmsMultiSender(appid, appkey)

        # 普通群发
        #result = multi_sender.send(0, "86", phone_numbers, "测试短信，普通群发，运维监控。", "", "")
        #rsp = json.loads(result)
        #print result

        # 指定模板群发
        # 假设短信模板内容为：测试短信，{1}，{2}，{3}，上学。
        params = [p1,p2]
        result = multi_sender.send_with_param("86", phone_numbers, templ_id, params, "", "", "")
        rsp = json.loads(result)
        print result

def voice():
     # 语音验证码请求
     voice = VoiceSender(appid=XXXXXX,appkey="XXXXXX")
     result = voice.send(nation_code="86",phone_number="XXXXXX",playtimes=2,msg="1234",ext="")
     rsp = json.loads(result)
     if(int(rsp['result']) != 0):
         errmsg=rsp['errmsg']
         print "request failed\n"+errmsg
     else:
         print "request success\n"+result


    # 语音通知请求
     voice_promt = VoicePromptSender(appid=XXXXX, appkey="XXXXXX")
     #note: msg内容，首先需要申请内容模板，通过后才可以发送
     result = voice_promt.send(nation_code="86", phone_number="XXXXXXX", playtimes=2, msg="你好语音模板", ext="")
     rsp = json.loads(result)
     if (rsp['result'] != 0):
        errmsg = rsp['errmsg']
        print "request failed\n" + "error code: "+str(rsp['result'])+"\t"+errmsg
     else:
        print "request success\n" + result


if __name__ == "__main__":
    #nowtime=time.strftime(r"%Y-%m-%d_%H-%M-%S",time.localtime())
    #ff=open("/tmp/sendsms.log","a+")
    
    if len(sys.argv) > 3:
        #ff.write(nowtime+' : ' + sys.argv[1] + ' : ' + sys.argv[2] + ' : ' + sys.argv[3] + '\n')
        sms(sys.argv[1],sys.argv[2],sys.argv[3])
    else:
        #ff.write(nowtime+' : no! \n' )
        sms()
    #ff.close()
    #voice()

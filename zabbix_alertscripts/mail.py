#!/usr/bin/python
import os
import smtplib
import traceback
import sys
import copy
reload(sys)
sys.setdefaultencoding('utf8')
from email.mime.text import MIMEText
mail_host = 'smtp.qiye.163.com'
mail_user = 'XXXX@XXXX.com'
mail_pwd = 'XXXXXXXX'
def send_mail(content,mailto,get_sub):
    print 'Setting MIMEText'
    msg = MIMEText( content.encode('utf8'), _subtype = 'html', _charset = 'utf8')  
    msg['From'] = mail_user  
    msg['Subject'] = u'%s' % get_sub  
    msg['To'] = ",".join( mailto )
    
    try:
        print 'connecting ',mail_host
        s = smtplib.SMTP_SSL(mail_host,465)
        print 'login to mail_host'
        s.login(mail_user,mail_pwd)
    
        print 'send mail'
        s.sendmail(mail_user,mailto,msg.as_string())
        print 'close the connection'
        s.close()
    except:
        f=open('/tmp/mail.log','a')
        f.write('%s\n' % traceback.format_exc() )
        f.close()

        print traceback.format_exc()
to_list = sys.argv[1].split(",")
#to_list = sys.argv[1].split(",")
#to_list=["XXXXX@XXXX.com","XXX@XXX.com",]
#print type(to_list)
#print to_list
#host = `cat /etc/sysconfig/network-scripts/ifcfg-eth1 | sed -n 4p | awk -F= '{print $2}'`
subject=sys.argv[2]
message=sys.argv[3]
#message=message.replace('\n','<br>')
#f=open('/tmp/mail.log','a')
#f.write('%s\n%s\n%s\n' % (to_list,subject,message) )
#f.close()

send_mail(message,to_list,subject)

